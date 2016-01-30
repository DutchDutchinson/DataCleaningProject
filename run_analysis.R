##Data Cleaning Project

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filedest <- "~/Coursera/Data Cleaning/Project/dataFile.zip"
filename <- "projectdata."
download.file(url = url, destfile = filedest)
unzip(filedest)

activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")

testdata <- read.table("UCI HAR Dataset/test/X_test.txt")
testlabels <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubject <- read.table("UCI HAR Dataset/test/subject_test.txt")

traindata <- read.table("UCI HAR Dataset/train/X_train.txt")
trainlabels <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubject <- read.table("UCI HAR Dataset/train/subject_train.txt")

##Extract only the mean and standard deviation



#combine the test and train data
testdf <-cbind(testsubject, testlabels, testdata)
traindf <- cbind(trainsubject, trainlabels, traindata)
df <- rbind(testdf, traindf)

#add the activity names and label subject and activity

featurenames <- (read.table("UCI HAR Dataset/features.txt"))
colnames(df) <- c("subject", "activity", as.character(featurenames[, 2]))

##subset for only mean and std variables
cleandf <- df[ ,grepl(".*[Mm]ean.*|.*[Ss]td.*|subject|activity", names(df))]

##Clean the column lables
names(cleandf) <- gsub('-mean', 'Mean', names(cleandf))
names(cleandf) <- gsub('-std', 'Std', names(cleandf))
names(cleandf) <- gsub('[-()]', ' ', names(cleandf))

#add description of activity
cleandf$activity <- factor(cleandf$activity, levels=activitylabels[ ,1], labels = activitylabels[ ,2])
cleandf$subject <- as.factor(cleandf$subject)

#Get mean for each subject and activity
dfmelt <- melt(cleandf, id.vars=c("subject", "activity"))
subjectmean <- dcast(dfmelt, subject + activity ~ variable, mean)

#final table
finaltable <- write.table(subjectmean, "tidy.text", row.names = FALSE, quote = FALSE)
