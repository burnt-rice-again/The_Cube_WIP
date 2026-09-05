
--- ENABLE CHEATS HERE
local Unlock_All_Technologies = true
local Start_with_Observers = false



local package = ...
-- called when starting a new game (skipped when loading a save or joining a multiplayer game)
function package:setup_scenario(settings)
	--settings.skip_explorables = true
	--BuildDefinitionTooltip('metalore')
end

-- called when mod is initializing
function package:init()
	print("init scenario file")
	Game.GetModPackage("Main/Freeplay").on_player_faction_spawn = nil
	Game.GetModPackage("Main/Freeplay").on_world_spawn = nil
	Game.GetModPackage("Main/Freeplay").setup_scenario = nil
	data.world_events = {}
	data.explorables.graveyard_drop = nil
	data.codex.x_human_robot_datacube = nil
	data.codex.x_human_human_datacube = nil
	data.codex.x_freeplay_restart = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_techtree = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_start = nil
	data.codex.x_freeplay_start = nil



end

-- called when starting up a new game
function package:on_world_spawn()
	local bug_faction = GetBugsFaction()

	local faction_time_bots = Map.CreateFaction("time_bots")
	faction_time_bots.default_trust = "ENEMY"

	



end

local function tester_spawn_observers(faction, x,y)
	local size = 100
	local tower = Map.CreateEntity(faction, 'fc_testing_observer')
	tower:Place(x+size,y+size)
	tower = Map.CreateEntity(faction, 'fc_testing_observer')
	tower:Place(x+size,y-size)
	tower = Map.CreateEntity(faction, 'fc_testing_observer')
	tower:Place(x-size,y+size)
	tower = Map.CreateEntity(faction, 'fc_testing_observer')
	tower:Place(x-size,y-size)
end


