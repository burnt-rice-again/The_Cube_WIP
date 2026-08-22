local package = ...

local default_map_id = "map_1v1_prime"

local function GetMapData()
	return data.map_data[Map.GetSave().lobby.map_id]
end

package.includes = {
	"ui/lobby.lua",
	"map_data/map_1v1_prime.lua",
	"map_data/map_2v2_planetside.lua",
}

function package:setup_scenario(settings)
	--settings.pregenerated_noise_offset = { 0, 0.21, 0, 0, }
	--settings.pregenerated_noise_scale = { 1, 0.4, 1, 1, }
	settings.skip_resources = true
	settings.skip_explorables = true
end

function package:get_new_player_faction_id()
	return Map.GetFaction("faction_1") and "faction_2" or "faction_1"
end

function package:switch_new_player_faction_id()
	return nil
end

function package:on_world_spawn()
	Map.GetSave().lobby = { map_id = default_map_id }
	Map.SetGameSpeed(0)
end

function package:on_player_faction_spawn(faction)
	faction.extra_data.started = nil -- clear until SpawnPlayerFaction
end

local function DefaultSpawnPlayerUnits(faction, loc)
	----------------------------------------------------------
	-- lander bot
	local lander = Map.CreateEntity(faction, "f_bot_2m_as")
	lander:AddComponent("c_deployment", "hidden")
	lander:AddComponent("c_power_cell")
	lander:AddComponent("c_fabricator", 1)
	--[[
	-- AI
	-- metalplate
	ImportBlueprint(faction, Tool.StringToTable("V3WW8Fc2AQYy31kJo0G1z5i8w1tR5zI1pl9Qf1mdosX2LKjLp057sXK000Dz921cSjA371Ljp1meMtZ1mcBEi1vwBJE001NfY1tOdAC3W2gPj23hgxQ00dtRt1pARxS1nhXY71mZhKc01drW820FjmE1rAJLk00VkNS289jSs1yypJx30el171rA1Ms1sYBya1r7Yf12ymrhq2edS8103PLHc1vhOtx0GPH3uV"))

	-- metalbar
	ImportBlueprint(faction, Tool.StringToTable("V3WW8Fc2AQYy31kJo0G1z5i8w1tR5zI1pl9Qf1mdosX2LKjLp057sXK1rA64J1nkYlA1vwCAb00vkIO2zdf4C07ITGw26ABKn00VjVd28RBAA0N9npp00e9B31sEZLw1viykz22XtuV1p9tv022WoW728CEUI00ds7X05gnmk21MUbN3W2FyN1z7LSI00VSKK1q0b0C1r1IVE1DPu6u21cirx0GLQVVy"))

	-- research
	ImportBlueprint(faction, Tool.StringToTable("8q2ck5yi0tMRo53BjgIa3lHLKD25UsPl0SSKqz2bKD7b1znodB1VBDmh00q2sx0JJxR21KgCgx4KsZtQ18MFQ60EL02P3NQXN52irNXo0Sejnu2AK2iE3YWVM90BnDyx14htTr1guYgj26jKSQ0PCNGG29m9wM2taiZO2jL7OS1Fk5vW1fchFm3SwzaX2xWcoF1D8XgA433mkx2jXchn1ILOmM3oMlqc3OnNyc1bHUo82P2NEP1Z6ttD2l0qWp2Y5pBe1RmiDO271JYN1RAYAr1v2Doi4AL2cW3sE0Tj2uxZQM0z6CDZ32L2OV4eWXkF1fYZfR1Dy3"))

	local beh = lander:AddComponent("c_autobase")
	UploadBehavior(beh, Tool.StringToTable("1CY2im4Ua1Bt3Bj4FAI6q0dOWEX1vRt5w2inOC902rnQk11bEpg4WGOQ13sYQ6L2RnVMc09NjnQ1XkSdo3iZqo509khDc0KWHm005hN3430wgEv3CbkJR2QqUG72oUOoR3MnjJp0kRK1D2Sig3f1XxKeu0Rf9nT0hV9BF2f6PM40zLIzx3Y9gxv0D1y5J0Fm3Ye410GYp4ULNVW3cWvKD1083cr4K6kSL0S8YqR1wiOqF1yyu661YYQ881efTx52VugnS0tXCIG1CNRgV0EnAWe0Z3oHZ3TSYPi0L5soK3MxxUl2U3Pil2RlqVl48ioee1qSXet4MIchw4KWXZ03zUrE308EU2o1Tb6310O2IXB2fV9RB423LN80Y75Ej0h2wiS3gvqkH3UNNes0gNy7d2fHsO20RsOOV3WYkvG1sVU3n46k8Qj4HSq9I3wkPqP0ruvKb3oxcWT2Jky9H2dQPRh1dxCdU4bVyzL2pNIxB2QAWPF0oskL81fYKoe4g3nL70UdW1v4SFkOl3onMDi0CigeC18t1Hp19lOUP03H1Hw24viuY054gtD1whOwo2Y3EwF199TWS3lU6SS3jLdog2oQRMI0OsraU2USO4X2Wh6AJ3WPshr30ARm01QwBFQ2hZj9L3HvQkU0SFAlS3aty1m3wAAj72mhZPm0NxAT60zgzhW0zZHNG0oQGXV3jGfVb3REBNO4dacrM14I6QX4Ew4lA2HuxG41T3fiR1oAQIl0MknAL1OYubV0LyiEX2r1Ccz4HCncU0smBBY49v3HR2SxoPS4XjuN83r7NPr3n8SoG2O9aLX1963xZ23Tu8d4DDTRv0fqos43sMcJ12mwFf10bL4MF30PRX208zh932f1gtn43qfX80qqKr12Htkez3tD8ZU3gLLYa2wocPh1QAGuM42qI0U1SdaFR3g617ni"))
	--]]
	lander:AddItem("c_uplink", 1)
	lander:AddComponent("c_portable_turret", 2)
	lander:AddItem("c_assembler", 1)
	lander:AddItem("circuit_board", 10)
	lander:AddItem("metalbar", 20)
	lander:AddItem("metalplate", 20)
	lander:Place(loc.x+0, loc.y+0)
	lander.disconnected = false
	faction.home_entity = lander

	-- resimulator
	local resim = Map.CreateEntity(faction, "f_building_sim")
	--resim:AddComponent("c_package_delivery", "hidden")
	resim:AddComponent("c_moduleefficiency_g")
	resim:Place(loc.x+1, loc.y+0)

	--[[
	local autobase = resim:AddComponent("c_autobase")
	UploadBehavior(autobase, Tool.StringToTable("1Dd2ioGsq1Bbj2d4IvTaC4RWFm62wO7Y82uiTBY1BrdmW1LBi6R3eiWo54NJoif4ZcyWv0YQG4o0ICbkC4RhayY2tnU4l2XGuJM0TTUk202qTSm4SAeOg22zkYD3ldW1e4AuLia1qDdcS25goWp3tXHzz0qNipI1wrRz827LLiq2ivXZQ0TgPNQ14RWxu2h2RO63fniiR3L4LkF1umM67053SEy37Jgss35bNan0KFK9C0p1ClH0pCWox1JKdjv0Tm10y2ktyRu4USHSk3CkP2A494f9g4748ot1snOrN2yPKJR4UE5yX0m5Vgn1lrlPf0H8TYD1uIp270gb1SG1iD9AF2zX9NY01GLD00Rieab4UkneF1MKXB01Rpi8k0S7yJk1DBSyh1LCcp60hJc7S2zIhHQ47rfsc0vH2H60WRO0j1YCubs4abMAo3msQyD13w2Jt0e6Ha8450rFt16DOhv1mmDKV4IaZrt1j6tt63gP1Ju2XPzPX0HWNIb3oyUkW3QlLVK2k2LLn4EhcEo45x8eM09oldi0OztIq3Ip81n14yW1j09LaR52Gktrp2sf8ba1rCv2P3lJZI22zTjwd11Z4hw3h9alj0NMUX52tWUWE0w0DMG1bnoVJ4OLVTi38jGt94fWZHC4XUUyc4dy3CR1xrN0h3QwTJs4ND17a0TIhqd3do5Rv3Nfea60PFAm50ZPv4D1c8Vao4Vxj1r2PQDuS17qNMD23NlBA4ezWI83QzMh74fl7LO0tJvX23NXSti2miczn1lEJEo4OfBlD1Ysn5v0lbUgh3y2VpR2bNOma0EhSUa0JN7Td1PZX7g1DFVPe2DHrx63DCTuu1ypbCx0YIVUb4YsGWR4VEQq919S"))
	--]]
	----------------------------------------------------------

	local bot1 = Map.CreateEntity(faction, "f_bot_1s_a")
	bot1:AddComponent("c_miner", 1)
	bot1:Place(loc.x+1, loc.y+3)
	bot1.disconnected = false
	bot1.logistics_carrier = false

	local bot2 = Map.CreateEntity(faction, "f_bot_1s_a")
	bot2:AddComponent("c_miner", 1)
	bot2:Place(loc.x-1, loc.y+3)
	bot2.disconnected = false
	bot2.logistics_carrier = false

	local bot3 = Map.CreateEntity(faction, "f_bot_1s_a")
	bot3:AddComponent("c_miner", 1)
	bot3:Place(loc.x+0, loc.y+3)
	bot3.disconnected = false
	bot3.logistics_carrier = false

	-- Defence Bot
	local bot5 = Map.CreateEntity(faction, "f_bot_1s_b")
	bot5:AddComponent("c_portable_turret", 1)
	bot5:Place(loc.x-2, loc.y+2)
	bot5.disconnected = false
	bot5.logistics_carrier = false
