-- Minetest 5.4.1 : airutils
violin = {}

violin.S = nil
violin.mod_name = core.get_current_modname()

if(core.get_translator ~= nil) then
    violin.S = core.get_translator(violin.mod_name)
else
    violin.S = function ( s ) return s end
end

local S = violin.S

local path = core.get_modpath(violin.mod_name) .. DIR_DELIM
dofile(path .. "hud.lua")
dofile(path .. "entities.lua")
dofile(path .. "register.lua")

core.register_on_joinplayer(function(player)
    local player_meta = player:get_meta()
    player_meta:set_int("_has_violin", 0)
end)

