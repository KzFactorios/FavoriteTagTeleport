---@diagnostic disable-next-line: undefined-global
local remote = remote

local settings_manager = require("settings.settings_manager")

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
  -- TODO implement validity
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

--- evaluates player surface and determines if player is in space
local function is_on_space_platform(player)
  if not player then return false end
  if not player.surface then return false end
  if not player.surface.map_gen_settings then return false end

  -- Planets have either default/custom terrain gen or specific planet presets
  local map_gen = player.surface.map_gen_settings
  return map_gen.preset == "space-platform" or map_gen.preset == "space"
end

-- Have we selected a point that is not in the fog of war?
local function position_can_be_tagged(position, player)
  if not player then return false end

  local chunk_position = {
    x = math.floor(position.x / 32),
    y = math.floor(position.y / 32)
  }
  return player.force.is_chunk_charted(player.physical_surface_index, chunk_position) 
    and player.force.is_chunk_visible(player.physical_surface_index, chunk_position)
end

---@param player LuaPlayer
---@param target_position {x:number, y:number}
local function teleport_player(player, target_position)
  if not player then return nil, "" end
  if not player.character then return nil, "" end

  if is_on_space_platform(player) then
    return nil,
        "The surgeon general has determined that teleportation on space platforms may incur death and is not authorized!"
  end

  --context.qmtt.player_data[player.index].render_mode = player.render_mode
  local surface = player.physical_surface
  local return_pos = nil
  local return_msg =
  "No valid teleport position found within the teleport radius. Please select another location or you could try increasing the search radius in settings. The hive mind discourages this practice as it will reduce the accuracy of your teleport landing points."

  local settings = settings_manager.get_player_settings(player)
  local teleport_radius = tonumber(settings.teleport_radius)
  local min_radius = settings.TELEPORT_RADIUS_MIN and settings.TELEPORT_RADIUS_MIN.value and tonumber(settings.TELEPORT_RADIUS_MIN.value) or 0
  local max_radius = settings.TELEPORT_RADIUS_MAX and settings.TELEPORT_RADIUS_MAX.value and tonumber(settings.TELEPORT_RADIUS_MAX.value) or 0

  -- Ensure teleport_radius is a valid number
  if not teleport_radius then
    teleport_radius = min_radius
  end

  if teleport_radius < min_radius then
    teleport_radius = min_radius
  elseif max_radius > 0 and teleport_radius > max_radius then
    teleport_radius = max_radius
  end

  -- Find a non-colliding position near the target position
  local closest_position = surface.find_non_colliding_position(
    player.character.name, -- Prototype name of the player's character
    target_position,       -- Target position to search around
    teleport_radius,       -- Search radius in tiles
    6                      -- Precision (smaller values = more precise, but slower) Range 0.01 - 8
  -- fastest but coarse, use 2-4
  -- balanced, use 6
  -- high precision, slowest, use 8
  )

  if closest_position then
    local valid = player.physical_surface.can_place_entity("character", closest_position)

    -- If a position is found, teleport the player there
    if valid then
      if player.teleport(closest_position, player.physical_surface, true) then
        return_pos = closest_position
        return_msg = ""
        -- note that caller is currently handling raising of teleport event
      end
    end
  end

  return return_pos, return_msg
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
  remove_ext_tag = remove_ext_tag,
  teleport_player = teleport_player,
  is_on_space_platform = is_on_space_platform,
  position_can_be_tagged = position_can_be_tagged
}
