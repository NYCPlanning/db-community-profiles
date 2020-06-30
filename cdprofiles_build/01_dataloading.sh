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
        python3 crime.py" | 
    psql $BUILD_ENGINE -f sql/crime.sql