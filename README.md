# The folder contains
1. the dataset folder with the intial data, unmodified, for description of them, see the README and other files in it
2. the mean_std_dataset.txt file with all data assembled from dataset
3. the mean_std_ave_over_subject_and_activity.txt file that computed averaged values of variables (mean and std variables only) over repeated observations for a given couple (subject , activity)
4. the run_analysis.R script used to generate the data
5. the CodeBook.md containing all available informations about the experiments, variables, and the way they were obtained

# the run_analysis.R
* gets the data from training and testing set (subject id, activity, and features measured)
* concatenates them in a tidy data set with one variable per column and one row per observation
* gets the features name from the corresponding file in the dataset folder and assign them to variables names
* replaces activity id by explicit activity factor
* keeps only mean and std for each feature
* averages features over each possible (subject,id) association 
* returns a tidy data set with one row per possible (ie 180 in this case).

You will find explicit comment all along the file to help you understand it
