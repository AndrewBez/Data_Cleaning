---
title: "Code_Description"
author: "Andrew"
date: "September 20, 2019"
output: html_document
---


## HOW THE CODE WORKS

The attached code merges test and train datasets, gives the variables descriptive names and, computes means by subject and activity, and outputs the results in "tidy.txt" file.

To set working directory replace *** with the path to your working directory

```
setwd("***")
```

We initialize the library plyr to use it below

```
library(plyr)
```

The code reads the test and train datasets as well as subject numbers and activity numbers for the observations

```
test_data <- read.table("./test/X_test.txt")
train_data <- read.table("./train/X_train.txt")

subject_test <- read.table("./test/subject_test.txt")
activity_test <- read.table("./test/y_test.txt")
subject_train <- read.table("./train/subject_train.txt")
activity_train <- read.table("./train/y_train.txt")
```

We plan to label each subject as "Subject #" instead of just "#". For instance, we want subject number two labeled "Subject 2" instead of just "2". To accomplish that we create a column of "Subject", column of "#" and concatenate them.

```
sbj_test_lbl <- as.data.frame(cbind("Subject",subject_test$V1," "))
sbj_test_lbl$V3 <- paste(sbj_test_lbl$V1,sbj_test_lbl$V2)
sbj_train_lbl <- as.data.frame(cbind("Subject",subject_train$V1," "))
sbj_train_lbl$V3 <- paste(sbj_train_lbl$V1,sbj_train_lbl$V2)
```

Next we change the activity labels from activity numbers to actual activity names
```
activity_lbl <- read.table("./activity_labels.txt")

act_test_lbl <- mapvalues(activity_test$V1,from = activity_lbl$V1, to = as.character(activity_lbl$V2))
act_train_lbl <- mapvalues(activity_train$V1,from = activity_lbl$V1, to = as.character(activity_lbl$V2))
```

Then the code joins subject and activity names with the corresponding data
```
test <- cbind(sbj_test_lbl$V3,act_test_lbl,test_data)
train <- cbind(sbj_train_lbl$V3,act_train_lbl,train_data)
```

Then we assing a name the subject and activity columns
```
colnames(test)[1:2] <- c("Subject", "Activity")
colnames(train)[1:2] <- c("Subject", "Activity")
```

On the next step code merges test and train datasets
```
combined <- rbind(train,test)
```

Then the code gives the variables descriptive names according to the downloaded description
```
features <- read.table("./features.txt")

colnames(combined)[3:563] <- as.character(features$V2)
```

Next we subset the dataset to extract only the measurements on the mean and standard deviation

```
select_features <- combined[,c(1,2,grep("-mean",colnames(combined)), grep("-std",colnames(combined)))]
```

Compute mean of each variable for each activity and each subject
```
results <- aggregate(select_features[3:81],select_features[2:1],mean)
```

Output the results
```
write.table(results,file = "./tidy.txt",row.names = FALSE)
```

##VARIABLES

Subject: Subject number
Activity: Activity name


'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag


for each of the signals above the following variables were retained:

mean(): Mean value

std(): Standard deviation


The entries of the dataset are means of the variables described above grouped by each subject and activity name.
