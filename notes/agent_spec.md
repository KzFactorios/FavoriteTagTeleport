# Agent Spec: Additional Details and Examples

This document supplements the main spec sheet with clarifications, strategies, and examples for areas previously identified as needing more detail.

---

## 1. Icon Handling

### Storage
- Store the icon as a string representing the sprite path (e.g., `item/iron-plate`).
- In the favorite/tag data structure:
  ```lua
  favorite = {
    pos_string = "...",
    icon = "item/iron-plate", -- sprite path string
    -- ...other fields
  }
  ```

### Validation
- When setting or loading an icon, validate with a helper:
  ```lua
  function is_valid_icon_path(sprite_path)
    return game.is_valid_sprite_path(sprite_path)
  end
  ```
- If invalid, fallback to `graphics/generic_marker.png`.

### Rendering
- In GUIs, use `sprite-button` with the stored sprite path.
- If the icon is missing/invalid, use the fallback.

### Integration Example
- When the user selects an icon in the picker, update the favorite/tag's `icon` field.
- When displaying, always validate before rendering.

---

## 2. Error Handling & Edge Cases

### GUI Desyncs
- Periodically (e.g., on_tick or on certain events), compare GUI state with expected data and refresh if mismatched.
- Provide a command `/ftt_refresh_gui` to force a full GUI rebuild for a player.

### Teleportation Failures
- If teleportation fails (e.g., blocked, invalid), print a message to the player:
  ```lua
  player.print{"ftt.teleport_failed", reason}
  ```
- Reasons could include: "Location blocked", "Invalid position", etc.

### Data Corruption
- On load, validate all persistent data. If corruption is detected, attempt to repair or reset affected entries and notify the user via `game.print`.

---

## 3. Migration & Versioning

- Store a `mod_version` in persistent data.
- On configuration change, compare stored version to current. If different, run migration scripts.
- Example:
  ```lua
  if global.mod_version ~= CURRENT_VERSION then
    migration.migrate(global, global.mod_version, CURRENT_VERSION)
    global.mod_version = CURRENT_VERSION
  end
  ```
- Migrations should be idempotent and log actions to the Factorio log.

---

## 4. Localization

- All user-facing strings should use locale keys (e.g., `{ftt.teleport_failed}`) and be defined in `locale/en/strings.cfg`.
- For dynamic text, use parameterized locale strings:
  ```lua
  player.print{"ftt.favorite_added", tag_name}
  ```
- When adding new features, always add corresponding locale keys.

---

## 5. Testing

- Place all tests in a `tests/` folder at the project root.
- Use [busted](https://olivinelabs.com/busted/) for unit testing.
- Example test file: `tests/test_favorite.lua`
  ```lua
  describe("Favorite Management", function()
    it("should add a favorite", function()
      -- test logic here
    end)
  end)
  ```
- Test cases should cover: data migration, GUI logic, teleportation logic, icon validation, and error handling.

---

## 6. Performance

- Use caching for frequently accessed data (e.g., chart_tags, ext_tags).
- Invalidate caches on relevant events (e.g., tag added/removed/modified, surface change).
- Example:
  ```lua
  function update_chart_tag_cache(surface_index)
    -- rebuild cache for surface
  end
  ```
- For large games, consider lazy loading or chunked updates.

---

## 7. Settings

- When a player changes settings (e.g., slot count), update their data structure accordingly.
- If reducing slot count, condense favorites and warn the player if any are lost.
- In multiplayer, settings changes should only affect the player who made the change.

---

## 8. Extensibility/API

- Expose a remote interface for other mods:
  ```lua
  remote.add_interface("ftt", {
    get_favorites = function(player_index) ... end,
    add_favorite = function(player_index, pos_string, icon) ... end,
    -- etc.
  })
  ```
- Document all available remote calls in the README.

---

## 9. Permissions/Access

- Only the creator of a chart_tag can edit/delete it.
- Any player can favorite any chart_tag.
- If a player tries to edit/delete another's tag, show a message: "You do not have permission to edit this tag."
- ext_tags track all players who have favorited a location via `faved_by_players`.

---

## 10. User Experience

- If a user tries to favorite a location already in their favorites, show a message: "This location is already in your favorites."
- Drag-and-drop reordering in multiplayer should lock the bar for the player during the operation and sync changes on drop.
- If a sync issue is detected, refresh the bar and notify the player.

---

## Example Locale Entries (locale/en/strings.cfg)
```
[ftt]
teleport_failed=Teleportation failed: {1}
favorite_added=Favorite added: {1}
permission_denied=You do not have permission to edit this tag.
already_favorited=This location is already in your favorites.
```

---

## Example Remote Interface Documentation (README excerpt)
```
### Remote Interface: ftt
- `get_favorites(player_index)` → Returns a table of the player's favorites.
- `add_favorite(player_index, pos_string, icon)` → Adds a favorite for the player.
- ...
```

---

## Example Test Directory Structure
```
tests/
  test_favorite.lua
  test_migration.lua
  test_icon_validation.lua
  ...
```

---

## Example GUI Refresh Command
```lua
commands.add_command("ftt_refresh_gui", "Refreshes the FTT GUI for the player", function(cmd)
  local player = game.get_player(cmd.player_index)
  if player then
    rebuild_ftt_gui(player)
    player.print{"ftt.gui_refreshed"}
  end
end)
```

---

## Example Cache Invalidation
```lua
function on_chart_tag_modified(event)
  update_chart_tag_cache(event.surface_index)
end
```

---

## Example Data Validation on Load
```lua
function validate_persistent_data()
  -- check all favorites, tags, etc. for validity
  -- repair or remove invalid entries
end
```

---

## Example for Handling Teleportation Failure
```lua
function try_teleport(player, position)
  if not can_teleport_to(position) then
    player.print{"ftt.teleport_failed", "Location blocked"}
    return false
  end
  -- teleport logic
end
```

---

## Example for Icon Validation and Fallback
```lua
function get_valid_icon(sprite_path)
  if is_valid_icon_path(sprite_path) then
    return sprite_path
  else
    return "generic_marker.png"
  end
end
```

---

## Example for Preventing Duplicate Favorites
```lua
function add_favorite(player_index, pos_string, icon)
  if is_already_favorited(player_index, pos_string) then
    game.get_player(player_index).print{"ftt.already_favorited"}
    return
  end
  -- add favorite logic
end
```

---

## Example for Drag-and-Drop Sync in Multiplayer
- Lock the bar for the player during drag.
- On drop, update order and broadcast to the player only.
- If a sync issue is detected (e.g., order mismatch), force a refresh and notify the player.

---

## End of Agent Spec
