CREATE TEMP TABLE cd_geo as (
    SELECT 
        borocd,
        ST_Area(wkb_geometry) / 43560 as acres,
        ST_Area(wkb_geometry) / 1609.34^2 as area_sqmi,
        wkb_geometry
    FROM dcp_cdboundaries.:"VERSION"
);

\COPY cd_geo TO PSTDOUT DELIMITER ',' CSV HEADER;