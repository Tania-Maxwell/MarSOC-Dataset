# Tidal *Mar*sh *S*oil *O*rganic *C*arbon (MarSOC) Dataset

## Repository Structure

**`Maxwell_MarSOC_dataset.csv`**: .csv file containing the final dataset. The data structure is described in the **`Maxwell_MarSOC_dataset_metadata.csv`** file. It contains 17,522 records distributed amongst 29 countries. 
- `data_paper/`: folder containing the list of studies included in the dataset, as well as figures for this data paper (generated from the following R script: ‘reports/04_data_process/scripts/04_data-paper_data_clean.R’). 
- `reports/01_litsearchr/`: folder containing .bib files with references from the original naive search, a .Rmd document describing the litsearchr analysis using nodes to go from the naive search to the final search string, and the .bib files from this final search, which were then imported into sysrev for abstract screening. 
- `reports/02_sysrev/`: folder with .csv files exported from sysrev after abstract screening. These files contain the included studies with their various labels. 
- `reports/03_data_format/`: folder containing all original data, associated scripts, and exported data.
- `reports/04_data_process/`: folder containing data processing scripts to bind and clean the exported data, as well as a script testing the different models for predicting soil organic carbon from organic matter and finalising the equation using all available data. A script testing and removing outliers is also included. 


## Dataset Metadata 

