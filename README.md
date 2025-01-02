# Bruce - Discord Bot

Bruce is the bot for the Aussie BroadWAN Discord server. Originally written in Go under the name of Tony, Bruce has evolved to embrace a more flexible and user-friendly approach. By leveraging the **[Driftwood]** framework, which utilizes Lua scripting, Bruce makes it easy for community members to add new features and commands without delving into complex programming.

- **Extensible with Lua Scripts**: Easily add new commands, subcommands, and features by writing Lua scripts.
- **Dynamic Interaction Handling**: Supports message components like buttons and dropdowns with advanced event handling.
- **State Management**: Built-in support for persistent and temporary states across interactions.
- **Event Scheduling**: Schedule delayed actions with Lua's run_after function.
- **Customizable Deployments**: Tailored for the Aussie BroadWAN Discord server but flexible enough for other servers.
- **Easy Logging**: Built-in debug, info, and error logging accessible via Lua.

## How to Run

### Setting Up Bruce

1. Create a Discord bot application via the [Discord Developer Portal].
2. Generate a bot token and save it in a `.env` file.
    - Use the provided `.env.example` file as a template by renaming it to `.env` and populating it with your bot's token and other necessary details.

### Running Bruce

Bruce can be run using Docker. Simply execute the following command in the bot’s directory:

```bash
docker compose up
```

To add custom functionality, place your Lua scripts in the `lua/` directory. Bruce will automatically load these scripts during startup.

Alternatively, use the following Docker Compose template to deploy Bruce:

```yaml
services:
  bot:
    image: "ghcr.io/lcox74/driftwood:v1.0.1"
    environment:
      - DISCORD_TOKEN=your_bot_token
      - GUILD_ID=your_guild_id # Your server ID
    volumes:
      - ./lua:/lua # Mounts your local lua directory to the container
```

[Driftwood]: https://github.com/lcox74/Driftwood
[Go]: https://go.dev/
[Discord Developer Portal]: https://discord.com/developers/docs/getting-started
