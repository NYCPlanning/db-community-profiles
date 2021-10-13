-- Spatial aggregation
DROP TABLE IF EXISTS crime;
WITH 
crimes_geom as (
    SELECT 
        ST_SetSRID(ST_MakePoint(longitude,latitude),4326) as geom
    FROM _crime
), 
crimes_cdta as (
    SELECT 
        b.cdta2020::text
    FROM crimes_geom a
    LEFT JOIN dcp_cdta2020 b
    ON st_within(a.geom, b.wkb_geometry)
),
CDTA_counts as (
    SELECT 
        cdta2020, 
        LEFT(cdta2020, 2) as boro,
        count(*) as crime_count
    FROM crimes_cdta
    GROUP BY cdta2020
),
BORO_counts as (
    SELECT 
        boro, 
        sum(crime_count) as crime_count_boro
    FROM CDTA_counts
    GROUP BY boro
)
SELECT
    a.cdta2020,
    a.crime_count,
    b.crime_count_boro,
    (select count(*) from crimes_geom) as crime_count_nyc
INTO crime
FROM CDTA_counts a
LEFT JOIN BORO_counts b
ON a.boro = b.boro;