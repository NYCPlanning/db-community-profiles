DROP TABLE IF EXISTS PARKS;
SELECT
	cdta2020, (CASE WHEN total_pop!=0 THEN total_pop_access/total_pop*100 END) as pct_served_parks
INTO PARKS
FROM (
	SELECT 
		lookup_geo.cdta2020,
		SUM(_decennial.value) as total_pop,
		SUM(_decennial.value) FILTER (WHERE lookup_geo.park_access::numeric = 1) as total_pop_access
	FROM _decennial RIGHT JOIN lookup_geo 
	ON _decennial.geoid = lookup_geo.bctcb2020
	WHERE length(_decennial.geoid) = 11
	GROUP BY lookup_geo.cdta2020
) park_access;