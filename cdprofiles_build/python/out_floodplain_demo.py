from functools import reduce
import pandas as pd
import os
import sys
from factfinder.main import Pff

acs = Pff(api_key=os.environ['CENSUS_API_KEY'], year=int(os.environ['V_ACS'].split('-')[1]))
decennial = Pff(api_key=os.environ['CENSUS_API_KEY'], year=int(os.environ['V_DECENNIAL']))

dec_variable_mapping = [
    {'pff_variable': 'decennial_pop', 'geotype': 'cd_fp_100', 'column_mapping': {'e': 'fp_100_pop'}},
    {'pff_variable': 'decennial_pop', 'geotype': 'cd_fp_500', 'column_mapping': {'e': 'fp_500_pop'}},
    ]

acs_variable_mapping = [
    {'pff_variable': 'costburden', 'geotype': 'cd_fp_100', 'column_mapping': {'p': 'fp_100_cost_burden', 'z': 'fp_100_cost_burden_moe'}},
    {'pff_variable': 'costburden', 'geotype': 'cd_fp_500', 'column_mapping': {'p': 'fp_500_cost_burden', 'z': 'fp_500_cost_burden_moe'}},
    {'pff_variable': 'costburden', 'geotype': 'cd_fp_100', 'column_mapping': {'e': 'fp_100_cost_burden_value', 'm': 'fp_100_cost_burden_value_moe'}},
    {'pff_variable': 'costburden', 'geotype': 'cd_fp_500', 'column_mapping': {'e': 'fp_500_cost_burden_value', 'm': 'fp_500_cost_burden_value_moe'}},
    {'pff_variable': 'rentburden', 'geotype': 'cd_fp_100', 'column_mapping': {'p': 'fp_100_rent_burden', 'z': 'fp_100_rent_burden_moe'}},
    {'pff_variable': 'rentburden', 'geotype': 'cd_fp_500', 'column_mapping': {'p': 'fp_500_rent_burden', 'z': 'fp_500_rent_burden_moe'}},
    {'pff_variable': 'rentburden', 'geotype': 'cd_fp_100', 'column_mapping': {'e': 'fp_100_rent_burden_value', 'm': 'fp_100_rent_burden_value_moe'}},
    {'pff_variable': 'rentburden', 'geotype': 'cd_fp_500', 'column_mapping': {'e': 'fp_500_rent_burden_value', 'm': 'fp_500_rent_burden_value_moe'}},
    {'pff_variable': 'mdhhinc', 'geotype': 'cd_fp_100', 'column_mapping': {'e': 'fp_100_mhhi', 'm': 'fp_100_mhhi_moe'}},
    {'pff_variable': 'mdhhinc', 'geotype': 'cd_fp_500', 'column_mapping': {'e': 'fp_500_mhhi', 'm': 'fp_500_mhhi_moe'}},
    {'pff_variable': 'mortg', 'geotype': 'cd_fp_100', 'column_mapping': {'p': 'fp_100_permortg', 'z': 'fp_100_permortg_moe'}},
    {'pff_variable': 'mortg', 'geotype': 'cd_fp_500', 'column_mapping': {'p': 'fp_500_permortg', 'z': 'fp_500_permortg_moe'}},
    {'pff_variable': 'mortg', 'geotype': 'cd_fp_100', 'column_mapping': {'e': 'fp_100_mortg_value', 'm': 'fp_100_mortg_value_moe'}},
    {'pff_variable': 'mortg', 'geotype': 'cd_fp_500', 'column_mapping': {'e': 'fp_500_mortg_value', 'm': 'fp_500_mortg_value_moe'}},
    {'pff_variable': 'ownerocc', 'geotype': 'cd_fp_100', 'column_mapping': {'p': 'fp_100_ownerocc', 'z': 'fp_100_ownerocc_moe'}},
    {'pff_variable': 'ownerocc', 'geotype': 'cd_fp_500', 'column_mapping': {'p': 'fp_500_ownerocc', 'z': 'fp_500_ownerocc_moe'}},
    {'pff_variable': 'ownerocc', 'geotype': 'cd_fp_100', 'column_mapping': {'e': 'fp_100_ownerocc_value', 'm': 'fp_100_ownerocc_value_moe'}},
    {'pff_variable': 'ownerocc', 'geotype': 'cd_fp_500', 'column_mapping': {'e': 'fp_500_ownerocc_value', 'm': 'fp_500_ownerocc_value_moe'}},
    ]

def calculate(inputs, pff):
    pff_variable=inputs['pff_variable']
    geotype=inputs['geotype']
    column_mapping=inputs['column_mapping']
    return pff.calculate(pff_variable,geotype).rename(columns=column_mapping)[['census_geoid']+list(column_mapping.values())]

dfs = []

for i in acs_variable_mapping:
    df = calculate(i, acs)
    dfs.append(df)

for i in dec_variable_mapping:
    df = calculate(i, decennial)
    dfs.append(df)

dff = reduce(lambda left,right: pd.merge(left,right, on=['census_geoid'],
                                            how='outer'), dfs)

#dff.to_csv('output/fp_output.csv', index=False)
dff.to_csv(sys.stdout, index=False)