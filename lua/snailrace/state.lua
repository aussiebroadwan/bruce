local driftwood = require("driftwood")

local constants = require("snailrace.core.constants")

local state = {}

--- Initialize the race state.
---@param host_id string The host's user ID.
---@param channel_id string The channel where the race is hosted.
---@param interaction CommandInteraction The interaction data from Discord.
---@return table current_state The initialized state.
state.initialize = function(host_id, channel_id, interaction)
    return {
        host = host_id,
        channel_id = channel_id,
        participants = { [host_id] = interaction.user.global_name },
        positions = { [host_id] = 0 },
        finish_order = {},    -- Track the finishing order
        deck = {},            -- The race deck
        boosts = {},          -- Tracks active boosts
        defends = {},         -- Tracks active defense effects
        gates = {},           -- Gate cards drawn at the start
        activated_gates = {}, -- Track activated gates
        gate_index = 1,       -- Current gate to check
        active = true,
        message_id = nil,
        deck_size_threshold = 0,
        redraws = 0,
    }
end

--- Get the current race state.
--- @return table|nil value The current race state, or nil if none exists.
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
