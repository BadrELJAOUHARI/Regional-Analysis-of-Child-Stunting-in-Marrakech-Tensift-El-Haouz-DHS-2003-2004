* Child stunting in historical Marrakech-Tensift-El Haouz (Morocco DHS 2003-04)
* PORTFOLIO REVIEW VERSION - UNTESTED; NOT THE ORIGINAL SUBMITTED ANALYSIS
* Requires separately prepared, authorized data/BD.dta matching the variables below.
* No claims of DHS sampling-design corrections are made in this exploratory script.

version 16.0
clear all
set more off

capture mkdir "outputs"
log using "outputs/stunting_analysis.log", text replace

capture confirm file "data/BD.dta"
if _rc {
    display as error "Missing data/BD.dta. See data/README.md; do not commit DHS microdata."
    log close
    exit 601
}
use "data/BD.dta", clear

* --- 1. Inspect expected variables and outcome coding ---
local predictors "genre pauvrete area clean_water clean_wc mater_age g_age hhage child_rank sex_cm region wt"
foreach v of local predictors {
    capture confirm variable `v'
    if _rc {
        display as error "Variable `v' is absent from prepared BD.dta."
        log close
        exit 111
    }
}
capture confirm string variable stunting
if _rc {
    display as error "This script expects string-valued stunting coded Yes/No. Verify recoding first."
    log close
    exit 459
}

* Explicitly preserve missing or unexpected outcome categories (do not label as No).
generate byte stunting_yes = .
replace stunting_yes = 1 if lower(strtrim(stunting)) == "yes"
replace stunting_yes = 0 if lower(strtrim(stunting)) == "no"
label define stunting_lbl 0 "Not stunted" 1 "Stunted", replace
label values stunting_yes stunting_lbl
count if missing(stunting_yes)
display as text "Observations with missing/unrecognized stunting: " r(N)
keep if !missing(stunting_yes)

* Categoricals were dummy-coded manually in the legacy code; use factor variables.
local cats "genre pauvrete area clean_water clean_wc mater_age g_age hhage child_rank sex_cm region"
foreach v of local cats {
    capture confirm numeric variable `v'
    if _rc {
        display as error "Categorical variable `v' is nonnumeric; encode with a verified codebook first."
        log close
        exit 459
    }
}

* --- 2. Descriptive/bivariate analysis ---
foreach v of local cats {
    display as text "--- Stunting vs. `v' ---"
    tabulate stunting_yes `v', row chi2 expected
    graph bar (count), over(`v') by(stunting_yes) ///
        title("Stunting by `v'") name(stunt_`v', replace)
    graph export "outputs/stunting_by_`v'.png", replace width(1600)
}

* Here wt is treated as a numeric quantity from the historical script.
* Check its actual definition; it may not be a sampling weight or child weight.
codebook wt
summarize wt, detail
by stunting_yes, sort: summarize wt
capture noisily ttest wt, by(stunting_yes)
graph box wt, over(stunting_yes) title("Recorded wt by stunting status") ///
    name(stunt_wt, replace)
graph export "outputs/wt_by_stunting.png", replace width(1600)

* --- 3. Exploratory logistic regression ---
* NOT survey-weighted, NOT a causal model. Input categories and model assumptions
* require validation against the report and the original data documentation.
logit stunting_yes i.g_age i.genre i.child_rank i.mater_age ///
    i.clean_water i.clean_wc i.pauvrete i.area i.sex_cm i.hhage
estimates store stunting_logit

* Grouped GOF: grouping is necessary when interpreting as Hosmer-Lemeshow.
capture noisily estat gof, group(10) table
lroc, title("Exploratory logistic model: ROC") name(stunting_roc, replace)
graph export "outputs/stunting_roc.png", replace width(1600)

* Model transcript is saved in outputs/stunting_analysis.log.
* To produce survey-design-correct inference, first establish weights/PSUs/
* strata from documented prepared data and revise the model accordingly.
log close
