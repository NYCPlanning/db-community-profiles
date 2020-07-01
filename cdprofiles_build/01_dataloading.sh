#!/bin/bash
source config.sh

docker run --rm\
    -v $(pwd):/src\
    -w /src/python\
    -e API_TOKEN=$API_TOKEN\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    nycplanning/cook:latest bash -c "
        python3 dataloading.py
        python3 out_crime.py" | 
    psql $BUILD_ENGINE -f sql/in_crime.sql

psql -q $EDM_DATA -f sql/out_facilities.sql | 
    psql $BUILD_ENGINE -f sql/in_facilities.sql &

psql -q $EDM_DATA -f sql/out_pluto_landusecount.sql | 
    psql $BUILD_ENGINE -f sql/in_pluto_landusecount.sql

psql -q $EDM_DATA -f sql/out_pluto_landusearea.sql |
    psql $BUILD_ENGINE -f sql/in_pluto_landusearea.sql

psql -q $EDM_DATA -f sql/out_floodplain.sql |
    psql $BUILD_ENGINE -f sql/in_floodplain.sql