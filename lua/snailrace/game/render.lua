local constants = require("snailrace.core.constants")
local utils = require("snailrace.core.utils")

local render = {}


--- Generate gate markers based on their state.
---@param state table The current race state.
---@param track_length number The length of the track.
---@return string The track line with gates represented.
local function generate_track_with_gates(state, track_length)
    local track = ""
    local gate_positions = constants.GATES

    for i = 1, track_length do
        if utils.contains(gate_positions, i) then
            local gate_index = utils.index_of(gate_positions, i)
            if state.activated_gates[gate_index] then
                track = track .. "o" -- Activated gate
            else
                track = track .. "+" -- Closed gate
            end
        else
            track = track .. "-"
        end
    end

    return track
end

--- Generate a visual representation of the join state
--- @param state table The current race state.
--- @return string message The rendered join state as a string.
render.join_race = function(state)
    local entrants = "Entrants:\n"
    local lane_number = 1
    for player_id, _ in pairs(state.positions) do
        local name = state.participants[player_id]
        if name then
            entrants = entrants .. string.format("[%d] %s\n", lane_number, name)
        end
        lane_number = lane_number + 1
    end

    return "```State: Join...\n\n" .. entrants .. "```"
end

--- Generate a visual representation of the race.
--- @param state table The current race state.
--- @return string message The rendered race track as a string.
render.race_track = function(state)
    local track_length = constants.MAX_UNITS + 1 -- Include finish line
    local race_render = "```State: In Progress...\n"
    race_render = race_render .. "   " .. string.rep(" ", track_length) .. "🏁\n"
    race_render = race_render .. "  |" .. generate_track_with_gates(state, track_length) .. "|\n"

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

    race_render = race_render .. "  |" .. generate_track_with_gates(state, track_length) .. "|\n\n" .. entrants .. "```"
    return race_render
end

--- Generate a visual representation of a finished race.
--- @param state table The current race state.
--- @return string message The rendered race track as a string.
render.race_track_finish = function(state)
    local track_length = constants.MAX_UNITS + 1 -- Include finish line
    local race_render = "```State: Concluded\n   " .. string.rep(" ", track_length) .. "🏁\n"
    race_render = race_render .. "  |" .. generate_track_with_gates(state, track_length) .. "|\n"

    local lane_number = 1
    local entrants = "Entrants:\n"
    for player_id, position in pairs(state.positions) do
        local name = state.participants[player_id]
        local place = state.finish_order[player_id]

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
            entrants = entrants .. string.format("[%d] %s", lane_number, name)
            if place == 1 then
                entrants = entrants .. " 🥇"
            elseif place == 2 then
                entrants = entrants .. " 🥈"
            elseif place == 3 then
                entrants = entrants .. " 🥉"
            end
            entrants = entrants .. "\n"
        end

        lane_number = lane_number + 1
    end

    race_render = race_render .. "  |" .. generate_track_with_gates(state, track_length) .. "|\n\n" .. entrants .. "```"
    return race_render
end

return render
