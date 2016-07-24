# GettingAndCleaningProj1

Instructions

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.
Review criterialess 

    1. The submitted data set is tidy.
    2. The Github repo contains the required scripts.
    3. GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
    4. The README that explains the analysis files is clear and understandable.
    5. The work submitted for this project is the work of the student who submitted it.

Getting and Cleaning Data Course Projectless 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement.
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names.
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Project Details

This repos contains
   1. run_analysis.R : the R-code run on the data set
   2. Tidy.dat : the clean data extracted from the original data using run_analysis.R
   3. CodeBook.md : the CodeBook reference to the variables in Tidy.dat
   4. README.md : This File - the analysis of the code in run_analysis.R
   

###Libraries Used

The libraries used in this operation are `data.table` and `dplyr`. We prefer `data.table` as it is efficient in handling large data as tables. `dplyr` is used to aggregate variables to create the tidy data.

```{r, message=FALSE}
library(data.table)
library(dplyr)
```


## 0. Setup - Download dataset and Read Metadata
###Download dataset zip file.
```{r}
URLF <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("UCIdataset.zip")) {
    download.file(URLF,dest="UCIdataset.zip")
}
unzip (zipfile="UCIdataset.zip", exdir = "./data")
```

###Read in the data from files. Read features labels and activity labels into table.
```{r}
features     = read.table('./data/UCI HAR Dataset/features.txt',header=FALSE)
activityType = read.table('./data/UCI HAR Dataset/activity_labels.txt',header=FALSE)
```

###Format data sets

Both training and test data sets are split up into subject, activity and features. They are present in three different files. 

####Read Training data
```{r}
subjectTrain = read.table('./data/UCI HAR Dataset/train/subject_train.txt',header=FALSE)
featureTrain = read.table('./data/UCI HAR Dataset/train/x_train.txt',header=FALSE)
activityTrain = read.table('./data/UCI HAR Dataset/train/y_train.txt',header=FALSE)
```

####Read Test data
```{r}
subjectTest  = read.table('./data/UCI HAR Dataset/test/subject_test.txt',header=FALSE)
featureTest  = read.table('./data/UCI HAR Dataset/test/x_test.txt',header=FALSE)
activityTest = read.table('./data/UCI HAR Dataset/test/y_test.txt',header=FALSE)
```


## 1. Merge the training and the test sets to create one data set
Combine the data in training and test data set and stores them in subject, activity and feature.
```{r}
subject <- rbind(subjectTrain, subjectTest)
colnames(subject) <- "Subject"
activity <- rbind(activityTrain, activityTest)
colnames(activity) <- "Activity"
feature <- rbind(featureTrain, featureTest)
colnames(feature) <- features$V2
```

###Merge the data
The data in `features`,`activity` and `subject` are merged data and stored in `finalData`.

```{r}
finalData <- cbind(feature, activity, subject)
```

##2. Extracts only the measurements on the mean and standard deviation for each measurement

Extract the column indices that have either mean or std in them.
```{r}
colWithMeanSTD <- grep(".*(mean|std).*", names(finalData), ignore.case=TRUE)

```
Add activity and subject columns to the list and look at the dimension of `completeData` 
```{r}
requiredCol <- c(colWithMeanSTD, 562, 563)
dim(finalData)
```

> dim(finalData)
[1] 10299   563


We create `extractedData` with the selected columns in `requiredColumns`. And again, we look at the dimension of `requiredColumns`. 
```{r}
extractData <- finalData[,requiredCol]
dim(extractData)
```
> dim(extractData)
[1] 10299    88

