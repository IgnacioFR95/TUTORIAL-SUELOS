#   _____           _                    _           _ 
#  |_   _|  _   _  | |_    ___    _ __  (_)   __ _  | |
#    | |   | | | | | __|  / _ \  | '__| | |  / _` | | |
#    | |   | |_| | | |_  | (_) | | |    | | | (_| | | |
#    |_|    \__,_|  \__|  \___/  |_|    |_|  \__,_| |_|
#    ____                  _                                     __    _         
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

#¡ANTENCIÓN! LEER ANTENTAMENTE EL ARCHIVO README ANTES DE INICIAR ESTE TUTORIAL.

# Para cualquier información adicional sobre el funcionamiento de algún comando,
# puedes utilizar "?NombreDelComando". Lo que abrirá una nueva pestaña con más
# información sobre su uso y la gramática que utiliza. Si el comando pertenece a
# un paquete de R concreto, puedes utilizar el comando "??NombreDelComando" para
# recibir la misma información.

################################### ÍNDICE #####################################

# |1|  PREPARACIÓN DE DATOS
#    ??? |1.1| Carga de datos iniciales.
#    ??? |1.2| Carga de códigos iniciales (source). 
#                           NOTA: NO SÉ SI LOS DEJAREMOS EN SOURCE O SE EXPLICAN
#    ??? |1.3| Carga de paquetes R necesarios.
#    ??? |1.4| Reclasificación datos originales a datos espaciales.
#   
# |2|  PREPARACIÓN ÁREA DE ESTUDIO
#    ??? |2.1| Generación del mapa base.
#          ??? 2.1.a Generación del polígono
#          ??? 2.1.b Generación de la malla
#    ??? |2.2| Adaptación de los datos a mapa base.
#
# |3|  NORMALIZACIÓN DE LAS VARIABLES
#    ??? 3.1 Metodología de normalización de variables
#          ??? 3.1.a Histograma
#          ??? 3.1.b Gráfico cuantil-cuantil
#          ??? 3.1.c Test de shapiro
#          ??? 3.1.d Modificación de los datos
#    ??? 3.2 Normalización variable GLUCOSIDASA
#    ??? 3.3 Normalización variable FOSFATASA
#    ??? 3.4 Normalización variable NITRÓGENO
#    ??? 3.4 Normalización variable FÓSFORO
#    ??? 3.5 Normalización variable POTASIO
#    ??? 3.6 Normalización variable CARBONO
#    ??? 3.7 Normalización variable pH
#    ??? 3.8 Normalización variable ARENA
#    ??? 3.9 Normalización variable LIMO
#    ??? 3.10 Normalización variable ARCILLA
#
# |4|  GENERACIÓN DE CARTOGRAFÍA EDÁFICA
#    ??? 4.1 Metodología de cartografía edáfica
#    ??? 4.2 Cartografía de variable GLUCOSIDASA
#    ??? 4.3 Cartografía de variable FOSFATASA
#    ??? 4.4 Cartografía de variable NITRÓGENO
#    ??? 4.4 Cartografía de variable FÓSFORO
#    ??? 4.5 Cartografía de variable POTASIO
#    ??? 4.6 Cartografía de variable CARBONO
#    ??? 4.7 Cartografía de variable pH
#    ??? 4.8 Cartografía de variable ARENA
#    ??? 4.9 Cartografía de variable LIMO
#    ??? 4.10 Cartografía de variable ARCILLA

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

suelo1 <- read.delim("data/Brea_suelos.txt", sep="\t", dec=",", header=T)
suelo2 <- read.delim("data/Orusco_suelos.txt", sep="\t", dec=",", header=T)

# Este comando dice: "Crea un nuevo objeto con el archivo de .txt con los datos, 
# su separación será con barras, el símbolo que marca el decimal es coma "," y la 
# primera fila de los datos corresponde al enunciado de las variables (por eso 
# le decimos que los datos tienen enunciado, y que lo tenga en cuenta como tal)".

load("data/AerialRoot.community.corregido.Rdata")


#______________________  1.2 CARGA DE CÓDIGOS INICIALES _______________________#

