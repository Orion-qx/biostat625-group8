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

![Exploratory Analysis on Categorical variables](https://github.com/Orion-qx/biostat625-group8/blob/main/img/categorical_v.png)

![Distribution of Age](https://github.com/Orion-qx/biostat625-group8/blob/main/img/age.png)

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


# References:  
[1] Rapoport, John, et al. “Length of Stay Data as a Guide to Hospital Economic Performance for ICU Patients.” Medical Care, vol. 41, no. 3, Mar. 2003, pp. 386–397., https://doi.org/10.1097/01.mlr.0000053021.93198.96.   
[2] Mekhaldi R.N., Caulier P., Chaabane S., Chraibi A., Piechowiak S. (2020) Using Machine Learning Models to Predict the Length of Stay in a Hospital Setting. In: Rocha Á., Adeli H., Reis L., Costanzo S., Orovic I., Moreira F. (eds) Trends and Innovations in Information Systems and Technologies. WorldCIST 2020. Advances in Intelligent Systems and Computing, vol 1159. Springer, Cham. https://doi.org/10.1007/978-3-030-45688-7_21  
[3] Liu Yingxin , Phillips Mike Codde Jim (2001) Factors influencing patients' length of stay. Australian Health Review 24, 63-70., https://doi.org/10.1071/AH010063  
[4] Kelly, Maria, et al. “Factors Predicting Hospital Length-of-Stay and Readmission after Colorectal Resection: A Population-Based Study of Elective and Emergency Admissions.” BMC Health Services Research, BioMed Central, 26 Mar. 2012, https://link.springer.com/article/10.1186/1472-6963-12-77.  
[5] Wang, Ying, et al. “Factors Associated with a Prolonged Length of Stay after Acute Exacerbation of Chronic Obstructive Pulmonary Disease (AECOPD).” International Journal of Chronic Obstructive Pulmonary Disease, Dove Medical Press, 20 Jan. 2014, https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3901775/.  
[6] Yoon, Philip, et al. “Analysis of Factors Influencing Length of Stay in the Emergency Department.” Canadian Journal of Emergency Medicine, vol. 5, no. 3, 2003, pp. 155–161., doi:10.1017/S1481803500006539.  
[7] T. Gentimis, A. J. Alnaser, A. Durante, K. Cook and R. Steele, "Predicting Hospital Length of Stay Using Neural Networks on MIMIC III Data," 2017 IEEE 15th Intl Conf on Dependable, Autonomic and Secure Computing, 15th Intl Conf on Pervasive Intelligence and Computing, 3rd Intl Conf on Big Data Intelligence and Computing and Cyber Science and Technology Congress(DASC/PiCom/DataCom/CyberSciTech), 2017, pp. 1194-1201, doi: 10.1109/DASC-PICom-DataCom-CyberSciTec.2017.191.  
[8] B. Thompson, K. O. Elish and R. Steele, "Machine Learning-Based Prediction of Prolonged Length of Stay in Newborns," 2018 17th IEEE International Conference on Machine Learning and Applications (ICMLA), 2018, pp. 1454-1459, doi: 10.1109/ICMLA.2018.00236.  
[9] Johnson, A., Pollard, T., Shen, L. et al. MIMIC-III, a freely accessible critical care database. Sci Data 3, 160035 (2016). https://doi.org/10.1038/sdata.2016.35  
[10] Felipe_Torres. “Query Builder v1.2.” Query Builder, https://querybuilder-lcp.mit.edu/.   
[11] “1.4. Support Vector Machines.” Scikit, https://scikit-learn.org/stable/modules/svm.html#:~:text=Support%20vector%20machines%20(SVMs)%20are,than%20the%20number%20of%20samples.   
[12] “Sklearn.ensemble.randomforestclassifier.” Scikit, https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html.   



