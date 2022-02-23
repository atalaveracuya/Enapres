	
*Colocar data en files 		
global Inicial "$dataset\\Inicial"
cap mkdir "$Inicial"


forvalues i=$ini/$fin{

	local year=2000
	local year=`year' + `i'
	local t = `year'+1-$inicio

cd "$dataset"
cd `year'
cd "Download"

	scalar r_enapres=ENAPRES[`t',1]
	forvalue j=1/12{
		scalar r_menapres=MENAPRES[`t',`j']
		local mod=r_enapres
		local i=r_menapres
		display "`i'" " " "`year'" " " "`mod'" " "
		
		cap copy "`mod'-Modulo`i'\\CAP_100_URBANO_RURAL.sav" "$Inicial\\CAP_100_`year'.sav"
		cap copy "`mod'-Modulo`i'\\CAP_100_URBANO_RURAL_3.sav" "$Inicial\\CAP_100_`year'.sav"
*		cap copy "`mod'-Modulo`i'\\CAP_200_URBANO_RURAL.sav" "$Inicial\\CAP_200_`year'.sav"
*		cap copy "`mod'-Modulo`i'\\CAP_200_URBANO_RURAL_4.sav" "$Inicial\\CAP_200_`year'.sav"		
*		cap copy "`mod'-Modulo`i'\\CAP_500_URBANO_RURAL.sav" "$Inicial\\CAP_500_`year'.sav"
*		cap copy "`mod'-Modulo`i'\\CAP_500_URBANO_RURAL_6.sav" "$Inicial\\CAP_500_`year'.sav"

*		cap copy "`mod'-Modulo`i'\\CAP_600_URBANO_7.sav" "$Inicial\\CAP_600_`year'.sav"
*		cap copy "`mod'-Modulo`i'\\CAP_600_URBANO.sav" "$Inicial\\CAP_600_`year'.sav"
		
	
		}
		}
		
/*		*2019 
cd 	"$ubicacion\dataset\2019\Download\684-Modulo1494\"
	cap copy "XXX-Modulo105\\CAP_600_URBANO_7.sav" "$Inicial\\CAP_600_2019.sav"

		*2020
				
cd 	"$ubicacion\dataset\2020\Download\"
	cap copy "736-Modulo1622\736-Modulo1622\\CAP_600_URBANO_7.sav" "$Inicial\\CAP_600_2020.sav"
	
	cap copy "736-Modulo1618\736-Modulo1618\\CAP_100_URBANO_RURAL_3.sav" "$Inicial\\CAP_100_2020.sav"

	
cd "$ubicacion\dataset\2016\Download\544-Modulo1076\XXX-Modulo104\"
		cap copy "CAP_500_URBANO_RURAL.sav" "$Inicial\\CAP_500_2016.sav"
			*/
