FROM python:3.12-slim as dbt_site_builder

WORKDIR /app

COPY . /app

ENV DATABASE_HOST postgres
ENV DBT_DIR /app
ENV DBT_PROFILES_DIR $DBT_DIR

RUN pip install -r requirements.txt

RUN dbt deps

ENTRYPOINT ["dbt", "docs", "generate"]

# serve site
FROM nginx:stable-alpine

COPY --from=dbt_site_builder /app/target/index.html /app/target/manifest.json /app/target/catalog.json /app/target/run_results.json /usr/share/nginx/html/

EXPOSE 80