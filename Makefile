export TZ=UTC

.PHONY: help
help:
	@awk -F ':.*# ' '/^[a-zA-Z0-9_-]+:.*# / {printf "\033[32m%-35s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: docker-up
docker-up: # Spin up local services with Docker.
	docker-compose up -d

.PHONY: docker-down
docker-down: # Tear down local services.
	docker-compose down -v

.PHONY: create-table
create-table: # Create a transactions table in PostgreSQL.
	docker exec postgres psql -U postgres -c " \
		CREATE TABLE IF NOT EXISTS transactions ( \
			id SERIAL PRIMARY KEY, \
			amount DOUBLE PRECISION NOT NULL, \
			timestamp TIMESTAMP NOT NULL DEFAULT NOW() \
		);"

.PHONY: populate-table
populate-table: # Populate the transactions table with dummy records.
	docker exec postgres psql -U postgres -c "INSERT INTO transactions (amount) VALUES (100.50), (250.75), (89.99), (500.00), (33.25)"

.PHONY: read-table
read-table: # Read the transactions table.
	docker exec postgres psql -U postgres -c "SELECT * FROM transactions"

.PHONY: psql
psql: # Run the PostgreSQL console.
	docker exec -it postgres psql -U postgres

.PHONY: register-connector
register-connector: # Register the Debezium PostgreSQL CDC Kafka Connector.
	curl --fail -X POST http://localhost:8083/connectors \
		-H "Content-Type: application/json" \
		-d '{ \
				"name": "postgres-connector", \
				"config": { \
					"connector.class": "io.debezium.connector.postgresql.PostgresConnector", \
					"database.hostname": "postgres", \
					"database.port": "5432", \
					"database.user": "postgres", \
					"database.password": "postgres", \
					"database.dbname": "postgres", \
					"topic.prefix": "postgres", \
					"table.include.list": "public.transactions", \
					"plugin.name": "pgoutput" \
				} \
			}'
