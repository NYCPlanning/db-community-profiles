DROP TABLE IF EXISTS _crime;
CREATE TABLE _crime (
    cmplnt_num text,
    cmplnt_fr_dt text,
    cmplnt_fr_tm text,
    cmplnt_to_dt text,
    cmplnt_to_tm text,
    addr_pct_cd text,
    rpt_dt text,
    ky_cd text,
    ofns_desc text,
    pd_cd text,
    pd_desc text,
    crm_atpt_cptd_cd text,
    law_cat_cd text,
    boro_nm text,
    loc_of_occur_desc text,
    prem_typ_desc text,
    juris_desc text,
    jurisdiction_code text,
    parks_nm text,
    hadevelopt text,
    housing_psa text,
    x_coord_cd text,
    y_coord_cd text,
    susp_age_group text,
    susp_race text,
    susp_sex text,
    transit_district text,
    latitude double precision, 
    longitude double precision,
    lat_lon text,
    patrol_boro text,
    station_name text,
    vic_age_group text,
    vic_race text,
    vic_sex text
); 

\COPY _crime FROM PSTDIN DELIMITER ',' CSV HEADER;

-- Spatial aggregation
DROP TABLE IF EXISTS crime;
WITH 
crimes_geom as (
SELECT 
    ST_SetSRID(ST_MakePoint(longitude,latitude),4326) as geom
FROM _crime
), 
crimes_borocd as (
SELECT 
    b.borocd::text
FROM crimes_geom a
JOIN dcp_cdboundaries b
on st_within(a.geom, b.wkb_geometry)
),
CD_counts as (
SELECT 
    borocd, 
    LEFT(borocd, 1) as boro,
    count(*) as crime_count
FROM crimes_borocd
GROUP BY borocd
),
BORO_counts as (
SELECT 
    boro, 
    sum(crime_count) as crime_count_boro
FROM CD_counts
GROUP BY boro
)
SELECT
    a.borocd,
    a.crime_count,
    b.crime_count_boro,
    (select count(*) from crimes_geom) as crime_count_nyc
INTO crime
FROM CD_counts a
LEFT JOIN BORO_counts b
ON a.boro = b.boro;