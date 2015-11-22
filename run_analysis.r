##Getting and cleaning data project

setwd("C:/Users/aman/Documents/Courses/Coursera/Data Science specialization/3-Getting and cleaning data/R Working Directory- getting and cleaning data/ProjectWork")
if(!file.exists("ProjectData.zip")){
  fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, destfile = "projectData.zip")
}
if(!file.exists("UCI HAR Dataset")){
  unzip("projectData.zip",overwrite = T)
}


#1. Merege the training and test sets to create one data set.


setwd("C:/Users/aman/Documents/Courses/Coursera/Data Science specialization/3-Getting and cleaning data/R Working Directory- getting and cleaning data/ProjectWork/UCI HAR Dataset")


##read the data

features = read.table("features.txt",header = F);  ##imort features.txt
activityType = read.table("activity_labels.txt", header = F); ##import activity_labels.txt 
subjectTrain = read.table("./train/subject_train.txt",header = F); ##import subject_train.txt
xTrain = read.table("./train/x_train.txt", header = F);  ##import x_train.txt
yTrain = read.table("./train/y_train.txt", header = F);  ##import y_train.txt

#Assign column names to the data imported above
colnames(activityType) = c("activityId","activityType");
colnames(subjectTrain) = "subjectId";
colnames(xTrain) = features[,2];
colnames(yTrain) = "activityId";

#Create final training set by merging yTrain, subjectTrain and xTrain

trainingData = cbind(yTrain,subjectTrain,xTrain)

#Read test data

subjectTest = read.table("./test/subject_test.txt", header = F);  #import subject_test.txt
xTest = read.table("./test/x_test.txt", header = F);  #import x_test.txt
yTest = read.table("./test/y_test.txt", header = F);  #import y_test.txt

#Assign column names to the data imported
colnames(subjectTest) = "subjectId";
colnames(xTest) = features[,2];
colnames(yTest) = "activityId";

#Create final training set by merging yTest, subjectTest and xTest

testData = cbind(yTest,subjectTest,xTest);

#combining train and test data set

finalData = rbind(trainingData,testData);



#2. Extract only the measurements on the mean and standard deviation for each measurement

## Create a vector for column names used in subsetting columns
colNames = colnames(finalData);

## Creating columns subsetting criteria
searchString = c("activity..","subject..","-mean..","-std..")

##subsetting finaldata
finalData = finalData[grepl(paste(searchString, collapse = "|"), colNames) & !grepl("-meanFreq..", colNames)]


#3. Uses descriptive activity names to name the activities in the data set

##merge the final data sets with the activity_type table
finalData = merge(finalData,activityType, by = "activityId", all.x = T )


#4. Appropriately labels the data set with descriptive variable names. 

colNames = colnames(finalData);

#cleaning up variable names
for(i in 1:length(colNames)){
    colNames[i] = gsub("\\()","",colNames[i])
    colNames[i] = gsub("-std","StdDev",colNames[i])
    colNames[i] = gsub("-mean","Mean",colNames[i])
    colNames[i] = gsub("^(t)","time",colNames[i])
    colNames[i] = gsub("^(f)","freq",colNames[i])
    colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
    colNames[i] = gsub("([Bb]ody)","Body",colNames[i])
    colNames[i] = gsub("([Aa]cc)","Acc",colNames[i])
    colNames[i] = gsub("([Jj]erk)","Jerk",colNames[i])
    colNames[i] = gsub("([Gg]yro)","Gyro",colNames[i])
    colNames[i] = gsub("([Mm]ag)","Magnitude",colNames[i])
}
  
#reassigning colnames to the final data columns
colnames(finalData) = colNames

#5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

#Creating a data set without activity_type column
finalDataNoActivityType = finalData[,names(finalData) != 'activityType']

#summarizing the data by activityId and subjectId
tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

#merging activityType
tidyData = merge(tidyData,activityType,by='activityId',all.x=TRUE);

#writting into a table
setwd("C:/Users/aman/Documents/Courses/Coursera/Data Science specialization/3-Getting and cleaning data/R Working Directory- getting and cleaning data/ProjectWork")

if(!file.exists("tidyData.txt")){
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')};

