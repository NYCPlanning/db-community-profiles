/*
DESCRIPTION:
    Creates summary statistics for land uses by community district using PLUTO.

INPUTS:
dcp_pluto (
    cd,
    landuse,
    lotarea
)

OUTPUTS:
    lots_res_1_2_family_bldg,
    lots_res_multifamily_walkup,
    lots_res_multifamily_elevator,
    lots_mixed_use,
    lots_commercial_office,
    lots_industrial_manufacturing,
    lots_transportation_utility,
    lots_public_facility_institution,
    lots_open_space,
    lots_parking,
    lots_vacant,
    lots_other_no_data,
    lots_total,
    lot_area___res_1_2_family_bldg,
    pct_lot_area___res_1_2_family_bldg,
    lot_area___res_multifamily_walkup,
    pct_lot_area___res_multifamily_walkup,
    lot_area___res_multifamily_elevator,
    pct_lot_area___res_multifamily_elevator,
    lot_area___mixed_use,
    pct_lot_area___mixed_use,
    lot_area___commercial_office,
    pct_lot_area___commercial_office,
    lot_area___industrial_manufacturing,
    pct_lot_area___industrial_manufacturing,
    lot_area___transportation_utility,
    pct_lot_area___transportation_utility,
    lot_area___public_facility_institution,
    pct_lot_area___public_facility_institution,
    lot_area___open_space,
    pct_lot_area___open_space,
    lot_area___parking,
    pct_lot_area___parking,
    lot_area___vacant,
    pct_lot_area___vacant,
    lot_area___other_no_data,
    pct_lot_area___other_no_data,
    total_lot_area
*/
DROP TABLE IF EXISTS PLUTO_landusecount_commpro;
CREATE TABLE PLUTO_landusecount_commpro as (
SELECT   
cd,
COUNT(*) FILTER (WHERE landuse='01') AS "lots_res_1_2_family_bldg",
COUNT(*) FILTER (WHERE landuse='02') AS "lots_res_multifamily_walkup",
COUNT(*) FILTER (WHERE landuse='03') AS "lots_res_multifamily_elevator",
COUNT(*) FILTER (WHERE landuse='04') AS "lots_mixed_use",
COUNT(*) FILTER (WHERE landuse='05') AS "lots_commercial_office",
COUNT(*) FILTER (WHERE landuse='06') AS "lots_industrial_manufacturing",
COUNT(*) FILTER (WHERE landuse='07') AS "lots_transportation_utility",
COUNT(*) FILTER (WHERE landuse='08') AS "lots_public_facility_institution",
COUNT(*) FILTER (WHERE landuse='09') AS "lots_open_space",
COUNT(*) FILTER (WHERE landuse='10') AS "lots_parking",
COUNT(*) FILTER (WHERE landuse='11') AS "lots_vacant",
COUNT(*) FILTER (WHERE landuse IS NULL) AS "lots_other_no_data",
COUNT(*) AS "lots_total"
FROM dcp_pluto
GROUP BY cd);

DROP TABLE IF EXISTS PLUTO_landusearea_commpro;
CREATE TABLE PLUTO_landusearea_commpro as (
WITH sumareas as (
SELECT cd, SUM(lotarea) AS totallotarea
FROM dcp_pluto
GROUP BY cd),
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
FROM dcp_pluto."20v4"  GROUP BY cd)
SELECT a.cd,
lot_area___res_1_2_family_bldg,
round(((lot_area___res_1_2_family_bldg::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___res_1_2_family_bldg,
lot_area___res_multifamily_walkup,
round(((lot_area___res_multifamily_walkup::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___res_multifamily_walkup,
lot_area___res_multifamily_elevator,
round(((lot_area___res_multifamily_elevator::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___res_multifamily_elevator,
lot_area___mixed_use,
round(((lot_area___mixed_use::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___mixed_use,
lot_area___commercial_office,
round(((lot_area___commercial_office::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___commercial_office,
lot_area___industrial_manufacturing,
round(((lot_area___industrial_manufacturing::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___industrial_manufacturing,
lot_area___transportation_utility,
round(((lot_area___transportation_utility::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___transportation_utility,
lot_area___public_facility_institution,
round(((lot_area___public_facility_institution::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___public_facility_institution,
lot_area___open_space,
round(((lot_area___open_space::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___open_space,
lot_area___parking,
round(((lot_area___parking::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___parking,
lot_area___vacant,
round(((lot_area___vacant::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___vacant,
lot_area___other_no_data,
round(((lot_area___other_no_data::double precision / totallotarea::double precision)*100)::numeric,2) as pct_lot_area___other_no_data,
total_lot_area
FROM landusesums a, sumareas b
WHERE a.cd = b.cd);