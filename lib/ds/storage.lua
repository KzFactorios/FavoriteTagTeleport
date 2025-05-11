---@class Storage
---@field mod_version string
---@field players table<integer, PlayerData>
---@field surfaces table<integer, SurfaceData>
---@field __DEBUG__ boolean
local Storage = {
  __DEBUG__ = false
}

--- Initializes the storage structure (called on mod init)
---@param self Storage
function Storage:on_init()
  self.mod_version = self.mod_version or "0.0.01"
  self.players = self.players or {}
  self.surfaces = self.surfaces or {}
end

--- Resets the entire storage structure (clears all data except __DEBUG__)
---@param self Storage
function Storage:reset()
  local debug_val = self.__DEBUG__
  self.mod_version = "0.0.01"
  self.players = {}
  self.surfaces = {}
  self.__DEBUG__ = debug_val
end

--- Adds a new player data entry
---@param self Storage
---@param player_index integer
---@param player_data PlayerData
function Storage:add_player_data(player_index, player_data)
  self.players = self.players or {}
  self.players[player_index] = player_data
end

--- Removes a player data entry
---@param self Storage
---@param player_index integer
function Storage:remove_player_data(player_index)
  if self.players then
    self.players[player_index] = nil
  end
end

return Storage
