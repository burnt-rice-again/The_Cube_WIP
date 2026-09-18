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

local CONTAINER_CULL_DIST = 0.5

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
    mesh = "The_Cube_WIP/textures/cube_blue.glb", 
	scale = {0.11,0.11,0.11},
}
data.visuals.vc_cube_empty = { 
    mesh = "The_Cube_WIP/textures/cube_empty.glb", 
	scale = {0.11,0.11,0.11},
}
data.visuals.vc_cube_green = { 
    mesh = "The_Cube_WIP/textures/cube_green.glb", 
	scale = {0.11,0.11,0.11},
}
data.visuals.vc_cube_purple = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Data.Containers_Blight_Data'"}
-- components 
data.visuals.vc_cube_storage = { 
    mesh = meshes.storage_single, 
    scale = { 4.5, 4.5, 4.5 },
	mesh_sockets = { ["fx"] = {0,0,-7} },
	light_radius = 2,
	light_color = {0,0,0,1},
	light_offset = { 0.0, 0.0, 2 },
}
-- console / cc_manifest
data.visuals.v_explorable_blightanomaly_03.scale = {0.4,0.4,0.4}

data.visuals.vc_souls ={
	mesh = "The_Cube_WIP/textures/Soul_Visual.glb",
	flags = "RandomRotation | RandomScale | RandomTranslation | NoShadows | AlignToTerrain",
	scale = { 0.1, 0.1, 0.1, },
	cull_ratio = CONTAINER_CULL_DIST
}
data.visuals.vc_soul_happy ={
	mesh = "The_Cube_WIP/textures/Soul_Happy.glb",
	flags = "RandomRotation | RandomScale | RandomTranslation | NoShadows | AlignToTerrain",
	scale = { 0.1, 0.1, 0.1, },
	cull_ratio = CONTAINER_CULL_DIST
}
data.visuals.vc_soul_angry ={
	mesh = "The_Cube_WIP/textures/Soul_Angry.glb",
	flags = "RandomRotation | RandomScale | RandomTranslation | NoShadows | AlignToTerrain",
	scale = { 0.1, 0.1, 0.1, },
	cull_ratio = CONTAINER_CULL_DIST
}
data.visuals.vc_tower1 = {
	mesh = "The_Cube_WIP/textures/PowerPylonColoured.glb",
	flags = "RandomRotation",
	--mesh = "The_Cube_WIP/textures/tower2.T3D",
	mesh_offset = { 0, 0, 98 },
	mesh_sockets = { ["fx"] = {0,0,22000}, },
	scale = {0.008,0.008,0.008}
	--placement = "Max",
	--materials = {"The_Cube_WIP/textures/energy_spehere_from_online.jpg"}
}
data.visuals.vc_chrono_tower = {
	mesh = "The_Cube_WIP/textures/BoostTower_1.glb",	
	--mesh_offset = {0,0,100	},
	scale = {0.2,0.2,0.2},
	mesh_sockets = { ["fx"] = {0,0,1470} },
	--cull_ratio = CONTAINER_CULL_DIST
}

-- change other cubes cull distance 
data.visuals.v_gears.cull_ratio = 1 
data.visuals.v_alien_data.cull_ratio = 1 
data.visuals.v_virus_data.cull_ratio = 1 

data.visuals.vc_static_gyro = {
	mesh = "The_Cube_WIP/textures/gyro.glb",
	mesh_offset = { 0, 0, 225},
	mesh_sockets = { ["Medium1"] = {0,0,0}, ["fx"] = {0,0,0}},
	sockets = {
		{ "Medium1", "Medium" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
	tile_size = { 7, 7 },
	tile_pattern = {
		1, 1, 0, 0, 0, 0, 0,
		1, 1, 0, 0, 0, 0, 0,
		0, 0, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 0, 0,
		0, 0, 0, 0, 0, 1, 1,
		0, 0, 0, 0, 0, 1, 1,
	},
	scale = {1,1,1},
}

data.visuals.vc_time_crystal = {
	mesh = "The_Cube_WIP/textures/In Progress Blender/TimeCrystal/TimeCrystal.glb",	
	mesh_offset = {0,0,100	},
	mesh_scale = {0,0,0.8},
	cull_ratio = CONTAINER_CULL_DIST
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
data.visuals.vc_crop_wire_seed0.RandomTranslation = {0.1,0.1,0.1}
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
data.visuals.vc_crop_phase_seed0.RandomTranslation = {0.3,0.3,0.3}
data.visuals.vc_crop_phase_seed1 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed1.scale = {0.8,0.8,0.8}
data.visuals.vc_crop_phase_seed2 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed2.scale = {1.1,1.1,1.1}
data.visuals.vc_crop_phase_seed3 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed3.scale = {1.4,1.4,1.4}
data.visuals.vc_crop_phase_seed4 = Tool.Copy(data.visuals.vc_crop_phase_seed0) -- v_succulent_05_A
data.visuals.vc_crop_phase_seed4.scale = {1.7,1.7,1.7}

----------- Seed Planters
data.visuals.vc_planter = {
	mesh = "The_Cube_WIP/textures/In Progress BlockBench/Planter.glb",
	scale = {0.5,0.5,0.5}
}


----------- Cubes as
data.visuals.vc_cube_sphere_item = Tool.Copy(data.visuals.v_explorable_blightanomaly_02)
data.visuals.vc_cube_sphere_item.scale = {0.1,.1,.1}
data.visuals.vc_cube_sphere_item.tile_size = nil
data.visuals.vc_cube_sphere_item.explorable_name = nil


data.visuals.vc_cube_sphere_frame = Tool.Copy(data.visuals.vc_cube_sphere_item)
data.visuals.vc_cube_sphere_frame.scale = {.45,.45,.45}
data.visuals.vc_cube_sphere_frame.sockets = nil
--data.visuals.vc_cube_sphere_frame.light_color = nil


--data.visuals.vc_cube_sphere.mesh_offset = {0,0,-400}

--- add light to crystal power
data.visuals.v_crystalpower_01_s.light_radius = 2
data.visuals.v_crystalpower_01_s.light_color = {0,0,1,0}
--data.visuals.v_crystalpower_01_s.light_offset = {0,0,1}
--- add light to crystal power
data.visuals.v_blightcrystalpower_01_m.light_radius = 2
data.visuals.v_blightcrystalpower_01_m.light_color = {1,0.5,0,0}
--data.visuals.v_crystalpower_01_s.light_offset = {0,0,1}
