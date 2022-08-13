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

AÑO = '2022'
MARCA    = 'JEEP'
MODELO   = 'RENEGADE'
RUT      = '24312997-4'
NOMBRE   = 'Diego Muñoz'
FechaN   = '10/01/1997'
SEXO     = 'Masculino'
EMAIL    = 'correo_generico@gmail.com'
TELEFONO = runif(1,900000000,999999999) %>% round(0) %>% as.character()

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
LISTA_MODELOS <- remote_driver$findElement(using = 'id',
                                          value = 'modelos')$selectTag()

ID_MODELO <- tibble(Nombre_modelo = LISTA_MODELOS$text,
                    value_modelo  = LISTA_MODELOS$value) %>% 
  filter(Nombre_modelo == 'RENEGADE') %>% 
  pull(value_modelo)


remote_driver$findElement(using = 'xpath',
                          value = paste0('//select[@id = "modelos"]/option[@value = ',ID_MODELO,']'))$clickElement()

# Ingresar Año

remote_driver$findElement(using = 'id',
                          value = 'ano')$sendKeysToElement(list(AÑO))

# Siguiente página
remote_driver$findElement(using = 'id',
                          value = 'siguiente1')$clickElement()

# RUT