# Esto carga algunos parámetros y comandos imprescindibles, se hace para acortar
# procesos y así ahorrar tiempo.También te asegura que tienes cargados todos los
# complementos necesarios y que la versión de R es apta para trabajar.

source("start/setup.R")
source("start/curatingdata.R") ##¡SÓLO SE PUEDE CARGAR UNA VEZ!


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

#  Con las siguientes operaciones vamos a modificar el tipo de objeto que son los 
# datos, para así poder trabajar con ellos espacialmente. Para ello, asignaremos 
# al objeto un nuevo sistema de coordenadas y limitaremos el número de decimales
# que puedan tener los datos a 10.

# Como trabajaremos de forma local, no necesitamos coordenadas globales, y por 
# ello utilizaremos como nuevas coordenadas los valores de Xlocal e Ylocal en
# relación a "suelo2". Al dar coordenadas a los datos de suelo2 los convierte de 
# un objeto "data.frame" a un objeto "SpatialPointDataFrame".

# Para esta operación utilizaremos el comando "coordinates()". Este comando dice:
# "Utiliza como coordenadas x e y para los datos recogidos en el objeto suelo2, 
# los valores de las columnas Xlocal e Ylocal respectivamente".

coordinates(suelo2) <- ~ Xlocal + Ylocal

# Con este comando podemos cerciorarnos si suelo2 ha cambiado su clase a
# "SpatialPointsDataFrame".

class(suelo2)

##Efectivamente, ahora es un "SpatialPointsDataFrame".##


#Por ultimo, limitaremos el número de decimales de los datos a 10, para evitar
# cifras excesivamente largas, para ello usaremos el siguiente comando:

options(digits=10)


################################################################################
######################## 2 PREPARACIÓN ÁREA DE ESTUDIO #########################
################################################################################

# En este proceso vamos a generar el mapa base desde el cual vamos a realizar 
# posteriormente los mapas de cada variable. En esta fase indicaremos el tamaño 
# del área de estudio, las coordenadas que poseen y el tamaño de malla que 
# utilizaremos para el posterior análisis por kriging.También adaptaremos los 
# datos al tamaño y forma del área estudiada.
# 


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


# Esta es una función diferente a la anterior, esta es "Polygons" con s al final.
# Aún no he entendido la diferencia leyéndome el manual.
ps1 <- Polygons(list(p1),1)

# Creamos un nuevo objeto para convertir "ps1" de la clase "Polygons" a
# un "SpatialPolygons" llamado sps1.
sps1 <- SpatialPolygons(list(ps1))

#Podemos ver qué clase es "sps1" con el comando "class()" y cerciorarnos.
class(sps1)

##Observamos que la clase es efectivamente "SpatialPolygons".

# 2.1.b Generación de la malla:
# Generaremos una malla con la ayuda del polígono creado en el paso anterior que 
# nos servirá para los posteriores análisis estadísticos de kriage.el tamaño de 
# la rejilla será de 0,05 x 0,05 m y eliminaremos los puntos que queden fuera de
# este rectángulo.
 


# El siguiente comando dice: "Creáme una malla regular con los datos de suelo2, 
# donde el tamaño de celda sean 5 cm".
grid = spsample(suelo2, type = "regular", cellsize = c(0.05, 0.05))

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

#Podemos observar cómo quedaría gráficamente el objeto "pts1".
plot(pts1)

# Asignamos un sistema de coordenadas a la malla:
grid = spsample(suelo2, type = "regular", cellsize = c(0.05,0.05), proj4string = CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))



################################################################################
########################## 3 NORMALIZACIÓN DE LAS VARIABLES ####################
################################################################################

# En esta tercera fase vamos a transformar los datos brutos para conseguir que 
# sigan una tendecia normalizada. Esto nos permitirá realizar la cartografía de
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
# dentro de unas coordenadas. Si el gráfico realiza una forma de U invertida "???"
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

hist(suelo2$GLUC) # No muestra un patrón normalizado.
qqnorm(suelo2$GLUC) # No muestra un patrón normalizado.
shapiro.test((suelo2$GLUC)) # El p-valor es muy bajo, No muestra un patrón normalizado.


