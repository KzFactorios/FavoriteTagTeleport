-- gui/common_gui.lua
-- FavoriteTagTeleport: Common GUI Utilities
-- Shared helper functions for building, updating, and managing GUIs in the mod.
-- Use this module for any logic or utilities shared between editor_GUI.lua, favorites_GUI.lua, and other GUI modules.

---@class CommonGUI
local CommonGUI = {}

--[[
    CommonGUI: Shared GUI helpers and utilities
    - Destroy GUI elements safely
    - Find or create GUI roots/frames
    - Standardize element naming and lookup
    - Register and unregister event handlers
    - Validate GUI state
    - Any other cross-GUI logic
]]

--- Safely destroys a GUI element if it exists
---@param element LuaGuiElement|nil
function CommonGUI.safe_destroy(element)
    if element and element.valid then
        element.destroy()
    end
end

--- Finds a child element by name, returns nil if not found
---@param parent LuaGuiElement|nil
---@param name string
---@return LuaGuiElement|nil
function CommonGUI.find_child(parent, name)
    if parent and parent.valid then
        return parent[name]
    end
    return nil
end

--- Utility: Standardize GUI element names (e.g., for favorites)
---@param prefix string
---@param id string|number
---@return string
function CommonGUI.element_name(prefix, id)
    return prefix .. tostring(id)
end

-- Add more shared helpers as needed

return CommonGUI
