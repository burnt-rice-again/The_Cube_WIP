--[[

tables below are used in resource and feature generation

func = {
	"Threshold",	-- requires range within [-1, 1]
	"Minimum",		-- returns local lakes in the noise function
	"Maximum",		-- returns local peaks in the noise function
	"Inversion",	-- returns points where the gradient of the noise function changes
}

param = {
	"None",			-- uses chance directly function not applied
	"Blightness",	[-1, 1]
	"Elevation",	[-1, 1]
	"Richness",		[-1, 1]
	"Variation",	[-1, 1]
	"Height",		[-1, 1]
	"Slope"			[ 0, 1]
}
s
density_mode = {
	"Random",	-- calculates density as a random value between the density min and max
	"Weighted"	-- calculates density as a weighted value between density min and max
}


-- function weight calculation based on this graph: https://www.desmos.com/calculator/9ju5vlyt79

data.land_features = {
	{
		frame = "frame_name",
		on_spawn = function(x, y, discoverer, node_index) end, -- alternative to frame
		exclusive = false,
		min_spawn_distance = 0,
		-- functions act as filter. weight of all functions is multipled to provide a final result
		functions = {
			{ func = "Threshold", param = "None", range = { -1, 1 }, falloff = 0, chance = 1 },				-- defaults, equivalent to 100% chance of spawning
			-- special cases
			{ chance = 0.5 },																				-- chance multiplier with no filtering
			{ func = "Threshold", param = "Blightness", range = { 0, -0.5 }, falloff = 0.5, chance = 1 },	-- valid with range max < min when falloff is > 0. it will give diminished chance results
		},
		-- nodes act as a selector. weight of the node is calculated bnased on functions. if node weight passes the test process stops
		-- otherwise process continutes to the next node. if all nodes fail the feature doesn't spawn.
		-- if there is a node selected itsd weight is multiplied to the feature weight
		nodes = {
			{
				functions = {
					{ func = "Threshold", param = "None", range = { -1, 1 }, falloff = 0, chance = 1 },
				},
				density_mode = "Random",
				density = { 1, 1 },
				visuals = { "visual_name" },
				resource = { resource_name = { min, max } },
				inventory = { resource_name = { min, max } },
			},
		}
	},
}

]]--

local Grasslands_TreeLine = 0.6
--local Grasslands_TreeLine_Var = 0.6
local plateau_level = Map.GetSettings().plateau_level
local plateau_inner = plateau_level + 0.2
local plateau_height = Map.GetPlateauHeight() - 0.3
--local water_level = Map.GetSettings().water_level
local rich_mul = Map.GetSettings().resource_amt or 1.0
local resource_inf = Map.GetSettings().resource_inf or false

-- old saves
local rsrich = Map.GetSettings().resource_richness
if rsrich then
	local bc = { 0.5, 1.0, 4.0, 1.0}
	rich_mul = bc[rsrich]
	resource_inf = rsrich == 4
end

local desert_level = -0.5
local grass_level = -0.15
local blight_threshold = Map.GetSettings().blight_threshold - 0.02

-- plateau
local plateau_rocky = 0.2
local plateau_center = 0.35
local plateau_fungus_falloff = (plateau_center-plateau_rocky)/2
local plateau_fungus = plateau_rocky+plateau_fungus_falloff

local crystal_richness_min = math.floor(40*rich_mul) -- 24
local crystal_richness_max = math.floor(48*rich_mul) -- 32
local crystal_coverage = 0.35

local crystal_dropped_coverage = 0.38
local crystal_dropped_patch_size = 0.8
local crystal_dropped_falloff = 0.1

local crystal_patch_falloff = 0.1
local crystal_patch_size = 1.2

local crystal_richness_falloff = 0.05

local crystal_edge = -1 -- patch edge

local metal_richness_min = math.floor(200*rich_mul) -- 60
local metal_richness_max = math.floor(260*rich_mul) -- 80
local metal_coverage = 0.36 -- Variation coverage
local metal_dropped_coverage = 0.45
local metal_patch_size = 0.93 -- richness width from edge -1 -> 1
local metal_patch_falloff = 0.25 -- richness falloff
local metal_dropped_falloff = 0.35
local metal_dist_falloff = 0.3 -- distance
local metal_edge = 1

