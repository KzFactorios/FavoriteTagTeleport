---@class PlayerDataInstance
---@field favorites table<integer, {slot_locked: boolean, favorite: Favorite}>
---@field surfaces table<integer, any>
---@field show_fave_bar_buttons boolean
---@field render_mode string
---@field remove_favorite fun(self: PlayerDataInstance, slot_number: integer)
---@field set_show_fave_bar_buttons fun(self: PlayerDataInstance, show: boolean)
---@field get_favorite_by_slot fun(self: PlayerDataInstance, slot_number: integer): table|nil
---@field get_show_fave_bar_buttons fun(self: PlayerDataInstance): boolean
---@field set_render_mode fun(self: PlayerDataInstance, mode: string)
---@field get_render_mode fun(self: PlayerDataInstance): string
---@field set_favorite fun(self: PlayerDataInstance, slot_number: integer, favorite: Favorite, slot_locked: boolean?)

---@class PlayerData
---@field new fun(): PlayerDataInstance
local PlayerData = {}

---Create a new PlayerData instance
---@return PlayerDataInstance
function PlayerData.new()
    local instance = {
        favorites = {},
        surfaces = {},
        show_fave_bar_buttons = false,
        render_mode = defines.render_mode.game
    }
    
    function instance:remove_favorite(slot_number)
        if type(slot_number) == "number" then
            self.favorites[slot_number] = nil
        end
    end
    
    function instance:set_show_fave_bar_buttons(show)
        self.show_fave_bar_buttons = show
    end
    
    function instance:get_favorite_by_slot(slot_number)
        return self.favorites[slot_number]
    end
    
    function instance:get_show_fave_bar_buttons()
        return self.show_fave_bar_buttons
    end
    
    function instance:set_render_mode(mode)
        self.render_mode = mode
    end
    
    function instance:get_render_mode()
        return self.render_mode
    end
    
    function instance:set_favorite(slot_number, favorite, slot_locked)
        self.favorites[slot_number] = { slot_locked = slot_locked or false, favorite = favorite }
    end
    
    return instance
end

return PlayerData
