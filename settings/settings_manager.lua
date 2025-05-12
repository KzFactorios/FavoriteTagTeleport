---@class SettingsManager
---@field get_player_settings fun(player: LuaPlayer):{teleport_radius: number, favorites_on: boolean, destination_msg_on: boolean, slots: number}
---@field get_setting fun(player: LuaPlayer, setting_name: string): any
---@field TELEPORT_RADIUS_DEFAULT number
---@field TELEPORT_RADIUS_MIN number
---@field TELEPORT_RADIUS_MAX number
local SettingsManager = {}

SettingsManager.TELEPORT_RADIUS_DEFAULT = 8
SettingsManager.TELEPORT_RADIUS_MIN = 5
SettingsManager.TELEPORT_RADIUS_MAX = 50

--- Retrieves the player settings for a given player.
---@param player LuaPlayer
---@return {teleport_radius: number, favorites_on: boolean, destination_msg_on: boolean, slots: number}
function SettingsManager.get_player_settings(player)
    if not player then
        return {
            teleport_radius = SettingsManager.TELEPORT_RADIUS_DEFAULT,
            favorites_on = true,
            destination_msg_on = true,
            slots = 10,
        }
    end

    local constants = require('settings.constants') -- Fixed require statement
    local PREFIX = constants.PREFIX

    local t_radius = tonumber(player.mod_settings[PREFIX .. "teleport-radius"] and player.mod_settings[PREFIX .. "teleport-radius"].value) or SettingsManager.TELEPORT_RADIUS_DEFAULT
    local favorites_on = (player.mod_settings[PREFIX .. "favorites-on"] and player.mod_settings[PREFIX .. "favorites-on"].value) ~= nil and player.mod_settings[PREFIX .. "favorites-on"].value or true
    local destination_msg_on = (player.mod_settings[PREFIX .. "destination-msg-on"] and player.mod_settings[PREFIX .. "destination-msg-on"].value) ~= nil and player.mod_settings[PREFIX .. "destination-msg-on"].value or true
    local slots = tonumber(player.mod_settings[PREFIX .. "slots"] and player.mod_settings[PREFIX .. "slots"].value) or 10

    local settings = {
        teleport_radius = t_radius,
        favorites_on = favorites_on,
        destination_msg_on = destination_msg_on,
        slots = slots,
    }

    return settings
end

--- Retrieves a specific setting value for a player.
---@param player LuaPlayer
---@param setting_name string
---@return any
function SettingsManager.get_setting(player, setting_name)
    local player_settings = SettingsManager.get_player_settings(player)
    if player_settings and player_settings[setting_name] then
        return player_settings[setting_name].value
    end
    return nil
end

return SettingsManager
