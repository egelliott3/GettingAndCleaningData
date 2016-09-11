library(data.table)
library(dplyr)

## Assumes all data has already been extracted to wd from the internal zip directory
##  \UCI HAR Dataset.  More specifically the wd should contain the files activity_labels.txt,
##  features.txt, etc.
##
## Ignoring the Inertial Signals data per forum recommendations since it is not relevant
##  to the calcuations we need to perform.
##

wdPath = getwd()

## Set root paths to the test and train directories relative to the working directory
testPath = file.path(wdPath, "test")
trainPath = file.path(wdPath, "train")

## Load subject files
dtTestSubject = read.table(file.path(testPath, "subject_test.txt"))
dtTrainSubject = read.table(file.path(trainPath, "subject_train.txt"))

## Load activity files
dtTestActivity = read.table(file.path(testPath, "y_test.txt"))
dtTrainActivity = read.table(file.path(trainPath, "y_train.txt"))

## Load data files
dtTestData = read.table(file.path(testPath, "X_test.txt"))
dtTrainData = read.table(file.path(trainPath, "X_train.txt"))

## Load features
dtFeatures = read.table(file.path(wdPath, "features.txt"))
setnames(dtFeatures, names(dtFeatures), c("featureId", "featureName"))

## Merge test and train sets for subject, activity and data respectively
dtSubjectMerged = rbind(dtTestSubject, dtTrainSubject)
setnames(dtSubjectMerged, "V1", "subjectId")

dtActivitytMerged = rbind(dtTestActivity, dtTrainActivity)
setnames(dtActivitytMerged, "V1", "activityId")

dtDataMerged = rbind(dtTestData, dtTrainData)

## Create a single dataset from the three we have
dtWorkingSet = cbind(cbind(dtSubjectMerged, dtActivitytMerged), dtDataMerged)

## Cleanup environment to reclaim memory
rm(dtTestSubject)
rm(dtTrainSubject)
rm(dtTestActivity)
rm(dtTrainActivity)
rm(dtTestData)
rm(dtTrainData)
rm(dtSubjectMerged)
rm(dtActivitytMerged)
rm(dtDataMerged)

## This leaves us with dtWorkingSet and dtFeatures remaining

## Filter the features data table down to only the mean() and std() entries
dtMeanStdFeatures = dtFeatures[grepl("mean\\(\\)|std\\(\\)", dtFeatures$featureName),]

## Update formatting of the featureIds to include a V to match our combinded working set
dtMeanStdFeatures = mutate(dtMeanStdFeatures, featureCode = paste0("V", featureId))

## Subset down to just the columns we want based on filtered features
dtWorkingSet = select_(dtWorkingSet, .dots=c("subjectId", "activityId", dtMeanStdFeatures$featureCode))

## Load activity labels so we can translate ids to names
dtActivityLabels = read.table(file.path(wdPath, "activity_labels.txt"))
setnames(dtActivityLabels, names(dtActivityLabels), c("activityId", "activityName"))

## Join our activity names into our working set based on activityId
dtWorkingSet = inner_join(dtWorkingSet, dtActivityLabels)

## Unpivot the dtWorkingSet so we have a feature and value per row
dtWorkingSet = melt(dtWorkingSet, c("subjectId", "activityId", "activityName"), variable.name="featureCode")

## Since our working format matches the feature format, join
dtWorkingSet = left_join(dtWorkingSet, dtMeanStdFeatures)

## Cleanup
rm(dtActivityLabels)
rm(dtFeatures)
rm(dtMeanStdFeatures)

## Parse featureName into columns that make sense based on the documentation
##  contained in features_info.txt

## Create new domain column with values Time or Frequency
dtWorkingSet = mutate(dtWorkingSet, domain = factor(grepl("^t", dtWorkingSet$featureName), labels=c("Frequency", "Time")))

## Create new instrument column with values for Gyroscope or Accelerometer
dtWorkingSet = mutate(dtWorkingSet, instrument = factor(grepl("Acc", dtWorkingSet$featureName), labels=c("Gyroscope", "Accelerometer")))

## Create new acceleration column with values for Body or Gravity
dtWorkingSet = mutate(dtWorkingSet, acceleration = factor(ifelse(grepl("Acc", dtWorkingSet$featureName), ifelse(grepl("Body", dtWorkingSet$featureName), 1, 2), 0), labels=c(NA, "Body", "Gravity")))

## Create new isJerk column with binary values
dtWorkingSet = mutate(dtWorkingSet, isJerk = grepl("Jerk", dtWorkingSet$featureName))

## Create new variable column with values for Mean and StandardDeviation
dtWorkingSet = mutate(dtWorkingSet, variable = factor(grepl("mean\\(\\)", dtWorkingSet$featureName), labels=c("StandardDeviation", "Mean")))

## Create new isMagnitue column with binary values
dtWorkingSet = mutate(dtWorkingSet, isMagnitude = grepl("Mag", dtWorkingSet$featureName))

## Create new axis column with values for X, Y and Z
dtWorkingSet = mutate(dtWorkingSet, axis = factor(ifelse(grepl("-X", dtWorkingSet$featureName), 0, ifelse(grepl("-Y", dtWorkingSet$featureName), 1, ifelse(grepl("-Z", dtWorkingSet$featureName), 2, 3))), labels=c("X", "Y", "Z", NA)))

## Pare down the set to only include the columns we are interested in
dtWorkingSet = select(dtWorkingSet, subjectId, activityName, domain, instrument, acceleration, isJerk, isMagnitude, variable, axis, value)


## Aggregate the working set into a tidy set with the group row count and mean of
##  the value
groupBy = group_by(dtWorkingSet, subjectId, activityName, domain, instrument, acceleration, isJerk, isMagnitude, variable, axis)
dtTidy = summarize(groupBy, count = n(), average = mean(value, rm.na = TRUE))


write.table(dtTidy, "./Tidy.txt", row.name=FALSE)