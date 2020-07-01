CREATE TEMP TABLE FLOODPLAIN as (
    SELECT cd,
        sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN lotarea ELSE 0 END) as fp_100_area,
        sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN numbldgs ELSE 0 END) as fp_100_bldg,
        sum(numbldgs) as cd_tot_bldgs,
        sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN unitsres ELSE 0 END) as fp_100_resunits,
        sum(unitsres) as cd_tot_resunits,
        sum(CASE WHEN (firm07_flag = '1' OR pfirm15_flag = '1') AND landuse = '09' THEN lotarea ELSE 0 END) as fp_100_openspace
    FROM dcp_pluto."20v4" a
    GROUP BY cd
    ORDER BY cd
);
\COPY FLOODPLAIN TO PSTDOUT DELIMITER ',' CSV HEADER;