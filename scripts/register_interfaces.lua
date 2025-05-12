-- Register the `ftt_editor_gui` remote interface
remote.add_interface("ftt_editor_gui", {
    open_for_favorite = function(player_index, slot_num)
        -- Placeholder implementation for opening the editor GUI for a favorite
        local player = game.get_player(player_index)
        if not player then
            error("Invalid player index: " .. tostring(player_index))
        end

        -- Log the action for now (replace with actual GUI logic later)
        game.print("Opening editor GUI for player " .. player.name .. " and slot " .. tostring(slot_num))
    end
})
