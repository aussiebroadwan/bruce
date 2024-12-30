local driftwood = require("driftwood")

local state = require("snailrace.state")
local constants = require("snailrace.core.constants")
local racers = require("snailrace.game.racers")
local logic = require("snailrace.game.logic")
local render = require("snailrace.game.render")

local commands = {}

--- Handle the "snailrace" command to host a race.
--- @param interaction CommandInteraction The command interaction.
commands.handle_snailrace_command = function(interaction)
    local host_id = interaction.user.id
    local channel_id = interaction.channel_id

    if state.get() then
        interaction:reply("A race is already active!", {ephemeral = true})
        return
    end

    local current_state = state.initialize(host_id, channel_id, interaction)

    -- Render initial race track and save the message ID
    local join_message = render.join_race(current_state)
    current_state.message_id = driftwood.message.add(channel_id, join_message, {
        driftwood.new_button("Join Race", "snailrace_join")
    })
    state.set(current_state)

    interaction:reply("A new snail race has started!")
    driftwood.timer.run_after(function()
        local start_state = state.get()
        if not start_state then
            driftwood.log.error("Failed to get the race state")
            return
        end

         -- Add fake racers
        racers.add_fake_racers(start_state)

        -- Build and shuffle the deck
        racers.build_deck(start_state)
        state.set(start_state)

        logic.race_tick()
    end, constants.JOIN_DURATION)
end

--- Handle the "join" button interaction.
--- @param interaction EventInteraction The command interaction.
commands.handle_join_button = function(interaction)
    local current_state = state.get()

    if not current_state or not current_state.active then
        interaction:reply("The race is no longer active.", {ephemeral = true})
        return
    end

    if current_state.participants[interaction.user.id] then
        interaction:reply("You're already in the race!", {ephemeral = true})
        return
    end

    current_state.participants[interaction.user.id] = interaction.user.global_name
    current_state.positions[interaction.user.id] = 0
    state.set(current_state)

    interaction:reply("You joined the race!", {ephemeral = true})

    local join_message = render.join_race(current_state)
    driftwood.message.edit(current_state.message_id, current_state.channel_id, join_message)
end

return commands
