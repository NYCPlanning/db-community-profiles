import pandas as pd
import os
import sys

'''
url='future_opendata_url'
df = pd.read_csv(url, dtype=str)
'''

temp_path = '../data/cd_poverty.csv'
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

df[cols].to_csv(sys.stdout, index=False)