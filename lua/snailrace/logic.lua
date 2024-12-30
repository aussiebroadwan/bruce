local driftwood = require("driftwood")

local state = require("snailrace.state")
local utils = require("snailrace.utils")
local render = require("snailrace.render")
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
    local drawn_card
    repeat
        drawn_card = table.remove(current_state.deck, 1)

        -- If the card belongs to a finished snail, discard and redraw
        if drawn_card and current_state.positions[drawn_card] >= constants.MAX_UNITS then
            drawn_card = nil
        end
    until drawn_card or #current_state.deck == 0

    -- If no valid card can be drawn, the race is over
    if not drawn_card then
        driftwood.log.info("No valid cards left. Ending race.")
        logic.finish_race()
        return
    end

    -- Move the snail forward
    current_state.positions[drawn_card] = current_state.positions[drawn_card] + 1

    -- If the snail crosses the finish line, assign a place

    if current_state.positions[drawn_card] >= constants.MAX_UNITS and not current_state.finish_order[drawn_card] then
        local place = utils.table_length(current_state.finish_order) + 1
        current_state.finish_order[drawn_card] = place
        driftwood.log.info("Snail " .. drawn_card .. " finished in place " .. place)
    end

    -- Render the race track and update the message
    local race_message = render.race_track(current_state)
    driftwood.message.edit(current_state.message_id, current_state.channel_id, race_message)

    -- Check if all snails have finished
    local all_finished = true
    for _, position in pairs(current_state.positions) do
        if position < constants.MAX_UNITS then
            all_finished = false
            break
        end
    end

    if all_finished then
        logic.finish_race()
        return
    end

    -- Save updated state and schedule the next tick
    state.set(current_state)
    driftwood.timer.run_after(logic.race_tick, 1)
end

--- End the race and announce the winners.
logic.finish_race = function()
    local current_state = state.get()
    if not current_state then
        driftwood.log.error("Tried to finish a race that doesn't exist.")
        return
    end

    -- Gather the results
    local results = "The race is over! Here are the results:\n"
    for player_id, place in pairs(current_state.finish_order) do
        local name = current_state.participants[player_id]
        results = results .. string.format("%d. %s\n", place, name)
    end

    driftwood.message.add(current_state.channel_id, results)
    state.clear()
end


return logic
