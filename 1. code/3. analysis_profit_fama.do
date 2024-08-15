/*******************************************************************************
* Hyunseo Park
* UC Davis
* Jan 29, 2024
*******************************************************************************/

global base "C:\7. Joint work with Shisham\code_ppi_cpi"

clear
import excel "$base\2. input\profit_data2.xlsx", sheet("fama_french") firstrow

drop Date

gen date = ym(year, month)
format date %tm

//gen qdate = qofd(dofm(mdate))
//format qdate %tq

ren FamaandFrench10Industries sector_name
tab sector_name

gen sector_id = .

replace sector_id = 1 if sector_name == "DURBL" 
replace sector_id = 2 if sector_name == "ENRGY" 
replace sector_id = 3 if sector_name == "HITEC" 
replace sector_id = 4 if sector_name == "HLTH" 
replace sector_id = 5 if sector_name == "MANUF" 
replace sector_id = 6 if sector_name == "NODUR" 
replace sector_id = 7 if sector_name == "OTHER" 
replace sector_id = 8 if sector_name == "SHOPS" 
replace sector_id = 9 if sector_name == "TELCM" 
replace sector_id = 10 if sector_name == "UTILS" 


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

save "$base\3. output\profit_data_fama.dta", replace

clear

use "$base\3. output\em_dat_month.dta"
//gen qdate = qofd(dofm(date))
//format %tq qdate
keep if iso == "USA"
//collapse(sum) drought ext_temp storm, by(qdate) 

merge m:m date using "$base\3. output\profit_data_fama.dta"
keep if _merge == 3 
drop _merge

sort sector_id date 
xtset sector_id date



/*******************************************************************************
** 1. Local Projection
*******************************************************************************/


local hmax = 24

foreach i in op_profit_de return_capital { 
	
forvalues h = 0/`hmax' {
	gen `i'`h' = f`h'.`i' - l.`i'
}
}

foreach u in "DURBL" "ENRGY" "HITEC" "MANUF" "NODUR" "OTHERS" "SHOPS" "TELCM" "UTILS" { 
	foreach k in op_profit_de return_capital { 
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
	 newey `k'`h' l(0/12).`i' l(1/12).(`k') if sector_name == "`u'",  lag(`h')  // baseline
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
title("Cumulative response of `k' to `i' in `u' sector", color(black) size(medsmall)) ///
ytitle("Rate", size(medsmall)) xtitle("Month", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white)) ysize(6) xsize(7)

graph export "$base\4. result\1. figures\profit_fama\irf_`k'_`i'_`u'.png", as(png) name("Graph") replace

}
}
}

