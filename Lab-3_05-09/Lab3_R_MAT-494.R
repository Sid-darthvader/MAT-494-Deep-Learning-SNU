#install.packages(c('ggplot2','readr','caret','neuralnet'))
library(readr)
dataset <- winequality_white

# Explore the distribution of Wine Quality ratings to come up with meaningful discretization thresholds
library(ggplot2)
ggplot(data = winequality_white, aes(x=quality,fill=factor(quality)))+
  geom_bar(stat = "count",width = 0.4)+
  ggtitle("Distribution of White Wine Ratings")+
  xlab("Wine Quality/Ratings")+
  ylab("Frequency")+
theme_minimal()

# Dividing Quality into 3-Classes and converting it into a categorical variable
dataset$quality <- as.factor(cut(dataset$quality, 
                   breaks=c(0,5.99,6,10), 
                   labels=c("Bad","Average","Good")))

# Split the data into training and test set
set.seed(26)
train_indices <- sample(1:nrow(dataset),0.80*nrow(dataset))
training_set  <- dataset[train_indices, ]
test_set <- dataset[-train_indices,]
y_actual <- test_set$quality
test_set$quality=NULL
attach(training_set)

# Checking Distribution of Classes amongst training observations
library(ggplot2)
ggplot(data = training_set, aes(x=quality,fill=quality))+
  geom_bar(stat = "count",width = 0.4)+
  ggtitle("Quality/Rating distribution of White Wines")+
  xlab("Wine Quality/Rating")+
  ylab("Frequency")+
theme_minimal()

set.seed(26) 
library(caret)
train.control <- trainControl(method = "cv", number = 10)# 10-fold Cross Validation

#install.packages("corrplot")
library(corrplot)
corr_matrix <- cor(training_set[,1:11])
corrplot(corr_matrix)# To observe correlations amongst features and decide which interaction terms to include in your model

# Model formulas to be used during training procedures
formula1 <- quality~`fixed acidity`+`volatile acidity`+`citric acid`+`residual sugar`+
  chlorides+`free sulfur dioxide`+`total sulfur dioxide`+density+pH+sulphates+
  alcohol

formula_nb <- quality~`fixed acidity`+`volatile acidity`+`residual sugar`+
  chlorides+`free sulfur dioxide`+sulphates+
  alcohol

### Logistic Regression Classifiers  ###
# Replace with LDA/QDA for Multi-Class problems

model.cv.lda <- train(formula1 , data = training_set, method = "lda",
                      trControl = train.control,tuneLength=10)
print(model.cv.lda)

### kNN Classifiers  ###
model.cv.knn <- train(formula1 , data = training_set, method = "knn",
                       trControl = train.control,tuneLength=10)
print(model.cv.knn)

### Naive Bayes Classifiers  ###
## Naive Bayes considering all the features
model.cv.nb1 <- train(formula1 , data = training_set, method = "naive_bayes",
                      trControl = train.control,tuneLength=10)
print(model.cv.nb1)

## Naive Bayes after removing dependent features
model.cv.nb2 <- train(formula_nb , data = training_set, method = "naive_bayes",
                      trControl = train.control,tuneLength=10)
print(model.cv.nb2)


### Support Vector Classifiers  ###
model.cv.svmLinear <- train(formula1 , data = training_set, method = "svmLinear",
                            trControl = train.control,tuneLength=10)
print(model.cv.svmLinear)

# WARNING!!!! THIS MODEL WILL TAKE A LONG TIME TO TRAIN.
model.cv.svmPoly <- train(formula1 , data = training_set, method = "svmPoly",
                          trControl = train.control)
print(model.cv.svmPoly)

model.cv.svmRBF <- train(formula1 , data = training_set, method = "svmRadial",
                         trControl = train.control)
print(model.cv.svmRBF)#0.614



### Tree Based Classifiers  ###
#1) Decision Tree Classifier
#model.cv.dt <- train(formula1 , data = training_set, method = "rpart",
#        trControl = train.control,tuneLength=10)
#print(model.cv.dt)

#2) Random Forest Classifier

# WARNING!!!! THIS MODEL WILL TAKE A LONG TIME TO TRAIN.
model.cv.RF <- train(formula1 , data = training_set, method = "rf",
                     trControl = train.control,tuneLength=10)
print(model.cv.RF)#0.7164

#3) XGBoost Classifier

# WARNING!!!! THIS MODEL WILL TAKE A LONG TIME TO TRAIN.
model.cv.XGBoost <- train(formula1 , data = training_set, method = "xgbTree",
                          trControl = train.control)
print(model.cv.XGBoost)


#Function to Test the performance of all our models on Unseen Test data.
test_classifier_performance <- function(model){
  predictions <- predict(model,test_set)
  print(confusionMatrix(data = predictions, reference = y_actual))
  print(confusionMatrix(data = predictions, reference = y_actual,mode = "prec_recall"))
}

test_classifier_performance(model.cv.nb2)

## Bonus: Neural Network (Best Network config chosen from 10^6 different networks)

model.cv.NN <- train(formula1 , data = training_set, method = "nnet",
                     trControl = train.control,tuneLength=10)
print(model.cv.NN)#Size describes the number of nodes that will be used in the hidden layer
# Weights are multiplied with a number<1 to prevent them from going too large and is termed as 'Decay'
test_classifier_performance(model.cv.NN)
plot(model.cv.NN)

