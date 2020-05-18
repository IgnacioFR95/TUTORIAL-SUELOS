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
# puedes utilizar "?NombreDelComando". Lo que te abrirá una nueva pestaña con más
# información sobre su uso y la gramática que utiliza.

#_________________________ PASO 1: CARGAR LOS DATOS ___________________________#
# Antes de realizar ninguna operación, debemos decirle al proyecto de R con qué
# datos vamos a trabajar. En nuestro caso, hemos generdo en formato ".txt" los
# datos a partir de un archivo de excel ".xlsx". De esta forma podremos trabajar
# con ellos en forma de código (Eliminando la necesidad de programas externos).

# El comando que utilizaremos será "read.delim" este comando lee un archivo y 
# crea un nuevo objeto con la información de este archivo

suelo1 <- read.delim("data/Brea_suelos.txt", sep="\t", dec=",", header=T)
suelo2 <- read.delim("data/Orusco_suelos.txt", sep="\t", dec=",", header=T)

load("data/AerialRoot.community.corregido.Rdata")


# ____________________CARGA DE CÓDIGOS INICIALES (source) _____________________#
# Esto carga algunos parámetros y comandos imprescindibles, se hace para acortar
# procesos y así ahorrar tiempo.También te asegura que tienes cargados todos los
# complementos necesarios y que la versión de R es apta para trabajar.
source("start/setup.R")
source("start/curatingdata.R") ##¡SÓLO SE PUEDE CARGAR UNA VEZ!


#____________________________ CARGA DE LOS PAQUETES ___________________________#
library(lattice)
library(sp)
library(gstat)
library(maptools)
library(spatstat)
library(raster)
library(automap)


################################################################################

# Damos como coordenadas los valores de Xlocal e Ylocal en relación a "suelo2",
# al dar coordenadas a los datos de suelo2 los convierte deun objeto "data.frame"
# a un objeto "SpatialPointDataFrame".

coordinates(suelo2) <- ~ Xlocal + Ylocal

# Con este comando podemos cerciorarnos si suelo2 ha cambiado su clase a
# "SpatialPointsDataFrame"
class(suelo2)

#Este código limita el número de decimales a 10, de aquí en adelante.
options(digits=10)

#_____________________ PREPARACIÓN DE LA ZONA DE ESTUDIO:______________________#
# En este proceso vamos a hacer dos cosas:
#
# 1. Crear un polígono que cubra la superficie del área estudiada.

# 2. Adaptar los datos de suelo2 al tamaño y forma del polígono, para poder
#    trabajar luego encima de esta.

#------------------------------------------------------------------------------#

# 1. CREACIÓN DEL POLÍGONO:
# Para ello, vamos a usar los cuatro puntos de las esquinas de nuestro área de
# estudio para generarla. Hemos cargado una matriz llamada "esquinas.parcela".
# Esta matriz tiene los datos en Xlocal e Ylocal de dónde se sitúan los vertices
# del rectángulo que forma nuestra parcela. Con estos datos, crearemos un
# polígono rectangular que cubra exactamente el área de estudio.

# Creamos el objeto "p1", que es básicamente el objeto que se forma al dibujar la
# matriz de esquinas.parcela.
p1 <- Polygon(esquinas.parcela[,1:2])


# Esta es una función diferente a la anterior, esta es "Polygons" con s al final.
# Aún no he entendido la diferencia leyéndome el manual.
ps1 <- Polygons(list(p1),1)

# Creamos un nuevo objeto para convertir "ps1" de la clase "Polygons" a
# un "SpatialPolygons" llamado sps1.
sps1 <- SpatialPolygons(list(ps1))

#Podemos ver qué clase es "sps1" con el comando "class()" y cerciorarnos.
class(sps1)


# CREACIÓN DE LA MALLA:
# En esta operación crearemos la malla de trabajo gracias al polígono que hemos
# creado en el paso anterior; el tamaño de los recuadros serán de 0,05 x 0,05 m
# y eliminaremos los puntos que queden fuera de este rectángulo.


