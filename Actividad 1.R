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

pagina %>% 
  html_elements(xpath = '//p[@class = "promotion-item__title"]') %>% 
  html_text2()

# Precio antiguo
pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__oldprice"]') %>% 
  html_text2() %>% 
  str_remove_all('\\$') %>% 
  str_trim() %>% 
  str_remove_all('\\.') %>% 
  as.numeric()

# Precio oferta
pagina %>% 
  html_elements(xpath = '//span[@class = "promotion-item__price"]') %>% 
  html_text2() %>% 
  str_remove_all('\\$') %>% 
  str_trim() %>% 
  str_remove_all('\\.') %>% 
  as.numeric()














