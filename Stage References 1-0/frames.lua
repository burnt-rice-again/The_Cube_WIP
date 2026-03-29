--[[
data.frames.sampleframe = {
	name = "<NAME>",
	visibility_range = <NUM>,
	visual = "<VISUALID>",
	-- Optional
	slots = { <SLOT_TYPE> = <NUM>, ... }, -- base inventory slots
	components = { { "<COMPONENTID>", "auto"|"hidden"|<POSITION> }, ... }, -- initial components
	slot_type = "garage", -- for bots
	movement_speed = <NUM>, -- makes unit movable
	flags = "None|NonHoverable|NonSelectable|AnimateRoot|ClearFoliage|ClearFoundations|ClearConstructions|DisplaceDroppedItems|Space|Flyer", -- default 'None'
	minimap_color = { <R>, <G>, <B> },
	drone_range = <RANGE>, -- for docked drones
	is_tethered = true, -- tethered units must always be docked (must be set on drones)
	docked_visual = "<VISUALID>", -- to have a separate appearance when docked in an item slot
	health_points = <NUM>, -- default 100
	trigger_channels = "building|bot", -- multiple channels separated by |
	component_boost = 0, -- extra boost, example 10 is 10%
	start_disconnected = true, -- entity starts out disconnected from logistics network
	start_lootable = true, -- entity starts out flagged as lootable
	on_placed = function(self, entity) ... end,
	on_remove = function(self, entity) ... end,
	on_destroy = function(self, entity, damager_entity) ... end,
	on_interact = function(self, entity, interactor_entity, is_retry) ... end,
	can_interact = function(self, entity, interactor_entity, is_retry) ... end,
	type = "Decoration|Foundation|Wall|Gate|DroppedItem|Resource|Construction", -- special type, default nil for units/buildings
}

]]

-- Base table for all frames
Frame = {
	texture = "Main/textures/icons/frame/replace.png",
	minimap_color = { 0.8, 0.8, 0.8 },
	shield_type = "alloy",
}

function Frame:RegisterFrame(id, frame)
	data.frames[id] = setmetatable(frame, { __index = self })
	return frame
end

local FrameCarapace = setmetatable({ shield_type = "carapace" }, { __index = Frame })  -- FramePhysical
local FrameObsidian = setmetatable({ shield_type = "obsidian" }, { __index = Frame })   -- FramePlasma
local FrameEnergy   = setmetatable({ shield_type = "energy" }, { __index = Frame })

Frame:RegisterFrame("f_empty", { visual = "v_empty" })

Frame:RegisterFrame("f_mothership", {
	name = "Mothership",
	race = "robot",
	slots = { storage = 8 },
	health_points = 65535,
	flags = "Space",
	texture = "Main/textures/icons/frame/mothership.png",
	visual = "v_mothership_internal",
	no_integrated_behavior = true,
})

-------------- player Buildings
Frame:RegisterFrame("f_landingpod", {
	size = "Special", race = "robot", index = 1001, name = "Command Center",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 30,
	slots = { storage = 12, },
	health_points = 1000, -- 500
	texture = "Main/textures/icons/frame/building_2x2_ad.png",
	trigger_channels = "building",
	visual = "v_base2x2_as",
	components = {
		{ "c_carrier_factory", "hidden" },
	},
	drop_on_deconstruct = function(x, y)
		Map.DropItemAt(x, y, "c_deployer", { bp = { frame = "f_landingpod" }, onetime = true }, true)
	end,
})

Frame:RegisterFrame("f_beacon", {
	size = "Other", race = "robot", index = 1001, name = "Beacon",
	health_points = 1,
	minimap_color = { 0.5, 0.3, 1 },
	visibility_range = 3,
	slots = { storage = 1 },
	texture = "Main/textures/icons/frame/deployment_beacon.png",
	construction_recipe = CreateConstructionRecipe({ beacon_frame = 1 }, 5),
	trigger_channels = "building",
	visual = "v_beacon",
	power = -1,
	no_foundations = true,
	components = {
		{ "c_internal_crane1" , "hidden" },
	},
})

Frame:RegisterFrame("f_beacon_l", {
	size = "Other", race = "robot", index = 1002, name = "Large Beacon",
	health_points = 1,
	minimap_color = { 0.5, 0.3, 1 },
	visibility_range = 15,
	slots = { storage = 2, },
	texture = "Main/textures/icons/frame/deployment_beacon_1.png",
	construction_recipe = CreateConstructionRecipe({ beacon_frame = 5, circuit_board = 1 }, 15),
	trigger_channels = "building",
	visual = "v_beacon_l",
	power = -5,
	components = {
		{ "c_internal_crane2", "hidden" },
	},
	no_foundations = true,
})

local f_spacedrop = Frame:RegisterFrame("f_spacedrop", {
	size = "Other", race = "robot", index = 1003, name = "Drop Pod",
	visual = "v_spacedrop_1",
	slots = { storage = 6 },
	visibility_range = 3,
	trigger_channels = "building",
	components = { { "c_disappear_empty" , "hidden" } },
	texture = "Main/textures/icons/frame/drop_pod.png",
	no_integrated_behavior = true,
})

function f_spacedrop:on_destroy(entity)
	-- remove any popups
	entity.faction:RunUI(function() Notification.Clear("droppod") end)
end


local f_wall = FrameEnergy:RegisterFrame("f_wall", {
	size = "Wall", race = "robot", index = 1002, name = "Wall",
	type = "Wall",
	health_points = 150, --400
	texture = "Main/textures/icons/frame/Building_Wall_a.png",
	construction_recipe = CreateConstructionRecipe({ metalbar = 3, crystal = 3 }, 40),
	trigger_channels = "building",
	visual = "v_wall0", -- default for construction site
	no_integrated_behavior = true,
})

local wall_table<const> = {
	-- lookups for new visuals using a bit mask as key (1-16)
	-- first is the new rotation for wall meshes, followed by the rotation for gate meshes, followed by wall visual ids
	{ 0, 0, "v_wall0", "v_wall_vir0", "v_wall_bli0" }, --  0 no adjacent
	{ 0, 1, "v_wall1", "v_wall_vir1", "v_wall_bli1" }, --  1 up
	{ 1, 0, "v_wall1", "v_wall_vir1", "v_wall_bli1" }, --  2 right
	{ 0, 0, "v_wall5", "v_wall_vir5", "v_wall_bli5" }, --  3 up+right
	{ 2, 1, "v_wall1", "v_wall_vir1", "v_wall_bli1" }, --  4 down
	{ 0, 1, "v_wall2", "v_wall_vir2", "v_wall_bli2" }, --  5 down+up
	{ 1, 0, "v_wall5", "v_wall_vir5", "v_wall_bli5" }, --  6 right+down
	{ 0, 1, "v_wall3", "v_wall_vir3", "v_wall_bli3" }, --  7 up+right+down
	{ 3, 0, "v_wall1", "v_wall_vir1", "v_wall_bli1" }, --  8 left
	{ 3, 0, "v_wall5", "v_wall_vir5", "v_wall_bli5" }, --  9 up+left
	{ 1, 0, "v_wall2", "v_wall_vir2", "v_wall_bli2" }, -- 10 left+right
	{ 3, 0, "v_wall3", "v_wall_vir3", "v_wall_bli3" }, -- 11 up+right+left
	{ 2, 0, "v_wall5", "v_wall_vir5", "v_wall_bli5" }, -- 12 left+down
	{ 2, 1, "v_wall3", "v_wall_vir3", "v_wall_bli3" }, -- 13 left+up+down
	{ 1, 0, "v_wall3", "v_wall_vir3", "v_wall_bli3" }, -- 14 left+right+down
	{ 0, 0, "v_wall4", "v_wall_vir4", "v_wall_bli4" }, -- 15 left+up+down+right
	-- wall lookup tables with bits for each rotation using the neighbor types as key (17-22)
	{  0,  0,  0,  0 }, -- [17] no neighbor
	{  1,  2,  4,  8 }, -- [18] one neighbor
	{  5, 10,  5, 10 }, -- [19] two opposite neighbors
	{  3,  6, 12,  9 }, -- [20] two corner neighbors
	{  7, 14, 13, 11 }, -- [21] three neighbors
	{ 15, 15, 15, 15 }, -- [22] four neighbors
	-- lookups for existing visual id number and neighbor type index using the current visual id as key
	v_wall0 = { 3, 17 }, v_wall_vir0 = { 4, 17 }, v_wall_bli0 = { 5, 17 }, -- no neighbor
	v_wall1 = { 3, 18 }, v_wall_vir1 = { 4, 18 }, v_wall_bli1 = { 5, 18 }, -- one neighbor
	v_wall2 = { 3, 19 }, v_wall_vir2 = { 4, 19 }, v_wall_bli2 = { 5, 19 }, -- two opposite neighbors
	v_wall5 = { 3, 20 }, v_wall_vir5 = { 4, 20 }, v_wall_bli5 = { 5, 20 }, -- two corner neighbors
	v_wall3 = { 3, 21 }, v_wall_vir3 = { 4, 21 }, v_wall_bli3 = { 5, 21 }, -- three neighbors
	v_wall4 = { 3, 22 }, v_wall_vir4 = { 4, 22 }, v_wall_bli4 = { 5, 22 }, -- four neighbors
	v_gate = true, -- special handling of gates
}

local function FixWallVisual(entity, bit, neighbor_type, is_remove, try_rotation, placing_self)
	local old_visual_id = entity.visual_id
	local my_type = (placing_self and neighbor_type) or wall_table[old_visual_id]
	if not my_type then return end -- not a wall or gate

	if my_type == true then -- gate
		local x, y = entity:GetLocationXY()
		local old_bits, old_rotation, ent_d, ent_u, ent_l, ent_r = 0, entity.rotation
		if not placing_self then
			-- gates can't reconstruct their existing neighbors from just the visual and rotation, so check neighboring tiles
			ent_d = (is_remove or bit ~= 1) and Map.GetEntityAt(x, y+1, FF_WALL|FF_GATE|FF_OWNFACTION, entity)
			ent_u = (is_remove or bit ~= 4) and Map.GetEntityAt(x, y-1, FF_WALL|FF_GATE|FF_OWNFACTION, entity)
			ent_l = (is_remove or bit ~= 8) and Map.GetEntityAt(x-1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity)
			ent_r = (is_remove or bit ~= 2) and Map.GetEntityAt(x+1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity)
			local typ_d = ent_d and wall_table[ent_d.visual_id]
			local typ_u = ent_u and wall_table[ent_u.visual_id]
			local typ_l = ent_l and wall_table[ent_l.visual_id]
			local typ_r = ent_r and wall_table[ent_r.visual_id]
			-- ignore neighboring gates that aren't the same rotation as us
			old_bits = (
				(typ_d and (typ_d ~= true or ent_d.rotation == old_rotation) and 1 or 0) |
				(typ_u and (typ_u ~= true or ent_u.rotation == old_rotation) and 4 or 0) |
				(typ_l and (typ_l ~= true or ent_l.rotation == old_rotation) and 8 or 0) |
				(typ_r and (typ_r ~= true or ent_r.rotation == old_rotation) and 2 or 0) )
		end
		-- when trying to manually rotate a gate or one next to us, do so only if there is a matching neighbor in that direction
		if try_rotation and ((try_rotation == 0 and (bit & 10) == 0) or (try_rotation == 1 and (bit & 5) == 0)) then
			try_rotation = nil -- no neighbor in desired orientation
		end
		-- if gate already had neighbors don't change rotation now
		local new_rotation = old_rotation
		if placing_self or old_bits == 0 or is_remove or try_rotation then
			local new_bits = (is_remove and (old_bits & ~bit) or (old_bits | bit))
			local new_visual = wall_table[new_bits + 1] -- Lua index starts at 1
			new_rotation = try_rotation or new_visual[2] -- gate rotation at [2]
			if old_rotation ~= new_rotation then entity:SetVisual(old_visual_id, new_rotation) end
			if placing_self or old_rotation ~= new_rotation then
				-- when placing or rotating a gate, make sure things not matching the gates orientation are turned away
				if new_rotation == 0 and (new_bits & 1) ~= 0 then FixWallVisual(Map.GetEntityAt(x, y+1, FF_WALL|FF_GATE|FF_OWNFACTION, entity), 4, my_type, true) end
				if new_rotation == 0 and (new_bits & 4) ~= 0 then FixWallVisual(Map.GetEntityAt(x, y-1, FF_WALL|FF_GATE|FF_OWNFACTION, entity), 1, my_type, true) end
				if new_rotation == 1 and (new_bits & 8) ~= 0 then FixWallVisual(Map.GetEntityAt(x-1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity), 2, my_type, true) end
				if new_rotation == 1 and (new_bits & 2) ~= 0 then FixWallVisual(Map.GetEntityAt(x+1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity), 8, my_type, true) end
			end
			if not placing_self and old_rotation ~= new_rotation then
				-- when rotating an existing gate, make sure things are turned towards us
				if new_rotation == 1 and ent_d then FixWallVisual(ent_d, 4, my_type) end
				if new_rotation == 1 and ent_u then FixWallVisual(ent_u, 1, my_type) end
				if new_rotation == 0 and ent_l then FixWallVisual(ent_l, 2, my_type) end
				if new_rotation == 0 and ent_r then FixWallVisual(ent_r, 8, my_type) end
			end
		end
		-- return true only if we are rotated towards the checked direction
		return (new_rotation == 0 and (bit & 10) ~= 0) or (new_rotation == 1 and (bit & 5) ~= 0)
	elseif (neighbor_type == true) or (neighbor_type[1] == my_type[1]) then -- gate or matching wall type
		local visual_id_number, neighbors_idx = my_type[1], my_type[2]
		local old_bits = placing_self and 0 or wall_table[neighbors_idx][entity.rotation + 1]
		local new_bits = (is_remove and (old_bits & ~bit) or (old_bits | bit))
		local new_visual = wall_table[new_bits + 1] -- Lua index starts at 1
		local new_visual_id, new_rotation = new_visual[visual_id_number], new_visual[1] -- wall rotation at [1]
		entity:SetVisual(new_visual_id, new_rotation)
		return true
	end
end

function f_wall:on_placed(entity, try_rotation)
	local my_type = wall_table[entity.visual_id]
	local x, y = entity:GetLocationXY()
	local ent_d, ent_u, ent_l, ent_r = Map.GetEntityAt(x, y+1, FF_WALL|FF_GATE|FF_OWNFACTION, entity), Map.GetEntityAt(x, y-1, FF_WALL|FF_GATE|FF_OWNFACTION, entity), Map.GetEntityAt(x-1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity), Map.GetEntityAt(x+1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity)
	local bits =
		(ent_d and FixWallVisual(ent_d, 4, my_type, false, try_rotation) and 1 or 0) |
		(ent_u and FixWallVisual(ent_u, 1, my_type, false, try_rotation) and 4 or 0) |
		(ent_l and FixWallVisual(ent_l, 2, my_type, false, try_rotation) and 8 or 0) |
		(ent_r and FixWallVisual(ent_r, 8, my_type, false, try_rotation) and 2 or 0)
	FixWallVisual(entity, bits, my_type, false, try_rotation, true)
end

function f_wall:on_remove(entity)
	local my_type = wall_table[entity.visual_id]
	local x, y = entity:GetLocationXY()
	local ent_d, ent_u, ent_l, ent_r = Map.GetEntityAt(x, y+1, FF_WALL|FF_GATE|FF_OWNFACTION, entity), Map.GetEntityAt(x, y-1, FF_WALL|FF_GATE|FF_OWNFACTION, entity), Map.GetEntityAt(x-1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity), Map.GetEntityAt(x+1, y, FF_WALL|FF_GATE|FF_OWNFACTION, entity)
	if ent_d then FixWallVisual(ent_d, 4, my_type, true) end
	if ent_u then FixWallVisual(ent_u, 1, my_type, true) end
	if ent_l then FixWallVisual(ent_l, 2, my_type, true) end
	if ent_r then FixWallVisual(ent_r, 8, my_type, true) end
end

function f_wall:try_rotate(entity)
	local my_type = wall_table[entity.visual_id]
	if my_type ~= true then return end -- only gates can be rotated manually
	self:on_placed(entity, ((entity.rotation + 1) & 1))
end

