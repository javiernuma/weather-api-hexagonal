.PHONY: help build test clean run docker-build docker-run docker-stop docker-clean

.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Weather API - Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

build: ## Build the project
	@echo "Building project..."
	mvn clean package -DskipTests
	@echo "✓ Build completed"

test: ## Run unit tests
	@echo "Running tests..."
	mvn clean test
	@echo "✓ Tests completed"

coverage: ## Generate test coverage report
	@echo "Generating coverage report..."
	mvn clean test jacoco:report
	@echo "✓ Coverage report at target/site/jacoco/index.html"

clean: ## Clean build artifacts
	mvn clean

run: ## Run the application locally
	mvn -pl bootstrap spring-boot:run

docker-build: ## Build Docker image
	@echo "Building Docker image..."
	docker build -t weather-api:latest .
	@echo "✓ Docker image built"

docker-run: ## Run application in Docker
	@echo "Starting Docker containers..."
	docker-compose up -d
	@echo "✓ Application running at http://localhost:8080"
	@echo "✓ Swagger UI at http://localhost:8080/swagger-ui.html"

docker-logs: ## Show Docker logs
	docker-compose logs -f weather-api

docker-stop: ## Stop Docker containers
	docker-compose stop

docker-down: ## Stop and remove Docker containers
	docker-compose down

docker-clean: docker-down ## Clean Docker resources
	docker-compose down -v --remove-orphans
	docker rmi weather-api:latest 2>/dev/null || true

docker-rebuild: docker-clean docker-build docker-run ## Rebuild and restart

verify: ## Run full verification
	mvn clean verify jacoco:report

api-test: ## Quick API test
	@curl -s "http://localhost:8080/api/weather/Madrid?source=mock" | jq '.' || echo "API test failed"

swagger: ## Open Swagger UI
	@open http://localhost:8080/swagger-ui.html 2>/dev/null || echo "Visit: http://localhost:8080/swagger-ui.html"