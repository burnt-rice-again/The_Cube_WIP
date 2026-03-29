
--[[

data.visuals.samplevisual = {
	mesh = "MESHPATH",
	-- Optional
	flags = "RandomRotation|RandomTranslation|RandomHeight|RandomScale|NoShadows|NoMainPass|NoDepthPass|NoCollision|AttachToRoot|HideInDiscovered|CutsHole|Decals|ComponentFaceTarget|SmallObject|AlignToTerrain",
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
	random_translation = { X, Y, Z }, -- factor (XY used for RandomTranslation, Z used for RandomHeight, defaults to 0.45 each)
}

]]

data.visuals.v_empty = {}

data.visuals.v_empty_alien = {
	mesh = "StaticMesh'/Game/Meshes/empty_socket.empty_socket'",
	scale = { 4, 4, 4 },
	mesh_offset = { 0, 0, 50 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "",       "Internal" },
	},
}

data.visuals.v_mothership_internal = {
	mesh = "StaticMesh'/Game/Meshes/empty_socket.empty_socket'",
	scale = { 4, 4, 4 },
	mesh_offset = { 0, 0, 50 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
}

data.visuals.v_empty_inventory = {
	mesh = "StaticMesh'/Game/Meshes/empty_Inventory.empty_Inventory'",
}

-- default dropped items
data.visuals.v_dropped_item = {
	--mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Storage_01_S.Component_Storage_01_S'",
	mesh = "StaticMesh'/Game/Meshes/four_inventory.four_inventory'",
	flags = "AlignToTerrain",
	--scale = { 1.7, 1.7, 1.7 },
	--mesh_offset = { 0,0,-5},
	place_effect = "fx_digital_in",
}

-- default inventory item visual
data.visuals.v_default_item = {
	mesh = "StaticMesh'/Game/Meshes/ResourceGathered/ResourceGathered_01_Obsidian_LP.ResourceGathered_01_Obsidian_LP'"
}

-- default inventory component visual
data.visuals.v_default_component = {
	mesh = "StaticMesh'/Game/Meshes/WhiteBox/WhiteBox_Export_Cube_100.WhiteBox_Export_Cube_100'",
}


---------- component visuals

--data.visuals.v_shared_storage = {
--	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Building_SharedStorage_01_4x4.Building_SharedStorage_01_4x4'",
--}

data.visuals.v_landingpad_01_l = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_LandingPad_01_L.Component_LandingPad_01_L'",
}