f_wall:RegisterFrame("f_wall_vir", {
	size = "Wall", race = "virus", index = 4001, name = "Virus Wall",
	desc = "Virus energy barrier",
	health_points = 1000,
	texture = "Main/textures/icons/frame/Building_Wall_b.png",
	construction_recipe = CreateConstructionRecipe({ infected_circuit_board = 2, energized_plate = 2 }, 40),
	visual = "v_wall_vir0", -- default for construction site
	shield_type = "carapace",
})

f_wall:RegisterFrame("f_wall_bli", {
	size = "Wall", race = "blight", index = 2001, name = "Blight Wall",
	desc = "Blight energy barrier",
	health_points = 1000,
	texture = "Main/textures/icons/frame/Building_Wall_c.png",
	construction_recipe = CreateConstructionRecipe({ hdframe = 2, blight_crystal = 2 }, 50),
	visual = "v_wall_bli0", -- default for construction site
	shield_type = "energy",
})

Frame:RegisterFrame("f_gate", {
	size = "Wall", race = "robot", index = 1001, name = "Gate",
	type = "Gate",
	health_points = 150,
	texture = "Main/textures/icons/frame/Building_Gate_a.png",
	construction_recipe = CreateConstructionRecipe({ hdframe = 1, crystal_powder = 1 }, 50),
	trigger_channels = "building",
	visual = "v_gate",
	on_placed = f_wall.on_placed,
	on_remove = f_wall.on_remove,
	try_rotate = f_wall.try_rotate,
	no_integrated_behavior = true,
})

Frame:RegisterFrame("f_building1x1a", {
	size = "Medium", race = "robot", index = 1001, name = "Building 1x1 (1M)",
	desc = "Sacrifices Inventory Space to be able to support a Medium Component",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 2 },
	health_points = 100, --150
	texture = "Main/textures/icons/frame/Building_1x1_A.png",
	construction_recipe = CreateConstructionRecipe({ reinforced_plate = 5, circuit_board = 2 }, 45),
	trigger_channels = "building",
	visual = "v_base1x1a",
})

Frame:RegisterFrame("f_building1x1b", {
	size = "Large", race = "robot", index = 1, name = "Building 1x1 (1L)",
	desc = "Can support a Large Component but lacks an inventory space",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 1 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ hdframe = 5, circuit_board = 4 }, 50),
	texture = "Main/textures/icons/frame/Building_1x1_B.png",
	trigger_channels = "building",
	visual = "v_base1x1b",
})

Frame:RegisterFrame("f_building1x1c", {
	size = "Small", race = "robot", index = 1002, name = "Building 1x1 (2S)",
	desc = "Provides a second Small Component Slot at the expense of Inventory Space",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 2 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ metalplate = 15, circuit_board = 2 }, 45),
	texture = "Main/textures/icons/frame/building_1x1_c.png",
	trigger_channels = "building",
	visual = "v_base1x1c",
})

Frame:RegisterFrame("f_building1x1d", {
	size = "Small", race = "robot", index = 1001, name = "Building 1x1 (1S)",
	desc = "Basic 1x1 Building with Good Inventory space, but supports only one Small Component",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 4 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 5 }, 35),
	texture = "Main/textures/icons/frame/building_1x1_d.png",
	trigger_channels = "building",
	visual = "v_base1x1d",
})

Frame:RegisterFrame("f_building1x1f", {
	size = "Small", race = "robot", index = 1011, name = "Storage Block (8)",
	desc = "A simple storage building. Automatically transfer items here through the logistics network by setting the Store register of other units to this building.",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 10,
	slots = { storage = 8 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ metalbar = 10, crystal = 10 }, 55),
	texture = "Main/textures/icons/frame/building_1x1_f.png",
	trigger_channels = "building",
	visual = "v_base1x1f",
})

Frame:RegisterFrame("f_building1x1g", {
	size = "Small", race = "robot", index = 1012, name = "Storage Block (16)",
	desc = "A larger storage building which allows double stacking",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 10,
	slots = { storage = 16 },
	health_points = 100, --150
	construction_recipe = CreateConstructionRecipe({ reinforced_plate = 5, circuit_board = 1 }, 75),
	texture = "Main/textures/icons/frame/building_1x1_g.png",
	trigger_channels = "building",
	visual = "v_base1x1g",
})

Frame:RegisterFrame("f_building1x1h", {
	size = "Medium", race = "robot", index = 1002, name = "Defense Block",
	desc = "Strong Building but lacking inventory",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 12,
	slots = { storage = 1 },
	health_points = 500, -- 300 -- 600
	component_boost = 50,
	construction_recipe = CreateConstructionRecipe({ reinforced_plate = 5, }, 70),
	texture = "Main/textures/icons/frame/building_1x1_h.png",
	trigger_channels = "building",
	visual = "v_base1x1h",
})

Frame:RegisterFrame("f_building2x1a", {
	size = "Medium", race = "robot", index = 1013, name = "Building 2x1 (2M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 4 },
	health_points = 400, -- 200
	--construction_recipe = CreateConstructionRecipe({ energized_plate = 10, circuit_board = 4 }, 15),
	construction_recipe = CreateConstructionRecipe({ reinforced_plate = 30, circuit_board = 4 }, 70),
	texture = "Main/textures/icons/frame/building_2x1_a.png",
	trigger_channels = "building",
	visual = "v_base2x1a",
})

Frame:RegisterFrame("f_building2x1e", {
	size = "Medium", race = "robot", index = 1015, name = "Building 2x1 (2S1M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 600, -- 400 --200
	slots = { storage = 8 },
	component_boost = 50,
	construction_recipe = CreateConstructionRecipe({ refined_crystal = 6, circuit_board = 4 }, 80),
	texture = "Main/textures/icons/frame/building_2x1_e.png",
	trigger_channels = "building",
	visual = "v_base2x1e",
})

Frame:RegisterFrame("f_building2x1f", {
	size = "Medium", race = "robot", index = 1012, name = "Building 2x1 (1M1S)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 4 },
	health_points = 300, --200
	construction_recipe = CreateConstructionRecipe({ metalplate = 20, metalbar = 20, circuit_board = 2 }, 60),
	texture = "Main/textures/icons/frame/building_2x1_f.png",
	trigger_channels = "building",
	visual = "v_base2x1f",
})

Frame:RegisterFrame("f_building2x1g", {
	size = "Medium", race = "robot", index = 1011, name = "Building 2x1 (1M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 4 },
	health_points = 250, --120
	construction_recipe = CreateConstructionRecipe({ metalplate = 12, metalbar = 12, circuit_board = 3 }, 50),
	texture = "Main/textures/icons/frame/building_2x1_g.png",
	trigger_channels = "building",
	visual = "v_base2x1g",
})

data.update_mapping.f_building2x2B = "f_building2x2b"
Frame:RegisterFrame("f_building2x2b", {
	size = "Medium", race = "robot", index = 1023, name = "Building 2x2 (3M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	health_points = 700, -- 300
	visibility_range = 20,
	slots = { storage = 6 },
	component_boost = 50,
	construction_recipe = CreateConstructionRecipe({ energized_plate = 12, icchip = 2 }, 90),
	texture = "Main/textures/icons/frame/Building_2x2_B.png",
	trigger_channels = "building",
	visual = "v_base2x2b",
})

Frame:RegisterFrame("f_building2x2f", {
	size = "Medium", race = "robot", index = 1021, name = "Building 2x2 (2M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 20,
	health_points = 700, --300
	slots = { storage = 8 },
	construction_recipe = CreateConstructionRecipe({ energized_plate = 8, circuit_board = 4 }, 80),
	texture = "Main/textures/icons/frame/building_2x2_F.png",
	trigger_channels = "building",
	visual = "v_base2x2f",
})

local f_building_sim = Frame:RegisterFrame("f_building_sim", {
	size = "Special", race = "robot", index = 1002, name = "Re-Simulator",
	desc = "Reconstructs objects on a simulation level, charged via datacubes",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 30,
	health_points = 3000, -- 400
	slots = { storage = 4, },
	construction_recipe = CreateConstructionRecipe({ circuit_board = 50, hdframe = 50, silicon = 50, crystal_powder = 50 }, 300),
	texture = "Main/textures/icons/frame/3x3_SIM.png",
	trigger_channels = "building",
	visual = "v_building_sim",
	components = {
		{ "c_resimulator", "hidden" },
	},
})

function f_building_sim:on_placed(entity)
	if not Map.IsFrontEnd() and entity.faction.is_player_controlled then
		if FactionCount("built_resimulator", true, entity.faction) and Map.GetSettings().scenario == "Main/Freeplay" then
			entity.faction:RunUI(function()
				local resim_pos = entity.interpolated_center
				local dist_from, dist_add = 4, 5
				local step_1_pos = { x = resim_pos.x, y = resim_pos.y + dist_from,            z = resim_pos.z + 2.0 }
				local step_1_trg = { x = resim_pos.x, y = resim_pos.y,                        z = resim_pos.z - 0.5 }
				local step_2_pos = { x = resim_pos.x, y = resim_pos.y + dist_from + dist_add, z = resim_pos.z + 1.0 }
				local step_2_trg = { x = resim_pos.x, y = resim_pos.y,                        z = resim_pos.z + 1.5 }
				local cutscene = { step_1_pos, step_1_trg, 20000, step_2_pos, step_2_trg }
				PlayCutsceneCamera(cutscene, nil, function (n, f, pos, trg, cnvs) -- circle camera around building instead of interpolating between two points
					if n ~= 6 then return end
					if not cnvs.logoimg then -- fade in game logo
						cnvs.logoimg = cnvs:Add("<Image dock=center image=\"Main/textures/logo/desynced_logo_glow.png\"/>")
						cnvs.logoimg:TweenFromTo("opacity", 0.0, 1.0, 4600)
						cnvs.logoimg:TweenFromTo("y", -350, -200, 5000)
					end
					local dist, pihalf, pidouble = dist_from + f * dist_add, 1.5707963267948966192313216916395, 6.283185307179586476925286766558
					pos[1], pos[2] = trg[1] + math.cos(pihalf + pidouble * f) * dist, trg[2] + math.sin(pihalf + pidouble * f) * dist
				end)
				UI.PlaySound("fx_music_main_menu") -- play title screen music
			end)
		end
		entity.faction:UnlockAchievement("BUILD_RESIM")
	end
end

local f_roamingbot = Frame:RegisterFrame("f_roamingbot", {
	texture = "Main/textures/icons/frame/RobotsUI_IconBot_01.png",
	name = "Curious Bot",
	desc = "---",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 2, },
	movement_speed = 2,
	power = 30,
	health_points = 100, -- 50
	race = "anomaly",
	flags = "AnimateRoot",
	trigger_channels = "bot",
	--production_recipe = CreateProductionRecipe({ metalbar = 5, crystal = 1 }, { c_fabricator = 3 }),
	visual = "v_robot_s",
	--components = { { "c_ai_bot_behavior", "hidden" } },
})

function f_roamingbot:on_interact(entity)
	if entity:CountItem("robot_datacube") > 0 then
		return
	end
	entity:AddItem("robot_datacube", math.random(1, 2))
end


-------------- PLAYER BOTS

Frame:RegisterFrame("f_bot_1s_as", {
	size = "Unit", race = "robot", index = 1012, name = "Scout",
	texture = "Main/textures/icons/frame/bot_1s_ad.png",
	desc = "Advanced high-speed starter bot with a single small socket",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 4, },
	movement_speed = 4,
	start_disconnected = true,
	health_points = 250, -- 150
	power = -2,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ icchip = 1, uframe = 3, fused_electrodes = 2 }, { c_robotics_factory = 60 }),
	visual = "v_bot_1s_as",
	components = { { "c_higrade_capacitor", "hidden" } },
})

Frame:RegisterFrame("f_bot_1s_adw", {
	size = "Unit", race = "robot", index = 1011, name = "Engineer",
	texture = "Main/textures/icons/frame/bot_1s_adw.png",
	desc = "Engineer unit with excellent production speed and extensive upgradeability",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 7,
	slots = { storage = 2, },
	movement_speed = 2,
	component_boost = 200,
	start_disconnected = true,
	health_points = 200, -- 120
	power = -4,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ icchip = 1, uframe = 2, fused_electrodes = 2 }, { c_robotics_factory = 60  }),
	visual = "v_bot_1s_adw",
	components = {
		--{ "c_moduleefficiency", "hidden" },
		{ "c_higrade_capacitor", "hidden" },
		--{ "c_internal_crane", "hidden" },
	}
})

Frame:RegisterFrame("f_bot_2m_as", {
	size = "Unit", race = "robot", index = 1013, name = "Command Center",
	texture = "Main/textures/icons/frame/bot_2m_ad.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 20,
	slots = { storage = 8, },
	movement_speed = 4,
	start_disconnected = true,
	power = -2,
	health_points = 400, -- 150
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_bot_2m_as",
	production_recipe = CreateProductionRecipe({ icchip = 10, uframe = 20, fused_electrodes = 20 }, { c_robotics_factory = 80 }),
	components = { { "c_higrade_capacitor", "hidden" } },
})

Frame:RegisterFrame("f_bot_1s_a", {
	size = "Unit", race = "robot", index = 1002, name = "Worker",
	texture = "Main/textures/icons/frame/bot_1s_a.png",
	desc = "Initial low-tech bots. Mount a single small component and have a single inventory.",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 1, },
	movement_speed = 2,
	start_disconnected = true,
	power = -2,
	health_points = 150, -- 50
	components = { { "c_integrated_capacitor", "hidden" } },
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ circuit_board = 1, metalbar = 5 }, { c_assembler = 35, c_robotics_factory = 20, c_carrier_factory = 35 }),
	visual = "v_bot_1s_a",
})

Frame:RegisterFrame("f_bot_1s_b", {
	size = "Unit", race = "robot", index = 1003, name = "Dashbot",
	texture = "Main/textures/icons/frame/bot_1s_b.png",
	desc = "A faster upgrade to the worker bot with additional inventory",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 2, },
	movement_speed = 4,
	start_disconnected = true,
	power = -3,
	health_points = 200, -- 100
	components = { { "c_integrated_capacitor", "hidden" } },
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ energized_plate = 1, circuit_board = 5 }, { c_robotics_factory = 30 }),
	visual = "v_bot_1s_b",
})

Frame:RegisterFrame("f_bot_2s", {
	size = "Unit", race = "robot", index = 1004, name = "Twinbot",
	texture = "Main/textures/icons/frame/bot_2s_a.png",
	desc = "A bot with two small components to allow complimentary functionality",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 4, },
	movement_speed = 3,
	start_disconnected = true,
	power = -3,
	health_points = 250, -- 150
	flags = "AnimateRoot",
	trigger_channels = "bot",
	components = { { "c_integrated_capacitor", "hidden" } },
	production_recipe = CreateProductionRecipe({ circuit_board = 5, energized_plate = 10, wire = 10 }, { c_robotics_factory = 60 }),
	visual = "v_bot_2s_a",
})

local bot_1m = Frame:RegisterFrame("f_bot_1m_a", {
	size = "Unit", race = "robot", index = 1005, name = "Cub",
	texture = "Main/textures/icons/frame/bot_1m_a.png",
	desc = "This bot is the first to mount a medium component",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 2,
	start_disconnected = true,
	power = -4,
	health_points = 350, -- 200
	flags = "AnimateRoot",
	components = { { "c_integrated_capacitor", "hidden" } },
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ circuit_board = 10, energized_plate = 10, wire = 10 }, { c_robotics_factory = 60 }),
	visual = "v_bot_1m_a",
})


-- misc
local f_dropped_item = Frame:RegisterFrame("f_dropped_item", {
	type = "DroppedItem",
	name = "Dropped Item",
	texture = "Main/textures/icons/values/dropped_item.png",
	start_lootable = true,
})

function f_dropped_item:can_interact(entity, interactor)
	for i,v in ipairs(entity.slots) do
		if v.unreserved_stack > 0 and (interactor:HaveFreeSpace(v.id) or interactor:GetFreeSocket(v.id)) then
			return true
		end
	end
end

function f_dropped_item:on_interact(entity, interactor, retry, only_id, only_amount)
	local items_remain = 0
	for i,v in ipairs(entity.slots) do
		local stack, got = v.stack, 0
		if stack > 0 and (not only_id or v.id == only_id) and (not only_amount or only_amount > 0) then
			got = interactor:TransferFrom(entity, v.id, (only_amount and math.min(stack, only_amount) or stack), true, true)
			if only_amount then only_amount = only_amount - got end
		end
		items_remain = items_remain + stack - got
	end
	if items_remain == 0 then
		entity:Destroy()
	end
