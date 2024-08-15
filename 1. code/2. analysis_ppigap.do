/*******************************************************************************
* Hyunseo Park
* UC Davis
* Jan 29, 2024
*******************************************************************************/

global base "C:\7. Joint work with Shisham\code_ppi_cpi"

clear
import excel "$base\2. input\oil_kanzig.xlsx", sheet("Sheet1") firstrow

drop Date

gen date = ym(year, month)
format date %tm
drop if date == . 

keep date oilsurprise

save "$base\3. output\oil_kanzig.dta", replace


clear
use "$base\3. output\em_dat_month.dta"

merge m:m iso date using "$base\3. output\oecd_month.dta"
keep if _merge == 3 
drop _merge

merge m:m date using "$base\3. output\carbonprice.dta"
drop _merge

merge m:m date using "$base\3. output\oil_kanzig.dta"
drop if _merge == 2
drop _merge

encode iso, gen(iso_n)
sort iso_n date
xtset iso_n date


// If you need more observation,
replace ppi_dom_con = ppi_tot_con if iso == "POL"
replace ppi_dom_con = ppi_tot_con if iso == "USA"

// If you need more observation, 
replace ppi_dom_int = ppi_tot_int if iso == "USA"

gen p_diff1 = (ln(cpi) - ln(ppi_dom_con))*100
gen p_diff2 = (ln(cpi) - ln(ppi_dom_int))*100
gen p_diff3 = (ln(ppi_dom_con) - ln(ppi_dom_int))*100

gen p_diff1_2 = (ln(cpi) - ln(ppi_tot_con))*100
gen p_diff2_2 = (ln(cpi) - ln(ppi_tot_int))*100
gen p_diff3_2 = (ln(ppi_tot_con) - ln(ppi_tot_int))*100


//replace p_diff2 = p_diff2_2 if p_diff2 == . 
replace p_diff3 = p_diff3_2 if iso == "POL"
replace p_diff3 = p_diff3_2 if iso == "USA"

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

local hmax = 25


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
gen inf_diff10 = inf_cpi - inf_ppi_con


foreach i in inf_diff4 inf_diff5 inf_diff6 inf_diff7 inf_diff8 inf_diff9 inf_diff10 lppi_con lppi_int lcpi p_diff1  p_diff2 p_diff3 inf_ppi_int inf_ppi_con inf_cpi cpi_total cpi_goods cpi_services { 
	
forvalues h = 0/`hmax' {
	gen `i'`h' = f`h'.`i' - l.`i'
}
}

foreach i in month{ 
	
forvalues h = 0/`hmax' {
	gen `i'`h' = f`h'.`i'
}
}


gen date2 = date + 800

sort iso_n date
by iso_n: gen tt = _n

drop if inf_diff8 == . 
//drop if inf_diff7 == . 

// inf_ppi_int inf_ppi_con inf_cpi inf_diff4 inf_diff5 inf_diff6 inf_diff7 inf_diff4 inf_diff5 inf_diff6 inf_diff7 inf_diff8 

foreach k in cpi_total cpi_goods cpi_services inf_ppi_int inf_ppi_con{
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
//	 xtreg `k'`h' l(0/12).`i' l(1/12).(`k') i.iso_n i.date i.month#i.iso_n,  vce(cluster iso_n)  // baseline
	 xtreg `k'`h' l(0/12).`i' l(1/12).(`k') i.iso_n i.date,  vce(cluster iso_n)  // baseline
	 tab iso if e(sample)
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
title("Cumulative response of `k' to `i' shock", color(black) size(medsmall)) ///
ytitle("Percent", size(medsmall)) xtitle("Month", size(medsmall)) ///
graphregion(color(white)) plotregion(color(white)) ysize(6) xsize(5)

graph export "$base\4. result\1. figures\irf_`k'_`i'.png", as(png) name("Graph") replace

}
}


