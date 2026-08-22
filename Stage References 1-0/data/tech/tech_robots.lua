------ General ------

-- unlocked when equipping uplink
data.techs.t_assembly = {
	name = "Research Uplink",
	desc = "Robotic assembly line enabling further logistic options",
	texture = "Main/textures/tech/uplink.png",
}

-- ROBOTS STARTING POINT
data.techs.t_robot_tech_basic = {
	name = "New Starter Tech", -- recovered database etc.
	desc = "Establishing our own technology in this new environment. We need to adapt to resources available on this planet.",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	unlocks = {
		-- starting resources
		'metalore', 'crystal', 'metalbar', 'metalplate', 'silica', 'foundationplate',
		'c_miner', 'circuit_board', --'reinforced_plate',

		'f_building1x1d', -- 1S
		'f_building1x1f', -- 8 Storage

		'f_bot_1s_a',

		-- starting research
		'f_foundation', 'c_deconstructor',
		'c_fabricator', 'c_assembler', 'c_uplink', 'c_portable_turret', 'c_integrated_behavior',

		-- starting values
		'v_color_red', 'v_color_green', 'v_color_blue', 'v_color_yellow', 'v_color_cyan', 'v_color_magenta', 'v_ally_faction',
		'v_color_black', 'v_color_brown', 'v_color_crimson', 'v_color_dark_grey', 'v_color_light_green', 'v_color_light_grey',
		'v_color_pink', 'v_color_white', 'v_color_pastel',
		'v_own_faction', 'v_enemy_faction', 'v_world_faction', 'v_bot', 'v_building', 'v_construction', 'v_droppeditem', 'v_resource', 'v_mineable',
		'v_alien_faction', 'v_solved', 'v_unsolved', 'v_can_loot', 'v_bug_faction', 'v_human_faction', 'v_robot_faction', 'v_blight', 'v_not_blight',
		'v_plateau', 'v_valley', 'v_in_powergrid', 'v_is_foundation', 'v_is_grounded', 'v_is_flying', 'v_is_flower', 'v_wall',

		-- states
		'v_damaged', 'v_infected', 'v_broken', 'v_unpowered', 'v_emergency', 'v_powereddown', 'v_moving', 'v_pathblocked', 'v_idle', 'v_setnum', 'v_maxrange',

		-- walls
		'f_wall',

		'x_tutorial',
		-- NEW How to Play entries
		'x_tc_controls', 'x_tc_buildings', 'x_tc_deployment', 'x_tc_components', 'x_tc_research', 'x_tc_resources_mining',
		'x_tc_production', 'x_tc_logistics', 'x_tc_behaviors', 'x_tc_research', 'x_tc_user_interface', 'x_tc_registers', 'x_tc_power',
		'x_tc_unit', 'x_tc_transport_route', 'x_tc_introduction', 'x_tc_the_interface', 'x_tc_virus', 'x_tc_blight',

		'f_carrier_bot',
		'c_scout_radar',
		'f_building2x1g',

		'x_bugs',
	},
}

-- Tier 0 research

------------------  BASIC TREE  ------------------

------------------  TIER ONE  ------------------

data.techs.t_signals1 = {
	order = 1,
	name = "Basic Signals",
	desc = "Allows for production of components for detection and signal transfer",
	-- desc = "Unlocks short range signal components that allow detection and information transfer",
	texture = "Main/textures/tech/robots/robot_logistics_01_1.png",
	uplink_recipe = CreateUplinkRecipe({ circuit_board = 1 }, 30),
	progress_count = 5,
	require_tech = { robot = "t_assembly", human = "t_robots_ai", alien = "t_robots_ai" },
	category = "Basic",
	unlocks = {
		'c_signal_reader', 'c_portable_radar', 'c_signpost',
		'v_arrow_up', 'v_arrow_down', 'v_arrow_left', 'v_arrow_right',
		'v_arrow_upleft', 'v_arrow_upright', 'v_arrow_downleft', 'v_arrow_downright', 'v_transport_route',
		'v_number_0', 'v_number_1', 'v_number_2', 'v_number_3', 'v_number_4', 'v_number_5', 'v_number_6', 'v_number_7', 'v_number_8', 'v_number_9',
		'v_lock_locked', 'v_lock_unlocked', 'v_alert', 'v_octagon', 'v_pentagon', 'v_star', 'v_power_production',
		'v_letter_A', 'v_letter_B', 'v_letter_C', 'v_letter_D', 'v_letter_E', 'v_letter_F', 'v_letter_G',
		'v_letter_H', 'v_letter_I', 'v_letter_J', 'v_letter_K', 'v_letter_L', 'v_letter_M', 'v_letter_N',
		'v_letter_O', 'v_letter_P', 'v_letter_Q', 'v_letter_R', 'v_letter_S', 'v_letter_T', 'v_letter_U',
		'v_letter_V', 'v_letter_W', 'v_letter_X', 'v_letter_Y', 'v_letter_Z',
	},
}
--	NEW
--	talkinghead = [[<hl>Basic Signals</> deals with sending and receiving signals around your base. It allows your buildings and units to communicate information to each other across any distance.]],

