local driftwood = require("driftwood")

local state = require("snailrace.state")
local constants = require("snailrace.core.constants")
local utils = require("snailrace.core.utils")
local cards = require("snailrace.cards.cards")
local handlers = require("snailrace.cards.effect_handlers")
local render = require("snailrace.game.render")
local racers = require("snailrace.game.racers")

local logic = {}

--- Check if all snails have finished the race.
---@param positions table<string, number> Snail positions.
---@return boolean result True if all snails have finished, otherwise false.
local function all_snails_finished(positions)
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
local function handle_deck_rebuild(current_state)
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
local function draw_valid_card(current_state)
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
local function draw_gate_cards(current_state)
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
local function activate_gate_card(gate_index, current_state)
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

    driftwood.log.info("Activating gate card at gate " .. constants.GATES[gate_index] .. ": " .. card.name)
    handlers.process_card(card.effects, gate_card.snail_id, current_state)
end

--- Perform a single race tick.
logic.race_tick = function()
    local current_state = state.get()
    if not current_state or not current_state.active then
        driftwood.log.info("Race ended early.")
        return
    end

    -- Handle deck rebuild and check for finish conditions
    if handle_deck_rebuild(current_state) then
        logic.finish_race()
        return
    end

    -- Draw a valid card
    local drawn_card = draw_valid_card(current_state)
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
            activate_gate_card(current_state.gate_index, current_state)
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
        driftwood.new_button("Join Race", "snailrace_join", true),
    })

    state.set(current_state)

    -- Check if all snails have finished
    if all_snails_finished(current_state.positions) then
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
    draw_gate_cards(start_state)

    state.set(start_state)
    logic.race_tick()
end


return logic
