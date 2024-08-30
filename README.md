# Global_Whale_Ship

### DATASET TITLE:
Code and data for the article: "Ship collision risk threatens whales across the world’s oceans"

### AUTHOR INFORMATION:
Name: Anna C. Nisi
Institution: University of Washington
Email: anisi@uw.edu

### DATA AND FILE OVERVIEW:
1. fit_ISDM.R
2. global_whale_ship_risk.csv
3. shipping_density.csv
4. blue_whale_isdm_data.csv
5. fin_whale_isdm_data.csv
6. humpback_whale_isdm_data.csv
7. sperm_whale_isdm_data.csv
8. prediction_data_north_pacific/

    * a. prediction_data_1.csv
    * b. prediction_data_2.csv
    * c. prediction_data_3.csv
    * d. prediction_data_4.csv
    * e. prediction_data_5.csv
    * f. prediction_data_6.csv
    * g. prediction_data_7.csv
    * h. prediction_data_8.csv
    * i. prediction_data_9.csv
    * j. prediction_data_10.csv
    * k. prediction_data_11.csv
    * l. prediction_data_12.csv
  
### DATA-SPECIFIC INFORMATION FOR: fit_ISDM.R

1. Description: Worked example code to fit whale integrated species distribution model (ISDM) incorporating survey, sightings, whaling records, and tagging data. Code includes data formatting and setup, model fitting, model validation, and spatial prediction and visualization. This script is applied to blue_whale_isdm_data.csv and the csv files within the prediction_data_north_pacific folder.

### DATA-SPECIFIC INFORMATION FOR: global_whale_ship_risk.csv

1. Number of variables: 37

2. Description: This data file contains the shipping traffic index, whale space-use index, whale ship-strike risk, ship-strike risk hotspots, and management information at 1 degree resolution for blue, fin, humpback, and sperm whales.

3. Variable list:  
    * x: longitude, center of grid cell
    * y: latitude, center of grid cell
    * shipping.index: Log-transformed shipping traffic, scaled between 0 and 1, used to calculate relative ship-strike risk
    * mgmt: the management status of a grid cell - i.e., whether there was any spatially-static vessel speed reduction (with a specific speed limit posted) or area closure, collated from the 2023 World Shipping Council report and detailed in the manuscript. This column includes both mandatory or voluntary ship-strike management measures. 
    * mgmt.mandatory: whether a grid cell contains a mandatory (rather than mandatory OR voluntary) management measure.
    * region: ocean region
    * blue.mean.occurrence: the mean predicted probability of occurrence within the grid cell across months of the year. 
    * blue.space.use: the blue whale space-use index, which is the mean probability of occurrence scaled between 0-1 and used to calculate the ship-strike risk index.
    * blue.risk: ship-strike risk index for blue whales, the product of blue whale space use index and shipping traffic index. 
    * blue.hotspot.99: whether a grid cell is a ship-strike risk hotspot (defined as a grid cell within the top 1% of risk) for blue whales. 
    * blue.hotspot.qs: whether a grid cell falls above the 90%, 95%, 99%, or 99.5% percentiles of ship-strike risk for blue whales. 
    * blue.hotspot.protected: whether a blue whale hotspot (99% definition) overlaps with any management measure
    * blue.hotspot.protected.mandatory: whether a blue whale hotspot (99% definition) overlaps with a mandatory management measure
    *  fin.mean.occurrence: the mean predicted probability of occurrence within the grid cell across months of the year. 
    * fin.space.use: the fin whale space-use index, which is the mean probability of occurrence scaled between 0-1 and used to calculate the ship-strike risk index.
    * fin.risk: ship-strike risk index for fin whales, the product of fin whale space use index and shipping traffic index. 
    * fin.hotspot.99: whether a grid cell is a ship-strike risk hotspot (defined as a grid cell within the top 1% of risk) for fin whales. 
    * fin.hotspot.qs: whether a grid cell falls above the 90%, 95%, 99%, or 99.5% percentiles of ship-strike risk for fin whales. 
    * fin.hotspot.protected: whether a fin whale hotspot (99% definition) overlaps with any management measure
    * fin.hotspot.protected.mandatory: whether a fin whale hotspot (99% definition) overlaps with a mandatory management measure
    *  humpback.mean.occurrence: the mean predicted probability of occurrence within the grid cell across months of the year. 
    * humpback.space.use: the humpback whale space-use index, which is the mean probability of occurrence scaled between 0-1 and used to calculate the ship-strike risk index.
    * humpback.risk: ship-strike risk index for humpback whales, the product of humpback whale space use index and shipping traffic index. 
    * humpback.hotspot.99: whether a grid cell is a ship-strike risk hotspot (defined as a grid cell within the top 1% of risk) for humpback whales. 
    * humpback.hotspot.qs: whether a grid cell falls above the 90%, 95%, 99%, or 99.5% percentiles of ship-strike risk for humpback whales. 
    * humpback.hotspot.protected: whether a humpback whale hotspot (99% definition) overlaps with any management measure
    * humpback.hotspot.protected.mandatory: whether a humpback whale hotspot (99% definition) overlaps with a mandatory management measure
    *  sperm.mean.occurrence: the mean predicted probability of occurrence within the grid cell across months of the year. 
    * sperm.space.use: the sperm whale space-use index, which is the mean probability of occurrence scaled between 0-1 and used to calculate the ship-strike risk index.
    * sperm.risk: ship-strike risk index for sperm whales, the product of sperm whale space use index and shipping traffic index. 
    * sperm.hotspot.99: whether a grid cell is a ship-strike risk hotspot (defined as a grid cell within the top 1% of risk) for sperm whales. 
    * sperm.hotspot.qs: whether a grid cell falls above the 90%, 95%, 99%, or 99.5% percentiles of ship-strike risk for sperm whales. 
    * sperm.hotspot.protected: whether a sperm whale hotspot (99% definition) overlaps with any management measure
    * sperm.hotspot.protected.mandatory: whether a sperm whale hotspot (99% definition) overlaps with a mandatory management measure
    * all.space.use: Mean space-use index across the four species for each grid cell 
    * all.risk: Mean ship-strike risk index across the four species for each grid cell
    * hotspot.overlap: How many species share a ship-strike risk hotspot in this grid cell
 