# El comando dice: Creáme una malla regular con los datos de suelo2, donde el
# tamaño de celda sean 5 cm
grid = spsample(suelo2, type = "regular", cellsize = c(0.05, 0.05))

# Con este comando eliminaremos los puntos que quedan fuera de nuestro grid.
pts1 <- as.data.frame(grid[!is.na(over(grid, sps1,))])

# Al ser una parcela independiente y no tener que relacionarla con otros lugares,
# no necesitamos que las coordenadas del gps sean las globales,simplificamos
# esto cambiando nuestro sistema de coordenadas a uno que solo tenga en cuenta
# la parcela.

# Cambiamos el nombre de las coordenadas de X e Y; los llamaremos Xlocal, Ylocal
# ya que en el paso siguiente, lo que haremos es cambiar el sist. de coordenadas,
# pasando de unas cordenadas globales (X,Y) a las coordenadas locales (X e Y local).
names(pts1) <- c("Xlocal", "Ylocal")

# Hacemos que pts1 asocie como coordenadas las columnas de Xlocal e Ylocal.
# A su vez generamos que pts1 pase a ser un SpatialPoints object con coordenadas.
coordinates(pts1) <- c("Xlocal", "Ylocal")

pts1 <- SpatialPixelsDataFrame(as(pts1, "SpatialPoints"), data=as(pts1, "data.frame"), tolerance=0.077)

#Podemos observar cómo quedaría gráficamente el objeto "pts1".
plot(pts1)

# Asignamos un sistema de coordenadas a la malla:
grid = spsample(suelo2, type = "regular", cellsize = c(0.05,0.05), proj4string = CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))


#_________________________ NORMALIZACIÓN DE LAS VARIABLES _____________________#

# Para la realización de los mapas, utilizaremos la técnica de krigging, que es
# un método de interpolación geoestadístico de estimación de puntos.Este método
# requiere que los datos de cada variable sigan una tendencia más o menos
# normalizada. En caso de que esta no lo sea, realizaremos modificaciones con el
# objetivo de normalizarlos.

# Observaremos gráficamente si los datos están normalizados visualizando el
# histograma y el qqnorm que representan; por último observaremos el p-valor
# obtenido del test de shapiro, si este indicador es mayor al 0.07, indica que
# los datos se adaptan a un patrón normalizado.


#############  GLUCOSIDASA  #############
hist(suelo2$GLUC) # No muestra un patrón normalizado.
qqnorm(suelo2$GLUC) # No muestra un patrón normalizado.
shapiro.test((suelo2$GLUC)) # El p-valor es muy bajo, No muestra un patrón normalizado.


hist(log(suelo2$GLUC)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$GLUC)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$GLUC)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo de la glucosidasa para el mapeado --> LOG(GLUC)


#############  FOSFATASA  #############
hist(suelo2$FOSF) # No muestra un patrón normalizado.
qqnorm(suelo2$FOSF) # No muestra un patrón normalizado.
shapiro.test((suelo2$FOSF)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$FOSF)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$FOSF)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$FOSF)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo de la fosfatasa para el mapeado --> LOG(FOSF)


#############  NITRÓGENO  #############
hist(suelo2$N) # Muestra un patrón normalizado.
qqnorm(suelo2$N) # Muestra un patrón normalizado.
shapiro.test((suelo2$N)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos directamente el valor de Nitrógeno para el mapeado --> (N)


#############  FÓSFORO  #############
hist(suelo2$P) # Muestra un patrón normalizado.
qqnorm(suelo2$P) # Muestra un patrón normalizado.
shapiro.test((suelo2$P)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos directamente el valor de Fósforo para el mapeado --> (P)


#############  POTASIO  #############  DUDA TOTAL
hist(suelo2$K) # No muestra un patrón normalizado.
qqnorm(suelo2$K) # No muestra un patrón normalizado.
shapiro.test((suelo2$K)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$K)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$K)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$K)) # El p-valor es aceptable. Muestra un patrón normalizado.

