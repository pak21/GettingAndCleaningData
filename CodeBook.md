# Codebook

## Script outputs

The script will produce three outputs:

* A `data` variable in the R workspace which contains the unsummarised data set
* A `tidyData` variable in the R workspace which contains the data set averaged by subject and activity
* A `tidydata.txt` file in the current directory

## data

This R variable contains 10299 observations of 68 variables:

- Columns 1-66: the 66 features which correspond to either a mean or a standard deviation from the original 561 features in the data set. The columns
  are named as per the features listed in `features.txt` and `features_info.txt` in the original zip file.
- Column 67 (`Activity`): the activity being undertaken (as a character vector)
- Column 68 (`SubjectId`): the subject which was undertaking this activity, using the same identifiers as in the original zip file.

## tidyData

This R variable contains 35 observations of 68 variables:

- Column 1 (`SubjectId`): the subject ID for which this observation is a summary; see `data` column 68.
- Column 2 (`Activity`): the activity for which this observation is a summary; see `data` column 67
- Columns 3-68: the mean value for all observations in `data` with the specified subject ID and activity. Column names correspond to those in `data`
  (and thus to those in `features.txt`).

## tidydata.txt

This is simply a serialisation of `tidyData` with `write.table`; the columns and meanings are exactly the same.
