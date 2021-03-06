# MAT-494-Deep-Learning-SNU
Summaries of Lab sessions conducted by me as a Teaching Assistant for MAT-494-Deep Learning (Monsoon-2020) at Shiv Nadar University, India. Please click on the respective lab title to access the code and datasets used.

### [**Lab-1: ML Recap-I: Regression and Linear Models**](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-1_22-08)
Demonstrated solving a real world Business problem by construction of different types of Linear Models starting from Univariate Linear, Quadratic, Cubic models and then moved on to adding some interaction terms before finally settling upon a Multiple Linear Regression Model. Commonly used metrics to judge a Regression models performance were also discussed.    

### [Lab-2: ML Recap-II: Classification](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-2_29-08)
Did a quick recap of the most popular and commonly used Machine Learning Classifers and covered the metrics used to judge a Classifiers performance for both balanced and imbalanced classification. These Classifiers were then used to solve an Imbalanced Class problem of predicting a Wines Quality from a real world dataset containing details about Red Wines from the Northwest Portugal. 

### [Lab-3: Wine Classification using Artificial Neural Networks(ANNs)](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-3_05-09)
Building on the learnings from the previous lab on the Red Wine dataset, this time a Dataset comprising of White wines was used. The procedure of constructing a basic Neural Network architecture (ANN Classifier) was demonstrated using Keras in Python. Finally, its performance was also compared with other popular tree-based ensemble classifers like Random Forests and Gradient Boosting (XGBoost).

### [Lab-4: Demand Forecasting using Artificial Neural Networks(ANNs)](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-4_12-09)
Important aspects of buidling good predictive models such as Exploratory Data Analysis(EDA) and Feature Engineering were demonstrated using two [Hotel Booking datasets](https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-02-11/readme.md) in Python. The focus of this lab was on improving model accuracies through dimensionality reduction using EDA and Feature Engineering. In the end, some basic Neural Network classifers(ANNs) were created to predict whether a user would cancel his booking or not. 

### [Lab-5: Recap of Classification and Regression using ANNs](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-5_19-09)
The two Hotel Booking datasets of Resort and City Hotels were merged into a single dataset. It was then used to demonstrate two tasks:-
- *Classification: To predict whether a new user would could cancel his booking or not*
- *Regression: To predict the price of a booked Hotel room on a particular day.*

Findings from EDA and newly engineered features from the previous lab were used to build complicated Neural Network architectures using the *neuralnet* package in R. The focus of this lab was more on building better ANNs with correct choices of layers, neurons, activation functions and other hyperparameters.  

### [Lab-6: General Regression Neural Networks (GRNNs)](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-6_26_09)
The original research paper on [General Regression Neural Networks (GRNNs)](https://ieeexplore.ieee.org/document/97934), *"a one-shot learning algorithm which does not assume any functional form for the underlying regression surface and solves the problem of getting stuck at local minimas"* was explained followed by its implementation in R. The use of GRNNs was motivated by taking a very small dataset comprising of merely 71 observations in order to predict the *Bodyfat* of a person. It was shown that in scenarios where traditional ANNs and ML methods don't perform well, GRNNs can be used to perform regression tasks even with extremely small sample sizes.  

### [Lab-7: Probabilistic Neural Networks (PNNs)](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-7_03-10)
Gave a summary of the original paper on [Probabilistic Neural Networks (PNNs)](https://wiki.eecs.yorku.ca/course_archive/2013-14/F/4403/_media/specht1990pnn.pdf). The implementation of PNNs was covered in R using the PIMAINDIANS-DIABETES dataset to build a binary classifier for predicting whether a pregnant woman is diabetic or not.

### [Lab-8: Machine Learning for Time Series & Forecasting](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-8_17-10)
- Gave a quick summary of the theory behind Time Series & Forecasting with it's real world applications (see presentation). Traditional Forecasting methods like *AR,MA,ARMA,ARIMA,ARCH & GARCH* were explained with their implementations on a univariate time-series data in python.
- Explained how engineer new features and convert traditional time series forecasting problems into supervised Machine Learning problems. The results obtained by the models built in the previous step were now compared with ML models like Linear Regression,XGBoost, Random Forests etc.


### [Lab-9: Recurrent Neural Networks](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-9/Elman_JordanRNNs)
Two types of Recurrent Neural Networks that work well even with less data viz. [*Elman RNNs & Jordan RNNs*](https://en.wikipedia.org/wiki/Recurrent_neural_network) were implemented in R to forecast the daily number of deaths in the UK from lung diseases.

### [Lab-10: Non-Linear Dimensionality Reduction](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/tree/master/Lab-10)
Limitations of Linear Dimensionality Reduction methods such as PCA were discussed and the use of Non-Linear Dimensionality Reduction was motivated. The theory behind 2 such methods- *Autoencoders* & *Stacked Autoencoders* was discussed and their implementation in R was demonstrated using the [Abalone dataset](http://archive.ics.uci.edu/ml/datasets/Abalone).  

## Student Projects:-

- [Anomaly Detection in ECGs using LSTM Autoencoders](https://github.com/abhisht51/Anomaly-Detection-Autoencoders) by Bhavya Jain & Abhisht Singh
- Generalizability of CNNs in classifying chest XRAY images by Narra Pratap
- [Deep Learning for predicting Bank Loan Term Deposit Subscription](https://github.com/prekshadhoot/Bank-Marketing-Analysis) by Samyak Nayak, Preksha Dhoot & Sneh Bhandari
- [Predicting Early Stage Diabetes Risk using Deep Learning](https://github.com/kartikeypro/Early-Stage-Risk-Diabetes-Using-Deep-Learning) by Kartikeya Garg & Mansi Goel
- [Forecasting Yes Bank Stock Prices using Feed Forward Neural Networks](https://github.com/Sid-darthvader/MAT-494-Deep-Learning-SNU/blob/master/Misc/Yes_Bank_Stock_Price_Prediction.pdf) by Puneet Pandey
- [Identifying  Customer Churn in Banking using Deep Learning](https://github.com/IshaTyagi721/Deep-Learning-Project/) by Isha Tyagi & Sanskriti Agarwal
- [Modelling Airline Passenger Satisfaction levels using Deep Learning](https://drive.google.com/drive/folders/1o7gY4Lx_r7i-fEv7ihp7Uduqj1MINL4D?usp=gmail) by Abhinav Keshri
