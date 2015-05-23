#Step1:
#Merge the training and test sets to create one dataset

trainX<-read.table("./UCI HAR DATASET/train/X_train.txt")
trainY<-read.table("./UCI HAR DATASET/train/y_train.txt")
trainSub <- read.table("./UCI HAR DATASET/train/subject_train.txt")

testX<-read.table("./UCI HAR DATASET/test/X_test.txt")
testY<-read.table("./UCI HAR DATASET/test/y_test.txt")
testSub <- read.table("./UCI HAR DATASET/test/subject_test.txt")

#Merging the data as per the step one
dataX<-rbind(trainX,testX)
dataY<-rbind(trainY,testY)
dataSub<-rbind(trainSub,testSub)

#Step 2:
#Extracts only the measurements on the mean and standard deviation for each measurement
#features read the file features from the given data set
features<- read.table("./UCI HAR DATASET/features.txt")
#reqInd gets the indices of only mean and standard deviation ignoring brackets
reqInd <- grep("mean\\(\\)|std\\(\\)",features[,2])
#Merge in the dataX with the appropriate data
dataX<- dataX[,reqInd]
names(dataX) <-gsub("\\(\\)","",features[reqInd,2])
names(dataX) <-gsub("-","",names(dataX))

#Step 3:
#Uses descriptive activity names to name the activities
activitylabel <- read.table("./UCI HAR DATASET/activity_labels.txt")
#Give the appropraite label from the Data Set Y and merging with activity labels
activity<-activitylabel[dataY[,1],2]
dataY[,1]<-activity
names(dataY)<-"activity"

#Step 4:
#Appropriately labels the data set with descriptive variable names
names(dataSub)<-"subject"
#Merge all the data and give one tidy data set
gooddata<-cbind(dataSub,dataY,dataX)

#Step 5:
#Creates a Second and independent tidy data set with the average 
#of variable for each activity and each subject
library(reshape2)
#Reshape2 library to combine each activity and subject
data<-melt(gooddata,id=c("subject","activity"))
#Calculate the mean of melt data
reqdata<-dcast(data,subject+activity ~...,mean)

write.table(reqdata,"./tidyData.txt")
