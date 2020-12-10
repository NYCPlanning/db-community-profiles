DROP TABLE IF EXISTS _acs;
CREATE TABLE _acs (
    borocd text,
    pct_white_nh double precision,
    pct_asian_nh double precision,
    pct_black_nh double precision,
    moe_unemployment_boro double precision,
    unemployment_boro double precision,
    moe_unemployment double precision,
    unemployment double precision,
    moe_unemployment_nyc double precision,
    unemployment_nyc double precision,
    moe_bach_deg_boro double precision,
    pct_bach_deg_boro double precision,
    moe_bach_deg double precision,
    pct_bach_deg double precision,
    moe_bach_deg_nyc double precision,
    pct_bach_deg_nyc double precision,
    moe_foreign_born double precision,
    pct_foreign_born double precision,
    female_under_5 double precision,
    female_10_14 double precision,
    female_15_19 double precision,
    female_20_24 double precision,
    female_25_29 double precision,
    female_30_34 double precision,
    female_35_39 double precision,
    female_40_44 double precision,
    female_45_49 double precision,
    female_50_54 double precision,
    female_55_59 double precision,
    female_5_9 double precision,
    female_60_64 double precision,
    female_65_69 double precision,
    female_70_74 double precision,
    female_75_79 double precision,
    female_80_84 double precision,
    female_85_over double precision,
    moe_hh_rent_burd_boro double precision,
    pct_hh_rent_burd_boro double precision,
    moe_hh_rent_burd double precision,
    pct_hh_rent_burd double precision,
    moe_hh_rent_burd_nyc double precision,
    pct_hh_rent_burd_nyc double precision,
    pct_hispanic double precision,
    moe_lep_rate_boro double precision,
    lep_rate_boro double precision,
    moe_lep_rate double precision,
    lep_rate double precision,
    moe_lep_rate_nyc double precision,
    lep_rate_nyc double precision,
    moe_mean_commute_boro double precision,
    mean_commute_boro double precision,
    moe_mean_commute double precision,
    mean_commute double precision,
    moe_mean_commute_nyc double precision,
    mean_commute_nyc double precision,
    male_under_5 double precision,
    male_10_14 double precision,
    male_15_19 double precision,
    male_20_24 double precision,
    male_25_29 double precision,
    male_30_34 double precision,
    male_35_39 double precision,
    male_40_44 double precision,
    male_45_49 double precision,
    male_50_54 double precision,
    male_55_59 double precision,
    male_5_9 double precision,
    male_60_64 double precision,
    male_65_69 double precision,
    male_70_74 double precision,
    male_75_79 double precision,
    male_80_84 double precision,
    male_85_over double precision,
    moe_over65_rate_boro double precision,
    over65_rate_boro double precision,
    moe_over65_rate double precision,
    over65_rate double precision,
    moe_over65_rate_nyc double precision,
    over65_rate_nyc double precision,
    pop_acs_boro double precision,
    pop_acs double precision,
    pop_acs_nyc double precision,
    moe_under18_rate_boro double precision,
    under18_rate_boro double precision,
    moe_under18_rate double precision,
    under18_rate double precision,
    moe_under18_rate_nyc double precision,
    under18_rate_nyc double precision,
    pop_2010 double precision
    --pop_2000 double precision
);

\COPY _acs FROM PSTDIN DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS acs;
SELECT
    *,
    (CASE 
        WHEN LEFT(borocd, 1) = '1' THEN 'Manhattan'
        WHEN LEFT(borocd, 1) = '2' THEN 'Bronx'
        WHEN LEFT(borocd, 1) = '3' THEN 'Brooklyn'
        WHEN LEFT(borocd, 1) = '4' THEN 'Queens'
        WHEN LEFT(borocd, 1) = '5' THEN 'Staten Island'
    END) as borough,
    round(
        (100 - (
            pct_hispanic+
            pct_asian_nh+
            pct_black_nh+
            pct_white_nh)
        )::numeric, 
        2
    ) as pct_other_nh
    --(pop_2010 - pop_2000) as pop_change_00_10
INTO acs
FROM _acs;