hist(log(suelo2$GLUC)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$GLUC)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$GLUC)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo de la glucosidasa para el mapeado --> LOG(GLUC)


#__________________  3.3 NORMALIZACIÓN DE VARIABLE FOSFATASA ________________#

hist(suelo2$FOSF) # No muestra un patrón normalizado.
qqnorm(suelo2$FOSF) # No muestra un patrón normalizado.
shapiro.test((suelo2$FOSF)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$FOSF)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$FOSF)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$FOSF)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo de la fosfatasa para el mapeado --> LOG(FOSF)


#___________________  3.4 NORMALIZACIÓN DE VARIABLE NITRÓGENO _________________#

hist(suelo2$N) # Muestra un patrón normalizado.
qqnorm(suelo2$N) # Muestra un patrón normalizado.
shapiro.test((suelo2$N)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos directamente el valor de Nitrógeno para el mapeado --> (N)


#____________________  3.5 NORMALIZACIÓN DE VARIABLE FÓSFORO __________________#

hist(suelo2$P) # Muestra un patrón normalizado.
qqnorm(suelo2$P) # Muestra un patrón normalizado.
shapiro.test((suelo2$P)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos directamente el valor de Fósforo para el mapeado --> (P)


#____________________  3.6 NORMALIZACIÓN DE VARIABLE POTASIO __________________#

hist(suelo2$K) # No muestra un patrón normalizado.
qqnorm(suelo2$K) # No muestra un patrón normalizado.
shapiro.test((suelo2$K)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$K)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$K)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$K)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos el logaritmo del potasio  para el mapeado --> LOG(K)


#____________________  3.7 NORMALIZACIÓN DE VARIABLE CARBONO __________________#

hist(suelo2$C) # No muestra un patrón normalizado.
qqnorm(suelo2$C) # No muestra un patrón normalizado.
shapiro.test((suelo2$C)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$C)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$C)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$C)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del carbono para el mapeado --> LOG(C)


#______________________  3.8 NORMALIZACIÓN DE VARIABLE pH _____________________#
##### ECHARLE UN OJO ####

hist(suelo2$pH) # No muestra un patrón normalizado.
qqnorm(suelo2$pH) # No muestra un patrón normalizado.
shapiro.test((suelo2$pH)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$pH)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$pH)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$pH)) # El p-valor es aceptable. Muestra un patrón normalizado.

hist(log(suelo2$pH+1)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$pH+1)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$pH+1)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del pH para el mapeado --> LOG(pH+1)


#____________________  3.9 NORMALIZACIÓN DE VARIABLE ARENA ____________________#

hist(suelo2$Arena) # Muestra un patrón normalizado.
qqnorm(suelo2$Arena) # Muestra un patrón normalizado.
shapiro.test((suelo2$Arena)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos directamente el valor de Arena para el mapeado --> (Arena)


#____________________  3.10 NORMALIZACIÓN DE VARIABLE LIMO ____________________#

hist(suelo2$Limo) # No muestra un patrón normalizado.
qqnorm(suelo2$Limo) # No muestra un patrón normalizado.
shapiro.test((suelo2$Limo)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$Limo)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$Limo)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$Limo)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del Limo para el mapeado --> LOG(Limo)


#___________________  3.11 NORMALIZACIÓN DE VARIABLE ARCILLA __________________#
##NI IDEA DE CUAL USAR##

hist(suelo2$Arcilla) #No muestra un patrón normalizado.
qqnorm(suelo2$Arcilla) #No muestra un patrón normalizado.
shapiro.test((suelo2$Arcilla)) #El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$Arcilla)) #No muestra un patrón normalizado.
qqnorm(log(suelo2$Arcilla)) #No muestra un patrón normalizado.
shapiro.test(log(suelo2$Arcilla)) #El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$Arcilla)+1) # No muestra un patrón normalizado.
qqnorm(log(suelo2$Arcilla)+1) # No muestra un patrón normalizado.
shapiro.test(log(suelo2$Arcilla)+1) #El p-valor es muy bajo, No muestra un patrón normalizado.

