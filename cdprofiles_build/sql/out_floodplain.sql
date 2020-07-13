CREATE TEMP TABLE FLOODPLAIN as (
    SELECT 
        cd,
        sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN lotarea ELSE 0 END) as fp_100_area,
        sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN numbldgs ELSE 0 END) as fp_100_bldg,
        sum(numbldgs) as cd_tot_bldgs,
        sum(CASE WHEN firm07_flag = '1' OR pfirm15_flag = '1' THEN unitsres ELSE 0 END) as fp_100_resunits,
        sum(unitsres) as cd_tot_resunits,
        sum(CASE WHEN (firm07_flag = '1' OR pfirm15_flag = '1') AND landuse = '09' THEN lotarea ELSE 0 END) as fp_100_openspace,
        sum(CASE WHEN 
            (select true in (
                select id IS NOT NULL 
                FROM fema_firms_500yr.latest b
                where ST_Intersects(geom,b.wkb_geometry)
                )
            )
            THEN lotarea
            ELSE 0 END) as fp_500_area,
        sum(CASE WHEN 
            (select true in (
                select id IS NOT NULL 
                FROM fema_firms_500yr.latest b
                where ST_Intersects(geom,b.wkb_geometry)
                )
            )
            AND landuse = '09' 
            THEN lotarea
            ELSE 0 END) as fp_500_openspace
    FROM dcp_pluto.:"VERSION" a
    GROUP BY cd
    ORDER BY cd
);
\COPY FLOODPLAIN TO PSTDOUT DELIMITER ',' CSV HEADER;