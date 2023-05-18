# Repository Structure

**`Maxwell_marshC_dataset.csv`**: .csv file containing the final dataset. The data structure is described in Table 1, as well as in the **`Maxwell_marshC_dataset_metadata.csv`** file. It contains 17,522 records distributed amongst 29 countries. 
- `data_paper/`: folder containing the list of studies included in the dataset, as well as figures for this data paper (generated from the following R script: ‘reports/04_data_process/scripts/04_data-paper_data_clean.R’). 
- `reports/01_litsearchr/`: folder containing .bib files with references from the original naive search, a .Rmd document describing the litsearchr analysis using nodes to go from the naive search to the final search string, and the .bib files from this final search, which were then imported into sysrev for abstract screening. 
- `reports/02_sysrev/`: folder with .csv files exported from sysrev after abstract screening. These files contain the included studies with their various labels. 
- `reports/03_data_format/`: folder containing all original data, associated scripts, and exported data.
- `reports/04_data_process/`: folder containing data processing scripts to bind and clean the exported data, as well as a script testing the different models for predicting soil organic carbon from organic matter and finalising the equation using all available data. A script testing and removing outliers is also included. 


# Dataset Metadata 

<table class=MsoNormalTable border=0 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;mso-yfti-tbllook:1184'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes'>
  <td valign=top style='border:solid black 1.0pt;background:#F7AF72;padding:
  2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;text-align:justify;line-height:
  normal'><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Variable name</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border:solid black 1.0pt;border-left:none;mso-border-left-alt:
  solid black 1.0pt;background:#F7AF72;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;text-align:justify;line-height:
  normal'><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Units</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border:solid black 1.0pt;border-left:none;mso-border-left-alt:
  solid black 1.0pt;background:#F7AF72;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;text-align:justify;line-height:
  normal'><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Descriptor</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border:solid black 1.0pt;border-left:none;mso-border-left-alt:
  solid black 1.0pt;background:#F7AF72;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;text-align:justify;line-height:
  normal'><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Type</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Source</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Study from which
  the data was extracted</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:2'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Original_source</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>If the source study
  was a review, the original study of the data&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Data_type</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Core-level,
  site-level, or from a review</span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:4'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Site</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>The name of the
  site where core(s) were taken</span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:5'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Core</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Core ID&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Plot</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>If site-level data,
  identifier of the site</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Site_name</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Unique ID per plot
  or core&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Soil_type</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Soil type (i.e.,
  peat, sand, silt, mud) when specified</span><span style='font-size:12.0pt;
  font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Latitude</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Decimal degrees</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Geographic
  coordinate of sample location in WGS84 (N - S)&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Longitude</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Decimal degrees</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Geographic
  coordinate of sample location in WGS84 (E - W)&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>accuracy_flag</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Accuracy of
  geographic coordinate (direct from dataset, averaged, or estimated using
  Google Earth)&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Country</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>The name of the
  country where the soil cores were taken&nbsp;</span><span style='font-size:
  12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Admin_unit</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Administrative unit
  below country level (Nation, State, Emirate)</span><span style='font-size:
  12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Year_collected</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>The year of the
  collection. If cores were taken over several years, the year the collection
  started.&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Integer</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:15'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Year_collected_end</span></span><span style='font-size:12.0pt;
  font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>If cores were taken
  over several years, the last year collected</span><span style='font-size:
  12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Integer</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:16'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>U_depth_m</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Metres</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Upper depth of soil
  core</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:17'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>L_depth_m</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Metres</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Lower depth of soil
  core</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:18'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Method</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Method used to
  measure organic carbon (%). Elemental analysis (EA), loss-on-ignition (LOI),
  Walkley Black&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:19'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Conv_factor</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Conversion factor
  used to convert soil organic matter measured via LOI to organic carbon</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:20'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_perc</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Soil organic carbon
  measurement</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:21'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>BD_g_cm3</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>g <span
  class=GramE>cm<sup><span style='font-size:5.0pt'>-3</span></sup></span></span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Dry bulk density
  measurement</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:22'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>SOM_perc</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Soil organic matter
  measurement</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:23'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>N_perc</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Nitrogen (%), if
  measured alongside C in a CN analyser.&nbsp;</span><span style='font-size:
  12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:24'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>Time_replicate</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Time <span
  class=GramE>replicate</span> for soil sampled more than once a year (summer,
  winter, month-specific)&nbsp;</span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:25'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Treatment</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Site-specific
  information (control, invaded, <span class=SpellE>univaded</span>, grazed, <span
  class=SpellE>ungrazed</span>, historic-breach, managed realignment,
  post-fire)&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:26'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>n_cores</span></span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Number of cores in
  site-level or review <span class=GramE>measurements, when</span> data
  available</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Integer</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:27'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>SOM_perc_mean</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Mean of soil
  organic matter measured (data not at core-level)</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:28'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>SOM_perc_sd</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Standard deviation
  of the mean of soil organic matter measured&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:29'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_perc_mean</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Mean of soil
  organic carbon measured (data not at core-level)</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:30'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_perc_sd</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Standard deviation
  of the mean of soil organic matter measured&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:31'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_perc_se</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Standard error of
  the mean of soil organic matter measured</span><span style='font-size:12.0pt;
  font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:32'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>BD_g_cm3_mean</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>g <span
  class=GramE>cm<sup><span style='font-size:5.0pt'>-3</span></sup></span></span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Mean of dry bulk
  density measured (data not at core-level)</span><span style='font-size:12.0pt;
  font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:33'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>BD_g_cm3_sd</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>g <span
  class=GramE>cm<sup><span style='font-size:5.0pt'>-3</span></sup></span></span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Standard deviation
  of the mean of dry bulk density measured&nbsp;</span><span style='font-size:
  12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:34'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>BD_g_cm3_se</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>g <span
  class=GramE>cm<sup><span style='font-size:5.0pt'>-3</span></sup></span></span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Standard error of
  the mean of dry bulk density measured&nbsp;</span><span style='font-size:
  12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:35'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_from_SOM_our_eq</span></span><span style='font-size:12.0pt;
  font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Soil organic carbon
  estimated from soil organic matter using our equation (Figure 4, Table
  S1).&nbsp;</span><span style='font-size:12.0pt;font-family:"Times New Roman",serif;
  mso-fareast-font-family:"Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:36'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_obs_est</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Method of OC
  measurement: “Observed”, “Estimated (study equation)” - OC from LOI with
  regional eq. (see <span class=SpellE>Conv_factor</span> column), “Estimated
  (our equation)” - OC from <span class=SpellE>Loi</span> with eq. 3</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:37'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  class=SpellE><span style='font-size:8.0pt;font-family:"Arial",sans-serif;
  mso-fareast-font-family:"Times New Roman";color:black;mso-fareast-language:
  EN-GB'>OC_perc_final</span></span><span style='font-size:12.0pt;font-family:
  "Times New Roman",serif;mso-fareast-font-family:"Times New Roman";mso-fareast-language:
  EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>%</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Coalesce of all
  columns of <span class=SpellE>OC_perc</span> (<span class=SpellE>OC_perc</span>,
  <span class=SpellE>OC_perc_mean</span>, and <span class=SpellE>OC_from_SOM_our_eq</span>)&nbsp;</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Numeric</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:38;mso-yfti-lastrow:yes'>
  <td valign=top style='border:solid black 1.0pt;border-top:none;mso-border-top-alt:
  solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Notes</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'></td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Varying sample-specific
  notes (i.e., flagged outliers)</span><span style='font-size:12.0pt;
  font-family:"Times New Roman",serif;mso-fareast-font-family:"Times New Roman";
  mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
  <td valign=top style='border-top:none;border-left:none;border-bottom:solid black 1.0pt;
  border-right:solid black 1.0pt;mso-border-top-alt:solid black 1.0pt;
  mso-border-left-alt:solid black 1.0pt;padding:2.15pt 2.15pt 2.15pt 2.15pt'>
  <p class=MsoNormal style='margin-bottom:0cm;line-height:normal'><span
  style='font-size:8.0pt;font-family:"Arial",sans-serif;mso-fareast-font-family:
  "Times New Roman";color:black;mso-fareast-language:EN-GB'>Character</span><span
  style='font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
  "Times New Roman";mso-fareast-language:EN-GB'><o:p></o:p></span></p>
  </td>
 </tr>
