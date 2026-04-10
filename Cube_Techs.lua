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
		texture = "Main/skin/Icons/Special/Technologies/Basic.png",
		--textures = {"Main/skin/Icons/Special/Technologies/Basic.png","Main/skin/Icons/Special/Technologies/Basic.png","Main/skin/Icons/Special/Technologies/Basic.png"}
	},
	{
		name = "Cube",
		initial_tech = "tc_cube_basic",
		sub_categories = { "Cube_Curiosity", "Cube_Obsession",},
		texture = "Main/skin/Icons/Special/Technologies/Robots.png",
		--textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png",},
	},
	{
		name = "Upgrades",
		initial_tech = "tc_upgrades_basic",
		sub_categories = { "tc_upgrades_1", "tc_upgrades_2"},
		texture = "Main/skin/Icons/Special/Technologies/Robots.png",
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
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- for testing 
		-- "f_human_foundation1","f_human_foundation2","f_human_foundation3","f_human_foundation4",
		-- "f_human_foundation5","f_human_foundation6","f_human_foundation7","f_human_foundation8",

		-- starting resources		
		"ic_cube_blue","datakey_robot","ic_souls",
		--components
		"cc_cube_storage","cc_crystal_power","cc_manifest",

		"xc_cube_1","xc_cube_power_1","xc_cube_pedestal",
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
		"v_color_red", "v_color_green", "v_color_blue", "v_color_yellow", "v_color_cyan", "v_color_magenta", "v_ally_faction",
		"v_color_black", "v_color_brown", "v_color_crimson", "v_color_dark_grey", "v_color_light_green", "v_color_light_grey",
		"v_color_pink", "v_color_white", "v_color_pastel",
		"v_own_faction", "v_enemy_faction", "v_world_faction", "v_bot", "v_building", "v_construction", "v_droppeditem", "v_resource", "v_damaged", "v_mineable",
		"v_alien_faction", "v_solved", "v_unsolved", "v_can_loot", "v_bug_faction", "v_human_faction", "v_robot_faction", "v_blight", "v_not_blight",
		"v_plateau", "v_valley", "v_in_powergrid", "v_is_foundation", "v_is_grounded", "v_is_flying", "v_is_flower",
		-- states
		"v_damaged", "v_infected", "v_broken", "v_unpowered", "v_emergency", "v_powereddown", "v_moving", "v_pathblocked", "v_idle", "v_setnum", "v_maxrange",
		"v_arrow_up", "v_arrow_down", "v_arrow_left", "v_arrow_right",
		"v_arrow_upleft", "v_arrow_upright", "v_arrow_downleft", "v_arrow_downright", "v_transport_route",
		"v_number_0", "v_number_1", "v_number_2", "v_number_3", "v_number_4", "v_number_5", "v_number_6", "v_number_7", "v_number_8", "v_number_9",
		"v_lock_locked", "v_lock_unlocked", "v_alert", "v_octagon", "v_pentagon", "v_star",
		"v_letter_A", "v_letter_B", "v_letter_C", "v_letter_D", "v_letter_E", "v_letter_F", "v_letter_G",
		"v_letter_H", "v_letter_I", "v_letter_J", "v_letter_K", "v_letter_L", "v_letter_M", "v_letter_N",
		"v_letter_O", "v_letter_P", "v_letter_Q", "v_letter_R", "v_letter_S", "v_letter_T", "v_letter_U",
		"v_letter_V", "v_letter_W", "v_letter_X", "v_letter_Y", "v_letter_Z",
	
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
data.techs.tc_upgrades_basic = {
	name = "Upgrades1", -- recovered database etc.
	desc = "Upgrades1",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
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
	},
	require_tech = { "tc_cube_basic" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 }, 50),
	category = "Cube_Curiosity"
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
	category = "Cube_Curiosity",
}
data.techs.tc_cube_blue_3 = {
	order = 2,
	name = "Cube Splitting", -- recovered database etc.
	desc = "With Incredible precision and emotion the Cube can theoretically be cracked open",
	texture = data.items.ic_cube_sphere.texture,
	unlocks = {
		-- new resources
		"ic_cube_sphere",
	},
	require_tech = { "tc_cube_blue_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 , crystal_powder = 1, ic_soul_angry = 1 }, 50),
	category = "Cube_Curiosity",
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
	require_tech = { "tc_cube_basic" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1 }, 300),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_red_2 = {
	order = 1,
	name = "Emotional Processing", -- recovered database etc.
	desc = "At Extreme Temperatures crystal vaporizes into a violent gas useful for generating power/nA byproduct of this process is some crystal powder that wasnt able to react",
	texture = data.items.ic_soul_angry.texture,
	unlocks = {
		-- new resources
		"cc_crystal_power_red","ic_soul_angry",
	},
	require_tech = { "tc_cube_red_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({crystal_powder = 1, ic_soul_plasma = 1 }, 300),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_red_3 = {
	order = 1,
	name = "Resource Regeneration", 
	desc = "",
	texture = data.components.c_blight_magnifier.texture,
	unlocks = {
		-- new resources
		"c_blight_magnifier","crystal_powder_alt","xc_cube_alt"
	},
	require_tech = { "tc_cube_red_2", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_plasma = 1, crystal_powder = 1 }, 100),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_red_4 = { 
	order = 51,
	name = "Anti-Cube Containment", 
	desc = "Captured Anti Cube for perpetual vertical force",
	texture = data.items.ldframe.texture,
	unlocks = {
		-- new resources
		"ldframe",
	},
	require_tech = { "tc_cube_red_3"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_cube_sphere = 1 }, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_red_5 = {
	order = 52,
	name = "Bulk Cube Refining", 
	desc = "Capture an Anti-Cube into a frame to defy gravity\n\nWarning Anti-Cube make behave unpredictably on interaction",
	texture = data.components.cc_red_furnace.texture,
	unlocks = {
		-- new resources
		"cc_red_furnace","ic_soul_plasma_alt",
	},
	require_tech = { "tc_cube_red_4"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ldframe = 1, ic_cube_sphere = 1 }, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_red_6 = {
	order = 52,
	name = "Ultimate Power", 
	desc = "Massive Power Generation",
	texture = data.components.cc_red_furnace.texture,
	unlocks = {
		-- new resources
		-- ultimate power? using superconductors 
	},
	require_tech = { "tc_cube_red_5"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ldframe = 1, ic_cube_sphere = 1 }, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_green_1= {
	order = 3,
	name = "Cube Haste",
	desc = "Energize the Cube to move faster",
	texture = data.items.ic_cube_green.texture,
	unlocks = {
		"ic_cube_green","xc_cube_green",
	},
	require_tech = { "tc_cube_basic" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ crystal_powder = 1 }, 50),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_green_2 = {
	order = 3,
	name = "Wire Weed Farming", -- recovered database etc.
	desc = "Conductive Wire Weed used for",
	texture = data.items.wire.texture,
	unlocks = {
		"wire",
		"cc_planter_wire",'fc_crop_wire_seed0','fc_crop_wire_plant'
	},
	require_tech = { "tc_cube_green_1", },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({datakey_robot = 1, crystal_powder = 1 }, 50),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_green_3 = {
	order = 3,
	name = "Outsourced Introspection", -- recovered database etc.
	desc = "A Brain in a jar set to ponder its own existence",
	texture = data.components.cc_green_brain.texture,
	unlocks = {
		"cc_green_brain","ic_soul_happy",
	},
	require_tech = { "tc_cube_green_2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ crystal_powder = 1, ic_soul_plasma = 1, wire = 1 }, 300),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_green_4 = {
	order = 1,
	name = "Farming", -- recovered database etc.
	desc = "Grow seeds",
	texture = data.items.phase_leaf.texture,
	unlocks = {
		-- new resources
		-- phase farming 
		"phase_leaf","cc_planter_phase_leaf",'fc_crop_phase_seed0','fc_crop_phase_plant'
	},
	require_tech = { "tc_cube_green_3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, ic_soul_plasma = 1, wire = 1 }, 300),
	category = "Cube_Obsession",
}
data.techs.tc_cube_green_5 = {
	order = 2,
	name = "Boost Speed",
	desc = "",
	texture = "Main/textures/icons/items/human/engine.png",
	unlocks = {
		-- new resources
		"xc_cube_boost",
		"engine","ic_fuel","cc_modulespeed","cc_modulespeed_s","cc_modulespeed_m","cc_modulespeed_l",
	},
	require_tech = { "tc_cube_green_4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, reinforced_plate = 1}, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_green_6 = {
	order = 2,
	name = "Phase Power",
	desc = "Uses phase fuel to make power",
	texture = "Main/textures/icons/items/human/engine.png",
	unlocks = {
		'cc_power_phase',
	},
	require_tech = { "tc_cube_green_5" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, reinforced_plate = 1}, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_anti_0 = { -- will unlock when cube is anhillated
	order = 1,
	name = "Anti Cube Annihilation", -- recovered database etc.
	desc = "Find",
	texture = data.frames.f_resourcenode_blightcrystal.texture,
	unlocks = {
		"blight_crystal","ic_time_crystal","xc_cube_anti","xc_cube_time_crystal",
	},
	require_tech = { "tc_cube_blue_3", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ blight_crystal = 1 }, 100),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_anti_1= {
	order = 40,
	name = "Localized Chrono Field Creation", -- recovered database etc.
	desc = "",
	texture = data.components.cc_moduleefficiency_l.texture,
	unlocks = {
		-- new resources
		"cc_moduleefficiency","cc_moduleefficiency_s","cc_moduleefficiency_m","cc_moduleefficiency_l","xc_cube_boost",
	},
	require_tech = { "tc_cube_anti_0", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, ic_soul_angry = 1 }, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_anti_2 = {
	order = 41,
	name = "Chrono Towers", 
	desc = "Towers Harnessing stabilized chrono crystal to create localized chronological fields",
	texture = data.frames.fc_boost_tower.texture,
	unlocks = {
		-- new resources
		"fc_boost_tower","xc_cube_boost",
	},
	require_tech = { "tc_cube_anti_1"},
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, ic_soul_angry = 1, phase_leaf = 1 }, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_anti_3= {
	order = 42,
	name = "Future Invasion", -- recovered database etc.
	desc = "Send Expeditions to the future to steal materials not craftable with the current technology\n\nWarning beware of response from attacked timeline",
	texture = data.items.fused_electrodes.texture,
	unlocks = {
		-- new resources
		"cc_time_travel_machine","fused_electrodes","xc_cube_time_travel"
	},
	require_tech = { "tc_cube_anti_2", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, ic_soul_plasma = 1, phase_leaf = 1, ic_cube_sphere = 1}, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_anti_4= {
	order = 42,
	name = "Negative Entropy Project", -- recovered database etc.
	desc = "The Final Form",
	texture = data.items.fused_electrodes.texture,
	unlocks = {
		-- new resources
	},
	require_tech = { "tc_cube_anti_3", },
	progress_count = 200,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1, fused_electrodes = 1, phase_leaf = 1, ic_cube_sphere = 1}, 100),
	category = "Cube_Obsession",
}



--------------------------------
---------- ROBOT ---------------
data.techs.tc_robot_metallurgy_1 = {
	order = 2,
	name = "Simple Metallurgy", -- recovered database etc.
	desc = "Steel foundarys are the 1st step in advancing to stronger building materials ",
	texture = data.items.steelblock.texture,
	unlocks = {
		-- new resources
		"steelblock",
	},
	require_tech = { "tc_robot_basic" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_metallurgy_2 = {
	order = 2,
	name = "More Materials", -- recovered database etc.
	desc = "Crush Laterite into Contrete or smelt it into Aluminium",
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
	name = "Adv Miners", -- recovered database etc.
	desc = "Crush Laterite into Contrete or smelt it into Aluminium",
	texture = data.components.c_adv_miner.texture,
	unlocks = {
		-- new resources
		"c_adv_miner",
	},
	require_tech = { "tc_robot_metallurgy_2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, ic_soul_angry = 1 }, 25),
	category = "Independance",
}
data.techs.tc_robot_metallurgy_4 = {
	order = 2,
	name = "Adv Miners", -- recovered database etc.
	desc = "Crush Laterite into Contrete or smelt it into Aluminium",
	texture = data.components.c_extractor.texture,
	unlocks = {
		-- new resources
		"c_extractor","concreteslab_alt","laterite"
	},
	require_tech = { "tc_robot_metallurgy_3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, ic_soul_angry = 1,phase_leaf = 1 }, 25),
	category = "Independance",
}
data.techs.tc_robot_beacons1 = {
	order = 2,
	name = "Beacons", -- recovered database etc.
	desc = "",
	texture = data.frames.f_beacon.texture,
	unlocks = {
		-- new resources
		"beacon_frame","f_beacon"
	},
	require_tech = { "tc_robot_metallurgy_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({steelblock = 1, datakey_robot = 1 }, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_beacons2 = {
	order = 2,
	name = "Bulk Recipes", -- recovered database etc.
	desc = "Alternative Bulk Recipes for basic items",
	texture = data.components.cc_manifest.texture,
	unlocks = {
		-- new resources
		"datakey_robot_alt","xc_cube_alt"
	},
	require_tech = { "tc_robot_beacons1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({steelblock = 1, datakey_robot = 1, reinforced_plate = 1 }, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_beacons3 = {
	order = 2,
	name = "Beacons", -- recovered database etc.
	desc = "",
	texture = data.frames.f_beacon_l.texture,
	unlocks = {
		-- new resources
		"f_beacon_l",
	},
	require_tech = { "tc_robot_beacons2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, datakey_robot = 1, phase_leaf = 1, reinforced_plate = 1 }, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_beacons4 = {
	order = 2,
	name = "More Bulk Crafting", -- recovered database etc.
	desc = "",
	texture = data.components.cc_manifest.texture,
	unlocks = {
		-- new resources
		"reinforced_plate_alt","steelblock_alt"
	},
	require_tech = { "tc_robot_beacons3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, datakey_robot = 1, phase_leaf = 1, reinforced_plate = 1, ic_soul_angry = 1 }, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_frames_1 = {
	order = 1,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"c_robotics_factory",
	},
	require_tech = { "tc_upgrades_basic" },
	progress_count = 10,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_frames_2 = {
	order = 1,
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Simple Robotics", -- recovered database etc.
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
	name = "Buildings Expanded", -- recovered database etc.
	desc = "",
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
	desc = "",
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
	desc = "",
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
	name = "Reinforced Walls", -- recovered database etc.
	desc = "",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x1b","f_building1x1h",
	},
	require_tech = {  "tc_building3" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, concreteslab = 1, wire = 1}, 50),
	category = "Independance",
}
data.techs.tc_building5= {
	order = 30,
	name = "Reinforced Walls", -- recovered database etc.
	desc = "",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building1x1e","f_building2x1c",
	},
	require_tech = {  "tc_building4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1}, 50),
	category = "Humility",
}
data.techs.tc_building6= {
	order = 30,
	name = "Reinforced Walls", -- recovered database etc.
	desc = "",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x1d","f_building2x2b","f_building3x2b"
	},
	require_tech = {  "tc_building5" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1}, 50),
	category = "Humility",
}
data.techs.tc_building7= {
	order = 30,
	name = "Reinforced Walls", -- recovered database etc.
	desc = "",
	texture = data.frames.f_building2x2f.texture,
	unlocks = {
		-- new resources
		"f_building2x2a","f_building2x2c","f_building2x2d"
	},
	require_tech = {  "tc_building6" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, ic_soul_happy = 1, ic_time_crystal = 1}, 50),
	category = "Humility",
}
data.techs.tc_building8= {
	order = 30,
	name = "Reinforced Walls", -- recovered database etc.
	desc = "",
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
	name = "Flying Robots", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.frames.f_flyer_bot.texture,
	unlocks = {
		-- new resources
		"f_flyer_bot","f_flyer_m","c_landing_pad",
	},
	require_tech = { "tc_robot_frames_4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_2 = {
	order = 1,
	name = "Flying Robots", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_drone_comp.texture,
	unlocks = {
		-- new resources
		"f_drone_miner_a","f_drone_transfer_a","c_drone_comp",
	},
	require_tech = { "tc_robot_fly_1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1, ic_soul_happy = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_3 = {
	order = 1,
	name = "Flying Robots", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_drone_port.texture,
	unlocks = {
		-- new resources
		"f_drone_transfer_a2","c_drone_port",
	},
	require_tech = { "tc_robot_fly_2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1, ic_soul_happy = 1, engine = 1}, 50),
	category = "Humility",
}
data.techs.tc_robot_fly_4 = {
	order = 1,
	name = "Flying Robots", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_drone_launcher.texture,
	unlocks = {
		-- new resources
		"f_drone_adv_miner","f_drone_defense_a","c_drone_launcher",
	},
	require_tech = { "tc_robot_fly_3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ldframe = 1, ic_soul_happy = 1, engine = 1, phase_leaf = 1}, 50),
	category = "Humility",
}

--------------------------------------------------------
------ UPGRADES ------------------------------
--- Networking
data.techs.tc_network1 = {
	order = 3,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_portable_relay","c_power_relay","c_small_battery"
	},
	require_tech = {"tc_cube_blue_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network2 = {
	order = 3,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_power_transmitter"
	},
	require_tech = { "tc_network1" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network3 = {
	order = 3,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_medium_capacitor","c_battery",
	},
	require_tech = { "tc_network2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, ic_soul_angry = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network4 = {
	order = 3,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_large_power_relay","c_large_battery","c_large_power_transmitter"
	},
	require_tech = { "tc_network3","tc_cube_green_1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, ic_soul_angry = 1, ic_time_crystal = 1}, 50),
	category = "tc_upgrades_1",
}

--- weapons 
data.techs.tc_weapons1 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		-- new resources
		'c_repairkit',"c_repairer","c_melee_pulse","c_adv_portable_turret",
	},
	require_tech = {"tc_robot_metallurgy_1" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_weapons2 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_pulselasers","c_pulse_disrupter","c_repairport"
	},
	require_tech = { "tc_weapons1" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, crystal_powder = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_weapons3 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_portable_turret_red","c_turret","c_repairer_small_aoe",
	},
	require_tech = { "tc_weapons2" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, crystal_powder = 1, wire = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_weapons4 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		 "c_twin_autocannons","c_human_missilelauncher",
	},
	require_tech = { "tc_weapons3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, wire = 1, crystal_powder = 1, reinforced_plate = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_weapons5 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube must be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_plasma_turret","c_plasma_cannon",
	},
	require_tech = { "tc_weapons4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ wire = 1,  ic_soul_angry = 1, reinforced_plate = 1, crystal_powder = 1}, 50),
	category = "tc_upgrades_2",
}
data.techs.tc_weapons6 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_railgun","c_light_cannon",
	},
	require_tech = { "tc_weapons5" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ ic_time_crystal = 1,  ic_soul_angry = 1, reinforced_plate = 1, crystal_powder = 1}, 50),
	category = "tc_upgrades_2",
}
data.techs.tc_weapons7 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		"c_laser_turret","c_missile_turret",
	},
	require_tech = { "tc_weapons6" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ ldframe = 1,  ic_soul_angry = 1, reinforced_plate = 1, ic_time_crystal = 1}, 50),
	category = "tc_upgrades_2",
}
--- storages 

data.techs.tc_robot_storage1 = {
	order = 4,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_small_storage.texture,
	unlocks = {
		-- new resources
		"c_small_storage", 
	},
	require_tech = {"tc_robot_metallurgy_1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_storage2 = {
	order = 4,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_internal_storage.texture,
	unlocks = {
		-- new resources
		"c_internal_storage", 
	},
	require_tech = { "tc_robot_storage1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1 }, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_storage3 = {
	order = 4,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_medium_storage.texture,
	unlocks = {
		-- new resources
		"c_medium_storage", 
	},
	require_tech = { "tc_robot_storage2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1, reinforced_plate = 1  }, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_storage4 = {
	order = 4,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_large_storage.texture,
	unlocks = {
		-- new resources
		"c_large_storage", 
	},
	require_tech = { "tc_robot_storage3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1, reinforced_plate = 1, ic_soul_happy = 1 }, 50),
	category = "tc_upgrades_1",
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
	require_tech = { "tc_cube_green_1"},
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ crystal_powder = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_signals2 = {
	order = 11,
	name = "Wireless Action", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_small_radar","c_shield_generator",
	},
	require_tech = { "tc_robot_signals1" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ wire = 1, crystal_powder = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_signals3 = {
	order = 11,
	name = "Wireless Action", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_radar","c_shield_generator2",
	},
	require_tech = { "tc_robot_signals2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ wire = 1, crystal_powder = 1, ic_soul_happy = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_signals4 = {
	order = 11,
	name = "Wireless Action", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_radar.texture,
	unlocks = {
		-- new resources
		"c_shield_generator3",
	},
	require_tech = { "tc_robot_signals3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ wire = 1, crystal_powder = 1, ic_soul_happy = 1, ldframe = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_robot_floor_1 = {
	order = 11,
	name = "Foundations", 
	desc = "BEEP BOOP",
	texture = data.frames.f_human_foundation1.texture,
	unlocks = {
		"f_human_foundation1","f_human_foundation_adv"
	},
	require_tech = { "tc_robot_metallurgy_2"},
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1}, 50),
	category = "tc_upgrades_2",
}
data.techs.tc_robot_floor_2 = {
	order = 11,
	name = "Foundations", 
	desc = "BEEP BOOP",
	texture = data.frames.f_human_foundation1.texture,
	unlocks = {
		"f_human_foundation2","f_human_foundation3","f_human_foundation4",
		"f_human_foundation5","f_human_foundation6","f_human_foundation7","f_foundation_adv",
	},
	require_tech = { "tc_robot_floor_1",},
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1, reinforced_plate = 1}, 50),
	category = "tc_upgrades_2",
}
data.techs.tc_robot_floor_3 = {
	order = 11,
	name = "Foundations", 
	desc = "BEEP BOOP",
	texture = data.frames.f_human_foundation1.texture,
	unlocks = {
		"f_human_foundation9","f_human_foundation8",
	},
	require_tech = { "tc_robot_floor_2",},
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1, reinforced_plate = 1, ic_time_crystal = 1}, 50),
	category = "tc_upgrades_2",
}






