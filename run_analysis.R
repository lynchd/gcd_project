## David Lynch
## Getting and Cleaning Data Course Project
library("dplyr");

## Some Helpers
fetchDataSetIfRequired <- function(URL, dest) {
  if(!file.exists(dest)) {  # There might still be a bug if a previous download partially completed. 
    download.file(URL, destfile = dest, method = "curl")
  }
}

unzipDataSetWithOverwrite <- function(file) {
  unzip(file, exdir=".", overwrite = TRUE)
}
## End Helpers

## File names
zipFile <-"dataset.zip"                                              # Full archive as downloaded
featuresFile <- "UCI HAR Dataset/features.txt"                       # Variable names for samples in all sets
trainSetFile <- "UCI HAR Dataset/train/X_train.txt"                  # Training set file
trainLabelsFile <- "UCI HAR Dataset/train/y_train.txt"               # Activity labels that apply to the training set file
trainSubjectFile <- "UCI HAR Dataset/train/subject_train.txt"        # Subject records for training
testSetFile <- "UCI HAR Dataset/test/X_test.txt"                     # Test set file
testLabelsFile <- "UCI HAR Dataset/test/Y_test.txt"                  # Activity labels that apply to the test set file
testSubjectFile <- "UCI HAR Dataset/test/subject_test.txt"           # Subject records for test

## 0 - Download and unzip the data
## This will leave a UCI HAR dataset folder in the working directory
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

fetchDataSetIfRequired(URL, zipFile);
unzipDataSetWithOverwrite(zipFile);

## Load up the data
features <- read.table(featuresFile)
trainSet <- read.table(trainSetFile)
trainLabel <- read.table(trainLabelsFile)
trainSubject <- read.table(trainSubjectFile)
testSet <- read.table(testSetFile)
testLabel <- read.table(testLabelsFile)
testSubject <- read.table(testSubjectFile)

## 1 - Merge the training and test sets to create one data set.
colnames(trainSet) <- features[,2]
colnames(trainLabel) <- c("label")
colnames(trainSubject) <- c("subject")

colnames(testSet) <- features[,2]
colnames(testLabel) <- c("label")
colnames(testSubject) <- c("subject")

## 2 - Extract only the measurements on the mean and stdev for each measurement.
# This should be done by selecting the columns that contain 'mean' and 'std'
getStdAndMeanColumns <- function(df) {
  return(df[,grepl("(mean|std)", names(trainSet), ignore.case = TRUE)])
}



trainSubset <- getStdAndMeanColumns(trainSet) %>>% mutate(label=trainLabel[,1]) %>>% mutate(subject=trainSubject[,1])

testSubset <- getStdAndMeanColumns(testSet)



## 3 - Use descriptive activity names to name the activities in the data set.

## 4 - Appropriately label the data set with descriptive variable names

## 5 - From the results of step 4, create a second, independent tidy data set with the avergae of each variable for each activity and each subject. 





