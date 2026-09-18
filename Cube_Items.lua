

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
data.item_slot_icons["cube"] = "The_Cube_WIP/textures/cube_icon_2.png"
-- add cube category 
table.insert(data.categories, 1, { name = "Cube", tab = "item",  defs = data.items,  filter_field = "tag", filter_val = "cube"   } )
--------------------------------------
---- Update Cube Existing Items -----------

-- Blue Cube items 
data.items.crystal_powder.production_recipe = CreateProductionRecipeWithWaste({ic_cube_blue = 1, crystal = 40,  }, {cc_manifest = 100}, 20, {ic_cube_empty = 1})
data.items.crystal_powder.tag = "simple_material"
data.items.crystal_powder.desc = "At the right frequency crystal will resonate with the cube inducing a cascade failure at the intermolecular level"
create_alt_recipe("crystal_powder",
	CreateProductionRecipeWithWaste(
	{ crystal = 80, ic_soul_angry = 1, phase_leaf = 20, blight_crystal = 10, ic_cube_blue = 1}, 
	{cc_manifest = 25, cc_red_furnace = 5},
	50, {ic_cube_empty = 1}),
	{desc = "Bulk Crystal Refraction"}
)
data.items.datakey_robot = {
	name = "Cube Log",
	index = 1010,
	desc = "Material manifested into a basic cognition pattern by the Cube",
	tag = "simple_material",
	texture = "Main/textures/icons/items/datakey_robot.png",
	visual = "v_gears",
	slot_type = "storage",
	race = "robot",
	stack_size = 20,
	production_recipe = CreateProductionRecipeWithWaste({ ic_cube_blue = 1, metalplate = 5 }, { cc_manifest = 50, cc_green_brain = 10 }, 5, {ic_cube_blue = 1}),
}
create_alt_recipe("datakey_robot",
	CreateProductionRecipeWithWaste(
	{ic_cube_empty = 1, reinforced_plate = 6, }, 
	{cc_green_brain = 60 , cc_red_furnace = 15},
	100, {ic_cube_blue = 1}),
	{desc = "Bulk Cube Log Filling"}
)
-- Red Cube items
data.items.reinforced_plate.race = "robot"
data.items.reinforced_plate.desc = "Forged In a high pressure workplace\nsteel learns the discipline to hold this factory together"
data.items.reinforced_plate.production_recipe = CreateProductionRecipeWithWaste(
{ic_cube_red = 1, steelblock = 80, crystal_powder = 20, wire = 20  }, 
{cc_manifest = 200, cc_red_furnace = 75}, 20, {ic_cube_empty = 1})
create_alt_recipe("reinforced_plate",
	CreateProductionRecipeWithWaste(
	{ic_cube_red = 1, steelblock = 80, ic_soul_plasma = 5, wire = 40  }, 
	{cc_manifest = 25, cc_red_furnace = 5},
	20, {ic_cube_empty = 1}),
	{desc = "Bulk Metal Smelting"}
)
--- Green cube 
data.items.phase_leaf.production_recipe = false
data.items.phase_leaf.tag = "resource"
data.items.phase_leaf.race = "virus"
data.items.phase_leaf.desc = "The fractal nature of this leaf causes anomlaous space distorations\nUseful for many alternative crafting recipes"

data.items.wire.name = "Neurotic Reed Fibre"
data.items.wire.desc = "Neurotic reed fibre, wound and ready for higher conceptualization"
data.items.wire.production_recipe = false
data.items.wire.race = "virus"
data.items.wire.index = 1011
data.items.wire.tag = "resource"
data.items.wire.texture = "The_Cube_WIP/textures/wire.png"
--- AntiCube 
data.items.ldframe.name = "AntiPhysics Frame"
data.items.ldframe.desc = "A Contained AntiCube ready for connection to a bot chassis"
data.items.ldframe.race = "robot"
data.items.ldframe.production_recipe = CreateProductionRecipe(
{ reinforced_plate = 2, phase_leaf = 4,ic_cube_sphere = 1, ic_soul_happy = 1, blight_crystal = 9}, { cc_manifest = 20 }, 1)


