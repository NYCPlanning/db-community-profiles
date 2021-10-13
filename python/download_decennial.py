import pandas as pd
from .utils import psql_insert_copy
from . import ENGINE

df = pd.read_csv(
    ('https://nyc3.digitaloceanspaces.com'
     '/edm-publishing/db-factfinder/decennial'
     '/year=2020'
     '/geography=2010_to_2020'
     '/decennial.csv')
)
df.loc[(df.variable == 'pop1'), :].to_sql(
    '_decennial',
    con=ENGINE,
    method=psql_insert_copy,
    if_exists='replace',
    index=False,
    chunksize=1000
)
