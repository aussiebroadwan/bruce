local constants = {}

-- State key for storing race data
constants.STATE_KEY = "snailrace_state"

-- Button interaction ID for joining the race
constants.BUTTON_JOIN_ID = "snailrace_join"

-- Maximum number of units to the finish line
constants.MAX_UNITS = 20

-- Gates positioned at specific units
constants.GATES = {5, 10, 15}

-- Predefined fake racers
constants.FAKE_RACERS = {"Turbo the Snail", "Speedy Slimy", "Shellshock"}

return constants
