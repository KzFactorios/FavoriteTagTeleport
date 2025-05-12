---@class Context
---@field storage Storage
local Context = {}

local PREFIX = require('settings.constants').PREFIX
--local storage = require('lib.ds.storage')
local PlayerData = require('lib.ds.player_data')
local SurfaceData = require('lib.ds.surface_data')
local SettingsManager = require('settings.settings_manager')

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
    if not player then return PlayerData.new() end
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

--- Gets the slot count for a player based on settings
---@param player LuaPlayer
---@return integer
function Context.get_slot_count(player)
    local default_slot_count = 10
    local s = SettingsManager.get_player_settings(player)
    return math.floor(tonumber(s[PREFIX .. "slots"].value) or default_slot_count)
end

--- Gets the player storage from global storage
---@param player LuaPlayer
---@return table|nil
function Context.get_player_storage(player)
    return global and global.ftt_storage and global.ftt_storage.players and global.ftt_storage.players[player.index]
end

--- Safely initializes the context
---@return Context
function Context.safe_init()
    return Context.init(global or {})
end

return Context
