# Kafka Connect
Project to showcase how to capture CDC events from a database and ingest them to Kafka.

Tech stack: Kafka Connect, Debezium and PostgreSQL.

<img width="1652" height="345" alt="image" src="https://github.com/user-attachments/assets/2540ee5d-9751-4a52-b022-7c8a8e501313" />

A [Docker Compose file](docker-compose.yml) is provided that spins up containers for Kafka, Schema Registry, Kafka Connect and PostgreSQL.

Run `make help` to see available commands to run the project.

Kafka topics can be browsed with Kafbat UI (http://localhost:8080) after spinning up the services.
