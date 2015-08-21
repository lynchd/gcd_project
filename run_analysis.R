# David Lynch
# Getting and Cleaning Data Course Project
library("dplyr");

# Some Helpers
fetchDataSetIfRequired <- function(URL, dest) {
  if(!file.exists(dest)) {  # There might still be a bug if a previous download partially completed. 
    print("Downloading data - this might take a minute.")
    download.file(URL, destfile = dest, method = "curl")
  } else {
    print("Zip file already downloaded. Not repeating.")
  }
}

unzipDataSetWithOverwrite <- function(file) {
  unzip(file, exdir=".", overwrite = TRUE)
}

# Download and unzip the data
# This will leave a UCI HAR dataset folder in the working directory
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fetchDataSetIfRequired(URL, "dataset.zip" );
unzipDataSetWithOverwrite("dataset.zip" );

dataRoot <- "UCI HAR Dataset"

# Load up the data
print("Loading data - this might take a minute.")
features <- read.table(file.path(dataRoot, "features.txt"))
trainSet <- read.table(file.path(dataRoot, "train", "X_train.txt"))
trainLabel <- read.table(file.path(dataRoot, "train", "y_train.txt"))
trainSubject <- read.table(file.path(dataRoot, "train", "subject_train.txt"))
testSet <- read.table(file.path(dataRoot, "test", "X_test.txt"))
testLabel <- read.table(file.path(dataRoot, "test", "y_test.txt"))
testSubject <- read.table(file.path(dataRoot, "test", "subject_test.txt"))
activityLabel <- read.table(file.path(dataRoot, "activity_labels.txt"))

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

# Set improved column headers - specified in different file see code book for details
newHeaders <- read.table("new_headers.txt")
colnames(mergedDf) <- newHeaders[,1] 
write.table(mergedDf, "merged-clean-data.txt")

# Create new average data set that groups the data by subject ID and activity label. 
# Then apply the average of each numeric variable based on these groupings. 
averagesDf <- group_by(mergedDf, subject_id, activity_label) %>% summarise_each(funs(mean))
write.table(averagesDf, "ave_by_subject_and_activity.txt", row.name=FALSE)

print("Cleaning job done!")