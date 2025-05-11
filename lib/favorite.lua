---@class Favorite
---@field pos_string string  -- Unique string for position
---@field icon string       -- Sprite path for icon (optional)
local Favorite = {}

function Favorite:get_map_position()
  local helpers = require("lib.data_helpers")
  return helpers.pos_string_to_map_position(self.pos_string)
end

--- Returns the ExtTag from a surface_data table that matches this favorite's pos_string
---@param surface_data table
---@return ExtTag|nil
function Favorite:get_ext_tag(surface_data)
  if not self.pos_string or not surface_data or not surface_data.ext_tags then return nil end
  return surface_data.ext_tags[self.pos_string]
end

--- Returns the ChartTag from a surface_data table that matches this favorite's pos_string
---@param surface_data table
---@return ChartTag|nil
function Favorite:get_chart_tag(surface_data)
  if not self.pos_string or not surface_data or not surface_data.chart_tags then return nil end
  return surface_data.chart_tags[self.pos_string]
end

--- Returns the text from the matched ChartTag
---@param surface_data table
---@return string|nil
function Favorite:get_text(surface_data)
  local chart_tag = self:get_chart_tag(surface_data)
  return chart_tag and chart_tag.text or nil
end

--- Returns the icon from the matched ChartTag
---@param surface_data table
---@return string|nil
function Favorite:get_icon(surface_data)
  local chart_tag = self:get_chart_tag(surface_data)
  return chart_tag and chart_tag.icon or nil
end

--- Returns the display_text from the matched ExtTag
---@param surface_data table
---@return string|nil
function Favorite:get_display_text(surface_data)
  local ext_tag = self:get_ext_tag(surface_data)
  return ext_tag and ext_tag.display_text or nil
end

--- Returns the display_description from the matched ExtTag
---@param surface_data table
---@return string|nil
function Favorite:get_display_description(surface_data)
  local ext_tag = self:get_ext_tag(surface_data)
  return ext_tag and ext_tag.display_description or nil
end

return Favorite
