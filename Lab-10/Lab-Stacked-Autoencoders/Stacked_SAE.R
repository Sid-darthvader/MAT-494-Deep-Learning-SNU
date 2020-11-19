library(SAENET)
data=read.csv('abalone.csv', header=TRUE)
summary(data)

data[data$height==0,]=NA

data=na.omit(data)

data$sex=NULL

summary(data)

data1=as.matrix(t(data))

set.seed (26)
n=nrow(data)
train =sample (1:n, 10, FALSE )

fit=SAENET.train(X.train = data1[,train],
                  n.nodes=c(5,4,2),
                  unit.type="logistic",
                  lambda = 1e-5,
                  beta = 1e-5,
                  rho = 0.07,
                epsilon =0.1,
                max.iterations = 100,
                optim.method = c("BFGS"),
                rel.tol=0.01,
                rescale.flag = TRUE,
                rescaling.offset = 0.001)

fit[[3]]$X.output

