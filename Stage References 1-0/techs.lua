data.tech_categories = {
	{
		name = "Virus",
		discovery_tech = "t_robotics_virus_discovery",
		initial_tech = "t_robots_virus",
		sub_categories = { "Virus" },
		texture = "Main/skin/Icons/Special/Technologies/Virus.png",
	},
	{
		name = "Human",
		discovery_tech = "t_robots_human_discovery",
		initial_tech = "t_human_intel",
		sub_categories = { "Human", "Humanity" },
		texture = "Main/skin/Icons/Special/Technologies/Human.png",
	},
	{
		name = "Robots",
		initial_tech = "t_robot_tech_basic",
		sub_categories = { "Basic", "Advanced", "Hybrid", "Simulator",
		},
		hidden_categories = { "Simulator" },
		is_shown = function(cat) local f = Game.GetLocalPlayerFaction() return f:IsUnlocked("x_elain_ending") or f:IsUnlocked("x_higgs_ending") end,
		--is_shown = function(cat) return true end,
		texture = "Main/skin/Icons/Special/Technologies/Robots.png",
		textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png",},
	},
	{
		name = "Alien",
		discovery_tech = "t_robots_alien_discovery",
		initial_tech = "t_robots_alien_research",
		sub_categories = { "Alien", "Energetics" },
		texture = "Main/skin/Icons/Special/Technologies/Aliens.png",
	},
	{
		name = "Blight",
		discovery_tech = "t_robots_blight_discovery",
		initial_tech = "t_blight_research",
		sub_categories = { "Blight" },
		texture = "Main/skin/Icons/Special/Technologies/Blight.png",
	},
}

data.tech_categories_race =
{
	["robot"] = data.tech_categories,
	["human"] = {
		data.tech_categories[1],
		{
			name = "Robots",
			initial_tech = "t_robots_ai",
			discovery_tech = "t_robots_discovery",
			sub_categories = { "Basic", "Advanced", },
			texture = "Main/skin/Icons/Special/Technologies/Robots.png",
			textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png",},
		},
		{
			name = "Human",
			initial_tech = "t_human_tech_basic",
			sub_categories = { "Humanity", "Human", "Hybrid", "Simulator" },
			hidden_categories = { "Simulator" },
			is_shown = function(cat) return Map.GetSave().the_simulator and Map.GetSave().the_simulator.is_placed or false end,
			texture = "Main/skin/Icons/Special/Technologies/Human.png",
		},
		data.tech_categories[4],
		data.tech_categories[5],
	},
	["alien"] = {
		data.tech_categories[1],
		data.tech_categories[2],
		{
			name = "Alien",
			initial_tech = "t_alien_tech_basic",
			sub_categories = { "Energetics", "Alien", "Hybrid", "Simulator" },
			hidden_categories = { "Simulator" },
			is_shown = function(cat) return Map.GetSave().the_simulator and Map.GetSave().the_simulator.is_placed or false end,
			texture = "Main/skin/Icons/Special/Technologies/Aliens.png",
		},
		{
			name = "Robots",
			initial_tech = "t_robots_ai",
			discovery_tech = "t_robots_discovery",
			sub_categories = { "Basic", "Advanced", },
			texture = "Main/skin/Icons/Special/Technologies/Robots.png",
			textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png",},
		},
		data.tech_categories[5],
	}
}

-- HUMAN
data.techs.t_robots_discovery = {
	name = "Robot Discovery",
	desc = "Technology derived from an advanced AI",
	texture = "Main/skin/Icons/Special/Technologies/Robots.png",
	-- unlocks = { "transformer", },
	unlocks = { "metalbar", "metalplate", },
	category = "Story",
	tooltip = function(w)
		return "Robot Discovery"
	end,
}

