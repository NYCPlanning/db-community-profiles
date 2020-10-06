import geopandas as gpd
import sys
import os

os.getcwd()
path = 'https://data.cityofnewyork.us/api/geospatial/rg6q-zak8?method=export&format=Shapefile'
gdf = gpd.read_file(path).set_crs("EPSG:4326")
gdf.to_csv('raw_parks.csv', index=False)
gdf.to_csv(sys.stdout, index=False)
