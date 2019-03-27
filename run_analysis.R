library(data.table)

library(dplyr)


unzip(zipfile = "UCI HAR Dataset.zip")
setwd("C:/Users/Mahe/Documents/UCI HAR Dataset")



###Reading Activity files

ActiTest <- read.table("./test/y_test.txt", header = F)

ActiTrain <- read.table("./train/y_train.txt", header = F)



###Read features files

FeatureTest <- read.table("./test/X_test.txt", header = F)

FeatureTrain <- read.table("./train/X_train.txt", header = F)



#Read subject files

SubTest <- read.table("./test/subject_test.txt", header = F)

SubTrain <- read.table("./train/subject_train.txt", header = F)



####Read Activity Labels

ActiLabels <- read.table("./activity_labels.txt", header = F)



#####Read Feature Names

FeatureNames <- read.table("./features.txt", header = F)



#####Merge dataframes: Features Test & Train, Activity Test & Train, Subject Test & Train

FeatureData <- rbind(FeatureTest, FeatureTrain)

SubData <- rbind(SubTest, SubTrain)

ActiData <- rbind(ActiTest, ActiTrain)



####Renaming columns in ActivityData & ActivityLabels dataframes

names(ActiData) <- "ActivityN"

names(ActiLabels) <- c("ActivityN", "Activity")



####Get factor of Activity names

Activity <- left_join(ActiData, ActiLabels, "ActivityN")[, 2]



####Rename SubjectData columns

names(SubData) <- "Subject"

#Rename FeaturesData columns using columns from FeaturesNames

names(FeatureData) <- FeatureNames$V2



###Create one large Dataset with only these variables: SubjectData,  Activity,  FeaturesData

DataSet <- cbind(SubData, Activity)

DataSet <- cbind(DataSet, FeatureData)



###Create New datasets by extracting only the measurements on the mean and standard deviation for each measurement

subFeatureNames <- FeatureNames$V2[grep("mean\\(\\)|std\\(\\)", FeatureNames$V2)]

DataNames <- c("Subject", "Activity", as.character(subFeatureNames))

DataSet <- subset(DataSet, select=DataNames)



#####Rename the columns of the large dataset using more descriptive activity names

names(DataSet)<-gsub("^t", "time", names(DataSet))

names(DataSet)<-gsub("^f", "frequency", names(DataSet))

names(DataSet)<-gsub("Acc", "Accelerometer", names(DataSet))

names(DataSet)<-gsub("Gyro", "Gyroscope", names(DataSet))

names(DataSet)<-gsub("Mag", "Magnitude", names(DataSet))

names(DataSet)<-gsub("BodyBody", "Body", names(DataSet))



####Create a second, independent tidy data set with the average of each variable for each activity and each subject

SecondDataSet<-aggregate(. ~Subject + Activity, DataSet, mean)

SecondDataSet<-SecondDataSet[order(SecondDataSet$Subject,SecondDataSet$Activity),]



#Save this tidy dataset to local file

write.table(SecondDataSet, file = "C:/Users/Mahe/Documents/UCI HAR Dataset/tidydata.txt",row.name=FALSE)