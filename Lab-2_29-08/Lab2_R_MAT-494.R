#install.packages(c('ggplot2','readr','caret'))
library(readr)
dataset <- Winequality_red
# Assigning labels to the response variable based on domain knowledge 
dataset$quality <- as.factor(ifelse(dataset$quality>6.5,"Good","Bad"))

# Split the data into training and test set
set.seed(26)
train_indices <- sample(1:nrow(dataset),0.80*nrow(dataset))
training_set  <- dataset[train_indices, ]
test_set <- dataset[-train_indices,]
y_actual <- test_set$quality
test_set$quality=NULL
attach(training_set)

# Checking Distribution of Classes amongst observations
library(ggplot2)
ggplot(data = training_set, aes(x=quality,fill=quality))+
  geom_bar(stat = "count",width = 0.2)+
  ggtitle("Distribution of Bad v/s Good Red Wines")+
  xlab("Wine Quality")+
  ylab("Frequency")
  theme_minimal()

set.seed(26) 
library(caret)
train.control <- trainControl(method = "cv", number = 10)# 10-fold Cross Validation

install.packages("corrplot")
library(corrplot)
corr_matrix <- cor(training_set[,1:11])
corrplot(corr_matrix)# To observe correlations amongst features and decide which interaction terms to include in your model
#1) fixed acidity:citric acid ; fixed acidity:density ; fixed acidity:pH
#2) free sulfur dioxide: total sulfur dioxide;

# Model formulas to be used during training procedures
formula1 <- quality~`fixed acidity`+`volatile acidity`+`citric acid`+`residual sugar`+
  chlorides+`free sulfur dioxide`+`total sulfur dioxide`+density+pH+sulphates+
  alcohol
formula2 <- quality~`fixed acidity`+`volatile acidity`+`fixed acidity`:`citric acid`+
  +`citric acid`+`residual sugar`+ chlorides+`free sulfur dioxide`+`total sulfur dioxide`+
  `free sulfur dioxide`:`total sulfur dioxide`+density+pH+sulphates+ alcohol

formula_nb <- quality~`fixed acidity`+`volatile acidity`+`residual sugar`+
  chlorides+`free sulfur dioxide`+sulphates+
  alcohol

### Logistic Regression Classifiers  ###
# Replace with LDA/QDA for Multi-Class problems

model.cv.lr1 <- train(formula1 , data = training_set, method = "glm",
                    trControl = train.control,tuneLength=10)
print(model.cv.lr1)

model.cv.lr2 <- train(formula2 , data = training_set, method = "glm",
                      trControl = train.control,tuneLength=10)
print(model.cv.lr2)

summary(model.cv.lr2)

### kNN Classifiers  ###
model.cv.knn1 <- train(formula1 , data = training_set, method = "knn",
                      trControl = train.control,tuneLength=10)
print(model.cv.knn1)

model.cv.knn2 <- train(formula2 , data = training_set, method = "knn",
                      trControl = train.control,tuneLength=10)
print(model.cv.knn2)

### Naive Bayes Classifiers  ###
model.cv.nb1 <- train(formula1 , data = training_set, method = "naive_bayes",
                       trControl = train.control,tuneLength=10)
print(model.cv.nb1)

model.cv.nb2 <- train(formula_nb , data = training_set, method = "naive_bayes",
                       trControl = train.control,tuneLength=10)
print(model.cv.knn2)


### Support Vector Classifiers  ###
model.cv.svmLinear <- train(formula1 , data = training_set, method = "svmLinear",
                      trControl = train.control,tuneLength=10)
print(model.cv.svmLinear)

model.cv.svmPoly <- train(formula1 , data = training_set, method = "svmPoly",
                       trControl = train.control)
print(model.cv.svmPoly)

model.cv.svmRBF <- train(formula1 , data = training_set, method = "svmRadial",
                          trControl = train.control)
print(model.cv.svmRBF)



### Tree Based Classifiers  ###
#1) Decision Tree Classifier
#model.cv.dt <- train(formula1 , data = training_set, method = "rpart",
            #        trControl = train.control,tuneLength=10)
#print(model.cv.dt)

#2) Random Forest Classifier
model.cv.RF <- train(formula1 , data = training_set, method = "rf",
                            trControl = train.control,tuneLength=10)
print(model.cv.RF)

#3) XGBoost Classifier
model.cv.XGBoost <- train(formula1 , data = training_set, method = "xgbTree",
                     trControl = train.control)
print(model.cv.XGBoost)

#Function to Test the performance of all our models on Unseen Test data.
test_classifier_performance <- function(model){
  predictions <- predict(model,test_set)
  print(confusionMatrix(data = predictions, reference = y_actual))
  print(confusionMatrix(data = predictions, reference = y_actual,mode = "prec_recall"))
}

test_classifier_performance(model.cv.lr1)
