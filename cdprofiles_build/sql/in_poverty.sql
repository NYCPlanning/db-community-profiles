DROP TABLE IF EXISTS POVERTY;
CREATE TEMP TABLE tmp (
    boro int,
    borocd text,
    neighborhood text,
    pov_rate_5yr_avg numeric,
    moe numeric
);

\COPY tmp FROM PSTDIN DELIMITER ',' CSV HEADER;

WITH boro AS (
    SELECT
        boro,
        ROUND(AVG(pov_rate_5yr_avg), 1) AS poverty_rate_boro
    FROM tmp
    GROUP BY boro
),

nyc AS (
    SELECT
        ROUND(AVG(a.pov_rate_5yr_avg), 1) AS poverty_rate_nyc
    FROM tmp a
),

boro_nyc AS (
    SELECT
        b.boro,
        b.poverty_rate_boro, 
        a.poverty_rate_nyc
    FROM nyc a, boro b
)

SELECT
    a.borocd,
    a.pov_rate_5yr_avg as poverty_rate,
    a.moe as moe_poverty_rate,
    b.poverty_rate_boro,
    b.poverty_rate_nyc
INTO POVERTY
FROM tmp a
JOIN boro_nyc b
ON a.boro = b.boro;