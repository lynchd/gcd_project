# David Lynch
# Getting and Cleaning Data Course Project
library("dplyr");

# Some Helpers
fetchDataSetIfRequired <- function(URL, dest) {
  if(!file.exists(dest)) {  # There might still be a bug if a previous download partially completed. 
    download.file(URL, destfile = dest, method = "curl")
  }
}

unzipDataSetWithOverwrite <- function(file) {
  unzip(file, exdir=".", overwrite = TRUE)
}

# File names
zipFile <-"dataset.zip"                                              # Full archive as downloaded
featuresFile <- "UCI HAR Dataset/features.txt"                       # Variable names for samples in all sets
trainSetFile <- "UCI HAR Dataset/train/X_train.txt"                  # Training set file
trainLabelsFile <- "UCI HAR Dataset/train/y_train.txt"               # Activity labels that apply to the training set file
trainSubjectFile <- "UCI HAR Dataset/train/subject_train.txt"        # Subject records for training
testSetFile <- "UCI HAR Dataset/test/X_test.txt"                     # Test set file
testLabelsFile <- "UCI HAR Dataset/test/Y_test.txt"                  # Activity labels that apply to the test set file
testSubjectFile <- "UCI HAR Dataset/test/subject_test.txt"           # Subject records for test
activityLabelFile <- "UCI HAR Dataset/activity_labels.txt"           # Labels for activity levels
newLabelFile <- "new_headers.txt"                                    # Improved column headers

# Download and unzip the data
# This will leave a UCI HAR dataset folder in the working directory
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fetchDataSetIfRequired(URL, zipFile);
unzipDataSetWithOverwrite(zipFile);

# Load up the data
features <- read.table(featuresFile)
trainSet <- read.table(trainSetFile)
trainLabel <- read.table(trainLabelsFile)
trainSubject <- read.table(trainSubjectFile)
testSet <- read.table(testSetFile)
testLabel <- read.table(testLabelsFile)
testSubject <- read.table(testSubjectFile)
activityLabel <- read.table(activityLabelFile)
newHeaders <- read.table(newLabelFile)

# Apply meaningful column names to both data-sets
colnames(trainSet) <- features[,2]
colnames(trainLabel) <- c("label")
colnames(trainSubject) <- c("subject")

colnames(testSet) <- features[,2]
colnames(testLabel) <- c("label")
colnames(testSubject) <- c("subject")

# Extract only the measurements on the mean and std for each measurement.
getStdAndMeanColumns <- function(df) {
  return(df[,grepl("(mean|std)", names(df), ignore.case = TRUE)])
}

# Attach labels and subjects to the main set of observations
attachLabelsAndSubjects <- function(df, labels, subjects) {
  df <- mutate(df, activity_label=labels[,1])
  df <- mutate(df, subject_id=subjects[,1])
  return(df)
}

# Prepare both sets of data using the above functions
trainSubset <- getStdAndMeanColumns(trainSet)
trainSubset <- attachLabelsAndSubjects(trainSubset, trainLabel, trainSubject)

testSubset <- getStdAndMeanColumns(testSet)
testSubset <- attachLabelsAndSubjects(testSubset, testLabel, testSubject)

# Merge all observations together to create one dataset
mergedDf <- merge(trainSubset, testSubset, all=TRUE)

# Convert label column into a factor
mergedDf$activity_label <- factor(mergedDf$activity_label)

# Apply the labels to the levels
levels(mergedDf$activity_label) <- activityLabel[,2]

# Set improved column headers - see code book for details
colnames(mergedDf) <- newHeaders[,1] 

# Create new average data set that groups the data by subject ID and activity label. 
# Then apply the average of each numeric variable based on these groupings. 
averagesDf <- group_by(mergedDf, subject_id, activity_label) %>% summarise_each(funs(mean))
write.table(mergedDf, "dave-lynch-tidy-data.txt")