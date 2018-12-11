library(dplyr)

## Download Dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destination <- "C:\\Users\\11335\\Desktop\\Coursera\\Getting and Cleaning Data" 
download.file(url, destination)

## Unzip dataSet to /data directory
unzip(zipfile="./Coursera/Getting and Cleaning Data.zip",exdir="./Coursera/Getting and Cleaning Data")

## Read training tables:
X_train <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt')

## Read testing tables:
X_test <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt')

## Read feature vector:
features <- read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/features.txt')

## Read activity labels:
activityLabels = read.table('./Coursera/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt')

## Merge dataset
X_total <- rbind(X_train, X_test)
y_total <- rbind(y_train, y_test)
subject_total <- rbind(subject_train, subject_test)
 
 ## Extract only the measurements on the mean and standard deviation for each measurement
selected_var <- features[grep('mean\\(\\)|std\\(\\)', features[,2]),]
X_total <- X_total[,selected_var[,1]]
 
## Uses descriptive activity names to name the activities in the data set
colnames(y_total) <- 'Activity'
y_total$activityLabels <- factor(y_total$Activity, labels = as.character(activityLabels[,2]))
Activity <- y_total[,-1]
 
## Appropriately labels the data set with descriptive variable names
colnames(X_total) <- features[selected_var[,1],2]
 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(subject_total) <- 'Subject'
All <- cbind(X_total, Activity, subject_total)
Tidy <- All %>% group_by(Activity, Subject) %>% summarise_all(funs(mean))
write.table(Tidy, file = './Coursera/Getting and Cleaning Data/tidydata.txt', row.names = FALSE, col.names = TRUE)

