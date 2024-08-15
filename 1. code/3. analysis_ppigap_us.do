/*******************************************************************************
* Hyunseo Park
* UC Davis
* Jan 29, 2024
*******************************************************************************/

global base "C:\7. Joint work with Shisham\code_ppi_cpi"

clear
import excel "$base\2. input\PPI_finished goods_US.xls", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_final
gen lppi_final = ln(ppi_final)
gen ppi_final_inf = lppi_final - l12.lppi_final 


save "$base\3. output\us_ppi_final.dta", replace




clear
import excel "$base\2. input\PPI_processed goods for intermediate demand_US.xls", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_int
gen lppi_int = ln(ppi_int)
gen ppi_int_inf = lppi_int - l12.lppi_int 


save "$base\3. output\us_ppi_int.dta", replace





clear
import excel "$base\2. input\PPI_finished goods less foods and energy_US.xls", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_final_less_energy
gen lppi_final_less_energy = ln(ppi_final_less_energy)
gen ppi_final_less_energy_inf = lppi_final_less_energy - l12.lppi_final_less_energy 


save "$base\3. output\us_ppi_final_less_energy.dta", replace



clear
import excel "$base\2. input\PPI_finished energy goods_US.xls", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_final_energy
gen lppi_final_energy = ln(ppi_final_energy)
gen ppi_final_energy_inf = lppi_final_energy - l12.lppi_final_energy 


save "$base\3. output\us_ppi_final_energy.dta", replace



clear
import excel "$base\2. input\PPI_intermediate energy goods_US.xls", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_int_energy
gen lppi_int_energy = ln(ppi_int_energy)
gen ppi_int_energy_inf = lppi_int_energy - l12.lppi_int_energy 


save "$base\3. output\us_ppi_int_energy.dta", replace




clear
import excel "$base\2. input\PPI_intermediate materials less foods and energy_US.xls", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date
rename ppi_int_material_less_energy ppi_int_mat_less_ener
keep date ppi_int_mat_less_ener
gen lppi_int_mat_less_ener = ln(ppi_int_mat_less_ener)
gen ppi_int_mat_less_ener_inf = lppi_int_mat_less_ener - l12.lppi_int_mat_less_ener 


save "$base\3. output\us_ppi_int_meterial_less_energy.dta", replace




clear
import excel "$base\2. input\PPI_final_demand_trade_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_trade_service
ren ppi_trade_service ppi_ser_trade
gen lppi_ser_trade = ln(ppi_ser_trade)
gen ppi_ser_trade_inf = lppi_ser_trade - l12.lppi_ser_trade 

save "$base\3. output\us_ppi_trade_service.dta", replace



clear
import excel "$base\2. input\PPI_hotel_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_hotel_service
ren ppi_hotel_service ppi_ser_hotel
gen lppi_ser_hotel = ln(ppi_ser_hotel)
gen ppi_ser_hotel_inf = lppi_ser_hotel- l12.lppi_ser_hotel

save "$base\3. output\us_ppi_hotel_service.dta", replace



clear
import excel "$base\2. input\PPI_final_demand_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_final_service
ren ppi_final_service ppi_ser_final
gen lppi_ser_final = ln(ppi_ser_final)
gen ppi_ser_final_inf = lppi_ser_final- l12.lppi_ser_final

save "$base\3. output\us_ppi_final_service.dta", replace



clear
import excel "$base\2. input\PPI_retail_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_retail_service
ren ppi_retail_service ppi_ser_retail
gen lppi_ser_retail  = ln(ppi_ser_retail)
gen ppi_ser_retail_inf = lppi_ser_retail- l12.lppi_ser_retail

save "$base\3. output\us_ppi_retail_service.dta", replace


clear
import excel "$base\2. input\PPI_nontrade_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_nontrade_service
ren ppi_nontrade_service ppi_ser_nontrade
gen lppi_ser_nontrade = ln(ppi_ser_nontrade)
gen ppi_ser_nontrade_inf = lppi_ser_nontrade - l12.lppi_ser_nontrade