end

local function SpawnPlayerFaction(faction)
	local md = GetMapData()
	local faction_num = tonumber(faction.id:match('_(%d+)')) or 1

	-- go through all factions and check the teams
	local my_team = faction.extra_data.team or faction_num
	for _,f in ipairs(Map.GetFactions()) do
		if f ~= faction then -- same faction
			if (f.extra_data.team or tonumber(f.id:match('_(%d+)'))) == my_team then
				-- set to ally
				faction:SetTrust(f, 'ALLY', true)
				-- share visibilty
				faction:ShareVisibility(f)
			else
				-- set to enemy
				faction:SetTrust(f, 'ENEMY', true)
			end
		end
	end

	-- change faction color?

	-------------------------------------------
	---------- Player Start Location ----------
	-------------------------------------------
	local loc = md.faction_info[faction_num].spawn_location
	if md.SpawnPlayerUnits then
		md:SpawnPlayerUnits(faction, loc)
	else
		DefaultSpawnPlayerUnits(faction, loc)
	end

	faction.home_location = loc
	faction.extra_data.started = Map.GetTick()

	faction:Unlock("t_robot_tech_basic")

	------------------------------------------
	---------- PRODUCTION BUILDINGS ----------
	------------------------------------------

	---- 1x1 Fabricator Build ----
	ImportBlueprint(faction, Tool.StringToTable("V2edceq03PLHc1vhOtx00VjmI00e9B31sEZLw1viykz22XtuV1p9tv022WoW728CEUI1saBbn1vjnu321MU3Q0uAQeV25tJJc0BnqQT5"))

	-- ---- Make Fabricators Building ----
	-- ImportBlueprint(faction, Tool.StringToTable("4v4ADMl630zJgm2jJuz62ywQBV2W95DY3v5OJA0gklgC0hap7O0R7x7H3mE0On3nuuX10kkG6d0PeJiY2oOwlr2m7wo72n0siU0kBRmU27Jhar3iX8vB4KpTE63N9tmG2DYGre07TgGm0P4tSI2MYGP80tq3S60oBke01raMUY1VUjid0E2l8O29WVWg1jBJ7J008ZoE2mpMNHQ"))

	-- ---- Make Assemblers Building ----
	-- ImportBlueprint(faction, Tool.StringToTable("V2eia4U39IBDE1maVoB1os9GE25vjUX22TIun21O99B275UrF1kJo0G1z5i8w1tR5zI1pl9Qf1mdosX3ChJnx1r9TGH275AnI1z3mGj30ibZN1rA1Ms000gce3qRshw2LKcb220HOnj1kIyem1rBgrB1r9kNx1q0ayw30Crf4271ucs2fltcO31MdI81xyg4S0h9L"))

	---- Unit Producer ----
	ImportBlueprint(faction, Tool.StringToTable("V3AQQ2m28Arpt22XKfA1r7ICy1mcmna2fmwub03PLHc095Jsz1vhOty00VjmI00e9B425rJb828CVKx1kNIfh289CgI02oBZv1pAAuQ275CwR1z3mGj371d7F23eO1L21LOWd3BYwDc29HK1G1vf8jx2CTJle1sXokD1rA1Mw0Er"))

	---- Miner Bot 01  -  Worker ----
	ImportBlueprint(faction, Tool.StringToTable("V3W4LNW23hgxQ2zvHoz00WYWg00e9B320BKzf25sybZ22TIun21O99B275UrF1kJnjk1kNaWA1mYbmj1mdosX3W02eL00RbvO22U7qS25sxwK1vYseO0aq6yk30isPS1rA1Ms0Aq"))

	---- Defencebot 01  -  Worker  /  Portable Turret ----
	ImportBlueprint(faction, Tool.StringToTable("V3W4LNW23hgxQ2zvHoz00WYWg00e9B323aWYb1meNlH1kJSaI25wYi4371dFV23eO1L21LOWd371M8a22Swti26n3aO1sXoch1rA1Mw1vwHL633KRme1q1MjG3BYw9F1r86HU0amXD40aqfjO21ceWm0BnqQTQ"))