--------------------------------------
---- Update Non Cube Existing Items -----------
data.items.crystal.name = "Resonance Crystal"
data.items.crystal.desc = "A Crystal chunk capable of emotional resonance with the cube or vaporized for energy"

data.items.metalplate.production_recipe = CreateProductionRecipe({metalore = 2}, {c_fabricator = 30}, 1)
data.items.metalplate.desc = "Fighting against entropy homogenzied matter can be smelted"

data.items.laterite.mining_recipe = CreateMiningRecipe({c_miner = 30, c_adv_miner = 15})

data.items.steelblock.name = "Steel Beams"
data.items.steelblock.desc = "The Trusty I beam. A Pylon of Civilization"
data.items.steelblock.production_recipe = CreateProductionRecipe(
{metalplate = 4, crystal = 1  }, {c_fabricator = 30, cc_red_furnace = 10}, 2)
data.items.steelblock.texture = "The_Cube_WIP/textures/steel_beam.png"
data.items.steelblock.race = "robot"
data.items.steelblock.tag = "simple_material"
data.items.steelblock.visual = data.items.metalbar.visual

-- create_alt_recipe("steelblock",
-- 	CreateProductionRecipeWithWaste(
-- 	{laterite = 40, metalplate = 20, ic_cube_red = 1}, 
-- 	{cc_red_furnace = 25},
-- 	20, {ic_cube_empty = 1}),
-- 	{desc = "Laterite Steel Alloy"}
-- )

data.items.concreteslab.desc = "With Concrete and Steel Humans ruled the world. Now they are all that's left"
data.items.concreteslab.production_recipe = CreateProductionRecipe(
{steelblock = 2, metalore = 4  }, {c_fabricator = 30}, 1)
data.items.concreteslab.tag = "simple_material"
data.items.concreteslab.race = "robot"
create_alt_recipe("concreteslab", 
	CreateProductionRecipe(
	{reinforced_plate = 1, wire = 5, metalore = 5}, 
	{c_fabricator = 25},
	10),
	{desc = "Reinforced Concrete Mixing"}
)
data.items.beacon_frame.production_recipe = CreateProductionRecipe({steelblock = 5, datakey_robot = 1}, {c_fabricator = 40, c_assembler = 30}, 1)

data.items.engine.production_recipe = CreateProductionRecipe(
{reinforced_plate = 4, wire = 6 , datakey_robot = 1, ic_soul_angry = 1}, {c_assembler = 120, cc_green_brain = 80}, 1)
data.items.engine.race = "robot"
data.items.engine.desc = "Entry 012 What a waste of entropy for a few tiles per hour"


