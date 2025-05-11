# QuickMapTagTeleport Mod – Spec Sheet

## Overview
A Factorio mod that enhances map tag management and teleportation, providing a favorites bar, quick map tag editing, and custom GUI elements. The mod is designed for multiplayer and singleplayer, with robust event handling and persistent player data.

---

## Key Features
- **Quick Teleportation:** Hotkeys to teleport to favorite map tag locations. Ctrl + [number] (1,2,3,4,5,6,7,8,9,0). 0 acts as 10. 
- **favorites_GUI:** Custom GUI for managing and selecting favorite locations. The player can have 10 favorite locations/slots per surface (it would be a plus for the max number to be handled dynamically in the user settings). The favorites bar will only ever show the favorites for the current surface. The favorites bar shows the slots, horizontally in the top gui, with small icons, if defined, for each favorite on the surface. There is an additional first slot with the icon of a red heart. This red heart icon will toggle the display of the remaining buttons and is tied to the user_data[show_fave_bar_buttons] It also shows the slot number for easy navigation (ie corresponds to the hotkey number for the slot). A left click on the slot immediately teleports the player to the favorites location. A right click on a slot will open a dialog, Fave_Edit_GUI in the gui.screen. Icons for each fave are to be shown in each slot. each slot should be 32px x 32px

- **editor_GUI:** Custom GUI for adding, editing, and removing map tags. Should show the current icon for the tag as 50px x 50px in a picker where another icon can be selected with ease
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
- **`gui/favorites_GUI.lua`**: Handles displaying the current favorites for the current surface. Handles events triggered by slot interaction - right-click, left-click. Implement drag and drop within the favorites bar to order and reorder favorites
- **`gui/editor_GUI.lua`**: Manages a GUI to add and update map tags.


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
This is just my first stab at structure. If you see a better way, please feel free to chime in
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
        
        show_fave_bar_buttons = true/false,
        render_mode = player.render_mode
        },
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

## Error Handling & Edge Cases
chart tags should be validated before used or added to any collections. invalid tags should be removed from any chart_tags collections

Please suggest methods to handle GUI desyncs

All communication to the user should be handled via game.print

- we will be writing unit tests at some point in the future and run them using busted please create a folder for tests



## Other considerations
- lookout for any alien mod conflicts

- we will be using standard factorio events to interact with other mods

- player settings in storage
  - show_fave_bar_buttons - this is toggled by clicking on the first slot in the favorites_GUI 
  - render_mode - tracks the render_mode of the player so that we can react to events in proper context

- create a function or structure in the control.lua (call it on_first_tick) that will run once for each player when they begin the game either by starting a new game or when loading a save file.

- chart_tags have a 1-1 relationship with ext_tags. They should both cascade their deletes to the other
- all players should be able to change all things that they own. chart_tags should only be editable by the creator, with the exception that every player should be able to make any chart tag a favorite of their own even if created by another player. ext_tags will track, via the faved_by_players list,, what ursers have favorited the location. This allows for one game-global list per surface. If a player tries to edit another players chart_tag, there should be mechanisms in place to disallow editing other than being able to favorite that location

- as this is a new project, there is no need to tackle migrations just yet
- plan for localization. If opportunities for locale specific phrasing is in order, create the proper entries

- wherever possible, use caching strategies to mitigate performance issues. Chart_tags and ext_tags could be accessed frequently, so develop a strategy to aid performance

- this project will be debugged in vscode

- if it is not possible to teleport, the reason should be sohwn in the chat log

## mod settings
- we should have settings - per-player
  - Favorites Bar On. default = true. This allows for the player to toggle the entire favorites bar display on/off. You are still able to use the teleportation functionality. However, changing this value may wipe all of your current favorites data.
  - Teleport Messages On. default = true. Allows for toggling the output of the teleportation messages in the chat_log
  - Slots. default = 10. Allow for the player to select the amouint of favorites that can be displayed per surface. Possible/restrict choices to 10,15,20,25. If a user moves from a larger count to a smaller count, all favorites with data should be included in the new collection. If there are more favorites currently than in the new size, first condense all the active favorites into the structure and warn that others will be deleted.
  - Teleport Radius. default = 7. allowable values are 4-20. Number of tiles to offset when trying to teleport to a new location and that location is occupied. The collective mind suggests higher values for denser developments. 



  ## GUI/UX
  #### user flows
  ##### map view operations
  1. User right-clicks in render_mode = chart_view
    - the tag editor_GUI opens and has a cancel and confirm button on the bottom
    - a button on the top row displays the coordinates that were clicked and allows for direct teleportation to that location. The gui will close after teleporting
    - the tag editor also allows for editing of the tag's data: text, icon, display_text and display_description. 
    - The text field allows for an icon to be placed into the text. the text and icon fields are stored in the chart_tag object while the display_text and display_description are stored in the corresponding ext_tag
    - the cancel button will disregard any changes and close the gui
    - the confirm button will create or update a chart_tag and a corresponding ext_tag matched by the position string which is simplay a string representing the x coordinate, then a dot, then the y coordinate. Check for the value "-0" which should always be converted to 0. x and y coords should always allow for at least 3 digits in this field. eg: 000.-1350
    - chart_tag coords must be unique. It should not be possible to have more than one chart_tag or ext_tag per position
  2. User left-clicks on an existing chart tag in render_mode = chart_view
    - this should bring up the stock editor. No gui from our mod to display, instead our mod listens to the on_chart_tag_modified event and updates any matching chart_tags and corresponding ext_tag
  3. User right-clicks on a chart tag in render_mode = chart_view
    - the tag editor opens and is populated with the information for that chart_tag and its corresponding ext_tag
    - upon confirm, the information will be saved back to the chart_tag and ext_tag and the gui will close
##### favorites bar
1. User left clicks on the red heart button. 
- This toggles the show_fav_bar_buttons value and the favorites_gui shows or hides the remaining slot buttons according to the state of show_fav_bar_buttons
2. User hovers over a slot.
- a tooltip is shown with the text of the chart_tag and on the next line, the position, converted to a pos_string
3. User left-clicks on a favorite slot
- The player is instantly teleported to the favorite location
4. User right-clicks on a favorite slot
- The editor_GUI appears with the information for the selected favorite and allows editing as described prior
5. User clicks and drags a favorite slot
- the red heart slot is not available for this operation
- if the selection is dropped, than the order of the favorites should be updated to reflect the new order and the favorites bar should show the new order




   