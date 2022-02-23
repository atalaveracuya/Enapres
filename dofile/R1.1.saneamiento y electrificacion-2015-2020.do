
/*---------------------------------------------------------------*
| Title: 	Limpieza, preparación de base de datos, indicadores	 |
| Project: 	Aálisis de Indicadores Enapres			             |
| Author:	Andrés Talavera Cuya						         |
| 					  									         |
|															     |
| Description:                                                   |
| Este .do importa las bases de datos de los módulos de la 	     |
|		Enapres y genera indicadores relevantes para el análisis |
| Date Created: 07/02/2022		 					             | |										                        | 
|                                                                |
| Version: Stata 16       	            					     |
*----------------------------------------------------------------*/

*---------------------------------------------------------------
*Transformar Bases de datos en Formato STATA
*---------------------------------------------------------------

global ubicacion "D:\ANDRES\Documentos\GitHub\IndicadoresStata\Enapres2" 
global Inicial   "$ubicacion\dataset\Inicial"
global excel     "$ubicacion\\excel"
cd "$Inicial"




	forvalue i =19/20{
	local year=2000
	local year=`year' + `i'

	cd "$Inicial"


		local allfiles : dir "." files "CAP_100*.sav"  
		foreach f of local allfiles {
			local g0=subinstr("`f'","CAP", "",.)
			local g1=subinstr("`g0'",".sav", "",.)
			local g2=subinstr("`g1'","  ", "",.)
			local g3=subinstr("`g2'"," `year'", "",.)
			display " ------------------Ano: `g2' -----------------"			
			import spss using "`f'", clear
			saveold "$Inicial\\`g2'.dta", replace
		}

	}

**


use cap_100_2019.dta,clear 
rename *, lower
tab p129a
replace p129a="6" if p129a=="6A" 
replace p129a="6" if p129a=="6B" 
destring p129a,replace 

replace p142="4" if p142=="4A"
replace p142="7" if p142=="7A"
destring p142,replace 
saveold cap_100_2019.dta,replace 


use cap_100_2018.dta,clear 
rename *, lower
br p109 p129a p142 p146 resfin ccdd
replace p129a="6" if p129a=="6A" 
replace p129a="6" if p129a=="6B" 
destring p129a,replace 

replace p142="4" if p142=="4A"
replace p142="7" if p142=="7A"
destring p142,replace 
saveold cap_100_2018.dta,replace 

 
use cap_100_2017.dta,clear 
rename *, lower
rename factoranual factor  
saveold cap_100_2017.dta,replace 


