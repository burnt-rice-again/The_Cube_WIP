--[[
	{
		albedo_height = "",																		-- sRGB, defaults to { 0, 0, 0, 0.5 } when empty
		emissive = "",																			-- sRGB, defaults to { 0, 0, 0 } when empty (not available for snow)
		normal_roughness_ao = "",																-- linear, defaults to { 0, 0, 0.5, 1 } when empty
		height_scale = 1, height_offset = 0,													-- applied to the heightmap before calculating the height blend
		sharpness = 1,																			-- biome blend sharpness
		strength = 0,																			-- set to anything > 0 to enable the biome
		blightness = { range = { -1, 1 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },		-- blightness blend parameters
		elevation = { range = { -1, 1 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },		-- elevation blend parameters
		richness = { range = { -1, 1 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },		-- richness blend parameters
		variation = { range = { -1, 1 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },		-- variation blend parameters
		world_height = { range = { -1, 1 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },	-- world height blend parameters
		minimap_color = {-1, -1, -1, -1}														-- color used in minimap. alpha used as reference height (hue shift, saturation & brightness aren't applied to this color value)
																								-- if any of RGB values is negative then the color is auto-calculated by the atlas and hue, saturation, brightness parameters
																								-- likewise, if A is -1 the height is auto-calculated by the heightmap. in most cases you might want to set A to -1
																								-- height_scale & height_offset aren't aplied to minimap height
		hue_shift = 0,																			-- albedo/emissive hue shift (-1, 1)
		saturation = 0,																			-- albedo/emissive saturation (0, 1)
		brightness = 0,																			-- albedo/emissive brightness adjustment (-1, 1)
		normal_sharpness = 0.5,																	-- adjust sharpness of normal map
		emissive_multiplier = 1.0																-- multiplier applied to emissive color (0, 5). (not available for snow)
		bump_level = 0.5,																		-- bump offse, range (0, 1). (not available for snow)
		bump_height = 0.0,																		-- bump height, range (-1, 1). (not available for snow)
		optional = true or false,																-- if true then this biome can be skipped in far distances
		reuse_previous = true or false, 														-- if this is true then the texture paths are ignored and the textures from the previous stage are used. base biome ignores this value
	},
]]--

local water_height = Map.GetWaterHeight()
local plateau_height = Map.GetPlateauHeight()
local plateau_level = Map.GetSettings().plateau_level
local blight_level = Map.GetSettings().blight_threshold

local function replace_biome(obj)
	for i,v in ipairs(data.biomes) do 
		if v.name == obj.name then 
			v = obj
		end
	end
end

local biome_water = {
		name = "shallow water pools",
		sharpness = 0.992, strength = 1,
		--richness = { range = { -1, 0 }, falloff = { 0, 0.1 }, contrast = 2, strength = 1 },
		variation = { range = { -1, 0 }, falloff = { -10, -1 }, contrast = 1, strength = 1 },
		world_height = { range = { plateau_height - 0.118415, 1 }, falloff = { 0.4, 0 }, contrast = 1, strength = 1 },
		hue_shift = 0.4, saturation = 0, brightness = 0,
		normal_sharpness = 0.4, bump_level = 0.5, bump_height = 0,
		optional = true,
		reuse_previous = true,
		richness = { range = { -1, 100 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },		-- richness blend parameters
	}

local lakes =	{
		name = "lakes",
		sharpness = 0.7, strength = 1,
		world_height = { range = { -1, water_height + 0 }, falloff = { -1, 0.1 }, contrast = 1, strength = 1 },
		hue_shift = 0.1, saturation = 0, brightness = 0,
		reuse_previous = true,
		richness = { range = { 50, 100 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },		-- richness blend parameters
	}

--replace_biome(lakes)

----- remove land features from table 

local function remove_item_from_array_by_frame(frame)
	for i,obj in ipairs(data.land_features) do 
		if obj.frame == frame then 
			table.remove(data.land_features, i)
			--("Removing Land Feature")
			--print(obj.frame)
			return true
		end
		if obj.frame == 'f_dropped_resource' and obj.nodes and obj.nodes[1].inventory then 
			if not obj.nodes[1].inventory.crystal and not obj.nodes[1].inventory.metal then 
				table.remove(data.land_features, i)
				--print("Removing Land Feature")
				--print(obj.frame)
				return true
			end
		end
	end
	return false 
end

while remove_item_from_array_by_frame("f_resourcenode_silica") == true do end
while remove_item_from_array_by_frame("f_resourcenode_obsidian")== true do end
while remove_item_from_array_by_frame("f_resourcenode_tree")== true do end
while remove_item_from_array_by_frame("f_resourcenode_blightcrystal")== true do end
--while remove_item_from_array_by_frame("f_resourcenode_metal")== true do end


-- add features to the table 

-- CHANGED TO EXPLOREABLE 
-- table.insert(data.land_features,	{
-- 	frame = "fc_wire_plant",
-- 	min_spawn_distance = 30,
-- 	functions = {
-- 		{ func = "Threshold", param = "Elevation", range = { 0, plateau_level+0.15 }, falloff = 0.05 },
-- 	},
-- 	nodes = {
-- 		{
-- 			visuals = { "vc_sea_grass", },
-- 		},
-- 	}
-- })

-- for i,obj in ipairs(data.land_features) do 
-- 	if obj.frame == 'f_resourcenode_metal' then 
-- 		-- new visuals 
-- 		obj.nodes[1].visuals = {"vc_pixel_ore_1", "vc_pixel_ore_2"}
-- 		-- larger distance 
-- 		obj.min_spawn_distance = 100
-- 		-- higher richness 
-- 		if obj.nodes[1].resource.metalore[1] ~= REG_INFINITE then 
-- 			obj.nodes[1].resource.metalore[1] = 100 * obj.nodes[1].resource.metalore[1]
-- 			obj.nodes[1].resource.metalore[2] = 100 * obj.nodes[1].resource.metalore[2]
-- 		end
-- 	end
-- end



local desert_level = -0.5
local grass_level = -0.15
local blight_threshold = Map.GetSettings().blight_threshold - 0.02

local rich_mul = Map.GetSettings().resource_amt or 1.0
local resource_inf = Map.GetSettings().resource_inf or false

local metal_richness_min = math.floor(200*rich_mul) -- 60
local metal_richness_max = math.floor(260*rich_mul) -- 80
local metal_coverage = 0.36 -- Variation coverage
local metal_patch_size = 0.93 -- richness width from edge -1 -> 1
local metal_dist_falloff = 0.3 -- distance
local metal_edge = 1

table.insert(data.land_features,{
	exclusive = true,
	frame = "f_resourcenode_pixel",
	min_spawn_distance = 100,
	functions = {
		{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
		{ func = "Threshold", param = "Elevation", range = { desert_level, grass_level }, falloff = 0.05 },
		{ func = "Threshold", param = "Variation", range = { metal_edge-metal_coverage, metal_edge }, falloff = metal_dist_falloff, },
		{ func = "Threshold", param = "Richness", falloff = 0.1, range = { -1, -1+metal_patch_size }, chance = 0.3},
	},
	nodes = {
		{
			visuals = { "vc_pixel_ore_1", "vc_pixel_ore_2" },
			resource = { ic_pixel = resource_inf and {REG_INFINITE ,REG_INFINITE } or { metal_richness_min*200, metal_richness_max*400 } },
		},
	}
})
-- does not work?
table.insert(data.land_features,{
	--exclusive = true,
	frame = "f_resourcenode_concrete",
	min_spawn_distance = 50,
	functions = {
		{ func = "Threshold", param = "Blightness", range = { -1, blight_threshold } },
		{ func = "Threshold", param = "Elevation", range = { desert_level, grass_level }, falloff = 0.05 },
		{ func = "Threshold", param = "Variation", range = { metal_edge-metal_coverage, metal_edge }, falloff = metal_dist_falloff -5, }, --high falloff here increase metal spread
		{ func = "Threshold", param = "Richness", falloff = 0.1, range = { -1, -1+metal_patch_size }, chance = 0.3},
	},
	nodes = {
		{
			visuals = {"v_2x2_a_ruined"},
			--visuals = { "v_simulator_ruined", "v_2x2_a_ruined","v_crashedship_2x2_moss","v_crashedship_2x2_desert","v_explorable_building_4","v_explorable_building_6","v_explorable_building_3", "v_battery_01_l_ruined", "v_missile_launcher_m_ruined","v_transporter_01_m_ruined","v_crashedship_2x1_moss","v_crashedship_2x1_desert","v_explorable_glitchbuilding","v_explorable_brokenship_1" },
			resource = { concreteslab = resource_inf and {REG_INFINITE ,REG_INFINITE } or { metal_richness_min*45, metal_richness_max*90 } },
		},
	}
})