data.techs.t_structures1 = {
	order = 2,
	name = "Basic Structures",
	desc = "Expands the range of small buildings with a variety of socket configurations",
	-- desc = "Expands the range of options for 1x1 buidlings",
	texture = "Main/textures/tech/robots/robot_robotics_01_1.png",
	uplink_recipe = CreateUplinkRecipe({ metalplate = 3 }, 15),
	progress_count = 10,
	require_tech = { robot = "t_assembly", human = "t_robots_ai", alien = "t_robots_ai" },
	unlocks = {
		'reinforced_plate',
		--'f_foundation_basic',
		'f_building1x1c', -- 2S
		'f_building2x1f', -- 1M1S
		'f_building1x1h', -- defense block
		-- 'x_freeplay_reinforced_plates',
	},
	category = "Basic",
}

data.techs.t_power0 = {
	order = 3,
	name = "Basic Power",
	desc = "Unlocks power production and storage components that contribute to your logistics network",
	-- desc = "This option unlocks power production and storage components that contribute to your power grid",
	texture = "Main/textures/tech/robots/robot_power_01_1.png",
	uplink_recipe = CreateUplinkRecipe({ crystal = 3 }, 15),
	progress_count = 10,
	require_tech = { robot = "t_assembly", human = "t_robots_ai", alien = "t_robots_ai" },
	category = "Basic",
	unlocks = {
		'c_crystal_power',
		'c_light',
		'c_light_rgb',
		'c_portable_relay',
		'c_small_relay',
	},
}
--	NEW
--	talkinghead = [[<hl>Power</> is required to run your base. If you go over your power threshold the <hl>efficiency</> of your units will decrease making them run slower until they are unable to function at all. Units have emergency stored power that allows them to return to base in the case of a power outage. You can check your power usage in the <hl>Command Center</>]],

------------------  TIER TWO  ------------------

data.techs.t_signals2 = {
	name = "Behaviors",
	desc = "Introduces Behaviors that allow increased and finer control of units and buildings for automation purposes",
	texture = "Main/textures/tech/robots/robot_logistics_02_1.png",
	uplink_recipe = CreateUplinkRecipe({ reinforced_plate = 1, circuit_board = 1 }, 100),
	progress_count = 10,
	require_tech = { "t_signals1" }, --{ "t_signals1" },
	category = "Basic",
	unlocks = {
		'c_behavior',
		'c_shared_storage',
		'beacon_frame', 'f_beacon',
		-- 'x_behaviors', -- codex
	},
}

data.techs.t_robotics10 = {
	name = "Basic Robotics",
	desc = "Introduction of Robotics Assembler allowing production of units with greater capabilities",
	-- desc = "New Robots production Component and additional units",
	-- desc = "Add additional robotics unit production",
	texture = "Main/textures/tech/robots/robot_robotics_02_1.png",

	uplink_recipe = CreateUplinkRecipe({ crystal = 1, reinforced_plate = 2 }, 50),
	progress_count = 10,
	require_tech = { "t_structures1" }, --{ "t_robotics0" },
	category = "Basic",
	unlocks = {
		'c_robotics_factory',
		'f_bot_1s_b',
		-- 'x_robotics', -- codex
		'f_building1x1a', -- 1M
		'f_building2x1a', -- 2M
		'energized_plate',
		'silicon',
	},
}