data.techs.t_robots_ai = {
	name = "Artificial Intelligence",
	texture = "Main/textures/icons/items/ai_core_PLAYER.png",
	desc = "An AI designed to advance technology",
	uplink_recipe = CreateUplinkRecipe({ circuit_board = 1 }, 1000),
	progress_count = 40,
	require_tech = { "t_robots_discovery" },
	unlocks = {
		-- starting resources
		"foundationplate", "c_miner",

		"f_building1x1d", -- 1S
		"f_building1x1f", -- 8 Storage
		"f_bot_1s_a",

		-- starting research
		"f_foundation", "c_deconstructor",
		"c_fabricator", "c_assembler", "c_uplink", "c_portable_turret", "c_integrated_behavior",

		"f_wall", "f_carrier_bot", "c_scout_radar", "f_building2x1g",
	},
	category = "Story",
}

data.techs.t_robots_human_discovery = {
	name = "Human Discovery",
	desc = "The technology from this race of humans seems scattered throughout this world, but finding and adapting it could expand our capabilities greatly.",
	texture = "Main/skin/Icons/Special/Technologies/Human.png",
	unlocks = { "human_datacube", },
	category = "Story",
	tooltip = function(w)
		local faction = Game.GetLocalPlayerFaction()
		local counters = faction.extra_data.counters
		if counters and counters.human_explorables_scanned and not faction:IsUnlocked("t_robots_human_discovery") then
			return "Human Discovery - Scan and search Human ruins"
		end
		return "Human Discovery"
	end,
}

data.techs.t_human_intel = {
	name = "Human Intel",
	texture = "Main/textures/tech/human_discovery.png",
	desc = "Research data used for Human Technology",
	uplink_recipe = CreateUplinkRecipe({ transformer = 1 }, 1000),
	progress_count = 40,
	require_tech = { "t_robots_human_discovery" },
	unlocks = { "laterite", "smallreactor", "blightbar", "reinforced_plate" },
	category = "Story",
}

-- Unlocks the Virus category
data.techs.t_robotics_virus_discovery = {
	name = "Virus Discovery",
	desc = "This virus seems to be a result of strange activity in the world. Its disruptive nature can provide opportunities for us if we can configure it for our own use.",
	texture = "Main/skin/Icons/Special/Technologies/Virus.png",
	category = "Story",
	unlocks = { "c_virus_protection", "infected_circuit_board", "blight_crystal", "bug_carapace", }, -- "c_virus_cure",
}

data.techs.t_robots_virus = {
	name = "Virus Research",
	desc = "?@!XXIkjksas!",
	texture = "Main/textures/tech/virus.png",
	uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 1 }, 1000),
	progress_count = 10,
	unlocks = { },
	require_tech = { "t_robotics_virus_discovery" },
	category = "Story",
}
---ALIENS

-- Unlocks the Alien category
data.techs.t_robots_alien_discovery = {
	name = "Alien Discovery",
	desc = "A strange alien race with highly advanced technology we can utilize",
	texture = "Main/skin/Icons/Special/Technologies/Aliens.png",
	unlocks = { "obsidian", "obsidian_brick" }, --, "x_aliens" -- "alien_artifact",
	category = "Story",
	tooltip = function(w)
		local faction = Game.GetLocalPlayerFaction()
		if faction:IsUnlocked("x_visited_console") and not faction:IsUnlocked("t_robots_alien_discovery") then
			return "Alien Discover - Solve a Console in the Blight"
		end
		return "Alien Discovery"
	end,
}

data.techs.t_robots_alien_research = {
	name = "Alien Technology",
	texture = "Main/textures/tech/alien_tech.png",
	desc = "Gain the ability to research alien technology",
	uplink_recipe = CreateUplinkRecipe({ obsidian_brick = 1 }, 500), -- energized_artifact
	progress_count = 60,
	require_tech  = { "t_robots_alien_discovery" },
	unlocks = { "c_anomaly_container_i", "c_autobase" }, -- "c_anomaly_extractor"
	category = "Story",
}

-------- BLIGHT
-- Unlocks the Blight category
data.update_mapping.t_robots_blight = "t_robots_blight_discovery"
data.techs.t_robots_blight_discovery = {
	name = "Blight Discovery",
	desc = "This blight appears to play a vital role in this planet's ecosystem, we need to understand it.",
	texture = "Main/skin/Icons/Special/Technologies/Blight.png",
	category = "Story",
	unlocks = { "c_blight_extractor", "c_blight_container_i", "blight_extraction", "blight_crystal", "blightbar" },
}

-- NEW: desciption added

