DROP TABLE IF EXISTS PLUTO_landusecount;
CREATE TABLE PLUTO_landusecount as (
SELECT   
    cd as borocd,
    COUNT(*) FILTER (WHERE landuse='01') AS lots_res_1_2_family_bldg,
    COUNT(*) FILTER (WHERE landuse='02') AS lots_res_multifamily_walkup,
    COUNT(*) FILTER (WHERE landuse='03') AS lots_res_multifamily_elevator,
    COUNT(*) FILTER (WHERE landuse='04') AS lots_mixed_use,
    COUNT(*) FILTER (WHERE landuse='05') AS lots_commercial_office,
    COUNT(*) FILTER (WHERE landuse='06') AS lots_industrial_manufacturing,
    COUNT(*) FILTER (WHERE landuse='07') AS lots_transportation_utility,
    COUNT(*) FILTER (WHERE landuse='08') AS lots_public_facility_institution,
    COUNT(*) FILTER (WHERE landuse='09') AS lots_open_space,
    COUNT(*) FILTER (WHERE landuse='10') AS lots_parking,
    COUNT(*) FILTER (WHERE landuse='11') AS lots_vacant,
    COUNT(*) FILTER (WHERE landuse IS NULL) AS lots_other_no_data,
    COUNT(*) AS lots_total
FROM dcp_mappluto
GROUP BY cd);