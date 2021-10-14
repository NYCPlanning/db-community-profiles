DROP TABLE IF EXISTS cdta_geometry;
CREATE TABLE cdta_geometry as (
    SELECT 
        cdta2020,
        ST_Area(wkb_geometry::geography) / 4046.8564224 as acres,
        ST_Area(wkb_geometry::geography) / 1609.34^2 as area_sqmi,
        wkb_geometry
    FROM dcp_cdta2020
);