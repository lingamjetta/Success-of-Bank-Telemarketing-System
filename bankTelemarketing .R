library(rattle)
library(ggplot2)
library(caret)
library(car)
library(randomForest)
library(rpart)
library(rpart.plot)
library(gmodels)
library(ROCR)
library(AUC)
library(ROSE)
setwd("I:\\docs\\Projects\\bank")
#importing the data
bank=read.csv("bank-full.csv",sep = ";")
str(bank)
#exploratory data analysis
prop.table(table(bank$y))
#univariant analysis
barchart(bank$y)
ggplot(bank,aes(bank$y))+geom_bar() #less peoples are yes
ggplot(bank,aes(age))+geom_histogram(binwidth = 0.9)
ggplot(bank,aes(balance))+geom_histogram()
#bivariant analysis
ggplot(bank,aes(y,age))+geom_boxplot()
ggplot(bank,aes(job,fill=y))+geom_bar()
ggplot(bank,aes(marital,fill=y))+geom_bar()

#data preprocessing  variable selection
sum(is.na(bank)) #no missing values

#feaure selection using the  hypothesis test
chisq.test(bank$job,bank$y) #accept alternative
chisq.test(bank$marital,bank$y)
chisq.test(bank$education,bank$y)
chisq.test(bank$default,bank$y)
chisq.test(bank$housing,bank$y)
#data preprocessing
prop.table(table(bank$y)) #0.88:0.11
#wraper methods to feture selections
var=bank[1:20000,]
model_ran=randomForest(y~.,data = var)
varImp(model_ran)
varImpPlot(model_ran)
#remove un important variables
bank=bank[,-c(14,15,16,5,9,8)]
#data preparation
set.seed(123)
sam=sample(nrow(bank),nrow(bank)*0.6)
train_data=bank[sam,]
test_data=bank[-sam,]
#build a random forest for variable selection
cart_model=rpart(y~.,data = train_data,method = "class")
fancyRpartPlot(cart_model)
#check for the varimp
varImp(cart_model)
#age job education f=default balance loan day not important
printcp(cart_model)
plotcp(cart_model) # no over fitting  the model
#predicting the model
ypred=predict(cart_model,newdata = test_data,type = "class")
table(ypred)
confusionMatrix(test_data$y,ypred)
#cross table
CrossTable(test_data$y,ypred) #poor model

#class imbalance problem
#oversampling the data
ovrdata=ovun.sample(y~.,data = train_data,method = "over")$data
prop.table(table(ovrdata$y))
#build the model with overdata
cart_samp=rpart(y~.,data = ovrdata,method = "class")
fancyRpartPlot(cart_samp)
printcp(cart_samp)
#predict 
cart_pred=predict(cart_samp,newdata = test_data,type = "class")
table(cart_pred)age
CrossTable(test_data$y,cart_pred)
#build random forest
glm_smp=glm(y~.,data = ovrdata,family = "binomial")
summary(glm_smp)
pred_glm=predict(glm_smp,newdata=test_data,type="response")
head(pred_glm)
pred_glm=ifelse(pred_glm>=0.5,"yes","no")
table(test_data$y)
table(test_data$y,pred_glm)
confusionMatrix(test_data$y,pred_glm)
#under sampling
undrdata=ovun.sample(y~.,data = train_data,method = "under")$data
prop.table(table(undrdata$y))
#use the undrdata build glm
glm_under=glm(y~.,data = undrdata,family = "binomial")
summary(glm_smp)
pred_under=predict(glm_under,newdata=test_data,type="response")
head(pred_under)
pred_under=ifelse(pred_under>=0.5,"yes","no")
table(pred_glm)
confusionMatrix(test_data$y,pred_under)
CrossTable(test_data$y,pred_under)

#roc auc graph
#convert all categoriacl to numerical
test_data$y=ifelse(test_data$y=="yes",1,0)
ypred=ifelse(ypred=="yes",1,0)
#cart
pred1=prediction(test_data$y,ypred)
per1=performance(pred1,"tpr","fpr")
plot(per1)
#sample cart
cart_pred=ifelse(cart_pred=="yes",1,0)
pre2=prediction(test_data$y,cart_pred)
per2=performance(pre2,"tpr","fpr")
plot(per2,add=TRUE,color=TRUE)
#glm
pred_glm=ifelse(pred_glm=="yes",1,0)
per3=prediction(test_data$y,pred_glm)
per3=performance(per3,"tpr","fpr")
plot(per3,add=TRUE,colors=rainbow(20))