<table>
    <tr>
        <td><strong>Variable name</strong></td>
        <td><strong>Units</strong></td>
        <td><strong>Descriptor</strong></td>
        <td><strong>Type</strong></td>
    </tr>
    <tr>
        <td>Source</td>
        <td></td>
        <td>Study from which the data was extracted</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Original_source</td>
        <td></td>
        <td>&quot;If the source study was a review, the original study of the data &quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Data_type</td>
        <td></td>
        <td>&quot;Core-level, site-level, or from a review&quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Site</td>
        <td></td>
        <td>The name of the site where core(s) were taken</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Core</td>
        <td></td>
        <td>Core ID</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Plot</td>
        <td></td>
        <td>&quot;If site-level data, identifier of the site&quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Site_name</td>
        <td></td>
        <td>Unique ID per plot or core</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Soil_type</td>
        <td></td>
        <td>&quot;Soil type (i.e., peat, sand, silt, mud) when specified&quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Latitude</td>
        <td>Decimal degrees</td>
        <td>Geographic coordinate of sample location in WGS84 (N - S)</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>Longitude</td>
        <td>Decimal degrees</td>
        <td>Geographic coordinate of sample location in WGS84 (E - W)</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>accuracy_flag</td>
        <td></td>
        <td>&quot;Accuracy of geographic coordinate (direct from dataset, averaged, or estimated using Google Earth) &quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Country</td>
        <td></td>
        <td>The name of the country where the soil cores were taken</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Admin_unit</td>
        <td></td>
        <td>&quot;Administrative unit below country level (Nation, State, Emirate)&quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Year_collected</td>
        <td></td>
        <td>&quot;The year of the collection. If cores were taken over several years, the year the collection started. &quot;</td>
        <td>Integer</td>
    </tr>
    <tr>
        <td>Year_collected_end</td>
        <td></td>
        <td>&quot;If cores were taken over several years, the last year collected&quot;</td>
        <td>Integer</td>
    </tr>
    <tr>
        <td>U_depth_m</td>
        <td>Metres</td>
        <td>Upper depth of soil core</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>L_depth_m</td>
        <td>Metres</td>
        <td>Lower depth of soil core</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>Method</td>
        <td></td>
        <td>&quot;Method used to measure organic carbon (%). Elemental analysis (EA), loss-on-ignition (LOI), Walkley Black &quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Conv_factor</td>
        <td></td>
        <td>Conversion factor used to convert soil organic matter measured via LOI to organic carbon</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>OC_perc</td>
        <td>%</td>
        <td>Soil organic carbon measurement</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>BD_g_cm3</td>
        <td>g cm-3</td>
        <td>Dry bulk density measurement</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>SOM_perc</td>
        <td>%</td>
        <td>Soil organic matter measurement</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>N_perc</td>
        <td>%</td>
        <td>&quot;Nitrogen (%), if measured alongside C in a CN analyser. &quot;</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>Time_replicate</td>
        <td></td>
        <td>&quot;Time replicate for soil sampled more than once a year (summer, winter, month-specific) &quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>Treatment</td>
        <td></td>
        <td>&quot;Site-specific information (control, invaded, univaded, grazed, ungrazed, historic-breach, managed realignment, post-fire) &quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>n_cores</td>
        <td></td>
        <td>&quot;Number of cores in site-level or review measurements, when data available&quot;</td>
        <td>Integer</td>
    </tr>
    <tr>
        <td>SOM_perc_mean</td>
        <td>%</td>
        <td>Mean of soil organic matter measured (data not at core-level)</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>SOM_perc_sd</td>
        <td>%</td>
        <td>Standard deviation of the mean of soil organic matter measured</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>OC_perc_mean</td>
        <td>%</td>
        <td>Mean of soil organic carbon measured (data not at core-level)</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>OC_perc_sd</td>
        <td>%</td>
        <td>Standard deviation of the mean of soil organic matter measured</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>OC_perc_se</td>
        <td>%</td>
        <td>Standard error of the mean of soil organic matter measured</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>BD_g_cm3_mean</td>
        <td>g cm-3</td>
        <td>Mean of dry bulk density measured (data not at core-level)</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>BD_g_cm3_sd</td>
        <td>g cm-3</td>
        <td>Standard deviation of the mean of dry bulk density measured</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>BD_g_cm3_se</td>
        <td>g cm-3</td>
        <td>Standard error of the mean of dry bulk density measured</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>OC_from_SOM_our_eq</td>
        <td>%</td>
        <td>&quot;Soil organic carbon estimated from soil organic matter using our equation (Figure 4, Table S1). &quot;</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>OC_obs_est</td>
        <td></td>
        <td>&quot;Method of OC measurement: “Observed”, “Estimated (study equation)” - OC from LOI with regional eq. (see Conv_factor column), “Estimated (our equation)” - OC from Loi with eq. 3&quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>OC_perc_final</td>
        <td>%</td>
        <td>&quot;Coalesce of all columns of OC_perc (OC_perc, OC_perc_mean, and OC_from_SOM_our_eq) &quot;</td>
        <td>Numeric</td>
    </tr>
    <tr>
        <td>Notes</td>
        <td></td>
        <td>&quot;Varying sample-specific notes (i.e., flagged outliers)&quot;</td>
        <td>Character</td>
    </tr>
    <tr>
        <td>DOI</td>
        <td></td>
        <td>Source study DOI url</td>
        <td>Character</td>
    </tr>
</table>


