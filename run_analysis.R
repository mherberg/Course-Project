# The purpose of this project is to demonstrate your ability to collect, work
# with, and clean a data set. The goal is to prepare tidy data that can be used
# for later analysis. You will be graded by your peers on a series of yes/no
# questions related to the project. You will be required to submit: 1) a tidy
# data set as described below, 2) a link to a Github repository with your script
# for performing the analysis, and 3) a code book that describes the variables,
# the data, and any transformations or work that you performed to clean up the
# data called CodeBook.md. You should also include a README.md in the repo with
# your scripts. This repo explains how all of the scripts work and how they are
# connected.
#
# One of the most exciting areas in all of data science right now is wearable
# computing - see for example this article . Companies like Fitbit, Nike, and
# Jawbone Up are racing to develop the most advanced algorithms to attract new
# users. The data linked to from the course website represent data collected
# from the accelerometers from the Samsung Galaxy S smartphone. A full
# description is available at the site where the data was obtained:
#
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
#
# Here are the data for the project:
#
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#
# You should create one R script called run_analysis.R that does the following.
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the
#    average of each variable for each activity and each subject.
#
# Good luck!

library(data.table)

# 'features.txt': List of all features.
# 'activity_labels.txt': Links the class labels with their activity name.
features <- fread("UCI HAR Dataset/features.txt")
activity_labels <- fread("UCI HAR Dataset/activity_labels.txt")

# 'train/X_train.txt': Training set. 'train/y_train.txt': Training labels.
# 'train/subject_train.txt': Each row identifies the subject who performed the
# activity for each window sample. Its range is from 1 to 30.
train <- fread("UCI HAR Dataset/train/X_train.txt")
y_train <- fread("UCI HAR Dataset/train/y_train.txt")
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt")

# 4. Appropriately labels the data set with descriptive variable names.
colnames(train) <- features$V2
train$activity <- y_train$V1
train$subject <- factor(subject_train$V1)

# 'test/X_test.txt': Test set. 'test/y_test.txt': Test labels.
# 'test/subject_test.txt': Each row identifies the subject who performed the
# activity for each window sample. Its range is from 1 to 30.
test <- fread("UCI HAR Dataset/test/X_test.txt")
y_test <- fread("UCI HAR Dataset/test/y_test.txt")
subject_test <- fread("UCI HAR Dataset/test/subject_test.txt")

# 4. Appropriately labels the data set with descriptive variable names.
colnames(test) <- features$V2
test$activity <- y_test$V1
test$subject <- factor(subject_test$V1)

# 1. Merges the training and the test sets to create one data set.
data <- rbind(test, train)

# 2. Extracts only the measurements on the mean and standard deviation for each
#    measurement.
measurements <- grep("std\\(\\)|mean\\(\\)",
                           colnames(data),
                           value = TRUE
                           )
measurements <- c(measurements, "subject", "activity")

data.filt <- data[, ..measurements]

# 3. Uses descriptive activity names to name the activities in the data set
data.filt$activity <- activity_labels$V2[match(data.filt$activity, activity_labels$V1)]

# 5. From the data set in step 4, creates a second, independent tidy data set with the
#    average of each variable for each activity and each subject.
data.tidy <- aggregate(. ~subject + activity, data.filt, mean)
write.table(data.tidy, "tidydata.txt", row.names = FALSE)