save "$base\3. output\us_ppi_nontrade_service.dta", replace


clear
import excel "$base\2. input\PPI_int_demand_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_int_service
ren ppi_int_service ppi_ser_int
gen lppi_ser_int = ln(ppi_ser_int)
gen ppi_ser_int_inf = lppi_ser_int - l12.lppi_ser_int

save "$base\3. output\us_ppi_int_service.dta", replace




clear
import excel "$base\2. input\PPI_engineering_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_engin_service
ren ppi_engin_service ppi_ser_engin
gen lppi_ser_engin = ln(ppi_ser_engin)
gen ppi_ser_engin_inf = lppi_ser_engin - l12.lppi_ser_engin

save "$base\3. output\us_ppi_engin_service.dta", replace



clear
import excel "$base\2. input\PPI_primary_service.xls", sheet("FRED Graph") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

tsset date

keep date ppi_primary_service
ren ppi_primary_service ppi_ser_primary
gen lppi_ser_primary = ln(ppi_ser_primary)
gen ppi_ser_primary_inf = lppi_ser_primary - l12.lppi_ser_primary

save "$base\3. output\us_ppi_primary_service.dta", replace


clear
import excel "$base\2. input\oil_kanzig.xlsx", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

keep date oilsurprise

save "$base\3. output\oil_kanzig.dta", replace

clear
import excel "$base\2. input\profit_data2.xlsx", sheet("compustat") firstrow

drop Date

gen date = ym(year, month)
format date %tm

//gen qdate = qofd(dofm(mdate))
//format qdate %tq

ren GICDescriptionReference sector_name
tab sector_name

gen sector_id = .

replace sector_id = 1 if sector_name == "Communication Services" 
replace sector_id = 2 if sector_name == "Consumer Discretionary" 
replace sector_id = 3 if sector_name == "Consumer Staples" 
replace sector_id = 4 if sector_name == "Energy" 
replace sector_id = 5 if sector_name == "Financials" 
replace sector_id = 6 if sector_name == "Health Care" 
replace sector_id = 7 if sector_name == "Industrials" 
replace sector_id = 8 if sector_name == "Information Technology" 
replace sector_id = 9 if sector_name == "Materials" 
replace sector_id = 10 if sector_name == "Real Estate"   // 2011.9 ~
replace sector_id = 11 if sector_name == "Utilities" 



ren GrossProfitMargin_Median gross_profit
ren NetProfitMargin_Median net_profit
ren OperatingProfitMarginAfterDe op_profit_de
ren OperatingProfitMarginBeforeD op_profit_nde
ren EffectiveTaxRate effective_tax
ren GrossProfitTotalAssets_Median gross_proffit_assets

ren AftertaxReturnonTotalStockh after_tax_return_tot
ren AftertaxReturnonInvestedCap after_tax_return_inv
ren AftertaxReturnonAverageComm after_tax_return_avg
ren PretaxReturnonTotalEarning pre_tax_return_tot
ren PretaxreturnonNetOperating pre_tax_return_oper
ren PretaxProfitMargin_Median pre_tax_return_profit
ren ReturnonAssets_Median return_asset
ren ReturnonCapitalEmployed_Media return_capital
ren ReturnonEquity_Median return_equity

save "$base\3. output\profit_data_compustat.dta", replace

clear

use "$base\3. output\em_dat_month.dta"
//gen qdate = qofd(dofm(date))
//format %tq qdate
keep if iso == "USA"
//collapse(sum) drought ext_temp storm, by(qdate) 


merge m:m date using "$base\3. output\oil_kanzig.dta"
//drop if _merge == 2
drop _merge


merge m:m date using "$base\3. output\us_ppi_int_meterial_less_energy.dta"
//keep if _merge == 3

drop _merge


