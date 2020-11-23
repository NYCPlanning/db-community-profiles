DROP TABLE IF EXISTS floodplain_demo;
CREATE TABLE facdb (
    borocd text,
    fp_100_cost_burden numeric,
    fp_500_cost_burden numeric,
    fp_100_cost_burden_value numeric,
    fp_500_cost_burden_value numeric,
    fp_100_rent_burden numeric,
    fp_500_rent_burden numeric,
    fp_100_rent_burden_value numeric,
    fp_500_rent_burden_value numeric,
    fp_100_mhhi numeric,
    fp_500_mhhi numeric,
    fp_100_permortg numeric,
    fp_500_permortg numeric,
    fp_100_mortg_value numeric,
    fp_500_mortg_value numeric,
    fp_100_ownerocc numeric,
    fp_500_ownerocc numeric,
    fp_100_ownerocc_value numeric,
    fp_500_ownerocc_value numeric,
    fp_100_pop numeric,
    fp_500_pop numeric
);

\COPY floodplain_demo FROM PSTDIN DELIMITER ',' CSV HEADER;