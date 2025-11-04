# Docker Setup & Local Configuration for MCP YouTube Server

This guide explains how to run the MCP YouTube server locally using Docker with the `mcp.json` configuration.

## Prerequisites

- **Docker Desktop** installed and running
- **YouTube Data API v3 Key** - [Get one here](https://console.cloud.google.com/)
- **MCP Client** (e.g., Claude Desktop, Cline, or custom client)
- Optional: **MongoDB Atlas** account for caching

## Quick Start

### 1. Build the Docker Image

```bash
docker build -t mcp-youtube:latest .
```

This creates a Docker image named `mcp-youtube:latest` with all dependencies and the compiled server.

### 2. Setup Environment Variables

Copy the example environment file and add your API keys:

```bash
cp .env.example .env
```

Edit `.env` and fill in your credentials:

```env
YOUTUBE_API_KEY=your_actual_api_key_here
MDB_MCP_CONNECTION_STRING=mongodb+srv://user:pass@cluster.mongodb.net/youtube_niche_analysis
```

### 3. Configure Your MCP Client

Use the provided `mcp.json` file. This configuration file tells your MCP client how to run the server via Docker.

**Example for Claude Desktop** (`~/.config/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "youtube": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "--env-file",
        "/path/to/mcp-youtube/.env",
        "mcp-youtube:latest"
      ],
      "disabled": false
    }
  }
}
```

Replace `/path/to/mcp-youtube/.env` with the absolute path to your `.env` file.

## How the mcp.json Configuration Works

The `mcp.json` file in this repository uses Docker to containerize the MCP server:

```json
{
  "mcpServers": {
    "youtube": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "--env-file",
        ".env",
        "mcp-youtube:latest"
      ]
    }
  }
}
```

**Breakdown:**

| Parameter | Purpose |
|-----------|---------|
| `command: "docker"` | Run the server via Docker |
| `--rm` | Remove container after exit |
| `-i` | Keep stdin open (required for MCP stdio) |
| `--env-file` | Load environment variables from `.env` file |
| `mcp-youtube:latest` | Image name and tag to run |

## Docker Image Details

The `Dockerfile` performs the following steps:

1. **Base Image:** `oven/bun:alpine` - lightweight Bun runtime
2. **Dependencies:** Installs all npm packages via `bun install`
3. **Build:** Compiles TypeScript to JavaScript with `bun run build`
4. **Environment:** Sets default (empty) values for `YOUTUBE_API_KEY` and `MDB_MCP_CONNECTION_STRING`
5. **Entrypoint:** Runs `bun dist/index.js` (the compiled MCP server)

## Running Without Docker (Alternative)

If you prefer running locally without Docker:

```bash
cp .env.example .env
# Edit .env with your API keys
bun install
bun run build
YOUTUBE_API_KEY=your_key bun dist/index.js
```

## Testing the Docker Image

### Run Interactively

```bash
docker run --rm -it --env-file .env mcp-youtube:latest
```

### Check Logs

```bash
docker run --rm --env-file .env mcp-youtube:latest 2>&1 | head -50
```

### Test Specific Tool

You can use the MCP Inspector to test the server:

```bash
docker run --rm -it --env-file .env mcp-youtube:latest
```

Then use the [MCP Inspector](https://github.com/modelcontextprotocol/inspector) to connect.

## Docker Compose (Optional)

For development with MongoDB caching, create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  mcp-youtube:
    build: .
    environment:
      YOUTUBE_API_KEY: ${YOUTUBE_API_KEY}
      MDB_MCP_CONNECTION_STRING: ${MDB_MCP_CONNECTION_STRING}
    stdin_open: true
    tty: true

  mongodb:
    image: mongo:7
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_DB: youtube_niche_analysis
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
```

Run with:

```bash
docker-compose up
```

## Troubleshooting

### "Command not found: docker"

Docker is not installed or not in your PATH. [Install Docker Desktop](https://www.docker.com/products/docker-desktop).

### "Connection refused" when connecting to MongoDB

Ensure your MongoDB connection string in `.env` is correct and the MongoDB instance is accessible.

### API Key not being recognized

- Verify `YOUTUBE_API_KEY` is set in `.env`
- Check that the file path in `mcp.json` points to the correct `.env` location
- Ensure no extra whitespace or quotes in the API key

### Container exits immediately

Check logs with:

```bash
docker run --rm --env-file .env mcp-youtube:latest 2>&1
```

## Performance Tips

1. **Use MongoDB caching** - Dramatically reduces API quota usage
2. **Reuse image builds** - Docker caches layers, rebuilds are fast
3. **Allocate sufficient resources** - Docker Desktop: Settings → Resources → increase Memory/CPU

## Cleaning Up

Remove the Docker image:

```bash
docker rmi mcp-youtube:latest
```

Remove all unused Docker resources:

```bash
docker system prune -a
```

## Security Notes

- **Never commit `.env`** - Add it to `.gitignore` (already done)
- **Use environment variables** - Never hardcode API keys
- **Restrict API key scope** - YouTube API keys should have minimal necessary permissions
- **Use private registries** - If pushing to Docker Hub, ensure privacy settings

## Next Steps

1. ✅ Build the Docker image: `docker build -t mcp-youtube:latest .`
2. ✅ Configure `.env` with your API keys
3. ✅ Update your MCP client's config (e.g., Claude Desktop)
4. ✅ Restart your MCP client
5. ✅ Start using the YouTube tools!

For more information, see [README.md](README.md) and [AGENTS.md](AGENTS.md).
