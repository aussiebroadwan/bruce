local constants = {}

-- State key for storing race data
constants.STATE_KEY = "snailrace_state"

-- Button interaction ID for joining the race
constants.BUTTON_JOIN_ID = "snailrace_join"

-- Maximum number of units to the finish line
constants.MAX_UNITS = 20

constants.MIN_PARTICIPANTS = 4

constants.MAX_REDRAW_ATTEMPTS = 3

-- Gates positioned at specific units
constants.GATES = {5, 10, 15}

-- Predefined fake racers
constants.FAKE_RACERS = {"Turbo the Snail", "Speedy Slimy", "Shellshock"}
constants.RACERS = {
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
    }
}

-- Tick speed
constants.TICK_SPEED = 1 -- seconds
constants.JOIN_DURATION = 5 -- seconds

constants.DECK_THRESHOLD_PERCENT = 0.2

return constants
