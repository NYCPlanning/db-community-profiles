/*
DESCRIPTION:
    Creates an count of 4 select facility subgroups by community district. 

INPUTS:
facilities (
    commboard,
    facsubgrp
)

OUTPUTS:
    count_parks,
    count_hosp_clinic,
    count_libraries,
    count_public_schools
*/
DROP TABLE IF EXISTS FACILITIES_commpro;
SELECT commboard,
  sum(CASE WHEN facsubgrp = 'PARKS' THEN 1 ELSE 0 END) count_parks,
  sum(CASE WHEN facsubgrp = 'HOSPITALS AND CLINICS' THEN 1 ELSE 0 END) count_hosp_clinic,
  sum(CASE WHEN facsubgrp = 'PUBLIC LIBRARIES' THEN 1 ELSE 0 END) count_libraries,
  sum(CASE WHEN facsubgrp = 'PUBLIC K-12 SCHOOLS' THEN 1 ELSE 0 END) count_public_schools
INTO FACILITIES_commpro
FROM facilities
GROUP BY commboard
ORDER BY commboard;