data.techs.t_blight_research = {
	name = "Blight Research",
	desc = "Blight gas analysis can begin to unlock the mysterious nature of the blight",
	texture = "Main/textures/tech/blight.png",
	uplink_recipe = CreateUplinkRecipe({ blight_extraction = 5 }, 500),
	progress_count = 30,
	require_tech = { "t_robots_blight_discovery" },
	unlocks = { "blight_plasma", "c_blight_container_s", "blightbar", },
	category = "Story",
}

data.techs.t_simulator_robots = {
	order = 2,
	name = "The Simulator",
	desc = "Understanding of the Simulator enough to unlock stability.",
	texture = "Main/textures/icons/alien/alienbuilding_simulator.png",
	require_tech = { "t_robotics4" },--{ "t_particle_forge", "t_robotics4", "t_fusion_generator" },
	uplink_recipe = CreateUplinkRecipe({ rainbowframe = 1, rainbow_research = 1 }, 10000),
	unlocks = { "c_the_simulator", "datakey_rainbow" }, -- "c_the_simulator",
	progress_count = 50,
	category = "Simulator",
	on_unlock = function(faction) Map.GetSave().stability_locked = false end, -- anyone researching simulation tech re-unlocks the world stability
}

data.techs.t_human_faction_npc = {
	name = "Human Technology",
	texture = "Main/skin/Icons/Special/Technologies/Human.png",
	unlocks = {
		"laterite", "aluminiumrod", "aluminiumsheet", "metalore", "crystal", "metalbar", "metalplate", "reinforced_plate", "wire", "silica", "silicon", "concreteslab",
		"transformer", "smallreactor", "crystal_powder", "fuel_rod",
		"x_tutorial", "x_bugs",
		"v_color_red", "v_color_green", "v_color_blue", "v_color_yellow", "v_color_cyan", "v_color_magenta", "v_ally_faction",
		"v_own_faction", "v_enemy_faction", "v_world_faction", "v_bot", "v_building", "v_construction", "v_droppeditem", "v_resource", "v_damaged",
		"v_alien_faction", "v_solved", "v_unsolved", "v_can_loot",
		"v_damaged", "v_infected", "v_broken", "v_unpowered", "v_emergency", "v_powereddown", "v_moving", "v_pathblocked", "v_idle", "v_setnum", "v_maxrange",
		"c_micro_reactor", "f_human_refinery", "f_human_carrier", "f_human_sciencelab", "gearbox",
		"steelblock", "fuel_rod", "f_human_warehouse", "f_human_adv_miner", "f_human_refinery", "f_human_lighttank", "c_light_cannon",
		"f_human_foundation", "empty_databank", "f_human_sciencelab", "f_human_foundation_basic", "f_human_foundation2", "f_human_foundation3", "f_human_foundation4",
		"f_human_barracks", "f_human_infantrymech", "f_human_bunker", "f_human_foundation_adv", "ceramictiles", "polymer", "f_human_factory","f_human_transport",
		"c_micro_reactor", "human_databank", "f_human_communication", "f_human_datacomplex", "f_human_AI_explorer", "f_human_foundation6", "f_human_foundation7",
		"f_human_vehiclefactory", "f_human_tankframe", "c_human_tank_turret", "f_human_rover", "f_human_carrier", "f_heavy_bunker", "f_human_commandcenter",
		"f_human_lander", "f_human_spaceport", "f_human_flyer", "f_human_foundation5", "f_human_powerplant", "f_human_large_tankframe", "c_human_missilelauncher",
		"enriched_fuel_rod", "icchip",
	}
}

