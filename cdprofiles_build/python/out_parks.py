import geopandas as gpd
import sys

url = 'https://data.cityofnewyork.us/api/geospatial/5vb5-y6cv?method=export&format=GeoJSON'
gdf = gpd.read_file(url)
gdf.to_csv('raw_parks.csv')
gdf.to_csv(sys.stdout, index=False)
