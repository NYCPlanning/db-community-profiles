import requests
import os
import sys

url='https://data.cityofnewyork.us/resource/qgea-i56i.csv'
headers = {'X-App-Token':os.environ['API_TOKEN']}
year = os.environ['V_CRIME']
params = {
            '$select':'*', 
            '$where':f'date_extract_y(cmplnt_fr_dt)={year} and ky_cd in (101,104,105,106,107,109,110)',
            '$limit':500000
        }

if not os.path.exists(f'../data/crimes_{year}.csv'):
    r = requests.get(f"{url}", headers=headers, params=params)
    if r.status_code == 200:
        with open(f'../data/crimes_{year}.csv', 'w') as f:
            f.write(r.text)
    else: 
        print('Something is wrong with source data, please check socrata')

with open(f'../data/crimes_{year}.csv', 'r') as f:
    sys.stdout.write(f.read())