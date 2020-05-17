
## Load the data #########################
suelo1 <- read.delim("data/Brea_suelos.txt", sep="\t", dec=",", header=T)
suelo2 <- read.delim("data/Orusco_suelos.txt", sep="\t", dec=",", header=T)

load("data/AerialRoot.community.corregido.Rdata")
###########################################

## Source some pieces of code: 
source("start/setup.R")
source("start/curatingdata.R") ## run only ONCE!
###########################

## loading packages: 
library(lattice)
library(sp)
library(gstat)
library(maptools)
library(spatstat)
library(raster)
library(automap)

##########################################################################################################################################################
coordinates(suelo2) <- ~ Xlocal + Ylocal   # convert data.frame object in SpatialPointsDataFrame object (package "sp")

class(suelo2) # show the class of the object. "SpatialPointsDataFrame"

## CREATE AN EMPTY POLYGON, OF THE SIZE OF THE PLOT, USING THE CORNERS
options(digits=10)
p1 <- Polygon(esquinas.parcela[,1:2]) #take the corners of the plot and returns an object of class "Polygon" (package "sp"). The function needs 2-column numeric matrix with coordinates.
ps1 <- Polygons(list(p1),1) #different function, now is "Polygons" returns an object of class "Polygons" (package "sp")
sps1 <- SpatialPolygons(list(ps1)) #convert the "polygons" object into an object of class  "SpatialPolygons" (package "sp")
class(sps1) # show the class of the object "SpatialPolygons"

## CREATE A GRID
### create a grid, remove points outside the window and convert it in a "spatial pixel dataframe"

grid = spsample(suelo2, type = "regular", cellsize = c(0.05, 0.05)) # create a grid of 0.05 x 0.05, using sample points locations within a square area.
pts1 <- as.data.frame(grid[!is.na(over(grid, sps1,))]) # remove points outside the window; This is a data frame object. 

names(pts1) <- c("Xlocal", "Ylocal") # change the names of X and Y
coordinates(pts1) <- c("Xlocal", "Ylocal") # creates a spatial object; SpatialPoints object, from coordinates

pts1 <- SpatialPixelsDataFrame(as(pts1, "SpatialPoints"), data=as(pts1, "data.frame"), tolerance=0.077) #and convert it into a "SpatialPixelsDataFrame"

plot(pts1)

## correction I think should be done to the script
# https://gis.stackexchange.com/questions/158021/plotting-map-resulted-from-kriging-in-r 

grid = spsample(suelo2, type = "regular", cellsize = c(0.05,0.05), proj4string = CRS("+proj=utm +ellps=WGS84 +datum=WGS84"))

# proj4string(suelo2) = CRS("+proj=utm +ellps=WGS84 +datum=WGS84")

##########################################################################
### FITTING A VARIOGRAM AND KRIGING

### (1) AUTOKRIGING 
# includes automatically also the function autofitVariogram
### GLUC
krGLUC1 <- autoKrige(log(GLUC+1) ~ 1, suelo2, pts1 ) ## without trend
krGLUC2 <- autoKrige(log(GLUC+1) ~ Xlocal, suelo2, new_data=pts1 ) ## with trend (as our case)
plot(krGLUC1)
plot(krGLUC2)

### (2) KRIGE - alternative function to autokrige

# before kriging you need to fit a variogram, you can do it manually (f(x) fitvariogram

## and setting the variables sill, range and nugget, but also by the function autofitVariogram

### as follows

# (2A)
# option A # we are creating an empty matrix where putting all results of possible models

SSErr.a <- matrix(NA,2,5)
colnames(SSErr.a) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(SSErr.a) <- c("Sin trend", "Con trend")

SSErr.a[1,1] <- autofitVariogram(log(GLUC) ~ 1, suelo2, model = c("Exp"))$sserr
SSErr.a[1,2] <- autofitVariogram(log(GLUC) ~ 1, suelo2, model = c("Sph"))$sserr
SSErr.a[1,3] <- autofitVariogram(log(GLUC)  ~ 1, suelo2, model = c("Gau"))$sserr
SSErr.a[1,4] <- autofitVariogram(log(GLUC)  ~ 1, suelo2, model = c("Lin"))$sserr
SSErr.a[1,5] <- autofitVariogram(log(GLUC)  ~ 1, suelo2, model = c("Ste"))$sserr

