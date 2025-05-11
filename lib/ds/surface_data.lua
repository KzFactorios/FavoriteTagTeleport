---@class SurfaceData
---@field chart_tags table<string, ChartTag> -- Keyed by pos_string derived from map_position
---@field ext_tags table<string, ExtTag>
local SurfaceData = {}

--- Gets the chart_tags collection, auto-populating if nil or empty
---@param self SurfaceData
---@param player LuaPlayer
---@return table<string, ChartTag>
function SurfaceData:get_chart_tags(player)
  if not self.chart_tags or next(self.chart_tags) == nil then
    self.chart_tags = {}
    local chart_tags = player.force.find_chart_tags(player.physical_surface_index)
    local helpers = require("lib.data_helpers")
    for _, tag in pairs(chart_tags) do
      --local pos_string = helpers.map_position_to_pos_string(tag.position)
      self.chart_tags[tag.map_position] = tag
    end
  end
  return self.chart_tags
end

--- Gets the ext_tags collection
---@param self SurfaceData
---@return table<string, ExtTag>
function SurfaceData:get_ext_tags()
  self.ext_tags = self.ext_tags or {}
  return self.ext_tags
end

--- Adds an ExtTag to the ext_tags collection
---@param self SurfaceData
---@param ext_tag ExtTag
function SurfaceData:add_ext_tag(ext_tag)
  if not ext_tag or not ext_tag.pos_string then return end
  self.ext_tags = self.ext_tags or {}
  self.ext_tags[ext_tag.pos_string] = ext_tag
end

--- Removes an ExtTag from the ext_tags collection by pos_string
---@param self SurfaceData
---@param pos_string string
function SurfaceData:remove_ext_tag(pos_string)
  if not self.ext_tags or not pos_string then return end
  self.ext_tags[pos_string] = nil
end

--- Removes invalid chart_tags and their corresponding ext_tags
---@param self SurfaceData
function SurfaceData:remove_invalid_chart_tags()
  if not self.chart_tags then return end
  local to_remove = {}
  for pos_string, tag in pairs(self.chart_tags) do
    if not tag.valid then
      table.insert(to_remove, pos_string)
    end
  end
  for _, pos_string in ipairs(to_remove) do
    self.chart_tags[pos_string] = nil
    if self.ext_tags then
      self.ext_tags[pos_string] = nil
    end
  end
end

--- Resets the chart_tags collection to nil
---@param self SurfaceData
function SurfaceData:reset_chart_tags()
  self.chart_tags = nil
end

return SurfaceData
