local driftwood = require("driftwood")

local constants = require("snailrace.constants")

local state = {}

--- Get the current race state.
--- @return table|nil The current race state, or nil if none exists.
state.get = function()
    return driftwood.state.get(constants.STATE_KEY)
end

--- Set the race state.
--- @param new_state table The new state to save.
state.set = function(new_state)
    driftwood.state.set(constants.STATE_KEY, new_state)
end

--- Clear the race state.
state.clear = function()
    driftwood.state.clear(constants.STATE_KEY)
end

return state
