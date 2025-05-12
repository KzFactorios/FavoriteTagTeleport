-- gui/common_gui.lua
-- FavoriteTagTeleport: Common GUI Utilities
-- Shared helper functions for building, updating, and managing GUIs in the mod.

local PREFIX = require('settings.constants').PREFIX
require('lib.factorio_types.gui')

---@class CommonGUI
---@field styles table<string, string> Common style names used across the mod
local CommonGUI = {
    styles = {
        frame = PREFIX .. 'frame',
        flow = PREFIX .. 'flow',
        button = PREFIX .. 'button',
        sprite_button = PREFIX .. 'sprite_button',
    }
}

--- Safely destroys a GUI element if it exists and is valid
---@param element LuaGuiElement|nil The element to destroy
---@return boolean success Whether the element was successfully destroyed
function CommonGUI.safe_destroy(element)
    if element and element.valid then
        element:destroy()
        return true
    end
    return false
end

--- Finds a child element by name, returns nil if not found
---@param parent LuaGuiElement|nil The parent element to search in
---@param name string The name of the child element to find
---@return LuaGuiElement|nil child The found child element or nil if not found
function CommonGUI.find_child(parent, name)
    if parent and parent.valid then
        return parent[name]
    end
    return nil
end

--- Standardizes GUI element names
---@param prefix string The prefix to use (usually mod prefix + element type)
---@param id string|number The unique identifier for the element
---@return string name The standardized element name
function CommonGUI.element_name(prefix, id)
    return prefix .. tostring(id)
end

--- Creates a standard frame with the mod's styling
---@param parent LuaGuiElement The parent element to add the frame to
---@param name string The name for the frame
---@param caption? string|table Optional caption for the frame
---@return LuaGuiElement|nil frame The created frame or nil if parent is invalid
function CommonGUI.create_frame(parent, name, caption)
    if not (parent and parent.valid) then return nil end
    return parent:add{
        type = 'frame',
        name = name,
        caption = caption,
        style = CommonGUI.styles.frame
    }
end

--- Creates a flow container with standard styling
---@param parent LuaGuiElement The parent element to add the flow to
---@param name string The name for the flow
---@param direction? "horizontal"|"vertical" Optional flow direction (defaults to 'horizontal')
---@return LuaGuiElement|nil flow The created flow or nil if parent is invalid
function CommonGUI.create_flow(parent, name, direction)
    if not (parent and parent.valid) then return nil end
    return parent:add{
        type = 'flow',
        name = name,
        direction = direction or 'horizontal',
        style = CommonGUI.styles.flow
    }
end

--- Creates a sprite button with standard styling
---@param parent LuaGuiElement The parent element to add the button to
---@param name string The name for the button
---@param sprite string The sprite to use for the button
---@param tooltip? string|table Optional tooltip for the button
---@return LuaGuiElement|nil button The created sprite button or nil if parent is invalid
function CommonGUI.create_sprite_button(parent, name, sprite, tooltip)
    if not (parent and parent.valid) then return nil end
    return parent:add{
        type = 'sprite-button',
        name = name,
        sprite = sprite,
        tooltip = tooltip,
        style = CommonGUI.styles.sprite_button
    }
end

--- Validates that a GUI element exists and is valid
---@param element LuaGuiElement|nil The element to validate
---@param context? string Optional context for error reporting
---@return boolean is_valid Whether the element is valid
---@return string? error_message Error message if invalid
function CommonGUI.validate_element(element, context)
    if not element then
        return false, string.format("GUI element not found%s", context and (" in " .. context) or "")
    end
    if not element.valid then
        return false, string.format("GUI element is invalid%s", context and (" in " .. context) or "")
    end
    return true
end

return CommonGUI
