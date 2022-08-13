# Web scraping
# Actividad 1
library(purrr)
library(tidyverse)
library(rvest)
# options(warn = -1)

pagina <- read_html('https://www.mercadolibre.cl/ofertas?promotion_type=deal_of_the_day&container_id=MLC779365-1&page=1')

'class = "hola"'

pagina %>% 
  html_element(xpath = '//ul[@class = "andes-pagination"]') %>% 
  html_children() %>% 
  html_text2() %>% 
  as.numeric() %>% 
  max(na.rm = TRUE) %>% 
  suppressWarnings()

# Extraer titulo del producto
pagina %>% 
  html_element(xpath = '//p[@class = "promotion-item__title"]') %>% 
  html_text2()


# Extraer el titulo de todos los productos, forma difícil
1:48 %>% 
  map_chr(.f = function(x){
    pagina %>% 
      html_element(xpath = paste0('//ol[@class = "items_container"]/li[',x,']//p[@class = "promotion-item__title"]')) %>% 
      html_text2()
  })

# Extraer el titulo de todos los productos, forma fácil
Nombre <- pagina %>% 
  html_elements(xpath = '//p[@class = "promotion-item__title"]') %>% 
  html_text2()

# Precio antiguo
Precio_antiguo <- pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__oldprice"]') %>% 
  html_text2() %>% 
  str_remove_all('\\$') %>% 
  str_trim() %>% 
  str_remove_all('\\.') %>% 
  as.numeric()

# Precio oferta
Precio_oferta <- pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__price"]') %>% 
  html_text2() %>% 
  str_remove_all('\\$') %>% 
  str_trim() %>% 
  str_remove_all('\\.') %>% 
  as.numeric()

# Envió gratis

# Da error porque existen elementos sin envió gratis
pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__shipping"]') %>% 
  html_text2()

# Forma difícil 
1:length(Nombre) %>% 
  map_chr(.f = function(x){
    pagina %>% 
      html_element(xpath = paste0('//ol[@class = "items_container"]/li[',x,']//span[@class = "promotion-item__shipping"]')) %>% 
      html_text2() %>% 
      if_else(is.na(.),'Sin envio gratis',.)
  })

# Cómo utilizar map, se debe llamar a la función, esta sin ejecutar, osea, sin () al final.
# map_int(.f = sum)
# map_int(.f = function(x){sum(x,na.rm = TRUE)})

# perrito <- function(x){
#   pagina %>% 
#     html_element(.,xpath = paste0('//ol[@class = "items_container"]/li[',x,']//span[@class = "promotion-item__shipping"]')) %>% 
#     html_text2(.) %>% 
#     if_else(is.na(.),'Sin envio gratis',.)}
# 
# 1:length(Nombre) %>% 
#   map_chr(.f = perrito)

# Vendedor
vendedor <- 1:length(Nombre) %>% 
  map_chr(.f = function(x){
    pagina %>% 
      html_element(xpath = paste0('//ol[@class = "items_container"]/li[',x,']//span[@class = "promotion-item__seller"]')) %>% 
      html_text2() %>% 
      if_else(is.na(.),'Sin información',.)
  })

# URL del producto 
URL <- pagina %>% 
  html_elements(xpath = '//a[@class = "promotion-item__link-container"]') %>% 
  html_attr('href')


# Función que extrae toda la información

scraping <- function(){
  
  pagina <- read_html('https://www.mercadolibre.cl/ofertas?promotion_type=deal_of_the_day&container_id=MLC779365-1&page=1')
  
  N_paginas <- pagina %>% 
    html_element(xpath = '//ul[@class = "andes-pagination"]') %>% 
    html_children() %>% 
    html_text2() %>% 
    as.numeric() %>% 
    max(na.rm = TRUE) %>% 
    suppressWarnings()
  
  1:N_paginas %>% 
    map_dfr(.f = function(y){
      
      pagina <- read_html(paste0('https://www.mercadolibre.cl/ofertas?promotion_type=deal_of_the_day&container_id=MLC779365-1&page=',y))
    
      # Nombre
      Nombre <- pagina %>% 
        html_elements(xpath = '//p[@class = "promotion-item__title"]') %>% 
        html_text2()
      
      # Precio antiguo
      Precio_antiguo <- pagina %>% 
        html_elements(xpath = '//span[@class = "promotion-item__oldprice"]') %>% 
        html_text2() %>% 
        str_remove_all('\\$') %>% 
        str_trim() %>% 
        str_remove_all('\\.') %>% 
        as.numeric()
      
      # Precio oferta
      Precio_oferta <- pagina %>% 
        html_elements(xpath = '//span[@class = "promotion-item__price"]') %>% 
        html_text2() %>% 
        str_remove_all('\\$') %>% 
        str_trim() %>% 
        str_remove_all('\\.') %>% 
        as.numeric()
      
      # Envió gratis
    
      Envio <- 1:length(Nombre) %>% 
        map_chr(.f = function(x){
          pagina %>% 
            html_element(xpath = paste0('//ol[@class = "items_container"]/li[',x,']//span[@class = "promotion-item__shipping"]')) %>% 
            html_text2() %>% 
            if_else(is.na(.),'Sin envio gratis',.)
        })
      
      # Vendedor
      vendedor <- 1:length(Nombre) %>% 
        map_chr(.f = function(x){
          pagina %>% 
            html_element(xpath = paste0('//ol[@class = "items_container"]/li[',x,']//span[@class = "promotion-item__seller"]')) %>% 
            html_text2() %>% 
            if_else(is.na(.),'Sin información',.)
        })
      
      # URL del producto 
      URL <- pagina %>% 
        html_elements(xpath = '//a[@class = "promotion-item__link-container"]') %>% 
        html_attr('href')
      
      
      Sys.sleep(runif(1,1,1.5))
      
      tibble(Nombre,
             Precio_antiguo,
             Precio_oferta,
             Envio,
             vendedor,
             URL)
      
    })
  
}

datos_mercado_libre <- scraping()


















