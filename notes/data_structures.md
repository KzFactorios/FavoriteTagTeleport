pos_string: For a string that represents the position. format is xxx.yyy. Any values == 0 should not be prepended with a - sign. Ensure zero values return and are stored and displayed as an absolute value.
map_position: refers to a MapPosition

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