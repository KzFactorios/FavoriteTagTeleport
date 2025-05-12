---@class SettingsManager
---@field get_player_settings fun(player: LuaPlayer): table<string, {value: number|string}>
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
---@return table<string, {value: any}>
function SettingsManager.get_player_settings(player)
    if not player then
        return {
            teleport_radius = 8,
            favorites_on = true,
            destination_msg_on = true,
        }
    end

    local constants = require(settings.constants)
    local PREFIX = constants.PREFIX

    local t_radius = SettingsManager.TELEPORT_RADIUS_DEFAULT
    if player.mod_settings[PREFIX .. "teleport-radius"] and
        player.mod_settings[PREFIX .. "teleport-radius"].value ~= nil then
        t_radius = player.mod_settings[PREFIX .. "teleport-radius"].value
    end

    local favorites_on = true
    if player.mod_settings[PREFIX .. "favorites-on"] and
        player.mod_settings[PREFIX .. "favorites-on"].value ~= nil then
        favorites_on = player.mod_settings[PREFIX .. "favorites-on"].value
    end

    local destination_msg_on = true
    if player.mod_settings[PREFIX .. "destination-msg-on"] and
        player.mod_settings[PREFIX .. "destination-msg-on"].value ~= nil then
        destination_msg_on = player.mod_settings[PREFIX .. "destination-msg-on"].value
    end

    local settings = {
        teleport_radius = t_radius,
        favorites_on = favorites_on,
        destination_msg_on = destination_msg_on,
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
