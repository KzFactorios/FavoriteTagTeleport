---@class Context
---@field storage Storage
local Context = {}

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
---@param player_index integer
---@return PlayerData
function Context:get_player_data(player_index)
  local players = self.storage.players
  if not players[player_index] then
    players[player_index] = {}
  end
  return players[player_index]
end

--- Gets or creates surface data
---@param self Context
---@param surface_index integer
---@return SurfaceData
function Context:get_surface_data(surface_index)
  local surfaces = self.storage.surfaces
  if not surfaces[surface_index] then
    surfaces[surface_index] = {}
  end
  return surfaces[surface_index]
end

return Context
