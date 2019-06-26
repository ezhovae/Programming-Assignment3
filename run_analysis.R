##Uploading the data into R
getwd()
setwd("C:/Users/d073728/OneDrive - SAP SE/Documents/Assignment3")
features <- read.csv("features.txt",header = FALSE, sep = ' ')
features <- as.character(features[,2])
train.x <- read.table('./UCI HAR Dataset/train/X_train.txt')
train.activity <- read.csv('./UCI HAR Dataset/train/y_train.txt', header = FALSE, sep = ' ')
train.subject <- read.csv('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = ' ')
data.train <-  data.frame(train.subject, train.activity, train.x)
names(data.train) <- c(c('subject', 'activity'), features)


test.x <- read.table('./UCI HAR Dataset/test/X_test.txt')
test.activity <- read.csv('./UCI HAR Dataset/test/y_test.txt', header = FALSE, sep = ' ')
test.subject <- read.csv('./UCI HAR Dataset/test/subject_test.txt', header = FALSE, sep = ' ')

data.test <-  data.frame(test.subject, test.activity, test.x)
names(data.test) <- c(c('subject', 'activity'), features)

##1.Merge of the datasets train and test 

data.all <- rbind(data.train, data.test)

##2. Extract measures of mean and sd

mean_sd <- grep('mean|std', features)
data.all2 <- data.all[,c(1,2,mean_sd + 2)]

##3.Name the activities in the data set using desciptive activities

activity.names <- read.table('./UCI HAR Dataset/activity_labels.txt', header = FALSE)
activity.names<- as.character(activity.names[,2])
data.all2$activity <- activity.names[data.all2$activity]

##4. Appropriately labels the data set with descriptive variable names.

new.names <- names(data.all2)
new.names <- gsub("^t", "Time", new.names)
new.names <- gsub("^f", "Frequency", new.names)
new.names <- gsub("-mean\\(\\)", "Mean", new.names)
new.names <- gsub("-std\\(\\)", "StdDev",new.names)
new.names <- gsub("-", "", new.names)
new.names <- gsub("BodyBody", "Body", new.names)

names(data.all2) <- new.names

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(data.all2[,3:81], by = list(activity = data.all2$activity, subject = data.all2$subject),FUN = mean)
write.table(x = tidy_data, file = "data_tidy.txt", row.names = FALSE)


