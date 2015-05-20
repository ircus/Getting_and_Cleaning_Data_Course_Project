# Processed Human Activity Recognition Using Smartphones Dataset

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### For each record it is provided:

- A 66-feature vector with average values within the specified activity and subject of the variables described in the CodeBook.md file.
- Its activity label. 
- An identifier of the subject who carried out the experiment.

### The dataset includes the following files:

- 'README.md'
- 'CodeBook.md' - describes the variables, the data, and transformations that were performed to make the data tidy
- 'run_analysis.R' - R-code that reproduces tidy_data_set.txt in the working directory, described in detail in a section below
- 'tidy_data_set.txt' - the dataset, each row correspond to a unique combination of a subject and an activity which are specifies by columns 1 and 2

### Notes: 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file, starting from 3rd position.

### run_analysis.R follows the steps below:
0. Check if there is the required dataset "UCI HAR Dataset" in the working directory, if not - download it from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and unzip it
1. Merge the training and the test sets to create one data set
Note: Inertial Signals are not required for further analysis
  1. Column bind files train/subject_train.txt, train/y_train.txt, and train/X_train.txt
  2. Column bind files test/subject_test.txt, test/y_test.txt, and test/X_test.txt
  3. Row bind the two results
2. Extract only the measurements on the mean and standard deviation for each measurement
  1. Import human-readable variable names from features.txt into a variable called colnames
  2. Extract those that have "mean()" or "std()" in their name
  3. Subset the dataset keeping just the "mean" and "std" variables
3. Use descriptive activity names to name the activities in the data set
  1. Extract descriptive activity labels from activity_labels.txt
  2. Substitute numeric activity labels with human-readable ones
4. Appropriately labels the data set with descriptive variable names.
  1. Create a vector of names: manually add human-readable names for the first 2 columns and use the previously imported colnames for the rest keeping just the "mean" and "std" variable names
  2. Rename the columns of the dataset using human-readable names
5. From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
  1. Group the observations by activity and subject (only one activity for one subject in each group) and calculate the means of the variables in each group, save the result in a new dataset
  2. Extract the information about the activity labels and subject identifiers from the automatically generated row names
 3. Attach the two columns (one with identifiers, the other with activity labels) to the beginning of the new dataset and add column names for them
6. Write the last dataset into a .txt file if it has not been done so already.