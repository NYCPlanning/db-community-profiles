import pandas as pd
import os
import sys

url='https://data.cityofnewyork.us/resource/rqhp-hivt.csv'
df = pd.read_csv(url, dtype=str)

cols = [
    "borough",
    "district",
    "acceptable_streets_feb_2014"
]

df.columns = [i.lower().replace(" ", "_") for i in df.columns]
for col in cols:
    assert col in df.columns

df[cols].to_csv(sys.stdout, index=False)