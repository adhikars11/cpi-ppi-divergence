/*******************************************************************************
* Shisham Adhikari
* UC Davis
* Jan 31, 2024
*******************************************************************************/

global base "/Users/shishamadhikari/Desktop/cpi-ppi-divergence"

clear all 
use "$base/3. output/em_dat_month.dta"

merge m:m iso date using "$base/3. output/oecd_month.dta"
keep if _merge == 3 
drop _merge

encode iso, gen(iso_n)
sort iso_n date
xtset iso_n date

/*******************************************************************************
** 1. Local Projection
*******************************************************************************/

local hmax = 10

foreach i in cpi_total cpi_goods cpi_services { 
	
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


foreach k in cpi_total cpi_goods cpi_services {

foreach i in ext_temp drought storm {
* Cumulative
eststo clear
cap drop b u d Months Zero
gen Months = _n-1 if _n<=`hmax' + 1
gen Zero =  0    if _n<=`hmax' + 1
gen b=0
gen u=0
gen d=0
forv h = 0/`hmax' {
	 xtreg `k'`h' l(0/12).`i' l(1/12).(`k') i.iso_n i.date2,  vce(cluster iso_n)  // baseline
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


