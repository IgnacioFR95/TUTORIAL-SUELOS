#______________________  1.2 CARGA DE CÓDIGOS INICIALES _______________________#

# Las siguientes operaciones, cargan algunos parámetros imprescindibles para la 
# realización de este tutorial. A su vez, comprueba que la versión de R es  
# apta para trabajar y confirma la correcta instalación de todos los paquetes 
# que vamos a necesitar.Por último, se realiza un "curating data" que es un 
# proceso en el que se homogeniza la base de datos y se eliman los parámetros
# innecesarios para el tutorial. (Los datos contienen información extra que otro
# investigador podría utilizar en el futuro para sus estudios)

# 1.1.a Comprobación de versiones y paquetes de datos: 

# I) Verificación de que la versión de R utilizada es la 3.6.0 o superior:

if(getRversion() < "3.6.0") {stop("##########\nLa versión de R que posee es antigua\nPor favor, instale la última versión\n##########")}

## El comando aplica lo siguiente: "Si la versión de R es menor que la 3.6.0,
## genera un mensaje de alerta donde especifique el mensaje" (En este caso, el 
## mensaje elegido es un aviso de que la versión de R es antigua y se necesita 
## actualizar)


# II) Verificación de que la versión de RStudio utilizada es la 1.0.1 o superior:

if(RStudio.Version()$version < "1.0.1"){stop("##########\nLa versión de RStudio que posee es antigua\nPor favor, instale la última versión\n##########")}

## El comando aplica lo siguiente: "Si la versión de RStudio es menor que la 
## 3.6.0, genera un mensaje de alerta donde especifique el mensaje" (En este 
## caso, el mensaje elegido es un aviso de que la versión de RStudio es antigua
## y se necesita actualizar)


# III) Verificación de que los paquetes CRAN necesarios están instalados:

CRAN_needed <- c("lattice","sp","gstat","maptools","spatstat","raster","automap")
installed_packages <- .packages(all.available = TRUE)
CRAN_needed2 <- CRAN_needed[!CRAN_needed %in% installed_packages]


# IV) Descargar paquetes faltantes de CRAN: 

if(length(CRAN_needed2) > 0){install.packages(CRAN_needed2)}stopifnot(all(c(CRAN_needed) %in% .packages(all.available = TRUE)))

# V) Eliminamos los objetos de comprobación:

rm(CRAN_needed, CRAN_needed2, installed_packages)

## El comando rm elimina los objetos puestos entre paréntesis, en este caso los
## objetos que hemos utilizado para confirmar que los paquetes están instalados.