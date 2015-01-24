#install.packages("downloader")
#install.pacakges("dplyr")
library(downloader)
library(dplyr)
dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download(dataURL,dest="ProjectDataset.zip", mode = "wb")
unzip ("ProjectDataset.zip", exdir = ".") #unzips the dataset into its named directory at the root of the WD
#load Xtrain.txt
dfXtrainText <- read.table("UCI HAR Dataset/train/X_train.txt",header=F,sep="",dec=".")
#load subject_train.tx
dfSubjectTrainText <- read.table("UCI HAR Dataset/train/subject_train.txt",header=F)
#add subject col to Xtrain DF
dfMergeSubXtrain <- cbind(dfSubjectTrainText,dfXtrainText)
#load features.txt
dfFeatures <- read.table("UCI HAR Dataset/features.txt",header=F)
#change into vector to clean up names
asVectorFeatures <- dfFeatures[,2]
cleanFeatures <- make.names(asVectorFeatures, unique = FALSE, allow_ = TRUE)
#set column titles vector with a "Subject" as first string
colTitles <- c("Subject",cleanFeatures)
# associate features list to merged DF as column tiles
colnames(dfMergeSubXtrain) <- colTitles
# if youneed to check output use "display <- head(dfMergeSubXtrain)[1:4]"

#load Activity index into a DF and modify it into a vector
dfActivIndex <- read.table("UCI HAR Dataset/train/y_train.txt",header=F,sep="")
dfActivIndex <- dfActivIndex[,1]
#substitute numbers for Activity label
ActivityIndex <- gsub(6,"LAYING",dfActivIndex)
#keep repeating until you get to 1
ActivityIndex <- gsub(5,"WALKING",ActivityIndex)
ActivityIndex <- gsub(4,"SITTING",ActivityIndex)
ActivityIndex <- gsub(3,"WALKING_DOWNSTAIRS",ActivityIndex)
ActivityIndex <- gsub(2,"WALKING_UPSTAIRS",ActivityIndex)
ActivityIndex <- gsub(1,"WALKING",ActivityIndex)
#at this stage all of the y file has become a activity label centric
#append it as a column to the DF
#Start by turning vector into a DF 
dfActivityIndex <- as.data.frame(ActivityIndex)
#give column the title "Activity"
colnames(dfActivityIndex) <- "Activity"
#add column to front of Train data frame
dfTrainFinal <- cbind(dfActivityIndex,dfMergeSubXtrain)
# view by typing dfTrainFinal[1:3,1:4]

#Repeat for Xtest.txt without colNames
dfXtestText <- read.table("UCI HAR Dataset/test/X_test.txt",header=F,sep="",dec=".")
dfSubjectTestText <- read.table("UCI HAR Dataset/test/subject_test.txt",header=F)
dfMergeSubXtest <- cbind(dfSubjectTestText,dfXtestText)
colnames(dfMergeSubXtest) <- colTitles

dfActivIndexTST <- read.table("UCI HAR Dataset/test/y_test.txt",header=F,sep="")
dfActivIndexTST <- dfActivIndexTST[,1]
ActivityIndexTST <- gsub(6,"LAYING",dfActivIndexTST)
ActivityIndexTST <- gsub(5,"WALKING",ActivityIndexTST)
ActivityIndexTST <- gsub(4,"SITTING",ActivityIndexTST)
ActivityIndexTST <- gsub(3,"WALKING_DOWNSTAIRS",ActivityIndexTST)
ActivityIndexTST <- gsub(2,"WALKING_UPSTAIRS",ActivityIndexTST)
ActivityIndexTST <- gsub(1,"WALKING",ActivityIndexTST)
dfActivityIndexTST <- as.data.frame(ActivityIndexTST)
colnames(dfActivityIndexTST) <- "Activity"
dfTestFinal <- cbind(dfActivityIndexTST,dfMergeSubXtest)
# Answer to project section 1 & 3 
dfMerged <- rbind(dfTrainFinal,dfTestFinal)
#Cleaning put duplicate columns
dfMerged <- dfMerged[,unique(colnames(dfMerged))]
#Verified by comparing dim(dfMerged) to length(unique(cleanFeatures)), 477+2 columns / 477 features

#determine column titles containing the string "mean"
colTitles <- c("Activity",colTitles)
columnsMean <- grep("mean",colTitles)
# DITTO for "std"
columnsSTD <- grep("std",colTitles)
#Extracting a data frame from the merged one containing means and standard deviations
#as well as the first two columns containing activity labels & subjects
# Answer to project section 2
dfMeanSTD <- dfMerged[,c(1,2,columnsMean,columnsSTD)]
# Answer to project section 3 is already in dfMerged & dfMeanSTD
# Variable names have been cleaned up and are as clear as can be given the data provided
# Therefore, project section 4 is satisfied

#Using dplyr group dfMeanSTD by Activity and Subject
dfMeanSTDGrouped <- group_by(dfMeanSTD,Activity,Subject)
#Apply the mean function and store the new Data Frame in dfAnswer5
dfAnswer5 <- summarise_each(dfMeanSTDGrouped,funs(mean))
#This result yields a DF that is expected for project section 5
