DROP TABLE IF EXISTS _nypd_major_felonies;
CREATE TABLE _nypd_major_felonies (
    cmplnt_num text,
    latitude double precision, 
    longitude double precision
); 

\COPY _nypd_major_felonies FROM PSTDIN DELIMITER ',' CSV HEADER;

-- Spatial aggregation
DROP TABLE IF EXISTS nypd_major_felonies;
WITH 
crimes_geom as (
SELECT 
    ST_SetSRID(ST_MakePoint(longitude,latitude),4326) as geom
FROM _nypd_major_felonies
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
INTO nypd_major_felonies
FROM CD_counts a
LEFT JOIN BORO_counts b
ON a.boro = b.boro;