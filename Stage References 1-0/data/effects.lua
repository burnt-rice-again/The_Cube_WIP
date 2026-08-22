--
-- sound_attenuation = "default", "low", "high"
-- sound_concurrency = "default", "machinery"

data.fx.fx_turret_laser = {
	--particle = { "ParticleSystem'/Game/Effects/PDS_Rock.PDS_Rock'", flags = "Preload", },
	--particle = "NiagaraSystem'/Game/Effects/Miner_Laser.Miner_Laser'",
	--sound = "SoundCue'/Game/Audio/FX/Components/bleep_Cue.bleep_Cue'",
	particle = { "NiagaraSystem'/Game/Effects/Comp/DS_Miner.DS_Miner'", flags = "Preload", },
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_digital = {
	particle = { "NiagaraSystem'/Game/Effects/DigitalFX.DigitalFX'", flags = "Preload", },
	sound = "Main/sounds/environment/dissolve_out.ogg",
}

data.fx.fx_digital_in = {
	particle = { "NiagaraSystem'/Game/Effects/DigitalInFX.DigitalInFX'", flags = "Preload", },
	sound = "Main/sounds/environment/dissolve_in.ogg",
}

data.fx.fx_heal_unit = {
	particle = { "NiagaraSystem'/Game/Effects/HealUnitFX.HealUnitFX'", flags = "Preload", },
}

data.fx.fx_smalldigital = {
	particle = { "NiagaraSystem'/Game/Effects/DigitalFXSmall.DigitalFXSmall'", flags = "Preload", },
}

data.fx.fx_scan = {
	particle = "NiagaraSystem'/Game/Effects/NS_Scan.NS_Scan'",
	flags = "Infinite",
}

data.fx.fx_shield = {
	particle = "NiagaraSystem'/Game/Effects/ShieldFX.ShieldFX'",
	particle_params = { color = { 5.0, 10.0, 50.0, 0.05 } }, -- blue
	group = "shields",
	flags = "Infinite",
}

data.fx.fx_shield2 = {
	particle = "NiagaraSystem'/Game/Effects/ShieldFX.ShieldFX'",
	particle_params = { color = { 15.0, 1.0, 50.0, 0.05 } }, -- purple
	group = "shields",
	flags = "Infinite",
}

data.fx.fx_shield3 = {
	particle = "NiagaraSystem'/Game/Effects/ShieldFX.ShieldFX'",
	particle_params = { color = { 50.0, 5.0, 5.0, 0.05 } }, -- red
	group = "shields",
	flags = "Infinite",
}

data.fx.fx_satellitelaunch = { particle = "NiagaraSystem'/Game/Effects/NS_LaunchSatellite.NS_LaunchSatellite'", }
data.fx.fx_satelliteland = { particle = "NiagaraSystem'/Game/Effects/NS_LandSatellite.NS_LandSatellite'", }

data.fx.fx_space_satellitelaunch = { particle = "NiagaraSystem'/Game/Effects/NS_LaunchSatellite1.NS_LaunchSatellite1'", }
data.fx.fx_space_satelliteland = { particle = "NiagaraSystem'/Game/Effects/NS_LandSatellite1.NS_LandSatellite1'", }

data.fx.fx_birds = {
	particle = "ParticleSystem'/Game/Effects/PDS_BlackBird_Flock.PDS_BlackBird_Flock'",
	flags = "Infinite|SoundLooping",
	sound = "Main/sounds/environment/birds_loop_mono_01.ogg",
	sound_attenuation = "low",
}

data.fx.fx_leaves = {
	--particle = "ParticleSystem'/Game/Effects/P_Leaves.P_Leaves'",
	particle = { "NiagaraSystem'/Game/Effects/LeavesFX.LeavesFX'", flags = "Preload", },
	flags = "Infinite",
}

data.fx.fx_move_bot = {
	--particle = "ParticleSystem'/Game/Realistic_Starter_VFX_Pack/Particles/Fire/P_Fire_Small.P_Fire_Small'"
	--particle = "NiagaraSystem'/Game/Effects/BotMove.BotMove'",
	particle = { "NiagaraSystem'/Game/Effects/BotMove.BotMove'", flags = "Preload", },
	sound = { "Main/sounds/environment/DEP_BOT_DRIVE_LOOP.ogg", flags = "Preload", },
	sound_attenuation = "low",
	flags = "Infinite|SoundLooping",
}

------------  ALIEN BASE EFFECTS -----------
data.fx.fx_alien_liquid = {
	particle = { "NiagaraSystem'/Game/Effects/NS_AlienLiquid.NS_AlienLiquid'", flags = "Preload", },
	flags = "Looping",
}

data.fx.fx_alien_whirl = {
	particle = { "NiagaraSystem'/Game/Effects/NS_AlienFeeder.NS_AlienFeeder'", flags = "Preload", },
	flags = "Looping",
}
data.fx.fx_alien_producer = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Producer.NS_Alien_Building_2x2_Producer'",
	flags = "Looping",
}
data.fx.fx_reforming_pool = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_ReformingPool.NS_Alien_Building_2x2_ReformingPool'",
	flags = "Looping",
}
data.fx.fx_alien_monolith = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Explorable_Monolith_02.NS_Explorable_Monolith_02'",
	flags = "Looping",
}
data.fx.fx_alien_feeder = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Feeder_02.NS_Alien_Building_2x2_Feeder_02'",
	flags = "Looping",
}
data.fx.fx_alien_pylon = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_1x1_Pylon.NS_Alien_Building_1x1_Pylon'",
	flags = "Looping",
}
data.fx.fx_alien_sensor_tower = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_1x1_SensorTower.NS_Alien_Building_1x1_SensorTower'",
	flags = "Looping",
}
data.fx.fx_alien_research_building = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Research.NS_Alien_Building_2x2_Research'",
	flags = "Looping",
}
data.fx.fx_alien_socket_building = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Socket_L_01.NS_Alien_Building_2x2_Socket_L_01'",
	flags = "Looping",
}
data.fx.fx_alien_storage = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Storage_01.NS_Alien_Building_2x2_Storage_01'",
	flags = "Looping",
}
data.fx.fx_alien_teleporter = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Teleporter_02.NS_Alien_Building_2x2_Teleporter_02'",
	flags = "Looping",
}
data.fx.fx_alien_defense_turret = {
	particle = "NiagaraSystem'/Game/Effects/AlienFaction/Unit_Systems/NS_Alien_Building_2x2_Turret.NS_Alien_Building_2x2_Turret'",
	flags = "Looping",
}

