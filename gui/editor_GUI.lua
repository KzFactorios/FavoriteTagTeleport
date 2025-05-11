-- gui/editor_GUI.lua
-- FavoriteTagTeleport: Editor GUI Library
-- Provides the main editor GUI for managing favorites, tags, and teleportation workflows.
-- This file is the entry point for the modular GUI system for the mod.

---@class EditorGUI
local EditorGUI = {}

--[[
    EditorGUI: High-level goals and workflows (see notes for details):
    - Display and edit favorite tags for the current player and surface
    - Integrate with icon picker (Factorio vanilla or custom)
    - Validate user input and update storage
    - Modular, event-driven, and robust against reloads
    - Support for opening/closing, updating, and destroying the editor GUI
    - Connect to data layer (Storage, PlayerData, SurfaceData, etc.)
    - Register and handle GUI events (button clicks, text changes, etc.)
    - Provide hooks for other GUI modules (favorites bar, icon picker, etc.)
]]

local Storage = require('lib.ds.storage')
local PlayerData = require('lib.ds.player_data')
local SurfaceData = require('lib.ds.surface_data')
local Favorite = require('lib.ds.favorite')
local wutils = require('lib.wutils')

-- Forward declarations for event names/ids
local GUI_NAMES = {
    editor_root = 'ftt_editor_root',
    favorites_list = 'ftt_favorites_list',
    add_favorite_btn = 'ftt_add_favorite_btn',
    icon_picker_btn = 'ftt_icon_picker_btn',
    save_btn = 'ftt_save_btn',
    cancel_btn = 'ftt_cancel_btn',
    -- ...add more as needed
}

--- Opens or updates the editor GUI for a player
---@param player LuaPlayer
function EditorGUI.open(player)
    -- TODO: Build or update the editor GUI for the player
    -- 1. Destroy existing editor GUI if present
    -- 2. Create root frame, add children (favorites list, add/edit controls, etc.)
    -- 3. Populate with current favorites from storage
    -- 4. Register event handlers for buttons, textfields, etc.
end

--- Closes the editor GUI for a player
---@param player LuaPlayer
function EditorGUI.close(player)
    -- TODO: Destroy the editor GUI if it exists
end

--- Refreshes the editor GUI for a player (e.g., after data changes)
---@param player LuaPlayer
function EditorGUI.refresh(player)
    -- TODO: Update the GUI elements to reflect current data
end

--- Handles GUI events (button clicks, text changes, etc.)
---@param event EventData.on_gui_click|EventData.on_gui_text_changed|... 
function EditorGUI.handle_event(event)
    -- TODO: Route events to the correct handler based on element name
end

--- Utility: Get the editor root element for a player
---@param player LuaPlayer
---@return LuaGuiElement|nil
function EditorGUI.get_root(player)
    -- TODO: Return the root frame if it exists
end

--[[
    Additional planned methods:
    - EditorGUI.add_favorite(player)
    - EditorGUI.edit_favorite(player, favorite_id)
    - EditorGUI.remove_favorite(player, favorite_id)
    - EditorGUI.show_icon_picker(player, callback)
    - EditorGUI.validate_input(input)
    - EditorGUI.update_storage(player)
    - ...etc.
]]

return EditorGUI
