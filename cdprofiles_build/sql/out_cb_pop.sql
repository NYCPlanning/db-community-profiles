DROP TABLE IF EXISTS cb_pop;
SELECT 
	geoid as bctcb2010,
	value as pop
INTO cb_pop
FROM pff_decennial."2010"
WHERE LENGTH(geoid::text) = 11
AND variable = 'Pop1';

\COPY cb_pop TO PSTDOUT DELIMITER ',' CSV HEADER;