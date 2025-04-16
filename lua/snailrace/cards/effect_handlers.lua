local driftwood = require("driftwood")
local constants = require("snailrace.core.constants")
local utils = require("snailrace.core.utils")
local effects = require("snailrace.cards.card_effects")

local handlers = {}

--- Process a move effect.
---@param amount number The number of spaces to move.
---@param snail_id string The snail's ID.
---@param state table The race state.
handlers.move = function(amount, snail_id, state)
    state.positions[snail_id] = (state.positions[snail_id] or 0) + amount

    -- Clamp the position to the maximum units
    if state.positions[snail_id] > constants.MAX_UNITS then
        state.positions[snail_id] = constants.MAX_UNITS
    end

    -- Clamp the position to the minimum units
    if state.positions[snail_id] < 0 then
        state.positions[snail_id] = 0
    end
end

--- Process a boost effect.
---@param snail_id string The snail's ID.
---@param state table The race state.
handlers.boost = function(snail_id, state)
    state.boosts = state.boosts or {}

    -- Check if the snail is already boosted
    if state.boosts[snail_id] then
        driftwood.log.debug("Snail " .. snail_id .. " is already boosted.")
        return
    end

    state.boosts[snail_id] = true -- Mark the snail as boosted with the current card's effects
end

--- Process an attack effect.
---@param snail_id string The attacking snail's ID.
---@param card_effects string[] The full effects of the card.
---@param state table The race state.
handlers.attack = function(snail_id, card_effects, state)
    local target_id

    if not target_id then
        driftwood.log.debug("Snail " .. snail_id .. " has no valid targets to attack.")
        return
    end

    -- Ensure the target is still racing
    if state.finish_order[target_id] then
        driftwood.log.debug("Snail " ..
        snail_id .. " tried to attack snail " .. target_id .. ", but it has already finished.")
        return
    end

    -- Check if the target is defending against this effect
    state.defends = state.defends or {}
    if state.defends[target_id] and utils.has_matching_effects(state.defends[target_id], card_effects) then
        state.defends[target_id] = nil -- Remove the defense

        driftwood.log.debug("Snail " .. target_id .. " defended against the attack from " .. snail_id .. ".")
        return -- Attack blocked
    end

    driftwood.log.debug("Snail " ..
    snail_id .. " is attacking snail " .. target_id .. " with " .. table.concat(card_effects, ", ") .. ".")

    -- Apply all secondary effects (e.g., "back", "skip") to the target
    for i, effect in ipairs(card_effects) do
        if effect == effects.ATTACK then
            handlers.attack(snail_id, { utils.unpack(card_effects, i + 1, nil) }, state)
        elseif effect == effects.DEFEND then
            handlers.defend(snail_id, { utils.unpack(card_effects, i + 1, nil) }, state)
        elseif effect == effects.SKIP then
            state.skips = state.skips or {}

            if state.skips[target_id] then
                driftwood.log.debug("Snail " .. target_id .. " is already forced to skip.")
                return
            end

            state.skips[target_id] = true
        else
            handlers.process(effect, snail_id, state)
        end
    end
end

--- Process a defend effect.
---@param snail_id string The snail's ID.
---@param card_effects string[] The full effects of the card.
---@param state table The race state.
handlers.defend = function(snail_id, card_effects, state)
    state.defends = state.defends or {}
    local processed_effects = {}

    if state.defends[snail_id] then
        processed_effects = state.defends[snail_id]
    end

    for i, effect in ipairs(card_effects) do
        if effect == effects.ATTACK then
            handlers.attack(snail_id, { utils.unpack(card_effects, i + 1, nil) }, state)
            break
        elseif effect ~= effects.DEFEND then
            handlers.process(effect, snail_id, state)
            table.insert(processed_effects, effect)
        end
    end

    state.defends[snail_id] = processed_effects -- Store the defense effects for the snail
    driftwood.log.debug("Snail " .. snail_id .. " is defending against " .. table.concat(processed_effects, ", ") .. ".")
end


--- Process a card effect.
---@param effect string The individual effect to process.
---@param snail_id string The snail's ID.
---@param state table The race state.
handlers.process = function(effect, snail_id, state)
    if effect == effects.FORWARD then
        handlers.move(1, snail_id, state)
        driftwood.log.debug("Snail " .. snail_id .. " moved " .. 1 .. " spaces.")
    elseif effect == effects.BACK then
        handlers.move(-1, snail_id, state)
        driftwood.log.debug("Snail " .. snail_id .. " moved " .. -1 .. " spaces.")
    elseif effect == effects.SKIP then
        -- Skip logic: Do nothing
        driftwood.log.debug("Snail " .. snail_id .. " skipped a turn.")
    elseif effect == effects.BOOST then
        handlers.boost(snail_id, state)
        driftwood.log.debug("Snail " .. snail_id .. " is boosted.")
    end
end

--- Process a full card's effects.
--- If an ATTACK or DEFEND effect is encountered, the unprocessed effects are passed to the respective handler.
---@param card_effects string[] The full effects of the card.
---@param snail_id string The snail's ID.
---@param state table The race state.
handlers.process_card = function(card_effects, snail_id, state)
    local processed_effects = {}
    local processed = 0
    local repeats = 1

    -- Check if snail is boosted, if so, double the effects
    if state.boosts and state.boosts[snail_id] then
        repeats = 2
        driftwood.log.info("Snail " .. snail_id .. " card is boosted")
        state.boosts[snail_id] = nil -- Remove the boost
    end

    if state.skips and state.skips[snail_id] then
        driftwood.log.debug("Snail " .. snail_id .. " forced to skip a turn.")
        state.skips[snail_id] = nil -- Remove the skip
        return
    end

    repeat
        processed_effects = {} -- Reset the processed effects
        for i, effect in ipairs(card_effects) do
            -- If attack or defend is encountered, stop processing and send remaining effects to the handler
            if effect == effects.ATTACK then
                handlers.attack(snail_id, { utils.unpack(card_effects, i + 1, nil) }, state)
            elseif effect == effects.DEFEND then
                handlers.defend(snail_id, { utils.unpack(card_effects, i + 1, nil) }, state)
            else
                -- Process non-attack/defend effects immediately
                handlers.process(effect, snail_id, state)
                table.insert(processed_effects, effect)
            end
        end

        processed = processed + 1
    until processed >= repeats
end

return handlers
