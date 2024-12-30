local effects = require("snailrace.core.card_effects")

---@class Card
---@field name string          # Unique identifier for the card
---@field effects string[] # Array of effects applied when the card is played
---@field weight number        # Probability weight of the card in the deck

local cards = {}

--- Define available cards.
---@type table<string, Card>
cards.definitions = {
    ["move"] = {
        name = "Move 1",
        effects = {effects.FORWARD},
        weight = 60
    },
    ["move_2"] = {
        name = "Move 2",
        effects = {effects.FORWARD, effects.FORWARD},
        weight = 80
    },
    ["back"] = {
        name = "Move Back 1",
        effects = {effects.BACK},
        weight = 30
    },
    ["back_2"] = {
        name = "Double Back",
        effects = {effects.BACK, effects.BACK},
        weight = 10
    },
    ["skip"] = {
        name = "skip",
        effects = {effects.SKIP},
        weight = 40,
    },
    ["boost"] = {
        name = "Turbo Boost",
        effects = {effects.BOOST},
        weight = 50
    },
    ["attack_back"] = {
        name = "Attack",
        effects = {effects.ATTACK, effects.BACK},
        weight = 20
    },
    ["defend_back"] = {
        name = "Defend",
        effects = {effects.DEFEND, effects.BACK},
        weight = 20
    },
    ["push_ahead"] = {
        name = "Push Ahead",
        effects = {effects.FORWARD, effects.DEFEND, effects.BACK, effects.SKIP},
        weight = 80
    }

}

--- Get a card definition by name.
--- @param name string The name of the card.
--- @return Card|nil The card definition, or nil if not found.
cards.get = function(name)
    return cards.definitions[name]
end

return cards
