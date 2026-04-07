--[[

data.visuals.samplevisual = {
	mesh = "MESHPATH",
	-- Optional
	flags = "RandomRotation|RandomTranslation|RandomScale|NoShadows|NoMainPass|NoDepthPass|NoCollision|AttachToRoot|HideInDiscovered|CutsHole|Decals|ComponentFaceTarget|SmallObject|AlignToTerrain",
	materials = { "MATERIALPATH" },
	-- Only for frame visuals
	tile_size = { <WIDTH>, <HEIGHT> },
	placement = "AtCenter", -- other options are : Min, Average, Max
	sockets = { { <MESHSOCKET>, <SOCKETSIZE> }, ... },
	scale = { <SCALEX>, <SCALEY>, <SCALEZ> },
	place_effect = <EFFECTID>
	move_effect = <EFFECTID>
	destroy_effect = "<EFFECTID>",
	tile_pattern = { ... }, -- for decorations
	hole_pattern = { ... }, -- for decorations
	frame_class = "FRAMECLASS", -- for blueprint based visuals
	bob_speed = 1.0, -- default scale from 0.25 to 4.0 based on volume of mesh
	-- Only for lights
	light_radius = 4,
	light_color = { 1, 0, 1, 1 },
	light_offset = { 0.0, 0.0, 2.4 },
	-- misc
	animation_speed = 1.0,
	specular_scale = 0.0,
	cull_ratio = 1.0,
	minimap_color = { R, G, B, A }, -- when not set uses setting in frame definition
	stencil = 0,
	sort_order = 0,
	mesh_offset = { X, Y, Z },
}

]]

-- https://sketchfab.com/max5644/models

local meshes = {
    landing_pad = "StaticMesh'/Game/Meshes/BaseBuildings/Component_LandingPad_01_L.Component_LandingPad_01_L'",

	storage_single = "StaticMesh'/Game/Meshes/empty_Inventory.empty_Inventory'",
    storage_s = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Storage_01_S.Component_Storage_01_S'",

    transformer = "StaticMesh'/Game/Meshes/Containers/Containers_Transformer.Containers_Transformer'",


    cube_blue = "StaticMesh'/Game/Meshes/Containers/Container_RobotDataCube.Container_RobotDataCube'",
    cube_blue_drained = "StaticMesh'/Game/Meshes/Containers/Containers_Box_Gears.Containers_Box_Gears'",

    cube_other_drained = "v_transformer",
    cube_unassigned = "v_small_reactor",
	present = "v_Present_01_S",

	blight_set_6_a = "NiagaraSystem'/Game/Cai/Effects/BlightVent/NS_BlightVent.NS_BlightVent'",
}

-- cube component
data.visuals.vc_cube_blue = { 
    mesh = meshes.cube_blue, 
    --scale = { 4, 4, 4 },
	--materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_Miner_Advanced_01_S/Component_Miner_Advanced_01_S.Component_Miner_Advanced_01_S'" },
}
data.visuals.vc_cube_empty = { 
    mesh = meshes.cube_blue, 
    --scale = { 4, 4, 4 },
	flags = "NoMainPass",
	--materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_Miner_Advanced_01_S/Component_Miner_Advanced_01_S.Component_Miner_Advanced_01_S'" },
}
data.visuals.vc_cube_purple = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Data.Containers_Blight_Data'"}
-- data.visualmeshes.cube_storage = {{
-- 		effect = meshes.storage_single,
-- 		transform = { { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 }, },
-- 	},
-- 	{
-- 		effect = meshes.storage_s,
-- 		transform = { { 1, 1, 1 }, { 1, 1, 1 }, { 1, 1, 1 }, },
-- 	},
-- }
--"NiagaraSystem'/Game/Meshes/Foliage/Blight/BlightRock_Pieces_02/NS_Blight_RockFragments_Floating.NS_Blight_RockFragments_Floating'"
--"NiagaraSystem'/Game/Cai/Effects/BlightVent/NS_BlightVent.NS_BlightVent'"
data.fx.vc_cube_steam = {
	{
		particle ={ "NiagaraSystem'/Game/Meshes/Foliage/Blight/BlightRock_Pieces_02/NS_Blight_RockFragments_Floating.NS_Blight_RockFragments_Floating'", flags = "Preload"},
		flags = "Infinite"
		--transform = { { -274.1640625, 216.6713867, 350.1871338 }, { 31.2168312, -164.5661774, 110.6963120 }, { 1.0000000, 1.0000000, 1.0000000 }, },
	},
}
-- components 
data.visuals.vc_cube_storage = { 
    mesh = meshes.storage_single, 
    scale = { 4.5, 4.5, 4.5 },
	mesh_sockets = { ["fx"] = {50,50,-100}, },
	light_radius = 2,
	light_color = {0,0,0,1},
	light_offset = { 0.0, 0.0, 2 },
	--specular_scale = 0
	-- materials = {
	-- 	"MaterialInstanceConstant'/Game/Cai/Resources/Blight/MI_Resource_Blight_Pickup_01.MI_Resource_Blight_Pickup_01'",
	-- }
}
-- data.visuals.v_empty_inventory = {
-- 	mesh = "StaticMesh'/Game/Meshes/empty_Inventory.empty_Inventory'",
-- }
-- console / cc_manifest
data.visuals.v_explorable_blightanomaly_03.scale = {0.4,0.4,0.4}

