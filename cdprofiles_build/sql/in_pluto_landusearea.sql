DROP TABLE IF EXISTS PLUTO_landusearea;
CREATE TABLE PLUTO_landusearea (
    borocd text,
    lot_area_res_1_2_family_bldg numeric,
    pct_lot_area_res_1_2_family_bldg numeric,
    lot_area_res_multifamily_walkup numeric,
    pct_lot_area_res_multifamily_walkup numeric,
    lot_area_res_multifamily_elevator numeric,
    pct_lot_area_res_multifamily_elevator numeric,
    lot_area_mixed_use numeric,
    pct_lot_area_mixed_use numeric,
    lot_area_commercial_office numeric,
    pct_lot_area_commercial_office numeric,
    lot_area_industrial_manufacturing numeric,
    pct_lot_area_industrial_manufacturing numeric,
    lot_area_transportation_utility numeric,
    pct_lot_area_transportation_utility numeric,
    lot_area_public_facility_institution numeric,
    pct_lot_area_public_facility_institution numeric,
    lot_area_open_space numeric,
    pct_lot_area_open_space numeric,
    lot_area_parking numeric,
    pct_lot_area_parking numeric,
    lot_area_vacant numeric,
    pct_lot_area_vacant numeric,
    lot_area_other_no_data numeric,
    pct_lot_area_other_no_data numeric,
    total_lot_area numeric
);
\COPY PLUTO_landusearea FROM PSTDIN DELIMITER ',' CSV HEADER;