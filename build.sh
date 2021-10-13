#!/bin/bash
source config.sh

# echo "Loading CDTA boundary data"
# import_public dcp_cdta2020 $V_GEO
# import_public dcp_facilities
# psql $BUILD_ENGINE -f sql/create_cdta_geometry.sql 

# echo "Load geolookups"
# python3 -m python.download_geolookups

# echo "Loading ACS Data"
# python3 -m python.download_acs
# psql $BUILD_ENGINE -f sql/create_acs.sql

# echo "Loading crime data"
# python3 -m python.download_crime
# psql $BUILD_ENGINE -f sql/create_crime.sql

# echo "Loading sanitation data"
# python3 -m python.download_sanitation   
# psql $BUILD_ENGINE -v VERSION=$V_SANITATION -f sql/create_sanitation.sql

# display "Loading poverty data"
# docker run --rm\
#     -v $(pwd):/src\
#     -w /src/python\
#     -e BUILD_ENGINE=$BUILD_ENGINE\
#     python:3.9-slim bash -c "
#         pip3 install -q pff-factfinder==$PFF_PKG_VERSION;
#         python3 out_poverty.py" |  
#     psql $BUILD_ENGINE -f sql/in_poverty.sql

# display "Loading park access"
# python3 -m python.download_decennial
# psql $BUILD_ENGINE -f sql/create_parks.sql

# display "Loading floodplain data"
# docker run --rm\
#     -v $(pwd):/src\
#     -w /src/python\
#     -e CENSUS_API_KEY=$CENSUS_API_KEY\
#     -e V_DECENNIAL=$V_DECENNIAL\
#     -e V_ACS=$V_ACS\
#     -e BUILD_ENGINE=$BUILD_ENGINE\
#     python:3.9-slim bash -c "
#         pip3 install -q pff-factfinder==$PFF_PKG_VERSION;
#         python3 out_floodplain_demo.py" |  
#     psql $BUILD_ENGINE -f sql/in_floodplain_demo.sql

# psql -q $EDM_DATA -v VERSION=$V_PLUTO -f sql/out_floodplain.sql |
#           psql $BUILD_ENGINE -f sql/in_floodplain.sql &

# display "Loading FacDB data"
# psql $BUILD_ENGINE -f sql/create_facdb.sql 

# display "Loading PLUTO data"
# psql -q $EDM_DATA -v VERSION=$V_PLUTO -f sql/out_pluto_landusecount.sql | 
#     psql $BUILD_ENGINE -f sql/in_pluto_landusecount.sql &

# psql -q $EDM_DATA -v VERSION=$V_PLUTO -f sql/out_pluto_landusearea.sql |
#     psql $BUILD_ENGINE -f sql/in_pluto_landusearea.sql &

# display "Loading look-up tables: Titles, CB contact, SON, decennial pop, tooltips, and PUMAs"

# cat data/cd_titles.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cd_titles;
#     CREATE TABLE cd_titles (
#         borocd text,
#         cd_full_title text,
#         cd_short_title text
#     ); 
#     COPY cd_titles FROM STDIN DELIMITER ',' CSV HEADER;
# "

# cat data/cb_contact.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cb_contact;
#     CREATE TABLE cb_contact (
#         borocd text,
#         cb_email text,
#         cb_website text
#     ); 
#     COPY cb_contact FROM STDIN DELIMITER ',' CSV HEADER;
# "

# cat data/cd_to_block.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cd_bctcb2010;
#     CREATE TABLE cd_bctcb2010 (
#         bctcb2010 text,
#         cd text,
#         geom geometry(Geometry, 4326)
#     ); 
#     COPY cd_bctcb2010 FROM STDIN DELIMITER ',' CSV HEADER;
# "

# cat data/cd_son.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cd_son;
#     CREATE TABLE cd_son (
#         borocd text,
#         neighborhoods text,
#         son_issue_1 text,
#         son_issue_2 text,
#         son_issue_3 text
#     ); 
#     COPY cd_son FROM STDIN DELIMITER ',' CSV HEADER;
# "

# cat data/cd_tooltips.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cd_tooltips;
#     CREATE TABLE cd_tooltips (
#         acs_tooltip text,
#         acs_tooltip_2 text,
#         acs_tooltip_3 text,
#         borocd text
#     ); 
#     COPY cd_tooltips FROM STDIN DELIMITER ',' CSV HEADER;
# "

# cat data/cd_decennial_pop.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cd_decennial_pop;
#     CREATE TABLE cd_decennial_pop (
#         borocd text,
#         pop_2000 text,
#         pop_2010 text,
#         pop_change_00_10 text
#     ); 
#     COPY cd_decennial_pop FROM STDIN DELIMITER ',' CSV HEADER;
# "

# cat data/cd_puma.csv | psql $BUILD_ENGINE -c "
#     DROP TABLE IF EXISTS cd_puma;
#     CREATE TABLE cd_puma (
#         borocd text,
#         puma text,
#         shared_puma boolean,
#         shared_puma_cd text
#     ); 
#     COPY cd_puma FROM STDIN DELIMITER ',' CSV HEADER;
# "

# wait
# display "Combine all"
# psql -q $BUILD_ENGINE\
#     -v V_PLUTO=$V_PLUTO\
#     -v V_ACS=$V_ACS\
#     -v V_DECENNIAL=$V_DECENNIAL\
#     -v V_FACDB=$V_FACDB\
#     -v V_CRIME=$V_CRIME\
#     -v V_SANITATION=$V_SANITATION\
#     -v V_GEO=$V_GEO\
#     -v V_PARKS=$V_PARKS\
#     -v V_POVERTY=$V_POVERTY\
#     -v V_CDNEEDS=$V_CDNEEDS\
#     -f sql/combine.sql

# wait
# display "Create download views"
# psql -q $BUILD_ENGINE -f sql/create_views.sql 

# wait
# display "Export outputs to csv"
# mkdir -p output
# psql $BUILD_ENGINE -c "\COPY (
#         SELECT * FROM combined
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/combined.csv & 
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM cd_demo_age_gender
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/cd_demo_age_gender.csv &
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM cd_demo_race_economics
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/cd_demo_race_economics.csv &
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM cd_administrative
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/cd_administrative.csv &
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM cd_built_environment
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/cd_built_environment.csv &
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM cd_floodplain
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/cd_floodplain.csv &
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM boro_cd_attributes
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/boro_cd_attributes.csv &
# psql $BUILD_ENGINE -c "\COPY (
#     SELECT * FROM city_cd_attributes
#     ) TO stdout DELIMITER ',' CSV HEADER;" > output/city_cd_attributes.csv

# display "Export versions to csv"
# echo "source, version" > output/versions.csv
# echo "dcp_cdboundaries, $V_GEO" >> output/versions.csv
# echo "crime, $V_CRIME" >> output/versions.csv
# echo "sanitation, $V_SANITATION" >> output/versions.csv
# echo "poverty, $V_POVERTY" >> output/versions.csv
# echo "dpr_access_zone, $V_PARKS" >> output/versions.csv
# echo "decennial, $V_DECENNIAL" >> output/versions.csv
# echo "facilities, $V_FACDB" >> output/versions.csv
# echo "dcp_pluto, $V_PLUTO" >> output/versions.csv
# echo "acs, $V_ACS" >> output/versions.csv
# echo "cd_needs, $V_CDNEEDS" >> output/versions.csv