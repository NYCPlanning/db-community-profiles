CREATE TEMP TABLE PLUTO_landusearea_commpro as (
    WITH 
    sumareas as (
        SELECT cd, SUM(ST_Area(geom::geography::geography)) AS totallotarea
        FROM dcp_pluto.:"VERSION"
        GROUP BY cd
    ),
    landusesums as (
        SELECT
            cd,
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='01') AS "lot_area___res_1_2_family_bldg",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='02') AS "lot_area___res_multifamily_walkup",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='03') AS "lot_area___res_multifamily_elevator",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='04') AS "lot_area___mixed_use",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='05') AS "lot_area___commercial_office",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='06') AS "lot_area___industrial_manufacturing",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='07') AS "lot_area___transportation_utility",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='08') AS "lot_area___public_facility_institution",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='09') AS "lot_area___open_space",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='10') AS "lot_area___parking",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse='11') AS "lot_area___vacant",
            SUM(ST_Area(geom::geography)) FILTER (WHERE landuse IS NULL) AS "lot_area___other_no_data",
            SUM(ST_Area(geom::geography)) AS "total_lot_area"
        FROM dcp_pluto.:"VERSION"  
        GROUP BY cd
    )
    SELECT 
        a.cd as borocd,
        ROUND(lot_area___res_1_2_family_bldg) as lot_area___res_1_2_family_bldg,
        ROUND(((lot_area___res_1_2_family_bldg / totallotarea)::numeric*100),2) as pct_lot_area___res_1_2_family_bldg,
        ROUND(lot_area___res_multifamily_walkup) as lot_area___res_multifamily_walkup,
        ROUND(((lot_area___res_multifamily_walkup / totallotarea)::numeric*100),2) as pct_lot_area___res_multifamily_walkup,
        ROUND(lot_area___res_multifamily_elevator) as lot_area___res_multifamily_elevator,
        ROUND(((lot_area___res_multifamily_elevator / totallotarea)::numeric*100),2) as pct_lot_area___res_multifamily_elevator,
        ROUND(lot_area___mixed_use) as lot_area___mixed_use,
        ROUND(((lot_area___mixed_use / totallotarea)::numeric*100),2) as pct_lot_area___mixed_use,
        ROUND(lot_area___commercial_office) as lot_area___commercial_office,
        ROUND(((lot_area___commercial_office / totallotarea)::numeric*100),2) as pct_lot_area___commercial_office,
        ROUND(lot_area___industrial_manufacturing) as lot_area___industrial_manufacturing,
        ROUND(((lot_area___industrial_manufacturing / totallotarea)::numeric*100),2) as pct_lot_area___industrial_manufacturing,
        ROUND(lot_area___transportation_utility) as lot_area___transportation_utility,
        ROUND(((lot_area___transportation_utility / totallotarea)::numeric*100),2) as pct_lot_area___transportation_utility,
        ROUND(lot_area___public_facility_institution) as lot_area___public_facility_institution,
        ROUND(((lot_area___public_facility_institution / totallotarea)::numeric*100),2) as pct_lot_area___public_facility_institution,
        ROUND(lot_area___open_space) as lot_area___open_space,
        ROUND(((lot_area___open_space / totallotarea)::numeric*100),2) as pct_lot_area___open_space,
        ROUND(lot_area___parking) as lot_area___parking,
        ROUND(((lot_area___parking / totallotarea)::numeric*100),2) as pct_lot_area___parking,
        ROUND(lot_area___vacant) as lot_area___vacant,
        ROUND(((lot_area___vacant / totallotarea)::numeric*100),2) as pct_lot_area___vacant,
        ROUND(lot_area___other_no_data) as lot_area___other_no_data,
        ROUND(((lot_area___other_no_data / totallotarea)::numeric*100),2) as pct_lot_area___other_no_data,
        ROUND(total_lot_area) as total_lot_area
    FROM landusesums a, sumareas b
    WHERE a.cd = b.cd
);

\COPY PLUTO_landusearea_commpro TO PSTDOUT DELIMITER ',' CSV HEADER;