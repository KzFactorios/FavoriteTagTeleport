---@param pos {x: number, y: number}
---@return string
local function map_position_to_pos_string(pos)
  -- Format: xxx.yyy, zero values as absolute (no negative sign for zero)
  local function format_coord(val)
    if val == 0 or val == -0 then return "0" end
    return string.format("%d", val)
  end
  return format_coord(pos.x) .. "." .. format_coord(pos.y)
end

---@param pos_string string
---@return {x: number, y: number}
local function pos_string_to_map_position(pos_string)
  local x, y = pos_string:match("([%-%d]+)%.([%-%d]+)")
  return { x = tonumber(x), y = tonumber(y) }
end

---@param icon string
---@return string
local function get_valid_icon(icon)
  if remote and remote.interfaces and remote.interfaces["__core__"] and remote.interfaces["__core__"].is_valid_sprite_path then
    if remote.call("__core__", "is_valid_sprite_path", icon) then
      return icon
    end
  end
  return "generic_marker.png"
end

return {
  map_position_to_pos_string = map_position_to_pos_string,
  pos_string_to_map_position = pos_string_to_map_position,
  get_valid_icon = get_valid_icon
}
