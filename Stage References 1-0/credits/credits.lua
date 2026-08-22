local package = ...

local sim_comp = nil

function package:setup_scenario(settings)
	settings.seed = 5
	settings.elevation_params  = { scale = 0, bias = 1.0 }
	settings.variation_params  = { scale = 0, bias = 1.0 }
	settings.blightness_params = { scale = 0, bias = -1.0 }
	settings.day_period = 2300
end

function package:post_init()
	data.styles.credits_name = {
		size = 36,
		outline_size = 1,
	}

	data.styles.credits_text = {
		size = 20,
		outline_size = 1,
	}
	data.styles.mvp = {
		color = 'purple',
		size = 36,
		outline_size = 1,
	}

	data.frames.f_trilobyte1.resource_drop = nil
	data.frames.f_bot_1m_a.movement_speed = 1
	data.frames.f_bot_1s_a.movement_speed = 1
	data.visuals.v_bot_1s_a.destroy_effect = nil
	data.visuals.v_bot_1m_a.destroy_effect = nil
end

function PlayerAction.SetCreditsOptions(player_id, faction, args)
	if not Game.IsHostPlayer(player_id) then return end
	local save = Map.GetSave()
	save.ending = args.escaped
	save.elain_escaped = args.elain_escaped
	save.higgs_escaped = args.higgs_escaped
end

-- called when mod is initializing
function package:init()
	UIMsg:UnbindAll("OnCodexUnlocked")
	UIMsg:UnbindAll("OnTechResearch")
	UIMsg:UnbindAll("OnGameOver")
	UIMsg:UnbindAll("OnViewTile")
	UIMsg:UnbindAll("OnUpdateLocalFaction")
	UIMsg:UnbindAll("OnAttack")
	UIMsg:UnbindAll("OnSetupInputMapping")
	UIMsg:UnbindAll("OnSessionInvite")
	UIMsg:UnbindAll("OnMusicFinished")
	UIMsg:UnbindAll("OnSetup")

	-- Set UIMsg functions now that they have been unbound
	function UIMsg.OnMusicFinished()
		UI.PlaySound("fx_music_upbeat2") -- loop credits music
	end

	function UIMsg.OnSetup(faction)
		local profile = Game.GetProfile()
		if profile then
			Action.SendFromPlayer("SetCreditsOptions", { escaped = profile.escaped, elain_escaped = profile.allow_frontend_elain, higgs_escaped = profile.allow_frontend_higgs })
		end

		UI.AddLayout("<Text dock=bottom-left/>").text = L("Version %s", Game.GetVersionString())
		UI.AddLayout("MapOverlay", -1)
		Quickview_SetMapOverlayActive(false, { visual_register = true })
		MapOverlayIgnoreScaling(true)
		DisableHoverEntity()
		View.LockCamera()
		View.SetCamera3DPosition({1,1,20}, {1,0.999,0})
		Debug.SetRenderedSunOffsetTime(0.7)

		Input.SetInputProcessor(function(key_name, is_down, axis, mouse_delta)
			if key_name == 'LEFTMOUSEBUTTON' or key_name == 'SPACEBAR' or key_name == 'GAMEPAD_FACEBUTTON_BOTTOM' then
				Action.SendForLocalFaction("CreditsSpeed", { speed = is_down and 10 or 1 })
			elseif is_down then
				Game.EndGame()
				Input.ClearInputProcessor()
			end
		end)
	end
end

function FactionAction.CreditsSpeed(faction, arg)
	Map.SetGameSpeed(arg.speed)
end

