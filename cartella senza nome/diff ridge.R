## SEE difference between lm coefficients and ridge coefficients
require(readr)
require(stringr)
require(MASS)
require(ggplot2)
require(PerformanceAnalytics)
require(corrplot)
library(VIM)
library(tidyverse)
require(gridExtra)
library(MASS)
library(DAAG)

################### Set wd


# Import the file 
car <- read.csv("car.csv")
car <- car[car$Kilometer != 2000.000, ]

# Transform into factors
car$Make <- as.factor(car$Make)
car$`Fuel.Type`<- as.factor(car$`Fuel.Type`)
car$Transmission <- as.factor(car$Transmission)
car$Owner <- as.factor(car$Owner)
car$`Seller.Type`<- as.factor(car$`Seller.Type`)
car$Drivetrain <- as.factor(car$Drivetrain)
car$SeatingCapacity <- as.factor(car$SeatingCapacity)

colnames(car)[5] <- "Fuel.Type"
# Split into train and test
set.seed(1)
index <- sample(nrow(car)*0.8, rep=F)
train <- car[index, ]
test <- car[-index, ]


# Fitto un modello lineare completo (regresso log(Price) su tutto)

fit1 <- lm(log(Price)~ ., data = train)
summary(fit1)
vif(fit1)     # some vif (toruqe, power, lenght are way above 10)
AIC(fit1)

# Buon modello: R2-adjust alto, low standard error and p-value for the F-statistics approximately 0

# Fit a ridge regression on the same full model in CV
# select lambda by GCV in the model with logLDC
set.seed(1)
grid.ridge<-lm.ridge(log(Price) ~ . ,lambda=seq(0.1,10,0.001), data=train)

lambda_selected<-grid.ridge$lambda[which(grid.ridge$GCV==min(grid.ridge$GCV))]

lm_ridge_GCV <- lm.ridge(log(Price) ~ ., lambda=lambda_selected, data=train)

# See difference between coeff
c1 <- round(fit1$coefficients, 4)
c2 <- round(coef(lm_ridge_GCV), 4)
dif <- round(abs(c1-c2), 4)
mean(dif)

View(cbind(c1, c2, dif))



# Fit a reduced model

fit2 <- lm(log(Price) ~Make+Year+Kilometer+Fuel.Type+Transmission+
                     Owner+Power+Length+Width+Height+SeatingCapacity+TankCapacity, data=train)
summary(fit2)    # questo è il modello che prenderei come modello finale 
AIC(fit2)
vif(fit2)       # tutti i vif stanno sotto al dieci

# Proviamo a fre ridge su questo (dovrebbe camabiare anche meno ripetto a prima)
grid.ridge1<-lm.ridge(log(Price) ~ Make+Year+Kilometer+Fuel.Type+Transmission+
                       Owner+Power+Length+Width+Height+SeatingCapacity+TankCapacity ,lambda=seq(0.1,10,0.001), data=train)

lambda_selected1<-grid.ridge$lambda[which(grid.ridge$GCV==min(grid.ridge$GCV))]

lm_ridge_GCV1 <- lm.ridge(log(Price) ~ Make+Year+Kilometer+Fuel.Type+Transmission+
                           Owner+Power+Length+Width+Height+SeatingCapacity+TankCapacity, lambda=lambda_selected, data=train)


# See difference
c11 <- round(fit2$coefficients, 4)
c22 <- round(coef(lm_ridge_GCV1), 4)
dif1 <- round(abs(c11-c22), 4)
mean(dif)

View(cbind(c11, c22, dif1))
