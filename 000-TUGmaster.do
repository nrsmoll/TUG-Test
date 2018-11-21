version 13.1
clear
capture log close
set more off
set scheme s2mono
*_____Macros_____
*Spreadsheet filenames
global primaryvar 

cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/part4BASELINE"
log using "TUGmasterdo.smcl", replace

*****************************************
*										*
*	Project name:		TUG				*
*	Programmed by:		Nicolas Smoll	*
*										*
*****************************************

quietly {
*Change directory commands
global dofilesfolder cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/part4BASELINE/dofiles/"
global analysisfolder cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/part4BASELINE/analysis/"
global databasefolder cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/maindatabase"
global tablesfolder cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/part4BASELINE/tables"
global figuresfolder cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/part4BASELINE/figures"

*Variable Lists
global baselinecatvar "sex level side paresis bmrc cci asa smoking working"
global normalcatvar "sex bmrc cci asa smoking working"
global binarycatvar "sex smoking working"
global baselinecontvar "age height weight bl_vasback bl_vasleg bl_rm bl_odi bl_eq5d_index bl_eq5dperc bl_sf12_pcs bl_sf12_mcs bl_tug"
global normalcontvar "age height weight vasback vasleg rm odi eq5d_index eq5dperc sf12_pcs sf12_mcs tug1_1"
}



$dofilesfolder
do 001-normalpopulation
$databasefolder
insheet using "HUGKSSGmaster.csv", clear delimiter(",")
$dofilesfolder
quietly {
do 002-spreadsheet
}
$dofilesfolder
do 003-baselinepopulation
$dofilesfolder
do 004-figures
$dofilesfolder
do 005-tscore





log close
cd "/users/nrsmoll/Dropbox/myresearch/TUGswiss/part4BASELINE"
translate TUGmasterdo.smcl Baseline_Results.pdf, replace
erase TUGmasterdo.smcl

exit