data.fx.fx_simulator = {
	particle = "NiagaraSystem'/Game/Cai/Explorables/BlightGiantOddBall/NE_MercurySubstance_Component.NE_MercurySubstance_Component'",
	flags = "Infinite",
}

data.fx.fx_unit_teleport = {
	particle = { "NiagaraSystem'/Game/Effects/NS_Teleporter_01.NS_Teleporter_01'", flags = "Preload", }
}

data.fx.fx_robotics_factory = {
	sound = "Main/sounds/component/robotics factory.ogg",
	flags = "SoundLooping",
	sound_concurrency = "machinery",
}

data.fx.fx_transfer = {
	sound = "Main/sounds/component/transfer.ogg",
	flags = "SoundLooping",
	sound_concurrency = "machinery",
}

data.fx.fx_uplink = {
	particle = { "NiagaraSystem'/Game/Effects/NS_Uplink.NS_Uplink'", flags = "Preload", },
	sound = "Main/sounds/component/uplink.ogg",
	flags = "Infinite",
	sound_concurrency = "machinery",
}

data.fx.fx_turret_2 = {
	particle = { "NiagaraSystem'/Game/Effects/Turret/DS_Turret_2.DS_Turret_2'", flags = "Preload", },
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_turret_3 = {
	particle = { "NiagaraSystem'/Game/Effects/Turret/DS_Turret_3.DS_Turret_3'", flags = "Preload", },
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_miner = {
	particle = { "NiagaraSystem'/Game/Effects/Comp/DS_Miner.DS_Miner'", flags = "Preload", },
	--sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	sound_attenuation = "low",
	sounds = {
		"Main/sounds/component/mining_laser_01.ogg",
		"Main/sounds/component/mining_laser_02.ogg",
		"Main/sounds/component/mining_laser_03.ogg",
		"Main/sounds/component/mining_laser_04.ogg",
	},
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_extractor = {
	particle = { "NiagaraSystem'/Game/Effects/Comp/DS_Miner.DS_Miner'", flags = "Preload", },
	sound_attenuation = "low",
	sounds = {
		"Main/sounds/component/extractor_01.ogg",
		"Main/sounds/component/extractor_02.ogg",
		"Main/sounds/component/extractor_03.ogg",
	},
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_alien_miner = {
	particle = { "NiagaraSystem'/Game/Effects/NS_AlienMiner.NS_AlienMiner'", flags = "Preload", },
	--random_pitch_range = 0.3, -- play up to 30% faster or slower
	--random_delay_range = 0.3, -- start delayed up to 300 milliseconds
	--flags = "Looping",
}

data.fx.fx_alien_attack = {
	particle = { "NiagaraSystem'/Game/Effects/Turret/DS_Alien_Attack.DS_Alien_Attack'", flags = "Preload", },
	sound = "Main/sounds/bug/squish.ogg",
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_alien_attack1 = {
	particle = { "NiagaraSystem'/Game/Effects/Comp/Slicer_Laser.Slicer_Laser'", flags = "Preload", },
	sound = "Main/sounds/bug/squish.ogg",
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

-- Plasma Blast
data.fx.fx_alien_attack2 = {
	particle = { "NiagaraSystem'/Game/Effects/Turret/DS_Alien_Attack2.DS_Alien_Attack2'", flags = "Preload", },
	sound = "Main/sounds/bug/squish.ogg",
	flags = "IgnoreRotation",
}

-- Fusion Bolt
data.fx.fx_alien_attack3 = {
	particle = { "NiagaraSystem'/Game/Effects/Turret/DS_Alien_Attack3.DS_Alien_Attack3'", flags = "Preload", },
	sound = "Main/sounds/bug/squish.ogg",
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_bug_attack = {
	particle = { "NiagaraSystem'/Game/Effects/Blood/NS_BugSpit.NS_BugSpit'", flags = "Preload", },
	--sound = "Main/sounds/bug/squish.ogg",
	sounds = {
		"Main/sounds/bug/bug attack_01.ogg",
		"Main/sounds/bug/bug attack_02.ogg",
		"Main/sounds/bug/bug attack_03.ogg",
	},
	flags = "IgnoreRotation",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_bug_attack_snd = {
	sounds = {
		"Main/sounds/bug/bug attack_01.ogg",
		"Main/sounds/bug/bug attack_02.ogg",
		"Main/sounds/bug/bug attack_03.ogg",
	},
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_turret_missile = {
	--particle = "NiagaraSystem'/Game/Effects/Turret/DS_Turret_Missile.DS_Turret_Missile'",
	particle = "NiagaraSystem'/Game/Effects/Turret/NS_Missile_Launcher1.NS_Missile_Launcher1'",
	--sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	flags = "IgnoreRotation",
	sounds = {
		"Main/sounds/component/missile turret shot_01.ogg",
		"Main/sounds/component/missile turret shot_02.ogg",
		"Main/sounds/component/missile turret shot_03.ogg",
	},
}

data.fx.fx_railgun = {
	particle = "NiagaraSystem'/Game/Effects/Comp/DS_Miner1.DS_Miner1'",
	flags = "IgnoreRotation",
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_photon_beam = {
	particle = "NiagaraSystem'/Game/Effects/Comp/DS_Photon_Beam.DS_Photon_Beam'",
	flags = "IgnoreRotation",
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

-- ENERGY BOMB
---------------
data.fx.fx_photon_bomb = {
	particle = "NiagaraSystem'/Game/Effects/Turret/NS_Photon_Bomb.NS_Photon_Bomb'",
	flags = "IgnoreRotation",
	sounds = {
		"Main/sounds/component/missile turret shot_01.ogg",
		"Main/sounds/component/missile turret shot_02.ogg",
		"Main/sounds/component/missile turret shot_03.ogg",
	},
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

-- PLASMA BLAST
---------------
data.fx.fx_plasma_blast = {
	particle = "NiagaraSystem'/Game/Effects/Turret/NS_Plasma_Blast.NS_Plasma_Blast'",
	flags = "IgnoreRotation",
	sounds = {
		"Main/sounds/component/missile turret shot_01.ogg",
		"Main/sounds/component/missile turret shot_02.ogg",
		"Main/sounds/component/missile turret shot_03.ogg",
	},
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}
-- MONOLITH LIGHTNING
---------------
data.fx.fx_alien_monolith_lightning = {
	particle = "NiagaraSystem'/Game/Effects/Comp/Monolith_Lightning.Monolith_Lightning'",
	flags = "IgnoreRotation",
	--random_pitch_range = 0.3, -- play up to 30% faster or slower
	--random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_pulse = {
	--particle = "NiagaraSystem'/Game/Effects/NS_Pulse.NS_Pulse'",
	particle = "NiagaraSystem'/Game/Effects/Turret/NS_PulseHit.NS_PulseHit'",
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_plasma_beam = {
	particle = "NiagaraSystem'/Game/Effects/Comp/DS_Plasma_Beam.DS_Plasma_Beam'",
	flags = "IgnoreRotation",
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_viral_pulse = {
	--particle = "NiagaraSystem'/Game/Effects/NS_Pulse.NS_Pulse'",
	particle = "NiagaraSystem'/Game/Effects/Turret/NS_PulseHit_Green.NS_PulseHit_Green'",
	sound = "Main/sounds/environment/BOT_FIRESHOT.ogg",
}

-- PLASMA BOLT
---------------
data.fx.fx_plasma_bolt = {
	particle = "NiagaraSystem'/Game/Effects/Turret/NS_Plasma_Bolt.NS_Plasma_Bolt'",
	flags = "IgnoreRotation",
	--random_pitch_range = 0.3, -- play up to 30% faster or slower
	--random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_blight_power = {
	particle = "NiagaraSystem'/Game/Effects/NS_BlightPowerGenerator.NS_BlightPowerGenerator'",
	sound = "Main/sounds/component/blight charger loop_01.ogg",
	flags = "Infinite|SoundLooping",
	sound_attenuation = "low",
	sound_concurrency = "machinery",
}

data.fx.fx_blight_extract = {
	particle = "NiagaraSystem'/Game/Effects/Blight_Extract.Blight_Extract'",
	sound = "Main/sounds/component/blight charger loop_01.ogg",
	flags = "Looping|SoundLooping",
	sound_attenuation = "low",
	sound_concurrency = "machinery",
}

data.fx.fx_blight_shield = {
	--particle = "NiagaraSystem'/Game/Effects/NS_BlightPowerShield.NS_BlightPowerShield'",
	particle = "NiagaraSystem'/Game/Effects/NS_BlightPowerShield_Paul.NS_BlightPowerShield_Paul'",
	sound = "Main/sounds/component/blight power loop_01.ogg",
	flags = "Infinite|SoundLooping",
	sound_concurrency = "machinery",
}

data.fx.fx_plasmasplat_1 = {
	particle = { "NiagaraSystem'/Game/Effects/Blood/NS_Plasma_Mesh_1.NS_Plasma_Mesh_1'",
		flags = "Preload",
	},
	sounds = {
		"Main/sounds/bug/bug killed_01.ogg",
		"Main/sounds/bug/bug killed_02.ogg",
		"Main/sounds/bug/bug killed_03.ogg",
	},
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

--data.fx.fx_greensplat_1 = { particle = { "NiagaraSystem'/Game/Effects/Blood/NS_Blood_Mesh_5.NS_Blood_Mesh_5'", sound = "Main/sounds/environment/CREEP_DIE.ogg", flags = "Preload", },}
data.fx.fx_greensplat_2 = {
	particle = { "NiagaraSystem'/Game/Effects/Blood/NS_Blood_Mesh_6.NS_Blood_Mesh_6'",
		flags = "Preload",
	},
	sounds = {
		"Main/sounds/bug/bug killed_01.ogg",
		"Main/sounds/bug/bug killed_02.ogg",
		"Main/sounds/bug/bug killed_03.ogg",
	},
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}
--data.fx.fx_greensplat_3 = { particle = { "NiagaraSystem'/Game/Effects/Blood/NS_Blood_Splat_2D_2.NS_Blood_Splat_2D_2'", sound = "Main/sounds/environment/CREEP_DIE.ogg", flags = "Preload", },}
data.fx.fx_greensplat_4 = {
	particle = {
		"NiagaraSystem'/Game/Effects/Blood/NS_Blood_Splat_3D_2.NS_Blood_Splat_3D_2'",
		flags = "Preload",
	},
	sounds = {
		"Main/sounds/bug/bug killed_01.ogg",
		"Main/sounds/bug/bug killed_02.ogg",
		"Main/sounds/bug/bug killed_03.ogg",
	},
	random_pitch_range = 0.3, -- play up to 30% faster or slower
	random_delay_range = 0.3, -- start delayed up to 300 milliseconds
}

data.fx.fx_move_bug = {
	sound = { "Main/sounds/bug/CREEP_IDLE(LOOP).ogg", flags = "Preload", },
	flags = "SoundLooping",
	sound_attenuation = "low",
}

data.fx.fx_glitch = {
	particle = "NiagaraSystem'/Game/Effects/Glitch_Sphere.Glitch_Sphere'",
	flags = "Infinite",
}

data.fx.fx_glitch2 = {
	particle = "NiagaraSystem'/Game/Effects/Glitch_Lightning.Glitch_Lightning'",
	flags = "Infinite",
}

data.fx.fx_glitch_flower = {
	particle = "NiagaraSystem'/Game/Effects/Glitch_Flower.Glitch_Flower'",
	flags = "Infinite",
}

data.fx.fx_alien_core = {
	particle = "NiagaraSystem'/Game/Effects/AlienCoreFX.AlienCoreFX'",
	flags = "Infinite",
}

------------------
data.fx.fx_power_core = {
	particle = { "NiagaraSystem'/Game/Effects/Comp/DS_Flare.DS_Flare'", flags = "Preload", },
	flags = "Infinite",
}

data.fx.fx_fabricator = {
	particle = { "NiagaraSystem'/Game/Effects/NS_Refinery.NS_Refinery'", flags = "Preload", },
	sound = { "Main/sounds/environment/FABRICATOR_BUILDING(LOOP).ogg", flags = "Preload", },
	flags = "Looping|SoundLooping",
	sound_concurrency = "machinery",
}

data.fx.fx_drone_production = {
	sound = { "Main/sounds/environment/FABRICATOR_BUILDING(LOOP).ogg", flags = "Preload", },
	flags = "SoundLooping",
	sound_concurrency = "machinery",
}

--data.fx.fx_repairer = {
--	particle = "NiagaraSystem'/Game/Effects/NS_Repairer.NS_Repairer'",
--	flags = "Infinite",
--}

data.fx.fx_deconstructor = {
	particle = "NiagaraSystem'/Game/Effects/NS_Deconstructor.NS_Deconstructor'",
	flags = "Infinite",
}

data.fx.fx_movehere = {
	particle = { "NiagaraSystem'/Game/Effects/NS_MoveArrow.NS_MoveArrow'", flags = "Preload", },
}

data.fx.fx_interacthere = {
	particle = { "NiagaraSystem'/Game/Effects/NS_InteractArrow.NS_InteractArrow'", flags = "Preload", },
}

data.fx.fx_ping = {
	particle = { "NiagaraSystem'/Game/Effects/NS_Ping.NS_Ping'", flags = "Preload", },
}

data.fx.fx_assembler = {
	particle = { "NiagaraSystem'/Game/Effects/NS_Assembler.NS_Assembler'", flags = "Preload", },
	sound = "Main/sounds/component/assembler.ogg",
	flags = "Looping|SoundLooping",
	sound_concurrency = "machinery",
}

data.fx.fx_refinery = {
	particle = "NiagaraSystem'/Game/Effects/NS_Refinery.NS_Refinery'",
	sound = "Main/sounds/component/refinery.ogg",
	flags = "Looping|SoundLooping",
	sound_concurrency = "machinery",
}

data.fx.fx_roar = {
	sound = "Main/sounds/bug/bug_roar.ogg",
	sound_attenuation = "high",
	sound_concurrency = "default",
}

data.fx.fx_worm_attack = {
	sound = "Main/sounds/bug/worm_attack.ogg",
	sound_attenuation = "high",
	sound_concurrency = "default",
	random_pitch_range = 0.2, -- play up to 30% faster or slower
	random_delay_range = 0.2, -- start delayed up to 300 milliseconds
}

data.fx.fx_EMP = {
	particle = "NiagaraSystem'/Game/Effects/NS_Explosion_EMP.NS_Explosion_EMP'",
	--flags = "Looping|SoundLooping",
}

--data.fx.fx_planetfall = {
--	particle = "NiagaraSystem'/Game/Sci-Fi_Starter_VFX_Pack_Niagara/Niagara/Impact/NS_Impact_Sand_1.NS_Impact_Sand_1'",
--}

data.fx.fx_3_elain =   { sound = "Main/sounds/ELAIN/3_ELAIN.ogg",   flags = "Voice" }
data.fx.fx_6_elain =   { sound = "Main/sounds/ELAIN/6_ELAIN.ogg",   flags = "Voice" }
data.fx.fx_9_elain =   { sound = "Main/sounds/ELAIN/9_ELAIN.ogg",   flags = "Voice" }
data.fx.fx_13_elain =  { sound = "Main/sounds/ELAIN/13_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_17_elain =  { sound = "Main/sounds/ELAIN/17_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_21_elain =  { sound = "Main/sounds/ELAIN/21_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_56_elain =  { sound = "Main/sounds/ELAIN/56_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_60_elain =  { sound = "Main/sounds/ELAIN/60_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_95_elain =  { sound = "Main/sounds/ELAIN/95_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_99_elain =  { sound = "Main/sounds/ELAIN/99_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_103_elain = { sound = "Main/sounds/ELAIN/103_ELAIN.ogg", flags = "Voice" }
data.fx.fx_107_elain = { sound = "Main/sounds/ELAIN/107_ELAIN.ogg", flags = "Voice" }
data.fx.fx_111_elain = { sound = "Main/sounds/ELAIN/111_ELAIN.ogg", flags = "Voice" }
data.fx.fx_115_elain = { sound = "Main/sounds/ELAIN/115_ELAIN.ogg", flags = "Voice" }
data.fx.fx_123_elain = { sound = "Main/sounds/ELAIN/123_ELAIN.ogg", flags = "Voice" }
data.fx.fx_127_elain = { sound = "Main/sounds/ELAIN/127_ELAIN.ogg", flags = "Voice" }
data.fx.fx_151_elain = { sound = "Main/sounds/ELAIN/151_ELAIN.ogg", flags = "Voice" }
data.fx.fx_155_elain = { sound = "Main/sounds/ELAIN/155_ELAIN.ogg", flags = "Voice" }
data.fx.fx_159_elain = { sound = "Main/sounds/ELAIN/159_ELAIN.ogg", flags = "Voice" }
data.fx.fx_163_elain = { sound = "Main/sounds/ELAIN/163_ELAIN.ogg", flags = "Voice" }
data.fx.fx_166_elain = { sound = "Main/sounds/ELAIN/166_ELAIN.ogg", flags = "Voice" }
data.fx.fx_205_elain = { sound = "Main/sounds/ELAIN/205_ELAIN.ogg", flags = "Voice" }
data.fx.fx_209_elain = { sound = "Main/sounds/ELAIN/209_ELAIN.ogg", flags = "Voice" }
data.fx.fx_213_elain = { sound = "Main/sounds/ELAIN/213_ELAIN.ogg", flags = "Voice" }
data.fx.fx_217_elain = { sound = "Main/sounds/ELAIN/217_ELAIN.ogg", flags = "Voice" }
data.fx.fx_221_elain = { sound = "Main/sounds/ELAIN/221_ELAIN.ogg", flags = "Voice" }
data.fx.fx_225_elain = { sound = "Main/sounds/ELAIN/225_ELAIN.ogg", flags = "Voice" }
data.fx.fx_229_elain = { sound = "Main/sounds/ELAIN/229_ELAIN.ogg", flags = "Voice" }
data.fx.fx_233_elain = { sound = "Main/sounds/ELAIN/233_ELAIN.ogg", flags = "Voice" }
data.fx.fx_237_elain = { sound = "Main/sounds/ELAIN/237_ELAIN.ogg", flags = "Voice" }
data.fx.fx_241_elain = { sound = "Main/sounds/ELAIN/241_ELAIN.ogg", flags = "Voice" }
data.fx.fx_462_elain = { sound = "Main/sounds/ELAIN/462_ELAIN.ogg", flags = "Voice" }
data.fx.fx_466_elain = { sound = "Main/sounds/ELAIN/466_ELAIN.ogg", flags = "Voice" }
data.fx.fx_470_elain = { sound = "Main/sounds/ELAIN/470_ELAIN.ogg", flags = "Voice" }
data.fx.fx_474_elain = { sound = "Main/sounds/ELAIN/474_ELAIN.ogg", flags = "Voice" }
data.fx.fx_506_elain = { sound = "Main/sounds/ELAIN/506_ELAIN.ogg", flags = "Voice" }
data.fx.fx_510_elain = { sound = "Main/sounds/ELAIN/510_ELAIN.ogg", flags = "Voice" }
data.fx.fx_514_elain = { sound = "Main/sounds/ELAIN/514_ELAIN.ogg", flags = "Voice" }

data.fx.fx_29_elain =  { sound = "Main/sounds/ELAIN/29_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_33_elain =  { sound = "Main/sounds/ELAIN/33_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_48_elain =  { sound = "Main/sounds/ELAIN/48_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_64_elain =  { sound = "Main/sounds/ELAIN/64_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_68_elain =  { sound = "Main/sounds/ELAIN/68_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_72_elain =  { sound = "Main/sounds/ELAIN/72_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_76_elain =  { sound = "Main/sounds/ELAIN/76_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_80_elain =  { sound = "Main/sounds/ELAIN/80_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_84_elain =  { sound = "Main/sounds/ELAIN/84_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_88_elain =  { sound = "Main/sounds/ELAIN/88_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_91_elain =  { sound = "Main/sounds/ELAIN/91_ELAIN.ogg",  flags = "Voice" }
data.fx.fx_119_elain = { sound = "Main/sounds/ELAIN/119_ELAIN.ogg", flags = "Voice" }
data.fx.fx_131_elain = { sound = "Main/sounds/ELAIN/131_ELAIN.ogg", flags = "Voice" }
data.fx.fx_135_elain = { sound = "Main/sounds/ELAIN/135_ELAIN.ogg", flags = "Voice" }
data.fx.fx_139_elain = { sound = "Main/sounds/ELAIN/139_ELAIN.ogg", flags = "Voice" }
data.fx.fx_147_elain = { sound = "Main/sounds/ELAIN/147_ELAIN.ogg", flags = "Voice" }
data.fx.fx_170_elain = { sound = "Main/sounds/ELAIN/170_ELAIN.ogg", flags = "Voice" }
data.fx.fx_174_elain = { sound = "Main/sounds/ELAIN/174_ELAIN.ogg", flags = "Voice" }
data.fx.fx_178_elain = { sound = "Main/sounds/ELAIN/178_ELAIN.ogg", flags = "Voice" }
data.fx.fx_182_elain = { sound = "Main/sounds/ELAIN/182_ELAIN.ogg", flags = "Voice" }
data.fx.fx_185_elain = { sound = "Main/sounds/ELAIN/185_ELAIN.ogg", flags = "Voice" }
data.fx.fx_189_elain = { sound = "Main/sounds/ELAIN/189_ELAIN.ogg", flags = "Voice" }
data.fx.fx_193_elain = { sound = "Main/sounds/ELAIN/193_ELAIN.ogg", flags = "Voice" }
data.fx.fx_197_elain = { sound = "Main/sounds/ELAIN/197_ELAIN.ogg", flags = "Voice" }
data.fx.fx_201_elain = { sound = "Main/sounds/ELAIN/201_ELAIN.ogg", flags = "Voice" }
data.fx.fx_245_elain = { sound = "Main/sounds/ELAIN/245_ELAIN.ogg", flags = "Voice" }
data.fx.fx_249_elain = { sound = "Main/sounds/ELAIN/249_ELAIN.ogg", flags = "Voice" }
data.fx.fx_253_elain = { sound = "Main/sounds/ELAIN/253_ELAIN.ogg", flags = "Voice" }
data.fx.fx_257_elain = { sound = "Main/sounds/ELAIN/257_ELAIN.ogg", flags = "Voice" }
data.fx.fx_261_elain = { sound = "Main/sounds/ELAIN/261_ELAIN.ogg", flags = "Voice" }
data.fx.fx_265_elain = { sound = "Main/sounds/ELAIN/265_ELAIN.ogg", flags = "Voice" }
data.fx.fx_269_elain = { sound = "Main/sounds/ELAIN/269_ELAIN.ogg", flags = "Voice" }
data.fx.fx_273_elain = { sound = "Main/sounds/ELAIN/273_ELAIN.ogg", flags = "Voice" }
data.fx.fx_335_elain = { sound = "Main/sounds/ELAIN/335_ELAIN.ogg", flags = "Voice" }
data.fx.fx_339_elain = { sound = "Main/sounds/ELAIN/339_ELAIN.ogg", flags = "Voice" }
data.fx.fx_346_elain = { sound = "Main/sounds/ELAIN/346_ELAIN.ogg", flags = "Voice" }
data.fx.fx_350_elain = { sound = "Main/sounds/ELAIN/350_ELAIN.ogg", flags = "Voice" }
data.fx.fx_357_elain = { sound = "Main/sounds/ELAIN/357_ELAIN.ogg", flags = "Voice" }
data.fx.fx_380_elain = { sound = "Main/sounds/ELAIN/380_ELAIN.ogg", flags = "Voice" }
data.fx.fx_384_elain = { sound = "Main/sounds/ELAIN/384_ELAIN.ogg", flags = "Voice" }
data.fx.fx_391_elain = { sound = "Main/sounds/ELAIN/391_ELAIN.ogg", flags = "Voice" }
data.fx.fx_402_elain = { sound = "Main/sounds/ELAIN/402_ELAIN.ogg", flags = "Voice" }
data.fx.fx_420_elain = { sound = "Main/sounds/ELAIN/420_ELAIN.ogg", flags = "Voice" }
data.fx.fx_424_elain = { sound = "Main/sounds/ELAIN/424_ELAIN.ogg", flags = "Voice" }
data.fx.fx_431_elain = { sound = "Main/sounds/ELAIN/431_ELAIN.ogg", flags = "Voice" }
data.fx.fx_437_elain = { sound = "Main/sounds/ELAIN/437_ELAIN.ogg", flags = "Voice" }
data.fx.fx_441_elain = { sound = "Main/sounds/ELAIN/441_ELAIN.ogg", flags = "Voice" }
data.fx.fx_454_elain = { sound = "Main/sounds/ELAIN/454_ELAIN.ogg", flags = "Voice" }
data.fx.fx_458_elain = { sound = "Main/sounds/ELAIN/458_ELAIN.ogg", flags = "Voice" }
data.fx.fx_478_elain = { sound = "Main/sounds/ELAIN/478_ELAIN.ogg", flags = "Voice" }
data.fx.fx_482_elain = { sound = "Main/sounds/ELAIN/482_ELAIN.ogg", flags = "Voice" }
data.fx.fx_486_elain = { sound = "Main/sounds/ELAIN/486_ELAIN.ogg", flags = "Voice" }
data.fx.fx_490_elain = { sound = "Main/sounds/ELAIN/490_ELAIN.ogg", flags = "Voice" }
data.fx.fx_494_elain = { sound = "Main/sounds/ELAIN/494_ELAIN.ogg", flags = "Voice" }
data.fx.fx_498_elain = { sound = "Main/sounds/ELAIN/498_ELAIN.ogg", flags = "Voice" }
data.fx.fx_502_elain = { sound = "Main/sounds/ELAIN/502_ELAIN.ogg", flags = "Voice" }
data.fx.fx_518_elain = { sound = "Main/sounds/ELAIN/518_ELAIN.ogg", flags = "Voice" }
data.fx.fx_522_elain = { sound = "Main/sounds/ELAIN/522_ELAIN.ogg", flags = "Voice" }
data.fx.fx_526_elain = { sound = "Main/sounds/ELAIN/526_ELAIN.ogg", flags = "Voice" }
data.fx.fx_530_elain = { sound = "Main/sounds/ELAIN/530_ELAIN.ogg", flags = "Voice" }
data.fx.fx_534_elain = { sound = "Main/sounds/ELAIN/534_ELAIN.ogg", flags = "Voice" }
data.fx.fx_538_elain = { sound = "Main/sounds/ELAIN/538_ELAIN.ogg", flags = "Voice" }
data.fx.fx_542_elain = { sound = "Main/sounds/ELAIN/542_ELAIN.ogg", flags = "Voice" }
data.fx.fx_546_elain = { sound = "Main/sounds/ELAIN/546_ELAIN.ogg", flags = "Voice" }
data.fx.fx_550_elain = { sound = "Main/sounds/ELAIN/550_ELAIN.ogg", flags = "Voice" }
data.fx.fx_554_elain = { sound = "Main/sounds/ELAIN/554_ELAIN.ogg", flags = "Voice" }
data.fx.fx_558_elain = { sound = "Main/sounds/ELAIN/558_ELAIN.ogg", flags = "Voice" }
data.fx.fx_562_elain = { sound = "Main/sounds/ELAIN/562_ELAIN.ogg", flags = "Voice" }
data.fx.fx_565_elain = { sound = "Main/sounds/ELAIN/565_ELAIN.ogg", flags = "Voice" }
data.fx.fx_572_elain = { sound = "Main/sounds/ELAIN/572_ELAIN.ogg", flags = "Voice" }
data.fx.fx_576_elain = { sound = "Main/sounds/ELAIN/576_ELAIN.ogg", flags = "Voice" }
data.fx.fx_580_elain = { sound = "Main/sounds/ELAIN/580_ELAIN.ogg", flags = "Voice" }
data.fx.fx_584_elain = { sound = "Main/sounds/ELAIN/584_ELAIN.ogg", flags = "Voice" }
data.fx.fx_588_elain = { sound = "Main/sounds/ELAIN/588_ELAIN.ogg", flags = "Voice" }
data.fx.fx_592_elain = { sound = "Main/sounds/ELAIN/592_ELAIN.ogg", flags = "Voice" }
data.fx.fx_596_elain = { sound = "Main/sounds/ELAIN/596_ELAIN.ogg", flags = "Voice" }
data.fx.fx_600_elain = { sound = "Main/sounds/ELAIN/600_ELAIN.ogg", flags = "Voice" }
data.fx.fx_604_elain = { sound = "Main/sounds/ELAIN/604_ELAIN.ogg", flags = "Voice" }
data.fx.fx_608_elain = { sound = "Main/sounds/ELAIN/608_ELAIN.ogg", flags = "Voice" }
data.fx.fx_612_elain = { sound = "Main/sounds/ELAIN/612_ELAIN.ogg", flags = "Voice" }
data.fx.fx_616_elain = { sound = "Main/sounds/ELAIN/616_ELAIN.ogg", flags = "Voice" }
data.fx.fx_620_elain = { sound = "Main/sounds/ELAIN/620_ELAIN.ogg", flags = "Voice" }

data.fx.fx_36_higgs  = { sound = "Main/sounds/HIGGS/36_HIGGS.ogg",  flags = "Voice" }
data.fx.fx_40_higgs  = { sound = "Main/sounds/HIGGS/40_HIGGS.ogg",  flags = "Voice" }
data.fx.fx_44_higgs  = { sound = "Main/sounds/HIGGS/44_HIGGS.ogg",  flags = "Voice" }
data.fx.fx_52_higgs  = { sound = "Main/sounds/HIGGS/52_HIGGS.ogg",  flags = "Voice" }
data.fx.fx_143_higgs = { sound = "Main/sounds/HIGGS/143_HIGGS.ogg", flags = "Voice" }
data.fx.fx_276_higgs = { sound = "Main/sounds/HIGGS/276_HIGGS.ogg", flags = "Voice" }
data.fx.fx_279_higgs = { sound = "Main/sounds/HIGGS/279_HIGGS.ogg", flags = "Voice" }
data.fx.fx_283_higgs = { sound = "Main/sounds/HIGGS/283_HIGGS.ogg", flags = "Voice" }
data.fx.fx_287_higgs = { sound = "Main/sounds/HIGGS/287_HIGGS.ogg", flags = "Voice" }
data.fx.fx_291_higgs = { sound = "Main/sounds/HIGGS/291_HIGGS.ogg", flags = "Voice" }
data.fx.fx_295_higgs = { sound = "Main/sounds/HIGGS/295_HIGGS.ogg", flags = "Voice" }
data.fx.fx_299_higgs = { sound = "Main/sounds/HIGGS/299_HIGGS.ogg", flags = "Voice" }
data.fx.fx_303_higgs = { sound = "Main/sounds/HIGGS/303_HIGGS.ogg", flags = "Voice" }
data.fx.fx_307_higgs = { sound = "Main/sounds/HIGGS/307_HIGGS.ogg", flags = "Voice" }
data.fx.fx_311_higgs = { sound = "Main/sounds/HIGGS/311_HIGGS.ogg", flags = "Voice" }
data.fx.fx_315_higgs = { sound = "Main/sounds/HIGGS/315_HIGGS.ogg", flags = "Voice" }
data.fx.fx_319_higgs = { sound = "Main/sounds/HIGGS/319_HIGGS.ogg", flags = "Voice" }
data.fx.fx_323_higgs = { sound = "Main/sounds/HIGGS/323_HIGGS.ogg", flags = "Voice" }
data.fx.fx_327_higgs = { sound = "Main/sounds/HIGGS/327_HIGGS.ogg", flags = "Voice" }
data.fx.fx_331_higgs = { sound = "Main/sounds/HIGGS/331_HIGGS.ogg", flags = "Voice" }
data.fx.fx_342_higgs = { sound = "Main/sounds/HIGGS/342_HIGGS.ogg", flags = "Voice" }
data.fx.fx_353_higgs = { sound = "Main/sounds/HIGGS/353_HIGGS.ogg", flags = "Voice" }
data.fx.fx_360_higgs = { sound = "Main/sounds/HIGGS/360_HIGGS.ogg", flags = "Voice" }
data.fx.fx_364_higgs = { sound = "Main/sounds/HIGGS/364_HIGGS.ogg", flags = "Voice" }
data.fx.fx_368_higgs = { sound = "Main/sounds/HIGGS/368_HIGGS.ogg", flags = "Voice" }
data.fx.fx_372_higgs = { sound = "Main/sounds/HIGGS/372_HIGGS.ogg", flags = "Voice" }
data.fx.fx_376_higgs = { sound = "Main/sounds/HIGGS/376_HIGGS.ogg", flags = "Voice" }
data.fx.fx_387_higgs = { sound = "Main/sounds/HIGGS/387_HIGGS.ogg", flags = "Voice" }
data.fx.fx_394_higgs = { sound = "Main/sounds/HIGGS/394_HIGGS.ogg", flags = "Voice" }
data.fx.fx_398_higgs = { sound = "Main/sounds/HIGGS/398_HIGGS.ogg", flags = "Voice" }
data.fx.fx_405_higgs = { sound = "Main/sounds/HIGGS/405_HIGGS.ogg", flags = "Voice" }
data.fx.fx_409_higgs = { sound = "Main/sounds/HIGGS/409_HIGGS.ogg", flags = "Voice" }
data.fx.fx_413_higgs = { sound = "Main/sounds/HIGGS/413_HIGGS.ogg", flags = "Voice" }
data.fx.fx_417_higgs = { sound = "Main/sounds/HIGGS/417_HIGGS.ogg", flags = "Voice" }
data.fx.fx_427_higgs = { sound = "Main/sounds/HIGGS/427_HIGGS.ogg", flags = "Voice" }
data.fx.fx_434_higgs = { sound = "Main/sounds/HIGGS/434_HIGGS.ogg", flags = "Voice" }
data.fx.fx_444_higgs = { sound = "Main/sounds/HIGGS/444_HIGGS.ogg", flags = "Voice" }
data.fx.fx_450_higgs = { sound = "Main/sounds/HIGGS/450_HIGGS.ogg", flags = "Voice" }
data.fx.fx_568_higgs = { sound = "Main/sounds/HIGGS/568_HIGGS.ogg", flags = "Voice" }

data.fx.fx_2_alien   = { sound = "Main/sounds/ALIEN/2_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_3_alien   = { sound = "Main/sounds/ALIEN/3_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_4_alien   = { sound = "Main/sounds/ALIEN/4_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_5_alien   = { sound = "Main/sounds/ALIEN/5_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_6_alien   = { sound = "Main/sounds/ALIEN/6_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_7_alien   = { sound = "Main/sounds/ALIEN/7_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_8_alien   = { sound = "Main/sounds/ALIEN/8_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_9_alien   = { sound = "Main/sounds/ALIEN/9_ALIEN.ogg",   flags = "Voice" }
data.fx.fx_10_alien  = { sound = "Main/sounds/ALIEN/10_ALIEN.ogg",  flags = "Voice" }
