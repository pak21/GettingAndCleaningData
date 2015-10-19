## Configuration variables go here

dataDir <- "UCI HAR Dataset"

## Ensure the packages we need are installed

# data.table is more than 10x faster than data.frame for this data
library(data.table)

# dplyr makes data manipulation sane
library(dplyr)

## Sanity check

if (!file.exists(dataDir)) {
  stop(
    c(
      "Directory '", dataDir, "' does not exist. ",
      "Please set the working directory to the location of the UCI HAR data."
    )
  )
}

## 1. Merges the training and the test sets to create one data set.

readData <- function(prefix, type) {
  typeDir <- file.path(dataDir, type)
  filePath <- file.path(typeDir, paste0(prefix, "_", type, ".txt"))
  fread(filePath)
}

readDataSet <- function(type) {
  readData("X", type)
}

readDataLabels <- function(type) {
  readData("y", type)
}

readSubjects <- function(type) {
  readData("subject", type)
}

data <- rbindlist(list(readDataSet("train"), readDataSet("test")))

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# Read in the list of features, filter to the columns which are means or standard deviations

features <- fread(file.path(dataDir, "features.txt")) %>%
  filter(grepl("mean()", V2, fixed = TRUE) | grepl("std()", V2, fixed = TRUE))

# Use those columns to select the appropriate columns from the data

data <- data[, features[[1]], with = FALSE]

## 3. Uses descriptive activity names to name the activities in the data set

# First, add the activities to the data set

labels <- rbindlist(list(readDataLabels("train"), readDataLabels("test")))
setnames(labels, c("ActivityId"))
data <- cbind(data, labels)

# Read in the list of activities

activities <- fread(file.path(dataDir, "activity_labels.txt"))
setnames(activities, c("ActivityId", "Activity"))

# And now look up the descriptive activity names, and drop the now unneeded ActivityId column

data <- data %>% inner_join(activities, by = "ActivityId")
data[, ActivityId := NULL]

## 4. Appropriately labels the data set with descriptive variable names.

# Nice and easy, just copy from the features list we created above

names(data)[1:nrow(features)] <- features[[2]]

## Before we finish, put the subjects into the data set

subjects <- rbindlist(list(readSubjects("train"), readSubjects("test")))
setnames(subjects, "SubjectId")
data <- cbind(data, subjects)

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# dplyr for the win

tidyData <- data %>% group_by(SubjectId, Activity) %>% summarise_each(funs(mean))

# And write the data out as per the instructions

write.table(tidyData, "tidyData.txt", row.names = FALSE)