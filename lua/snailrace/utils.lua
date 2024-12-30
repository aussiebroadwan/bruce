local utils = {}

--- Shuffle a table in place.
--- @param tbl table The table to shuffle.
utils.shuffle = function(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
end

return utils
