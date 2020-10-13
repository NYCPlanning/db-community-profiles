#!/bin/bash
source config.sh

display "loading CD boundary data"
psql -q $RECIPE_ENGINE -v VERSION=$V_GEO -f sql/out_cd_geo.sql |
    psql $BUILD_ENGINE -f sql/in_cd_geo.sql 

display "loading crime data"
docker run --rm\
    -v $(pwd):/src\
    -w /src/python\
    --user $UID\
    -e API_TOKEN=$API_TOKEN\
    -e V_CRIME=$V_CRIME\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "
        python3 out_crime.py" |  
    psql $BUILD_ENGINE -f sql/in_crime.sql

display "loading sanitation data"
docker run --rm\
    -v $(pwd):/src\
    -w /src/python\
    -e V_SANITATION=$V_SANITATION\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "
        python3 out_sanitation.py" |  
    psql $BUILD_ENGINE -v VERSION=$V_SANITATION -f sql/in_sanitation.sql

display "loading look-up tables: puma, cd titles, cb contact, cd to bctcb2010, son, tooltips"

cat data/cd_puma.csv | psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cd_puma;
    CREATE TABLE cd_puma (
        borocd text,
        puma text
    ); 
    COPY cd_puma FROM STDIN DELIMITER ',' CSV HEADER;
"

cat data/cd_titles.csv | psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cd_titles;
    CREATE TABLE cd_titles (
        borocd text,
        cd_full_title text,
        cd_short_title text
    ); 
    COPY cd_titles FROM STDIN DELIMITER ',' CSV HEADER;
"

cat data/cb_contact.csv | psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cb_contact;
    CREATE TABLE cb_contact (
        borocd text,
        cb_email text,
        cb_website text
    ); 
    COPY cb_contact FROM STDIN DELIMITER ',' CSV HEADER;
"

cat data/cd_to_block.csv | psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cd_bctcb2010;
    CREATE TABLE cd_bctcb2010 (
        bctcb2010 text,
        cd text,
        geom geometry(Geometry, 4326)
    ); 
    COPY cd_bctcb2010 FROM STDIN DELIMITER ',' CSV HEADER;
"

cat data/cd_son.csv | psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cd_son;
    CREATE TABLE cd_son (
        borocd text,
        neighborhoods text,
        cd_son_fy2018 text,
        son_issue_1 text,
        son_issue_2 text,
        son_issue_3 text
    ); 
    COPY cd_son FROM STDIN DELIMITER ',' CSV HEADER;
"

cat data/cd_tooltips.csv | psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cd_tooltips;
    CREATE TABLE cd_tooltips (
        acs_tooltip text,
        acs_tooltip_2 text,
        acs_tooltip_3 text,
        borocd text
    ); 
    COPY cd_tooltips FROM STDIN DELIMITER ',' CSV HEADER;
"

display "loading 2010 decennial population data"
psql -q $EDM_DATA -v VERSION=$V_FACDB -f sql/out_cb_pop.sql | 
    psql $BUILD_ENGINE -f sql/in_cb_pop.sql 

display "loading park access data"
docker run --rm\
    -v $(pwd):/src\
    -w /src/python\
    -e V_PARKS=$V_PARKS\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "pip3 install -q geopandas;
        python3 out_parks.py" |  
    psql $BUILD_ENGINE -f sql/in_parks.sql

display "loading FacDB data"
psql -q $EDM_DATA -v VERSION=$V_FACDB -f sql/out_facdb.sql | 
    psql $BUILD_ENGINE -f sql/in_facdb.sql &

display "loading PLUTO data"
psql -q $EDM_DATA -v VERSION=$V_PLUTO -f sql/out_pluto_landusecount.sql | 
    psql $BUILD_ENGINE -f sql/in_pluto_landusecount.sql &

psql -q $EDM_DATA -v VERSION=$V_PLUTO -f sql/out_pluto_landusearea.sql |
    psql $BUILD_ENGINE -f sql/in_pluto_landusearea.sql &

psql -q $EDM_DATA -v VERSION=$V_PLUTO -f sql/out_floodplain.sql |
    psql $BUILD_ENGINE -f sql/in_floodplain.sql &

display "loading ACS data"
psql -q $EDM_DATA -v VERSION=$V_ACS -f sql/out_acs.sql |
    psql $BUILD_ENGINE -f sql/in_acs.sql & 

wait
display "combine all"
psql -q $BUILD_ENGINE\
    -v V_PLUTO=$V_PLUTO\
    -v V_ACS=$V_ACS\
    -v V_FACDB=$V_FACDB\
    -v V_CRIME=$V_CRIME\
    -v V_SANITATION=$V_SANITATION\
    -v V_GEO=$V_GEO\
    -v V_PARKS=$V_PARKS\
    -f sql/combine.sql