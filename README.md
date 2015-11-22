Getting and Cleaning Data Project


This is the course project for Getting and Cleaning data coursera course. The R script run_analysis.R does the following:

1. Download the data set if it doesnt already exist
2. Load the train & test dataset along with activity and feature info
3. Merge the training and test data set, keeping only those columns that reflects mean or standard deviation
4. From the selected data above, changing column names to more meningful names.
5. Finally calculating average values for each columns by activity and subject and writting the data into tidyData.txt file.