hist(sqrt(suelo2$Arcilla)) #  No muestra un patrón normalizado.
qqnorm(sqrt(suelo2$Arcilla)) # No muestra un patrón normalizado.
shapiro.test(sqrt(suelo2$Arcilla)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist((suelo2$Arcilla-median(suelo2$Arcilla))/sd(suelo2$Arcilla)) 
#No muestra un patrón normalizado.
qqnorm((suelo2$Arcilla-median(suelo2$Arcilla))/sd(suelo2$Arcilla)) 
#No muestra un patrón normalizado.
shapiro.test((suelo2$Arcilla-median(suelo2$Arcilla))/sd(suelo2$Arcilla)) 
#El p-valor es muy bajo, No muestra un patrón normalizado.

##NI IDEA DE CUAL USAR USO LOG QUE TIENE EL P-Valor más bajo##
# Utilizaremos el logaritmo del Arcilla para el mapeado --> LOG(Arcilla)



################################################################################
######################## 4 GENERACIÓN DE CARTOGRAFÍA EDÁFICA ###################
################################################################################

# En esta última fase, vamos a realizar los mapas de cada una de las variables
# utilizando el método de interpolación estadístico de estimación denominado
# Kriging. Esta técnica de interpolación, utiliza un modelo de variograma para
# obtener los ponderadores para poder estimar el resto del área intermedia donde
# no se tiene un dato real recogido directamente del campo.


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
# adapta mejor a lo que queremos, posteriormente, se genera ese modelo en
# cartografía.

# Antes de realizar el kriging manual y, para mejorar la precisión del kriging, 
# necesitamos observar a qué modelo matemático concreto se ajusta el variograma 
# con mayor exactitud. 
 
# Esto, podemos observarlo mediante el comando "autofitVariogram" seguido de los
# diferentes modelos estudiados: Exponencial (Exp), Esférico (Sph), Gausiano(Gau)
# Lineal(Lin) y la parametrización de Stein (Ste).

# Ejemplo:
autofitVariogram(log(GLUC) ~ 1, suelo2, model = c("Exp"))$sserr

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

# 4.2.a Autokrigging de Glucosidasa:

# Autokriging sin tendencia:
Autok.GLUC.ST <- autoKrige(log(GLUC) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.GLUC.ST)

# Autokriging con tendencia
Autok.GLUC.CT <- autoKrige(log(GLUC) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.GLUC.CT)


# 4.2.b Kriging manual de Glucosidasa:

# Generamos una matriz donde exponer las semivarianzas de cada modelo:

## Le decimos al programa "genera una matriz de 2x5 y nombra las columnas y las 
## filas con los nombres de los modelos y la tendencia respectivamente".

MatrizGLUC <- matrix(NA,2,5)
colnames(MatrizGLUC) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizGLUC) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
## Le decimos al programa "rellena la matriz generada con la semivarianza de cada
## modelo matemático y con o sin tendencia". Se debe asegurar de introducir los
## datos en el mismo orden que hemos facilitado a la matriz en el anterior paso.

#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizGLUC[1,1] <- autofitVariogram(log(GLUC) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizGLUC[1,2] <- autofitVariogram(log(GLUC) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizGLUC[1,3] <- autofitVariogram(log(GLUC)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizGLUC[1,4] <- autofitVariogram(log(GLUC)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizGLUC[1,5] <- autofitVariogram(log(GLUC)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizGLUC[2,1] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizGLUC[2,2] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizGLUC[2,3] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizGLUC[2,4] <- autofitVariogram(log(GLUC) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizGLUC[2,5] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor de semivarianza menor.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.

## Con el siguiente comando le decimos al programa "Dime qué coordenada de la
## matriz tiene un valor menor".
which((MatrizGLUC) == min(MatrizGLUC), arr.ind=TRUE)

# En este caso nos dice que "STE CON TENDENCIA" es el mejor, así que será el 
# utilizado.Realizamos un autofitting de nuestros datos adaptándolo al modelo 
#"ste" con tendencia:

v.fitGLUCsteCT = autofitVariogram(log(GLUC) ~ Xlocal, suelo2, model = c("Ste"))$var_model

# A continuación podemos realizar el kriaje de la Glucosidasa.

