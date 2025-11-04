#!/bin/bash

# MCP YouTube Server - Docker Setup Script
# This script helps set up and run the MCP YouTube server using Docker

set -e

echo "🚀 MCP YouTube Server - Docker Setup"
echo "===================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "✅ Docker found: $(docker --version)"
echo ""

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📋 Creating .env file from .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ .env created. Please edit it with your YouTube API key."
    else
        echo "❌ .env.example not found"
        exit 1
    fi
else
    echo "✅ .env file already exists"
fi

echo ""
echo "🔨 Building Docker image..."
docker build -t mcp-youtube:latest .

echo ""
echo "✅ Docker image built successfully!"
echo ""
echo "📝 Next steps:"
echo "   1. Edit .env file with your YouTube API key:"
echo "      - YOUTUBE_API_KEY=your_api_key_here"
echo "      - (Optional) MDB_MCP_CONNECTION_STRING for MongoDB caching"
echo ""
echo "   2. For Claude Desktop, copy mcp.json to ~/.config/Claude/claude_desktop_config.json"
echo "      and update the path to .env file:"
echo "      \"--env-file\": \"/absolute/path/to/mcp-youtube/.env\""
echo ""
echo "   3. Restart your MCP client"
echo ""
echo "📖 For more information, see DOCKER.md"