data.techs.t_power10 = {
	name = "Power Transduction",
	texture = "Main/textures/tech/robots/robot_power_02_1.png",
	desc = "Conversion of basic power into additional forms for added power options.",
	--desc = "Adds additional Components which can expand the area of the power grid",
	-- desc = "New Componets which can expanded the power grid",
	uplink_recipe = CreateUplinkRecipe({ crystal = 2, reinforced_plate = 1 }, 150),
	progress_count = 10,
	require_tech = { "t_power0" },
	category = "Basic",
	unlocks = { 'c_solar_cell', 'c_small_battery', 'c_capacitor', 'c_melee_pulse', 'c_shield_generator', },
}

------------------  TIER THREE  ------------------

data.techs.t_signals3 = {
	name = "Nanobots",
	desc = "Remote connection to units and items allows for damage repair and quick transportation of inventory",
	texture = "Main/textures/tech/robots/robot_logistics_03_1.png",
	uplink_recipe = CreateUplinkRecipe({ energized_plate = 1, circuit_board = 5 }, 150),
	progress_count = 5,
	require_tech = { "t_signals2" },
	category = "Basic",
	unlocks = {
		'c_repairer', 'c_repairkit',
		'c_portablecrane',
		--'c_smart_shared_storage',
	},
}

data.techs.t_robotics0 = {
	name = "Robotics Production",
	desc = "Expansion and improvement of production ability adding more advanced units and buildings",
	texture = "Main/textures/tech/robots/robot_robotics_03_1.png",

	uplink_recipe = CreateUplinkRecipe({ silicon = 2, energized_plate = 2 }, 100),
	progress_count = 10,
	require_tech = { "t_robotics10" }, --{ "t_assembly" },
	category = "Basic",
	unlocks = {
		'f_bot_2s', -- 2S
		'f_bot_1m_a', -- 1M
		'f_building2x2f', --2M
		'wire',
	},
}

data.techs.t_power1 = {
	name = "Expanded Power",
	texture = "Main/textures/tech/robots/robot_power_03_1.png",
	desc = "Increased ability to supply grid through wind powered production and power storage components",
	uplink_recipe = CreateUplinkRecipe({ crystal = 5, energized_plate = 1 }, 100),
	progress_count = 10,
	require_tech = { "t_power10" }, --{ "t_power0" },
	category = "Basic",
	unlocks = {
		'c_pulselasers', 'c_adv_portable_turret', 'c_wind_turbine', 'c_medium_capacitor', 'c_power_relay',
	},
}

------------------  TIER FOUR  ------------------

data.techs.t_research1 = {
	name = "Gateway Technology",
	desc = "The understanding of simulation data opening a gateway to advanced technologies and materials",
	texture = "Main/textures/tech/robots/robot_robotics_04_1_gt.png",
	uplink_recipe = CreateUplinkRecipe({ robot_datacube = 1, wire = 6, energized_plate = 4 }, 400),
	progress_count = 5,
	require_tech = { "t_robotics0" },
	unlocks = {
		'c_refinery',
		'crystal_powder', 'hdframe',
		'f_building_sim',
		'c_resimulator_large',
		'f_gate',
		'c_resimulator_core',
	},
	category = "Basic",
}

----- ADVANCED

-------------- TIER 1 ---------------

data.techs.t_storage1 = {
	order = 1,
	name = "Advanced Logistics",
	desc = "Logistics upgrades for storing of items",
	texture = "Main/textures/tech/robots/robot_logistics_04_1.png",
	uplink_recipe = CreateUplinkRecipe({ wire = 2, crystal_powder = 4 }, 250),
	progress_count = 20,
	require_tech = { "t_research1" },
	unlocks = {
		'c_radio_receiver', 'c_radio_transmitter',
		'c_internal_storage',
		-- 'x_tech_storage', -- codex
		'c_small_storage',
		'c_deployer',
		'c_repairer_small_aoe',
	},
	category = "Advanced",
}
--	NEW
--	talkinghead = [[<hl>Storage</> is an important part of keeping your base efficient. Inventory slots are limited on your Units so having extra options for storage will be more and more valuable as you stockpile and control the flow of your materials throughout your base so they are readily available when you need them.]],

data.techs.t_structures2 = {
	order = 2,
	name = "Advanced Materials",
	desc = "Advanced material refinement expanding building options.",
	texture = "Main/textures/tech/robots/robot_robotics_05_1.png",
	uplink_recipe = CreateUplinkRecipe({ wire = 3, hdframe = 3 }, 400),
	progress_count = 20,
	require_tech = { "t_research1" },
	unlocks = {
		'f_building1x1b', -- 1L
		'f_building2x1c', -- 2M
		'f_building2x1e', -- 2S1M
		'refined_crystal',
		'f_foundation_basic',
		'cable',
	},
	category = "Advanced",
}

