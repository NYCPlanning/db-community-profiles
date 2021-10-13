DROP TABLE IF EXISTS acs;
WITH
cdta AS (
    SELECT
    *,
    'NYC' as city,
    census_geoid as cdta2020,
    (CASE 
        WHEN LEFT(census_geoid, 2) = 'MN' THEN 'Manhattan'
        WHEN LEFT(census_geoid, 2) = 'BX' THEN 'Bronx'
        WHEN LEFT(census_geoid, 2) = 'BK' THEN 'Brooklyn'
        WHEN LEFT(census_geoid, 2) = 'QN' THEN 'Queens'
        WHEN LEFT(census_geoid, 2) = 'SI' THEN 'Staten Island'
    END) as borough
    FROM _acs
    WHERE census_geoid NOT IN ('36061', '36005', '36047', '36081', '36085')
),
boro AS (
    SELECT 
    *,
    (CASE 
        WHEN census_geoid = '36061' THEN 'Manhattan'
        WHEN census_geoid = '36005' THEN 'Bronx'
        WHEN census_geoid = '36047' THEN 'Brooklyn'
        WHEN census_geoid = '36081' THEN 'Queens'
        WHEN census_geoid = '36085' THEN 'Staten Island'
    END) as borough
    FROM _acs
    WHERE census_geoid IN ('36061', '36005', '36047', '36081', '36085')
),
city AS (
    SELECT 
    *,
    'NYC' as city
    FROM _acs
    WHERE census_geoid = '3651000'
),
cd_boro AS (
    SELECT
        a.city,
        a.cdta2020, 
        a.borough,
        a.pct_white_nh,
        a.pct_asian_nh,
        a.pct_black_nh,
        round(
            (100 - (
                a.pct_hispanic+
                a.pct_asian_nh+
                a.pct_black_nh+
                a.pct_white_nh)
            )::numeric, 
            2
        ) as pct_other_nh,
        a.moe_unemployment,
        a.unemployment,
        a.moe_bach_deg,
        a.pct_bach_deg,
        a.moe_foreign_born,
        a.pct_foreign_born,
        a.female_under_5,
        a.female_10_14,
        a.female_15_19,
        a.female_20_24,
        a.female_25_29,
        a.female_30_34,
        a.female_35_39,
        a.female_40_44,
        a.female_45_49,
        a.female_50_54,
        a.female_55_59,
        a.female_5_9,
        a.female_60_64,
        a.female_65_69,
        a.female_70_74,
        a.female_75_79,
        a.female_80_84,
        a.female_85_over,
        a.moe_hh_rent_burd,
        a.pct_hh_rent_burd,
        a.pct_hispanic,
        a.moe_lep_rate,
        a.lep_rate,
        a.moe_mean_commute,
        a.mean_commute,
        a.male_under_5,
        a.male_10_14,
        a.male_15_19,
        a.male_20_24,
        a.male_25_29,
        a.male_30_34,
        a.male_35_39,
        a.male_40_44,
        a.male_45_49,
        a.male_50_54,
        a.male_55_59,
        a.male_5_9,
        a.male_60_64,
        a.male_65_69,
        a.male_70_74,
        a.male_75_79,
        a.male_80_84,
        a.male_85_over,
        a.moe_over65_rate,
        a.over65_rate,
        a.pop_acs,
        a.moe_under18_rate,
        a.under18_rate,
        --(a.pop_2010 - a.pop_2000) as pop_change_00_10,
        -- a.pop_2000,
        -- a.pop_2010,
        b.moe_unemployment_boro,
        b.unemployment_boro,
        b.moe_bach_deg_boro,
        b.pct_bach_deg_boro,
        b.moe_hh_rent_burd_boro,
        b.pct_hh_rent_burd_boro,
        b.moe_lep_rate_boro,
        b.lep_rate_boro,
        b.moe_mean_commute_boro,
        b.mean_commute_boro,
        b.moe_over65_rate_boro,
        b.over65_rate_boro,
        b.pop_acs_boro,
        b.moe_under18_rate_boro,
        b.under18_rate_boro
    FROM cdta a
    JOIN boro b
    ON a.borough = b.borough
),
cdta_boro_city AS (
    SELECT a.*, 
        b.moe_unemployment_nyc,
        b.unemployment_nyc,
        b.moe_bach_deg_nyc,
        b.pct_bach_deg_nyc,
        b.moe_hh_rent_burd_nyc,
        b.pct_hh_rent_burd_nyc,
        b.moe_lep_rate_nyc,
        b.lep_rate_nyc,
        b.moe_mean_commute_nyc,
        b.mean_commute_nyc,
        b.moe_over65_rate_nyc,
        b.over65_rate_nyc,
        b.pop_acs_nyc,
        b.moe_under18_rate_nyc,
        b.under18_rate_nyc
    FROM cd_boro a 
    JOIN city b
    ON a.city = b.city
)
SELECT * INTO acs FROM cdta_boro_city;
