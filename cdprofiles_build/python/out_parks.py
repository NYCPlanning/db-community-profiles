import pandas as pd
import os
import sys
from factfinder.main import Pff

decennial = Pff(
    api_key=os.environ['CENSUS_API_KEY'], 
    year=int(os.environ['V_DECENNIAL']), 
    source='decennial'
)

df_with_access = decennial.calculate('decennial_pop', 'cd_park_access')
df_total = decennial.calculate('decennial_pop', 'cd')
df = df_with_access.merge(df_total, on='census_geoid', suffixes=('_access', '_total'))
df['per_access'] = df['e_access']/df['e_total']

#df[['census_geoid','per_access']].to_csv('output/parks_output.csv', index=False)
df[['census_geoid','per_access']].to_csv(sys.stdout, index=False)