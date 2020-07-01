CREATE TEMP TABLE PLUTO_landusearea_commpro as (
    WITH 
    sumareas as (
        SELECT cd, SUM(lotarea) AS totallotarea
        FROM dcp_pluto."20v4"
        GROUP BY cd
    ),
    landusesums as (
        SELECT
            cd,
            SUM(lotarea) FILTER (WHERE landuse='01') AS "lot_area___res_1_2_family_bldg",
            SUM(lotarea) FILTER (WHERE landuse='02') AS "lot_area___res_multifamily_walkup",
            SUM(lotarea) FILTER (WHERE landuse='03') AS "lot_area___res_multifamily_elevator",
            SUM(lotarea) FILTER (WHERE landuse='04') AS "lot_area___mixed_use",
            SUM(lotarea) FILTER (WHERE landuse='05') AS "lot_area___commercial_office",
            SUM(lotarea) FILTER (WHERE landuse='06') AS "lot_area___industrial_manufacturing",
            SUM(lotarea) FILTER (WHERE landuse='07') AS "lot_area___transportation_utility",
            SUM(lotarea) FILTER (WHERE landuse='08') AS "lot_area___public_facility_institution",
            SUM(lotarea) FILTER (WHERE landuse='09') AS "lot_area___open_space",
            SUM(lotarea) FILTER (WHERE landuse='10') AS "lot_area___parking",
            SUM(lotarea) FILTER (WHERE landuse='11') AS "lot_area___vacant",
            SUM(lotarea) FILTER (WHERE landuse IS NULL) AS "lot_area___other_no_data",
            SUM(lotarea) AS "total_lot_area"
        FROM dcp_pluto."20v4"  
        GROUP BY cd
    )
    SELECT 
        a.cd as borocd,
        lot_area___res_1_2_family_bldg,
        round(((lot_area___res_1_2_family_bldg / totallotarea)*100),2) as pct_lot_area___res_1_2_family_bldg,
        lot_area___res_multifamily_walkup,
        round(((lot_area___res_multifamily_walkup / totallotarea)*100),2) as pct_lot_area___res_multifamily_walkup,
        lot_area___res_multifamily_elevator,
        round(((lot_area___res_multifamily_elevator / totallotarea)*100),2) as pct_lot_area___res_multifamily_elevator,
        lot_area___mixed_use,
        round(((lot_area___mixed_use / totallotarea)*100),2) as pct_lot_area___mixed_use,
        lot_area___commercial_office,
        round(((lot_area___commercial_office / totallotarea)*100),2) as pct_lot_area___commercial_office,
        lot_area___industrial_manufacturing,
        round(((lot_area___industrial_manufacturing / totallotarea)*100),2) as pct_lot_area___industrial_manufacturing,
        lot_area___transportation_utility,
        round(((lot_area___transportation_utility / totallotarea)*100),2) as pct_lot_area___transportation_utility,
        lot_area___public_facility_institution,
        round(((lot_area___public_facility_institution / totallotarea)*100),2) as pct_lot_area___public_facility_institution,
        lot_area___open_space,
        round(((lot_area___open_space / totallotarea)*100),2) as pct_lot_area___open_space,
        lot_area___parking,
        round(((lot_area___parking / totallotarea)*100),2) as pct_lot_area___parking,
        lot_area___vacant,
        round(((lot_area___vacant / totallotarea)*100),2) as pct_lot_area___vacant,
        lot_area___other_no_data,
        round(((lot_area___other_no_data / totallotarea)*100),2) as pct_lot_area___other_no_data,
        total_lot_area
    FROM landusesums a, sumareas b
    WHERE a.cd = b.cd
);

\COPY PLUTO_landusearea_commpro TO PSTDOUT DELIMITER ',' CSV HEADER;