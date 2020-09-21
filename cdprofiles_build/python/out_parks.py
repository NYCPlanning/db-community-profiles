import geopandas as gpd
import sys
import os

os.getcwd()

#path = 'https://data.cityofnewyork.us/api/geospatial/5vb5-y6cv?method=export&format=GeoJSON'
path = '../data/park_service_area/park_service_area.shp'
gdf = gpd.read_file(path).set_crs("EPSG:4326")
gdf.to_csv('raw_parks.csv', index=False)
gdf.to_csv(sys.stdout, index=False)