end

local function WorldSpawn(map_data)
	map_data.spawn_explorables()

	-------------------------------------
	---- RESOURCE SPAWNING --------------
	----------------------------------------
	for _,v in ipairs(map_data.resource_array or {}) do
		local nodetype, x, y, amt, rot, vis, resourcenode = v[1], v[2], v[3], v[4], v[5], v[6]
		if nodetype == 'metalore' then resourcenode = Map.CreateEntity("world", "f_resourcenode_metal", vis)
		elseif nodetype == 'crystal' then resourcenode = Map.CreateEntity("world", "f_resourcenode_crystal", vis)
		elseif nodetype == 'silica' then resourcenode =  Map.CreateEntity("world", "f_resourcenode_silica", vis)
		elseif nodetype == 'blight_crystal' then resourcenode =  Map.CreateEntity("world", "f_resourcenode_blightcrystal", vis)
		end

		if resourcenode then
			resourcenode:SetRegister(FRAMEREG_GOTO, { id = nodetype, num = amt })
			resourcenode:Place(x, y, rot)
		else
			print("--- INVALID NODE TYPE ---")
		end
	end
	----------------------------------------

	----------------------------------------
	---- ENEMIES ---------------------------
	----------------------------------------
	local bugs = GetBugsFaction()
	for _,v in ipairs(map_data.bugs_array or {}) do
		local bugtype, x, y, rot, lvl = v[1], v[2], v[3], v[4], v[5]

		local bug = Map.CreateEntity(bugs, bugtype)
		bug:Place(x, y, rot)

		local bugspawn = bug:FindComponent("c_bug_spawn", true)
		bugspawn.extra_data.lvl = lvl
		bugspawn.extra_data.bugs = {}
		bugspawn.extra_data.extra_spawned = 0
		bugspawn.extra_data.spawned = -990
	end
	----------------------------------------

	----------------------------------------
	---- CREEPS ----------------------------
	----------------------------------------
	for _,v in ipairs(map_data.creep_array or {}) do
		local bugtype, x, y, rot, comps = v[1], v[2], v[3], v[4], v[5]

		local bug = Map.CreateEntity(bugs, bugtype)
		for __, c in ipairs(comps or {}) do
			bug:AddComponent(c)
		end
		bug:Place(x, y, rot)
	end
