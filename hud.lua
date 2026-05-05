violin.hud_list = {}

function violin.update_hud(self, player, chord_index, note_index)
    if player == nil then return end
    local player_name = player:get_player_name()

    local screen_pos_x = 0.3
    local screen_pos_y = 0.5

    local chord_y = 0
    if chord_index == 1 then
        chord_y = -205
    elseif chord_index == 2 then
        chord_y = -150
    elseif chord_index == 3 then
        chord_y = -95
    elseif chord_index == 4 then
        chord_y = -40
    else
        chord_y = -205
    end

    local note_x = 0
    local note_y = chord_y - 8
    
    if note_index == 1 then
        note_x = -500
    elseif note_index == 2 then
        note_x = -195 -- -109
    elseif note_index == 3 then
        note_x = -147 -- -157.5
    elseif note_index == 4 then
        note_x = -99 -- -206
    elseif note_index == 5 then
        note_x = -51 -- -254.5
    end

    local ids = violin.hud_list[player_name]
    if ids then
        --mark selected chord
        player:hud_change(ids["chord"], "offset", {x = 0.0, y = chord_y})
        player:hud_change(ids["note"], "offset", {x = note_x, y = note_y})

    else
        ids = {}

        ids["title"] = player:hud_add({
            type = "text",
            position  = {x = screen_pos_x, y = screen_pos_y},
            offset    = {x = -100, y = 0.0},
            text      = "Hand First Position",
            alignment = { x = -1.0, y = -1.0 },
            scale     = { x = 150, y = 30},
            number    = 0xFFFFFF,
        })

        ids["chord"] = player:hud_add({
            type = "image",
            position  = {x = screen_pos_x, y = screen_pos_y},
            offset    = {x = 0.0, y = chord_y},
            text      = "violin_map_chord_marker.png",
            scale     = { x = 1.0, y = 1.0},
            alignment = { x = -1.0, y = -1.0 },
        })

        ids["bg"] = player:hud_add({
            type = "image",
            position  = {x = screen_pos_x, y = screen_pos_y},
            offset    = {x = 0.0, y = 0.0},
            text      = "violin_notes_mi.png",
            scale     = { x = 1.0, y = 1.0},
            alignment = { x = -1.0, y = -1.0 },
        })

        ids["note"] = player:hud_add({
            type = "image",
            position  = {x = screen_pos_x, y = screen_pos_y},
            offset    = {x = note_x, y = note_y},
            text      = "violin_notes_marker.png",
            scale     = { x = 1.0, y = 1.0},
            alignment = { x = -1.0, y = -1.0 },
        })

        violin.hud_list[player_name] = ids
    end
end


function violin.remove_hud(player)
    if player then
        local player_name = player:get_player_name()
        --minetest.chat_send_all(player_name)
        local ids = violin.hud_list[player_name]
        if ids then
            player:hud_remove(ids["title"])
            player:hud_remove(ids["chord"])
            player:hud_remove(ids["bg"])
            player:hud_remove(ids["note"])
        end
        violin.hud_list[player_name] = nil
    end

end
