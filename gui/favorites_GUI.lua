-- gui/favorites_GUI.lua
-- FavoriteTagTeleport: Favorites Bar GUI Library
-- Provides the favorites bar GUI for quick teleportation and tag access.
-- Modular, event-driven, and integrates with the editor GUI and data layer.

---@class FavoritesGUI
local FavoritesGUI = {}

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

local Storage = require('lib.ds.storage')
local PlayerData = require('lib.ds.player_data')
local SurfaceData = require('lib.ds.surface_data')
local Favorite = require('lib.ds.favorite')
local wutils = require('lib.wutils')
local CommonGUI = require('gui.common_gui')

local GUI_NAMES = {
    favorites_bar = 'ftt_favorites_bar',
    favorite_btn_prefix = 'ftt_favorite_btn_',
    edit_btn = 'ftt_edit_favorite_btn',
    -- ...add more as needed
}

FavoritesGUI.GUI_NAMES = GUI_NAMES

local DRAGGING_STYLE = 'ftt_favorite_slot_btn_dragging'
local DROP_TARGET_STYLE = 'ftt_favorite_slot_btn_drop_target'

--- Opens or updates the favorites bar GUI for a player
---@param player LuaPlayer
function FavoritesGUI.open(player)
    local gui = player.gui.top
    local CommonGUI = require('gui.common_gui')
    -- Destroy existing bar if present
    CommonGUI.safe_destroy(gui[GUI_NAMES.favorites_bar])

    -- Main container (outer)
    local bar = gui.add{
        type = 'flow',
        name = GUI_NAMES.favorites_bar,
        direction = 'horizontal',
        style = 'ftt_favorites_bar_outer_flow' -- define in styles.lua
    }

    -- Border container (for styling)
    local border = bar.add{
        type = 'frame',
        name = 'ftt_favorites_bar_border',
        direction = 'horizontal',
        style = 'ftt_favorites_bar_border_frame' -- define in styles.lua
    }

    -- Toggle + slots horizontal stack
    local row = border.add{
        type = 'flow',
        name = 'ftt_favorites_bar_row',
        direction = 'horizontal',
        style = 'ftt_favorites_bar_row_flow' -- define in styles.lua
    }

    -- Toggle button container
    local toggle_container = row.add{
        type = 'flow',
        name = 'ftt_toggle_container',
        direction = 'horizontal',
        style = 'ftt_toggle_container_flow' -- define in styles.lua
    }
    local toggle_btn = toggle_container.add{
        type = 'sprite-button',
        name = 'ftt_favorites_toggle_btn',
        sprite = 'utility/heart',
        style = 'ftt_favorites_toggle_btn',
        tooltip = {'ftt.favorites_toggle_tooltip'}
    }

    -- Slots container (holds all favorite slots)
    local slots_container = row.add{
        type = 'flow',
        name = 'ftt_slots_container',
        direction = 'horizontal',
        style = 'ftt_slots_container_flow' -- define in styles.lua
    }

    -- Get player data/settings for slot count and bar visibility
    local player_data = PlayerData
    if global and global.ftt_storage and global.ftt_storage.players then
        player_data = global.ftt_storage.players[player.index] or player_data
    end
    local show_slots = player_data.get_show_fave_bar_buttons and player_data:get_show_fave_bar_buttons() or true
    slots_container.visible = show_slots

    -- Determine slot count (default 10, or from settings)
    local slot_count = 10
    if settings and settings.get_player_settings then
        local s = settings.get_player_settings(player)
        if s and s["ftt_slots"] then
            slot_count = tonumber(s["ftt_slots"].value) or 10
        end
    end

    -- Add slot buttons
    for i = 1, slot_count do
        local fav = player_data.favorites and player_data.favorites[i]
        slots_container.add{
            type = 'sprite-button',
            name = GUI_NAMES.favorite_btn_prefix .. i,
            sprite = (fav and fav.favorite and fav.favorite.icon) or 'item/iron-gear-wheel',
            style = 'ftt_favorite_slot_btn',
            tooltip = FavoritesGUI.get_slot_tooltip(fav, i)
        }
    end
end

--- Closes the favorites bar GUI for a player
---@param player LuaPlayer
function FavoritesGUI.close(player)
    -- TODO: Destroy the favorites bar GUI if it exists
end

--- Refreshes the favorites bar GUI for a player
---@param player LuaPlayer
function FavoritesGUI.refresh(player)
    -- Rebuild the bar to reflect current favorites and order
    FavoritesGUI.open(player)
end

--- Handles drag-and-drop reordering of favorites
---@param player LuaPlayer
---@param from_slot integer
---@param to_slot integer
function FavoritesGUI.reorder_favorites(player, from_slot, to_slot)
    if not (global and global.ftt_storage and global.ftt_storage.players) then return end
    local pdata = global.ftt_storage.players[player.index]
    if not (pdata and pdata.favorites) then return end
    if from_slot == to_slot then return end
    -- Swap or move favorite entries
    local moving = pdata.favorites[from_slot]
    if not moving then return end
    -- Remove from old slot
    pdata.favorites[from_slot] = nil
    -- Shift others if needed (simple insert, not full reorder)
    -- If destination occupied, shift right
    if pdata.favorites[to_slot] then
        for i = #pdata.favorites, to_slot, -1 do
            pdata.favorites[i+1] = pdata.favorites[i]
        end
    end
    pdata.favorites[to_slot] = moving
    FavoritesGUI.refresh(player)
