library(data.table)
library(dplyr)
ftN <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/features.txt")
actL <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/activity_labels.txt", header = FALSE)
subTrn <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjectTest <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
actTST <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/test/y_test.txt", header = FALSE)
fTest <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/test/X_test.txt", header = FALSE)
actTrn <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/train/y_train.txt", header = FALSE)
fetTrn <- read.table("C:/Users/saeed/Desktop/hti/programnig/R/ass.4/UCI HAR Dataset/train/X_train.txt", header = FALSE)
subject <- rbind(subTrn, subjectTest)
activity <- rbind(actTrn, actTST)
features <- rbind(fetTrn, fTest)
colnames(features) <- t(ftN[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
completeData <- cbind(features,activity,subject)
columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
requiredColumns <- c(columnsWithMeanSTD, 562, 563)
dim(completeData)
extractedData <- completeData[,requiredColumns]
dim(extractedData)
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(actl[i,2])
}
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(actL[i,2])
}
extractedData$Activity <- as.factor(extractedData$Activity)
names(extractedData)
names(extractedData)<-gsub("Acc", "Accelerometer", names(extractedData))
names(extractedData)<-gsub("Gyro", "Gyroscope", names(extractedData))
names(extractedData)<-gsub("BodyBody", "Body", names(extractedData))
names(extractedData)<-gsub("Mag", "Magnitude", names(extractedData))
names(extractedData)<-gsub("^t", "Time", names(extractedData))
names(extractedData)<-gsub("^f", "Frequency", names(extractedData))
names(extractedData)<-gsub("tBody", "TimeBody", names(extractedData))
names(extractedData)<-gsub("-mean()", "Mean", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-std()", "STD", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("-freq()", "Frequency", names(extractedData), ignore.case = TRUE)
names(extractedData)<-gsub("angle", "Angle", names(extractedData))
names(extractedData)<-gsub("gravity", "Gravity", names(extractedData))
names(extractedData)
extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)
tidyData <- aggregate(. ~Subject + Activity, extractedData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)

