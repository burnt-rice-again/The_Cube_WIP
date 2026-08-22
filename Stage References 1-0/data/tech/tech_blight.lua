------ General ------

-- 1 DISCOVERY

-- 2 RESEARCH

-- 3
------ "t_blight_research" required to Research T! Blight Techs


-- TIER 1 : Blight Resource
-- TIER 2 : Blight Magnifiy
-- TIER 3 : Blight Conversion

------------------  TIER ONE  ------------------

data.techs.t_blight_shield = {
	order = 1,
	name = "Blight Shield",
	texture = "Main/textures/tech/blight/blight_field_01_1.png",
	desc = "Allows units to enter the blight",
	uplink_recipe = CreateUplinkRecipe({ blight_plasma = 1, }, 700),
	progress_count = 30,
	require_tech = { "t_blight_research" },
	unlocks = { 'c_blight_shield', 'c_blight_container_m', },
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

data.techs.t_blight_plasma = {
	order = 2,
	name = "Plasma Concentration",
	texture = "Main/textures/tech/blight/blight_control_01_1.png",
	desc = "Concentrated plasma allowing for constructing plasma weapons",
	uplink_recipe = CreateUplinkRecipe({ blight_plasma = 3, blight_extraction = 2 }, 500),
	progress_count = 20,
	require_tech = { "t_blight_research" },
	unlocks = { 'c_portable_turret_red', 'blight_datacube', 'f_wall_bli' },
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

data.techs.t_blight_visibility = {
	order = 3,
	name = "Blight Visibility",
	texture = "Main/textures/tech/blight/blight_terra_01_1.png",
	desc = "Allows Visibility into the Blight",
	uplink_recipe = CreateUplinkRecipe({ blight_plasma = 1, blight_extraction = 1 }, 700),
	progress_count = 40,
	require_tech = { "t_blight_research" },
	unlocks = { 'obsidian', },
	category = "Blight",
	on_unlock = function(faction)
		faction.extra_data.blight_fog = 1
		faction:RunUI("OnFactionUpdateBlightfog", faction)
		StabilityAdd(faction, "research_blight")
	end,
}

------------------  TIER TWO  ------------------

data.techs.t_blight_protection = {
	name = "Blight Stability",
	texture = "Main/textures/tech/blight/blight_field_03_1.png",
	desc = "Blight mechanics for creating System Stability. Allows units to enter or build within the blight without any adverse effects.",
	unlocks = { }, --'c_blight_magnifier' },
	uplink_recipe = CreateUplinkRecipe({ blight_datacube = 1, obsidian = 1, }, 1000),
	progress_count = 40,
	require_tech = { "t_blight_visibility" },  --"t_obsidian",
	category = "Blight",
	on_unlock = function(faction) faction.has_blight_shield = true StabilityAdd(faction, "research_blight") end,
}

data.techs.t_blight_magnifier = {
	name = "Conversion",
	desc = "Blight mechanics for conversion of System Resources",
	texture = "Main/textures/tech/blight/blight_control_02_1.png",
	uplink_recipe = CreateUplinkRecipe({ blight_datacube = 4, }, 1000),
	progress_count = 20,
	require_tech = { "t_blight_plasma", },
	unlocks = { 'c_blight_converter', 'blight_research', 'c_plasma_turret', },
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

data.techs.t_blight_power = {
	name = "Blight Power",
	texture = "Main/textures/tech/blight/blight_field_02_1.png",
	desc = "Enables advanced power generation and storage applications",
	uplink_recipe = CreateUplinkRecipe({ blight_datacube = 4, blight_extraction = 4, }, 200),
	progress_count = 10,
	require_tech = { "t_blight_shield" },
	unlocks = { 'c_blight_power', 'c_blightcrystal_power', },
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

------------------  TIER THREE  ------------------
data.techs.t_grass_terraformer = {
	name = "Basic Terraformer",
	texture = "Main/textures/tech/blight/blight_terra_03_1.png",
	desc = "Reversing the effects of Blight on the landscape",
	uplink_recipe = CreateUplinkRecipe({ blight_research = 2, laterite = 4, obsidian = 4, }, 1500),
	progress_count = 20,
	require_tech = { "t_blight_protection" },
	unlocks = { 'c_terraformer' },
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

data.techs.t_blight_conversion = {
	texture = "Main/textures/tech/blight/blight_control_03_1.png",
	name = "Magnification",
	desc = "Blight mechanics for magnification of System Resources",
	uplink_recipe = CreateUplinkRecipe({ blight_crystal = 5, blight_research = 4, }, 2000),
	progress_count = 20,
	require_tech = { "t_blight_magnifier" },
	unlocks = {
		'c_blight_magnifier',
		'datakey_blight',
		'c_blight_ac',
	},
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

data.techs.t_blight_terraformer = {
	name = "Blight Terraformer",
	texture = "Main/textures/tech/blight/blight_terra_02_1.png",
	desc = "Blight mechanics for imprinting Blight on the landscape",
	unlocks = { 'c_blight_terraformer', },
	uplink_recipe = CreateUplinkRecipe({ blight_research = 2, blight_extraction = 5, }, 1500),
	progress_count = 20,
	require_tech = { "t_blight_power" },
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}

--[[
------------------  BLIGHT FINAL TECH  ------------------
data.techs.t_blight_control = {
	name = "Simulation Control",
	texture = "Main/textures/tech/blight/blight_control_04_1.png",
	desc = "Blight mechanics for isolating and eliminating rogue architecture",
	uplink_recipe = CreateUplinkRecipe({ blight_research = 4, }, 3000),
	progress_count = 30,
	require_tech = { "t_blight_conversion" },
	unlocks = {
		--'c_blight_control',
		'datakey_blight',
		'c_blight_ac',
		-- 'x_freeplay_blight_04_h1',
		-- 'x_freeplay_blight_04_e1',
	},
	category = "Blight",
	on_unlock = function(faction) StabilityAdd(faction, "research_blight") end,
}
]]--
