CREATE TEMP TABLE acs as (
    WITH 
    demo as (
        SELECT * FROM pff_demographic.:"VERSION" 
        WHERE geotype in ('PUMA2010', 'City2010', 'Boro2010')
    ),
    soci as (
        SELECT * FROM pff_social.:"VERSION" 
        WHERE geotype in ('PUMA2010', 'City2010', 'Boro2010')
    ),
    hous as (
        SELECT * FROM pff_housing.:"VERSION" 
        WHERE geotype in ('PUMA2010', 'City2010', 'Boro2010')
    ),
    econ as (
        SELECT * FROM pff_economic.:"VERSION" 
        WHERE geotype in ('PUMA2010', 'City2010', 'Boro2010')
    )
    SELECT
        a.puma,
        a.boro,
        (SELECT e FROM demo WHERE variable = 'FPop50t54' and geotype='PUMA2010' and geoid=a.puma) as female_50_54,
        (SELECT z FROM demo WHERE variable = 'PopU181' and geotype='City2010') as moe_under18_rate_nyc,
        (SELECT z FROM demo WHERE variable = 'PopU181' and geotype='Boro2010' and geoid=a.borocode) as moe_under18_rate_boro,
        (SELECT e FROM demo WHERE variable = 'Pop_1' and geotype='PUMA2010' and geoid=a.puma) as pop_acs,
        (SELECT p FROM demo WHERE variable = 'Hsp1' and geotype='PUMA2010' and geoid=a.puma) as pct_hispanic,
        (SELECT p FROM demo WHERE variable = 'AsnNH' and geotype='PUMA2010' and geoid=a.puma) as pct_asian_nh,
        (SELECT p FROM demo WHERE variable = 'BlNH' and geotype='PUMA2010' and geoid=a.puma) as pct_black_nh,
        (SELECT p FROM demo WHERE variable = 'WtNH' and geotype='PUMA2010' and geoid=a.puma) as pct_white_nh,
        (SELECT p FROM demo WHERE variable = 'FPop85pl' and geotype='PUMA2010' and geoid=a.puma) as female_85_over,
        (SELECT p FROM demo WHERE variable = 'MPop85pl' and geotype='PUMA2010' and geoid=a.puma) as male_85_over,
        (SELECT p FROM demo WHERE variable = 'FPop80t84' and geotype='PUMA2010' and geoid=a.puma) as female_80_84,
        (SELECT p FROM demo WHERE variable = 'MPop80t84' and geotype='PUMA2010' and geoid=a.puma) as male_80_84,
        (SELECT p FROM demo WHERE variable = 'FPop75t79' and geotype='PUMA2010' and geoid=a.puma) as female_75_79,
        (SELECT p FROM demo WHERE variable = 'MPop75t79' and geotype='PUMA2010' and geoid=a.puma) as male_75_79,
        (SELECT p FROM demo WHERE variable = 'FPop70t74' and geotype='PUMA2010' and geoid=a.puma) as female_70_74,
        (SELECT p FROM demo WHERE variable = 'MPop70t74' and geotype='PUMA2010' and geoid=a.puma) as male_70_74,
        (SELECT p FROM demo WHERE variable = 'FPop65t69' and geotype='PUMA2010' and geoid=a.puma) as female_65_69,
        (SELECT p FROM demo WHERE variable = 'MPop65t69' and geotype='PUMA2010' and geoid=a.puma) as male_65_69,
        (SELECT p FROM demo WHERE variable = 'FPop60t64' and geotype='PUMA2010' and geoid=a.puma) as female_60_64,
        (SELECT p FROM demo WHERE variable = 'MPop60t64' and geotype='PUMA2010' and geoid=a.puma) as male_60_64,
        (SELECT p FROM demo WHERE variable = 'FPop55t59' and geotype='PUMA2010' and geoid=a.puma) as female_55_59,
        (SELECT p FROM demo WHERE variable = 'MPop55t59' and geotype='PUMA2010' and geoid=a.puma) as male_55_59,
        (SELECT p FROM demo WHERE variable = 'MPop50t54' and geotype='PUMA2010' and geoid=a.puma) as male_50_54,
        (SELECT p FROM demo WHERE variable = 'FPop45t49' and geotype='PUMA2010' and geoid=a.puma) as female_45_49,
        (SELECT p FROM demo WHERE variable = 'MPop45t49' and geotype='PUMA2010' and geoid=a.puma) as male_45_49,
        (SELECT p FROM demo WHERE variable = 'FPop40t44' and geotype='PUMA2010' and geoid=a.puma) as female_40_44,
        (SELECT p FROM demo WHERE variable = 'MPop40t44' and geotype='PUMA2010' and geoid=a.puma) as male_40_44,
        (SELECT p FROM demo WHERE variable = 'FPop35t39' and geotype='PUMA2010' and geoid=a.puma) as female_35_39,
        (SELECT e FROM demo WHERE variable = 'MPop35t39' and geotype='PUMA2010' and geoid=a.puma) as male_35_39,
        (SELECT p FROM demo WHERE variable = 'FPop30t34' and geotype='PUMA2010' and geoid=a.puma) as female_30_34,
        (SELECT p FROM demo WHERE variable = 'MPop30t34' and geotype='PUMA2010' and geoid=a.puma) as male_30_34,
        (SELECT p FROM demo WHERE variable = 'FPop25t29' and geotype='PUMA2010' and geoid=a.puma) as female_25_29,
        (SELECT p FROM demo WHERE variable = 'MPop25t29' and geotype='PUMA2010' and geoid=a.puma) as male_25_29,
        (SELECT p FROM demo WHERE variable = 'FPop20t24' and geotype='PUMA2010' and geoid=a.puma) as female_20_24,
        (SELECT p FROM demo WHERE variable = 'MPop20t24' and geotype='PUMA2010' and geoid=a.puma) as male_20_24,
        (SELECT p FROM demo WHERE variable = 'FPop15t19' and geotype='PUMA2010' and geoid=a.puma) as female_15_19,
        (SELECT p FROM demo WHERE variable = 'MPop15t19' and geotype='PUMA2010' and geoid=a.puma) as male_15_19,
        (SELECT p FROM demo WHERE variable = 'FPop10t14' and geotype='PUMA2010' and geoid=a.puma) as female_10_14,
        (SELECT p FROM demo WHERE variable = 'MPop10t14' and geotype='PUMA2010' and geoid=a.puma) as male_10_14,
        (SELECT p FROM demo WHERE variable = 'FPop5t9' and geotype='PUMA2010' and geoid=a.puma) as female_5_9,
        (SELECT p FROM demo WHERE variable = 'MPop5t9' and geotype='PUMA2010' and geoid=a.puma) as male_5_9,
        (SELECT p FROM demo WHERE variable = 'FPop0t5' and geotype='PUMA2010' and geoid=a.puma) as female_under_5,
        (SELECT p FROM demo WHERE variable = 'MPop0t5' and geotype='PUMA2010' and geoid=a.puma) as male_under_5,
        (SELECT z FROM demo WHERE variable = 'Pop65pl1' and geotype='City2010') as moe_over65_rate_nyc,
        (SELECT p FROM demo WHERE variable = 'Pop65pl1' and geotype='City2010') as over65_rate_nyc,
        (SELECT z FROM demo WHERE variable = 'Pop65pl1' and geotype='Boro2010' and geoid=a.borocode) as moe_over65_rate_boro,
        (SELECT p FROM demo WHERE variable = 'Pop65pl1' and geotype='Boro2010' and geoid=a.borocode) as over65_rate_boro,
        (SELECT z FROM demo WHERE variable = 'Pop65pl1' and geotype='PUMA2010' and geoid=a.puma) as moe_over65_rate,
        (SELECT p FROM demo WHERE variable = 'Pop65pl1' and geotype='PUMA2010' and geoid=a.puma) as over65_rate,
        (SELECT p FROM demo WHERE variable = 'PopU181' and geotype='City2010') as under18_rate_nyc,
        (SELECT p FROM demo WHERE variable = 'PopU181' and geotype='Boro2010' and geoid=a.borocode) as under18_rate_boro,
        (SELECT z FROM demo WHERE variable = 'PopU181' and geotype='PUMA2010' and geoid=a.puma) as moe_under18_rate,
        (SELECT p FROM demo WHERE variable = 'PopU181' and geotype='PUMA2010' and geoid=a.puma) as under18_rate,
        (SELECT z FROM soci WHERE variable = 'LgOEnLEP1' and geotype='City2010') as moe_lep_rate_nyc,
        (SELECT p FROM soci WHERE variable = 'LgOEnLEP1' and geotype='City2010') as lep_rate_nyc,
        (SELECT z FROM soci WHERE variable = 'LgOEnLEP1' and geotype='Boro2010' and geoid=a.borocode) as moe_lep_rate_boro,
        (SELECT p FROM soci WHERE variable = 'LgOEnLEP1' and geotype='Boro2010' and geoid=a.borocode) as lep_rate_boro,
        (SELECT z FROM soci WHERE variable = 'LgOEnLEP1' and geotype='PUMA2010' and geoid=a.puma) as moe_lep_rate,
        (SELECT p FROM soci WHERE variable = 'LgOEnLEP1' and geotype='PUMA2010' and geoid=a.puma) as lep_rate,
        (SELECT z FROM soci WHERE variable = 'Fb1' and geotype='PUMA2010' and geoid=a.puma) as moe_foreign_born,
        (SELECT p FROM soci WHERE variable = 'Fb1' and geotype='PUMA2010' and geoid=a.puma) as pct_foreign_born,
        (SELECT z FROM hous WHERE variable = 'GRPI35pl' and geotype='City2010') as moe_hh_rent_burd_nyc,
        (SELECT p FROM hous WHERE variable = 'GRPI35pl' and geotype='City2010') as pct_hh_rent_burd_nyc,
        (SELECT z FROM hous WHERE variable = 'GRPI35pl' and geotype='Boro2010' and geoid=a.borocode) as moe_hh_rent_burd_boro,
        (SELECT p FROM hous WHERE variable = 'GRPI35pl' and geotype='Boro2010' and geoid=a.borocode) as pct_hh_rent_burd_boro,
        (SELECT z FROM hous WHERE variable = 'GRPI35pl' and geotype='PUMA2010' and geoid=a.puma) as moe_hh_rent_burd,
        (SELECT p FROM hous WHERE variable = 'GRPI35pl' and geotype='PUMA2010' and geoid=a.puma) as pct_hh_rent_burd,
        (SELECT m FROM econ WHERE variable = 'MnTrvTm' and geotype='City2010') as moe_mean_commute_nyc,
        (SELECT e FROM econ WHERE variable = 'MnTrvTm' and geotype='City2010') as mean_commute_nyc,
        (SELECT m FROM econ WHERE variable = 'MnTrvTm' and geotype='Boro2010' and geoid=a.borocode) as moe_mean_commute_boro,
        (SELECT e FROM econ WHERE variable = 'MnTrvTm' and geotype='Boro2010' and geoid=a.borocode) as mean_commute_boro,
        (SELECT m FROM econ WHERE variable = 'MnTrvTm' and geotype='PUMA2010' and geoid=a.puma) as moe_mean_commute,
        (SELECT e FROM econ WHERE variable = 'MnTrvTm' and geotype='PUMA2010' and geoid=a.puma) as mean_commute,
        (SELECT z FROM econ WHERE variable = 'CvLFUEm1' and geotype='City2010') as moe_unemployment_nyc,
        (SELECT p FROM econ WHERE variable = 'CvLFUEm1' and geotype='City2010') as unemployment_nyc,
        (SELECT z FROM econ WHERE variable = 'CvLFUEm1' and geotype='Boro2010' and geoid=a.borocode) as moe_unemployment_boro,
        (SELECT p FROM econ WHERE variable = 'CvLFUEm1' and geotype='Boro2010' and geoid=a.borocode) as unemployment_boro,
        (SELECT z FROM econ WHERE variable = 'CvLFUEm1' and geotype='PUMA2010' and geoid=a.puma) as moe_unemployment,
        (SELECT p FROM econ WHERE variable = 'CvLFUEm1' and geotype='PUMA2010' and geoid=a.puma) as unemployment,
        (SELECT z FROM soci WHERE variable = 'EA_BchDH' and geotype='City2010') as moe_bach_deg_nyc,
        (SELECT p FROM soci WHERE variable = 'EA_BchDH' and geotype='City2010') as pct_bach_deg_nyc,
        (SELECT z FROM soci WHERE variable = 'EA_BchDH' and geotype='Boro2010' and geoid=a.borocode) as moe_bach_deg_boro,
        (SELECT p FROM soci WHERE variable = 'EA_BchDH' and geotype='Boro2010' and geoid=a.borocode) as pct_bach_deg_boro,
        (SELECT z FROM soci WHERE variable = 'EA_BchDH' and geotype='PUMA2010' and geoid=a.puma) as moe_bach_deg,
        (SELECT p FROM soci WHERE variable = 'EA_BchDH' and geotype='PUMA2010' and geoid=a.puma) as pct_bach_deg
    FROM (
        SELECT distinct 
            geoid as puma,
            (CASE 
                WHEN geogname ~* 'Brooklyn' then 'Brooklyn'
                WHEN geogname ~* 'Manhattan' then 'Manhattan'
            	WHEN geogname ~* 'Staten Island' then 'Staten Island'
                WHEN geogname ~* 'Queens' then 'Queens'
                WHEN geogname ~* 'Bronx' then 'Bronx'
            END) as boro,
            (CASE 
                WHEN geogname ~* 'Brooklyn' then '3'
                WHEN geogname ~* 'Manhattan' then '1'
            	WHEN geogname ~* 'Staten Island' then '5'
                WHEN geogname ~* 'Queens' then '4'
                WHEN geogname ~* 'Bronx' then '2'
            END) as borocode
        FROM demo
        WHERE geotype='PUMA2010'
    ) a
);

\COPY acs TO PSTDOUT DELIMITER ',' CSV HEADER;
