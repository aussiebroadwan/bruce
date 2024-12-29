local driftwood = require("driftwood")

local state = require("snailrace.state")
local render = require("snailrace.render")
local racers = require("snailrace.racers")
local constants = require("snailrace.constants")

local logic = {}

--- Perform a single race tick.
logic.race_tick = function()
    local current_state = state.get()
    if not current_state or not current_state.active then
        driftwood.log.info("Race ended early.")
        return
    end

    -- Draw a card from the deck
    local drawn_card = table.remove(current_state.deck, 1)
    if not drawn_card then
        driftwood.log.error("Deck is empty! Race logic failed.")
        return
    end

    -- Move the snail forward
    current_state.positions[drawn_card] = current_state.positions[drawn_card] + 1

    -- Render the race track and update the message
    local race_message = render.race_track(current_state)
    driftwood.message.edit(current_state.message_id, current_state.channel_id, race_message)

    -- Check for gate or finish line
    local current_gate = constants.GATES[current_state.gate_index]
    if current_gate and current_state.positions[drawn_card] >= current_gate then
        current_state.positions[drawn_card] = current_state.positions[drawn_card] - 1
        current_state.gate_index = current_state.gate_index + 1
    end

    -- Check for winner
    for player_id, position in pairs(current_state.positions) do
        if position >= constants.MAX_UNITS then
            logic.end_race(player_id)
            return
        end
    end

    -- Save updated state and schedule the next tick
    state.set(current_state)
    driftwood.timer.run_after(logic.race_tick, 2)
end

--- End the race and announce the winner.
-- @param winner_id string The Discord user ID of the winner.
logic.end_race = function(winner_id)
    local current_state = state.get()
    if not current_state then
        driftwood.log.error("Tried to end a race that doesn't exist.")
        return
    end

    local message = "The race is over! The winner is <@" .. winner_id .. ">!\n"
    driftwood.message.add(current_state.channel_id, message)
    state.clear()
end

return logic
