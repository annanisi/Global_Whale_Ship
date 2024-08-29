######### Example code for fitting whale integrated species distribution models ######
## Blue whales in the North Pacific Ocean

# Packages
library(INLA)
library(inlabru)
library(tidyverse)
library(sf)
library(maps)
library(ggplot2)


###################### Data formatting ####################

# Load blue whale data for North Pacific
data.dir <- 'data/' # set data directory
out.dir <- 'out_files/' # set output file directory
np <- read_csv(paste0(data.dir, 'blue_whale_isdm_data.csv')) %>% # Blue whale location data (presence/absence) and covariates
  filter(subpopulation == 'North Pacific')

# Add indicators for data types
np <- np %>% mutate(data_type_os = if_else(data_type == 'sighting', 1, 0),
                    data_type_surv = if_else(data_type == 'survey', 1, 0),
                    data_type_tag = if_else(data_type == 'tagging', 1, 0),
                    data_type_whaling = if_else(data_type == 'whaling', 1, 0))

# Load prediction data for North Pacific
pred_data <- list()
for(i in 1:12){
  pred_data[[i]] <- read_csv(paste0(data.dir,'prediction_data_north_pacific/prediction_data_',i,'.csv')) # Spatial data for prediction (mean monthly climatological conditions at .25 degree resolution)
}
pred_data <- do.call('rbind', pred_data)

# Scale covariates for np -------------------------------------------------
# Centered by mean, scaled by standard deviation

# Collect mean and sd for each covariate
covs <- c('mld', 'PPupper200m','sla','sst_sd','sst','bathy','bathy_sd')
sc_cov_names <- paste0('sc_', covs)
cov_scale_info <- data.frame(cov_name = covs,
                             sc_cov_name = sc_cov_names,
                             mean = NA,
                             sd = NA)
for(i in covs){
  cov_scale_info$mean[cov_scale_info$cov_name == i] <- mean(np[,i])
  cov_scale_info$sd[cov_scale_info$cov_name == i] <- sd(np[,i])
  np[,paste0('sc_', i)] <- (np[,i] - cov_scale_info$mean[cov_scale_info$cov_name == i])/cov_scale_info$sd[cov_scale_info$cov_name == i]
}

# Center and scale data (subtract mean, divide by SD)
for(i in covs){
  np[,paste0('sc_', i)] <- (np[,i] - cov_scale_info$mean[cov_scale_info$cov_name == i])/cov_scale_info$sd[cov_scale_info$cov_name == i]
}


# Split into training and validation sets ---------------------------------
# 80% training, 20% validation

# Add indicators:
set.seed(1)
np$set <- 'validation'
percent = .8
for(j in unique(np$data_type)){
  for(k in c(0,1)){
    training_indices <- sample(which(np$presence == k & np$data_type == j),
                                 size = percent*sum(np$presence == k & np$data_type == j))
    np$set[training_indices] <- 'training'
  }
}

# Training data: List by data type
data_list_training = list()
data_list_training$os_data = np %>% filter(data_type == 'sighting',
                                           set == 'training')
data_list_training$surv_data = np %>% filter(data_type == 'survey',
                                             set == 'training')
data_list_training$whaling_data = np %>% filter(data_type == 'whaling',
                                                set == 'training')
data_list_training$tag_data = np %>% filter(data_type == 'tagging',
                                            set == 'training')

# Subset validation data:
val_data <- np %>% filter(set == 'validation')


# Get sample size ---------------------------------------------------------

np %>%
  group_by(data_type, presence) %>%
  summarize(n = n(),
            n_training = sum(set == 'training')) %>%
  mutate(percent_training = n_training/n)

# Scale prediction data ---------------------------------------------------

# Scale spatial prediction data as with location data
for(i in 1:length(covs)){
  print(covs[i])
  pred_data[, paste0('sc_', covs[i])] <- (pred_data[,covs[i]] - cov_scale_info$mean[cov_scale_info$cov_name == covs[i]])/cov_scale_info$sd[cov_scale_info$cov_name == covs[i]] # (Data - mean) / sd
}

