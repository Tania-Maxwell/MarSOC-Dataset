merge_csv_export_authors.Rmd : script to merge sysrev output with original input bibliography to get the associated DOIs. 
Script also exports list of authors from studies. Also beginnings of script to export PDFs (not used). 

1. sysrev_raw_refs.ris AND sysrev_raw_refs.bib : references imported to https://sysrev.com/u/6789/p/119559 

2. sysrev_raw_refs_export.ris: same as sysrev_raw_refs.ris with different order (TY then AU) for import to Zotero

3. raw_refs_merged.csv : merged data frame of relabeled raw refs from sysrev (from "eports/02_sysrev/sysrev_exports_relabel/UserAnswers_P119559_0804_A1168.csv")
and original refs exported to sysrev ("reports/01_litsearchr/exported_to_sysrev_raw") to get DOIs from each study

4. raw_refs_reduced.csv : abstracts labelled as locations of interest and including primary data after 2nd sysrev abstract labelling

5. synthesisr_bibliography.bib: references corresponding to raw_refs_reduced.csv

6. raw_refs_reduced_labelled.csv : edited raw_refs_reduced.csv using Google Sheets. Refs labelled as "Review and Raw" in the 1st round of sysrev abstract labelled
additionally added at the end to centalize review of studies. Downloaded 16.05.23

Following files generated to identify authors to contact asking for data from references: 

7.  raw_refs_reduced_author-list.csv : list of all authors in the raw_refs_reduced.csv file

8. raw_refs_all_author-list.csv : list of all authors in the raw_refs_merged.csv file to look for authors with several studies

9. raw_refs_all_author-list_duplicates.csv : list of all authors which were included in more than one study
