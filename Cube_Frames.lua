
--- New Crafting Recipes in tech order 

-- Tech Category Inpependace 
-- Bot Frames 
-- lvl 0
data.frames.f_bot_1s_a.production_recipe = CreateProductionRecipe({ metalplate = 4, datakey_robot = 1 }, { c_robotics_factory = 25, c_carrier_factory = 60 })

-- lvl 1
data.frames.f_bot_1s_b.production_recipe = CreateProductionRecipe({ metalplate = 2, datakey_robot = 1, steelblock = 4 }, { c_robotics_factory = 80 })
data.frames.f_bot_1m_a.production_recipe = CreateProductionRecipe({ steelblock = 10, datakey_robot = 1, metalplate = 5 }, { c_robotics_factory = 80 })
data.frames.f_bot_2s.production_recipe = CreateProductionRecipe({ steelblock = 6, datakey_robot = 2, wire = 4 }, { c_robotics_factory = 80 })
data.frames.f_transport_bot.production_recipe = CreateProductionRecipe({ ic_soul_happy = 1, wire = 6, metalplate = 8 }, { c_robotics_factory = 80 })
data.frames.f_bot_1m_b.production_recipe = CreateProductionRecipe({ ic_soul_happy = 1, wire = 4, steelblock = 16 }, { c_robotics_factory = 80 })
-- lvl2 
data.frames.f_bot_1s_as.production_recipe = CreateProductionRecipe({ reinforced_plate = 9, ic_soul_happy = 1, datakey_robot = 4 }, { c_robotics_factory = 80 })
data.frames.f_bot_1m1s.production_recipe = CreateProductionRecipe({ ic_soul_happy = 1, wire = 16, reinforced_plate = 16 }, { c_robotics_factory = 80 })
data.frames.f_bot_1l_a.production_recipe = CreateProductionRecipe({ ic_soul_happy = 1, engine = 4, reinforced_plate = 32 }, { c_robotics_factory = 80 })
data.frames.f_bot_1m_c.production_recipe = CreateProductionRecipe({ ic_soul_happy = 1, engine = 4, reinforced_plate = 12, fused_electrodes = 4 }, { c_robotics_factory = 80 })
data.frames.f_bot_1s_adw.production_recipe = CreateProductionRecipe({ ic_soul_happy = 1, engine = 1, reinforced_plate = 9, fused_electrodes = 16 }, { c_robotics_factory = 80 })

-- Building Frames 
-- lvl 0
data.frames.f_building1x1d.construction_recipe = CreateConstructionRecipe({ metalplate = 4, crystal = 1 }, 20)
data.frames.f_building1x1f.construction_recipe = CreateConstructionRecipe({ metalplate = 8, crystal = 8 }, 20)
data.frames.f_building2x1g.construction_recipe = CreateConstructionRecipe({ metalplate = 6, crystal = 4 }, 20)
data.frames.f_building2x1f.construction_recipe = CreateConstructionRecipe({ metalplate = 8, crystal = 4, datakey_robot = 1 }, 20)
-- lvl 1 
data.frames.f_building1x1c.construction_recipe = CreateConstructionRecipe({ metalplate = 8,  crystal = 4 }, 20)
data.frames.f_building1x1a.construction_recipe = CreateConstructionRecipe({ metalplate = 16,  crystal = 8  }, 20)
data.frames.f_building2x1a.construction_recipe = CreateConstructionRecipe({ metalplate = 4, steelblock = 8, datakey_robot = 2 }, 30)
data.frames.f_building2x2f.construction_recipe = CreateConstructionRecipe({ metalplate = 4, steelblock = 12, datakey_robot = 4 }, 30)
data.frames.f_building1x1b.construction_recipe = CreateConstructionRecipe({ steelblock = 9, concreteslab = 12, datakey_robot = 1 }, 20)
data.frames.f_building2x1e.construction_recipe = CreateConstructionRecipe({ steelblock = 16, concreteslab = 25, datakey_robot = 4 }, 20)
data.frames.f_building2x1e.component_boost = 0
data.frames.f_wall.construction_recipe = CreateConstructionRecipe({ metalplate = 1, concreteslab = 4 }, 20)
data.frames.f_gate.construction_recipe = CreateConstructionRecipe({ metalplate = 2, concreteslab = 4, crystal = 2 }, 20)
data.frames.f_building2x1b.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building1x1g.construction_recipe = CreateConstructionRecipe({ concreteslab = 32, reinforced_plate = 16, }, 40)
-- f_building1x1h
-- lvl2 
data.frames.f_building1x1e.construction_recipe = CreateConstructionRecipe({ concreteslab = 32, reinforced_plate = 16, phase_leaf = 9 }, 40)
data.frames.f_building2x1c.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x1c.component_boost = 0
data.frames.f_building2x1d.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x1d.component_boost = 0
data.frames.f_building2x2b.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x2b.component_boost = 0
data.frames.f_building3x2b.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x2a.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x2a.component_boost = 0
data.frames.f_building2x2c.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x2c.component_boost = 0
data.frames.f_building2x2d.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x2d.component_boost = 0
data.frames.f_building2x2e.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building2x2e.component_boost = 0
data.frames.f_building3x2a.construction_recipe = CreateConstructionRecipe({ concreteslab = 30, reinforced_plate = 12, datakey_robot = 5 }, 40)
data.frames.f_building3x2a.component_boost = 0

