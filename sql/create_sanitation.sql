DROP TABLE IF EXISTS SANITATION;
WITH 
nyc_avg as (
    SELECT AVG(acceptable_streets_pct) as nyc_avg
    FROM _SANITATION
    WHERE REPLACE(month, ' ', '') = :'VERSION'
),

boro_avg as (
    SELECT
        a.borough, 
        AVG(a.acceptable_streets_pct) as boro_avg,
        b.nyc_avg
    FROM _SANITATION a, nyc_avg b
    WHERE REPLACE(a.month, ' ', '') = :'VERSION'
    GROUP BY a.borough, b.nyc_avg
)

SELECT
    a.month,
    (CASE
        WHEN a.borough ~* 'Manhattan' THEN '1'||RIGHT(a.district, 2)
        WHEN a.borough ~* 'Bronx' THEN '2'||RIGHT(a.district, 2)
        WHEN a.borough ~* 'Brooklyn' THEN  '3'||RIGHT(a.district, 2)
        WHEN a.borough ~* 'Queens' THEN '4'||RIGHT(a.district, 2)
        WHEN a.borough ~* 'Staten Island' THEN '5'||RIGHT(a.district, 2)
    END) as borocd,
    AVG(a.acceptable_streets_pct) as pct_clean_strts,
    b.boro_avg as pct_clean_strts_boro,
    b.nyc_avg as pct_clean_strts_nyc
INTO SANITATION FROM _SANITATION a
LEFT JOIN boro_avg b ON a.borough = b.borough
WHERE REPLACE(a.month, ' ', '') = :'VERSION'
GROUP BY a.month, a.borough, a.district, b.boro_avg, b.nyc_avg;
