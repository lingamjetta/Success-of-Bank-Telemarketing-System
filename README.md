# Success-of-Bank-Telemarketing-System
This project related to direct marketing campaigns of a bank based on phone calls 
## Business understanding
This Dataset is banking direct telemarketing campaigns bassed on the phone calls weather customer subscribe to product or not,
if the customer subscribed(yes),not(no).
## Terget data Predict subscribed or not (yes,no)
### Data exploration and Preprocessing
This bank-full.csv dataset have totally  45211 observations with 17 variiable 

'data.frame':	45211 obs. of  17 variables:
 $ age      : int  58 44 33 47 33 35 28 42 58 43 ...
 $ job      : Factor w/ 12 levels "admin.","blue-collar",..: 5 10 3 2 12 5 5 3 6 10 ...
 $ marital  : Factor w/ 3 levels "divorced","married",..: 2 3 2 2 3 2 3 1 2 3 ...
 $ education: Factor w/ 4 levels "primary","secondary",..: 3 2 2 4 4 3 3 3 1 2 ...
 $ default  : Factor w/ 2 levels "no","yes": 1 1 1 1 1 1 1 2 1 1 ...
 $ balance  : int  2143 29 2 1506 1 231 447 2 121 593 ...
 $ housing  : Factor w/ 2 levels "no","yes": 2 2 2 2 1 2 2 2 2 2 ...
 $ loan     : Factor w/ 2 levels "no","yes": 1 1 2 1 1 1 2 1 1 1 ...
 $ contact  : Factor w/ 3 levels "cellular","telephone",..: 3 3 3 3 3 3 3 3 3 3 ...
 $ day      : int  5 5 5 5 5 5 5 5 5 5 ...
 $ month    : Factor w/ 12 levels "apr","aug","dec",..: 9 9 9 9 9 9 9 9 9 9 ...
 $ duration : int  261 151 76 92 198 139 217 380 50 55 ...
 $ campaign : int  1 1 1 1 1 1 1 1 1 1 ...
 $ pdays    : int  -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 ...
 $ previous : int  0 0 0 0 0 0 0 0 0 0 ...
 $ poutcome : Factor w/ 4 levels "failure","other",..: 4 4 4 4 4 4 4 4 4 4 ...
 $ y        : Factor w/ 2 levels "no","yes": 1 1 1 1 1 1 1 1 1 1 ...
 
 #the target varriable was y factor (yes,no)
 ->target variiable distribution
 prop.table(table(bank$y))

       no       yes 
0.8830152 0.1169848 
->88:12 means that it is a imbalance data so for classification propblem data imbalance was a problem,
beacuse algorithm does not have engouh data to learn the minority class, then the accuracy of the model will be decreased
the model always predict the majority class,so missclassification was occured.
### We check how the class imbalance was effect the model Accuracy
->check the missing values
sum(is.na(bank))
0
no missing values in the dataset
## variable selection for that i used the wraper method i.e(backword selection)
backword selection using the "Randomforest" model to variable selection
->Randomforest not only used for predictions it also used for variable selection 
model_ran=randomForest(y~.,data = var)
->iam not used any other parameters simply training data and formula
->using varimp method from randomforest we select the variables

varImp(model_ran)
> varImp(model_ran)
             Overall