data.frames.f_flyer_bot.production_recipe = CreateProductionRecipe({ ldframe = 1, datakey_robot = 2, metalplate = 4 }, { c_robotics_factory = 50 })
data.frames.f_flyer_m.production_recipe = CreateProductionRecipe({ ldframe = 2, ic_soul_happy = 4, reinforced_plate = 6 }, { c_robotics_factory = 80 })
data.frames.f_drone_transfer_a.production_recipe = CreateProductionRecipe({ ldframe = 1, ic_soul_happy = 1, metalplate = 2 }, { c_robotics_factory = 80 })
data.frames.f_drone_transfer_a2.production_recipe = CreateProductionRecipe({ ldframe = 1, ic_soul_happy = 1, reinforced_plate = 2, engine = 1 }, { c_robotics_factory = 80 })
data.frames.f_drone_miner_a.production_recipe = CreateProductionRecipe({ ldframe = 1, ic_soul_happy = 2, metalplate = 6, c_miner = 1  }, { c_robotics_factory = 80 })
data.frames.f_drone_adv_miner.production_recipe = CreateProductionRecipe({ ldframe = 1, ic_soul_happy = 4, reinforced_plate = 6, c_adv_miner = 1 }, { c_robotics_factory = 80 })
data.frames.f_drone_defense_a.production_recipe = CreateProductionRecipe({ ldframe = 1, ic_soul_happy = 2, reinforced_plate = 6, c_adv_portable_turret = 1 }, { c_robotics_factory = 80 })

-- foundations 
-- bugs drops
data.frames.f_trilobyte1.resource_drop = {"ic_souls", "vc_souls"}
data.frames.f_tetrapuss1.resource_drop = {"ic_souls", "vc_souls"}
data.frames.f_tripodonte1.resource_drop = {"ic_souls", "vc_souls"}

data.frames.f_human_warehouse.desc = "Not for safe storage of humans\nSee Workplace incident #110100100"


-------------------------------------------
------------- Robot Frames -----------------
-- scrap recycler 
Frame:RegisterFrame("fc_scrap_recycler", {
	name = "Scrap recycler",
	desc = "Sorts Scrap into useful resources",
	race = "human",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 10,
	health_points = 600,
	power = -5, -- -20
	slots = { storage = 8 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 20, steelblock = 20 }, 120),
	texture = "Main/textures/icons/human/Human_Building_2x2_Refinery.png",
	trigger_channels = "building",
	visual = "v_human_refinery",
	components = {
		{ "cc_scrap_fabricator", "hidden" },
	},
	size = "Human",
})


-- Starting Bots 




-------------------------------------------
------------- Custom Frames -----------------

