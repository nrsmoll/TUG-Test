
*______________Standardization of TUG Test int z- and t-scores________________________
$databasefolder
use TUGdata, clear

gen abnormal=.
gen ztug=.
gen ttug=. 

forval x = 0/1 {
	forval y = 0/1 {
	display "mean (if age2cat==`x' and sex==`y') = ${MEANagecat`x'sex`y'}"
	display "SD (if age2cat==`x' and sex==`y') = ${SDagecat`x'sex`y'}"
	display "UL (if age2cat==`x' and sex==`y') = ${upper99agecat`x'sex`y'}"
	
	replace abnormal=1 if age2cat==`x' & sex==`y' & bl_tug>${upper99agecat`x'sex`y'}
	replace ztug=(bl_tug-${MEANagecat`x'sex`y'})/${SDagecat`x'sex`y'} if age2cat==`x' & sex==`y'
	replace ttug=(10*ztug) + 100 if age2cat==`x' & sex==`y'
	}
}

replace abnormal=0 if abnormal==.
la def abnormal 0 "Normal" 1 "Abnormal"
la val abnormal abnormal

summarize bl_tug
local num = r(N)

$figuresfolder
twoway (histo ttug,  percent ytitle("Percent") ylabel(0(10)50) legend(order(1 "TUG Test Time: Percent" 2 "ODI Score"  ))) (scatter bl_rm ttug, ytitle("RM Score", axis(2)) yaxis(2) xline(123) msize(vsmall) mfcolor(none) xtitle("T-Score in Diseased Population"))
graph export "figure8.pdf", as(pdf) replace 









