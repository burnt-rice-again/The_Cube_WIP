------ General ------

-- 1 DISCOVERY

-- 2 RESEARCH

-- 3

-- TIER 1 : Human-Bot Basics:
data.techs.t_human_tech_basic = {
	name = "Human Technology", -- recovered database etc.
	texture = "Main/skin/Icons/Special/Technologies/Human.png",
	unlocks = {
		-- starting resources
		'laterite', 'aluminiumrod', 'aluminiumsheet', 'metalore', 'crystal', 'metalbar', 'metalplate', 'reinforced_plate', 'silica', 'silicon', 'concreteslab',
		'transformer', 'smallreactor', 'engine', 'crystal_powder', 'fuel_rod', 'c_micro_reactor', 'f_human_refinery', 'f_human_carrier', 'f_human_sciencelab',

		'x_tutorial', 'x_bugs',
		'v_color_red', 'v_color_green', 'v_color_blue', 'v_color_yellow', 'v_color_cyan', 'v_color_magenta', 'v_ally_faction',
		'v_color_black', 'v_color_brown', 'v_color_crimson', 'v_color_dark_grey', 'v_color_light_green', 'v_color_light_grey',
		'v_color_pink', 'v_color_white', 'v_color_pastel',
		'v_own_faction', 'v_enemy_faction', 'v_world_faction', 'v_bot', 'v_building', 'v_construction', 'v_droppeditem', 'v_resource', 'v_mineable',
		'v_alien_faction', 'v_solved', 'v_unsolved', 'v_can_loot', 'v_bug_faction', 'v_human_faction', 'v_robot_faction', 'v_blight', 'v_not_blight',
		'v_plateau', 'v_valley', 'v_in_powergrid', 'v_is_foundation', 'v_is_grounded', 'v_is_flying', 'v_is_flower', 'v_wall',

		-- states
		'v_damaged', 'v_infected', 'v_broken', 'v_unpowered', 'v_emergency', 'v_powereddown', 'v_moving', 'v_pathblocked', 'v_idle', 'v_setnum', 'v_maxrange',
	},
}

-------------------  HUMAN-BOT HYBRID TREE  -----------------------
-------------------------------------------------------------------

------------------  TIER ONE  ------------------

------ Logistics ------

data.techs.t_extractor = {
	order = 2,
	name = "Extraction",
	texture = "Main/textures/tech/extractor.png",
	desc = "Unlocks laser mineral extraction",
	uplink_recipe = CreateUplinkRecipe({ transformer = 1, }, 800),
	progress_count = 20,
	require_tech = { robot = "t_human_intel", human = "t_human_electronics", alien = "t_human_intel" },
	unlocks = { 'micropro', 'c_extractor', 'aluminiumsheet', 'aluminiumrod', 'human_datacube', 'f_human_foundation1' },
	category = "Human",
}

------ Production ------

data.techs.t_humanproduction = {
	order = 1,
	name = "Production",
	texture = "Main/textures/tech/deconstruction.png",
	desc = "Hybrid Human/Robot Technology for Human Production capability",
	uplink_recipe = CreateUplinkRecipe({ smallreactor = 1, }, 800),
	progress_count = 20,
	require_tech = { robot = "t_human_intel", human = "t_human_electronics", alien = "t_human_intel" },
	unlocks = { 'c_human_factory_robots', 'c_repairport', 'engine', 'datakey', 'c_twin_autocannons', },
	category = "Human",
}

data.techs.t_adv_drones = {
	order = 3,
	name = "Advanced Drones",
	texture = "Main/textures/tech/flight.png",
	desc = "Allows construction of drones and related facilities",
	uplink_recipe = CreateUplinkRecipe({ engine = 1,  }, 800),
	progress_count = 20,
	require_tech = { robot = "t_human_intel", human = "t_human_electronics", alien = "t_human_intel" },
	unlocks = { 'c_drone_launcher', 'f_drone_transfer_a2', 'f_drone_miner_a' },
	category = "Human",
}

------------------  TIER TWO  ------------------

