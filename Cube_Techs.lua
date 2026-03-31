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
	-- {
	-- 	name = "Upgrades",
	-- 	initial_tech = "tc_upgrades_basic",
	-- 	sub_categories = { "tc_upgrades_1", "tc_adv_upgrades"},
	-- 	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	-- 	textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png"},
	-- },
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
		-- "ic_cube_green", "cc_plant_seed","ic_cube_pink","ceramictiles",
		-- ,"f_human_foundation1","f_human_foundation2","f_human_foundation3","f_human_foundation4",
		-- "f_human_foundation5","f_human_foundation6","f_human_foundation7","f_human_foundation8",
		--"cc_pipe_crane",""

		-- starting resources		
		"ic_cube_blue","ic_cube_empty","datakey_robot","ic_souls",
		-- starting buildings
		-- starting bots 
		-- starting componenets
			--new
		"cc_cube_storage","cc_crystal_power","cc_manifest",
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
        "metalore","crystal",
		
		"metalplate",

		
		-- starting buildings
		
		"f_building1x1d","f_building1x1f","f_building2x1g","f_building2x1f",

		-- starting bots 
		"f_bot_1s_a","f_carrier_bot",
			--other


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
		"c_signpost","c_behavior","c_shared_storage",
	},
	uplink_recipe = CreateUplinkRecipe({ bot_ai_core = 1 }, 300),
	progress = 1,
}

data.techs.tc_cube_refining = {
	order = 2,
	name = "Blue Cube Refining", -- recovered database etc.
	desc = "The Cubes Materials are Unfathomable, But our own are not ",
	texture = data.items.ic_cube_blue.texture,
	unlocks = {
		-- new resources
		"crystal_powder","cc_cube_recharger",
		
		
		-- new components 
		--"cc_refinery",

	},
	require_tech = { "tc_cube_basic" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 }, 50),
	category = "Cube_Curiosity"
}
data.techs.tc_cube_red_refining = {
	order = 1,
	name = "Hidden Fury", -- recovered database etc.
	desc = "Deep in the earth the planet rages. A molten ocean of dreams forever trapped under a thin blanket of reality.",
	texture = data.items.ic_cube_red.texture,
	unlocks = {
		-- new resources
		"ic_cube_red","cc_red_cube_refinery","reinforced_plate","cc_crystal_power_red",
	},
	require_tech = { "tc_cube_basic" },
	tooltip = 'Find a molten explorable to unlock this tech for free',
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 }, 300),
	category = "Cube_Curiosity",
}
-- data.techs.tc_cube_red_power = {
-- 	order = 1,
-- 	name = "Crystal Vaporization", -- recovered database etc.
-- 	desc = "At Extreme Temperatures crystal vaporizes into a violent gas useful for generating power/nA byproduct of this process is some crystal powder that wasnt able to react",
-- 	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
-- 	unlocks = {
-- 		-- new resources
-- 		"cc_crystal_power_red",
-- 	},
-- 	require_tech = { "tc_cube_red_refining" },
-- 	progress_count = 100,
-- 	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 }, 300),
-- 	category = "Cube_Curiosity",
-- }
data.techs.tc_cube_emotion_processing = {
	order = 1,
	name = "Emotional Processing", -- recovered database etc.
	desc = "",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- new resources
		"ic_soul_angry",
	},
	require_tech = { "tc_cube_red_refining", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, ic_soul_plasma = 1 }, 100),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_green_discovery= {
	order = 3,
	name = "Farming", -- recovered database etc.
	desc = "Grow seeds",
	texture = data.items.ic_cube_green.texture,
	unlocks = {
		-- new resources
		"ic_cube_green",
		-- phase farming 
		"wire",

		"cc_planter_wire",'fc_crop_wire_seed0','fc_crop_wire_plant'
	},
	require_tech = { "tc_cube_basic" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 }, 50),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_green_2= {
	order = 3,
	name = "Farming", -- recovered database etc.
	desc = "Grow seeds",
	texture = data.items.phase_leaf.texture,
	unlocks = {
		-- new resources
		-- phase farming 
		"phase_leaf","cc_planter_phase_leaf",'fc_crop_phase_seed0','fc_crop_phase_plant'
	},
	require_tech = { "tc_cube_green_discovery" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, wire = 1 }, 300),
	category = "Cube_Curiosity",
}

