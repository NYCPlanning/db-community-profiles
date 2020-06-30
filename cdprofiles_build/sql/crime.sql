CREATE TEMP TABLE crimes (
    cmplnt_num text,
    latitude double precision, 
    longitude double precision
); 

\COPY crimes FROM PSTDIN DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS nypd_major_felonies;
WITH 
crimes_geom as (
SELECT 
    ST_SetSRID(ST_MakePoint(longitude,latitude),4326) as geom
FROM crimes
), 
crimes_borocd as (
SELECT 
    b.borocd
FROM crimes_geom a
JOIN dcp_cdboundaries b
on st_within(a.geom, b.wkb_geometry)
)
SELECT 
    borocd, 
    count(*) as counts
INTO nypd_major_felonies
FROM crimes_borocd
GROUP BY borocd;