import logging

from app.utils.utils import load_schema_from_yml
from app.utils.sources import Source
from app.utils.transforms import Transformer
from app import config


def ingest(logger):
    sync_names = ['cars', 'clients', 'transactions']
    transformer = Transformer()

    for name in sync_names:
        # Load config
        sync = load_schema_from_yml(f'app/schemas/{name}.yml')
        logger.info(f"{sync['name']} – Schema config founded successfully, type: {sync['type']}.")

        # Extract data from source
        source = Source(name, source_type=sync['type'])
        source_df = source.read()
        if source_df is not None:
            logger.info(f"{sync['name']} – Data extracted from source correctly.")

        # Transform
        errors = transformer.validate(source_df, schema=sync['fields'])
        if len(errors) > 0:
            logger.error(errors)
            raise Exception
        logger.info(f"{sync['name']} – Schema validated.")

        dtypes = {key: value['type'] for key, value in sync['fields'].items()}
        parsed_df = transformer.parse(source_df, dtypes=dtypes)
        logger.info(f"{sync['name']} – Data types parsed correctly.")

        clean_df = transformer.add_metadata(parsed_df, pk=sync['primary_key'])
        logger.info(f"{sync['name']} – Metadata added successfully.")

        # Load (create or append only)
        con = f'postgresql+psycopg2://{config.DWH_USER}:{config.DWH_PWD}@{config.DWH_HOST}:{config.DWH_PORT}/{config.DWH_DB}'
        clean_df.to_sql(name, schema='raw', con=con, if_exists='append', index=False)
        logger.info(f"{sync['name']} – Table pushed to the data warehouse")


def main():
    logger = logging.getLogger(__name__)
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - infinit-vcumer - %(levelname)s - %(message)s')

    ingest(logger)


if __name__ == '__main__':
    main()
