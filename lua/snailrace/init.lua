local driftwood = require("driftwood")

-- Import modules
local commands = require("snailrace.commands")

-- Register the "snailrace" command and join button interaction
driftwood.register_application_command({
    name = "snailrace",
    description = "Host a snail race",
    handler = commands.handle_snailrace_command,
})

driftwood.register_interaction("snailrace_join", commands.handle_join_button)