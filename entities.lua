local S = violin.S

local sol_chord = {"247399__mtg__overall-quality-of-single-note-violin-g3",
                    "247401__mtg__overall-quality-of-single-note-violin-a3",
                    "247402__mtg__overall-quality-of-single-note-violin-b3",
                    "247404__mtg__overall-quality-of-single-note-violin-c4",
                    "247406__mtg__overall-quality-of-single-note-violin-d4"}

local re_chord = {"247405__mtg__overall-quality-of-single-note-violin-d4",
                    "247407__mtg__overall-quality-of-single-note-violin-e4",
                    "247408__mtg__overall-quality-of-single-note-violin-f4",
                    "247430__mtg__overall-quality-of-single-note-violin-g4",
                    "247410__mtg__overall-quality-of-single-note-violin-a4"}

local la_chord = {"247409__mtg__overall-quality-of-single-note-violin-a4",
                    "247411__mtg__overall-quality-of-single-note-violin-b4",
                    "247412__mtg__overall-quality-of-single-note-violin-c5",
                    "247413__mtg__overall-quality-of-single-note-violin-d5",
                    "247415__mtg__overall-quality-of-single-note-violin-e5"}

local mi_chord = {"247415__mtg__overall-quality-of-single-note-violin-e5",
                    "247416__mtg__overall-quality-of-single-note-violin-f5",
                    "247417__mtg__overall-quality-of-single-note-violin-g5",
                    "247419__mtg__overall-quality-of-single-note-violin-a5",
                    "247447__mtg__overall-quality-of-single-note-violin-b5"}



local function note_play(self, ctrl, player)
    if not ctrl then return end

    if self.is_playing_note ==nil then self.is_playing_note = false end

    local pitch_angle = math.deg(player:get_look_vertical())

    local curr_chord = mi_chord
    local chord_index = 1
    if pitch_angle > 0 then
        chord_index = 2
        curr_chord = la_chord
    end
    if pitch_angle > 10 then
        chord_index = 3
        curr_chord = re_chord
    end
    if pitch_angle > 20 then
        chord_index = 4
        curr_chord = sol_chord
    end
   
    local note_index = 1

    if ctrl.right then note_index = 2 end
    if ctrl.down then note_index = 3 end
    if ctrl.left then note_index = 4 end
    if ctrl.sneak then note_index = 5 end
    
    local note = curr_chord[note_index] or ''

    if ctrl.dig then
        if self.is_playing_note == false then
            self._note = core.sound_play(note, {
                        object = self.object,
                        gain = 1.0,
                        fade = 0.0,
                        pitch = 1.0,
                        loop = false,
                    }, false)
            self.is_playing_note = true
        end
    else
        if self.is_playing_note == true and self._note then
            core.sound_stop(self._note)
            self._note = nil
            self.is_playing_note = false
        end
    end
    violin.update_hud(self, player, chord_index, note_index)
end

function violin.check_has_violin_attached(player)
    if not player then return true end
    local obj_children = player:get_children()
    local lua_ent = nil
    local has_violin = false
    for _, child in ipairs(obj_children) do
        lua_ent = nil
        lua_ent = child:get_luaentity()
        if lua_ent then
	        if lua_ent.name == "violin:instrument" then
                has_violin = true
                break
	        end
        end
    end

    return has_violin
end

function violin.equip(player)
    if not player then
        return
    end

    local pos = player:get_pos()
    local pname = player:get_player_name()

	local violin = core.add_entity(pos, "violin:instrument", staticdata)
	if violin then
        local ent = violin:get_luaentity()
        if ent then
		    violin:set_yaw(player:get_look_horizontal())

            violin:set_attach(player, "", {x = -4.2, y = 13, z = 2}, {x = 0, y = 20, z = 0})

            player:set_bone_override("Head", {rotation = {vec = {x=0, y=math.rad(-60), z=0}, absolute = true}})
            player:set_bone_override("Arm_Left", {rotation = {vec = {x=math.rad(-30), y=0, z=math.rad(-95)}, absolute = true}})
            player:set_physics_override({speed = 0,})
            ent.violin = violin

            local player_meta = player:get_meta()
            player_meta:set_int("_has_violin",1)
        end
	end
end

core.register_entity('violin:instrument',{
    initial_properties = {
	    physical = false,
	    collide_with_objects=false,
	    pointable=false,
        backface_culling = false,
	    visual = "mesh",
	    mesh = "violin.glb",
        visual_size = {x = 1, y = 1, z = 1},
	    textures = {"violin_wood_dark.png",
                    "violin_wood.png",
                    "violin_wood_light.png", --cavalete
                    "violin_chords.png",
                    },
	},
    _muted = true,
	
    on_activate = function(self,std)
	    self.sdata = core.deserialize(std) or {}
        
        core.after(1, function()
            self._muted = false
        end)

	    if self.sdata.remove then self.object:remove() end
    end,
	    
    get_staticdata=function(self)
      self.sdata.remove=true
      return core.serialize(self.sdata)
    end,

    on_step=function(self, dtime)
        local player = self.violin:get_attach()
        if not player then
            self.violin:remove()
            return
        end

		local ctrl = player:get_player_control()
        if not ctrl or self._muted == true then return end

        --TODO play the selected note
        note_play(self, ctrl, player)

        --remove the violin
        if ctrl.place then
            self.violin:remove()
            player:set_bone_override("Head", nil)
            player:set_bone_override("Arm_Left", nil)
            player:set_physics_override({speed = 1,})
            violin.remove_hud(player)

            local player_meta = player:get_meta()
            player_meta:set_int("_has_violin",0)
        end
    end
})
