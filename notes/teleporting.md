```lua
function map_tag_utils.teleport_player_to_closest_position(player, target_position)
  if not player then return nil, "" end
  if not player.character then return nil, "" end

  if map_tag_utils.is_on_space_platform(player) then
    return nil,
        "The surgeon general has determined that teleportation on space platforms may incur death and is not authorized!"
  end

  context.qmtt.player_data[player.index].render_mode = player.render_mode
  local surface = player.surface
  local return_pos = nil
  local return_msg =
  "No valid teleport position found within the teleport radius. Please select another location or you could try increasing the search radius in settings. The hive mind discourages this practice as it will reduce the accuracy of your teleport landing points."

  local settings = add_tag_settings.getPlayerSettings(player)
  local teleport_radius = settings.teleport_radius
  
  if teleport_radius < add_tag_settings.TELEPORT_RADIUS_MIN then
    teleport_radius = add_tag_settings.TELEPORT_RADIUS_MIN
  elseif teleport_radius > add_tag_settings.TELEPORT_RADIUS_MAX then
    teleport_radius = add_tag_settings.TELEPORT_RADIUS_MAX
  end

  -- Find a non-colliding position near the target position
  local closest_position = surface.find_non_colliding_position(
    player.character.name, -- Prototype name of the player's character
    target_position,       -- Target position to search around
    teleport_radius,       -- Search radius in tiles
    4                      -- Precision (smaller values = more precise, but slower) Range 0.01 - 8
  -- fastest but coarse, use 2-4
  -- balanced, use 6
  -- high precision, slowest, use 8
  )

  if closest_position then
    local valid = player.surface.can_place_entity({ name = "character", position = closest_position })

    -- If a position is found, teleport the player there
    if valid then
      if player.teleport(closest_position, player.surface) then
        return_pos = closest_position
        return_msg = ""
        -- note that caller is currently handling raising of teleport event
      end
    end
  end

  return return_pos, return_msg
end


-- returns the position of the first colliding tag in the area
function map_tag_utils.position_has_colliding_tags(position, snap_scale, player)
  if not player then return nil end

  local collision_area = {
    left_top = {
      x = position.x - snap_scale + 0.1,
      y = position.y - snap_scale + 0.1
    },
    right_bottom = {
      x = position.x + snap_scale - 0.1,
      y = position.y + snap_scale - 0.1
    }
  }

  local colliding_tags = player.force.find_chart_tags(player.surface, collision_area)
  if colliding_tags and #colliding_tags > 0 then
    return colliding_tags[1].position
  end

  return nil
  --TODO RESEARCH return next(colliding_tags) ~= nil
end
```