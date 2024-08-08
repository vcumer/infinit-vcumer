import logging
import pandas as pd

from datetime import datetime


class Transformer:
    def __init__(self):
        return

    def validate(self, df: pd.DataFrame, schema: dict):
        """ Validate schema consistency."""
        errors = []

        for column, properties in schema.items():
            if column not in df.columns:
                # Check column existence
                if properties['required']:
                    errors.append(f"Missing required column: {column}")

        # Check unexpected columns
        for column in df.columns:
            if column not in schema:
                errors.append(f"Unexpected column: {column}")

        return errors

    def parse(self, df: pd.DataFrame, dtypes: dict):
        """ Try to parse dataframe with the expected schema."""
        try:
            parsed_df = df.astype(dtypes)
            return parsed_df
        except Exception as e:
            logging.error(e)
            raise e

    def add_metadata(self, df: pd.DataFrame, pk: str):
        """ Add normalize the table content with common useful metadata."""
        cols = df.columns
        now = datetime.now()
        df['meta_processing_time'] = df.iloc[:, 0].apply(lambda _: now)
        df['meta_entity_id'] = df[pk]
        return df.loc[:, ['meta_processing_time', 'meta_entity_id'] + [col for col in cols]]

