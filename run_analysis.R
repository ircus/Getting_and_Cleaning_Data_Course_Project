## 0. Check if there is the required dataset "UCI HAR Dataset" in the working directory, if not - download and unzip it

if (!file.exists("UCI HAR Dataset")) {
	if (!file.exists("UCI HAR Dataset.zip")) {
		download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip", method = "curl")
	}
	unzip("UCI HAR Dataset.zip")
}

## 1. Merge the training and the test sets to create one data set.

## 1. Merge the training and the test sets to create one data set.
# Note: Inertial Signals are not required for further analysis
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_data <- cbind(subject_train, y_train, X_train)
rm(subject_train, y_train, X_train)

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data <- cbind(subject_test, y_test, X_test)
rm(subject_test, y_test, X_test)

data <- rbind(train_data, test_data)
rm(train_data, test_data)

## 2. Extract only the measurements on the mean and standard deviation for each measurement

# Import human-readable variable names
colnames <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F)
colnames <- colnames$V2

# Extract those that have "mean()" or "std()" in their name
cols_to_keep <- c(TRUE, TRUE, grepl("mean[()]", colnames)|grepl("std[()]", colnames))

# Subset the dataset keeping just the "mean" and "std" variables
mean_std_data <- data[cols_to_keep]
rm(data)

## 3. Use descriptive activity names to name the activities in the data set

# Extract descriptive activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity_labels <- activity_labels$V2

# Substitute numeric activity labels with human-readable ones
mean_std_data[[2]] <- factor(mean_std_data[[2]])
levels(mean_std_data[[2]]) <- activity_labels
rm(activity_labels)


## 4. Appropriately labels the data set with descriptive variable names. 

# Add human-readable names for the first 2 columns and use the previously imported colnames for the rest
colnames <- c("subject_identifier", "activity_label", colnames)
colnames <- colnames[cols_to_keep]

# Rename the columns of the dataset using human-readable names
colnames(mean_std_data) <- colnames
rm(colnames, cols_to_keep)

## 5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

# Group the observations by activity and subject (only one activity for one subject in each group) and calculate the means of the variables in each group, save the result in a new dataset
avg_mean_std_data <- data.frame(t(sapply(split(mean_std_data[3:length(mean_std_data)], list(mean_std_data$activity_label, factor(mean_std_data$subject_identifier))), colMeans)))

# Extract the information about the activity labels and subject identifiers from the automatically generated row names
rownames <- unlist(strsplit(dimnames(avg_mean_std_data)[[1]], "[.]"))
even <- (1:length(rownames))%%2==0

# Attach the two columns (one with identifiers, the other with activity labels) to the beginning of the new dataset and add column names for them
avg_mean_std_data <- cbind(rownames[even], rownames[!even], avg_mean_std_data)
names(avg_mean_std_data)[1:2] <- c("subject_identifier", "activity_label")
rm(rownames, even)
avg_mean_std_data$subject_identifier <- as.integer(avg_mean_std_data$subject_identifier)
rownames(avg_mean_std_data) <- 1:nrow(avg_mean_std_data)
avg_mean_std_data <- avg_mean_std_data[order(avg_mean_std_data$subject_identifier),]

## 6. Write the last dataset into a .txt file if it has not been done so already.

if (!file.exists("tidy_data_set.txt")) {write.table(avg_mean_std_data, file = "tidy_data_set.txt", row.names = FALSE)}
