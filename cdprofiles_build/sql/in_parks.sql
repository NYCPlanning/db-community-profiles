DROP TABLE IF EXISTS PARKS;
CREATE TEMP TABLE tmp (
    type text,
    geom geometry(Geometry,4326)
);

\COPY tmp FROM PSTDIN DELIMITER ',' CSV HEADER;

SELECT
b.borocd,
(CASE
    WHEN ST_OVERLAPS(a.geom, b.wkb_geometry) THEN 
        ST_AREA(ST_INTERSECTION(a.geom, b.wkb_geometry)) / ST_AREA(b.wkb_geometry)
    ELSE 0
END) as pct_served_parks
INTO PARKS
FROM tmp a, cd_geo b;

