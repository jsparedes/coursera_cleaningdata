setwd("C:/Users/jparedes.ICA/Downloads/Cleaning Data/Project - UCI HAR Dataset")
# Change it according your workspace

######################### Part 1: ###############################
# Merges the training and the test sets to create one data set.

# Reading Train
data_train <- read.table("./data/train/X_train.txt")          # 7352 x 561
label_train <- read.table("./data/train/y_train.txt")         # 7352 x 1
subject_train <- read.table("./data/train/subject_train.txt") # 7352 x 1
# Reading Test
data_test <- read.table("./data/test/X_test.txt")             # 2947 x 561
label_test <- read.table("./data/test/y_test.txt")            # 2947 x 1
subject_test <- read.table("./data/test/subject_test.txt")    # 2947 x 1
# Total = Train + Test : (Merging)
data_total <- rbind(data_train, data_test)                    # 10299 x 561
label_total <- rbind(label_train, label_test)                 # 10299 x 1
subject_total <- rbind(subject_train, subject_test)           # 10299 x 1

######################### Part 2: ###############################
# Extracts only the measurements on the mean and standard deviation
# for each measurement 

features <- read.table("./data/features.txt") # 561 x 2
# Getting indexes that contain "mean" and "std"
indices_MeanStd <- grep("mean\\(\\)|std\\(\\)", features[, 2]) # 66
# Good lecture: fBodyAccJerk-mean()-X
# Bad lecture: fBodyAcc-meanFreq()-X

data_total <- data_total[, indices_MeanStd] # 10299 x 66
names(data_total) <- features[indices_MeanStd, 2]

######################### Part 3: ###############################
# Uses descriptive activity names to name the
# activities in the data set
activities <- read.table("./data/activity_labels.txt") # 6 x 2
activityLabel <- activities[label_total[, 1], 2]
label_total[, 1] <- activityLabel                      # 10299 x 1
names(label_total) <- "Activity"

######################### Part 4: ###############################
# Appropriately labels the data set with descriptive activity names. 
names(subject_total) <- "Subject"
data_filtered <- cbind(subject_total, label_total, data_total) # 10299 x 68
write.table(data_filtered, "merged_data_filtered.txt")

######################### Part 5: ###############################
# Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
data <- data_filtered[,3:ncol(data_filtered)]
criteria <- list(Subject=data_filtered$Subject, Activity=data_filtered$Activity)
tidy_dataset <- aggregate(data, criteria, mean)          # 180 x 68
tidy_dataset<-tidy_dataset[order(tidy_dataset$Subject),] #ordering
row.names(tidy_dataset) <- NULL # Removing row.names, not necessary
write.table(tidy_dataset, "tidy_dataset_means.txt")