data.techs.t_ldframe = {
	name = "Matrix Frames",
	texture = "Main/textures/tech/low_density_frames.png",
	desc = "Create frames that are strong but low-weight",
	uplink_recipe = CreateUplinkRecipe({ human_datacube = 1, transformer = 1 }, 1000),
	progress_count = 40,
	require_tech = { "t_extractor", },
	unlocks = {
		'ldframe',
		'c_radar',
		'microscope',
		'human_research',
		-- 'x_freeplay_human_02',
		-- 'x_freeplay_human_02_repair',
	},
	category = "Human",
}

-- Unlocks the Advanced Power category
data.techs.t_power_units = {
	name = "Power Units",
	texture = "Main/textures/tech/power_cells.png",
	desc = "Enables advanced power generation and storage applications",
	uplink_recipe = CreateUplinkRecipe({ human_datacube = 1,  smallreactor = 1 }, 1000),
	progress_count = 40,
	require_tech = { "t_humanproduction", },
	unlocks = { 'c_power_unit', 'c_missile_turret', 'c_large_battery', 'c_large_power_relay' },
	category = "Human",
}


data.techs.t_shuttles = {
	name = "Flyers",
	texture = "Main/textures/icons/frame/flyer_medium.png",
	desc = "Allows construction of long distance flyers and related facilities",
	uplink_recipe = CreateUplinkRecipe({ human_datacube = 1,  engine = 1, ldframe = 1 }, 1000),
	progress_count = 40,
	require_tech = { "t_adv_drones" },
	unlocks = { 'c_landing_pad', 'f_flyer_m', 'f_flyer_bot', },

	category = "Human",
}

------------------  TIER THREE  ------------------

data.techs.t_hacking_tool = {
	name = "Hacking",
	texture = "Main/textures/tech/hacking_tool.png",
	desc = "Allows Hacking of digital entities",
	uplink_recipe = CreateUplinkRecipe({ smallreactor = 2, human_research = 2, }, 3000),
	progress_count = 40,
	require_tech = { "t_power_units" },
	unlocks = { 'c_hacking_tool', 'datakey_human' },
	category = "Human",
}

data.techs.t_power_cores = {
	name = "Human Science",
	texture = "Main/textures/icons/components/component_ScienceAnalyzer_01_l.png",
	desc = "Enables advanced power generation and storage applications",
	uplink_recipe = CreateUplinkRecipe({ microscope = 1, human_research = 3, }, 2000),
	progress_count = 30,
	require_tech = { "t_ldframe" },
	unlocks = { 'c_human_science_analyzer_robots', 'c_anomaly_container_i', 'anomaly_particle', 'anomaly_cluster', 'c_railgun' },  -- 'c_power_core', 'c_power_unit',

	category = "Human",
}

data.techs.t_satellites = {
	name = "Satellites",
	texture = "Main/textures/icons/frame/satellite.png",
	desc = "Allows construction of satellites that can be launched into space",
	uplink_recipe = CreateUplinkRecipe({ human_research = 4, engine = 4, ldframe = 2 }, 3000),
	progress_count = 20,
	require_tech = { "t_shuttles" },
	unlocks = { 'f_amac', 'f_satellite' },
	category = "Human",
	wonder = true,
}

------------------  HUMAN-BOT HYBRID FINAL TECH THREE  ------------------

data.techs.t_human_technology = {
	name = "Human Technology",
	texture = "Main/textures/icons/components/resimulator_human.png",
	desc = "Unlocking the path to the full potential of Human technology",
	uplink_recipe = CreateUplinkRecipe({human_research = 3 }, 2500), -- empty_databank = 5, microscope = 5,
	progress_count = 40,
	require_tech = { "t_power_cores" },
	unlocks = {
		--'empty_databank',
		--'human_databank',
		'concreteslab',
		'c_human_ac',
		-- 'c_micro_reactor',
		-- 'gearbox',
		-- 'c_power_core', 'c_power_unit',
	},
	category = "Human",
}

-------------------------------

--[[
data.techs.t_signals4 = {
	name = "Long Range Signals",
	texture = "Main/textures/tech/tech_comms.png",
	desc = "Unlocks long range signal reader",
	uplink_recipe = CreateUplinkRecipe({ human_datacube = 1, }, 300),
	progress_count = 30,
	require_tech = { "t_human_intel" }, --{ "t_signals2" },
	category = "Human",
	unlocks = { 'c_radar', },
}
--]]