hist(((suelo2$K-median(suelo2$K))/sd(suelo2$K)))
qqnorm(((suelo2$K-median(suelo2$K))/sd(suelo2$K)))
shapiro.test(((suelo2$K-median(suelo2$K))/sd(suelo2$K)))

hist(log(suelo2$K+1)) # No muestra un patrón normalizado.
qqnorm(log(suelo2$K+1)) # No muestra un patrón normalizado.
shapiro.test(log(suelo2$K+1)) # El p-valor es muy bajo, No muestra un patrón normalizado.


# Utilizaremos el logaritmo del potasio  para el mapeado --> LOG(K)


############# CARBONO  #############
hist(suelo2$C) # No muestra un patrón normalizado.
qqnorm(suelo2$C) # No muestra un patrón normalizado.
shapiro.test((suelo2$C)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$C)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$C)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$C)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del carbono para el mapeado --> LOG(C)


############# pH  #############  DUDA TOTAL
hist(suelo2$pH) # No muestra un patrón normalizado.
qqnorm(suelo2$pH) # No muestra un patrón normalizado.
shapiro.test((suelo2$pH)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$pH)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$pH)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$pH)) # El p-valor es aceptable. Muestra un patrón normalizado.

hist(log(suelo2$pH+1)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$pH+1)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$pH+1)) # El p-valor es aceptable. Muestra un patrón normalizado.

hist(((suelo2$pH-median(suelo2$pH))/sd(suelo2$pH)))
qqnorm(((suelo2$pH-median(suelo2$pH))/sd(suelo2$pH)))
shapiro.test(((suelo2$pH-median(suelo2$pH))/sd(suelo2$pH)))

hist((sqrt(suelo2$pH))) # No muestra un patrón normalizado.
qqnorm((sqrt(suelo2$pH))) # No muestra un patrón normalizado.
shapiro.test((sqrt(suelo2$pH))) # El p-valor es muy bajo, No muestra un patrón normalizado.

# Utilizaremos el logaritmo del pH para el mapeado --> LOG(pH)


#############  Arena  #############
hist(suelo2$Arena) # Muestra un patrón normalizado.
qqnorm(suelo2$Arena) # Muestra un patrón normalizado.
shapiro.test((suelo2$Arena)) # El p-valor es aceptable. Muestra un patrón normalizado.


# Utilizaremos directamente el valor de Arena para el mapeado --> (Arena)



############# LIMO  #############
hist(suelo2$Limo) # No muestra un patrón normalizado.
qqnorm(suelo2$Limo) # No muestra un patrón normalizado.
shapiro.test((suelo2$Limo)) # El p-valor es muy bajo, No muestra un patrón normalizado.

hist(log(suelo2$Limo)) # Muestra un patrón normalizado.
qqnorm(log(suelo2$Limo)) # Muestra un patrón normalizado.
shapiro.test(log(suelo2$Limo)) # El p-valor es aceptable. Muestra un patrón normalizado.

# Utilizaremos el logaritmo del Limo para el mapeado --> LOG(Limo)










#______________________________NOTAS PARA HACER MAPAS__________________________#

# Hay dos formas de hacer este proceso:
# 1.Automáticamente con la función autokrigging:El propio R te realiza los
#  cálculos y el sistema con una mejor relación con la realidad.

# 2.Krigging manual: Ejecutamos cinco modelos matemáticos con y sin tendencia
# y observamos cual se adapta mejor a lo que queremos, posteriormente, se genera
# ese modelo en cartografía.


#_____________________________MAPITA DE GLUCOSIDASA___________________________#

### AUTOKRIGGING GLUCOSIDASA ###

