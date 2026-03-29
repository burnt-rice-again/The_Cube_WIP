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

data.biomes = {
	{
		name = "sand",
		albedo_height = "Main/textures/landscape/T_Landscape_Sand_01_Albedo-H.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Sand_01_N-R-AO.tga",
		height_scale = 1, height_offset = -0.5,
		sharpness = 1, strength = 1,
		world_height = { range = { -1, plateau_height - 0.551415 }, falloff = { 0, 0.2 }, contrast = 1, strength = 1 },
	},
	{
		name = "cliff base",
		albedo_height = "Main/textures/landscape/T_Landscape_Rock_01_Albedo-H.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Rock_01_N-R-AO.tga",
		sharpness = 1, strength = 1,
		world_height = { range = { plateau_height - 0.451415, 1 }, falloff = { 0.2, 0 }, contrast = 1, strength = 1 },
		normal_sharpness = 0.5, bump_level = 0.4, bump_height = 0.5,
	},
	{
		name = "sandrock",
		albedo_height = "Main/textures/landscape/T_Landscape_Sandstone_02_Albedo-H.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Sandstone_02_N-R-AO.tga",
		sharpness = 0.92, strength = 1,
		blightness = { range = { -1, blight_level - 0.15 }, falloff = { 0, 0.5 }, contrast = 1, strength = 1 },
		elevation = { range = { -1, plateau_level - 0.36 }, falloff = { 1, 0 }, contrast = 1, strength = 1 },
		richness = { range = { 0.25, 0.3 }, falloff = { 1, 1 }, contrast = 0.3, strength = 1 },
		world_height = { range = { -1, plateau_height - 0.451415 }, falloff = { 0.2, 0.1 }, contrast = 1, strength = 1 },
		normal_sharpness = 0.667, bump_level = 0.5, bump_height = 0.5,
	},
	{
		name = "lakes",
		sharpness = 0.7, strength = 1,
		world_height = { range = { -1, water_height + 0 }, falloff = { 0, 0.1 }, contrast = 1, strength = 1 },
		hue_shift = 0.1, saturation = 0, brightness = 0,
		reuse_previous = true,
	},
	{
		name = "desert3",
		albedo_height = "Main/textures/landscape/T_Landscape_Sandstone_01_Albedo-H.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Sandstone_01_N-R-AO.tga",
		sharpness = 0.7, strength = 1,
		elevation = { range = { -1, plateau_level - 0.4 }, falloff = { 1, 0.5 }, contrast = 1, strength = 1 },
		richness = { range = { -0.4, -0.3 }, falloff = { 1, 1 }, contrast = 0.1, strength = 1 },
		world_height = { range = { -1, plateau_height - 0.451415 }, falloff = { 0, 0 }, contrast = 1, strength = 1 },
		normal_sharpness = 0.667, bump_level = 0.5, bump_height = 0.5,
	},
	{
		name = "grass",
		albedo_height = "Main/textures/landscape/T_Landscape_Grass_02_Albedo-H.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Grass_02_N-R-AO.tga",
		sharpness = 0.542857, strength = 1,
		blightness = { range = { -1, blight_level + 0 }, falloff = { 0, 0.1 }, contrast = 1, strength = 1 },
		elevation = { range = { plateau_level - 0.3, plateau_level + 0 }, falloff = { 0.05, 0.05 }, contrast = 0.6, strength = 1 },
		world_height = { range = { -1, plateau_height - 0.553854 }, falloff = { 0, 0.314634 }, contrast = 0.987036, strength = 1 },
	},
	{
		name = "grass on slope",
		sharpness = 0.542857, strength = 1,
		blightness = { range = { -1, blight_level + 0 }, falloff = { 0, 0.1 }, contrast = 1, strength = 1 },
		elevation = { range = { plateau_level - 0.3, plateau_level + 0 }, falloff = { 0.05, 0.05 }, contrast = 0.6, strength = 1 },
		world_height = { range = { -1, plateau_height - 0.553854 }, falloff = { 0, 0.314634 }, contrast = 0.987036, strength = 1 },
		optional = true,
		reuse_previous = true,
	},
	{
		name = "blighted grass",
		sharpness = 0.5, strength = 1,
		blightness = { range = { blight_level + 0, 1 }, falloff = { 0.1, 0 }, contrast = 1, strength = 1 },
		elevation = { range = { plateau_level - 0.3, plateau_level + 0 }, falloff = { 0.05, 0.05 }, contrast = 0.6, strength = 1 },
		world_height = { range = { -1, plateau_height - 0.451415 }, falloff = { 0, 0.3 }, contrast = 1, strength = 1 },
		hue_shift = -0.2, saturation = 0, brightness = 0,
		optional = true,
		reuse_previous = true,
	},
	{
		name = "clifftop 1 (mossy)",
		albedo_height = "Main/textures/landscape/T_Landscape_Rock_02_Albedo-H.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Rock_02_N-R-AO.tga",
		sharpness = 0.9, strength = 1,
		richness = { range = { -1, 0 }, falloff = { 0, 0.1 }, contrast = 2, strength = 1 },
		world_height = { range = { plateau_height - 0.118115, 1 }, falloff = { 0.4, 0 }, contrast = 1, strength = 1 },
		normal_sharpness = 0.8, bump_level = 0.5, bump_height = 0.5,
		optional = true,
	},
	{
		name = "shallow water pools",
		sharpness = 0.992, strength = 1,
		richness = { range = { -1, 0 }, falloff = { 0, 0.1 }, contrast = 2, strength = 1 },
		variation = { range = { -1, 0 }, falloff = { 0, 0.1 }, contrast = 1, strength = 1 },
		world_height = { range = { plateau_height - 0.118415, 1 }, falloff = { 0.4, 0 }, contrast = 1, strength = 1 },
		hue_shift = 0.4, saturation = 0, brightness = 0,
		normal_sharpness = 0.4, bump_level = 0.5, bump_height = 0,
		optional = true,
		reuse_previous = true,
	},
	{
		name = "blight",
		albedo_height = "Main/textures/landscape/T_Landscape_Blight_02_Albedo-H.tga",
		emissive = "Main/textures/landscape/T_Landscape_Blight_02_Emissive-Alpha.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Blight_02_N-R-AO.tga",
		height_scale = 2, height_offset = 1,
		sharpness = 0.98, strength = 1,
		blightness = { range = { blight_level + 0.01, 1 }, falloff = { 0.06, 0.03 }, contrast = 0.7, strength = 1 },
		minimap_color = { 0.12, 0.05, 0.1, 0.75 },
		normal_sharpness = 0.8, bump_level = 0.5, bump_height = 0.5,
		emissive_multiplier = 2,
	},
	{
		name = "blight2",
		albedo_height = "Main/textures/landscape/T_Landscape_Blight_03_Albedo-H.tga",
		emissive = "Main/textures/landscape/T_Landscape_Blight_03_Emissive-Alpha.tga",
		normal_roughness_ao = "Main/textures/landscape/T_Landscape_Blight_03_N-R-AO.tga",
		height_scale = 2, height_offset = 0.1,
		sharpness = 0.98, strength = 1,
		blightness = { range = { blight_level + 0.05, 1 }, falloff = { 0.05, 0 }, contrast = 1, strength = 1 },
		minimap_color = { 0.25, 0.1, 0.18, 0.75 },
		normal_sharpness = 0.8, bump_level = 0.5, bump_height = 0.5,
		emissive_multiplier = 2,
	},
}

data.snow =
{
	name = "snow",
	albedo_height = "Main/textures/landscape/T_Landscape_Sand_01_Albedo-H.tga",
	normal_roughness_ao = "Main/textures/landscape/T_Landscape_Snow_01_N-R-AO.tga",
	height_scale = 1, height_offset = 1,
	sharpness = 0.75, strength = 1,
	richness = { range = { 0.3, 1.0 }, falloff = { 1.000000, 0.000000 }, contrast = 0.50000, strength = 1.000000 },
	blightness = { range = { -1, blight_level }, falloff = { 0, 0.5 }, contrast = 0.50000, strength = 0.7500000 },
	world_height = { range = { 0.88, 1.0 }, falloff = { 0.60000, 0.000000 }, contrast = 0.20000, strength = 1.000000 },
	minimap_color = { 1, 1, 1, 0.75 },
	hue_shift = 0.45, saturation = 0, brightness = 0.2,
}
