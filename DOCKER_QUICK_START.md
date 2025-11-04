# Docker Quick Start - 5 Minutes to Running

## 1️⃣ Build the Image

```bash
docker build -t mcp-youtube:latest .
```

Or use the setup script:

```bash
./setup-docker.sh
```

## 2️⃣ Configure Environment

```bash
cp .env.example .env
# Edit .env and add your YouTube API key
```

## 3️⃣ Update Your MCP Client Config

### For Claude Desktop

Edit `~/.config/Claude/claude_desktop_config.json`:

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

**Important:** Replace `/path/to/mcp-youtube` with the absolute path to your repository.

### For Other MCP Clients

Use the provided `mcp.json` file and adapt it for your client's configuration format.

## 4️⃣ Restart Your MCP Client

- Claude Desktop: Restart the application
- Other clients: Reconnect to the server

## 5️⃣ Start Using the Tools! 🎉

The YouTube tools should now be available in your MCP client.

---

## Common Commands

```bash
# Build the image
docker build -t mcp-youtube:latest .

# Run the server interactively
docker run --rm -it --env-file .env mcp-youtube:latest

# Check logs
docker run --rm --env-file .env mcp-youtube:latest 2>&1 | head -50

# Remove the image
docker rmi mcp-youtube:latest
```

## Troubleshooting

**Error: "Docker not found"**
- Install [Docker Desktop](https://www.docker.com/products/docker-desktop)

**Error: "API key not recognized"**
- Verify the absolute path to `.env` in your MCP client config
- Check that `YOUTUBE_API_KEY` is set in `.env`

**Container exits immediately**
- Run: `docker run --rm --env-file .env mcp-youtube:latest 2>&1` to see error logs

---

📖 For detailed information, see [DOCKER.md](DOCKER.md)
