#install.packages(c('ggplot2','readr','caret'))
install.packages("keras")
#install.packages("tensorflow")
library(keras)
install_keras()
#install_keras(tensorflow = "gpu") #Note that you should only do this if your workstation has an NVIDIA GPU and
#required software (CUDA and cuDNN)

dataset <- winequality_white
library(ggplot2)
ggplot(data = winequality_white, aes(x=quality,fill=factor(quality)))+
  geom_bar(stat = "count",width = 0.4)+
  ggtitle("Distribution of White Wine Ratings")+
  xlab("Wine Quality/Ratings")+
  ylab("Frequency")+
  theme_minimal()

# Dividing Quality into 3-Classes and converting it into a categorical variable
dataset$quality <- cut(dataset$quality, 
                                 breaks=c(0,5.99,6,10), 
                                 labels=c("1","2","3"))

dataset$quality <- as.numeric(dataset$quality)
str(dataset)
# Updated Distribution
ggplot(data = dataset, aes(x=quality,fill=quality))+
  geom_bar(stat = "count",width = 0.4)+
  ggtitle("Quality/Rating distribution of White Wines")+
  xlab("Wine Quality/Rating")+
  ylab("Frequency")+
  theme_minimal()

dataset <- as.matrix(dataset)
# Normalize the `iris` data
df_scaled <- normalize(as.matrix(dataset[,1:11]))

# Determine sample size
ind <- sample(2, nrow(df_scaled), replace=TRUE, prob=c(0.67, 0.33))

# Split the `iris` data
keras.training <- df_scaled[ind==1, 1:11]
keras.test <- df_scaled[ind==2, 1:11]

# Split the class attribute
keras.trainingtarget <- dataset[ind==1, 12]
keras.testtarget <- dataset[ind==2, 12]

# One hot encode training target values
keras.trainLabels <- to_categorical(keras.trainingtarget)

# One hot encode test target values
keras.testLabels <- to_categorical(keras.testtarget)

# Print out the iris.testLabels to double check the result
print(keras.testLabels)





# Initialize a sequential model
model.nn1 <- keras_model_sequential() 

# Add layers to the model
model.nn1 %>% 
  layer_dense(units = 8, activation = 'relu', input_shape = c(11)) %>% # 1st Hidden Layer
  layer_dense(units = 3, activation = 'softmax')# Output Layer

# Print a summary of a model
summary(model.nn1)

# Get model configuration
get_config(model.nn1)

# Get layer configuration
get_layer(model.nn1, index = 1)

# List the model's layers
model.nn1$layers

# List the input tensors
model.nn1$inputs

# List the output tensors
model.nn1$outputs


# Compile the model
model.nn1 %>% compile(loss ='categorical_crossentropy',optimizer='adam',metrics='accuracy')

library(keras)
library(tensorflow)
install_tensorflow()

library("tensorflow")
tensorflow::use_condaenv("r-tensorflow")

# Fit the model 
model.nn1 %>% fit(keras.training,keras.trainLabels, 
  epochs = 200,   batch_size = 5, validation_split = 0.2)
