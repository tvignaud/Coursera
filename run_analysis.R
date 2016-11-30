# You should set the directory to be one level up of the dataset folder containing the initial data with the initial folder structure

# Merges the training and the test sets to create one data set


## put measurements, activity and subject from testing set together, with appropriate variable names
setwd("./dataset/test/")
data_test_measure <- read.table("./X_test.txt",sep="")
data_test_activity <- read.table("./y_test.txt",sep="")
data_test_subject <- read.table("./subject_test.txt",sep="")
data_test <- cbind(data_test_subject,data_test_activity,data_test_measure)

## put measurements, activity and subject from training set together, with appropriate variable names
setwd("../train/")
data_train_measure <- read.table("./X_train.txt",sep="")
data_train_activity <- read.table("./y_train.txt",sep="")
data_train_subject <- read.table("./subject_train.txt",sep="")
data_train <- cbind(data_train_subject,data_train_activity,data_train_measure)

# put train and test together
data_full <- rbind(data_test,data_train)

# read variable names from features.txt and use it to name the variables in data_full
features_con <- file("../features.txt")
features_names_numbered <- readLines(features_con)
close(features_con)
features_names_numbered_split <- strsplit(features_names_numbered," ")
features_names <- matrix(unlist(features_names_numbered_split),ncol=2,nrow=561,byrow=TRUE)[,2]

names(data_full) <- c("Subject_id","Activity_id",features_names)


# Extracts only the measurements on the mean and standard deviation for each measurement. 

## get the variable names containing mean or std
col_list_mean_std <- grepl("([Mm]ean)|([Ss]td)",features_names)

## Keep activity and subject information as well (column 1 and 2)
col_list_mean_std <- c(TRUE,TRUE,col_list_mean_std)

## extract only the mean and std measurements
data_full_mean_std <- data_full[,col_list_mean_std]

# Uses descriptive activity names to name the activities in the data set

## get activity labels from txt file in the folder
activity_con <- file("../activity_labels.txt")
activity_labels_numbered <- readLines(activity_con)
close(activity_con)

## split numbering and descriptive part
activity_labels_numbered_split <- strsplit(activity_labels_numbered," ")
activity_labels <- matrix(unlist(activity_labels_numbered_split),ncol=2,nrow=6,byrow=TRUE)

## factor activity label and apply corresponding description
data_full_mean_std$Activity_explicit <- factor(data_full_mean_std$Activity_id,labels=activity_labels[,2])

# Appropriately labels the data set with descriptive variable names
## already done in order to select mean and std for each variables

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## loop over unique number of subject and activity and put data 
subject_set <- unique(data_full_mean_std$Subject_id)
activity_set <- unique(data_full_mean_std$Activity_explicit)
row_count <- 0
data_ave_subject_activity <- data_full_mean_std #initialize object

for (i in 1:length(subject_set)){
  for (j in 1:length(activity_set)){
    row_count <- row_count + 1
    data_ave_subject_activity[row_count,1] <- subject_set[i] #store subject
    data_ave_subject_activity[row_count,89] <- activity_set[j] #store activity
    # get list of line to keep corresponding to a couple (subject,activity)
    condition_subject_activity <- which(data_full_mean_std$Subject_id==subject_set[i] & data_full_mean_std$Activity_explicit == activity_set[j])
    # compute the mean for all column variables
    for (k in 2:88){
      data_ave_subject_activity[row_count,k] <- mean(data_full_mean_std[condition_subject_activity,k])
    }
  }
}

##reorder first by subject and second by activity and put subject_id, explicit_activity first (Activity_id is removed)
sorting_row <- order(data_ave_subject_activity$Subject_id[1:row_count],data_ave_subject_activity$Activity_id[1:row_count])
data_ave_subject_activity <- data_ave_subject_activity[sorting_row,c(1,89,3:88)]
data_full_mean_std <- data_full_mean_std[,c(1,89,3:88)] #no row ordering here


##output 2 file containing data_full_mean_std ,data_ave_subject_activity
write.table(data_full_mean_std,"../../mean_std_dataset.txt",row.names = FALSE)
write.table(data_ave_subject_activity, "../../mean_std_ave_over_subject_and_activity.txt",row.names = FALSE)

setwd("../..")
