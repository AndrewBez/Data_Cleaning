#set working directory
#replace *** with the path to your working directory
setwd("***")

#library plyr will be used below
library(plyr)

#read test and train data
test_data <- read.table("./test/X_test.txt")
train_data <- read.table("./train/X_train.txt")

#read subject numbers and activity numbers for the observations in test and train data
subject_test <- read.table("./test/subject_test.txt")
activity_test <- read.table("./test/y_test.txt")
subject_train <- read.table("./train/subject_train.txt")
activity_train <- read.table("./train/y_train.txt")

#we plan to label each subject as "Subject #" instead of just "#"
#here we create a column of "Subject #"
sbj_test_lbl <- as.data.frame(cbind("Subject",subject_test$V1," "))
sbj_test_lbl$V3 <- paste(sbj_test_lbl$V1,sbj_test_lbl$V2)
sbj_train_lbl <- as.data.frame(cbind("Subject",subject_train$V1," "))
sbj_train_lbl$V3 <- paste(sbj_train_lbl$V1,sbj_train_lbl$V2)

#read activity names dictionary
activity_lbl <- read.table("./activity_labels.txt")

#use activity name dictionary to replace the activity numbers with activity names
act_test_lbl <- mapvalues(activity_test$V1,from = activity_lbl$V1, to = as.character(activity_lbl$V2))
act_train_lbl <- mapvalues(activity_train$V1,from = activity_lbl$V1, to = as.character(activity_lbl$V2))

#merge subject and activity name with the corresponding data
test <- cbind(sbj_test_lbl$V3,act_test_lbl,test_data)
train <- cbind(sbj_train_lbl$V3,act_train_lbl,train_data)

#name the subject and activity columns
colnames(test)[1:2] <- c("Subject", "Activity")
colnames(train)[1:2] <- c("Subject", "Activity")

#merge test and training datasets
combined <- rbind(train,test)

#read feature names
features <- read.table("./features.txt")

#use feature names to give the variables descriptive names
colnames(combined)[3:563] <- as.character(features$V2)

#extract only the measurements on the mean and standard deviation
select_features <- combined[,c(1,2,grep("-mean",colnames(combined)), grep("-std",colnames(combined)))]

#create a dataframe with the mean of each variable for each activity and each subject
results <- aggregate(select_features[3:81],select_features[2:1],mean)

#write the resulting dataset to a txt file
write.table(results,file = "./tidy.txt",row.names = FALSE)
