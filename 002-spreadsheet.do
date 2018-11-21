
destring age-bmi loh-bl_sf12_mcs, ignore("n/a") replace

misstable summarize age-bmi 

gen age2cat=.
replace age2cat=0 if age<60
replace age2cat=1 if age>=60
la def age2cat 0 "Younger" 1 "Older"
la val age2cat age2cat

la def sex 0 "Male" 1 "Female"
la val sex sex

gen logtug=log(bl_tug)


$databasefolder
save TUGdata, replace