## Con esta función pedimos al programa "Genera un objeto que sea el fruto del
## kriaje de los datos de suelo2 adaptados al modelo "Ste" con tendencia en la 
## malla pts1".

GLUC.mapa <- krige(log(GLUC) ~  Xlocal, suelo2, pts1, v.fitGLUCsteCT)

# Por útlimo, observaremos el resultado gráficamente, dando como fruto un mapa
# de la zona en el que se observan las concentraciones de glucosidasa:

## La siguiente función expresa "Genera un gráfico del objeto GLUC.mapa (que es
## el resultado del kriaje de los datos) y cuyo título sea "GLUCOSIDASA".

plot(GLUC.mapa, main= "GLUCOSIDASA") 




#____________________________ MAPITA DE FOSFATASA _____________________________#

### AUTOkriging FOSFATASA ###

# Autokriging sin tendencia:
Autok.FOSF.ST <- autoKrige(log(FOSF+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.FOSF.ST)

# Autokriging con tendencia
Autok.FOSF.CT <- autoKrige(log(FOSF+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.FOSF.CT)


### PREPARACIÓN kriging MANUAL DE LA FOSFATASA ###

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizFOSF <- matrix(NA,2,5)
colnames(MatrizFOSF) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizFOSF) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizFOSF[1,1] <- autofitVariogram(log(FOSF) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizFOSF[1,2] <- autofitVariogram(log(FOSF) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizFOSF[1,3] <- autofitVariogram(log(FOSF)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizFOSF[1,4] <- autofitVariogram(log(FOSF)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizFOSF[1,5] <- autofitVariogram(log(FOSF)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizFOSF[2,1] <- autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizFOSF[2,2] <- autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizFOSF[2,3] <- autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizFOSF[2,4] <- autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizFOSF[2,5] <- autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizFOSF) == min(MatrizFOSF), arr.ind=TRUE)

# En este caso nos dice que "GAU SIN TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "Gau" sin tendencia:
v.fitFOSFgauST = autofitVariogram(log(FOSF) ~ 1, suelo2, model = c("Gau"))$var_model


### REALIZACIÓN kriging MANUAL FOSFATASA ###
FOSF.mapa <- krige(log(FOSF+1) ~  1, suelo2, pts1, v.fitFOSFgauST)


plot(FOSF.mapa, main= "FOSFATASA") #En el intercomillado va el título.

################################################################################
################################################################################

#____________________________ MAPITA DE NITRÓGENO _____________________________#

### AUTOkriging NITRÓGENO ###

# Autokriging sin tendencia:
Autok.N.ST <- autoKrige(log(N+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.N.ST)

# Autokriging con tendencia
Autok.N.CT <- autoKrige(log(N+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.N.CT)


### PREPARACIÓN kriging MANUAL DE LA NITRÓGENO ###

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizN <- matrix(NA,2,5)
colnames(MatrizN) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizN) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizN[1,1] <- autofitVariogram(log(N) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizN[1,2] <- autofitVariogram(log(N) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizN[1,3] <- autofitVariogram(log(N)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizN[1,4] <- autofitVariogram(log(N)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizN[1,5] <- autofitVariogram(log(N)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizN[2,1] <- autofitVariogram(log(N)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizN[2,2] <- autofitVariogram(log(N)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizN[2,3] <- autofitVariogram(log(N)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizN[2,4] <- autofitVariogram(log(N)  ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizN[2,5] <- autofitVariogram(log(N)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizN) == min(MatrizN), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "Ste" sin tendencia:
v.fitNsteST = autofitVariogram(log(N) ~ 1, suelo2, model = c("Ste"))$var_model


### REALIZACIÓN kriging MANUAL NITRÓGENO ###
N.mapa <- krige(log(N+1) ~  1, suelo2, pts1, v.fitNsteST)


plot(N.mapa, main= "NITRÓGENO") #En el intercomillado va el título.

################################################################################
################################################################################


#_____________________________MAPITA DE POTASIO___________________________#

### AUTOkriging POTASIO ###

# Autokriging sin tendencia:
Autok.K.ST <- autoKrige(log(K+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.K.ST)

# Autokriging con tendencia
Autok.K.CT <- autoKrige(log(K+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.K.CT)


### PREPARACIÓN kriging MANUAL POTASIO ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizK <- matrix(NA,2,5)
colnames(MatrizK) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizK) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizK[1,1] <- autofitVariogram(log(K) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizK[1,2] <- autofitVariogram(log(K) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizK[1,3] <- autofitVariogram(log(K)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizK[1,4] <- autofitVariogram(log(K)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizK[1,5] <- autofitVariogram(log(K)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizK[2,1] <- autofitVariogram(log(K)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizK[2,2] <- autofitVariogram(log(K)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizK[2,3] <- autofitVariogram(log(K)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizK[2,4] <- autofitVariogram(log(K) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizK[2,5] <- autofitVariogram(log(K)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizK) == min(MatrizK), arr.ind=TRUE)

# En este caso nos dice que "LIN CON TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "ste" con tendencia:
v.fitKlinCT = autofitVariogram(log(K) ~ Xlocal, suelo2, model = c("Lin"))$var_model


### REALIZACIÓN kriging MANUAL POTASIO ###
K.mapa <- krige(log(K+1) ~  Xlocal, suelo2, pts1, v.fitKlinCT)


plot(K.mapa, main= "POTASIO") #En el intercomillado va el título.

################################################################################
################################################################################
#_____________________________MAPITA DE CARBONO ___________________________#

### AUTOkriging CARBONO ###

# Autokriging sin tendencia:
Autok.C.ST <- autoKrige(log(C+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.C.ST)

# Autokriging con tendencia
Autok.C.CT <- autoKrige(log(C+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.C.CT)


### PREPARACIÓN kriging MANUAL CARBONO ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizC <- matrix(NA,2,5)
colnames(MatrizC) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizC) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizC[1,1] <- autofitVariogram(log(C) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizC[1,2] <- autofitVariogram(log(C) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizC[1,3] <- autofitVariogram(log(C)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizC[1,4] <- autofitVariogram(log(C)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizC[1,5] <- autofitVariogram(log(C)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizC[2,1] <- autofitVariogram(log(C)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizC[2,2] <- autofitVariogram(log(C)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizC[2,3] <- autofitVariogram(log(C)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizC[2,4] <- autofitVariogram(log(C) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizC[2,5] <- autofitVariogram(log(C)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizC) == min(MatrizC), arr.ind=TRUE)

# En este caso nos dice que "GAU CON TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "ste" con tendencia:
v.fitCgauCT = autofitVariogram(log(C) ~ Xlocal, suelo2, model = c("Gau"))$var_model


### REALIZACIÓN kriging MANUAL CARBONO ###
C.mapa <- krige(log(C+1) ~  Xlocal, suelo2, pts1, v.fitCgauCT)


plot(C.mapa, main= "CARBONO") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE pH ___________________________#

### AUTOkriging pH ###

# Autokriging sin tendencia:
Autok.pH.ST <- autoKrige((pH) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.pH.ST)

# Autokriging con tendencia
Autok.pH.CT <- autoKrige((pH) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.pH.CT)


### PREPARACIÓN kriging MANUAL pH ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizpH <- matrix(NA,2,5)
colnames(MatrizpH) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizpH) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizpH[1,1] <- autofitVariogram((pH) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizpH[1,2] <- autofitVariogram((pH) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizpH[1,3] <- autofitVariogram((pH)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizpH[1,4] <- autofitVariogram((pH)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizpH[1,5] <- autofitVariogram((pH)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizpH[2,1] <- autofitVariogram((pH)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizpH[2,2] <- autofitVariogram((pH)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizpH[2,3] <- autofitVariogram((pH)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizpH[2,4] <- autofitVariogram((pH) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizpH[2,5] <- autofitVariogram((pH)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizpH) == min(MatrizpH), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "ste" sin tendencia:
v.fitpHsteST = autofitVariogram((pH) ~ 1, suelo2, model = c("Ste"))$var_model


### REALIZACIÓN kriging MANUAL pH ###
pH.mapa <- krige((pH+1) ~  1, suelo2, pts1, v.fitpHsteST)


plot(pH.mapa, main= "pH") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE CONTENIDO EN ARENAS ___________________________#

### AUTOkriging CONTENIDO EN ARENAS ###

# Autokriging sin tendencia:
Autok.Arena.ST <- autoKrige(log(Arena+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.Arena.ST)

# Autokriging con tendencia
Autok.Arena.CT <- autoKrige(log(Arena+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.Arena.CT)


### PREPARACIÓN kriging MANUAL CONTENIDO EN ARENAS ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizArena <- matrix(NA,2,5)
colnames(MatrizArena) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizArena) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizArena[1,1] <- autofitVariogram(log(Arena) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizArena[1,2] <- autofitVariogram(log(Arena) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizArena[1,3] <- autofitVariogram(log(Arena)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizArena[1,4] <- autofitVariogram(log(Arena)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizArena[1,5] <- autofitVariogram(log(Arena)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizArena[2,1] <- autofitVariogram(log(Arena)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizArena[2,2] <- autofitVariogram(log(Arena)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizArena[2,3] <- autofitVariogram(log(Arena)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizArena[2,4] <- autofitVariogram(log(Arena) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizArena[2,5] <- autofitVariogram(log(Arena)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizArena) == min(MatrizArena), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "ste" sin tendencia:
v.fitArenasteST = autofitVariogram(log(Arena) ~ 1, suelo2, model = c("Ste"))$var_model


### REALIZACIÓN kriging MANUAL CONTENIDO EN ARENAS ###
Arena.mapa <- krige(log(Arena+1) ~  1, suelo2, pts1, v.fitArenasteST)


plot(Arena.mapa, main= "CONTENIDO EN ARENAS") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE CONTENIDO EN LIMO ___________________________#

### AUTOkriging CONTENIDO EN LIMO ###

# Autokriging sin tendencia:
Autok.Limo.ST <- autoKrige(log(Limo+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.Limo.ST)

# Autokriging con tendencia
Autok.Limo.CT <- autoKrige(log(Limo+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.Limo.CT)


### PREPARACIÓN kriging MANUAL CONTENIDO EN LIMO ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizLimo <- matrix(NA,2,5)
colnames(MatrizLimo) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizLimo) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizLimo[1,1] <- autofitVariogram(log(Limo) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizLimo[1,2] <- autofitVariogram(log(Limo) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizLimo[1,3] <- autofitVariogram(log(Limo)  ~ 1, suelo2, model = c("Gau"))$sserr
MatrizLimo[1,4] <- autofitVariogram(log(Limo)  ~ 1, suelo2, model = c("Lin"))$sserr
MatrizLimo[1,5] <- autofitVariogram(log(Limo)  ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizLimo[2,1] <- autofitVariogram(log(Limo)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizLimo[2,2] <- autofitVariogram(log(Limo)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizLimo[2,3] <- autofitVariogram(log(Limo)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizLimo[2,4] <- autofitVariogram(log(Limo) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizLimo[2,5] <- autofitVariogram(log(Limo)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizLimo) == min(MatrizLimo), arr.ind=TRUE)

# En este caso nos dice que "STE SIN TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "ste" sin tendencia:
v.fitLimosteST = autofitVariogram(log(Limo) ~ 1, suelo2, model = c("Ste"))$var_model


### REALIZACIÓN kriging MANUAL CONTENIDO EN LIMO ###
Limo.mapa <- krige(log(Limo+1) ~  1, suelo2, pts1, v.fitLimosteST)


plot(Limo.mapa, main= "CONTENIDO EN LIMO") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE CONTENIDO EN ARCILLAS ___________________________#

### AUTOkriging CONTENIDO EN ARCILLAS ###

# Autokriging sin tendencia:
Autok.Arcilla.ST <- autoKrige(log(Arcilla+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.Arcilla.ST)

# Autokriging con tendencia
Autok.Arcilla.CT <- autoKrige(log(Arcilla+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.Arcilla.CT)


### PREPARACIÓN kriging MANUAL CONTENIDO EN ARCILLAS ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizArcilla <- matrix(NA,2,5)
colnames(MatrizArcilla) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizArcilla) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizArcilla[1,1] <- autofitVariogram(log(Arcilla) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizArcilla[1,2] <- autofitVariogram(log(Arcilla) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizArcilla[1,3] <- autofitVariogram(log(Arcilla) ~ 1, suelo2, model = c("Gau"))$sserr
MatrizArcilla[1,4] <- autofitVariogram(log(Arcilla) ~ 1, suelo2, model = c("Lin"))$sserr
MatrizArcilla[1,5] <- autofitVariogram(log(Arcilla) ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizArcilla[2,1] <- autofitVariogram(log(Arcilla) ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizArcilla[2,2] <- autofitVariogram(log(Arcilla) ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizArcilla[2,3] <- autofitVariogram(log(Arcilla) ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizArcilla[2,4] <- autofitVariogram(log(Arcilla) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizArcilla[2,5] <- autofitVariogram(log(Arcilla) ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizArcilla) == min(MatrizArcilla), arr.ind=TRUE)

# En este caso nos dice que "LIN CON TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "Lin" con tendencia:
v.fitArcillalinCT = autofitVariogram(log(Arcilla) ~ Xlocal, suelo2, model = c("Lin"))$var_model


### REALIZACIÓN kriging MANUAL CONTENIDO EN ARCILLAS ###
Arcilla.mapa <- krige(log(Arcilla+1) ~  Xlocal, suelo2, pts1, v.fitArcillalinCT)


plot(Arcilla.mapa, main= "CONTENIDO EN ARCILLAS") #En el intercomillado va el título.

################################################################################
################################################################################


#_____________________________MAPITA DE FÓSFORO ___________________________#

### AUTOkriging FÓSFORO ###

# Autokriging sin tendencia:
Autok.P.ST <- autoKrige(log(P+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.P.ST)

# Autokriging con tendencia
Autok.P.CT <- autoKrige(log(P+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.P.CT)


### PREPARACIÓN kriging MANUAL FÓSFORO ###

# Como hemos dicho anteriormente, antes de realizar el kriging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizP <- matrix(NA,2,5)
colnames(MatrizP) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizP) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
#Sin tendencia (Ponemos un 1, para indicar que no hay tendencia):
MatrizP[1,1] <- autofitVariogram(log(P+1) ~ 1, suelo2, model = c("Exp"))$sserr
MatrizP[1,2] <- autofitVariogram(log(P+1) ~ 1, suelo2, model = c("Sph"))$sserr
MatrizP[1,3] <- autofitVariogram(log(P+1) ~ 1, suelo2, model = c("Gau"))$sserr
MatrizP[1,4] <- autofitVariogram(log(P+1) ~ 1, suelo2, model = c("Lin"))$sserr
MatrizP[1,5] <- autofitVariogram(log(P+1) ~ 1, suelo2, model = c("Ste"))$sserr
#Con tendencia (Utilizamos Xlocal como tendencia):
MatrizP[2,1] <- autofitVariogram(log(P+1) ~ Xlocal, suelo2,model = c("Exp"))$sserr
MatrizP[2,2] <- autofitVariogram(log(P+1) ~ Xlocal, suelo2,model = c("Sph"))$sserr
MatrizP[2,3] <- autofitVariogram(log(P+1) ~ Xlocal, suelo2,model = c("Gau"))$sserr
MatrizP[2,4] <- autofitVariogram(log(P+1) ~ Xlocal, suelo2,model = c("Lin"))$sserr
MatrizP[2,5] <- autofitVariogram(log(P+1) ~ Xlocal, suelo2,model = c("Ste"))$sserr

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizP) == min(MatrizP), arr.ind=TRUE)

# En este caso nos dice que "GAU CON TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "Gau" con tendencia:
v.fitPgauCT = autofitVariogram(log(P+1) ~ Xlocal, suelo2, model = c("Gau"))$var_model


### REALIZACIÓN kriging MANUAL FÓSFORO ###
P.mapa <- krige(log(P+1) ~  Xlocal, suelo2, pts1, v.fitPgauCT)


plot(P.mapa, main= "FÓSFORO") #En el intercomillado va el título.

################################################################################
################################################################################

