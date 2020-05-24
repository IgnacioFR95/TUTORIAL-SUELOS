#   _____           _                    _           _ 
#  |_   _|  _   _  | |_    ___    _ __  (_)   __ _  | |
#    | |   | | | | | __|  / _ \  | '__| | |  / _` | | |
#    | |   | |_| | | |_  | (_) | | |    | | | (_| | | |
#    |_|    \__,_|  \__|  \___/  |_|    |_|  \__,_| |_|
#    ____                  _                                     __   __         
#   / ___|   __ _   _ __  | |_    ___     __ _   _ __    __ _   / _| /_/   __ _ 
#  | |      / _` | | '__| | __|  / _ \   / _` | | '__|  / _` | | |_  | |  / _` |
#  | |___  | (_| | | |    | |_  | (_) | | (_| | | |    | (_| | |  _| | | | (_| |
#   \____|  \__,_| |_|     \__|  \___/   \__, | |_|     \__,_| |_|   |_|  \__,_|
#                      __                |___/                                           
#  _____       _      /_/   __   _                
# | ____|   __| |   __ _   / _| (_)   ___    __ _ 
# |  _|    / _` |  / _` | | |_  | |  / __|  / _` |
# | |___  | (_| | | (_| | |  _| | | | (__  | (_| |
# |_____|  \__,_|  \__,_| |_|   |_|  \___|  \__,_|
#                                                   Por: Ignacio Fernández Ruiz


################################################################################
################################################################################

#¡ANTENCIÓN! LEA ANTENTAMENTE EL ARCHIVO README ANTES DE INICIAR ESTE TUTORIAL.

# Para cualquier información adicional sobre el funcionamiento de algún comando,
# puede utilizar "?NombreDelComando". Lo que abrirá una nueva pestaña con más
# información sobre su uso y la gramática que utiliza. Si el comando pertenece a
# un paquete de R concreto, puede utilizar el comando "??NombreDelComando" para
# recibir la misma información.

################################### ÍNDICE #####################################

# |1|  PREPARACIÓN DE LOS DATOS
#      |1.1| Carga de datos iniciales
#      |1.2| Comprobaciones iniciales
#              |1.2.a| Verificación de la versión de R
#              |1.2.b| Verificación de la versión de RStudio
#              |1.2.c| Verificación de los paquetes CRAN
#              |1.2.d| Finalización de las comprobaciones
#              |1.2.e| Curating data
#      |1.3| Carga de paquetes R necesarios
#      |1.4| Reclasificación datos originales a datos espaciales.
#   
# |2|  PREPARACIÓN DEL ÁREA DE ESTUDIO
#      |2.1| Generación del mapa base
#              |2.1.a| Generación del polígono
#              |2.1.b| Generación de la malla
#      |2.2| Adaptación de los datos al mapa base
#
# |3|  NORMALIZACIÓN DE LAS VARIABLES
#      |3.1| Metodología de normalización de variables
#              |3.1.a| Histograma
#              |3.1.b| Gráfico cuantil-cuantil
#              |3.1.c| Test de shapiro
#              |3.1.d| Modificación de los datos
#      |3.2| Normalización variable GLUCOSIDASA
#      |3.3| Normalización variable FOSFATASA
#      |3.4| Normalización variable NITRÓGENO
#      |3.5| Normalización variable FÓSFORO
#      |3.6| Normalización variable POTASIO
#      |3.7| Normalización variable CARBONO
#      |3.8| Normalización variable pH
#      |3.9| Normalización variable ARENA
#      |3.10| Normalización variable LIMO
#      |3.11| Normalización variable ARCILLA
#
# |4|  GENERACIÓN DE LA CARTOGRAFÍA EDÁFICA
#      |4.1| Metodología de cartografía edáfica
#              |4.1.a| Función "autokriging()"
#              |4.1.b| Kriging manual
#      |4.2| Cartografía de variable GLUCOSIDASA
#              |4.2.a| Autokriging de Glucosidasa
#              |4.2.b| Kriging manual de Glucosidasa
#      |4.3| Cartografía de variable FOSFATASA
#              |4.3.a| Autokriging de Fosfatasa
#              |4.3.b| Kriging manual de Fosfatasa
#      |4.4| Cartografía de variable NITRÓGENO
#              |4.4.a| Autokriging de Nitrógeno
#              |4.4.b| Kriging manual de Nitrógeno
#      |4.5| Cartografía de variable FÓSFORO
#              |4.5.a| Autokriging de Fósforo
#              |4.5.b| Kriging manual de Fósforo
#      |4.6| Cartografía de variable POTASIO
#              |4.6.a| Autokriging de Potasio
#              |4.6.b| Kriging manual de Potasio
#      |4.7| Cartografía de variable CARBONO
#              |4.7.a| Autokriging de Carbono
#              |4.7.b| Kriging manual de Carbono
#      |4.8| Cartografía de variable pH
#              |4.8.a| Autokriging de pH
#              |4.8.b| Kriging manual de pH
#      |4.9| Cartografía de variable ARENA
#              |4.9.a| Autokriging de Arena
#              |4.9.b| Kriging manual de Arena
#      |4.10| Cartografía de variable LIMO
#              |4.10.a| Autokriging de Limo
#              |4.10.b| Kriging manual de Limo
#      |4.11| Cartografía de variable ARCILLA 
#              |4.11.a| Autokriging de Arcilla
#              |4.11.b| Kriging manual de Arcilla


################################################################################
############################# 1 PREPARACIÓN DE DATOS ###########################
################################################################################

# En esta fase, realizaremos todas las operaciones previas a la generación de la
# cartografía. Comprobaremos las versiones utilizadas, descargaremos los datos y 
# paquetes necesarios para las fases posteriores y transformaremos los datos a 
# los formatos espaciales necesarios.



#_______________________  1.1 CARGA DE DATOS INICIALES ________________________#