end

Frame:RegisterFrame("f_construction", {
	type = "Construction",
	name = "Construction",
	texture = "Main/textures/icons/values/construction.png",
})

local c_foundation = Frame:RegisterFrame("f_foundation", {
	size = "Foundation", race = "robot", index = 1001, name = "Foundation",
	texture = "Main/textures/icons/frame/Foundations_2.png",
	type = "Foundation",
	desc = "The ground foundation that gives a speed boost",
	minimap_color = { 0.3, 0.3, 0.5 },
	construction_recipe = CreateConstructionRecipe({ foundationplate = 1 }, 5),
	cost_modifier = 0.9,
	health_points = 1,
	visual = "v_foundation",
})

c_foundation:RegisterFrame("f_human_foundation1", {
	size = "Foundation", race = "human", index = 3001, name = "Pavement",
	texture = "Main/textures/icons/human/Human_Foundations_01.png",
	visual = "v_human_foundation1",
	construction_recipe = CreateConstructionRecipe({ aluminiumrod = 2, laterite = 5 }, 5),
	cost_modifier = 0.7
})

c_foundation:RegisterFrame("f_human_foundation2", {
	size = "Foundation", race = "human", index = 3021, name = "White Markings",
	texture = "Main/textures/icons/human/Human_Foundations_02.png",
	visual = "v_human_foundation2",
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, }, 5),
	cost_modifier = 0.6
})

c_foundation:RegisterFrame("f_human_foundation3", {
	size = "Foundation", race = "human", index = 3022, name = "Yellow Markings",
	texture = "Main/textures/icons/human/Human_Foundations_03.png",
	visual = "v_human_foundation3",
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, }, 5),
	cost_modifier = 0.6
})

c_foundation:RegisterFrame("f_human_foundation4", {
	size = "Foundation", race = "human", index = 3023, name = "Red Markings",
	texture = "Main/textures/icons/human/Human_Foundations_04.png",
	visual = "v_human_foundation4",
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, }, 5),
	cost_modifier = 0.6
})

c_foundation:RegisterFrame("f_human_foundation5", {
	size = "Foundation", race = "human", index = 3026, name = "Blue Markings",
	texture = "Main/textures/icons/human/Human_Foundations_05.png",
	visual = "v_human_foundation5",
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, }, 5),
	cost_modifier = 0.6
})

c_foundation:RegisterFrame("f_human_foundation6", {
	size = "Foundation", race = "human", index = 3024, name = "Green Markings",
	texture = "Main/textures/icons/human/Human_Foundations_06.png",
	visual = "v_human_foundation6",
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, }, 5),
	cost_modifier = 0.6
})

c_foundation:RegisterFrame("f_human_foundation7", {
	size = "Foundation", race = "human", index = 3025, name = "Purple Markings",
	texture = "Main/textures/icons/human/Human_Foundations_07.png",
	visual = "v_human_foundation7",
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, }, 5),
	cost_modifier = 0.6
})

c_foundation:RegisterFrame("f_human_foundation8", {
	size = "Foundation", race = "robot", index = 1005, name = "Logo Foundation",
	texture = "Main/textures/icons/human/Human_Foundations_08.png",
	visual = "v_human_foundation8",
	cost_modifier = 0.5,
	construction_recipe = CreateConstructionRecipe({ foundationplate = 5, hdframe = 1,  }, 5),
})

c_foundation:RegisterFrame("f_human_foundation9", {
	size = "Foundation", race = "robot", index = 1004, name = "Hex Foundation",
	texture = "Main/textures/icons/human/Human_Foundations_09.png",
	visual = "v_human_foundation9",
	cost_modifier = 0.5,
	construction_recipe = CreateConstructionRecipe({ foundationplate = 5, hdframe = 1,  }, 5),
})

c_foundation:RegisterFrame("f_foundation_basic", {
	size = "Foundation", race = "robot", index = 1002, name = "Foundation (Basic)",
	texture = "Main/textures/icons/frame/Foundations_3.png",
	minimap_color = { 0.3, 0.3, 0.5 },
	construction_recipe = CreateConstructionRecipe({ foundationplate = 2, reinforced_plate = 1,  }, 5),
	cost_modifier = 0.8,
	visual = "v_foundation_basic",
	desc = "The ground foundation that gives a speed boost",
})

c_foundation:RegisterFrame("f_foundation_adv", {
	size = "Foundation", race = "robot", index = 1003, name = "Foundation (Advanced)",
	texture = "Main/textures/icons/frame/Foundations_4.png",
	minimap_color = { 0.3, 0.3, 0.5 },
	cost_modifier = 0.6,
	construction_recipe = CreateConstructionRecipe({ foundationplate = 5, energized_plate = 1,  }, 5),
	desc = "The ground foundation that gives a speed boost",
	visual = "v_foundation_adv",
})

Frame:RegisterFrame("f_human_foundation", {
	size = "Foundation", race = "human", index = 3012, name = "Human Foundation",
	texture = "Main/textures/icons/human/Human_Foundations_1.png",
	type = "Foundation",
	minimap_color = { 0.5, 0.3, 0.3 },
	construction_recipe = CreateConstructionRecipe({ ceramictiles = 1 }, 10),
	cost_modifier = 0.7,
	visual = "v_human_foundation",
})

Frame:RegisterFrame("f_human_foundation_basic", {
	size = "Foundation", race = "human", index = 3011, name = "Basic Human Foundation",
	texture = "Main/textures/icons/human/Human_Foundations_00.png",
	type = "Foundation",
	minimap_color = { 0.5, 0.3, 0.3 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 1 }, 5),
	cost_modifier = 0.9,
	visual = "v_human_foundation_basic",
})

-- explorables
local f_explorable = Frame:RegisterFrame("f_explorable", {
	name = "Explorable",
	visibility_range = 4,
	slots = { storage = 6, },
	minimap_color = { 1, 1, 0 },
	texture = "Main/textures/icons/values/explorable.png",
	is_explorable = true,
	on_destroy = function(self, entity, damager)
		if not damager then return end
		Map.DropItemAt(entity.location, "unstable_matter", math.random(3, 6), "f_dropped_resource")
	end,
	drop_on_deconstruct = function(x, y)
		Map.DropItemAt(x, y, "unstable_matter", math.random(3, 6), "f_dropped_resource")
	end,
})

f_explorable:RegisterFrame("f_human_explorable", {
	name = "Human Explorable",
	minimap_color = { 0.5, 1, 0 },
	race = "human",
})

local f_alien_explorable = f_explorable:RegisterFrame("f_alien_explorable", {
	name = "Alien Explorable",
	texture = "Main/textures/icons/values/alien.png",
	minimap_color = { 1, 0.5, 0.5 },
	shield_type = "obsidian",
	race = "alien",
	construction_recipe = CreateConstructionRecipe({ obsidian = 20, crystal = 10  }, 300),
	on_destroy = function(self, entity, damager)
		if not damager then return end
		Map.DropItemAt(entity.location, "obsidian", math.random(3, 6), "f_dropped_resource")
	end,
	drop_on_deconstruct = function(x, y)
		Map.DropItemAt(x, y, "obsidian", math.random(3, 6), "f_dropped_resource")
	end,
})

f_alien_explorable:RegisterFrame("f_alien_heart_shard", {
	size = "Alien", race = "alien", index = 5022, name = "Heart Shard",
	desc = "The primary structure for an alien base.",
	-- visibility_range = 6,
	-- slots = { storage = 4, },
	-- minimap_color = { 1, 0.5, 0.5 },
	-- texture = "Main/textures/icons/values/building.png",
	visual = "v_explorable_blightanomaly_01",
	-- is_explorable = true,
	------------------------------
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 20,
	health_points = 2000,
	power = 1000,
	slots = { storage = 8, anomaly = 3, },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 30, crystalized_obsidian = 30, energized_artifact = 1 }, 400),
	texture = "Main/textures/icons/alien/alienbuilding_alienheart.png",
	trigger_channels = "building",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_heart_factory", "hidden" },
		{ "c_heart_factory", "hidden" },
		{ "c_alien_field", "hidden" },
		{ "c_alien_heart_repair", "hidden" },
	},
})

f_alien_explorable:RegisterFrame("f_alien_observer", {
	size = "Alien", race = "alien", index = 5016, name = "Alien Observer",
	desc = "Alien structure capable of scanning wide areas and detecting anomalies",
	visibility_range = 80,
	-- slots = { storage = 4, },
	-- minimap_color = { 1, 0.5, 0.5 },
	-- texture = "Main/textures/icons/values/building.png",
	visual = "v_explorable_blightanomaly_02",
	-- is_explorable = true,
	------------
	minimap_color = { 0.9, 0.7, 0.3 },
	health_points = 1000,
	power = -40,
	slots = { storage = 3, anomaly = 1 },
	construction_recipe = CreateConstructionRecipe({ crystalized_obsidian = 20, blight_crystal = 20, energized_artifact = 1 }, 200), -- shaped_obsidian = 20,
	texture = "Main/textures/icons/alien/alienbuilding_observer.png",
	trigger_channels = "building",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_field", "hidden" },
		{ "c_observer_eye", "hidden" }
	},
})

f_alien_explorable:RegisterFrame("f_alien_console", {
	size = "Alien", race = "alien", index = 5023, name = "Console",
	desc = "Alien simulation interface structure",
	-- visibility_range = 6,
	-- slots = { storage = 4, },
	-- minimap_color = { 1, 0.5, 0.5 },
	visual = "v_explorable_blightanomaly_03",
	-- is_explorable = true,
	----------------------------
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 20,
	health_points = 700,
	power = -25,
	slots = { storage = 3, anomaly = 1 },
	construction_recipe = CreateConstructionRecipe({ crystalized_obsidian = 20, plasma_crystal = 10, energized_artifact = 1  }, 250),
	texture = "Main/textures/icons/alien/alienbuilding_console.png",
	trigger_channels = "building",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_field", "hidden" },
		{ "c_admin_shell", "hidden" }
	},
})

f_alien_explorable:RegisterFrame("f_alien_monolith", {
	size = "Alien", race = "alien", index = 5024, name = "Monolith",
	desc = "Primary defense structure",
	-- visibility_range = 6,
	-- slots = { storage = 4, },
	-- minimap_color = { 1, 0.5, 0.5 },
	-- texture = "Main/textures/icons/values/building.png",
	visual = "v_explorable_monolith_02",
	-- is_explorable = true,
	------------------------------
	visibility_range = 20,
	health_points = 4000,
	power = -50,
	slots = { storage = 6, anomaly = 1 },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 20, crystalized_obsidian = 20, energized_artifact = 1 }, 400),
	texture = "Main/textures/icons/alien/alienbuilding_monolith.png",
	trigger_channels = "building",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_field", "hidden" },
		{ "c_monolith_effect", "hidden" },
		{ "c_monolith_lightning", "hidden" },
	},
})

f_alien_explorable:RegisterFrame("f_alien_time_egg", {
	size = "Alien", race = "alien", index = 5021, name = "Time Egg",
	desc = "Special alien item transference structure.",
	visual = "v_explorable_timeegg_01",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 20,
	health_points = 700,
	power = -20,
	slots = { storage = 6, anomaly = 1 },
	construction_recipe = CreateConstructionRecipe({ crystalized_obsidian = 25, blight_crystal = 20, energized_artifact = 1  }, 300),
	texture = "Main/textures/icons/alien/alienbuilding_egg.png",
	trigger_channels = "building",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_field", "hidden" },
		{ "c_time_egg_transference", "hidden" },
	},
})

f_alien_explorable:RegisterFrame("f_explorable_simulator", {
	name = "The Simulator",
	desc = "The Heart of the Nexus Web",
	slots = { },
	minimap_color = { 0.5, 1, 0},
	immortal = true, -- TODO Maybe do this another way later
	health_points = 60000,
	texture = "Main/textures/icons/alien/alienbuilding_simulator.png",
	visual = "v_explorable_blightgiantoddball",
	size = "Mission",
	components = {
		{ "c_virus_cure", "hidden" },
	},
	construction_recipe = false,
	on_interact = function() end, -- like space elevator, don't count visit
	on_placed = function(_, entity)
		local sim = Map.GetSave().the_simulator
		if not sim then Map.GetSave().the_simulator = entity end
	end,
})

data.update_mapping.f_explorable_alien = "f_explorable"

function f_explorable:on_interact(entity, interactor, retry)
	if retry then return end
	local explorable_race = entity.visual_def.explorable_race
	if explorable_race then
		local faction = interactor.faction
		FactionCount("visited_explorable_" .. explorable_race, true, faction)
		if explorable_race == "alien" then
			local visual_id = entity.visual_id
			if visual_id == "v_explorable_blightanomaly_03" then
				if data.codex.x_visited_console then
					faction:Unlock("x_visited_console")
				end
			elseif visual_id == "v_explorable_blightanomaly_02" then
				if data.codex.x_visited_observer then
					faction:Unlock("x_visited_observer")
				end
			elseif visual_id == "v_explorable_timeegg_01" then
				if data.codex.x_visited_time_egg then
					faction:Unlock("x_visited_time_egg")
				end
			elseif visual_id == "v_explorable_monolith_01" then
				if data.codex.x_visited_monolith then
					faction:Unlock("x_visited_monolith")
				end
			elseif visual_id == "v_explorable_blightanomaly_01" then
				if data.codex.x_visited_heart_shard then
					faction:Unlock("x_visited_heart_shard")
				end
			end
		end
	end
	entity.extra_data.visited = true
end

--------- features
Frame:RegisterFrame("f_feature", {
	type = "Decoration",
	name = "Feature",
	cost_modifier = 1,
})

Frame:RegisterFrame("f_blocking_feature", {
	type = "Decoration",
	name = "Land Feature",
	minimap_color = { 0.2, 0.2, 0.2 },
	cost_modifier = -1,
})

local f_damage_plant = Frame:RegisterFrame("f_damage_plant", {
	size = "Other", race = "alien", index = 5002, name = "Power Flower",
	desc = "Flora on the plateau which causes disruptions in power. Can be used to provide excellent defenses.",
	minimap_color = { 1, 1, 0 },
	visual = "v_damage_plant",
	components = { { "c_damage_plant", "hidden" } },
	texture = "Main/textures/icons/frame/powerflower_frame.png",
	construction_recipe = CreateConstructionRecipe({ anomaly_cluster = 1, power_petal = 10 }, 15),
	is_flower = true,
})

function f_damage_plant:on_destroy(entity, damager)
	if not damager or entity.faction.is_player_controlled then return end
	Map.DropItemAt(entity.location, "power_petal", 1, "f_dropped_resource")
end

local f_phase_plant = FrameObsidian:RegisterFrame("f_phase_plant", {
	size = "Other", race = "alien", index = 5001, name = "Phase Flower",
	desc = "Flora on the plateau which causes matter disturbances. Can be used to provide excellent defenses.",
	texture = "Main/textures/icons/frame/phaseflower_frame.png",
	visual = "v_phase_plant",
	minimap_color = { 1, 1, 0 },
	components = { { "c_phase_plant", "hidden" } },
	construction_recipe = CreateConstructionRecipe({ anomaly_cluster = 1, phase_leaf = 10 }, 15),
	is_flower = true,
})

function f_phase_plant:on_destroy(entity, damager)
	-- phase plants drop a leaf even without a damager due to self-destruction by on_trigger of c_phase_plant
	if entity.faction.is_player_controlled then return end
	Map.DropItemAt(entity.location, "phase_leaf", math.random(3), "f_dropped_resource")
end

data.update_mapping.f_trilobyte01 = "f_trilobyte1"
local f_trilobyte1 = FrameCarapace:RegisterFrame("f_trilobyte1", {
	size = "Virus", race = "virus", index = 4001, name = "Trilobyte",
	texture = "Main/textures/icons/bugs/trilobite.png",
	slot_type = "bughole",
	visibility_range = 15,
	movement_speed = 3,
	health_points = 14, -- 7
	slots = { storage = 1 },
	start_disconnected = true,
	trigger_channels = "bot|bug",
	visual = "v_trilobite1",
	components = {
		{ "c_trilobyte_attack", "hidden" },
		{ "c_trilobyte_consume", "hidden" },
	},
	production_recipe = CreateProductionRecipe({ virus_research_data = 1, bug_carapace = 20, silica = 10 }, { c_virus_decomposer = 45 }),
	resource = { 1, 1},
	resource_drop = {"silica", "v_silicascatter_node1" },
	--minimap_color = { 1, 0, 0 },
})

