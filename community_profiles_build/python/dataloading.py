from sqlalchemy import create_engine
from cook import Importer
import os
import pandas as pd
from multiprocessing import Pool, cpu_count
from utils.exporter import exporter

RECIPE_ENGINE = os.environ.get("RECIPE_ENGINE", "")
BUILD_ENGINE = os.environ.get("BUILD_ENGINE", "")
EDM_DATA = os.environ.get("EDM_DATA", "")


def ETL(table):
    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name=table)


tables = [
    "dcp_mappluto",
    "dcp_cdboundaries"
]


def dcp_mappluto():
    recipe_engine = create_engine(RECIPE_ENGINE)
    build_engine = create_engine(BUILD_ENGINE)

    df = pd.read_sql(
        """
        SELECT 
            b.version,
            b.bbl::numeric::bigint::text,
            b.unitsres,
            b.bldgarea,
            b.comarea,
            b.officearea,
            b.retailarea,
            b.resarea,
            b.yearbuilt,
            b.yearalter1,
            b.yearalter2,
            b.bldgclass,
            b.landuse,
            b.ownertype,
            b.ownername,
            b.condono,
            b.numbldgs,
            b.numfloors,
            b.firm07_fla,
            b.pfirm15_fl,
            b.wkb_geometry
        FROM dcp_mappluto.latest b
        """,
        recipe_engine,
    )
    exporter(df=df, table_name="dcp_mappluto", sep="|", con=build_engine)
    build_engine.execute(
        """
        ALTER TABLE dcp_mappluto 
        ALTER COLUMN wkb_geometry TYPE Geometry USING ST_SetSRID(ST_GeomFromText(ST_AsText(wkb_geometry)), 4326);
        """
    )
    del df


def load_crime(year):
    # Filter from opendata
    df = pd.read_csv(f"https://data.cityofnewyork.us/resource/qgea-i56i.csv?$query=SELECT%20latitude,%20longitude%20WHERE%20date_extract_y(cmplnt_fr_dt)={year}%20AND%20ky_cd%20IN%20(101,104,105,106,107,109,110)%20LIMIT%20500000")
    
    # Export to build engine
    exporter(df=df, table_name="crime", con=build_engine)
    del df



if __name__ == "__main__":
    with Pool(processes=cpu_count()) as pool:
        pool.map(ETL, tables)

    load_crime()