-- plants 
data.visuals.vc_souls ={
	mesh = "StaticMesh'/Game/Cai/Resources/Silica/Pickup_01/SM_Resource_Silica_Pickup_01.SM_Resource_Silica_Pickup_01'",
	flags = "RandomRotation | RandomScale | RandomTranslation | NoShadows | AlignToTerrain",
	scale = { 2, 2, 2, },
	-- materials = {
	-- 	"MaterialInstanceConstant'/Game/Cai/Resources/Blight/MI_Resource_Blight_Pickup_01.MI_Resource_Blight_Pickup_01'",
	-- 	"MaterialInstanceConstant'/Game/Cai/Resources/Blight/Impostors/MI_Resource_Blight_Small_01_Impostor.MI_Resource_Blight_Small_01_Impostor'",}
}

data.visuals.vc_mug_anim = {
	animesh = "The_Cube_WIP/textures/In Progress Blender/Cube_test_2.glb",
	frame_class = "Blueprint'/Game/Blueprints/Frames/DSModFrameActor.DSModFrameActor_C'",

	--mesh_offset = { 0, 0, 0 },
	scale = {0.8,0.8,0.8},
	--mesh_sockets = { ["fx"] = {50,50,100}, },
	--placement = "AtCenter",
	--materials = {"The_Cube_WIP/textures/energy_spehere_from_online.jpg"}
}

