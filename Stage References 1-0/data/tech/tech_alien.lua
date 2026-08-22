------ General ------

-- 1 DISCOVERY
-- 2 RESEARCH
-- 3

-- TIER 1 : Alien-Bot Basics:

-------------------  ALIEN-BOT HYBRID TREE  -----------------------
--------------------------------------------------------
------------------  TIER ONE  ------------------

--NEW: description change

data.techs.t_alien_tech_basic = {
	name = "Alien Technology", -- recovered database etc.
	texture = "Main/skin/Icons/Special/Technologies/Aliens.png",
	unlocks = {
		'metalore', 'crystal', 'metalbar', 'metalplate', 'silica', 'silicon', 'cable',
		'obsidian', 'blight_crystal', 'anomaly_particle', 'anomaly_cluster', 'anomaly_heart', 'obsidian_brick', 'shaped_obsidian', 'alien_artifact', 'energized_artifact',
		'f_alien_worker', 'f_alien_researcher',

		-- starting values
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

------------------  TIER ONE  ------------------

data.techs.t_phase = {
	order = 1,
	name = "Phasing",
	texture = "Main/textures/tech/alien/alien_obsidian_01_1.png",
	desc = "Bridging short distances by creating small folds in space",
	uplink_recipe = CreateUplinkRecipe({ phase_leaf = 1, anomaly_cluster = 1 }, 600),
	progress_count = 20,
	require_tech = { robot = "t_robots_alien_research", human = "t_robots_alien_research", alien = "t_alien_command3" },
	unlocks = { 'cpu', 'phase_leaf', 'f_phase_plant', 'c_portable_teleporter' },
	category = "Alien",
}

data.techs.t_energy_form = {
	order = 2,
	name = "Energy Form",
	texture = "Main/textures/tech/alien/alien_energy_01_1.png",
	desc = "Bringing anomaly particles into clusters that generate coherent response patterns",
	uplink_recipe = CreateUplinkRecipe({ anomaly_particle = 1 }, 600),
	progress_count = 40,
	require_tech = { robot = "t_robots_alien_research", human = "t_robots_alien_research", alien = "t_alien_command3" },
	unlocks = { 'alien_datacube', 'anomaly_cluster', 'c_alien_stealth', 'c_alien_factory_robots', }, -- 'c_alien_factory'
	category = "Alien",
}

data.techs.t_energy_folding = {
	order = 3,
	name = "Energy Folding",
	texture = "Main/textures/tech/alien/alien_control_01_1.png",
	desc = "Allows molding of obsidian using alien technologies",
	uplink_recipe = CreateUplinkRecipe({ power_petal = 1, anomaly_cluster = 1 }, 1200),
	progress_count = 10,
	require_tech = { robot = "t_robots_alien_research", human = "t_robots_alien_research", alien = "t_alien_command3" },
	unlocks = { 'power_petal', 'f_damage_plant', 'c_alien_key', },
	category = "Alien",
}

------------------  TIER TWO  ------------------

data.techs.t_teleportation = {
	name = "Teleportation",
	texture = "Main/textures/tech/alien/alien_control_02_1.png",
	desc = "Ability to send data to any point in the simulation",
	uplink_recipe = CreateUplinkRecipe({ alien_datacube = 4, cpu = 1 }, 3000), -- 200
	progress_count = 10,
	require_tech = { "t_phase" },
	unlocks = {
		'c_unit_teleport',
		'c_turret_phaseflower'
	},
	category = "Alien",
}

data.techs.t_anomaly_heart = {
	name = "Anomaly Heart",
	texture = "Main/textures/tech/alien/alien_energy_03_1.png",
	desc = "The merging of blight plasma matrixes and anomaly clusters, creating something seemingly with a will of its own",
	uplink_recipe = CreateUplinkRecipe({ obsidian_brick = 2, alien_datacube = 2 }, 1000),
	progress_count = 50,
	require_tech = { "t_energy_form" },
	unlocks = {
		'anomaly_heart',
		'alien_research',
		'f_hybrid_worker',
		'f_hybrid_alien_soldier',
		'c_reforming_pool_comp',
	},
	category = "Alien",
}

data.techs.t_obsidian_maniputalion = {
	name = "Obsidian Manipulation",
	texture = "Main/textures/tech/alien/alien_obsidian_02_1.png",
	desc = "Obsidian structures can be imprinted with a kind of neural response network",
	uplink_recipe = CreateUplinkRecipe({ unstable_matter = 1, alien_datacube = 1 }, 1000),
	require_tech = { "t_energy_folding" },
	progress_count = 50,
	unlocks = {
		'alien_artifact', 'c_turret_powerflower', 'shaped_obsidian',
		'v_signal_a', 'v_signal_b', 'v_signal_c', 'v_signal_d', 'v_signal_e',
	},
	category = "Alien",
}

------------------  TIER THREE  ------------------

data.techs.t_resim_tech = {
	name = "Reformation",
	texture = "Main/textures/tech/alien/alien_control_03_1.png",
	desc = "Breaks down items into its base simulation elements",
	uplink_recipe = CreateUplinkRecipe({ alien_research = 2 }, 1000),
	progress_count = 40,
	unlocks = {
		'c_alien_sc',
		'c_alien_factory_comp',
	},
	require_tech = { "t_teleportation" },
	category = "Alien",
}

data.techs.t_energy_manipulation = {
	name = "Energy Manipulation",
	texture = "Main/textures/tech/alien/alien_energy_02_1.png",
	desc = "Obsidian structures can directly receive and respond to anomaly heart signaling and commands",
	uplink_recipe = CreateUplinkRecipe({ alien_research = 3 }, 1000), -- alien_datacube
	progress_count = 30,
	require_tech = { "t_anomaly_heart", },
	unlocks = {
		'energized_artifact',
		'c_hybrid_beam_cannon',
		'c_adv_alien_factory',
		'c_plasma_bloom_comp',
		'c_alien_powergenerator_comp',
	},
	category = "Alien"
}

data.techs.t_exoskeletons = {
	name = "Exoskeletons",
	texture = "Main/textures/tech/alien/alien_obsidian_03_1.png",
	desc = "Manipulation of obsidian into exoskeleton formations",
	uplink_recipe = CreateUplinkRecipe({ alien_research = 2 }, 1000), -- alien_research
	progress_count = 40,
	unlocks = {
		'f_alien_smallframe',
		'c_particle_ripper',
		'c_sentinel_lance_comp',
	},  -- 'f_alienbot',
	require_tech = { "t_obsidian_maniputalion" },
	category = "Alien",
}

-- data.techs.t_exoskeletons = {
-- 	name = "Exoskeletons",
-- 	texture = "Main/textures/tech/alien/alien_obsidian_03_1.png",
-- 	desc = "Manipulation of obsidian into exoskeleton formations",
-- 	uplink_recipe = CreateUplinkRecipe({ rainbow_research = 1 }, 1000), -- alien_research
-- 	progress_count = 40,
-- 	unlocks = { 'f_alien_worker', 'f_hybrid_alien_soldier' },  -- 'f_alienbot'
-- 	require_tech = { "t_obsidian_maniputalion" },
-- 	category = "Alien",
-- }

------------------  ALIEN-BOT FINAL TECH  ------------------

data.techs.t_anomaly_technology = {
	name = "Anomaly Technology",
	texture = "Main/textures/icons/components/resimulator_alien.png",
	desc = "Unlocking the path to the full potential of Alien technology",
	uplink_recipe = CreateUplinkRecipe({ alien_research = 3 }, 1000), -- 100
	progress_count = 40,
	require_tech = { "t_energy_manipulation" },
	unlocks = {
		'c_alien_ac',
		'datakey_alien',
		'c_time_egg_transference_comp',
		'c_alien_research_comp',
		'c_sensor_spike_comp',
		-- 'alien_ai_core',
	},
	category = "Alien",
}

------------------- ENERGETICS ----------------------

-------------------  PURE ALIEN TREE  ------------------
--------------------------------------------------------

-- 1 Industry and Tech
-- 2 Command and Communication
-- 3 Military and Defense

--------------------------------------------------------
-- TIER 1

data.techs.t_alien_producer = {
	order = 1, -- 1 Industry and Tech - Morphism - Metamorphics
	-- name = "Paragenic Crucible",  --Paragenesis
	name = "Plasma Wellspring",  -- Energetics 1  -- The Wellspring
	desc = "Alien Extractions and Formation Methods",
	texture = "Main/textures/tech/alien/energetics/energetics_industry_1.png",
	uplink_recipe = CreateUplinkRecipe({ alien_artifact = 1, blight_plasma = 1 }, 800), -- 500
	progress_count = 20,
	require_tech = { robot = "t_anomaly_technology",  human = "t_anomaly_technology", alien = "t_alien_tech_basic" },
	--require_tech = { "t_energy_manipulation" },
	unlocks = {
		'f_alien_extractor',
		'f_alien_miner',
		'f_alien_transport',
		'empty_artifact_research',
		-- 'f_alien_worker',
		-- 'f_alien_soldier',
		'f_alien_powergenerator',
	},
	category = "Energetics",
}

data.techs.t_alien_feeder = {
	order = 2, -- Command and Communication
	name = "The Nexasphere",  -- The Noosphere
	desc = "Alien core communication mindscape",
	texture = "Main/textures/tech/alien/energetics/energetics_comm_1.png",
	-- desc = "Food Generator",
	uplink_recipe = CreateUplinkRecipe({ alien_artifact = 3 }, 2000), -- 500
	progress_count = 10,
	require_tech = { robot = "t_anomaly_technology", human = "t_anomaly_technology", alien = "t_alien_tech_basic" },
	--require_tech = { "t_energy_manipulation" },
	unlocks = {
		'f_alien_researcher',
		'f_alien_feeder',
		'f_alien_worker',
		'f_alien_pylon',
		'plasma_crystal',
	},
	category = "Energetics",
}

data.techs.t_alien_extractor = {
	order = 3, -- 3 Military and Defense
	name = "Paragenic Crucible",  --Paragenesis
	-- name = "Plasma Wellspring",  -- Energetics 1  -- The Wellspring
	desc = "Alien power and units formation",
	-- 	desc = "Alien Extraction Facility",
	texture = "Main/textures/tech/alien/energetics/energetics_1.png",
	uplink_recipe = CreateUplinkRecipe({ alien_artifact = 1, plasma_crystal = 2 }, 800), -- 500
	progress_count = 20,
	require_tech = { robot = "t_anomaly_technology", human = "t_anomaly_technology", alien = "t_alien_tech_basic" },
	--require_tech = { "t_energy_manipulation" },
	unlocks = {
		-- 'f_alien_extractor',
		'f_alien_producer',
		'f_alien_scout',
		'f_alien_pincer',
	},
	category = "Energetics",
}

--------------------------------------------------------
-- TIER 2

data.techs.t_alien_production2 = {
	name = "Transmorphic Channeling",  -- transmorphism
	desc = "Alien material manipulation",
	texture = "Main/textures/tech/alien/energetics/energetics_industry_2.png",
	uplink_recipe = CreateUplinkRecipe({ empty_artifact_research = 2, anomaly_cluster = 1 }, 1200), -- 600
	progress_count = 20,
	require_tech = { "t_alien_producer" },
	unlocks = {
		'f_alien_storage',
		'f_alien_reformingpool',
		'alien_artifact_research',
		'crystalized_obsidian',
		'c_anomaly_lattice',
	},
	category = "Energetics",
}

data.techs.t_alien_command2 = {
	name = "The Nexus Web", --Nexalink  -- Web of Whispers
	desc = "Alien quantum wave and vibration transference",
	texture = "Main/textures/tech/alien/energetics/energetics_comm_2.png",
	uplink_recipe = CreateUplinkRecipe({ empty_artifact_research = 2 }, 750), -- 600
	progress_count = 40,
	require_tech = { "t_alien_feeder" },
	unlocks = {
		'f_alien_sensortower',
		'f_alien_teleporter',
		'f_alien_socketbuilding',
		'f_alien_observer',
	},
	category = "Energetics",
}

data.techs.t_alien_energetics2 = {
	name = "Ion Forge",
	desc = "Alien power focus and amplification.",
	texture = "Main/textures/tech/alien/energetics/energetics_2.png",
	uplink_recipe = CreateUplinkRecipe({ empty_artifact_research = 2, plasma_crystal = 2 }, 1000), -- 600
	progress_count = 20,
	require_tech = { "t_alien_extractor" },
	unlocks = {
		'f_alien_soldier',
		'f_alien_turret',
		'f_alien_tankframe',
		'c_alien_ion_lance',
	},
	category = "Energetics",
}


--------------------------------------------------------
-- TIER 3

data.techs.t_alien_production3 = {
	name = "Metamorphism",
	desc = "Alien warping of materials, time, and space",
	texture = "Main/textures/tech/alien/energetics/energetics_industry_3.png",
	uplink_recipe = CreateUplinkRecipe({ alien_artifact_research = 2, crystalized_obsidian = 2 }, 1500), -- 600
	progress_count = 20,
	require_tech = { "t_alien_production2" },
	unlocks = {
		'f_alien_time_egg',
		'f_alien_probe',
	},
	category = "Energetics",
}

data.techs.t_alien_command3 = {
	name = "Vortex of Voices",  -- the overmind
	desc = "Alien Overmind of expanded consciousness and communication",
	texture = "Main/textures/tech/alien/energetics/energetics_comm_3.png",
	uplink_recipe = CreateUplinkRecipe({ alien_artifact_research = 2, crystalized_obsidian = 1 }, 1200), -- 600
	progress_count = 30,
	require_tech = { "t_alien_command2" },
	unlocks = {
		'f_alien_heart_shard',
		'f_alien_console',
	},
	category = "Energetics",
}

data.techs.t_alien_energetics3 = {
	name = "Aurora Storm",
	desc = "Alien power focus and amplification",
	texture = "Main/textures/tech/alien/energetics/energetics_3.png",
	uplink_recipe = CreateUplinkRecipe({ crystalized_obsidian = 1, alien_artifact_research = 2 }, 1500), -- 600
	progress_count = 20,
	require_tech = { "t_alien_energetics2" },
	unlocks = {
		'f_alien_hvy_soldier',
		'f_alien_monolith',
	},
	category = "Energetics",
}
