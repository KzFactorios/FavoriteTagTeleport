-- gui/favorites_GUI.lua
-- Provides the favorites bar GUI for quick teleportation and tag access.
--[[
    FavoritesGUI: High-level goals and workflows (see notes for details):
    - Display a horizontal bar of favorite tags for the current player
    - Allow quick teleportation or tag actions via buttons
    - Integrate with editor GUI for editing/removing favorites
    - Support drag-and-drop reordering
    - Robust against reloads and GUI resets
    - Register and handle GUI events (button clicks, drag, etc.)
    - Connect to data layer (Storage, PlayerData, SurfaceData, etc.)
    - Use common GUI helpers from common_gui.lua
]]

-- Organized imports
require('lib.factorio_types.factorio_gui_types')
local PlayerData = require('lib.ds.player_data')
local data_helpers = require('lib.data_helpers')
local PREFIX = require('settings.constants').PREFIX
local CommonGUI = require('gui.common_gui')

---@class FavoritesGUI
local FavoritesGUI = {}

-- Constants
local GUI_NAMES = {
    favorites_bar = PREFIX .. 'favorites_bar',
    favorite_btn_prefix = PREFIX .. 'favorite_btn_',
    edit_btn = PREFIX .. 'edit_favorite_btn',
    favorites_border = PREFIX .. 'favorites_bar_border',
    favorites_row = PREFIX .. 'favorites_bar_row',
    slots_container = PREFIX .. 'slots_container'
}

local DEFAULT_SLOT_COUNT = 10

FavoritesGUI.GUI_NAMES = GUI_NAMES

-- Helper function to get player data safely
---@param player LuaPlayer
---@return PlayerDataInstance
local function get_player_data(player)
    if not global then return PlayerData.new() end
    if not global.ftt_storage then return PlayerData.new() end
    if not global.ftt_storage.players then return PlayerData.new() end
    return global.ftt_storage.players[player.index] or PlayerData.new()
end

-- Get the configured number of favorite slots
---@param player LuaPlayer
---@return number
local function get_slot_count(player)
    if not settings then return DEFAULT_SLOT_COUNT end
    local player_settings = settings.get_player_settings(player)
    if not player_settings then return DEFAULT_SLOT_COUNT end
    local slots_value = player_settings[PREFIX .. "slots"]
    if not slots_value or not slots_value.value then return DEFAULT_SLOT_COUNT end
    return math.floor(tonumber(slots_value.value) or DEFAULT_SLOT_COUNT)
end

-- Helper to check if a favorite slot exists and is valid
---@param player_data table
---@param slot_num number
---@return boolean
local function has_valid_favorite(player_data, slot_num)
    if not player_data then return false end
    if not player_data.favorites then return false end
    local fav = player_data.favorites[slot_num]
    if not fav then return false end
    return fav.favorite ~= nil
end

-- Create a favorite slot button
---@param container LuaGuiElement
---@param slot_num integer
---@param favorite_data {favorite: Favorite, slot_locked: boolean}|nil
local function create_favorite_slot(container, slot_num, favorite_data)
    local sprite = 'utility/not_available'
    local tooltip = 'Empty slot'
    
    if favorite_data and favorite_data.favorite then
        local favorite = favorite_data.favorite
        sprite = favorite.icon or sprite
        tooltip = favorite.pos_string or tooltip
    end
    
    container.add('sprite-button', {
        name = GUI_NAMES.favorite_btn_prefix .. tostring(slot_num),
        sprite = sprite,
        tooltip = tooltip,
        style = PREFIX .. 'favorite_slot_btn'
    })
end

-- Create the favorites bar structure
---@param gui LuaGuiElement The parent GUI element
---@return LuaGuiElement The created favorites bar
local function create_favorites_bar(gui)
    local bar = gui.add('frame', {
        name = GUI_NAMES.favorites_bar,
        direction = 'horizontal',
        style = PREFIX .. 'favorites_bar_frame'
    })
    
    local border = bar.add('frame', {
        name = GUI_NAMES.favorites_border,
        style = PREFIX .. 'favorites_bar_border_frame'
    })
    
    local row = border.add('flow', {
        name = GUI_NAMES.favorites_row,
        direction = 'horizontal',
        style = PREFIX .. 'favorites_bar_row_flow'
    })
    
    local slots = row.add('flow', {
        name = GUI_NAMES.slots_container,
        direction = 'horizontal',
        style = PREFIX .. 'slots_container_flow'
    })
    
    row.add('sprite-button', {
        name = GUI_NAMES.edit_btn,
        sprite = 'utility/rename_icon_small_black',
        style = PREFIX .. 'favorites_edit_btn'
    })
    
    return bar
end

-- Update the favorites bar for a player
---@param player LuaPlayer The player to update the favorites bar for
function FavoritesGUI.update_favorites_bar(player)
    local player_data = get_player_data(player)
    local slot_count = get_slot_count(player)
    
    -- Get or create the favorites bar GUI
    local gui = player.gui.left
    local bar = gui[GUI_NAMES.favorites_bar] or create_favorites_bar(gui)
    local slots = bar[GUI_NAMES.favorites_border][GUI_NAMES.favorites_row][GUI_NAMES.slots_container]
    
    -- Clear existing slots
    slots.clear()
    
    -- Add favorite slots
    for i = 1, slot_count do
        local favorite_data = player_data.favorites[i]
        create_favorite_slot(slots, i, favorite_data)
    end
end

return FavoritesGUI
