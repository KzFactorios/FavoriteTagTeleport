---@param player_data PlayerData
---@param slot_number integer
---@param favorite Favorite
function add_favorite_to_slot(player_data, slot_number, favorite)
  if not player_data.favorites then player_data.favorites = {} end
  player_data.favorites[slot_number] = { slot_locked = false, favorite = favorite }
end

---@param player_data PlayerData
---@param slot_number integer
function remove_favorite_from_slot(player_data, slot_number)
  if player_data.favorites then
    player_data.favorites[slot_number] = {}
  end
end

---@param surface_data SurfaceData
---@param chart_tag ChartTag
function add_chart_tag(surface_data, chart_tag)
  if not surface_data.chart_tags then surface_data.chart_tags = {} end
  -- Use pos_string as key, derived from map_position
  local helpers = require("lib.data_helpers")
  local pos_string = helpers.map_position_to_pos_string(chart_tag.map_position)
  surface_data.chart_tags[pos_string] = chart_tag
end

---@param surface_data SurfaceData
---@param pos_string string
function remove_chart_tag(surface_data, pos_string)
  if surface_data.chart_tags then
    surface_data.chart_tags[pos_string] = nil
  end
end

---@param surface_data SurfaceData
---@param ext_tag ExtTag
function add_ext_tag(surface_data, ext_tag)
  if not surface_data.ext_tags then surface_data.ext_tags = {} end
  surface_data.ext_tags[ext_tag.pos_string] = ext_tag
end

---@param surface_data SurfaceData
---@param pos_string string
function remove_ext_tag(surface_data, pos_string)
  if surface_data.ext_tags then
    surface_data.ext_tags[pos_string] = nil
  end
end

return {
  add_favorite_to_slot = add_favorite_to_slot,
  remove_favorite_from_slot = remove_favorite_from_slot,
  add_chart_tag = add_chart_tag,
  remove_chart_tag = remove_chart_tag,
  add_ext_tag = add_ext_tag,
  remove_ext_tag = remove_ext_tag
}
