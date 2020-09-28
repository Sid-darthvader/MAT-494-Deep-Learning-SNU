## We try to predict ADR (i.e the Hotel Room Price) using ANNs

install.packages('neuralnet')
library(ggplot2)
dataset <- hotel_bookings
attach(dataset)

# Treat NA Values
dataset<-na.omit(dataset) 

# Dimensionality Reduction through Feature Engineering
dataset$guests <-  dataset$adults + dataset$children + dataset$babies
dataset$stay_total <- dataset$stays_in_week_nights + dataset$stays_in_weekend_nights
dataset$different_room_alloted <-  ifelse(dataset$reserved_room_type!=dataset$assigned_room_type,1,0)
y <- dataset$adr
dataset$is_canceled = NULL
dataset$arrival_date_year = NULL
library(dplyr)
dataset<- dataset %>% select(!c(adults,children,babies,stays_in_week_nights,stays_in_weekend_nights
                                ,reserved_room_type,assigned_room_type))
X <- dataset

# One-Hot Encode all the categorical features
str(X)
library(caret)
dmy <- dummyVars(" ~ .", data = X)
X_encoded <- data.frame(predict(dmy, newdata = dataset))


# Scale dataset for NN
min_max_scaler <- function(x){
  return((x- min(x)) /(max(x)-min(x)))
}
X_scaled <- min_max_scaler(X_encoded)

# Split into train and test set
set.seed(26)
train_indices = sample(1:nrow(X_encoded),0.8*nrow(X_scaled))
X_train = X_scaled[train_indices,]
X_test = X_scaled[-train_indices,]
y_train = y[train_indices]
y_test = y[-train_indices]
length(y_train)

# Build NN
NN_train <- cbind(X_train,y_train)
library(neuralnet)
# Single Layer NN with 100 neurons in the hidden layer
model.NN1 <- neuralnet(y_train~.,NN_train,hidden= c(100),linear.output = FALSE,
                       algorithm = "rprop+" , err.fct = "sse" ,
                       act.fct = "logistic",lifesign="full",rep=10)# You can specify Learning rate only when using Backprop

# NN with 2 hidden layers containing 1000 neurons each 
model.NN2 <- neuralnet(y_train~.,NN_train,hidden= c(1000,1000),linear.output = FALSE,
                       algorithm = "rprop+" , err.fct = "sse" ,
                       act.fct = c("logistic","logistic"),lifesign="full",rep=10)# You can specify Learning rate only when using Backprop

# Visualize NN Architecture
plot(model.NN1,intercept = FALSE ,show.weights = FALSE )
plot(model.NN2,intercept = FALSE ,show.weights = FALSE )
# Evaluate Performance on Unseen Data

##Function to Test the performance of our NN models on Unseen Test data.
test_regressor_performance <- function(model){
  predicted_val <- compute(model.NN1,X_test)
  library(caret)
  mse = MSE(predicted_val, y_test)
  mae = MAE(predicted_val, y_test)
  rmse = RMSE(predicted_val, y_test)
  r2 = R2(predicted_val, original, form = "traditional")
  print(" MAE:", mae, "\n", "MSE:", mse, "\n", 
      "RMSE:", rmse, "\n", "R-squared:", r2)
  }

test_regressor_performance(model.NN1)
test_regressor_performance(model.NN2)


