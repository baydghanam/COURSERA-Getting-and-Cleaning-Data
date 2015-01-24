# Data source, references and description: #
For a summary description of the data used as source for this script please refer to the following URL
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Libraries uploaded at the beginning of the script: #
library(downloader)

library(dplyr)

This presumes that the said packages have been installed beforehand.

# Variables used and script stages #
## Loading initial data tables: ##
dataURL - is assigned the URL of the zipped archive of files used in this project. This is downloaded and unzipped in the WD. The files are therefore found in wd/UCI HAR Dataset

dfXtrainText - is used to load "UCI HAR Dataset/train/X_train.txt" as a table into memory

dfSubjectTrainText - is used to load "UCI HAR Dataset/train/subject_train.txt" as a table into memory

dfMergeSubXtrain - is assigned the DF resulting from the binding of the subject listing to the train data DF

## To add the "features" as variables assigned to the columns of dfMergeSubXtrain, the script proceeds as follows: ##
dfFeatures - loads "UCI HAR Dataset/features.txt" as a table in memory
asVectorFeatures - to extract the features from the table in vector form

cleanFeatures - serves as the first stage cleanup of the features vector so that elements correspond to R Language constraints

colTitles - is a vector that concatenates cleanFeatures with the string "Subject" that will serve as the name of the first columns of dfMergeSubXtrain. The aforementioned operation is executed using the function colnames()
 
##Manipulation of the ytrain_txt to produce readable activity labels: ##
dfActivIndex - is used to load "UCI HAR Dataset/train/y_train.txt" as a table in memory. 
The first column of dfActivIndex is extracted to be used in substituting the corresponding variable strings listed in the "activity_labels.txt" file.

ActivityIndex - is the variable used for the aforementionedoperation.

dfActivityIndex - turns ActivityIndex into a data frame to which a colimn name "Activity" is added using the colnames() function

## Producing the top half of the merged table requested in the project section 1: ##
dfTrainFinal - is the data table produced by binding dfActivityIndex as a first column to dfMergeSubXtrain

## The same process is applied to "UCI HAR Dataset/test/X_test.txt" except for the column names. The variables used are for this stage are: ##
dfXtestText

dfSubjectTestText

dfMergeSubXtest

dfActivIndexTST

ActivityIndexTST

dfActivityIndexTST

dfTrainFinal - which will be used to merge with dfTrainFinal 

## Creation of the merged data tables requested in section 1 and cleaning up the resulting data: ##
dfMerged - rbinds dfTrainFinal & dfTrainFinal to form the merged data table. By extracting out the columns with duplicated names and affecting the result to **dfMerged we get the final result corresponding to what is expected in section 1 of the project**.

## For section 2 the following variables are introduced: ##
columnsMean - a vector containing all column names that include the string "mean"

columnsSTD - a vector containing all column names that include the string "std"

dfMeanSTD - extracts the data table from dfMerged that contains only the columns indexed by columnsMean & columnsSTD to which have been added the activity and subject columns.
**dfMeanSTD is therefore the answer to section 2 of the project.**

## For section 3 the "Activity" column of dfMerged is compliant with what is expected for descriptive activity levels. ##

## For section 4 the cleaned up variables that already serve as column names are descriptive enough. The column names of the data table dfMerged are compliant with what is requested in section 4 of the project. ##

## For section 5 the DPLYR library comes into play: ##
dfMeanSTDGrouped - is used to group the data in dfMeanSTD by Activity & Subject

**dfAnswer5 - applies the summarise_each() function to produce the mean values of the grouping as requested in section 5**


