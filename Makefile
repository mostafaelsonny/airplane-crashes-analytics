.PHONY: help up down ps logs test producer spark psql clean

help:
	@echo "Available commands:"
	@echo "  make up          - Start all docker containers (Kafka, Postgres, NiFi)"
	@echo "  make down        - Stop all docker containers"
	@echo "  make ps          - View running containers"
	@echo "  make logs        - Follow docker logs"
	@echo "  make test        - Run test suite"
	@echo "  make psql        - Open psql shell inside postgres container"
	@echo "  make producer    - Run Python historical data producer"
	@echo "  make spark       - Run Spark structured streaming consumer"
	@echo "  make clean       - Remove python cache and temp files"

up:
	docker compose -f infrastructure/docker-compose.yml up -d

down:
	docker compose -f infrastructure/docker-compose.yml down

ps:
	docker compose -f infrastructure/docker-compose.yml ps

logs:
	docker compose -f infrastructure/docker-compose.yml logs -f

test:
	pytest tests/ -v

psql:
	docker exec -it postgres psql -U postgres -d airplane_crashes_db

producer:
	python producer/src/producer.py

spark:
	python spark/src/spark_consumer.py

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