### DATA-SPECIFIC INFORMATION FOR: shipping_density.csv

1. Number of variables: 4

2. Description: Shipping traffic from Automatic Identification Systems (AIS) data at 1˚ resolution for non-fishing vessels >300GT. 

3. Variable list
    * longitude: longitude of the grid cell center (-180-180)
    * latitude: latitude of grid cell center
    * shipping_density: Mean (across years 2017-2022) cumulative distance traveled by non-fishing vessels >300GT within each grid cell
    * shipping_density_speed_weighted: Mean (across years 2017-2022) cumulative speed-weighted distance traveled by non-fishing vessels >300GT within each grid cell. Following Redfern et al. 2024, speed-weighted distance is calculated for each vessel track by multiplying the length of the vessel track with the probability that a collision would be lethal based on vessel speed (Conn and Silber 2013). 

### DATA-SPECIFIC INFORMATION FOR: blue_whale_isdm_data.csv

1. Number of variables: 12

2. Description: Data to run integrated species distribution models for blue whales. This dataset contains blue whale presence and background/absence points with environmental covariates sourced from Copernicus Marine Service (CMEMS) Global Ocean Physics Reanalysis, CMEMS Global Ocean Biogeochemistry Hindcast, and ETOPO1 Global Relief Model. 

3. Variable list 
    * species: 'Blue' for all records.
    * subpopulation: The large-scale geographic subpopulation for this record, one of 'North Pacific', 'North Atlantic', 'Indian Ocean-Western Pacific', 'Eastern South Pacific', or 'Antarctic'. Please see manuscript for definitions of subpopulation boundaries. 
    * presence: Whether a location was a whale presence record (1) or a absence (for survey data) or background (for whaling, sightings, tagging) location (0).
    * data_type: the data type for this location, either survey (from a scientific survey with survey tracklines recorded), sighting (sightings data for which tracklines or effort were not recorded), whaling (from whaling records), or tagging data (from animal-borne GPS tags). 
    * tag_id: the individual tag ID for tagging data to include random effects by individuals in tagging datasets. Non-tagging datasets are assigned 'Untagged', and this term is not included in the model for non-tagging datasets.
    * mld: mixed layer depth (m), from CMEMS.
    * PPupper200m: net primary production (mg m-3 day-1) from CMEMS.
    * sla: sea level anomaly (m), from CMEMS.
    * sst: sea surface temperature (°C).
    * sst_sd: the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C), calculated from CMEMS SST.
    * bathy:  bathymetry (m), from ETOPO1 Global Relief Model.
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), from ETOPO1 Global Relief Model.

