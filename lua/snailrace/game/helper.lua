local driftwood = require("driftwood")

local constants = require("snailrace.core.constants")
local cards = require("snailrace.cards.cards")
local handlers = require("snailrace.cards.effect_handlers")
local racers = require("snailrace.game.racers")

local helpers = {}

--- Check if all snails have finished the race.
---@param positions table<string, number> Snail positions.
---@return boolean result True if all snails have finished, otherwise false.
helpers.all_snails_finished = function(positions)
    for _, position in pairs(positions) do
        if position < constants.MAX_UNITS then
            return false
        end
    end
    return true
end

--- Rebuild and reshuffle the deck if required.
---@param current_state table The current race state.
---@return boolean result True if the race should finish due to exceeding redraw limits.
helpers.handle_deck_rebuild = function(current_state)
    if #current_state.deck <= current_state.deck_size_threshold then
        driftwood.log.info("Deck size below threshold. Rebuilding and reshuffling.")
        racers.build_deck(current_state)
        current_state.redraws = current_state.redraws + 1
        if current_state.redraws >= constants.MAX_REDRAW_ATTEMPTS then
            driftwood.log.info("Max redraw limit reached. Stopping the race.")
            return true
        end
    end
    return false
end

--- Draw a valid card from the deck.
---@param current_state table The current race state.
---@return table|nil card The drawn card or nil if no valid cards remain.
helpers.draw_valid_card = function(current_state)
    local drawn_card
    repeat
        if #current_state.deck == 0 then
            driftwood.log.info("Deck is empty. Rebuilding and reshuffling.")
            racers.build_deck(current_state)
            current_state.redraws = current_state.redraws + 1
            if current_state.redraws >= constants.MAX_REDRAW_ATTEMPTS then
                return nil
            end
        end
        drawn_card = table.remove(current_state.deck, 1)
    until not drawn_card or current_state.positions[drawn_card.snail_id] < constants.MAX_UNITS
    return drawn_card
end

--- Draw three gate cards at the start of the race.
---@param current_state table The current race state.
helpers.draw_gate_cards = function(current_state)
    for i = 1, #constants.GATES do
        local gate_card = table.remove(current_state.deck, 1)
        if gate_card then
            table.insert(current_state.gates, gate_card)
        else
            driftwood.log.error("Not enough cards in the deck to assign gate cards.")
        end
    end
end

--- Activate the gate card effect.
---@param gate_index number The index of the gate.
---@param current_state table The current race state.
helpers.activate_gate_card = function(gate_index, current_state)
    if current_state.activated_gates[gate_index] then
        return -- Gate card already activated
    end

    local gate_card = current_state.gates[gate_index]
    if not gate_card then
        driftwood.log.error("No gate card found for gate index " .. gate_index)
        return
    end

    -- Mark gate as activated
    current_state.activated_gates[gate_index] = true

    -- Get the card definition
    local card = cards.get(gate_card.card)
    if not card then
        driftwood.log.error("Gate card not found: " .. gate_card.card)
        return
    end

    driftwood.log.info("Activating gate card at gate " ..
    constants.GATES[gate_index] .. ": " .. card.name .. " for snail " .. gate_card.snail_id)
    handlers.process_card(card.effects, gate_card.snail_id, current_state)
end

return helpers
