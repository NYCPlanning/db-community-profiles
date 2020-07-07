#!/bin/bash
source config.sh

display "loading CD boundaries"
docker run --rm\
    -v $(pwd):/src\
    -w /src/python\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "
        python3 dataloading.py"

display "loading crime data"
docker run --rm\
    -v $(pwd):/src\
    -w /src/python\
    -e API_TOKEN=$API_TOKEN\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "
        python3 out_crime.py" |  
    psql $BUILD_ENGINE -f sql/in_crime.sql

psql $BUILD_ENGINE -c "
    DROP TABLE IF EXISTS cd_puma;
    CREATE TABLE cd_puma (
        borocd text,
        puma text
    ); 
"
imports_csv cd_puma

display "loading FacDB data"
psql -q $EDM_DATA -v VERSION=$V_FACDB -f sql/out_facilities.sql | 
    psql $BUILD_ENGINE -f sql/in_facilities.sql &

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
display "complete"