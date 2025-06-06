---@diagnostic disable-next-line: undefined-global
local game = game
---@diagnostic disable-next-line: undefined-global
local global = global
---@diagnostic disable-next-line: undefined-global
local settings = settings
---@diagnostic disable-next-line: undefined-global
local remote = remote
---@diagnostic disable-next-line: undefined-global
local script = script
---@diagnostic disable-next-line: undefined-global
local defines = defines
---@diagnostic disable-next-line: undefined-global
local PREFIX = require("settings/constants").PREFIX

-- Factorio mod: FavoriteTagTeleport - control.lua
-- Main entry point for event registration and mod lifecycle
local Storage = require('lib.ds.storage')
local surface_data = require('lib.ds.surface_data') -- Add this line or adjust the path as needed
local FavoritesGUI = require('gui.favorites_GUI')

local storage = Storage

local _startup = 0

-- Factorio lifecycle events
local function on_init()
    storage:on_init()
    -- Ensure global is initialized before setting up ftt_storage
    global = global or {}
    global.ftt_storage = global.ftt_storage or { players = {} }

    -- Ensure context.storage is initialized
    if not storage.players then
        storage.players = {}
    end
    -- TODO: Initialize GUIs, register GUI handlers, set up player GUIs, etc.
end

local function on_load()
    -- TODO: Rebuild GUI lookup tables, re-register event handlers if needed
end

local function on_configuration_changed(event)
    -- TODO: Handle mod upgrades, migration, and player re-initialization
end

--- Handle mod settings changes
local function on_runtime_mod_setting_changed(event)
    if not event or not game then return end
    -- .player_index is optional in the API but we need the player index in our logic
    if not event.player_index then return end

    local player = game.get_player(event.player_index)
    if not player then return end

    local setting_name = event.setting
    local setting_type

    if setting_type == "runtime-per-user" and setting_name == PREFIX .. "favorites-on" then
        --control.apply_favorites_on_off_state(player)
        --control.update_uis(player)
    end
end

local function on_first_game_tick(event)
    for _, player in pairs(game.players) do
        if not player then break end
        --TODO what to do on startup
    end
    if not _startup then
        script.on_event(defines.events.on_tick, nil)
        _startup = 1
    end
end

-- Player events
local function on_player_created(event)
    local player = game.get_player(event.player_index)
    FavoritesGUI.open(player)
end

local function on_player_joined_game(event)
    local player = game.get_player(event.player_index)
    FavoritesGUI.open(player)
end

--- This occurs when a player switches between different controller modes,
--- such as moving from character control to god mode, spectator mode,
--- or any other available controller type in the game
--- ie: fave bar should only show in game mode
local function on_player_controller_changed(event)
    -- TODO: react to player controller changes
end

--- This addresses an error that was happening with the inclusion
--- of map_tag_editor (I think)
local function on_player_changed_force(event)
    if not game then return end
    local player = game.get_player(event.player_index)
    if not player then return end
    -- implemented to handle EditorExtensions incompat? 1/20/2025
    local result = pcall(surface_data.reset_chart_tags, player)
end

local function on_player_left_game(event)
    -- TODO: Handle player leaving (cleanup if needed)
end

local function on_player_removed(event)
    -- TODO: Remove player data from storage
end

--- React to changes from the stock editor. update chart and ext tags
--- Chart tag events
local function on_chart_tag_removed(event)
    --qmtt.handle_chart_tag_removal(event)
end

--TODO decide if this is necessary to handle stock editor and/or should
--- handle mod's additions for consistency
local function on_chart_tag_added(event)
    -- TODO: ensure that a matching ext_tag is created?
end


local function on_chart_tag_modified(event)
    --qmtt.handle_chart_tag_modified(event)
end

-- Custom input events (hotkeys, GUI triggers)
local function on_teleport(event)
    -- TODO: Handle custom input events
end

-- Register events
script.on_init(on_init)
script.on_load(on_load)
script.on_configuration_changed(on_configuration_changed)
script.on_event("on_player_created", on_player_created)
script.on_event("on_player_controller_changed", on_player_controller_changed)
script.on_event("on_player_changed_force", on_player_changed_force)
script.on_event("on_tick", on_first_game_tick)
script.on_event("on_player_left_game", on_player_left_game)
script.on_event("on_player_removed", on_player_removed)
script.on_event("on_chart_tag_added", on_chart_tag_added)
script.on_event("on_chart_tag_removed", on_chart_tag_removed)
script.on_event("on_chart_tag_modified", on_chart_tag_modified)
script.on_event("on_runtime_mod_setting_changed", on_runtime_mod_setting_changed)
-- Register custom input events as needed
script.on_event("script_raised_teleported", on_teleport)

-- Register GUI events
script.on_event(defines.events.on_gui_click, FavoritesGUI.handle_event)
script.on_event(defines.events.on_gui_elem_changed, FavoritesGUI.handle_event)

-- Drag-and-drop logic for favorites bar
script.on_event(defines.events.on_gui_location_changed, function(event)
    local element = event.element
    if not (element and element.valid) then return end

    if FavoritesGUI.GUI_NAMES and FavoritesGUI.GUI_NAMES.favorite_btn_prefix and
        string.find(element.name, FavoritesGUI.GUI_NAMES.favorite_btn_prefix, 1, true) == 1 then
        -- Drag-and-drop logic: update order if a favorite slot is moved
        -- (Implement order update and refresh bar)
        -- You may want to store drag state in global or player table
        -- For now, just refresh the bar
        local player = game.get_player(event.player_index)        
        FavoritesGUI.refresh(player)
    end
end)

--- TODO: set events for hotkeys
--[[for i = 1, 10 do
  script.on_event(prototypes.custom_input[PREFIX .. "teleport-to-fave-" .. i], function(event)
    ---@diagnostic disable-next-line: undefined-field
    local player = game.get_player(event.player_index)
    if not player then return end

    local faves = context.get_player_favorites_on_current_surface(player)
    if not faves then return end

    local sel_fave = faves[i]
    if sel_fave and sel_fave._pos_idx and sel_fave._pos_idx ~= "" then
      -- Teleporting on a space platform is handled at teleport function
      map_tag_utils.teleport_player_to_closest_position(player,
        wutils.decode_position_from_pos_idx(sel_fave._pos_idx))
    end
  end)
end]]

-- Utility: Debug print if __DEBUG__ is enabled
local function debug_print(msg)
    if game and storage.__DEBUG__ then
        game.print('[FTT DEBUG] ' .. tostring(msg))
    end
end

return {
    on_init = on_init,
    on_load = on_load,
    on_configuration_changed = on_configuration_changed,
    on_player_created = on_player_created,
    on_player_joined_game = on_player_joined_game,
    on_player_controller_changed = on_player_controller_changed,
    on_player_changed_force = on_player_changed_force,
    on_first_tick = on_first_game_tick,
    on_player_left_game = on_player_left_game,
    on_player_removed = on_player_removed,
    on_chart_tag_added = on_chart_tag_added,
    on_chart_tag_removed = on_chart_tag_removed,
    on_chart_tag_modified = on_chart_tag_modified,
    on_teleport = on_teleport,
    on_runtime_mod_setting_changed = on_runtime_mod_setting_changed,
    debug_print = debug_print
}
