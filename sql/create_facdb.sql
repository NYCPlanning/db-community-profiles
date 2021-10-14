DROP TABLE IF EXISTS facdb;
SELECT
    dcp_cdta2020.cdta2020,
    COUNT(*) FILTER (WHERE facsubgrp = 'PARKS') as count_parks,
    COUNT(*) FILTER (WHERE facsubgrp = 'HOSPITALS AND CLINICS') as count_hosp_clinic,
    COUNT(*) FILTER (WHERE facsubgrp = 'PUBLIC LIBRARIES') as count_libraries,
    COUNT(*) FILTER (WHERE facsubgrp = 'PUBLIC K-12 SCHOOLS') as count_public_schools
INTO facdb FROM dcp_facilities LEFT JOIN dcp_cdta2020 
ON ST_Within(dcp_facilities.wkb_geometry, dcp_cdta2020.wkb_geometry)
WHERE facsubgrp IN ('PARKS', 'HOSPITALS AND CLINICS', 'PUBLIC LIBRARIES', 'PUBLIC K-12 SCHOOLS')
AND dcp_cdta2020.cdta2020 IS NOT NULL
GROUP BY dcp_cdta2020.cdta2020
ORDER BY dcp_cdta2020.cdta2020;