data.visuals.v_light_01_s = {mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Light_01_S.Component_Light_01_S'", light_radius = 5,}
data.visuals.v_power_relay_01_l    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerRelay_01_L.Component_PowerRelay_01_L'" }
data.visuals.v_power_relay_01_m    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerRelay_01_M.Component_PowerRelay_01_M'" }
data.visuals.v_power_relay_01_s    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerRelay_01_S.Component_PowerRelay_01_S'" }
data.visuals.v_power_cell_01_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerCell_01_S.Component_PowerCell_01_S'" }
data.visuals.v_power_core_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerCore_01_L.Component_PowerCore_01_L'" }
data.visuals.v_assembler_01_m  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Assembler_01_M.Component_Assembler_01_M'", animation_speed = 0 }
data.visuals.v_capacitor_01_s  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Capacitor_01_S.Component_Capacitor_01_S'" }

data.visuals.v_battery_01_l    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Battery_01_L.Component_Battery_01_L'" }
data.visuals.v_battery_01_m    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Battery_01_M.Component_Battery_01_M'" }

data.visuals.v_dronehub_01_m   = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_DroneHub_01_M.Component_DroneHub_01_M'" }
data.visuals.v_dronehub_01_s   = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_DronePort_S.Component_DronePort_S'" }
data.visuals.v_fabricator_01_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Fabricator_01_S.Component_Fabricator_01_S'" }
data.visuals.v_amalgamator_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Amalgamator_01_L.Component_Amalgamator_01_L'" }
data.visuals.v_teleporter_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Teleporter_01_L.Component_Teleporter_01_L'" }
data.visuals.v_alienfactory_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Alien_Factory_01_L.Component_Alien_Factory_01_L'" }

data.visuals.v_deconstructor_01_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Deconstructor_01_S.Component_Deconstructor_01_S'", }

data.visuals.v_refinery_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Refinery_01_M.Component_Refinery_01_M'", } --light_color = { 1, 0.6, 0.1, 8}, light_radius = 1, light_offset = { 0,0,0.6}}
--data.visuals.v_roboticsfactory_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_RoboticsFactory_01_M.Component_RoboticsFactory_01_M'" }
data.visuals.v_roboticsfactory_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/VAT/Component_RoboticsFactory_01_M/Component_RoboticsFactory_01_M_VAT.Component_RoboticsFactory_01_M_VAT'", animation_speed = 0 }

data.visuals.v_adv_refinery_01_m  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_AdvancedRefinery_01_M.Component_AdvancedRefinery_01_M'", scale = { 0.70, 0.70, 0.80 }, }

data.visuals.v_adv_assembler_01_l  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_AdvancedAssembler_01_L.Component_AdvancedAssembler_01_L'", scale = { 1.25, 1.25, 1.25 }, }
data.visuals.v_adv_alien_factory_01_l  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_AdvancedAlienFactory_01_M.Component_AdvancedAlienFactory_01_M'", scale = { .95, .95, .95 }, }

data.visuals.v_crystalbattery_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_CrystalBattery_01_M.Component_CrystalBattery_01_M'", animation_speed = 1 }
data.visuals.v_crystalpower_01_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_CrystalPower_01_S.Component_CrystalPower_01_S'" }
data.visuals.v_blightcrystalpower_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightCrystalPower_01_M.Component_BlightCrystalPower_01_M'" }

data.visuals.v_blightpowergenerator_01_m = {mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightPowerGenerator_01_M.Component_BlightPowerGenerator_01_M'" }
data.visuals.v_transporter_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Transporter_01_M.Component_Transporter_01_M'" }
data.visuals.v_blightextractor_s = {mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightExtractor_01_S.Component_BlightExtractor_01_S'" }
data.visuals.v_blightcontainer_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightContainer_01_M.Component_BlightContainer_01_M'" }
data.visuals.v_blightcontainer_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightContainer_01_S.Component_BlightContainer_01_S'" }


data.visuals.v_solarpanel_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_SolarPanel_01_M.Component_SolarPanel_01_M'" }
data.visuals.v_solarpanel_01_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_SolarPanel_01_S.Component_SolarPanel_01_S'" }
data.visuals.v_storage_01_m    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Storage_01_M.Component_Storage_01_M'" }
data.visuals.v_storage_01_s    = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Storage_01_S.Component_Storage_01_S'" }
data.visuals.v_storage_l       = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_LargeStorage_01_L.Component_LargeStorage_01_L'" }
--data.visuals.v_smartstorage_m  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_SmartStorage_01_M.Component_SmartStorage_01_M'" }
data.visuals.v_laserextractor_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_LaserExtractor_01_M.Component_LaserExtractor_01_M'", flags = "ComponentFaceTarget" }
data.visuals.v_scanner_s  = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Scanner_01_S.Component_Scanner_01_S'", flags = "ComponentFaceTarget" }

data.visuals.v_repairer_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Repairer_01_M.Component_Repairer_01_M'" }
data.visuals.v_repairer_AoE_01_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Repairer_AoE_01_S.Component_Repairer_AoE_01_S'" }
data.visuals.v_repairer_AoE_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Repairer_AoE_01_M.Component_Repairer_AoE_01_M'" }
data.visuals.v_repairport_01_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_RepairPort_01_M.Component_RepairPort_01_M'" }

-- turrets

-- Robot Special

data.visuals.v_melee_pulse_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_MeleePulse_01_S.Component_MeleePulse_01_S'", }
data.visuals.v_pulse_disrupter_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PulseDisrupter_01_M.Component_PulseDisrupter_01_M'", }
data.visuals.v_viral_pulse_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ViralPulse_01_S.Component_ViralPulse_01_S'", }
data.visuals.v_photon_beam_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PhotonBeam_01_M.Component_PhotonBeam_01_M'", }
data.visuals.v_starterturret_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_StarterTurret_01_S.Component_StarterTurret_01_S'", animation_speed = 0.3, }
data.visuals.v_photon_canon_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PhotonCannon_01_M.Component_PhotonCannon_01_M'", }
data.visuals.v_plasma_canon_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PlasmaCannon_01_M.Component_PlasmaCannon_01_M'", }

-- Robot Standard Turrets
data.visuals.v_starterturret_adv_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_StarterTurret_Adv_01_S.Component_StarterTurret_Adv_01_S'", animation_speed = 0.3, flags = "ComponentFaceTarget" }
data.visuals.v_pulselasers_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PulseLasers_01_M.Component_PulseLasers_01_M'", flags = "ComponentFaceTarget", }
data.visuals.v_turret_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_StandardTurret_01_M.Component_StandardTurret_01_M'", animation_speed = 0.3, scale = { 0.95, 0.95, 0.95 }, flags = "ComponentFaceTarget" }
data.visuals.v_laser_turret_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_LaserTurret_01_M.Component_LaserTurret_01_M'", scale = { 1.0, 1.0, 1.0 }, flags = "ComponentFaceTarget" }

-- Human
data.visuals.v_twin_autocannons_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_TwinTurret_01_M.Component_TwinTurret_01_M'", flags = "ComponentFaceTarget", scale = { 0.8, 0.8, 0.8 }, }
data.visuals.v_missile_launcher_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_MissileLauncher_01_L.Component_MissileLauncher_01_L'", flags = "ComponentFaceTarget" }
data.visuals.v_railgun_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Railgun_01_M.Component_Railgun_01_M'", flags = "ComponentFaceTarget" }

-- Alien
data.visuals.v_alien_plasma_beam_m = { mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Tank_02/Component_AlienTankTurret_02.Component_AlienTankTurret_02'", flags = "ComponentFaceTarget" }
data.visuals.v_alien_plasma_beam_s = { mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Tank_01/Component_AlienTankTurret_01.Component_AlienTankTurret_01'", flags = "ComponentFaceTarget" }
data.visuals.v_hybrid_beam_cannon_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_AlienBeamTurret_01_M.Component_AlienBeamTurret_01_M'", flags = "ComponentFaceTarget" }

data.visuals.v_starterturret_red_s =
{
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_StarterTurret_01_S.Component_StarterTurret_01_S'",
	materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_StarterTurret_01_S/Component_StarterTurret_01_S_Red.Component_StarterTurret_01_S_Red'", },
	animation_speed = 0.3,
}
data.visuals.v_starterturret_green_s =
{
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_StarterTurret_01_S.Component_StarterTurret_01_S'",
	materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_StarterTurret_01_S/Component_StarterTurret_01_S_Green.Component_StarterTurret_01_S_Green'", },
	animation_speed = 0.3,
}

data.visuals.v_starterturret_drain_s =
{
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_StarterTurret_01_S.Component_StarterTurret_01_S'",
	materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_StarterTurret_01_S/Component_StarterTurret_01_S_Drain.Component_StarterTurret_01_S_Drain'", },
	animation_speed = 0.3,
}

data.visuals.v_starterturret_phase_m =
{
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Turret_01_M.Component_Turret_01_M'",
	materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_StarterTurret_01_S/Component_StarterTurret_01_S_Green.Component_StarterTurret_01_S_Green'", },
	animation_speed = 0.3,
}

data.visuals.v_radar_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Radar_01_S.Component_Radar_01_S'" }
data.visuals.v_radar_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Radar_01_M.Component_Radar_01_M'" }
data.visuals.v_power_transmitter_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerTransmitter_01_M.Component_PowerTransmitter_01_M'" }
data.visuals.v_power_transmitter_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PowerTransmitter_01_L.Component_PowerTransmitter_01_L'" }
data.visuals.v_wind_turbine_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_WindTurbine_01_M.Component_WindTurbine_01_M'", scale = { 1.2, 1.2, 1.2 },  }
data.visuals.v_wind_turbine_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_WindTurbine_01_M.Component_WindTurbine_01_M'", scale = { 1.8, 1.8, 1.8 }, }
data.visuals.v_hacking_tool_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_HackingTool_01_S.Component_HackingTool_01_S'", flags = "ComponentFaceTarget" }
data.visuals.v_miner_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Miner_01_S.Component_Miner_01_S'", flags = "ComponentFaceTarget" }
data.visuals.v_miner_adv_s = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Miner_01_S.Component_Miner_01_S'",
	materials = { "MaterialInstanceConstant'/Game/Meshes/BaseBuildings/Materials/Component_Miner_Advanced_01_S/Component_Miner_Advanced_01_S.Component_Miner_Advanced_01_S'" },
	flags = "ComponentFaceTarget",
}

-- overclock
data.visuals.v_moduleoc_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_S.Component_ModuleBase_01_S'", light_color = { 0, 0.5, 1.0 } }
data.visuals.v_moduleoc_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_M.Component_ModuleBase_01_M'", light_color = { 0, 0.5, 1.0 } }
data.visuals.v_moduleoc_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_L.Component_ModuleBase_01_L'", light_color = { 0, 0.5, 1.0 } }
-- health
data.visuals.v_modulehealth_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_S.Component_ModuleBase_01_S'", light_color = { 0, 0.6, 0 } }
data.visuals.v_modulehealth_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_M.Component_ModuleBase_01_M'", light_color = { 0, 0.6, 0 } }
data.visuals.v_modulehealth_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_L.Component_ModuleBase_01_L'", light_color = { 0, 0.6, 0 } }
-- vis
data.visuals.v_modulevis_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_S.Component_ModuleBase_01_S'", light_color = { 0.6, 0.6, 0 } }
data.visuals.v_modulevis_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_M.Component_ModuleBase_01_M'", light_color = { 0.6, 0.6, 0 } }
data.visuals.v_modulevis_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_L.Component_ModuleBase_01_L'", light_color = { 0.6, 0.6, 0 } }
-- speed
data.visuals.v_modulespeed_s = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_S.Component_ModuleBase_01_S'", light_color = { 1, 0, 0 } }
data.visuals.v_modulespeed_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_M.Component_ModuleBase_01_M'", light_color = { 1, 0, 0 } }
data.visuals.v_modulespeed_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ModuleBase_01_L.Component_ModuleBase_01_L'", light_color = { 1, 0, 0 } }

data.visuals.v_uplink_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Uplink_01_M.Component_Uplink_01_M'" }
-- data.visuals.v_dataanalyzer_m = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_DataAnalyzer_01_M.Component_DataAnalyzer_01_M'" }
data.visuals.v_scienceanalyzer_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ScienceAnalzyer_01_L.Component_ScienceAnalzyer_01_L'" }
data.visuals.v_dataanalyzer_L = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_DataAnalyzer_01_L.Component_DataAnalyzer_01_L'", }

data.visuals.v_dataanalyzer_L_Robot = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_DataAnalyzer_01_L.Component_DataAnalyzer_01_L'",
}


-----------------------------------------------
-- [ WHAT WAS THIS ? ]  - This was the Virus Bug Turret
-- data.visuals.v_virus_robot_turret_01 = { mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusTurret_01_M.Component_VirusTurret_01_M'", light_color = {0.2, 0.8, 0.1}, light_radius = 2, flags = "ComponentFaceTarget" }

-- [ VIRUS DESTABILIZER ]
data.visuals.v_virus_destabilizer = {
	-- mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusAntenna_02_M.Component_VirusAntenna_02_M'",
	mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusAntenna_04_M.Component_VirusAntenna_04_M'",
	flags = "ComponentFaceTarget",
}

-- [ WARP BRIDGE ]    This is the new Warp Bridge
data.visuals.v_virus_warp_bridge = { mesh = "StaticMesh'/Game/Meshes/Virus/GammaSet/Component_VirusPosessor_01_M/Component_VirusPosessor_01_M.Component_VirusPosessor_01_M'", light_color = {0.2, 0.8, 0.1}, light_radius = 2, flags = "ComponentFaceTarget" }

-- This is now temporarily the Virus Duplicator
data.visuals.v_virus_duplicator = { mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusAntenna_01_M.Component_VirusAntenna_01_M'" }

--  This is the new Virus Possessor
data.visuals.v_virus_possessor = { mesh = "StaticMesh'/Game/Meshes/Virus/GammaSet/Component_VirusDestabilizer_01_M/Component_VirusDestabilizer_01_M.Component_VirusDestabilizer_01_M'",  scale = { 1.2, 1.2, 1.2 }, flags = "ComponentFaceTarget" }

-----------------------------------------------

data.visuals.v_blight_magnifier = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightAntenna_01_M.Component_BlightAntenna_01_M'" }
data.visuals.v_blight_converter = { mesh = "StaticMesh'/Game/Meshes/Blight/Component_BlightAntenna_03_M.Component_BlightAntenna_03_M'" }
data.visuals.v_human_communication = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/Human_Building_Communication_01.Human_Building_Communication_01'",
	placement = "Max",
	tile_size = { 3, 3},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}
data.visuals.v_human_transport = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicle_Transport_01.Human_Vehicle_Transport_01'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_missile_launcher = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Missle_Turret_01.Human_Missle_Turret_01'", scale = { 1.5, 1.5, 1.5 },
	flags = "ComponentFaceTarget",
}

-- VIRUS Components
-- [ Virus Ray ]
data.visuals.v_virus_ray = { mesh = "StaticMesh'/Game/Meshes/Virus/GammaSet/Component_VirusRay_01_M/Component_VirusRay_01_M.Component_VirusRay_01_M'" } -- [ Virus Ray ]
-- [ Robot Hive ]
data.visuals.v_virus_decomposer_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_VirusDecomposer_01_L.Component_VirusDecomposer_01_L'" }-- [ Robot Hive ]

-- [ Component Bitlock ]
data.visuals.v_virus_robot_antenna_03 = { mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusAntenna_03_M.Component_VirusAntenna_03_M'" }-- [ Component Bitlock ]
--  This is the NEW [ COMPONENT RECYCLER ]
data.visuals.v_virus_component_recycler = { mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusTurret_01_M.Component_VirusTurret_01_M'" } -- Virus [ Component Recycler ]

--  This was the [ Component recycler / alien deconstructor ] ?
data.visuals.v_virus_robot_jammer = { mesh = "StaticMesh'/Game/Meshes/Virus/Component_VirusAntenna_01_M.Component_VirusAntenna_01_M'" } -- [ ??? ]

--data.visuals.v_virus_turret_01 = { mesh = "StaticMesh'/Game/Meshes/Virus/Virus_Turret_01.Virus_Turret_01'" }
--data.visuals.v_virus_antenna_01 = { mesh = "StaticMesh'/Game/Meshes/Virus/Virus_Antanna_01.Virus_Antanna_01'" }

-- BLIGHT Components
data.visuals.v_blight_plasmaturret_s = { mesh = "StaticMesh'/Game/Meshes/Blight/Component_BlightWeapon_01_S.Component_BlightWeapon_01_S'", flags = "ComponentFaceTarget" }

data.visuals.v_generic_i = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Generic_01_I.Component_Generic_01_I'" }

data.visuals.v_satellite = {
	sockets = {
		{ "", "Small"    },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_satellite_inventory = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Satellite.Satellite'",
}

data.visuals.v_space_satellite = {
	sockets = {
		{ "", "Small"    },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_space_satellite_inventory = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Space_Satellite.Space_Satellite'",
}

data.visuals.v_robot_s = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/RobotUnit_S_01.RobotUnit_S_01'",
	light_radius = 5,
	sockets = {
		--{ "",       "Medium"   },
		{ "Small1", "Small"    },
		{ "Small2", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

local bot_light_color = { 0.1, 0.5, 1, 4 }

data.visuals.v_bot_1s_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_A.Bot_1S_A'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1s_b = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_B.Bot_1S_B'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}


data.visuals.v_bot_1s_as = {
	--mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD.Bot_1S_AD'",
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_AD/Ver2/Bot_1S_AD.Bot_1S_AD'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1s_adw = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1S_ADW.Bot_1S_ADW'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}


data.visuals.v_bot_2m_as = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_2M_AD/Ver2/Bot_2M_AD.Bot_2M_AD'",
	--mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_2M_AD.Bot_2M_AD'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Medium1", "Medium" },
		{ "Medium2", "Medium" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	mesh_offset = { 0, 0, 10 },
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_2s_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_2S_A.Bot_2S_A'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Small1", "Small"    },
		{ "Small2", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	mesh_offset = { 0, 0, 10 },
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1m_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1M_A.Bot_1M_A'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Medium1","Medium"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1m_b = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1M_B.Bot_1M_B'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Medium1", "Medium"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1m_c = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1M_C.Bot_1M_C'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Medium1","Medium"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1m1s_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1M1S_A.Bot_1M1S_A'",
	light_radius = 5,
	light_color = bot_light_color,
	sockets = {
		{ "Medium1","Medium"   },
		{ "Small1", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	--	placement = "Max",
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_bot_1l_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_1L_A.Bot_1L_A'",
	light_radius = 8,
	light_color = bot_light_color,
	sockets = {
		{ "Large1", "Large" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_drone_transfer_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Drone_Transport_A.Drone_Transport_A'",
	flags = "RandomHeight|RandomTranslation",
	random_translation = { 0.3, 0.3, 0.45 },
	scale = {0.8, 0.8, 0.8},
	--light_radius = 8,
	--sockets = {
	--	{ "",  "Internal" },
	--	{ "",  "Internal" },
	--},
	destroy_effect = "fx_digital",
}

data.visuals.v_drone_transfer_b = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Drone_Transport_B.Drone_Transport_B'",
	flags = "RandomHeight|RandomTranslation",
	random_translation = { 0.3, 0.3, 0.45 },
	--scale = {0.8, 0.8, 0.8},
	--light_radius = 8,
	sockets = {
		{ "",  "Internal" },
		{ "",  "Internal" },
	},
	destroy_effect = "fx_digital",
}

data.visuals.v_drone_miner_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Drone_Miner_A.Drone_Miner_A'",
	flags = "RandomHeight|RandomTranslation",
	random_translation = { 0.3, 0.3, 0.45 },
	--light_radius = 8,
	sockets = {
		{ "",  "Internal" },
		{ "",  "Internal" },
	},
	destroy_effect = "fx_digital",
}

data.visuals.v_drone_adv_miner = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Drone_Miner_B.Drone_Miner_B'",
	flags = "RandomHeight|RandomTranslation",
	random_translation = { 0.3, 0.3, 0.45 },
	--light_radius = 8,
	sockets = {
		{ "",  "Internal" },
		{ "",  "Internal" },
	},
	destroy_effect = "fx_digital",
}

data.visuals.v_drone_defense_a = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Drone_Defense_A.Drone_Defense_A'",
	flags = "RandomHeight|RandomTranslation",
	random_translation = { 0.3, 0.3, 0.45 },
	--light_radius = 8,
	sockets = {
		{ "",  "Internal" },
		{ "",  "Internal" },
	},
	destroy_effect = "fx_digital",
}

data.visuals.v_robot2 = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/RobotUnit_M_01.RobotUnit_M_01'",
	light_radius = 8,
	sockets = {
		{ "Medium1", "Medium"   },
		{ "Small1",  "Small"    },
		{ "Small2",  "Small"    },
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_robot3 = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/RobotUnit_L_01.RobotUnit_L_01'",
	light_radius = 8,
	sockets = {
		{ "Medium1", "Medium" },
		{ "Medium2", "Medium" },
		{ "Small1",  "Small"  },
		{ "Small2",  "Small"  },
		{ "Small3",  "Small"  },
	},
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_robot4 = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/RobotUnit_L_02.RobotUnit_L_02'",
	light_radius = 8,
	sockets = {
		{ "Large1", "Large"    },
		{ "Small1", "Small"    },
		{ "Small2", "Small"    },
		{ "Small3", "Small"    },
		{ "Small4", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_explorable_bot = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/RobotUnit_02.RobotUnit_02'",
	sockets = {
		{ "", "Small"    },
		{ "", "Internal" },
		{ "", "Internal" },
	},
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_explorable_bot2 = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/RobotUnit_04.RobotUnit_04'",
	sockets = {
		{ "", "Small"    },
		{ "", "Internal" },
		{ "", "Internal" },
	},
	move_effect = "fx_move_bot",
	destroy_effect = "fx_digital",
}

data.visuals.v_energystorage = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Building_EnergyStorage_01_4x4.Building_EnergyStorage_01_4x4'",
	explorable_race = "anomaly",
	destroy_effect = "fx_digital",
}

-- ruined components
data.visuals.v_battery_01_l_ruined = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/RuinedComponent/Component_Battery_01_L_1x1_Ruined.Component_Battery_01_L_1x1_Ruined'",
	tile_size = { 1, 1 },
	scale = { 1.5, 1.5, 1.5, },
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_missile_launcher_m_ruined = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/RuinedComponent/Component_MissileLauncher_01_L_1X1_Ruined.Component_MissileLauncher_01_L_1X1_Ruined'",
	tile_size = { 1, 1 },
	scale = { 1.5, 1.5, 1.5, },
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_transporter_01_m_ruined = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/RuinedComponent/Component_Transporter_01_L_1x1_Ruined.Component_Transporter_01_L_1x1_Ruined'",
	flags="RandomRotation",
	scale = { 2, 2, 3, },
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_simulator_ruined = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/BB_01.BB_01'",
	tile_size = {3,3},
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_2x2_a_ruined = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/BB_04.BB_04'",
	tile_size = {2,2},
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_crashedship_2x1_moss = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Crashed_Ship_02_2x1.Crashed_Ship_02_2x1'",
	tile_size = {1, 2},
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_crashedship_2x2_moss = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Crashed_Ship_02_2x2.Crashed_Ship_02_2x2'",
	flags = "RandomRotation",
	tile_size = {2, 2},
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}
data.visuals.v_crashedship_2x1_desert = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Crashed_Ship_02_2x1.Crashed_Ship_02_2x1'",
	materials = {  "MaterialInstanceConstant'/Game/Meshes/Explorables/Crashed_Ship_Desert/MI_Crashed_Ship_Desert.MI_Crashed_Ship_Desert'" },
	tile_size = {1, 2},
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

data.visuals.v_crashedship_2x2_desert = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Crashed_Ship_02_2x2.Crashed_Ship_02_2x2'",
	materials = {  "MaterialInstanceConstant'/Game/Meshes/Explorables/Crashed_Ship_Desert/MI_Crashed_Ship_Desert.MI_Crashed_Ship_Desert'" },
	flags = "RandomRotation",
	tile_size = {2, 2},
	explorable_race = "robot",
	destroy_effect = "fx_digital",
}

---------- foundation visuals
data.visuals.v_foundation = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	specular_scale = 0.0,
}

---------- Human foundation visuals
data.visuals.v_human_foundation_basic = {
	--mesh = { "StaticMesh'/Game/Meshes/Humans/Buildings/Human_Building_Foundation_02.Human_Building_Foundation_02'" },
	mesh = "StaticMesh'/Game/Meshes/Humans/Human_Foundation_01_A.Human_Foundation_01_A'",
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
}

data.visuals.v_human_foundation1 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02a_Inst.FoundationTiling_Human_02a_Inst'",
	}
}

data.visuals.v_human_foundation2 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02b_Inst.FoundationTiling_Human_02b_Inst'",
	}
}

data.visuals.v_human_foundation3 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02c_Inst.FoundationTiling_Human_02c_Inst'",
	}
}

data.visuals.v_human_foundation4 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02d_Inst.FoundationTiling_Human_02d_Inst'",
	}
}

