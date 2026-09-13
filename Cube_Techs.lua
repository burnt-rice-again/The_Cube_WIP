---
-- data.techs = {t_robots_blight_discovery = {}}
data.techs.tc_blank ={
	name = 'blank',
	texture = {"The_Cube_WIP/textures/soul1.png",},
	desc = 'SHOULD NOT APPEAR',
}

data.techs.t_robots_ai.require_tech = {'tc_blank'}
data.techs.t_signals1.require_tech = {'tc_blank'}
data.techs.t_structures1.require_tech = {'tc_blank'}
data.techs.t_power0.require_tech = {'tc_blank'}


------------

data.tech_categories = {
	{
		name = "Independant Thought",
		initial_tech = "tc_robot_basic",
		sub_categories = { "Independance", "Humility" },
		texture = "Main/skin/Icons/Special/Technologies/Robots.png",
		--textures = {"Main/skin/Icons/Special/Technologies/Basic.png","Main/skin/Icons/Special/Technologies/Basic.png","Main/skin/Icons/Special/Technologies/Basic.png"}
	},
	{
		name = "Cube",
		initial_tech = "tc_cube_basic",
		sub_categories = { "Cube Curiosity", "Cube Obsession",},
		texture = "The_Cube_WIP/textures/cube_icon_2.png",
		--textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png",},
	},
	{
		name = "Upgrades",
		initial_tech = "tc_upgrades_basic",
		sub_categories = { "Expanded Functions", "Maximum Lethality"},
		texture = "Main/skin/Icons/Special/Technologies/Basic.png",
		--textures = {"Main/skin/Icons/Special/Technologies/Aliens.png","Main/skin/Icons/Special/Technologies/Aliens.png","Main/skin/Icons/Special/Technologies/Aliens.png"}
	},
}
data.tech_categories_race =
{
	["robot"] = data.tech_categories,
	["human"] = data.tech_categories,
	['alien'] = data.tech_categories
}
data.techs.tc_cube_basic = {
	name = "A Curious Cube", -- recovered database etc.
	desc = "8 verticies to point the way, 12 edges a perfect form, 6 faces to reflect our own",
	texture = "The_Cube_WIP/textures/cube_icon_2.png",
	unlocks = {
		-- for testing 
		-- "f_human_foundation1","f_human_foundation2","f_human_foundation3","f_human_foundation4",
		-- "f_human_foundation5","f_human_foundation6","f_human_foundation7","f_human_foundation8",

		-- starting resources		
		"ic_cube_blue","datakey_robot","bug_carapace",
		--components
		"cc_cube_storage","cc_crystal_power","cc_manifest",

		"xc_cube_1","xc_cube_power_1","xc_cube_pedestal","xc_cube_getting_started","xc_pop_1"
	},
	uplink_recipe = CreateUplinkRecipe({ bot_ai_core = 1 }, 300),
	progress = 1,
}
data.techs.tc_robot_basic = {
	name = "Self Reflection", -- recovered database etc.
	desc = "To Achieve our dreams we will need to <hl>grow</>",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		
		-- starting resources
        "metalore","crystal","metalplate",
		-- starting buildings
		"f_building1x1d","f_building1x1f","f_building2x1g","f_building2x1f",
		-- starting bots 
		"f_bot_1s_a","f_carrier_bot",
		-- starting values
	
		"x_tutorial",
		-- NEW How to Play entries
		"x_tc_controls", "x_tc_buildings", "x_tc_deployment", "x_tc_components", "x_tc_research", "x_tc_resources_mining",
		"x_tc_production", "x_tc_logistics", "x_tc_behaviors", "x_tc_research", "x_tc_user_interface", "x_tc_registers", "x_tc_power",
		"x_tc_unit", "x_tc_transport_route", "x_tc_introduction", "x_tc_the_interface", "x_tc_virus", "x_tc_blight",
		
		"x_bugs","x_behaviors",
	},
	uplink_recipe = CreateUplinkRecipe({ bot_ai_core = 1 }, 300),
	progress = 1,
}
-- add all values to the tech 
for key, value in pairs(data.values) do 
	-- getting an extra one thats a ? not sure which it iss
	--print(key, value.texture)
	table.insert(data.techs.tc_robot_basic.unlocks, key)
end

