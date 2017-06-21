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
