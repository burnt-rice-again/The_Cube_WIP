



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
	local home_entity = Map.CreateEntity(faction, "f_landingpod",true)
	home_entity:AddComponent("cc_cube_storage")
	home_entity:AddComponent("cc_manifest")
	home_entity:AddComponent("c_higrade_capacitor")
	home_entity:AddComponent("c_internal_field")
	
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
	flier:AddComponent("c_anomaly_container_i")
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
	transport:Place(loc.x+4,loc.y+4)


	------------------------------
	-- testing buildings 


end

