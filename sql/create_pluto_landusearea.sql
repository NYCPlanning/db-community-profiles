DROP TABLE IF EXISTS PLUTO_landusearea_commpro;
CREATE TABLE PLUTO_landusearea_commpro as (
    WITH 
    sumareas as (
        SELECT cd, SUM(ST_Area(wkb_geometry::geography::geography)) AS totallotarea
        FROM dcp_mappluto
        GROUP BY cd
    ),
    landusesums as (
        SELECT
            cd,
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='01') AS "lot_area___res_1_2_family_bldg",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='02') AS "lot_area___res_multifamily_walkup",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='03') AS "lot_area___res_multifamily_elevator",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='04') AS "lot_area___mixed_use",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='05') AS "lot_area___commercial_office",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='06') AS "lot_area___industrial_manufacturing",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='07') AS "lot_area___transportation_utility",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='08') AS "lot_area___public_facility_institution",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='09') AS "lot_area___open_space",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='10') AS "lot_area___parking",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse='11') AS "lot_area___vacant",
            SUM(ST_Area(wkb_geometry::geography)) FILTER (WHERE landuse IS NULL) AS "lot_area___other_no_data",
            SUM(ST_Area(wkb_geometry::geography)) AS "total_lot_area"
        FROM dcp_mappluto  
        GROUP BY cd
    )
    SELECT 
        a.cd as borocd,
        lot_area___res_1_2_family_bldg::integer,
        round(((lot_area___res_1_2_family_bldg / totallotarea)::numeric*100),2) as pct_lot_area___res_1_2_family_bldg,
        lot_area___res_multifamily_walkup::integer,
        round(((lot_area___res_multifamily_walkup / totallotarea)::numeric*100),2) as pct_lot_area___res_multifamily_walkup,
        lot_area___res_multifamily_elevator::integer,
        round(((lot_area___res_multifamily_elevator / totallotarea)::numeric*100),2) as pct_lot_area___res_multifamily_elevator,
        lot_area___mixed_use::integer,
        round(((lot_area___mixed_use / totallotarea)::numeric*100),2) as pct_lot_area___mixed_use,
        lot_area___commercial_office::integer,
        round(((lot_area___commercial_office / totallotarea)::numeric*100),2) as pct_lot_area___commercial_office,
        lot_area___industrial_manufacturing::integer,
        round(((lot_area___industrial_manufacturing / totallotarea)::numeric*100),2) as pct_lot_area___industrial_manufacturing,
        lot_area___transportation_utility::integer,
        round(((lot_area___transportation_utility / totallotarea)::numeric*100),2) as pct_lot_area___transportation_utility,
        lot_area___public_facility_institution::integer,
        round(((lot_area___public_facility_institution / totallotarea)::numeric*100),2) as pct_lot_area___public_facility_institution,
        lot_area___open_space::integer,
        round(((lot_area___open_space / totallotarea)::numeric*100),2) as pct_lot_area___open_space,
        lot_area___parking::integer,
        round(((lot_area___parking / totallotarea)::numeric*100),2) as pct_lot_area___parking,
        lot_area___vacant::integer,
        round(((lot_area___vacant / totallotarea)::numeric*100),2) as pct_lot_area___vacant,
        lot_area___other_no_data::integer,
        round(((lot_area___other_no_data / totallotarea)::numeric*100),2) as pct_lot_area___other_no_data,
        total_lot_area::integer
    FROM landusesums a, sumareas b
    WHERE a.cd = b.cd
);