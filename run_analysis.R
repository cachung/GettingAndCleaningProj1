# This script will downlaod UCI HAR Dataset from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# Download the UCI dataset.zip
URLF <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("UCIdataset.zip")) {
    download.file(URLF,dest="UCIdataset.zip")
}
unzip (zipfile="UCIdataset.zip", exdir = "./data")

## Use dplyr to aggregate variables to create the tidy data
library(data.table)


##
## 1. Merge the training and test sets to create one data set.
##
# 1.1 Read in the data from files. Read features labels and activity labels into table
features     = read.table('./data/UCI HAR Dataset/features.txt',header=FALSE)
activityType = read.table('./data/UCI HAR Dataset/activity_labels.txt',header=FALSE)

# 1.2 Read training set into table
subjectTrain = read.table('./data/UCI HAR Dataset/train/subject_train.txt',header=FALSE)
featureTrain       = read.table('./data/UCI HAR Dataset/train/x_train.txt',header=FALSE)
activityTrain       = read.table('./data/UCI HAR Dataset/train/y_train.txt',header=FALSE)

# 1.3 Read test set into table
subjectTest  = read.table('./data/UCI HAR Dataset/test/subject_test.txt',header=FALSE)
featureTest        = read.table('./data/UCI HAR Dataset/test/x_test.txt',header=FALSE)
activityTest        = read.table('./data/UCI HAR Dataset/test/y_test.txt',header=FALSE)

#
# Combine the data in training and test data set and stores them in subject, activity and feature.
#
subject <- rbind(subjectTrain, subjectTest)
colnames(subject) <- "Subject"
activity <- rbind(activityTrain, activityTest)
colnames(activity) <- "Activity"
feature <- rbind(featureTrain, featureTest)
colnames(feature) <- features$V2

# Combine feature, activity and subject into finalData.
finalData <- cbind(feature, activity, subject)


##
## 2. Extracts only the measurement on the mean and sd for each measurement
##
colWithMeanSTD <- grep(".*(mean|std).*", names(finalData), ignore.case=TRUE)
requiredCol <- c(colWithMeanSTD, 562, 563)
extractData <- finalData[,requiredCol]


##
## 3. Use descriptive activity names to name the activities in the data set.
## 
for (i in 1:6) {
    extractData$Activity[extractData$Activity == i] <- as.character(activityType[i,2])
}
# Factor the activity variable
extractData$Activity <- as.factor(extractData$Activity)

##
## 4. Appropriately labels the data set with descriptive variable names
##
## Look at the extractData using names(extractData), the following acronyms need to replace
##
## By examining extractData, we can say that the following acronyms can be replaced:
##    Acc can be replaced with Accelerometer
##    Gyro can be replaced with Gyroscope
##    BodyBody can be replaced with Body
##    Mag can be replaced with Magnitude
##    Character f can be replaced with Frequency
##    Character t can be replaced with Time

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

##
##  5. From the data set in step 4, create a second independent tidy data with the average
##     of each variable for each activity and each subject

## Use Subject as factor variable
extractData$Subject <- as.factor(extractData$Subject)
extractData <- data.table(extractData)

library(dplyr)
## Create a tidy data with the average of each variable for each activity and each subject
tidyData <- aggregate(. ~Subject + Activity, extractData, mean)
tidyData <- tidyData[order(tidyData$Subject, tidyData$Activity),]

## Output the file
write.table(tidyData, file="Tidy.txt", row.names=FALSE)