data.techs.tc_cube_soul_refining= {
	order = 2,
	name = "Soul Plasma Refinery", -- recovered database etc.
	desc = "This facotry will run on the power of friendship",
	texture = data.items.anomaly_particle.texture,
	unlocks = {
		-- new resources
		"ic_soul_plasma",
		"cc_soul_refinery","fc_pipe","cc_power_souls",'cc_pipe_output_i',
	},
	require_tech = { "tc_cube_refining" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1 , crystal_powder = 1 }, 50),
	category = "Cube_Curiosity",
}

data.techs.tc_cube_hyper_discovery= {
	order = 2,
	name = "Parrallel Universe Thoery", -- recovered database etc.
	desc = "",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- new resources
		"ic_cube_pink","cc_time_travel_machine","fused_electrodes","c_moduleefficiency","c_moduleefficiency_s","c_moduleefficiency_m","c_moduleefficiency_l",
	},
	require_tech = { "tc_cube_soul_refining", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, ic_soul_plasma = 1 }, 100),
	category = "Cube_Obsession",
}
data.techs.tc_cube_green_brain = {
	order = 3,
	name = "Outsourced Introspection", -- recovered database etc.
	desc = "A Brain in a jar set to ponder its own existence",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- new resources
		"cc_green_brain","ic_soul_happy","micropro"
	},
	require_tech = { "tc_cube_green_2", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, wire = 1 }, 50),
	category = "Cube_Curiosity",
}
data.techs.tc_cube_yellow_discovery= {
	order = 1,
	name = "Tempered Cube", -- recovered database etc.
	desc = "",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- new resources
		"ic_cube_yellow","ic_living_metal"
	},
	require_tech = { "tc_cube_soul_refining", },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ ic_soul_happy = 1, ic_soul_angry = 1 }, 100),
	category = "Cube_Obsession",
}

data.techs.tc_engine= {
	order = 3,
	name = "Boost Speed", -- recovered database etc.
	desc = "",
	texture = "Main/textures/icons/items/human/engine.png",
	unlocks = {
		-- new resources
		"engine","ic_fuel","c_modulespeed","c_modulespeed_s","c_modulespeed_m","c_modulespeed_l",
	},
	require_tech = { "tc_cube_soul_refining" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 5, concreteslab = 2 }, 300),
	category = "Cube_Obsession",
}



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
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1}, 25),
	category = "Independance",
}

