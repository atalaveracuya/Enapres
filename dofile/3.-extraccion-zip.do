
*Paso 2: extraccion zip
 * Archivos de SPSS 
global url 		 "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS"

forvalues i=$ini/$fin{

	local year=2000
	local year=`year' + `i'
	local t = `year'+1-$inicio

	cd "$dataset"
	cap mkdir `year'
	cd `year'
	
	cap mkdir "Download"
	cd "Download"

	scalar r_enapres=ENAPRES[`t',1]
		forvalue j=1/12{
		scalar r_menapres=MENAPRES[`t',`j']
		display "`year'" " " r_enapres " " r_menapres
		local menapres=r_menapres
		local enapres=r_enapres
		cap copy $url/`enapres'-Modulo`menapres'.zip BD`enapres'_`menapres'.zip 
		cap unzipfile BD`enapres'_`menapres', replace
		cap erase BD`enapres'_`menapres'.zip
		}
		
	}

	
/*	http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS/495-Modulo699.zip

global url 		 "http://iinei.inei.gob.pe/iinei/srienaho/descarga/SPSS"

forvalues i=$ini/$fin{

	local year=2000
	local year=`year' + `i'
	local t = `year'+1-$inicio

	scalar r_enapres=ENAPRES[1,1]
		forvalue j=1/12{
		scalar r_menapres=MENAPRES[`t',`j']
		display "`year'" " " r_enapres " " r_menapres
		local menapres=r_menapres
		local enapres=r_enapres
		cap copy $url/`enapres'-Modulo`menapres'.zip BD`enapres'_`menapres'.zip 
*		cap unzipfile BD`enapres'_`menapres', replace
*		cap erase BD`enapres'_`menapres'.zip
		}
} 
*/
