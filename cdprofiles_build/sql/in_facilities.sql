DROP TABLE IF EXISTS facdb;
CREATE TABLE facdb (
    borocd text,
    count_parks numeric,
    count_hosp_clinic numeric,
    count_libraries numeric,
    count_public_schools numeric
);

\COPY facdb FROM PSTDIN DELIMITER ',' CSV HEADER;