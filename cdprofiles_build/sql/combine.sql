WITH
JOIN_ACS AS (
	SELECT
        b.borocd,
		b.puma,
        a.female_50_54,
        a.moe_under18_rate_nyc,
        a.moe_under18_rate_boro,
        a.pop_acs,
        a.pct_hispanic,
        a.pct_asian_nh,
        a.pct_black_nh,
        a.pct_white_nh,
        a.female_85_over,
        a.male_85_over,
        a.female_80_84,
        a.male_80_84,
        a.female_75_79,
        a.male_75_79,
        a.female_70_74,
        a.male_70_74,
        a.female_65_69,
        a.male_65_69,
        a.female_60_64,
        a.male_60_64,
        a.female_55_59,
        a.male_55_59,
        a.male_50_54,
        a.female_45_49,
        a.male_45_49,
        a.female_40_44,
        a.male_40_44,
        a.female_35_39,
        a.male_35_39,
        a.female_30_34,
        a.male_30_34,
        a.female_25_29,
        a.male_25_29,
        a.female_20_24,
        a.male_20_24,
        a.female_15_19,
        a.male_15_19,
        a.female_10_14,
        a.male_10_14,
        a.female_5_9,
        a.male_5_9,
        a.female_under_5,
        a.male_under_5,
        a.moe_over65_rate_nyc,
        a.over65_rate_nyc,
        a.moe_over65_rate_boro,
        a.over65_rate_boro,
        a.moe_over65_rate,
        a.over65_rate,
        a.under18_rate_nyc,
        a.under18_rate_boro,
        a.moe_under18_rate,
        a.under18_rate,
        a.moe_lep_rate_nyc,
        a.lep_rate_nyc,
        a.moe_lep_rate_boro,
        a.lep_rate_boro,
        a.moe_lep_rate,
        a.lep_rate,
        a.moe_foreign_born,
        a.pct_foreign_born,
        a.moe_hh_rent_burd_nyc,
        a.pct_hh_rent_burd_nyc,
        a.moe_hh_rent_burd_boro,
        a.pct_hh_rent_burd_boro,
        a.moe_hh_rent_burd,
        a.pct_hh_rent_burd,
        a.moe_mean_commute_nyc,
        a.mean_commute_nyc,
        a.moe_mean_commute_boro,
        a.mean_commute_boro,
        a.moe_mean_commute,
        a.mean_commute,
        a.moe_unemployment_nyc,
        a.unemployment_nyc,
        a.moe_unemployment_boro,
        a.unemployment_boro,
        a.moe_unemployment,
        a.unemployment,
        a.moe_bach_deg_nyc,
        a.pct_bach_deg_nyc,
        a.moe_bach_deg_boro,
        a.pct_bach_deg_boro,
        a.moe_bach_deg,
        a.pct_bach_deg,
        a.pct_other_nh
    FROM cd_puma b
    LEFT JOIN acs a
    ON a.borocd = b.borocd
),
JOIN_CRIME AS (
    SELECT
        a.*,
        b.crime_count,
        b.crime_count_boro,
        b.crime_count_nyc
    FROM JOIN_ACS a
    LEFT JOIN nypd_major_felonies b
    ON a.borocd = b.borocd
),
JOIN_pluto_landusearea AS (
    SELECT
        a.*,
        b.lot_area___res_1_2_family_bldg,
        b.pct_lot_area___res_1_2_family_bldg,
        b.lot_area___res_multifamily_walkup,
        b.pct_lot_area___res_multifamily_walkup,
        b.lot_area___res_multifamily_elevator,
        b.pct_lot_area___res_multifamily_elevator,
        b.lot_area___mixed_use,
        b.pct_lot_area___mixed_use,
        b.lot_area___commercial_office,
        b.pct_lot_area___commercial_office,
        b.lot_area___industrial_manufacturing,
        b.pct_lot_area___industrial_manufacturing,
        b.lot_area___transportation_utility,
        b.pct_lot_area___transportation_utility,
        b.lot_area___public_facility_institution,
        b.pct_lot_area___public_facility_institution,
        b.lot_area___open_space,
        b.pct_lot_area___open_space,
        b.lot_area___parking,
        b.pct_lot_area___parking,
        b.lot_area___vacant,
        b.pct_lot_area___vacant,
        b.lot_area___other_no_data,
        b.pct_lot_area___other_no_data,
        b.total_lot_area
    FROM JOIN_CRIME a
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
        b.fp_100_openspace
    FROM JOIN_facdb a
    LEFT JOIN floodplain b
    ON a.borocd = b.borocd
)
SELECT * FROM JOIN_floodplain;