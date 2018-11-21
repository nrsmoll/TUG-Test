$databasefolder
use normalTUG, clear

$figuresfolder
forval x = 0/1 {
	forval y = 0/1 {

	if (`x'==0) {
	local sex "Males"
	}
	else {
	local sex "Females"
	
	}
	
	if (`y'==0) {
	local agecat "Less than 60yrs"
	}
	else {
	local agecat "Greater than 60yrs"
	
	}
	
	summarize tug1_1 if age2cat==`x' & sex==`y'
	swilk tug1_1 if age2cat==`x' & sex==`y'
	local num = r(N)
histogram tug1_1 if age2cat==`x' & sex==`y', normal yline(100, lcolor(gs14)) ylabel(0(25)100) xlabel(2(2)16) title("`sex'") subtitle("`agecat'", ring(0) ) text(30 3 "n=`num'") xtitle(TUG Test Time (Seconds)) percent saving(normagecat`x'sex`y', replace) nodraw
	}
}

$figuresfolder
graph combine "normagecat0sex0" "normagecat0sex1" "normagecat1sex0" "normagecat1sex1", imargin(1 1 1 1)
graph export "figure2tugnorms.pdf", replace as(pdf)

$databasefolder
use TUGdata, clear	 
$figuresfolder
***** Figure 1 RM *****
twoway scatter  logtug bl_rm if bl_rm<=25, ysca(alt) xsca(alt range(0 25)) xlabel(, grid gmax) xtitle("") ///
	legend(order(1 "Log of TUG Time" 2 "Best Fit & 95% CI") size(vsmall) ring(0) pos(10) col(1)) || lfitci logtug bl_tug, range(0 25) saving(main, replace )  nodraw

twoway histogram logtug, fraction xsca(alt reverse) ytitle("Log of TUG Test Time") xtitle("") xlabel(.1 .3) horiz fxsize(25) saving(hy, replace) nodraw
twoway histogram bl_rm, fraction ysca(alt reverse)  xtitle("Roland-Morris Score") ytitle("") ylabel(.1 .2) ylabel(,nogrid) xlabel(,grid gmax) fysize(25) saving(hx, replace) nodraw

graph combine hy.gph main.gph hx.gph, hole(3) ///	
	imargin(0 0 0 0) graphregion(margin(l=22 r=22)) ///
	title("", size(medium))
graph export "figure3tugrm.pdf", replace as(pdf)

***** Figure 2 ODI *****
twoway scatter logtug bl_odi, ysca(alt) xsca(alt) xlabel(, grid gmax) xtitle("") ///
	legend(order(1 "Log of TUG Time" 2 "Best Fit & 95% CI") size(vsmall) ring(0) pos(10) col(1)) || lfitci logtug bl_odi, saving(main, replace ) nodraw

twoway histogram logtug, fraction xsca(alt reverse) ytitle("Log of TUG Test Time") xtitle("") xlabel(.1 .3) horiz fxsize(25) saving(hy, replace) nodraw
twoway histogram bl_odi, fraction ysca(alt reverse)  xtitle("Oswestry Disability Index") ytitle("") ylabel(.1 .2) ylabel(,nogrid) xlabel(,grid gmax) fysize(25) saving(hx, replace) nodraw

graph combine hy.gph main.gph hx.gph, hole(3) ///	
	imargin(0 0 0 0) graphregion(margin(l=22 r=22)) ///
	title("", size(medium))
graph export "figure4tugodi.pdf", as(pdf) replace


***** Figure 3 Eq5D index*****
twoway scatter  logtug bl_eq5d_index, ysca(alt) xsca(alt) xlabel(, grid gmax) xtitle("") ///
	legend(order(1 "Log of TUG Time" 2 "Best Fit & 95% CI") size(vsmall) ring(0) pos(10) col(1)) || lfitci logtug bl_eq5d_index, range(0 1) saving(main, replace )  nodraw

twoway histogram logtug, fraction xsca(alt reverse) ytitle("Log of TUG Test Time") xtitle("") xlabel(.1 .3) horiz fxsize(25) saving(hy, replace) nodraw
twoway histogram bl_eq5d_index, fraction ysca(alt reverse)  xtitle("EQ5D Index") ytitle("") ylabel(.1 .2) ylabel(,nogrid) xlabel(,grid gmax) fysize(25) saving(hx, replace) nodraw

graph combine hy.gph main.gph hx.gph, hole(3) ///	
	imargin(0 0 0 0) graphregion(margin(l=22 r=22)) ///
	title("", size(medium))
graph export "figure5tugeq5dindex.pdf", replace as(pdf)

***** Figure 4 Eq5D VAS*****
twoway scatter  logtug bl_eq5dperc, ysca(alt) xsca(alt) xlabel(, grid gmax) xtitle("") ///
	legend(order(1 "Log of TUG Time" 2 "Best Fit & 95% CI") size(vsmall) ring(0) pos(10) col(1)) || lfitci  logtug bl_eq5dperc,  saving(main, replace )  nodraw

twoway histogram logtug, fraction xsca(alt reverse) ytitle("Log of TUG Test Time") xtitle("") xlabel(.1 .3) horiz fxsize(25) saving(hy, replace) nodraw
twoway histogram bl_eq5dperc, fraction ysca(alt reverse)  xtitle("EQ5D VAS") ytitle("") ylabel(.1 .2) ylabel(,nogrid) xlabel(,grid gmax) fysize(25) saving(hx, replace) nodraw

graph combine hy.gph main.gph hx.gph, hole(3) ///	
	imargin(0 0 0 0) graphregion(margin(l=22 r=22)) ///
	title("", size(medium))
graph export "figure6tugeq5dvas.pdf", replace as(pdf)

***** Figure 5 PCS*****
twoway scatter  logtug bl_sf12_pcs, ysca(alt) xsca(alt) xlabel(, grid gmax) xtitle("") ///
	legend(order(1 "Log of TUG Time" 2 "Best Fit & 95% CI") size(vsmall) ring(0) pos(10) col(1)) || lfitci logtug bl_sf12_pcs ,  saving(main, replace ) nodraw

twoway histogram logtug, fraction xsca(alt reverse) ytitle("Log of TUG Test Time") xtitle("") xlabel(.1 .3) horiz fxsize(25) saving(hy, replace) nodraw
twoway histogram bl_sf12_pcs, fraction ysca(alt reverse)  xtitle("SF12-PCS") ytitle("") ylabel(.1 .2) ylabel(,nogrid) xlabel(,grid gmax) fysize(25) saving(hx, replace) nodraw

graph combine hy.gph main.gph hx.gph, hole(3) ///	
	imargin(0 0 0 0) graphregion(margin(l=22 r=22)) ///
	title("", size(medium))
graph export "figure7tugpcs.pdf", replace as(pdf)


correlate logtug bl_vasback bl_vasleg bl_rm bl_odi bl_eq5d_index bl_eq5dperc bl_sf12_pcs bl_sf12_mcs
foreach var of varlist bl_rm bl_odi bl_eq5d_index bl_eq5dperc bl_sf12_pcs {
regress  `var' logtug
}