data.visuals.v_human_foundation5 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02e_Inst.FoundationTiling_Human_02e_Inst'",
	}
}

data.visuals.v_human_foundation6 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02f_Inst.FoundationTiling_Human_02f_Inst'",
	}
}

data.visuals.v_human_foundation7 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_02g_Inst.FoundationTiling_Human_02g_Inst'",
	}
}

data.visuals.v_human_foundation8 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_03b_Inst.FoundationTiling_Human_03b_Inst'",
	}
}

data.visuals.v_human_foundation9 = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_03c_Inst.FoundationTiling_Human_03c_Inst'",
	}
}

data.visuals.v_foundation_basic = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_B.Component_Foundation_01_B'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	specular_scale = 0.0,
}

data.visuals.v_foundation_adv = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_C.Component_Foundation_01_C'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	specular_scale = 0.0,
}

data.visuals.v_human_foundation = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_01_Inst.FoundationTiling_Human_01_Inst'",
	},
}

data.visuals.v_human_foundation_adv = {
	mesh = { "StaticMesh'/Game/Meshes/RobotBuildings/Component_Foundation_01_A.Component_Foundation_01_A'" },
	flags = "CanBePlacedOnSlopes",
	tile_size = { 1, 1},
	materials = {
		"MaterialInstanceConstant'/Game/Meshes/Humans/Foundations/FoundationTiling_Human_04a_Inst.FoundationTiling_Human_04a_Inst'",
	},
}

---------- building visuals
data.visuals.v_base1x1a = {
	--mesh = "StaticMesh'/Game/Meshes/BaseBuildings/BASE_F1-1_A.BASE_F1-1_A'",
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_A.Building_1x1_A'",
	placement = "Max",
	tile_size = { 1, 1},
	--light_color = { 1.0, 1.0, 1.0},
	--light_radius = 5,
	sockets = {
		{ "Medium1", "Medium"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base1x1b = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_B.Building_1x1_B'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "Large1", "Large"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}


data.visuals.v_base1x1c = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_C.Building_1x1_C'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "small1", "Small" },
		{ "small2", "Small" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base1x1d = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_D.Building_1x1_D'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "small1", "Small" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		--{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base1x1e = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_E.Building_1x1_E'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base1x1f = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_F.Building_1x1_F'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base1x1g = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_G.Building_1x1_G'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base1x1h = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_1x1_H.Building_1x1_H'",
	placement = "Max",
	tile_size = { 1, 1},
	sockets = {
		{ "Medium1", "Medium"   },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1a = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_A.Building_2x1_A'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "Medium2", "Medium"   },
		{ "Medium1", "Medium"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1b = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_B.Building_2x1_B'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Large1", "Large"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1c = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_C.Building_2x1_C'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1d = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_D.Building_2x1_D'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "Medium1", "Medium"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1e = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_E.Building_2x1_E'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "medium1", "Medium" },
		{ "small1", "Small"  },
		{ "small2", "Small" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1f = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_F.Building_2x1_F'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "Medium1", "Medium"   },
		{ "Small1", "Small"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x1g = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x1_G.Building_2x1_G'",
	placement = "Max",
	tile_size = { 1, 2 },
	sockets = {
		{ "Medium1", "Medium"   },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_building_fg = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_3x3_FG.Building_3x3_FG'",
	placement = "Max",
	tile_size = { 3, 3 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	light_radius = 3,
	light_color = { 1, 0.5, 0, 16 },
	light_offset = { 0.0, 0.0, 1.8 },
}

data.visuals.v_building_fg = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_3x3_FG.Building_3x3_FG'", scale = { 1.5, 1.5, 1.5 },
	placement = "Max",
	tile_size = { 5, 5 }, -- { 3, 3 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	light_radius = 3,
	light_color = { 1, 0.5, 0, 16 },
	light_offset = { 0.0, 0.0, 1.8 },
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
}

data.visuals.v_building_pf = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_3x3_PF.Building_3x3_PF'",
	placement = "Max",
	tile_size = { 3, 3 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	light_radius = 3,
	light_color = { 1, 0.0, 0, 10 },
	light_offset = { 0.0, 0.0, 2.6 },
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
}

data.visuals.v_building_sim = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/3x3_SIM.3x3_SIM'",
	placement = "Max",
	tile_size = { 3, 3},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
}

data.visuals.v_base2x2_as = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_AD/Ver2/Building_2x2_AD.Building_2x2_AD'",
	placement = "Max",
	tile_size = { 3, 3},
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "",        "Internal" },
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.update_mapping.v_base2x2A = "v_base2x2a"
data.visuals.v_base2x2a = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_A.Building_2x2_A'",
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "Large1", "Large"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.update_mapping.v_base2x2B = "v_base2x2b"
data.visuals.v_base2x2b = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_B.Building_2x2_B'",
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "Medium3", "Medium"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.update_mapping.v_base2x2C = "v_base2x2c"
data.visuals.v_base2x2c = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_C.Building_2x2_C'",
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Large1", "Large"  },
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.update_mapping.v_base2x2D = "v_base2x2d"
data.visuals.v_base2x2d = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_D.Building_2x2_D'",
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Large1", "Large"  },
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.update_mapping.v_base2x2E = "v_base2x2e"
data.visuals.v_base2x2e = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_E.Building_2x2_E'",
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Small1",  "Small"  },
		{ "Small2",  "Small"  },
		{ "Small3",  "Small"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base2x2f = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_F.Building_2x2_F'",
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Medium1", "Medium"  },
		{ "Medium2", "Medium"  },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base3x2a = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_3x2_A.Building_3x2_A'",
	placement = "Max",
	tile_size = { 3, 2},
	--light_color = { 1.0, 1.0, 1.0},
	--light_radius = 8,
	sockets = {
		{ "medium1", "Medium"  },
		{ "medium2", "Medium"  },
		{ "medium3", "Medium"  },
		{ "large1", "Large"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_base3x2b = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_3x2_B.Building_3x2_B'",
	placement = "Max",
	tile_size = { 2, 3},
	sockets = {
		{ "medium1", "Medium"  },
		{ "medium2", "Medium"  },
		{ "small1", "Small"  },
		{ "small2", "Small"    },
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_amac_01_xl = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Amac_01_XL.Component_Amac_01_XL'",
	placement = "Max",
	tile_size = { 3, 2 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal"  },
		{ "", "Internal"  },
	},
}

---------- human buildings
data.visuals.v_human_explorable_5x5_a = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Human_Explorable_5x5_A/Human_Explorable_5x5_A.Human_Explorable_5x5_A'",
	tile_size = { 5, 5},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	mesh_offset = { 0,0,1},
	sockets = { { "", "Internal" }, },
	--scale = { 0.7, 0.7, 0.7 },
	explorable_race = "human",
	explorable_name = "Data Complex",
}

data.visuals.v_human_miner = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Mech/Human_Mech_Miner_01.Human_Mech_Miner_01'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_human_adv_miner = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Mech/GammaSet/Human_MiningMech_01.Human_MiningMech_01'", scale = { 1.05, 1.05, 1.05},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
	},
}

data.visuals.v_human_commandcenter = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_3x3_CommandHQ.Human_Building_3x3_CommandHQ'", scale = { 1.15, 1.15, 1.15},
	tile_size = { 5, 4},
	placement = "Max",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_powerplant = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x2_PowerStation.Human_Building_2x2_PowerStation'", scale = { 1.25, 1.25, 1.25},
	tile_size = { 3, 3},
	placement = "Max",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

data.visuals.v_human_refinery = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x2_Refinery.Human_Building_2x2_Refinery'",
	tile_size = { 2, 2},
	placement = "Max",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_factory = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_3x3_Factory.Human_Building_3x3_Factory'",
	placement = "Max",
	tile_size = { 3, 3},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_vehiclefactory = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x2_VehicleFactory_B.Human_Building_2x2_VehicleFactory_B'",
	placement = "Max",
	tile_size = { 2, 2},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_barracks = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x2_Barracks.Human_Building_2x2_Barracks'",
	placement = "Max",
	tile_size = { 2, 2},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

data.visuals.v_human_spaceport = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_3x3_SpacePort.Human_Building_3x3_SpacePort'",
	placement = "Max",
	tile_size = { 3, 3},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_sciencelab = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x2_ScienceLab.Human_Building_2x2_ScienceLab'",
	placement = "Max",
	tile_size = { 2, 2},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_warehouse = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x4_Warehouse.Human_Building_2x4_Warehouse'",
	placement = "Max",
	tile_size = { 4, 2},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

data.visuals.v_human_sensor_array = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_2x2_CommsBuilding.Human_Building_2x2_CommsBuilding'",
	placement = "Max",
	tile_size = { 2, 2},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_bunker = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/Human_Building_Bunker_01.Human_Building_Bunker_01'",
	placement = "Max",
	tile_size = { 2, 2},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

data.visuals.v_heavy_bunker = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/Human_Building_Bunker_02.Human_Building_Bunker_02'", scale = { 1.5, 1.5, 1.5 },
	placement = "Max",
	tile_size = { 3, 3},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "medium1", "Medium"  },
		{ "", "Internal" },
	},
}

data.visuals.v_human_lander = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/GammaSet/Human_Vehicle_Dropship_02.Human_Vehicle_Dropship_02'",
	scale = { 1.05, 1.05, 1.05, },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_datacomplex = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Buildings/GammaSet/Human_Building_5x5_BlightResearch.Human_Building_5x5_BlightResearch'",
	placement = "Max",
	tile_size = { 5, 5},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_carrier = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Mech/GammaSet/Human_CarrierMech_01.Human_CarrierMech_01'", scale = { 1.05, 1.05, 1.05},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
	},
}

data.visuals.v_human_infantrymech = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Mech/GammaSet/Human_CombatMech_01.Human_CombatMech_01'", scale = { 1.1, 1.1, 1.1},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_large_tankframe = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicles_02/Human_Missile_Tank_02.Human_Missile_Tank_02'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Large1", "Large" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_flyer = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicle_Bird_01.Human_Vehicle_Bird_01'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	mesh_offset = { 0,0,200},
}

