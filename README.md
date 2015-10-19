# Getting and Cleaning Data Course Project

## Running the script

1. Ensure you have the [`data.table`](https://cran.r-project.org/web/packages/data.table/index.html) and
[`dplyr`](https://cran.r-project.org/web/packages/dplyr/index.html) packages installed (`install.packages(c("data.table", "dplyr"))`)
2. Download the data file from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).
3. Unzip the data file using a tool of your choice; there should now be a directory called `UCI HAR Dataset` in the current directory.
4. `source("run_analysis.R")`

This will leave you with two important objects in the R workspace:

* `data`: the full, unsummarised data set as produced in steps 1-4 of the requirements
* `tidyData`: the summarised data set as produced in step 5 of the requirements

and a `tidyData.txt` file in the current directory which is the result of writing `tidyData` with `write.table`.

## Understanding the script

The script makes heavy use of `data.table` and `dplyr`; you may want to review the appropriate lectures
([data.table](https://class.coursera.org/getdata-033/lecture/19), [dplyr 1](https://class.coursera.org/getdata-033/lecture/57), [dplyr
2](https://class.coursera.org/getdata-033/lecture/59)) if you're not already familiar with them.

The script itself is broken down into sections which correspond to each of the steps in the requirements, along with a couple of extra bits at the
top. Walking down in order:

- Configuration variables: just lets you change the location of the data files if you want to for any reason.
- Ensure the packages we need are installed: self explanatory, I hope
- Sanity check: provide a nice error message if the script is run in the wrong directory
- Merge the data sets: define a few helper functions, then just read in the two main data sets (with `fread`) and merge them (with `rbindlist`).
- Extract the means and standard deviations: read the feature list to know which columns represent either means or standard deviations, then subset
the data table to extract just the appropriate columns. Looking at the `features` variable may be instructive as to how the subsetting is working.
- Name the activities: add the numeric activity IDs to the data set, then read in the list of activities and match the two up using the `inner_join`
  function from `dplyr`; this works very similarly to the `join` function from `plyr` covered in the [Merging
  data](https://class.coursera.org/getdata-033/lecture/39) lecture but is quicker :-) We don't need the numeric activity IDs any more, so drop them
  from the output here.
- Create descriptive variable names: just copies them from the `features` variable we defined above.
- Add subjects: none of the above needed the subject IDs, so we'll add them to the data set here.
- Create a tidy data set: `dplyr` really makes this one easy. No need to worry about working out how many columns you've got or anything like that,
  just let `dplyr` do all the heavy lifting. Finish by writing the data set out.
