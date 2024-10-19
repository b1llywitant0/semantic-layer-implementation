include .env

help:
	@echo "## docker-build		- Build Docker Images (amd64) including its inter-container network."
	@echo "## postgres			- Run a Postgres container."
	@echo "## spark			- Run a Spark cluster, rebuild the postgres container, then create the destination tables."
	@echo "## airflow			- Spinup airflow scheduler and webserver."
	@echo "## datahub			- Spinup datahub instances."
	@echo "## metabase			- Spinup metabase instance."
	@echo "## clean			- Cleanup all running containers related to the challenge."

docker-build:
	@echo '__________________________________________________________'
	@echo 'Building Docker Images ...'
	@chmod 777 logs/
	@echo '__________________________________________________________'
	@docker network inspect finpro-network >/dev/null 2>&1 || docker network create finpro-network
	@echo '__________________________________________________________'
	@docker build -t dataeng-dibimbing/spark -f ./docker/Dockerfile.spark .
	@echo '__________________________________________________________'
	@docker build -t dataeng-dibimbing/airflow -f ./docker/Dockerfile.airflow .
	@echo '==========================================================='

spark:
	@echo '__________________________________________________________'
	@echo 'Creating Spark Cluster ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-spark.yml --env-file .env up -d
	@echo '==========================================================='

airflow:
	@echo '__________________________________________________________'
	@echo 'Creating Airflow Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-airflow.yml --env-file .env up -d
	@echo '==========================================================='

postgres: postgres-create postgres-create-warehouse postgres-create-table postgres-ingest-csv

postgres-create:
	@docker compose -f ./docker/docker-compose-postgres.yml --env-file .env up -d
	@echo '__________________________________________________________'
	@echo 'Postgres container created at port ${POSTGRES_PORT}...'
	@echo '__________________________________________________________'
	@echo 'Postgres Docker Host	: ${POSTGRES_CONTAINER_NAME}' &&\
		echo 'Postgres Account	: ${POSTGRES_USER}' &&\
		echo 'Postgres password	: ${POSTGRES_PASSWORD}' &&\
		echo 'Postgres Db		: ${POSTGRES_DW_DB}'
	@echo '==========================================================='
	@sleep 5

postgres-create-table:
	@echo '__________________________________________________________'
	@echo 'Creating tables...'
	@echo '_________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DW_DB} -f sql/tables-ddl.sql
	@echo '==========================================================='

postgres-ingest-csv:
	@echo '__________________________________________________________'
	@echo 'Ingesting CSV...'
	@echo '_________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DW_DB} -f sql/ingest.sql
	@echo '==========================================================='

postgres-create-warehouse:
	@echo '__________________________________________________________'
	@echo 'Creating Ecommerce DB...'
	@echo '_________________________________________'
	@docker exec -it ${POSTGRES_CONTAINER_NAME} psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} -f sql/ecommerce-ddl.sql
	@echo '==========================================================='

datahub-create:
	@echo '__________________________________________________________'
	@echo 'Creating Datahub Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-datahub.yml --env-file .env up
	@echo '==========================================================='

datahub-ingest:
	@echo '__________________________________________________________'
	@echo 'Ingesting Data to Datahub ...'
	@echo '__________________________________________________________'
	@datahub ingest -c ./datahub/sample.yaml --dry-run
	@echo '==========================================================='

metabase: postgres-create-warehouse
	@echo '__________________________________________________________'
	@echo 'Creating Metabase Instance ...'
	@echo '__________________________________________________________'
	@docker compose -f ./docker/docker-compose-metabase.yml --env-file .env up
	@echo '==========================================================='

clean:
	"C:/Program Files/Git/bin/bash.exe" ./scripts/goodnight.sh


postgres-bash:
	@docker exec -it finpro-postgres bash