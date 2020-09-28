"
The original study collected data from 117 healthy German
subjects, 46 men and 71 women. The bodyfat data frame
contains the data collected on 10 variables for the 71 women.
"


install.packages(c("grnn","TH.data"))
library(grnn)
library(caret)
#data("bodyfat",package="TH.data")
#dataset <- bodyfat

# Treat NA Values
dataset<-na.omit(dataset)

# Visualize distributions
library(ggplot2)
# Histogram with density plot
ggplot(dataset, aes(x=dataset$DEXfat)) + 
  geom_histogram(bins=10,aes(y=..density..), colour="black", fill="yellow")+
  geom_density(alpha=.5, fill="red") 

# Dimensionality Reduction through Feature Engineering

# One-Hot Encode all the categorical features


# Scale dataset for NN
y = dataset$DEXfat
X = dataset 
X$DEXfat=NULL

#Min-Max Scalar
min_max_scaler <- function(x){
  return((x- min(x)) /(max(x)-min(x)))
}

#Log Scalar
log_scaler <- function(x){
  return(log(x))
  }
#X_scaled <- log_scaler(X)
X_scaled <- X
n <- nrow(dataset)

n_train <- 45
set.seed(465)
train <- sample(1:n ,n_train ,FALSE)
test = -train

training_set = dataset[train,]
test_set = dataset[test,]
#write.csv(training_set,"BodyFat_Train.csv")
#write.csv(test_set,"BodyFat_Test.csv")
test_set$DEXfat=NULL

model.lm = lm(training_set$DEXfat~.,data = training_set)
summary(model.lm)
predictions.lm = predict(model.lm,test_set)
R2(predictions.lm,y[test])
MAE(predictions.lm,y[test])

"Sigma determines the spread/ shape of the distribution.
It is known as the smoothing factor.
You can interpret the smoothing parameter as follows...
Suppose we had a single input, the greater the value of smooth-
ing factor, the more significant distant training cases become
for the predicted value. The larger the smoothing value the
smoother the function is, and in the limit it becomes a multi-
variate Gaussian. Smaller values of the smoothing parameter
allow the estimated density to assume non-Gaussian shapes.
"

# Creating a grid of sigma values to choose from
sigma = seq(0.5,15.4, by = 0.1)

grnn_model_arr = 1:150
model_r2_score = rep(0,150)



for(j in 1:150){
 fit_basic1 <- learn(data.frame(y[train],X_scaled[train,]))
 given_sigma = sigma[j]
 grnn_model <- smooth(fit_basic1, sigma = given_sigma)

 n_test <- nrow(X_scaled[test,])
 pred <- 1:n_test

  for(i in 1:n_test){
    pred[i] <- guess(grnn_model, as.matrix(X_scaled[-train,][i,]))
  }
 predicted_val = pred
 y_test = y[-train]
 library(caret)
 r2= R2(predicted_val, y_test, form = "traditional")
 model_r2_score[j] = r2
}

best_model_index <- which.max(model_r2_score)
best_sigma <- sigma[best_model_index]
best_r2_score <- max(model_r2_score)

model_results <- as.data.frame(cbind(sigma,model_r2_score))

library(ggplot2)
ggplot(model_results, aes(x=model_results$sigma, y=model_results$model_r2_score)) +
  geom_line(color = "#00AFBB", size = 2)+
  geom_vline(xintercept=best_sigma)+
  xlab("Sigma(Smoothing Parameter)") +
  theme_minimal() +
  ylab("R2 Score")+
  scale_x_continuous(n.breaks = 50)+
  ylim(0,1)