data.items.fused_electrodes.name = "Superconductor"
data.items.fused_electrodes.desc = "This Material is beyond our current understanding\n1024 years into the future we will invent a way to manufacture it"
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
	texture = 'The_Cube_WIP/textures/cube_blue.png',
	visual = "vc_cube_blue",--"v_robot_data",
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_cube_green = 1, datakey_robot = 1 }, { cc_manifest = 50 },1,{ic_cube_blue = 1}),
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
	texture = "The_Cube_WIP/textures/cube_empty.png",
	visual = "vc_cube_empty",
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
	visual = "vc_cube_red",
	--production_recipe = CreateProductionRecipe({ crystal_powder = 2, hdframe = 1 }, { c_robotics_factory = 200, }),
}
data.items.ic_cube_green = {
	name = "RESTLESS CUBE",
	index = 1002,
	desc = "<hl>THE CUBE IS SHIMMERING</>\nSpeeds up bots",
	locked_desc = "Find a large weed in the plains and claim a cutting",
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "Main/textures/icons/items/virus_research_data.png",
	visual = "vc_cube_green",
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_cube_blue = 1, crystal_powder = 1 }, { cc_manifest = 25, },1, {ic_cube_green = 1}),--phase_leaf = 6
}
create_alt_recipe("ic_cube_green",
	CreateProductionRecipeWithWaste(
	{ic_cube_empty = 1, ic_soul_plasma = 1}, 
	{cc_manifest = 5},
	1,
	{ic_cube_green = 1}),
	{desc = "Lightning Fast Restless Cube Forming"}
)
data.items.ic_cube_sphere = {
	name = "ANTI - CUBE",
	index = 1004,
	desc = [[<hl>Heresey, there is a sphere inside the cube!</>
<rl>WARNING: extremly unstable around the Cube</>
The Anti-Cube can exist in an infinate number of states simultaneously.
]],
	tag = "cube",
	slot_type = "cube",
	stack_size = 1,
	race = "alien",
	texture = "Main/textures/icons/alien/alienunit_worker_a.png",
	visual = 'vc_cube_sphere_item',
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_cube_red = 1, ic_soul_plasma = 1,  }, 
	{ cc_manifest = 200, }, 1, {ic_cube_sphere = 2, ic_cube_empty = 1}),
	--production_recipe = CreateProductionRecipeWithWaste(
	-- { ic_cube_blue = 1, crystal = 1, }, { cc_manifest = 200, cc_red_furnace = 50},
	-- 1, {ic_cube_sphere = 1, ic_cube_empty = 1}),
	--alt_item = "datakey_robot",
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
--data.items.bug_carapace = nil
--data.update_mapping.bug_carapace = "bug_carapace"
data.items.bug_carapace = {
	name = "Lingering Souls",
	index = 1010,
	desc = "Incorporeal Friends\n\nDropped by defeated enemies",
	tag = "resource",
	texture = "The_Cube_WIP/textures/soul3.png",
	visual = "vc_souls", -- "v_scaramar1",
	slot_type = "storage",
	stack_size = 20,
}
data.items.ic_soul_plasma = {
	name = "Ectoplasma",
	index = 1010,
	race = "robot",
	desc = "Refined Soul Energy\nCan only be transferred through plasma relay towers",
	tag = "advanced_material",
	texture = "Main/textures/icons/items/anomaly_particle.png",
	--visual = "v_scaramar1",
	slot_type = "anomaly",
	stack_size = 100,
	production_recipe = CreateProductionRecipeWithWaste(
	{ic_cube_blue = 1, bug_carapace = 5, crystal_powder = 10 },
	{ cc_soul_refinery = 50 },
	50, {ic_cube_blue = 1}),
}
create_alt_recipe("ic_soul_plasma", 
	CreateProductionRecipeWithWaste(
	{ic_cube_blue = 1, bug_carapace = 10, phase_leaf = 20, ic_time_crystal = 1 }, 
	{cc_soul_refinery = 10,},
	50,
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
	visual = "vc_soul_happy",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipe(
	{ ic_soul_plasma = 5, datakey_robot = 2, crystal_powder = 1, wire = 4 },
	{ cc_green_brain = 100}, 1),
}
data.items.ic_soul_angry = {
	name = "Soul Pearls",
	index = 1011,
	race = "robot",
	desc = "Residual emotinal baggage found at the bottom of the soul forge\n\nSoul pearls provide a strong focus for energy, allowing for destructive lasers and incredible power systems",
	tag = "advanced_material",
	texture = "The_Cube_WIP/textures/soul4.png",
	visual = "vc_soul_angry",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipeWithWaste(
	{ ic_soul_plasma = 50, ic_cube_red = 1, crystal_powder = 10 }, 
	{cc_manifest = 200, cc_green_brain = 50, cc_red_furnace = 60},
	5, {ic_cube_empty = 1}),
}
create_alt_recipe("ic_soul_angry", 
	CreateProductionRecipeWithWaste(
	{ic_cube_red = 1, ic_soul_plasma = 50, phase_leaf = 10, ic_soul_happy = 5 }, 
	{cc_manifest = 50, cc_green_brain = 15, cc_red_furnace = 15},
	10,
	{ic_cube_empty = 1}),
	{desc = "Alternative Soul Plasma Extraction"}
)
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
	desc = "3,2,1 Liftoff",
	tag = "advanced_material",
	texture = "The_Cube_WIP/textures/fuel.png",
	visual = "v_scaramar1",
	slot_type = "storage",
	stack_size = 20,
	production_recipe = CreateProductionRecipe(
	{ phase_leaf = 10, crystal_powder = 1, blight_crystal = 2}, 
	{ cc_soul_refinery = 20, cc_red_furnace = 15 }, 20),
}
data.items.ic_time_crystal = {
	name = 'Chrono Crystal',
	index = 10,
	tag = 'advanced_material',
	race = "robot",
	desc = 'Stabilized Chrono Crystal\nTrapped by Joy then caged in wire\n\nChrono crystals are used to create pockets of distorted time',
	stack_size = 20,
	slot_type = 'storage',
	visual = 'vc_time_crystal',
	texture = "The_Cube_WIP/textures/TimeCrystal.png",
	production_recipe = CreateProductionRecipe({ blight_crystal = 9, wire = 12,ic_soul_happy = 1, reinforced_plate = 2 }, { cc_green_brain = 25, cc_manifest = 70 }, 1),
}
data.items.blight_crystal.name = "Unstable Chrono Crystal"
data.items.blight_crystal.desc = "Unstable Chrono Crystal formed from the <rl>anhillation</> of the AntiCube"