SSErr.a[2,1] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
SSErr.a[2,2] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
SSErr.a[2,3] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
SSErr.a[2,4] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Lin"))$sserr
SSErr.a[2,5] <- autofitVariogram(log(GLUC)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

which((SSErr.a) == min(SSErr.a), arr.ind=TRUE) ## sserr is the sum of squares, the minimum value corresponds to the best model

#(2B)
#option B: if you want you can directly use these functions and you will have the best model

GLUC1 <- variogram(log(GLUC) ~ 1, data=suelo2) # create a variogram, trend k (constant)
GLUC2 <- variogram(log(GLUC) ~ Xlocal, data=suelo2) # with a trend

v.fit1 = autofitVariogram(log(GLUC) ~ 1, suelo2, model = c("Ste"))$var_model # autofitting the model
v.fit2 = autofitVariogram(log(GLUC) ~ Xlocal, suelo2, model = c("Ste"))$var_model

plot(GLUC1, v.fit1)
plot(GLUC2, v.fit2)

### note: we indicated the model "Ste" but if you do not specify the type of model the function selects for you the best model (in this case "Ste")

#variogram1 <- autofitVariogram(log(GLUC)  ~ 1, suelo2) # sin trend
#plot(variogram1)
#variogram2 <- autofitVariogram(log(GLUC)  ~ Xlocal+Ylocal, suelo2)  # con trend
#plot(variogram2)


### now we apply the function krige
GLUC.tr1 <- krige(log(GLUC+1) ~  1, suelo2, pts1, v.fit1) # trend k

GLUC.tr2 <- krige(log(GLUC+1) ~  Xlocal, suelo2, pts1, v.fit2) # trend

plot(GLUC.tr1)
plot(GLUC.tr2, main= "Glucosidasa")

################################################################################
################################################################################




















### FOSF
#variogram1<-autofitVariogram(log(GLUC)  ~ 1, suelo2) # sin trend
#plot(variogram1)
#variogram2<-autofitVariogram(log(GLUC)  ~ Xlocal+Ylocal, suelo2)  # con trend
#plot(variogram2)

SSErr.b <- matrix(NA,2,5)
colnames(SSErr.b) <- c("Exponencial","Esferico","Gausiano","Lineal","Ste")
rownames(SSErr.b) <- c("Sin trend","Con trend")

SSErr.b[1,1]<-autofitVariogram(log(FOSF) ~ 1, suelo2,model = c("Sph"))$sserr
SSErr.b[1,2]<-autofitVariogram(log(FOSF) ~ 1, suelo2,model = c("Sph"))$sserr
SSErr.b[1,3]<-autofitVariogram(log(FOSF)  ~ 1, suelo2,model = c("Gau"))$sserr
SSErr.b[1,4]<-autofitVariogram(log(FOSF)  ~ 1, suelo2,model = c("Lin"))$sserr
SSErr.b[1,5]<-autofitVariogram(log(FOSF)  ~ 1, suelo2,model = c("Ste"))$sserr

SSErr.b[2,1]<-autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Exp"))$sserr
SSErr.b[2,2]<-autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Sph"))$sserr
SSErr.b[2,3]<-autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Gau"))$sserr
SSErr.b[2,4]<-autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Lin"))$sserr
SSErr.b[2,5]<-autofitVariogram(log(FOSF)  ~ Xlocal, suelo2,model = c("Ste"))$sserr

which((SSErr.b)==min(SSErr.b), arr.ind=TRUE) ## sserr is the sum of squares, the minimum value corresponds
# to the best model
SSErr.b
## the best model would be gaussian without trend with this approach, even if the Ste has similar
# value: 0.93 (or 0.94 with trend) compared with 0.90 of gaussian


FOSF1<-variogram(log(FOSF+1)~1, data=suelo2) # create a variogram, trend k (constant)
FOSF2<-variogram(log(FOSF+1)~Xlocal, data=suelo2) # with a trend
v.fit1 = autofitVariogram(log(FOSF+1) ~ 1, suelo2)$var_model# autofitting the model
v.fit2 = autofitVariogram(log(FOSF+1) ~ Xlocal, suelo2)$var_model
plot(FOSF1,v.fit1)
plot(FOSF2,v.fit2)
### autofit is giving us another model = Ste has the best (without trend better than with trend)
### now I try to use autofitvariogram giving it the gaussian model

v.fit_gaus1 = autofitVariogram(log(FOSF+1) ~ 1, suelo2, model = "Gau")$var_model
v.fit_gaus = autofitVariogram(log(FOSF+1) ~ Xlocal, suelo2, model = "Gau")$var_model
plot(FOSF2,v.fit_gaus)

## I adopt now the gaussian even if I think that the "Ste" would be similar
### now we apply the function krige

FOSF.tr1 <- krige(log(FOSF+1) ~  1 , suelo2,pts1,v.fit_gaus1) # trend k
FOSF.tr2 <- krige(log(FOSF+1) ~  Xlocal , suelo2,pts1,v.fit_gaus) # trend 
plot(FOSF.tr1,main= "Phosphatase")
plot(FOSF.tr2, main= "Phosphatase")

### NOW WE CAN REPEAT IT WITH THE "STE"
FOSF.tr1 <- krige(log(FOSF+1) ~  1 , suelo2,pts1,v.fit1) 
plot(FOSF.tr1,main= "Phosphatase" )

### EXTRA
v.fit = autofitVariogram(pH ~ 1, Vari2,model = c("Ste"))$var_model
v.fit2 = autofitVariogram(pH ~ x+y, Vari2,model = c("Ste"))$var_model
plot(vv,v.fit)
plot(vv,v.fit2)

#!!! IMPORTANT TO SEE LATER! Before doing this I reading in Tomislav et al. that when you do a regression
# kriging (it should be the same of universal), you have to do the variogram of residuals
# I do that e.g. Nitrogen
N.rsvar<-variogram(residuals(N~Xlocal+Ylocal), suelo2)
Nres<-residuals(N.lm)
varN<-variogram(N~Xlocal+Ylocal,suelo2)
N.rsvar<-variogram(Nres, suelo2) # is not working I don't know why
# see better later
