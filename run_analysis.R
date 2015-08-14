## David Lynch
## Getting and Cleaning Data Course Project

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

## 0 - Download and unzip the data
## This will leave a UCI HAR dataset folder in the working directory
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <-"dataset.zip"
fetchDataSetIfRequired(URL, zipFile);
unzipDataSetWithOverwrite(zipFile);

## 1 - Merge the training and test sets to create one data set.

## 2 - Extract only the measurements on the mean and stdev for each measurement.

## 3 - Use descriptive activity names to name the activities in the data set.

## 4 - Appropriately label the data set with descriptive variable names

## 5 - From the results of step 4, create a second, independent tidy data set with the avergae of each variable for each activity and each subject. 





