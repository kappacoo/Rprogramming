####  Download file ####
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "project", method = "curl")

#### unzip folder ####
unzip("project")

#### view files in folder ####
list.files("UCI HAR Dataset")
list.files("UCI HAR Dataset/train")

#### Read activity ta ##### 
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
str(activity_labels)

#### Read in feature labels #####
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)
str(features)

#### which features are mean and std #####
features_mean <- grep("mean()", features$V2, fixed = T) ## index of rows that are mean()
features[features_mean,]

features_std <- grep("std()", features[,2], fixed = T) ## index of rows 
features[features_std,]

length(features_mean) ## checking now many features mean
length(features_std) ## confirming match
###############################
#### Read in training data #### 
train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features[,2])
dim(train)
names(train)

# filter mean and std 
train <- train[,c(features_mean, features_std)]
dim(train)

## modifying column names
names(train) <- gsub(".", "", names(train), fixed = T)
names(train) <- sub("mean", "Mean", names(train))
names(train) <- sub("std", "Std", names(train))

#### Read in activites and subjects for training data #### 
activities_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

dim(train)
dim(activities_train)
dim(subject_train)

#### combine subject, activities, and features for training data #####
train <- cbind(activities_train, subject_train, train)
dim(train)
names(train)
##############################
#### Read in testing data #### 
test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features[,2])
dim(test)
names(test)

# filter mean and std 
test <- test[,c(features_mean, features_std)]
dim(test)

## modifying column names
names(test) <- gsub(".", "", names(test), fixed = T)
names(test) <- sub("mean", "Mean", names(test))
names(test) <- sub("std", "Std", names(test))

#### Read in activites and subjects for testing data #### 
activities_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

dim(test)
dim(activities_test)
dim(subject_test)

#### combine subject, activities, and features for testing data #####
test <- cbind(activities_test, subject_test, test)
dim(test)
names(test)

#########################################
#### Combine training and test data #####

df <- rbind(train, test)
dim(df)
names(df)

##### Changing activity names #####
df$activity <- as.factor(df$activity) ## convert to factor
levels(df$activity) <- activity_labels[,2] ## change level names 


###### Creating data summary by subject and activity ######
require(dplyr)
df_tidy <- tbl_df(df)

df_tidy_summary <- df_tidy %>% 
  group_by(subject, activity) %>% 
  summarise_all(funs(mean))
