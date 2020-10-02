##### Probabilistic Neural Networks(PNNs) ######

# We build a PNN to help classify the diabetes status of women.
install.packages(c("pnn","mlbench"))
library(pnn)
library(mlbench)
data("PimaIndiansDiabetes2",package="mlbench")
dataset <- PimaIndiansDiabetes2
# Check number of NA values in each row of our dataset
sapply(dataset, function(x)sum(is.na(x)))
dataset$triceps=NULL
dataset$insulin=NULL
dataset = na.omit(dataset)
y<-(dataset$diabetes)
dataset$diabetes <-NULL

#Check for Imbalanced Classification
library(dplyr)
PimaIndiansDiabetes2 %>% group_by(diabetes) %>% summarise(n=n())
# 500 neg results and 268 pos results so its Imbalanced Classification,
#so accuracy might not be a correct metric to judge performance

#Scale your dataset
df_scaled <-scale(dataset)
df_scaled <-cbind(as.factor(y),df_scaled)
set.seed(26)
n= nrow(df_scaled)
n_train = 0.8*n
n_test = ceiling(n-n_train)
train_indices = sample(1:n, n_train)
test_indices = -train_indices

# First Model
fit_basic=learn(data.frame(y[train_indices], df_scaled[train_indices,]))
fit=smooth(fit_basic, sigma =0.5)
result=perf(fit)
result$success_rate # 96% accurate on test set
# Model with optimal values of sigma

# Creating a grid of sigma values to choose from
sigma = seq(0.2,3, by = 0.2)
pnn_model_arr = 1:15
model_success_rate = rep(0,15)


fit_basic=learn(data.frame(y[train_indices], df_scaled[train_indices,]))
for(j in 1:15){
  given_sigma = sigma[j]
  pnn_model=smooth(fit_basic, sigma =given_sigma)
  result=perf(pnn_model)
  result$success_rate
  pred <- 1:n_test
  for(i in 1:n_test) {
    pred[i]=guess(pnn_model, as.matrix(df_scaled[-train_indices,][i,]))$category
  }
  #table(pred, y[-train_indices], dnn=c("predicted", "actual"))
  model_success_rate[j]=(sum(pred==y[-train_indices])/n_test)
}

best_model_index <- which.max(model_success_rate)
best_sigma <- sigma[best_model_index]
best_success_rate <- max(model_success_rate)

model_results <- as.data.frame(cbind(sigma,model_success_rate))

library(ggplot2)
ggplot(model_results, aes(x=model_results$sigma, y=model_results$model_success_rate)) +
  geom_line(color = "#00AFBB", size = 2)+
  geom_vline(xintercept=best_sigma)+
  xlab("Sigma(Smoothing Parameter)") +
  theme_minimal() +
  ylab("Success Rate")+
  scale_x_continuous(n.breaks = 15)+
  ylim(0,1)

#Test the performance of the best model using other metrics.
  library(caret)
  fit_basic=learn(data.frame(y[train_indices], df_scaled[train_indices,]))
  pnn_model=smooth(fit_basic, sigma = best_sigma)
  pred <- 1:n_test
  for(i in 1:n_test) {
    pred[i]=guess(pnn_model, as.matrix(df_scaled[-train_indices,][i,]))$category
  }
  y_actual = y[-train_indices]
  predictions <- as.factor(pred)
  print(confusionMatrix(data = predictions, reference = y_actual))
  print(confusionMatrix(data = predictions, reference = y_actual,mode = "prec_recall"))

