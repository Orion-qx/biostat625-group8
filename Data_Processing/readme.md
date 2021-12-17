# Major Files:

## demo_datamerge.R

Because the whole MIMIC-III is giant, we develop this R script using a small demo data. This script is tested locally and comfirmed bug-free. The major purpose of this script is to conduct data cleaning, merge tables, and generate exploratory results. 

## demo_datamerge_final.R

This is script serves the same purpose as the first file but the final version, with which we process data in Biostatistics Cluster. After running this script, new dataset is obtained and ready for model fitting. 

## job_final.txt
A txt file submitted to biostatistics cluster and reduce the time of data processing from 1 hour to 2 minutes.