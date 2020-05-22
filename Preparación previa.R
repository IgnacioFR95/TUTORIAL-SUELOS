#______________________  1.2 COMPROBACIONES INICIALES  ________________________#

# Las siguientes operaciones, cargan algunos parámetros imprescindibles para la 
# realización de este tutorial. A su vez, comprueba que la versión de R es  
# apta para trabajar y confirma la correcta instalación de todos los paquetes 
# que vamos a necesitar.Por último, se realiza un "curating data" de los datos, 
# que es un  proceso en el que se homogeniza la base de datos brutos  y se eliman
# los parámetros innecesarios para el tutorial. (Los datos contienen información
# extra que otro investigador podría utilizar en el futuro para sus estudios)
 


# 1.2.a) Verificación de que la versión de R utilizada es la 3.6.0 o superior:

if(getRversion() < "3.6.0") {stop("##########\nLa versión de R que posee es antigua\nPor favor, instale la última versión\n##########")}

## El comando aplica lo siguiente: "Si la versión de R es menor que la 3.6.0,
## genera un mensaje de alerta donde especifique el mensaje" (En este caso, el 
## mensaje elegido es un aviso de que la versión de R es antigua y se necesita 
## actualizar)


# 1.2.b) Verificación de que la versión de RStudio utilizada es la 1.0.1 o superior:

if(RStudio.Version()$version < "1.0.1"){stop("##########\nLa versión de RStudio que posee es antigua\nPor favor, instale la última versión\n##########")}

## El comando aplica lo siguiente: "Si la versión de RStudio es menor que la 
## 3.6.0, genera un mensaje de alerta donde especifique el mensaje" (En este 
## caso, el mensaje elegido es un aviso de que la versión de RStudio es antigua
## y se necesita actualizar)


# 1.2.c) Verificación de que los paquetes CRAN necesarios están instalados:

CRAN_needed <- c("lattice","sp","gstat","maptools","spatstat","raster","automap")
installed_packages <- .packages(all.available = TRUE)
CRAN_needed2 <- CRAN_needed[!CRAN_needed %in% installed_packages]

# Descarga de paquetes faltantes de CRAN: 

if(length(CRAN_needed2) > 0){install.packages(CRAN_needed2)}
stopifnot(all(c(CRAN_needed) %in% .packages(all.available = TRUE)))


# 1.2.d) Finalización de las comprobaciones de paquetes y versiones:

rm(CRAN_needed, CRAN_needed2, installed_packages)

## El comando "rm()" elimina los objetos puestos entre paréntesis, en este caso 
## los objetos que hemos utilizado para confirmar que los paquetes están instalados.


# 1.2.e) Curating data 

# Renombramos el título de de la columna 11 (COD -> Codigo_muestra).

colnames(suelo2)[11] <- "Codigo_muestra"

# Eliminamos las columnas que no nos interesan para este tutorial en concreto,
# simplificando así los datos.

orusco.soil <- suelo2
suelo2$Fecha <- NULL
suelo2$COND <- NULL
suelo2$Altura.elipsoidal <- NULL
suelo2$id_suelo_raiz <- NULL
suelo2$Nº <- NULL
suelo2$Marco <- NULL