### DATA-SPECIFIC INFORMATION FOR: fin_whale_isdm_data.csv

1. Number of variables: 12

2. Description: Data to run integrated species distribution models for fin whales. This dataset contains fin whale presence and background/absence points with environmental covariates sourced from Copernicus Marine Service (CMEMS) Global Ocean Physics Reanalysis, CMEMS Global Ocean Biogeochemistry Hindcast, and ETOPO1 Global Relief Model. 

3. Variable list 
    * species: 'Fin' for all records.
    * subpopulation: The large-scale geographic subpopulation for this record, one of 'North Pacific', 'North Atlantic', or 'Southern Hemisphere'.Please see manuscript for definitions of subpopulation boundaries. 
    * presence: Whether a location was a whale presence record (1) or a absence (for survey data) or background (for whaling, sightings, tagging) location (0).
    * data_type: the data type for this location, either survey (from a scientific survey with survey tracklines recorded), sighting (sightings data for which tracklines or effort were not recorded), whaling (from whaling records), or tagging data (from animal-borne GPS tags). 
    * tag_id: the individual tag ID for tagging data to include random effects by individuals in tagging datasets. Non-tagging datasets are assigned 'Untagged', and this term is not included in the model for non-tagging datasets.
    * mld: mixed layer depth (m), from CMEMS.
    * PPupper200m: net primary production (mg m-3 day-1) from CMEMS.
    * sla: sea level anomaly (m), from CMEMS.
    * sst: sea surface temperature (°C).
    * sst_sd: the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C), calculated from CMEMS SST.
    * bathy:  bathymetry (m), from ETOPO1 Global Relief Model.
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), from ETOPO1 Global Relief Model.  

### DATA-SPECIFIC INFORMATION FOR: humpback_whale_isdm_data.csv

1. Number of variables: 12

2. Description: Data to run integrated species distribution models for humpback whales. This dataset contains humpback whale presence and background/absence points with environmental covariates sourced from Copernicus Marine Service (CMEMS) Global Ocean Physics Reanalysis, CMEMS Global Ocean Biogeochemistry Hindcast, and ETOPO1 Global Relief Model. 

3. Variable list 
    * species: 'Humpback' for all records.
    * subpopulation: The large-scale geographic subpopulation for this record, one of 'N Pac' (North Pacific), 'N Atl' (North Atlantic), or 'SH' (Southern Hemisphere). Please see manuscript for definitions of subpopulation boundaries. 
    * presence: Whether a location was a whale presence record (1) or a absence (for survey data) or background (for whaling, sightings, tagging) location (0).
    * data_type: the data type for this location, either survey (from a scientific survey with survey tracklines recorded), sighting (sightings data for which tracklines or effort were not recorded), whaling (from whaling records), or tagging data (from animal-borne GPS tags). 
    * tag_id: the individual tag ID for tagging data to include random effects by individuals in tagging datasets. Non-tagging datasets are assigned 'Untagged', and this term is not included in the model for non-tagging datasets.
    * mld: mixed layer depth (m), from CMEMS.
    * PPupper200m: net primary production (mg m-3 day-1) from CMEMS.
    * sla: sea level anomaly (m), from CMEMS.
    * sst: sea surface temperature (°C).
    * sst_sd: the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C), calculated from CMEMS SST.
    * bathy:  bathymetry (m), from ETOPO1 Global Relief Model.
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), from ETOPO1 Global Relief Model.

### DATA-SPECIFIC INFORMATION FOR: sperm_whale_isdm_data.csv

