import pandas as pd
from .utils import psql_insert_copy
from . import ENGINE

pd.read_csv(
    ('https://nyc3.digitaloceanspaces.com'
     '/edm-publishing/db-factfinder/acs_community_profiles'
     '/year=2019'
     '/geography=2010_to_2020'
     '/acs_community_profiles.csv')
).to_sql(
    '_acs',
    con=ENGINE,
    method=psql_insert_copy,
    if_exists='replace',
    index=False,
    chunksize=1000
)