data.visuals.v_human_lighttank = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicle_Tank_01.Human_Vehicle_Tank_01'", scale = { 0.65, 0.65, 0.65 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Small1", "Small" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_tank = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicles_02/Human_Vehicle_Tank_02.Human_Vehicle_Tank_02'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Medium1", "Medium" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_light_turret = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_LightTurret_01.Human_LightTurret_01'", scale = { 0.8, 0.8, 0.8 },
	flags = "ComponentFaceTarget",
}

data.visuals.v_human_tank_turret = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicles_02/Human_Vehicle_Top_02.Human_Vehicle_Top_02'",
	flags = "ComponentFaceTarget",
}

data.visuals.v_human_rover = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicles_02/Human_Rover_02.Human_Rover_02'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_aiexplorer = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicles_02/Human_AI_Explorer_02.Human_AI_Explorer_02'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
}

data.visuals.v_human_buggy_upgraded = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicles_02/Human_Vehicle_Buggy_02.Human_Vehicle_Buggy_02'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" }
	},
}

data.visuals.v_human_buggy = {
	mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicle_Buggy_01.Human_Vehicle_Buggy_01'",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" } }
}

data.visuals.v_human_buggy_broken = {
	mesh = "StaticMesh'/Game/Meshes/four_inventory.four_inventory'",
	meshes = {
		{
			mesh = "StaticMesh'/Game/Meshes/Humans/Vehicles/Human_Vehicle_Buggy_01.Human_Vehicle_Buggy_01'",
			transforms = { { { 0, 0, -10 }, { 15.0000000, -29.9832821, 30.0000000 }, { 1, 1, 1 }, }, },
		},
	},
	inventory_slots = { {} }, -- need at least one, this hides it inside the mesh
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

---------- alien visuals
local alien_color = { 1.0, 0.05, 0.0, 4.0}
local alien_ss = 0.5

data.visuals.v_alien_extractor_dead = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/AlienBuilding_2X2_ExtractorDead.AlienBuilding_2X2_ExtractorDead'",
	tile_size = {2, 2},
	flags = "RandomRotation",
	destroy_effect = "fx_digital",
	sockets = { { "", "Internal" }, { "", "Internal" }, },
	explorable_race = "alien",
}

data.visuals.v_alien_feeder_dead = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/AlienBuilding_2X2_FeederDead.AlienBuilding_2X2_FeederDead'",
	tile_size = {2, 2},
	destroy_effect = "fx_digital",
	flags = "RandomRotation",
	sockets = { { "", "Internal" }, { "", "Internal" }, },
	explorable_race = "alien",
}

data.visuals.v_alien_soldier = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Soldier_02/AlienUnit_Soldier_A_new.AlienUnit_Soldier_A_new'", scale = { 0.85, 0.85, 0.85 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, }, --{ "", "Internal" },
	explorable_race = "alien"
}

data.visuals.v_hybrid_alien_soldier = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Soldier_Hybrid_01/Alien_Soldier_Hybrid_01.Alien_Soldier_Hybrid_01'", scale = { 0.9, 0.9, 0.9 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Small1", "Small" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
	explorable_race = "alien"
}

data.visuals.v_alien_hvy_soldier = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Soldier_01/Alien_Soldier_01.Alien_Soldier_01'", scale = { 1.1, 1.1, 1.1 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, }, --{ "", "Internal" },
	explorable_race = "alien"
}

data.visuals.v_alien_smallframe = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Tank_01/Alien_Tank_01.Alien_Tank_01'", scale = { 0.7, 0.7, 0.7 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Small1", "Small" },
		{ "", "Internal" },
	},
}

data.visuals.v_alien_tankframe = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Tank_02/Alien_Tank_02.Alien_Tank_02'", scale = { 0.6, 0.6, 0.6 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Medium1", "Medium" },
		{ "", "Internal" },
	},
}

data.visuals.v_alien_scout = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/AlienUnit_01/AlienUnit_Scout_A.AlienUnit_Scout_A'", scale = { 0.8, 0.8, 0.8 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, { "", "Internal" }, },
}

data.visuals.v_alien_probe = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_Probe_01/Alien_Probe_01.Alien_Probe_01'", scale = { 0.3, 0.3, 0.3 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_virus_teleporter = {
	mesh = "StaticMesh'/Game/Meshes/Virus/Virus_Warp_Point.Virus_Warp_Point'",-- scale = { 0.2, 0.2, 0.2 },
	light_color = { 0.1, 1.0, 0.2, 20},
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

data.visuals.v_alien_transport = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_StorageTransport_01/Alien_StorageTransport_01.Alien_StorageTransport_01'", scale = { 0.7, 0.7, 0.7 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, }, -- { "", "Internal" },
}

data.visuals.v_alien_pincer = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/AlienUnit_Transport_A/AlienUnit_Transport_A_02.AlienUnit_Transport_A_02'", scale = { 0.9, 0.9, 0.9 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, }, -- { "", "Internal" },
}

data.visuals.v_alien_extractor = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_Extractor_02/Alien_Building_2x2_Extractor_02.Alien_Building_2x2_Extractor_02'", scale = { 0.85, 0.85, 0.85 },
	tile_size = { 2, 2 },
	meshes = data.visualmeshes.alien_foundation_2x2,
	--flags = "RandomRotation",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

data.visuals.v_alien_feeder = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_Feeder_02/Alien_Building_2x2_Feeder_02.Alien_Building_2x2_Feeder_02'",
	light_radius = 5,
	tile_size = { 2, 2 },
	--flags = "RandomRotation",
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	--materials = {  "MaterialInstanceConstant'/Game/Materials/Glitch/M_GlitchScene_Inst.M_GlitchScene_Inst'" },
	placement = "Max",
}

data.visuals.v_alien_producer = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/AlienBuilding_2X2_Producer.AlienBuilding_2X2_Producer'", scale = { 1.4, 1.4, 1.4 },
	light_radius = 5,
	tile_size = { 3, 3 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

data.visuals.v_alien_researcher = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/AlienBuilding_2X2_Research.AlienBuilding_2X2_Research'", scale = { 1.2, 1.2, 1.2 },
	light_radius = 5,
	tile_size = { 2, 2 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

data.visuals.v_alien_storage = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_Storage_01/Alien_Building_2x2_Storage_01.Alien_Building_2x2_Storage_01'", scale = { 1, 1, 1 },
	light_radius = 5,
	tile_size = { 2, 2 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

data.visuals.v_alien_sensortower = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/AlienBuilding_SensorTower.AlienBuilding_SensorTower'", scale = { 0.8, 0.8, 0.8 },
	meshes = data.visualmeshes.alien_foundation_1x1,
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 5,
	tile_size = { 1, 1 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

data.visuals.v_alien_socketbuilding = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_Socket_L_01/Alien_Building_2x2_Socket_L_01.Alien_Building_2x2_Socket_L_01'", scale = { 0.75, 0.75, 0.75 },
	meshes = data.visualmeshes.alien_foundation_2x2,
	tile_size = { 2, 2 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "Large1", "Large"    },
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
		{ "", "Internal" },
	},
	placement = "Max",
}

data.visuals.v_alien_reformingpool = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_ReformingPool_01/Alien_Building_2x2_ReformingPool.Alien_Building_2x2_ReformingPool'", scale = { 1.15, 1.15, 1.15 },
	light_radius = 5,
	tile_size = { 2, 2 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	placement = "Max",
	sockets = {
		{ "", "Internal" },
	},
}

data.visuals.v_alien_miner = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/AlienBuilding_2X2_Miner.AlienBuilding_2X2_Miner'",
	-- tile_size = { 2, 2 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

data.visuals.v_alien_teleporter = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_Teleporter_02/Alien_Building_2x2_Teleporter_02.Alien_Building_2x2_Teleporter_02'", scale = { 1.4, 1.4, 1.4 },
	meshes = data.visualmeshes.alien_foundation_2x2,
	tile_size = { 3, 3 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, }, --  { "", "Internal" },
	placement = "Max",
}

data.visuals.v_alien_turret = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_2x2_Turret_02/AlienBuilding_2x2_Turret.AlienBuilding_2x2_Turret'", scale = { 0.8, 0.8, 0.8 },
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
}

data.visuals.v_alien_pylon = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_1x1_Pylon_2/Alien_Building_1X1_Pylon.Alien_Building_1X1_Pylon'", scale = { 1.1, 1.1, 1.1 },
	meshes = data.visualmeshes.alien_foundation_1x1,
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

data.visuals.v_hybrid_worker = {
	mesh = "StaticMesh'/Game/Meshes/AlienFaction/GammaSet/Alien_ArtificialWorkerSoul_01/Alien_ArtificialWorkerSoul_01.Alien_ArtificialWorkerSoul_01'", scale = { 1, 1, 1 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 4,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, { "", "Internal" }, },
}

data.visuals.v_spacedrop_1 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/SpaceDrop_01.SpaceDrop_01'",
	tile_size = { 1, 1},
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}

---------- explorable visuals
data.visuals.v_explorable_brokenship_1 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Explorable_SpaceDrop_01.Explorable_SpaceDrop_01'",
	tile_size = { 1, 1 },
	destroy_effect = "fx_digital",
	--explorable_race = "robot", -- commented out to not give out robot rewards
}

data.visuals.v_explorable_glitchbuilding = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Explorable_SpaceDrop_01.Explorable_SpaceDrop_01'",
	tile_size = { 1, 1 },
	destroy_effect = "fx_digital",
	explorable_race = "anomaly",
}

-- 4 - power
data.visuals.v_explorable_building_4 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Ver2/ExplorableBuilding_04.ExplorableBuilding_04'",
	tile_size = {3, 3},
	sockets = { { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, },
	scale = {2.4, 2.4, 2.4},
	destroy_effect = "fx_digital",
	explorable_race = "human",
	explorable_name = "Power Plant",
}

-- 2 - storage
data.visuals.v_explorable_building_2 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Ver2/ExplorableBuilding_02.ExplorableBuilding_02'",
	tile_size = {3, 3},
	sockets = { { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, },
	scale = {3.3, 3.3, 3.3},
	destroy_effect = "fx_digital",
	explorable_race = "human",
	explorable_name = "Warehouse",
}

-- 6 - factory
data.visuals.v_explorable_building_6 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Ver2/ExplorableBuilding_06.ExplorableBuilding_06'",
	tile_size = {3, 3},
	sockets = { { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, },
	scale = {2.3, 2.3, 2.3},
	destroy_effect = "fx_digital",
	explorable_race = "human",
	explorable_name = "Factory",
}

-- 3 - research
data.visuals.v_explorable_building_3 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/Ver2/ExplorableBuilding_03.ExplorableBuilding_03'",
	tile_size = {3, 3},
	sockets = { { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, { "", "Internal" }, },
	scale = {2.4, 2.4, 2.4},
	destroy_effect = "fx_digital",
	explorable_race = "human",
	explorable_name = "Research Lab",
}

-- scatter
data.visuals.v_crystalscatter_node1 = {
	--mesh = "StaticMesh'/Game/Meshes/Scatter/ScatterCrystal_01.ScatterCrystal_01'",
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Pickup_01/SM_Resource_Crystal_Pickup_01.SM_Resource_Crystal_Pickup_01'",
	flags = "RandomRotation | RandomScale | RandomTranslation | NoShadows | AlignToTerrain",
	tile_size = { 1, 1},
	scale = { 2, 2, 2, },
}

data.visuals.v_silicascatter_node1 = {
	--mesh = "StaticMesh'/Game/Meshes/Scatter/ScatterSilica_01.ScatterSilica_01'",
	mesh = "StaticMesh'/Game/Cai/Resources/Silica/Pickup_01/SM_Resource_Silica_Pickup_01.SM_Resource_Silica_Pickup_01'",
	flags = "RandomRotation | RandomScale | RandomTranslation | NoShadows | AlignToTerrain",
	scale = { 2, 2, 2, },
}

