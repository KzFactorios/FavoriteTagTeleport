local wutils = {}

local next = next

--- Finds the next empty element to the left in the given table
--- @param tbl table
--- @param start integer?
--- @return integer|nil
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

--- Finds the next empty element to the right in the given table
--- @param tbl table
--- @param start integer?
--- @return integer|nil
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

--- Finds the first element in a table where element[key] == value
--- @param tbl table
--- @param key string
--- @param value any
--- @return table|nil, integer|nil
function wutils.find_element_by_key_and_value(tbl, key, value)
  if type(tbl) ~= "table" then return nil, nil end
  if tbl and #tbl > 0 then
    for i, element in pairs(tbl) do
      if element[key] and element[key] == value then
        return element, i
      end
    end
  end
  return nil, nil
end

--- Filters an array by a predicate function
--- Example usage:
---   local even = wutils.array_filter({1,2,3,4}, function(v) return v % 2 == 0 end)
---   -- even = {2, 4}
--- @param array table
--- @param predicate fun(value:any, index:integer):boolean
--- @return table
function wutils.array_filter(array, predicate)
  local result = {}
  local result_index = 1
  for i, value in ipairs(array) do
    if predicate(value, i) then
      result[result_index] = value
      result_index = result_index + 1
    end
  end
  return result
end

--- Finds the index of a value in a table (array part)
--- @param tbl table
--- @param value any
--- @return integer|nil
function wutils.find_index_of_value(tbl, value)
  if type(tbl) ~= "table" then return nil end
  for i, v in ipairs(tbl) do
    if v == value then
      return i
    end
  end
  return nil
end

--- Finds an element by position in a table
--- @param tbl table
--- @param key string
--- @param pos table
--- @return table|nil
function wutils.find_element_by_position(tbl, key, pos)
  if type(tbl) ~= "table" or type(pos) ~= "table" then return nil end
  for _, element in pairs(tbl) do
    if element and type(element) == "table" and element.valid ~= false and element[key] ~= nil then
      local epos = element[key]
      if type(epos) == "table" and epos.x ~= nil and epos.y ~= nil then
        if tonumber(epos.x) == tonumber(pos.x) and tonumber(epos.y) == tonumber(pos.y) then
          return element
        end
      end
    end
  end
  return nil
end

--- Finds the index of a tag element by position
--- @param tbl table
--- @param key string
--- @param pos table
--- @param check_validity boolean?
--- @return integer
function wutils.find_tag_element_idx_by_position(tbl, key, pos, check_validity)
  if key == nil or pos == nil then return -1 end
  if type(tbl) ~= "table" or type(pos) ~= "table" then return -1 end
  for idx, element in pairs(tbl) do
    if (not check_validity or (element.valid ~= false)) and type(element) == "table" and element[key] ~= nil then
      local epos = element[key]
      if type(epos) == "table" and epos.x ~= nil and epos.y ~= nil then
        if tonumber(epos.x) == tonumber(pos.x) and tonumber(epos.y) == tonumber(pos.y) then
          return idx
        end
      end
    end
  end
  return -1
end

--- Checks if a table contains a key or value
--- @param t table
--- @param key any
--- @return boolean
function wutils.table_contains_key(t, key)
  if type(t) ~= "table" then return false end
  for k, v in pairs(t) do
    if k == key or v == key then
      return true
    end
  end
  return false
end

--- Removes an element from an array and shifts remaining elements down
--- @param tbl table
--- @param key any
function wutils.remove_element(tbl, key)
  if type(tbl) ~= "table" or key == nil then
    error("Invalid arguments: expected (table, key)")
  end
  local index = nil
  for i, v in ipairs(tbl) do
    if v == key then
      index = i
      break
    end
  end
  if index then
    for i = index, #tbl - 1 do
      tbl[i] = tbl[i + 1]
    end
    tbl[#tbl] = nil
  end
end

--- Gets the index of an element in an array by key/value
--- @param t table
--- @param key string
--- @param value any
--- @return integer
function wutils.get_element_index(t, key, value)
  if type(t) ~= "table" then return -1 end
  for i = 1, #t do
    local match = t[i]
    if (match ~= nil or (type(match) == "table" and next(match) ~= nil)) and match[key] == value then
      return i
    end
  end
  return -1
end

--- Limits text to a given length, appending ... if truncated
--- @param inp string
--- @param limit integer
--- @return string
function wutils.limit_text(inp, limit)
  if string.len(inp) < limit then return inp end
  return string.sub(inp, 1, limit) .. "..."
end

--- Checks if a string starts with a given substring
--- @param haystack string
--- @param needle string
--- @return boolean
function wutils.starts_with(haystack, needle)
  return haystack:sub(1, #needle) == needle
end

--- Trims whitespace from both ends of a string
--- @param s string
--- @return string
function wutils.trim(s)
  local from = s:match "^%s*()"
  return from > #s and "" or s:match(".*%S", from)
end

--- Splits a string by a pattern
--- @param str string
--- @param pat string
--- @return table
function wutils.split(str, pat)
  local t = {}
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

--- Splits a path by / or \
--- @param str string
--- @return table
function wutils.split_path(str)
  return wutils.split(str, '[\\/]+')
end

return wutils