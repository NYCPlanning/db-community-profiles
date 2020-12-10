#!/bin/bash
source config.sh
function python_runner {
    docker run --rm\
        -v $(pwd):/src\
        -w /src/python\
        -e CENSUS_API_KEY=$CENSUS_API_KEY\
        -e V_ACS=$V_ACS\
        -e V_DECENNIAL=$V_DECENNIAL\
        -e V_CRIME=$V_CRIME\
        -e V_SANITATION=$V_SANITATION\
        -e V_PARKS=$V_PARKS\
        -e V_POVERTY=$V_POVERTY\
        -e BUILD_ENGINE=$BUILD_ENGINE\
        python:3.7-slim bash -c "
            pip3 install -q --upgrade pip;
            pip3 install -q pff-factfinder;
            python3 $1.py" |
        psql $BUILD_ENGINE -f sql/$2.sql
}

function park {
    display "Loading park access data"
    python_runner out_parks in_parks
}

function acs {
    display "Loading ACS data"
    python_runner out_acs in_acs
}

function flood {
    display "Loading floodplain data"
    python_runner out_floodplain_demo in_floodplain_demo
}

function poverty {
    display "Loading poverty data"
    python_runner out_poverty in_poverty
}

function crime {
    display "Loading crime data"
    python_runner out_crime in_crime
}

function sanitation {
    display "Loading sanitation data"
    python_runner out_sanitation in_sanitation
}

case $1 in
    "park")         park;;
    "acs")          acs;;
    "flood")        flood;;
    "poverty")      poverty;;
    "crime")        crime;;
    "sanitation")   sanitation;;
    *)              echo "$1";;
esac

exit 0