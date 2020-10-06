DROP TABLE IF EXISTS bctcb_pop_2010;
CREATE TEMP TABLE temp (
    bctcb2010 text,
    pop numeric
);

\COPY temp FROM PSTDIN DELIMITER ',' CSV HEADER;

SELECT
    a.bctcb2010,
    b.cd,
    a.pop as pop_2010,
    ST_Area(b.geom) as area,
    b.geom
INTO bctcb_pop_2010
FROM temp a 
LEFT JOIN cd_bctcb2010 b
ON a.bctcb2010 = b.bctcb2010;