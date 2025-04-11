local driftwood = require("driftwood")

--- Register a handler for when the bot is ready.
driftwood.on_ready(function()
    local bot_channel = os.getenv("BOT_CHANNEL")
    if not bot_channel then
        driftwood.log.info("BOT_CHANNEL env value isn't set")
        return
    end

    -- Get the ID of the bot testing channel.
    local channel_id = driftwood.channel.get(bot_channel)
    if channel_id == nil then
        driftwood.log.error("Channel '".. bot_channel .. "' not found")
        return
    end

    -- Add a message to the channel.
    driftwood.message.add(channel_id, "Hello, world! I have rebooted.")

end)
