import requests
import os
import sys

url='https://data.cityofnewyork.us/resource/qgea-i56i.csv'
headers = {'X-App-Token':os.environ['API_TOKEN']}
params = {
            '$select':'cmplnt_num,latitude,longitude', 
            '$where':f'date_extract_y(cmplnt_fr_dt)=2016 and ky_cd in (101,104,105,106,107,109,110)',
            '$limit':500000
        }

r = requests.get(f"{url}", headers=headers, params=params).text
sys.stdout.write(r)