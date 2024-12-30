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
    },

    -- A Charge Attack will move the snail forward 2 units and attack another 
    -- snail, which moves them 1 unit forward as well. This is beneficial to the
    -- snail but it does it does affect another snail positively as well which
    -- could cause you to lose.
    ["charge"] = {
        name = "Charge Attack",
        effects = {effects.FORWARD, effects.FORWARD, effects.ATTACK, effects.FORWARD},
        weight = 72
    },

    -- A Sticky Trap card will cause the snail to skip a turn, and cause another 
    -- snail to skip a turn as well. This is a neutral card that doesn't affect
    -- the snail playing it, but it does affect another snail negatively.
    ["sticky_trap"] = {
        name = "Sticky Trap",
        effects = {effects.SKIP, effects.ATTACK, effects.SKIP},
        weight = 40
    },

    -- A Double Attack card will cause the snail to move forward and attack 2 
    -- snails, moving them back 1 unit each. This is a high value card that
    -- benefits the snail playing it and affects two other snails negatively.
    ["double_attack"] = {
        name = "Double Attack",
        effects = {effects.FORWARD, effects.ATTACK, effects.BACK, effects.ATTACK, effects.BACK},
        weight = 85
    },

    -- A Slipstream card will cause the snail to move forward 2 units, attack 
    -- 2 other snails pushing them forward 1 unit
    ["slipstream"] = {
        name = "Slipstream",
        effects = {effects.FORWARD, effects.FORWARD, effects.ATTACK, effects.FORWARD, effects.ATTACK, effects.FORWARD},
        weight = 75
    },

    ["reverse_psychology"] = {
        name = "Reverse Psychology",
        effects = {effects.DEFEND, effects.BACK, effects.SKIP, effects.ATTACK, effects.BACK, effects.ATTACK, effects.BACK},
        weight = 55
    },

    -- A snail retracts into its shell to defend against incoming attacks.
    ["shell_shield"] = {
        name = "Shell Shield",
        effects = {effects.DEFEND, effects.SKIP},
        weight = 35
    },

    -- The snail leaves behind a slippery trail that slows down other racers.
    ["slime_trail"] = {
        name = "Slime Trail",
        effects = {effects.ATTACK, effects.SKIP},
        weight = 40
    },

    -- A luxury snail taxi service whisks the snail forward in style.
    ["escargot_express"] = {
        name = "Escargot Express",
        effects = {effects.FORWARD, effects.FORWARD, effects.FORWARD},
        weight = 95
    },
    
    -- The snail stumbles upon a lush garden and stops for a feast.
    ["garden_buffet"] = {
        name = "Garden Buffet",
        effects = {effects.SKIP, effects.BOOST},
        weight = 45
    },
    
    -- The snail conjures a storm of salt, forcing at least 3 snails to move back.
    ["salt_storm"] = {
        name = "Salt Storm",
        effects = {effects.ATTACK, effects.BACK, effects.ATTACK, effects.BACK, effects.ATTACK, effects.BACK,},
        weight = 90
    },

    -- The snail glides faster thanks to the morning dew’s slick surface.
    ["morning_dew"] = {
        name = "Morning Dew",
        effects = {effects.FORWARD, effects.BOOST},
        weight = 55
    },

    -- The snail stirs up a pile of compost, causing chaos among the racers.
    ["compost_chaos"] = {
        name = "Compost Chaos",
        effects = {effects.ATTACK, effects.SKIP, effects.ATTACK, effects.SKIP},
        weight = 35
    }
    
    
}

--- Get a card definition by name.
--- @param name string The name of the card.
--- @return Card|nil The card definition, or nil if not found.
cards.get = function(name)
    return cards.definitions[name]
end

return cards