# Antes de realizar ninguna operación, debemos decirle al proyecto de R con qué
# datos vamos a trabajar. En nuestro caso, hemos generado en formato ".txt" los
# datos a partir de un archivo de excel ".xlsx". De esta forma podremos trabajar
# con ellos en forma de código (Eliminando la necesidad de programas externos).

# El comando que utilizaremos será "read.delim", este comando lee un archivo y 
# crea un nuevo objeto con la información de este archivo como una si fuera una
# base de datos.

VariablesSuelo <- read.delim("data/Orusco_suelos.txt", sep="\t", dec=",", header=T)
load("data/AerialRoot.community.corregido.Rdata")

## Este comando dice: "Crea un nuevo objeto con el archivo de .txt con los datos, 
## su separación será con barras, el símbolo que marca el decimal es coma "," y 
## la primera fila de los datos corresponde al enunciado de las variables (por  
## eso le decimos que los datos tienen enunciado, y que lo tenga en cuenta como 
## tal)".



#______________________  1.2 COMPROBACIONES INICIALES  ________________________#

# Las siguientes operaciones, cargan algunos parámetros imprescindibles para la 
# realización de este tutorial. A su vez, comprueba que la versión de R es  
# apta para trabajar y confirma la correcta instalación de todos los paquetes 
# que vamos a necesitar.Por último, se realiza un "curating data" de los datos, 
# que es un  proceso en el que se homogeniza la base de datos brutos  y se eliman
# los parámetros innecesarios para el tutorial. (Los datos contienen información
# extra que otro investigador podría utilizar en el futuro para sus estudios)



# 1.2.a) Verificación de la versión de R:
# Comprobaremos que la versión sea igual o superior a la 3.6.0.

if(getRversion() < "3.6.0") {stop("##########\nLa versión de R que posee es antigua\nPor favor, instale la última versión\n##########")}

## El comando aplica lo siguiente: "Si la versión de R es menor que la 3.6.0,
## genera un mensaje de alerta donde especifique el mensaje" (En este caso, el 
## mensaje elegido es un aviso de que la versión de R es antigua y se necesita 
## actualizar)


# 1.2.b) Verificación de la versión de RStudio:
# Comprobaremos que la versión sea igual o superior a la 1.0.1.

if(RStudio.Version()$version < "1.0.1"){stop("##########\nLa versión de RStudio que posee es antigua\nPor favor, instale la última versión\n##########")}

## El comando aplica lo siguiente: "Si la versión de RStudio es menor que la 
## 3.6.0, genera un mensaje de alerta donde especifique el mensaje" (En este 
## caso, el mensaje elegido es un aviso de que la versión de RStudio es antigua
## y se necesita actualizar)


# 1.2.c) Verificación de los paquetes CRAN:
# Comprobaremos si los paquetes necesarios están instalados.
PaquetesNecesarios <- c("lattice","sp","gstat","maptools","spatstat","raster","automap")
installed_packages <- .packages(all.available = TRUE)
PaquetesNecesarios2 <- PaquetesNecesarios[!PaquetesNecesarios %in% installed_packages]

# Descarga de paquetes faltantes de CRAN: 

if(length(PaquetesNecesarios2) > 0){install.packages(PaquetesNecesarios2)}
stopifnot(all(c(PaquetesNecesarios) %in% .packages(all.available = TRUE)))


# 1.2.d) Finalización de las comprobaciones:

rm(PaquetesNecesarios, PaquetesNecesarios2, installed_packages)

## El comando "rm()" elimina los objetos puestos entre paréntesis, en este caso 
## los objetos que hemos utilizado para confirmar que los paquetes están instalados.


# 1.2.e) Curating data:

# Renombramos el título de de la columna 11 (COD -> Codigo_muestra).

colnames(VariablesSuelo)[11] <- "Codigo_muestra"

# Eliminamos las columnas que no nos interesan para este tutorial en concreto,
# simplificando así los datos.

orusco.soil <- VariablesSuelo
VariablesSuelo$Fecha <- NULL
VariablesSuelo$COND <- NULL
VariablesSuelo$Altura.elipsoidal <- NULL
VariablesSuelo$id_suelo_raiz <- NULL
VariablesSuelo$Nº <- NULL
VariablesSuelo$Marco <- NULL
VariablesSuelo$ID_GPS <- NULL

#___________________  1.3 CARGA DE PAQUETES DE R NECESARIOS ___________________#

# En el paso 1.2 hemos descargado los paquetes de R que necesitamos para hacer 
# el tutorial.Vamos a cargarlos usando el comando "library(NombreDelPaquete)"

library(lattice)
library(sp)
library(gstat)
library(maptools)
library(spatstat)
library(raster)
library(automap)


#______ 1.4 RECLASIFICACIÓN DE LOS DATOS ORIGINALES A DATOS ESPACIALES ________#

# Con las siguientes operaciones vamos a modificar el tipo de objeto que son los 
# datos, para así poder trabajar con ellos espacialmente. Para ello, asignaremos 
# al objeto un nuevo sistema de coordenadas y limitaremos el número de decimales
# que puedan tener los datos a 10.

# Como trabajaremos de forma local, no necesitamos coordenadas globales, y por 
# ello utilizaremos como nuevas coordenadas los valores de Xlocal e Ylocal en
# relación a "VariablesSuelo". Al dar coordenadas a los datos de VariablesSuelo los convierte de 
# un objeto "data.frame" a un objeto "SpatialPointDataFrame".

# Para esta operación utilizaremos el comando "coordinates()". Este comando dice:
# "Utiliza como coordenadas x e y para los datos recogidos en el objeto  
# VariablesSuelo, los valores de las columnas Xlocal e Ylocal respectivamente".

coordinates(VariablesSuelo) <- ~ Xlocal + Ylocal

# Con este comando podemos cerciorarnos si VariablesSuelo ha cambiado su clase a
# "SpatialPointsDataFrame".

class(VariablesSuelo)

## Efectivamente, ahora es un "SpatialPointsDataFrame".##


