from python import ENGINE
import pandas as pd
from . import ENGINE
from .utils import psql_insert_copy

url = 'https://data.cityofnewyork.us/api/views/rqhp-hivt/rows.csv?accessType=DOWNLOAD'
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

df['acceptable_streets_%'] = df['acceptable_streets_%'].astype(float)
df.rename(
    columns={"acceptable_streets_%": 'acceptable_streets_pct'}
).to_sql(
    '_sanitation',
    con=ENGINE,
    if_exists='replace',
    index=False,
    method=psql_insert_copy
)
