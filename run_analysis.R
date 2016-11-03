# Download zip file if the dataset doesn't exists
if (!file.exists("UCI HAR Dataset")) {
   zipUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(zipUrl, destfile="./Dataset.zip", method="auto")
   unzip(zipfile="./Dataset.zip", exdir=".", overwrite = TRUE)
}

# remove zip file if both unzip file and zip file exists
if(file.exists("./Dataset.zip") & file.exists("UCI HAR Dataset")){
   file.remove("./Dataset.zip")
}


# Read tables from train folder
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
s_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)

# Read tables from test folder
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# assign column names to dataset
features <- read.table('./UCI HAR Dataset/features.txt', header = FALSE)
colnames(x_train) <- features[,2]
colnames(x_test)  <- features[,2]
names(y_train) <- "Activity"
names(y_test)  <- "Activity"
names(s_train) <- "Subject"
names(s_test)  <- "Subject"

# subset data with mean & std columns
z_train <- x_train[,grep("mean|std",features[,2])]
z_test  <- x_test[,grep("mean|std",features[,2])]

# Combine all dataset into one dataset
all_train <- cbind(y_train, s_train, z_train)
all_test  <- cbind(y_test,  s_test,  z_test)
all_data  <- rbind(all_train, all_test)

# Reading activity labels
a_Labels = read.table('./UCI HAR Dataset/activity_labels.txt')
names(a_Labels) <- c("Activity", "ActivityDesc")

# replace the activity id to labels
all_data$Activity <- factor(all_data$Activity, levels = a_Labels$Activity, labels = a_Labels$ActivityDesc)
all_data$Subject  <- as.factor(all_data$Subject)

# create a tidy dataset with the average of each variable for each activity and each subject.
tidy_data <- aggregate(. ~Activity + Subject, data = all_data, mean)
tidy_data <- tidy_data[order(tidy_data$Subject,tidy_data$Activity),]

# write a text format output
write.table(tidy_data, "./tidy_data.txt", row.name=FALSE)