local silica_richness_min = math.floor(80*rich_mul) -- 30
local silica_richness_max = math.floor(100*rich_mul) -- 40
local silica_falloff = (plateau_center-plateau_rocky)/2.0
local silica_patch_size = 0.05
local silica_patch_edge = 0.4

local laterite_richness_min = math.floor(260*rich_mul)
local laterite_richness_max = math.floor(380*rich_mul)

local blight_crystal_patch_falloff = 0.03
local blight_crystal_richness_min = math.floor(20*rich_mul) -- 2
local blight_crystal_richness_max = math.floor(28*rich_mul)-- 4

local obsidian_richness_min = math.floor(40*rich_mul)
local obsidian_richness_max = math.floor(50*rich_mul)
local obsidian_coverage = 0.4 -- Variation coverage
local obsidian_patch_size = 0.53 -- richness width from edge -1 -> 1
local obsidian_patch_falloff = 0.3 -- richness falloff
local obsidian_dist_falloff = 0.3 -- distance
local obsidian_edge = 1

local skip_resources = Map.GetSettings().skip_resources
local skip_foliage = Map.GetSettings().skip_foliage
local skip_explorables = Map.GetSettings().skip_explorables

local resources = {
	-- rich crystal
	{
		frame = "f_resourcenode_crystal",
		min_spawn_distance = 50,
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-crystal_patch_falloff }, falloff = crystal_patch_falloff },
			{ func = "Threshold", param = "Elevation", range = { grass_level+crystal_patch_falloff, plateau_level-0.01 }, falloff = crystal_patch_falloff},
			{ func = "Threshold", param = "Variation", range = { crystal_edge, crystal_edge+crystal_coverage, }, falloff = crystal_patch_falloff},
			{ func = "Threshold", param = "Richness", range = { 1-crystal_patch_size-0.1, 1 }, falloff = crystal_richness_falloff},
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
		},
		nodes = {
			{
				visuals = { "v_crystal_rich1", }, -- "v_crystal_rich2", "v_bluecrack1",
				resource = { crystal = resource_inf and {REG_INFINITE ,REG_INFINITE } or  { crystal_richness_min*130, crystal_richness_max*150 } },
			},
		}
	},

	-- medium crystal
	{
		frame = "f_resourcenode_crystal",
		min_spawn_distance = 2,
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-crystal_patch_falloff }, falloff = crystal_patch_falloff },
			{ func = "Threshold", param = "Elevation", range = { grass_level+crystal_patch_falloff, plateau_level-0.01 }, falloff = crystal_patch_falloff },
			{ func = "Threshold", param = "Variation", range = { crystal_edge, crystal_edge+crystal_coverage, }, falloff = crystal_patch_falloff},
			{ func = "Threshold", param = "Richness", range = { 1-crystal_patch_size, 1 }, falloff = crystal_richness_falloff},
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
			{ chance = 0.1 },
		},
		nodes = {
			{
				visuals = { "v_crystalmedium1a","v_crystalmedium1b", },
				resource = { crystal = { crystal_richness_min*6, crystal_richness_max*10 } },
				--density = {1, 4},
				density_mode = "Weighted",
			},
		}
	},
	-- small crystal

	{
		frame = "f_resourcenode_crystal",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-crystal_patch_falloff }, falloff = crystal_patch_falloff },
			{ func = "Threshold", param = "Elevation", range = { grass_level+crystal_patch_falloff, plateau_level-0.01 }, falloff = crystal_patch_falloff },
			{ func = "Threshold", param = "Variation", range = { crystal_edge, crystal_edge+crystal_coverage, }, falloff = crystal_patch_falloff },
			{ func = "Threshold", param = "Richness", range = { 1-crystal_patch_size, 1 }, falloff = crystal_richness_falloff},
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
			--{ chance = 0.7 },
		},
		nodes = {
			{
				visuals = { "v_crystalsmalla"},
				resource = { crystal = { crystal_richness_min*2, crystal_richness_max*3 } },
				density = {3, 6},
				density_mode = "Weighted",
			},
		},
	},
	-- dropped crystal
	{
		frame = "f_dropped_resource",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-crystal_patch_falloff+crystal_dropped_falloff }, falloff = crystal_dropped_falloff },
			{ func = "Threshold", param = "Elevation", range = { grass_level+crystal_patch_falloff-crystal_dropped_falloff, plateau_level-0.01 }, falloff = crystal_dropped_falloff },
			{ func = "Threshold", param = "Variation", range = { crystal_edge, crystal_edge+crystal_dropped_coverage+crystal_dropped_falloff, }, falloff = crystal_dropped_falloff},
			{ func = "Threshold", param = "Richness", range = { 1-crystal_patch_size-crystal_dropped_falloff, 1 }, falloff = crystal_dropped_falloff},
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, },
			{ chance = 0.4 },
		},
		nodes = {
			{
				visuals = { "v_crystalscatter_node1",}, -- "v_crystalmedium1b",
				inventory = { crystal = { 1, 6 } },
				--density = {1, 6},
				--density_mode = "Weighted",
			},
		},
	},

	-- rich metal
	{
		exclusive = true,
		frame = "f_resourcenode_metal",
		min_spawn_distance = 30,
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Elevation", range = { desert_level, grass_level }, falloff = 0.05 },
			{ func = "Threshold", param = "Variation", range = { metal_edge-metal_coverage, metal_edge }, falloff = metal_dist_falloff, },
			{ func = "Threshold", param = "Richness", falloff = 0.1, range = { -1, -1+metal_patch_size }, chance = 0.3},
		},
		nodes = {
			{
				visuals = { "v_metalrich1", "v_metalrich2", },
				resource = { metalore = resource_inf and {REG_INFINITE ,REG_INFINITE } or { metal_richness_min*45, metal_richness_max*55 } },
			},
		}
	},
	-- normal metal
	{
		exclusive = true,
		frame = "f_resourcenode_metal",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Elevation", range = { desert_level, grass_level }, falloff = 0.05 },
			{ func = "Threshold", param = "Variation", range = { metal_edge-metal_coverage, metal_edge }, falloff = metal_dist_falloff, },
			{ func = "Threshold", param = "Richness", range = { -1, -1+metal_patch_size }, falloff = metal_patch_falloff},
		},
		nodes = {
			{
				visuals = { "v_metalmedium1a", "v_metalmedium2a", }, -- "v_metalmedium1b", "v_metalmedium1c", "v_metalmedium1a", },
				resource = { metalore = { metal_richness_min*2, metal_richness_max*4 } },
				functions = {
					--{ func = "Threshold", param = "Richness", range = { -1, -1+metal_patch_size }, falloff = metal_patch_falloff/2.0},
					{ chance = 0.6 },
				},
				density = {2, 3},
				density_mode = "Weighted",
			},
			{
				visuals = { "v_metalsmall1a" },
				resource = { metalore = { metal_richness_min*2, metal_richness_max*4 } },
				functions = {
					--{ func = "Threshold", param = "Elevation", range = { -0.4, -0.1 }, falloff = 0.1 },
				},
				density = {3, 8},
				density_mode = "Weighted",
			},
		}
	},

	-- pickupable metal
	{
		frame = "f_dropped_resource",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Elevation", range = { desert_level, grass_level }, falloff = 0.05 },
			{ func = "Threshold", param = "Variation", range = { metal_edge-metal_dropped_coverage, metal_edge }, falloff = metal_dist_falloff, },
			{ func = "Threshold", param = "Richness", range = { -1, -1+metal_patch_size }, falloff = metal_dropped_falloff},
			{ chance = 0.6 },
		},
		nodes = {
			{
				visuals = { "v_metalpickup1a", },
				inventory = { metalore = { 1, 3 } },
			},
		}
	},

	-- silica plateau
	{
		exclusive = true,
		frame = "f_resourcenode_silica",
		min_spawn_distance = 15,
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Elevation", range = { plateau_level+silica_falloff, plateau_level+(silica_falloff*2.0) }, falloff=silica_falloff },
			{ func = "Threshold", param = "Variation", range = { silica_patch_edge-silica_patch_size, silica_patch_edge }, falloff = 0.15, },
			{ func = "Threshold", param = "Height", range = { 0, 1 } },
		},
		nodes = {
			{
				visuals = { "v_silica_node", },
				resource = { silica = resource_inf and {REG_INFINITE ,REG_INFINITE } or { silica_richness_min*60, silica_richness_max*80 } },
			},
		}
	},

	{
		exclusive = true,
		frame = "f_resourcenode_silica",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Elevation", range = { plateau_level, plateau_level+(silica_falloff*2.0) }, falloff=silica_falloff },
			{ func = "Threshold", param = "Variation", range = { silica_patch_edge-silica_patch_size, silica_patch_edge }, falloff = 0.15, },
			{ func = "Threshold", param = "Richness", falloff = 0.33, range = { 0, 0 },},
			{ func = "Threshold", param = "Height", range = { plateau_height, 1 } },
		},
		nodes = {
			{
				functions = { { chance = 0.55 }},
				visuals = { "v_silica_medium1", },
				resource = { silica = { silica_richness_min*5, silica_richness_max*8 } },
				density = {1, 3},
				density_mode = "Weighted",
			},
		}
	},


	-- silica desert dropped
	{
		exclusive = true,
		frame = "f_dropped_resource",
		functions = {
			{ func = "Threshold", param = "Variation", range = { -1, 0 },},
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.05, plateau_level }, },
			{ func = "Threshold", param = "Richness", range = { 0.1, 0.1 }, falloff = 0.04, chance = 0.3 },
		},
		nodes = {
			{
				visuals = { "v_silicascatter_node1" },
				inventory = { silica = { 2, 3 } },
				density_mode = "Weighted",
			},
		},
	},

	-- laterite
	-- rich
	{
		exclusive = true,
		frame = "f_resourcenode_laterite",
		min_spawn_distance = 50,
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, 0 } },
			{ func = "Threshold", param = "Elevation", range = { -0.7, -0.3 }, falloff = 0.05 },
			{ func = "Threshold", param = "Variation", range = { -0.3, 0.1 }, falloff = 0.15, },
			{ func = "Threshold", param = "Richness", falloff = 0.25, range = { 0, 0 },},
			{ chance = 0.3 },
		},
		nodes = {
			{
				visuals = { "v_laterite_node_large1",  }, -- "v_laterite_node_large2",  "v_decorationrock_floatingrock1"
				resource = { laterite = resource_inf and {REG_INFINITE ,REG_INFINITE } or { laterite_richness_min*30, laterite_richness_max*40 } },
			},
		}
	},

	-- normal
	{
		exclusive = true,
		frame = "f_resourcenode_laterite",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, 0 } },
			{ func = "Threshold", param = "Elevation", range = { -0.7, -0.3 } },
			{ func = "Threshold", param = "Variation", range = { -0.3, 0.2 }, falloff = 0.15, },
			{ func = "Threshold", param = "Richness", falloff = 0.1, range = { 0, 0 },},
		},
		nodes = {
			{
				visuals = { "v_laterite_medium1",},
				resource = { laterite = { laterite_richness_min, laterite_richness_max } },
			},
		}
	},
	-- normal
	{
		exclusive = true,
		frame = "f_resourcenode_laterite",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, 0 } },
			{ func = "Threshold", param = "Elevation", range = { -0.7, -0.3 } },
			{ func = "Threshold", param = "Variation", range = { -0.3, 0.2 }, falloff = 0.15, },
			{ func = "Threshold", param = "Richness", falloff = 0.1, range = { 0, 0 },},
		},
		nodes = {
			{
				visuals = { "v_laterite_small1" },
				resource = { laterite = { laterite_richness_min, laterite_richness_max } },
				density = {1, 3},
				density_mode = "Weighted",
			},
		}
	},

	-- blight crystals
	{
		exclusive = true,
		frame = "f_resourcenode_blightcrystal",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { blight_threshold, 1 }, falloff = blight_crystal_patch_falloff },
			{ func = "Threshold", param = "Variation", range = { crystal_edge, crystal_edge+crystal_coverage+crystal_patch_falloff, }, falloff = blight_crystal_patch_falloff },
			{ func = "Threshold", param = "Richness", range = { 0, 0 }, falloff = 0.5 },
			{ chance = 0.8 },
		},
		nodes = {
			{
				visuals = { "v_blightcrystal_small1" },
				resource = { blight_crystal = { blight_crystal_richness_min, blight_crystal_richness_max } },
				functions = { { chance = 0.6 }},
				density = {1, 6},
				density_mode = "Weighted",
			},
			{
				visuals = { "v_blightcrystal1a", "v_blightcrystal1b", }, --"v_blightcrystal1c" },
				resource = { blight_crystal = resource_inf and {REG_INFINITE ,REG_INFINITE } or { blight_crystal_richness_min*10, blight_crystal_richness_max*10 } },
				--density = {1, 6},
				--density_mode = "Weighted",
			},
		},
	},

	-- obsidian

	-- rich obsidian
	{
		exclusive = true,
		frame = "f_resourcenode_obsidian",
		min_spawn_distance = 10,
		functions = {
			{ func = "Threshold", param = "Blightness", range = { blight_threshold+0.05, 1, } },
			{ func = "Threshold", param = "Variation", range = { obsidian_edge-obsidian_coverage, obsidian_edge }, falloff = obsidian_dist_falloff, },
			{ func = "Threshold", param = "Richness", falloff = 0.1, range = { -1, -1+obsidian_patch_size }, chance = 0.7},
		},
		nodes = {
			{
				visuals = { "v_obsidian_large", },
				resource = { obsidian = resource_inf and {REG_INFINITE ,REG_INFINITE } or {  obsidian_richness_min*50, obsidian_richness_max*80} },
			},
		}
	},

	-- normal obsidian
	{
		exclusive = true,
		frame = "f_resourcenode_obsidian",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { blight_threshold+0.05, 1,  } },
			{ func = "Threshold", param = "Variation", range = { obsidian_edge-obsidian_coverage, obsidian_edge }, falloff = obsidian_dist_falloff, },
			{ func = "Threshold", param = "Richness", range = { -1, -1+obsidian_patch_size }, falloff = obsidian_patch_falloff},
		},
		nodes = {
			{
				visuals = { "v_obsidian_medium", },
				resource = { obsidian = {  obsidian_richness_min*2, obsidian_richness_max*3} },
				functions = {
					{ chance = 0.6 },
				},
			},
		}
	},
}

