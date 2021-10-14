#!/bin/bash
source config.sh

cdta () {
    echo "Loading CDTA boundary data"
    import_public dcp_cdta2020 $V_GEO
    psql $BUILD_ENGINE -f sql/create_cdta_geometry.sql 
}

lookups () {
    echo "Load geolookups"
    python3 -m python.download_geolookups
    echo "Loading look-up tables: Titles, CB contact, SON, decennial pop, tooltips, and PUMAs"
    psql $BUILD_ENGINE -f sql/create_lookups.sql 
}

acs () {
    echo "Loading ACS Data"
    python3 -m python.download_acs
    psql $BUILD_ENGINE -f sql/create_acs.sql
}

crime () {
    echo "Loading crime data"
    python3 -m python.download_crime
    psql $BUILD_ENGINE -f sql/create_crime.sql
}

sanitation () {
    echo "Loading sanitation data"
    python3 -m python.download_sanitation   
    psql $BUILD_ENGINE -v VERSION=$V_SANITATION -f sql/create_sanitation.sql
}

poverty () {
    echo "Loading poverty data"
    python3 -m python.download_poverty
    psql $BUILD_ENGINE -f sql/create_poverty.sql
}

park () {
    echo "Loading park access"
    python3 -m python.download_decennial
    psql $BUILD_ENGINE -f sql/create_parks.sql
}

floodplain () {
    echo "Loading floodplain data"
    import_public fema_firms_500yr
    psql $BUILD_ENGINE -f sql/create_floodplain.sql
}

facdb () {
    echo "Loading FacDB data"
    import_public dcp_facilities $V_FACDB
    psql $BUILD_ENGINE -f sql/create_facdb.sql 
}


pluto () {
    echo "Loading PLUTO data"
    import_public dcp_mappluto $V_PLUTO
    psql $BUILD_ENGINE -f sql/create_pluto_landusecount.sql &
    psql $BUILD_ENGINE -f sql/create_pluto_landusearea.sql &
    wait
}

combine () {
    echo "Combine all"
    psql -q $BUILD_ENGINE\
        -v V_PLUTO=$V_PLUTO\
        -v V_ACS=$V_ACS\
        -v V_DECENNIAL=$V_DECENNIAL\
        -v V_FACDB=$V_FACDB\
        -v V_CRIME=$V_CRIME\
        -v V_SANITATION=$V_SANITATION\
        -v V_GEO=$V_GEO\
        -v V_PARKS=$V_PARKS\
        -v V_POVERTY=$V_POVERTY\
        -v V_CDNEEDS=$V_CDNEEDS\
        -f sql/combine.sql
}

views () {
    echo "Create download views"
    psql -q $BUILD_ENGINE -f sql/create_views.sql 
}

versions () {
    psql $BUILD_ENGINE -c "
        DROP TABLE IF EXISTS source_data_versions;
        CREATE TABLE source_data_versions (
            source text,
            version text
        );

        INSERT INTO source_data_versions (source, version)
        VALUES 
            ('dcp_cdta2020', '$V_GEO'),
            ('facilities', '$V_FACDB'),
            ('pluto', '$V_PLUTO'),
            ('acs', '$V_ACS'),
            ('decennial', '$V_DECENNIAL'),
            ('crime', '$V_CRIME'),
            ('sanitation', '$V_SANITATION'),
            ('poverty', '$V_POVERTY'),
            ('park', '$V_PARKS'),
            ('cd_needs', '$V_CDNEEDS');
    "
}

output () {
    echo "Export outputs to csv"
    mkdir -p output && (
        cd output
        CSV_export combined & 
        CSV_export cd_demo_age_gender &
        CSV_export cd_demo_race_economics &
        CSV_export cd_administrative &
        CSV_export cd_built_environment &
        CSV_export cd_floodplain &
        CSV_export boro_cd_attributes &
        CSV_export city_cd_attributes &
        CSV_export cd_demo_race_economics &
        CSV_export cd_demo_race_economics &
        CSV_export cd_demo_race_economics &
        CSV_export source_data_versions &
        wait
    )
}

publish () {
    Upload staging &
    Upload $DATE

    wait 
    echo "Upload Complete"

}

all () {
    cdta & 
    lookups &
    versions &
    pluto
    wait

    acs &
    crime &
    sanitation &
    poverty &
    park &
    floodplain &
    facdb
    wait
    
    combine
    views
    output
}

case $1 in
    hi) echo "hi";;
    cdta|lookups|acs|crime|sanitation) $1 ;;
    park|floodplain|facdb|pluto|combine) $1;;
    poverty|views|output|versions|all|publish) $1;;
esac