f_trilobyte1:RegisterFrame("f_triloscout", {
	size = "Virus", race = "virus", index = 4002, name = "Triloscout",
	production_recipe = false,
	components = {
		{ "c_trilobyte_attack", "hidden" },
		{ "c_bug_harvest", "hidden" },
	}
})

local f_wasp1 = f_trilobyte1:RegisterFrame("f_wasp1", {
	size = "Virus", race = "virus", index = 4031, name = "Wasp",
	texture = "Main/textures/icons/bugs/toxicWasp.png",
	health_points = 100, -- 7
	cost_modifier = 0,
	slots = { storage = 1 },
	visual = "v_wasp1",
	components = {
		{ "c_wasp_attack1", "hidden" },
	},
	production_recipe = CreateProductionRecipe({ virus_research_data = 1, bug_carapace = 20, silica = 10 }, { c_virus_decomposer = 45 }),
	resource = { 1, 3},
})

f_trilobyte1:RegisterFrame("f_larva1", {
	size = "Virus", race = "virus", index = 4061, name = "Larva",
	texture = "Main/textures/icons/bugs/larva1.png",
	components = {
		{ "c_larva_attack1", "hidden" },
	},
	movement_speed = 2,
	visual = "v_larva1",
	health_points = 1500,
	production_recipe = false,
	resource_drop = false,
	on_destroy = function(self, entity, damager)
		if not damager then return end
		local faction, loc, setreg = entity.faction, entity.location, damager.exists and { coord = damager.location }
		Map.Defer(function()
			for _=1,3 do
				local e = Map.CreateEntity(faction, "f_larva2")
				e:Place(loc)
				if setreg then e:FindComponent("c_turret", true):SetRegister(1, setreg) end
			end
		end)
	end,
	destroy_effect = false,
})

f_trilobyte1:RegisterFrame("f_larva2", {
	size = "Virus", race = "virus", index = 4062, name = "Larva Small",
	texture = "Main/textures/icons/bugs/larva2.png",
	components = {
		{ "c_larva_attack2", "hidden" },
	},
	movement_speed = 3,
	visual = "v_larva2",
	health_points = 800,
	production_recipe = false,
	resource_drop = false
})

f_trilobyte1:RegisterFrame("f_worm1", {
	size = "Virus", race = "virus", index = 4999, name = "Viper Worm",
	texture = "Main/textures/icons/bugs/worm.png",
	components = {
		{ "c_worm_beam", "hidden" },
	},
	movement_speed = 2,
	visual = "v_worm1",
	health_points = 15000,
	resource = { 50, 60 },
	resource_drop = {"bug_carapace", "v_default_item" },
	production_recipe = false,
})

f_trilobyte1:RegisterFrame("f_lucanops1", {
	size = "Virus", race = "virus", index = 4025, name = "Scyther",  -- Mandibore -- Scaravore --Scythe
	texture = "Main/textures/icons/bugs/lucanops.png",
	components = {
		{ "c_lucanops_beam", "hidden" },
		{ "c_virus_protection", "hidden" },
	},
	movement_speed = 7,
	visual = "v_lucanops1",
	health_points = 6000, -- 3500
	production_recipe = false,
	resource = { 6, 8},
	resource_drop = {"silica", "v_silicascatter_node1" },
})

FrameCarapace:RegisterFrame("f_luanops_egg", {
	size = "Virus", race = "virus", index = 4024, name = "Scyther Egg",
	texture = "Main/textures/icons/bugs/egg1.png",
	visibility_range = 10,
	slots = { bughole = 18, storage=4 },
	trigger_channels = "bug|building",
	health_points = 450,
	visual = "v_egg1",
	components = {
		{ "c_egg_hatch", "hidden" },
	},
})

f_trilobyte1:RegisterFrame("f_tetrapuss1", {
	size = "Virus", race = "virus", index = 4071, name = "Mortako", -- Cephalopult --  Tako Taihou -- Mortar
	texture = "Main/textures/icons/bugs/tetrapuss.png",
	components = {
		{ "c_tetrapuss_attack1", "hidden" },
	},
	movement_speed = 3,
	visual = "v_tetrapuss1",
	health_points = 450,
	production_recipe = false,
	resource = { 6, 8},
	resource_drop = {"silica", "v_silicascatter_node1" },
})

f_trilobyte1:RegisterFrame("f_tripodonte1", {
	size = "Virus", race = "virus", index = 4051, name = "Malacostra",  -- Crustacean
	texture = "Main/textures/icons/bugs/tripodonte.png",
	components = {
		{ "c_tripodonte1", "hidden" },
	},
	movement_speed = 3,
	visual = "v_tripodonte1",
	health_points = 2200, -- 1800
	production_recipe = false,
	resource = { 4, 6},
	resource_drop = {"silica", "v_silicascatter_node1" },
})

f_trilobyte1:RegisterFrame("f_trilobyte1a", {
	size = "Virus", race = "virus", index = 4003, name = "Greelobyte",
	texture = "Main/textures/icons/bugs/greelobyte.png",
	health_points = 56,
	visual = "v_trilobite1a",
	production_recipe = CreateProductionRecipe({ virus_research_data = 10, bug_carapace = 20, silica = 10 }, { c_virus_decomposer = 45 }),
	movement_speed = 3.5,
	components = {
		{ "c_trilobyte_attack_t2", "hidden" },
		{ "c_trilobyte_consume", "hidden" },
	},
})

f_trilobyte1:RegisterFrame("f_trilobyte1b", {
	size = "Virus", race = "virus", index = 4004, name = "Trilopew",
	texture = "Main/textures/icons/bugs/trilopew.png",
	health_points = 80,
	visual = "v_trilobite1b",
	production_recipe = false,
	movement_speed = 4,
	components = {
		{ "c_trilobyte_attack_t3", "hidden" },
		{ "c_trilobyte_shield", "hidden"},
		{ "c_trilobyte_consume", "hidden" },
	},
})

f_trilobyte1:RegisterFrame("f_trilobyte_testdummy", { index = 9999, name = "Test Dummy Ground", production_recipe = false, health_points = 65535, components = { {"c_testdummy_healer", "hidden"}},})
f_wasp1:RegisterFrame("f_wasp1_testdummy", { index = 9999, name = "Test Dummy Air", production_recipe = false, health_points = 65535, components = { {"c_testdummy_healer", "hidden"}},})

function f_trilobyte1:on_destroy(entity, damager)
	-- don't do anything unless killed or if this entity belongs to a player controlled faction
	if not damager or entity.faction.is_player_controlled then return end

	local damager_faction = damager.faction -- is nil if damager were destroyed
	if damager_faction then
		if damager_faction.is_player_controlled then
			FactionCount("BugsKilled", 1, damager_faction)
		end
		StabilityAdd(damager_faction, "kill_enemy")
	end

	if not self.resource_drop then return end
	Map.DropItemAt(entity.location, self.resource_drop[1], math.random(self.resource[1], self.resource[2]), "f_dropped_resource", self.resource_drop[2])
end

