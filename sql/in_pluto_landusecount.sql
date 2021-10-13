DROP TABLE IF EXISTS PLUTO_landusecount;
CREATE TABLE PLUTO_landusecount (
    borocd text,
    lots_res_1_2_family_bldg numeric,
    lots_res_multifamily_walkup numeric,
    lots_res_multifamily_elevator numeric,
    lots_mixed_use numeric,
    lots_commercial_office numeric,
    lots_industrial_manufacturing numeric,
    lots_transportation_utility numeric,
    lots_public_facility_institution numeric,
    lots_open_space numeric,
    lots_parking numeric,
    lots_vacant numeric,
    lots_other_no_data numeric,
    lots_total numeric
);
\COPY PLUTO_landusecount FROM PSTDIN DELIMITER ',' CSV HEADER;