--[[
data.techs.t_power4 = {
	name = "Advanced Power",
	texture = "Main/textures/tech/robots/tech_power.png",
	desc = "Unlocks advanced power options",
	uplink_recipe = CreateUplinkRecipe({ human_databank = 4, smallreactor = 1 }, 800),
	progress_count = 20,
	require_tech = { "t_missile_turret" },
	category = "Human",
	unlocks = { 'c_large_power_transmitter' },
}
--]]

--[[
data.techs.t_missile_turret = {
	name = "Missile Turret",
	texture = "Main/textures/tech/missile_turret.png",
	desc = "Ability to construct higher-power turrets",
	uplink_recipe = CreateUplinkRecipe({ human_research = 2, }, 400),
	progress_count = 20,
	require_tech = { "t_signals4" },
	unlocks = { 'c_missile_turret' },
	category = "Human",
}
--]]

-------------------  PURE HUMAN TREE  -----------------------
-------------------------------------------------------------

-- 1 Industry and Tech
-- 2 Command and Communication
-- 3 Military and Defense

data.techs.t_human_industry1 = {
	order = 2, -- 1 Industry and Tech
	name = "Mass Storage",
	desc = "Storage systems with maximized resource capacity, supporting large-scale expansion.",
	texture = "Main/textures/tech/human/human_industry_1.png",
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1 }, 300),
	progress_count = 50,
	require_tech = { robot = "t_human_technology", human = "t_human_tech_basic", alien = "t_human_technology" },
	unlocks = {
		'steelblock',
		'fuel_rod',
		-- 'enriched_fuel_rod',
		--'silicon',
		'f_human_warehouse',
		'f_human_adv_miner',
		'f_human_refinery',
		'f_human_lighttank',
		'c_light_cannon',
		-- 'transformer',
		-- 'f_human_refinery',
		'f_human_foundation',
		-- 'f_human_miner',
	},
	category = "Humanity",
}

data.techs.t_human_comm1 = {
	order = 1, -- 2 Command and Communication
	name = "Human Communications",
	desc = "Communication technologies for enhanced information flow and storing critical data.",
	texture = "Main/textures/tech/human/human_comm_1.png",
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1 }, 300),
	progress_count = 50,
	require_tech = { robot = "t_human_technology", human = "t_human_tech_basic", alien = "t_human_technology" },
	unlocks = {
		--'f_human_miner',
		--'microscope',
		'empty_databank',
		'f_human_sciencelab',
		-- 'c_human_science', -- check
		'f_human_foundation_basic',
		'f_human_foundation2',
		'f_human_foundation3',
		'f_human_foundation4',
	},
	category = "Humanity",
}

data.techs.t_human_defense1 = {
	order = 3, -- 3 Military and Defense
	name = "Human Infantry",
	desc = "Specialized training in mechanized operations for combat in hostile environments.",
	texture = "Main/textures/tech/human/human_defense_1.png",
	uplink_recipe = CreateUplinkRecipe({ concreteslab = 1 }, 300),
	progress_count = 50,
	require_tech = { robot = "t_human_technology", human = "t_human_tech_basic", alien = "t_human_technology" },
	unlocks = {
		'gearbox',
		-- 'transformer',
		'f_human_barracks',
		'f_human_infantrymech', -- 'ldframe',
		'f_human_bunker',
		'f_human_foundation_adv',
	},
	category = "Humanity",
}

-------------------------------------------

-- t_human_commandcenter
-- t_human_refinery
-- t_human_powerplant

-------------------------------------------

data.techs.t_human_industry2 = {
	-- 1 Industry and Tech
	name = "Human Production",
	desc = "Expansion of production capabilities for advanced material and component production.",
	texture = "Main/textures/tech/human/human_industry_2.png",
	uplink_recipe = CreateUplinkRecipe({ steelblock = 2 }, 600),
	progress_count = 30,
	require_tech = { "t_human_industry1" },
	unlocks = {
		'ceramictiles',
		'polymer',
		'f_human_factory',
		'f_human_transport',
		'c_micro_reactor',
	},
	category = "Humanity",
}

