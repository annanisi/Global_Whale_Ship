# Global_Whale_Ship
Code and data for the article: "Ship collision risk threatens whales across the world’s oceans"

Scripts: 
* fit_ISDM.R: Worked example code to fit whale integrated species distribution model (ISDM) incorporating survey, sightings, whaling records, and tagging data. Code includes data formatting and setup, model fitting, model validation, and spatial prediction. Example data is for blue whales in the North Pacific Ocean (see below: blue_whale_north_pacific_isdm_data.csv, prediction_data_north_pacific/prediction_data_x.csv)
* public_location_data.Rmd: This markdown script collates downloadable location data from the following sources: the Global Biodiversity Information Facility (GBIF), Ocean Biodiversity Information System (OBIS), Spatial Ecological Analysis of Megavertebrate Populations (OBIS-SEAMAP), California Department of Fish and Wildlife, MoveBank, and Australian Antarctic Data Center).

Data and metadata: 
* blue_whale_north_pacific_isdm_data.csv: Example data for fitting whale ISDM, using the fit_ISDM.R. This dataset contains blue whale presence and background points with environmental covariates for the North Pacific Ocean. Environmental covariates (mld, PPupper200m, sla, sst, sst_sd, bathy, bathy_sd) were from CMEMS as detailed in manuscript. 
    * species: 'Blue whale' for all records
    * subpopulation: 'N Pacific' for all records
    * presence: whether a location was a whale presence record (1) or a absence (for survey data) or background (for whaling, sightings, tagging) location.
    * data_type: the data type for this location, either planned survey, opportunistic sighting, whaling record, or tagging data. 
    * tag_id: the individual tag ID for tagging data to include random effects by individuals in tagging datasets. Non-tagging datasets are assigned tag_id == 1, and this term is not included in the model for non-tagging datasets.
    * mld: mixed layer depth (m), from CMEMS.
    * PPupper200m: net primary production (mg m-3 day-1) from CMEMS.
    * sla: sea level anomaly (m), from CMEMS.
    * sst: sea surface temperature (°C)
    * sst_sd: the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C), calculated from CMEMS SST
    * bathy:  bathymetry (m), from CMEMS
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), calculated from CMEMS bathymetry 
    
* prediction_data_north_pacific/prediction_data_x.csv: 12 files of spatial covariate data at .25 degree resolution for the North Pacific Ocean. These data are split by month into 12 files for space reasons and contain the same columns within each. The environmental conditions are calculated based on mean monthly climatologies for each covariate (mld, PPupper200m, sla, sst, sst_sd, bathy, bathy_sd), accessed from CMEMS and processed as detailed in manuscript. These data are used to predict monthly blue whale distributions across the North Pacific in the fit_ISDM.R script. 
Example data for fitting whale ISDM, using the fit_ISDM.R. This dataset contains blue whale presence and background points with environmental covariates for the North Pacific Ocean. Environmental covariates were from CMEMS as detailed in manuscript. 
    * month: month of the year (1-12)
    * longitude: longitude of the grid cell center (-180-180)
    * longitude_360: longitude of the grid cell center (0-360), for Pacific-centered mapping 
    * latitude: latitude of grid cell center
    * mld: climatology of mixed layer depth (m) for that month, from CMEMS.
    * PPupper200m: climatology of net primary production (mg m-3 day-1) for that month from CMEMS.
    * sla: climatology of sea level anomaly (m) for that month, from CMEMS.
    * sst: climatology of sea surface temperature (°C) for that month, from CMEMS
    * sst_sd: climatology of the spatial standard deviation of sea surface temperature (a proxy for frontal activity; °C) for that month, calculated from CMEMS SST
    * bathy: bathymetry (m), from CMEMS
    * bathy_sd: rugosity (a proxy for seabed complexity calculated as standard deviation of bathymetry; m), calculated from CMEMS bathymetry 
    
* global_whale_ship_risk.csv: Shipping traffic, whale space-use, whale ship-strike risk, ship-strike risk hotspots, and management information at 1 degree resolution for blue, fin, humpback, and sperm whales. 
    * x: longitude, center of grid cell
    * y: latitude, center of grid cell
    * shipping.index: Log-transformed shipping traffic, scaled between 0 and 1, used to calculate relative ship-strike risk
    * mgmt: the management status of a grid cell - i.e., whether there was any spatially-static vessel speed reduction (with a specific speed limit posted) or area closure, collated from the 2023 World Shipping Council report and detailed in the manuscript. This column includes both mandatory or voluntary ship-strike management measures. 
    * mgmt.mandatory: whether a grid cell contains a mandatory (rather than mandatory OR voluntary) management measure.
    * region: ocean region
    * The following columns are calculated for all whale species (blue, fin, humpback, and sperm) and the metadata is the same for each, so metadata provided for blue whales as an example: 
        * blue.mean.occurrence: the mean predicted probability of occurrence within the grid cell across months of the year. 
        * blue.space.use: the blue whale space-use index, which is the mean probability of occurrence scaled between 0-1 and used to calculate the ship-strike risk index.
        * blue.risk: ship-strike risk index for blue whales, the product of blue whale space use index and shipping traffic index. 
        * blue.hotspot.99: whether a grid cell is a ship-strike risk hotspot (defined as a grid cell within the top 1% of risk) for blue whales. 
        * blue.hotspot.qs: whether a grid cell falls above the 90%, 95%, 99%, or 99.5% percentiles of ship-strike risk for blue whales. 
        * blue.hotspot.protected: whether a blue whale hotspot (99% definition) overlaps with any management measure
        * blue.hotspot.protected.mandatory: whether a blue whale hotspot (99% definition) overlaps with a mandatory management measure
    * all.space.use: Mean space-use index across the four species for each grid cell 
    * all.risk: Mean ship-strike risk index across the four species for each grid cell
    * hotspot.overlap: How many species share a ship-strike risk hotspot in this grid cell
    