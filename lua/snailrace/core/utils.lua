local utils = {}

--- Shuffle a table in place.
--- @param tbl table The table to shuffle.
utils.shuffle_table = function(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

--- Count the number of elements in a table.
--- @param tbl table The table to count.
--- @return number count The number of elements in the table.
utils.table_length = function(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end

--- Get the keys of a table as an array.
--- @param tbl table The table to get keys from.
--- @return table keys The keys of the table.
utils.keys = function(tbl)
    local k = {}
    for key, _ in pairs(tbl) do
        table.insert(k, key)
    end
    return k
end

--- Dump a table to a string.
--- @param tbl table The table to dump.
--- @return string table_string The table as a string.
utils.dump = function(tbl)
    if type(tbl) == 'table' then
       local s = '{ '
       for k,v in pairs(tbl) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. utils.dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(tbl)
    end
end


--- Check if two lists of effects have matching elements.
---@param effects1 string[] The first list of effects.
---@param effects2 string[] The second list of effects.
---@return boolean True if there is a match, false otherwise.
utils.has_matching_effects = function(effects1, effects2)
    for _, effect1 in ipairs(effects1) do
        for _, effect2 in ipairs(effects2) do
            if effect1 == effect2 then
                return true
            end
        end
    end
    return false
end

--- Get a random target excluding the given snail ID.
---@param excluded_id string The ID to exclude.
---@param positions table<string, number> The positions of all snails.
---@return string|nil The ID of a random target, or nil if no valid targets exist.
utils.get_random_target = function(excluded_id, positions)
    local targets = {}
    for id, _ in pairs(positions) do
        if id ~= excluded_id then
            table.insert(targets, id)
        end
    end

    if #targets == 0 then
        return nil -- No valid targets
    end

    return targets[math.random(#targets)]
end


--- Mimic the behavior of table.unpack to unpack elements from a table.
--- @param tbl table The table to unpack.
--- @param start number The starting index for unpacking (default: 1).
--- @param stop number|nil The ending index for unpacking (default: #tbl).
--- @return ... Returns the unpacked elements.
utils.unpack = function(tbl, start, stop)
    start = start or 1
    stop = stop or #tbl

    if start > stop then
        return -- Base case: no elements to unpack
    else
        return tbl[start], utils.unpack(tbl, start + 1, stop) -- Recursive unpacking
    end
end

--- Check if a value exists in a table.
---@param tbl table The table to search.
---@param value any The value to check for.
---@return boolean exists True if the value exists, otherwise false.
utils.contains = function(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

--- Find the index of a value in a table.
---@param tbl table The table to search.
---@param value any The value to find.
---@return number|nil index The index of the value, or nil if not found.
utils.index_of = function(tbl, value)
    for index, v in ipairs(tbl) do
        if v == value then
            return index
        end
    end
    return nil
end

return utils