use cap_100_2016.dta,clear
rename *, lower
rename factoranual factor  
*elabel list (regionnatu) iff (# != .)
*label drop labels245
rename regionnatu Regionnatu
gen regionnatu=string(Regionnatu)
saveold cap_100_2016.dta,replace 


use cap_100_2015.dta,clear 
rename *, lower
rename factoranual factor  
saveold cap_100_2015.dta,replace 

use cap_100_2020.dta,clear 
rename *, lower
rename p129g p129a
rename p142a p142 
saveold cap_100_2020.dta,replace 




use cap_100_2015.dta,clear 
append using cap_100_2016.dta ,force 
append using cap_100_2017.dta ,force 
append using cap_100_2018.dta ,force 
append using cap_100_2019.dta ,force 
append using cap_100_2020.dta ,force 



*departamentos 

******************************
******  Variable rDpto  ******
******************************
drop ubigeo
gen ubigeo=ccdd+ccpp+ccdi 
gen rDpto=real(substr(ubigeo,1,2))

label var rDpto "Departamento"

label define rDpto /*
*/ 1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" /*
*/ 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Lima" 16 "Loreto" 17 "Madre de Dios" 18 "Moquegua" 19 "Pasco" 20 "Piura" /* 
*/ 21 "Puno" 22 "San Martín" 23 "Tacna" 24 "Tumbes" 25 "Ucayali"

label values rDpto rDpto

*******************************
******  Variable rDpto2  ******
*******************************


gen LimMetro=.
replace LimMetro=1 if rDpto==7
replace LimMetro=1 if nombrepp=="LIMA"

gen rDpto2=rDpto if rDpto<16
replace rDpto2=16 if rDpto==15 & LimMetro!=1
replace rDpto2=rDpto+1 if rDpto>=16

label var rDpto2 "Departamento"

label define rDpto2 /*
*/ 1 "Amazonas" 2 "Áncash" 3 "Apurímac" 4 "Arequipa" 5 "Ayacucho" 6 "Cajamarca" 7 "Prov Const del Callao" 8 "Cusco" 9 "Huancavelica" 10 "Huánuco" /*
*/ 11 "Ica" 12 "Junín" 13 "La Libertad" 14 "Lambayeque" 15 "Prov de Lima" 16 "Lima Provincias" 17 "Loreto" 18 "Madre de Dios" 19 "Moquegua" 20 "Pasco" 21 "Piura" /* 
*/ 22 "Puno" 23 "San Martín" 24 "Tacna" 25 "Tumbes" 26 "Ucayali"

label values rDpto2 rDpto2


la def p129a 1 "Red pública dentro de la vivienda" 2 "Red pública fuera de la vivienda,pero dentro de la edificación" 3 "Pilón o pileta de uso público" 4 "Camión-cisterna u otro similar" 5 "Pozo (agua subterránea)" 6 "Río, acequia, manantial o similar" 7 "Otro"
la val p129a p129a


*COBERTURA DE AGUA POR RED PÚBLICA
gen agua=(p129a==1 | p129a==2 | p129a==3)
la var agua "Agua por red pública"
la def agua 1 "tiene" 0 "no tiene" 
la val agua agua  


*COBERTURA DE ALCANTARILLADO U OTRAS FORMAS DE DISPOSICIÓN DE EXCRETAS
gen desague=(p142==1 | p142==2 | p146==3)
la var desague "desagüe por red pública"
la def desague 1 "tiene" 0 "no tiene" 
la val desague desague  

*COBERTURA DE ELECTRIFICACIÓN POR RED PÚBLICA

recode p109 (1=1 "Tiene") (2=0 "No tiene"), gen(elec)
 
*SERVICIO BÁSICO INTEGRADO
gen ssintegr=((p109==1) & (p129a==1 | p129a==2 | p129a==3) & (p142==1 | p142==2 | p146==3))
la def ssintegr 1 "tiene" 0 "no tiene" 
la val ssintegr ssintegr 


*INTERRUPCIONES O CORTES EN LA ENERGÍA ELÉCTRICA 
*(No Incluye los cortes por falta de pago)
gen ss=p111a if elec==1 
recode ss (1=1 "Tiene") (2=0 "No tiene"), gen(corteselec)
la var corteselec "INTERRUPCIONES O CORTES EN LA ENERGÍA ELÉCTRICA, EN EL MES ANTERIOR"


*CONTINUIDAD EN LA PROVISIÓN DE AGUA 
*horas_sem: número de horas a la semana en que los hogares cuenta con el servicio de agua por red pública.

*horas_dia: número de horas al día en que los hogares cuenta con el servicio de agua por red pública.

*gen agua=(p129a==1 | p129a==2 | p129a==3)
gen horas_sem=p130a*7 if p130==1 & agua==1
replace horas_sem=p130b*p130c if horas_sem==.

gen horas_dia=horas_sem/7

****************
**Estimaciones** 
****************
*TIPO DE ABASTECIMIENTO DE AGUA 
tab anio p129a  [iw=factor], nofreq row  

**NACIONAL 

*COBERTURA DE AGUA POR RED PÚBLICA 
tab anio agua  [iw=factor] ,nofreq row matcell(agua) 
tab rDpto2 agua if anio=="2019" [iw=factor] ,nofreq row  
 
mat list agua
mata : st_matrix("rowtot", rowsum(st_matrix("agua")))
mat list rowtot
mata: st_matrix("agua_pc", st_matrix("agua") :/ st_matrix("rowtot"))
mata: st_matrix("agua_pc", st_matrix("agua_pc") :* 100)
mat agua_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat agua_pcx[`i',1]=agua_pc[`j',2]
}

putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel Q8 = matrix(agua_pcx),nformat(#,#) hcenter  

mat list agua_pcx

*COBERTURA DE ALCANTARILLADO U OTRAS FORMAS DE DISPOSICIÓN DE EXCRETAS 
tab anio desague   [iw=factor] ,nofreq row matcell(desague)  
tab rDpto2 desague if anio=="2019" [iw=factor] ,nofreq row  

mata : st_matrix("rowtot", rowsum(st_matrix("desague")))
mata: st_matrix("desague_pc", st_matrix("desague") :/ st_matrix("rowtot"))
mata: st_matrix("desague_pc", st_matrix("desague_pc") :* 100)
mat desague_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat desague_pcx[`i',1]=desague_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel R8 = matrix(desague_pcx),nformat(#,#) hcenter  

mat list desague_pcx

*ELECTRIFICACIÓN POR RED PÚBLICA
tab anio elec  [iw=factor] ,nofreq row matcell(elec)  
tab rDpto2  elec if anio=="2019" [iw=factor] ,nofreq row  


mata : st_matrix("rowtot", rowsum(st_matrix("elec")))
mata: st_matrix("elec_pc", st_matrix("elec") :/ st_matrix("rowtot"))
mata: st_matrix("elec_pc", st_matrix("elec_pc") :* 100)

mat elec_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat elec_pcx[`i',1]=elec_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel S8 = matrix(elec_pcx),nformat(#,#) hcenter  

mat list elec_pcx


*COBERTURA DE SERVICIO BÁSICO INTEGRADO
tab anio ssintegr [iw=factor] ,nofreq row matcell(ssintegr)  
tab rDpto2 ssintegr if anio=="2019" [iw=factor] ,nofreq row  

mata : st_matrix("rowtot", rowsum(st_matrix("ssintegr")))
mata: st_matrix("ssintegr_pc", st_matrix("ssintegr") :/ st_matrix("rowtot"))
mata: st_matrix("ssintegr_pc", st_matrix("ssintegr_pc") :* 100)

mat ssintegr_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat ssintegr_pcx[`i',1]=ssintegr_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel T8 = matrix(ssintegr_pcx),nformat(#,#) hcenter  

mat list ssintegr_pcx

**
**RURAL 
**
*COBERTURA DE AGUA POR RED PÚBLICA - RURAL
tab anio agua if area==2  [iw=factor] ,nofreq row matcell(agua) 
tab rDpto2 agua if area==2 & anio=="2019" [iw=factor] ,nofreq row  

mat list agua
mata : st_matrix("rowtot", rowsum(st_matrix("agua")))
mat list rowtot
mata: st_matrix("agua_pc", st_matrix("agua") :/ st_matrix("rowtot"))
mata: st_matrix("agua_pc", st_matrix("agua_pc") :* 100)
mat agua_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat agua_pcx[`i',1]=agua_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel Q27 = matrix(agua_pcx),nformat(#,#) hcenter  

mat list agua_pcx

*COBERTURA DE ALCANTARILLADO U OTRAS FORMAS DE DISPOSICIÓN DE EXCRETAS -RURAL
tab anio desague if area==2  [iw=factor] ,nofreq row matcell(desague)  
tab rDpto2 desague if area==2 & anio=="2019" [iw=factor] ,nofreq row  

mata : st_matrix("rowtot", rowsum(st_matrix("desague")))
mata: st_matrix("desague_pc", st_matrix("desague") :/ st_matrix("rowtot"))
mata: st_matrix("desague_pc", st_matrix("desague_pc") :* 100)
mat desague_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat desague_pcx[`i',1]=desague_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel R27 = matrix(desague_pcx),nformat(#,#) hcenter  

mat list desague_pcx


tab rDpto2 desague if area==2 & anio=="2020" [iw=factor] ,nofreq row  



*ELECTRIFICACIÓN POR RED PÚBLICA- AREA RURAL 
tab anio elec if area==2  [iw=factor] ,nofreq row matcell(elec)  
tab rDpto2  elec if area==2 & anio=="2019" [iw=factor] ,nofreq row  

mata : st_matrix("rowtot", rowsum(st_matrix("elec")))
mata: st_matrix("elec_pc", st_matrix("elec") :/ st_matrix("rowtot"))
mata: st_matrix("elec_pc", st_matrix("elec_pc") :* 100)

mat elec_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat elec_pcx[`i',1]=elec_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel S27 = matrix(elec_pcx),nformat(#,#) hcenter  

mat list elec_pcx


*COBERTURA DE SERVICIO BÁSICO INTEGRADO
tab anio ssintegr if area==2  [iw=factor] ,nofreq row matcell(ssintegr)  
tab rDpto2 ssintegr if area==2 & anio=="2019" [iw=factor] ,nofreq row  

mata : st_matrix("rowtot", rowsum(st_matrix("ssintegr")))
mata: st_matrix("ssintegr_pc", st_matrix("ssintegr") :/ st_matrix("rowtot"))
mata: st_matrix("ssintegr_pc", st_matrix("ssintegr_pc") :* 100)

mat ssintegr_pcx=J(6,1,.)

forvalues i=1/6 {
local j=`i'
mat ssintegr_pcx[`i',1]=ssintegr_pc[`j',2]
}
putexcel set "${excel}\report.xlsx", sheet("R1.1") modify 
putexcel T27= matrix(ssintegr_pcx),nformat(#,#) hcenter  

mat list ssintegr_pcx


*CONTINUIDAD EN LA PROVISIÓN DE AGUA
preserve 
collapse (mean) horas_dia (mean) horas_sem [iw=factor], by(anio area rDpto2)  
sort  rDpto2 anio 

keep if anio=="2020"
keep if area==2
sort horas_dia 
drop anio area horas_sem 
export excel using "${excel}\report.xlsx",sheet("R1.1" , modify) cell(V60) keepcellfmt   
restore 

preserve 
collapse (mean) horas_dia (mean) horas_sem [iw=factor], by(anio area)   
keep if anio=="2020"
keep if area==2
sort horas_dia 
export excel using "${excel}\report.xlsx",sheet("R1.1" , modify) cell(X60) keepcellfmt   
restore 


*CONTINUIDAD EN LA PROVISIÓN DE AGUA
preserve 
collapse (mean) horas_dia (mean) horas_sem [iw=factor], by(anio rDpto2)  
sort  rDpto2 anio 

keep if anio=="2020"
save "D:\ANDRES\Documentos\GitHub\MapaPeruGUI\dataset\horas_agua.dta" ,replace 
restore  

*EL MES ANTERIOR-CORTES DE ENERGÍA ELÉCTRICA 
*(No Incluye los cortes por falta de pago)
tab anio corteselec if elec==1 & area==2 [iw=factor] ,nofreq row matcell(corteselec) 

tab elec if anio=="2019"

tab corteselec if anio=="2019" 
tab rDpto2 corteselec if anio=="2019" [iw=factor] ,nofreq row  


*COBERTURA DE AGUA POR RED PÚBLICA - URBANO 
tab anio agua if area==1  [iw=factor] ,nofreq row matcell(agua) 
tab rDpto2 agua if area==1 & anio=="2020" [iw=factor] ,nofreq row  


*COBERTURA DE ALCANTARILLADO U OTRAS FORMAS DE DISPOSICIÓN DE EXCRETAS -URBANO 
tab anio desague if area==1 [iw=factor] ,nofreq row matcell(desague) 
tab rDpto2 desague if area==1 & anio=="2020" [iw=factor] ,nofreq row  


*ELECTRIFICACIÓN POR RED PÚBLICA- AREA URBANA 
tab anio elec if area==1 [iw=factor] ,nofreq row matcell(DSS)  
tab rDpto2 elec if area==1 & anio=="2019" [iw=factor] ,nofreq row  


*EL MES ANTERIOR-CORTES DE ENERGÍA ELÉCTRICA 
*(No Incluye los cortes por falta de pago)
tab anio corteselec if elec==1 & area==1 [iw=factor] ,nofreq row matcell(corteselec) 
tab area corteselec if elec==1, nofreq row 
tab rDpto2 corteselec if anio=="2019" [iw=factor] ,nofreq row  


*COBERTURA DE SERVICIO BÁSICO INTEGRADO
tab area ssintegr if area==1  [iw=factor], nofreq row 
tab rDpto2 ssintegr if area==1 [iw=factor], nofreq row 

**************************************************************************
