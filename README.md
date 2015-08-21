# README
This project cleans and tidies a raw data set of mobile sensor that attempts to tie human activity to data recorded on sensors. Here is the abstract from the data set README.

## Background
```
Human Activity Recognition Using Smartphones Dataset
Version 1.0
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
activityrecognition@smartlab.ws
www.smartlab.ws
==================================================================
```


The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.


## Execute
To run the data clean, execute *run_analysis.R*.
The analysis is fully self contained, and fetches the raw data from the internet. Therefore make sure you have an internet connection. 

1. Results for the raw clean data are written to *merged-clean-data.txt*
2. Results for the grouped and averaged data are written to *ave_by_subject_and_activity.txt*

## How it works
The processing steps are as follows. 

1. Download source data file.
2. Extract the source data file. 
3. Load up the subject file, feature file (with variable names), label file and raw observations for both the training and test sets. 
4. Apply the original feature names to the variable names of the column sets. 
5. Strip out the variables that are not based on mean or std-dev. 
6. Merge in the subject column and the label column for both sets.
7. Merge both sets of observations together to form one set. 
8. Apply a 'cleaned up' set of variable names to the resulting data set. 
9. Write out the file merged-clean-data.txt
9. Reduce to 180 observations by grouping the set from step 8 by subject, activity label and mean of the numeric variables. 
10. Write out the file ave_by_subject_and_activity.txt as an independent data set. 

## More details
See [CodeBook.md](https://github.com/lynchd/gcd_project/blob/master/CodeBook.md) for more detailed information on the tidied data set including why the data is tidy and things like new variable names.  
