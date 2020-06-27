library(dplyr)
library(tidyverse)
install.packages("codebook")
library(codebook)

#donwload zipped files from URL and then unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "files", mode = "wb")
unzip("files")

#reading all tables
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("serial", "Functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("serial", "Activity"))
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "serial")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "serial")

#row bind the test and train values
binded_x <- rbind(x_test, x_train)
binded_y <- rbind(y_test, y_train)
subject <- rbind(subject_test, subject_train)

#column bind the three different attributes
raw_data_combined <- cbind(subject, binded_x, binded_y)

#select only mean and std columns
analysis <- raw_data_combined %>%
  select(serial, subject, contains("mean"), contains("std")) 

#changing activity labels from their numeric values to characters
analysis$serial[analysis$serial == '1'] <- 'WALKING'
analysis$serial[analysis$serial == '2'] <- 'WALKING_UPSTAIRS'
analysis$serial[analysis$serial == '3'] <- 'WALKING_DOWNSTAIRS'
analysis$serial[analysis$serial == '4'] <- 'SITTING'
analysis$serial[analysis$serial == '5'] <- 'STANDING'
analysis$serial[analysis$serial == '6'] <- 'LAYING'

#making columns more readable
names(analysis)<- gsub("Acc", "Accelerometer", names(analysis))
names(analysis)<- gsub("tBody", "time", names(analysis))
names(analysis)<- gsub("fBody", "frequency", names(analysis))
names(analysis)<- gsub("Gyro", "Gyroscope", names(analysis))
names(analysis)<-gsub("BodyBody", "Body", names(analysis))
names(analysis)<-gsub("Mag", "Magnitude", names(analysis))
names(analysis)<-gsub("serial", "Activity", names(analysis))
names(analysis)

#taking mean of all columns based on subject and activity
tidy_data <- analysis %>%
  group_by(subject, Activity) %>%
  summarise_all(list(mean))

write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)