function f_trilobyte1:on_remove(entity)
	-- when docked, heal a little
	entity:AddHealth((entity.max_health - entity.health) // 2)
end

local f_gastarias1 = f_trilobyte1:RegisterFrame("f_gastarias1", {
	size = "Virus", race = "virus", index = 4011, name = "Scale Worm",
	texture = "Main/textures/icons/bugs/gastarias.png",
	health_points = 300, -- 200 -- 120
	trigger_channels = "bot|bug",
	visual = "v_gastarias1",
	flags = "ClearFoundations",
	movement_speed = 2,
	production_recipe = CreateProductionRecipe({ virus_research_data = 1, bug_carapace = 20, silicon = 10 }, { c_virus_decomposer = 45 }),
	components = {
		{ "c_trilobyte_attack1", "hidden" },
	},
	resource = { 1, 3 },
})

f_gastarias1:RegisterFrame("f_gastarias2", {
	size = "Virus", race = "virus", index = 4012, name = "Shield Worm",
	texture = "Main/textures/icons/bugs/shieldworm.png",
	health_points = 350, -- 200 -- 120
	trigger_channels = "bot|bug",
	visual = "v_gastarias2",
	flags = "ClearFoundations",
	movement_speed = 2,
	production_recipe = false,
	components = {
		{ "c_shieldworm_shield", "hidden" },
		{ "c_trilobyte_attack2", "hidden" },
	},
	resource = { 1, 4 },
})

local f_scaramar1 = f_trilobyte1:RegisterFrame("f_scaramar1", {
	size = "Virus", race = "virus", index = 4021, name = "Malika",
	texture = "Main/textures/icons/bugs/scaramar.png",
	health_points = 200, -- 250 -- 150 -- 400
	trigger_channels = "bot|bug",
	visual = "v_scaramar1",
	movement_speed = 3,
	production_recipe = CreateProductionRecipe({ obsidian_infected = 15, bug_carapace =15 }, { c_hive_spawner = 80 }),
	components = {
		{ "c_trilobyte_attack2", "hidden" },
	},
})

f_scaramar1:RegisterFrame("f_scaramar1_egg", {
	size = "Virus", race = "virus", index = 4023, name = "Female Malika",
	production_recipe = false,
	components = {
		{ "c_trilobyte_attack2", "hidden" },
		{ "c_egg_spawner1", "hidden" },
	},
})

f_trilobyte1:RegisterFrame("f_scaramar2", {
	size = "Virus", race = "virus", index = 4022, name = "Mothika",
	texture = "Main/textures/icons/bugs/mothika.png",
	health_points = 250, -- 150 -- 300
	trigger_channels = "bot|bug",
	visual = "v_scaramar2",
	movement_speed = 2,
	cost_modifier = 0, -- makes it fly
	production_recipe = CreateProductionRecipe({ obsidian_infected = 20, bug_carapace =10 }, { c_hive_spawner = 80 }),
	components = {
		{ "c_trilobyte_attack2", "hidden" },
	},
	resource = { 2, 4 },
})

f_trilobyte1:RegisterFrame("f_gastarid1", {
	size = "Virus", race = "virus", index = 4041, name = "Ravager",
	texture = "Main/textures/icons/bugs/gastarid.png",
	health_points = 1400, -- 850 -- 700
	movement_speed = 3,
	trigger_channels = "bot|bug",
	visual = "v_gastarid1",
	slots = { storage = 8 },
	production_recipe = CreateProductionRecipe({ obsidian_infected = 10, bug_carapace =20 }, { c_hive_spawner = 80 }),
	components = {
		{ "c_trilobyte_attack3", "hidden" },
		{ "c_virus_protection", "hidden" },
		{ "c_virus_claws", "hidden" },
		{ "c_ravager_virus_converter", "hidden" },
	},
	resource = { 2, 4 },
})

local f_charcharosaurus1 = f_trilobyte1:RegisterFrame("f_charcharosaurus1", {
	size = "Virus", race = "virus", index = 4081, name = "Gigakaiju",
	texture = "Main/textures/icons/bugs/gigakaiju.png",
	health_points = 30000, -- 10000
	movement_speed = 6,
	trigger_channels = "bot|bug",
	visual = "v_charcharosaurus1",
	production_recipe = false,
	components = {
		{ "c_trilobyte_attack4", "hidden" },
		{ "c_virus_protection", "hidden" },
	},
})

function f_charcharosaurus1:on_destroy(entity, damager)
	-- don't do anything unless killed or if this entity belongs to a player controlled faction
	if not damager or entity.faction.is_player_controlled then return end

	local damager_faction = damager.faction -- is nil if damager were destroyed
	if damager_faction then
		if damager_faction.is_player_controlled then
			FactionCount("BugsKilled", 1, damager_faction)
		end
		StabilityAdd(damager_faction, "kill_boss")
		damager_faction:UnlockAchievement("KILL_GIGAKAIJU")
	end

	Map.DropItemAt(entity.location, "higgs_broken_core", true)
	Map.DropItemAt(entity.location, "unstable_matter", 100, true)
	Map.DropItemAt(entity.location, "anomaly_particle", 100, true)
end

--------- resources
local function CreateResourceDef(index, name, harvest_id, color, tex)
	return {
		type = "Resource", index = index, name = name,
		texture = tex or "Main/textures/icons/values/resource.png",
		harvest_id = harvest_id,
		minimap_color = color,
	}
end

Frame:RegisterFrame("f_resourcenode_metal",         CreateResourceDef(1, "Metal Ore Deposit",            "metalore",       { 0.3, 0.3, 0.3 }, "Main/textures/icons/frame/resource_metalore.png"))
Frame:RegisterFrame("f_resourcenode_crystal",       CreateResourceDef(2, "Crystal Chunk Deposit",        "crystal",        { 0.3, 0.3, 1.0 }, "Main/textures/icons/frame/resource_crystal.png"))
Frame:RegisterFrame("f_resourcenode_silica",        CreateResourceDef(3, "Silica Sand Deposit",          "silica",         { 1.0, 1.0, 1.0 }, "Main/textures/icons/frame/resource_silica.png"))
Frame:RegisterFrame("f_resourcenode_tree",          CreateResourceDef(4, "Silica Tree",                  "silica",         { 1.0, 1.0, 1.0 }, "Main/textures/icons/frame/resource_silicatree.png"))
Frame:RegisterFrame("f_resourcenode_laterite",      CreateResourceDef(5, "Laterite Ore Deposit",         "laterite",       { 1.0, 0.4, 0.2 }, "Main/textures/icons/frame/resource_laterite.png"))
Frame:RegisterFrame("f_resourcenode_blightcrystal", CreateResourceDef(6, "Blight Crystal Chunk Deposit", "blight_crystal", { 1.0, 0.4, 0.2 }, "Main/textures/icons/frame/resource_blightcrystal.png"))
Frame:RegisterFrame("f_resourcenode_obsidian",      CreateResourceDef(7, "Obsidian Chunk Deposit",       "obsidian",       { 0.7, 0.3, 0.3 }, "Main/textures/icons/frame/resource_obsidian.png"))

f_dropped_item:RegisterFrame("f_dropped_resource", {
	name = "Scattered Resource",
	--flags = "NonSelectable",
})


---------- explorable frames
Frame:RegisterFrame("f_exploreable_bot_glitch", {
	texture = "Main/textures/icons/frame/glitchbot.png",
	name = "Small Bot Glitch",
	slot_type = "garage",
	health_points = 20,
	visibility_range = 20,
	trigger_channels = "bot",
	slots = { storage = 4, },
	movement_speed = 5,
	power = 0,
	race = "anomaly",
	flags = "AnimateRoot",
})

---------- bugs
local f_bug_hive = FrameCarapace:RegisterFrame("f_bug_hive", {
	size = "Hive", race = "virus", index = 4002, name = "Bug Hive",
	texture = "Main/textures/icons/frame/bughive.png",
	visibility_range = 10,
	slots = { bughole = 18, storage=4 },
	trigger_channels = "bug|building",
	health_points = 250,
	visual = "v_bughive",
	components = {
		{ "c_bug_spawn", "hidden" },
		{ "c_virus_protection", "hidden" },
	},
	--minimap_color = { 1, 0, 0 },
})

f_bug_hive:RegisterFrame("f_bug_hive_large", {
	size = "Hive", race = "virus", index = 4003, name = "Large Bug Hive",
	texture = "Main/textures/icons/frame/bughive.png",
	visibility_range = 10,
	slots = { virus = 10, bughole = 27, storage = 8 },
	trigger_channels = "bug|building",
	health_points = 600,
	visual = "v_bughive_large",
	construction_recipe = CreateConstructionRecipe({ bug_carapace = 40, obsidian_infected = 40 }, 80),
	components = {
		{ "c_bug_spawner_large", "hidden" },
		{ "c_virus_cure", "hidden" },
		{ "c_bug_wave_spawner", "hidden" }, -- from Wave Spawn Hive
		{ "c_hive_spawner", "hidden" },  -- from Infected Obsidian Hive
	},
	--minimap_color = { 1, 0, 0 },
})


local f_giant_home = FrameCarapace:RegisterFrame("f_giant_home", {
	size = "Hive", race = "virus", index = 4004, name = "Giant Beast",
	texture = "Main/textures/icons/frame/bughive.png",
	trigger_channels = "bug|building",
	visibility_range = 10,
	health_points = 30,
	visual = "v_bughole",
	--minimap_color = { 1, 0, 0 },
})

-- a place for the bugs to call home without any slots
f_giant_home:RegisterFrame("f_bug_home", {
	size = "Hive", race = "virus", index = 4001, name = "Bug Hole",
})

function f_bug_hive:on_destroy(entity, damager)
	-- don't do anything unless killed or if this entity belongs to a player controlled faction
	if not damager or entity.faction.is_player_controlled then return end

	local loc = entity.location
	Map.DropItemAt(loc, "silica", math.random(10, 20), "f_dropped_resource", "v_silicascatter_node1")

	for _,slot in ipairs(entity.slots) do
		if slot.entity then return end
	end

	local spawner = entity:FindComponent("c_bug_spawn", true)
	if spawner then
		local map_tick, ed_spawned = Map.GetTick(), spawner.extra_data.spawned or 0
		if map_tick - ed_spawned < 900 then return end
	end

	local damager_faction, damager_location = damager.faction, damager.location -- is nil if damager were destroyed
	if not damager_faction or not damager_faction.is_player_controlled then return end

	Map.Defer(function()
		local player_level = GetPlayerFactionLevel(damager_faction)
		local bug_levels = GetBugCountsForLevel(player_level, math.min((player_level // 8)+1, 15))
		for i=1,#bug_levels do
			if bug_levels[i] > 0 then
				for j=1,bug_levels[i] do
					local bug = CreateBugForBugLevel(i)
					bug.has_blight_shield = true
					bug:Place(loc, math.random(3))
					bug:AddComponent("c_bug_homeless", "hidden")
					bug:FindComponent("c_turret", true):SetRegisterCoord(1, damager_location)
				end
			end
		end
	end)
end


local f_bug_hole = FrameCarapace:RegisterFrame("f_bug_hole", {
	texture = "Main/textures/icons/frame/bughole.png",
	name = "Bug Hole",
	visibility_range = 10,
	slots = { bughole = 3, storage=1 },
	trigger_channels = "bug",
	health_points = 30,
	visual = "v_bughole",
	race = "virus",
	--cost_modifier = 2,
	components = {
		{ "c_bug_spawn", "hidden" },
	},
	--minimap_color = { 1, 0, 0 },
})

function f_bug_hole:on_destroy(entity, damager)
	-- don't do anything unless killed or if this entity belongs to a player controlled faction
	if not damager or entity.faction.is_player_controlled then return end

	Map.DropItemAt(entity.location, "silica", math.random(5, 10), "f_dropped_resource", "v_silicascatter_node1")
end


--------------- Generic Alien Buildings
--Frame:RegisterFrame("f_alien_building", {
--	name = "Alien Building",
--	visibility_range = 5,
--	health_points = 100,
--	slots = { storage = 6, },
--	--components = { { "c_glitch", "auto" },},
--})

Frame:RegisterFrame("f_building1x1e", {
	size = "Small", race = "robot", index = 1013, name = "Storage Block (24)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	slots = { storage = 24 },
	health_points = 400, -- 200,
	construction_recipe = CreateConstructionRecipe({ hdframe = 5, icchip = 1 }, 80),
	texture = "Main/textures/icons/frame/building_1x1_e.png",
	trigger_channels = "building",
	visual = "v_base1x1e",
})

Frame:RegisterFrame("f_building2x1b", {
	size = "Large", race = "robot", index = 2, name = "Building 2x1 (1M1L)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 400, -- 300 -- 150
	slots = { storage = 4 },
	construction_recipe = CreateConstructionRecipe({ hdframe = 5, icchip = 1, energized_plate = 4 }, 70),
	texture = "Main/textures/icons/frame/building_2x1_b.png",
	trigger_channels = "building",
	visual = "v_base2x1b",
})

Frame:RegisterFrame("f_building2x1c", {
	size = "Medium", race = "robot", index = 1014, name = "Building 2x1 (2M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 600, -- 300 --150
	slots = { storage = 8 },
	component_boost = 20,
	construction_recipe = CreateConstructionRecipe({ refined_crystal = 5, circuit_board = 4 }, 80),
	texture = "Main/textures/icons/frame/building_2x1_c.png",
	trigger_channels = "building",
	visual = "v_base2x1c",
})

Frame:RegisterFrame("f_building2x1d", {
	size = "Medium", race = "robot", index = 1016, name = "Building 2x1 (1M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 250, -- 150
	slots = { storage = 24 },
	--construction_recipe = CreateConstructionRecipe({ energized_plate = 8, circuit_board = 2 }, 15),
	component_boost = 100,
	construction_recipe = CreateConstructionRecipe({ hdframe = 5, fused_electrodes = 5, icchip = 2 }, 70),
	texture = "Main/textures/icons/frame/building_2x1_d.png",
	trigger_channels = "building",
	visual = "v_base2x1d",
})

data.update_mapping.f_building2x2A = "f_building2x2a"
Frame:RegisterFrame("f_building2x2a", {
	size = "Large", race = "robot", index = 3, name = "Building 2x2 (2M1L)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 20,
	health_points = 800, -- 600 -- 300
	component_boost = 30,
	slots = { storage = 12 },
	construction_recipe = CreateConstructionRecipe({ icchip = 2, hdframe = 5, energized_plate = 8 }, 90),
	texture = "Main/textures/icons/frame/Building_2x2_A.png",
	trigger_channels = "building",
	visual = "v_base2x2a",
})

data.update_mapping.f_building2x2C = "f_building2x2c"
Frame:RegisterFrame("f_building2x2c", {
	size = "Large", race = "robot", index = 4, name = "Building 2x2 (2M1L)",
	minimap_color = { 0.8, 0.8, 0.8 },
	health_points = 1000, -- 700 -- 350
	visibility_range = 20,
	slots = { storage = 16 },
	component_boost = 50,
	construction_recipe = CreateConstructionRecipe({ icchip = 2, fused_electrodes = 10, hdframe = 10 }, 120),
	texture = "Main/textures/icons/frame/building_2x2_c.png",
	trigger_channels = "building",
	visual = "v_base2x2c",
})

data.update_mapping.f_building2x2D = "f_building2x2d"
Frame:RegisterFrame("f_building2x2d", {
	size = "Large", race = "robot", index = 5, name = "Building 2x2 (2M1L)",
	minimap_color = { 0.8, 0.8, 0.8 },
	health_points = 1000, -- 700 -- 350
	visibility_range = 20,
	component_boost = 50,
	slots = { storage = 12 },
	construction_recipe = CreateConstructionRecipe({ icchip = 2, fused_electrodes = 8, hdframe = 5 }, 150),
	texture = "Main/textures/icons/frame/building_2x2_d.png",
	trigger_channels = "building",
	visual = "v_base2x2d",
})

data.update_mapping.f_building2x2E = "f_building2x2e"
Frame:RegisterFrame("f_building2x2e", {
	size = "Medium", race = "robot", index = 1022, name = "Building 2x2 (1M3S)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 20,
	health_points = 1000, -- 700 -- 350
	slots = { storage = 12 },
	component_boost = 50,
	construction_recipe = CreateConstructionRecipe({ icchip = 3, fused_electrodes = 7, hdframe = 5 }, 120),
	texture = "Main/textures/icons/frame/building_2x2_e.png",
	trigger_channels = "building",
	visual = "v_base2x2e",
})

Frame:RegisterFrame("f_building_pf", {
	size = "Special", race = "robot", index = 1005, name = "Particle Forge",
	-- desc = "A powerful building that converts anomaly particles into usable materials",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 30,
	health_points = 2000, -- 1000 -- 400
	slots = {  anomaly = 10 , storage = 4, virus = 2, gas = 2, },
	texture = "Main/textures/icons/frame/building_3x3_pf.png",
	construction_recipe = CreateConstructionRecipe({ uframe = 150, fused_electrodes = 50 }, 500),
	trigger_channels = "building",
	visual = "v_building_pf",
	components = { { "c_particle_forge", "hidden" } }
})

-- Twelve Inventory Transport --

Frame:RegisterFrame("f_transport_bot", {
	size = "Unit", race = "robot", index = 1008, name = "Transport Bot",
	texture = "Main/textures/icons/frame/transport_bot.png",
	desc = "A cargo bot that gives up components in favor of inventory space",
	minimap_color = { 0.9, 0.9, 0.8 },
	health_points = 100, -- 100
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 12 },
	movement_speed = 6,
	start_disconnected = true,
	components = { { "c_higrade_capacitor", "hidden" } },
	flags = "AnimateRoot",
	trigger_channels = "bot",
	power = -3,
	production_recipe = CreateProductionRecipe({ circuit_board = 2, hdframe = 5, optic_cable = 5 }, { c_robotics_factory = 45 }),
	visual = "v_transport_bot",
})

Frame:RegisterFrame("f_bot_1m1s", {
	size = "Unit", race = "robot", index = 1007, name = "Hound",
	texture = "Main/textures/icons/frame/bot_1m1s_a.png",
	desc = "An upgraded version of the Cub, adding a small socket in the back",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	power = -3,
	health_points = 550, -- 250
	slots = { storage = 4, },
	movement_speed = 3,
	start_disconnected = true,
	flags = "AnimateRoot",
	components = { { "c_integrated_capacitor", "hidden" } },
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ circuit_board = 10, hdframe = 5, optic_cable = 2 }, { c_robotics_factory = 80 }),
	visual = "v_bot_1m1s_a",
})

bot_1m:RegisterFrame("f_bot_1m_b", {
	size = "Unit", race = "robot", index = 1006, name = "Hauler",
	texture = "Main/textures/icons/frame/bot_1m_b.png",
	desc = "A bot with a medium socket, excellent speed and expanded storage",
	power = -3,
	slots = { storage = 4, },
	movement_speed = 4,
	start_disconnected = true,
	health_points = 350, -- 200
	production_recipe = CreateProductionRecipe({ circuit_board = 5, hdframe = 5, optic_cable = 5 }, { c_robotics_factory = 80 }),
	components = { { "c_integrated_capacitor", "hidden" } },
	visual = "v_bot_1m_b",
})

bot_1m:RegisterFrame("f_bot_1m_c", {
	size = "Unit", race = "robot", index = 1010, name = "Mark V",
	texture = "Main/textures/icons/frame/bot_1m_c.png",
	desc = "An advanced bot with a medium socket and exceptional speed and capacity",
	slots = { storage = 4, },
	movement_speed = 5,
	start_disconnected = true,
	power = -2,
	health_points = 600, -- 300
	components = { { "c_higrade_capacitor", "hidden" } },
	production_recipe = CreateProductionRecipe({ icchip = 5, uframe = 15, fused_electrodes = 2 }, { c_robotics_factory = 80 }),
	visual = "v_bot_1m_c",
})

Frame:RegisterFrame("f_bot_1l_a", {
	size = "Unit", race = "robot", index = 1009, name = "Rock",
	texture = "Main/textures/icons/frame/bot_1l_a.png",
	desc = "Slow moving but mounts a large component and has exceptional inventory space",
	minimap_color = { 0.9, 0.9, 0.8 },
	health_points = 700, -- 350
	power = -3,
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 8, },
	movement_speed = 2,
	start_disconnected = true,
	components = { { "c_higrade_capacitor", "hidden" } },
	flags = "AnimateRoot|ClearFoliage",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ icchip = 5, hdframe = 10, optic_cable = 20 }, { c_robotics_factory = 80 }),
	visual = "v_bot_1l_a",
})

-- Small Flyer Bot --

Frame:RegisterFrame("f_flyer_bot", {
	size = "Unit", race = "human", index = 3001, name = "Shuttle Bot",
	texture = "Main/textures/icons/frame/flyer_small.png",
	desc = "A bot that flies",
	minimap_color = { 0.9, 0.9, 0.8 },
	health_points = 120, -- 100
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 1 },
	movement_speed = 4,
	start_disconnected = true,
	power = -2,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	production_recipe = CreateProductionRecipe({ micropro = 3, ldframe = 5, engine = 2 }, { c_robotics_factory = 60 }),
	visual = "v_flyer_bot",
	cost_modifier = 0, -- makes it fly
	components = {
		{ "c_higrade_capacitor", "hidden" },
		{ "c_blight_shield", "hidden" },
	},
})

-- DRONES
Frame:RegisterFrame("f_drone_transfer_a", {
	size = "Drone", race = "robot", index = 1001, name = "Drone",
	texture = "Main/textures/icons/frame/drone_transfer_a.png",
	desc = "Small flying transport drone. Must be assigned to a drone port to take orders.",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "drone",
	visibility_range = 3,
	slots = { storage = 1 },
	movement_speed = 4,
	power = -1,
	health_points = 5,
	cost_modifier = 0,
	drone_range = 10,
	is_tethered = true,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_drone_transfer_a",
	production_recipe = CreateProductionRecipe({ circuit_board = 2, hdframe = 1, cable = 1 }, { c_drone_port = 120, c_drone_comp = 120, c_drone_launcher = 80, c_robotics_factory = 100 }),
})

Frame:RegisterFrame("f_drone_transfer_a2", {
	size = "Drone", race = "human", index = 3001, name = "Transfer Drone",
	texture = "Main/textures/icons/frame/drone_transfer_b.png",
	desc = "Small flying transport unit. Must be assigned to a drone port to take orders.",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "drone",
	visibility_range = 5,
	health_points = 5,
	slots = { storage = 1 },
	movement_speed = 6,
	cost_modifier = 0,
	power = -1,
	drone_range = 20,
	is_tethered = true,
	trigger_channels = "bot",
	flags = "AnimateRoot",
	visual = "v_drone_transfer_b",
	production_recipe = CreateProductionRecipe({ micropro = 1, optic_cable = 5, engine = 1 }, { c_drone_port = 120, c_drone_comp = 120, c_drone_launcher = 80, c_robotics_factory = 100 }),
})

Frame:RegisterFrame("f_drone_miner_a", {
	size = "Drone", race = "human", index = 3002, name = "Miner Drone",
	texture = "Main/textures/icons/frame/drone_miner_a.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "drone",
	visibility_range = 5,
	health_points = 5,
	slots = { storage = 1 },
	movement_speed = 3,
	cost_modifier = 0,
	power = -1,
	drone_range = 6,
	is_tethered = true,
	trigger_channels = "bot",
	flags = "AnimateRoot",
	visual = "v_drone_miner_a",
	components = { { "c_miner", "hidden" } },
	production_recipe = CreateProductionRecipe({ micropro = 1, transformer = 1, engine = 1 }, { c_drone_port = 120, c_drone_comp = 120, c_drone_launcher = 80, c_robotics_factory = 100 }),
})

Frame:RegisterFrame("f_drone_adv_miner", {
	size = "Drone", race = "human", index = 3003, name = "Advanced Miner Drone",
	texture = "Main/textures/icons/frame/drone_miner_b.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "drone",
	visibility_range = 5,
	health_points = 5,
	slots = { storage = 1 },
	movement_speed = 3,
	cost_modifier = 0,
	power = -1,
	drone_range = 6,
	is_tethered = true,
	trigger_channels = "bot",
	flags = "AnimateRoot",
	visual = "v_drone_adv_miner",
	components = { { "c_adv_miner", "hidden" } },
	production_recipe = CreateProductionRecipe({ engine = 1, ldframe = 10, micropro = 5 }, { c_drone_port = 120, c_drone_comp = 120, c_drone_launcher = 80, c_robotics_factory = 100 }),
})

Frame:RegisterFrame("f_drone_defense_a", {
	size = "Drone", race = "human", index = 3004, name = "Defense Drone",
	texture = "Main/textures/icons/frame/drone_defense_a.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "drone",
	visibility_range = 5,
	health_points = 75,
	slots = { storage = 1 },
	movement_speed = 6,
	cost_modifier = 0,
	power = -1,
	trigger_channels = "bot",
	drone_range = 6,
	is_tethered = true,
	flags = "AnimateRoot",
	visual = "v_drone_defense_a",
	components = { { "c_defense_drone_turret", "hidden" } },
	production_recipe = CreateProductionRecipe({ icchip = 2, fused_electrodes = 2, engine = 1 }, { c_drone_port = 120, c_drone_comp = 120, c_drone_launcher = 80, c_robotics_factory = 100 }),
})

