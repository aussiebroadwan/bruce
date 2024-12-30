local utils = require("snailrace.core.utils")
local constants = require("snailrace.core.constants")
local decks = require("snailrace.core.decks")

local racers = {}

--- Add fake racers to the race.
--- @param state table The current race state.
racers.add_fake_racers = function(state)
    local required_slots = constants.MIN_PARTICIPANTS - utils.table_length(state.participants)
    local fake_racer_ids = utils.keys(constants.RACERS)

    -- Shuffle the fake racer IDs to randomize selection
    utils.shuffle_table(fake_racer_ids)

    for i = 1, required_slots do
        local fake_id = fake_racer_ids[i]
        if not fake_id then break end -- No more predefined racers available

        local racer = constants.RACERS[fake_id]
        if racer then
            state.participants[fake_id] = racer.name
            state.positions[fake_id] = 0
        end
    end
end

--- Build and shuffle the race deck.
--- Each card in the deck is represented as `{ snail_id = string, card = string }`.
--- @param state table The current race state.
racers.build_deck = function(state)
    state.deck = {}
    for snail_id, _ in pairs(state.participants) do
        -- Retrieve the racer's unique deck
        local racer_deck = racers.get_deck(snail_id)
        for _, card_name in ipairs(racer_deck) do
            table.insert(state.deck, {snail_id = snail_id, card = card_name})
        end
    end
    utils.shuffle_table(state.deck)

    -- Set the reshuffle threshold (20% of the total deck size)
    state.deck_size_threshold = math.ceil(#state.deck * constants.DECK_THRESHOLD_PERCENT)
end

--- Retrieve a racer's unique deck.
--- If the racer has a `deck_preset`, use the preset deck; otherwise, load a random deck.
--- @param snail_id string The ID of the racer.
--- @return string[] The racer's deck of card names.
racers.get_deck = function(snail_id)
    local racer_definition = constants.RACERS[snail_id]
    if racer_definition then
        if racer_definition.deck_preset then
            return decks.load_deck(racer_definition.deck_preset) -- Generate the deck from the preset
        end
    end

    -- If no deck preset, load a random deck
    return decks.load_random_deck()
end


--- Record a racer's finish placement.
--- Keeps track of the last 5 placements.
--- @param snail_id string The ID of the snail.
--- @param placement number The placement in the race.
racers.record_placement = function(snail_id, placement)
    local racer_definition = constants.RACERS[snail_id]
    if racer_definition then
        table.insert(racer_definition.history, placement)
        if #racer_definition.history > 5 then
            table.remove(racer_definition.history, 1) -- Keep the last 5 placements
        end
    end
end

return racers