Frame:RegisterFrame("fc_crystal_power_red", {
	name = "Fury Cube Power Plant",
	desc = "Uses Extreme heat to vaporize crystals into enormous amounts of power",
	race = "robot",
	--minimap_color = data.values.v_color_crimson.color,
    visibility_range = 10,
	health_points = 500,
	--power = 0,
	slots = {storage = 11,cube = 1 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 250, steelblock = 150, datakey_robot = 20 }, 120),
	texture = "Main/textures/icons/values/plateau.png",
	trigger_channels = "building",
	visual = "v_human_powerplant",
    components = {
        { "cc_crystal_power_red", "hidden" },
		{ "c_internal_transmitter", "hidden" },
		{ "c_internal_transmitter", "hidden" },
		{ "c_internal_transmitter", "hidden" },
		{ "c_internal_transmitter", "hidden" },
	},
})
--data.visuals.v_starterturret_red_s.scale = {2,2,2.5}
Frame:RegisterFrame("fc_pipe", {
	name = "Plasma Relay Tower",
	desc = "Channels Electroplamsa to other towers and receiveing Points",
	race = "robot",
    visibility_range = 10,
	health_points = 500,
	power = -1,
	start_disconnected = true,
	--slots = {anomaly = 1 },
	construction_recipe = CreateConstructionRecipe({steelblock = 6, concreteslab = 4, crystal_powder = 1},1),
	--construction_recipe = CreateConstructionRecipe({ concreteslab = 9, steelblock = 20, phase_leaf = 10 }, 40),
	texture = "Main/textures/icons/components/Component_Blight1.png",
	trigger_channels = "building",
	visual = "vc_tower1",--'v_blight_stabilizer',
    components = {
        { "cc_pipe_crane", "hidden" },
	},
	size = "Other",
	no_foundations = true,
})
--"v_energystorage"

Frame:RegisterFrame("fc_mug",{
	name = "mug",
	health_points = 5,
	race = "robot",
	construction_recipe = CreateConstructionRecipe({steelblock = 1, concreteslab = 1},1),
	texture = "Main/textures/icons/components/Component_Blight1.png",
	trigger_channels = "building",
	visual = 'vc_mug',--"v_blight_stabilizer",
	size = "Large",
	no_foundations = true,
	is_explorable = true,
})



local fc_wire_plant = Frame:RegisterFrame("fc_wire_plant", {
	name = "Neurotic Reed Plant",
	desc = "Flora that has conductive tendrils for zapping local insects",
	size = "Other",
	--minimap_color = false, 
	health_points = 25, 
	visual = "v_succulent_04",
	texture = "Main/textures/icons/frame/powerflower_frame.png",
	--construction_recipe = CreateConstructionRecipe({ anomaly_cluster = 1, power_petal = 10 }, 1),
	race = "alien",
	no_foundations = true,
	is_flower = true,
})

function fc_wire_plant:on_destroy(entity, damager)
	if not damager or entity.faction.is_player_controlled then return end
	Map.DropItemAt(entity.location, "wire", math.random(20) + 10 , "f_dropped_resource")
	Map.DropItemAt(entity.location, "cc_plant_seed2", 1, "f_dropped_resource")
end
Frame:RegisterFrame("f_resourcenode_pixel",  {
		type = "Resource", index = 1, name = "Voxel Deposit",
		texture = "Main/textures/icons/values/resource.png",
		harvest_id = 'metalore',
		minimap_color = { 0.3, 0.3, 0.3 },
})
Frame:RegisterFrame("f_resourcenode_concrete",  {
		type = "Resource", index = 1, name = "Ruins",
		texture = "Main/textures/icons/values/resource.png",
		harvest_id = 'concreteslab',
		minimap_color = { 0.3, 0.3, 0.3 },
})
-------------------------------------------
------------- Explorables -----------------