</table>


# Citation

When using data from this dataset please cite both the publication and the dataset. The dataset version from DD-MM-2023 is archived in the following Figshare repository: [insert Figshare url]. 

<div>
<p> 
@article{maxwell_global_2023,
	title = {},
	volume = {},
	issn = {},
	url = {},
	abstract = {,
	journaltitle = {},
	author = {},
	urldate = {},
	date = {},
}

@misc{maxwell_data_2023,
	title = {},
	url = {},
	abstract = {},
	publisher = {},
	author = {},
	date = {2023},
	doi = {},
}
</p> 
</div>


# Licence

Creative Commons Attribution 4.0 International Public License (CC-BY)

# Acknowledgements 

We would like to thank everyone who contributed to the collection of the soil cores and their lab analyses, without whom this dataset compilation would not be possible. Specifically, we would like to thank Andre Rovai, Maria Fernanda Adame, Janine B. Adams, J. Álvarez-Rogel, William E.N. Austin, Kim Beasy, Francesco Boscutti, Michael E. Böttcher, Tjeerd Joris Bouma, Richard H. Bulmer, Annette Burden, Shannon A. Burke, Saritta Camacho, Doongar Chaudhary, Gail L. Chmura, Margareth Copertino, Grace M. Cott, Christopher Craft, John Day, Carmen B. de los Santos, Weixin Ding, Lionel Denis, Joanna C. Ellison, Carolyn J. Ewers Lewis, Luise Giani, Maria Gispert, Swanne Gontharet, José A. González-Pérez, M. Nazaret González-Alcaraz, Connor Gorham, Anna Elizabeth Graversen, Anthony Grey, Roberta  Guerra, Qiang He, James R. Holmquist, Alice R. Jones, José A. Juanes, Brian P Kelleher, Karen Kohfeld, Dorte Krause-Jensen, Anna Lafratta, Paul S Lavery, Edward A. Laws, Carmen Leiva-Dueñas, Pei Sun Loh, Catherine E. Lovelock, Carolyn J. Lundquist, Peter I. Macreadie, Inés Mazarrasa, J. Patrick Megonigal, Joao M. Neto, Juliana Nogueira, Michael J. Osland, Jordi F. Pagès, Nipuni Perera, Eva-Maria Pfeiffer, Thomas Pollmann, Jacqueline L. Raw, María Recio, Ana Carolina Ruiz-Fernández, Sophie K. Russell , John M. Rybczyk, Marek Sammul, Christian Sanders, Rui Santos , Oscar Serrano, Matthias Siewert, Craig Smeaton, Zhaoliang Song, Carmen Trasar-Cepeda, Robert R. Twilley, Marijn Van de Broek, Stefano Vitti, Livia Vittori Antisari, Baptiste Voltz, Christy Wails, Raymond D. Ward, Melissa Ward, Jaxine Wolfe, Renmin Yang, Sebastian Zubrzycki, Emily Landis, Lindsey Smart, Mark Spalding, and Thomas A. Worthington. The research was funded by The Nature Conservancy through the Bezos Earth Fund and other donor support. 

# Contact

For any queries, please contact Tania L. Maxwell (taniamaxwell7 [at] gmail.com). This dataset is currently being formatted for incoporation into the [Coastal Carbon Atlas](https://ccrcn.shinyapps.io/CoastalCarbonAtlas/). 