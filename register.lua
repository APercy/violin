local S = violin.S

core.register_tool("violin:violin", {
    description = S("Violin"),
    inventory_image = "violin_ico.png",
    stack_max=1,

    on_use = function(itemstack, player, pointed_thing)
        if not player then return end
        local player_meta = player:get_meta()

        local check_has_violin = player_meta:get_int("_has_violin")
        if check_has_violin == nil or check_has_violin == 0 then
            has_violin = violin.check_has_violin_attached(player)
            if has_violin == false then 
                violin.equip(player)
                player_meta:set_int("_has_violin",1)
            end
        end
    end,
})


core.register_craft({
    output = "violin:violin",
    recipe = {
	    {"",             "default:junglewood",  ""},
	    {"default:wood", "default:steel_ingot", "default:wood"},
	    {"default:wood", "default:junglewood",  "default:wood"},
    },
})

