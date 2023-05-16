merge_csv_export_authors.Rmd : script to merge sysrev output with original input bibliography to get the associated DOIs. 
Script also exports list of authors from studies. Also beginnings of script to export PDFs (not used). 

1. sysrev_review_refs.ris AND sysrev_review_refs.bib : references exported from systev as "Review" from https://sysrev.com/p/117521

2. review_refs_merged.csv : merged data frame of review refs from sysrev (from "exports/02_sysrev/sysrev_exports/sysrev_review.csv")
and original refs exported to sysrev ("reports/01_litsearchr/exported_to_sysrev/") to get DOIs from each study

3. review_refs_merged_labelled.csv : edited raw_refs_reduced.csv using Google Sheets. Refs labelled as "Review and Raw" in the 1st round of sysrev abstract labelled
additionally added at the end to centalize review of studies. Downloaded 16.05.23