------------------------------- START FOREST
local foliage = {
	-- Trees
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.05, plateau_level-0.02 }, falloff = 0.05 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
		},
		nodes = {

			----------------------------------
			-- leafy trees
			{
				visuals = { "v_tree_04_large_01", "v_tree_04_Medium_01", "v_tree_04_Medium_02", "v_tree_04_Medium_03" }, --v_tree_04_hero_01, v_tree_04_Large_01, v_tree_04_Medium_01, v_tree_04_Medium_02, v_tree_04_Medium_03, v_tree_04_Small_01,
				functions = {
					--{ func = "Threshold", param = "Richness", falloff = 1, range = { Grasslands_TreeLine_Var, 1 }, },
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { Grasslands_TreeLine, Grasslands_TreeLine + 0.1},},
				},
				density = {1, 0.7},
				density_mode = "Weighted",
			},
			-- NO VISUALS SET
			--[[
			-- succulent trees
			{
				--visuals = { "v_tree_05_large", "v_tree_05_medium", "v_tree_05_small" }, --v_tree_04_hero_01, v_tree_04_Large_01, v_tree_04_Medium_01, v_tree_04_Medium_02, v_tree_04_Medium_03, v_tree_04_Small_01,
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { Grasslands_TreeLine, Grasslands_TreeLine +0.1},},
				},
				density = {1, 1},
				density_mode = "Weighted",
			},
			--]]
		},
	},

	-- Inner larger trees
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.05, plateau_level-0.02 }, falloff = 0.05 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
		},
		nodes = {

			{
				visuals = { "v_tree_04_large_01_ExtraLarge", "v_tree_04_hero_01" },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { Grasslands_TreeLine + 0.2, 1},},
				},
				density = {1, 0.3},
				density_mode = "Weighted",
			},
		},
	},

	-- Succulent Trees
	{
		exclusive = false,
		frame = "f_resourcenode_tree",
		--frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.05, plateau_level-0.02 }, falloff = 0.05 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
			{ chance = 0.01 },
		},
		nodes = {

			{
				visuals = { "v_tree_05_large", "v_tree_05_medium", "v_tree_05_small" },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0, range = { Grasslands_TreeLine -0.5, Grasslands_TreeLine},},
				},
				resource = { silica = { 12, 20 } },
				--density = {1, 0.01},
				--density_mode = "Weighted",
			},
		},
	},

	-- ring of medium large trees
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.05, plateau_level-0.02 }, falloff = 0.05 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
		},
		nodes = {

			{
				visuals = { "v_tree_04_large_01_Larger", },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { Grasslands_TreeLine + 0.1 , Grasslands_TreeLine + 0.2},},
				},
				density = {1, 0.3},
				density_mode = "Weighted",
			},
		},
	},

	-- Tree shrubbery
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.05, plateau_level-0.02 }, falloff = 0.05 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height } },
		},
		nodes = {
			{
				visuals = { "v_succulent_02_large", },
				functions = {
					--{ func = "Threshold", param = "Richness", falloff = 1, range = { Grasslands_TreeLine_Var, 1 }, },
					{ func = "Threshold", param = "Variation", falloff = 0.4, range = { Grasslands_TreeLine, 1},},
				},
				density_mode = "Weighted",
				density = {1, 1},
			},
		},
	},

	-- Prarie Tall Wavy Grass
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level, plateau_level }, falloff = 0.03 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			----------------------------------
			-- grass
			-- grass
			{
				visuals = {"v_longgrass_01", },-- "v_longgrass_02", "v_longgrass_02", "v_longgrass_02" }, --"v_longgrass_03", "v_longgrass_02", },
				functions = {
					--{ func = "Threshold", param = "Variation", falloff = 0.2, range = { -1, 0},},
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { -1, Grasslands_TreeLine - 0.4},},
					--{ chance = 100 },
				},
				density_mode = "Random",
				density = {1, 5},
			},
			-- NO VISUALS SET
			--[[
			{
				--visuals = {"v_longgrass_02", },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { -1, Grasslands_TreeLine - 0.4},},
					{ chance = 2 },
				},
				density_mode = "Weighted",
				density = {.2, 10},
			},
			--]]
		},
	},

	-- Prarie GroundGrass
	-- taller than normal groundgrass
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+ 0.02, plateau_level }, falloff = 0.04 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			{
				visuals = {"v_shortgrass_01_tall", },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0.2, range = { -1, Grasslands_TreeLine - 0.4},},
				},
				--density_mode = "Weighted",
				--density = {1, 0.9},
			},
		},
	},

	-- Prarie Pearls
	-- random large chunks of pearls in the fields
	--[[
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level, plateau_level }, falloff = 0.03 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			----------------------------------
			-- grass
			-- grass
			{
				visuals = {"v_pearls_02", },-- "v_longgrass_02", "v_longgrass_02", "v_longgrass_02" }, --"v_longgrass_03", "v_longgrass_02", },
				functions = {
					--{ func = "Threshold", param = "Variation", range = { -1, grass_tree },},
					--{ chance = 100 },
				},
				density_mode = "Random",
				density = {.1, .1},
			},
		},
	},
	--]]

	-- TreeEdge Pearls
	-- lots of pearls covering ground
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.08, plateau_level-0.02 }, falloff = 0.1 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			----------------------------------
			{
				visuals = { "v_pearls_03" }, -- "v_pearls_01", "v_pearls_02",
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0, range = { Grasslands_TreeLine -0.4, Grasslands_TreeLine},},
				},
				density_mode = "Weighted",
				density = {1, 2},
			},
		},
	},
	-- TreeEdge Succulents
	-- many succulents groups
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.02, plateau_level-0.02 }, falloff = 0.1 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			{
				visuals = { "v_succulent_01", "v_succulent_02", "v_succulent_03", "v_succulent_04", "v_succulent_05_A", "v_succulent_05_B", "v_succulent_05_C" },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0, range = { Grasslands_TreeLine -0.3, Grasslands_TreeLine},},
				},
				density_mode = "Random",
				density = {1, 2},
			},
		},
	},
	-- more treeedge Succulents
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.02, plateau_level-0.02 }, falloff = 0.1 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			{
				visuals = { "v_succulent_01", "v_succulent_02", "v_succulent_05_A", "v_succulent_05_B", "v_succulent_05_C", },
				functions = {
					{
						func = "Threshold", param = "Variation", falloff = 0, range = { Grasslands_TreeLine -0.5, Grasslands_TreeLine},
					},
				},
				density_mode = "Random",
				density = {1, 2},
			},
		},
	},

	-- tiny trees
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.02, plateau_level-0.02 }, falloff = 0.1 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			{
				visuals = { "v_tree_04_small_01", },
				functions = {
					{
						func = "Threshold", param = "Variation", falloff = 0, range = { Grasslands_TreeLine -0.5, Grasslands_TreeLine},
					},
				},
				density_mode = "Random",
				density = {0.1, 0.005},
			},
		},
	},
	-- TreeEdge GroundGrass
	-- short ground grass
	{
		exclusive = false,
		frame = "f_feature",
		functions = {
			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold-0.05 }, falloff = 0.05 },
			{ func = "Threshold", param = "Elevation", range = { grass_level+0.02, plateau_level-0.02 }, falloff = 0.03 },
			{ func = "Threshold", param = "Height", range = { -1, plateau_height }, falloff = 0 },
		},
		nodes = {
			----------------------------------
			{
				visuals = { "v_shortgrass_01" },
				functions = {
					{ func = "Threshold", param = "Variation", falloff = 0.5, range = { Grasslands_TreeLine, 1},},
				},
				--density_mode = "Random",
				density = {1, 1},
			},
		},
	},
	---------------------------------------- START PLATEAU

	-- plateau rocks
	{
		frame = "f_blocking_feature",
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.1, plateau_rocky-0.05 }, falloff = 0.1 },
			{ func = "Threshold", param = "Richness", range = { -0.2, 0.2 } },
			--{ func = "Threshold", param = "Blightness", range = { -1,  } },
		},
		nodes = {
			{
				visuals = {
					"v_decorationrock_largeplateau_1a",
					"v_decorationrock_largeplateau_1b",
					"v_decorationrock_largeplateau_1c",
					"v_decorationrock_largeplateau_2a",
					"v_decorationrock_largeplateau_2b",
					"v_decorationrock_largeplateau_2c",
					"v_decorationrock_largeplateau_2d",
					"v_decorationrock_largeplateau_3a",
					"v_decorationrock_largeplateau_3b",
					"v_decorationrock_largeplateau_3c",
					"v_decorationrock_largeplateau_3d",
				},
				functions = {
					{ chance = 0.3 },
				},
			},
		},
	},
	{
		frame = "f_blocking_feature",
		min_spawn_distance = 8,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.2, plateau_inner }, falloff = 0.05 },
			{ func = "Threshold", param = "Slope", range = { 0, 0.0 }, falloff = 0.0 },
			{ func = "Threshold", param = "Blightness", falloff = 0.05, range = { -1, blight_threshold - 0.1 } },
			--{chance = 0.95},
		},
		nodes = {
			{
				visuals = { "plateau_set_01", "plateau_set_02", "plateau_set_03", "plateau_set_hole_01", "plateau_set_hole_02", },
			},
		}
	},

	{
		frame = "f_damage_plant",
		min_spawn_distance = 16,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.1, plateau_level+0.15 }, falloff = 0.05 },
		},
		nodes = {
			{
				visuals = { "v_damage_plant", },
			},
		}
	},

	{
		frame = "f_phase_plant",
		min_spawn_distance = 16,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.1, plateau_level+0.15 }, falloff = 0.05 },
		},
		nodes = {
			{
				visuals = { "v_phase_plant", },
			},
		}
	},

	---------------------------------------- END PLATEAU
	-- desert trees sticks
	{
		--exclusive = true,
		frame = "f_feature",
		functions = {

			{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
			{ func = "Threshold", param = "Elevation", range = { -0.4, -0.3 }, falloff = 0.05 },
			{ func = "Threshold", param = "Variation", range = { -1, -0.3 }, falloff = 0.05 },
		},
		nodes = {
			-- red trees
			{
				visuals = { "v_tree12a1","v_tree12a3", "v_tree12a2", "v_tree12a5",}, --"v_tree12a4",
				density = { 1, 3 },
				density_mode = "Weighted",
				functions = {
					{ func = "Threshold", param = "Richness", range = { 0, 1}, falloff = 0.2, chance = 0.7 },
				},
			},
			-- sticky trees
			{
				functions = {
					{ func = "Threshold", param = "Richness", range = { -1, 0}, falloff = 0.2, chance = 0.3 },
				},
				visuals = {"v_tree4a",},
				--density_mode = "Weighted",
				--density = { 1, 3 },
			},
		},
	},

	-- deep blight rocks
	{
		frame = "f_blocking_feature",
		min_spawn_distance = 10,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.05, 1 }, falloff = 0.05 },
			{ func = "Threshold", param = "Blightness", falloff = 0.0, range = { blight_threshold + 0.2, 1 } },
		},
		nodes = {
			{
				visuals = {
					"blight_set_03",
					----"blight_set_04",
					"blight_set_05",
					"blight_set_06",
				},
			},
		}
	},

	-- shallow blight rocks 1
	{
		frame = "f_blocking_feature",
		min_spawn_distance = 30,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.03, plateau_level+0.08 }, falloff = 0.03 },
			{ func = "Threshold", param = "Blightness", falloff = 0.0, range = { blight_threshold+0.15, 1 } },
		},
		nodes = {
			{
				visuals = {
					----"blight_set_04",
					"blight_set_07",
					"blight_set_08",
					"blight_set_09",
				},
			},
		}
	},

	-- shallow blight rocks 2
	{
		frame = "f_blocking_feature",
		min_spawn_distance = 20,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { plateau_level+0.03, plateau_level+0.18 }, falloff = 0.03 },
			{ func = "Threshold", param = "Blightness", falloff = 0.0, range = { blight_threshold+0.03, 1 } },
		},
		nodes = {
			{
				visuals = {
					"blight_set_01",
					"blight_set_02",
					----"blight_set_04",
				},
			},
		}
	},
}

local explorables = {
	-- explorables
	{
		min_spawn_distance = 22,
		on_spawn = function(x, y, discoverer)
			Explorable_SpawnAt(x, y, discoverer)
		end,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { -0.4, 0.4 } },
			--{ chance = 0.5 },
		},
		nodes = {
			{
				functions = { { func = "Maximum", param = "Richness" } },
			},
		},
	},
	{
		min_spawn_distance = 18,
		on_spawn = function(x, y, discoverer)
			Explorable_SpawnAt(x, y, discoverer, "hostile")
		end,
		functions = {
			{ func = "Threshold", param = "Elevation", range = { -0.4, 0.4 } },
		},
		nodes = {
			{
				functions = { { func = "Maximum", param = "Richness" } },
			},
		},
	},
}

data.land_features = { }
local lf = data.land_features
if not skip_resources then for _,v in ipairs(resources) do table.insert(lf, v) end end
if not skip_foliage then for _,v in ipairs(foliage) do table.insert(lf, v) end end
if not skip_explorables then for _,v in ipairs(explorables) do table.insert(lf, v) end end

