#install.packages(c('ggplot2','readr','caret'))
library(readr)
dataset <- cereal
# Split the data into training and test set
set.seed(26)
train_indices <- sample(1:nrow(dataset),0.75*nrow(dataset))
training_set  <- dataset[train_indices, ]
test_set <- dataset[-train_indices,]
y_actual <- test_set$rating
test_set$rating=NULL
attach(training_set)

# Trying out different models wherein Rating is the response

#Model-1 => y = ax + b
univ.linear.model <- lm(training_set$rating~calories, data = training_set)

#Model-2 => y = ax^2 + bx + c
quadratic.model <- lm(training_set$rating~poly(calories,2), data = training_set)

#Model-3 => y = ax^3 + bx^2 + cx + d
cubic.model <- lm(training_set$rating~poly(calories,3), data = training_set)

#Model-4 => y = ax_1  + b(x_2*x_3) + c
interaction.terms.model <- lm(training_set$rating~calories+calories:sugars, data = training_set)

#Model-5 => y = ax_1 + bx_2 + cx_3 ... kx_n + l 
multiple.linear.model <- lm(training_set$rating~calories+sugars+fat+protein+fiber+carbo+sodium+potass, data = training_set)
summary(univ.linear.model)
# Make predictions using trained models on test set and computing the R2, RMSE and MAE
predictions1 <- predict(univ.linear.model,test_set)
predictions2 <- predict(quadratic.model,test_set)
predictions3 <- predict(cubic.model,test_set)
predictions4 <- predict(interaction.terms.model,test_set)
predictions5 <- predict(multiple.linear.model,test_set)
library(caret)
# Calculating metrics to judge model performance
data.frame( R2 = R2(predictions1, y_actual),
            RMSE = RMSE(predictions1, y_actual),
            MAE = MAE(predictions1, y_actual))


## Results using 10-fold cross validation ##

# Define training control as 10-fold cross-validation
set.seed(26) 
train.control <- trainControl(method = "cv", number = 10)
# Training the models
model.cv.1 <- train(rating~ calories , data = dataset, method = "lm",
               trControl = train.control)
model.cv.2 <- train(rating~ poly(calories,2) , data = dataset, method = "lm",
                    trControl = train.control)
model.cv.3 <- train(rating~ poly(calories,3) , data = dataset, method = "lm",
                    trControl = train.control)
model.cv.4 <- train(rating~ calories:sugars , data = dataset, method = "lm",
                    trControl = train.control)
model.cv.5 <- train(rating~calories+sugars+fat+protein+fiber+carbo+sodium+potass, data = dataset, method = "lm",
                    trControl = train.control)

# Summarize the results
print(model.cv.1)

## Extra--
# Visualizing how ratings vary with features it is most correlated with...
corr.matrix  <- as.data.frame(cor(dataset))# Sugars and Calories seem to have the highest correlations

#Plotting a graph which depicts that Cereals having lower Calories & Sugar content usually achieve higher ratings
library(ggplot2)
cal=dataset$calories
sug=dataset$sugars
rating=dataset$rating
ggplot(data=cereal,aes(x=sug,y=cal,col=rating))+
  geom_jitter(data=cereal,aes(sug,cal,col=rating))+
  labs(x="Sugar",y="Calories")+
  geom_smooth(method="lm",se=FALSE,col='black')+
  theme_bw()
