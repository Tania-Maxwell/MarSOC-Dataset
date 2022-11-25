when reformatting more training data
1. create new folder (in core-level, site-level or meta-analysis) for data 'reports/03_data_format/data/./...'
2. create script with first author last name _ year 'reports/03_data_format/scritps/...'
3. this exports to 'reports/03_data_format/data/exported/...'
3. compile all data using script 'reports/03_data_format/data/bind/combine_datasets.R' 
4. clean data (merge columns, create column with raw and site-level values) using script 'reports/04_data_clean/scripts/01_data_clean.R' 
5. run 02_SOM_to_OC if have both SOM and OC data, to regenerate the conversion equation  'reports/04_data_clean/scripts/02_SOM_to_OC.R' 