end

--- Enhanced tooltip for favorite slot
---@param favorite table|nil
---@param slot_num integer
---@return table|string
function FavoritesGUI.get_slot_tooltip(favorite, slot_num)
    if not favorite or not favorite.favorite then
        return {'ftt.favorite_slot_tooltip_empty', slot_num}
    end
    local fav = favorite.favorite
    local text = fav.text or ''
    local pos = fav.pos_string or ''
    return {'ftt.favorite_slot_tooltip', slot_num, text, pos}
end

--- Handles GUI events (button clicks, drag, etc.)
---@param event table  -- Factorio event
function FavoritesGUI.handle_event(event)
    local element = event.element
    if not (element and element.valid) then return end
    local player = game.get_player(event.player_index)
    if not player then return end

    -- Toggle button logic
    if element.name == 'ftt_favorites_toggle_btn' then
        local player_data = global.ftt_storage.players[player.index]
        local show = not (player_data:get_show_fave_bar_buttons())
        player_data:set_show_fave_bar_buttons(show)
        -- Refresh the bar to update visibility
        FavoritesGUI.open(player)
        return
    end

    -- Slot button logic
    if string.find(element.name, GUI_NAMES.favorite_btn_prefix, 1, true) == 1 then
        local slot_num = tonumber(string.sub(element.name, #GUI_NAMES.favorite_btn_prefix + 1))
        if not slot_num then return end
        if event.button == defines.mouse_button_type.left then
            -- Left click: teleport to favorite location
            -- (Teleport logic to be implemented elsewhere)
            if global.ftt_storage and global.ftt_storage.players then
                local pdata = global.ftt_storage.players[player.index]
                if pdata and pdata.favorites and pdata.favorites[slot_num] then
                    local fav = pdata.favorites[slot_num].favorite
                    if fav and fav.pos_string then
                        -- Call teleport utility (to be implemented)
                        if remote.interfaces["ftt_teleport"] and remote.interfaces["ftt_teleport"].teleport_to then
                            remote.call("ftt_teleport", "teleport_to", player.index, fav.pos_string)
                        else
                            player.print{"ftt.teleport_not_implemented"}
                        end
                    else
                        player.print{"ftt.no_favorite_in_slot", slot_num}
                    end
                end
            end
        elseif event.button == defines.mouse_button_type.right then
            -- Right click: open editor GUI for this favorite
            if remote.interfaces["ftt_editor_gui"] and remote.interfaces["ftt_editor_gui"].open_for_favorite then
                remote.call("ftt_editor_gui", "open_for_favorite", player.index, slot_num)
            else
                player.print{"ftt.editor_not_implemented"}
            end
        end
        return
    end

    -- Drag-and-drop: visual feedback
    if event.name == defines.events.on_gui_location_changed and string.find(element.name, GUI_NAMES.favorite_btn_prefix, 1, true) == 1 then
        local from_slot = tonumber(element.tags and element.tags.from_slot or string.sub(element.name, #GUI_NAMES.favorite_btn_prefix + 1))
        local to_slot = tonumber(element.tags and element.tags.to_slot or from_slot)
        if from_slot and to_slot then
            -- Set dragging style on the dragged slot
            local bar = FavoritesGUI.get_bar(player)
            if bar then
                local slots_container = bar['ftt_favorites_bar_border']['ftt_favorites_bar_row']['ftt_slots_container']
                for i, child in pairs(slots_container.children) do
                    if i == from_slot then
                        child.style = DRAGGING_STYLE
                        child.tooltip = {'ftt.favorite_slot_tooltip_dragging', i}
                    elseif i == to_slot and from_slot ~= to_slot then
                        child.style = DROP_TARGET_STYLE
                        child.tooltip = {'ftt.favorite_slot_tooltip_drop_target', i}
                    else
                        child.style = 'ftt_favorite_slot_btn'
                        child.tooltip = FavoritesGUI.get_slot_tooltip(player_data.favorites and player_data.favorites[i], i)
                    end
                end
            end
        end
        -- ...existing reorder logic...
        if from_slot and to_slot and from_slot ~= to_slot then
            FavoritesGUI.reorder_favorites(player, from_slot, to_slot)
        end
        return
    end
end

--- Utility: Get the favorites bar element for a player
---@param player LuaPlayer
---@return LuaGuiElement|nil
function FavoritesGUI.get_bar(player)
    return player.gui.top[GUI_NAMES.favorites_bar]
end

--[[
    Additional planned methods:
    - FavoritesGUI.add_favorite_btn(player, favorite)
    - FavoritesGUI.remove_favorite_btn(player, favorite_id)
    - FavoritesGUI.reorder_favorites(player, new_order)
    - FavoritesGUI.update_storage(player)
    - ...etc.
]]

return FavoritesGUI
