####################################################################################################
##  Pablo del Amor Saavedra 
##  run_analysis.R 
# 1.- Merges the training and the test sets to create one data set.
# 2.- Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.- Uses descriptive activity names to name the activities in the data set
# 4.- Appropriately labels the data set with descriptive variable names.
#
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
####################################################################################################

# Install package readr for read_delim function
if(!require("readr")){
    install.packages("readr")
    library(readr)
}

# We use reshape2 package for dmelt and dcast functions
if(!require("reshape2")){
    install.packages("reshape2")
    library(reshape2)
}


# Create "data" folder if it doesn't exist
if (!file.exists("./data")) { dir.create("./data") }

# Download source data and unzip to data folder if it doesn't exist
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./data/dataset.zip")) {
    download.file(fileURL,destfile="./data/dataset.zip",method="curl")
    unzip("./data/dataset.zip",exdir="./data")
}

#  Data format:
# Each row:  total acel(x,y,z) | body acel (x,y,z) | gyro vel (x,y,z) | (1,.,561) feature | Activity | Subject_Id

#Inertial Signals - NOT NEEDED - ONLY NEED mean and standard deviation FEATURES (Point 2)
# in .data/Test or Train / Inertial Signals/ body_acc_xyz and body_gyro_xyz and total_acc_xyz_ for test and train

# ACTIVITY LABELS -> V1 value V2 text
activity_labels <- read.csv("./data/UCI HAR Dataset/activity_labels.txt",header=FALSE,sep=" ")

# READ TEST AND TRAIN DATA AND FORMAT DATA FRAMES PRIOR MERGING

# TEST #########################################################################################
# Reads 561 columns / 2947 rows
feature_test <-  read_delim("./data/UCI HAR Dataset/test/X_test.txt",delim=" ",col_names=FALSE) 

# Add new column settype "test"
feature_test$settype="test"

# Reads  2947 rows
activity_test <-  read_delim("./data/UCI HAR Dataset/test/y_test.txt",delim=" ",col_names=FALSE) 

# Convert activity codes into lower case label:
activity_test <- factor(activity_test$X1,levels=unique(activity_test$X1),labels=tolower(activity_labels$V2))
# Add activity to data frame
feature_test$activity=activity_test

# Reads  2947 rows
subject_test <- read_delim("./data/UCI HAR Dataset/test/subject_test.txt",delim=" ",col_names=FALSE) 
# Add subject to data frame
feature_test$subjectid=subject_test$X1

# TRAIN #########################################################################################
# Reads 561 columns / 7352 rows
feature_train <-  read_delim("./data/UCI HAR Dataset/train/X_train.txt",delim=" ",col_names=FALSE) 

# Add new column settype "train"
feature_train$settype="train"

# Reads  7352 rows
activity_train <-  read_delim("./data/UCI HAR Dataset/train/y_train.txt",delim=" ",col_names=FALSE) 

# Convert activity codes into lower case label:
activity_train <- factor(activity_train$X1,levels=unique(activity_train$X1),labels=tolower(activity_labels$V2))
# Add activity to data frame
feature_train$activity=activity_train

# Reads  7352 rows
subject_train <- read_delim("./data/UCI HAR Dataset/train/subject_train.txt",delim=" ",col_names=FALSE) 
# Add subject to data frame
feature_train$subjectid=subject_train$X1

# Read FEATURE LABELS
feature_labels <- feature <- read_delim("./data/UCI HAR Dataset/features.txt",delim=" ",col_names = FALSE)

# Rename COLS
colnames(feature_test)=c(feature_labels$X2,"settype","activity","subjectid")
colnames(feature_train)=c(feature_labels$X2,"settype","activity","subjectid")

# FILTER DATA SETS WITH MEAN AND STD DEVIATION MEASUREMENTS ONLY
patterns <- c("std()","mean()","settype","activity","subjectid")

feature_test <- feature_test[, grepl(paste(patterns, collapse="|"), names(feature_test))]
feature_train <- feature_train[, grepl(paste(patterns, collapse="|"), names(feature_train))]

# 1 .- MERGE TEST AND TRAIN DATA SETS:
mergedf <- merge(feature_test,feature_train,all=TRUE)

View(mergedf)

# 5.- New dataset with the average of each variable for each activity and each subject

# Convert character columns to numeric for average calculation 
mergedf[,1:79] <- sapply(mergedf[,1:79] , as.numeric)

# melt data , long and short group by activity and subjectid
dfmelt <- melt(mergedf,id=c("activity","subjectid"), measure.vars=c(1:79) , na.rm=TRUE)

# cast and get average by activiy and subjectid
dfcast <- dcast(dfmelt, activity ~ variable + subjectid, mean )

View(dfcast)

# Export data frame into file final.txt
write.table(dfcast, "final.txt",row.names=FALSE)
