CREATE TEMP TABLE PLUTO_landusearea_commpro as (
    WITH 
    sumareas as (
        SELECT cd, SUM(ST_Area(geom::geography)) AS totallotarea
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
        round(lot_area___res_1_2_family_bldg::numeric, 2),
        round(((lot_area___res_1_2_family_bldg / totallotarea)::numeric*100),2) as pct_lot_area___res_1_2_family_bldg,
        round(lot_area___res_multifamily_walkup::numeric, 2),
        round(((lot_area___res_multifamily_walkup / totallotarea)::numeric*100),2) as pct_lot_area___res_multifamily_walkup,
        round(lot_area___res_multifamily_elevator::numeric, 2),
        round(((lot_area___res_multifamily_elevator / totallotarea)::numeric*100),2) as pct_lot_area___res_multifamily_elevator,
        round(lot_area___mixed_use::numeric, 2),
        round(((lot_area___mixed_use / totallotarea)::numeric*100),2) as pct_lot_area___mixed_use,
        round(lot_area___commercial_office::numeric, 2),
        round(((lot_area___commercial_office / totallotarea)::numeric*100),2) as pct_lot_area___commercial_office,
        round(lot_area___industrial_manufacturing::numeric, 2),
        round(((lot_area___industrial_manufacturing / totallotarea)::numeric*100),2) as pct_lot_area___industrial_manufacturing,
        round(lot_area___transportation_utility::numeric, 2),
        round(((lot_area___transportation_utility / totallotarea)::numeric*100),2) as pct_lot_area___transportation_utility,
        round(lot_area___public_facility_institution::numeric, 2),
        round(((lot_area___public_facility_institution / totallotarea)::numeric*100),2) as pct_lot_area___public_facility_institution,
        round(lot_area___open_space::numeric, 2),
        round(((lot_area___open_space / totallotarea)::numeric*100),2) as pct_lot_area___open_space,
        round(lot_area___parking::numeric, 2),
        round(((lot_area___parking / totallotarea)::numeric*100),2) as pct_lot_area___parking,
        round(lot_area___vacant::numeric, 2),
        round(((lot_area___vacant / totallotarea)::numeric*100),2) as pct_lot_area___vacant,
        round(lot_area___other_no_data::numeric, 2),
        round(((lot_area___other_no_data / totallotarea)::numeric*100),2) as pct_lot_area___other_no_data,
        round(total_lot_area::numeric, 2)
    FROM landusesums a, sumareas b
    WHERE a.cd = b.cd
);

\COPY PLUTO_landusearea_commpro TO PSTDOUT DELIMITER ',' CSV HEADER;