----- METAL

data.visuals.v_metalpickup1a = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/MetallicOre/ResourceMetallicOre_01.ResourceMetallicOre_01'",
	mesh = "StaticMesh'/Game/Cai/Resources/Iron/Pickup_02/SM_Resource_Iron_Pickup_02.SM_Resource_Iron_Pickup_02'",
	flags = "RandomRotation | RandomTranslation | AlignToTerrain",
	--scale = { 0.5, 0.5, 0.5 },
	--mesh_offset = { 0, 0, 0 },
}


data.visuals.v_metalsmall1a = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/MetallicOre/ResourceMetallicOre_01.ResourceMetallicOre_01'",
	mesh = "StaticMesh'/Game/Cai/Resources/Iron/Pickup_01/SM_Resource_Iron_Pickup_01.SM_Resource_Iron_Pickup_01'",
	flags = "RandomRotation | RandomTranslation",
	scale = { 0.8, 0.8, 0.8 },
	-- mesh_offset = { 0, 0, 0 },
}

data.visuals.v_metalmedium1a = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/MetallicOre/Ver02/ResourceMetallicOre_01_C.ResourceMetallicOre_01_C'",
	mesh = "StaticMesh'/Game/Cai/Resources/Iron/Medium/SM_Resource_Iron_Medium_01.SM_Resource_Iron_Medium_01'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 0.75, 0.75, 0.75 },
	--mesh_offset = { 0, 0, -5 },
}

data.visuals.v_metalmedium2a = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/MetallicOre/Ver02/ResourceMetallicOre_01_C.ResourceMetallicOre_01_C'",
	mesh = "StaticMesh'/Game/Cai/Resources/Iron/Medium_02/SM_Resource_Iron_Medium_02.SM_Resource_Iron_Medium_02'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 0.8, 0.8, 0.8 },
	--mesh_offset = { 0, 0, -5 },
}

data.visuals.v_metalrich1 = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/MetallicOre/Ver02/ResourceMetallicOre_01_B.ResourceMetallicOre_01_B'",
	mesh = "StaticMesh'/Game/Cai/Resources/Iron/Large/SM_Resource_Iron_Large_01.SM_Resource_Iron_Large_01'",
	flags = "RandomRotation",
	placement = "Min",
	tile_size = {2, 2},
	scale = { 0.8, 0.8, 0.8 },
}

data.visuals.v_metalrich2 = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/MetallicOre/Ver02/ResourceMetallicOre_01_A.ResourceMetallicOre_01_A'",
	mesh = "StaticMesh'/Game/Cai/Resources/Iron/Large_02/SM_Resource_Iron_Large_02.SM_Resource_Iron_Large_02'",
	flags = "RandomRotation",
	placement = "Min",
	tile_size = {2, 2},
	scale = { 0.9, 0.9, 0.9 },
}

----- CRYSTAL
data.visuals.v_blightcrystal1a = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Medium_01/SM_Resource_Crsytal_Medium_01.SM_Resource_Crsytal_Medium_01'",
	materials = {
		"MaterialInstanceConstant'/Game/Cai/Resources/Blight/MI_Resource_Blight_Medium_01.MI_Resource_Blight_Medium_01'",
		"MaterialInstanceConstant'/Game/Cai/Resources/Blight/Impostors/MI_Resource_Blight_Medium_01_Impostor.MI_Resource_Blight_Medium_01_Impostor'",
	},
	flags = "RandomRotation | RandomScale",
}
data.visuals.v_blightcrystal1b = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Medium_02/SM_Resource_Crystal_Medium_02.SM_Resource_Crystal_Medium_02'",
	materials = {
		"MaterialInstanceConstant'/Game/Cai/Resources/Blight/MI_Resource_Blight_Medium_02.MI_Resource_Blight_Medium_02'",
		"MaterialInstanceConstant'/Game/Cai/Resources/Blight/Impostors/MI_Resource_Blight_Medium_02_Impostor.MI_Resource_Blight_Medium_02_Impostor'",
	},
	flags = "RandomRotation | RandomScale",
}
data.visuals.v_blightcrystal_small1 = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Small_01/SM_Resource_Crystal_Small_01.SM_Resource_Crystal_Small_01'",
	materials = {
		"MaterialInstanceConstant'/Game/Cai/Resources/Blight/MI_Resource_Blight_Pickup_01.MI_Resource_Blight_Pickup_01'",
		"MaterialInstanceConstant'/Game/Cai/Resources/Blight/Impostors/MI_Resource_Blight_Small_01_Impostor.MI_Resource_Blight_Small_01_Impostor'",
	},
	flags = "RandomRotation | RandomTranslation | RandomScale | NoShadows",
}

data.visuals.v_crystal_rich1 = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Large_01/SM_Resource_Crystal_Large_01.SM_Resource_Crystal_Large_01'",
	flags = "RandomRotation",
	tile_size = {3, 3},
	placement = "Min",
	--[[
	tile_pattern = {
		0, 1, 1, 1, 0,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		0, 1, 1, 1, 0,
	},
	--]]
	scale = { 0.8, 0.8, 0.8 },
}

-- instanced Crystals
data.visuals.v_crystalmedium1a = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Medium_01/SM_Resource_Crsytal_Medium_01.SM_Resource_Crsytal_Medium_01'",
	flags = "RandomRotation | RandomScale",
}

data.visuals.v_crystalmedium1b = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Medium_02/SM_Resource_Crystal_Medium_02.SM_Resource_Crystal_Medium_02'",
	flags = "RandomRotation | RandomScale",
}

data.visuals.v_crystalsmalla = {
	mesh = "StaticMesh'/Game/Cai/Resources/Crystal/Small_01/SM_Resource_Crystal_Small_01.SM_Resource_Crystal_Small_01'",
	flags = "RandomRotation | RandomTranslation | RandomScale | NoShadows",
}

---- OBSIDIAN
data.visuals.v_obsidian_large = { --v_obsidian_node1 = {
	mesh = "StaticMesh'/Game/Cai/Resources/Obsidian/Large_02/SM_Resource_Obsidian_Large_02.SM_Resource_Obsidian_Large_02'",
	flags = "RandomRotation | RandomScale",
}
data.visuals.v_obsidian_medium = { --v_obsidian_node2 = {
	mesh = "StaticMesh'/Game/Cai/Resources/Obsidian/Medium_01/SM_Resource_Obsidian_Medium_01.SM_Resource_Obsidian_Medium_01'",
	flags = "RandomRotation | RandomScale | RandomTranslation",
}

---- LATERITE

data.visuals.v_laterite_node_large1 = {
	--	mesh = "StaticMesh'/Game/Meshes/Resources/Laterite/Ver02/ResourceLaterite_01_A.ResourceLaterite_01_A'",
	mesh = "StaticMesh'/Game/Cai/Resources/Laterite/Large_01/SM_Resource_Laterite_Large_01.SM_Resource_Laterite_Large_01'",
	flags = "RandomRotation | RandomScale",
	placement = "Min",
	tile_size = {3, 3},
	--	scale = { 0.45, 0.45, 0.4 },
}

--[[
	data.visuals.v_laterite_node_large2 = {
	mesh = "StaticMesh'/Game/Meshes/Resources/Laterite/Ver02/ResourceLaterite_01_B.ResourceLaterite_01_B'",
	flags = "RandomRotation | RandomScale",
	placement = "Min",
	tile_size = {2, 2},
	scale = { 0.35, 0.35, 0.2 },
}
--]]

data.update_mapping.v_laterite_node1 = "v_laterite_medium1"
data.visuals.v_laterite_medium1 = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/Laterite/Ver02/ResourceLaterite_01_C.ResourceLaterite_01_C'",
	mesh = "StaticMesh'/Game/Cai/Resources/Laterite/Medium_01/SM_Resource_Laterite_Medium_01.SM_Resource_Laterite_Medium_01'",
	flags = "RandomRotation  | RandomScale | RandomTranslation | AlignToTerrain",
	placement = "Min",
	--scale = { 0.6, 0.6, 0.6 },
}

data.update_mapping.v_laterite_node2 = "v_laterite_small1"
data.visuals.v_laterite_small1 = {
	-- mesh = "StaticMesh'/Game/Meshes/Resources/Laterite/Ver02/ResourceLaterite_01_D.ResourceLaterite_01_D'",
	mesh = "StaticMesh'/Game/Cai/Resources/Laterite/Small_01/SM_Resource_Laterite_Small_01.SM_Resource_Laterite_Small_01'",
	flags = "RandomRotation  | RandomScale | RandomTranslation | AlignToTerrain",
	placement = "Min",
	--scale = { 0.6, 0.6, 0.6 },
}

---- SILICA
data.visuals.v_silica_node = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/Silica/Ver02/ResourceSilica_B.ResourceSilica_B'",
	mesh = "StaticMesh'/Game/Cai/Resources/Silica/Large_01/SM_Resource_Silica_Large_01.SM_Resource_Silica_Large_01'",
	flags = "RandomRotation | RandomScale | AlignToTerrain",
	placement = "Average",
	sockets = {
		{ "large1", "Large" },
	},
	tile_size = {2, 2},
	scale = {0.9, 0.9, 0.9},
}

data.visuals.v_silica_medium1 = {
	--mesh = "StaticMesh'/Game/Meshes/Resources/Silica/Ver02/ResourceSilica_C.ResourceSilica_C'",
	mesh = "StaticMesh'/Game/Cai/Resources/Silica/Medium_01/SM_Resource_Silica_Medium_01.SM_Resource_Silica_Medium_01'",
	flags = "RandomRotation | RandomScale | RandomTranslation | AlignToTerrain",
	placement = "Average",
}

-- blocking rocks on the plateau
local decorock_cull_dist = 1
data.visuals.v_decorationrock_largeplateau_1a = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_LargePlateau_01_A.DecorationRock_LargePlateau_01_A'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Min", tile_size = { 4, 4 }, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_1b = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_LargePlateau_01_B.DecorationRock_LargePlateau_01_B'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Min", tile_size = { 4, 4 }, scale = { 1.5, 1.5, 2.0, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_1c = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_LargePlateau_01_C.DecorationRock_LargePlateau_01_C'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Min", tile_size = { 4, 4 }, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }

data.visuals.v_decorationrock_largeplateau_2a = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_MediumPlateau_01_A.DecorationRock_MediumPlateau_01_A'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = { 2, 2 }, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_2b = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_MediumPlateau_01_B.DecorationRock_MediumPlateau_01_B'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = { 2, 2 }, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_2c = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_MediumPlateau_01_C.DecorationRock_MediumPlateau_01_C'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = { 2, 2 }, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_2d = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_MediumPlateau_01_D.DecorationRock_MediumPlateau_01_D'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = { 2, 2 }, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }

data.visuals.v_decorationrock_largeplateau_3a = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_SmallPlateau_01_A.DecorationRock_SmallPlateau_01_A'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = {1, 1}, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_3b = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_SmallPlateau_01_B.DecorationRock_SmallPlateau_01_B'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = {1, 1}, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_3c = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_SmallPlateau_01_C.DecorationRock_SmallPlateau_01_C'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = {1, 1}, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_decorationrock_largeplateau_3d = { mesh = "StaticMesh'/Game/Meshes/Decoration/Rocks/PlateauRock_Ver02/DecorationRock_SmallPlateau_01_D.DecorationRock_SmallPlateau_01_D'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = {1, 1}, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }

