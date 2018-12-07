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

## Assign column names:
colnames(X_train) <- features[,2] 
colnames(y_train) <-"ActivityId"
colnames(subject_train) <- "SubjectId"
 
colnames(X_test) <- features[,2] 
colnames(y_test) <- "ActivityId"
colnames(subject_test) <- "SubjectId"
 
colnames(activityLabels) <- c('ActivityId','ActivityType')
 
## Merge all data in one set:
Train <- cbind(y_train, subject_train, X_train)
Test <- cbind(y_test, subject_test, X_test)
Data <- setAllInOne <- rbind(Train, Test)

## Extract the measurements on the mean and standard deviation:
# Read column names:
DataCol <- colnames(Data)

# Create vector for defining ID, mean and standard deviation:
mean_and_std <- (grepl("ActivityId" , DataCol) | 
                 grepl("SubjectId" , DataCol) | 
                 grepl("mean.." , DataCol) | 
                 grepl("std.." , DataCol) 
                 )

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

## Using descriptive activity names to name the activities in the data set:
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='ActivityId',
                              all.x=TRUE)

## Make a tidy data set:
TidySet <- aggregate(. ~SubjectId + ActivityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$SubjectId, TidySet$ActivityId),]

write.table(TidySet, "./Coursera/Getting and Cleaning Data/UCI HAR Dataset/TidySet.txt", row.name=FALSE)

