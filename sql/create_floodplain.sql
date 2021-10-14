DROP TABLE IF EXISTS FLOODPLAIN;
CREATE TABLE FLOODPLAIN as (
    SELECT 
        cd,
        sum(ROUND(lotarea/27878400, 2)) FILTER (WHERE firm07_fla = '1' OR pfirm15_fl = '1') as fp_100_area,
        sum(numbldgs) FILTER (WHERE firm07_fla = '1' OR pfirm15_fl = '1') as fp_100_bldg,
        sum(numbldgs) as cd_tot_bldgs,
        sum(unitsres) FILTER (WHERE firm07_fla = '1' OR pfirm15_fl = '1') as fp_100_resunits,
        sum(unitsres) as cd_tot_resunits,
        sum(ROUND(lotarea/27878400, 3)) FILTER( WHERE (firm07_fla = '1' OR pfirm15_fl = '1') AND landuse = '09') as fp_100_openspace,
        sum(ROUND(lotarea/27878400, 2)) FILTER (
            WHERE true in (
                    SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b 
                    WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
            )
        ) as fp_500_area,
        sum(ROUND(lotarea/27878400, 3)) FILTER (
            WHERE true in (
                SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b
                WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
            ) AND landuse = '09'
        ) as fp_500_openspace,
        sum(numbldgs) FILTER (
            WHERE true in (
                SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b
                WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
            )
        ) as fp_500_bldg,
        sum(unitsres) FILTER (
            WHERE true in (
                SELECT fld_ar_id IS NOT NULL FROM fema_firms_500yr b
                WHERE ST_Intersects(wkb_geometry,b.wkb_geometry)
            )
        ) as fp_500_resunits
    FROM dcp_mappluto a
    GROUP BY cd ORDER BY cd
);