# Make 1D meshes for covariate effects ------------------------------------

make_spline_mesh_spde <- function(df, var_name, n){ # Function to define knots and make spde for 1d random fields
  data <- df[, var_name]
  data <- data[!is.na(data)]
  out <- list()
  out$knot_locs <- quantile(data, ppoints(n))
  out$mesh <- inla.mesh.1d(out$knot_locs)
  out$spde <- inla.spde2.matern(out$mesh, constr = FALSE)
  out$spde.idx <- inla.spde.make.index(paste0(var_name, '.x'), n.spde = out$spde$n.spde)
  out
}

for(i in 1:length(covs)){
  print(i)
  assign(x = paste0(covs[i], '.spde'),  # put regular cov name for naming the object
         value = make_spline_mesh_spde(df = np, var_name = sc_cov_names[i], n = 10))
}


##################### Model fitting #####################
# NOTE: this takes a lot of time and memory to run

# Set model formula
form <- ' ~ 0 + Intercept(1) +
  bathy_field(sc_bathy, model = bathy.spde$spde) +
  PPupper200m_field(sc_PPupper200m, model = PPupper200m.spde$spde) +
  sst_field(sc_sst, model = sst.spde$spde) +
  sst_sd_field(sc_sst_sd, model = sst_sd.spde$spde) +
  bathy_sd_field(sc_bathy_sd, model = bathy_sd.spde$spde) +
  mld_field(sc_mld, model = mld.spde$spde) +
  sla_field(sc_sla, model = sla.spde$spde) +
data_type_os(1) + data_type_surv(1) + tag(tag_id, model = "iid")'

# Fit model
mod <- bru(as.formula(form),
           like(formula = presence ~ 0 + Intercept + bathy_field + PPupper200m_field + sst_field + sst_sd_field + bathy_sd_field + mld_field + sla_field + data_type_os + data_type_surv + data_type_tag,
                data = data_list_training$os_data,  family = 'poisson', E = 0),
           like(formula = presence ~ 0 + Intercept + bathy_field + PPupper200m_field + sst_field + sst_sd_field + bathy_sd_field + mld_field + sla_field + data_type_os + data_type_surv + data_type_tag,
                data = data_list_training$whaling_data,  family = 'poisson', E = 0),
           like(formula = presence ~ 0 + Intercept + bathy_field + PPupper200m_field + sst_field + sst_sd_field + bathy_sd_field + mld_field + sla_field + data_type_os + data_type_surv + data_type_tag + tag,
                data = data_list_training$tag_data, family = 'poisson', E = 0),
           like(formula = presence ~ 0 + Intercept + bathy_field + PPupper200m_field + sst_field + sst_sd_field + bathy_sd_field + mld_field + sla_field + data_type_os + data_type_surv + data_type_tag,
                data = data_list_training$surv_data, family = 'binomial', Ntrials = 1),
           options = bru_options(control.family = list(list(link = "log"),
                                                       list(link = "log"),
                                                       list(link = "log"),
                                                       list(link = "logit")),
                                 control.inla = list(int.strategy = "eb", strategy = 'gaussian')))

save(mod, file = paste0(out.dir, 'np_model.Rda'))

##################### Model prediction #####################

# Predict validation data  ------------------------------------------------

