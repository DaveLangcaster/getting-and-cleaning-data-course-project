---
title: "Readme.md"
author: "Dave Langcaster"
date: "15 September 2018"
output: html_document
keep_md: yes
---

# Coursera *Getting and Cleaning Data* course project

This is the repository for the Getting and Cleaning Data Course Project and contains the following files:

<table>
<tr><th>File Name</th><th>Description</th></tr>
<tr><td valign=top><code>README.md</code></td><td>Documentation explaining the project and how to use files contained in the repository.</td></tr>
<tr><td valign=top><code>Codebook.md</code></td><td>R A description of the data in a data set, including variable names, descriptions and data formats.</td></tr>
<tr><td valign=top><code>run_analysis.R</code></td><td>R script to download the zipped data files, unpack them into a directory, read the unzipped files into a set of data frames, and then clean the data. The cleaned data, consisting of an aggregated data table of means and standard deviations with human readable variable names is then output to a text file for analysis.</td></tr>
<tr><td valign=top><code>tidyData.txt</code></td><td>A standard ACSII text file containing the cleaned, aggregated mean/standard deviation data.</td></tr>
<tr><td valign=top><code>tidyData.csv</code></td><td>An alternative version of <code>tidyData.txt</code> in .csv format.</td></tr>
</table>

## Tidying the Data <a name="tidying-data"></a>

The R script <code>run_analysis.R</code> can be used to re-create the tidy data set. The script merges training and test data together to create a single data set, the columns containing mean and standard deviation measurements are extracted (79 variables from the original 561). These measurements are then avaraged for each subject and activity type. This final data set is then written to a text file.

<code>run_analysis.R</code> carries out the following steps to produce the final, tidy, data set:

- Install and load the required packages <code>data.table</code>, <code>dplyr</code> and <code>plyr</code> if they are not already installed.
- Download and unzip source data if it doesn't already exist on the local machine.
- Read the source data into a set of data tables.
- Merge the training and the test sets to create one data set.
- Extract only the measurements on the mean and standard deviation for each measurement.
- Apply descriptive activity names to the activities in the data set.
- Appropriately label the data set with descriptive variable names.
- Create a second, independent tidy set with the average of each variable for each activity and each subject.
- Write the data set to the <code>tidyData.txt</code> file.

The `tidyData.txt` file in this repository was created by running the `run_analysis.R` script using R version 3.5.1 (2018-07-02) on Windows 7 64-bit edition.

This script requires the <code>data.table</code> (version 1.11.4), <code>dplyr</code> (version 0.7.6) and <code>plyr</code> (version 1.8.4) packages
