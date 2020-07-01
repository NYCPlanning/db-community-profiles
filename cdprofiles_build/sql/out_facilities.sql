CREATE TEMP TABLE facdb as (
    SELECT 
        commboard as borocd,
        sum(CASE WHEN facsubgrp = 'PARKS' THEN 1 ELSE 0 END) count_parks,
        sum(CASE WHEN facsubgrp = 'HOSPITALS AND CLINICS' THEN 1 ELSE 0 END) count_hosp_clinic,
        sum(CASE WHEN facsubgrp = 'PUBLIC LIBRARIES' THEN 1 ELSE 0 END) count_libraries,
        sum(CASE WHEN facsubgrp = 'PUBLIC K-12 SCHOOLS' THEN 1 ELSE 0 END) count_public_schools
    FROM facilities.latest
    GROUP BY commboard
    ORDER BY commboard   
);

\COPY facdb TO PSTDOUT DELIMITER ',' CSV HEADER;