merge m:m date using "$base\3. output\us_ppi_final.dta"
//keep if _merge == 3

drop _merge

merge m:m date using "$base\3. output\us_ppi_final_less_energy.dta"
//keep if _merge == 3

drop _merge

merge m:m date using "$base\3. output\us_ppi_final_energy.dta"
//keep if _merge == 3

drop _merge

merge m:m date using "$base\3. output\us_ppi_int.dta"
//keep if _merge == 3

drop _merge

merge m:m date using "$base\3. output\us_ppi_int_energy.dta"
//keep if _merge == 3

drop _merge


merge m:m date using "$base\3. output\us_ppi_trade_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_hotel_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_final_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_retail_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_nontrade_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_int_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_engin_service.dta"
drop _merge


merge m:m date using "$base\3. output\us_ppi_primary_service.dta"
drop _merge



merge m:m date using "$base\3. output\carbonprice.dta"
drop _merge


gen year = year(dofm(date))
//keep if year > 1998






/*******************************************************************************
** 1. Local Projection
*******************************************************************************/

sort date
tsset date


gen ppi_inf_diff = ppi_final_inf - ppi_int_inf
gen ppi_inf_diff_non_ener = ppi_final_less_energy_inf - ppi_int_mat_less_ener_inf
gen ppi_inf_diff_ener = ppi_final_energy_inf - ppi_int_energy_inf

local hmax = 24

foreach i in ppi_inf_diff ppi_inf_diff_non_ener ppi_inf_diff_ener ppi_final_inf ppi_int_inf ppi_int_energy_inf ppi_final_less_energy_inf ppi_int_mat_less_ener_inf ppi_final_energy_inf ppi_ser_primary_inf ppi_ser_engin_inf ppi_ser_int_inf ppi_ser_nontrade_inf ppi_ser_retail_inf ppi_ser_final_inf ppi_ser_hotel_inf ppi_ser_trade_inf{ 
	
forvalues h = 0/`hmax' {
	gen `i'`h' = f`h'.`i' - l.`i'
}
}

// shock: ext_temp cp_surprise oilsurprise
// services: ppi_ser_primary_inf ppi_ser_engin_inf ppi_ser_int_inf ppi_ser_nontrade_inf ppi_ser_retail_inf ppi_ser_final_inf ppi_ser_hotel_inf ppi_ser_trade_inf 
// ppi: ppi_final_inf ppi_int_inf ppi_final_energy_inf ppi_int_energy_inf ppi_final_less_energy_inf ppi_int_mat_less_ener_inf 
// price gap: ppi_inf_diff ppi_inf_diff_ener ppi_inf_diff_non_ener

foreach k in ppi_ser_primary_inf ppi_ser_engin_inf ppi_ser_int_inf ppi_ser_nontrade_inf ppi_ser_retail_inf ppi_ser_final_inf ppi_ser_hotel_inf ppi_ser_trade_inf   { 
		foreach i in ext_temp {
* Cumulative
eststo clear
cap drop b u d Months Zero
gen Months = _n-1 if _n<=`hmax' + 1
gen Zero =  0    if _n<=`hmax' + 1
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 newey `k'`h' l(0/12).`i' l(1/12).(`k'),  lag(`h')  // baseline
replace b = _b[`i']                        if _n == `h' + 2
replace u = _b[`i'] + 1.645* _se[`i']  if _n == `h' + 2
replace d = _b[`i'] - 1.645* _se[`i']  if _n == `h' + 2
eststo
}

twoway ///
(rarea u d  Months,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Months, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line Zero Months, lcolor(black)), legend(off) ///
title("Cumulative response of `k' to `i'", color(black) size(medsmall)) ///
ytitle("Rate", size(medsmall)) xtitle("Month", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white)) ysize(6) xsize(7)

graph export "$base\4. result\1. figures\ppi_gap_us\irf_`k'_`i'.png", as(png) name("Graph") replace

}
}


