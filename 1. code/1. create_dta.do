/*******************************************************************************
* Hyunseo Park
* UC Davis
* Jan 29, 2024
*******************************************************************************/

/*******************************************************************************
** 1. Merging price level data by economic activity and type of goods
*******************************************************************************/

global base "/Users/shishamadhikari/Desktop/cpi-ppi-divergence"


** Economic activities - Total producer prices - Manufacturing

clear

import delimited "$base/2. input/oecd_price.csv", encoding(UTF-8) 
keep if subject == "PIEAMP01"     
keep location time value
ren value ppi_tot_manufact
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_tot_manufact_month.dta", replace


** Economic activities - Domestic producer prices - Manufacturing

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PIEAMP02"     
keep location time value
ren value ppi_dom_manufact
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_dom_manufact_month.dta", replace


** Economic activities - Total Producer prices - Manufacture of food products

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PIEAFD01"     
keep location time value
ren value ppi_tot_manufact_food
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_tot_manufact_food_month.dta", replace


** Economic activities - Domestic Producer prices - Manufacture of food products

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PIEAFD02"     
keep location time value
ren value ppi_dom_manufact_food
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_dom_manufact_food_month.dta", replace

** Type of goods - Domestic Producer prices - Intermediate goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PITGIG02"     
keep location time value
ren value ppi_dom_int
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_dom_int_month.dta", replace


** Type of goods - Total Producer prices - Intermediate goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PITGIG01"     
keep location time value
ren value ppi_tot_int
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_tot_int_month.dta", replace


** Type of goods - Domestic Producer prices - Consumer goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PITGCG02"    
keep location time value
ren value ppi_dom_con
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_dom_con_month.dta", replace


** Type of goods - Total Producer prices - Consumer goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PITGCG01"    
keep location time value
ren value ppi_tot_con
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_tot_con_month.dta", replace


** Stage of processing - Domestic Producer prices - Intermediate goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PISPIG02"     
keep location time value
ren value ppi_dom_int_stage
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_dom_int_stage_month.dta", replace


** Stage of processing - Total Producer prices - Intermediate goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PISPIG01"     
keep location time value
ren value ppi_tot_int_stage
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_tot_int_stage_month.dta", replace


** Stage of processing - Domestic Producer prices - Finished goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PISPFG02"     
keep location time value
ren value ppi_dom_fin_stage
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_dom_fin_stage_month.dta", replace


** Stage of processing - Total Producer prices - Finished goods

clear

import delimited "$base/2. input/oecd_price.csv"
keep if subject == "PISPFG01"     
keep location time value
ren value ppi_tot_fin_stage
gen date = monthly(time, "YM")

save "$base/3. output/data_ppi_tot_fin_stage_month.dta", replace


** CPI

clear

import delimited "$base/2. input/oecd_cpi.csv"
keep if v6 == "Index"
rename ïlocation location
keep location time value
ren value cpi
gen date = monthly(time, "YM")

save "$base/3. output/data_cpi_month.dta", replace


** CPI goods

clear

import delimited "$base/2. input/cpi_service_goods_inflation.csv"
keep if v16 == "Goods"
keep ref_area time_period obs_value
ren ref_area location
ren time_period time

ren obs_value cpi_goods
gen date = monthly(time, "YM")
//format date %tm

save "$base/3. output/data_cpi_goods_month.dta", replace

** CPI services

clear

import delimited "$base/2. input/cpi_service_goods_inflation.csv"
keep if v16 == "Services less housing"
keep ref_area time_period obs_value
ren ref_area location
ren time_period time

ren obs_value cpi_services
gen date = monthly(time, "YM")
// format date %tm

save "$base/3. output/data_cpi_services_month.dta", replace


** CPI goods inflation

clear

import delimited "$base/2. input/cpi_service_goods_inflation.csv"
keep if v16 == "Total"
keep ref_area time_period obs_value
ren ref_area location
ren time_period time

ren obs_value cpi_total
gen date = monthly(time, "YM")
//format date %tm

save "$base/3. output/data_cpi_total_month.dta", replace


** Data Merge

clear 

use "$base/3. output/data_cpi_month.dta"
gen nn = 1
collapse (mean) nn, by(location)
expand 765 + 720 + 1
bysort location: gen date = _n - 721
drop nn

foreach i in "ppi_dom_int_month" "ppi_tot_int_month" "ppi_dom_con_month" "ppi_tot_con_month" ///
"ppi_dom_int_stage_month" "ppi_tot_int_stage_month" "ppi_dom_fin_stage_month" "ppi_tot_fin_stage_month" ///
"ppi_tot_manufact_month" "ppi_dom_manufact_month" "ppi_tot_manufact_food_month" "ppi_dom_manufact_food_month" "cpi_month" ///
"cpi_total_month" "cpi_services_month" "cpi_goods_month" {

merge m:1 date location using "$base/3. output/data_`i'.dta"
drop _merge 
	
}

ren location iso
//gen date = monthly(time, "YM")
format date %tm 
save "$base/3. output/oecd_month.dta", replace

/*******************************************************************************
** 2. Merging climate disaster variables
*******************************************************************************/

clear

import excel "$base/2. input/em_dat.xlsx", sheet("EM-DAT Data") firstrow
ren ISO iso
ren Country country
ren Subregion subregion
ren Region region
ren DisNo id
ren StartYear year
ren StartMonth month
ren DisasterType disaster
drop if month == . 
gen date=ym(year, month)
gen date_tm = date
format date_tm %tm

preserve
 
keep if disaster == "Drought"
sort iso year 
gen drought = 1
collapse (mean) drought, by(iso date)
save "$base/3. output/drought.dta", replace

restore
 
preserve
 
keep if disaster == "Extreme temperature"
sort iso year 
gen ext_temp = 1
collapse (mean) ext_temp, by(iso date)
save "$base/3. output/ext_temp.dta", replace

restore 
 
preserve
 
keep if disaster == "Storm"
sort iso year 
gen storm = 1
collapse (mean) storm, by(iso date)
save "$base/3. output/storm.dta", replace

restore


gen nn = 1
collapse (mean) nn, by(iso region subregion)

expand 765 + 720 + 1					// total number of dates: "date" starts from -720 and ends at 765 
bysort iso: gen date = _n - 721			// first date of dates is -720

sort iso date
drop nn 

merge m:1 iso date using "$base/3. output/drought.dta"
drop _merge
replace drought = 0 if drought == . 

merge m:1 iso date using "$base/3. output/ext_temp.dta"
drop _merge
replace ext_temp = 0 if ext_temp == . 

merge m:1 iso date using "$base/3. output/storm.dta"
drop _merge
replace storm = 0 if storm == . 

format date %tm
gen month = month(dofm(date))

save "$base/3. output/em_dat_month.dta", replace
 
/*******************************************************************************
** 3. Carbon pricing shocks
*******************************************************************************/

clear

import excel "C:/7. Joint work with Shisham/code_ppi_cpi/2. input/carbonPolicyShocks.xlsx", sheet("Baseline") firstrow
gen date2 = monthly(Date, "YM")

drop Date
rename date2 date
format date %tm
ren Surprise cp_surprise
ren Shock cp_shock

save "$base/3. output/carbonprice.dta", replace
