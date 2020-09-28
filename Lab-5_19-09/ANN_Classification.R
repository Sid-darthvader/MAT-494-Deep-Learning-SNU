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
y <- dataset$is_canceled
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
                       algorithm = "rprop+" , err.fct = "sse" ,act.fct = "logistic",lifesign="minimal")
plot(model.NN1,intercept = FALSE ,show.weights = FALSE )

# NN with 2 hidden layers containing 1000 neurons each 
model.NN2 <- neuralnet(y_train~.,NN_train,hidden= c(1000,1000),linear.output = FALSE,
                       algorithm = "rprop+" , err.fct = "sse" ,
                       act.fct = c("sigmoid","sigmoid"),lifesign="minimal")