age       143.785280
job       119.713779
marital    37.334813
education  46.305374
default     6.979335
balance   187.102073
housing    19.757177
loan       19.497510
contact    17.165408
day       133.081429
month      31.847742
duration  839.389890
campaign   83.957178
pdays       0.000000
previous    0.000000
poutcome    0.000000
-> varImpPlot(model_ran)
![rplot](https://user-images.githubusercontent.com/24644939/27388089-296c85ce-56b8-11e7-9abb-09138725a9db.png)

-> From the above plot we remove the variable which have the highest importance,(pdays,previous,poutcome) 0 importance so we remove the variables from dataset to train the model
-> Remove unimportant variables
bank=bank[,-c(14,15,16,5,9,8)]
## split the data for test and train 
Trian 60% and Test 40% 
-> Always training data must be more compared to test data
# model building 
-> cart model used to build the model because it work on both numerical and categorical data and imbalance data
library(rpart)
cart_model=rpart(y~.,data = train_data,method = "class")

![rplot01](https://user-images.githubusercontent.com/24644939/27388804-2feadc82-56ba-11e7-8683-360b48c6ffbb.png)

### check the model overfiting using the cp(complex parameter)
> printcp(cart_model)

"Classification tree:
rpart(formula = y ~ ., data = train_data, method = "class")

Variables actually used in tree construction:
[1] duration month   

Root node error: 3184/27126 = 0.11738

n= 27126 

        CP nsplit rel error  xerror     xstd
1 0.027324      0   1.00000 1.00000 0.016649
2 0.027010      2   0.94535 0.97456 0.016464
3 0.010000      4   0.89133 0.90484 0.015937"
-> cp value was mininmum and xerror(cross validation error)alsoo minimum so no need to prune the tree,
Predict the model using test data
-> ypred=predict(cart_model,newdata = test_data,type = "class")
"table(ypred)
ypred
   no   yes 
16907  1178 "

# calculate the accuracy using the confusion matrix
> confusionMatrix(test_data$y,ypred)
Confusion Matrix and Statistics

          Reference
Prediction    no   yes
       no  15477   503
       yes  1430   675
                                          
               Accuracy : 0.8931          
                 95% CI : (0.8885, 0.8976)
    No Information Rate : 0.9349          
    P-Value [Acc > NIR] : 1               
                                          
                  Kappa : 0.3575          
 Mcnemar's Test P-Value : <2e-16          
                                          
            Sensitivity : 0.9154          
            Specificity : 0.5730          
         Pos Pred Value : 0.9685          
         Neg Pred Value : 0.3207          
             Prevalence : 0.9349          
         Detection Rate : 0.8558          
   Detection Prevalence : 0.8836          
      Balanced Accuracy : 0.7442          
                                          
       'Positive' Class : no    
 -> we got accuracy 81% but accuracy is not only metric to messure 
 ### Note: When we checkk the above result model biased towards majority class (no) beacuse of unbalanced data
 ## Recall precession F1-score
 # Recall =TP/(TP+FN)
 > 675/(675+503)
[1] 0.5730051
## Precession=TP/(TP+FP)
675/(675+1430)
[1] 0.3206651
## F1-score=2*(p*R)/(P+R)
 2*(0.57*0.32)/(0.32+0.57)
[1] 0.4098876
-> From this we concluded that poor model so we remove the class imbalance propblem
## Class Imabalance 
-> Class imbalance problem was removed by 3 methods
1)Overfitting
2)Underfitting
3)generating methods (both)
-> in R we have ROSE(Random over sampling estimation)
#### library(ROSE)
->using over sampling the data
>"ovrdata=ovun.sample(y~.,data = train_data,method = "over")$data"
Check the balance
> prop.table(table(ovrdata$y))

       no       yes 
0.5001358 0.4998642 
##### this was balanced now buiild the model with this ovrdata
->Building the model with ovrdata simple glm model
glm_smp=glm(y~.,data = ovrdata,family = "binomial")
-> it AIC=43017 less compared to other model
#predicting the model
> pred_glm=predict(glm_smp,data=test_data,type="response")
> confusionMatrix(test_data$y,pred_glm)
Confusion Matrix and Statistics

          Reference
Prediction    no   yes
       no  13112  2868
       yes   461  1644
                                          
               Accuracy : 0.8159          
                 95% CI : (0.8102, 0.8215)
    No Information Rate : 0.7505          
    P-Value [Acc > NIR] : < 2.2e-16       
                                          
                  Kappa : 0.402           
 Mcnemar's Test P-Value : < 2.2e-16       
                                          
            Sensitivity : 0.9660          
            Specificity : 0.3644          
         Pos Pred Value : 0.8205          
         Neg Pred Value : 0.7810          
             Prevalence : 0.7505          
         Detection Rate : 0.7250          
   Detection Prevalence : 0.8836          
      Balanced Accuracy : 0.6652          
                                          
       'Positive' Class : no        
   
   # Recall, Precession and F1_score
  > 1644/(1644+461)
[1] 0.7809976
Recall=0.78
-> Precession
> 1644/(1644+2868)
[1] 0.3643617
p=0.38
#F1_score=2*(0.78*0.36)/(0.78+0.36)
-> F1_Score=0.48
## Conclussion
-> F1-score of normal model is only 0.40, but balanced data f1_score was 0.48 iit improved
