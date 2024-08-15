# Shisham Adhikari, UC Davis
# Aug 14, 2024

# clear environment
rm(list=ls()) 

# install and load packages
if (!require("pacman")) install.packages("pacman") 
pacman::p_load(tidyverse,readxl,readr,lubridate, janitor, zoo)
# If a package is installed, it will be loaded. 
# If any are not, the missing package(s) will be installed from CRAN and then loaded.

###############################################################################################
# 1. Merging price level data by economic activity and type of goods
###############################################################################################

base <- "/Users/shishamadhikari/Desktop/cpi-ppi-divergence"

# Function to process and save data
process_save_data <- function(df, filter_val, value_name, output_file) {
  df %>%
    filter(subject == filter_val) %>%
    select(location, time, value) %>%
    rename(!!value_name := value) %>%
    mutate(date = as.yearmon(time, "%Y-%m")) %>%
    write_csv(file.path(base, paste0("3. output/", output_file)))
}

# Economic activities - Total producer prices - Manufacturing
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PIEAMP01", "ppi_tot_manufact", "data_ppi_tot_manufact_month.csv")

# Economic activities - Domestic producer prices - Manufacturing
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PIEAMP02", "ppi_dom_manufact", "data_ppi_dom_manufact_month.csv")

# Economic activities - Total Producer prices - Manufacture of food products
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PIEAFD01", "ppi_tot_manufact_food", "data_ppi_tot_manufact_food_month.csv")

# Economic activities - Domestic Producer prices - Manufacture of food products
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PIEAFD02", "ppi_dom_manufact_food", "data_ppi_dom_manufact_food_month.csv")

# Type of goods - Domestic Producer prices - Intermediate goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PITGIG02", "ppi_dom_int", "data_ppi_dom_int_month.csv")

# Type of goods - Total Producer prices - Intermediate goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PITGIG01", "ppi_tot_int", "data_ppi_tot_int_month.csv")

# Type of goods - Domestic Producer prices - Consumer goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PITGCG02", "ppi_dom_con", "data_ppi_dom_con_month.csv")

# Type of goods - Total Producer prices - Consumer goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PITGCG01", "ppi_tot_con", "data_ppi_tot_con_month.csv")

# Stage of processing - Domestic Producer prices - Intermediate goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PISPIG02", "ppi_dom_int_stage", "data_ppi_dom_int_stage_month.csv")

# Stage of processing - Total Producer prices - Intermediate goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PISPIG01", "ppi_tot_int_stage", "data_ppi_tot_int_stage_month.csv")

# Stage of processing - Domestic Producer prices - Finished goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PISPFG02", "ppi_dom_fin_stage", "data_ppi_dom_fin_stage_month.csv")

# Stage of processing - Total Producer prices - Finished goods
df <- read_csv(file.path(base, "2. input/oecd_price.csv")) %>% clean_names()
process_save_data(df, "PISPFG01", "ppi_tot_fin_stage", "data_ppi_tot_fin_stage_month.csv")

# CPI
df <- read_csv(file.path(base, "2. input/oecd_cpi.csv")) %>% clean_names()
df %>%
  filter(measure_2 == "Index") %>%
  select(location, time, value) %>%
  rename(cpi = value) %>%
  mutate(date = as.yearmon(time, "%Y-%m")) %>%
  write_csv(file.path(base, "3. output/data_cpi_month.csv"))

# CPI goods
df <- read_csv(file.path(base, "2. input/cpi_service_goods_inflation.csv"))  %>% clean_names()
df %>%
  filter(df[[16]] == "Goods") %>%
  select(ref_area, time_period, obs_value) %>%
  rename(location = ref_area, time = time_period, cpi_goods = obs_value) %>%
  mutate(date = as.yearmon(time, "%Y-%m")) %>%
  write_csv(file.path(base, "3. output/data_cpi_goods_month.csv"))

# CPI services
df <- read_csv(file.path(base, "2. input/cpi_service_goods_inflation.csv")) %>% clean_names()
df %>%
  filter(df[[16]] == "Services less housing") %>%
  select(ref_area, time_period, obs_value) %>%
  rename(location = ref_area, time = time_period, cpi_services = obs_value) %>%
  mutate(date = as.yearmon(time, "%Y-%m")) %>%
  write_csv(file.path(base, "3. output/data_cpi_services_month.csv"))

# CPI total
df <- read_csv(file.path(base, "2. input/cpi_service_goods_inflation.csv")) %>% clean_names()
df %>%
  filter(df[[16]] == "Total") %>%
  select(ref_area, time_period, obs_value) %>%
  rename(location = ref_area, time = time_period, cpi_total = obs_value) %>%
  mutate(date = as.yearmon(time, "%Y-%m")) %>%
  write_csv(file.path(base, "3. output/data_cpi_total_month.csv"))

# All price indices data Merge
# Load the CPI data
cpi <- read_csv(file.path(base, "3. output/data_cpi_month.csv"))

# Convert the 'time' column in the CPI data to the year-month format
cpi <- cpi %>%
  mutate(date = as.yearmon(time, "%Y-%m")) %>%
  select(-time)
