---@class ExtTag
---@field pos_string string           -- Unique string for position
---@field display_text string         -- Display name for UI
---@field display_description string  -- Description for UI
---@field faved_by_players table<integer> -- List of player indices who have favorited this tag
local ExtTag = {}

--- Returns the MapPosition table for this pos_string
function ExtTag:get_map_position()
  local helpers = require("lib.data_helpers")
  return helpers.pos_string_to_map_position(self.pos_string)
end

--- Sets the display_text for this ExtTag
---@param value string
function ExtTag:set_display_text(value)
  self.display_text = value
end

--- Sets the display_description for this ExtTag
---@param value string
function ExtTag:set_display_description(value)
  self.display_description = value
end

--- Adds a player index to the faved_by_players list (if not already present)
---@param player_index integer
function ExtTag:add_favorited_by_player(player_index)
  if not self.faved_by_players then self.faved_by_players = {} end
  for _, v in ipairs(self.faved_by_players) do
    if v == player_index then return end
  end
  table.insert(self.faved_by_players, player_index)
end

--- Removes a player index from the faved_by_players list
---@param player_index integer
function ExtTag:remove_favorited_by_player(player_index)
  if not self.faved_by_players then return end
  for i, v in ipairs(self.faved_by_players) do
    if v == player_index then
      table.remove(self.faved_by_players, i)
      return
    end
  end
end

--- Returns true if the player_index is in the faved_by_players list
---@param player_index integer
---@return boolean
function ExtTag:is_favorited_by_player(player_index)
  if not self.faved_by_players then return false end
  for _, v in ipairs(self.faved_by_players) do
    if v == player_index then return true end
  end
  return false
end

--- Validates an ExtTag instance
---@param ext_tag ExtTag
---@return boolean
function ExtTag.validate(ext_tag)
  return type(ext_tag) == "table" and type(ext_tag.pos_string) == "string" and type(ext_tag.display_text) == "string"
end

return ExtTag
