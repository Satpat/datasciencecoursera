# Getting and Cleaning Data Project John Hopkins Coursera




# 1. Merges the training and the test sets to create one data set.

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# 3. Uses descriptive activity names to name the activities in the data set

# 4. Appropriately labels the data set with descriptive variable names.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each


# Load Packages and get the Data

library(data.table)
library(dplyr)
unzip(zipfile = "UCI HAR Dataset.zip")
setwd("C:/Users/Mahe/Documents/UCI HAR Dataset")



# Reading Activity files

ActiTest <- read.table("./test/y_test.txt", header = F)
ActiTrain <- read.table("./train/y_train.txt", header = F)



# Reading features files

FeatureTest <- read.table("./test/X_test.txt", header = F)
FeatureTrain <- read.table("./train/X_train.txt", header = F)



# Reading subject files

SubTest <- read.table("./test/subject_test.txt", header = F)
SubTrain <- read.table("./train/subject_train.txt", header = F)



# Reading Activity Labels

ActiLabels <- read.table("./activity_labels.txt", header = F)



# Reading Feature Names

FeatureNames <- read.table("./features.txt", header = F)



# Merging dataframes: Features Test & Train, Activity Test & Train, Subject Test & Train

FeatureData <- rbind(FeatureTest, FeatureTrain)
SubData <- rbind(SubTest, SubTrain)
ActiData <- rbind(ActiTest, ActiTrain)



# Renaming columns in ActiData & ActiLabels dataframes

names(ActiData) <- "ActivityN"
names(ActiLabels) <- c("ActivityN", "Activity")



# Getting factor of Activity names

Activity <- left_join(ActiData, ActiLabels, "ActivityN")[, 2]



# Renaming SubData columns

names(SubData) <- "Subject"



# Rename FeaturesData columns using columns from FeaturesNames

names(FeatureData) <- FeatureNames$V2



# Creating one large Dataset with only these variables: SubjectData,  Activity,  FeaturesData

DataSet <- cbind(SubData, Activity)
DataSet <- cbind(DataSet, FeatureData)



# Creating new datasets by extracting only the measurements on the mean and standard deviation for each measurement

subFeatureNames <- FeatureNames$V2[grep("mean\\(\\)|std\\(\\)", FeatureNames$V2)]
DataNames <- c("Subject", "Activity", as.character(subFeatureNames))
DataSet <- subset(DataSet, select=DataNames)



# Renaming the columns of the large dataset using more descriptive activity names

names(DataSet)<-gsub("^t", "time", names(DataSet))
names(DataSet)<-gsub("^f", "frequency", names(DataSet))
names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))
names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))
names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))
names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))



# Creating a second, tidy data set with the mean of each variable for each activity and each subject

SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)
SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]



# Saving this tidy dataset to local file

write.table(SecondDataSet, file = "C:/Users/Mahe/Documents/UCI HAR Dataset/tidydata.txt",row.name=FALSE)