##3. Uses descriptive activity names to name the activities in the data set
The activity names are taken from metadata `activityType`.
```{r}
for (i in 1:6) {
    extractData$Activity[extractData$Activity == i] <- as.character(activityType[i,2])
}
```
Factor the `activity` variable, after the activity names are updated.
```{r}
extractData$Activity <- as.factor(extractData$Activity)
```
##4. Appropriately labels the data set with descriptive variable names
Here are the names of the variables in `extractData` 
```{r}
names(extractData)
```
```{r}
> names(extractData)
 [1] "tBodyAcc-mean()-X"                    "tBodyAcc-mean()-Y"                   
 [3] "tBodyAcc-mean()-Z"                    "tBodyAcc-std()-X"                    
 [5] "tBodyAcc-std()-Y"                     "tBodyAcc-std()-Z"                    
 [7] "tGravityAcc-mean()-X"                 "tGravityAcc-mean()-Y"                
 [9] "tGravityAcc-mean()-Z"                 "tGravityAcc-std()-X"                 
[11] "tGravityAcc-std()-Y"                  "tGravityAcc-std()-Z"                 
[13] "tBodyAccJerk-mean()-X"                "tBodyAccJerk-mean()-Y"               
[15] "tBodyAccJerk-mean()-Z"                "tBodyAccJerk-std()-X"                
[17] "tBodyAccJerk-std()-Y"                 "tBodyAccJerk-std()-Z"                
[19] "tBodyGyro-mean()-X"                   "tBodyGyro-mean()-Y"                  
[21] "tBodyGyro-mean()-Z"                   "tBodyGyro-std()-X"                   
[23] "tBodyGyro-std()-Y"                    "tBodyGyro-std()-Z"                   
[25] "tBodyGyroJerk-mean()-X"               "tBodyGyroJerk-mean()-Y"              
[27] "tBodyGyroJerk-mean()-Z"               "tBodyGyroJerk-std()-X"               
[29] "tBodyGyroJerk-std()-Y"                "tBodyGyroJerk-std()-Z"               
[31] "tBodyAccMag-mean()"                   "tBodyAccMag-std()"                   
[33] "tGravityAccMag-mean()"                "tGravityAccMag-std()"                
[35] "tBodyAccJerkMag-mean()"               "tBodyAccJerkMag-std()"               
[37] "tBodyGyroMag-mean()"                  "tBodyGyroMag-std()"                  
[39] "tBodyGyroJerkMag-mean()"              "tBodyGyroJerkMag-std()"              
[41] "fBodyAcc-mean()-X"                    "fBodyAcc-mean()-Y"                   
[43] "fBodyAcc-mean()-Z"                    "fBodyAcc-std()-X"                    
[45] "fBodyAcc-std()-Y"                     "fBodyAcc-std()-Z"                    
[47] "fBodyAcc-meanFreq()-X"                "fBodyAcc-meanFreq()-Y"               
[49] "fBodyAcc-meanFreq()-Z"                "fBodyAccJerk-mean()-X"               
[51] "fBodyAccJerk-mean()-Y"                "fBodyAccJerk-mean()-Z"               
[53] "fBodyAccJerk-std()-X"                 "fBodyAccJerk-std()-Y"                
[55] "fBodyAccJerk-std()-Z"                 "fBodyAccJerk-meanFreq()-X"           
[57] "fBodyAccJerk-meanFreq()-Y"            "fBodyAccJerk-meanFreq()-Z"           
[59] "fBodyGyro-mean()-X"                   "fBodyGyro-mean()-Y"                  
[61] "fBodyGyro-mean()-Z"                   "fBodyGyro-std()-X"                   
[63] "fBodyGyro-std()-Y"                    "fBodyGyro-std()-Z"                   
[65] "fBodyGyro-meanFreq()-X"               "fBodyGyro-meanFreq()-Y"              
[67] "fBodyGyro-meanFreq()-Z"               "fBodyAccMag-mean()"                  
[69] "fBodyAccMag-std()"                    "fBodyAccMag-meanFreq()"              
[71] "fBodyBodyAccJerkMag-mean()"           "fBodyBodyAccJerkMag-std()"           
[73] "fBodyBodyAccJerkMag-meanFreq()"       "fBodyBodyGyroMag-mean()"             
[75] "fBodyBodyGyroMag-std()"               "fBodyBodyGyroMag-meanFreq()"         
[77] "fBodyBodyGyroJerkMag-mean()"          "fBodyBodyGyroJerkMag-std()"          
[79] "fBodyBodyGyroJerkMag-meanFreq()"      "angle(tBodyAccMean,gravity)"         
[81] "angle(tBodyAccJerkMean),gravityMean)" "angle(tBodyGyroMean,gravityMean)"    
[83] "angle(tBodyGyroJerkMean,gravityMean)" "angle(X,gravityMean)"                
[85] "angle(Y,gravityMean)"                 "angle(Z,gravityMean)"                
[87] "Activity"                             "Subject"  
```

