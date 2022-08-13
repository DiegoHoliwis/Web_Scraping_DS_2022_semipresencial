# Actividad 2

# install.packages('RSelenium')
library(tidyverse)
library(rvest)
library(RSelenium)

# Configuración inicial (siempre la misma)
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE) # Se finalizan los procesos Java

driver <- RSelenium::rsDriver(browser = "chrome", 
                              chromever = "104.0.5112.79")
remote_driver <- driver[["client"]]

remote_driver$navigate("https://www.santander.cl/cotizador-web/")

# pagina %>% html_element(xpath = '....') # Con rvest

# Seleccionar marca del vehículo

remote_driver$findElement(using = 'xpath',
                          value = '//select[@id = "marcas"]')

LISTA_MARCAS <- remote_driver$findElement(using = 'id',
                          value = 'marcas')$selectTag()

ID_MARCA <- tibble(Nombre_marca = LISTA_MARCAS$text,
       value_marca  = LISTA_MARCAS$value) %>% 
  filter(Nombre_marca == 'JEEP') %>% 
  pull(value_marca)


remote_driver$findElement(using = 'xpath',
                          value = paste0('//select[@id = "marcas"]/option[@value = ',ID_MARCA,']'))$clickElement()

# Seleccionar el modelo del vehículos