data.visuals.v_damage_plant = { mesh = "StaticMesh'/Game/Meshes/Foliage/Shrub/FoliageShrubType_06_a.FoliageShrubType_06_a'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = {1, 1}, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }
data.visuals.v_phase_plant = { mesh = "StaticMesh'/Game/Meshes/Foliage/Fungus/FungusType_08.FungusType_08'", flags = "RandomRotation | RandomScale | AlignToTerrain", placement = "Average", tile_size = {1, 1}, scale = { 1, 1, 1, }, cull_ratio = decorock_cull_dist }

-- bug frame visuals
--data.visuals.v_bugtree = { mesh = "StaticMesh'/Game/Meshes/Foliage/Tree/TreeType_08_A.TreeType_08_A'", flags = "RandomRotation | RandomScale", }
data.visuals.v_bughive = {
	mesh = "StaticMesh'/Game/Meshes/Trilobyte/Buildings/TrilobyteHive_01.TrilobyteHive_01'",
	flags = "RandomRotation | RandomScale",
	scale = {2, 2, 2},
	tile_size = {2,2},
	animation_speed = 1,
	destroy_effect = "fx_greensplat_4",
}

data.visuals.v_egg1 = {
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Gastarias/Meshes/BP_Egg.BP_Egg_C'",
}

data.visuals.v_bughive_large = {
	mesh = "StaticMesh'/Game/Meshes/Trilobyte/Buildings/TrilobyteHive_01.TrilobyteHive_01'",
	flags = "RandomRotation | RandomScale",
	sockets = {
		{ "",        "Internal" },
	},
	scale = {3, 3, 3},
	tile_size = {3,3},
	animation_speed = 1,
	destroy_effect = "fx_greensplat_4",
}

data.visuals.v_bughole = {
	mesh = "StaticMesh'/Game/Meshes/Trilobyte/Buildings/TrilobyteHive_01_Entrance.TrilobyteHive_01_Entrance'",
	flags = "RandomRotation | RandomScale",
	scale = {2, 2, 2},
	destroy_effect = "fx_greensplat_4",
}

data.visuals.v_trilobite1 = {
	frame_class = "Blueprint'/Game/TrilobitesCollection/Trilobite_01/Trilobite_01BP.Trilobite_01BP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_wasp1 = {
	frame_class = "Blueprint'/Game/ToxicWasp/Wasp_BP1.Wasp_BP1_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
	flags = "RandomTranslation|RandomHeight",
	mesh_offset = { 0, 0, 35 },
	random_translation = { 0.5, 0.5, 0.5 },
}

data.visuals.v_trilobite1a = {
	frame_class = "Blueprint'/Game/TrilobitesCollection/Trilobite_01/Trilobite_01BPA.Trilobite_01BPA_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_trilobite1b = {
	frame_class = "Blueprint'/Game/TrilobitesCollection/Trilobite_01/Trilobite_01BPB.Trilobite_01BPB_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_gastarias1 = {
	tile_size = { 1, 1 },
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Gastarias/Meshes/Gastarias_FBP.Gastarias_FBP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_gastarias2 = {
	tile_size = { 1, 1 },
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Gastarias/Meshes/Gastarias2_FBP.Gastarias2_FBP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_scaramar1 = {
	tile_size = { 1, 1 },
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Scaramar/Meshes/SK_Scaramar_FBP.SK_Scaramar_FBP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_scaramar2 = {
	tile_size = { 1, 1 },
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Scaramar/Meshes/SK_Scaramar_Flyer_FBP.SK_Scaramar_Flyer_FBP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
	flags = "RandomTranslation|RandomHeight",
	mesh_offset = { 0, 0, 220 },
	random_translation = { 0.5, 0.5, .75 },
}


data.visuals.v_gastarid1 = {
	tile_size = { 1, 1 },
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Gastarid/Meshes/SK_Gastarid_FBP.SK_Gastarid_FBP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_charcharosaurus1 = {
	tile_size = { 1, 1 },
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Charcharosaurus/Meshes/SK_Charcharosaurus_FBP.SK_Charcharosaurus_FBP_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_EMP",
}

data.visuals.v_larva1 = {
	frame_class = "Blueprint'/Game/Worm/Mesh/BP_Larva.BP_Larva_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
}

data.visuals.v_larva2 = {
	frame_class = "Blueprint'/Game/Worm/Mesh/BP_Larva.BP_Larva_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	scale = { 0.5, 0.5, 0.5 },
	move_effect = "fx_move_bug",
}

data.visuals.v_worm1 = {
	frame_class = "Blueprint'/Game/Worm/Mesh/BP_Worm.BP_Worm_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_lucanops1 = {
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Lucanops/BP_Lucanops.BP_Lucanops_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_tetrapuss1 = {
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Tetrapuss/BP_Tetrapuss.BP_Tetrapuss_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

data.visuals.v_tripodonte1 = {
	frame_class = "Blueprint'/Game/SciFiCreaturesVol1/Tripodonte/BP_Tripodonte.BP_Tripodonte_C'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
	move_effect = "fx_move_bug",
	destroy_effect = "fx_greensplat_2",
}

local foliage_flags = "RandomRotation|RandomTranslation|RandomScale"
local small_foliage_flags = "RandomRotation|RandomTranslation|RandomScale|SmallObject"
local tree_cull_distance = 1 / 1.5

-- forest of trees
data.visuals.v_tree12a1 = { mesh = "StaticMesh'/Game/Meshes/Foliage/Tree/TreeType_12_A1.TreeType_12_A1'", flags = foliage_flags, destroy_effect = "fx_smalldigital", cull_ratio = tree_cull_distance, scale = {1.5, 1.5, 1.5} }
data.visuals.v_tree12a2 = { mesh = "StaticMesh'/Game/Meshes/Foliage/Tree/TreeType_12_A2.TreeType_12_A2'", flags = foliage_flags, destroy_effect = "fx_smalldigital", cull_ratio = tree_cull_distance, scale = {2, 2, 2}  }
data.visuals.v_tree12a3 = { mesh = "StaticMesh'/Game/Meshes/Foliage/Tree/TreeType_12_A3.TreeType_12_A3'", flags = foliage_flags, destroy_effect = "fx_smalldigital", cull_ratio = tree_cull_distance, scale = {1.5, 1.5, 1.5} }
data.visuals.v_tree12a5 = { mesh = "StaticMesh'/Game/Meshes/Foliage/Tree/TreeType_12_A5.TreeType_12_A5'", flags = foliage_flags, destroy_effect = "fx_smalldigital", cull_ratio = tree_cull_distance, scale = {5, 5, 5}  }

-- clusters trees
data.visuals.v_tree4a = { mesh = "StaticMesh'/Game/Meshes/Foliage/Tree/TreeType_04_A.TreeType_04_A'", flags = foliage_flags, destroy_effect = "fx_smalldigital", cull_ratio = tree_cull_distance, }


local short_cull_distance = 1 / 3
local medium_cull_distance = 1 / 2
local long_cull_distance = 4 / 5 -- long cull distance set to where fade out starts

----------------- PLATEAU
local container_cull_distance = 1 / 2
data.visuals.v_obsidian_brick = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Obsidian_Bricks.Containers_Obsidian_Bricks'", cull_ratio = container_cull_distance }
data.visuals.v_silica = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Silica.Containers_Silica'", cull_ratio = container_cull_distance, }
---
data.visuals.v_bot_ai_core = { mesh = "StaticMesh'/Game/Meshes/Containers/Container_Ai_Core.Container_Ai_Core'", cull_ratio = container_cull_distance, }
data.visuals.v_simulation_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Simulation_Data.Containers_Simulation_Data'", cull_ratio = container_cull_distance, }
data.visuals.v_advanced_robotics_research = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Advanced_Robotics.Containers_Advanced_Robotics'", cull_ratio = container_cull_distance, }
data.visuals.v_human_research_item = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Human_Intel.Containers_Human_Intel'", cull_ratio = container_cull_distance, }
data.visuals.v_alien_research_item = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Alien_Research.Containers_Alien_Research'", cull_ratio = container_cull_distance, }
data.visuals.v_blight_research_item = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Research.Containers_Blight_Research'", cull_ratio = container_cull_distance, }
data.visuals.v_virus_research = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Virus_Research.Containers_Virus_Research'", cull_ratio = container_cull_distance, }
---
data.visuals.v_alien_artifact = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Alien.Containers_Alien'", cull_ratio = container_cull_distance, }
data.visuals.v_blight_plasma = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Alien_Food.Containers_Alien_Food'", cull_ratio = container_cull_distance, }
data.visuals.v_plasma_crystal = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Plasma_Crystal.Containers_Plasma_Crystal'", cull_ratio = container_cull_distance, }
---
data.visuals.v_gears = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Box_Gears.Containers_Box_Gears'", cull_ratio = container_cull_distance, }
data.visuals.v_small_reactor = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Smallreactor.Containers_Smallreactor'", cull_ratio = container_cull_distance, }
data.visuals.v_engine = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Engine.Containers_Engine'", cull_ratio = container_cull_distance, }
data.visuals.v_microscope = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Microscope.Containers_Microscope'", cull_ratio = container_cull_distance, }
data.visuals.v_transformer = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Transformer.Containers_Transformer'", cull_ratio = container_cull_distance, }
data.visuals.v_circuit_board = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_CircuitBoard.Containers_CircuitBoard'", cull_ratio = container_cull_distance, }
data.visuals.v_circuit_board_infected = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_InfectedCircuitBoard.Containers_InfectedCircuitBoard'", cull_ratio = container_cull_distance, }

data.visuals.v_cpu = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_CPU.Containers_CPU'", cull_ratio = container_cull_distance, }
data.visuals.v_micropro = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Microprocessor.Containers_Microprocessor'", cull_ratio = container_cull_distance, }
data.visuals.v_icchip = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_IC_Chips.Containers_IC_Chips'", cull_ratio = container_cull_distance, }
---
data.visuals.v_wire = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Wires.Containers_Wires'", cull_ratio = container_cull_distance, }
data.visuals.v_cable = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Cable.Containers_Cable'", cull_ratio = container_cull_distance, }
data.visuals.v_optic_cable = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Optic_Cable.Containers_Optic_Cable'", cull_ratio = container_cull_distance, }
data.visuals.v_silicon = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Silicon.Containers_Silicon'", cull_ratio = container_cull_distance, }
data.visuals.v_fused_electrodes = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Fused_Electrodes.Containers_Fused_Electrodes'", cull_ratio = container_cull_distance, }
---
--[[ -- UNUSED / OLD ENTRIES
data.visuals.v_blight_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Data.Containers_Blight_Data'", cull_ratio = container_cull_distance, }
]]
data.visuals.v_robot_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Container_RobotDataCube.Container_RobotDataCube'", cull_ratio = container_cull_distance, }
data.visuals.v_alien_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Container_AlienResearch.Container_AlienResearch'", cull_ratio = container_cull_distance, }
data.visuals.v_human_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Container_HumanResearch.Container_HumanResearch'", cull_ratio = container_cull_distance, }
data.visuals.v_virus_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Container_VirusResearch.Container_VirusResearch'", cull_ratio = container_cull_distance, }
---
data.visuals.v_crystal_powder = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Crystal_Powerer.Containers_Crystal_Powerer'", cull_ratio = container_cull_distance, }
data.visuals.v_refined_crystal = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Refined_Crystal.Containers_Refined_Crystal'", cull_ratio = container_cull_distance, }

---
data.visuals.v_metalplate = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Metal_Plates.Containers_Metal_Plates'", cull_ratio = container_cull_distance, }
data.visuals.v_reinforced_plate = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Reinforced_Plate.Containers_Reinforced_Plate'", cull_ratio = container_cull_distance, }
data.visuals.v_low_density_frame = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Low_Density_Frame.Containers_Low_Density_Frame'", cull_ratio = container_cull_distance, }
data.visuals.v_high_density_frame = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_High_Density_Frame.Containers_High_Density_Frame'", cull_ratio = container_cull_distance, }
data.visuals.v_energized_plate = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Energized_Plate.Containers_Energized_Plate'", cull_ratio = container_cull_distance, }
---
data.visuals.v_metalbar = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Metal_Bars.Containers_Metal_Bars'", cull_ratio = container_cull_distance, }
data.visuals.v_blightbar = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Bars.Containers_Blight_Bars'", cull_ratio = container_cull_distance, }
data.visuals.v_obsidian = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Obsidian.Containers_Obsidian'", cull_ratio = container_cull_distance, }
data.visuals.v_crystal = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Crystal_Raw.Containers_Crystal_Raw'", cull_ratio = container_cull_distance, }
data.visuals.v_blight_crystal = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Crystal_Raw.Containers_Blight_Crystal_Raw'", cull_ratio = container_cull_distance, }
data.visuals.v_laterite = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Laterite.Containers_Laterite'", cull_ratio = container_cull_distance, }
data.visuals.v_aluminium_rod = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Aluminum_Cops.Containers_Aluminum_Cops'", cull_ratio = container_cull_distance, }
data.visuals.v_aluminium_sheet = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Aluminum_Sheets.Containers_Aluminum_Sheets'", cull_ratio = container_cull_distance, }
data.visuals.v_metalore = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Metal_Ore.Containers_Metal_Ore'", cull_ratio = container_cull_distance, }

-- NOT RIGHT
-- data.visuals.v_virus_data = { mesh = "StaticMesh'/Game/Meshes/Containers/Containers_Blight_Data.Containers_Blight_Data'", cull_ratio = container_cull_distance, }
-- fixed

-- data.visuals.v_flyer_s = { mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Flyer_S.Bot_Flyer_S'", }

data.visuals.v_carrier_bot = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Carrier_A.Bot_Carrier_A'",
}

data.visuals.v_transport_bot = {
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Flyer.Flyer'",
	sockets = {
		{ "",        "Internal" },
		{ "",        "Internal" },
		{ "",        "Internal" },
	},
}
data.visuals.v_flyer_m =
{
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Flyer_M.Bot_Flyer_M'",
	sockets = {
		{ "",        "Internal" },
	},
}

data.visuals.v_flyer_bot =
{
	mesh = "StaticMesh'/Game/Meshes/RobotUnits/Bot_Flyer_S.Bot_Flyer_S'",
	sockets = {
		{ "",        "Internal" },
	},
}

data.visuals.v_explorable_spaceelevator = {
	meshes = data.visualmeshes.bp_sets_explorable_spaceelevator,
	tile_size = { 8, 8 },
	tile_pattern = {
		0, 0, 1, 1, 1, 1, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 0,
		0, 0, 1, 1, 1, 1, 0, 0,
	},
	mesh = "StaticMesh'/Game/Meshes/empty_socket.empty_socket'",

	destroy_effect = "fx_digital",
	explorable_race = "human",
	explorable_name = "Space Elevator",
}

data.visuals.plateau_set_01 = {
	--frame_class = "Blueprint'/Game/Meshes/Plateau/Sets/BP_Sets_Plateau_01.BP_Sets_Plateau_01_C'",
	-- frame actor has 1 niagara particle so can't be fully converted
	meshes = data.visualmeshes.bp_sets_plateau_01,
	effects = data.visualeffects.bp_sets_plateau_01,
	tile_size = { 3, 3 },
	tile_pattern = {
		0, 1, 1,
		1, 1, 1,
		1, 1, 0,
	},
}

data.visuals.plateau_set_02 = {
	--frame_class = "Blueprint'/Game/Meshes/Plateau/Sets/BP_Sets_Plateau_02.BP_Sets_Plateau_02_C'",
	-- frame actor has 1 niagara particle so can't be fully converted
	meshes = data.visualmeshes.bp_sets_plateau_02,
	effects = data.visualeffects.bp_sets_plateau_02,
	tile_size = { 6, 5 },
	tile_pattern = {
		0, 1, 1, 1, 0, 0,
		0, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 0,
	},
}

data.visuals.plateau_set_03 = {
	--frame_class = "Blueprint'/Game/Meshes/Plateau/Sets/BP_Sets_Plateau_03.BP_Sets_Plateau_03_C'",
	-- frame actor has 1 niagara particle so can't be fully converted
	meshes = data.visualmeshes.bp_sets_plateau_03,
	effects = data.visualeffects.bp_sets_plateau_03,
	tile_size = { 4, 5 },
	tile_pattern = {
		0, 1, 1, 0,
		1, 1, 1, 1,
		1, 1, 1, 1,
		1, 1, 1, 1,
		1, 1, 1, 0,
	},
}

data.visuals.plateau_set_hole_01 = {
	--frame_class = "Blueprint'/Game/Meshes/Plateau/Sets/BP_Sets_Plateau_Hole_01.BP_Sets_Plateau_Hole_01_C'",
	-- frame actor contains 1 light so can't be converted to meshes
	meshes = data.visualmeshes.bp_sets_plateau_hole_01,
	tile_size = { 5, 5 },
	flags = "CutsHole",
	tile_pattern = {
		0, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		1, 1, 1, 1, 1,
		0, 1, 1, 1, 1,
	},
	hole_pattern = {
		0, 0, 0, 0, 0,
		0, 1, 1, 1, 0,
		0, 1, 1, 1, 0,
		0, 1, 1, 1, 0,
		0, 0, 0, 0, 0,
	},
}

data.visuals.plateau_set_hole_02 = {
	--frame_class = "Blueprint'/Game/Meshes/Plateau/Sets/BP_Sets_Plateau_Hole_02.BP_Sets_Plateau_Hole_02_C'",
	meshes = data.visualmeshes.bp_sets_plateau_hole_02,
	effects = data.visualeffects.bp_sets_plateau_hole_02,
	tile_size = { 12, 22 },
	flags = "CutsHole",
	tile_pattern = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0,
	},
	hole_pattern = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0,
		0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	},
}

data.visuals.v_beacon = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Beacon/Beacon_01.Beacon_01'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	sockets = {
		{ "",       "Internal" },
	},
}

data.visuals.v_beacon_l = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Beacon/Beacon_01.Beacon_01'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	sockets = {
		{ "",       "Internal" },
		{ "",       "Internal" },
		{ "",       "Internal" },
	},
	scale = { 1.6, 1.6, 2.5 },
}

data.visuals.v_wall0 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_00.Walls_00'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}
data.visuals.v_wall1 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_01.Walls_01'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}
data.visuals.v_wall2 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_02.Walls_02'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}
data.visuals.v_wall3 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_03.Walls_03'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}
data.visuals.v_wall4 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_04.Walls_04'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}
data.visuals.v_wall5 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_05.Walls_05'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}

local wall_mat1<const> = "MaterialInstanceConstant'/Game/Meshes/RobotBuildings/Walls/Wall/Walls.Walls'"
local wall_mat_vir<const> = "MaterialInstanceConstant'/Game/Meshes/RobotBuildings/Walls/Wall/WallLight_Virus_M_Inst.WallLight_Virus_M_Inst'"
local wall_mat_bli<const> = "MaterialInstanceConstant'/Game/Meshes/RobotBuildings/Walls/Wall/WallLight_Blight_M_Inst.WallLight_Blight_M_Inst'"
local wall_flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs"

data.visuals.v_wall_vir0 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_00.Walls_00'",
	materials = { wall_mat1, wall_mat_vir },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_vir1 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_01.Walls_01'",
	materials = { wall_mat1, wall_mat_vir },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_vir2 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_02.Walls_02'",
	materials = { wall_mat1, wall_mat_vir },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_vir3 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_03.Walls_03'",
	materials = { wall_mat1, wall_mat_vir },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_vir4 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_04.Walls_04'",
	materials = { wall_mat1, wall_mat_vir },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_vir5 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_05.Walls_05'",
	materials = { wall_mat1, wall_mat_vir },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}