data.techs.tc_robot_metallurgy_2 = {
	order = 2,
	name = "More Materials", -- recovered database etc.
	desc = "Crush Laterite into Contrete or smelt it into Aluminium",
	texture = data.items.laterite.texture,
	unlocks = {
		-- new resources
		"laterite","concreteslab","f_human_foundation_basic",
		

		--"f_flyer_m","f_flyer_bot","c_landing_pad","c_small_storage",
	},
	require_tech = { "tc_robot_metallurgy_1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1 }, 25),
	category = "Independance",
}

data.techs.tc_robot_beacons1 = {
	order = 2,
	name = "Beacons", -- recovered database etc.
	desc = "",
	texture = data.frames.f_beacon.texture,
	unlocks = {
		-- new resources
		"beacon_frame","f_beacon",
		

		--"f_flyer_m","f_flyer_bot","c_landing_pad","c_small_storage",
	},
	require_tech = { "tc_robot_metallurgy_2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, datakey_robot = 1 }, 50),
	category = "Independance",
}


data.techs.tc_robot_frames_1 = {
	order = 1,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		"c_robotics_factory",
		--"steelblock","f_building1x1c","f_building1x1a",

		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
	},
	require_tech = { "tc_upgrades_basic" },
	progress_count = 25,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_frames_2 = {
	order = 1,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources

		"f_bot_1m_a","f_bot_1s_b",
	},
	require_tech = { "tc_robot_frames_1" },
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, steelblock = 1}, 25),
	category = "Independance",
}
data.techs.tc_robot_frames_3 = {
	order = 1,
	name = "Simple Robotics", -- recovered database etc.
	desc = "BEEP BOOP",
	texture = data.components.c_robotics_factory.texture,
	unlocks = {
		-- new resources
		
		--"steelblock","f_building1x1c","f_building1x1a",
		"f_bot_2s",
		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
	},
	require_tech = { "tc_robot_frames_2" },
	progress_count = 100,
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
		
		--"steelblock","f_building1x1c","f_building1x1a",
		"f_transport_bot",
		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
	},
	require_tech = { "tc_robot_frames_3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ datakey_robot = 1, steelblock = 1, wire = 1, ic_soul_happy = 1}, 50),
	category = "Independance",
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
	progress_count = 50,
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
	progress_count = 50,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1}, 25),
	category = "Independance",
}
data.techs.tc_building3= {
	order = 30,
	name = "Deep Foundations", -- recovered database etc.
	desc = "",
	texture = data.items.concreteslab.texture,
	unlocks = {
		-- new resources
		"f_building1x1b","f_building2x1e",
		"f_wall","f_gate",
	},
	require_tech = {  "tc_building2", "tc_robot_metallurgy_2", },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, concreteslab = 1}, 50),
	category = "Independance",
}
data.techs.tc_building4= {
	order = 30,
	name = "Reinforced Walls", -- recovered database etc.
	desc = "",
	texture = data.items.concreteslab.texture,
	unlocks = {
		-- new resources
		"f_building2x1b","f_building1x1g","f_building1x1h",
	},
	require_tech = {  "tc_building3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ metalplate = 1, steelblock = 1, concreteslab = 1, reinforced_plate = 1}, 50),
	category = "Independance",
}
--------------------------------------------------------

------ UPGRADES


--- Robot Frames ---


--- Networking
data.techs.tc_network1 = {
	order = 9,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_portable_relay"
	},
	require_tech = { "tc_upgrades_basic" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  wire = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network2 = {
	order = 9,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_power_relay","c_small_battery",
	},
	require_tech = { "tc_network1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network3 = {
	order = 9,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_power_transmitter"
	},
	require_tech = { "tc_network2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, phase_leaf = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network4 = {
	order = 9,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_medium_capacitor","c_battery",
	},
	require_tech = { "tc_network3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, phase_leaf = 1, ic_soul_angry = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_network5 = {
	order = 9,
	name = "Improved Networking", -- recovered database etc.
	desc = "Start a Linkin Profile",
	texture = data.components.c_power_relay.texture,
	unlocks = {
		-- new resources
		"c_large_power_relay","c_large_battery","c_large_power_transmitter"
	},
	require_tech = { "tc_network4" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  crystal_powder = 1, wire = 1, phase_leaf = 1, ic_soul_angry = 1, fused_electrodes = 1}, 50),
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
		'c_repairkit',"c_repairer","c_melee_pulse",
	},
	require_tech = { "tc_upgrades_basic" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_weapons2 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		-- new resources
		"c_adv_portable_turret",
	},
	require_tech = { "tc_weapons1" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, wire = 1}, 50),
	category = "tc_upgrades_1",
}
data.techs.tc_weapons3 = {
	order = 9,
	name = "Improved Soul Capture Methods", -- recovered database etc.
	desc = "The Cube needs to be studied\nThe Factory Needs Power\nThe Forges Needs Souls\nHARVEST THEM",
	texture = data.components.c_adv_portable_turret.texture,
	unlocks = {
		-- new resources
		"c_portable_turret_red","c_portable_turret_green"
	},
	require_tech = { "tc_weapons2" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({  steelblock = 1, wire = 1, phase_leaf = 1}, 50),
	category = "tc_upgrades_1",
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
		--"steelblock","f_building1x1c","f_building1x1a",

		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
	},
	require_tech = { "tc_upgrades_basic" },
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
		--"steelblock","f_building1x1c","f_building1x1a",

		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
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
		--"steelblock","f_building1x1c","f_building1x1a",

		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
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
		--"steelblock","f_building1x1c","f_building1x1a",

		--"f_bot_1m_a","f_bot_1s_b","c_power_relay",
	},
	require_tech = { "tc_robot_storage3" },
	progress_count = 100,
	uplink_recipe = CreateUplinkRecipe({ steelblock = 1, wire = 1, reinforced_plate = 1, fused_electrodes = 1 }, 50),
	category = "tc_upgrades_1",
}















