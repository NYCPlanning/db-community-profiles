CREATE VIEW cd_demo_age_gender AS (
    SELECT 
        cd_full_title as cd_name,
        borocd as cd_number,
        borough,
        pop_2000,
        pop_2010,
        pop_acs as pop_estimate_acs,
        pop_change_00_10,
        female_under_5 as pop_pct_female_under_5,
        female_5_9 as pop_pct_female_5_9,
        female_10_14 as pop_pct_female_10_14,
        female_15_19 as pop_pct_female_15_19,
        female_20_24 as pop_pct_female_20_24,
        female_25_29 as pop_pct_female_25_29,
        female_30_34 as pop_pct_female_30_34,
        female_35_39 as pop_pct_female_35_39,
        female_40_44 as pop_pct_female_40_44,
        female_45_49 as pop_pct_female_45_49,
        female_50_54 as pop_pct_female_50_54,
        female_55_59 as pop_pct_female_55_59,
        female_60_64 as pop_pct_female_60_64,
        female_65_69 as pop_pct_female_65_69,
        female_70_74 as pop_pct_female_70_74,
        female_75_79 as pop_pct_female_75_79,
        female_80_84 as pop_pct_female_80_84,
        female_85_over as pop_pct_female_85_over,
        male_under_5 as pop_pct_male_under_5,
        male_5_9 as pop_pct_male_5_9,
        male_10_14 as pop_pct_male_10_14,
        male_15_19 as pop_pct_male_15_19,
        male_20_24 as pop_pct_male_20_24,
        male_25_29 as pop_pct_male_25_29,
        male_30_34 as pop_pct_male_30_34,
        male_35_39 as pop_pct_male_35_39,
        male_40_44 as pop_pct_male_40_44,
        male_45_49 as pop_pct_male_45_49,
        male_50_54 as pop_pct_male_50_54,
        male_55_59 as pop_pct_male_55_59,
        male_60_64 as pop_pct_male_60_64,
        male_65_69 as pop_pct_male_65_69,
        male_70_74 as pop_pct_male_70_74,
        male_75_79 as pop_pct_male_75_79,
        male_80_84 as pop_pct_male_80_84,
        male_85_over as pop_pct_male_85_over,
        under18_rate,
        moe_under18_rate,
        over65_rate,
        moe_over65_rate
    FROM combined
);

CREATE VIEW cd_demo_race_economics AS (
    SELECT
        cd_full_title as cd_name,
        borocd as cd_number,
        borough,
        pct_foreign_born,
        moe_foreign_born,
        lep_rate,
        moe_lep_rate,
        pct_white_nh,
        pct_black_nh,
        pct_asian_nh,
        pct_other_nh,
        pct_hispanic,
        poverty_rate,
        moe_poverty_rate,
        pct_hh_rent_burd,
        moe_hh_rent_burd,
        pct_bach_deg,
        moe_bach_deg,
        unemployment,
        moe_unemployment,
        mean_commute,
        moe_mean_commute,
        crime_count,
        crime_per_1000
    FROM combined
);

CREATE VIEW cd_administrative AS (
    SELECT
        cd_full_title as cd_name,
        borocd as cd_number,
        borough,
        neighborhoods as cd_neighborhoods,
        cb_email,
        cb_website,
        son_issue_1,
        son_issue_2,
        son_issue_3
    FROM combined
);

CREATE VIEW cd_built_environment AS (
    SELECT
        cd_full_title as cd_name,
        borocd as cd_number,
        borough,
        lots_res_1_2_family_bldg,
        pct_lot_area_res_1_2_family_bldg,
        lots_res_multifamily_walkup,
        pct_lot_area_res_multifamily_walkup,
        lots_res_multifamily_elevator,
        pct_lot_area_res_multifamily_elevator,
        lots_mixed_use,
        pct_lot_area_mixed_use,
        lots_commercial_office,
        pct_lot_area_commercial_office,
        lots_industrial_manufacturing,
        pct_lot_area_industrial_manufacturing,
        lots_transportation_utility,
        pct_lot_area_transportation_utility,
        lots_public_facility_institution,
        pct_lot_area_public_facility_institution,
        lots_open_space,
        pct_lot_area_open_space,
        lots_parking,
        pct_lot_area_parking,
        lots_vacant,
        pct_lot_area_vacant,
        lots_other_no_data,
        pct_lot_area_other_no_data,
        lots_total,
        count_hosp_clinic as count_hospitals_clinics,
        count_libraries,
        count_parks,
        pct_served_parks,
        count_public_schools,
        cd_tot_bldgs as cd_total_buildings,
        cd_tot_resunits as cd_total_resunits,
        pct_clean_strts,
        area_sqmi as cd_area_sqmi,
        acres as cd_area_acres
    FROM combined
);

