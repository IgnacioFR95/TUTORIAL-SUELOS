##1## glucosidase
hist(suelo2$GLUC) # NOT NORMAL
shapiro.test((suelo2$GLUC)) # not normal
qqnorm(suelo2$GLUC) # not normal
# You have to transform it before calculations
hist(log(suelo2$GLUC)) # much more better
shapiro.test(log(suelo2$GLUC)) # acceptable p-value 0.07
qqnorm(log(suelo2$GLUC)) # better

hist(suelo2$P) # NOT NORMAL
shapiro.test((suelo2$P)) # not normal
qqnorm(suelo2$P) # not normal
# You have to transform it before calculations
hist(log(suelo2$P) # much more better
shapiro.test(log(suelo2$P) # acceptable p-value 0.07
qqnorm(log(suelo2$P)) # better
