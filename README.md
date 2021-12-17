# BIOSTAT 625 - Group 8

# Project Description:

Hospital beds, wards and laboratories are important health care resources with limited availability. Inefficient health resources management will result in lower profits for hospitals and overall higher costs for society. Prolonged waiting time and care delays could also be the problems. To deal with those issues, we think the length of stay(LOS) will be a good indicator since it explains up to 90% interpatient variation in hospital costs. 

In this project, The Medical Information Mart for Intensive Care III(MIMIC-III), a large, real-world and de-identified collection of medical records, is used. There are over 700 million rows in all 40 tables in the original dataset. After selecting and literature reviewing, we finally decide to use 6 of them. 

Although MIMIC-III is publicly-available database, it has restriction and cannot be public without premission. Therefore, we do not include datasets in this GitHub page.

# Major Files:

## demo_datamerge.R

Because the whole MIMIC-III is giant, we develop this R script using a small demo data. This script is tested locally and comfirmed bug-free. The major purpose of this script is to conduct data cleaning, merge tables, and generate exploratory results. 

## demo_datamerge_final.R

This is script serves the same purpose as the first file but the final version, with which we process data in Biostatistics Cluster. After running this script, new dataset is obtained and ready for model fitting. 


## Classifying_LoS_ML_mimic3.ipynb
This script is used for data exploration and classifying the outcome using several maching learning methods(including SVM and Random Forest).

# Partial Results:
## Merged Data Description
The original data includes 58976 observations with 11573 missing values. When exclude "diagnosis" as a variable, there are 33 columns in total; when include "diagnosis", there are 14566 columns.

Result of exploration of the variables are shown as below.(see more details in [Classifying_LoS_ML_mimic3.ipynb](https://github.com/Orion-qx/biostat625-group8/Classifying_LoS_ML_mimic3.ipynb))

![Exploratory Analysis on Categorical variables]("https://github.com/Orion-qx/biostat625-group8/blob/main/img/age.png")

![Distribution of Age]("https://github.com/Orion-qx/biostat625-group8/blob/main/img/age.png")

## Classification
outcome variable: y: (length of stay in hospital > 5 days)

80% of the data are used for training and 20% of them are used for testing.

(Please see more details in [Classifying_LoS_ML_mimic3.ipynb](https://github.com/Orion-qx/biostat625-group8/Classifying_LoS_ML_mimic3.ipynb))

### SVM(exclude diagnosis)
With 5 fold cv, the unbiased accuracy score is around 0.6966.

### Random Forest(exclude diagnosis)
With 5 fold cv, the unbiased accuracy score is around 0.6964.

Turning for 24 pairs of hyperparameters, the best pair of hyperparameter results in AUC=0.74.

### Random Forest(include diagnosis)
With the same procedure but include diagnosis as a variable, the best pair of hyperparameter results in AUC=0.71 after testing for 24 pairs of hyperparameters.





