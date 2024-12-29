local utils = require("snailrace.utils")
local constants = require("snailrace.constants")

local racers = {}

--- Add fake racers to the race.
-- @param state table The current race state.
racers.add_fake_racers = function(state)
    for i, name in ipairs(constants.FAKE_RACERS) do
        local fake_id = "fake_" .. i
        state.participants[fake_id] = name
        state.positions[fake_id] = 0
    end
end

--- Build and shuffle the race deck.
-- @param state table The current race state.
racers.build_deck = function(state)
    state.deck = {}
    for player_id in pairs(state.participants) do
        for _ = 1, 32 do
            table.insert(state.deck, player_id)
        end
    end
    utils.shuffle(state.deck)
end

return racers
