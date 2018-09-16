---
title: "Codebook.md"
author: "Dave Langcaster"
date: "15 September 2018"
output: html_document
keep_md: yes
---

# Codebook for the *Getting and Cleaning Data* course project < name="codebook"></a> 

## Project Description <name="project-description"></a>

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

The purpose of this project was to demonstrate an ability to collect, work with, and clean a data set. The goal was to prepare tidy data that can be used for later analysis.

## Study design and data processing<a name="study-design"></a>

Data used in this project was obtained from [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#). A full description of the study design can be found on the website.

### Collection of the raw data <name="data-collection"></a>

Study data was collected in the following way, as described by the researchers:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
> 
> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Notes on the original (raw) data <name="data-notes"></a>

- Features are normalized and bounded within [-1,1]. 
- Each feature vector is a row on the 'X' and 'y' files. 
- The units used for the accelerations (total and body) are 'g's (gravity of earth -> 9.80665 m/seg2). 
- The gyroscope units are rad/seg. 
- A video of the experiment including an example of the 6 recorded activities with one of the participants can be seen in [this video](http://www.youtube.com/watch?v=XOEN9W05_4A) 

## Guide to create the tidy data file <name="creating-tidy-data-guide"></a>

The tidy data file was created by following these steps:

1. Install and load the required packages <code>data.table</code>, <code>dplyr</code> and <code>plyr</code> if they are not already installed.
2. Download and unzip [source data](http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip) if it doesn't already exist on the local machine.
3. Read the source data into a set of data tables. From the 'Readme.txt' file of the HAR dataset, the dataset contains the following files:

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

4. Merge the training and the test sets to create one data set.
5. Extract only the measurements on the mean and standard deviation for each measurement.
6. Apply descriptive activity names to the activities in the data set.
7. Appropriately label the data set with descriptive variable names.
8. Create a second, independent tidy set with the average of each variable for each activity and each subject.
9. Write the data set to the <code>tidy_data.txt</code> file.

### Cleaning of the data<name="cleaning-data"></a>

The <code>run_analysis.R</code> file performs the following actions to create a tidy data set:

#### Merge training and test sets<name="merging datasets"></a>

The test and training data ("X_train.txt", "X_test.txt"), subject IDs ("subject_train.txt", "subject_test.txt") and activity IDs (y_train.txt, y_test.txt) are merged using <code>rbind()</code> and <code>cbind()</code> to produce a single dataset stored in the variable <code>merged_data</code>. Variables are named using the original variable names assigned by the researchers from the file "features.txt". The <code>colnames()</code> function was used to do this, and also to apply the labels "activityId" and "subjectId" to the activity and subject varaiables respectively.

#### Extract mean and standard deviation variables<name="extract-means-stds"></a>

Variables containing mean and standard deviation measurements are extracted using <code>grepl("subject|activity|mean|std", colnames(merged_data))</code> and assigned to a variable <code>mean_std</code>. 

#### Use descriptive activity names<name="descriptive names"></a>

Activities are labelled via an intermediate variable <code>act_names</code> which is created by applying the <code>merge()</code> function to the <code>merged_data</code> and <code>activity_labels</code> variables. The <code>activity_labels</code> variable was created by reading in the "activity_labels.txt" file from the original data set.

#### Label variables appropriately<name="label-variables"></a>

An intermediate variable <code>act_cols</code> was used to store the labels for the columns, and a series of <code>gsub()</code> operations were carried out to remove the special characters (\, -, "") and to expand abbreviations (i.e. "f" expanded to "frequencyDomain")

[See the Readme.md document that describes the code in greater detail](https://github.com/DaveLangcaster/getting-and-cleaning-data-course-project/blob/master/README.md)

### Create a tidy data set<name="create-tidy-data"></a>

A final data set <code>tidy_means</code> is created containing the average of each variable for each subject and activity using <code>ddply()</code> to iterate over the <code>act_names</code> table, grouping by subject and activity, and calculating the mean for each variable.

## Description of the variables in the tidy_data.txt file<name="tidy-data-description"></a>

### Identifiers <a name="identifiers"></a>

Identifier variables in the tidy dat set are:

*  an identifier of the subject who carried out the experiment (__subjectId__): a numeric variable 1:30
* an activity ID (__activityId__): a numeric variable 1:6 
* an activity label (__activityType__): WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

### Sensor variables <name="sensor-variables"></a>

The sensor variables are contained a 79-feature vector with time and frequency domain signal variables (numeric)

### Average of measurements <a name="average-measurements"></a>

All measurements are floating-point values, normalised and bounded within [-1,1].

Prior to normalisation, acceleration measurements (variables containing `Accelerometer`) were made in *g*'s (9.81 m.s⁻²) and gyroscope measurements (variables containing `Gyroscope`) were made in radians per second (rad.s⁻¹).

Magnitudes of three-dimensional signals (variables containing `Magnitude`) were calculated using the Euclidean norm.

The measurements are classified in two domains:

- Time-domain signals (variables prefixed by `timeDomain`), resulting from the capture of accelerometer and gyroscope raw signals.

- Frequency-domain signals (variables prefixed by `frequencyDomain`), resulting from the application of a Fast Fourier Transform (FFT) to some of the time-domain signals.

#### Time-domain signals <name="time-domain-signals"></a>

- Average time-domain body acceleration in the X, Y and Z directions:

	- `timeDomainBodyAccelerometerMeanX`
	- `timeDomainBodyAccelerometerMeanY`
	- `timeDomainBodyAccelerometerMeanZ`

- Standard deviation of the time-domain body acceleration in the X, Y and Z directions:

	- `timeDomainBodyAccelerometerStandardDeviationX`
	- `timeDomainBodyAccelerometerStandardDeviationY`
	- `timeDomainBodyAccelerometerStandardDeviationZ`

- Average time-domain gravity acceleration in the X, Y and Z directions:

	- `timeDomainGravityAccelerometerMeanX`
	- `timeDomainGravityAccelerometerMeanY`
	- `timeDomainGravityAccelerometerMeanZ`

- Standard deviation of the time-domain gravity acceleration in the X, Y and Z directions:

	- `timeDomainGravityAccelerometerStandardDeviationX`
	- `timeDomainGravityAccelerometerStandardDeviationY`
	- `timeDomainGravityAccelerometerStandardDeviationZ`

- Average time-domain body acceleration jerk (derivation of the acceleration in time) in the X, Y and Z directions:

	- `timeDomainBodyAccelerometerJerkMeanX`
	- `timeDomainBodyAccelerometerJerkMeanY`
	- `timeDomainBodyAccelerometerJerkMeanZ`

- Standard deviation of the time-domain body acceleration jerk (derivation of the acceleration in time) in the X, Y and Z directions:

	- `timeDomainBodyAccelerometerJerkStandardDeviationX`
	- `timeDomainBodyAccelerometerJerkStandardDeviationY`
	- `timeDomainBodyAccelerometerJerkStandardDeviationZ`

- Average time-domain body angular velocity in the X, Y and Z directions:

	- `timeDomainBodyGyroscopeMeanX`
	- `timeDomainBodyGyroscopeMeanY`
	- `timeDomainBodyGyroscopeMeanZ`

- Standard deviation of the time-domain body angular velocity in the X, Y and Z directions:

	- `timeDomainBodyGyroscopeStandardDeviationX`
	- `timeDomainBodyGyroscopeStandardDeviationY`
	- `timeDomainBodyGyroscopeStandardDeviationZ`

- Average time-domain body angular velocity jerk (derivation of the angular velocity in time) in the X, Y and Z directions:

	- `timeDomainBodyGyroscopeJerkMeanX`
	- `timeDomainBodyGyroscopeJerkMeanY`
	- `timeDomainBodyGyroscopeJerkMeanZ`

- Standard deviation of the time-domain body angular velocity jerk (derivation of the angular velocity in time) in the X, Y and Z directions:

	- `timeDomainBodyGyroscopeJerkStandardDeviationX`
	- `timeDomainBodyGyroscopeJerkStandardDeviationY`
	- `timeDomainBodyGyroscopeJerkStandardDeviationZ`

- Average and standard deviation of the time-domain magnitude of body acceleration:

	- `timeDomainBodyAccelerometerMagnitudeMean`
	- `timeDomainBodyAccelerometerMagnitudeStandardDeviation`

- Average and standard deviation of the time-domain magnitude of gravity acceleration:

	- `timeDomainGravityAccelerometerMagnitudeMean`
	- `timeDomainGravityAccelerometerMagnitudeStandardDeviation`

- Average and standard deviation of the time-domain magnitude of body acceleration jerk (derivation of the acceleration in time):

	- `timeDomainBodyAccelerometerJerkMagnitudeMean`
	- `timeDomainBodyAccelerometerJerkMagnitudeStandardDeviation`

- Average and standard deviation of the time-domain magnitude of body angular velocity:

	- `timeDomainBodyGyroscopeMagnitudeMean`
	- `timeDomainBodyGyroscopeMagnitudeStandardDeviation`

- Average and standard deviation of the time-domain magnitude of body angular velocity jerk (derivation of the angular velocity in time):

	- `timeDomainBodyGyroscopeJerkMagnitudeMean`
	- `timeDomainBodyGyroscopeJerkMagnitudeStandardDeviation`

#### Frequency-domain signals <name="frequency-domain-signals"></a>

- Average frequency-domain body acceleration in the X, Y and Z directions:

	- `frequencyDomainBodyAccelerometerMeanX`
	- `frequencyDomainBodyAccelerometerMeanY`
	- `frequencyDomainBodyAccelerometerMeanZ`

- Standard deviation of the frequency-domain body acceleration in the X, Y and Z directions:

	- `frequencyDomainBodyAccelerometerStandardDeviationX`
	- `frequencyDomainBodyAccelerometerStandardDeviationY`
	- `frequencyDomainBodyAccelerometerStandardDeviationZ`

- Weighted average of the frequency components of the frequency-domain body acceleration in the X, Y and Z directions:

	- `frequencyDomainBodyAccelerometerMeanFrequencyX`
	- `frequencyDomainBodyAccelerometerMeanFrequencyY`
	- `frequencyDomainBodyAccelerometerMeanFrequencyZ`

- Average frequency-domain body acceleration jerk (derivation of the acceleration in time) in the X, Y and Z directions:

	- `frequencyDomainBodyAccelerometerJerkMeanX`
	- `frequencyDomainBodyAccelerometerJerkMeanY`
	- `frequencyDomainBodyAccelerometerJerkMeanZ`

- Standard deviation of the frequency-domain body acceleration jerk (derivation of the acceleration in time) in the X, Y and Z directions:

	- `frequencyDomainBodyAccelerometerJerkStandardDeviationX`
	- `frequencyDomainBodyAccelerometerJerkStandardDeviationY`
	- `frequencyDomainBodyAccelerometerJerkStandardDeviationZ`

- Weighted average of the frequency components of the frequency-domain body acceleration jerk (derivation of the acceleration in time) in the X, Y and Z directions:

	- `frequencyDomainBodyAccelerometerJerkMeanFrequencyX`
	- `frequencyDomainBodyAccelerometerJerkMeanFrequencyY`
	- `frequencyDomainBodyAccelerometerJerkMeanFrequencyZ`

- Average frequency-domain body angular velocity in the X, Y and Z directions:

	- `frequencyDomainBodyGyroscopeMeanX`
	- `frequencyDomainBodyGyroscopeMeanY`
	- `frequencyDomainBodyGyroscopeMeanZ`

- Standard deviation of the frequency-domain body angular velocity in the X, Y and Z directions:

	- `frequencyDomainBodyGyroscopeStandardDeviationX`
	- `frequencyDomainBodyGyroscopeStandardDeviationY`
	- `frequencyDomainBodyGyroscopeStandardDeviationZ`

- Weighted average of the frequency components of the frequency-domain body angular velocity in the X, Y and Z directions:

	- `frequencyDomainBodyGyroscopeMeanFrequencyX`
	- `frequencyDomainBodyGyroscopeMeanFrequencyY`
	- `frequencyDomainBodyGyroscopeMeanFrequencyZ`

- Average, standard deviation, and weighted average of the frequency components of the frequency-domain magnitude of body acceleration:

	- `frequencyDomainBodyAccelerometerMagnitudeMean`
	- `frequencyDomainBodyAccelerometerMagnitudeStandardDeviation`
	- `frequencyDomainBodyAccelerometerMagnitudeMeanFrequency`

- Average, standard deviation, and weighted average of the frequency components of the frequency-domain magnitude of body acceleration jerk (derivation of the acceleration in time):

	- `frequencyDomainBodyAccelerometerJerkMagnitudeMean`
	- `frequencyDomainBodyAccelerometerJerkMagnitudeStandardDeviation`
	- `frequencyDomainBodyAccelerometerJerkMagnitudeMeanFrequency`

- Average, standard deviation, and weighted average of the frequency components of the frequency-domain magnitude of body angular velocity:

	- `frequencyDomainBodyGyroscopeMagnitudeMean`
	- `frequencyDomainBodyGyroscopeMagnitudeStandardDeviation`
	- `frequencyDomainBodyGyroscopeMagnitudeMeanFrequency`

- Average, standard deviation, and weighted average of the frequency components of the frequency-domain magnitude of body angular velocity jerk (derivation of the angular velocity in time):

	- `frequencyDomainBodyGyroscopeJerkMagnitudeMean`
	- `frequencyDomainBodyGyroscopeJerkMagnitudeStandardDeviation`
	- `frequencyDomainBodyGyroscopeJerkMagnitudeMeanFrequency`

## Sources <name="sources"></a>

1.  <a name="uci-har"/>Human Activity Recognition Using Smartphones Data Set.
    URL: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>. Accessed 05/21/2014
2. <a name="har-smart"/>Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz.
   *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*.
   International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


