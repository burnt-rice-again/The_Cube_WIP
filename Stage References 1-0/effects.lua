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
