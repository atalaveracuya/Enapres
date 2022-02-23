***********************************
global periodo=$final - $inicio + 1
global ini=$inicio-2000 
global fin=$final-2000  

display "$periodo"
display "$ini"
display "$fin"

*codigo de encuestas 
clear 
input int codenc int anio
266 2010
293	2011
325	2012
406	2013
438	2014
495	2015
544	2016
596	2017
626	2018
684 2019
736	2020
end

keep if anio>=$inicio & anio<=$final  


**matrix codigo de encuesta - ENAHO 
mkmat codenc, mat(ENAPRES)
mat list ENAPRES