# Autokrigging sin tendencia:
Autok.GLUC.ST <- autoKrige(log(GLUC+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.GLUC.ST)

# Autokrigging con tendencia
Autok.GLUC.CT <- autoKrige(log(GLUC+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.GLUC.CT)


### PREPARACIÓN KRIGGING MANUAL GLUCOSIDASA ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
# ajustar el variograma. Se puede hacer manualmente con el comando "(f(x) fitvariogram)"
#  y poniendo las diferentes variables o hacerlo automáticamente con la función
# "(autofitVariogram)".

# Buscaremos manualmente cual es el mejor modelo y lo utlizaremos.
# Vamos a crear una matriz (una tabla) vacía donde poner los resultados de los
# 5 modelos que estudiaremos y si lo hacemos con tendencia o sin tendencia.

# Estamos creando una matriz vacía donde poner todos los resultados de los
# posibles modelos:

MatrizGLUC <- matrix(NA,2,5)
colnames(MatrizGLUC) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(MatrizGLUC) <- c("Sin tendencia", "Con tendencia")

#Rellenamos con los datos de cada modelo:
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

# El modelo que se ajuste mejor será el que tenga un valor más bajo.
# Con el siguiente comando sabremos qué modelo nos aporta la semivarianza mínima.
which((MatrizGLUC) == min(MatrizGLUC), arr.ind=TRUE)

# En este caso nos dice que "STE CON TENDENCIA" es el mejor, así que lo usaremos.
# Realizamos un autofitting del modelo "ste" con tendencia:
v.fitGLUCsteCT = autofitVariogram(log(GLUC) ~ Xlocal, suelo2, model = c("Ste"))$var_model


### REALIZACIÓN KRIGGING MANUAL GLUCOSIDASA ###
GLUC.mapa <- krige(log(GLUC+1) ~  Xlocal, suelo2, pts1, v.fitGLUCsteCT)


plot(GLUC.mapa, main= "GLUCOSIDASA") #En el intercomillado va el título.

################################################################################
################################################################################

#____________________________ MAPITA DE FOSFATASA _____________________________#

### AUTOKRIGGING FOSFATASA ###

# Autokrigging sin tendencia:
Autok.FOSF.ST <- autoKrige(log(FOSF+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.FOSF.ST)

# Autokrigging con tendencia
Autok.FOSF.CT <- autoKrige(log(FOSF+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.FOSF.CT)


### PREPARACIÓN KRIGGING MANUAL DE LA FOSFATASA ###

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


### REALIZACIÓN KRIGGING MANUAL FOSFATASA ###
FOSF.mapa <- krige(log(FOSF+1) ~  1, suelo2, pts1, v.fitFOSFgauST)


plot(FOSF.mapa, main= "FOSFATASA") #En el intercomillado va el título.

################################################################################
################################################################################

#____________________________ MAPITA DE NITRÓGENO _____________________________#

### AUTOKRIGGING NITRÓGENO ###

# Autokrigging sin tendencia:
Autok.N.ST <- autoKrige(log(N+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.N.ST)

# Autokrigging con tendencia
Autok.N.CT <- autoKrige(log(N+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.N.CT)


### PREPARACIÓN KRIGGING MANUAL DE LA NITRÓGENO ###

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


### REALIZACIÓN KRIGGING MANUAL NITRÓGENO ###
N.mapa <- krige(log(N+1) ~  1, suelo2, pts1, v.fitNsteST)


plot(N.mapa, main= "NITRÓGENO") #En el intercomillado va el título.

################################################################################
################################################################################


#_____________________________MAPITA DE POTASIO___________________________#

### AUTOKRIGGING POTASIO ###

# Autokrigging sin tendencia:
Autok.K.ST <- autoKrige(log(K+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.K.ST)

# Autokrigging con tendencia
Autok.K.CT <- autoKrige(log(K+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.K.CT)


### PREPARACIÓN KRIGGING MANUAL POTASIO ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL POTASIO ###
K.mapa <- krige(log(K+1) ~  Xlocal, suelo2, pts1, v.fitKlinCT)


plot(K.mapa, main= "POTASIO") #En el intercomillado va el título.

################################################################################
################################################################################
#_____________________________MAPITA DE CARBONO ___________________________#

### AUTOKRIGGING CARBONO ###

# Autokrigging sin tendencia:
Autok.C.ST <- autoKrige(log(C+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.C.ST)

# Autokrigging con tendencia
Autok.C.CT <- autoKrige(log(C+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.C.CT)


### PREPARACIÓN KRIGGING MANUAL CARBONO ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL CARBONO ###
C.mapa <- krige(log(C+1) ~  Xlocal, suelo2, pts1, v.fitCgauCT)


plot(C.mapa, main= "CARBONO") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE pH ___________________________#

### AUTOKRIGGING pH ###

# Autokrigging sin tendencia:
Autok.pH.ST <- autoKrige((pH) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.pH.ST)

# Autokrigging con tendencia
Autok.pH.CT <- autoKrige((pH) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.pH.CT)


### PREPARACIÓN KRIGGING MANUAL pH ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL pH ###
pH.mapa <- krige((pH+1) ~  1, suelo2, pts1, v.fitpHsteST)


plot(pH.mapa, main= "pH") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE CONTENIDO EN ARENAS ___________________________#

### AUTOKRIGGING CONTENIDO EN ARENAS ###

# Autokrigging sin tendencia:
Autok.Arena.ST <- autoKrige(log(Arena+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.Arena.ST)

# Autokrigging con tendencia
Autok.Arena.CT <- autoKrige(log(Arena+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.Arena.CT)


### PREPARACIÓN KRIGGING MANUAL CONTENIDO EN ARENAS ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL CONTENIDO EN ARENAS ###
Arena.mapa <- krige(log(Arena+1) ~  1, suelo2, pts1, v.fitArenasteST)


plot(Arena.mapa, main= "CONTENIDO EN ARENAS") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE CONTENIDO EN LIMO ___________________________#

### AUTOKRIGGING CONTENIDO EN LIMO ###

# Autokrigging sin tendencia:
Autok.Limo.ST <- autoKrige(log(Limo+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.Limo.ST)

# Autokrigging con tendencia
Autok.Limo.CT <- autoKrige(log(Limo+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.Limo.CT)


### PREPARACIÓN KRIGGING MANUAL CONTENIDO EN LIMO ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL CONTENIDO EN LIMO ###
Limo.mapa <- krige(log(Limo+1) ~  1, suelo2, pts1, v.fitLimosteST)


plot(Limo.mapa, main= "CONTENIDO EN LIMO") #En el intercomillado va el título.

################################################################################
################################################################################

#_____________________________MAPITA DE CONTENIDO EN ARCILLAS ___________________________#

### AUTOKRIGGING CONTENIDO EN ARCILLAS ###

# Autokrigging sin tendencia:
Autok.Arcilla.ST <- autoKrige(log(Arcilla+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.Arcilla.ST)

# Autokrigging con tendencia
Autok.Arcilla.CT <- autoKrige(log(Arcilla+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.Arcilla.CT)


### PREPARACIÓN KRIGGING MANUAL CONTENIDO EN ARCILLAS ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL CONTENIDO EN ARCILLAS ###
Arcilla.mapa <- krige(log(Arcilla+1) ~  Xlocal, suelo2, pts1, v.fitArcillalinCT)


plot(Arcilla.mapa, main= "CONTENIDO EN ARCILLAS") #En el intercomillado va el título.

################################################################################
################################################################################


#_____________________________MAPITA DE FÓSFORO ___________________________#

### AUTOKRIGGING FÓSFORO ###

# Autokrigging sin tendencia:
Autok.P.ST <- autoKrige(log(P+1) ~ 1, suelo2, pts1 )
#Visualizamos como queda sin tendencia:
plot(Autok.P.ST)

# Autokrigging con tendencia
Autok.P.CT <- autoKrige(log(P+1) ~ Xlocal, suelo2, new_data=pts1 )
#Visualizamos como queda con tendencia:
plot(Autok.P.CT)


### PREPARACIÓN KRIGGING MANUAL FÓSFORO ###

# Como hemos dicho anteriormente, antes de realizar el krigging manual necesitamos
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


### REALIZACIÓN KRIGGING MANUAL FÓSFORO ###
P.mapa <- krige(log(P+1) ~  Xlocal, suelo2, pts1, v.fitPgauCT)


plot(P.mapa, main= "FÓSFORO") #En el intercomillado va el título.

################################################################################
################################################################################

