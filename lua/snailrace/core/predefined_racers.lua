
local predefined = {}

--- @class Racer
--- @field name string The name of the racer.
--- @field deck_preset string The deck preset to use for the racer.
--- @field history number[] The last 5 placements of the racer.

-- Predefined bot racers
--- @type table<string, Racer>
predefined.RACERS = {
    ["bot_snail_001"] = {
        name = "Granite Grump",
        deck_preset = "steady_racer", -- Uses the steady racer deck preset
        history = {} -- History of race participation and results
    },
    ["bot_snail_002"] = {
        name = "Flashy Floater",
        deck_preset = "speedster", -- Uses the speedster deck preset
        history = {}
    },
    ["bot_snail_003"] = {
        name = "Rockslide Rudy",
        deck_preset = "aggressive_attacker", -- Uses the aggressive attacker deck preset
        history = {}
    },
    ["bot_snail_004"] = {
        name = "Turbo Tom",
        deck_preset = "risky_gambler", -- Uses the risky gambler deck preset
        history = {}
    },
    ["bot_snail_005"] = {
        name = "Shielded Shelly",
        deck_preset = "defensive_strategist", -- Uses the defensive strategist deck preset
        history = {}
    },
    ["bot_snail_006"] = {
        name = "Sprinter Sandy",
        deck_preset = "sprinter", -- Uses the sprinter deck preset
        history = {}
    },
    ["bot_snail_007"] = {
        name = "Balanced Bob",
        deck_preset = "balanced_runner", -- Uses the balanced runner deck preset
        history = {}
    },
    ["bot_snail_008"] = {
        name = "Disruptor Dan",
        deck_preset = "disruptor", -- Uses the disruptor deck preset
        history = {}
    },
    ["bot_snail_009"] = {
        name = "Cautious Carla",
        deck_preset = "opportunist", -- Uses the opportunist deck preset
        history = {}
    },
    ["bot_snail_010"] = {
        name = "Risky Ricky",
        deck_preset = "risk_taker", -- Uses the risk taker deck preset
        history = {}
    },
    ["bot_snail_011"] = {
        name = "Slippery Sam",
        deck_preset = "slime_master", -- Uses the slime master deck preset
        history = {}
    },
    ["bot_snail_012"] = {
        name = "Zooming Zelda",
        deck_preset = "turbo_charger", -- Uses the turbo charger deck preset
        history = {}
    },
    ["bot_snail_013"] = {
        name = "Chaos Carl",
        deck_preset = "chaos_creator", -- Uses the chaos creator deck preset
        history = {}
    },
    ["bot_snail_014"] = {
        name = "Defensive Dave",
        deck_preset = "defensive_crawler", -- Uses the defensive crawler deck preset
        history = {}
    },
    ["bot_snail_015"] = {
        name = "Trailblazing Tina",
        deck_preset = "trailblazer", -- Uses the trailblazer deck preset
        history = {}
    },
    ["bot_snail_016"] = {
        name = "Tricky Trevor",
        deck_preset = "trickster", -- Uses the trickster deck preset
        history = {}
    },
    ["bot_snail_017"] = {
        name = "Powerful Pete",
        deck_preset = "power_snail", -- Uses the power snail deck preset
        history = {}
    },
    ["bot_snail_018"] = {
        name = "Sneaky Stella",
        deck_preset = "opportunist_stalker", -- Uses the opportunist stalker deck preset
        history = {}
    },
    ["bot_snail_019"] = {
        name = "Speedy Steve",
        deck_preset = "speed_demon", -- Uses the speed demon deck preset
        history = {}
    },
    ["bot_snail_020"] = {
        name = "Saboteur Sally",
        deck_preset = "saboteur", -- Uses the saboteur deck preset
        history = {}
    }
}

return predefined