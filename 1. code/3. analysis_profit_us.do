/*******************************************************************************
* Hyunseo Park
* UC Davis
* Jan 29, 2024
*******************************************************************************/

global base "C:\7. Joint work with Shisham\code_ppi_cpi"

clear
import excel "$base\2. input\profit_data.xlsx", sheet("Sheet1") firstrow
//gen lnmanuf = ln(Manufacturing)*100
//gen lndurgoods = ln(Durablegoods)*100
//gen lnnondurgoods = ln(Nondurablegoods)*100
//gen lnretail = ln(Retailtrade)*100
//gen lnmachinery = ln(Machinery)*100
//gen lnpetro = ln(Petroleumandcoalproducts)*100
//gen lnwholesale = ln(Wholesaletrade)*100

ren Manufacturing manuf
ren Durablegoods durgoods
ren Nondurablegoods nondurgoods
ren Retailtrade retail
ren Machinery machinery
ren Petroleumandcoalproducts petro
ren Wholesaletrade wholesale



gen qdate = qofd(date)
format %tq qdate
save "$base\3. output\profit_data.dta", replace

clear

use "$base\3. output\em_dat_month.dta"
gen qdate = qofd(dofm(date))
format %tq qdate
keep if iso == "USA"
collapse(sum) drought ext_temp storm, by(qdate) 

merge m:m qdate using "$base\3. output\profit_data.dta"
keep if _merge == 3 
drop _merge

tsset qdate
/*
replace ppi_dom_con = ppi_tot_con 

// If you need more observation, 
replace ppi_dom_int = ppi_tot_int 

gen p_diff1 = (ln(cpi) - ln(ppi_dom_con))*100
gen p_diff2 = (ln(cpi) - ln(ppi_dom_int))*100
gen p_diff3 = (ln(ppi_dom_con) - ln(ppi_dom_int))*100

gen p_diff1_2 = (ln(cpi) - ln(ppi_tot_con))*100
gen p_diff2_2 = (ln(cpi) - ln(ppi_tot_int))*100
gen p_diff3_2 = (ln(ppi_tot_con) - ln(ppi_tot_int))*100


replace p_diff3 = p_diff3_2 

gen inf_diff1 = p_diff1 - l12.p_diff1
gen inf_diff2 = p_diff2 - l12.p_diff2
gen inf_diff3 = p_diff3 - l12.p_diff3

gen ln_ppi_dom_int = ln(ppi_dom_int)
gen ppi3_inf = ln_ppi_dom_int - l12.ln_ppi_dom_int
gen ln_cpi = ln(cpi)
gen cpi_inf = ln_cpi - l12.ln_cpi

replace cpi_inf = . if ppi3_inf == . 

drop if ppi_dom_int == . 
drop if ppi_dom_con == . 


/*******************************************************************************
** 1. Local Projection
*******************************************************************************/

local hmax = 10


gen lppi_con = ln(ppi_dom_con)*100
gen lppi_int = ln(ppi_dom_int)*100
gen lcpi = ln(cpi)*100

gen inf_ppi_int = (lppi_int - l12.lppi_int)
gen inf_ppi_con = (lppi_con - l12.lppi_con)
gen inf_cpi = (lcpi - l12.lcpi)

gen inf_diff4 = cpi_goods - inf_ppi_int
gen inf_diff5 = cpi_total - inf_ppi_int
gen inf_diff6 = cpi_total - inf_ppi_con
gen inf_diff7 = cpi_goods - inf_ppi_con
gen inf_diff8 = inf_ppi_con - inf_ppi_int
gen inf_diff9 = cpi_goods - cpi_services

*/

local hmax = 25
gen quarter_i = ceil(month(date)/3)

foreach i in manuf durgoods nondurgoods retail machinery petro wholesale { 
	
forvalues h = 0/`hmax' {
	gen `i'`h' = f`h'.`i' - l.`i'
}
}

foreach i in quarter_i { 
	
forvalues h = 0/`hmax' {
	gen `i'`h' = f`h'.`i'
}
}


// inf_ppi_int inf_ppi_con inf_cpi inf_diff4 inf_diff5 inf_diff6 inf_diff7 inf_diff4 inf_diff5 inf_diff6 inf_diff7 inf_diff8 

foreach k in manuf durgoods nondurgoods retail machinery petro wholesale {
foreach i in ext_temp {
* Cumulative
eststo clear
cap drop b u d Quarters Zero
gen Quarters = _n-1 if _n<=`hmax' + 1
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
(rarea u d  Quarters,  ///
fcolor(gs13) lcolor(gs13) lw(none) lpattern(solid)) ///
(line b Quarters, lcolor(blue) lpattern(solid) lwidth(thick)) ///
(line Zero Quarters, lcolor(black)), legend(off) ///
title("Cumulative profit response of `k' to `i' shock", color(black) size(medsmall)) ///
ytitle("Billion $", size(medsmall)) xtitle("Quarter", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white)) ysize(6) xsize(5)

graph export "$base\4. result\1. figures\profit\irf_`k'_`i'.png", as(png) name("Graph") replace

}
}


