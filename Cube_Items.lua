

-- alternative  recipes.
---@param id string of original item 
---@param recipe table recipe from CreateProductionRecipeWithWaste ect
---@param overide_values table of values to overwite ect {desc = "New Desc"}
local function create_alt_recipe(id,recipe,overide_values)
	local item = Tool.Copy(data.items[id])
	item.production_recipe = recipe
	item.alt_item = id
	for key, val in pairs(overide_values) do
		item[key] = val
	end
	item.race = 'human'
	data.items[id.."_alt"] = item
	data.items[id].has_alt = id.."_alt"
end
-- create slot for cube
data.item_slot_icons["cube"] = "Main/skin/Icons/Special/Technologies/Robots.png"
-- add cube category 
data.categories[#data.categories+1] = { name = "Cube", tab = "item",  defs = data.items,  filter_field = "tag", filter_val = "cube"   }

--------------------------------------
---- Update Cube Existing Items -----------

-- Blue Cube items 
data.items.crystal_powder.production_recipe = CreateProductionRecipeWithWaste({ic_cube_blue = 1, crystal = 40,  }, {cc_manifest = 100}, 20, {ic_cube_empty = 1})
data.items.crystal_powder.desc = "At the right frequency crystal will resonate with the cube inducing a cascade failure at the intermolecular level"
create_alt_recipe("crystal_powder",
	CreateProductionRecipeWithWaste(
	{ic_cube_blue = 1, crystal = 100, ic_soul_angry = 5}, 
	{cc_manifest = 25, cc_red_furnace = 5},
	50, {ic_cube_empty = 1}),
	{desc = "Bulk Crystal Refraction"}
)
data.items.datakey_robot = {
	name = "Cube Log",
	index = 1010,
	desc = "The Cube holds histories of the past.  There is surely knowladge to be gained there",
	tag = "research",
	texture = "Main/textures/icons/items/datakey_robot.png",
	visual = "v_gears",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipeWithWaste({ ic_cube_blue = 1, metalplate = 5 }, { cc_manifest = 25, cc_green_brain = 5 }, 5, {ic_cube_blue = 1}),
}
create_alt_recipe("datakey_robot",
	CreateProductionRecipeWithWaste(
	{ic_cube_empty = 1, reinforced_plate = 20, }, 
	{cc_green_brain = 25 , cc_red_furnace = 5},
	20, {ic_cube_blue = 1}),
	{desc = "Bulk Cube Log Filling"}
)
-- Red Cube items
data.items.reinforced_plate.production_recipe = CreateProductionRecipeWithWaste(
{ic_cube_red = 1, steelblock = 100, crystal_powder = 10, wire = 10  }, 
{cc_manifest = 120, cc_red_furnace = 50}, 20, {ic_cube_empty = 1})
create_alt_recipe("reinforced_plate",
	CreateProductionRecipeWithWaste(
	{ic_cube_red = 1, steelblock = 100, laterite = 60, ic_soul_plasma = 100, wire = 40  }, 
	{cc_manifest = 50, cc_red_furnace = 5},
	20, {ic_cube_empty = 1}),
	{desc = "Bulk Metal Smelting"}
)
--- Green cube 
data.items.phase_leaf.production_recipe = false
data.items.phase_leaf.tag = "resource"
data.items.phase_leaf.race = "virus"

data.items.wire.name = "Neurotic Reed Fibre"
data.items.wire.desc = "Conductive reed fibre, wound and ready for higher conceptualization"
data.items.wire.production_recipe = false
data.items.wire.race = "virus"
--- AntiCube 
data.items.ldframe.name = "AntiPhysics Frame"
data.items.ldframe.desc = "A Contained AntiCube ready for connection to a bot chassis"
data.items.ldframe.race = "robot"
data.items.ldframe.production_recipe = CreateProductionRecipe(
{ reinforced_plate = 6, phase_leaf = 4,ic_cube_sphere = 1, wire = 4 }, { cc_manifest = 20 }, 1)


--------------------------------------
---- Update Non Cube Existing Items -----------
data.items.crystal.name = "Resonance Crystal"

data.items.metalplate.production_recipe = CreateProductionRecipe({metalore = 2}, {c_fabricator = 30}, 1)
data.items.laterite.mining_recipe = CreateMiningRecipe({c_miner = 30, c_adv_miner = 15})

data.items.steelblock.name = "Steel Beams"
data.items.steelblock.desc = "The Trusty I beam. A Pylon of Civilization"
data.items.steelblock.production_recipe = CreateProductionRecipe(
{metalplate = 4, crystal = 1  }, {c_fabricator = 30, cc_red_furnace = 10}, 2)
data.items.steelblock.texture = "The_Cube_WIP/textures/steel_beam.png"
data.items.steelblock.race = nil
data.items.steelblock.tag = "simple_material"
create_alt_recipe("steelblock",
	CreateProductionRecipeWithWaste(
	{laterite = 40, metalplate = 20, ic_cube_red = 1}, 
	{cc_red_furnace = 25},
	20, {ic_cube_empty = 1}),
	{desc = "Laterite Steel Alloy"}
)

data.items.concreteslab.desc = "With Concrete and Steel Humans ruled the world. Now all thats left is their ruins"
data.items.concreteslab.production_recipe = CreateProductionRecipe({steelblock = 4, metalore = 4  }, {c_fabricator = 30}, 4)
data.items.concreteslab.tag = "simple_material"
create_alt_recipe("concreteslab", 
	CreateProductionRecipe(
	{laterite = 4, steelblock = 1}, 
	{c_fabricator = 25},
	1),
	{desc = "Laterite Concrete Mixing"}
)
data.items.beacon_frame.production_recipe = CreateProductionRecipe({steelblock = 5, datakey_robot = 1}, {c_fabricator = 40, c_assembler = 30}, 1)

data.items.engine.production_recipe = CreateProductionRecipe(
{reinforced_plate = 4, wire = 6 , datakey_robot = 1, ic_soul_angry = 1}, {c_assembler = 120, cc_green_brain = 80}, 1)
data.items.engine.race = "robot"

data.items.fused_electrodes.name = "Superconductor"
data.items.fused_electrodes.desc = "This Material is beyond our current understanding\nItleast we know we will eventually be able to manufacture it"
data.items.fused_electrodes.production_recipe = false

--------------------------------------
---- CUBE! -----------

data.items.ic_cube_blue = {
	name = "THE CUBE",
	index = 1000,
	desc = "<bl>Limitless Potential</>",
	locked_desc = "",
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "Main/textures/icons/items/robot_research_cube.png",
	visual = "vc_cube_blue",--"v_robot_data",
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_cube_green = 1, crystal = 20 }, { cc_manifest = 50 },1,{ic_cube_blue = 1}),
	--v_robot_data
}

