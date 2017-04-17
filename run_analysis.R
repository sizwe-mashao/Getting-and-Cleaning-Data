setwd("C:/Users/ShopDemo/Desktop/Data & analytics/Getting and cleaning data/Project Assignment")

library(dplyr)
library(data.table)
library(tidyr)

Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("samsung_data.zip")) {download.file(Url, "samsung_data.zip")}
if(!file.exists("samsung_data")) {unzip("samsung_data.zip", exdir = "samsung_data")}

setwd("C:/Users/ShopDemo/Desktop/Data & analytics/Getting and cleaning data/Project Assignment/samsung_data/UCI HAR Dataset")


features        <- read.table("./features.txt",header=F)
activity_labels   <- read.table("./activity_labels.txt",header=F)
subject_train    <-read.table("./train/subject_train.txt", header=F)
x_train          <- read.table("./train/X_train.txt", header=F)
y_train          <- read.table("./train/y_train.txt", header=F)



names(activity_labels)<-c("activity_ID","activity_type")
names(features) <- c("number","name")
names(x_train) <- features$name
names(y_train) <- "activity_ID"
names(subject_train) <- "subject_ID"




subject_test    <-read.table("./test/subject_test.txt", header=F)
x_test         <- read.table("./test/X_test.txt", header=F)
y_test         <- read.table("./test/y_test.txt", header=F)



names(subject_test) <- "subject_ID"
names(x_test) <- features$name
names(y_test) <- "activity_ID"

data_test <- cbind(y_test,subject_test,x_test)
data_train <- cbind(y_train,subject_train,x_train)



data_final <- rbind(data_train,data_test)


###Extracts only the measurements on the mean and standard deviation for each measurement.
colNames <- names(data_final)
mean_std_names <- grepl("mean|std|ID",colNames)
mean_std_names_index <-  which(mean_std_names)
data_mean_and_std <- data_final[,mean_std_names_index]

##Uses descriptive activity names to name the activities in the data set

data_mean_and_std$activity_ID <- as.character(data_mean_and_std$activity_ID)
data_mean_and_std$activity_ID[data_mean_and_std$activity_ID == 1] <- "Walking"
data_mean_and_std$activity_ID[data_mean_and_std$activity_ID == 2] <- "Walking Upstairs"
data_mean_and_std$activity_ID[data_mean_and_std$activity_ID == 3] <- "Walking Downstairs"
data_mean_and_std$activity_ID[data_mean_and_std$activity_ID == 4] <- "Sitting"
data_mean_and_std$activity_ID[data_mean_and_std$activity_ID == 5] <- "Standing"
data_mean_and_std$activity_ID[data_mean_and_std$activity_ID == 6] <- "Laying"
data_mean_and_std$activity_ID <- as.factor(data_mean_and_std$activity_ID)
 
##Appropriately labels the data set with descriptive variable names.

names(data_mean_and_std) <- gsub("Acc", "Accelerator", names(data_mean_and_std))
names(data_mean_and_std) <- gsub("Mag", "Magnitude", names(data_mean_and_std))
names(data_mean_and_std) <- gsub("Gyro", "Gyroscope", names(data_mean_and_std))
names(data_mean_and_std) <- gsub("^t", "time", names(data_mean_and_std))
names(data_mean_and_std) <- gsub("^f", "frequency", names(data_mean_and_std))

##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and each subject.

tidy.dt <- data.table(data_mean_and_std)
tidy_data <- tidy.dt[, lapply(.SD, mean), by = 'subject_ID,activity_ID']
write.table(tidy_data, file = "tidy.txt", row.names = FALSE)





