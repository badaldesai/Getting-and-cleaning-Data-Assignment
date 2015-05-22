trainX<-read.table("./UCI HAR DATASET/train/X_train.txt")
trainY<-read.table("./UCI HAR DATASET/train/y_train.txt")
trainSub <- read.table("./UCI HAR DATASET/train/subject_train.txt")

testX<-read.table("./UCI HAR DATASET/test/X_test.txt")
testY<-read.table("./UCI HAR DATASET/test/y_test.txt")
testSub <- read.table("./UCI HAR DATASET/test/subject_test.txt")

dataX<-rbind(trainX,testX)
dataY<-rbind(trainY,testY)
dataSub<-rbind(trainSub,testSub)

features<- read.table("./UCI HAR DATASET/features.txt")
reqInd <- grep("mean\\(\\)|std\\(\\)",features[,2])
dataX<- dataX[,reqInd]
names(dataX) <-gsub("\\(\\)","",features[reqInd,2])
names(dataX) <-gsub("-","",names(dataX))

activitylabel <- read.table("./UCI HAR DATASET/activity_labels.txt")
activity<-activitylabel[dataY[,1],2]
dataY[,1]<-activity
names(dataY)<-"activity"

names(dataSub)<-"subject"
gooddata<-cbind(dataSub,dataY,dataX)

library(reshape2)

data<-melt(gooddata,id=c("subject","activity"))
reqdata<-dcast(data,subject+activity ~...,mean)

write.table(reqdata,"./tidyData.txt")