# Bruce - Discord Bot

Bruce is the bot for the Aussie BroadWAN Discord server. Originally written in Go under the name of Tony, Bruce has evolved to embrace a more flexible and user-friendly approach. By leveraging the **[Driftwood]** framework, which utilizes Lua scripting, Bruce makes it easy for community members to add new features and commands without delving into complex programming.

- **Extensible with Lua Scripts**: Easily add new commands, subcommands, and features by writing Lua scripts.
- **Dynamic Interaction Handling**: Supports message components like buttons and dropdowns with advanced event handling.
- **State Management**: Built-in support for persistent and temporary states across interactions.
- **Event Scheduling**: Schedule delayed actions with Lua's run_after function.
- **Customizable Deployments**: Tailored for the Aussie BroadWAN Discord server but flexible enough for other servers.
- **Easy Logging**: Built-in debug, info, and error logging accessible via Lua.

## How to Run

To deploy your own instance of Bruce, start by creating a Discord bot 
application. Detailed instructions are available in the [Discord Dev Doc]. 
After setting up your bot, generate a Bot Token and save it in a `.env` file.

> **Note:** Use the provided .env.example as a template. Simply rename it to 
>           `.env` and update its contents accordingly.

The bot then can be ran using Docker, simply run `docker compose up` in the directory to launch the bot. To add additional funcitonality, add files to the `lua/` directory.

[Driftwood]: https://github.com/lcox74/Driftwood
[Go]: https://go.dev/
[Discord Dev Doc]: https://discord.com/developers/docs/getting-started