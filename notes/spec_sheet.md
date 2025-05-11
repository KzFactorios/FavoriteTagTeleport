# QuickMapTagTeleport Mod – Spec Sheet

## Overview
A Factorio mod that enhances map tag management and teleportation, providing a favorites bar, quick map tag editing, and custom GUI elements. The mod is designed for multiplayer and singleplayer, with robust event handling and persistent player data.

---

## Key Features
- **Quick Teleportation:** Hotkeys to teleport to favorite map tag locations. Ctrl + [number] (1,2,3,4,5,6,7,8,9,0). 0 acts as 10. 
- **fbar_GUI:** Custom GUI for managing and selecting favorite locations. The player can have 10 favorite locations/slots per surface (it would be a plus for the max number to be handled dynamically in the user settings). The favorites bar will only ever show the favorites for the current surface. The favorites bar shows the slots, with small icons, if defined, for each favorite on the surface. It also shows the slot number for easy navigation (ie corresponds to the hotkey number for the slot). A left click on the slot immeddiately teleports the player to the favorites location. A right click on a slot will open a dialog, Fave_Edit_GUI in the gui.screen 

- **tag_editor_GUI:** Custom GUI for adding, editing, and removing map tags.
- **Uses the existing map tag editor** Not all functionality can be implemented in our custom guis. 
- **Persistent Data:** Player favorites and settings are stored using a context-based schema. See below for further explanation of the structure
- **Custom Input Events:** Hotkeys and custom input events for fast actions.
- **Multiplayer considerations are imperative!** individual player settings should not apply to all players. Each player can have their own preferences for showing the fave bar gui and using the favorites at all. Each player's favorites are their own. Other players should be able to see anotther players tags, but as far as favorites go, they are per-player and not shared with other players. It would be nice to flesh out a sharing system at some point.
---

## Core Modules

### 1. `control.lua`
- Main entry point for event registration and mod lifecycle.
- Handles Factorio events: player join/leave, configuration changes, runtime settings, tick events, and custom input.
- Initializes and updates GUIs for all players.

### 2. GUI Modules
- **`gui/fbar_GUI.lua`**: Handles displaying the current favorites for the current surface. Handles events triggered by slot interaction - right-click, left-click. Implement drag and drop within the favorites bar to order and reorder favorites
- **`gui/tag_editor_GUI.lua`**: Manages a GUI to add and update map tags.


### 3. `lib/context.lua`
- **Persistent data storage and schema management.**
- Replaces legacy `storage` module.
- Provides player data access, inits all data structures

### 4. 'lib/favorite.lua'
- Handles favorites management

### 5. `scripts/event_handlers/custom_input_event_handler.lua`
- Handles custom input events (hotkeys, GUI triggers).

### 6. `utils/map_tag_utils.lua`
- Utility functions for map tag position, collision, and teleportation logic.

### 7. `settings/constants.lua` and `settings/add_tag_settings.lua`
- Defines mod constants, event names, and per-player settings.

### 8. `lib/ext_tag.lua
- relates to chart_tags and provides for handling extended details

### 9. the "migrations" folder
- stores any migrations for version changes
 - On mod version change, `migration.migrate(context)` is called if needed.
---

## Data Flow & Architecture

- **Event-Driven:** All user actions and game events are handled via Factorio’s event system, with custom events for mod-specific actions.
- **Persistent Context:** All player and mod data is stored in a context object, ensuring safe migration and multiplayer compatibility.

---

## Storage Structure (Persistent Data)

- **All persistent data is managed via the `context` module.**
- The storage schema is player-centric and surface-aware, supporting multiplayer and multiple surfaces.
- **Typical structure:**
  ```lua
  storage = {
    
    players = {
      [player_index] = {
          [surface_index] = {
            favorites = {
              [slot_number] = {
                slot_locked: boolean,
                favorite = {
                  pos_string: string,
                }
              },
            }
            ...
          },
          ...
        },
        show_fave_bar_buttons = true/false,
        render_mode = player.render_mode
      },
    
    surfaces = {
        [surface_index] = {
          chart_tags = {
            {
              -- chart_tag objects are to be cached for the surface
              -- these are shared by all players
              -- this collection is constructed by calling player.force.findd_chart_tags(surface_index)
            }
          },
          ext_tags = {
            -- ext_tag objects are to be cached for the surface
              -- these are shared by all players
              ext_tag = {
                pos_string,
                faved_by_players {
                  list of player indices that have favorited this position
                },
                display_text,
                display_description
              }
          }
        }
      }
      ...
    },
    ... -- other global mod data
  }
  ```

---

## Initialization & Lifecycle

- **`on_init`:** Initializes context, GUI structures, registers GUI handlers, and sets up all player GUIs.
- **`on_load`:** Rebuilds GUI lookup tables.
- **`on_configuration_changed`:** Handles mod upgrades, migration, and player re-initialization.
- **Player Events:** Handles player join, leave, and removal, cleaning up GUIs and data as needed.

---

## Coding Patterns & Best Practices

- **No Direct Requires Between GUI Modules:** Absolutely structure the code to prevent circular dependencies.
- **Event Handler Centralization:** All custom input and GUI events are handled in dedicated modules.
- **Debug Logging:** Conditional debug logging using `context.__DEBUG`.
- try to keep files sizes as small as possible even if it means creating other files for better organization and readability

---

## Extensibility

- **Custom Events:** Use `script.generate_event_name()` for new mod events.
- **Settings:** Extend `add_tag_settings.lua` and `constants.lua` for new per-player or global settings.

---

## Known Limitations / Gotchas

- **No Code After Return:** Lua ignores code after a `return` statement.

---

