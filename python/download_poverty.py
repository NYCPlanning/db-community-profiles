import pandas as pd
from . import ENGINE
from .utils import psql_insert_copy

'''
url='future_opendata_url'
df = pd.read_csv(url, dtype=str)
'''

temp_path = 'data/cd_poverty.csv'
df = pd.read_csv(temp_path, dtype=str)

cols = [
    "boro",
    "borocd",
    "neighborhood",
    "5yr_avg_pov_rate",
    "moe"
]

df.columns = [i.lower().replace(" ", "_") for i in df.columns]
for col in cols:
    assert col in df.columns

df[cols]\
    .rename(columns={'5yr_avg_pov_rate': 'pov_rate_5yr_avg'})\
    .to_sql('_poverty', con=ENGINE, method=psql_insert_copy,
            if_exists='replace', index=False)