Frame:RegisterFrame("f_flyer_m", {
	size = "Drone", race = "human", index = 3011, name = "Flyer",
	texture = "Main/textures/icons/frame/flyer_medium.png",
	desc = "A fast flying drone that can perform construction based logistics operations outside of the logistics network when docked in a landing pad",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "flyer",
	health_points = 80,
	trigger_channels = "bot",
	visibility_range = 20,
	slots = { storage = 2 },
	movement_speed = 7,
	cost_modifier = 0,
	power = -5,
	flags = "AnimateRoot|Flyer",
	is_tethered = true,
	visual = "v_flyer_m",
	production_recipe = CreateProductionRecipe({ micropro = 1, ldframe = 5, engine = 2 }, { c_landing_pad = 100, c_robotics_factory = 200 }),
	components = {
		{ "c_higrade_capacitor", "hidden" },
		{ "c_blight_shield", "hidden" },
	},
})

Frame:RegisterFrame("f_satellite", {
	size = "Drone", race = "robot", index = 1011, name = "Satellite",
	texture = "Main/textures/icons/frame/satellite.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "satellite",
	slots = { storage = 5 },
	--movement_speed = 6,
	power = 0,
	health_points = 100,
	--drone_range = 15,
	flags = "Space",
	travel_time = 30 * TICKS_PER_SECOND,
	landing_time = 6 * TICKS_PER_SECOND,
	visual = "v_satellite",
	docked_visual = "v_satellite_inventory",
	launch_effect = "fx_satellitelaunch",
	landing_effect = "fx_satelliteland",
	components = { { "c_satellite", "hidden" }, },
	production_recipe = CreateProductionRecipe({ micropro = 5, ldframe = 10, engine = 5 }, { c_satellite_launcher = 30 }),
	on_placed = function(self, entity)
		Map.DropItemAt(entity, "c_deployer", { bp = { frame = "f_satellite" }, onetime = true }, true)
		entity:Destroy()
	end,
})

Frame:RegisterFrame("f_space_satellite", {
	size = "Drone", race = "human", index = 3021, name = "Small Satellite",
	texture = "Main/textures/icons/frame/satellite_small.png",
	desc = "Small single thruster human satellite.",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "satellite",
	slots = { storage = 3 },
	power = 0,
	health_points = 50,
	--drone_range = 15,
	travel_time = 10 * TICKS_PER_SECOND,
	landing_time = 6 * TICKS_PER_SECOND,
	flags = "Space",
	visual = "v_space_satellite",
	docked_visual = "v_space_satellite_inventory",
	launch_effect = "fx_space_satellitelaunch",
	landing_effect = "fx_space_satelliteland",
	components = { { "c_satellite", "hidden" }, },
	production_recipe = CreateProductionRecipe({ c_micro_reactor = 1, ldframe = 10, engine = 5 }, { c_satellite_launcher = 100, c_space_launcher = 30 }),
	on_placed = function(self, entity)
		Map.DropItemAt(entity, "c_deployer", { bp = { frame = "f_space_satellite" }, onetime = true }, true)
		entity:Destroy()
	end,
})

data.update_mapping.f_building3x2 = "f_building3x2a"
Frame:RegisterFrame("f_building3x2a", {
	size = "Large", race = "robot", index = 6, name = "Building 3x2 (1L3M)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 35,
	health_points = 1200, -- 800 -- 400
	slots = { storage = 12 },
	--construction_recipe = CreateConstructionRecipe({ icchip = 4, energized_plate = 12, hdframe = 10 }, 15),
	component_boost = 100,
	components = { { "c_integrated_power_cell" , "hidden" } }, -- "c_carrier_factory",
	construction_recipe = CreateConstructionRecipe({ icchip = 10, optic_cable = 20, fused_electrodes = 20, uframe = 15 }, 250),
	texture = "Main/textures/icons/frame/building_3x2_a.png",
	trigger_channels = "building",
	visual = "v_base3x2a",
})

Frame:RegisterFrame("f_building3x2b", {
	size = "Medium", race = "robot", index = 1031, name = "Building 3x2 (2M2S)",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 35,
	health_points = 800, -- 400
	slots = { storage = 8 },
	--construction_recipe = CreateConstructionRecipe({ icchip = 1, energized_plate = 10 }, 15),
	-- slots = { storage = 16 },
	components = { { "c_integrated_cell" , "hidden" } }, -- "c_carrier_factory",
	construction_recipe = CreateConstructionRecipe({ icchip = 10, hdframe = 10, refined_crystal = 5, }, 120),
	texture = "Main/textures/icons/frame/building_3x2_B.png",
	trigger_channels = "building",
	visual = "v_base3x2b",
})

Frame:RegisterFrame("f_amac", {
	size = "Special", race = "robot", index = 1003, name = "AMAC",
	desc = "This structure allows for the construction and launching of satellites capable of operating in space.",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 35,
	health_points = 1000, -- 800 -- 400
	construction_recipe = CreateConstructionRecipe({ ldframe = 10, hdframe = 10, micropro = 10, smallreactor = 10 }, 350),
	texture = "Main/textures/icons/frame/Building_Amac_01_XL.png",
	trigger_channels = "building",
	power = -50,
	slots = { storage = 4, },
	components = {
		{ "c_satellite_launcher", "hidden" },
	},
	visual = "v_amac_01_xl",
})

Frame:RegisterFrame("f_virus_teleporter", {
	name = "Virus Teleporter",
	texture = "Main/textures/icons/frame/virus_warp_point.png",
	desc = "A warp bridge that temporarily allows units to transport across large distances using virus teleporters. Virus Source Code can be used to strengthen the connection.",
	race = "virus",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	start_disconnected = false,
	health_points = 10,
	trigger_channels = "bot",
	visual = "v_virus_teleporter",
	components = {
		{ "c_blight_shield", "hidden" },
		{ "c_virus_protection", "hidden" },
	},
})

Frame:RegisterFrame("f_building_fg", {
	size = "Special", race = "robot", index = 1004, name = "Fusion Generator",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 30,
	health_points = 1000,
	slots = { storage = 4 },
	construction_recipe = CreateConstructionRecipe({ uframe = 200, fused_electrodes = 100 }, 600),
	texture = "Main/textures/icons/frame/building_3x3_fg.png",
	trigger_channels = "building",
	visual = "v_building_fg",
	components = {
		{ "c_fusion_generator", "hidden" },
	},
})

Frame:RegisterFrame("f_human_flyer", {
	size = "Unit", race = "human", index = 3010, name = "Human Shuttle",
	texture = "Main/textures/icons/human/human_vehicle_flyer_01.png",
	desc = "An airborne fast-moving human vehicle",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 3, },
	movement_speed = 8,
	cost_modifier = 0, -- makes it fly
	start_disconnected = true,
	power = 0, ---10,
	health_points = 80,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_flyer",
	production_recipe = CreateProductionRecipe({ polymer = 10, smallreactor = 1, engine = 4 }, { c_human_spaceport = 100 }),
})

Frame:RegisterFrame("f_human_lighttank", {
	size = "Unit", race = "human", index = 3003, name = "Light Frame",
	texture = "Main/textures/icons/human/human_vehicle_tank_01.png",
	desc = "A human light fighting vehicle with a gun mount",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 5,
	start_disconnected = true,
	power = -10,
	health_points = 150,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_lighttank",
	production_recipe = CreateProductionRecipe({ aluminiumrod = 10, aluminiumsheet = 10 }, { c_human_commandcenter = 240, c_human_barracks = 80 }),
	components = {
		{ "c_fission_reactor", "hidden" },
	},
})

-------------------------------
--- Producible Human Tank Frame
-------------------------------
Frame:RegisterFrame("f_human_tankframe", {
	size = "Unit", race = "human", index = 3007, name = "Tank Frame",
	texture = "Main/textures/icons/human/human_tank_frame_02.png",
	desc = "A human armoured fighting vehicle with a turret mount",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 4, -- 3
	start_disconnected = true,
	power = -15,
	health_points = 700,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_tank",
	production_recipe = CreateProductionRecipe({ ceramictiles = 20, polymer = 5, smallreactor = 1 }, { c_human_vehiclefactory = 180 }),
	components = {
		{ "c_fission_reactor", "hidden" },
	},
})

-----------------------------------------------------
--- Producible Heavy Tank Frame with 2 medium sockets
-----------------------------------------------------
--[[
Frame:RegisterFrame("f_human_heavy_tankframe", {
	size = "Unit", race = "human", index = 3999, name = "Heavy Tank Frame",
	texture = "Main/textures/icons/human/human_large_tank_frame_02.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 1, },
	movement_speed = 4,
	start_disconnected = true,
	power = -40,
	health_points = 1000,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_heavy_tankframe",
	production_recipe = CreateProductionRecipe({ polymer = 20, micropro = 5, smallreactor = 3 }, { c_human_factory = 300, c_human_vehiclefactory = 80 }),
	components = {
		{ "c_micro_reactor", "hidden" },
	},
})
]]--

---------------------------------------------------
--- Producible Heavy Tank Frame with 1 large socket
---------------------------------------------------
Frame:RegisterFrame("f_human_large_tankframe", {
	size = "Unit", race = "human", index = 3011, name = "Large Tank Frame",
	texture = "Main/textures/icons/human/human_large_tank_frame_02.png",
	desc = "A heavily armoured fighting vehicle with a large turret mount",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 4,
	start_disconnected = true,
	power = -10,
	health_points = 1400,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_large_tankframe",
	production_recipe = CreateProductionRecipe({ polymer = 20, c_micro_reactor = 1, smallreactor = 3 }, { c_human_vehiclefactory = 240 }),
	components = {
		{ "c_fission_reactor", "hidden" },
	},
})

---------------------------------------------------
--- The origial Tank that can be found in Deployers
---------------------------------------------------
Frame:RegisterFrame("f_human_tank", {
	size = "Unit", race = "human", index = 3999, name = "Human Tank",
	texture = "Main/textures/icons/human/human_tank.png",
	desc = "A human armoured fighting vehicle armed with a turret",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 4, -- 3
	start_disconnected = true,
	power = -15,
	health_points = 1000,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_tank",
	-- production_recipe = CreateProductionRecipe({ ldframe = 5, micropro = 1, smallreactor = 1 }, { c_human_factory = 240, c_human_vehiclefactory = 80 }),
	components = {
		{ "c_human_tank_turret", "auto"  },
		{ "c_fission_reactor", "hidden" },
	},
})

---------------------
--- to be removed
---------------------
--[[
Frame:RegisterFrame("f_human_heavy_tank", {
	size = "Unit", race = "human", index = 3999, name = "Human Heavy Tank",
	texture = "Main/textures/icons/human/human_vehicle_tank_01.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 1, },
	movement_speed = 4,
	start_disconnected = true,
	power = -40,
	health_points = 1000,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_heavy_tank",
	production_recipe = CreateProductionRecipe({ polymer = 20, ceramictiles = 10, smallreactor = 3 }, { c_human_factory = 300, c_human_vehiclefactory = 80 }),
	components = {
		{ "c_human_tank_turret" },
		{ "c_human_tank_turret" },
		{ "c_micro_reactor", "hidden" },
	},
})
]]--


Frame:RegisterFrame("f_human_miner", {
	size = "Unit", race = "human", index = 3999, name = "Human Miner Mech",
	texture = "Main/textures/icons/human/human_mech_miner_01.png",
	desc = "Human operated Mech with adaptable fusion beam drillers",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 3,
	start_disconnected = true,
	power = -5,
	health_points = 50,
	trigger_channels = "bot",
	visual = "v_human_miner",
	production_recipe = CreateProductionRecipe({ ldframe = 5, micropro = 1, engine = 1  }, { c_human_barracks = 50, c_human_factory = 150, }),
	components = {
		{ "c_fission_reactor", "hidden" },
		{ "c_human_miner", "hidden" },
	},
})

-- Alien units
local f_alien_soldier = FrameObsidian:RegisterFrame("f_alien_soldier", {
	size = "Unit", race = "alien", index = 5009, name = "Obsidian Soldier",
	desc = "Basic Alien combat unit",
	texture = "Main/textures/icons/alien/alienunit_soldier_a.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 20,
	slots = { storage = 2, anomaly = 1 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 20, energized_artifact = 1 }, { c_alien_factory = 120, c_alien_factory_comp = 180 }),
	movement_speed = 5,
	start_disconnected = true,
	power = 0, -- -10
	health_points = 2000,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_soldier",
	components = {
		{ "c_alien_attack", "hidden" },
		{ "c_alien_powercore", "hidden" },
	},
})

function f_alien_soldier:on_destroy(entity, damager)
	-- don't do anything unless killed
	if not damager then return end

	local faction, loc, rot, damager_loc = entity.faction, entity.location, entity.rotation, damager.location -- is nil if damager were destroyed
	local runto_loc = {
		x = loc.x + (damager_loc and (loc.x - damager_loc.x) or 10) * 5,
		y = loc.y + (damager_loc and (loc.y - damager_loc.y) or 10) * 5,
	}
	Map.Defer(function()
		local aliencore = Map.CreateEntity(faction, "f_alien_worker")  --"f_alienbot"
		aliencore:Place(loc, rot)
		aliencore:MoveTo(runto_loc.x, runto_loc.y)
		Map.Delay("DelayedDestroyEntity", 10, { ent = aliencore, nodrop = true })
	end)
end

------------- Generic Alien Bots

--[[
FrameObsidian:RegisterFrame("f_alienbot", {
	size = "Unit", race = "alien", index = 5999, name = "Alien Unit",
	texture = "Main/textures/icons/alien/alienunit_worker_a.png",
	minimap_color = { 0.8, 0, 0.8 },
	slot_type = "garage", -- slot_type = "alien",
	visibility_range = 8,
	slots = { storage = 4, },
	production_recipe = CreateProductionRecipe({ obsidian = 20 }, { c_alien_feeder = 120 }),
	health_points = 100,
	movement_speed = 4,
	start_disconnected = true,
	flags = "AnimateRoot",
	components = {
		{ "c_alien_core", "hidden" },
		{ "c_alien_miner", "hidden" },
		--{ "c_alien_attack", "auto" },
	},
	visual = "v_empty_alien",
})
--]]

FrameObsidian:RegisterFrame("f_alien_worker", {
	size = "Unit", race = "alien", index = 5006, name = "Alien Worker",
	desc = "Basic Alien unit",
	texture = "Main/textures/icons/alien/alienunit_worker_a.png",
	minimap_color = { 0.8, 0, 0.8 },
	slot_type = "garage",
	visibility_range = 8,
	slots = { storage = 2, anomaly = 1}, -- storage = 4,
	production_recipe = CreateProductionRecipe({ blight_plasma = 20, anomaly_cluster = 1 }, { c_heart_factory = 120, c_alien_droneport = 160 }), -- energized_artifact = 1
	health_points = 100,
	power = 0, -- -1
	movement_speed = 5,
	trigger_channels = "bot",
	start_disconnected = true,
	flags = "AnimateRoot",
	components = {
		{ "c_alien_core", "hidden" },
		{ "c_alien_crane3", "hidden" },
		--{ "c_alien_attack", "auto" },
	},
	visual = "v_empty_alien",
})

--[[
-- old alien worker which is the alien transport

FrameObsidian:RegisterFrame("f_alien_worker", {
	size = "Unit", race = "alien", index = 5999, name = "Alien Worker",
	texture = "Main/textures/icons/alien/alienunit_soldier_a.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	production_recipe = CreateProductionRecipe({ obsidian = 20 }, { c_alien_factory = 120, c_alien_factory_comp = 120 }),
	movement_speed = 3,
	start_disconnected = true,
	power = 0,
	health_points = 10,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_worker",
	components = {
		{ "c_alien_powercore", "hidden" },
	},
})
--]]

