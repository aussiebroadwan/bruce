local constants = {}

-- General race configuration
constants.STATE_KEY = "snailrace_state"     -- State key for storing race data
constants.BUTTON_JOIN_ID = "snailrace_join" -- Button interaction ID for joining the race
constants.MAX_UNITS = 20                    -- Maximum number of units to the finish line
constants.MIN_PARTICIPANTS = 4              -- Minimum participants required to start a race
constants.MAX_REDRAW_ATTEMPTS = 3           -- Maximum attempts to redraw a card

-- Timing configuration
constants.TICK_SPEED = 1    -- Tick speed in seconds
constants.JOIN_DURATION = 5 -- Join phase duration in seconds

-- Deck configuration
constants.DECK_THRESHOLD_PERCENT = 0.2 -- Threshold to reshuffle the deck when 20% of cards remain

-- Gates positioned at specific units
constants.GATES = { 5, 10, 15 }

return constants
