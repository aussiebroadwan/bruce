local driftwood = require("driftwood")

local state = require("snailrace.state")
local constants = require("snailrace.core.constants")
local render = require("snailrace.game.render")
local racers = require("snailrace.game.racers")
local helpers = require("snailrace.game.helper")
local cards = require("snailrace.cards.cards")
local handlers = require("snailrace.cards.effect_handlers")
local utils = require("snailrace.core.utils")

local logic = {}

--- Perform a single race tick.
logic.race_tick = function()
    local current_state = state.get()
    if not current_state or not current_state.active then
        driftwood.log.info("Race ended early.")
        return
    end

    -- Handle deck rebuild and check for finish conditions
    if helpers.handle_deck_rebuild(current_state) then
        logic.finish_race()
        return
    end

    -- Draw a valid card
    local drawn_card = helpers.draw_valid_card(current_state)
    if not drawn_card then
        driftwood.log.info("No valid cards left. Ending race.")
        logic.finish_race()
        return
    end

    -- Get the card definition
    local card = cards.get(drawn_card.card)
    if not card then
        driftwood.log.error("Card not found: " .. drawn_card.card)
        return
    end

    -- Apply all effects from the card
    driftwood.log.info("Snail " .. drawn_card.snail_id .. " drew card: " .. card.name)
    handlers.process_card(card.effects, drawn_card.snail_id, current_state)

    -- Check if all snails have reached or passed the current gate
    local gate_position = constants.GATES[current_state.gate_index]
    if gate_position then
        local all_passed = true
        for _, position in pairs(current_state.positions) do
            if position < gate_position then
                all_passed = false
                break
            end
        end

        if all_passed then
            helpers.activate_gate_card(current_state.gate_index, current_state)
            current_state.gate_index = current_state.gate_index + 1
        end
    end

    -- Update positions and check if any snail finishes
    for snail_id, position in pairs(current_state.positions) do
        if position >= constants.MAX_UNITS and not current_state.finish_order[snail_id] then
            local place = utils.table_length(current_state.finish_order) + 1
            current_state.finish_order[snail_id] = place
            driftwood.log.debug("Snail " .. snail_id .. " finished in place " .. place)
        end
    end

    -- Render and update state
    local race_message = render.race_track(current_state)
    driftwood.message.edit(current_state.message_id, current_state.channel_id, race_message, {
        components = {
            driftwood.new_button("Join Race", "snailrace_join", true),
        }
    })

    state.set(current_state)

    -- Check if all snails have finished
    if helpers.all_snails_finished(current_state.positions) then
        logic.finish_race()
        return
    end

    driftwood.timer.run_after(logic.race_tick, constants.TICK_SPEED)
end

--- Finish the race and announce the results.
logic.finish_race = function()
    local current_state = state.get()
    if not current_state then
        driftwood.log.error("Tried to finish a race that doesn't exist.")
        return
    end

    -- Render and update state
    local race_message = render.race_track_finish(current_state)
    driftwood.message.edit(current_state.message_id, current_state.channel_id, race_message, {
        components = {
            driftwood.new_button("Join Race", "snailrace_join", true),
        }
    })

    -- Clear state
    state.clear()
end

--- Start the race and draw gate cards.
logic.race_start = function()
    local start_state = state.get()
    if not start_state then
        driftwood.log.error("Failed to get the race state")
        return
    end

    -- Add fake racers
    racers.add_fake_racers(start_state)

    -- Build and shuffle the deck
    racers.build_deck(start_state)

    -- Draw gate cards
    helpers.draw_gate_cards(start_state)

    state.set(start_state)
    logic.race_tick()
end


return logic
