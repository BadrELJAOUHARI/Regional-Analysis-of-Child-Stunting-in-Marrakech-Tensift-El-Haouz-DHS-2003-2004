# Child Stunting in Morocco: A Regional DHS Analysis (2003–2004)

### Marrakech–Tensift–El Haouz | Stata · Public Health · Logistic Regression

![Stata](https://img.shields.io/badge/Stata-Statistical_Analysis-1A5D9C) ![Data](https://img.shields.io/badge/Survey-Morocco_DHS_2003–04-286D68) ![Methods](https://img.shields.io/badge/Methods-Logistic_Regression-6555A4)

**How is child stunting associated with household and demographic characteristics in the historical Marrakech–Tensift–El Haouz region of Morocco?**

This project documents an exploratory analysis of child stunting using data attributed to Morocco's **2003–2004 Enquête sur la Population et la Santé Familiale (EPSF)**, part of the Demographic and Health Surveys (DHS) series. It examines variation across child, maternal, and household characteristics through bivariate comparisons, graphical summaries, and logistic regression.

> **Project status:** Historical academic analysis and Stata code archive. The original report is provided for reference. The revised Stata script is a separately labelled, **untested** code-cleanup proposal; it has not been run against the original prepared data. Do not treat this repository as an independently verified or fully reproducible statistical replication.

## Research focus

Child stunting is an indicator of chronic undernutrition, commonly operationalized using height-for-age measurements relative to a child growth standard. The study's original Stata file uses a prepared binary `stunting` variable; the underlying code that constructs this measure from raw DHS anthropometry is **not included**.

The analysis asks how stunting status varies with:

- **Child characteristics:** age group, sex, birth order, and recorded weight.
- **Maternal and household characteristics:** mother's age; household-head age and sex.
- **Living conditions:** poverty category, rural/urban area, drinking-water access, and sanitation access.

The original script also references a `region` variable. Its categories and relationship to the geographic study restriction should be checked against the prepared data and report before interpreting any within-region comparisons.

## Analytical approach

| Component | Stata implementation | Purpose |
| --- | --- | --- |
| Descriptive comparisons | `tabulate`, `summarize` | Inspect differences in stunting status across groups |
| Bivariate associations | Pearson chi-square tests; two-sample *t*-test | Explore group differences, without implying causality |
| Visualization | Bar charts and box plots | Summarize observed distributions |
| Binary-outcome modelling | `logit` | Examine conditional associations between the recorded predictors and stunting status |
| Model diagnostics | `estat gof`, `lroc` | Inspect grouped goodness-of-fit and discrimination |

The study is **observational**. Neither statistically significant associations nor model discrimination should be presented as evidence of a causal effect.

## Repository contents

```text
.
├── README.md
├── analysis/
│   ├── stunting_analysis_original.do      # Original code, archived unchanged
│   └── stunting_analysis_reviewed.do      # Cautiously revised; untested
├── docs/
│   └── child-stunting-marrakech-2003-2004-report.pdf
├── data/
│   └── README.md                          # Data provenance and access
└── .gitignore
```

The PDF is the **original submitted analysis report**, not a newly generated report from the reviewed script.

## Data and provenance

**Survey:** *Enquête sur la Population et la Santé Familiale 2003–2004* (Morocco DHS 2003–04), catalog reference `MAR_2003_DHS_v01_M`. The survey was produced by Moroccan health-sector institutions and is part of the DHS survey program.

- [World Bank Microdata Library: survey metadata and citation guidance](https://microdata.worldbank.org/catalog/1430)
- [DHS Program: available datasets](https://dhsprogram.com/data/available-datasets.cfm)
- [Guide to DHS Statistics](https://www.dhsprogram.com/pubs/pdf/DHSG1/Guide_to_DHS_Statistics_DHS-7_v2.pdf)

The analysis references a locally prepared file named **`BD.dta`**. This file is **not** a standard DHS distribution filename. The preparation and recoding steps that produced it have not been provided; downloading the original survey alone is therefore **not sufficient to reproduce the analysis**.

**No respondent-level DHS data are included in this repository.** Obtain datasets through authorized DHS access, comply with their terms, and do not publicly redistribute the underlying data or confidential respondent information. See [`data/README.md`](data/README.md).

## How to examine or run the code

1. Review the [original report](docs/child-stunting-marrakech-2003-2004-report.pdf) and original Stata script to understand the historical analysis.
2. Obtain authorized access to the relevant DHS files and, separately, the data-preparation/recode specification needed to construct the project-specific `BD.dta`.
3. For the proposed cleanup script, place the prepared `BD.dta` at `data/BD.dta` in your local working copy.
4. From the repository root in Stata, run:

   ```stata
   do "analysis/stunting_analysis_reviewed.do"
   ```

5. Inspect generated tables, diagnostics, and figures in `outputs/`. Compare all regenerated results with the report before interpreting or presenting them.

The reviewed script expects `stunting` to contain the strings `Yes` and `No`, and it expects categorical predictors to be numeric. It fails rather than silently guessing when these assumptions are not met.

## Known limitations and methodological considerations

- **Prepared dataset missing:** `BD.dta`, its codebook, the regional filtering logic, and preprocessing steps are not available in this repository.
- **Survey design:** The archived script does not declare DHS weights, clusters, or strata through `svyset`. Its significance tests and standard errors should not be treated as design-corrected estimates. DHS guidance recommends accounting for the survey design in inference.
- **Original code issues:** The original outcome recode can treat missing labels as `0`; `summarize wt, by(stunting)` is not valid Stata syntax; and ungrouped `estat gof` is not necessarily the Hosmer–Lemeshow test described in the comments.
- **Reviewed version not validated:** The updated code corrects obvious handling and syntax issues but may yield results different from those in the report. The data and Stata runtime were not available for a reproducibility check.
- **Interpretation:** Stunting risk factors are associations in historical, observational survey data. The regional name refers to the administrative geography used at that time; estimates should not be extrapolated to present-day Marrakech or Morocco.

## Scope of future improvements

A complete replication would require the original authorized data, preprocessing/recode script, variable dictionary, confirmation of the height-for-age stunting definition, explicit survey-design settings, and a rerun of all tables and regression diagnostics. These elements have **not** been invented or backfilled here.

## Author and acknowledgement

**Badr El Jaouhari** — statistical analysis and project documentation.

**Data acknowledgement:** Morocco's *Enquête sur la Population et la Santé Familiale 2003–2004* and the institutions responsible for its production and dissemination. The data providers are not responsible for this project's analysis or conclusions.

This is an independent academic portfolio project and is not endorsed by the DHS Program or Moroccan health authorities.
