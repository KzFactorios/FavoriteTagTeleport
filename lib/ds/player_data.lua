---@class PlayerData
---@field favorites table<integer, {slot_locked: boolean, favorite: Favorite}>
---@field show_fave_bar_buttons boolean
---@field render_mode string
local PlayerData = {}

--- Gets the favorite entry for a given slot number
---@param self PlayerData
---@param slot_number integer
---@return table|nil
function PlayerData:get_favorite_by_slot(slot_number)
  if not self.favorites then return nil end
  return self.favorites[slot_number]
end

--- Sets the favorite entry for a given slot number
---@param self PlayerData
---@param slot_number integer
---@param favorite Favorite
---@param slot_locked boolean?
function PlayerData:set_favorite(slot_number, favorite, slot_locked)
  if not self.favorites then self.favorites = {} end
  self.favorites[slot_number] = { slot_locked = slot_locked or false, favorite = favorite }
end

--- Removes the favorite entry for a given slot number
---@param self PlayerData
---@param slot_number integer
function PlayerData:remove_favorite(slot_number)
  if self.favorites then
    self.favorites[slot_number] = nil
  end
end

--- Gets the show_fave_bar_buttons value
---@param self PlayerData
---@return boolean
function PlayerData:get_show_fave_bar_buttons()
  return self.show_fave_bar_buttons
end

--- Sets the show_fave_bar_buttons value
---@param self PlayerData
---@param value boolean
function PlayerData:set_show_fave_bar_buttons(value)
  self.show_fave_bar_buttons = value
end

--- Gets the render_mode value
---@param self PlayerData
---@return string
function PlayerData:get_render_mode()
  return self.render_mode
end

--- Sets the render_mode value
---@param self PlayerData
---@param value string
function PlayerData:set_render_mode(value)
  self.render_mode = value
end

return PlayerData
