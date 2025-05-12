---@diagnostic disable-next-line: undefined-global
local data = data

local PREFIX = require("settings/constants").PREFIX

local gui_style = data.raw["gui-style"].default

--- gui_style[PREFIX .. "add_tag_table"] = {
---  type = "table_style",
---  horizontal_spacing = 8
---}

data:extend({
  {
    type = "button_style",
    name = "ftt_favorite_slot_btn_dragging",
    parent = "slot_button",
    default_graphical_set = {
      base = {position = {68, 17}, corner_size = 8, tint = {r=1, g=0.8, b=0.2, a=1}}
    },
    hovered_graphical_set = {
      base = {position = {68, 17}, corner_size = 8, tint = {r=1, g=1, b=0.4, a=1}}
    },
    clicked_graphical_set = {
      base = {position = {68, 17}, corner_size = 8, tint = {r=1, g=0.6, b=0.1, a=1}}
    },
    border = true,
    border_color = {r=1, g=0.8, b=0.2, a=1},
    size = 32,
    padding = 2,
  },
  {
    type = "button_style",
    name = "ftt_favorite_slot_btn_drop_target",
    parent = "slot_button",
    default_graphical_set = {
      base = {position = {68, 17}, corner_size = 8, tint = {r=0.2, g=0.8, b=1, a=1}}
    },
    hovered_graphical_set = {
      base = {position = {68, 17}, corner_size = 8, tint = {r=0.4, g=1, b=1, a=1}}
    },
    clicked_graphical_set = {
      base = {position = {68, 17}, corner_size = 8, tint = {r=0.1, g=0.6, b=1, a=1}}
    },
    border = true,
    border_color = {r=0.2, g=0.8, b=1, a=1},
    size = 32,
    padding = 2,
  }
})
