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

return ChartTag
