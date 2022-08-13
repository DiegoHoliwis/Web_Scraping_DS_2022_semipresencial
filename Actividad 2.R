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


