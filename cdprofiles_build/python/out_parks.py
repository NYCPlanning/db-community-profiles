import pandas as pd
import os
from factfinder.main import Pff

decennial = Pff(api_key=os.environ['CENSUS_API_KEY'], year=os.environ['V_DECENNIAL'])
df_with_access = decennial.calculate_variable('pop2010', 'cd_park_access')
df_total = decennial.calculate_variable('pop2010', 'cd')
df = df_with_access.merge(df_total, on='census_geoid', suffixes=('_access', '_total'))
df['per_access'] = df['e_access']/df['e_total']

df[['census_geoid','per_access']].to_csv('parks_output.csv', index=False)
df[['census_geoid','per_access']].to_csv(sys.stdout, index=False)