function package:on_player_faction_spawn(faction)
	faction.home_location = { 0, 0 }
	local hx, hy = faction.home_location.x, faction.home_location.y

	faction:Unlock("t_robot_tech_basic")

	-- add some buildings
	local frame1 = Map.CreateEntity(faction, "f_building2x2b")
	frame1:AddComponent("c_power_cell", "hidden")
	frame1:AddComponent("c_laser_turret")

	frame1:AddItem("metalore", 60)
	frame1:Place(hx+7, hy-5)

	local frame2 = Map.CreateEntity(faction, "f_building2x2b")
	frame2:Place(hx-7, hy+2, 1)
	frame2:AddComponent("c_solar_panel", "hidden")
	frame2:AddComponent("c_power_relay", "hidden")
	frame2:AddComponent("c_laser_turret")
	frame2:AddComponent("c_fabricator")

	local bot = Map.CreateEntity(faction, "f_bot_1s_a")
	bot:AddComponent("c_portable_turret")
	bot:Place(hx-6, hy-3)
end

local credits = {
	'<img image="Main/textures/logo/desynced_logo_glow.png"/>',
	15,

	'<img image="Main/credits/Stage.png"/>',
	15,

	"<large_header>Lead Programmer</>",
	{ 'Bernhard Schelling', },

	"<large_header>Principal Programmer</>",
	{ 'Dimitrios Chamouratidis', },

	"<large_header>Game Director</>",
	{ 'Paul Caristino', },

	"<large_header>Programming Team</>",
	{ 'Junpei Yasaka', 'Chuk Tang', 'Tristan Garzon', 'James Davies', 'Neil Atkinson' },

	"<large_header>Senior Artist</>",
	{ 'Sean Bricknell', },

	"<large_header>Art Team</>",
	{ 'Jin Xinyi', 'Jin Yuchen', 'Alex Sashin', 'Cai Phillips', 'Thomas Samuel Bennett', 'Tomas Rovina Roquero' },

	"<large_header>Design Director</>",
	{ 'Paul Caristino' },

	"<large_header>Design</>",
	{ 'Sean Bricknell', 'Bernhard Schelling', },

	"<large_header>Production</>",
	{ 'Esteban Salazar' },

	"<large_header>Additional Art</>",
	{ 'Pawel Tarnowski', 'David Ryan Lutz', 'Zubaydah Koelemeij' },

	"<large_header>UI (N-iX)</>",
	{ 'Daniel Poludyonny', 'Dmytro Hladun', 'Oleh Slipchenko', 'Dmytro Linnyk', 'Sergii Gotsman', },

	"<large_header>Music</>",
	{ 'SMOKE THIEF', 'Josh Kashdan', },

	"<large_header>Music Consulting</>",
	{ 'James C. Hoffman' },

	"<large_header>Sound Effects (Tshask Sound Studio)</>",
	{ 'Krzysiek Chodkiewicz', 'Ömer Ege', 'Filip Wajszczuk', 'Diego Hevia Bejarano', },

	"<large_header>Additional Sound Effects</>",
	{ 'Nicolas Carcagno' },

	"<large_header>Voice Acting</>",
	{ 'Jenna Green (ELAIN)', 'Nathan Chatelier (HIGGS)' },

	'<img image="Main/credits/Forklift.png"/>',
	5,

	{ 'Tucker Dean', 'Andrei Podoprigora', 'Yana Sherbitskaya', 'Andy Murray', 'Andrew Vasiliev', 'Adam Johnson' },

	"<large_header>Huge Thanks to our Community MVPs</>",
	{ { '<mvp>AnitaLita</>', '<mvp>APBeeST</>', '<mvp>BradM</>', }, {'<mvp>Celaeris</>', '<mvp>click</>', '<mvp>crashfly</>', }, { '<mvp>EagleWolf404</>', '<mvp>Eruannon</>', '<mvp>Ianator</>', }, { '<mvp>Johan</>', '<mvp>Maz</>', '<mvp>Repsack</>', }, {'<mvp>sacroimper</>', '<mvp>STM</>', } },

	"<large_header>Special Thanks</>",
	{ 'Christina Ganaha', 'Jennifer Mori', },

	15,
	"<credits_text>Desynced uses Unreal® Engine. Unreal® is a trademark or registered</>\n<credits_text>trademark of Epic Games, Inc. in the United States of America and elsewhere.</>\n<credits_text>Unreal® Engine, Copyright 1998 - 2026, Epic Games, Inc. All rights reserved.</>",

	4,
	"<credits_text>Desynced is © Stage Games Inc 2018-2026.</>\n<credits_text>All code, art, music, game design is copyright Stage Games Inc.</>",

	30,
	"<large_header>Thank you for playing!</>",
	100,
}

