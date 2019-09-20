
# Study design.

Run_analysis.R script is the only script that turns the data from the experiments into the data set required with the following conditions:


1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement.

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


We use readr and reshape packages, for the read_delim and melt and dcast functions.

We create "data" folder if it doesn't exist then  Download source data and unzip to data folder if it doesn't exist.
Data format:
Each row:  total acel(x,y,z) | body acel (x,y,z) | gyro vel (x,y,z) | (1,.,561) feature | Activity | Subject_Id

Inertial Signals - NOT NEEDED - ONLY NEED mean and standard deviation FEATURES (Point 2)
in .data/Test or Train / Inertial Signals/ body_acc_xyz and body_gyro_xyz and total_acc_xyz_ for test and train.

We read test and train data and format data frames prior merging.

For the TEST and TRAIN data we reads 561 columns / 2947 rows feature data
then we add new column settype "test".
We read activity codes from the y_xxx.txt and then convert activity codes into lower case label, then we add activity to data frame and read subject and add it to data frame

Then we rename new columns to "settype", "activity" and "subjectid"
and filter data sets with mean and std deviation measurements only

Then we merge test and train data sets with the merge function

For the dataset with the average of each variable for each activity and each subject

We convert  character columns to numeric for average calculation 
and  melt data , long and short group by activity and subjectid
then we cast and get average by activiy and subjectid to the new dfcast data frame.

# About the source data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 


# Code Book

## DATA SETS

###  **mergedf** Data frame

VARS:

* tBodyAcc-mean()-X             * tBodyAcc-mean()-Y              * tBodyAcc-mean()-Z

* tBodyAcc-std()-X               * tBodyAcc-std()-Y               * tBodyAcc-std()-Z

* tGravityAcc-mean()-X            * tGravityAcc-mean()-Y            * tGravityAcc-mean()-Z

* tGravityAcc-std()-X             * tGravityAcc-std()-Y             * tGravityAcc-std()-Z

* tBodyAccJerk-mean()-X          * tBodyAccJerk-mean()-Y          * tBodyAccJerk-mean()-Z

* tBodyAccJerk-std()-X           * tBodyAccJerk-std()-Y           * tBodyAccJerk-std()-Z

* tBodyGyro-mean()-X             * tBodyGyro-mean()-Y             * tBodyGyro-mean()-Z

* tBodyGyro-std()-X              * tBodyGyro-std()-Y              * tBodyGyro-std()-Z

* tBodyGyroJerk-mean()-X         * tBodyGyroJerk-mean()-Y         * tBodyGyroJerk-mean()-Z

* tBodyGyroJerk-std()-X          * tBodyGyroJerk-std()-Y          * tBodyGyroJerk-std()-Z

* tBodyAccMag-mean()              * tBodyAccMag-std()           * tGravityAccMag-mean()

* tGravityAccMag-std()         * tBodyAccJerkMag-mean()          * tBodyAccJerkMag-std()

* tBodyGyroMag-mean()             * tBodyGyroMag-std()        * tBodyGyroJerkMag-mean()

* tBodyGyroJerkMag-std()               * fBodyAcc-mean()-X        *BodyAcc-mean()-Y

* fBodyAcc-mean()-Z                * fBodyAcc-std()-X                * fBodyAcc-std()-Y

* fBodyAcc-std()-Z           * fBodyAcc-meanFreq()-X           * fBodyAcc-meanFreq()-Y

* fBodyAcc-meanFreq()-Z           * fBodyAccJerk-mean()-X         * fBodyAccJerk-mean()-Y

* fBodyAccJerk-mean()-Z            * fBodyAccJerk-std()-X         * fBodyAccJerk-std()-Y

* fBodyAccJerk-std()-Z       * fBodyAccJerk-meanFreq()-X       * fBodyAccJerk-meanFreq()-Y

* fBodyAccJerk-meanFreq()-Z              * fBodyGyro-mean()-X      * fBodyGyro-mean()-Y

* fBodyGyro-mean()-Z               * fBodyGyro-std()-X               * fBodyGyro-std()-Y

* fBodyGyro-std()-Z          * fBodyGyro-meanFreq()-X          * fBodyGyro-meanFreq()-Y

* fBodyGyro-meanFreq()-Z              * fBodyAccMag-mean()         * fBodyAccMag-std()

* fBodyAccMag-meanFreq()      * fBodyBodyAccJerkMag-mean()    * fBodyBodyAccJerkMag-std()

* fBodyBodyAccJerkMag-meanFreq()     * fBodyBodyGyroMag-mean()    * fBodyBodyGyroMag-std()

* fBodyBodyGyroMag-meanFreq()  * fBodyBodyGyroJerkMag-mean()  * fBodyBodyGyroJerkMag-std()

* fBodyBodyGyroJerkMag-meanFreq()    * settype      * activity        * subjectid 
                       
                      
	* Variables: from 1 to 79, **numeric**,  are sensor standard deviation or mean values (-std / -mean) .
	* Variables from 80 to 82, are **characters**
	* settype, which can be "train" or "test" indicating the source of the sensor data.
	* activity which can be WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS , SITTING , STANDING or LAYING
	* subjectid which is a numeric value from 1 to 30, an identifier of the subject who carried out the experiment.
    
    
###  **dfcast** Data frame
    
	* Same 1 to 79 variables from mergedf data frame but for each subjectid, ie, tBodyAcc-mean()-X\_1, which is tBodyAcc-mean()-X average for subject 1, and grouped by activity in each row, row 1 to 6 is avarage for activity walking, walking_upstairs, walking\_downstairs, sitting, standing and laying.
	* Total 2371 columns and 6 rows.
    
    This data frame is exported in CSV format to **final.csv**
    