---- Final ITems 
data.items.ic_broken_reality = {
	name = 'Unstable Understanding',
	index = 11,
	tag = 'hitech_material',
	race = "robot",
	desc = 'How to cook a Universe\nIngriedent 1 - Forget the laws of reality to surpass them',
	stack_size = 20,
	slot_type = 'storage',
	visual = data.items.anomaly_cluster.visual,
	texture = data.items.anomaly_cluster.texture,
	production_recipe = CreateProductionRecipe({ fused_electrodes = 10, ic_cube_sphere = 1, phase_leaf = 20,  ic_fuel = 10 }, { cc_manifest = 100, cc_red_furnace = 50 }, 1),
}
data.items.ic_proto_sent = {
	name = 'Proto-Sentinece',
	index = 11,
	tag = 'hitech_material',
	race = "robot",
	desc = 'How to cook a Universe\nIngriedent 3\nIf a Universe is created and no one can witness it, does it exist?',
	stack_size = 20,
	slot_type = 'storage',
	visual = data.items.anomaly_heart.visual,
	texture = data.items.anomaly_heart.texture,
	production_recipe = CreateProductionRecipeWithWaste({ ic_soul_angry = 5, ic_soul_happy = 5, cc_green_brain = 1,  ic_soul_plasma = 10, ic_cube_blue = 1 },{ cc_green_brain = 100 }, 1, {ic_cube_green = 1}),
}
data.items.ic_matter = {
	name = 'Primordial Matter',
	index = 11,
	tag = 'hitech_material',
	race = "robot",
	desc = 'How to cook a Universe\nIngriedent 2 - A Generous portion of matter',
	stack_size = 20,
	slot_type = 'storage',
	visual = data.items.obsidian.visual,
	texture = data.items.obsidian.texture,
	production_recipe = CreateProductionRecipeWithWaste({ ic_time_crystal = 2, reinforced_plate = 20, fused_electrodes = 10,  ic_fuel = 10, ic_cube_red = 1 }, { cc_red_furnace = 100 }, 5, {ic_cube_empty = 1}),
}
data.items.ic_micro_universe = {
	name = 'Micro Universe',
	index = 12,
	tag = 'hitech_material',
	race = "robot",
	desc = 'Our Duty Complete\nSo long as the chain continues this string of Universes shall never truly die\n<rl>Add a bot to the Anti Entropy Loom\'s garage to begin new game plus</>',
	stack_size = 20,
	slot_type = 'storage',
	visual = data.items.anomaly_heart.visual,
	texture = "Main/textures/tech/blight/blight_terra_03_1.png",
	production_recipe = CreateProductionRecipeWithWaste({ ic_broken_reality = 16, ic_proto_sent = 16, ic_matter = 16, ic_cube_blue = 1}, { cc_gyro_fabricator = 100 }, 1, {ic_cube_blue = 1}),
}




