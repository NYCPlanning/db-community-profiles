import pandas as pd
import os
import sys

url='https://data.cityofnewyork.us/api/views/rqhp-hivt/rows.csv?accessType=DOWNLOAD'
df = pd.read_csv(url, dtype=str)

cols = [
    "month",
    "borough",
    "district",
    "acceptable_streets_%"
]

df.columns = [i.lower().replace(" ", "_") for i in df.columns]
for col in cols:
    assert col in df.columns

df[cols].to_csv(sys.stdout, index=False)