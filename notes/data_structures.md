# Data Layer Structures and Conventions

## notes
the following is only included for developer reference. Do not act to follow any of the informationn
https://forums.kleientertainment.com/forums/topic/159850-tutorial-vs-code-lua-extension-with-dst-setup/

## utilize the lua language server extension
- annotate code with LuaCATS/Emmy-lua style for all code

## pos_string
- A string representation of a map position, formatted as `xxx.yyy`.
- Zero values should be stored and displayed as absolute (no negative sign for zero).
- Used as a unique key for chart_tags and ext_tags.

## MapPosition
- Table: `{x = double, y = double}` or shorthand `{double, double}`.
- Used for all position storage and calculations.

## Favorite Structure (Expanded)
```lua
favorite = {
  pos_string = "123.456",         -- Unique string for position
}

```
a favorite will combine information stored in chart_tag and ext_tag based on matching a pos_string to a mapPosition or a pos_string to pos_string

## Chart Tag Structure (Expanded, should mimic LuaCustomChartTag)
```lua
chart_tag = {
  pos_string = "123.456",         -- Unique string for position
  icon = "item/iron-plate",       -- Sprite path for icon
  text = "My Tag",                -- Tag text
  last_user = LuaPlayer,           -- Last editing player
  tag_number = uint,               -- Unique tag number
  surface = LuaSurface,            -- Surface reference
  valid = boolean,                 -- Validity flag
}
```

## Extended Tag Structure (Expanded)
```lua
ext_tag = {
  pos_string = "123.456",         -- Unique string for position
  display_text = "Display Name",  -- Display name for UI
  display_description = "...",    -- Description for UI
  faved_by_players = { [player_index] = true, ... },
  -- Other ext_tag fields as needed
}
```

## Storage Schema (Expanded Summary)
```lua
storage = {
  mod_version = "0.0.01",
  players = {
    [player_index] = {
      [surface_index] = {
        favorites = { [slot_number] = { slot_locked = false, favorite = { ... } }, ... },
        -- ...
      },
      show_fave_bar_buttons = true,
      render_mode = "chart-view",
      -- ...
    },
    -- ...
  },
  surfaces = {
    [surface_index] = {
      chart_tags = { [pos_string] = chart_tag, ... },
      ext_tags = { [pos_string] = ext_tag, ... },
    },
    -- ...
  },
  -- ...
}
```

## Data Layer Helper Conventions
- Always validate `icon` paths before use; fallback to `generic_marker.png` if invalid.
- Use `pos_string` as the unique key for all tag lookups. Provide helpers to convert between MapPosition and pos_string.
- Store timestamps for creation and modification if you want to support future features like sorting or auditing.
- All helpers for access, mutation, and validation should be implemented in `lib/context.lua`.

## ClassLuaCustomChartTag
https://lua-api.factorio.com/stable/classes/LuaCustomChartTag.html
A custom tag that shows on the map view.

Members
destroy()		
Destroys this tag.

icon	:: RW SignalID	
This tag's icon, if it has one. [...]

last_user	:: RW LuaPlayer?	
The player who last edited this tag.

position	:: R MapPosition	
The position of this tag.

text	:: RW string	
tag_number	:: R uint	
The unique ID for this tag on this force.

force	:: R LuaForce	
The force this tag belongs to.

surface	:: R LuaSurface	
The surface this tag belongs to.

valid	:: R boolean	
Is this object valid? [...]

object_name	:: R string	
The class name of this object. [...]

Methods
destroy() 
Destroys this tag.

Attributes
icon :: Read|Write SignalID   
This tag's icon, if it has one. Writing nil removes it.

last_user :: Read|Write LuaPlayer  ?
The player who last edited this tag.

position :: Read MapPosition   
The position of this tag.

text :: Read|Write string   
tag_number :: Read uint   
The unique ID for this tag on this force.

force :: Read LuaForce   
The force this tag belongs to.

surface :: Read LuaSurface   
The surface this tag belongs to.

valid :: Read boolean   
Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be false. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.

object_name :: Read string   
The class name of this object. Available even when valid is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.

## MapPosition :: table or {double, double}
https://lua-api.factorio.com/stable/concepts/MapPosition.html
Coordinates on a surface, for example of an entity. MapPositions may be specified either as a dictionary with x, y as keys, or simply as an array with two elements.

Positive values should show an absolute value. Never prepend a plus sign.
Zero should be treated as an absolute value and should show a minus sign.

The coordinates are saved as a fixed-size 32 bit integer, with 8 bits reserved for decimal precision, meaning the smallest value step is 1/2^8 = 0.00390625 tiles.

Table fields
x	:: double	
y	:: double	
Examples
-- Explicit definition
{x = 5.5, y = 2}
{y = 2.25, x = 5.125}
-- Shorthand
{1.625, 2.375}

# Data Layer Class Design (LuaCATS/Emmy-lua style)

---

---@class Favorite
---@field pos_string string  -- Unique string for position
local Favorite = {}

---

---@class ChartTag
---@field position      -- A MapPosition Unique string for position
---@field icon string           -- Sprite path for icon
---@field text string           -- Tag text
---@field last_user LuaPlayer   -- Last editing player
---@field tag_number uint       -- Unique tag number
---@field surface LuaSurface    -- Surface reference
---@field valid boolean         -- Validity flag
local ChartTag = {}

---

---@class ExtTag
---@field pos_string string           -- Unique string for position
---@field display_text string         -- Display name for UI
---@field display_description string  -- Description for UI
---@field faved_by_players table<integer,> -- Set of player indices
local ExtTag = {}

---

---@class PlayerData
---@field favorites table<integer, {slot_locked: boolean, favorite: Favorite}>
---@field show_fave_bar_buttons boolean
---@field render_mode string
local PlayerData = {}

---

---@class SurfaceData
---@field chart_tags table<string, ChartTag>
---@field ext_tags table<string, ExtTag>
local SurfaceData = {}

---

---@class Storage
---@field mod_version string
---@field players table<integer, PlayerData>
---@field surfaces table<integer, SurfaceData>
local Storage = {}

---

-- Helper: Convert MapPosition to pos_string
---@param pos {x: number, y: number}
---@return string
local function map_position_to_pos_string(pos)
  -- Implementation here
end

-- Helper: Convert pos_string to MapPosition
---@param pos_string string
---@return {x: number, y: number}
local function pos_string_to_map_position(pos_string)
  -- Implementation here
end




-- Helper: Validate icon path
---@param icon string
---@return string
local function get_valid_icon(icon)
  -- Implementation here (fallback to generic_marker.png if invalid)
end