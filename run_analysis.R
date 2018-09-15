# Getting and Cleaning Data Project John Hopkins Coursera
# Author: Dave Langcaster

# This R Script carries out the following steps required for the course project:

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

################################################################################
# -1. The first set of tasks is to is to load the required packages and get the data
################################################################################

# Task -1.1: Check if the required packages are loaded, and load them if not

packages <- c("data.table", "dplyr", "plyr")
package.check <- lapply(packages, FUN = function(x) {
        if (!require(x, character.only = TRUE)) {
                install.packages(x, dependencies = TRUE)
                library(x, character.only = TRUE)
        }
})

# Task -1.2: Download the zipped data files 

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("dataFiles.zip")) {
        download.file(url, file.path(path, "dataFiles.zip"))
}

# Task -1.3: Unzip the data files

unzip(zipfile = "dataFiles.zip")

####################################################################
# 0. Next, we need to read the data into R from the unzipped text files
####################################################################

# Task 0.1: Create variables to hold file paths

unzip_dir <- "UCI\ HAR\ Dataset"
feature_src <- paste(unzip_dir, "/features.txt", sep = "")
activity_labels_src <- paste(unzip_dir, "/activity_labels.txt", sep = "")
x_train_src <- paste(unzip_dir, "/train/X_train.txt", sep = "")
y_train_src <- paste(unzip_dir, "/train/y_train.txt", sep = "")
subject_train_src <- paste(unzip_dir, "/train/subject_train.txt", sep = "")
x_test_src  <- paste(unzip_dir, "/test/X_test.txt", sep = "")
y_test_src  <- paste(unzip_dir, "/test/y_test.txt", sep = "")
subject_test_src <- paste(unzip_dir, "/test/subject_test.txt", sep = "")

# Task 0.2: Read the data in using read.table

features <- read.table(feature_src, colClasses = c("character"))
activity_labels <- read.table(activity_labels_src, col.names = c("activityId", "activityType"))
x_train <- read.table(x_train_src)
y_train <- read.table(y_train_src)
subject_train <- read.table(subject_train_src)
x_test <- read.table(x_test_src)
y_test <- read.table(y_test_src)
subject_test <- read.table(subject_test_src)

##################################################################
# 1. Merges the training and the test sets to create one data set.
##################################################################

# Task 1.1: Assign column names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

# Task 1.2 Create a single table using cbind and rbind

merged_data <- rbind(
        cbind(subject_train, x_train, y_train),
        cbind(subject_test, x_test, y_test) 
)

# Task 1.3 remove unnecessary data tables

rm(subject_train, x_train, y_train, subject_test, x_test, y_test)

############################################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################

mean_std <- grepl("subject|activity|mean|std", colnames(merged_data))

merged_data <- merged_data[, mean_std]

###########################################################################
# 3. Uses descriptive activity names to name the activities in the data set
###########################################################################

act_names <- merge(merged_data, activity_labels,
                              by='activityId',
                              all.x=FALSE)

############################################################################
# Step 4 - Appropriately label the data set with descriptive variable names
############################################################################

# Task 4.1 Get the column names

act_cols <- colnames(act_names)

# Task 4.2 Remove special characters

act_cols <- gsub("[\\(\\)-]", "", act_cols)

# Task 4.3 Expand abbreviations and tidy column names

act_cols <- gsub("^f", "frequencyDomain", act_cols)
act_cols <- gsub("^t", "timeDomain", act_cols)
act_cols <- gsub("Acc", "Accelerometer", act_cols)
act_cols <- gsub("Gyro", "Gyroscope", act_cols)
act_cols <- gsub("Mag", "Magnitude", act_cols)
act_cols <- gsub("Freq", "Frequency", act_cols)
act_cols <- gsub("mean", "Mean", act_cols)
act_cols <- gsub("std", "StandardDeviation", act_cols)
act_cols <- gsub("BodyBody", "Body", act_cols)

colnames(act_names) <- act_cols

##############################################################################
# Step 5 - Create a second, independent tidy set with the average of each
#          variable for each activity and each subject
##############################################################################

# Task 5.1 Group data by subject and activity and summarise on mean

tidy_means <- ddply(act_names, c("subjectId","activityId", "activityType"), numcolwise(mean))

# Task 5.2 Output to both a .txt and .csv file

write.table(tidy_means, file = "tidyData.txt", row.name = FALSE, quote = FALSE)
fwrite(x = tidy_means, file = "tidyData.csv", quote = FALSE)
