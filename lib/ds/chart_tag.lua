---@class ChartTag
---@field map_position {x:number, y:number}      -- Unique map position
---@field icon string           -- Sprite path for icon
---@field text string           -- Tag text
---@field last_user LuaPlayer   -- Last editing player
---@field tag_number uint       -- Unique tag number
---@field surface LuaSurface    -- Surface reference
---@field valid boolean         -- Validity flag
local ChartTag = {}

--- Returns the pos_string representation of the map_position
function ChartTag:get_pos_string()
  local helpers = require("lib.data_helpers")
  return helpers.map_position_to_pos_string(self.map_position)
end

--- Validates a ChartTag instance
---@param chart_tag ChartTag
---@return boolean
function ChartTag.validate(chart_tag)
  return type(chart_tag) == "table"
    and type(chart_tag.map_position) == "table"
    and type(chart_tag.map_position.x) == "number"
    and type(chart_tag.map_position.y) == "number"
    and type(chart_tag.text) == "string"
end

return ChartTag
