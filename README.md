# Coursera *Getting and Cleaning Data* course project

Repository for the Getting and Cleaning Data Course Project

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users.

The purpose of this project was to demonstrate an ability to collect, work with, and clean a data set. The goal was to prepare tidy data that can be used for later analysis.

This repository contains the following files:

<table>
<tr><th>File Name</th><th>Description</th></tr>
<tr><td valign=top><code>README.md</code></td><td>Documentation explaining the project and how to use files contained in the repository.</td></tr>
<tr><td valign=top><code>Codebook.md</code></td><td>R A description of the data in a data set, including variable names, descriptions and data formats.</td></tr>
<tr><td valign=top><code>run_analysis.R</code></td><td>R script to download the zipped data files, unpack them into a directory, read the unzipped files into a set of data frames, and then clean the data. The cleaned data, consisting of an aggregated data table of means and standard deviations with human readable variable names is then output to a text file for analysis.</td></tr>
<tr><td valign=top><code>tidyData.txt</code></td><td>A standard ACSII text file containing the cleaned, aggregated mean/standard deviation data.</td></tr>
<tr><td valign=top><code>tidyData.csv</code></td><td>An alternative version of <code>tidyData.txt</code> in .csv format.</td></tr>
</table>

## Study design <a name="study-design"></a>

Data used in this project was obtained from [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#). Study data was collected in the following way, as described by the researchers:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
> 
> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Tidying the Data <a name="tidying-data"></a>

The R script <code>run_analysis.R</code> can be used to re-create the tidy data set. The script merges training and test data together to create a single data set, the columns containing mean and standard deviation measurements are extracted (79 variables from the original 561). These measurements were then avareaged for each subject and activity type. This final data set was then written to a text file.

<code>run_analysis.R</code> carries out the following steps to produce the final, tidy, data set:

- Install install and load the required packages <code>data.table</code>, <code>dplyr</code> and <code>plyr</code> if they are not already installed.
- Download and unzip source data if it doesn't exist.
- Read the source data into a set of data tables.
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Apply descriptive activity names to the activities in the data set.
- Appropriately label the data set with descriptive variable names.
- Create a second, independent tidy set with the average of each variable for each activity and each subject.
- Write the data set to the <code>tidy_data.txt</code> file.