data.frames.f_explorable:RegisterFrame("fc_volcano", {
	name = "Volcano",
	desc = "A door to the heart of the world",
	race = "alien",
	minimap_color = data.values.v_color_crimson.color,
	visibility_range = 10,
	health_points = 60000,
	--power = -5, -- -20a
	slots = {cube = 1 },
	--construction_recipe = CreateConstructionRecipe({ concreteslab = 20, steelblock = 20 }, 120),
	texture = "Main/textures/icons/values/plateau.png",
	trigger_channels = "building",
	visual = "blight_set_03",
    components = {
		--{ "cc_explorable_fix", 'hidden' },
		--{"c_explorable_netwalk", 'hidden'}
	},
	is_explorable = true,
})
data.frames.f_explorable:RegisterFrame("fc_wire_weed", {
	name = "Wire Weed Plant",
	desc = "A Fast Growing weed that flowers with conductive fibres",
	race = "alien",
	minimap_color = data.values.v_color_green.color,
	visibility_range = 1,
	health_points = 500,
	--power = -5, -- -20a
	slots = {storage = 4, cube = 1 },
	--construction_recipe = CreateConstructionRecipe({ concreteslab = 20, steelblock = 20 }, 120),
	texture = "Main/textures/icons/values/plateau.png",
	visual = "vc_sea_grass",
    components = {
		--{ "cc_explorable_fix", 'hidden' },
		--{"c_explorable_netwalk", 'hidden'}
	},
	is_explorable = true,
})

Frame:RegisterFrame("fc_testing_observer",{
	visual = "v_beacon_l",
	name = "obeserving tower",
	visibility_range = 100,
})

-- @Entity From frame
-- @Bool True to place two anticubes instead of 1
function Place_Anti_Cube(entity, do_again)
	-- location can be entity or location
	if entity == nil then print("ERROR location is invalid for anticube") end 
	-- if location.x == nil then
	-- 	-- not coord is entity 
	-- 	if location.location ~= nil then 
	-- 		location = location.location
	-- 	end
	-- look for frame with space 
	local list_nearby = Map.GetEntitiesInRange(entity.location.x, entity.location.y, 5, 5, 1, FF_OWNFACTION, entity.faction)
	for key, val in pairs(list_nearby) do 
		if val:HaveFreeSpace("ic_cube_sphere") == true then
			val:AddItem("ic_cube_sphere")
			val:PlayEffect("fx_ping")
			return 
		end
	end
	-- place as frame 
	local cord = entity.location
	local faction = entity.faction
	Map.Defer(function()
	local new_frame = Map.CreateEntity(faction, "fc_cube_sphere")
	if new_frame ~= nil then
		new_frame:Place(cord.x + math.random(-6,6), cord.y + math.random(-6,6)) end
	end)
	if do_again == true then  Place_Anti_Cube(entity, false) end 
end 


local fc_cube_sphere = Frame:RegisterFrame("fc_cube_sphere",{
	name = data.items.ic_cube_sphere.name,
	desc = "A Self Replicating Anti-Cube\n\nWill Multiply On Interaction with regular Matter\n\nHighly Volatile When Around The Cube\n\nCan not be destroyed by conventional means",
	visual = "vc_cube_sphere_frame",
	texture = data.items.ic_cube_sphere.texture,
})
-- using both will double up.
-- function fc_cube_sphere:on_destroy(frame, cause, attacker)
-- 	Place_Anti_Cube(frame)
-- 	--Place_Anti_Cube(frame)
-- end 
function fc_cube_sphere:on_remove(frame, cause)
	Place_Anti_Cube(frame,true)
end 

data.visuals.v_beacon_l.mesh_sockets = { ["fx"] = {0,0,100} }
local fc_boost_tower = Frame:RegisterFrame("fc_boost_tower",{
	name = "Chrono Field Module",
	desc = "Dilates Time around the target unit\n\nRequires Advanced Fuel",
	texture = data.frames.f_beacon_l.texture,
	visual = data.frames.f_beacon_l.visual,
	components = {
		{"cc_boost_tower","hidden"}
	},
	construction_recipe = CreateConstructionRecipe({reinforced_plate = 16, ic_soul_happy = 1, wire = 4, concreteslab = 9},50)
})