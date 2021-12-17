# library
library(dplyr)

# load dataset============================================================
admission <- read.csv("ADMISSIONS.csv")
patients <- read.csv("PATIENTS.csv")
ICUstays <- read.csv("ICUSTAYS.csv")
diagnoses_icd <- read.csv("DIAGNOSES_ICD.csv")
D_ICD <- read.csv("D_ICD_DIAGNOSES.csv")
lab_events <- read.csv("LABEVENTS.csv")
D_labitems <- read.csv("D_LABITEMS.csv")

colnames(admission) <- tolower(colnames(admission))
colnames(patients) <- tolower(colnames(patients))
colnames(ICUstays) <- tolower(colnames(ICUstays))
colnames(diagnoses_icd) <- tolower(colnames(diagnoses_icd))
colnames(D_ICD) <- tolower(colnames(D_ICD))
colnames(lab_events) <- tolower(colnames(lab_events))
colnames(D_labitems) <- tolower(colnames(D_labitems))


adm.var <- c("subject_id","hadm_id", "admittime", "dischtime", 'admission_type',
             'ethnicity','marital_status', 'diagnosis','hospital_expire_flag','deathtime')
admission.new <- admission[,adm.var]

pat.var <- c("subject_id", 'gender', 'dob')
patients.new <- patients[,pat.var]

# for each patient ID calculate the precentage of abnormal
labevents_new <- lab_events %>% group_by(subject_id, hadm_id) %>% mutate(abnorm_percent = sum(flag == "abnormal")/n()) %>% distinct(subject_id, hadm_id, abnorm_percent)

# keep seq_num == 1 for diagnosis and keep # of ICD_9
diagnoses_icd <- diagnoses_icd %>% group_by(subject_id, hadm_id) %>% mutate(num_icd = n())
diagnoses_icd.new <- diagnoses_icd[diagnoses_icd$seq_num==1,]
# group by hadm_id to get los
ICUstays.new <- ICUstays %>% group_by(hadm_id) %>% mutate(ICU_los_sum = sum(los), ICU_times = n_distinct(icustay_id)) %>% distinct(subject_id, hadm_id, ICU_los_sum, ICU_times)

#merge data================================================================
## merge gender, dob from patients.csv to admissions
admission.new <- left_join(admission.new, patients.new, by = 'subject_id')

## calculate days stay in hospital
admission.new$hospital_los <- as.numeric(difftime(admission.new$dischtime, admission.new$admittime, units = "days"))

## using PATIENTS.csv(bod) and ADMISSION.csv(admittime) to calculate the age
admission.new$admit_age_yr <- as.numeric(difftime(admission.new$admittime,admission.new$dob,units = "weeks" ))/52.25

## merge los from ICUstays to admission.new
admission.new <- left_join(admission.new, ICUstays.new[,c("ICU_los_sum", "hadm_id", "subject_id", "ICU_times")], by = c("hadm_id","subject_id"))

## merge seq_num, icd9_code from diagnoses_icd to admission.new
admission.new <- left_join(admission.new, diagnoses_icd.new[,c('subject_id','icd9_code', "hadm_id", "num_icd")],by = c('subject_id', "hadm_id"))

## add ICD codes' short title and long tile from D_ICD_DIAGNOSES.csv to admission.new
admission.new <- left_join(admission.new, D_ICD[,-1], by = 'icd9_code')

## merge labevents to admission.new
admission.new <- left_join(admission.new, labevents_new, by = c('subject_id', "hadm_id"))

## merge D_LABITEMS.csv to admission.new
#admission.new <- left_join(admission.new, D_labitems[,-1], by = c("itemid"))

#######################################################
### some patients age 300 means age > 89
#unique(admission.new[admission.new$admit_age_yr >= 299,"subject_id"])
#######################################################

admission.new$admit_age_yr <- ifelse(admission.new$admit_age_yr > 299, 90, admission.new$admit_age_yr)

## combine race
### combine UNKNOWN/NOT SPECIFIED
rename_race <- function(words) {
  temp_w <- unlist(strsplit(as.character(words), split = " "))[1]
  temp_w <- unlist(strsplit(as.character(temp_w), split = "/"))[1]
  if (temp_w == "UNKNOWN" | temp_w == "PATIENT" | temp_w == "UNABLE") {
    temp_w = "UNKNOWN"
  } else if (temp_w == "AMERICAN") {
    temp_w = "AMERICAN NATIVE"
  } else if (temp_w == "NATIVE") {
    temp_w = "NATIVE HAWAIIAN"
  } else if (temp_w == "MIDDLE") {
    temp_w = "MIDDLE EASTERN"
  } else if (temp_w == "MULTI") {
    temp_w = "MULTI RACE"
  } else if (temp_w == "SOUTH") {
    temp_w = "SOUTH AMERICAN"
  }
  return(temp_w)
}
admission.new$ethnicity_adj <- as.factor(unlist(lapply(admission.new$ethnicity, rename_race)))


write.csv(admission.new, "merged_data.csv")



