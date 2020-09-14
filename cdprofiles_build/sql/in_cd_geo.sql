DROP TABLE IF EXISTS cd_geo;
CREATE TABLE cd_geoms (
    borocd text,
    acres numeric,
    area_sqmi numeric,
    wkb_geometry geometry(Geometry,4326)
);

\COPY cd_geo FROM PSTDIN DELIMITER ',' CSV HEADER;