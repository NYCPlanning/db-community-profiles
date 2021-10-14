import pandas as pd
from . import ENGINE
from .utils import psql_insert_copy

pd.read_csv(
    ('https://raw.githubusercontent.com'
     '/NYCPlanning/db-factfinder'
     '/dev'
     '/factfinder/data/lookup_geo/'
     '2020'
     '/lookup_geo.csv'),
    dtype=str
).to_sql(
    'lookup_geo',
    con=ENGINE,
    if_exists='replace',
    index=False,
    method=psql_insert_copy
)