data.techs.t_power11 = {
	order = 3,
	name = "Power Upgrade",
	texture = "Main/textures/tech/robots/robot_power_04_1.png",
	desc = "Unlocks options to send power over greater distances",
	uplink_recipe = CreateUplinkRecipe({ hdframe = 1, crystal_powder = 2 }, 500),
	progress_count = 20,
	require_tech = { "t_research1" },
	category = "Advanced",
	unlocks = { 'c_wind_turbine_l', 'c_power_transmitter', 'f_beacon_l', 'c_pulse_disrupter', -- 'c_pulselasers',
	-- 'c_solar_cell',
	},
}

-------------- TIER 2 ---------------

data.techs.t_storage4 = {
	name = "Drone Storage",
	desc = "Medium sized storage and small automated drones",
	texture = "Main/textures/tech/robots/robot_logistics_05_1.png",
	uplink_recipe = CreateUplinkRecipe({ cable = 3, circuit_board = 1, refined_crystal = 1 }, 1000),
	progress_count = 10,
	require_tech = { "t_storage1", },
	unlocks = {
		--'c_smart_storage',
		'c_drone_port', 'f_drone_transfer_a',
		'c_medium_storage', 'f_building1x1g',
		'c_modulevisibility',
	},
	category = "Advanced",
}

data.techs.t_structures4 = {
	name = "Advanced Structures",
	desc = "Understanding of core structural matrices allowing for advanced chip, matrix, and frame production.",
	texture = "Main/textures/tech/robots/robot_robotics_06_1.png",
	uplink_recipe = CreateUplinkRecipe({ robot_datacube = 3, circuit_board = 1, refined_crystal = 1 }, 500),
	progress_count = 20,
	require_tech = { "t_structures2" }, --{ "t_structures3", },
	unlocks = {
		'f_building2x2a', -- 2M1L
		'f_building2x1b', -- 1L1M
		'f_building3x2b', -- 2M2S
		'f_building2x2b', -- 3M
		'f_foundation_adv',
		'icchip',
		'c_modulehealth',
		'c_modulehealth_s',
		'c_advanced_assembler',
	},
	category = "Advanced",
}

data.techs.t_power12 = {
	name = "Power Field",
	texture = "Main/textures/tech/robots/robot_power_05_1.png",
	desc = "Using power fields to generate defenses",
	uplink_recipe = CreateUplinkRecipe({ hdframe = 2, circuit_board = 1, refined_crystal = 1 }, 500),
	progress_count = 30,
	require_tech = { "t_power11" },
	category = "Advanced",
	unlocks = {
		'c_shield_generator2',
		'c_turret',
		'c_photon_cannon',
		'c_moduleefficiency_l',
		'c_modulespeed',
	}, -- 'c_modulevisibility_s', -- 'c_modulevisibility', -- 'c_pulse_disrupter', --'c_power_relay',
}

-------------- TIER 3 ---------------

data.techs.t_defense2 = {
	name = "Scanner Tech",
	texture = "Main/textures/tech/robots/robot_logistics_06_1.png",
	desc = "Improved sensor equipment with extended radar ability and the ability to scan buildings.",
	uplink_recipe = CreateUplinkRecipe({ refined_crystal = 2, icchip = 1, robot_datacube = 4 }, 750),
	progress_count = 20,
	require_tech = { "t_storage4" },
	category = "Advanced",
	unlocks = {
		'c_small_scanner',
		'c_small_radar',
		'c_repairer_aoe',
		'c_modulevisibility_s',
		'c_modulespeed_m',
	},
}

data.techs.t_robotics2 = {
	name = "Matrix Technology",
	texture = "Main/textures/tech/robots/robot_robotics_07_1.png",
	desc = "Unlocks advanced robotics matrix technology",
	uplink_recipe = CreateUplinkRecipe({ robot_datacube = 4, refined_crystal = 1, icchip = 1 }, 750),
	progress_count = 20,
	require_tech = { "t_structures4" },
	category = "Advanced",
	unlocks = {
		'optic_cable', 'datacube_matrix',
		--'f_foundation_adv',
		'f_bot_1m_b', -- 1M
		'f_bot_1m1s',  -- 1M1S
		'f_transport_bot',
		'c_modulehealth_m', -- 'c_modulespeed_l',
	},
}