model_terms <- as.formula('~ 0 + Intercept +
                                      bathy_field +
                                      PPupper200m_field +
                                      sst_field +
                                      sst_sd_field +
                                      bathy_sd_field +
                                      mld_field +
                                      sla_field')
form_predict <- as.formula(paste0('~ exp(', as.character(model_terms[2]), ')', '/(1 + exp(', as.character(model_terms[2]), '))'))

val_data <- predict(mod, data = val_data, formula = form_predict, drop = F)


# Monthly spatial projections ---------------------------------------------

spatial_pred <- predict(mod, data = na.omit(pred_data), formula = form_predict)


# Model validation metrics: AUC & TSS -------------------------------------

# AUC
val_predict <- prediction(val_data$mean,
                        val_data$presence)
roc<- performance(val_predict, 'tpr', 'fpr')
auc <- performance(val_predict, 'auc')@y.values[[1]]
auc # 0.906

# Function to calculate TSS
calculate_TSS <- function(val_data, cutoff_vals = seq(0, 1, .001)){ # Takes a dataframe of predicted values
  out <- list(data = NA)
  roc_df <- data.frame(cutoff = cutoff_vals,
                       n_pred_presence = NA,
                       n_pred_absence = NA,
                       area = NA)
  for(i in 1:nrow(roc_df)){
    roc_df$n_pred_presence[i] <- sum(val_data$mean >= roc_df$cutoff[i] & val_data$presence == 1) # predicted true presences
    roc_df$n_pred_absence[i] <- sum(val_data$mean < roc_df$cutoff[i] & val_data$presence == 0) # predicted true absences
  }
  roc_df <- roc_df %>%
    mutate(sensitivity = n_pred_presence/sum(val_data$presence),
           specificity = n_pred_absence/sum(val_data$presence == 0),
           x_specificity = 1-specificity,
           SSS = sensitivity + specificity) %>% # Sum of specificity and sensitivity to determine cutoff value
    arrange(x_specificity, sensitivity)

  # Calculate cutoff that maximizes sum of sensitivity and specificity:

  full_cutoff <- roc_df$cutoff[roc_df$SSS == max(roc_df$SSS)]
  # print(full_cutoff)
  length_cutoff <- length(full_cutoff) # Get length (sometimes there is the same MaxSSS between two)
  cutoff <- mean(full_cutoff) # when there's a tie take the mean
  # Assign predicted presences to validation data
  val_data <- val_data %>%
    mutate(predicted_presence = if_else(mean >= cutoff, 1, 0))
  true_presences <- val_data %>%
    filter(presence == 1)
  true_absences <- val_data %>%
    filter(presence == 0)
  # Sensitivity: proportion of presences that are predicted presences
  sensitivity <- sum(true_presences$predicted_presence == 1)/nrow(true_presences)
  # Specificity: proportion of absences that are predicted absences
  specificity <- sum(true_absences$predicted_presence == 0)/nrow(true_absences)
  # TSS = sensitiity + specificity - 1
  TSS <- sensitivity + specificity - 1
  TSS
}

# TSS

tss <- calculate_TSS(val_data)
tss # 0.693

# Make maps ---------------------------------------------------------------

# Get world countries projected 0-360
countries <- map_data('world', wrap=c(0,360))
countries <- countries %>%
  st_as_sf(coords = c('long','lat'), crs = 4326, remove = F) %>%
  group_by(group) %>%
  summarize(geometry = st_combine(geometry)) %>%
  st_cast('POLYGON')

# Make monthly distribution maps in North Pacific
range(spatial_pred$latitude)
map.list <- list()
for(i in 1:12){
  map.list[[i]] <- ggplot() +
     geom_tile(spatial_pred %>% filter(month == i), mapping = aes(x =longitude_360, y = latitude, fill= mean))+
    scale_fill_viridis(na.value = 'white', name = 'P(Occurrence)', limits = c(0,1)) +
     geom_sf(data = countries, col = 'gray40', fill = 'gray85') +
     coord_sf(xlim = range(spatial_pred$longitude_360), ylim = range(spatial_pred$latitude)) +
     theme_void() +
     theme(legend.position = "bottom",
           legend.key.width=unit(1,"cm"))+
     ggtitle(paste0('Blue whale - ', month.name[i]))
}

for(i in 1:12){
  png(filename = paste0(out.dir, 'blue_whale_north_pacific_',month.name[i],'.png'),height = 5, width = 5, units = 'in', res = 500, type = 'quartz')
  print(map.list[[i]])
  dev.off()
}
