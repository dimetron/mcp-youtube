.PHONY: help install setup clean build lint format test test-watch test-coverage inspector dev ci all check docker-build docker-run docker-stop docker-logs

# Default target - show available commands
help:
	@echo "MCP YouTube Server - Available Make Commands"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make install          Install project dependencies"
	@echo "  make setup            Complete project setup (install + build)"
	@echo ""
	@echo "Development:"
	@echo "  make dev              Start development with inspector"
	@echo "  make inspector        Run MCP server with local inspector"
	@echo "  make build            Compile TypeScript to JavaScript"
	@echo "  make clean            Remove build artifacts"
	@echo ""
	@echo "Code Quality:"
	@echo "  make lint             Check code for linting errors"
	@echo "  make format           Auto-format code with Prettier"
	@echo "  make test             Run all tests"
	@echo "  make test-watch       Run tests in watch mode"
	@echo "  make test-coverage    Run tests with coverage report"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build     Build Docker image"
	@echo "  make docker-run       Run Docker container"
	@echo "  make docker-stop      Stop and remove Docker container"
	@echo "  make docker-logs      View Docker container logs"
	@echo ""
	@echo "CI/CD:"
	@echo "  make ci               Run all CI checks (lint, test, build)"
	@echo "  make all              Alias for 'make ci'"
	@echo ""

# Install dependencies
install:
	@echo "📦 Installing dependencies..."
	bun install

# Complete setup (install + build)
setup: install build
	@echo "✅ Project setup complete!"

# Remove build artifacts and caches
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -rf dist
	rm -rf coverage
	rm -rf node_modules/.cache
	@echo "✅ Clean complete!"

# Build TypeScript project
build:
	@echo "🔨 Building project..."
	bun run build
	@echo "✅ Build complete!"

# Run linter
lint:
	@echo "🔍 Linting code..."
	bun run lint

# Format code with Prettier
format:
	@echo "✨ Formatting code..."
	bun run format

# Run all tests
test:
	@echo "🧪 Running tests..."
	bun test

# Run tests in watch mode
test-watch:
	@echo "🧪 Running tests in watch mode..."
	bun test --watch

# Run tests with coverage
test-coverage:
	@echo "🧪 Running tests with coverage..."
	bun test --coverage

# Run MCP server with inspector
inspector:
	@echo "🔍 Starting MCP inspector..."
	bun run inspector

# Alias for inspector (common dev workflow)
dev: inspector

# CI workflow - run all checks
ci: lint test build
	@echo "✅ All CI checks passed!"

# Alias for ci
all: ci

# Quick development cycle - format, lint, test
check: format lint test
	@echo "✅ All checks passed!"

# Docker build
docker-build:
	@echo "🐳 Building Docker image..."
	docker build -t mcp-youtube:latest .
	@echo "✅ Docker image built successfully!"

# Docker run
docker-run: docker-build
	@echo "🚀 Starting Docker container..."
	docker run -d \
		--name mcp-youtube \
		-e YOUTUBE_API_KEY=$${YOUTUBE_API_KEY} \
		-e MDB_MCP_CONNECTION_STRING=$${MDB_MCP_CONNECTION_STRING} \
		mcp-youtube:latest
	@echo "✅ Docker container started! Use 'make docker-logs' to view logs."

# Docker stop and remove
docker-stop:
	@echo "🛑 Stopping Docker container..."
	@docker stop mcp-youtube 2>/dev/null || true
	@docker rm mcp-youtube 2>/dev/null || true
	@echo "✅ Docker container stopped and removed!"

# Docker logs
docker-logs:
	@echo "📋 Docker container logs:"
	docker logs -f mcp-youtube