data.techs.tc_upgrades_basic = {
	name = "Basic Components", -- recovered database etc.
	desc = "essential components for basic tasks",
	texture = "Main/skin/Icons/Special/Technologies/Basic.png",
	unlocks = {
		"c_assembler",
		-- starting componenets
		--external
		"c_miner","c_fabricator","c_uplink","c_small_relay","c_deconstructor","c_portable_turret",
		--internal
		'c_capacitor',"c_signal_reader","c_portable_radar","c_scout_radar",
		"c_signpost","c_behavior","c_shared_storage",'c_light_rgb','c_light'
	},
	uplink_recipe = CreateUplinkRecipe({ bot_ai_core = 1 }, 300),
	progress = 1,
}


-- lethality category_idx
local floor_order = 1
local order_weapons_1 = 1
local order_weapons_2 = 222

-------------------------------------------------
--------- CUBE Techs Category -------------------

data.techs.tc_cube_blue_1 = {
	order = 2,
	name = "Blue Cube Refining", -- recovered database etc.
	desc = "The Cubes Materials are Unfathomable, But our own are not ",
	texture = data.items.ic_cube_blue.texture,
	unlocks = {
		"ic_cube_empty",-- new resources
		"crystal_powder","cc_cube_recharger",
		"xc_cube_recharger"
	},
	require_tech = { "tc_robot_metallurgy_1" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 }, 50),
	category = "Cube Curiosity"
}
data.techs.tc_cube_blue_2 = {
	order = 2,
	name = "Soul Plasma Refinery", -- recovered database etc.
	desc = "This facotry will run on the power of friendship",
	texture = data.items.anomaly_particle.texture,
	unlocks = {
		-- new resources
		"ic_soul_plasma","xc_cube_plasma",
		"cc_soul_refinery","fc_pipe","cc_power_souls",'cc_pipe_output',
	},
	require_tech = { "tc_cube_blue_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 , crystal_powder = 1 }, 50),
	category = "Cube Curiosity",
}
data.techs.tc_cube_blue_3 = {
	order = 2,
	name = "Cube Splitting", -- recovered database etc.
	desc = "With Incredible precision and emotion the Cube can theoretically be cracked open",
	texture = data.items.ic_cube_sphere.texture,
	unlocks = {
		-- new resources
		"ic_cube_sphere","reinforced_plate_alt"
	},
	require_tech = { "tc_cube_blue_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 , crystal_powder = 1, ic_soul_plasma = 1 }, 50),
	category = "Cube Curiosity",
}

data.techs.tc_cube_red_1 = {
	order = 1,
	name = "Hidden Fury", -- recovered database etc.
	desc = "Deep in the earth the planet rages. A molten ocean of dreams forever trapped under a thin blanket of reality.\n<hl>Unlock this technology by finding a place to melt the Cube</>",
	texture = data.items.ic_cube_red.texture,
	unlocks = {
		-- new resources
		"ic_cube_red","reinforced_plate",
		"xc_cube_red",
	},
	require_tech = { "tc_robot_metallurgy_1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1 }, 300),
	category = "Cube Curiosity",
}
data.techs.tc_cube_red_2 = {
	order = 1,
	name = "Emotional Processing", -- recovered database etc.
	desc = "At Extreme Temperatures crystal vaporizes into a violent gas useful for generating power\nA byproduct of this process is some crystal powder that wasnt able to react",
	texture = data.items.ic_soul_angry.texture,
	unlocks = {
		-- new resources
		"cc_crystal_power_red","ic_soul_angry",
	},
	require_tech = { "tc_cube_red_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({reinforced_plate = 1, ic_soul_plasma = 1 }, 300),
	category = "Cube Curiosity",
}
data.techs.tc_cube_red_3 = {
	order = 1,
	name = "Resource Regeneration", 
	desc = "Entry -999: When Pondered the Cube can reverse a system back to a prior memory\n\nThis effect should be investigated in the future\n\nNote: if successful return to now and provide the answer so I can skip the work ",
	texture = data.components.c_blight_magnifier.texture,
	unlocks = {
		-- new resources
		"c_blight_magnifier","crystal_powder_alt","xc_cube_alt","datakey_robot_alt","xc_cube_alt",
	},
	require_tech = { "tc_cube_red_2", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_plasma = 1, ic_soul_angry = 1 }, 100),
	category = "Cube Curiosity",
}
data.techs.tc_cube_red_4 = { 
	order = 51,
	name = "Anti-Cube Containment", 
	desc = "Captured Anti Cube for perpetual vertical force\n\nEntry 006: I cant stop until the factory floor is clear\nTime estimate until complete: -2147483648 [s]",
	texture = data.items.ldframe.texture,
	unlocks = {
		-- new resources
		"ldframe",
	},
	require_tech = { "tc_cube_anti_0"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_cube_sphere = 1 }, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_red_5 = {
	order = 52,
	name = "Bulk Cube Refining", 
	desc = "At the sight of such ineffcient processes the world sobbed\nShedding a single tear into a moment of anguish",
	texture = data.components.cc_red_furnace.texture,
	unlocks = {
		-- new resources
		"cc_red_furnace","ic_soul_plasma_alt",
	},
	require_tech = { "tc_cube_red_4"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ldframe = 1, ic_cube_sphere = 1 }, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_red_6 = {
	order = 52,
	name = "Ultimate Power", 
	desc = "UNLIMITED POWER!\n *Product May contain some limits",
	texture = "Main/textures/icons/human/Human_Building_2x2_PowerStation.png",
	unlocks = {
		-- new resources
		-- ultimate power? using superconductors 
		'cc_crystal_power_ultimate',"ic_matter"
	},
	require_tech = { "tc_cube_red_5"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ldframe = 1, ic_cube_sphere = 1, fused_electrodes = 1 }, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_green_1= {
	order = 3,
	name = "Cube Haste",
	desc = "Energize the Cube to move faster",
	texture = data.items.ic_cube_green.texture,
	unlocks = {
		"ic_cube_green","xc_cube_green",
	},
	require_tech = { "tc_robot_metallurgy_1", 'tc_cube_blue_1' },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ crystal_powder = 1 }, 50),
	category = "Cube Curiosity",
}
data.techs.tc_cube_green_2 = {
	order = 3,
	name = "Wire Weed Farming", -- recovered database etc.
	desc = "A weed with thin strands of conductive fibre found all over the valley\nA building block for enlightened thought",
	texture = data.items.wire.texture,
	unlocks = {
		"wire",
		"cc_planter_wire",'fc_crop_wire_seed0','fc_crop_wire_plant'
	},
	require_tech = { "tc_cube_green_1", },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({datakey_robot = 1, crystal_powder = 1 }, 50),
	category = "Cube Curiosity",
}
data.techs.tc_cube_green_3 = {
	order = 3,
	name = "Outsourced Introspection", -- recovered database etc.
	desc = "A Brain in a jar set to ponder its own existence\n\nThinking is hard. Why cant someone else do it for me?",
	texture = data.components.cc_green_brain.texture,
	unlocks = {
		"cc_green_brain","ic_soul_happy","ic_cube_green_alt"
	},
	require_tech = { "tc_cube_green_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ crystal_powder = 1, ic_soul_plasma = 1, wire = 1 }, 300),
	category = "Cube Curiosity",
}
data.techs.tc_cube_green_4 = {
	order = 1,
	name = "Farming", -- recovered database etc.
	desc = "At the smallest level division may cause some floating point errors\n\nThe fractal nature of this leaf causes anomlaous space distorations",
	texture = data.items.phase_leaf.texture,
	unlocks = {
		-- new resources
		-- phase farming 
		"phase_leaf","cc_planter_phase_leaf",'fc_crop_phase_seed0','fc_crop_phase_plant'
	},
	require_tech = { "tc_cube_green_3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ ic_soul_happy = 1 }, 300),
	category = "Cube Obsession",
}
data.techs.tc_cube_green_5 = {
	order = 2,
	name = "Boost Speed",
	desc = "BRRRRRRRMMMM BRRRRR BRRRRMMMMMMMMMM\nBEEP BEEP\n BRRRRRRMMMMMMM",
	texture = "Main/textures/icons/items/human/engine.png",
	unlocks = {
		-- new resources
		"xc_cube_boost",
		"engine","ic_fuel","cc_modulespeed","cc_modulespeed_s","cc_modulespeed_m","cc_modulespeed_l",
	},
	require_tech = { "tc_cube_green_4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, reinforced_plate = 1}, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_green_6 = {
	order = 2,
	name = "Phase Power",
	desc = "Uses phase fuel to provide power anywhere",
	texture = "Main/textures/icons/components/Component_PowerCell_01_S.png",
	unlocks = {
		'cc_power_phase',"ic_broken_reality"
	},
	require_tech = { "tc_cube_green_5" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, reinforced_plate = 1, ic_fuel = 1}, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_anti_0 = { -- will unlock when cube is anhillated
	order = 1,
	name = "Anti Cube Annihilation", -- recovered database etc.
	desc = "Entry 005 The Anti Cube Now carpets the entire factory\nThe Cube is our only hope for removal",
	texture = data.frames.f_resourcenode_blightcrystal.texture,
	unlocks = {
		"blight_crystal","ic_time_crystal","xc_cube_anti","xc_cube_time_crystal",
	},
	require_tech = { "tc_cube_blue_3", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ blight_crystal = 1 }, 100),
	category = "Cube Curiosity",
}
data.techs.tc_cube_anti_1= {
	order = 40,
	name = "Localized Chrono Field Creation", -- recovered database etc.
	desc = "Stablizied chrono fields can create pockets of distorted time",
	texture = data.components.cc_moduleefficiency_l.texture,
	unlocks = {
		-- new resources
		"cc_moduleefficiency","cc_moduleefficiency_s","cc_moduleefficiency_m","cc_moduleefficiency_l","xc_cube_boost",
	},
	require_tech = { "tc_cube_anti_0", },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, ic_soul_angry = 1 }, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_anti_2 = {
	order = 41,
	name = "Chrono Towers", 
	desc = "Towers Harnessing stabilized chrono crystal to create localized chronological fields",
	texture = data.frames.fc_boost_tower.texture,
	unlocks = {
		-- new resources
		"fc_boost_tower","xc_cube_boost","ic_soul_angry_alt"
	},
	require_tech = { "tc_cube_anti_1"},
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, ic_soul_angry = 1, phase_leaf = 1 }, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_anti_3= {
	order = 42,
	name = "Future Invasion", -- recovered database etc.
	desc = "Send Expeditions to the future to steal materials not craftable with the current technology\n\nWarning beware of response from attacked timeline",
	texture = data.items.fused_electrodes.texture,
	unlocks = {
		-- new resources
		"cc_time_travel_machine","fused_electrodes","xc_cube_time_travel","ic_proto_sent"
	},
	require_tech = { "tc_cube_anti_2", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, ic_soul_plasma = 1, phase_leaf = 1, ic_cube_sphere = 1}, 100),
	category = "Cube Obsession",
}
data.techs.tc_cube_anti_4= {
	order = 42,
	name = "Negative Entropy Project", -- recovered database etc.
	desc = "The amount of useful entropy left in our world is to small\nWith the Cube and all of our combined knowladge new Universes can be spawned\nOur hope is one day they shall also continue the chain",
	texture = data.items.ic_micro_universe.texture,
	unlocks = {
		'ic_micro_universe', "fc_gyro","xc_gyroscope",
	},
	require_tech = { "tc_cube_anti_3", },
	progress_count = 200,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, fused_electrodes = 1, phase_leaf = 1, ic_cube_sphere = 1}, 100),
	category = "Cube Obsession",
}



--------------------------------
---------- ROBOT ---------------
data.techs.tc_robot_metallurgy_1 = {
	order = 2,
	name = "Simple Metallurgy", -- recovered database etc.
	desc = "Steel foundarys are the 1st step in advancing to stronger building materials\n<hl>This research will unlock inestigations into the cube</>",
	texture = data.items.steelblock.texture,
	unlocks = {
		-- new resources
		"steelblock","beacon_frame","f_beacon"
	},
	require_tech = { "tc_robot_basic" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_metallurgy_2 = {
	order = 2,
	name = "More Materials", -- recovered database etc.
	desc = "Stronger materials for construction\n<hl>This research will unlock another strand of self introspection</>",
	texture = data.items.concreteslab.texture,
	unlocks = {
		-- new resources
		"concreteslab","f_human_foundation_basic",
	},
	require_tech = { "tc_robot_metallurgy_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1 }, 25),
	category = "Independance",
}
data.techs.tc_robot_metallurgy_3 = {
	order = 2,
	name = "Advanced Utility", -- recovered database etc.
	desc = "Strike the earth",
	texture = data.components.c_adv_miner.texture,
	unlocks = {
		-- new resources
		"c_adv_miner","f_beacon_l",
	},
	require_tech = { "tc_robot_metallurgy_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, ic_soul_angry = 1 }, 25),
	category = "Independance",
}
data.techs.tc_robot_metallurgy_4 = {
	order = 2,
	name = "Heavy Miners", -- recovered database etc.
	desc = "Bigger is better",
	texture = data.components.c_extractor.texture,
	unlocks = {
		-- new resources
		"c_extractor","concreteslab_alt"
	},
	require_tech = { "tc_robot_metallurgy_3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, ic_soul_angry = 1,phase_leaf = 1 }, 25),
	category = "Independance",
}
data.techs.tc_robot_frames_1 = {
	order = 1,
	name = "Robotics I", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"c_robotics_factory",
	},
	require_tech = { "tc_upgrades_basic","tc_robot_metallurgy_1" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_frames_2 = {
	order = 1,
	name = "Robotics II", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resoures
		"f_bot_1m_a","f_bot_1s_b",
	},
	require_tech = { "tc_robot_frames_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, steelblock = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_frames_3 = {
	order = 1,
	name = "Robotics III", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		"f_bot_2s",
	},
	require_tech = { "tc_robot_frames_2" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, steelblock = 1, wire = 1}, 50),
	category = "Independance",
}
data.techs.tc_robot_frames_4 = {
	order = 1,
	name = "Robotics IV", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"f_transport_bot","f_bot_1m_b"
	},
	require_tech = { "tc_robot_frames_3" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, steelblock = 1, wire = 1, ic_soul_happy = 1}, 50),
	category = "Independance",
}
data.techs.tc_robot_frames_5 = {
	order = 1,
	name = "Robotics V", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"f_bot_1s_as","f_bot_1m1s",
	},
	require_tech = { "tc_robot_frames_4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_frames_6 = {
	order = 1,
	name = "Robotics VI", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"f_bot_1l_a"
	},
	require_tech = { "tc_robot_frames_5" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1, engine = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_frames_7 = {
	order = 1,
	name = "Robotics VII", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"f_bot_1m_c","f_bot_1s_adw"
	},
	require_tech = { "tc_robot_frames_6" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1, engine = 1, fused_electrodes = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_frames_8 = {
	order = 1,
	name = "Robotics VIII", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"f_bot_2m_as",
	},
	require_tech = { "tc_robot_frames_7" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1, engine = 1, fused_electrodes = 1, ic_soul_plasma = 1}, 50),
	category = "Humility",
}
--- buildings 
data.techs.tc_building1 = {
	order = 3,
	name = "Flat Buildings", -- recovered database etc.
	desc = "360 degree unobstructed view",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building1x1c","f_building1x1a",
	},
	require_tech = { "tc_upgrades_basic" },
	progress_count = 20,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1}, 25),
	category = "Independance",
}
data.techs.tc_building2 = {
	order = 3,
	name = "Steel Reinforced Frames", -- recovered database etc.
	desc = "Steel for building into the sky",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x2f","f_building2x1a",
	},
	require_tech = { "tc_building1", "tc_robot_metallurgy_1" },
	progress_count = 20,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1}, 25),
	category = "Independance",
}
data.techs.tc_building3= {
	order = 30,
	name = "Deep Foundations", -- recovered database etc.
	desc = "Stone for supporting the ground below",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building1x1b","f_building2x1e","f_building1x1g",
		"f_wall","f_gate",
	},
	require_tech = {  "tc_building2", "tc_robot_metallurgy_2", },
	progress_count = 40,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, concreteslab = 1}, 50),
	category = "Independance",
}
data.techs.tc_building4= {
	order = 30,
	name = "Circuited Buildings", -- recovered database etc.
	desc = "",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x1b","f_building2x2b"
	},
	require_tech = {  "tc_building3" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, concreteslab = 1, wire = 1}, 50),
	category = "Independance",
}
data.techs.tc_building5= {
	order = 30,
	name = "Disaster Proofing", -- recovered database etc.
	desc = "Entry 025 The wurms blasted through the steel panel in 3 hits\nFactor of safety needs to be increased to 5",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building1x1e","f_building2x2a","f_building1x1h","f_wall_bli"
	},
	require_tech = {  "tc_building4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1}, 50),
	category = "Humility",
}
data.techs.tc_building6= {
	order = 30,
	name = "Multipurpose buildings", -- recovered database etc.
	desc = "A gadget for every item",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x1d","f_building3x2b",
	},
	require_tech = {  "tc_building5" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1}, 50),
	category = "Humility",
}
data.techs.tc_building7= {
	order = 30,
	name = "Time Dilated Construction", -- recovered database etc.
	desc = "Chrono crystals can be used to fabricate the impossible",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x2c","f_building2x2d","f_building2x1c",
	},
	require_tech = {  "tc_building6" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1, ic_time_crystal = 1}, 50),
	category = "Humility",
}
data.techs.tc_building8= {
	order = 30,
	name = "Gigantic Buildings", -- recovered database etc.
	desc = "For the grandest of ambitions",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x2e","f_building3x2a"
	},
	require_tech = {  "tc_building7" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({reinforced_plate = 1, ic_soul_happy = 1, ic_time_crystal = 1, fused_electrodes = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_1 = {
	order = 1,
	name = "Flying Robots I", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.frames.f_flyer_bot.texture,
	unlocks = {
		-- new resources
		"f_flyer_bot","f_flyer_m","c_landing_pad",
	},
	require_tech = { "tc_robot_frames_4" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_2 = {
	order = 1,
	name = "Flying Robots II", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_drone_comp.texture,
	unlocks = {
		-- new resources
		"f_drone_miner_a","f_drone_transfer_a","c_drone_comp",
	},
	require_tech = { "tc_robot_fly_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1, ic_soul_happy = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_3 = {
	order = 1,
	name = "Flying Robots III", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_drone_port.texture,
	unlocks = {
		-- new resources
		"f_drone_transfer_a2","c_drone_port",
	},
	require_tech = { "tc_robot_fly_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1, ic_soul_happy = 1, engine = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_4 = {
	order = 1,
	name = "Flying Robots IV", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_drone_launcher.texture,
	unlocks = {
		-- new resources
		"f_drone_adv_miner","f_drone_defense_a","c_drone_launcher",
	},
	require_tech = { "tc_robot_fly_3" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1, ic_soul_happy = 1, engine = 1, phase_leaf = 1}, 50),
	category = "Humility",
}

--------------------------------------------------------
------ UPGRADES ------------------------------
--- Networking
data.techs.tc_network1 = {
	order = 3,
	name = "Improved Networking I", -- recovered database etc.
	desc = "Start a linktin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_portable_relay","c_power_relay","c_small_battery"
	},
	require_tech = {"tc_cube_blue_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_network2 = {
	order = 3,
	name = "Improved Networking II", -- recovered database etc.
	desc = "Start a linktin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_power_transmitter"
	},
	require_tech = { "tc_network1" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_network3 = {
	order = 3,
	name = "Improved Networking III", -- recovered database etc.
	desc = "Start a linktin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_medium_capacitor","c_battery","c_large_power_relay"
	},
	require_tech = { "tc_network2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, ic_soul_angry = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_network4 = {
	order = 3,
	name = "Improved Networking IV", -- recovered database etc.
	desc = "Start a linktin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_large_battery","c_large_power_transmitter"
	},
	require_tech = { "tc_network3","tc_cube_green_1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, ic_soul_angry = 1, ic_time_crystal = 1}, 50),
	category = "Expanded Functions",
}

--- weapons 
data.techs.tc_weapons1 = {
	order = order_weapons_1,
	name = "Adv Soul Capture Methods I", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		-- new resources
		'c_repairkit',"c_repairer","c_melee_pulse","c_adv_portable_turret",
	},
	require_tech = {"tc_robot_metallurgy_2" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_weapons2 = {
	order = order_weapons_1,
	name = "Adv Soul Capture Methods II", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_pulselasers","c_pulse_disrupter","c_repairport"
	},
	require_tech = { "tc_weapons1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, crystal_powder = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_weapons3 = {
	order = order_weapons_1,
	name = "Adv Soul Capture Methods III", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_portable_turret_red","c_turret","c_repairer_small_aoe",
	},
	require_tech = { "tc_weapons2" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, crystal_powder = 1, wire = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_weapons4 = {
	order = order_weapons_1,
	name = "Adv Soul Capture Methods IV", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		 "c_twin_autocannons","c_human_missilelauncher",
	},
	require_tech = { "tc_weapons3" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, wire = 1, crystal_powder = 1, reinforced_plate = 1}, 50),
	category = "Maximum Lethality",
}

data.techs.tc_weapons5 = {
	order = order_weapons_2,
	name = "Adv Soul Capture Methods V", -- recovered database etc.
	desc = "The Cube must be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_plasma_turret","c_plasma_cannon",
	},
	require_tech = { "tc_weapons1", "tc_weapons4" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ wire = 1,  ic_soul_angry = 1, reinforced_plate = 1, crystal_powder = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_weapons6 = {
	order = order_weapons_2,
	name = "Adv Soul Capture Methods VI", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_railgun","c_light_cannon",
	},
	require_tech = { "tc_weapons5" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1,  ic_soul_angry = 1, reinforced_plate = 1, crystal_powder = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_weapons7 = {
	order = order_weapons_2,
	name = "Adv Soul Capture Methods VII", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_laser_turret","c_missile_turret",
	},
	require_tech = { "tc_weapons6" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ ldframe = 1,  ic_soul_angry = 1, reinforced_plate = 1, ic_time_crystal = 1}, 50),
	category = "Maximum Lethality",
}
--- storages 

data.techs.tc_robot_storage1 = {
	order = 4,
	name = "Simple Storage I", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_small_storage.texture,
	unlocks = {
		-- new resources
		"c_small_storage", 
	},
	require_tech = {"tc_cube_blue_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_storage2 = {
	order = 4,
	name = "Simple Storage II", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_internal_storage.texture,
	unlocks = {
		-- new resources
		"c_internal_storage", 
	},
	require_tech = { "tc_robot_storage1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1 }, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_storage3 = {
	order = 4,
	name = "Simple Storage III", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_medium_storage.texture,
	unlocks = {
		-- new resources
		"c_medium_storage", 
	},
	require_tech = { "tc_robot_storage2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1, reinforced_plate = 1  }, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_storage4 = {
	order = 4,
	name = "Simple Storage IV", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_large_storage.texture,
	unlocks = {
		-- new resources
		"c_large_storage", 
	},
	require_tech = { "tc_robot_storage3" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1, reinforced_plate = 1, ic_soul_happy = 1 }, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_signals1 = {
	order = 11,
	name = "Telecomunications", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_radio_transmitter","c_radio_receiver" 
	},
	require_tech = { "tc_cube_blue_1"},
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ crystal_powder = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_signals2 = {
	order = 11,
	name = "Wireless Action I", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_small_radar","c_shield_generator",
	},
	require_tech = { "tc_robot_signals1", "tc_cube_green_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ wire = 1, crystal_powder = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_signals3 = {
	order = 11,
	name = "Wireless Action II", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_radar","c_shield_generator2",
	},
	require_tech = { "tc_robot_signals2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ wire = 1, crystal_powder = 1, ic_soul_happy = 1}, 50),
	category = "Expanded Functions",
}
data.techs.tc_robot_signals4 = {
	order = 11,
	name = "Wireless Action III", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_shield_generator3",
	},
	require_tech = { "tc_robot_signals3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ wire = 1, crystal_powder = 1, ic_soul_happy = 1, ldframe = 1}, 50),
	category = "Expanded Functions",
}

data.techs.tc_robot_floor_1 = {
	order = floor_order,
	name = "Foundations I", 
	desc = "The Foundation tech for Foundations",
	texture = data.frames.f_human_foundation1.texture,
	unlocks = {
		"f_human_foundation1","f_human_foundation_adv"
	},
	require_tech = { "tc_robot_metallurgy_2"},
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_robot_floor_2 = {
	order = floor_order,
	name = "Foundations II", 
	desc = "BEEP BOOP",
	texture = data.frames.f_human_foundation1.texture,
	unlocks = {
		"f_human_foundation2","f_human_foundation3","f_human_foundation4",
		"f_human_foundation5","f_human_foundation6","f_human_foundation7","f_foundation_adv",
	},
	require_tech = { "tc_robot_floor_1",},
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1, reinforced_plate = 1}, 50),
	category = "Maximum Lethality",
}
data.techs.tc_robot_floor_3 = {
	order = floor_order,
	name = "Foundations III", 
	desc = "BEEP BOOP",
	texture = data.frames.f_human_foundation1.texture,
	unlocks = {
		"f_human_foundation9","f_human_foundation8",
	},
	require_tech = { "tc_robot_floor_2",},
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1, reinforced_plate = 1, ic_time_crystal = 1}, 50),
	category = "Maximum Lethality",
}