data.items.ic_cube_empty = {
	name = "DORMANT CUBE",
	index = 1001,
	desc = "<bl>THE CUBE IS EMPTY</>",
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "The_Cube_WIP/textures/cube_blue_drained.png",
	visual = "v_gears",
	--production_recipe = CreateProductionRecipe({ ic_cube_blue = 1, hdframe = 1 }, { c_robotics_factory = 200, }),
}
data.items.ic_cube_red = {
	name = "FURY CUBE",
	index = 1002,
	desc = "<rl>THE CUBE IS HOT</>",
	locked_desc = "Find a fissure to the underworld\nBoil a sleeping cube in its hellfire",
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "Main/textures/icons/items/alien_datacube.png",
	visual = "v_alien_data",
	--production_recipe = CreateProductionRecipe({ crystal_powder = 2, hdframe = 1 }, { c_robotics_factory = 200, }),
}
data.items.ic_cube_green = {
	name = "RESTLESS CUBE",
	index = 1002,
	desc = "<hl>THE CUBE IS RESTLESS</>\nSpeeds up holding unit",
	locked_desc = "Find a large weed in the plains and claim a cutting",
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "Main/textures/icons/items/virus_research_data.png",
	visual = "v_virus_data",
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_cube_blue = 1, crystal_powder = 1 }, { cc_manifest = 200, },1, {ic_cube_green = 1}),--phase_leaf = 6
}
create_alt_recipe("ic_cube_green", 
	CreateProductionRecipeWithWaste(
	{ic_cube_empty = 1, ic_soul_plasma = 16}, 
	{cc_manifest = 25,},
	1,
	{ic_cube_empty = 1}),
	{desc = "Alternative Soul Plasma Conversion"}
)
data.items.ic_cube_sphere = {
	name = "ANTI-CUBE",
	index = 1004,
	desc = [[<hl>Heresey, there is a sphere inside the cube!</>
<rl>WARNING: extremly unstable around the Cube</>
	]],
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "Main/textures/icons/alien/alienunit_worker_a.png",
	visual = 'vc_cube_sphere_item',
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_cube_red = 1, ic_soul_plasma = 100,  }, 
	{ cc_manifest = 200, }, 1, {ic_cube_sphere = 1, ic_cube_empty = 1}),
	--production_recipe = CreateProductionRecipeWithWaste(
	-- { ic_cube_blue = 1, crystal = 1, }, { cc_manifest = 200, cc_red_furnace = 50},
	-- 1, {ic_cube_sphere = 1, ic_cube_empty = 1}),
	alt_item = "datakey_robot",
}
-- data.items.ic_cube_yellow = {
-- 	name = "TEMPERED CUBE",
-- 	index = 1003,
-- 	desc = "A cube half full",
-- 	tag = "cube",
-- 	slot_type = "cube",
-- 	stack_size = 1,
-- 	race = "alien",
-- 	texture = "Main/textures/icons/items/human_datacube.png",
-- 	visual = "v_human_data",
-- 	production_recipe = CreateProductionRecipeWithWaste({ ic_soul_angry = 1, ic_soul_happy = 1, ic_cube_red = 1 }, { cc_manifest = 200, cc_green_brain = 100 },1,{ic_cube_yellow = 1}),
-- }
-- data.items.ic_cube_pink = {
-- 	name = "HYPER CUBE",
-- 	index = 1003,
-- 	desc = "A cube half full",
-- 	tag = "cube",
-- 	slot_type = "cube",
-- 	stack_size = 1,
-- 	race = "alien",
-- 	texture = "The_Cube_WIP/textures/robot_research_cube_ghost.png",
-- 	visual = "v_blight_plasma",
-- 	production_recipe = CreateProductionRecipeWithWaste({ ic_cube_green = 1, phase_leaf = 20 }, { cc_manifest = 200, },1,{ic_cube_pink = 1}),
-- }
-- data.items.ic_cube_purple = {
-- 	name = "POSI-CUBE",
-- 	index = 1003,
-- 	desc = "THE CUBE IS CALM",
-- 	tag = "cube",
-- 	slot_type = "cube",
-- 	stack_size = 1,
-- 	race = "alien",
-- 	texture = "Main/textures/icons/items/blight_datacube.png",
-- 	visual = 'v_micropro', --"v_bot_ai_core", -- "v_simulation_data","v_blight_research_item"
-- 	production_recipe = CreateProductionRecipe({ crystal_powder = 2, hdframe = 1, ic_cube_blue =1 }, { cc_manifest = 200, }),
-- }