FrameObsidian:RegisterFrame("f_hybrid_worker", {
	size = "Unit", race = "alien", index = 5001, name = "Hybrid Worker",
	desc = "Alien unit",
	texture = "Main/textures/icons/alien/alienunit_hybrid_worker.png",
	minimap_color = { 0.8, 0, 0.8 },
	slot_type = "garage",
	visibility_range = 8,
	slots = { storage = 3, anomaly = 1},
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 10, hdframe = 2, anomaly_heart = 1 }, { c_alien_factory_robots = 160 }),
	health_points = 350,
	power = -2,
	movement_speed = 5,
	trigger_channels = "bot",
	start_disconnected = true,
	flags = "AnimateRoot",
	components = {
		{ "c_alien_core", "hidden" },
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_crane2", "hidden" },
	},
	visual = "v_hybrid_worker",
})

FrameObsidian:RegisterFrame("f_alien_transport", {
	size = "Unit", race = "alien", index = 5005, name = "Alien Transport",
	desc = "An Alien vehicle for transporting items and units",
	texture = "Main/textures/icons/alien/alienunit_transport_a.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 12, anomaly = 1, garage = 5 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 15, energized_artifact = 1 }, { c_alien_factory = 120, c_alien_factory_comp = 200 }),
	movement_speed = 3,
	start_disconnected = true,
	power = 0, -- -10
	health_points = 400,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_transport",
	components = {
		{ "c_alien_powercore", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_pincer", {
	size = "Unit", race = "alien", index = 5008, name = "Alien Pincer",
	desc = "An Alien combat unit with integrated teleportation",
	texture = "Main/textures/icons/alien/alienunit_pincer.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, anomaly = 1, garage = 4 },
	power = 0, -- -10
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 20, energized_artifact = 1 }, { c_alien_factory = 120, c_alien_factory_comp = 200 }),
	movement_speed = 4,
	start_disconnected = true,
	health_points = 700,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_pincer",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_plasma_shot", "hidden" },
		{ "c_integrated_teleporter", "hidden" },
	},
})

local f_alien_scout = FrameObsidian:RegisterFrame("f_alien_scout", {
	size = "Unit", race = "alien", index = 5007, name = "Alien Scout",
	desc = "Advanced unit with sensor array and stealth capability",
	texture = "Main/textures/icons/alien/alienunit_scout_a.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 25,
	slots = { storage = 3, anomaly = 1 },
	power = 0, -- -15
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 15, energized_artifact = 1 }, { c_heart_factory = 120, c_alien_factory = 60, c_alien_factory_comp = 100 }),
	movement_speed = 6,
	start_disconnected = true,
	health_points = 450,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_scout",
	components = {
		{ "c_alien_mini_turret", "hidden" },
		{ "c_alien_powercore", "hidden" },
		{ "c_integrated_stealth", "hidden" },
		{ "c_alien_sensor", "hidden" },
	},
})

f_alien_scout:RegisterFrame("f_alien_scout_probe", {
	size = "Unit", race = "alien", index = 5999, name = "Alien Scout Probe",
	movement_speed = 1,
	production_recipe = false,
	on_destroy = function(self, entity, damager)
		if not damager then return end
		Map.DropItemAt(entity.location, "unstable_matter", math.random(35, 45), "f_dropped_resource")

		-- also spawn some soldiers
		local x, y = entity:GetLocationXY()
		Map.Defer(function()
			local soliders = { "f_alien_hvy_soldier", "f_alien_soldier" }
			for i=1,3 do
				local s = Map.CreateEntity(GetAlienFaction(), soliders[math.random(#soliders)])
				s:Place(x + math.random(-3, 3), y + math.random(-3, 3))
				Map.Delay("DelayedDestroyEntity", 300, { ent = s, nodrop = true })
			end
		end)
	end,
})

FrameObsidian:RegisterFrame("f_alien_probe", {
	size = "Drone", race = "alien", index = 5001, name = "Nexus Probe",
	desc = "Alien drone produced by Pylon",
	texture = "Main/textures/icons/alien/alienunit_probe.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "drone",
	visibility_range = 25,
	slots = { storage = 2, anomaly = 2 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 3, plasma_crystal = 1 }, { c_alien_droneport = 40 }),
	movement_speed = 10,
	start_disconnected = false,
	health_points = 50,
	cost_modifier = 0,
	power = 0,
	drone_range = 20,
	is_tethered = true,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_probe",
	components = {
		-- { "c_alien_powercore", "hidden" },
	},
})

Frame:RegisterFrame("f_human_datacomplex", {
	size = "Human", race = "human", index = 3012, name = "Blight Complex",
	desc = "Allows extraction and research of the blight. Must be built deep inside the blight to operate.",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 750,
	power = -750,
	slots = { storage = 8, virus = 3, gas = 3 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 50, steelblock = 50, smallreactor = 5 }, 350),
	texture = "Main/textures/icons/human/Human_Building_5x5_BlightResearch.png",
	-- texture = "Main/textures/icons/human/Human_Building_5x5_BlightResearch.png",
	trigger_channels = "building",
	visual = "v_human_datacomplex",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_blight_extractor", "hidden" },
		{ "c_blight_extractor", "hidden" },
		{ "c_human_datacomplex", "hidden" },
		-- { "c_power_cell", "hidden" },
	},
})

Frame:RegisterFrame("f_human_foundation_adv", {
	size = "Foundation", race = "human", index = 3013, name = "Advanced Human Foundation",
	texture = "Main/textures/icons/human/Human_Foundations_3.png",
	type = "Foundation",
	minimap_color = { 0.5, 0.3, 0.3 },
	construction_recipe = CreateConstructionRecipe({ polymer = 1, }, 5),
	cost_modifier = 0.7,
	visual = "v_human_foundation_adv",
})

Frame:RegisterFrame("f_human_commandcenter", {
	size = "Human", race = "human", index = 3022, name = "Human Command HQ",
	desc = "Command structure with a range of basic functions supporting establishment of base of operations",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 20,
	health_points = 800,
	power = 0, -- -150
	slots = { storage = 16 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 30, polymer = 30, smallreactor = 30 }, 240),
	texture = "Main/textures/icons/human/Human_Building_3x3_CommandHQ.png",
	trigger_channels = "building",
	visual = "v_human_commandcenter",
	components = {
		{ "c_small_fusion_reactor", "hidden" },
		{ "c_human_commandcenter", "hidden" },
		{ "c_human_commandcenter", "hidden" },
	},
	drop_on_deconstruct = function(x, y)
		Map.DropItemAt(x, y, "c_deployer", { bp = { frame = "f_human_commandcenter" }, onetime = true }, true)
	end,
})

Frame:RegisterFrame("f_human_powerplant", {
	size = "Human", race = "human", index = 3023, name = "Human Power Plant",
	desc = "Power plants house fusion reactor cores that produce a tremendous amount of power",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 500,
	power = 0,
	slots = { storage = 4 },
	construction_recipe = CreateConstructionRecipe({ concreteslab =30, ceramictiles = 30, polymer = 30, smallreactor = 30 }, 120),
	texture = "Main/textures/icons/human/Human_Building_2x2_PowerStation.png",
	trigger_channels = "building",
	visual = "v_human_powerplant",
	components = {
		-- { "c_human_powerplant", "hidden" },
		{ "c_fusion_reactor", "hidden" },
		{ "c_internal_transmitter", "hidden" },
		{ "c_internal_transmitter", "hidden" },
		{ "c_internal_transmitter", "hidden" },
		{ "c_internal_transmitter", "hidden" },
	},
})

Frame:RegisterFrame("f_human_refinery", {
	size = "Human", race = "human", index = 3003, name = "Human Refinery",
	desc = "The refinery handles the processing of simple to advanced materials",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 500,
	power = -10, -- -50
	slots = { storage = 8 },
	-- component_boost = 200,
	construction_recipe = CreateConstructionRecipe({ aluminiumsheet = 10, aluminiumrod = 10, }, 100),  -- ldframe = 10, micropro = 2
	texture = "Main/textures/icons/human/Human_Building_2x2_Refinery.png",
	trigger_channels = "building",
	visual = "v_human_refinery",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_human_refinery", "hidden" },
		{ "c_human_refinery", "hidden" },
		-- { "c_human_refinery", "hidden" },
	},
})

Frame:RegisterFrame("f_human_factory", {
	size = "Human", race = "human", index = 3013, name = "Human Factory",
	desc = "Human factories are able to produce hi-tech materials and Human components",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 700,
	power = -10, -- -50
	slots = { storage = 8, },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 20, ceramictiles = 30, gearbox = 5 }, 120),
	texture = "Main/textures/icons/human/Human_Building_3x3_Factory.png",
	trigger_channels = "building",
	visual = "v_human_factory",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_human_factory", "hidden" }
	},
})

Frame:RegisterFrame("f_human_vehiclefactory", {
	size = "Human", race = "human", index = 3014, name = "Vehicle Factory",
	desc = "A factory dedicated specifically to the production of vehicle units",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 800,
	power = -10, -- -50
	slots = { storage = 8, },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 20, ceramictiles = 30, gearbox = 10  }, 180),
	texture = "Main/textures/icons/human/Human_Building_2x2_VehicleFactory_B.png",
	trigger_channels = "building",
	visual = "v_human_vehiclefactory",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_human_vehiclefactory", "hidden" }
	},
})

Frame:RegisterFrame("f_human_barracks", {
	size = "Human", race = "human", index = 3004, name = "Human Barracks",
	desc = "The Barracks handles both the training of Human operators and Mech production",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 800,
	power = -10, -- -50
	slots = { storage = 8, },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 20, steelblock = 20, gearbox = 5  }, 150), --  smallreactor = 10
	-- construction_recipe = CreateConstructionRecipe({ steelblock = 10, ldframe = 10, micropro = 2 }, 120),
	texture = "Main/textures/icons/human/Human_Building_2x2_Barracks.png",
	trigger_channels = "building",
	visual = "v_human_barracks",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_human_barracks", "hidden" }
	},
})

Frame:RegisterFrame("f_human_spaceport", {
	size = "Human", race = "human", index = 3021, name = "Human Spaceport",
	desc = "The production and launch facilities of human aerospace",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 800,
	power = -10,
	slots = { storage = 16, },
	construction_recipe = CreateConstructionRecipe({ polymer = 30, steelblock = 30, ceramictiles = 30, smallreactor = 20  }, 200),
	texture = "Main/textures/icons/human/Human_Building_3x3_SpacePort.png",
	trigger_channels = "building",
	visual = "v_human_spaceport",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_human_spaceport", "hidden" },
		{ "c_space_launcher", "hidden" },
	},
})

Frame:RegisterFrame("f_human_sciencelab", {
	size = "Human", race = "human", index = 3001, name = "Human Science Lab",
	desc = "The science lab is the center of research and communications",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 15,
	health_points = 500,
	power = -10,
	slots = { storage = 8, },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 5, aluminiumsheet = 10}, 90), -- smallreactor = 20
	-- construction_recipe = CreateConstructionRecipe({ ldframe = 10, micropro = 2 }, 120),
	texture = "Main/textures/icons/human/Human_Building_2x2_ScienceLab.png",
	trigger_channels = "building",
	visual = "v_human_sciencelab",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_human_science", "hidden" },
		-- { "c_human_data_processor", "hidden" },
	},
})

Frame:RegisterFrame("f_human_warehouse", {
	size = "Human", race = "human", index = 3002, name = "Human Warehouse",
	desc = "Fusion powered structures store mass volumes of resources and expand the network range",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 20,
	health_points = 600,
	power = -5, -- -20
	slots = { storage = 64 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 20, steelblock = 20 }, 150),
	texture = "Main/textures/icons/human/Human_Building_2x4_Warehouse.png",
	trigger_channels = "building",
	visual = "v_human_warehouse",
	components = {
		{ "c_small_fusion_reactor", "hidden" },
		{ "c_internal_transporter", "hidden" },
	},
})

Frame:RegisterFrame("f_human_communication", {
	size = "Human", race = "human", index = 3011, name = "Multimodal AI Center",
	desc = "A hi-tech and multi-functional building handling micro and macro level networks",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 40,
	health_points = 500,
	power = -10, -- -50
	slots = { storage = 4, anomaly = 3, virus = 4 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 10, steelblock = 10, smallreactor = 5, gearbox = 4 }, 250), -- smallreactor = 10
	texture = "Main/textures/icons/human/Human_Building_2x2_CommsBuilding.png",
	trigger_channels = "building",
	visual = "v_human_sensor_array",
	components = {
		{ "c_micro_reactor", "hidden" },
		{ "c_radar_array", "hidden" },
		-- { "c_radar", "hidden" },
		{ "c_human_aicenter", "hidden" },
		--{ "c_human_explorer_slot1" }
		-- { "c_human_data_processor", "hidden" }
	},
})

Frame:RegisterFrame("f_human_bunker", {
	size = "Human", race = "human", index = 3005, name = "Bunker",
	desc = "Hardened structure equipped with mounted autocannons and advanced network integration. Unit garages provide repairs.",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 40,
	health_points = 1000,
	--power = -20,
	slots = { storage = 2 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 10, steelblock = 10 }, 80),
	texture = "Main/textures/icons/human/human_building_bunker_01.png",
	trigger_channels = "building",
	visual = "v_human_bunker",
	components = {
		{ "c_human_autocannons", "hidden" },
		{ "c_bunker_repair_2", "hidden" },
		{ "c_human_repairkit", "hidden" },
		{ "c_micro_reactor", "hidden" },
		{ "c_internal_field", "hidden" }
	},
})

Frame:RegisterFrame("f_heavy_bunker", {
	size = "Human", race = "human", index = 3015, name = "Heavy Bunker",
	desc = "A more heavily armoured version of the bunker with additional unit repair garages",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 40,
	health_points = 1500,
	--power = -40,
	slots = { storage = 2 },
	construction_recipe = CreateConstructionRecipe({ concreteslab = 30, steelblock = 30, ceramictiles = 30 }, 120),
	texture = "Main/textures/icons/human/human_building_bunker_01.png",
	trigger_channels = "building",
	visual = "v_heavy_bunker",
	components = {
		{ "c_human_autocannons", "hidden" },
		{ "c_bunker_repair_4", "hidden" },
		{ "c_human_repairkit", "hidden" },
		{ "c_micro_reactor", "hidden" },
		{ "c_internal_field", "hidden" }
	},
})

Frame:RegisterFrame("f_human_lander", {
	size = "Unit", race = "human", index = 3012, name = "Human Lander",
	desc = "Versatile dropship and short range explorer vessel capable of establishing a preliminary base of operations",
	texture = "Main/textures/icons/human/Human_Vehicle_Dropship_02.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 8, },
	movement_speed = 2,
	power = -10, -- -150
	cost_modifier = 0, -- makes it fly
	health_points = 800,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_lander",
	production_recipe = CreateProductionRecipe({ concreteslab = 30, polymer = 30, smallreactor = 30 }, { c_human_spaceport = 360 }),
	components = {
		{ "c_small_fusion_reactor", "hidden" },
		{ "c_human_deployment", "hidden" },
	},
})

Frame:RegisterFrame("f_human_carrier", {
	size = "Unit", race = "human", index = 3009, name = "Human Carrier",
	desc = "A fast human operator Mech for short range transportation",
	texture = "Main/textures/icons/human/Human_CarrierMech.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 5,
	slots = { storage = 2, },
	movement_speed = 5,
	start_disconnected = false,
	power = -5,
	health_points = 100,
	trigger_channels = "bot",
	visual = "v_human_carrier",
	production_recipe = CreateProductionRecipe({ aluminiumsheet = 4, aluminiumrod = 4 }, { c_human_barracks = 30, c_human_commandcenter = 150 }),
	components = {
		-- { "c_micro_reactor", "hidden" }
	},
})

Frame:RegisterFrame("f_human_infantrymech", {
	size = "Unit", race = "human", index = 3004, name = "Infantry Mech",
	desc = "Human piloted skirmisher Mech with light support weapons",
	texture = "Main/textures/icons/human/Human_InfantryMech_01.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, },
	movement_speed = 4,
	start_disconnected = true,
	power = -10, -- -20
	health_points = 400,
	trigger_channels = "bot",
	visual = "v_human_infantrymech",
	production_recipe = CreateProductionRecipe({ aluminiumsheet = 3, aluminiumrod = 1, gearbox = 2 }, { c_human_barracks = 30, }),
	components = {
		{ "c_fission_reactor", "hidden" },
		{ "c_human_autocannons", "hidden" },
		{ "c_human_supportlauncher", "hidden" }, },
})