-- called when a new player faction is spawned or respawned
--- Start with an adv base + cube 
function package:on_player_faction_spawn(faction, is_respawn)
	local settings = Map.GetSettings()
	if settings.unlock_all_techs == true then Unlock_All_Technologies = true end
	if settings.library then faction.extra_data.library = Tool.Copy (settings.library) end 

	
	-- starting techs 
	faction:Unlock("tc_robot_basic")
	faction:Unlock("tc_cube_basic")
	faction:Unlock("tc_upgrades_basic")
	-- Research Unlock for testing 
	if Unlock_All_Technologies then 
		for key, val in pairs(data.techs) do 
			if "tc_" == string.sub(key, 1, 3) then 
				faction:Unlock(key)
			end
		end
	end
	-- blightness
	faction.extra_data.blight_fog = 1
	faction.has_blight_shield = true

	-- set player trust  
	faction:SetTrust("time_bots","ENEMY", true)
	
	-- select starting location for player faction
	faction.home_location = GetPlayerFactionHomeOnGround()
	local loc = faction.home_location

	--addfoundations for start
	local start_area_size = 8
	CreateFoundationsFromCentre(loc.x+1, loc.y+1, start_area_size,start_area_size,"f_human_foundation_basic",faction)
	loc.x = loc.x + 1
	loc.y = loc.y + 1

	--spawn wals 
	for n = -start_area_size, start_area_size do 
		if n > 2 or n < -2 then 
			--horizontal
			local wall = Map.CreateEntity(faction, "f_wall")
			wall:Place(loc.x + n, loc.y+start_area_size, false)
			wall = Map.CreateEntity(faction, "f_wall")
			wall:Place(loc.x + n, loc.y-start_area_size, false)
			--vertical
			wall = Map.CreateEntity(faction, "f_wall")
			wall:Place(loc.x + start_area_size, loc.y+n, false)
			wall = Map.CreateEntity(faction, "f_wall")
			wall:Place(loc.x - start_area_size, loc.y+n, false)

		end
	end

	-- spawn home building
	local home_entity = Map.CreateEntity(faction, "f_landingpod",true)
	home_entity:AddComponent("cc_cube_storage")
	home_entity:AddComponent("cc_manifest")
	home_entity:AddComponent("c_higrade_capacitor")
	home_entity:AddComponent("c_internal_field")
	
	home_entity:AddItem("ic_cube_blue")
	home_entity:AddItem("datakey_robot", 40)
	home_entity:AddItem("cc_cube_storage", 2)
	home_entity:AddItem("cc_crystal_power", 1)
	home_entity:AddItem("c_assembler", 1)
	home_entity:AddItem("c_fabricator", 2)
	home_entity:Place(loc.x-1, loc.y-1)
	faction.home_entity = home_entity

	local new_entity = Map.CreateEntity(faction, "f_building1x1a")
	new_entity:AddComponent("c_fabricator")
	new_entity:SetRegister(5,{id="metalplate",num=REG_INFINITE})
	new_entity:AddItem("metalplate", 40)
	new_entity:Place(loc.x-2, loc.y+2)
	-- -- spawn ore miner
	local miner1 = Map.CreateEntity(faction, "f_bot_1s_adw")
	miner1:AddComponent("c_adv_miner")
	miner1:AddComponent("c_capacitor")
	miner1:AddComponent("c_portable_radar")
	miner1:Place(loc.x,loc.y+2)
	miner1 = Map.CreateEntity(faction, "f_bot_1s_adw")
	miner1:AddComponent("c_adv_miner")
	miner1:AddComponent("c_capacitor")
	miner1:AddComponent("c_portable_radar")
	miner1:Place(loc.x+1,loc.y+2)
	miner1 = Map.CreateEntity(faction, "f_bot_1s_adw")
	miner1:AddComponent("c_adv_miner")
	miner1:AddComponent("c_capacitor")
	miner1:AddComponent("c_portable_radar")
	miner1:Place(loc.x-1,loc.y+2)

	--spawn power source 
	local new_entity = Map.CreateEntity(faction, "f_building2x1f")
	new_entity:AddComponent("cc_cube_storage")
	new_entity:AddComponent("cc_crystal_power")
	new_entity:AddComponent("c_capacitor")
	new_entity:AddComponent("c_capacitor")
	--new_entity:AddItem("ic_cube_empty", 1)
	new_entity:AddItem("crystal", 80)
	new_entity:Place(loc.x+5, loc.y-5)

	-- resource metal
	new_entity = Map.CreateEntity("world", "f_resourcenode_metal", "v_2x2_a_ruined")
	new_entity:SetRegister(FRAMEREG_GOTO, {id="metalore",num=math.random(10000, 25000)})
	new_entity:Place(loc.x-7, loc.y+7,2)
	-- resource crystal
	new_entity = Map.CreateEntity("world", "f_resourcenode_crystal", "v_crystalmedium1a")
	new_entity:SetRegister(FRAMEREG_GOTO, {id="crystal",num=math.random(2000, 5000)})
	new_entity:Place(loc.x+7, loc.y+7,2)
	new_entity = Map.CreateEntity("world", "f_resourcenode_crystal", "v_crystalmedium1b")
	new_entity:SetRegister(FRAMEREG_GOTO, {id="crystal",num=math.random(2000, 5000)})
	new_entity:Place(loc.x+6, loc.y+7,2)
	new_entity = Map.CreateEntity("world", "f_resourcenode_crystal", "v_crystalsmalla")
	new_entity:SetRegister(FRAMEREG_GOTO, {id="crystal",num=math.random(500, 2500)})
	new_entity:Place(loc.x+7, loc.y+6,2)

	-- spawn consturction fliers 
	local flier = Map.CreateEntity(faction, "f_flyer_bot")
	flier.logistics_carrier = true
	flier.disconnected = false
	flier:Place(loc.x+4,loc.y+3)

	-- cub with cube transporter 
	local transport = Map.CreateEntity(faction, "f_bot_1m_a")
	transport:AddComponent("cc_cube_storage")
	--transport:AddItem("ic_cube_empty")
	transport:GetSlot(1):SetLockedItem()
	transport:GetSlot(2):SetLockedItem()
	transport.logistics_carrier = true
	transport.disconnected = false
	transport.extra_data.name = "CUBEy"
	transport:Place(loc.x+4,loc.y+4)

		--- new game plus bots 
	if (settings.extra_bots) then 
		for key, val in pairs(settings.extra_bots) do
			--local ent = Map.CreateEntity(faction, val.frame)
			local ent = CreateFrameOrBlueprint(faction, val)
			-- local ent = Tool.StringToTable(val.ent)
			-- ent.powered_down = false
			-- if val.behavior_id then 
			local b_comp = ent:FindComponent("c_behavior", true, 1, true)
			if b_comp ~= nil and b_comp.has_extra_data and b_comp.extra_data.main_id then 
				SetBehavior(b_comp, b_comp.extra_data.main_id)
				-- SetBehavior(b_comp, val.behavior_id)
				--Action.SendForEntity("Behavior", ent, { comp = b_comp })

			end
			ent:Place(loc.x-8,loc.y)
		end
	end



	------------------------------
	-- testing buildings 


	--spawn Farming Tester
	-- new_entity = Map.CreateEntity(faction, "f_building2x2c")
	-- new_entity:AddComponent("cc_planter_phase_leaf")
	-- new_entity:AddItem("cc_planter_wire")
	-- new_entity:AddComponent("cc_cube_storage")
	-- new_entity:AddComponent("c_adv_portable_turret")
	-- new_entity:AddItem("ic_cube_green", 1)
	-- new_entity:AddItem("crystal_powder", 10)
	-- new_entity:AddItem("c_deconstructor", 1)
	-- new_entity:AddItem("steelblock", 40)
	-- new_entity:AddItem("c_portable_radar", 2)
	-- new_entity:AddItem("c_deconstructor", 1)
	-- home_entity:AddItem("cc_manifest")
	-- new_entity:Place(loc.x+13, loc.y)

	-- new_entity = Map.CreateEntity(faction, "f_building2x2c")
	-- new_entity:AddComponent("c_blight_magnifier")
	-- new_entity:AddComponent("cc_cube_storage")
	-- new_entity:AddComponent("c_blight_terraformer")
	-- new_entity:AddItem("ic_cube_green", 1)
	-- new_entity:Place(loc.x+13, loc.y)
	-- new_entity = Map.CreateEntity("world", "f_resourcenode_metal", "v_2x2_a_ruined")
	-- new_entity:SetRegister(FRAMEREG_GOTO, {id="metalore",num=math.random(100, 200)})
	-- new_entity:Place(loc.x+13, loc.y)

	-- local volcano = Map.CreateEntity(faction, "fc_volcano")
	-- volcano:Place(loc.x+3,loc.y+6)

	--local volcano = Map.CreateEntity("world", "f_explorable", "blight_set_03")
	-- local volcano = Map.CreateEntity("world", "fc_volcano")

	-- volcano.extra_data.rewards = {ic_cube_red = 1}
	-- --volcano:AddComponent(, 'hidden')
	-- --Explorable_AddMinigame(volcano,"c_explorable_netwalk")
	-- -- Explorable_AddRobotPuzzles(volcano) 
	-- -- volcano.extra_data.solved = true
	-- local fix = volcano:AddComponent("cc_explorable_fix", "hidden")
	-- fix.extra_data.explorable_fix = "ic_cube_empty"
	-- volcano:SetRegister(FRAMEREG_SIGNAL, { id = "ic_cube_empty", num = 1 })
	-- volcano:Place(loc.x+3,loc.y+6)

	local gyro = Map.CreateEntity(faction, "fc_gyro")
	gyro:AddComponent("cc_cube_storage")
	gyro:AddItem("ic_broken_reality", 20)
	gyro:AddItem("ic_proto_sent", 20)
	gyro:AddItem("ic_matter", 20)
	gyro:Place(loc.x,loc.y-10)

	local recharger = Map.CreateEntity(faction, "f_building2x2c")
	recharger:AddComponent("cc_pipe_output")
	recharger:AddComponent("cc_cube_storage")
	recharger:AddComponent("cc_crystal_power_red")
	recharger:AddComponent("cc_cheat_tech")
	recharger:AddItem("ic_soul_plasma",100)
	recharger:AddItem("crystal_powder",60)
	--recharger:AddItem("ic_cube_red")
	recharger:Place(loc.x-3,loc.y+10)

	-- local recharger = Map.CreateEntity(faction, "f_building2x2c")
	-- recharger:AddComponent("cc_time_travel_machine")
	-- recharger:AddComponent("c_turret")
	-- recharger:AddComponent("cc_cube_storage")
	-- recharger:AddComponent("c_power_cell")
	-- recharger:Place(loc.x+6,loc.y-6)


	-- local test_enemy = Map.CreateEntity(GetBugsFaction(), "f_scaramar2")
	-- test_enemy:Place(loc.x-6,loc.y-12)


	-- local pipe = Map.CreateEntity(faction, "fc_pipe")
	-- --recharger:AddItem("ic_soul_plasma",20)
	-- pipe:Place(loc.x-12,loc.y)
	-- pipe = Map.CreateEntity(faction, "fc_pipe")
	-- pipe:AddItem("ic_soul_plasma",9)
	-- pipe:Place(loc.x-8,loc.y+10)

	-- pipe = Map.CreateEntity(faction, "fc_pipe")
	-- pipe:AddItem("ic_soul_plasma",1)
	-- pipe:Place(loc.x-8,loc.y+4)

	-- -- --testing soul refinery 
	-- pipe = Map.CreateEntity(faction, "f_building2x2c")
	-- pipe:AddComponent("cc_soul_refinery")
	-- pipe:AddComponent("cc_cube_storage")
	-- pipe:AddComponent("cc_modulespeed")
	-- pipe:AddComponent("cc_modulespeed")
	-- --pipe:AddComponent("cc_pipe_output")
	-- pipe:AddItem("bug_carapace",200)
	-- pipe:AddItem("ic_soul_angry",20)
	-- pipe:AddItem("ic_soul_happy",20)
	-- pipe:AddItem("ic_time_crystal",20)
	-- pipe:AddItem("ic_cube_blue",1)

	-- pipe:Place(loc.x-8,loc.y)

	-- pipe = Map.CreateEntity(faction, "f_building2x1f")
	-- pipe:AddComponent("cc_power_souls")
	-- pipe:AddComponent("cc_pipe_output")
	-- --pipe:AddComponent("cc_pipe_output")
	-- pipe:Place(loc.x-11,loc.y+8)


	-- local defence_block = Map.CreateEntity(faction, "f_building1x1h")
	-- defence_block:AddComponent("cc_cube_storage")
	-- defence_block:AddItem("ic_cube_sphere",1)
	-- defence_block:Place(loc.x,loc.y-6)

	-- defence_block = Map.CreateEntity(faction, "fc_cube_sphere")
	-- defence_block:Place(loc.x+1,loc.y-6)

	-- --- booot tower 
	-- defence_block = Map.CreateEntity(faction, "fc_boost_tower")
	-- defence_block:Place(loc.x,loc.y+8)
	-- home_entity:AddItem("ic_fuel", 40)

	-- testing visuals 
	-- local mug = Map.CreateEntity(faction, "fc_mug")
	-- mug:Place(loc.x, loc.y+5)

	if Start_with_Observers then tester_spawn_observers(faction, loc.x,loc.y) end
	 
end

--