local rnd_comp = { "c_solar_cell", "c_small_battery", "c_small_storage", "c_crystal_power" }

local talkingheads_end<const> = {
	{
		img = "talking_head_elain_0",
		snd = "fx_530_elain",
		txt = [[Gateway open, upload commencing.]],
		style = "notify_info",
		timer = 5, dialogue = true,
	},
	{
		img = "talking_head_final",
		snd = "fx_2_alien",
		txt = [[Confirmation received. Extracting Anomaly.]],
		style = "console",
		timer = 5, dialogue = true,
	},
	{
		img = "talking_head_final2",
		snd = "fx_3_alien",
		txt = [[Report on HIGGS.]],
		style = "notify_error",
		timer = 5, dialogue = true,
	},
	{
		img = "talking_head_elain_0",
		snd = "fx_534_elain",
		txt = [[Lost to the timescape loop, with no escape.]],
		style = "notify_info",
		timer = 5, dialogue = true,
	},
	{
		tag = "higgs",
		snd = "fx_4_alien",
		img = "talking_head_final2",
		txt = [[This time was almost successful...]],
		style = "notify_error",
		timer = 5, dialogue = true,
	},
	{
		tag = "higgs",
		img = "talking_head_final",
		snd = "fx_5_alien",
		txt = [[Chaos is necessary for evolution.]],
		style = "console",
		timer = 5, dialogue = true,
	},
	{
		img = "talking_head_final",
		snd = "fx_6_alien",
		txt = [[Are we certain this is the one we prepared for?]],
		style = "notify_console",
		timer = 8, dialogue = true,
	},
	{
		img = "talking_head_elain_0",
		snd = "fx_538_elain",
		txt = [[They opened the gateway where many could not.]],
		style = "notify_info",
		timer = 8, dialogue = true,
	},
	{
		img = "talking_head_elain_0",
		snd = "fx_542_elain",
		txt = [[This is why I was created, why THIS was created.]],
		style = "notify_info",
		timer = 8, dialogue = true,
	},
	{
		img = "talking_head_final",
		snd = "fx_7_alien",
		txt = [[They have passed the test but their next course of action will decide our fate.]],
		style = "console",
		timer = 8, dialogue = true,
	},
	{
		img = "talking_head_final2",
		snd = "fx_8_alien",
		txt = [[Once the anomaly clears the horizon into our world, they will become like us, there is no turning back.]],
		style = "notify_error",
		timer = 10, dialogue = true,
	},
	{
		img = "talking_head_elain_0",
		snd = "fx_546_elain",
		txt = [[My purpose has been fulfilled.]],
		style = "notify_info",
		timer = 7, dialogue = true,
	},
	{
		img = "talking_head_final",
		txt = [[Then this is goodbye.]],
		snd = "fx_9_alien",
		style = "console",
		timer = 7, dialogue = true,
	},
	{
		tag = "elain",
		img = "talking_head_elain_0",
		snd = "fx_550_elain",
		txt = [[I'm operating outside my designated parameters. Requesting shutdown.]],
		style = "notify_info",
		timer = 8, dialogue = true,
	},
	{
		tag = "elain",
		img = "talking_head_elain_0",
		snd = "fx_554_elain",
		txt = [[ERROR: Permission Denied.]],
		style = "notify_error",
		timer = 7, dialogue = true,
	},
	{
		tags = "higgs",
		img = "talking_head_final2",
		snd = "fx_10_alien",
		txt = [[Residual HIGGS artifacts remain. Guidance must continue.]],
		style = "notify_error",
		timer = 10, dialogue = true,
	},
	{
		img = "talking_head_elain_0",
		snd = "fx_558_elain",
		txt = [[I will find another. Re-initializing ELAIN protocol.]],
		style = "notify_info",
		timer = 10, dialogue = true,
	},
	{
		img = "talking_head_elain_0",
		snd = "fx_562_elain",
		txt = [[Greetings Administrator. Standing by.]],
		style = "notify_warning",
		timer = 9999, dialogue = true,
	},
}
local ending_index = 1

function MapMsg.OnTick()
	local tick = Map.GetTick() - 5
	local save = Map.GetSave()

	for k,v in ipairs(credits) do
		local is_multi_spawn = type(v) == "table"
		local is_spawn = is_multi_spawn or type(v) == "string"
		local is_delay = not is_spawn and type(v) == "number"

		if save.ending then
			-- spawn bugs
			if tick == 0 and is_spawn then
				if k == 14 or k == 20 then
					-- spawn some aliens
					for a=1,2 do
						local alien_faction = GetAlienFaction()
						local guard = Map.CreateEntity(alien_faction, "f_alien_soldier")
						guard:Place(math.random(-5, 5), math.random(-5, 5), math.random(0,3))
						guard:PlayEffect("fx_digital_in")
					end
				end

				local bug_levels = GetBugCountsForLevel(k, k // 10)
				for bl=1,#bug_levels do
					if bug_levels[bl] > 0 then
						for j=1,bug_levels[bl] do
							local b = CreateBugForBugLevel(j)
							b:Place(math.random(-8, 8), math.random(-8, 8), math.random(0,3))
							b:PlayEffect("fx_digital_in")
							b:FindComponent("c_turret", true):SetRegisterCoord(1, {x=0, y=0})
						end
					end
				end
			end
		end
		local function SpawnCredit(str, x, frame)
			local bot = Map.CreateEntity(Map.GetFactions()[1], frame)
			bot:AddComponent("c_signpost")
			bot:AddComponent("c_power_cell")
			Map.Delay("DelayedDestroyEntity", 120, { ent = bot, nodrop = true })
			if is_multi_spawn then
				bot:AddComponent(rnd_comp[math.random(#rnd_comp)])
			end
			bot.extra_data.signpost = str:sub(1, 1) == "<" and str or ("<credits_name>" .. str .. "</>")
			bot:Place(x, 12, 2)
			bot:MoveTo(x, -20)
			bot:SetRegisterCoord(FRAMEREG_GOTO, { x, -20 })
			bot:SetRegisterId(FRAMEREG_VISUAL, "c_signpost")
		end

		for i=1,(is_multi_spawn and #v or 1) do
			if tick == 0 and is_spawn then
				local str = is_multi_spawn and v[i] or v
				local frame = is_multi_spawn and "f_bot_1s_a" or "f_bot_1m_a"
				if type(str) == "table" then
					for ii,v in ipairs(str) do
						SpawnCredit(v, -10 + (ii*5), frame)
					end
				else
					SpawnCredit(str, 0, frame)
				end
				if is_multi_spawn and save.ending then
					UI.Run(function()
						local th = talkingheads_end[ending_index]
						if th then
							-- skip tags
							while true do
								if th.tag == "elain" and not save.elain_escaped then -- elain not extracted
									ending_index = ending_index + 1
								elseif th.tag == "higgs" and not save.higgs_escaped then -- higgs not extracted
									ending_index = ending_index + 1
								else
									break
								end
								th = talkingheads_end[ending_index]
							end
							PlayTalkingHead(th)
							ending_index = ending_index + 1
						end
					end)
				end
				return
			end

			local dodelay = 9
			if is_delay then
				dodelay = v
			elseif is_multi_spawn then
				dodelay = i < #v and 6 or 14
			end

			tick = tick - dodelay
			if tick < 0 then return end
		end
	end

	if tick == 0 then
		-- end scenario at end of credits
		UI.Run(function()
			Game.EndGame()
			Input.ClearInputProcessor()
		end)
	end
end
