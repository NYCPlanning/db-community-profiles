DROP TABLE IF EXISTS combined CASCADE;
WITH
JOIN_CRIME AS (
    SELECT
        a.*,
        b.crime_count,
        b.crime_count_boro,
        b.crime_count_nyc,
        round(b.crime_count*1000/a.pop_acs::numeric,1) as crime_per_1000,
        round(b.crime_count_boro*1000/a.pop_acs_boro::numeric,1) as crime_per_1000_boro,
        round(b.crime_count_nyc*1000/a.pop_acs_nyc::numeric,1) as crime_per_1000_nyc
    FROM acs a
    LEFT JOIN crime b
    ON a.borocd = b.borocd
),
JOIN_sanitation AS(
    SELECT
        a.*,
        b.pct_clean_strts,
        b.pct_clean_strts_boro,
        b.pct_clean_strts_nyc
    FROM JOIN_CRIME a
    LEFT JOIN sanitation b
    ON a.borocd = b.borocd
),
JOIN_pluto_landusearea AS (
    SELECT
        a.*,
        b.lot_area_res_1_2_family_bldg,
        b.pct_lot_area_res_1_2_family_bldg,
        b.lot_area_res_multifamily_walkup,
        b.pct_lot_area_res_multifamily_walkup,
        b.lot_area_res_multifamily_elevator,
        b.pct_lot_area_res_multifamily_elevator,
        b.lot_area_mixed_use,
        b.pct_lot_area_mixed_use,
        b.lot_area_commercial_office,
        b.pct_lot_area_commercial_office,
        b.lot_area_industrial_manufacturing,
        b.pct_lot_area_industrial_manufacturing,
        b.lot_area_transportation_utility,
        b.pct_lot_area_transportation_utility,
        b.lot_area_public_facility_institution,
        b.pct_lot_area_public_facility_institution,
        b.lot_area_open_space,
        b.pct_lot_area_open_space,
        b.lot_area_parking,
        b.pct_lot_area_parking,
        b.lot_area_vacant,
        b.pct_lot_area_vacant,
        b.lot_area_other_no_data,
        b.pct_lot_area_other_no_data,
        b.total_lot_area
    FROM JOIN_sanitation a
    LEFT JOIN pluto_landusearea b
    ON a.borocd = b.borocd
),
JOIN_pluto_landusecount AS (
    SELECT
        a.*,
        b.lots_res_1_2_family_bldg,
        b.lots_res_multifamily_walkup,
        b.lots_res_multifamily_elevator,
        b.lots_mixed_use,
        b.lots_commercial_office,
        b.lots_industrial_manufacturing,
        b.lots_transportation_utility,
        b.lots_public_facility_institution,
        b.lots_open_space,
        b.lots_parking,
        b.lots_vacant,
        b.lots_other_no_data,
        b.lots_total
    FROM JOIN_pluto_landusearea a
    LEFT JOIN pluto_landusecount b
    ON a.borocd = b.borocd
),
JOIN_facdb as (
    SELECT
        a.*,
        b.count_parks,
        b.count_hosp_clinic,
        b.count_libraries,
        b.count_public_schools
    FROM JOIN_pluto_landusecount a
    LEFT JOIN facdb b
    ON a.borocd = b.borocd
),
JOIN_floodplain as (
    SELECT
        a.*,
        b.fp_100_area,
        b.fp_100_bldg,
        b.cd_tot_bldgs,
        b.fp_100_resunits,
        b.cd_tot_resunits,
        b.fp_100_openspace,
        b.fp_500_area,
        b.fp_500_openspace
    FROM JOIN_facdb a
    LEFT JOIN floodplain b
    ON a.borocd = b.borocd
),
JOIN_floodplain_demo as (
    SELECT
        a.*,
        b.fp_100_cost_burden,
        b.fp_500_cost_burden,
        b.fp_100_cost_burden_value,
        b.fp_500_cost_burden_value,
        b.fp_100_rent_burden,
        b.fp_500_rent_burden,
        b.fp_100_rent_burden_value,
        b.fp_500_rent_burden_value,
        b.fp_100_mhhi,
        b.fp_500_mhhi,
        b.fp_100_permortg,
        b.fp_500_permortg,
        b.fp_100_mortg_value,
        b.fp_500_mortg_value,
        b.fp_100_ownerocc,
        b.fp_500_ownerocc,
        b.fp_100_ownerocc_value,
        b.fp_500_ownerocc_value,
        b.fp_100_pop,
        b.fp_500_pop
    FROM JOIN_floodplain a
    LEFT JOIN floodplain_demo b
    ON a.borocd = b.borocd
),
JOIN_geom as (
    SELECT
        a.*,
        b.acres,
        b.area_sqmi,
        b.wkb_geometry
    FROM JOIN_floodplain_demo a
    LEFT JOIN cd_geo b
    ON a.borocd = b.borocd   
),
JOIN_titles as (
    SELECT
        a.*,
        b.cd_full_title,
        b.cd_short_title
    FROM JOIN_geom a
    LEFT JOIN cd_titles b
    ON a.borocd = b.borocd
),
JOIN_cb_contact as (
    SELECT
        a.*,
        b.cb_email,
        b.cb_website
    FROM JOIN_titles a
    LEFT JOIN cb_contact b
    ON a.borocd = b.borocd
),
JOIN_parks as (
    SELECT
        a.*,
        b.pct_served_parks
    FROM JOIN_cb_contact a
    LEFT JOIN parks b
    ON a.borocd = b.borocd
),
JOIN_dcp as (
    SELECT
        a.*,
        b.neighborhoods,
        b.cd_son_fy2018,
        b.son_issue_1,
        b.son_issue_2,
        b.son_issue_3
    FROM JOIN_parks a
    LEFT JOIN cd_son b
    ON a.borocd = b.borocd
),
JOIN_tooltips as (
    SELECT
        a.*,
        b.acs_tooltip,
        b.acs_tooltip_2,
        b.acs_tooltip_3
    FROM JOIN_dcp a
    LEFT JOIN cd_tooltips b
    ON a.borocd = b.borocd
),
JOIN_poverty as (
    SELECT
        a.*,
        b.poverty_rate,
        b.moe_poverty_rate,
        b.poverty_rate_boro,
        b.poverty_rate_nyc
    FROM JOIN_tooltips a 
    LEFT JOIN poverty b 
    ON a.borocd = b.borocd
)

SELECT 
    *,
    :'V_PLUTO' as v_pluto,
    :'V_ACS' as v_acs,
    :'V_DECENNIAL' as v_decennial,
    :'V_FACDB' as v_facdb,
    :'V_CRIME' as v_crime,
    :'V_SANITATION' as v_sanitation,
    :'V_GEO' as v_geo,
    :'V_PARKS' as v_parks,
    :'V_POVERTY' as v_poverty
INTO combined
FROM JOIN_poverty;

ALTER TABLE combined
DROP COLUMN pop_acs_boro,
DROP COLUMN pop_acs_nyc;

--\COPY combined TO PSTDOUT DELIMITER ',' CSV HEADER;
