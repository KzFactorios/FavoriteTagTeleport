local wutils = {}

local next = next

--- finds the next empty element to the left in the given table
--- returns nil if no empty element found
--- start from given index or last index if not provided
function wutils.find_next_empty_left_index(tbl, start)
    if type(tbl) ~= "table" then return nil end

    local idx = start or #tbl
    idx = idx - 1

    while idx > 0 do
        if next(tbl[idx]) == nil then
            return idx
        end
        idx = idx - 1
    end

    return nil
end

--- finds the next empty element to the right in the given table
--- returns nil if no empty element found
--- start from given index or 0 if not provided
function wutils.find_next_empty_right_index(tbl, start)
    if type(tbl) ~= "table" then return nil end

    local idx = start or 0
    local end_tbl = #tbl
    idx = idx + 1

    while idx <= end_tbl do
        if next(tbl[idx]) == nil then
            return idx
        end
        idx = idx + 1
    end

    return nil
end

function wutils.find_element_by_key_and_value(tbl, key, value)
    if type(tbl) ~= "table" then return nil end

    if tbl and #tbl > 0 then
        for i, element in pairs(tbl) do
            if element[key] and element[key] == value then
                return element, i
            end
        end
    end
    return nil
end

function wutils.array_filter(array, predicate)
    local result = {}
    local result_index = 1
    for i, value in pairs(array) do
      if predicate(value, i) then
        result[result_index] = value
        result_index = result_index + 1
      end
    end
    return result
end

function wutils.find_index_of_value(tbl, value)
    if type(tbl) ~= "table" then return nil end

    for i, v in ipairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end

-- TODO is it necessary to pass in the key?
--- Given a position object {x = xxx, y = yyy}
--- find the matching element in the supplied table
--- @returns position, nil 
function wutils.find_element_by_position(tbl, key, pos)
    if type(tbl) ~= "table" or type(pos) ~= "table" then return nil end
    for _, element in pairs(tbl) do
        if element and type(element) == "table" and element.valid ~= false and element[key] ~= nil then
            local epos = element[key]
            if type(epos) == "table" and epos.x ~= nil and epos.y ~= nil then
                local px = tostring(pos.x)
                local py = tostring(pos.y)
                if (tostring(epos.x) == px and tostring(epos.y) == py)
                    or (tonumber(epos.x) == tonumber(pos.x) and tonumber(epos.y) == tonumber(pos.y))
                then
                    return element
                end
            end
        end
    end
    return nil
end

-- TODO is it necessary to pass in the key?
--- Given a position object {x = xxx, y = yyy}
--- find the matching tag element index in the supplied tag table
--- @returns number, -1 
function wutils.find_tag_element_idx_by_position(tbl, key, pos, check_validity)
    if key == nil or pos == nil then return -1 end
    if type(tbl) ~= "table" or type(pos) ~= "table" then return -1 end
    for idx, element in pairs(tbl) do
        if (not check_validity or (element.valid ~= false)) and type(element) == "table" and element[key] ~= nil then
            local epos = element[key]
            if type(epos) == "table" and epos.x ~= nil and epos.y ~= nil then
                local px = tostring(pos.x)
                local py = tostring(pos.y)
                if (tostring(epos.x) == px and tostring(epos.y) == py)
                    or (tonumber(epos.x) == tonumber(pos.x) and tonumber(epos.y) == tonumber(pos.y))
                then
                    return idx
                end
            end
        end
    end
    return -1
end

--- The name says it all
--- @returns boolean
function wutils.table_contains_key(t, key)
    if type(t) ~= "table" then return false end

    for k, v in pairs(t) do
        if k == key or v == key then
            return true
        end
    end
    return false
end

--- remove the element and shift the remaining elements down
function wutils.remove_element(tbl, key)
    if type(tbl) ~= "table" then
        error("Invalid arguments: expected (table)")
    end

    local index = nil
    for i, v in ipairs(tbl) do
        if v == key then
            index = i
            break
        end
    end
    -- If the element was found, shift elements to retain order
    if index then
        for i = index, #tbl - 1 do
            tbl[i] = tbl[i + 1]
        end
        tbl[#tbl] = nil -- Remove the last element (duplicate after shifting)
    end
end

function wutils.get_element_index(t, key, value)
    if type(t) ~= "table" then return -1 end

    for i = 1, #t do
        local match = t[i]
        if (match ~= nil or (type(match) == "table" and next(match) ~= nil)) and
            match[key] == value then
            return i
        end
    end
    return -1
end

function wutils.limit_text(inp, limit)
    if string.len(inp) < limit then return inp end

    return string.sub(inp, 1, limit) .. "..."
end

function wutils.starts_with(haystack, needle)
    return haystack:sub(1, #needle) == needle
end


-- http://lua-users.org/wiki/StringTrim

--function trim12(s)
function wutils.trim(s)
    local from = s:match "^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end

-- Compatibility: Lua-5.1
function wutils.split(str, pat)
    local t = {} -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function wutils.split_path(str)
    return wutils.split(str, '[\\/]+')
end

return wutils