Important Considerations
Surface Name:

To teleport to a space platform, you need to know the surface name. Space Exploration surfaces typically follow a naming convention like "Nauvis Orbit" or "Orbit <body>".
Use the following to list all available surfaces:
lua
Copy
Edit
for name, surface in pairs(game.surfaces) do
  game.print("Surface name: " .. name)
end
Target Position:

Ensure that the target_position is a valid location. If the position is invalid (e.g., outside the platform bounds or not on space tiles), the teleportation will fail.
Collision Rules in Space:

In the Space Exploration mod, certain areas require valid platform tiles (e.g., space scaffolding). Teleporting to an invalid location (like empty space without tiles) will likely cause the player or entity to fall and die.
Testing Before Teleporting:

Check if the position is valid using surface.can_place_entity() or similar checks:
lua
Copy
Edit
local is_valid = space_surface.can_place_entity({name = "character", position = target_position})
if is_valid then
  player.teleport(target_position, space_surface)
else
  player.print("Cannot teleport to that location; no valid platform!")
end


```lua
--- evaluates player surface and determines if player is in space
function map_tag_utils.is_on_space_platform(player)
  if not player then return false end
  if not player.surface then return false end
  if not player.surface.map_gen_settings then return false end

  -- Planets have either default/custom terrain gen or specific planet presets
  local map_gen = player.surface.map_gen_settings
  return map_gen.preset == "space-platform" or map_gen.preset == "space"
end
```