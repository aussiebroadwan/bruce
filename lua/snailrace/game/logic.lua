local driftwood = require("driftwood")

local state = require("snailrace.state")
local cards = require("snailrace.core.cards")
local constants = require("snailrace.core.constants")
local handlers = require("snailrace.core.effect_handlers")
local utils = require("snailrace.core.utils")
local render = require("snailrace.game.render")
local racers = require("snailrace.game.racers")

local logic = {}

--- Check if all snails have finished the race.
---@param positions table<string, number> Snail positions.
---@return boolean True if all snails have finished, otherwise false.
local function all_snails_finished(positions)
    for _, position in pairs(positions) do
        if position < constants.MAX_UNITS then
            return false
        end
    end
    return true
end

--- Perform a single race tick.
logic.race_tick = function()
    local current_state = state.get()
    if not current_state or not current_state.active then
        driftwood.log.info("Race ended early.")
        return
    end

    local finishing = false

    -- Check if deck size is below threshold and rebuild if needed
    if #current_state.deck <= current_state.deck_size_threshold then
        driftwood.log.info("Deck size is below threshold. Rebuilding and reshuffling the deck.")
        racers.build_deck(current_state)

        current_state.redraws = current_state.redraws + 1
        if current_state.redraws >= constants.MAX_REDRAW_ATTEMPTS then
            driftwood.log.info("Max redraw limit reached. Stopping the race.")
            finishing = true
        end
    end

    -- Draw a card
    local drawn_card
    repeat
        -- If the deck is empty, rebuild and reshuffle
        if #current_state.deck == 0 then
            driftwood.log.info("Deck is empty. Rebuilding and reshuffling the deck.")
            racers.build_deck(current_state)

            current_state.redraws = current_state.redraws + 1
            if current_state.redraws >= constants.MAX_REDRAW_ATTEMPTS then
                driftwood.log.info("Max redraw limit reached. Stopping the race.")
                finishing = true
            end
        end

        drawn_card = table.remove(current_state.deck, 1)

        -- If the card belongs to a finished snail, discard and redraw
        if drawn_card and current_state.positions[drawn_card.snail_id] >= constants.MAX_UNITS then
            drawn_card = nil
        end
    until drawn_card

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
    driftwood.log.info("Snail " .. drawn_card.snail_id .. " drew card: " .. card.name)

    -- Apply all effects from the card
    handlers.process_card(card.effects, drawn_card.snail_id, current_state)

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
        driftwood.new_button("Join Race", "snailrace_join", true),
    })

    state.set(current_state)

    -- Check if all snails have finished
    if all_snails_finished(current_state.positions) or finishing then
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
        driftwood.new_button("Join Race", "snailrace_join", true),
    })

    -- Clear state
    state.clear()
end

return logic
