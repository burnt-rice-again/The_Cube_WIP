local package = ...

-- files loaded when mod is initializing
package.includes = {
	"freeplay/freeplay_events.lua",
	"freeplay/freeplay_codex.lua",
	"freeplay/freeplay_tutorial.lua",
	"freeplay/freeplay_explorables.lua",
}

function package:setup_scenario(settings)
	if settings.tutorial then
		settings.peaceful = 1
	end
end

function package:init()
	local satunlock = data.techs.t_satellites.unlocks
	satunlock[#satunlock+1] = "x_freeplay_researched_satellties"

	local t_structures4_unlocks = data.techs.t_structures4.unlocks
	t_structures4_unlocks[#t_structures4_unlocks + 1] = "x_freeplay_robot_08_h1"

	local t_structures5_unlocks = data.techs.t_structures5.unlocks
	t_structures5_unlocks[#t_structures5_unlocks + 1] = "x_freeplay_robot_09_h1"

	local t_robotics3_unlocks = data.techs.t_robotics3.unlocks
	t_robotics3_unlocks[#t_robotics3_unlocks + 1] = "x_freeplay_robot_10_h1"

	local t_robotics3_unlocks = data.techs.t_robotics3.unlocks
	t_robotics3_unlocks[#t_robotics3_unlocks + 1] = "x_freeplay_robot_10"

	local t_robotics4_unlocks = data.techs.t_robotics4.unlocks
	t_robotics4_unlocks[#t_robotics4_unlocks + 1] = "x_freeplay_robot_11_h1"

	local t_robotics4_unlocks = data.techs.t_robotics4.unlocks
	t_robotics4_unlocks[#t_robotics4_unlocks + 1] = "x_freeplay_robot_11_h2"

	-- local t_ldframe_unlocks = data.techs.t_ldframe.unlocks
	-- t_ldframe_unlocks[#t_ldframe_unlocks + 1] = "x_freeplay_human_02"

	local t_robots_human_discovery_unlocks = data.techs.t_robots_human_discovery.unlocks
	t_robots_human_discovery_unlocks[#t_robots_human_discovery_unlocks + 1] = "x_freeplay_human_discovery"

	local t_human_intel_unlocks = data.techs.t_human_intel.unlocks
	t_human_intel_unlocks[#t_human_intel_unlocks + 1] = "x_freeplay_human_research"

	-- local t_extractor_unlocks = data.techs.t_extractor.unlocks
	-- t_extractor_unlocks[#t_extractor_unlocks + 1] = "x_freeplay_human_01_2"

	--local t_robotics_virus_discovery_unlocks = data.techs.t_robotics_virus_discovery.unlocks
	--t_robotics_virus_discovery_unlocks[#t_robotics_virus_discovery_unlocks + 1] = "x_freeplay_virus_discovery"

	local t_robots_virus_unlocks = data.techs.t_robots_virus.unlocks
	t_robots_virus_unlocks[#t_robots_virus_unlocks + 1] = "x_freeplay_virus_00"

	local t_robots_virus_cure_unlocks = data.techs.t_robots_virus_cure.unlocks
	t_robots_virus_cure_unlocks[#t_robots_virus_cure_unlocks + 1] = "x_freeplay_virus_01"

	local t_robots_virus_vaccine_unlocks = data.techs.t_robots_virus_vaccine.unlocks
	t_robots_virus_vaccine_unlocks[#t_robots_virus_vaccine_unlocks + 1] = "x_freeplay_virus_02"

	local t_robots_blight_discovery_unlocks = data.techs.t_robots_blight_discovery.unlocks
	t_robots_blight_discovery_unlocks[#t_robots_blight_discovery_unlocks + 1] = "x_freeplay_blight_discovery"

	local t_blight_plasma_unlocks = data.techs.t_blight_plasma.unlocks
	t_blight_plasma_unlocks[#t_blight_plasma_unlocks + 1] = "x_freeplay_blight_01"

	local t_blight_magnifier_unlocks = data.techs.t_blight_magnifier.unlocks
	t_blight_magnifier_unlocks[#t_blight_magnifier_unlocks + 1] = "x_freeplay_blight_02"

	local t_blight_protection_unlocks = data.techs.t_blight_protection.unlocks
	t_blight_protection_unlocks[#t_blight_protection_unlocks + 1] = "x_freeplay_blight_02_stability"

	local t_blight_conversion_unlocks = data.techs.t_blight_conversion.unlocks
	t_blight_conversion_unlocks[#t_blight_conversion_unlocks + 1] = "x_freeplay_blight_03"

	-- local t_blight_conversion_unlocks = data.techs.t_blight_conversion.unlocks
	-- t_blight_conversion_unlocks[#t_blight_conversion_unlocks + 1] = "x_freeplay_blight_03_h2"

	local nanounlock = data.techs.t_signals3.unlocks
	nanounlock[#nanounlock+1] = "x_freeplay_nanobots"
end

function package:on_world_spawn()
	if Map.GetSettings().allow_race_selection then
		Map.SetGameSpeed(0) -- paused until FactionAction.FreeplaySelectRace
	end
end

function package:on_player_faction_spawn(faction)
	local race = faction.extra_data.race
	if Map.GetSettings().allow_race_selection then
		if not race then
			faction.extra_data.started = nil -- clear until we get called again
			faction:RunUI("FreeplayRaceSelection")
			return -- this function gets called again by FactionAction.SelectRace
		end
		faction.extra_data.started = Map.GetTick() -- set to now
	end

	if race == "alien" then
		faction:Unlock("t_robots_blight_discovery", false)
		faction:Unlock("t_blight_research", false)
		faction:Unlock("t_blight_visibility", false)
		faction:Unlock("t_blight_protection", false)
		faction.has_blight_shield = true
		local find_player_faction_home = function ()
			for num = 1,999999999 do
				-- get an unspawned 60x60 chunk and check 9 spots inside of it (check a 20x20 grid)
				local loc_x, loc_y = Map.GetUndiscoveredLocation(num)
				for x = loc_x - 20, loc_x + 20, 20 do
					for y = loc_y - 20, loc_y + 20, 20 do
						if Map.GetBlightness(x, y) > 0.2 then
							return { x, y }
						end
					end
				end
			end
			return { 0, 0 }
		end
		faction.home_location = find_player_faction_home()
		local loc = faction.home_location
		faction.home_entity = FreeplaySpawnPlayerAlien(faction, loc)
		faction:Unlock("t_alien_tech_basic")
	elseif race == "human" then
		faction.home_location = GetPlayerFactionHomeOnGround()
		local loc = faction.home_location
		for _x=loc.x-3,loc.x+3 do
			for _y=loc.y-3,loc.y+3 do
				Map.CreateEntity(faction, "f_human_foundation"):Place(_x,_y)
			end
		end

		faction:Unlock("t_human_tech_basic")
		faction:Unlock("t_human_industry1", false)
		faction.home_entity = FreeplaySpawnPlayerHuman(faction, loc)
	else
		local is_tutorial = Map.GetSettings().tutorial
		faction.home_location = (is_tutorial and faction.id == "faction_1" and { 13, 20 }) or GetPlayerFactionHomeOnGround()
		local loc = faction.home_location
		faction.home_entity = FreeplaySpawnPlayer(faction, loc)

		-- show intro
		faction:RunUI("FreeplayRobotIntro")
		faction:Unlock("t_robot_tech_basic")

		Map.Delay("StartOfGame", 10, { faction = faction, })
		if is_tutorial then
			Map.Delay("TutorialBegin", 16, { faction = faction, })
		end
	end
end

function Delay.StartOfGame(arg)
	-- unlock starting tech/codex for this scenario for the local player (unlocked by default)
	arg.faction:Unlock("x_freeplay_start")

	local loc = arg.faction.home_location
	local spacedrop1 = Map.CreateEntity(arg.faction, "f_spacedrop", "v_spacedrop_1")
	local slot = spacedrop1:AddItem("c_deployer", 1)
	slot.extra_data = {
		onetime = true,
		bp = {
			regs = { [5] = { id = 'metalbar', num = REG_INFINITE }, },
			frame = "f_building1x1d",
			components = { { "c_fabricator", 1 } },
			links = { { 3, 5 } },
			name = "Metal Bar Production"
		}
	}
	spacedrop1:AddItem("c_fabricator", 1)
	spacedrop1:AddItem("circuit_board", 10)
	spacedrop1:AddItem("metalbar", 20)
	Map.Delay("EjectDropPod", 3, { location = {loc.x-5, loc.y+5}, entity = spacedrop1, effect = "fx_EMP", notification = true })
end

data.objectives = data.objectives or {}

local intro_text = L[[
ACTIVATION PROTOCOL CONFIRMED

ERROR... MAIN SYSTEMS CHECK
ERROR... DATA INTEGRITY
ERROR... FORCE RECOVERY

*** DATA CORRUPTION - ACTIVATING HIGGS PROTOCOL ***

RESTARTING SIMULATIONβ..7g.h3Η.ΣHf.7Δf.7
Δ...f...3*n..x7..... PARTIAL RECOVERY CONFIRMED

SIMULATION INTEGRITY ........ DΞSYNCΣD

PRESS ANY KEY TO BEGIN SIMULATION]]

function UIMsg.FreeplayRobotIntro()
	if Action.IsReplayPlayback() then return end
	-- show intro UI with intro text
	UI.AddLayout([[
		<Box bg="Main/skin/Assets/Terminal Background.png?tile=true" padding=120>
			<Text id=error_text style=console/>
		</Box>
		]], {
		construct = function(widget)
			Game.OfflinePause(true)
			widget.speed=40
			Input.SetInputProcessor(function(key_name, is_down, axis)
				if is_down or axis then return end
				if widget.every_frame_update then -- speed it up
					widget.speed = 540
				else
					-- close
					widget:closeintro()
					Input.ClearInputProcessor()
				end
				return false
			end)
		end,

		closeintro = function(w)
			UI.PlaySound("fx_ui_INIT_GAME")
			UI.PlaySound("fx_environment_SYSTEM_GLITCH")

			Game.OfflinePause(false)

			w:TweenFromTo("y", 0, -2000, 100, 'InQuad', function() w:RemoveFromParent() end)

			local loc = Game.GetLocalPlayerFaction().home_location
			View.PlayEffect("fx_EMP", loc.x, loc.y)


			-- static effect on startup
			UI.AddLayout("Spacer", { every_frame_update = function(w, dt)
				w.timer = (w.timer or 3.0) - dt
				if w.timer < 0.0 then
					View.SetPostProcess("ScreenStaticAmount", 0)
					w:RemoveFromParent()
				else
					View.SetPostProcess("ScreenStaticAmount", w.timer/6)
				end
			end})
		end,

		every_frame_update = function(w, dt)
			local lastt = w.t or 0.0
			local t = lastt + (dt*w.speed)
			w.t = t

			local lastnum = math.floor(lastt) + 1
			local num = math.floor(t) + 1
			if num > #intro_text then
				UI.PlaySound("fx_ui_INIT_TYPING_DONE")
				w.error_text.text = intro_text
				w.every_frame_update = nil
				return
			end

			local rndchrs = '[&4+~HA#z..'
			local rndnum = math.random(#rndchrs)
			local rndchr = (num < #intro_text) and rndchrs:sub(rndnum,rndnum) or ""
			local currstr = string.sub(intro_text, 1, num)

			w.error_text.text = L("%S%S", currstr, rndchr)

			if lastnum ~= num then
				if string.sub(intro_text, num-1, num-1) == "\n" then
					-- play nothing after enter (and don't repeat enter twice)
				elseif string.sub(intro_text, num, num) == "\n" then
					UI.PlaySound("fx_ui_INIT_TYPING_ENTER")
				elseif num % 5 == 1 then
					UI.PlaySound("fx_ui_INIT_TYPING_CHAR")
				end
			end
		end,
	},99999)
end

local RaceSelection_layout<const> =
[[
	<Modal dock=fill>
		<Canvas>
			<Image dock=fill image=tech_tree_pattern_bg/>
			<Image id=patternimg x=0 y=0 width=2560 height=1440 image=tech_tree_pattern/>
			<Box dock=center padding=60>
				<VerticalList child_padding=60 id=mainlist>
					<text textalign=center style=large_header text="Faction Selection"/>
					<HorizontalList child_padding=60 height=390>
						<Button race=robot on_click={on_click_select} on_double_click={on_click_start}>
							<VerticalList width=300 child_padding=8 margin=12 dock=fill>
								<Text textalign=center style=notify_warning text="Robot"/>
								<Image image="Main/textures/codex/production_top.png" width=300 height=200/>
								<Text fill=true wrap=true text="Robots are an advanced artificial intelligence with modular technology. The default game mode. Main scenario and story missions."/>
							</VerticalList>
						</Button>
						<Button race=human on_click={on_click_select} on_double_click={on_click_start}>
							<VerticalList width=300 child_padding=8 margin=12 dock=fill>
								<Text textalign=center style=notify_warning text="Human"/>
								<Image image="Main/textures/tech/human/human_industry_3.png" width=300 height=200/>
								<Text fill=true wrap=true text="Humans are landing on the planet and try to discover the nature of the blight. No Campaign scenario or story missions."/>
							</VerticalList>
						</Button>
						<Button race=alien on_click={on_click_select} on_double_click={on_click_start}>
							<VerticalList width=300 child_padding=8 margin=12 dock=fill>
								<Text textalign=center style=notify_warning text="Alien"/>
								<Image image="Main/textures/tech/alien/energetics/energetics_comm_3.png" width=300 height=200/>
								<Text fill=true wrap=true text="Aliens are an advanced race that live within the blight and have unique technology and gameplay. Knowledge of advanced gameplay mechanics is required. No Campaign scenario or story missions."/>
							</VerticalList>
						</Button>
					</HorizontalList>
					<Button id=startbtn icon=icon_confirm text="Start" disabled=true on_click={on_click_start}/>
					<HorizontalList>
						<Button id=factionbtn text="Switch Faction" on_click={on_switch_faction} fill=1 margin_right=60/>
						<Button id=invitebtn text="Invite Friend"  on_click={on_invite} fill=1/>
						<Spacer fill=3/>
						<Button id=endbtn text="End Game" on_click={on_ui_cancel} fill=1/>
					</HorizontalList>
				</VerticalList>
			</Box>
			<Box id=glow hidden=true dock=top-left bg=tutorial_highlight/>
		</Canvas>
	</Modal>
]]

local RaceSelection = {}
UI.Register("RaceSelection", RaceSelection_layout, RaceSelection)

function RaceSelection:construct()
	self.factionbtn.hidden = not Map.GetSettings().allow_faction_switch
	self.invitebtn.hidden = (Game.GetNetMode() == "offline") or not Game.CanInviteFriend()
end

function RaceSelection:every_frame_update(dt)
	self.patternimg.x = (self.patternimg.x - dt*35.0)
	if self.patternimg.x < -314.0 then self.patternimg.x = self.patternimg.x + 314.0 end

	self.patternimg.y = (self.patternimg.y - dt*15.0)
	if self.patternimg.y < -314.0 then self.patternimg.y = self.patternimg.y + 314.0 end
end

function RaceSelection:on_click_select(btn)
	self.selected_race = btn.race
	self.startbtn.disabled = false

	local glow = self.glow
	glow.hidden = false
	glow:SetIgnoreHitTest()
	glow.x, glow.y, glow.width, glow.height = btn:GetViewportPosition()
end

function RaceSelection:on_click_start()
	Action.SendForLocalFaction("FreeplaySelectRace", { race = self.selected_race })
	self.mainlist.disabled = true
end

function RaceSelection:on_invite()
	Game.ShowFriendInviteUI()
end

function RaceSelection:on_switch_faction(btn)
	UI.MenuPopup("<Box bg=popup_box_bg padding=10 blur=true><ScrollList width=200 id=list child_padding=3></ScrollList></Box>", {
		construct = function(menu)
			local playerfaction = Game.GetLocalPlayerFaction()
			for _,f in ipairs(Map.GetFactions()) do
				if f.is_player_controlled then
					menu.list:Add("<Button on_click={on_select}/>", { text = NOLOC(f.name), faction_id = f.id, disabled = (f == playerfaction or f.extra_data.locked) })
				end
			end
			btn.active = true
		end,
		destruct = function() if btn:IsValid() then btn.active = false end end,
		on_select = function(menu, faction_btn)
			-- check faction lock
			if Game.GetLocalPlayerFaction().extra_data.locked then
				local player_faction_id = Game.GetLocalPlayerFaction().id
				for _, player in ipairs(Game.GetAllPlayers()) do
					if player.faction_id == player_faction_id and not player.is_local then
						goto has_another_player
					end
				end
				-- last player is switching factions, set it to open
				Action.SendForLocalFaction("SetFactionLock", { lock = false })
				::has_another_player::
			end

			View.SelectEntities({})
			Action.SendFromPlayer("SwitchFaction", { faction_id = faction_btn.faction_id })
			UI.CloseMenuPopup()
		end,
	}, btn, 'UP')
end

function RaceSelection:on_ui_cancel() -- this also prevents in-game menu from opening
	ConfirmBox("Are you sure you want to abort the scenario and return to the main menu?", function()
		Game.EndGame()
	end)
end

function FactionAction.FreeplaySelectRace(faction, arg)
	if not faction.extra_data.race then -- avoid race condition ;)
		faction.extra_data.race = arg.race
		package:on_player_faction_spawn(faction)
		if Map.GetTick() == 0 and Map.GetGameSpeed() == 0 then
			Map.SetGameSpeed(1) -- was paused in package:on_world_spawn
		end
	end

	faction:RunUI("FreeplayRaceSelection")
end

local function RefreshRaceSelection()
	if Map.GetSettings().allow_race_selection and not Game.GetLocalPlayerFaction().extra_data.race then
		if not RaceSelection.open then
			local w = UI.AddLayout("RaceSelection", 1)
			w.hidden = Action.IsReplayPlayback()
			w.class.open = w
			if not w.hidden then Game.GetProfile().played_race_selection = true end
		end
	elseif RaceSelection.open then
		RaceSelection.open:TweenFromTo('opacity', 1, 0, 300, 100, function(w) w:RemoveFromParent() end)
		RaceSelection.open.class.open = nil
		View.ResetCamera(true)
	end
end

UIMsg.OnSetup = RefreshRaceSelection
UIMsg.OnLocalFactionChanged = RefreshRaceSelection
UIMsg.FreeplayRaceSelection = RefreshRaceSelection
