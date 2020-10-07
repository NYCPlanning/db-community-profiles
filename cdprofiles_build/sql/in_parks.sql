DROP TABLE IF EXISTS PARKS;
CREATE TEMP TABLE tmp (
    type text,
    geom text
);

\COPY tmp FROM PSTDIN DELIMITER ',' CSV HEADER;

WITH geom_tmp AS(
    SELECT ST_MakeValid(ST_GeometryFromText(geom, 4326)) as geom
    FROM tmp
)
SELECT
b.cd as borocd,
SUM(CASE
    WHEN b.pop_2010 = 0 THEN 0
    WHEN b.area = 0 THEN 0
    WHEN ST_CoveredBy(b.geom, a.geom) 
        THEN b.pop_2010
    WHEN NOT ST_Intersects(a.geom, b.geom) THEN 0
    ELSE 
        ST_AREA(ST_INTERSECTION(a.geom, b.geom))* b.pop_2010 / b.area
END) / SUM(b.pop_2010) as pct_served_parks
INTO PARKS
FROM geom_tmp a, bctcb_pop_2010 b
GROUP BY borocd;

