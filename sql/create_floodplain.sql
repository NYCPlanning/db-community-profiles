-- DROP TABLE IF EXISTS FLOODPLAIN;
-- CREATE TABLE FLOODPLAIN as (
--     SELECT 
--         cd,
--         sum(ROUND(lotarea/27878400, 2)) FILTER (WHERE firm07_fla = '1' OR pfirm15_fl = '1') as fp_100_area,
--         sum(numbldgs) FILTER (WHERE firm07_fla = '1' OR pfirm15_fl = '1') as fp_100_bldg,
--         sum(numbldgs) as cd_tot_bldgs,
--         sum(unitsres) FILTER (WHERE firm07_fla = '1' OR pfirm15_fl = '1') as fp_100_resunits,
--         sum(unitsres) as cd_tot_resunits,
--         sum(ROUND(lotarea/27878400, 3)) FILTER( WHERE (firm07_fla = '1' OR pfirm15_fl = '1') AND landuse = '09') as fp_100_openspace,
--         sum(ROUND(lotarea/27878400, 2)) FILTER (
--             WHERE true in (
--                     SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b 
--                     WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
--             )
--         ) as fp_500_area,
--         sum(ROUND(lotarea/27878400, 3)) FILTER (
--             WHERE true in (
--                 SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b
--                 WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
--             ) AND landuse = '09'
--         ) as fp_500_openspace,
--         sum(numbldgs) FILTER (
--             WHERE true in (
--                 SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b
--                 WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
--             )
--         ) as fp_500_bldg,
--         sum(unitsres) FILTER (
--             WHERE true in (
--                 SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b
--                 WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
--             )
--         ) as fp_500_resunits
--     FROM dcp_mappluto a
--     GROUP BY cd ORDER BY cd
-- );

DROP TABLE IF EXISTS FLOODPLAIN_DEMO;
CREATE TABLE FLOODPLAIN_DEMO AS (
    SELECT 
        _acs.census_geoid as cdta2020,
        _acs.fp_100_cost_burden,
        _acs.fp_100_cost_burden_value,
        _acs.fp_500_cost_burden,
        _acs.fp_500_cost_burden_value,
        _acs.fp_100_rent_burden,
        _acs.fp_100_rent_burden_value,
        _acs.fp_500_rent_burden,
        _acs.fp_500_rent_burden_value,
        _acs.fp_100_mhhi,
        _acs.fp_500_mhhi,
        _acs.fp_100_permortg,
        _acs.fp_100_mortg_value,
        _acs.fp_500_permortg,
        _acs.fp_500_mortg_value,
        _acs.fp_100_ownerocc,
        _acs.fp_100_ownerocc_value,
        _acs.fp_500_ownerocc,
        _acs.fp_500_ownerocc_value,
        decennial_population.fp_100_pop,
        decennial_population.fp_500_pop
    FROM _acs JOIN (
        SELECT 
            lookup_geo.cdta2020,
            SUM(value) FILTER (WHERE lookup_geo.fp_100::numeric = 1) AS fp_100_pop,
            SUM(value) FILTER (WHERE lookup_geo.fp_500::numeric = 1) AS fp_500_pop
        FROM _decennial 
        RIGHT JOIN lookup_geo ON _decennial.geoid = lookup_geo.bctcb2020
        WHERE LENGTH(_decennial.geoid) = 11 AND variable = 'pop1'
        GROUP BY lookup_geo.cdta2020
    ) decennial_population ON _acs.census_geoid = decennial_population.cdta2020
);