1. Number of variables: 11

2. Description: Data to run integrated species distribution models for sperm whales. This dataset contains sperm whale presence and background/absence points with environmental covariates sourced from Copernicus Marine Service (CMEMS) Global Ocean Physics Reanalysis, CMEMS Global Ocean Biogeochemistry Hindcast, and ETOPO1 Global Relief Model. 

3. Variable list 
    * species: 'Sperm' for all records.
    * presence: Whether a location was a whale presence record (1) or a absence (for survey data) or background (for whaling, sightings, tagging) location (0).
    * data_type: the data type for this location, either survey (from a scientific survey with survey tracklines recorded), sighting (sightings data for which tracklines or effort were not recorded), whaling (from whaling records), or tagging data (from animal-borne GPS tags). 
    * tag_id: the individual tag ID for tagging data to include random effects by individuals in tagging datasets. Non-tagging datasets are assigned 'Untagged', and this term is not included in the model for non-tagging datasets.
    * mld: mixed layer depth (m), from CMEMS.
    * PPupper200m: net primary production (mg m-3 day-1) from CMEMS.
    * sla: sea level anomaly (m), from CMEMS.
    * sst: sea surface temperature (°C).
    * sst_sd: the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C), calculated from CMEMS SST.
    * bathy:  bathymetry (m), from ETOPO1 Global Relief Model.
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), from ETOPO1 Global Relief Model.

### DATA-SPECIFIC INFORMATION FOR: prediction_data_north_pacific/prediction_data_1.csv, prediction_data_north_pacific/prediction_data_2.csv, prediction_data_north_pacific/prediction_data_3.csv, prediction_data_north_pacific/prediction_data_4.csv, prediction_data_north_pacific/prediction_data_5.csv, prediction_data_north_pacific/prediction_data_6.csv, prediction_data_north_pacific/prediction_data_7.csv,  prediction_data_north_pacific/prediction_data_8.csv, prediction_data_north_pacific/prediction_data_9.csv, prediction_data_north_pacific/prediction_data_10.csv, prediction_data_north_pacific/prediction_data_11.csv, and prediction_data_north_pacific/prediction_data_12.csv,

1. Number of variables: 11

2. Description: These files contain spatial covariate data at 0.25˚ resolution for the North Pacific Ocean to make it easy to run the example script - fit_ISDM.R. The file structure of these 12 csv files is identical, they are split up by month to reduce file sizes. Environmental covariates were sourced from Copernicus Marine Service (CMEMS) Global Ocean Physics Reanalysis, CMEMS Global Ocean Biogeochemistry Hindcast, and ETOPO1 Global Relief Model. For dynamic covariates (i.e., mld, PPupper200m, sla, sst, sst_sd, bathy, bathy_sd), prediction layers were generated via calculating mean monthly climatologies for each dynamic covariate as detailed in the manuscript. 

3. Variable list 
    * month: month of the year (1-12)
    * longitude: longitude of the grid cell center (-180-180)
    * longitude_360: longitude of the grid cell center (0-360), for Pacific-centered mapping 
    * latitude: latitude of grid cell center
    * mld: climatology of mixed layer depth (m) for that month, from CMEMS.
    * PPupper200m: climatology of net primary production (mg m-3 day-1) for that month from CMEMS.
    * sla: climatology of sea level anomaly (m) for that month, from CMEMS.
    * sst: climatology of sea surface temperature (°C) for that month, from CMEMS
    * sst_sd: climatology of the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C) for that month, calculated from CMEMS SST
    * bathy: bathymetry (m), from ETOPO1 Global Relief Model. 
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), calculated from ETOPO1 Global Relief Model. 

### References:
* P. B. Conn, G. K. Silber, Vessel speed restrictions reduce risk of collision-related mortality for North Atlantic right whales. Ecosphere 4, art43 (2013).
* J. V. Redfern, B. C. Hodge, D. E. Pendleton, A. R. Knowlton, J. Adams, E. M. Patterson, C. P. Good, J. J. Roberts, Estimating reductions in the risk of vessels striking whales achieved by management strategies. Biological Conservation, 110427 (2024).
