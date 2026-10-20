# Data access and preparation

The repository deliberately does **not** distribute respondent-level survey files.

## Original survey

- **Survey:** Morocco, *Enquête sur la Population et la Santé Familiale* (EPSF), 2003–2004.
- **DHS catalog reference:** `MAR_2003_DHS_v01_M`.
- **Metadata:** https://microdata.worldbank.org/catalog/1430
- **Authorized data access:** https://dhsprogram.com/data/available-datasets.cfm

Review the applicable DHS terms and register/request access for the relevant survey files before using them. You must independently meet any requirements for access and use; public GitHub hosting does not authorize republication of microdata.

## Prepared analysis input

The archived Stata script expects an analysis-ready **`BD.dta`** file with variables:

`stunting`, `genre`, `pauvrete`, `area`, `clean_water`, `clean_wc`, `mater_age`, `g_age`, `hhage`, `child_rank`, `sex_cm`, `region`, `wt`.

This is a **custom prepared-data schema** inferred from the original Stata code, *not* a claim that the official DHS files expose these exact variable names or category codings.

No data preparation or crosswalk is available here. In particular, do not assume the revised script will work on a downloaded raw DHS file without recoding and filtering.

If you have an authorized copy of the exact historical `BD.dta` and verified documentation for its construction, store it locally at `data/BD.dta`; `.gitignore` prevents it being committed to this repo.

For any published statistical results, cite the exact DHS survey and the download source/date in accordance with the survey catalog's citation requirements.
