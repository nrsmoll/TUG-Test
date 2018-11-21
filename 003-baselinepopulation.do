$databasefolder
use TUGdata, clear


******Table 1 Baseline******
$tablesfolder
tabout $baselinecatvar using baselinecatvartable1.csv, oneway replace c(freq col) lines(none) clab(No. %) ///
	f(0 0p 0 0p 0 0p) style(csv) layout(No. % No. % No. %) ptotal(none) h3(nil)		

tabout $baselinecatvar using baselinecontvartable2.csv, ///
         c(mean age sd age mean height sd height mean weight sd weight mean bmi sd bmi ///
		 mean bl_vasback sd bl_vasback mean bl_vasleg sd bl_vasleg mean bl_rm sd bl_rm mean bl_odi sd bl_odi mean bl_tug sd bl_tug) replace oneway sum ///
		 f(1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1p 1c 1c 1c) ///
		 clab(Age SD Height_(cm) SD Weight_(kg) SD BMI SD VAS_Back SD VAS_Leg SD Roland-Morris SD Owswestry_Disability_Index SD Baseline_TUG_Test SD)

foreach var of varlist $baselinecontvar {
tabstat `var', statistic(mean sd) save
matrix l = r(StatTotal)
global mean`var' = l[1,1]
global sd`var' = l[2,1]
}

matrix t1baseline = ($meanage, $sdage \ ///
				$meanheight, $sdheight \ ///
				$meanweight, $sdweight \ ///
				$meanbl_vasback, $sdbl_vasback \ ///
				$meanbl_vasleg, $sdbl_vasleg \ ///
				$meanbl_rm, $sdbl_rm \ ///
				$meanbl_odi, $sdbl_odi \ ///
				$meanbl_eq5d_index, $sdbl_eq5d_index \ ///
				$meanbl_eq5dperc, $sdbl_eq5dperc \ ///
				$meanbl_sf12_pcs, $sdbl_sf12_pcs \ ///
				$meanbl_sf12_mcs, $sdbl_sf12_mcs \ ///
				$meanbl_tug, $sdbl_tug )
				
matrix colnames t1baseline = "Mean" "SD"
matrix rownames t1baseline = Age Height Weight VAS_Back VAS_Leg Roland_Morris Oswestry EQ5D EQ5Dperc SF12_PCS SF12_MCS TUG

$tablesfolder
putexcel A1=matrix(t1baseline, names) using table1baseline, replace
matrix list t1baseline

foreach var of varlist $baselinecatvar {
	tab `var'
}