# Por ultimo, limitaremos el número de decimales de los datos a 10, para evitar
# cifras excesivamente largas, para ello usaremos el siguiente comando:

options(digits=10)


################################################################################
######################## 2 PREPARACIÓN ÁREA DE ESTUDIO #########################
################################################################################

# En este proceso, vamos a generar el mapa base desde el cual vamos a realizar 
# posteriormente el mapa de cada variable. En esta fase indicaremos el tamaño 
# del área de estudio, las coordenadas que poseen y el tamaño de malla que 
# utilizaremos para el posterior análisis por kriging.También refinaremos y 
# adaptaremos los datos al tamaño y forma del área estudiada.



#_______________________  2.1 GENERACIÓN DEL MAPA BASE ________________________#


# 2.1.a Creacion del polígono base: 
# Generaremos un rectángulo con dimensiones iguales al área de estudio donde
# posteriormente plasmaremos los diferentes mapas que generemos.


# Para ello, vamos a usar los cuatro puntos de las esquinas de nuestro área de
# estudio. Hemos cargado una matriz llamada "esquinas.parcela".
# Esta matriz tiene los datos en Xlocal e Ylocal de dónde se sitúan los vertices
# del rectángulo que forma nuestra parcela. Con estos datos, crearemos un
# polígono rectangular que cubra exactamente el área de estudio.

# Creamos el objeto "p1", que es básicamente el cuadrado que se forma al dibujar 
# la matriz de "esquinas.parcela".
p1 <- Polygon(esquinas.parcela[,1:2])


# Ahora dotaremos a este polígono de un atributo espacial, utilizando el comando
# "Polygons()".

ps1 <- Polygons(list(p1),1)

# Creamos un nuevo objeto para convertir "ps1" de la clase "Polygons" a
# un "SpatialPolygons" llamado sps1.
sps1 <- SpatialPolygons(list(ps1))

# Podemos ver qué clase es "sps1" con el comando "class()" y cerciorarnos.
class(sps1)

## Observamos que la clase es efectivamente "SpatialPolygons".

# 2.1.b Generación de la malla:

# Generaremos una malla con la ayuda del polígono creado en el paso anterior que 
# nos servirá para los posteriores análisis estadísticos de kriaje.el tamaño de 
# la rejilla será de 0,05 x 0,05 m y eliminaremos los puntos que queden fuera de
# este rectángulo.

# El siguiente comando dice: "Creáme una malla regular con los datos de VariablesSuelo, 
# donde el tamaño de celda sean 5 cm".
grid = spsample(VariablesSuelo, type = "regular", cellsize = c(0.05, 0.05))

# Con la siguiente línea de comando eliminaremos los puntos que quedan fuera de 
# nuestro grid.
pts1 <- as.data.frame(grid[!is.na(over(grid, sps1,))])

# Al ser una parcela independiente y no tener que relacionarla con otros lugares,
# no necesitamos que las coordenadas del gps sean las globales,simplificamos
# esto cambiando nuestro sistema de coordenadas a uno que solo tenga en cuenta
# la parcela.

# Cambiamos el nombre de las coordenadas de X e Y; los llamaremos Xlocal, Ylocal
# ya que en el paso siguiente, lo que haremos es cambiar el sist. de coordenadas,
# pasando de unas cordenadas globales (X,Y) a las coordenadas locales (X e Ylocal).
names(pts1) <- c("Xlocal", "Ylocal")

# Hacemos que pts1 asocie como coordenadas las columnas de Xlocal e Ylocal.
# A su vez generamos que pts1 pase a ser un SpatialPoints object con coordenadas.
coordinates(pts1) <- c("Xlocal", "Ylocal")

pts1 <- SpatialPixelsDataFrame(as(pts1, "SpatialPoints"), data=as(pts1, "data.frame"), tolerance=0.077)

# Podemos observar cómo quedaría gráficamente el objeto "pts1".
plot(pts1)

# Asignamos un sistema de coordenadas a la malla:
grid = spsample(VariablesSuelo, type = "regular", cellsize = c(0.05,0.05), proj4string = CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))



################################################################################
########################## 3 NORMALIZACIÓN DE LAS VARIABLES ####################
################################################################################

# En esta tercera fase, vamos a transformar los datos brutos para conseguir que 
# sigan una tendencia normalizada. Esto nos permitirá realizar la cartografía de
# cada variable utilizando el método de kriging y autokriging en la fase 4.


#_______________  3.1 METODOLOGÍA DE NORMALIZACIÓN DE VARIABLES _______________#


# Para la realización de los mapas, utilizaremos la técnica de kriging, que es
# un método de interpolación geoestadístico de estimación de puntos.Este método
# requiere que los datos de cada variable sigan una tendencia más o menos
# normalizada. En caso de que esta no lo sea, realizaremos modificaciones con el
# objetivo de normalizarlos.

# Observaremos gráficamente si los datos están normalizados visualizando 
# gráficamente su histograma y su gráfico cuantil-cuantil. Por último se hará un
# test de shapiro para comprobar si cumple con una tendencia normalizada.

# 3.1.a Histograma: 

# Representación de distribuciones de frecuencias, en el que se emplean rectángulos
# dentro de unas coordenadas. Si el gráfico realiza una forma de U invertida
# en la parte central del dibujo, tendrá una tendencia normalizada.
# Para realizar este gráfico, utilizaremos el comando "hist()".


# 3.1.b Gráfico cuantil-cuantil: 

# También denominada "qqnorm" nos permite observar cómo de cerca está la 
# distribución observada a una distribución normal idealizada. Si la línea del
# gráfico dibuja una linea recta y ascendente "/" indicará que los valores siguen
# una tendencia normalizada. 
# Para realizar este gráfico, utilizaremos el comando "qqnorm()".


# 3.1.c Test de Shapiro:

