DROP TABLE IF EXISTS FLOODPLAIN;
CREATE TABLE FLOODPLAIN (
    borocd text,
    fp_100_area numeric,
    fp_100_bldg numeric,
    cd_tot_bldgs numeric,
    fp_100_resunits numeric,
    cd_tot_resunits numeric,
    fp_100_openspace numeric,
    fp_500_area numeric,
    fp_500_openspace numeric,
    fp_500_bldg numeric,
    fp_500_resunits numeric
);
\COPY FLOODPLAIN FROM PSTDIN DELIMITER ',' CSV HEADER;