data.techs.t_power2 = {
	name = "Power Storage",
	texture = "Main/textures/tech/robots/robot_power_06_1.png",
	desc = "Unlocks simple power options",
	uplink_recipe = CreateUplinkRecipe({ robot_datacube = 4, refined_crystal = 2, icchip = 1 }, 750),
	progress_count = 20,
	require_tech = { "t_power12" },
	category = "Advanced",
	unlocks = {
		'c_battery',
		'c_solar_panel',
		'c_photon_beam',
		'c_moduleefficiency_m',
		'c_modulespeed_s',
	}, -- 'c_modulehealth_s', -- 'c_modulehealth', -- 'c_plasma_cannon', --'c_photon_cannon',
}

-------------- TIER 4 ---------------

data.techs.t_research2 = {
	name = "Supercomputing",
	-- name = "Data Analysis",
	--texture = "Main/textures/icons/items/refinedcrystal.png",
	texture = "Main/textures/tech/robots/robot_robotics_08_1_sc.png",
	desc = "Allows more advanced computation research",
	uplink_recipe = CreateUplinkRecipe({ robot_datacube = 5, datacube_matrix = 1, icchip = 2 }, 1000),
	progress_count = 20,
	require_tech = { "t_robotics2"} , --{ "t_assembly" },
	unlocks = {
		'c_data_analyzer',  -- 'datacube_matrix', 'optic_cable',
		'robot_research',
		'f_bot_1l_a',  -- 1L
		'c_modulespeed_l', -- 'c_modulespeed_m',
		'c_modulehealth_l',
		'f_human_foundation9',
	},
	category = "Advanced",
}

------------------------------------------------------------------------
----------------------- ROBOTS (3rd Tree)  -----------------------------
------------------------------------------------------------------------

------------------  TIER ONE  ------------------
data.techs.t_storage2 = {
	order = 1,
	name = "Hybrid Automation",
	desc = "Logistics upgrade",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 1, human_research = 1 }, 1500),
	texture = "Main/textures/tech/item_transporter.png",
	progress_count = 30,
	require_tech = { "t_research2" }, --{ "t_storage1", },
	unlocks = {
		'c_crane',
		'f_building1x1e', -- 24 slots
		'c_modulevisibility_m',
		'c_drone_comp',
		'f_drone_defense_a',
		'f_drone_adv_miner'
	},
	category = "Hybrid",
}

data.techs.t_structures5 = {
	order = 2,
	name = "Epic Structures",
	texture = "Main/textures/icons/frame/building_2x2_e.png",
	desc = "Highest level of refinement and foundational building materials for the most sophisticated structures",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 1, optic_cable = 1 }, 1000),
	progress_count = 30,
	require_tech = { "t_research2" },
	unlocks = {
		-- 'f_building2x2c', -- 2M1L
		'f_building2x2d', -- 2M1L
		'f_building2x2e', -- 1M3S
		'fused_electrodes',
		'c_advanced_refinery',
		'f_human_foundation8',
		'uframe',
	},
	category = "Hybrid",
}

data.techs.t_power5 = {
	order = 3,
	name = "Hybrid Tech",
	texture = "Main/textures/icons/components/portable_shieldgenerator_red.png",
	desc = "Unlocks advanced power options",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 1, blight_research = 1 }, 1500),
	progress_count = 30,
	require_tech = { "t_research2" },
	category = "Hybrid",
	unlocks = {
		'c_shield_generator3',
		'c_moduleefficiency_s',
		'c_power_core',
	},
}

------------------ TIER TWO ------------------
data.techs.t_storage3 = {
	name = "Hybrid Power",
	desc = "Storage upgrades",
	texture = "Main/textures/icons/components/powercell.png",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 2, human_research = 1, virus_research = 1 }, 1500),
	progress_count = 20,
	require_tech = { "t_storage2", },
	unlocks = {
		'f_building2x1d', -- 1M + storage
		'c_large_storage',
		'c_modulevisibility_l',
		'c_power_cell',
		'c_viral_pulse',
		'c_large_power_transmitter',
	},
	category = "Hybrid",
}

