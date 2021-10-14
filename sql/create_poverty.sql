DROP TABLE IF EXISTS POVERTY;
WITH boro AS (
    SELECT
        boro,
        ROUND(AVG(pov_rate_5yr_avg::numeric), 1) AS poverty_rate_boro
    FROM _poverty
    GROUP BY boro
),

nyc AS (
    SELECT
        ROUND(AVG(a.pov_rate_5yr_avg::numeric), 1) AS poverty_rate_nyc
    FROM _poverty a
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
    a.pov_rate_5yr_avg::numeric as poverty_rate,
    a.moe::numeric as moe_poverty_rate,
    b.poverty_rate_boro,
    b.poverty_rate_nyc
INTO POVERTY
FROM _poverty a
JOIN boro_nyc b
ON a.boro = b.boro;