data.visuals.v_wall_bli0 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_00.Walls_00'",
	materials = { wall_mat1, wall_mat_bli },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_bli1 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_01.Walls_01'",
	materials = { wall_mat1, wall_mat_bli },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_bli2 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_02.Walls_02'",
	materials = { wall_mat1, wall_mat_bli },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_bli3 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_03.Walls_03'",
	materials = { wall_mat1, wall_mat_bli },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_bli4 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_04.Walls_04'",
	materials = { wall_mat1, wall_mat_bli },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}
data.visuals.v_wall_bli5 = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_05.Walls_05'",
	materials = { wall_mat1, wall_mat_bli },
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = wall_flags,
}

data.visuals.v_gate = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Walls/Walls_Gate_A.Walls_Gate_A'",
	place_effect = "fx_digital_in",
	destroy_effect = "fx_digital",
	flags = "CanBePlacedOnSlopes|CanBePlacedOnCliffs",
}

--[[

-- Grasslands
--data.visuals.v_clovers = { mesh = "StaticMesh'/Game/Cai/Grasslands/Clovers/Var1_LOD1.Var1_LOD1'", flags = "RandomRotation | RandomTranslation | RandomScale" }
--data.visuals.v_fern_01 = { mesh = "StaticMesh'/Game/Cai/Grasslands/Fern_01/SM_Grasslands_Fern_01.SM_Grasslands_Fern_01'", flags = "RandomRotation | RandomTranslation | RandomScale" }
--data.visuals.v_grass_01 = { mesh = "StaticMesh'/Game/Cai/Grasslands/Fern_01/SM_Grasslands_Fern_01.SM_Grasslands_Fern_01'", flags = "RandomRotation | RandomTranslation | RandomScale" }
--]]

-- Grass
data.visuals.v_shortgrass_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/ShortGrass_01/SM_ShortGrass_01.SM_ShortGrass_01'",
	flags = "RandomRotation|NoShadows",
	scale = { 1.3, 1.3, 0.3 },
	cull_ratio = 1 / 4,
	--mesh_offset = { 0, 0, -1 },
	--materials = {  "MaterialInstanceConstant'/Game/Cai/Grasslands/ShortGrass_01/M_ShortGrass_Long.M_ShortGrass_Long'" },
}

data.visuals.v_shortgrass_01_tall =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/ShortGrass_01/SM_ShortGrass_01.SM_ShortGrass_01'",
	scale = { 1.3, 1.3, 2 },
	cull_ratio = 1 / 5,
	flags = "RandomRotation|NoShadows",
	--mesh_offset = { 0, 0, -1 },
	--materials = {  "MaterialInstanceConstant'/Game/Cai/Grasslands/ShortGrass_01/M_ShortGrass_Long.M_ShortGrass_Long'" },
}

data.visuals.v_longgrass_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Grass_01/SM_Grasslands_WavyGrass_01.SM_Grasslands_WavyGrass_01'",
	flags = "RandomTranslation|RandomScale|NoShadows",
	scale = { 2, 2, 0.4 },
	cull_ratio = 1 / 4,
	--cull_ratio = 0,
}

-- Succulents
data.visuals.v_succulent_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_01/SM_Grasslands_Succulent_01.SM_Grasslands_Succulent_01'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	--scale = { .5, .5, .5 },
	cull_ratio = long_cull_distance,
}
data.visuals.v_succulent_02 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_02/SM_Grasslands_Succulent_02.SM_Grasslands_Succulent_02'",
	flags = "RandomRotation | RandomTranslation | RandomScale | NoShadows",
	scale = { 1, 1, 1 },
	cull_ratio = medium_cull_distance,
}
data.visuals.v_succulent_02_large =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_02/SM_Grasslands_Succulent_02.SM_Grasslands_Succulent_02'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.5, 1.5, 2 },
	cull_ratio = medium_cull_distance,
}
data.visuals.v_succulent_03 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_03/SM_Grasslands_Succulent_03.SM_Grasslands_Succulent_03'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	--Scale =  { 0.5, 0.5, 0.5 },
	cull_ratio = medium_cull_distance,
}
data.visuals.v_succulent_04 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_04/SM_Grasslands_Succulent_04.SM_Grasslands_Succulent_04'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	--scale = { .5, .5, .5 },
	cull_ratio = medium_cull_distance,
}
data.visuals.v_succulent_05_A =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_05/SM_Succulent_05.SM_Succulent_05'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 0.7, 0.7, 0.7 },
	cull_ratio = long_cull_distance,
	--flags = "NoShadows",
}
data.visuals.v_succulent_05_B =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_05/SM_Succulent_05_B.SM_Succulent_05_B'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1, 1, 1 },
	cull_ratio = long_cull_distance,
	--flags = "NoShadows",
}
data.visuals.v_succulent_05_C =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Succulent_05/SM_Succulent_05_C.SM_Succulent_05_C'",
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1, 1, 1 },
	cull_ratio = long_cull_distance,
	--flags = "NoShadows",
}

data.visuals.v_pearls_03 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/StringOfPearls_01/SM_StringOfPearls_03.SM_StringOfPearls_03'",
	flags = "RandomTranslation | RandomScale| RandomRotation",
	tile_size = { 2, 2 },
	scale = { 0.7, 0.7, 1 },
	cull_ratio = medium_cull_distance,
	--flags = "NoShadows",
}

--data.visuals.v_tree_02_A = { mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_02/flowerbudstest_01.flowerbudstest_01'", flags = "RandomRotation | RandomTranslation | RandomScale", }
--data.visuals.v_tree_03_A = { mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_03/Tree_03_A.Tree_03_A'" , flags = "RandomRotation | RandomTranslation | RandomScale", }

-- Trees

data.visuals.v_tree_04_hero_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Hero_01.SM_Grasslands_Tree_04_Hero_01'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.5, 1.5, 1.5 },
}

data.visuals.v_tree_04_large_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Large_01.SM_Grasslands_Tree_04_Large_01'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.2, 1.2, 1.2 },
}

