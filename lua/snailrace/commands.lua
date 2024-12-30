local driftwood = require("driftwood")

local state = require("snailrace.state")
local racers = require("snailrace.racers")
local logic = require("snailrace.logic")
local render = require("snailrace.render")

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

    local current_state = {
        host = host_id,
        channel_id = channel_id,
        participants = {[host_id] = interaction.user.global_name},
        positions = {[host_id] = 0},
        finish_order = {}, -- Track finishing order
        deck = {},
        gate_index = 1,
        active = true,
        message_id = nil
    }

    -- Add fake racers
    racers.add_fake_racers(current_state)

    -- Build and shuffle the deck
    racers.build_deck(current_state)

    -- Render initial race track and save the message ID
    local race_message = render.race_track(current_state)
    current_state.message_id = driftwood.message.add(channel_id, race_message)
    state.set(current_state)

    interaction:reply_with_action("A new snail race has started! Click below to join.", {
        driftwood.new_button("Join Race", "snailrace_join")
    })

    driftwood.timer.run_after(logic.race_tick, 30)
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
end

return commands
