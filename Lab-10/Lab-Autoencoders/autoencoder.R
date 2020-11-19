#install.packages("autoencoder")
library(autoencoder)
#Predicting the age of abalone(marine sea-snails) from physical measurements.
#The age of abalone is determined by cutting the shell through the cone, staining it, and counting the number of rings through a microscope-- a boring and time-consuming task.
#Other measurements, which are easier to obtain, are used to predict the age.

################ Dataset Description #################

#Name / Data Type / Measurement Unit / Description
#-----------------------------
 # Sex / nominal / -- / M, F, and I (infant)
#Length / continuous / mm / Longest shell measurement
#Diameter / continuous / mm / perpendicular to length
#Height / continuous / mm / with meat in shell
#Whole weight / continuous / grams / whole abalone
#Shucked weight / continuous / grams / weight of meat
#Viscera weight / continuous / grams / gut weight (after bleeding)
#Shell weight / continuous / grams / after being dried
#Rings / integer / -- / +1.5 gives the age in years

#######################################################
data=read.csv('abalone.csv', header=TRUE)# data has already been scaled
summary(data)

data[data$height==0,]=NA

data=na.omit(data)

#####
# dummify the data
library(caret)
dmy <- dummyVars(" ~ .", data = data)
data_encoded <- data.frame(predict(dmy, newdata = data))
#####
summary(data)

# We transpose the data, convert it to a matrix and store the result in the R object data1
data1=as.matrix(t(data_encoded))

set.seed(26)
n=nrow(data)
train =sample(1:n,10, FALSE)
# output values are set equal to input values, i.e. x̂ = x in order to learn the identity function h(x) ≈ x
#After learning the weights W , each hidden neuron represents
#a certain feature of the input data. Thus, the hidden layer
#h(x) can be considered as a new feature representation of the
#input data. The hidden representation h(x) is then used to
#reconstruct an approximation x̂ of the input using the decoder
#function g(x̂).


# A linear autoencoder can learn the Eigenvectors of the data equivalent to 
#applying PCA to the inputs. A nonlinear autoencoder is capable of discovering more complex,
#multi-modal structure in the data. In certain situations, a nonlinear autoencoder 
#can even outperform PCA for certain dimensionality reduction tasks

#fit a model with 5 hidden nodes and a sparsity parameter of 7%.
fit=autoencode(X.train = data1[,train],#
                  X.test = NULL,
                  nl = 3,
                  N.hidden = 7,
                  unit.type = "logistic",
                  lambda = 1e-5,
                  beta = 1e-5,
                  rho = 0.07,
                  epsilon =0.1,
                  max.iterations = 100,
                  optim.method = c("BFGS"),
                  rel.tol=0.01,
                  rescale.flag = TRUE,
                  rescaling.offset = 0.001)

fit$mean.error.training.set
features =predict(fit,X.input = data1[,train],hidden.output =TRUE)
features$X.output

pred=predict(fit , X.input = data1 [,train], hidden.output=FALSE)
pred$X.output[,1]# Autoencoder Reconstructed Values
data1[,1] # Original Values