# Es una prueba estadística para contrastar la normalidad de un conjunto de datos.
# El test nos dará un p-valor,si este indicador es mayor al 0.07, indica que los
# datos se adaptan a un patrón normalizado.
# Para realizar esta comprobación, utilizaremos el comando "shapiro.test()".


# 3.1.d Modificación de los datos:

# En caso de que los datos no se ajusten a la tendecia normalidad, debemos 
# ejecutar transformaciones de los datos para intentar que se adapten. Para ello
# podemos hacer algunas de las siguientes transformaciones:

# 1º Realizar el logaritmo                          --> Log(variable)
# 2º Realizar el logaritmo +1                       --> Log (variable+1)
# 3º Realizar (Variable - media)/desviación estándar--> var-median(var)/sd(var)
# 4º Realizar raíz cuadrada                         --> sqrt(variable)
# 5º Realizar box-cox*                              --> boxcox(variable)

# *NOTA: Para el uso de la función boxcox() debemos abrir antes library(MASS)*


#__________________  3.2 NORMALIZACIÓN DE VARIABLE GLUCOSIDADA ________________#

hist(VariablesSuelo$GLUC) # No muestra un patrón normalizado.
qqnorm(VariablesSuelo$GLUC) # No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$GLUC)) # El p-valor es muy bajo, No muestra un patrón normalizado.


hist(log(VariablesSuelo$GLUC)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$GLUC)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$GLUC)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo de la glucosidasa para el mapeado --> LOG(GLUC)


#__________________  3.3 NORMALIZACIÓN DE VARIABLE FOSFATASA ________________#

hist(VariablesSuelo$FOSF) # No muestra un patrón normalizado.
qqnorm(VariablesSuelo$FOSF) # No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$FOSF)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$FOSF)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$FOSF)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$FOSF)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo de la fosfatasa para el mapeado --> LOG(FOSF)


#___________________  3.4 NORMALIZACIÓN DE VARIABLE NITRÓGENO _________________#