data.visuals.vc_mug = {
	mesh = "The_Cube_WIP/textures/In Progress Blender/Pixels Small 1/pixels_s_1.glb",
	--mesh_offset = { 0, 0, 1000000},
	--scale = {0.03,0.03,0.03},
	--mesh_sockets = { ["fx"] = {50,50,100}, },
	--placement = "AtCenter",
	--materials = {"The_Cube_WIP/textures/energy_spehere_from_online.jpg"}
}
data.visuals.vc_tower1 = {
	mesh = "The_Cube_WIP/textures/PowerPylonColoured.glb",
	--mesh = "The_Cube_WIP/textures/tower2.T3D",
	mesh_offset = { 0, 0, 98 },
	mesh_sockets = { ["fx"] = {0,0,22000}, },
	scale = {0.008,0.008,0.008}
	--placement = "Max",
	--materials = {"The_Cube_WIP/textures/energy_spehere_from_online.jpg"}
}
data.visuals.vc_gyroscope = {
	animesh = "The_Cube_WIP/textures/customanim.glb",
	frame_class = "Blueprint'/Game/Blueprints/Frames/DSModFrameActor.DSModFrameActor_C'",
	bob_speed = 0,
	sockets = {
		{ "", "Small" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
	--scale = { 4.5, 4.5, 4.5 },
	--mesh_offset = { -400, 2400, 20 },
}

data.visuals.vc_pixel_ore_1 = {
	mesh = "The_Cube_WIP/textures/In Progress Blender/Pixels Small 1/pixels_s_1.glb",
	--mesh_offset = { 0, 0, 0},
	--scale = {0.2,0.2,0.2},
	tile_size = {3,3},
	flags = "RandomRotation"
	--mesh_sockets = { ["fx"] = {50,50,100}, },
	--placement = "AtCenter",
	--materials = {"The_Cube_WIP/textures/energy_spehere_from_online.jpg"}
}
data.visuals.vc_pixel_ore_2 = {
	mesh = "The_Cube_WIP/textures/In Progress Blender/Squares_8.glb",
	--mesh_offset = { 0, 0, 0},
	scale = {0.8,0.8,0.8},
	tile_size = {2,2},
	flags = "RandomRotation"
	--mesh_sockets = { ["fx"] = {50,50,100}, },
	--placement = "AtCenter",
	--materials = {"The_Cube_WIP/textures/energy_spehere_from_online.jpg"}
}
data.visuals.vc_cube_blue = {
	mesh = "The_Cube_WIP/textures/In Progress Blender/Cube_3.glb",
	--mesh_offset = { 0, 0, 1000000},
	scale = {0.03,0.03,0.03},
}
data.visuals.vc_time_crystal = {
	mesh = "The_Cube_WIP/textures/In Progress Blender/TimeCrystal/TimeCrystal.glb",	
	--mesh_offset = {0,0,10000	}
	mesh_scale = {0,0,0.8}
}

data.visuals.vc_sea_grass = Tool.Copy(data.visuals.v_succulent_04)
data.visuals.vc_sea_grass.scale = {3,3,3}
data.visuals.vc_sea_grass.flags = "RandomRotation|RandomScale|RandomTranslation"

------------------ plants 
--- Crop Plants
data.visuals.vc_crop_wire = Tool.Copy(data.visuals.v_succulent_04)
data.visuals.vc_crop_wire.scale = {2,2,2}
data.visuals.vc_crop_wire.flags = "RandomRotation|RandomScale|RandomTranslation"

data.visuals.vc_crop_wire_seed0 = Tool.Copy(data.visuals.v_succulent_01) -- v_succulent_05_A
data.visuals.vc_crop_wire_seed0.scale = {0.5,0.5,0.5}
data.visuals.vc_crop_wire_seed1 = Tool.Copy(data.visuals.vc_crop_wire_seed0) -- v_succulent_05_A
data.visuals.vc_crop_wire_seed1.scale = {0.8,0.8,0.8}
data.visuals.vc_crop_wire_seed2 = Tool.Copy(data.visuals.vc_crop_wire_seed0) -- v_succulent_05_A
data.visuals.vc_crop_wire_seed2.scale = {1.1,1.1,1.1}
data.visuals.vc_crop_wire_seed3 = Tool.Copy(data.visuals.vc_crop_wire_seed0) -- v_succulent_05_A
data.visuals.vc_crop_wire_seed3.scale = {1.4,1.4,1.4}
data.visuals.vc_crop_wire_seed4 = Tool.Copy(data.visuals.vc_crop_wire_seed0) -- v_succulent_05_A
data.visuals.vc_crop_wire_seed4.scale = {1.7,1.7,1.7}

data.visuals.vc_crop_phase = Tool.Copy(data.visuals.v_phase_plant)
data.visuals.vc_crop_phase.scale = {2,2,2}
data.visuals.vc_crop_phase.flags = "RandomRotation|RandomScale|RandomTranslation"

data.visuals.vc_crop_phase_seed0 = Tool.Copy(data.visuals.v_succulent_05_A) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed0.scale = {0.5,0.5,0.5}
data.visuals.vc_crop_phase_seed1 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed1.scale = {0.8,0.8,0.8}
data.visuals.vc_crop_phase_seed2 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed2.scale = {1.1,1.1,1.1}
data.visuals.vc_crop_phase_seed3 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed3.scale = {1.4,1.4,1.4}
data.visuals.vc_crop_phase_seed4 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed4.scale = {1.7,1.7,1.7}

----------- Cubes 
data.visuals.vc_cube_sphere_item = Tool.Copy(data.visuals.v_explorable_blightanomaly_02)
data.visuals.vc_cube_sphere_item.scale = {0.1,.1,.1}
data.visuals.vc_cube_sphere_item.tile_size = nil

data.visuals.vc_cube_sphere_frame = Tool.Copy(data.visuals.vc_cube_sphere_item)
data.visuals.vc_cube_sphere_frame.scale = {.45,.45,.45}
--data.visuals.vc_cube_sphere.mesh_offset = {0,0,-400}



