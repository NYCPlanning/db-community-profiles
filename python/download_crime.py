import requests
from . import ENGINE, API_TOKEN
from .utils import psql_insert_copy
import pandas as pd
import os
from io import StringIO

url = 'https://data.cityofnewyork.us/resource/qgea-i56i.csv'
headers = {'X-App-Token': API_TOKEN}
year = os.environ['V_CRIME']
params = {
    '$select': '*',
    '$where': f'date_extract_y(cmplnt_fr_dt)={year} and ky_cd in (101,104,105,106,107,109,110)',
    '$limit': 500000000
}

r = requests.get(f"{url}", headers=headers, params=params)
if r.status_code == 200:
    pd.read_csv(StringIO(r.text))\
        .to_sql(
            '_crime',
            con=ENGINE,
            if_exists='replace',
            index=False,
            method=psql_insert_copy
    )
else:
    print('Something is wrong with source data, please check socrata')
