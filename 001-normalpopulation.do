******Reliability and Agreement******
$databasefolder
insheet using "TESTRETESTlongmaster.csv", clear delimiter(",")
$analysisfolder 

summarize tug, detail

summarize tug if test==1
global inter_ICC_AB_sd `r(sd)'
summarize tug if rater==1
global intra_ICC_AB_sd `r(sd)'

*ICC Intra-Rater Reliability
icc tug target test if rater==1, consistency format(%9.2f)
global intra_ICC_CO `r(icc_i)'
icc tug target test if rater==1, format(%9.2f)
global intra_ICC_AB `r(icc_i)'

*ICC Inter-Rater Reliability
icc tug target rater if test==1, consistency format(%9.2f)
global inter_ICC_CO  `r(icc_i)'
icc tug target rater if test==1, format(%9.2f)
global inter_ICC_AB `r(icc_i)'

*Standard Error of Measurement
global intraSE = $intra_ICC_AB_sd * sqrt(1 - $inter_ICC_AB)
display $intraSE

global interSE = $inter_ICC_AB_sd * sqrt(1 - $inter_ICC_AB)
display $interSE

matrix rater = ($intra_ICC_CO, $inter_ICC_CO \ ///
				$intra_ICC_AB, $inter_ICC_AB \ ///
				$intraSE, $interSE)
matrix colnames rater = Intra-Rater Inter-Rater
matrix rownames rater = Consistency Absolute "Standard Error of Measurement"

$tablesfolder
putexcel A1=matrix(rater, names) using table2reliability, replace


******Characteristics of the Normal Population******

$databasefolder
insheet using "CONTROLmaster.csv", clear delimiter(",")
quietly {
drop bmi
gen bmi=weight/((height/100)^2)

gen age2cat=.
replace age2cat=0 if age<60
replace age2cat=1 if age>=60
la val age2cat age2cat
}
drop if centre==.
save normalTUG, replace

***Table 1 Macro Building***
foreach var of varlist $normalcontvar {
tabstat `var', statistic(mean sd) save
matrix l = r(StatTotal)
global mean`var'norm = l[1,1]
global sd`var'norm = l[2,1]
}

quietly {
$tablesfolder
tabout $normalcatvar using normalscontvartable1.csv, ///
         c(mean age sd age mean height sd height mean weight sd weight mean bmi sd bmi ///
		 mean vasback sd vasback mean vasleg sd vasleg mean rm sd rm mean odi sd odi mean eq5d_index sd eq5d_index mean sf12_pcs sd sf12_pcs mean sf12_mcs sd sf12_mcs mean tug1_1 sd tug1_1) replace oneway sum ///
		 f(1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1c 1p 1c 1c 1c) ///
		 clab(Age SD Height_(cm) SD Weight_(kg) SD BMI SD VAS_Back SD VAS_Leg SD Roland-Morris SD Owswestry_Disability_Index SD EQ5D_Index SD sf12_pcs SD sf12_mcs SD TUG_Time SD)

tabout $normalcatvar using normalscatvartable1.csv, oneway replace c(freq col) lines(none) clab(No. %) ///
	f(0 0p 0 0p 0 0p) style(csv) layout(No. % No. % No. %) ptotal(none) h3(nil)				 
}

******Normal Population TUG Values******
***Overall***
tabstat tug1_1, statistic(mean sd p1 q p99)
summarize tug1_1
global mean = r(mean)
global sd = r(sd)
global upper95  = $mean +($sd * 1.94)
global upper99  = $mean +($sd * 2.33)
display $upper95
display $upper99


***Stratified by Age (60yrs)***
forval x = 0/1 {
swilk tug1_1 if age2cat==`x'
summarize tug1_1 if age2cat==`x'
global MEANagecat`x' = r(mean)
global SDagecat`x' = r(sd)

global upper95agecat`x'  = ${MEANagecat`x'} + (${SDagecat`x'} * 1.94)
global upper99agecat`x'  = ${MEANagecat`x'} + (${SDagecat`x'} * 2.33)

display ${upper95agecat`x'}
display ${upper99agecat`x'}
}

***Stratified by Sex (females==1)***
forval x = 0/1 {
swilk tug1_1 if sex==`x'
summarize tug1_1 if sex==`x'
global MEANsex`x' = r(mean)
global SDsex`x' = r(sd)

global upper95sex`x'  = ${MEANsex`x'} +(${SDsex`x'} * 1.94)
global upper99sex`x'  = ${MEANsex`x'} +(${SDsex`x'} * 2.33)

display ${upper95sex`x'}
display ${upper99sex`x'}
}

***Stratified by Age (60yrs) & Sex (females==1)***
forval x = 0/1 {
	forval y = 0/1 {
	
	swilk tug1_1 if age2cat==`x' & sex==`y'
	summarize tug1_1 if age2cat==`x' & sex==`y'
	global MEANagecat`x'sex`y' = r(mean)
	global SDagecat`x'sex`y' = r(sd)

	global upper95agecat`x'sex`y'  = ${MEANagecat`x'sex`y'} + (${SDagecat`x'sex`y'} * 1.94)
	global upper99agecat`x'sex`y'  = ${MEANagecat`x'sex`y'} + (${SDagecat`x'sex`y'} * 2.33)

	display ${upper95agecat`x'sex`y'}
	display ${upper99agecat`x'sex`y'}
	}
}

display $upper95agecat1

matrix x = ($MEANagecat0sex0, $SDagecat0sex0, $upper99agecat0sex0, $MEANagecat0sex1, $SDagecat0sex1, $upper99agecat0sex1, $MEANagecat0, $SDagecat0, $upper99agecat0 \ ///
		   $MEANagecat1sex0, $SDagecat1sex0, $upper99agecat1sex0, $MEANagecat1sex1, $SDagecat1sex1, $upper99agecat1sex1, $MEANagecat1, $SDagecat1, $upper99agecat1 \ ///
		   $MEANsex0, $SDsex0, $upper99sex0, $MEANsex1, $SDsex1, $upper99sex1, $mean, $sd, $upper99 )
matrix colnames x = "Male (Mean)" "Male (SD)" "Male (UL 99%)" "Female (Mean)" "Female (SD)" "Female (UL 99%)" "Overall (Mean)" "Overall (SD)" "Overall (UL 99%)"
matrix rownames x = <60yrs >60yrs Overall

$tablesfolder
putexcel A1=matrix(x, names) using table3meansdlimits, replace
matrix list x


