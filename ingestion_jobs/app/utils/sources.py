import logging
import pandas as pd

from .. import config

TYPE_TO_READER = {
    'json': pd.read_json,
    'csv': pd.read_csv,
    'postgres': pd.read_sql_table
}


class Source:
    def __init__(self, name: str, source_type: str, schema: str = 'products'):
        """ Returns the source data as a python DataFrame.

        Available source types: postgres | csv | json"""
        self.source_type = source_type
        self.name = name
        self.file_path = name if source_type == 'postgres' else f'app/data/{name}.{source_type}'
        self.schema = schema

    def read(self):
        # Optional method arguments for the reader
        args = {
            key: value for key, value in {
                'con': f'postgresql+psycopg2://{config.OPERATIONAL_PRODUCT_DB_USER}:{config.OPERATIONAL_PRODUCT_DB_PWD}@{config.OPERATIONAL_PRODUCT_DB_HOST}:{config.OPERATIONAL_PRODUCT_DB_PORT}/{config.OPERATIONAL_PRODUCT_DB_DB}' if self.source_type == 'postgres' else None,
                'schema': self.schema if self.source_type == 'postgres' else None
            }.items() if value is not None
        }

        try:
            df = TYPE_TO_READER[self.source_type](self.file_path, **args)
            return df
        except Exception as e:
            logging.error(e)
            return None