Frame:RegisterFrame("f_human_transport", {
	size = "Unit", race = "human", index = 3006, name = "Human Transport",
	desc = "Human transportation and logistics barge, with network and repair capabilities",
	texture = "Main/textures/icons/human/human_vehicle_transport_01.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 8 },
	movement_speed = 5,
	start_disconnected = true,
	power = -20,
	health_points = 500,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_human_transport",
	production_recipe = CreateProductionRecipe({ aluminiumsheet = 20, aluminiumrod = 20, gearbox = 10 }, { c_human_vehiclefactory = 120 }),
	components = {
		{ "c_fission_reactor", "hidden" },
		{ "c_internal_field", "hidden" },
		{ "c_transport_repair", "hidden" },
		{ "c_human_repairkit", "hidden",}
	},
})

Frame:RegisterFrame("f_human_adv_miner", {
	size = "Unit", race = "human", index = 3002, name = "Miner Mech",
	desc = "Human operated Mech with adaptable fusion beam drillers",
	texture = "Main/textures/icons/human/Human_MiningMech_01.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 3, },
	movement_speed = 3,
	component_boost = 50,
	start_disconnected = true,
	power = -10,
	health_points = 200,
	trigger_channels = "bot",
	visual = "v_human_adv_miner",
	production_recipe = CreateProductionRecipe({ aluminiumsheet = 5, aluminiumrod = 5, }, { c_human_barracks = 50, c_human_commandcenter = 250 }),
	components = {
		{ "c_fission_reactor", "hidden" },
		{ "c_human_miner", "hidden" },
	},
})

---------------------------------------------------------
----- NON-MISSION Human Explorers - Damaged and Undamaged
-------- f_human_explorer_broken repaired and becomes f_human_explorer
-------- f_human_explorer is upgraded in resim and becomes f_human_explorer_upgraded
----------------------------
----------------------------
--- this is not the mission entry - the mission ones are named "f_human_explorer_broken" "f_human_explorer"
--- this is the acutal Human Rover as part of Humanity
------------------------------------------------------------
Frame:RegisterFrame("f_human_rover", {
	size = "Unit", race = "human", index = 3008, name = "Human Rover",
	desc = "Fast scout and exploration vehicle",
	texture = "Main/textures/icons/human/human_rover_02.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 5, },
	movement_speed = 5,
	start_disconnected = true,
	power = -15,
	trigger_channels = "bot",
	health_points = 500,
	visual = "v_human_rover",
	production_recipe = CreateProductionRecipe({ aluminiumrod = 20 , aluminiumsheet = 15 }, { c_human_commandcenter = 240, c_human_vehiclefactory = 60 }),
	components = {
		{ "c_fission_reactor", "hidden" },
		{ "c_radar_suite", "hidden" },
		-- { "c_light_cannon", "hidden" },
	},
})

---------------------------------------------------------
--- this is not the mission entry - the mission ones are named "f_human_explorer_upgraded"
--- this is the acutal Human AI Explorer as part of Humanity
---------------------------------------------------------
Frame:RegisterFrame("f_human_AI_explorer", {
	size = "Unit", race = "human", index = 3005, name = "Human AI Explorer",
	desc = "Advanced rover with a hi-tech data acquisition and transfer suite",
	texture = "Main/textures/icons/human/human_ai_explorer_02.png",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 5, virus = 3},
	movement_speed = 4,
	start_disconnected = true,
	power = -20, -- -10
	trigger_channels = "bot",
	health_points = 500,
	visual = "v_human_aiexplorer",
	components = {
		{ "c_small_scanner", "hidden" },
		{ "c_mission_human_docker", "hidden" },
		{ "c_intel_extractor", "hidden" },
		{ "c_blight_shield", "hidden" },
		{ "c_human_explorer_slot2", "hidden"},
		{ "c_fission_reactor", "hidden" },
	},
	production_recipe = CreateProductionRecipe({ c_micro_reactor = 1, transformer = 5 , polymer = 20 }, { c_human_vehiclefactory = 100  }),
})

-----------------------------------------------------------
---------- Produces Anomlay Particles from Blight Crystal
-----------------------------------------------------------
FrameObsidian:RegisterFrame("f_alien_extractor", {
	size = "Alien", race = "alien", index = 5001, name = "Soulweaver", -- Anomaly Extractor
	desc = "This structure draws anomaly particles from blight crystal and forms anomaly clusters",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 800,
	power = 0, -- -25,
	slots = { storage = 6, anomaly = 4 },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 20, blight_crystal = 20, energized_artifact = 1 }, 200), -- f_alien_worker = 1
	texture = "Main/textures/icons/alien/alienbuilding_2x2_extractor.png",
	trigger_channels = "building",
	visual = "v_alien_extractor",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_converter", "hidden" },
		{ "c_alien_converter", "hidden" },
	},
})

-----------------------------------
---------- Produces Blight Plasma
-----------------------------------
FrameObsidian:RegisterFrame("f_alien_feeder", {
	size = "Alien", race = "alien", index = 5004, name = "Plasma Bloom", -- Feeder
	desc = "Plasma production building",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 800,
	power = 0, -- -25,
	slots = { storage = 4, anomaly = 2 },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 25, energized_artifact = 1 }, 150), -- f_alien_worker = 1
	texture = "Main/textures/icons/alien/alienbuilding_2x2_feeder.png",
	trigger_channels = "building",
	visual = "v_alien_feeder",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_feeder", "hidden" },
		{ "c_bloom_producer", "hidden"},
	},
})

-----------------------------------
---------- Constructs Alien Units
-----------------------------------
FrameObsidian:RegisterFrame("f_alien_producer", {
	size = "Alien", race = "alien", index = 5006, name = "Formation Crucible", -- producer
	desc = "Primary unit production building",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 700,
	power = 0, -- -25,
	slots = { storage = 5, anomaly = 2 },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 30, energized_artifact = 1 }, 200), -- anomaly_particle = 10
	texture = "Main/textures/icons/alien/alienbuilding_2x2_producer.png",
	trigger_channels = "building",
	visual = "v_alien_producer",
	components = {
		{ "c_alien_factory", "hidden" },
		{ "c_alien_powercore", "hidden" },
	},
})

----------------------------------
---------- Alien Research Uplink
----------------------------------
FrameObsidian:RegisterFrame("f_alien_researcher", {
	size = "Alien", race = "alien", index = 5003, name = "Nexaspire", -- research building - Noospire
	desc = "Alien structure for research and communications",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 700,
	slots = { storage = 5, anomaly = 1 },
	power = 0, -- -25,
	construction_recipe = CreateConstructionRecipe({ obsidian_brick = 20, energized_artifact = 1 }, 80),
	texture = "Main/textures/icons/alien/alienbuilding_2x2_research.png",
	trigger_channels = "building",
	visual = "v_alien_researcher",
	components = {
		{ "c_alien_research", "hidden" },
		{ "c_alien_powercore", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_sensortower", {
	size = "Alien", race = "alien", index = 5013, name = "Sensor Spike", -- sensor tower
	desc = "Alien wave receptor",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 35,
	health_points = 300,
	slots = { storage = 1, anomaly = 1 },
	power = 0, -- -5,
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 15, plasma_crystal = 20, energized_artifact = 1 }, 60), -- shaped_obsidian = 30
	texture = "Main/textures/icons/alien/alienbuilding_sensortower.png",
	trigger_channels = "building",
	visual = "v_alien_sensortower",
	components = {
		{ "c_blight_terraformer", "hidden" },
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_sensor_wide", "hidden" },
		{ "c_sensortower_effect", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_socketbuilding", {
	size = "Alien", race = "alien", index = 5015, name = "Symbiotech", -- socket building
	desc = "Evolved structure to be able to socket components",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 1000,
	slots = { storage = 5, anomaly = 1, virus = 1, gas = 1 },
	power = 0, -- -25,
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 20, blight_crystal = 30, energized_artifact = 1 }, 200),
	texture = "Main/textures/icons/alien/alienbuilding_symbiotech.png",
	trigger_channels = "building",
	visual = "v_alien_socketbuilding",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_socketbuilding_effect", "hidden" },
	},
})

-----------------------------------
------------------ Alien Refinery
-----------------------------------
FrameObsidian:RegisterFrame("f_alien_reformingpool", {
	size = "Alien", race = "alien", index = 5012, name = "Reforming Pool", -- refinery
	desc = "Structure capable reconstructing and refining raw materials",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 800,
	slots = { storage = 5, anomaly = 1, garage = 2 },
	power = 0, -- -25,
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 25, anomaly_cluster = 2, energized_artifact = 1 }, 180),
	texture = "Main/textures/icons/alien/alienbuilding_reformingpool.png",
	trigger_channels = "building",
	visual = "v_alien_reformingpool",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_reforming_pool", "hidden" },
		{ "c_synthesis_pool", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_miner", {
	size = "Unit", race = "alien", index = 5004, name = "Drill Spike", -- miner
	desc = "Alien structure capable of harvesting most resources",
	slot_type = "garage",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 10,
	health_points = 1500,
	component_boost = 300,
	movement_speed = 2,
	power = 0, -- -30,
	start_disconnected = true,
	slots = { storage = 5, anomaly = 2 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 20, energized_artifact = 1 }, { c_heart_factory = 120, c_alien_factory = 90, c_alien_factory_comp = 320 }),
	texture = "Main/textures/icons/alien/alienbuilding_2x2_miner.png",
	trigger_channels = "bot",
	visual = "v_alien_miner",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_miner", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_turret", {
	size = "Unit", race = "alien", index = 5010, name = "Sentinel Tower", -- defense turret
	desc = "Alien base mobile defense structure",
	slot_type = "garage",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 25,
	health_points = 3000,
	movement_speed = 2,
	power = 0, -- -10,
	slots = { storage = 2, anomaly = 1 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 25, plasma_crystal = 10, energized_artifact = 1 }, { c_heart_factory = 160, c_alien_factory = 200, c_alien_factory_comp = 320  }),
	texture = "Main/textures/icons/alien/alienbuilding_defense_turret.png",
	trigger_channels = "building",
	visual = "v_alien_turret",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_sentinel_lance", "hidden" },
		{ "c_turret_building_effect", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_teleporter", {
	size = "Alien", race = "alien", index = 5014, name = "Nexus Warp", -- teleporter
	desc = "Transport units across large distances",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 700,
	slots = { storage = 4, anomaly = 1 },
	power = 0, -- -10,
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 20, plasma_crystal = 50, energized_artifact = 1 }, 200),
	texture = "Main/textures/icons/alien/alienbuilding_teleporter.png",
	trigger_channels = "building",
	visual = "v_alien_teleporter",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_teleporter", "hidden" },
		{ "c_nexus_teleporter_effect", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_pylon", {
	size = "Alien", race = "alien", index = 5005, name = "Pylon",
	desc = "Structure terraforms land to blight and expands the network",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 15,
	health_points = 500,
	power = 0, -- -5,
	slots = { storage = 4, anomaly = 2 },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 15, energized_artifact = 1 }, 80),
	texture = "Main/textures/icons/alien/alienbuilding_pylon.png",
	trigger_channels = "building",
	visual = "v_alien_pylon",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_terraformer", "hidden" },
		{ "c_alien_droneport", "hidden" },
		{ "c_alien_field", "hidden" },
		{ "c_pylon_effect", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_storage", {
	size = "Alien", race = "alien", index = 5011, name = "Storage Pods",
	desc = "Alien pods for storage",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 10,
	health_points = 700,
	power = 0, -- -15,
	slots = { storage = 14, anomaly = 4 },
	construction_recipe = CreateConstructionRecipe({ shaped_obsidian = 20, energized_artifact = 1 }, 200),
	texture = "Main/textures/icons/alien/alienbuilding_storage.png",
	trigger_channels = "building",
	visual = "v_alien_storage",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_deconstructor", "hidden" },
		{ "c_alien_storage_effect", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_smallframe", {
	size = "Unit", race = "alien", index = 5003, name = "Small Obsidian Tank Frame",
	desc = "An Alien combat vehicle with a turret mount",
	texture = "Main/textures/icons/alien/alienunit_tankframe.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 20,
	slots = { storage = 2, anomaly = 1 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 10, energized_artifact = 1 }, { c_alien_factory_robots = 200, c_alien_factory = 100, c_alien_factory_comp = 150 }),
	movement_speed = 5,
	start_disconnected = true,
	power = 0, -- -10,
	health_points = 1000,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_smallframe",
	components = {
		{ "c_alien_powercore", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_tankframe", {
	size = "Unit", race = "alien", index = 5011, name = "Obsidian Tank Frame",
	desc = "A heavy Alien combat vehicle with a turret mount",
	texture = "Main/textures/icons/alien/alienunit_tankframe.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 20,
	slots = { storage = 2, anomaly = 1 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 10, crystalized_obsidian = 10, energized_artifact = 1 }, { c_alien_factory = 120, c_alien_factory_comp = 180 }),
	movement_speed = 4,
	start_disconnected = true,
	power = 0, -- -20,
	health_points = 1600,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_tankframe",
	components = {
		{ "c_alien_powercore", "hidden" },
	},
})

f_alien_scout:RegisterFrame("f_hybrid_alien_soldier", {
	size = "Unit", race = "alien", index = 5002, name = "Hybrid Obsidian Soldier",
	desc = "Alien soldier unit combining robot and alien technology",
	texture = "Main/textures/icons/alien/alienunit_hybridsoldier.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 15,
	slots = { storage = 2, anomaly = 1 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 20, hdframe = 10, anomaly_heart = 1 }, { c_alien_factory_robots = 160 }),
	movement_speed = 4,
	start_disconnected = true,
	power = 0, -- -10,
	health_points = 800,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_hybrid_alien_soldier",
	components = {
		{ "c_alien_ripper", "hidden" },
		{ "c_alien_powercore", "hidden" },
	},
})

f_alien_scout:RegisterFrame("f_alien_hvy_soldier", {
	size = "Unit", race = "alien", index = 5012, name = "Heavy Obsidian Soldier",
	desc = "Heavy Alien soldier unit",
	texture = "Main/textures/icons/alien/alienunit_heavysoldier.png",
	minimap_color = { 0.9, 0.7, 0.3 },
	slot_type = "garage",
	visibility_range = 20,
	slots = { storage = 2, anomaly = 1 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 25, crystalized_obsidian = 5, energized_artifact = 1 }, { c_alien_factory = 160, c_alien_factory_comp = 280 }),
	movement_speed = 5,
	start_disconnected = true,
	power = 0, -- -20,
	health_points = 2500,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	visual = "v_alien_hvy_soldier",
	components = {
		{ "c_fusion_bolt", "hidden" },
		{ "c_alien_powercore", "hidden" },
	},
})

FrameObsidian:RegisterFrame("f_alien_powergenerator", {
	size = "Alien", race = "alien", index = 5002, name = "Blight Power Nova",
	desc = "Alien mass power generator",
	minimap_color = { 0.9, 0.7, 0.3 },
	visibility_range = 10,
	health_points = 800,
	movement_speed = 4,
	start_disconnected = true,
	power = 0,
	slots = { storage = 4, anomaly = 2 },
	production_recipe = CreateProductionRecipe({ shaped_obsidian = 30, plasma_crystal = 15, energized_artifact = 1 }, { c_heart_factory = 160, c_alien_factory = 200, c_alien_factory_comp = 300 }),
	texture = "Main/textures/icons/alien/alienbuilding_powergenerator.png",
	trigger_channels = "bot",
	visual = "v_alien_powergenerator",
	components = {
		{ "c_alien_powercore", "hidden" },
		{ "c_alien_powergenerator", "hidden" },
	},
})

Frame:RegisterFrame("f_carrier_bot", {
	size = "Unit", race = "robot", index = 1001, name = "Runner",
	texture = "Main/textures/icons/frame/carrier_bot.png",
	desc = "A small cargo bot for moving items",
	minimap_color = { 0.9, 0.9, 0.8 },
	health_points = 5,
	slot_type = "garage",
	visibility_range = 5,
	slots = { storage = 1 },
	movement_speed = 3,
	start_disconnected = false,
	flags = "AnimateRoot",
	trigger_channels = "bot",
	power = -2,
	production_recipe = CreateProductionRecipe({ metalplate = 3, crystal = 3 }, { c_carrier_factory = 10, c_assembler = 15 }),
	visual = "v_carrier_bot",
})
