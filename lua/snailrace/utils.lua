local utils = {}

--- Shuffle a table in place.
--- @param tbl table The table to shuffle.
utils.shuffle = function(tbl)
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

return utils
