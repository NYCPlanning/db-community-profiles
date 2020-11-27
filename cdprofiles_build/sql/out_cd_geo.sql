CREATE TEMP TABLE cd_geo as (
    SELECT 
        borocd,
        ST_Area(wkb_geometry::geography) / 4046.8564224 as acres,
        ST_Area(wkb_geometry::geography) / 1609.34^2 as area_sqmi,
        wkb_geometry
    FROM dcp_cdboundaries.latest
);

\COPY cd_geo TO PSTDOUT DELIMITER ',' CSV HEADER;