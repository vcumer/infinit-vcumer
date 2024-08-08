import yaml


def load_schema_from_yml(file_path):
    with open(file_path, 'r') as yml_file:
        schema = yaml.safe_load(yml_file)
    return schema
