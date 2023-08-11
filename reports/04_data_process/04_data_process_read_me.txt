when reformatting more training data
1. create new folder (in core-level, site-level or meta-analysis) for data 'reports/03_data_format/data/./...'
2. create script with first author last name _ year 'reports/03_data_format/scritps/...'
3. this exports to 'reports/03_data_format/data/exported/...'
3. compile all data using script 'reports/03_data_format/data/bind/combine_datasets.R' 
4. clean data (merge columns, create column with raw and site-level values) using script 'reports/04_data_process/scripts/01_data_clean.R' 
5. identify and flag outliers using script 'reports/04_data_process/scripts/02_outliers.R' 
6. run 03_SOM_to_OC if have both SOM and OC data, to regenerate the conversion equation 'reports/04_data_process/scripts/03_SOM_to_OC.R' 
7. generate point map, data histograms and calculate SOC density and stocks using the script 'reports/04_data_process/scripts/04_data-paper_data_clean.R' 
8. run SOM_to_OC_per_study.R for study-level relationship between SOM and SOC (Fig. S2)