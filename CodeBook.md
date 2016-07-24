# Description




# Data Set Information:
(Source: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)
[![Experiment Video](http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://www.youtube.com/watch?v=XOEN9W05_4A)


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

Records of activity windows. Each one composed of:
- A 561-feature vector with time and frequency domain variables.
- Its associated activity label.
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- '[Web Link]': The raw triaxial acceleration signal for the experiment number XX and associated to the user number YY. Every row is one acceleration sample (three axis) captured at a frequency of 50Hz.

- '[Web Link]': The raw triaxial angular speed signal for the experiment number XX and associated to the user number YY. Every row is one angular velocity sample (three axis) captured at a frequency of 50Hz.

- '[Web Link]': include all the activity labels available for the dataset (1 per row).
Column 1: experiment number ID,
Column 2: user number ID,
Column 3: activity number ID
Column 4: Label start point (in number of signal log samples (recorded at 50Hz))
Column 5: Label end point (in number of signal log samples)

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the activity ID with their activity name.

- '[Web Link]': Training set.

- '[Web Link]': Training labels.

- '[Web Link]': Test set.

- '[Web Link]': Test labels.

- '[Web Link]': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- '[Web Link]': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

Notes:
======

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the 'X' and 'y' files.
- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2).
- The gyroscope units are rad/seg.
- A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in the following link: [Web Link]

For more information about this dataset please contact har '@' smartlab.ws or check our website www.smartlab.ws