# List of file names to merge
file_names <- c("ppi_dom_int_month", "ppi_tot_int_month", "ppi_dom_con_month", "ppi_tot_con_month",
                "ppi_dom_int_stage_month", "ppi_tot_int_stage_month", "ppi_dom_fin_stage_month",
                "ppi_tot_fin_stage_month", "ppi_tot_manufact_month", "ppi_dom_manufact_month",
                "ppi_tot_manufact_food_month", "ppi_dom_manufact_food_month", 
                "cpi_total_month", "cpi_services_month", "cpi_goods_month")

# Load and merge each dataset
for (file_name in file_names) {
  
  # Read the data to be merged
  merge_df <- read_csv(file.path(base, paste0("3. output/data_", file_name, ".csv")))
  
  # Convert the 'time' column in merge_df to the year-month format
  merge_df <- merge_df %>%
    mutate(date = as.yearmon(time, "%Y-%m")) %>%
    select(-time)  # Drop the 'time' column
  
  # Perform the left join with CPI data
  cpi <- cpi %>%
    left_join(merge_df, by = c("location", "date"))
}

# Rename 'location' to 'iso'
cpi <- cpi %>%
  rename(iso = location)

# Save the final data
write_csv(cpi, file.path(base, "3. output/oecd_month.csv"))

###############################################################################################
# 2. Merging climate disaster variables
###############################################################################################
# Function to process EM-DAT data
# Load the Excel data
em_dat <- read_excel(file.path(base, "2. input/em_dat.xlsx"), sheet = "EM-DAT Data")

# Rename columns
em_dat <- em_dat %>%
  clean_names() %>%
  rename(id = dis_no,
         year = start_year,
         month = start_month,
         disaster = disaster_type)

# Drop rows where 'month' is missing
em_dat <- em_dat %>%
  filter(!is.na(month)) %>%
  mutate(date = as.yearmon(paste(year, month), "%Y %m")) 

# Create a copy for later use (preserve functionality in Stata)
em_dat_preserved <- em_dat

# Function to process disaster data
process_disaster <- function(data, disaster_type, output_file) {
  data %>%
    filter(disaster == disaster_type) %>%
    group_by(iso, date) %>%
    summarise(!!disaster_type := mean(1), .groups = 'drop') %>%
    write_csv(file.path(base, paste0("3. output/", output_file)))
}

# Process and save data for Drought
process_disaster(em_dat, "Drought", "drought.csv")

# Restore the original dataset for the next processing
em_dat <- em_dat_preserved

# Process and save data for Extreme Temperature
process_disaster(em_dat, "Extreme temperature", "ext_temp.csv")

# Restore the original dataset for the next processing
em_dat <- em_dat_preserved

# Process and save data for Storm
process_disaster(em_dat, "Storm", "storm.csv")

# Restore the original dataset for the next processing
em_dat <- em_dat_preserved

# Initialize with collapsed data by iso, region, and subregion
em_dat_collapsed <- em_dat %>%
  group_by(iso, region, subregion) %>%
  summarise(nn = mean(1), .groups = 'drop')

# Expand the data to have a full time series
expanded_data <- em_dat_collapsed %>%
  slice(rep(1:n(), each = 1486)) %>%  # 1486 = 765 + 720 + 1
  group_by(iso) %>%
  mutate(date = seq(-720, 765)) %>%
  mutate(date = as.yearmon(date / 12 + 1900)) %>%  # Convert to yearmon starting from 1900
  ungroup() %>%
  select(-nn)

# Merge with drought data
drought <- read_csv(file.path(base, "3. output/drought.csv")) %>% clean_names()
expanded_data <- expanded_data %>%
  left_join(drought %>% mutate(date = as.yearmon(date, "%Y-%m")), by = c("iso", "date")) %>%
  mutate(drought = ifelse(is.na(drought), 0, drought))

# Merge with extreme temperature data
ext_temp <- read_csv(file.path(base, "3. output/ext_temp.csv")) %>% clean_names()
expanded_data <- expanded_data %>%
  left_join(ext_temp %>% mutate(date = as.yearmon(date, "%Y-%m")) %>% rename(ext_temp = extreme_temperature), by = c("iso", "date")) %>%
  mutate(ext_temp = ifelse(is.na(ext_temp), 0, ext_temp))

# Merge with storm data
storm <- read_csv(file.path(base, "3. output/storm.csv"))  %>% clean_names()
expanded_data <- expanded_data %>%
  left_join(storm %>% mutate(date = as.yearmon(date, "%Y-%m")), by = c("iso", "date")) %>%
  mutate(storm = ifelse(is.na(storm), 0, storm))

# Add the month variable extracted from the date
expanded_data <- expanded_data %>%
  mutate(month = format(date, "%m"))

# Save the final dataset
write_csv(expanded_data, file.path(base, "3. output/em_dat_month.csv"))

###############################################################################################
# 3. Carbon pricing shocks
###############################################################################################

carbon_shocks <- read_excel(file.path(base, "2. input/carbonPolicyShocks.xlsx"), sheet = "Baseline") %>%
  mutate(date = as.yearmon(Date, "%Y-%m")) %>%
  select(-Date) %>%
  rename(cp_surprise = Surprise, cp_shock = Shock) %>%
  write_csv(file.path(base, "3. output/carbonprice.csv"))