foreach var of varlist $baselinecontvar {
	tabstat `var', statistic(n p25 p50 p75 p99 iqr mean sd)
}

tabstat bl_tug, statistic(q n) save
matrix l = r(StatTotal)
global Nall = l[4,1]

******Discussion Counts******
count if bl_vasback<3
display `r(N)'/253

count if bl_rm<5
display `r(N)'/253

count if bl_odi<10
display `r(N)'/253

count if bl_eq5dperc>85
display `r(N)'/253

count if bl_sf12_pcs>38.6 & bl_sf12_pcs<58.4
display `r(N)'/253


******Baseline Severity Stratification
tabstat bl_tug if bl_tug>$upper99, statistic(n) save
matrix l = r(StatTotal)
centile bl_tug if bl_tug>$upper99, centile(33 66)
global p33overall = r(c_1)
global p66overall = r(c_2)
global Noverall = l[1,1]

display $Noverall / $Nall


***Stratified by Age (60yrs)***
forval x = 0/1 {
	centile bl_tug if age2cat==`x' & bl_tug>${upper99agecat`x'}, centile(33 66)
	global p33agecat`x' = r(c_1)
	global p66agecat`x' = r(c_2)
}

***Stratified by Sex (females==1)***
forval x = 0/1 {
	centile bl_tug if sex==`x' & bl_tug> ${upper99sex`x'}, centile(33 66)
	global p33sex`x' = r(c_1)
	global p66sex`x' = r(c_2)
}

matrix drop _all
matrix x = 0
***Stratified by Age (60yrs) & Sex (females==1)***
forval x = 0/1 {
	forval y = 0/1 {
	centile bl_tug if age2cat==`x' & sex==`y' & bl_tug > ${upper99agecat`x'sex`y'}, centile(33 66)
	global p33agecat`x'sex`y' = r(c_1)
	global p66agecat`x'sex`y' = r(c_2)
	summarize bl_tug if age2cat==`x' & sex==`y' & bl_tug > ${upper99agecat`x'sex`y'}
	matrix x = x \ r(N)
	}
}

matsum x ,  column(c1) display
di 100/$Nall

matrix y = ($p33agecat0sex0, $p66agecat0sex0, $p33agecat0sex1, $p66agecat0sex1, $p33agecat0, $p66agecat0 \ ///
		   $p33agecat1sex0, $p66agecat1sex0, $p33agecat1sex1, $p66agecat1sex1, $p33agecat1, $p66agecat1 \ ///
		   $p33sex0, $p66sex0, $p33sex1, $p66sex1, $p33overall, $p66overall )
matrix colnames y = "Male (33%)" "Male (66%)" "Female (33%)" "Female (66%)" "Overall (33%)" "Overall (66%)" 
matrix rownames y = <60yrs >60yrs Overall

$tablesfolder
putexcel A1=matrix(y, names) using table4severitystratification, replace
matrix list y


correlate bl_tug bl_rm bl_odi bl_eq5dperc bl_vasleg bl_vasback bl_sf12_mcs bl_sf12_pcs
	 
		 
***Comparisons with the Normal Population***
$databasefolder
use TUGdata, clear

rename bl_vasback vasback
rename bl_vasleg vasleg
rename bl_rm rm
rename bl_odi odi
rename bl_eq5d_index eq5d_index
rename bl_eq5dperc eq5dperc
rename bl_sf12_pcs sf12_pcs
rename bl_sf12_mcs sf12_mcs
rename bl_tug tug1_1

foreach var of varlist $normalcontvar {
		summarize `var'
		global MEANbaseline`var' = r(mean)
		global SDbaseline`var' = r(sd)
		global OBSbaseline`var' = r(N)
		}
		
use normalTUG, clear
foreach var of varlist $normalcontvar {
		summarize `var'
		global MEANnormal`var' = r(mean)
		global SDnormal`var' = r(sd)
		global OBSnormal`var' = r(N)
		}
		

***Welch's T-Test for Unequal Variances***		
foreach x of varlist $normalcontvar {
	global tvalue`x' = (${MEANnormal`x'} - ${MEANbaseline`x'})	/ (sqrt(((${SDnormal`x'}^2)/${OBSnormal`x'}) + ((${SDbaseline`x'}^2)/${OBSbaseline`x'})))
	global df`x' = (((${SDnormal`x'}^2)/${OBSnormal`x'}) + ((${SDbaseline`x'}^2)/${OBSbaseline`x'}))^2  /  ((((${SDnormal`x'}^2)/${OBSnormal`x'})^2 / (${OBSnormal`x'} - 1)) + (((${SDbaseline`x'}^2)/${OBSbaseline`x'})^2 / (${OBSbaseline`x'} - 1)))
	display "`x'"
	global pvalue`x' = round(ttail(${df`x'}, abs(${tvalue`x'})), 0.0001)
	display ${pvalue`x'}
}

matrix t1norm = ($meanagenorm, $sdagenorm, $pvalueage \ ///
				$meanheightnorm, $sdheightnorm, $pvalueheight \ ///
				$meanweightnorm, $sdweightnorm, $pvalueweight \ ///
				$meanvasbacknorm, $sdvasbacknorm, $pvaluevasback \ ///
				$meanvaslegnorm, $sdvaslegnorm, $pvaluevasleg \ ///
				$meanrmnorm, $sdrmnorm, $pvaluerm \ ///
				$meanodinorm, $sdodinorm, $pvalueodi \ ///
				$meaneq5d_indexnorm, $sdeq5d_indexnorm, $pvalueeq5d_index \ ///
				$meaneq5dpercnorm, $sdeq5dpercnorm, $pvalueeq5dperc \ ///
				$meansf12_pcsnorm, $sdsf12_pcsnorm, $pvaluesf12_pcs \ ///
				$meansf12_mcsnorm, $sdsf12_mcsnorm, $pvaluesf12_mcs \ ///
				$meantug1_1norm, $sdtug1_1norm,  $pvaluetug1_1 )
				
matrix colnames t1norm = "Mean" "SD" "p-Value"
matrix rownames t1norm = Age Height Weight VAS_Back VAS_Leg Roland_Morris Oswestry EQ5D EQ5Dperc SF12_PCS SF12_MCS TUG

$tablesfolder
putexcel A1=matrix(t1norm, names) using table1norm, replace
matrix list t1norm


$databasefolder
*Categorical Var
use normalTUG, clear
matrix drop _all
foreach var of varlist $binarycatvar {
levelsof `var'
local level = r(levels)
	foreach num of numlist `level' {
		count if `var' == `num'
		local subtotal = r(N)
		count
		local total = r(N)
		matrix `var'`num' = `subtotal', round((`subtotal'/`total')*100,.1)
		}
	matrix normal`var' = 9999, 9999
	foreach num of numlist `level' {
	matrix normal`var' = normal`var' \ `var'`num'
	}
}

$databasefolder
use TUGdata, clear

foreach var of varlist $binarycatvar {
levelsof `var'
local level = r(levels)
	foreach num of numlist `level' {
		count if `var' == `num'
		local subtotal = r(N)
		count
		local total = r(N)
		matrix `var'`num' = `subtotal', round((`subtotal'/`total')*100,.1)
		}
	matrix baseline`var' = 9999, 9999
	foreach num of numlist `level' {
	matrix baseline`var' = baseline`var' \ `var'`num'
	}
}

matrix J = .,.,.,.
foreach var of varlist $binarycatvar { 
matrix `var' = normal`var' , baseline`var'
matrix `var' = `var'[2..3,1...]
matrix J = J \ `var'
}

matrix J = J[2..7,1...]
matrix colnames J = "Freq" "%" "Freq" "%"
matrix rownames J = "Males" "Females" "Non-Smokers" "Smokers" "Not Working" "Working"

$tablesfolder
putexcel A1=matrix(J, names) using table1categorical, replace
matrix list J

*For CHI2 Calculations
$databasefolder
*Categorical Var
use normalTUG, clear
matrix drop _all
foreach var of varlist $binarycatvar {
levelsof `var'
local level = r(levels)
	foreach num of numlist `level' {
		count if `var' == `num'
		matrix `var'`num' = r(N)
		}
	matrix normal`var' = 9999
	foreach num of numlist `level' {
	matrix normal`var' = normal`var' \ `var'`num'
	}
}


$databasefolder
use TUGdata, clear

foreach var of varlist $binarycatvar {
levelsof `var'
local level = r(levels)
	foreach num of numlist `level' {
		count if `var' == `num'
		matrix `var'`num' = r(N)
		}
	matrix baseline`var' = 9999
	foreach num of numlist `level' {
	matrix baseline`var' = baseline`var' \ `var'`num'
	}
}

foreach var of varlist $binarycatvar { 
matrix `var' = normal`var' , baseline`var'
matrix `var' = `var'[2..3,1...]

global `var'chi2 = ((((`var'[1,1] * `var'[2,2])-(`var'[1,2]*`var'[2,1]))^2) * (`var'[1,1] + `var'[1,2] + `var'[2,1] + `var'[2,2])) / ((`var'[1,1] + `var'[1,2]) * (`var'[2,1] + `var'[2,2]) * (`var'[1,2] + `var'[2,2]) * (`var'[1,1] + `var'[2,1]))
global `var'pvalue = chi2tail(1,${`var'chi2})
di "`var' p-value"
di ${`var'pvalue}
}



***** Model 1 *****
regress bl_tug i.diagnosis c.bl_rm c.age i.sex c.bmi c.bl_vasleg bl_vasback paresis cci

***** Model 2 *****
regress bl_tug c.bl_odi c.age i.sex  c.bl_vasleg bl_vasback c.bmi paresis cci 





