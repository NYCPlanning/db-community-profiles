/*
DESCRIPTION:
    Creates summary stats of what is in the floodplain by CD. 

INPUTS:
dcp_pluto (
    cd,
    firm07_flag,
    pfirm15_flag,
    lotarea,
    numbldgs,
    unitsres,
    landuse 
)

OUTPUTS:
    fp_100_area,
    fp_100_bldg,
    cd_tot_bldgs,
    fp_100_resunits,
    cd_tot_resunits,
    fp_100_openspace
*/
DROP TABLE IF EXISTS FLOODPLAIN_commpro;
SELECT cd,
  sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN lotarea ELSE 0 END) as fp_100_area,
  sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN numbldgs ELSE 0 END) as fp_100_bldg,
  sum(numbldgs) as cd_tot_bldgs,
  sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN unitsres ELSE 0 END) as fp_100_resunits,
  sum(unitsres) as cd_tot_resunits,
  sum(CASE WHEN (firm07_flag = '1' OR pfirm15_flag = '1') AND landuse = '09' THEN lotarea ELSE 0 END) as fp_100_openspace
INTO FLOODPLAIN_commpro
FROM dcp_pluto a
GROUP BY cd
ORDER BY cd;