data.techs.t_human_comm2 = {
	-- 2 Command and Communication
	name = "Human Data",
	desc = "Comprehensive data management with finely tuned scanning tech and superior AI supported analysis capabilities.",
	texture = "Main/textures/tech/human/human_comm_2.png",
	uplink_recipe = CreateUplinkRecipe({ empty_databank = 1 }, 600),
	progress_count = 40,
	require_tech = { "t_human_comm1" },
	unlocks = {
		'human_databank',
		'f_human_communication',
		'f_human_datacomplex',
		'f_human_AI_explorer',
		'f_human_foundation6',
		'f_human_foundation7',
	},
	category = "Humanity",
	on_unlock = function(faction) faction.has_blight_shield = true end,
}

data.techs.t_human_defense2 = {
	-- 3 Military and Defense
	name = "Human Armour",
	desc = "Innovation in armored vehicle design, expanding combat options.",
	texture = "Main/textures/tech/human/human_defense_2.png",
	uplink_recipe = CreateUplinkRecipe({ empty_databank = 1 }, 600),
	progress_count = 20,
	require_tech = { "t_human_defense1" },
	unlocks = {
		'f_human_vehiclefactory',
		'f_human_tankframe',
		'c_human_tank_turret',
		'f_human_rover',
		'f_human_carrier',
		'f_heavy_bunker',
	},
	category = "Humanity",
}

-------------------------------------------
------------------------------------------

-- t_human_spaceport
-- t_human_factory
-- t_human_science

------------------------------------------


data.techs.t_human_industry3 = {
	-- 1 Industry and Tech
	name = "Human Industrial",
	desc = "Heavy duty industrial processes allowing large scale production capability.",
	texture = "Main/textures/tech/human/human_industry_3.png",
	uplink_recipe = CreateUplinkRecipe({ human_databank = 1, polymer = 3 }, 600),
	progress_count = 30,
	require_tech = { "t_human_industry2" },
	unlocks = {
		-- 'polymer',
		'f_human_commandcenter',
		'f_human_lander',
	},
	category = "Humanity",
}

data.techs.t_human_comm3 = {
	-- 2 Command and Communication
	name = "Human Aerospace",
	desc = "Advancements in materials, engineering, and production allow deployment of atmospheric and space-faring vehicles.",
	texture = "Main/textures/tech/human/human_comm_3.png",
	uplink_recipe = CreateUplinkRecipe({ human_databank = 1, polymer = 2 }, 750),
	progress_count = 40,
	require_tech = { "t_human_comm2" },
	unlocks = {
		-- 'engine',
		'f_human_spaceport',
		'f_human_flyer',
		'f_human_foundation5',
		'f_space_satellite'
	},
	category = "Humanity",
}

data.techs.t_human_defense3 = {
	-- 3 Military and Defense
	name = "Human Power",
	desc = "Breakthroughs in fusion technology integration support expanding grand-scale infrastructure.",
	texture = "Main/textures/tech/human/human_defense_3.png",
	uplink_recipe = CreateUplinkRecipe({ human_databank = 1, polymer = 2 }, 750),
	progress_count = 40,
	require_tech = { "t_human_defense2" },
	unlocks = {
		'f_human_powerplant',
		-- 'f_human_heavy_tankframe',
		'f_human_large_tankframe',
		'c_human_missilelauncher',
		'enriched_fuel_rod',
	},
	category = "Humanity",
}

data.techs.t_human_electronics = {
	-- 3 Military and Defense
	name = "Electronic Circuits",
	desc = "Leveraging electronic circuits enabling more component based technology",
	texture = "Main/textures/icons/items/circuit_board.png",
	uplink_recipe = CreateUplinkRecipe({ circuit_board = 1, }, 750),
	progress_count = 40,
	require_tech = { robot = "", human = "t_human_industry3", alien = "" },
	--require_tech = { "t_human_industry3" },
	unlocks = {
		'icchip', 'wire', 'cable',
	},
	race = "human",
	category = "Humanity",
}
------------------------------------------

-- t_human_communication
-- t_human_barracks
-- t_human_warehouse

------------------------------------------

--[[
data.techs.t_human_ultimate = {
	-- 1 Industry and Tech
	name = "Human Apex",
	texture = "Main/textures/tech/human/human_apex.png",
	desc = "Human Apex",
	uplink_recipe = CreateUplinkRecipe({ human_databank = 5, polymer = 20 }, 200),
	progress_count = 10,
	require_tech = { "t_human_industry3" },
	unlocks = {
		-- 'f_human_commandcenter',
		-- 'f_human_lander',
	},
	category = "Humanity",
}
]]--