data.techs.t_robotics3 = {
	name = "Ultra-Tech Framework",
	texture = "Main/textures/tech/robots/robot_robotics_03_1.png",
	desc = "Unlocks quantum level robotics technologies, units and buildings",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 3, fused_electrodes = 3 }, 1500),
	progress_count = 20,
	require_tech = { "t_structures5" }, --{ "t_robotics2" },
	category = "Hybrid",
	unlocks = {
		'f_bot_1m_c', -- 1M
		'f_building3x2a', -- 1L3M
		'f_building2x2c', -- 2M1L
		'c_laser_turret',
		'rainbow_research',
	},
}

-- data.techs.t_defense3 = {
-- 	name = "Defense Systems",
-- 	texture = "Main/textures/icons/components/component_laserturret_01_m.png",
-- 	desc = "Protect yourself",
-- 	uplink_recipe = CreateUplinkRecipe({ robot_research = 3, fused_electrodes = 2 }, 800),
-- 	progress_count = 10,
-- 	require_tech = { "t_power5" },
-- 	category = "Hybrid",
-- 	unlocks = {
-- 		'c_laser_turret',
-- 	},
-- }

data.techs.t_power21 = {
	name = "Advanced Hybridization",
	texture = "Main/textures/icons/components/Component_Range5Transporter_01_L.png",
	desc = "Unlocks simple power options",
	uplink_recipe = CreateUplinkRecipe({ rainbow_research = 2, anomaly_heart = 1 }, 1500),
	progress_count = 40,
	require_tech = { "t_particle_forge" },
	category = "Hybrid",
	unlocks = {
		'c_phase_transporter5',
		'c_plasma_cannon',
	}
}

------------------  TIER THREE  ------------------

data.techs.t_particle_forge = {
	name = "Anomaly Transformation",
	texture = "Main/textures/tech/particle_forge.png",
	desc = "An advanced particle fabricator",
	uplink_recipe = CreateUplinkRecipe({ rainbow_research = 1, unstable_matter = 1 }, 1500),
	progress_count = 20,
	require_tech = { "t_power5" },
	unlocks = {
		'f_building_pf',
		'c_moduleefficiency',
		'c_monolith_lightning_comp',
	},
	category = "Hybrid",
	wonder = true,
}

data.techs.t_robotics4 = {
	name = "Quantum Robotics",
	texture = "Main/textures/tech/robots/tech_icon_13.png",
	desc = "Unlocks the next generation level of robotics technologies and units",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 5, uframe = 5 }, 1500),
	progress_count = 20,
	require_tech = { "t_robotics3" }, --{ "t_robotics2" },
	category = "Hybrid",
	unlocks = {
		'f_bot_1s_as', 'f_bot_2m_as',
		'f_bot_1s_adw', -- Engineer
		'c_adv_miner',
		'datakey_robot',
		'rainbowframe',
	},
}

data.techs.t_fusion_generator = {
	name = "Fusion Power",
	texture = "Main/textures/tech/fusion_generator.png",
	desc = "An advanced particle power generator",
	uplink_recipe = CreateUplinkRecipe({ rainbow_research = 5 }, 2000),
	progress_count = 20,
	slots = { anomaly = 8 },
	require_tech = { "t_storage3" },
	unlocks = { 'f_building_fg',
	},  -- 'c_hybrid_beam_cannon'
	category = "Hybrid",
	wonder = true,
}

------------------  ROBOT THIRD THREE FINAL TECH ------------------

--[[
data.techs.t_the_simulator = {
	name = "The Simulator",
	texture = "Main/textures/icons/frame/3x3_SIM.png",
	desc = "The Simulator",
	uplink_recipe = CreateUplinkRecipe({ rainbow_research = 20 }, 2000),
	progress_count = 40,
	require_tech = { "t_robotics4" },
	unlocks = {
		'f_building_simulator',
		'datakey_robot'
		-- 'x_freeplay_robot_12',  -- 'c_robot_ac',
	},
	category = "Hybrid",
	wonder = true,
}
--]]

--[[
data.techs.t_storage6 = {
	name = "Storage Logistics",
	desc = "Logistics upgrade",
	texture = "Main/textures/tech/robots/robot_logistics_05_1.png",
	uplink_recipe = CreateUplinkRecipe({ robot_research = 3, refined_crystal = 2, fused_electrodes = 2 }, 500),
	progress_count = 10,
	require_tech = { "t_storage2", },
	unlocks = { },
	category = "Hybrid",
}
--]]

