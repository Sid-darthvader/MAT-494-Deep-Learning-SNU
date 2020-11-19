#We build a model to predict the total number of deaths from bronchitis,
#emphysema and asthma in the United Kingdom

#install.packages("tseries","quantmod")
library(tseries)
library(quantmod)

data("UKLungDeaths",package = "datasets")# Monthly ts from 1974 to 1979
par(mfrow =c(3,1))
plot(ldeaths, xlab = " Year ",ylab = " Both sexes ",main = " Total ")
plot(mdeaths , xlab = "Year" ,ylab = " Males ",main = " Males")
plot(fdeaths , xlab ="Year",ylab = " Females ",main="Females")
y <-as.ts(ldeaths)
y <-log(y)# Normalize the data to stabilize values
y <- as.ts(scale(y)) # Scale the dataset before plugging inside Neural Network
y <-as.zoo(y)

###### Model-1 (Including lags of past 12 months) ######

x1=Lag (y , k = 1)
x2=Lag (y , k = 2)
x3=Lag (y , k = 3)
x4=Lag (y , k = 4)
x5=Lag (y , k = 5)
x6=Lag (y , k = 6)
x7=Lag (y , k = 7)
x8=Lag (y , k = 8)
x9=Lag (y , k = 9)
x10=Lag (y , k = 10)
x11=Lag (y , k = 11)
x12=Lag (y , k = 12)
deaths <- cbind( x1 , x2 , x3,
                 x4 , x5 , x6 ,
                 x7 , x8 , x9 ,
                 x10 , x11 , x12 )
deaths <- cbind (y,deaths)
head(round(deaths,2),14)
deaths <- deaths[-(1:12),]
head(round(deaths,2),6)# First 7 values contain NA so they need to be removed

n = nrow(deaths)
n_train<-45
train = 1:45
test = 46:60
#train <- sample(1: n , n_train , FALSE )
#test = -train
inputs <- deaths[,2:13]
outputs <- deaths[,1]

library(RSNNS)
fit1 <- elman(inputs[train],outputs[train],size =c(1,1),
               learnFuncParams =c (0.1),maxit =1000)
fit2 <- jordan(inputs[train], outputs[train],size =c(1),learnFuncParams =c (0.1),maxit=1000)
par(mfrow =c (1,1) )
plotIterativeError(fit1)
summary(fit1)
pred <- predict(fit1, inputs[test])
library(caret)
R2(outputs[test],pred)