end

function package:on_player_ready_change(player_id, state)
	local player_factions, already_started = Map.GetPlayerFactions()
	for _,f in ipairs(player_factions) do
		if f.extra_data.started then already_started = true break end
	end

	if already_started then  -- late join
		if not state then return end

		local faction = Map.GetFaction(Game.GetPlayerById(player_id).faction_id)
		if not faction.extra_data.started then
			faction.name = nil -- let game use the name of the first player
			faction.is_player_controlled = true -- show in "Switch Faction" menu
			SpawnPlayerFaction(faction)
		end
	else
		for _,p in ipairs(Game.GetAllPlayers()) do if not p.ready then return end end -- not everyone ready

		-- Set map texture before anything is spawned
		local md = GetMapData()
		if md.map_texture then Map.ModifySettings("pregenerated_noise", md.map_texture) end

		-- spawn player factions
		for _,faction in ipairs(player_factions) do
			faction.name = nil -- let game use the name of the first player
			if faction.has_logged_in_player then
				SpawnPlayerFaction(faction)
			else
				faction.is_player_controlled = false -- hide from "Switch Faction" menu
			end
		end

		-- spawn ai player factions
		for _,v in ipairs(Map.GetSave().lobby.ai or {}) do
			if v then
				local faction = Map.GetFaction(v.faction_id)
				if not faction.extra_data.started then
					-- New faction, AI player not playing together with human player
					faction.is_player_controlled = true -- show in "Switch Faction" menu
					SpawnPlayerFaction(faction)
				end

				-- Add AI base controller
				faction:Unlock("c_autobase")
				for _,e in ipairs(faction.entities) do
					if e.id == "f_bot_2m_as" then
						if e:FindComponent("c_autobase") then break end
						local autobase = e:AddComponent("c_autobase")
						UploadBehavior(autobase, Tool.StringToTable("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"))
						break
					end
				end
			end
		end

		WorldSpawn(md)

		Map.SetGameSpeed(1)
	end

	UI.Run("OnCloseVersusLobby") -- hide lobby UI
end

