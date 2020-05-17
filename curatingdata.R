###############################
##### (1) curating Brea de Tajo
###############################

# change suelo1 names to match suelo2 names
names(suelo2)
names(suelo1) = c("code_sample", "X_GPS", "Y_GPS", "P", "Arena", "Limo", "Arcilla", "Amonio", "Nitrato", "SOC", "FOSF", "GLUC",
           "K", "pH", "COND", "x.r", "y.r", "N","S", "C", "H",                              "x0","y0","xrt","yrt")


## TO DO llamarlo Xlocal y Ylocal y NO TRANSFORMAR!!!!!!!!!!!!
  
suelo1$X <- as.numeric(as.character(suelo1$X_GPS))-min(as.numeric(as.character(suelo1$X_GPS)))
suelo1$Y <- as.numeric(as.character(suelo1$Y_GPS))-min(as.numeric(as.character(suelo1$Y_GPS)))

# for now...remove other coordinates not needed right now
suelo1[,c("x.r", "y.r", "x0","y0","xrt","yrt", "H")] <- NULL

# reorder the columns

suelo1 <- suelo1[c(1,2,3,19,20,12,11,16,17,4,13,18,14,15,5,6,7,8,9,10)]

############################################
##### (2) curating Orusco de tajuna (suelo2)
############################################
colnames(suelo2)[11] <- "code_sample"
suelo2$code_sample
orusco.soil <- suelo2
suelo2$Fecha <- NULL  # remove the dates, we don't need them.

############################################
##### (3) esquinas.parcela orusco
############################################
#orusco.corners <- data.frame(X=c(NA, NA, NA, NA), Y=c(NA, NA, NA, NA))
#orusco.corners$X <- esquinas.parcela$Xlocal-min(esquinas.parcela$Xlocal)
#orusco.corners$Y <- esquinas.parcela$Ylocal-min(esquinas.parcela$Ylocal)
#orusco.corners
#esquinas.parcela
