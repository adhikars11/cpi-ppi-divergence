# Shisham Adhikari, UC Davis
# Aug 14, 2024

# clear environment
rm(list=ls()) 

# install and load packages
if (!require("pacman")) install.packages("pacman") 
pacman::p_load(tidyverse,readxl,readr,lubridate, janitor, zoo, plm, foreign, haven)
# If a package is installed, it will be loaded. 
# If any are not, the missing package(s) will be installed from CRAN and then loaded.

base <- "/Users/shishamadhikari/Desktop/cpi-ppi-divergence"

###############################################################################################
# 1. Read in datasets
###############################################################################################

# Read in the datasets
em_dat_month <- read_dta(file.path(base, "3. output/em_dat_month.dta")) %>% 
  clean_names() 
oecd_month <- read_dta(file.path(base, "3. output/oecd_month.dta"))  %>% clean_names()

# Merge the datasets by 'iso' and 'date'
expanded_data <- em_dat_month %>%
  inner_join(oecd_month, by = c("iso", "date")) %>%
  mutate(iso_n = factor(iso)) %>%
  mutate(date2 = date + 800)

reference_date <- as.Date("1960-01-01")

expanded_data <- expanded_data %>%
  mutate(date = reference_date %m+% months(date),
         date2 = reference_date %m+% months(date2)) %>%
  mutate(date = format(date, "%Y-%m"),
         date2 = format(date2, "%Y-%m")) 

# Set the panel structure
expanded_data <- pdata.frame(expanded_data, index = c("iso_n", "date"))

# Define CPI and shock variables
cpi_variables <- c("cpi_total", "cpi_goods", "cpi_services")
shock_variables <- c("ext_temp", "drought", "storm")

# Set the maximum horizon
hmax <- 10

# Initialize an empty list to store results
results_list <- list()

# Loop through each CPI variable (k) and each shock variable (i)
for (k in cpi_variables) {
  for (i in shock_variables) {
    expanded_data <- expanded_data %>%
      mutate(n = row_number())
    expanded_data <- expanded_data %>%
      mutate(
        Months = ifelse(row_number() <= hmax + 1, row_number() - 1, NA),
        Zero = ifelse(row_number() <= hmax + 1, 0, NA),
        b = 0,
        u = 0,
        d = 0
      )
    for (h in 0:hmax){
      # Generate lagged variables explicitly
      expanded_data <- expanded_data %>%
        group_by(iso_n) %>%
        mutate(!!paste0(k, "_lag", h) := lag(!!sym(k), h),
               !!paste0(i, "_lag", h) := lag(!!sym(i), h)) %>%
        ungroup()
    }
  }
}

      # Construct the formula
      model_formula <- as.formula(paste0(k, "_lag", h, " ~ ", 
                                         paste0("lag(", i, ", 0:12)", collapse = " + "), " + ",
                                         paste0("lag(", k, ", 1:12)", collapse = " + "), " + 
                                         factor(iso_n) + factor(date2)"))
      # Run the panel regression with clustered standard errors
      model <- tryCatch({
        plm(model_formula, data = expanded_data, model = "within", index = c("iso_n", "date2"))
      }, error = function(e) {
        message("Error in model fitting: ", e)
        return(NULL)
      })
      
      if (!is.null(model)) {
        clustered_se <- vcovHC(model, method = "arellano", type = "HC0", cluster = "group")
        
        # Get coefficient and standard error
        coef_name <- paste0(i, "_lag0")
        if (coef_name %in% names(coef(model))) {
          coef_value <- coef(model)[[coef_name]]
          se_value <- sqrt(clustered_se[coef_name, coef_name])
          
          # Store the results at position `h + 2`
          results_list[[paste(k, h, i, sep = "_")]] <- list(
            b = coef_value,
            u = coef_value + 1.645 * se_value,
            d = coef_value - 1.645 * se_value
          )
        } else {
          message("Coefficient for ", i, " not found at horizon ", h)
        }
        
        # Tabulate the estimation sample (analogous to `tab iso if e(sample)`)
        est_sample <- which(!is.na(model$residuals))
        print(table(expanded_data$iso_n[est_sample]))
      }
    }
  }
}