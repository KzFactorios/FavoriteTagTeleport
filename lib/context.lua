---@class Context
---@field storage Storage
local Context = {}

--local storage = require('lib.ds.storage')
local PlayerData = require('lib.ds.player_data')
local SurfaceData = require('lib.ds.surface_data')

--- Initializes the context data structure if not present
---@param global_table table
---@return Context
function Context.init(global_table)
  if not global_table.storage then
    global_table.storage = {
      mod_version = "0.0.01",
      players = {},
      surfaces = {}
    }
  end
  return setmetatable({ storage = global_table.storage }, { __index = Context })
end

--- Gets or creates player data
---@param self Context
---@param player LuaPlayer
---@return PlayerData
function Context:get_player_data(player)
  if not player then return {} end
  local players = self.storage.players
  local player_index = player.index
  if not players[player_index] then
    players[player_index] = PlayerData.new()
  end
  return players[player_index]
end

--- Gets or creates surface data
---@param self Context
---@param surface_index integer
---@param player any
---@return SurfaceData
function Context:get_surface_data(surface_index, player)
  local surfaces = self.storage.surfaces
  if not surfaces[surface_index] then
    surfaces[surface_index] = SurfaceData.new()
  end
  return surfaces[surface_index]
end

return Context