By examining `extractData`, we can say that the following acronyms can be replaced:

- `Acc` can be replaced with Accelerometer

- `Gyro` can be replaced with Gyroscope

- `BodyBody` can be replaced with Body

- `Mag` can be replaced with Magnitude

- Character `f` can be replaced with Frequency

- Character `t` can be replaced with Time

```{r}
names(extractData)<-gsub("Acc", "Accelerometer", names(extractData))
names(extractData)<-gsub("Gyro", "Gyroscope", names(extractData))
names(extractData)<-gsub("BodyBody", "Body", names(extractData))
names(extractData)<-gsub("Mag", "Magnitude", names(extractData))
names(extractData)<-gsub("^t", "Time", names(extractData))
names(extractData)<-gsub("^f", "Frequency", names(extractData))
names(extractData)<-gsub("tBody", "TimeBody", names(extractData))
names(extractData)<-gsub("-mean()", "Mean", names(extractData), ignore.case = TRUE)
names(extractData)<-gsub("-std()", "STD", names(extractData), ignore.case = TRUE)
names(extractData)<-gsub("-freq()", "Frequency", names(extractData), ignore.case = TRUE)
names(extractData)<-gsub("angle", "Angle", names(extractData))
names(extractData)<-gsub("gravity", "Gravity", names(extractData))
```
Here are the names of the variables in `extractData` after they are edited
```{r}
names(extractData)
```
```{r}
> names(extractData)
 [1] "TimeBodyAccelerometerMean()-X"                    
 [2] "TimeBodyAccelerometerMean()-Y"                    
 [3] "TimeBodyAccelerometerMean()-Z"                    
 [4] "TimeBodyAccelerometerSTD()-X"                     
 [5] "TimeBodyAccelerometerSTD()-Y"                     
 [6] "TimeBodyAccelerometerSTD()-Z"                     
 [7] "TimeGravityAccelerometerMean()-X"                 
 [8] "TimeGravityAccelerometerMean()-Y"                 
 [9] "TimeGravityAccelerometerMean()-Z"                 
[10] "TimeGravityAccelerometerSTD()-X"                  
[11] "TimeGravityAccelerometerSTD()-Y"                  
[12] "TimeGravityAccelerometerSTD()-Z"                  
[13] "TimeBodyAccelerometerJerkMean()-X"                
[14] "TimeBodyAccelerometerJerkMean()-Y"                
[15] "TimeBodyAccelerometerJerkMean()-Z"                
[16] "TimeBodyAccelerometerJerkSTD()-X"                 
[17] "TimeBodyAccelerometerJerkSTD()-Y"                 
[18] "TimeBodyAccelerometerJerkSTD()-Z"                 
[19] "TimeBodyGyroscopeMean()-X"                        
[20] "TimeBodyGyroscopeMean()-Y"                        
[21] "TimeBodyGyroscopeMean()-Z"                        
[22] "TimeBodyGyroscopeSTD()-X"                         
[23] "TimeBodyGyroscopeSTD()-Y"                         
[24] "TimeBodyGyroscopeSTD()-Z"                         
[25] "TimeBodyGyroscopeJerkMean()-X"                    
[26] "TimeBodyGyroscopeJerkMean()-Y"                    
[27] "TimeBodyGyroscopeJerkMean()-Z"                    
[28] "TimeBodyGyroscopeJerkSTD()-X"                     
[29] "TimeBodyGyroscopeJerkSTD()-Y"                     
[30] "TimeBodyGyroscopeJerkSTD()-Z"                     
[31] "TimeBodyAccelerometerMagnitudeMean()"             
[32] "TimeBodyAccelerometerMagnitudeSTD()"              
[33] "TimeGravityAccelerometerMagnitudeMean()"          
[34] "TimeGravityAccelerometerMagnitudeSTD()"           
[35] "TimeBodyAccelerometerJerkMagnitudeMean()"         
[36] "TimeBodyAccelerometerJerkMagnitudeSTD()"          
[37] "TimeBodyGyroscopeMagnitudeMean()"                 
[38] "TimeBodyGyroscopeMagnitudeSTD()"                  
[39] "TimeBodyGyroscopeJerkMagnitudeMean()"             
[40] "TimeBodyGyroscopeJerkMagnitudeSTD()"              
[41] "FrequencyBodyAccelerometerMean()-X"               
[42] "FrequencyBodyAccelerometerMean()-Y"               
[43] "FrequencyBodyAccelerometerMean()-Z"               
[44] "FrequencyBodyAccelerometerSTD()-X"                
[45] "FrequencyBodyAccelerometerSTD()-Y"                
[46] "FrequencyBodyAccelerometerSTD()-Z"                
[47] "FrequencyBodyAccelerometerMeanFreq()-X"           
[48] "FrequencyBodyAccelerometerMeanFreq()-Y"           
[49] "FrequencyBodyAccelerometerMeanFreq()-Z"           
[50] "FrequencyBodyAccelerometerJerkMean()-X"           
[51] "FrequencyBodyAccelerometerJerkMean()-Y"           
[52] "FrequencyBodyAccelerometerJerkMean()-Z"           
[53] "FrequencyBodyAccelerometerJerkSTD()-X"            
[54] "FrequencyBodyAccelerometerJerkSTD()-Y"            
[55] "FrequencyBodyAccelerometerJerkSTD()-Z"            
[56] "FrequencyBodyAccelerometerJerkMeanFreq()-X"       
[57] "FrequencyBodyAccelerometerJerkMeanFreq()-Y"       
[58] "FrequencyBodyAccelerometerJerkMeanFreq()-Z"       
[59] "FrequencyBodyGyroscopeMean()-X"                   
[60] "FrequencyBodyGyroscopeMean()-Y"                   
[61] "FrequencyBodyGyroscopeMean()-Z"                   
[62] "FrequencyBodyGyroscopeSTD()-X"                    
[63] "FrequencyBodyGyroscopeSTD()-Y"                    
[64] "FrequencyBodyGyroscopeSTD()-Z"                    
[65] "FrequencyBodyGyroscopeMeanFreq()-X"               
[66] "FrequencyBodyGyroscopeMeanFreq()-Y"               
[67] "FrequencyBodyGyroscopeMeanFreq()-Z"               
[68] "FrequencyBodyAccelerometerMagnitudeMean()"        
[69] "FrequencyBodyAccelerometerMagnitudeSTD()"         
[70] "FrequencyBodyAccelerometerMagnitudeMeanFreq()"    
[71] "FrequencyBodyAccelerometerJerkMagnitudeMean()"    
[72] "FrequencyBodyAccelerometerJerkMagnitudeSTD()"     
[73] "FrequencyBodyAccelerometerJerkMagnitudeMeanFreq()"
[74] "FrequencyBodyGyroscopeMagnitudeMean()"            
[75] "FrequencyBodyGyroscopeMagnitudeSTD()"             
[76] "FrequencyBodyGyroscopeMagnitudeMeanFreq()"        
[77] "FrequencyBodyGyroscopeJerkMagnitudeMean()"        
[78] "FrequencyBodyGyroscopeJerkMagnitudeSTD()"         
[79] "FrequencyBodyGyroscopeJerkMagnitudeMeanFreq()"    
[80] "Angle(TimeBodyAccelerometerMean,Gravity)"         
[81] "Angle(TimeBodyAccelerometerJerkMean),GravityMean)"
[82] "Angle(TimeBodyGyroscopeMean,GravityMean)"         
[83] "Angle(TimeBodyGyroscopeJerkMean,GravityMean)"     
[84] "Angle(X,GravityMean)"                             
[85] "Angle(Y,GravityMean)"                             
[86] "Angle(Z,GravityMean)"                             
[87] "Activity"                                         
[88] "Subject"
```
##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Firstly, let us set `Subject` as a factor variable. 
```{r}
extractData$Subject <- as.factor(extractData$Subject)
extractData <- data.table(extractData)
```
We create `tidyData` as a data set with average for each activity and subject. Then, we order the entries in `tidyData` and write it into data file `Tidy.txt` that contains the processed data.

```{r}
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]

write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
```