## Citation

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
	title = {Database: global marsh soil carbon},
	url = {},
	abstract = {},
	publisher = {FigShare},
	author = {Maxwell, Tania L. and Rovai, André S. and Adame, Maria Fernanda and Adams, Janine B. and Álvarez-Rogel, J. and Austin, William E.N. and Beasy, Kim and Boscutti, Francesco and Böttcher, Michael E. and Bouma, Tjeerd Joris and Bulmer, Richard H. and Burden, Annette and Burke, Shannon A. and Camacho, Saritta and Chaudhary, Doongar and Chmura, Gail L. and Copertino, Margareth and Cott, Grace M. and Craft, Christopher and Day, John and de los Santos, Carmen B. and Ding, Weixin and Denis, Lionel and Ellison, Joanna C. and Ewers Lewis, Carolyn J. and Giani, Luise and Gispert, Maria and Gontharet, Swanne and González-Pérez, José A. and González-Alcaraz, M. Nazaret and Gorham, Connor and Graversen, Anna Elizabeth and Grey, Anthony and Guerra, Roberta  and He, Qiang and Holmquist, James R. and Jones, Alice R. and Juanes, José A. and Kelleher, Brian P and Kohfeld, Karen and Krause-Jensen, Dorte and Lafratta, Anna and Lavery, Paul S and Laws, Edward A. and Leiva-Dueñas, Carmen and Loh, Pei Sun and Lovelock, Catherine E. and Lundquist, Carolyn J. and Macreadie, Peter I. and Mazarrasa, Inés and Megonigal, J. Patrick and Neto, Joao M. and Nogueira, Juliana and Osland, Michael J. and Pagès, Jordi F. and Perera, Nipuni and Pfeiffer, Eva-Maria and Pollmann, Thomas and Raw, Jacqueline L. and Recio, María and Ruiz-Fernández, Ana Carolina and Russell , Sophie K. and Rybczyk, John M. and Sammul, Marek and Sanders, Christian and Santos , Rui and Serrano, Oscar and Siewert, Matthias and Smeaton, Craig and Song, Zhaoliang and Trasar-Cepeda, Carmen and Twilley, Robert R. and Van de Broek, Marijn and Vitti, Stefano and Vittori Antisari, Livia and Voltz, Baptiste and Wails, Christy and Ward, Raymond D. and Ward, Melissa and Wolfe, Jaxine and Yang, Renmin and Zubrzycki, Sebastian and Landis, Emily and Smart, Lindsey and Spalding, Mark D. and Worthington, Thomas A.},
	date = {2023},
	doi = {},
}
</p> 
</div>


## Licence

Creative Commons License (CC0)

## Acknowledgements 

We would like to thank everyone who contributed to the collection of the soil cores and their lab analyses, without whom this dataset compilation would not be possible. Specifically, we would like to thank Andre Rovai, Maria Fernanda Adame, Janine B. Adams, J. Álvarez-Rogel, William E.N. Austin, Kim Beasy, Francesco Boscutti, Michael E. Böttcher, Tjeerd Joris Bouma, Richard H. Bulmer, Annette Burden, Shannon A. Burke, Saritta Camacho, Doongar Chaudhary, Gail L. Chmura, Margareth Copertino, Grace M. Cott, Christopher Craft, John Day, Carmen B. de los Santos, Weixin Ding, Lionel Denis, Joanna C. Ellison, Carolyn J. Ewers Lewis, Luise Giani, Maria Gispert, Swanne Gontharet, José A. González-Pérez, M. Nazaret González-Alcaraz, Connor Gorham, Anna Elizabeth Graversen, Anthony Grey, Roberta  Guerra, Qiang He, James R. Holmquist, Alice R. Jones, José A. Juanes, Brian P Kelleher, Karen Kohfeld, Dorte Krause-Jensen, Anna Lafratta, Paul S Lavery, Edward A. Laws, Carmen Leiva-Dueñas, Pei Sun Loh, Catherine E. Lovelock, Carolyn J. Lundquist, Peter I. Macreadie, Inés Mazarrasa, J. Patrick Megonigal, Joao M. Neto, Juliana Nogueira, Michael J. Osland, Jordi F. Pagès, Nipuni Perera, Eva-Maria Pfeiffer, Thomas Pollmann, Jacqueline L. Raw, María Recio, Ana Carolina Ruiz-Fernández, Sophie K. Russell , John M. Rybczyk, Marek Sammul, Christian Sanders, Rui Santos , Oscar Serrano, Matthias Siewert, Craig Smeaton, Zhaoliang Song, Carmen Trasar-Cepeda, Robert R. Twilley, Marijn Van de Broek, Stefano Vitti, Livia Vittori Antisari, Baptiste Voltz, Christy Wails, Raymond D. Ward, Melissa Ward, Jaxine Wolfe, Renmin Yang, Sebastian Zubrzycki, Emily Landis, Lindsey Smart, Mark Spalding, and Thomas A. Worthington. The research was funded by The Nature Conservancy through the Bezos Earth Fund and other donor support. 

## Contact

For any queries, please contact Tania L. Maxwell (taniamaxwell7 [at] gmail.com). This dataset is currently being formatted for incoporation into the [Coastal Carbon Atlas](https://ccrcn.shinyapps.io/CoastalCarbonAtlas/). 