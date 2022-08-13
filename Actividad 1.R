# Web scraping
# Actividad 1

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