-- "v_hybrid_worker" for final production building ?
--------------------------------------
---- Soul Related Items -----------

data.items.ic_souls = {
	name = "Lingering Souls",
	index = 1010,
	race = "robot",
	desc = "",
	tag = "resource",
	texture = "The_Cube_WIP/textures/soul3.png",
	visual = "v_bot_ai_core", -- "v_scaramar1",
	slot_type = "storage",
	stack_size = 20,
}
data.items.ic_soul_plasma = {
	name = "Ectoplasma",
	index = 1010,
	race = "anomaly",
	desc = "Refined Soul Energy\nCan only be transferred through tansmission towers",
	tag = "simple_material",
	texture = "Main/textures/icons/items/anomaly_particle.png",
	--visual = "v_scaramar1",
	slot_type = "anomaly",
	stack_size = 100,
	production_recipe = CreateProductionRecipeWithWaste(
	{ic_cube_blue = 1, ic_souls = 50 },
	{ cc_soul_refinery = 400 },
	100, {ic_cube_blue = 1}),
}
create_alt_recipe("ic_soul_plasma", 
	CreateProductionRecipeWithWaste(
	{ic_cube_red = 1, ic_souls = 40, phase_leaf = 1 }, 
	{cc_soul_refinery = 25,},
	100,
	{ic_cube_empty = 1}),
	{desc = "Alternative Soul Plasma Extraction"}
)
data.items.ic_soul_happy = {
	name = "Enlightened Souls",
	index = 1010,
	race = "robot",
	desc = "Empowered, Fortified and Self Determined\n\nEnlightened Souls are capable of independant thought. Perfect for operations involving control and automation",
	tag = "advanced_material",
	texture = "The_Cube_WIP/textures/soul2.png",
	visual = "v_scaramar1",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipe(
	{ ic_soul_plasma = 1, datakey_robot = 1, crystal_powder = 1 },
	{ cc_green_brain = 1}, 1),
}
data.items.ic_soul_angry = {
	name = "Soul Pearls",
	index = 1011,
	race = "robot",
	desc = "Left at the bottom of the soul forge, Crystalized emotinal baggage\n\nSoul pearls provide a strong focus for energy, allowing for destructive lasers and incredible power systems",
	tag = "advanced_material",
	texture = "The_Cube_WIP/textures/soul4.png",
	visual = "v_scaramar1",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_soul_plasma = 100, ic_cube_red = 1 }, 
	{ cc_soul_refinery = 10, cc_red_furnace = 5},
	5, {ic_cube_empty = 1}),
}
-- data.items.ic_living_metal = {
-- 	name = "Living Metal",
-- 	index = 1011,
-- 	race = "robot",
-- 	desc = "All Parts Are Equalally valuable",
-- 	tag = "hitech_material",
-- 	texture = "The_Cube_WIP/textures/mercury.png",
-- 	visual = "v_scaramar1",
-- 	slot_type = "storage",
-- 	stack_size = 20,
-- 	production_recipe = CreateProductionRecipeWithWaste({ ic_soul_plasma = 10, ic_cube_yellow = 1, ic_soul_happy = 1, reinforced_plate = 20 }, { cc_manifest = 60 }, 5, {ic_cube_yellow = 1}),
-- }
data.items.ic_fuel = {
	name = "Rocket Fuel",
	index = 1020,
	race = "robot",
	desc = "3,2,1 Liftoff\nFuel for engines",
	tag = "advanced_material",
	texture = "The_Cube_WIP/textures/fuel.png",
	visual = "v_scaramar1",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipe(
	{ phase_leaf = 10, crystal_powder = 1}, 
	{ cc_soul_refinery = 20, cc_red_furnace = 15 }, 20),
}
data.items.ic_time_crystal = {
	name = 'Chrono Crystal',
	index = 10,
	tag = 'advanced_material',
	desc = 'Stabilized Chrono Crystal\nTrapped by Joy then caged in wire\n\nChrono crystals are used to create pockets of distorted time',
	stack_size = 20,
	slot_type = 'storage',
	visual = 'vc_time_crystal',
	texture = "The_Cube_WIP/textures/In Progress Blender/TimeCrystal/TimeCrystal.png",
	production_recipe = CreateProductionRecipe({ blight_crystal = 4, wire = 12,ic_soul_happy = 1, reinforced_plate = 2 }, { cc_green_brain = 25, cc_manifest = 70 }, 1),
}
data.items.blight_crystal.name = "Unstable Chrono Crystal"
data.items.blight_crystal.desc = "Unstable Chrono Crystal formed from the <rl>anhillation</> of the AntiCube"







