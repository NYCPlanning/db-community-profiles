DROP TABLE IF EXISTS PARKS;

CREATE TEMP TABLE tmp (
    census_geoid text,
    per_access numeric
);

\COPY tmp FROM PSTDIN DELIMITER ',' CSV HEADER;

SELECT 
    census_geoid as borocd,
    per_access as pct_served_parks
INTO PARKS
FROM tmp;