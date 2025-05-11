---@param favorite Favorite
---@return boolean
local function validate_favorite(favorite)
  return type(favorite) == "table" and type(favorite.pos_string) == "string"
end

---@param chart_tag ChartTag
---@return boolean
local function validate_chart_tag(chart_tag)
  return type(chart_tag) == "table"
    and type(chart_tag.map_position) == "table"
    and type(chart_tag.map_position.x) == "number"
    and type(chart_tag.map_position.y) == "number"
    and type(chart_tag.text) == "string"
end

---@param ext_tag ExtTag
---@return boolean
local function validate_ext_tag(ext_tag)
  return type(ext_tag) == "table" and type(ext_tag.pos_string) == "string" and type(ext_tag.display_text) == "string"
end

return {
  validate_favorite = validate_favorite,
  validate_chart_tag = validate_chart_tag,
  validate_ext_tag = validate_ext_tag
}
