# library
library(dplyr)
library(pheatmap)

# load dataset============================================================
admission <- read.csv("ADMISSIONS.CSV")
patients <- read.csv("PATIENTS.csv")
ICUstays <- read.csv("ICUSTAYS.csv")
diagnoses_icd <- read.csv("DIAGNOSES_ICD.csv")
D_ICD <- read.csv("D_ICD_DIAGNOSES.csv")
lab_events <- read.csv("LABEVENTS.csv")
D_labitems <- read.csv("D_LABITEMS.csv")

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
ICUstays.new <- ICUstays %>% group_by(hadm_id) %>% mutate(los_sum = sum(los)) %>% distinct(subject_id, hadm_id, los_sum)

#merge data================================================================
## merge gender, dob from patients.csv to admissions
admission.new <- left_join(admission.new, patients.new, by = 'subject_id')

## using PATIENTS.csv(bod) and ADMISSION.csv(admittime) to calculate the age
admission.new$admit_age_yr <- as.numeric(difftime(admission.new$admittime,admission.new$dob,units = "weeks" ))/52.25

## merge los from ICUstays to admission.new
admission.new <- left_join(admission.new, ICUstays.new[,c("los_sum", "hadm_id", "subject_id")], by = c("hadm_id","subject_id"))

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
unique(admission.new[admission.new$admit_age_yr >= 299,"subject_id"])
#######################################################

admission.new$admit_age_yr <- ifelse(admission.new$admit_age_yr > 299, 90, admission.new$admit_age_yr)

write.csv(admission.new, "merged_data.csv")

## graph
continuous <- admission.new[,sapply(admission.new,is.numeric)]
corr <- cor(continuous[,-c(1:2)])
pheatmap(corr,cluster_rows = F,cluster_cols = F,color = colorRampPalette(c("white","navy"))(50))

ggplot(admission.new) + geom_point(aes(x = admit_age_yr, y = log(los_sum))) + 
  xlab("Patients' Age when Admitted") + 
  ylab("log of longth of stay")

ggplot(admission.new) + geom_boxplot(aes(x = gender, y = log(los_sum)))


#pheatmap(corr,color = colorRampPalette(c("#ABC6D9",'#D8D8C0',"#D9ACAB"))(256))

  #CNV_draw,
         #cluster_rows = F,cluster_cols = T,scale = 'row',border_color = "grey",
         #fontsize_row = 6, fontsize_col = 7,
         #clustering_distance_cols = 'correlation',
         #annotation_row=annotation_row,annotation_names_row = F,
         #show_rownames = F,annotation_legend = T,
         #color = colorRampPalette(c("navy", "white", "firebrick3"))(50))
#CNV_heat3<-pheatmap(CNV_draw,
                    