data.techs.t_alien_faction_npc = {
	name = "Alien Technology",
	texture = "Main/skin/Icons/Special/Technologies/Aliens.png",
	unlocks = {
		"metalore", "crystal", "metalbar", "metalplate", "silica", "silicon", "cable",
		"obsidian", "blight_crystal", "anomaly_particle", "anomaly_cluster", "anomaly_heart", "obsidian_brick", "shaped_obsidian", "alien_artifact", "energized_artifact",
		"v_color_red", "v_color_green", "v_color_blue", "v_color_yellow", "v_color_cyan", "v_color_magenta", "v_ally_faction",
		"v_own_faction", "v_enemy_faction", "v_world_faction", "v_bot", "v_building", "v_construction", "v_droppeditem", "v_resource", "v_damaged",
		"v_alien_faction", "v_solved", "v_unsolved", "v_can_loot",
		"f_alien_researcher",
		"f_alien_extractor", "f_alien_miner", "f_alien_transport", "empty_artifact_research", "f_alien_powergenerator", "f_alien_researcher","f_alien_feeder",
		"f_alien_worker", "f_alien_pylon", "plasma_crystal", "f_alien_producer", "f_alien_scout", "f_alien_pincer", "f_alien_storage","f_alien_reformingpool",
		"alien_artifact_research", "crystalized_obsidian", "c_anomaly_lattice", "f_alien_sensortower", "f_alien_teleporter", "f_alien_socketbuilding",
		"f_alien_observer", "f_alien_soldier", "f_alien_turret", "f_alien_tankframe", "c_alien_ion_lance", "f_alien_time_egg", "f_alien_probe",
		"f_alien_heart_shard", "f_alien_console", "f_alien_hvy_soldier", "f_alien_monolith",
	}
}

--[[

data.techs.sampletech = {
	name = "<NAME>",
	description = "<TEXT>",
	category = "<NAME>",                 --category name
	-- Optional
	intel = "<ITEMID>",                   --item id of intel item
	require_tech = { "<TECHID>", ... },   --requires other tech
	unlocks = { "<ITEMID>", ... },        --researching this tech unlocks these item/component/frame for production
	progress_count = <NUM>,               --the number of research progress needed to unlock this tech; if not set automatically unlock once requirements are met
	uplink_recipe = CreateUplinkRecipe(   --the uplink needed to increase progress (needed when progress_count is set)
		{ <INGREDIENT_ITEM_ID> = <INGREDIENT_NUM>, ... },
		<TICKS>
	),
	on_unlock = function(faction) ... end,, -- callback called when this tech was researched/unlocked
}

]]

local researchable_tech_cache = {}
function GetResearchableTech(faction)
	local cache = researchable_tech_cache[faction.index]
	if cache then return cache end

	local unlocked = faction.unlocked_techs
	for i,v in ipairs(unlocked) do unlocked[v] = true end

	local race = faction.extra_data.race or "robot"
	local researchable = {}
	local depths = {}
	for id,def in pairs(data.techs) do
		if not unlocked[id] then
			local require_tech = def.require_tech and (def.require_tech[race] or def.require_tech[1])
			if require_tech then
				if not unlocked[require_tech] then goto skip_tech end
				local depth = 0
				local reqdef
				while require_tech do
					depth = depth + 1
					reqdef = data.techs[require_tech]
					if reqdef == nil then print(require_tech) end
					require_tech = reqdef.require_tech and (reqdef.require_tech[race] or reqdef.require_tech[1])
				end
				depths[id] = depth
				researchable[#researchable+1] = id
				researchable[id] = true
			end
			::skip_tech::
		end
	end
	table.sort(researchable, function(a, b) return depths[a] < depths[b] end)
	researchable_tech_cache[faction.index] = researchable
	return researchable
end

function MapMsg.OnTechResearch(faction, tech_id)
	-- clear researchable cache
	researchable_tech_cache[faction.index] = false

	-- advance queue
	local research_queue = faction.extra_data.research_queue
	for i,v in ipairs(research_queue or {}) do
		if v == tech_id then
			table.remove(research_queue, i)
			break
		end
	end

	-- Trigger uplink updates
	for _,c in ipairs(faction:GetComponents("c_uplink", true)) do
		-- If we are being called via c_uplink:on_update we can't (and don't need to) activate this one uplink
		if not c.is_updating then
			c:Activate()
		end
	end
	local all_research = true
	for i, v in ipairs(data.tech_categories) do
		if not faction:IsUnlocked(v.initial_tech) then all_research = false break end
	end
	if all_research then faction:UnlockAchievement("RAINBOW_TECH") end
end

function MapMsg.OnFactionRespawn(faction)
	researchable_tech_cache[faction.index] = false
end
