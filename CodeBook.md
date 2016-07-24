# CodeBook

## Description
This document is to describe how the data transformed by run_analysis.R script and the definition of variables in Tidy.dat.


## Input Data Set
### Data Set Used as follow:
(Source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)
[![Experiment Video](http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://www.youtube.com/watch?v=XOEN9W05_4A)


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### The Content of UCIdataset.zip

- `X_train.txt` = variable features that are intended for training.
- `y_train.txt` = the activities corresponding to `X_train.txt`.
- `subject_train.txt` = information on the subjects from whom data is collected.
- `X_test.txt` = variable features that are intended for testing.
- `y_test.txt` = the activities corresponding to `X_test.txt`.
- `subject_test.txt` = information on the subjects from whom data is collected. 10299 observations.
- `activity_labels.txt` = metadata on the different types of activities.
      * WALKING
      * WALKING_UPSTAIRS
      * WALKING_DOWNSTAIRS
      * SITTING
      * STANDING
      * LAYING
- `features.txt` = the name of the features in the data sets.


## Transformation
1. Training Data Set
⋅⋅* subject_train.txt reads into subjectTrain
⋅⋅* x_train.txt reads into featureTrain
⋅⋅* y_train.txt reads into activityTrain
2. Test Data Set
⋅⋅* subject_test.txt reads into TestTrain
⋅⋅* x_test.txt reads into featureTest
⋅⋅* y_test.txt read into activityTest
3. Labels
⋅⋅* features.txt reads into features
⋅⋅* activity_labels.txt reads into activityType
4. Combine training and test data set
⋅⋅* Merge all subjects in training and test data set into "subject"
⋅⋅* Merge all activities in training and test data set into "activity"
⋅⋅* Merge all features in training and test data set into "feature"
⋅⋅* Combine feature, subject, activity into finalData
5. Clean up the variable names
⋅⋅* Acronyms in variable names in `extractData`, like 'Acc', 'Gyro', 'Mag', 't' and 'f' are replaced with descriptive labels such as 'Accelerometer', 'Gyroscpoe', 'Magnitude', 'Time' and 'Frequency'.
⋅⋅* `tidyData` is created as a set with average for each activity and subject of `extractData`. Entries in `tidyData` are ordered based on activity and subject.

## Output

The output data "Tidy.txt" is a space-delimited separate value file. The header contains the names of the variables. It contains the mean and Standard Deviation of each measurement.


