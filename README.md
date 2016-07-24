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
dim(requiredCol)
```
We create `extractedData` with the selected columns in `requiredColumns`. And again, we look at the dimension of `requiredColumns`. 
```{r}
extractData <- finalData[,requiredCol]
dim(extractData)
```
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

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

Firstly, let us set `Subject` as a factor variable. 
```{r}
extractData$Subject <- as.factor(extractData$Subject)
extractData <- data.table(extractData)
```
We create `tidyData` as a data set with average for each activity and subject. Then, we order the entries in `tidyData` and write it into data file `Tidy.dat` that contains the processed data.

```{r}
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = TRUE)
```

