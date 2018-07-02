library(dplyr)
library(data.table)
library(stringr)

## reading text data into R

testdata<-read.table("./x_test.txt")
                      
testactivity<-read.table("./y_test.txt")
                      
testsubject<-read.table("./subject_test.txt")

traindata<-read.table("./x_train.txt")
                      
trainactivity<-read.table("./y_train.txt")
                      
trainsubject<-read.table("./subject_train.txt")

## combining subject number, activity level and the respective data

testdata<-cbind(testsubject, testactivity, testdata)

traindata<-cbind(trainsubject, trainactivity, traindata)

## creating the header vector

colClasses=c("NULL", "character")

feature<-read.table("./features.txt", colClasses=colClasses)

header<-c(c("subject", "activity"),feature[,1])

## formatting the variable names in the header

header<-gsub("[(|)]","",header)

header<-gsub("BodyBody","Body",header)

header[557:563]<-c("angle-tBodyAccMean,gravity","angle-tBodyAccJerkMean,gravityMean",
					"angle-tBodyGyroMean,gravityMean","angle-tBodyGyroJerkMean,gravityMean",
					"angle-X,gravityMean","angle-Y,gravityMean", "angle-Z,gravityMean")
					
## creating data tables in order to use setnames function

testdata<-data.table(testdata)

traindata<-data.table(traindata)

## set the column names of the data

setnames(testdata,header)

setnames(traindata,header)

## combining test and training data

mdata<-rbind(testdata,traindata)

## converting the data table back to data frame

mdata<-data.frame(mdata)

## extracting only the mean and standard deviation for each measurement

newdata<-mdata[,grepl("subject|activity|mean(?!Freq)|std", names(mdata), perl=TRUE)]

## labeling the activity levels
newdata$activity<- factor(newdata$activity,
						levels = c(1,2,3,4,5,6),
						labels = c("walking", "walking_upstairs", "walking_downstairs","sitting","standing","laying"))

## converting subject number to factor
newdata[,1]<-as.factor(newdata[,1])						

## calculate the average of each variable, group by subject number and activity type		
			
df1 <- newdata %>% group_by(subject, activity) %>% summarise_if(is.numeric,mean)

## export the result to a text file
write.table(df1, "./ouput.txt", row.names = FALSE)

## the CSV format looks nicer						
write.csv(df1, "./ouput.csv", row.names = FALSE)						
						
						
						
						
						
						