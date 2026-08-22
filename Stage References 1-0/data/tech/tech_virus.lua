
------ General ------

-- 1 DISCOVERY
-- Finding Virus DATACUBE unlocks the Virus category:    t_robotics_virus_discovery
-- unlocks:  Virus Datacube /  Virus Protection /  Virus cure?? / Virus Container / infected_circuit_board

-- 2 RESEARCH
-- Researching VIRUS Research Unlocks the Virus category:    t_robots_virus
-- unlocks:  Virus Research Data Matrix

-- 3
------ "t_robots_virus" required to Research T! Virus Techs

-- TIER 1 : Virus Basics:          / CURE / BUGS (recyling)
-- TIER 2 : Virus Disruption:
-- TIER 3 : Virus Disruption:

------------------  TIER ONE  ------------------

data.techs.t_robots_virus_cryto = {
	order = 1,
	name = "Virus Crypto",
	desc = "Tools for using the virus in a disruptive way",
	texture = "Main/textures/tech/virus/virus_offense_01_1.png",
	uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 1 }, 800),
	progress_count = 20,
	unlocks = { 'c_virus_bitlock', 'c_portable_turret_green' },
	require_tech = { "t_robots_virus" },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

data.techs.t_robots_virus_cure = {
	order = 2,
	name = "Virus Cure",
	desc = "A protective barrier that prevents the virus from infecting units and buildings in the surrounding area",
	texture = "Main/textures/tech/virus/virus_core_01_1.png",
	uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 2 }, 500),
	progress_count = 25,
	unlocks = { 'c_virus_cure', },
	require_tech = { "t_robots_virus" },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

-- VIRUS/BUGS Relationship
data.techs.t_robots_recycling = {
	order = 3,
	name = "Hive",
	desc = "Virus component for Bug production",
	texture = "Main/textures/tech/virus/virus_bugs_01_1.png",
	uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 1 }, 800),
	progress_count = 20,
	require_tech = { "t_robots_virus" },
	unlocks = { 'c_virus_decomposer', 'virus_research_data' },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

------------------  TIER TWO  ------------------

data.techs.t_robots_virus_vaccine = {
	name = "Virus Protection",
	desc = "Protection against the virus's direct negative effects. Your units and buildings can still carry and spread the virus but no longer suffer negative effects. Shields still destabilize from attacks.",
	texture = "Main/textures/tech/virus/virus_core_03_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research_data = 2 }, 800),
	progress_count = 25,
	require_tech = { "t_robots_virus_cure" },
	unlocks = {
		'virus_research',
		'c_virus_container_i',
		'virus_source_code',
		'f_wall_vir',
	},
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

data.techs.t_robots_virus_jamming = {
	name = "Virus Infection",
	desc = "Virus tools transmit Virus as a directed attack",
	texture = "Main/textures/tech/virus/virus_offense_02_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research_data = 1 }, 1000),
	progress_count = 20,
	unlocks = { 'c_virus_jamming' },
	require_tech = { "t_robots_virus_cryto" },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

data.techs.t_robots_virus_bugs = {
	name = "Virus Waveform", --	name = "Virus Bug Generation - WIP",
	desc = "Viral wave frequencies that destabilize and scramble matter, with blight and obsidian formations especially vulnerable.",
	texture = "Main/textures/tech/virus/virus_bugs_02_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research_data = 1 }, 1000),
	progress_count = 20,
	unlocks = {
		'c_virus_recycler',
		'c_virus_destabilizer',
		'obsidian_infected',
		'c_virus_converter',
	},
	require_tech = { "t_robots_recycling" },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

------------------  TIER THREE  ------------------

data.techs.t_robots_antivirus = {
	name = "Anti-Virus",
	desc = "Gain positive effects from the virus and bitlock effect",
	texture = "Main/textures/tech/virus/virus_core_02_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research = 3 }, 2000),
	progress_count = 30,
	unlocks = {
		'c_virus_ac',
		'datakey_virus',
		'c_virus_duplicator',
	},
	require_tech = { "t_robots_virus_vaccine" },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

data.techs.t_robots_virus_possession = {
	name = "Bug Possession",
	desc = "Bug overwriting of data technology",
	texture = "Main/textures/tech/virus/virus_bugs_03_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research = 4 }, 1500),
	progress_count = 20,
	unlocks = {
		'c_virus_possessor'
	},
	require_tech = { "t_robots_virus_bugs" },
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

data.techs.t_robots_virus_bug_attacks = {
	name = "Bug Attacks",
	desc = "Replication of Bug Attacks",
	texture = "Main/textures/tech/virus/virus_offense_03_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research = 4 }, 1500),
	progress_count = 20,
	require_tech = { "t_robots_virus_jamming" },
	unlocks = {
		'c_warp_bridge',
		'c_warp_anchor',
		'f_bug_hive_large',
		'f_gastarid1',
		'f_scaramar1',
		'f_scaramar2',
	},
	category = "Virus",
	on_unlock = function(faction) StabilityAdd(faction, "research_virus") end,
}

--[[
------------------  VIRUS FINAL TECH  ------------------
data.techs.t_robots_disable = {
	name = "Virus Wipe",
	desc = "Virus tools that completely integrate with virus technology",
	texture = "Main/textures/tech/virus/virus_core_04_1.png",
	uplink_recipe = CreateUplinkRecipe({ virus_research = 2, virus_source_code = 1 }, 3000),
	progress_count = 30,
	unlocks = {
		'c_virus_ac',
		'datakey_virus'
	},
	require_tech = { "t_robots_antivirus" },
	category = "Virus",
}
]]--