CREATE VIEW cd_floodplain AS (
    SELECT
        cd_full_title as cd_name,
        borocd as cd_number,
        borough,
        fp_100_area,
        fp_500_area,
        fp_100_bldg,
        fp_500_bldg,
        fp_100_cost_burden,
        fp_100_cost_burden_moe,
        fp_500_cost_burden,
        fp_500_cost_burden_moe,
        fp_100_cost_burden_value,
        fp_100_cost_burden_value_moe,
        fp_500_cost_burden_value,
        fp_500_cost_burden_value_moe,
        fp_100_mhhi,
        fp_100_mhhi_moe,
        fp_500_mhhi,
        fp_500_mhhi_moe,
        fp_100_mortg_value,
        fp_100_mortg_value_moe,
        fp_500_mortg_value,
        fp_500_mortg_value_moe,
        fp_100_openspace,
        fp_500_openspace,
        fp_100_ownerocc,
        fp_100_ownerocc_moe,
        fp_500_ownerocc,
        fp_500_ownerocc_moe,
        fp_100_ownerocc_value,
        fp_100_ownerocc_value_moe,
        fp_500_ownerocc_value,
        fp_500_ownerocc_value_moe,
        fp_100_permortg,
        fp_100_permortg_moe,
        fp_500_permortg,
        fp_500_permortg_moe,
        fp_100_pop as fp_100_pop_2010,
        fp_500_pop as fp_500_pop_2010,
        fp_100_rent_burden,
        fp_100_rent_burden_moe,
        fp_500_rent_burden,
        fp_500_rent_burden_moe,
        fp_100_rent_burden_value,
        fp_100_rent_burden_value_moe,
        fp_500_rent_burden_value,
        fp_500_rent_burden_value_moe,
        fp_100_resunits,
        fp_500_resunits
    FROM combined
);

CREATE VIEW boro_cd_attributes AS (
    SELECT DISTINCT
        borough,
        under18_rate_boro as under18_rate,
        moe_under18_rate_boro as moe_under18_rate,
        over65_rate_boro as over65_rate,
        moe_over65_rate_boro as moe_over65_rate,
        lep_rate_boro as lep_rate,
        moe_lep_rate_boro as moe_lep_rate,
        pct_hh_rent_burd_boro as pct_hh_rent_burd,
        moe_hh_rent_burd_boro as moe_hh_rent_burd,
        poverty_rate_boro as poverty_rate,
        pct_bach_deg_boro as pct_bach_deg,
        moe_bach_deg_boro as moe_bach_deg,
        unemployment_boro as unemployment,
        moe_unemployment_boro as moe_unemployment,
        mean_commute_boro as mean_commute,
        moe_mean_commute_boro as moe_mean_commute,
        pct_clean_strts_boro as pct_clean_strts,
        crime_count_boro as crime_count,
        crime_per_1000_boro as crime_per_1000
    FROM combined
);

CREATE VIEW city_cd_attributes AS (
    SELECT DISTINCT
        under18_rate_nyc as under18_rate,
        moe_under18_rate_nyc as moe_under18_rate,
        over65_rate_nyc as over65_rate,
        moe_over65_rate_nyc as moe_over65,
        lep_rate_nyc as lep_rate,
        moe_lep_rate_nyc as moe_lep_rate,
        pct_hh_rent_burd_nyc as pct_hh_rent_burd,
        moe_hh_rent_burd_nyc as moe_hh_rent_burd,
        poverty_rate_nyc as poverty_rate,
        pct_bach_deg_nyc as pct_bach_deg,
        moe_bach_deg_nyc as moe_bach_deg,
        unemployment_nyc as unemployment,
        moe_unemployment_nyc as moe_unemployment,
        mean_commute_nyc as mean_commute,
        moe_mean_commute_nyc as moe_mean_commute,
        pct_clean_strts_nyc as pct_clean_strts,
        crime_count_nyc as crime_count,
        crime_per_1000_nyc as crime_per_1000
    FROM combined
);