hist(VariablesSuelo$N) # Muestra un patrón normalizado.
qqnorm(VariablesSuelo$N) # Muestra un patrón normalizado.
shapiro.test((VariablesSuelo$N)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos directamente el valor de Nitrógeno para el mapeado --> (N)


#____________________  3.5 NORMALIZACIÓN DE VARIABLE FÓSFORO __________________#

hist(VariablesSuelo$P) # Muestra un patrón normalizado.
qqnorm(VariablesSuelo$P) # Muestra un patrón normalizado.
shapiro.test((VariablesSuelo$P)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos directamente el valor de Fósforo para el mapeado --> (P)


#____________________  3.6 NORMALIZACIÓN DE VARIABLE POTASIO __________________#

hist(VariablesSuelo$K) # No muestra un patrón normalizado.
qqnorm(VariablesSuelo$K) # No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$K)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$K)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$K)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$K)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos el logaritmo del potasio  para el mapeado --> LOG(K)


#____________________  3.7 NORMALIZACIÓN DE VARIABLE CARBONO __________________#

hist(VariablesSuelo$C) # No muestra un patrón normalizado.
qqnorm(VariablesSuelo$C) # No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$C)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$C)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$C)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$C)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del carbono para el mapeado --> LOG(C)


#______________________  3.8 NORMALIZACIÓN DE VARIABLE pH _____________________#
##### ECHARLE UN OJO ####

hist(VariablesSuelo$pH) # No muestra un patrón normalizado.
qqnorm(VariablesSuelo$pH) # No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$pH)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$pH)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$pH)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$pH)) # El p-valor es aceptable. Muestra un patrón normalizado.

hist(log(VariablesSuelo$pH+1)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$pH+1)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$pH+1)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del pH para el mapeado --> (pH)


#____________________  3.9 NORMALIZACIÓN DE VARIABLE ARENA ____________________#

hist(VariablesSuelo$Arena) # Muestra un patrón normalizado.
qqnorm(VariablesSuelo$Arena) # Muestra un patrón normalizado.
shapiro.test((VariablesSuelo$Arena)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos directamente el valor de Arena para el mapeado --> (Arena)


#____________________  3.10 NORMALIZACIÓN DE VARIABLE LIMO ____________________#

hist(VariablesSuelo$Limo) # No muestra un patrón normalizado.
qqnorm(VariablesSuelo$Limo) # No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$Limo)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$Limo)) # Muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$Limo)) # Muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$Limo)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del Limo para el mapeado --> LOG(Limo)


#___________________  3.11 NORMALIZACIÓN DE VARIABLE ARCILLA __________________#
##NI IDEA DE CUAL USAR##

hist(VariablesSuelo$Arcilla) #No muestra un patrón normalizado.
qqnorm(VariablesSuelo$Arcilla) #No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$Arcilla)) #El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$Arcilla)) #No muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$Arcilla)) #No muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$Arcilla)) #El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(VariablesSuelo$Arcilla)+1) # No muestra un patrón normalizado.
qqnorm(log(VariablesSuelo$Arcilla)+1) # No muestra un patrón normalizado.
shapiro.test(log(VariablesSuelo$Arcilla)+1) #El p-valor es muy bajo, No muestra un patrón normalizado.

hist(sqrt(VariablesSuelo$Arcilla)) #  No muestra un patrón normalizado.
qqnorm(sqrt(VariablesSuelo$Arcilla)) # No muestra un patrón normalizado.
shapiro.test(sqrt(VariablesSuelo$Arcilla)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist((VariablesSuelo$Arcilla-median(VariablesSuelo$Arcilla))/sd(VariablesSuelo$Arcilla)) 
#No muestra un patrón normalizado.
qqnorm((VariablesSuelo$Arcilla-median(VariablesSuelo$Arcilla))/sd(VariablesSuelo$Arcilla)) 
#No muestra un patrón normalizado.
shapiro.test((VariablesSuelo$Arcilla-median(VariablesSuelo$Arcilla))/sd(VariablesSuelo$Arcilla)) 
#El p-valor es muy bajo, No muestra un patrón normalizado.

##NI IDEA DE CUAL USAR USO LOG QUE TIENE EL P-Valor más bajo##
# Utilizaremos el logaritmo del Arcilla +1 para el mapeado --> LOG(Arcilla)+1



################################################################################
##################### 4 GENERACIÓN DE LA CARTOGRAFÍA EDÁFICA ###################
################################################################################

# En esta última fase, vamos a realizar los mapas de cada una de las variables
# utilizando el método de estimación geoestadístico denominado kriging.Esta 
# técnica de interpolación, utiliza un modelo de variograma para poder estimar 
# el resto de puntos intermedios donde no se tiene un dato real recogido 
# directamente del campo.


#__________________  4.1 METODOLOGÍA DE CARTOGRAFÍA EDÁFICA ___________________#

# Existen dos formas para la realización de cartografía edáfica utilizando el 
# método de kriaje:

# 4.1.a Automáticamente con la función "autokriging()": 
# El propio programa estadístico R, realiza los cálculos y elige el sistema con 
# una mejor relación con la realidad. Sus estimaciones aunque bastante precisas, 
# suelen incurrir en cierto error, este puede ser asumible dependiendo del grado
# de precisión que desee el estudio.

# 4.1.b Kriging manual: 
# Ejecutamos cinco modelos matemáticos con y sin tendencia y observamos cual se
# adapta mejor a nuestra serie de datos, posteriormente, se genera un krigeado
# partiendo de ese modelo y se visualiza cómo quedaría gráficamente.

# Antes de realizar el kriging manual y, para mejorar la precisión del kriging, 
# necesitamos observar a qué modelo matemático concreto se ajusta el variograma 
# con mayor exactitud. 

# Esto, podemos observarlo mediante el comando "autofitVariogram" seguido de los
# diferentes modelos estudiados: Exponencial (Exp), Esférico (Sph), Gausiano(Gau)
# Lineal(Lin) y la parametrización de Stein (Ste).

# Ejemplo:
autofitVariogram(log(GLUC) ~ 1, VariablesSuelo, model = c("Exp"))$sserr

# Esta línea de código nos informará cómo se adapta el variograma de datos de la
# Glucosidasa al modelo exponencial sin ninguna tendencia. Este comando nos dará
# como salida un valor de semivarianza, cuanto más cercano esté este valor a 0,
# mayor se ajustará los datos a la modelización Exponencial (en este caso).

# Para procesar todos los modelos a la vez, vamos a crear una matriz (una tabla) 
# vacía donde poner los resultados de semivarianza sin tendencia o con ella 
# (utilizando Xlocal como valores de tendencia) de los 5 modelos estudiados. De
# esta forma, podremos observar qué valor de semivarianza es menor (es decir, a 
# qué modelo se ajustan mejor los datos) y utilizar ese modelo matemático para
# producir la cartografía mediante el kriging.


#__________________  4.2 CARTOGRAFÍA DE VARIABLE GLUCOSIDASA ___________________#

# 4.2.a Autokriging de Glucosidasa:

# Autokriging sin tendencia:
Autok.GLUC.ST <- autoKrige(log(GLUC) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.GLUC.ST)

# Autokriging con tendencia
Autok.GLUC.CT <- autoKrige(log(GLUC) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.GLUC.CT)


# 4.2.b Kriging manual de Glucosidasa:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizGLUC <- matrix(NA,2,5)
colnames(MatrizGLUC) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizGLUC) <- c("Sin tendencia", "Con tendencia")

# Rellenamos con los datos de cada modelo:
## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

# Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizGLUC[1,1] <- autofitVariogram(log(GLUC) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizGLUC[1,2] <- autofitVariogram(log(GLUC) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizGLUC[1,3] <- autofitVariogram(log(GLUC)  ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizGLUC[1,4] <- autofitVariogram(log(GLUC)  ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizGLUC[1,5] <- autofitVariogram(log(GLUC)  ~ 1, VariablesSuelo, model = c("Ste"))$sserr
# Con tendencia (Utilizamos Xlocal como tendencia):
MatrizGLUC[2,1] <- autofitVariogram(log(GLUC)  ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizGLUC[2,2] <- autofitVariogram(log(GLUC)  ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizGLUC[2,3] <- autofitVariogram(log(GLUC)  ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizGLUC[2,4] <- autofitVariogram(log(GLUC) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizGLUC[2,5] <- autofitVariogram(log(GLUC)  ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la matriz
## tiene un valor menor".
which((MatrizGLUC) == min(MatrizGLUC), arr.ind=TRUE)

# En este caso nos dice que "STE CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"ste" con tendencia:

v.fitGLUCsteCT = autofitVariogram(log(GLUC) ~ Xlocal, VariablesSuelo, model = c("Ste"))$var_model

# A continuación podemos realizar el kriaje de la Glucosidasa.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Ste" con tendencia en la 
## malla pts1".

GLUC.mapa <- krige(log(GLUC) ~  Xlocal, VariablesSuelo, pts1, v.fitGLUCsteCT)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de glucosidasa:

## La siguiente función expresa "Genera un gráfico del objeto GLUC.mapa (que es
## el resultado del kriaje de los datos) y cuyo título sea "GLUCOSIDASA".

plot(GLUC.mapa, main= "GLUCOSIDASA") 




#__________________  4.3 CARTOGRAFÍA DE VARIABLE FOSFATASA ____________________#

# 4.3.a Autokriging de Fosfatasa:

# Autokriging sin tendencia:
Autok.FOSF.ST <- autoKrige(log(FOSF) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.FOSF.ST)

# Autokriging con tendencia
Autok.FOSF.CT <- autoKrige(log(FOSF) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.FOSF.CT)


# 4.2.b Kriging manual de Fosfatasa:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".


MatrizFOSF <- matrix(NA,2,5)
colnames(MatrizFOSF) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizFOSF) <- c("Sin tendencia", "Con tendencia")

# Rellenamos con los datos de cada modelo:
## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizFOSF[1,1] <- autofitVariogram(log(FOSF) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizFOSF[1,2] <- autofitVariogram(log(FOSF) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizFOSF[1,3] <- autofitVariogram(log(FOSF)  ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizFOSF[1,4] <- autofitVariogram(log(FOSF)  ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizFOSF[1,5] <- autofitVariogram(log(FOSF)  ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizFOSF[2,1] <- autofitVariogram(log(FOSF)  ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizFOSF[2,2] <- autofitVariogram(log(FOSF)  ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizFOSF[2,3] <- autofitVariogram(log(FOSF)  ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizFOSF[2,4] <- autofitVariogram(log(FOSF)  ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizFOSF[2,5] <- autofitVariogram(log(FOSF)  ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la matriz
## tiene un valor menor".
which((MatrizFOSF) == min(MatrizFOSF), arr.ind=TRUE)

# En este caso nos dice que "GAU SIN TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Gau" sin tendencia:

v.fitFOSFgauST = autofitVariogram(log(FOSF) ~ 1, VariablesSuelo, model = c("Gau"))$var_model


# A continuación podemos realizar el kriaje de la fosfatasa:

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Gau" sin tendencia en la 
## malla pts1".
FOSF.mapa <- krige(log(FOSF) ~  1, VariablesSuelo, pts1, v.fitFOSFgauST)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de glucosidasa:

## La siguiente función expresa "Genera un gráfico del objeto FOSF.mapa (que es
## el resultado del kriaje de los datos) y cuyo título sea "FOSFATASA".

plot(FOSF.mapa, main= "FOSFATASA")


#__________________  4.4 CARTOGRAFÍA DE VARIABLE NITRÓGENO ____________________#

# 4.4.a Autokriging de Nitrógeno:

# Autokriging sin tendencia:
Autok.N.ST <- autoKrige((N) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.N.ST)

# Autokriging con tendencia
Autok.N.CT <- autoKrige((N) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.N.CT)


# 4.4.b Kriging manual de Nitrógeno:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizN <- matrix(NA,2,5)
colnames(MatrizN) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizN) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizN[1,1] <- autofitVariogram((N) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizN[1,2] <- autofitVariogram((N) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizN[1,3] <- autofitVariogram((N)  ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizN[1,4] <- autofitVariogram((N)  ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizN[1,5] <- autofitVariogram((N)  ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizN[2,1] <- autofitVariogram((N)  ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizN[2,2] <- autofitVariogram((N)  ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizN[2,3] <- autofitVariogram((N)  ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizN[2,4] <- autofitVariogram((N)  ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizN[2,5] <- autofitVariogram((N)  ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".
which((MatrizN) == min(MatrizN), arr.ind=TRUE)

# En este caso nos dice que "LIN CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Lin" con tendencia:

v.fitNlinCT = autofitVariogram((N) ~ 1, VariablesSuelo, model = c("Lin"))$var_model


# A continuación podemos realizar el kriaje del Nitrógeno.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Lin" con tendencia en la 
## malla pts1".

N.mapa <- krige((N) ~  1, VariablesSuelo, pts1, v.fitNlinCT)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Nitrógeno:

## La siguiente función expresa "Genera un gráfico del objeto N.mapa (que es el
## resultado del kriaje de los datos) y cuyo título sea "NITRÓGENO".

plot(N.mapa, main= "NITRÓGENO") 


#__________________  4.5 CARTOGRAFÍA DE VARIABLE FÓSFORO ____________________#

# 4.5.a Autokriging de Fósforo:

# Autokriging sin tendencia:
Autok.P.ST <- autoKrige((P) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.P.ST)

# Autokriging con tendencia
Autok.P.CT <- autoKrige((P) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.P.CT)


# 4.5.b Kriging manual de Fósforo:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".


MatrizP <- matrix(NA,2,5)
colnames(MatrizP) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizP) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

# Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizP[1,1] <- autofitVariogram((P) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizP[1,2] <- autofitVariogram((P) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizP[1,3] <- autofitVariogram((P) ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizP[1,4] <- autofitVariogram((P) ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizP[1,5] <- autofitVariogram((P) ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizP[2,1] <- autofitVariogram((P) ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizP[2,2] <- autofitVariogram((P) ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizP[2,3] <- autofitVariogram((P) ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizP[2,4] <- autofitVariogram((P) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizP[2,5] <- autofitVariogram((P) ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".
which((MatrizP) == min(MatrizP), arr.ind=TRUE)


# En este caso nos dice que "GAU CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Gau" con tendencia:
v.fitPgauCT = autofitVariogram((P) ~ Xlocal, VariablesSuelo, model = c("Gau"))$var_model


# A continuación podemos realizar el kriaje del Fósforo.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Gau" con tendencia en la 
## malla pts1".

P.mapa <- krige((P) ~  Xlocal, VariablesSuelo, pts1, v.fitPgauCT)


# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Fósforo:

## La siguiente función expresa "Genera un gráfico del objeto P.mapa (que es el
## resultado del kriaje de los datos) y cuyo título sea "FÓSFORO".

plot(P.mapa, main= "FÓSFORO") #En el intercomillado va el título.



#___________________  4.6 CARTOGRAFÍA DE VARIABLE POTASIO _____________________#

# 4.6.a Autokriging de Potasio:

# Autokriging sin tendencia:
Autok.K.ST <- autoKrige(log(K) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.K.ST)

# Autokriging con tendencia
Autok.K.CT <- autoKrige(log(K) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.K.CT)


# 4.6.b Kriging manual de Potasio:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizK <- matrix(NA,2,5)
colnames(MatrizK) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizK) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizK[1,1] <- autofitVariogram(log(K) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizK[1,2] <- autofitVariogram(log(K) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizK[1,3] <- autofitVariogram(log(K)  ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizK[1,4] <- autofitVariogram(log(K)  ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizK[1,5] <- autofitVariogram(log(K)  ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizK[2,1] <- autofitVariogram(log(K)  ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizK[2,2] <- autofitVariogram(log(K)  ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizK[2,3] <- autofitVariogram(log(K)  ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizK[2,4] <- autofitVariogram(log(K) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizK[2,5] <- autofitVariogram(log(K)  ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr


# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".

which((MatrizK) == min(MatrizK), arr.ind=TRUE)

# En este caso nos dice que "LIN CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Lin" con tendencia:

v.fitKlinCT = autofitVariogram(log(K) ~ Xlocal, VariablesSuelo, model = c("Lin"))$var_model


# A continuación podemos realizar el kriaje del Potasio.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Lin" con tendencia en la 
## malla pts1".

K.mapa <- krige(log(K) ~  Xlocal, VariablesSuelo, pts1, v.fitKlinCT)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Potasio:

## La siguiente función expresa "Genera un gráfico del objeto K.mapa (que es el
## resultado del kriaje de los datos) y cuyo título sea "POTASIO".

plot(K.mapa, main= "POTASIO") 



#___________________  4.7 CARTOGRAFÍA DE VARIABLE CARBONO _____________________#

# 4.7.a Autokriging de Carbono:

# Autokriging sin tendencia:
Autok.C.ST <- autoKrige(log(C) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.C.ST)

# Autokriging con tendencia
Autok.C.CT <- autoKrige(log(C) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.C.CT)


# 4.7.b Kriging manual de Carbono:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizC <- matrix(NA,2,5)
colnames(MatrizC) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizC) <- c("Sin tendencia", "Con tendencia")

# Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

# Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizC[1,1] <- autofitVariogram(log(C) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizC[1,2] <- autofitVariogram(log(C) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizC[1,3] <- autofitVariogram(log(C)  ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizC[1,4] <- autofitVariogram(log(C)  ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizC[1,5] <- autofitVariogram(log(C)  ~ 1, VariablesSuelo, model = c("Ste"))$sserr
# Con tendencia (Utilizamos Xlocal como tendencia):
MatrizC[2,1] <- autofitVariogram(log(C)  ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizC[2,2] <- autofitVariogram(log(C)  ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizC[2,3] <- autofitVariogram(log(C)  ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizC[2,4] <- autofitVariogram(log(C) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizC[2,5] <- autofitVariogram(log(C)  ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".

which((MatrizC) == min(MatrizC), arr.ind=TRUE)

# En este caso nos dice que "GAU CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
# "Gau" con tendencia:

v.fitCgauCT = autofitVariogram(log(C) ~ Xlocal, VariablesSuelo, model = c("Gau"))$var_model


# A continuación podemos realizar el kriaje del Carbono.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Gau" con tendencia en la 
## malla pts1".

C.mapa <- krige(log(C) ~  Xlocal, VariablesSuelo, pts1, v.fitCgauCT)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Carbono:

## La siguiente función expresa "Genera un gráfico del objeto C.mapa (que es el
## resultado del kriaje de los datos) y cuyo título sea "CARBONO".

plot(C.mapa, main= "CARBONO")


#______________________  4.8 CARTOGRAFÍA DE VARIABLE pH _______________________#

# 4.8.a Autokriging de pH:

# Autokriging sin tendencia:
Autok.pH.ST <- autoKrige((pH) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.pH.ST)

# Autokriging con tendencia
Autok.pH.CT <- autoKrige((pH) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.pH.CT)


# 4.8.b Kriging manual de pH:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizpH <- matrix(NA,2,5)
colnames(MatrizpH) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizpH) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizpH[1,1] <- autofitVariogram((pH) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizpH[1,2] <- autofitVariogram((pH) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizpH[1,3] <- autofitVariogram((pH) ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizpH[1,4] <- autofitVariogram((pH) ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizpH[1,5] <- autofitVariogram((pH) ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizpH[2,1] <- autofitVariogram((pH) ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizpH[2,2] <- autofitVariogram((pH) ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizpH[2,3] <- autofitVariogram((pH) ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizpH[2,4] <- autofitVariogram((pH) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizpH[2,5] <- autofitVariogram((pH) ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".

which((MatrizpH) == min(MatrizpH), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Ste" sin tendencia:

v.fitpHsteST = autofitVariogram((pH) ~ 1, VariablesSuelo, model = c("Ste"))$var_model

# A continuación podemos realizar el kriaje del pH.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Ste" sin tendencia en la 
## malla pts1".

pH.mapa <- krige((pH) ~  1, VariablesSuelo, pts1, v.fitpHsteST)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de pH:

## La siguiente función expresa "Genera un gráfico del objeto pH.mapa (que es el
## resultado del kriaje de los datos) y cuyo título sea "pH".

plot(pH.mapa, main= "pH") 



#_____________________  4.9 CARTOGRAFÍA DE VARIABLE ARENA _____________________#

# 4.9.a Autokriging de Arena:

# Autokriging sin tendencia:
Autok.Arena.ST <- autoKrige((Arena) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.Arena.ST)

# Autokriging con tendencia
Autok.Arena.CT <- autoKrige((Arena) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.Arena.CT)


# 4.9.b Kriging manual de Arena:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizArena <- matrix(NA,2,5)
colnames(MatrizArena) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizArena) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizArena[1,1] <- autofitVariogram((Arena) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizArena[1,2] <- autofitVariogram((Arena) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizArena[1,3] <- autofitVariogram((Arena)  ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizArena[1,4] <- autofitVariogram((Arena)  ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizArena[1,5] <- autofitVariogram((Arena)  ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizArena[2,1] <- autofitVariogram((Arena)  ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizArena[2,2] <- autofitVariogram((Arena)  ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizArena[2,3] <- autofitVariogram((Arena)  ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizArena[2,4] <- autofitVariogram((Arena) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizArena[2,5] <- autofitVariogram((Arena)  ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".

which((MatrizArena) == min(MatrizArena), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Ste" sin tendencia:

v.fitArenasteST = autofitVariogram((Arena) ~ 1, VariablesSuelo, model = c("Ste"))$var_model


# A continuación podemos realizar el kriaje de la Arena.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Ste" sin tendencia en la 
## malla pts1"

Arena.mapa <- krige((Arena) ~  1, VariablesSuelo, pts1, v.fitArenasteST)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Arena:

## La siguiente función expresa "Genera un gráfico del objeto Arena.mapa (que es 
## el resultado del kriaje de los datos) y cuyo título sea "CONTENIDO EN ARENAS".


plot(Arena.mapa, main= "CONTENIDO EN ARENAS")



#_____________________  4.10 CARTOGRAFÍA DE VARIABLE LIMO _____________________#

# 4.10.a Autokriging de Limo:

# Autokriging sin tendencia:
Autok.Limo.ST <- autoKrige(log(Limo) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.Limo.ST)

# Autokriging con tendencia
Autok.Limo.CT <- autoKrige(log(Limo) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.Limo.CT)


# 4.10.b Kriging manual de Limo:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizLimo <- matrix(NA,2,5)
colnames(MatrizLimo) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizLimo) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizLimo[1,1] <- autofitVariogram(log(Limo) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizLimo[1,2] <- autofitVariogram(log(Limo) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizLimo[1,3] <- autofitVariogram(log(Limo) ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizLimo[1,4] <- autofitVariogram(log(Limo) ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizLimo[1,5] <- autofitVariogram(log(Limo) ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizLimo[2,1] <- autofitVariogram(log(Limo) ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizLimo[2,2] <- autofitVariogram(log(Limo) ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizLimo[2,3] <- autofitVariogram(log(Limo) ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizLimo[2,4] <- autofitVariogram(log(Limo) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizLimo[2,5] <- autofitVariogram(log(Limo) ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".

which((MatrizLimo) == min(MatrizLimo), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Ste" sin tendencia:

v.fitLimosteST = autofitVariogram(log(Limo) ~ 1, VariablesSuelo, model = c("Ste"))$var_model

# A continuación podemos realizar el kriaje de la variable Limos.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Ste" sin tendencia en la 
## malla pts1".

Limo.mapa <- krige(log(Limo) ~  1, VariablesSuelo, pts1, v.fitLimosteST)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Limos:

## La siguiente función expresa "Genera un gráfico del objeto Limo.mapa (que es 
## el resultado del kriaje de los datos) y cuyo título sea "CONTENIDO EN LIMO".

plot(Limo.mapa, main= "CONTENIDO EN LIMO") 


#____________________  4.11 CARTOGRAFÍA DE VARIABLE ARCILLA ____________________#

# 4.11.a Autokriging de Arcilla:


# Autokriging sin tendencia:
Autok.Arcilla.ST <- autoKrige(log(Arcilla+1) ~ 1, VariablesSuelo, pts1 )
# Visualizamos como sería la representación gráfica sin tendencia:
plot(Autok.Arcilla.ST)

# Autokriging con tendencia:
Autok.Arcilla.CT <- autoKrige(log(Arcilla+1) ~ Xlocal, VariablesSuelo, new_data=pts1 )
# Visualizamos como sería la representación gráfica con tendencia:
plot(Autok.Arcilla.CT)


# 4.11.b Kriging manual de Arcillas:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizArcilla <- matrix(NA,2,5)
colnames(MatrizArcilla) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizArcilla) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:

## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizArcilla[1,1] <- autofitVariogram(log(Arcilla+1) ~ 1, VariablesSuelo, model = c("Exp"))$sserr
MatrizArcilla[1,2] <- autofitVariogram(log(Arcilla+1) ~ 1, VariablesSuelo, model = c("Sph"))$sserr
MatrizArcilla[1,3] <- autofitVariogram(log(Arcilla+1) ~ 1, VariablesSuelo, model = c("Gau"))$sserr
MatrizArcilla[1,4] <- autofitVariogram(log(Arcilla+1) ~ 1, VariablesSuelo, model = c("Lin"))$sserr
MatrizArcilla[1,5] <- autofitVariogram(log(Arcilla+1) ~ 1, VariablesSuelo, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizArcilla[2,1] <- autofitVariogram(log(Arcilla+1) ~ Xlocal, VariablesSuelo,model = c("Exp"))$sserr
MatrizArcilla[2,2] <- autofitVariogram(log(Arcilla+1) ~ Xlocal, VariablesSuelo,model = c("Sph"))$sserr
MatrizArcilla[2,3] <- autofitVariogram(log(Arcilla+1) ~ Xlocal, VariablesSuelo,model = c("Gau"))$sserr
MatrizArcilla[2,4] <- autofitVariogram(log(Arcilla+1) ~ Xlocal, VariablesSuelo,model = c("Lin"))$sserr
MatrizArcilla[2,5] <- autofitVariogram(log(Arcilla+1) ~ Xlocal, VariablesSuelo,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## El siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".

which((MatrizArcilla) == min(MatrizArcilla), arr.ind=TRUE)

# En este caso nos dice que "LIN CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"Lin" con tendencia:

v.fitArcillalinCT = autofitVariogram(log(Arcilla+1) ~ Xlocal, VariablesSuelo, model = c("Lin"))$var_model


# A continuación podemos realizar el kriaje de las arcillas:

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de VariablesSuelo adaptados al modelo "Lin" con tendencia en la 
## malla pts1".

Arcilla.mapa <- krige(log(Arcilla+1) ~  Xlocal, VariablesSuelo, pts1, v.fitArcillalinCT)


# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de Arcilla:

## La siguiente función expresa "Genera un gráfico del objeto Arcilla.mapa (que 
## es el resultado del kriaje de los datos) y cuyo título sea "CONTENIDO EN 
## ARCILLA".

plot(Arcilla.mapa, main= "CONTENIDO EN ARCILLAS")


################################################################################
################################################################################
################################################################################
################################################################################

Á É Í Ó Ú    á é í ó ú    Ñ ñ
