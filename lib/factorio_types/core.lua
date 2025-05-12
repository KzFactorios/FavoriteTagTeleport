---@class LuaPlayer
---@field gui table<string, any>  -- GUI roots (top, left, center, etc.)
---@field index integer
---@field print fun(msg: string|table)
---@field teleport fun(position: {x: number, y: number}, surface: any, raise_teleported?: boolean): boolean
---@field character any
---@field physical_surface_index integer
---@field physical_surface LuaSurface
---@field mod_settings table<string, any>

---@class LuaGameScript
---@field get_player fun(player_index: integer): LuaPlayer
---@field print fun(msg: string)
---@field players table<integer, LuaPlayer>

---@class LuaSurface
---@field name string
---@field index uint
---@field can_place_entity fun(name: string, position: {x: number, y: number}):boolean
---@field find_non_colliding_position fun(name:string, center:{x:number,y:number}, radius: number, precision: number): {x:number,y:number}

---@class LuaRemote
---@field call fun(self: LuaRemote, interface: string, method: string, ...: any): any
---@field interfaces table<string, table<string, function>>

---@alias uint integer  -- Alias for unsigned integers

---@class defines
---@field events table<string, integer>  -- Event definitions

---@type LuaGameScript
---@diagnostic disable-next-line: undefined-global
game = game

---@type table
---@diagnostic disable-next-line: undefined-global
global = global

---@type LuaRemote
---@diagnostic disable-next-line: undefined-global
remote = remote

---@type table
---@diagnostic disable-next-line: undefined-global
defines = defines

---@type LuaSettings
---@diagnostic disable-next-line: undefined-global
settings = settings
