DROP TABLE IF EXISTS parks_subdivided;
DROP TABLE IF EXISTS _PARKS;
DROP TABLE IF EXISTS PARKS;

CREATE TEMP TABLE tmp (
    type text,
    geom text
);

\COPY tmp FROM PSTDIN DELIMITER ',' CSV HEADER;

CREATE TABLE parks_subdivided AS(
    SELECT 
        ST_SubDivide(ST_MakeValid(ST_GeometryFromText(geom, 4326)), 100) as geom  
    FROM tmp
);
CREATE INDEX "parks_subdivided_geom_idx" ON parks_subdivided USING GIST (geom gist_geometry_ops_2d);
CREATE INDEX "bctcb_pop_2010_geom_idx" ON bctcb_pop_2010 USING GIST (geom gist_geometry_ops_2d);

SELECT 
    b.bctcb2010,
    b.cd,
    b.pop_2010,
    SUM(CASE WHEN ST_Intersects(a.geom, b.geom) THEN ST_Area(ST_Intersection(a.geom, b.geom)) ELSE 0 END) as intersect_area,
    b.area
INTO _PARKS
FROM parks_subdivided a, bctcb_pop_2010 b
GROUP BY b.bctcb2010, b.pop_2010, b.area, b.geom, b.cd;

SELECT
    cd as borocd,
    SUM(pop_2010) as pop_2010,
    SUM(intersect_area) as intersect_area,
    SUM(area) as area,
    SUM(intersect_area)/SUM(area) as prop_area_with_access,
    (CASE WHEN SUM(pop_2010) = 0 THEN NULL
        ELSE
        SUM(CASE
                WHEN pop_2010 = 0 THEN 0
                WHEN area = 0 THEN 0
                ELSE intersect_area * pop_2010 / area
            END) / SUM(pop_2010)
    END) as pct_served_parks
INTO PARKS
FROM _PARKS
GROUP BY borocd;