function package:init()
	-----  Immortal Resources  -----
	data.frames.f_resourcenode_obsidian.immortal = true
	data.frames.f_resourcenode_laterite.immortal = true
	data.frames.f_resourcenode_metal.immortal = true
	data.frames.f_resourcenode_crystal.immortal = true
	data.frames.f_resourcenode_silica.immortal = true
	data.frames.f_resourcenode_blightcrystal.immortal = true
	data.frames.f_resourcenode_tree.immortal = true

	-- Disable race specific rewards on these explorables
	data.visuals.v_alien_feeder_dead.explorable_race = "world"
	data.visuals.v_alien_extractor_dead.explorable_race = "world"
	data.visuals.v_explorable_building_2.explorable_race = "world"
	data.visuals.v_explorable_building_4.explorable_race = "world"

	------------------------------ TEST RTS Fast Progress -----------------------

	--data.land_features = {}

	data.frames.f_building_sim.on_destroy = function(self, entity, damager)
		local faction = entity.faction
		Map.Defer(function()
			for _,v in ipairs(faction.entities) do
				if v.exists then v:Destroy() end
			end
		end)
	end

	-- ROBOTS STARTING POINT
	data.tech_categories = {
		--[[
		{
			name = "Virus",
			discovery_tech = "t_robotics_virus_discovery",
			initial_tech = "t_robots_virus",
			sub_categories = { "Virus" },
			texture = "Main/skin/Icons/Special/Technologies/Virus.png",
		},
		{
			name = "Human",
			discovery_tech = "t_robots_human_discovery",
			initial_tech = "t_human_intel",
			sub_categories = { "Human" },
			texture = "Main/skin/Icons/Special/Technologies/Human.png",
		},
		--]]
		{
			name = "Robots",
			initial_tech = "t_robot_tech_basic",
			sub_categories = { "Basic", },
			texture = "Main/skin/Icons/Special/Technologies/Robots.png",
			textures = { "Main/skin/Icons/Special/Technologies/Basic.png", "Main/skin/Icons/Special/Technologies/Robots.png", "Main/skin/Icons/Special/Technologies/Robots.png",},
		},
		--[[
		{
			name = "Alien",
			discovery_tech = "t_robots_alien_discovery",
			initial_tech = "t_robots_alien_research",
			sub_categories = { "Alien", },
			texture = "Main/skin/Icons/Special/Technologies/Aliens.png",
		},
		{
			name = "Blight",
			discovery_tech = "t_robots_blight_discovery",
			initial_tech = "t_blight_research",
			sub_categories = { "Blight" },
			texture = "Main/skin/Icons/Special/Technologies/Blight.png",
		},
		--]]
	}

	data.techs.t_robot_tech_basic = {
		name = "New Starter Tech", -- recovered database etc.
		texture = "Main/skin/Icons/Special/Technologies/Robots.png",
		unlocks = {
			-----------------------------------
			------------- CODEX ---------------
			-----------------------------------
			'x_bugs',

			-- NEW How to Play entries
			'x_tc_controls',   'x_tc_buildings', 'x_tc_deployment', 'x_tc_components',     'x_tc_research',  'x_tc_resources_mining',
			'x_tc_production', 'x_tc_logistics', 'x_tc_behaviors',     'x_tc_research',   'x_tc_user_interface', 'x_tc_registers', 'x_tc_power',
			'x_tc_unit',       'x_tc_transport_route',

			---------------------------------------
			----------- Starting Values -----------
			---------------------------------------
			'v_color_red', 'v_color_green', 'v_color_blue', 'v_color_yellow', 'v_color_cyan', 'v_color_magenta', 'v_ally_faction',
			'v_color_black', 'v_color_brown', 'v_color_crimson', 'v_color_dark_grey', 'v_color_light_green', 'v_color_light_grey',
			'v_color_pink', 'v_color_white', 'v_color_pastel',
			'v_own_faction', 'v_enemy_faction', 'v_world_faction', 'v_bot', 'v_building', 'v_construction', 'v_droppeditem', 'v_resource', 'v_damaged', 'v_mineable',
			'v_alien_faction', 'v_solved', 'v_unsolved', 'v_can_loot', 'v_bug_faction', 'v_human_faction', 'v_robot_faction', 'v_blight', 'v_not_blight',
			'v_plateau', 'v_valley', 'v_in_powergrid', 'v_is_foundation', 'v_is_grounded', 'v_is_flying', 'v_is_flower',

			-----------------------------------
			----------- Information -----------
			-----------------------------------
			'v_arrow_up', 'v_arrow_down', 'v_arrow_left', 'v_arrow_right',
			'v_arrow_upleft', 'v_arrow_upright', 'v_arrow_downleft', 'v_arrow_downright',
			'v_number_0', 'v_number_1', 'v_number_2', 'v_number_3', 'v_number_4', 'v_number_5', 'v_number_6', 'v_number_7', 'v_number_8', 'v_number_9',
			'v_lock_locked', 'v_lock_unlocked', 'v_alert',

			----------------------------------
			------------- states -------------
			----------------------------------
			'v_damaged', 'v_infected', 'v_broken', 'v_unpowered', 'v_emergency', 'v_powereddown', 'v_moving', 'v_pathblocked', 'v_idle',

			-------------- Starting Research -------------
			'f_foundation', 'foundationplate',

			---------------------------------
			----------- Logistics -----------
			---------------------------------
			'c_signpost', 'c_behavior', 'c_shared_storage', 'c_portablecrane',
			'f_drone_transfer_a2', 'f_drone_miner_a', 'f_drone_defense_a',

			----------------------------------
			-------------- Power -------------
			----------------------------------
			'c_light',
			'c_crystal_power',
			'c_portable_relay',
			'c_small_relay', 'c_power_relay',
			'c_capacitor', 'c_medium_capacitor',
			'c_small_battery', 'c_battery',
			'c_solar_cell', 'c_solar_panel',
			'c_power_transmitter',
			'c_wind_turbine', 'c_wind_turbine_l',
			'c_power_core',

			---------------------------------
			----------- Resources -----------
			---------------------------------
			-- Tier 1
			'metalore', 'crystal', 'metalbar', 'metalplate', 'silica', 'blight_crystal',
			'crystal_powder', 'cable',
			'circuit_board', 'reinforced_plate', 'energized_plate',
			'silicon', 'wire',
			'hdframe',
			'robot_datacube',

			-- Tier 2
			'refined_crystal',
			'icchip', 'optic_cable',
			'datacube_matrix',
			'robot_research',

			-- Tier 3
			'fused_electrodes',

			--- Alien/Blight ---
			'blight_plasma',
			'obsidian',
			'energized_artifact',
			'power_petal',

			--- Human ---
			'cpu',
			'micropro',
			'transformer',

			------------------------------------------
			----------- Starting Production ----------
			------------------------------------------
			'c_fabricator', 'c_assembler', 'c_advanced_assembler', 'c_miner',
			'c_robotics_factory', 'c_refinery', 'c_data_analyzer',

			-----------------------------------
			--------- Starting Units ----------
			-----------------------------------

			'f_building1x1a', -- 1M
			'f_building1x1b', -- 1L
			-- 'f_building1x1c', -- 2s
			'f_building1x1d', -- 1s

			'f_building1x1f', -- Storage Block (8)
			'f_building1x1g', -- Storage Block (16)

			'f_building2x1a', -- 2M
			-- 'f_building2x1b', -- 1L1M
			-- 'f_building2x1c', -- 2M
			-- 'f_building2x1d', -- 1M (24 storage)
			-- 'f_building2x1e', -- 2s1M
			'f_building2x1f', -- 1M-1s
			'f_building2x1g', -- 1M  -- Defense Building

			'f_building2x2a', -- 2M1L
			-- 'f_building2x2b', -- 3M
			-- 'f_building2x2c', -- 2M1L
			-- 'f_building2x2d', -- 2M1L
			-- 'f_building2x2e', -- 1M3s
			'f_building2x2f', -- 2M

			-- 'f_building3x2a', -- 1L3M
			-- 'f_building3x2b', -- 2M2s

			'f_building_sim', -- The Resimulator

			'f_bot_1s_a', -- scout
			'f_carrier_bot',

			-------------- Walls -------------
			'f_wall', 'f_gate',

			-------------- Starting Components -------------
			'c_deconstructor', 'c_scout_radar', 'c_uplink', 'c_portable_turret',

			------------------------
			-- WHEN to Unlock?
			------------------------
			-- 'c_plasma_turret',
			-- 'c_portable_turret_red', 'c_portable_turret_green',
			-- 'c_portable_radar', 'c_signal_reader',
			-- 'c_drone_comp',

			'f_building1x1h', -- Defence Block
		},
	}

	-------------------------------
	---------- ABILITIES ----------
	-------------------------------

	data.techs.t_signals1 = {
		order = 1,
		name = "ABILITIES",
		desc = "Allows for production of components for detection and signal transfer",
		texture = "Main/textures/tech/robots/robot_logistics_01_1.png",
		uplink_recipe = CreateUplinkRecipe({ silica = 4, }, 50), -- 50
		progress_count = 5,
		require_tech = { "t_assembly" },
		category = "Basic",
		unlocks = {
			'c_portable_radar', 'c_signal_reader', 'c_repairkit',
		},
	}

	data.techs.t_signals2 = {
		name = "ABILITIES II",
		desc = "Allows for production of components for detection and signal transfer",
		texture = "Main/textures/tech/robots/robot_logistics_01_1.png",
		uplink_recipe = CreateUplinkRecipe({ silica = 4, reinforced_plate = 1 }, 75), -- 50
		progress_count = 5,
		require_tech = { "t_signals1" },
		category = "Basic",
		unlocks = {
			'c_repairer', 'beacon_frame', 'f_beacon',
		},
	}

	data.techs.t_signals3 = {
		name = "ABILITIES III",
		desc = "Introduces Behaviors that allow increased and finer control of units for automation purposes",
		texture = "Main/textures/tech/robots/robot_logistics_02_1.png",
		uplink_recipe = CreateUplinkRecipe({ silicon = 6, hdframe = 1 }, 100), -- 100
		progress_count = 5,
		require_tech = { "t_signals2" },
		category = "Basic",
		unlocks = {
			'c_repairer_small_aoe', 'c_small_radar', 'c_drone_port',
		},
	}

	data.techs.t_signals4 = {
		name = "ABILITIES IV",
		desc = "Remote connection to units and items allows for damage repair and quick transportation of inventory",
		texture = "Main/textures/tech/robots/robot_logistics_03_1.png",
		uplink_recipe = CreateUplinkRecipe({ silicon = 6, icchip = 1 }, 150), -- 150
		progress_count = 5,
		require_tech = { "t_signals3" },
		category = "Basic",
		unlocks = {
			'c_repairer_aoe',
		},
	}

	data.techs.t_signals5 = {
		name = "ABILITIES V",
		desc = "Remote connection to units and items allows for damage repair and quick transportation of inventory",
		texture = "Main/textures/tech/robots/robot_logistics_03_1.png",
		uplink_recipe = CreateUplinkRecipe({ fused_electrodes = 4, }, 250), -- 250
		progress_count = 5,
		require_tech = { "t_signals4" },
		category = "Basic",
		unlocks = {
			'c_drone_launcher',
		},
	}

	--[[
		-------------------------------
		------------ UNITS ------------
		-------------------------------
		'f_bot_1s_b', -- Dashbot
		'f_bot_1m_a', -- Cub
		'f_bot_2s', -- Twinbot
		'f_bot_1m1s', -- Hound
		'f_bot_1m_b', -- Hauler
		'f_bot_1l_a', -- Rock
		'f_bot_1m_c', -- Mark V
		'f_bot_1s_as', -- Scout
		'f_bot_1s_adw', -- Engineer
		'f_bot_2m_as', -- Command Lander
	]]--


	data.techs.t_structures1 = {
		order = 2,
		name = "UNITS",
		desc = "Expands the range of small buildings with a variety of socket configurations",
		texture = "Main/textures/tech/robots/robot_robotics_01_1.png",
		uplink_recipe = CreateUplinkRecipe({ silica = 4,}, 50), -- 50
		progress_count = 5,
		require_tech = { "t_assembly" },
		category = "Basic",
		unlocks = {
			'f_bot_1s_b', -- Dashbot
			'f_building1x1c',
		},
	}

	data.techs.t_robotics10 = {
		name = "UNITS II",
		desc = "Introduction of Robotics Assembler allowing production of units with greater capabilities",
		texture = "Main/textures/tech/robots/robot_robotics_02_1.png",

		uplink_recipe = CreateUplinkRecipe({ silicon = 4, energized_plate = 1 }, 100), -- 100
		progress_count = 5,
		require_tech = { "t_structures1" },
		category = "Basic",
		unlocks = {
			'f_bot_2s', -- Twinbot
			'f_bot_1m_a', -- Cub
			'f_building2x1c',
			'f_building2x1e'
		},
	}

	data.techs.t_robotics0 = {
		name = "UNITS III",
		desc = "Expansion and improvement of production ability adding more advanced units",
		texture = "Main/textures/tech/robots/robot_robotics_03_1.png",

		uplink_recipe = CreateUplinkRecipe({ silicon = 6, hdframe = 1 }, 150), -- 150
		progress_count = 5,
		require_tech = { "t_robotics10" },
		category = "Basic",
		unlocks = {
			'f_bot_1m_b', -- Hauler
			'f_bot_1m1s', -- Hound
			'f_building3x2b',
			'f_building2x2b',
		},
	}

	data.techs.t_robotics0t4 = {
		name = "UNITS IV",
		desc = "Expansion and improvement of production ability adding more advanced units",
		texture = "Main/textures/tech/robots/robot_robotics_03_1.png",

		uplink_recipe = CreateUplinkRecipe({ fused_electrodes = 1, icchip = 1 }, 200), -- 200
		progress_count = 5,
		require_tech = { "t_robotics0" },
		category = "Basic",
		unlocks = {
			'f_bot_1l_a', -- Rock
			'f_bot_1s_as', -- Scout
			'f_bot_1s_adw', -- Engineer
			'f_building2x2d',
			'f_building2x2e',
		},
	}

	data.techs.t_research1 = {
		name = "UNITS V",
		desc = "The understanding of simulation data opening a gateway to advanced technologies and meta materials",
		texture = "Main/textures/tech/robots/robot_robotics_04_1_gt.png",
		uplink_recipe = CreateUplinkRecipe({ fused_electrodes = 8 }, 250), -- 250
		progress_count = 5,
		require_tech = { "t_robotics0t4" },
		unlocks = {
			'f_bot_2m_as', -- Command Lander
			'f_bot_1m_c', -- Mark V
			'f_building3x2a',
			'f_building2x2c',
		},
		category = "Basic",
	}

	--------------------------------
	------------ COMBAT ------------
	--------------------------------

	data.techs.t_power0 = {
		order = 3,
		name = "COMBAT",
		desc = "Unlocks power production and storage components that contribute to your power grid",
		texture = "Main/textures/tech/robots/robot_power_01_1.png",
		uplink_recipe = CreateUplinkRecipe({ silica = 4, wire = 1 }, 50), -- 50
		progress_count = 5,
		require_tech = { "t_assembly" },
		category = "Basic",
		unlocks = {
			'c_melee_pulse', 'c_adv_portable_turret',
		},
	}

	data.techs.t_power10 = {
		name = "COMBAT II",
		texture = "Main/textures/tech/robots/robot_power_02_1.png",
		desc = "Power Transmission for expanding the power grid and improving range of power options",
		uplink_recipe = CreateUplinkRecipe({ silicon = 4, energized_plate = 1 }, 75), -- 75
		progress_count = 5,
		require_tech = { "t_power0" },
		category = "Basic",
		unlocks = {
			'c_pulselasers', 'c_pulse_disrupter', 'c_shield_generator',
		},
	}

	data.techs.t_power1 = {
		name = "COMBAT III",
		texture = "Main/textures/tech/robots/robot_power_03_1.png",
		desc = "Increased ability to supply grid through wind powered production and power storage components",
		uplink_recipe = CreateUplinkRecipe({ silicon = 6, hdframe = 1 }, 150), -- 150
		progress_count = 5,
		require_tech = { "t_power10" }, --{ "t_power0" },
		category = "Basic",
		unlocks = {
			'c_turret', 'c_photon_cannon',
		},
	}

	data.techs.t_power1t4 = {
		name = "COMBAT IV",
		texture = "Main/textures/tech/robots/robot_power_03_1.png",
		desc = "Increased ability to supply grid through wind powered production and power storage components",
		uplink_recipe = CreateUplinkRecipe({ silicon = 8, icchip = 1 }, 200), -- 200
		progress_count = 5,
		require_tech = { "t_power1" }, --{ "t_power0" },
		category = "Basic",
		unlocks = {
			'c_plasma_cannon', 'c_photon_beam', 'c_shield_generator2',
		},
	}

	data.techs.t_power1t5 = {
		name = "COMBAT V",
		texture = "Main/textures/tech/robots/robot_power_03_1.png",
		desc = "Increased ability to supply grid through wind powered production and power storage components",
		uplink_recipe = CreateUplinkRecipe({ fused_electrodes = 4, }, 250), -- 250
		progress_count = 5,
		require_tech = { "t_power1t4" }, --{ "t_power0" },
		category = "Basic",
		unlocks = {
			'c_laser_turret', 'c_shield_generator3', --'c_railgun', --'c_hybrid_beam_cannon',
		},
	}

	-- Tier 0 research
	------------------  BASIC TREE  ------------------
	------------------  TIER ONE  ------------------
	--[[
		data.techs.t_virus_rts1 = {
			order = 1,
			name = "T-1  Virus",
			desc = "Virus",
			texture = "Main/textures/tech/virus/virus_offense_01_1.png",
			uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 2 }, 50),
			progress_count = 5,
			require_tech = { "t_assembly" },
			category = "Basic",
			unlocks = {
			},
		}
		data.techs.t_human_rts1 = {
			order = 2,
			name = "T-1  Human Hybrid",
			desc = "Human Hybrid",
			texture = "Main/textures/tech/extractor.png",
			uplink_recipe = CreateUplinkRecipe({ blight_crystal = 1 }, 50),
			progress_count = 5,
			require_tech = { "t_assembly" },
			category = "Basic",
			unlocks = {
			},
		}
	]]--
	--[[
		data.techs.t_blight_rts1 = {
			order = 6,
			name = "T-1  Blight",
			desc = "Blight",
			texture = "Main/textures/tech/blight/blight_control_01_1.png",
			uplink_recipe = CreateUplinkRecipe({ blight_extraction = 2 }, 50),
			progress_count = 5,
			require_tech = { "t_assembly" },
			category = "Basic",
			unlocks = {
			},
		}
	]]--
	------------------  TIER TWO  ------------------
	--[[
		data.techs.t_virus_rts2 = {
			order = 1,
			name = "T-2  Virus",
			desc = "Virus",
			texture = "Main/textures/tech/virus/virus_offense_02_1.png",
			uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 3 }, 50),
			progress_count = 10,
			require_tech = { "t_virus_rts1" },
			category = "Basic",
			unlocks = {
			},
		}
		data.techs.t_human_rts2 = {
			order = 2,
			name = "T-2  Human Hybrid",
			desc = "Human Hybrid",
			texture = "Main/textures/tech/low_density_frames.png",
			uplink_recipe = CreateUplinkRecipe({ blight_crystal = 3 }, 50),
			progress_count = 10,
			require_tech = { "t_human_rts1" },
			category = "Basic",
			unlocks = {
			},
		}
	]]--
	--[[
		data.techs.t_blight_rts2 = {
			order = 6,
			name = "T-2  Blight",
			desc = "Blight",
			texture = "Main/textures/tech/blight/blight_control_02_1.png",
			uplink_recipe = CreateUplinkRecipe({ blight_extraction = 5 }, 50),
			progress_count = 10,
			require_tech = { "t_blight_rts1" },
			category = "Basic",
			unlocks = {
			},
		}
	]]--
	------------------  TIER THREE  ------------------
	--[[
		data.techs.t_virus_rts3 = {
			order = 1,
			name = "T-3  Virus",
			desc = "Virus",
			texture = "Main/textures/tech/virus/virus_offense_03_1.png",
			uplink_recipe = CreateUplinkRecipe({ infected_circuit_board = 4 }, 50),
			progress_count = 15,
			require_tech = { "t_virus_rts2" },
			category = "Basic",
			unlocks = {
			},
		}
		data.techs.t_human_rts3 = {
			order = 2,
			name = "T-1  Human Hybrid",
			desc = "Human Hybrid",
			texture = "Main/textures/icons/components/component_ScienceAnalyzer_01_l.png",
			uplink_recipe = CreateUplinkRecipe({ blight_crystal = 5 }, 50),
			progress_count = 15,
			require_tech = { "t_human_rts2" },
			category = "Basic",
			unlocks = {
			'c_missile_turret',
			},
		}
	]]--
	--[[
		data.techs.t_blight_rts3 = {
			order = 6,
			name = "T-3  Blight",
			desc = "Blight",
			texture = "Main/textures/tech/blight/blight_control_03_1.png",
			uplink_recipe = CreateUplinkRecipe({ blight_extraction = 10 }, 50),
			progress_count = 15,
			require_tech = { "t_blight_rts2" },
			= "Basic",
			unlocks = {
			},
		}
	]]--

	-- ---------------------------  SILICA DROP IN VERSUS  -------------------------------
	-- -----------------------------------------------------------------------------------
	data.frames.f_trilobyte1.resource = { 5, 8 }
	data.frames.f_gastarias1.resource = { 7, 15 }
	data.frames.f_scaramar1.resource = { 12, 25 }
	data.components.c_shield_generator3.production_recipe.ingredients.c_shield_generator2 = nil
	data.components.c_shield_generator3.production_recipe.producers.c_assembler = 5
	data.components.c_laser_turret.production_recipe.ingredients.c_turret = nil
	data.components.c_laser_turret.production_recipe.producers.c_assembler = 5
	data.components.c_plasma_cannon.production_recipe.ingredients.c_photon_cannon = nil
	data.components.c_photon_beam.production_recipe.ingredients.c_photon_cannon = nil
	data.components.c_plasma_cannon.production_recipe.producers.c_assembler = 5
	data.components.c_photon_beam.production_recipe.producers.c_assembler = 5
	data.components.c_turret.production_recipe.ingredients.c_adv_portable_turret = nil
	data.components.c_photon_cannon.production_recipe.ingredients.c_adv_portable_turret = nil
	data.components.c_pulse_disrupter.production_recipe.ingredients.c_melee_pulse = nil
	data.components.c_pulselasers.production_recipe.ingredients.c_portable_turret = nil
	data.components.c_adv_portable_turret.production_recipe.ingredients.c_portable_turret = nil


	----------------------------------------------------------------------

	--local prod = data.frames.f_bot_1s_as.production_recipe.producers
	--prod.c_package_delivery = 50
	--[[
	local md = GetMapData()
	if md.init then
		md.init()
	end
	--]]
end
