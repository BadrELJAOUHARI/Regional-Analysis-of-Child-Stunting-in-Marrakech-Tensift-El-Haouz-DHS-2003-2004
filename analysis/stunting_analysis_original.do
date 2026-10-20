**DO-FILE Analyse Régionale du Phénomène du Retard de Croissance Région Marrakech-Tensift-El Haouz**

* Lecture de la base de données 
use "BD.dta"

* 1) Analyse bivariée entre stunting et toutes les variables

	* stunting vs genre (Bar Chart)
tabulate stunting genre, chi2 expected row
graph bar (count), over(genre) by(stunting) title("Retard de croissance par genre")

	* stunting vs pauvrete (Bar Chart)
tabulate stunting pauvrete, chi2 expected row
graph bar (count), over(pauvrete) by(stunting) title("Retard de croissance par niveau de pauvreté")

	* stunting vs area (Bar Chart)
tabulate stunting area, chi2 expected row
graph bar (count), over(area) by(stunting) title("Retard de croissance par zone géographique")

	* stunting vs clean_water (Bar Chart)
tabulate stunting clean_water, chi2 expected row
graph bar (count), over(clean_water) by(stunting) title("Retard de croissance par accès à l'eau potable")

	* stunting vs clean_wc (Bar Chart)
tabulate stunting clean_wc, chi2 expected row
graph bar (count), over(clean_wc) by(stunting) title("Retard de croissance par accès à des toilettes propres")

	* stunting vs mater_age (Bar)
		* Histogram with percentages
tabulate mater_age, generate(perc_mater_age)
graph bar (percent), over(mater_age) by(stunting, legend(order(1 "Sans retard" 2 "Avec retard")))  title("Retard de croissance par âge de la mère") subtitle("Pourcentage par catégorie")

	* stunting vs g_age (Bar)
		* Histogram with percentages
tabulate g_age, generate(perc_g_age)
graph bar (percent), over(g_age) by(stunting, legend(order(1 "Sans retard" 2 "Avec retard"))) title("Retard de croissance par âge de l'enfant") subtitle("Pourcentage par catégorie")

	* stunting vs hhage (Bar Chart)
tabulate stunting hhage, chi2 expected row
graph bar (count), over(hhage) by(stunting) title("Retard de croissance par âge du chef de ménage")

	* stunting vs child_rank (Bar Chart)
tabulate stunting child_rank, chi2 expected row
graph bar (count), over(child_rank) by(stunting) title("Retard de croissance par rang de naissance")

	* stunting vs sex_cm (Bar Chart)
tabulate stunting sex_cm, chi2 expected row
graph bar (count), over(sex_cm) by(stunting) title("Retard de croissance par sexe du chef de ménage")

	* stunting vs region (Bar Chart)
tabulate stunting region, chi2 expected row
graph bar (count), over(region) by(stunting) title("Retard de croissance par région géographique")

	* stunting vs wt 
summarize wt, detail
summarize wt, by(stunting)

	* Test t de Student pour comparer les moyennes
ttest wt, by(stunting)

	* Boxplot pour visualiser la distribution du poids par statut de retard
graph box wt, over(stunting) title("Distribution du poids par retard de croissance")


* 2) Analyse de régression logistique

	* Création de la variable binaire pour la malnutrition
gen stunting_Yes = 0
replace stunting_Yes = 1 if stunting == "Yes"

	* Transformation des variables catégoriques en variables indicatrices
tab g_age, gen(g_age)
tab genre, gen(genre)
tab child_rank, gen(child_rank)
tab mater_age, gen(mater_age)
tab clean_water, gen(clean_water)
tab clean_wc, gen(clean_wc)
tab pauvrete, gen(pauvrete)
tab area, gen(area)
tab sex_cm, gen(sex_cm)
tab hhage, gen(hhage)

	* Suppression des valeurs manquantes
drop if missing(stunting_Yes)

	* Régression logistique
logit stunting_Yes g_age2 g_age3 g_age4 g_age5 genre2 child_rank2 child_rank3 mater_age2 mater_age3 mater_age4 mater_age5 clean_water2 clean_wc2 pauvrete2 pauvrete3 area2 sex_cm2 hhage2 hhage3 hhage4 hhage5

	* Test de Hosmer-Lemeshow
estat gof

	* Courbe ROC
lroc

	* Exportation des résultats
capture outreg2 using results.doc, replace