data.visuals.v_tree_04_large_01_ExtraLarge =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Large_01.SM_Grasslands_Tree_04_Large_01'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 2, 2, 2 },
}
data.visuals.v_tree_04_large_01_Larger =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Large_01.SM_Grasslands_Tree_04_Large_01'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.5, 1.5, 1.5 },
}

data.visuals.v_tree_04_Medium_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Medium_01.SM_Grasslands_Tree_04_Medium_01'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.2, 1.2, 1.2 },
}

data.visuals.v_tree_04_Medium_02 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Medium_02.SM_Grasslands_Tree_04_Medium_02'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.2, 1.2, 1.2 },
}

data.visuals.v_tree_04_Medium_03 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Medium_03.SM_Grasslands_Tree_04_Medium_03'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	scale = { 1.2, 1.2, 1.2 },
}

data.visuals.v_tree_04_small_01 =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_04/SM_Grasslands_Tree_04_Small_01.SM_Grasslands_Tree_04_Small_01'" ,
	flags = "RandomRotation | RandomTranslation | RandomScale",
	cull_ratio = short_cull_distance,
	scale = { 1.5, 1.5, 1.5 },
}

-- Trees (Succulent Type)
data.visuals.v_tree_05_small =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_05/SM_Grasslands_Tree_05_Small.SM_Grasslands_Tree_05_Small'" ,
	flags = "RandomRotation | RandomScale",
}
data.visuals.v_tree_05_medium =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_05/SM_Grasslands_Tree_05_Medium.SM_Grasslands_Tree_05_Medium'" ,
	flags = "RandomRotation | RandomScale",
}
data.visuals.v_tree_05_large =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_05/SM_Grasslands_Tree_05_Large.SM_Grasslands_Tree_05_Large'" ,
	flags = "RandomRotation | RandomScale",
}
data.visuals.v_big_daikon =
{
	mesh = "StaticMesh'/Game/Cai/Grasslands/Tree_05/SM_Grasslands_Tree_05_Large.SM_Grasslands_Tree_05_Large'" ,
	flags = "RandomRotation",
	destroy_effect = "fx_digital",
	scale = { 2.23, 2.25, 2.25 },
	tile_size = { 2, 2 },
}

data.visuals.blight_set_01 = {
	meshes = data.visualmeshes.blight_set_01,
	tile_size = { 8, 6 },
	tile_pattern = {
		0, 1, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 0, 0,
	},
	scale = { 0.95, 0.95, 0.95 },
	placement = "Min",
}

data.visuals.blight_set_02 = {
	meshes = data.visualmeshes.blight_set_02,
	tile_size = { 8, 6 },
	tile_pattern = {
		0, 0, 1, 1, 1, 1, 1, 0,
		0, 0, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 1, 0, 0,
	},
	placement = "Min",
}

data.visuals.blight_set_03 = {
	meshes = data.visualmeshes.blight_set_03,
	effects = data.visualeffects.blight_set_03,
	tile_size = { 8, 6 },
	tile_pattern = {
		0, 1, 1, 1, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 1, 1, 0,
	},
	scale = { 0.9, 0.9, 0.9 },
	--mesh_offset = { 0, 0, 0 },
	placement = "Min",
}

data.visuals.blight_set_04 = {
	meshes = data.visualmeshes.blight_set_04,
	effects = data.visualeffects.blight_set_04,
	tile_size = { 8, 6 },
	tile_pattern = {
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1,
	},
	placement = "Min",
}

data.visuals.blight_set_05 = {
	meshes = data.visualmeshes.blight_set_05,
	effects = data.visualeffects.blight_set_05,
	tile_size = { 14, 9 },
	tile_pattern = {
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
	},
	mesh_offset = { 400, -200, 0 },
	placement = "Min",
}

data.visuals.blight_set_06 = {
	meshes = data.visualmeshes.blight_set_06,
	effects = data.visualeffects.blight_set_06,
	tile_size = { 13, 11 },
	tile_pattern = {
		1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0,
	},
	scale = { 0.75, 0.75, 0.9 },
	mesh_offset = { -200, 0, 0 },
	placement = "Min",
}

data.visuals.blight_set_07 = {
	meshes = data.visualmeshes.blight_set_07,
	tile_size = { 6, 7 },
	tile_pattern = {
		0, 0, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 0,
	},
	mesh_offset = { 0, -75, 0 },
	placement = "Min",
}

data.visuals.blight_set_08 = {
	meshes = data.visualmeshes.blight_set_08,
	effects = data.visualeffects.blight_set_08,
	tile_size = { 7, 10 },
	tile_pattern = {
		0, 0, 1, 1, 1, 0, 0,
		0, 1, 1, 1, 1, 1, 0,
		0, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 0, 0,
		1, 1, 1, 0, 0, 0, 0,
	},
	mesh_offset = { -150, 50, 0 },
	placement = "Min",
}

data.visuals.blight_set_09 = {
	meshes = data.visualmeshes.blight_set_09,
	tile_size = { 6, 7 },
	tile_pattern = {
		1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 0,
		0, 0, 1, 1, 0, 0,
	},
	mesh_offset = { 120, -125, -30 },
	placement = "Min",
}

data.visuals.v_base2x2f_broken = {
	mesh = "StaticMesh'/Game/Meshes/RobotBuildings/Building_2x2_F.Building_2x2_F'",
	materials = { "MaterialInstanceConstant'/Game/Meshes/RobotBuildings/Building_2x2_F/MI_Building_2x2_F_Damaged.MI_Building_2x2_F_Damaged'", },
	placement = "Max",
	tile_size = { 2, 2},
	sockets = {
		{ "Medium1", "Medium"  },
	},
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
}

-- NEW BLIGHT UNIQUES
------------------
-- HEART SHARD
------------------
data.visuals.v_explorable_blightanomaly_01 = {
	mesh = "StaticMesh'/Game/Cai/Explorables/BlightAnomaly_01/SM_Explorable_BlightAnomaly_01.SM_Explorable_BlightAnomaly_01'",
	effect = "NiagaraSystem'/Game/Cai/Explorables/BlightAnomaly_01/NS_Explorable_BlightAnomaly_01.NS_Explorable_BlightAnomaly_01'",
	explorable_race = "alien",
	explorable_name = "Heart Shard",
	tile_size = { 2, 2},
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = {
		{ "", "Internal" },
		{ "", "Internal" },
	},
	placement = "Max",
}

------------------
-- OBSERVER
------------------
data.visuals.v_explorable_blightanomaly_02 = {
	mesh = "StaticMesh'/Game/Cai/Explorables/BlightAnomaly_02/SM_Explorable_BlightAnomaly_02.SM_Explorable_BlightAnomaly_02'",
	effect = "NiagaraSystem'/Game/Cai/Explorables/BlightAnomaly_02/NS_Explorable_BlightAnomaly_01.NS_Explorable_BlightAnomaly_01'",
	explorable_race = "alien",
	explorable_name = "Observer",
	tile_size = { 2, 2},
	light_color = alien_color,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
	-- flags="RandomRotation|RandomScale",
	-- placement = "Min",
}

------------------
-- CONSOLE
------------------
data.visuals.v_explorable_blightanomaly_03 = {
	mesh = "StaticMesh'/Game/Cai/Explorables/BlightAnomaly_03/bake.bake'",
	effect = "NiagaraSystem'/Game/Cai/Explorables/BlightAnomaly_03/NS_Explorable_BlightAnomaly_03.NS_Explorable_BlightAnomaly_03'",
	explorable_race = "alien",
	explorable_name = "Console",
	tile_size = { 2, 2},
	light_color = alien_color,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
}

------------------
-- MONOLITH
------------------
data.visuals.v_explorable_monolith_01 = {
	mesh = "StaticMesh'/Game/Cai/Explorables/Monolith/SM_Explorable_Monolith_01.SM_Explorable_Monolith_01'",
	effect = "NiagaraSystem'/Game/Cai/Explorables/Monolith/NS_Explorable_Monolith_01.NS_Explorable_Monolith_01'",
	explorable_race = "alien",
	explorable_name = "Monolith",
	tile_size = { 2, 2},
	light_color = alien_color,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	-- flags="RandomRotation|RandomScale",
	placement = "Min",
}

data.visuals.v_explorable_monolith_02 = {
	mesh = "StaticMesh'/Game/Meshes/Explorables/GammaSet/Explorable_Monolith_02.Explorable_Monolith_02'",
	effect = "NiagaraSystem'/Game/Cai/Explorables/Monolith/NS_Explorable_Monolith_01.NS_Explorable_Monolith_01'",
	meshes = data.visualmeshes.alien_foundation_3x3,
	explorable_race = "alien",
	explorable_name = "Monolith",
	tile_size = { 2, 2},
	light_color = alien_color,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Max",
	-- flags="RandomRotation|RandomScale",
	-- placement = "Min",
}

------------------
-- TIME EGG
------------------
data.visuals.v_explorable_timeegg_01 = {
	mesh = "StaticMesh'/Game/Cai/Explorables/TimeEgg/SM_Explorable_TimeEgg_01.SM_Explorable_TimeEgg_01'",
	effect = "NiagaraSystem'/Game/Cai/Explorables/TimeEgg/NS_Explorable_TimeEgg_01.NS_Explorable_TimeEgg_01'",
	mesh_offset = {0,0,-10}, -- not all have this**
	explorable_race = "alien",
	explorable_name = "Time Egg",
	tile_size = { 2, 2},
	light_color = alien_color,
	light_radius = 2,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	sockets = { { "", "Internal" }, },
	placement = "Min",
}

------------------
-- THE SIMULATOR
------------------
data.visuals.v_explorable_blightgiantoddball = {
	meshes = data.visualmeshes.bp_sets_explorable_blightgiantoddball,
	effects = data.visualeffects.bp_sets_explorable_blightgiantoddball,
	explorable_name = "The Simulator",
	tile_size = { 11, 11 },
	scale = { .9, .9, .9},
	light_color = alien_color,
	light_radius = 5,
	sockets = { { "", "Internal" }, },
	placement = "Min",
	tile_pattern = {
		0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0,
		0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0,
		0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0,
	},
}

data.visuals.v_the_simulator = {
	mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_TheSimulator_L.Component_TheSimulator_L'",
}

data.visuals.v_ReformingPool_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_ReformingPool_01_L.Component_ReformingPool_01_L'" }
data.visuals.v_AlienCrucible_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Crucible_01_L.Component_Crucible_01_L'" }
data.visuals.v_PlasmaBloom_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_PlasmaBloom_01_M.Component_PlasmaBloom_01_M'" }
data.visuals.v_SentinelTurret_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_SentinelTurret_01_M.Component_SentinelTurret_01_M'", scale = { 1.1, 1.1, 1.3}, }
data.visuals.v_Monolith_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Monolith_01_L.Component_Monolith_01_L'", scale = { 1.25, 1.25, 1.25}, }
data.visuals.v_NexaSpire_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_NexaSpire_01_L.Component_NexaSpire_01_L'", scale = { 0.8, 0.8, 0.8}, }
data.visuals.v_SensorSpikeComRadar_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_SensorSpikeComRadar_01_M.Component_SensorSpikeComRadar_01_M'", scale = { 0.8, 0.8, 0.8}, }
data.visuals.v_Range5Transporter_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_Range5Transporter_01_L.Component_Range5Transporter_01_L'", scale = { 1.3, 1.3, 1.3}, }
data.visuals.v_TimeEgg_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_TimeEgg_01_L.Component_TimeEgg_01_L'", scale = { 0.8, 0.8, 0.8}, }
data.visuals.v_AlienPowerGenerator_01_l = { mesh = "StaticMesh'/Game/Meshes/BaseBuildings/Component_BlightPowerGenerator_01_L.Component_BlightPowerGenerator_01_L'", scale = { 0.9, 0.9, 0.9 }, }

data.visuals.v_alien_powergenerator = {
	mesh = "StaticMesh'/Game/Meshes/AlienBuildings/GammaSet/Alien_Building_1x1_BlightPowerGenerator/Alien_Building_1x1_BlightPowerGenerator.Alien_Building_1x1_BlightPowerGenerator'", scale = { 1.15, 1.15, 1.15 },
	light_color = alien_color,
	specular_scale = alien_ss,
	light_radius = 5,
	destroy_effect = "fx_digital",
	place_effect = "fx_digital_in",
	placement = "Max",
	sockets = {
		{ "", "Internal" },
	},
}
