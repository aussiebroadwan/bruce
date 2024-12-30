local constants = require("snailrace.constants")

local render = {}

--- Generate a visual representation of the race.
--- @param state table The current race state.
--- @return string The rendered race track as a string.
render.race_track = function(state)
    local track_length = constants.MAX_UNITS + 1 -- Include finish line
    local race_render = "```\n   " .. string.rep(" ", track_length) .. "🏁\n"
    race_render = race_render .. "  |" .. string.rep("-", track_length) .. "|\n"

    local lane_number = 1
    local entrants = "Entrants:\n"
    for player_id, position in pairs(state.positions) do
        local name = state.participants[player_id]

        -- Determine the track visualization
        local trail = string.rep(".", position) -- Trail stops at the last spot before finish
        local finish_display = ""

        if position >= constants.MAX_UNITS then
            -- Show the snail's place if it has finished
            finish_display = " " .. tostring(state.finish_order[player_id] or "?")
        else
            -- Otherwise, show the remaining track and the finish line
            finish_display = string.rep(" ", (constants.MAX_UNITS - 1) - position) .. "|"
        end

        race_render = race_render .. string.format("%2d| %s🐌%s\n", lane_number, trail, finish_display)

        if name then
            entrants = entrants .. string.format("[%d] %s\n", lane_number, name)
        end

        lane_number = lane_number + 1
    end

    race_render = race_render .. "  |" .. string.rep("-", track_length) .. "|\n\n" .. entrants .. "```"
    return race_render
end

return render
