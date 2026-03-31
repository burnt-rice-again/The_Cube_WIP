



local package = ...
-- called when starting a new game (skipped when loading a save or joining a multiplayer game)
function package:setup_scenario(settings)
	--settings.skip_explorables = true
	--BuildDefinitionTooltip('metalore')
end

-- called when mod is initializing
function package:init()

end

-- called when starting up a new game
function package:on_world_spawn()

	local bug_faction = GetBugsFaction()

	local faction_time_bots = Map.CreateFaction("time_bots")
	faction_time_bots.default_trust = "ENEMY"

end

local function tester_spawn_observers(faction, x,y)

	local size = 100
	local tower = Map.CreateEntity(faction, 'cc_testing_observer')
	tower:Place(x+size,y+size)
	tower = Map.CreateEntity(faction, 'cc_testing_observer')
	tower:Place(x+size,y-size)
	tower = Map.CreateEntity(faction, 'cc_testing_observer')
	tower:Place(x-size,y+size)
	tower = Map.CreateEntity(faction, 'cc_testing_observer')
	tower:Place(x-size,y-size)

end


-- called when a new player faction is spawned or respawned
--- Start with an adv base + cube 
function package:on_player_faction_spawn(faction, is_respawn)
	
	-- starting techs 
	faction:Unlock("tc_robot_basic")
	faction:Unlock("tc_cube_basic")
	faction:Unlock("tc_upgrades_basic")
	-- Research Unlock for testing 
	for key, val in pairs(data.techs) do 
		if "tc_" == string.sub(key, 1, 3) then 
			faction:Unlock(key)
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
	local home_entity = Map.CreateEntity(faction, "f_landingpod")
	home_entity:AddComponent("cc_cube_storage")
	home_entity:AddComponent("cc_manifest")
	home_entity:AddComponent("c_higrade_capacitor")
	home_entity:AddComponent("cc_pipe_output_i")
	--home_entity:AddComponent("c_modulevisibility_m")
	--home_entity:AddComponent("c_modulevisibility_m")
	home_entity:AddItem("ic_cube_blue")
	home_entity:AddItem("datakey_robot", 40)
	home_entity:AddItem("cc_cube_storage", 2)
	home_entity:AddItem("cc_crystal_power", 1)
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
	-- miner1:SetRegister(5,{id="metalore",num=REG_INFINITE})
	-- --miner1:SetRegister(FRAMEREG_STORE,{entity = recycler})
	-- miner1.disconnected = false
	-- miner1:Place(loc.x-4,loc.y)
	-- -- crystal miner
	-- miner1 = Map.CreateEntity(faction, "f_bot_1s_adw")
	-- miner1:AddComponent("c_adv_miner")
	-- miner1:AddComponent("c_capacitor")
	-- miner1:SetRegister(5,{id="crystal",num=REG_INFINITE})
	-- miner1.disconnected = false
	-- miner1:Place(loc.x+5,loc.y+5)

	--spawn recharger 
	-- local new_entity = Map.CreateEntity(faction, "f_building2x1f")
	-- new_entity:AddComponent("cc_cube_storage")
	-- new_entity:AddComponent("cc_cube_recharger")
	-- new_entity:AddItem("ic_souls", 80)
	-- new_entity:Place(loc.x+4, loc.y-5)

	--spawn power source 
	local new_entity = Map.CreateEntity(faction, "f_building2x1f")
	new_entity:AddComponent("cc_cube_storage")
	new_entity:AddComponent("cc_crystal_power")
	--new_entity:AddItem("ic_cube_empty", 1)
	new_entity:AddItem("crystal", 80)
	new_entity:Place(loc.x+5, loc.y-5)

	--spawn relay 
	new_entity = Map.CreateEntity(faction, "f_building1x1b")
	new_entity:AddComponent("c_large_power_relay")
	new_entity:Place(loc.x+3, loc.y)	

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

	--spawn Farming Tester
	-- new_entity = Map.CreateEntity(faction, "f_building2x2c")
	-- new_entity:AddComponent("cc_planter_wire")
	-- new_entity:AddComponent("cc_cube_storage")
	-- new_entity:AddComponent("c_adv_portable_turret")
	-- new_entity:AddItem("ic_cube_green", 1)
	-- new_entity:AddItem("crystal_powder", 10)
	-- new_entity:AddItem("c_deconstructor", 1)
	-- new_entity:AddItem("steelblock", 40)
	-- new_entity:AddItem("c_portable_radar", 2)
	-- new_entity:AddItem("c_deconstructor", 1)
	--home_entity:AddItem("cc_manifest")
	--new_entity:Place(loc.x+13, loc.y)


	-- spawn consturction fliers 
	local flier = Map.CreateEntity(faction, "f_flyer_bot")
	flier:AddComponent("c_anomaly_container_i")
	flier.logistics_carrier = true
	flier.disconnected = false
	flier:Place(loc.x+4,loc.y+3)

	-- cub with cube transporter 
	local transport = Map.CreateEntity(faction, "f_bot_1m_c")
	transport:AddComponent("cc_cube_storage")
	--transport:AddItem("ic_cube_empty")
	transport.logistics_carrier = true
	transport.disconnected = false
	transport:Place(loc.x+4,loc.y+4)




	-- testing buildings 

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

	-- --- Farming Tester
	-- local farm = Map.CreateEntity(faction, "f_building2x2b")
	-- farm:AddComponent("cc_plant_seed2")
	-- --recharger:AddComponent("c_power_cell")
	-- --recharger:AddComponent("cc_manifest")
	-- farm:AddComponent("cc_cube_storage")
	-- farm:AddItem("ic_cube_red",1)
	-- farm:Place(loc.x+5,loc.y)

	-- recharger = Map.CreateEntity(faction, "f_building2x2c")
	-- recharger:AddComponent("cc_red_furnace")
	-- recharger:AddComponent("cc_cube_storage")
	-- recharger:AddComponent("c_power_cell")
	-- recharger:Place(loc.x-3,loc.y+10)

	-- recharger = Map.CreateEntity(faction, "f_building2x2c")
	-- recharger:AddComponent("cc_time_travel_machine")
	-- recharger:AddComponent("c_turret")
	-- recharger:AddComponent("c_blight_shield")
	-- recharger:AddComponent("cc_cube_storage")
	-- recharger:AddComponent("c_power_cell")
	-- recharger:AddItem("concreteslab",180)
	-- recharger:Place(loc.x-6,loc.y-6)




	--faction:RevealArea(0,0,200,200,1)

	-- local test_enemy = Map.CreateEntity(GetBugsFaction(), "f_scaramar2")
	-- test_enemy:Place(loc.x-6,loc.y-12)


	local pipe = Map.CreateEntity(faction, "fc_pipe")
	--recharger:AddItem("ic_soul_plasma",20)
	pipe:Place(loc.x-12,loc.y)
	pipe = Map.CreateEntity(faction, "fc_pipe")
	pipe:AddItem("ic_soul_plasma",9)
	pipe:Place(loc.x-8,loc.y+10)

	pipe = Map.CreateEntity(faction, "fc_pipe")
	pipe:AddItem("ic_soul_plasma",1)
	pipe:Place(loc.x-8,loc.y+4)

	--testing soul refinery 
	pipe = Map.CreateEntity(faction, "f_building2x2c")
	pipe:AddComponent("cc_soul_refinery")
	pipe:AddComponent("cc_pipe_input")
	pipe:AddComponent("c_power_cell")
	--pipe:AddComponent("cc_pipe_output")
	pipe:AddItem("ic_souls",200)
	pipe:Place(loc.x-8,loc.y)

	-- testing visuals 
	-- local mug = Map.CreateEntity(faction, "fc_mug")
	-- mug:Place(loc.x, loc.y+5)

	tester_spawn_observers(faction, loc.x,loc.y)
end

