# 1. Go and fetch data
if (!file.exists("./data")) {
  dir.create("./data")
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, dest="./data/dataset.zip", method="curl")
  unzip("./data/dataset.zip", exdir="./data")
}

# 2. Merges the training and the test sets to create one data set
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_s <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
  
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_s <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
  
merge_x <- rbind(test_x, train_x)
merge_y <- rbind(test_y, train_y)
merge_s <- rbind(test_s, train_s)
  
mergeSet <- cbind(merge_x, merge_s, merge_y)

## 3. Extracts only the measurements on the mean and standard deviation for each measurement
features  <- read.table("./data/UCI HAR Dataset/features.txt")
mergeSet2 <- mergeSet[, c(grep("(mean|std)", features$V2), 562, 563)]

## 4. Uses descriptive activity names to name the activities in the data set
names(mergeSet2) <- c(grep("(mean|std)", features[[2]], value=T), "subject_id", "activity_id")

activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
mergeSet2 <- cbind(mergeSet2, sapply(mergeSet2$activity_id, function(x){ toString(activity_labels[x, 2]) }))
