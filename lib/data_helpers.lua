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

---@param player_data PlayerData
---@param slot_number integer
---@param favorite Favorite
local function add_favorite_to_slot(player_data, slot_number, favorite)
  if not player_data.favorites then player_data.favorites = {} end
  player_data.favorites[slot_number] = { slot_locked = false, favorite = favorite }
end

---@param player_data PlayerData
---@param slot_number integer
local function remove_favorite_from_slot(player_data, slot_number)
  if player_data.favorites then
    player_data.favorites[slot_number] = {}
  end
end

---@param surface_data SurfaceData
---@param chart_tag ChartTag
local function add_chart_tag(surface_data, chart_tag)
  if not surface_data.chart_tags then surface_data.chart_tags = {} end
  local pos_string = map_position_to_pos_string(chart_tag.map_position)
  surface_data.chart_tags[pos_string] = chart_tag
end

---@param surface_data SurfaceData
---@param pos_string string
local function remove_chart_tag(surface_data, pos_string)
  if surface_data.chart_tags then
    surface_data.chart_tags[pos_string] = nil
  end
end

---@param surface_data SurfaceData
---@param ext_tag ExtTag
local function add_ext_tag(surface_data, ext_tag)
  if not surface_data.ext_tags then surface_data.ext_tags = {} end
  surface_data.ext_tags[ext_tag.pos_string] = ext_tag
end

---@param surface_data SurfaceData
---@param pos_string string
local function remove_ext_tag(surface_data, pos_string)
  if surface_data.ext_tags then
    surface_data.ext_tags[pos_string] = nil
  end
end

return {
  map_position_to_pos_string = map_position_to_pos_string,
  pos_string_to_map_position = pos_string_to_map_position,
  get_valid_icon = get_valid_icon,
  add_favorite_to_slot = add_favorite_to_slot,
  remove_favorite_from_slot = remove_favorite_from_slot,
  add_chart_tag = add_chart_tag,
  remove_chart_tag = remove_chart_tag,
  add_ext_tag = add_ext_tag,
  remove_ext_tag = remove_ext_tag
}
