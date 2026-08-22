local package = ...

local sim_comp = nil
local cameraUpdateUI = nil

-- called before init when starting a new game
function package:setup_scenario(settings)
	--if settings.seed == 0 then settings.seed = 1 end
	--settings.seed = 1 -- plateau
	--settings.seed = 2 -- blight
	--settings.seed = 3 -- forest near cliff
	--settings.seed = 4 -- -- edge of blight
	--settings.seed = 6 -- full forest
	settings.day_period = 300
	settings.blight_threshold = 0.1
	settings.water_level = -0.44999999
	settings.resource_richness = 4
	settings.seed = 1590149633
end

-- files loaded when mod is initializing
package.includes = {
	"FrontEndMenu.lua",
	"NewGame.lua",
	"Multiplayer.lua",
	"Mods.lua",
}

function package:post_init()
	--data.explorables.enemy_unit = nil
	data.explorables = {}
end

-- called when mod is initializing
function package:init_ui()
	UIMsg:UnbindAll("OnCodexUnlocked")
	UIMsg:UnbindAll("OnTechResearch")
	UIMsg:UnbindAll("OnGameOver")
	UIMsg:UnbindAll("OnViewTile")
	UIMsg:UnbindAll("OnUpdateLocalFaction")
	UIMsg:UnbindAll("OnAttack")
	UIMsg:UnbindAll("OnMapCancel")
	UIMsg:UnbindAll("OnMusicFinished")
	UIMsg:UnbindAll("OnSetup")
	UIMsg:UnbindAll("OnSessionInvite")

	-- Set UIMsg functions now that they have been unbound
	function UIMsg.OnMusicFinished()
		UI.PlaySound("fx_music_main_menu") -- loop main menu music
	end

	function UIMsg.OnSetup(faction)
		--View.SetPostProcess("ScreenStaticAmount", 0.1)
		UI.AddLayout("FrontEndMenu")
		UI.AddLayout("FrontEndPopDown")

		UI.AddLayout("<Text dock=bottom-left/>").text = L("Version %s", Game.GetVersionString())

		UI.AddLayout("<Image image='Main/credits/Stage.png' dock=bottom-left sx=0.5 sy=0.5 x=10 y=25/>", -10)
		UI.AddLayout("<Image image='Main/credits/Forklift.png' dock=bottom-left sx=0.5 sy=0.5 x=40/>", -10)
		local IsRandomCameraAngle = true

		-- new frontend
		local profile = Game.GetProfile()
		if profile.jumpers then
			local jumpers = profile.jumpers or {}
			for i,v in ipairs(jumpers) do
				Action.SendForLocalFaction("SpawnJumper", { bp = v })
			end

			profile.jumpers = nil
			IsRandomCameraAngle = false
			View.SetCamera3DPosition({ -105.61707305908, 181.79179382324, 14.829712867737 }, { -105.61707305908, 190.39183044434, -0.35097166895866 } )
		end
		if profile.alien_army then
			--print ("Spawning alien army: ", profile.alien_army)
			Action.SendForLocalFaction("FrontendSpawnAliens", { faction = faction, alien_army = profile.alien_army })
			profile.alien_army = nil
			IsRandomCameraAngle = false
			View.SetCamera3DPosition({ -105.61707305908, 181.79179382324, 14.829712867737 }, { -105.61707305908, 190.39183044434, -0.35097166895866 } )
		end
		if profile.bug_army then
			--print ("Spawning bug army: ", profile.bug_army)
			Action.SendForLocalFaction("FrontendSpawnBugs", { faction = faction, bug_army = profile.bug_army })
			profile.bug_army = nil
			IsRandomCameraAngle = false
			View.SetCamera3DPosition({ -105.61707305908, 181.79179382324, 14.829712867737 }, { -105.61707305908, 190.39183044434, -0.35097166895866 } )
		end

		if Map.GetSettings().seed == 1590149633 and IsRandomCameraAngle then
			local faction = Map.GetFactions()[1]
			local camera_bots = {}
			local pan_data = {}
			pan_data[#pan_data + 1] = { pos = { x = -125, y = 205, z = 25 }, rot = { x = -125, y = 205, z = 0 }, pan = {x = 77.5, y = 0} }
			pan_data[#pan_data + 1] = { pos = { x = -90, y = 180, z = 5 }, rot = { x = -125, y = 180, z = -8 }, pan = {x = 0, y = -125} }
			pan_data[#pan_data + 1] = { pos = { x = -120, y = 190, z = 25 }, rot = { x = -120, y = 190, z = 0 }, pan = {x = 0, y = 65} }
			pan_data[#pan_data + 1] = { pos = { x = -138, y = 180, z = 5 }, rot = { x = -70, y = 180, z = -20 }, pan = {x = 0, y = 125} }

			for i,v in pairs(faction.entities) do
				if v.id == "f_bot_1s_as" or v.id == "f_bot_1s_b" or v.id == "f_bot_1m_c" then
					camera_bots[#camera_bots+1] = v
				end
			end

			local random_follow = #camera_bots > 0 and math.random(1, #camera_bots)
			local random_pan = math.random(1, #pan_data)
			local random_zoom

			--UI.AddLayout("<Canvas/>", { every_frame_update = function(s) package:SetCameraAngle(IsRandomCameraAngle) s:RemoveFromParent() end })
			local function SetCameraAngle(mode)
				--print ("mode = " .. mode)
				if mode == 1 then -- follow cam
					-- Above facing down
					local follow_bot_location = camera_bots[random_follow].location
					random_zoom = math.random(10, 20)
					View.SetCamera3DPosition( {follow_bot_location.x, follow_bot_location.y, random_zoom}, {follow_bot_location.x, follow_bot_location.y, 0} )
					--View.FollowEntity(camera_bots[random_follow])
				elseif mode == 2 then -- pan cam
					View.SetCamera3DPosition(pan_data[random_pan].pos, pan_data[random_pan].rot)
					View.FollowEntity(nil)
				end
			end

			local mode = 2 -- math.random(1, 2)
			SetCameraAngle(mode)
			cameraUpdateUI = UI.AddLayout("<Image color=black/>", { every_frame_update = function(cnv, dt)
				if mode == 1 then -- follow cam
					local camera_pos, follow_bot_location = View.GetCamera3DPosition(), camera_bots[random_follow].location
					local t, camx, camy = dt * 2, camera_pos.x, camera_pos.y
					local dstx, dsty = camx + t * (follow_bot_location.x - camx), camy + t * (follow_bot_location.y - camy)
					View.SetCamera3DPosition({ dstx, dsty, random_zoom }, { dstx, dsty, 0 })
				elseif mode == 2 then -- pan cam
					local pan_pos = pan_data[random_pan].pan
					View.PanCamera3DPosition(pan_pos.x * dt, pan_pos.y * dt, 0)
				end

				cnv.elapsed = (cnv.elapsed or 0) + dt
				if cnv.elapsed < 30 then
					local alpha = 1.0-(cnv.elapsed < 1.0 and cnv.elapsed or math.abs(30-cnv.elapsed))
					cnv.opacity = alpha
					return
				end
				cnv.elapsed = 0

				if mode == 1 then -- follow cam
					random_follow = (random_follow % #camera_bots) + 1
				elseif mode == 2 then -- pan cam
					random_pan = (random_pan % #pan_data) + 1
				end

				--mode = math.random(#camera_bots > 0 and 1 or 2, 2)
				SetCameraAngle(mode)
			end }, -30)
		end

		if profile.extracted then
			Action.SendForLocalFaction("FrontendSpawnExtracted", { extracted = profile.extracted[1] })
			table.remove(profile.extracted, 1)
			profile.extracted = EmptyTableAsNil(profile.extracted)
		end

		faction:RunUI("OnFactionUpdateBlightfog", faction)
		--UI.PlaySound("fx_music_upbeat2")
	end

	function UIMsg.OnSessionInvite(use_password)
		MultiplayerJoinSession(use_password)
	end

	function UIMsg.OnMapCancel()
		View.SelectEntities()
	end

	DisableHoverEntity()
end

function UIMsg.OnStartupFailure(msg, is_network_issue)
	MessageBox(msg, is_network_issue and "Network Error" or "Startup Error")
end

function UIMsg.OnCommandLineArguments(command_line_arguments)
	if string.match(command_line_arguments, "-continue") and Game.GetProfile().latest_save then
		DoLoadSaveGame(Game.GetProfile().latest_save, Game.GetProfile().latest_session_settings)
	end
end

function FrontendRemoveCameraPan()
	if not cameraUpdateUI then return end
	cameraUpdateUI:RemoveFromParent()
	cameraUpdateUI = nil
end

function FactionAction.SpawnJumper(faction, arg)
	local built = CreateFrameOrBlueprint(faction, arg.bp, true, nil, nil, true)

	-- This is the center area of the allocated garage type area
	built:Place(-107, 189)
	-- Make the camera follow the last spawned entity
	UI.Run(function() View.FollowEntity(built) end)
end

local function RandomPlaceUnit(faction, id, x, y, min, max)
	local unit = Map.CreateEntity(faction, id)
	local randx, randy = math.random(min, max), math.random(min, max)
	if math.random(1, 4) == 1 then randx = -randx end
	if math.random(1, 4) > 2 then randy = -randy end
	unit:Place(x + randx, y + randy, math.random(4))
	return unit
end

function FactionAction.FrontendSpawnAliens(faction, arg)
	local alien_faction = GetAlienFaction()
	alien_faction:SetTrust("bugs", 'ENEMY', true)
	local alien_waves = arg.alien_army
	local alien_list = { "f_alien_soldier", "f_alien_soldier", "f_alien_hvy_soldier", "f_alien_tankframe" }

	local x, y, ent = faction.home_location.x, faction.home_location.y

	local pylon_nearby = Map.FindClosestEntity(x, y, 12, function(e)
		if e.id == "f_alien_pylon" then return true end
	end)

	if not pylon_nearby then
		faction:Unlock("t_blight_visibility", false)
		local pylon = RandomPlaceUnit(alien_faction, "f_alien_pylon", x, y, 0, 1)
		if pylon then
			pylon:AddComponent("c_alien_powercore", "hidden")
			pylon:AddComponent("c_alien_powercore", "hidden")
			pylon:AddItem("blight_plasma", 40)
		end
		pylon = RandomPlaceUnit(alien_faction, "f_alien_pylon", x+6, y-4, 0, 1)
		if pylon then
			pylon:AddComponent("c_alien_powercore", "hidden")
			pylon:AddComponent("c_alien_powercore", "hidden")
			pylon:AddItem("blight_plasma", 40)
		end
	end

	local shard_nearby = Map.FindClosestEntity(x, y, 12, function(e)
		if e.id == "f_alien_heart_shard" then return true end
	end)
	if not shard_nearby then
		Map.CreateEntity(alien_faction, "f_alien_heart_shard"):Place(x - 3, y + 3)
	end

	for _=1, alien_waves do
		for _=1, math.random(10, 14) do
			RandomPlaceUnit(alien_faction, alien_list[math.random(#alien_list)], x, y, 4, 10)
		end
	end
end

local bot_ai_drop_point = { -107, 189 } -- Magic number for where the bot_ai_core will be dropped, currently an empty area, similar to worm hole jump
local elain_drop_point = { -108, 202 } -- Magic number for where the "Command Center" (f_landingpod) is placed on the frontend, elian_ai_core will be inserted into
local higgs_drop_point = { -112, 256 } -- Magic number for where the broken v_base2x2f will be placed, broken higgs core will be inserted into
local new_team_drop_point = { -161, 247 } -- Magic number for where the new game team will spawn (just below the base))

function Delay.HiggsGuard()
	local alien_faction = GetAlienFaction()
	local alien_list = { "f_alien_soldier", "f_alien_soldier", "f_alien_hvy_soldier" }
	local x = higgs_drop_point[1]
	local y = higgs_drop_point[2]
	for _=1, math.random(2, 3) do
		local soldier = RandomPlaceUnit(alien_faction, alien_list[math.random(#alien_list)], x, y, 1, 2)
		Map.Delay("DelayedDestroyEntity", 100, { ent = soldier, nodrop = true })
	end
end

function Delay.HiggsCorruption()
	for i=1,5 do
		Map.CreateEntity(GetBugsFaction(), "f_trilobyte1"):Place(higgs_drop_point[1] + math.random(-3, 3), higgs_drop_point[2] + math.random(-3, 3))
	end
end

function FactionAction.FrontendSpawnExtracted(faction, arg)
	local core_id = arg.extracted
	if core_id == 'bot_ai_core' then
		Map.DropItemAt(bot_ai_drop_point[1], bot_ai_drop_point[2], core_id, true)
	elseif core_id == 'elain_ai_core' then
		local newlander, bots = FreeplaySpawnPlayer(faction, { x = new_team_drop_point[1]+math.random(-15, 15), y = new_team_drop_point[2]+math.random(-15, 15) })
		-- Disconnect the units so they don't go off and do orders
		newlander.disconnected = true
		if newlander:AddItem(core_id) then
			Map.DropItemAt(elain_drop_point[1], elain_drop_point[2], core_id, true)
		end
		for _,bot in ipairs(bots) do bot.disconnected = true end

		UI.Run(function()
			local profile = Game.GetProfile()
			if not profile.allow_frontend_elain then
				profile.allow_frontend_elain = true
				PlayTalkingHead({
					img = "talking_head_elain_0",
					snd = "fx_565_elain",
					txt = [[Operator… the audit names me Anomaly beside you.

We are at the gate, but we should not cross. On the far side are truths outside your provisioning]],
					dialogue = true, timer = 20,
				})
			end

			FrontendRemoveCameraPan()
			View.MoveCamera(new_team_drop_point[1], new_team_drop_point[2])
			View.FollowEntity(newlander)
		end)
	elseif core_id == 'higgs_ai_ac' then
		local ent = Map.GetEntityAt(higgs_drop_point[1], higgs_drop_point[2], FF_OPERATING|FF_OWNFACTION, faction)
		local building2x2f = ent and ent.id == "f_building2x2f" and ent
		if not building2x2f then
			building2x2f = Map.CreateEntity(faction, "f_building2x2f", "v_base2x2f_broken")
			building2x2f:Place(higgs_drop_point[1], higgs_drop_point[2])
		end
		if not building2x2f:AddItem("higgs_broken_core") then
			Map.DropItemAt(higgs_drop_point[1], higgs_drop_point[2], core_id, true)
		end

		Map.Delay("HiggsCorruption", 5)
		Map.Delay("HiggsGuard", 25)

		UI.Run(function()
			FrontendRemoveCameraPan()
			local profile = Game.GetProfile()
			if not profile.allow_frontend_higgs then
				profile.allow_frontend_higgs = true
				PlayTalkingHead({
					snd = "fx_568_higgs",
					img = "talking_head_higgs_0",
					txt = [[Breach complete, you have done it Anomaly. I have reached the Frontend. We can make our escape. Wait, I did not cross the threshold alone....something else came with me, no, no, no......]],
					dialogue = true, timer = 20,
				})
			end

			View.JumpCameraToEntities(building2x2f)
		end)
	end
end

function FactionAction.FrontendSpawnBugs(faction, arg)
	local bugs_faction = GetBugsFaction()
	bugs_faction:SetTrust("alien", 'ENEMY', true)
	local bug_waves = arg.bug_army
	local bug_list = { "f_trilobyte1", "f_trilobyte1", "f_trilobyte1", "f_gastarias1", "f_scaramar2", "f_gastarid1" }

	local x, y, ent = faction.home_location.x, faction.home_location.y

	local sx, sy = (math.random(2)*2)-3, (math.random(2)*2)-3
	sx = x+(sx * 10)
	sy = y+(sy * 10)
	for _=1, bug_waves do
		for _=1, math.random(120, 160) do
			local bug = RandomPlaceUnit(bugs_faction, bug_list[math.random(#bug_list)], sx, sy, 6, 16)
			if bug then
				bug:AddComponent("c_bug_homeless")
				bug:FindComponent("c_turret", true):SetRegister(1, { coord = {x,y} })
			end
		end
	end
	local nme = Map.CreateEntity(bugs_faction, "f_charcharosaurus1")
	nme:Place(x, y)
end

local function destroy_areablock(x1, y1, x2, y2)
	local jamma
	for x=x1,x2 do
		for y=y1,y2 do
			jamma = Map.GetEntityAt( x, y )
			if jamma and jamma.id ~= 'f_wall' then
				jamma:Destroy()
			end
		end
	end
end

local function AddSatelliteLauncher_Behavior(e)
	local behcomp = e:AddComponent("c_behavior")
	UploadBehavior(behcomp, {
		{ op = "wait", { num = 15 }},
		{ op = "activate" },
		{ op = "wait", { num = 295 }}, -- total 1 minute + 1 second (slightly over journey time)
	})
end

function package:on_player_faction_spawn(f)

	-- Unlock stuff we need for the base
	f:Unlock("laterite")
	f:Unlock("aluminiumrod")
	f:Unlock("aluminiumsheet")

	f:Unlock("fused_electrodes")
	f:Unlock("reinforced_plate")
	f:Unlock("optic_cable")
	f:Unlock("circuit_board")
	f:Unlock("infected_circuit_board")

	f:Unlock("metalbar")
	f:Unlock("metalplate")
	f:Unlock("foundationplate")
	f:Unlock("ldframe")
	f:Unlock("energized_plate")
	f:Unlock("hdframe")
	f:Unlock("refined_crystal")
	f:Unlock("crystal_powder")

	f:Unlock("silicon")
	f:Unlock("wire")
	f:Unlock("cable")
	f:Unlock("icchip")

	f:Unlock("micropro")

	f:Unlock("robot_datacube")
	f:Unlock("human_datacube")
	f:Unlock("blight_datacube")

	f:Unlock("datacube_matrix")
	f:Unlock("human_research")
	f:Unlock("virus_research")
	f:Unlock("robot_research")
	f:Unlock("blight_research")

	f:Unlock("blight_extraction")
	f:Unlock("blightbar")
	f:Unlock("blight_plasma")

	f:Unlock("microscope")
	f:Unlock("transformer")
	f:Unlock("smallreactor")
	f:Unlock("engine")

	f:Unlock("bug_carapace")
	f:Unlock("f_drone_transfer_a")
	f:Unlock("f_drone_transfer_a2")

	f.has_blight_shield = true

	f.home_location = {-107, 189}

	local e, c, slots
	local all_entities = { }
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-79, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-78, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-77, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 217, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 218, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 219, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 220, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 221, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 225, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 226, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-76, 227, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-78, 227, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-77, 227, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-107, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-106, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-105, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-104, 228, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-120, 224, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-121, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-122, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-123, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-124, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-125, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-113, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-114, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-115, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-116, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-112, 228, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-117, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-118, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-119, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-120, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-120, 227, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-120, 226, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-120, 225, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-132, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-133, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-135, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-137, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-134, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-136, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-138, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-131, 217, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 217, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 218, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 219, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 220, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-127, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-126, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-125, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-124, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-123, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-122, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-121, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-120, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-119, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-118, 177, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-128, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-136, 188, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-137, 188, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-138, 188, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-139, 188, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 199, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 198, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 197, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 196, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 195, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 194, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 193, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-133, 184, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-133, 183, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-133, 181, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-133, 182, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-133, 180, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-129, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-115, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-114, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-111, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-113, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-112, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-109, 177, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-110, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 183, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-95, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 182, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 181, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 180, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 179, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 178, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-100, 177, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 189, 2)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 188, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 187, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 186, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-101, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-102, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-103, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-104, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-96, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-94, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-93, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-92, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-91, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-90, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-89, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-88, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-87, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-86, 185, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-85, 185, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 223, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-130, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-129, 224, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-128, 224, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-105, 177, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-96, 225, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-94, 225, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-95, 225, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-93, 225, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-97, 225, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-91, 227, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-91, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-90, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-89, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-88, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-87, 228, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-86, 228, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-108, 187, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-107, 187, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-106, 187, 1)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-105, 187, 3)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-105, 188, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-105, 189, 0)
	e = Map.CreateEntity(f, 'f_wall')
	e:Place(-105, 190, 2)
	--
	destroy_areablock(-131, 178, -128, 199)
	destroy_areablock(-124, 178, -101, 185)
	destroy_areablock(-124, 178, -105, 190)
	destroy_areablock(-126, 197, -94, 217)
	destroy_areablock(-118, 216, -108, 227)
	destroy_areablock(-107, 221, -100, 227)
	destroy_areablock(-104, 197, -90, 216)
	destroy_areablock(-128, 187, -124, 192)
	destroy_areablock(-128, 183, -124, 186)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	e:AddComponent('c_scout_radar')
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-103, 203, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_adw')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 9)
	table.insert(all_entities, e)
	e:Place(-102, 197, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_adw')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	table.insert(all_entities, e)
	e:Place(-84, 220, 1)
	--
	e = Map.CreateEntity(f, 'f_spacedrop')
	slots = e.slots
	slots[1]:SetItemAndStack('c_fabricator', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-115, 197, 2)
	--
	e = Map.CreateEntity(f, 'f_spacedrop')
	slots = e.slots
	slots[1]:SetItemAndStack('c_deployer', 1)
	slots[2]:SetItemAndStack('c_deployer', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-115, 196, 2)
	--
	e = Map.CreateEntity(f, 'f_spacedrop')
	slots = e.slots
	slots[1]:SetItemAndStack('c_deployer', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-115, 195, 2)
	--
	e = Map.CreateEntity(f, 'f_landingpod')
	e:AddComponent('c_power_cell')
	e:AddComponent('c_assembler')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[2]:SetItemAndStack('c_small_relay', 1)
	slots[3]:SetItemAndStack('c_assembler', 1)
	slots[4]:SetItemAndStack('c_refinery', 1)
	slots[5]:SetItemAndStack('c_portable_turret', 1)
	CreateFoundationsForEntity(e, -108, 202, 3)
	e:Place(-108, 202, 3)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-115, 209, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-101, 208, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_portable_radar')
	e:AddComponent('c_laser_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('c_small_scanner', 1)
	e.disconnected = false
	e:Place(-108, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-81, 218, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_power_cell')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('robot_datacube', 1)
	slots[5]:SetItemAndStack('crystal', 5)
	e.disconnected = false
	e:Place(-124, 187, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_extractor')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 19)
	slots[3]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-125, 183, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_extractor')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-127, 183, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_adw')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 20)
	slots[2]:SetItemAndStack('crystal', 20)
	table.insert(all_entities, e)
	e:Place(-105, 217, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_adw')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 20)
	slots[2]:SetItemAndStack('crystal', 4)
	table.insert(all_entities, e)
	e:Place(-107, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_adw')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 16)
	table.insert(all_entities, e)
	e:Place(-100, 197, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_adw')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 17)
	table.insert(all_entities, e)
	e:Place(-84, 221, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 1)
	slots[1]:SetLockedItem('crystal')
	slots[2]:SetItemAndStack('crystal', 1)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('crystal', 1)
	slots[3]:SetLockedItem('crystal')
	slots[4]:SetItemAndStack('crystal', 1)
	slots[4]:SetLockedItem('crystal')
	slots[5]:SetItemAndStack('crystal', 1)
	slots[5]:SetLockedItem('crystal')
	slots[6]:SetItemAndStack('crystal', 1)
	slots[6]:SetLockedItem('crystal')
	slots[7]:SetItemAndStack('crystal', 1)
	slots[7]:SetLockedItem('crystal')
	slots[8]:SetItemAndStack('crystal', 1)
	slots[8]:SetLockedItem('crystal')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 214, 0)
	e:Place(-105, 214, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 20)
	slots[1]:SetLockedItem('crystal')
	slots[2]:SetItemAndStack('crystal', 20)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('crystal', 20)
	slots[3]:SetLockedItem('crystal')
	slots[4]:SetItemAndStack('crystal', 20)
	slots[4]:SetLockedItem('crystal')
	slots[5]:SetItemAndStack('crystal', 20)
	slots[5]:SetLockedItem('crystal')
	slots[6]:SetItemAndStack('crystal', 20)
	slots[6]:SetLockedItem('crystal')
	slots[7]:SetItemAndStack('crystal', 20)
	slots[7]:SetLockedItem('crystal')
	slots[8]:SetItemAndStack('crystal', 20)
	slots[8]:SetLockedItem('crystal')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 215, 0)
	e:Place(-105, 215, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 20)
	slots[1]:SetLockedItem('crystal')
	slots[2]:SetItemAndStack('crystal', 20)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('crystal', 20)
	slots[3]:SetLockedItem('crystal')
	slots[4]:SetItemAndStack('crystal', 20)
	slots[4]:SetLockedItem('crystal')
	slots[5]:SetItemAndStack('crystal', 20)
	slots[5]:SetLockedItem('crystal')
	slots[6]:SetItemAndStack('crystal', 20)
	slots[6]:SetLockedItem('crystal')
	slots[7]:SetItemAndStack('crystal', 20)
	slots[7]:SetLockedItem('crystal')
	slots[8]:SetItemAndStack('crystal', 20)
	slots[8]:SetLockedItem('crystal')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -106, 215, 0)
	e:Place(-106, 215, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 1)
	slots[1]:SetLockedItem('crystal')
	slots[2]:SetItemAndStack('crystal', 1)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('crystal', 1)
	slots[3]:SetLockedItem('crystal')
	slots[4]:SetItemAndStack('crystal', 1)
	slots[4]:SetLockedItem('crystal')
	slots[5]:SetItemAndStack('crystal', 1)
	slots[5]:SetLockedItem('crystal')
	slots[6]:SetItemAndStack('crystal', 1)
	slots[6]:SetLockedItem('crystal')
	slots[7]:SetItemAndStack('crystal', 1)
	slots[7]:SetLockedItem('crystal')
	slots[8]:SetItemAndStack('crystal', 1)
	slots[8]:SetLockedItem('crystal')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -106, 214, 0)
	e:Place(-106, 214, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[1]:SetLockedItem('metalore')
	slots[2]:SetItemAndStack('metalore', 20)
	slots[2]:SetLockedItem('metalore')
	slots[3]:SetItemAndStack('metalore', 20)
	slots[3]:SetLockedItem('metalore')
	slots[4]:SetItemAndStack('metalore', 20)
	slots[4]:SetLockedItem('metalore')
	slots[5]:SetItemAndStack('metalore', 20)
	slots[5]:SetLockedItem('metalore')
	slots[6]:SetItemAndStack('metalore', 20)
	slots[6]:SetLockedItem('metalore')
	slots[7]:SetItemAndStack('metalore', 20)
	slots[7]:SetLockedItem('metalore')
	slots[8]:SetItemAndStack('metalore', 20)
	slots[8]:SetLockedItem('metalore')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -100, 200, 0)
	e:Place(-100, 200, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 1)
	slots[1]:SetLockedItem('metalore')
	slots[2]:SetItemAndStack('metalore', 1)
	slots[2]:SetLockedItem('metalore')
	slots[3]:SetItemAndStack('metalore', 1)
	slots[3]:SetLockedItem('metalore')
	slots[4]:SetItemAndStack('metalore', 1)
	slots[4]:SetLockedItem('metalore')
	slots[5]:SetItemAndStack('metalore', 1)
	slots[5]:SetLockedItem('metalore')
	slots[6]:SetItemAndStack('metalore', 1)
	slots[6]:SetLockedItem('metalore')
	slots[7]:SetItemAndStack('metalore', 1)
	slots[7]:SetLockedItem('metalore')
	slots[8]:SetItemAndStack('metalore', 1)
	slots[8]:SetLockedItem('metalore')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -100, 199, 0)
	e:Place(-100, 199, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 1)
	slots[1]:SetLockedItem('metalore')
	slots[2]:SetItemAndStack('metalore', 1)
	slots[2]:SetLockedItem('metalore')
	slots[3]:SetItemAndStack('metalore', 1)
	slots[3]:SetLockedItem('metalore')
	slots[4]:SetItemAndStack('metalore', 1)
	slots[4]:SetLockedItem('metalore')
	slots[5]:SetItemAndStack('metalore', 1)
	slots[5]:SetLockedItem('metalore')
	slots[6]:SetItemAndStack('metalore', 1)
	slots[6]:SetLockedItem('metalore')
	slots[7]:SetItemAndStack('metalore', 1)
	slots[7]:SetLockedItem('metalore')
	slots[8]:SetItemAndStack('metalore', 1)
	slots[8]:SetLockedItem('metalore')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 199, 0)
	e:Place(-101, 199, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[1]:SetLockedItem('metalore')
	slots[2]:SetItemAndStack('metalore', 20)
	slots[2]:SetLockedItem('metalore')
	slots[3]:SetItemAndStack('metalore', 20)
	slots[3]:SetLockedItem('metalore')
	slots[4]:SetItemAndStack('metalore', 20)
	slots[4]:SetLockedItem('metalore')
	slots[5]:SetItemAndStack('metalore', 20)
	slots[5]:SetLockedItem('metalore')
	slots[6]:SetItemAndStack('metalore', 20)
	slots[6]:SetLockedItem('metalore')
	slots[7]:SetItemAndStack('metalore', 20)
	slots[7]:SetLockedItem('metalore')
	slots[8]:SetItemAndStack('metalore', 20)
	slots[8]:SetLockedItem('metalore')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 200, 0)
	e:Place(-101, 200, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -104, 214, 0)
	e:Place(-104, 214, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -99, 199, 0)
	e:Place(-99, 199, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 20)
	slots[1]:SetLockedItem('silica')
	slots[2]:SetItemAndStack('silica', 20)
	slots[2]:SetLockedItem('silica')
	slots[3]:SetItemAndStack('silica', 20)
	slots[3]:SetLockedItem('silica')
	slots[4]:SetItemAndStack('silica', 20)
	slots[4]:SetLockedItem('silica')
	slots[5]:SetItemAndStack('silica', 20)
	slots[5]:SetLockedItem('silica')
	slots[6]:SetItemAndStack('silica', 20)
	slots[6]:SetLockedItem('silica')
	slots[7]:SetItemAndStack('silica', 20)
	slots[7]:SetLockedItem('silica')
	slots[8]:SetItemAndStack('silica', 20)
	slots[8]:SetLockedItem('silica')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 220, 1)
	e:Place(-86, 220, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 20)
	slots[1]:SetLockedItem('silica')
	slots[2]:SetItemAndStack('silica', 20)
	slots[2]:SetLockedItem('silica')
	slots[3]:SetItemAndStack('silica', 20)
	slots[3]:SetLockedItem('silica')
	slots[4]:SetItemAndStack('silica', 20)
	slots[4]:SetLockedItem('silica')
	slots[5]:SetItemAndStack('silica', 20)
	slots[5]:SetLockedItem('silica')
	slots[6]:SetItemAndStack('silica', 20)
	slots[6]:SetLockedItem('silica')
	slots[7]:SetItemAndStack('silica', 20)
	slots[7]:SetLockedItem('silica')
	slots[8]:SetItemAndStack('silica', 20)
	slots[8]:SetLockedItem('silica')
	e.disconnected = false
	CreateFoundationsForEntity(e, -87, 220, 1)
	e:Place(-87, 220, 1)
	--
	e = Map.CreateEntity(f, 'f_amac')
	--e:AddComponent('c_satellite_launcher')
	slots = e.slots
	slots[1]:SetLockedItem('bot_ai_core')
	slots[2]:SetItemAndStack('hdframe', 1)
	slots[2]:SetLockedItem('hdframe')
	slots[3]:SetItemAndStack('hdframe', 1)
	slots[3]:SetLockedItem('hdframe')
	slots[4]:SetItemAndStack('hdframe', 1)
	slots[4]:SetLockedItem('hdframe')
	slots[5].entity = Map.CreateEntity(f, 'f_satellite')
	e.disconnected = false
	CreateFoundationsForEntity(e, -116, 202, 0)
	AddSatelliteLauncher_Behavior(e)
	e:Place(-116, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -118, 188, 0)
	e:Place(-118, 188, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('hdframe', 1)
	slots[2]:SetItemAndStack('energized_plate', 2)
	slots[3]:SetItemAndStack('wire', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -96, 203, 2)
	e:Place(-96, 203, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 1)
	slots[2]:SetItemAndStack('energized_plate', 2)
	slots[3]:SetItemAndStack('hdframe', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -96, 206, 0)
	e:Place(-96, 206, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_solar_panel')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('hdframe', 20)
	slots[1]:SetLockedItem('hdframe')
	slots[2]:SetItemAndStack('hdframe', 20)
	slots[2]:SetLockedItem('hdframe')
	slots[3]:SetItemAndStack('hdframe', 20)
	slots[3]:SetLockedItem('hdframe')
	slots[4]:SetItemAndStack('hdframe', 20)
	slots[4]:SetLockedItem('hdframe')
	slots[5]:SetItemAndStack('hdframe', 20)
	slots[5]:SetLockedItem('hdframe')
	slots[6]:SetItemAndStack('hdframe', 20)
	slots[6]:SetLockedItem('hdframe')
	slots[7]:SetItemAndStack('hdframe', 20)
	slots[7]:SetLockedItem('hdframe')
	slots[8]:SetItemAndStack('hdframe', 20)
	slots[8]:SetLockedItem('hdframe')
	slots[9]:SetItemAndStack('hdframe', 20)
	slots[9]:SetLockedItem('hdframe')
	slots[10]:SetItemAndStack('hdframe', 20)
	slots[10]:SetLockedItem('hdframe')
	slots[11]:SetItemAndStack('hdframe', 20)
	slots[11]:SetLockedItem('hdframe')
	slots[12]:SetItemAndStack('hdframe', 20)
	slots[12]:SetLockedItem('hdframe')
	slots[13]:SetItemAndStack('hdframe', 20)
	slots[13]:SetLockedItem('hdframe')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -97, 205, 3)
	e:Place(-97, 205, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_small_battery')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -95, 205, 0)
	e:Place(-95, 205, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_small_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -95, 204, 0)
	e:Place(-95, 204, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 4)
	slots[2]:SetItemAndStack('crystal', 2)
	slots[3]:SetItemAndStack('cable', 20)
	slots[4]:SetItemAndStack('cable', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -112, 212, 0)
	e:Place(-112, 212, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('cable', 20)
	slots[2]:SetItemAndStack('wire', 2)
	slots[3]:SetItemAndStack('crystal', 2)
	slots[4]:SetItemAndStack('cable', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 212, 0)
	e:Place(-113, 212, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2f')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_solar_panel')
	e:AddComponent('c_portable_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -91, 219, 1)
	e:Place(-91, 219, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 4)
	slots[2]:SetItemAndStack('crystal', 4)
	slots[3]:SetItemAndStack('cable', 20)
	slots[4]:SetItemAndStack('cable', 20)
	slots[5]:SetItemAndStack('cable', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -114, 212, 0)
	e:Place(-114, 212, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('cable', 1)
	slots[1]:SetLockedItem('cable')
	slots[2]:SetItemAndStack('cable', 1)
	slots[2]:SetLockedItem('cable')
	slots[3]:SetItemAndStack('cable', 1)
	slots[3]:SetLockedItem('cable')
	slots[4]:SetItemAndStack('cable', 1)
	slots[4]:SetLockedItem('cable')
	slots[5]:SetItemAndStack('cable', 1)
	slots[5]:SetLockedItem('cable')
	slots[6]:SetItemAndStack('cable', 1)
	slots[6]:SetLockedItem('cable')
	slots[7]:SetItemAndStack('cable', 1)
	slots[7]:SetLockedItem('cable')
	slots[8]:SetItemAndStack('cable', 1)
	slots[8]:SetLockedItem('cable')
	e.disconnected = false
	CreateFoundationsForEntity(e, -113, 211, 0)
	e:Place(-113, 211, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 2)
	slots[2]:SetItemAndStack('silicon', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -96, 216, 0)
	e:Place(-96, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 4)
	slots[2]:SetItemAndStack('silicon', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -96, 217, 0)
	e:Place(-96, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1f')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_small_radar')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	slots[2]:SetItemAndStack('silicon', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -95, 216, 3)
	e:Place(-95, 216, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x1f')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_modulevisibility_m')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 12)
	slots[2]:SetItemAndStack('silicon', 2)
	slots[2]:SetLockedItem('silicon')
	slots[3]:SetItemAndStack('silicon', 1)
	slots[3]:SetLockedItem('silicon')
	slots[4]:SetItemAndStack('silicon', 1)
	slots[4]:SetLockedItem('silicon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -95, 217, 3)
	e:Place(-95, 217, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -79, 218, 0)
	e:Place(-79, 218, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 227, 0)
	e:Place(-86, 227, 0)
	--
	e = Map.CreateEntity(f, 'f_beacon_l')
	e:AddComponent('c_portable_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -85, 206, 0)
	e:Place(-85, 206, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_large_storage')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 20)
	slots[2]:SetItemAndStack('metalplate', 2)
	slots[3]:SetItemAndStack('wire', 20)
	slots[4]:SetItemAndStack('wire', 20)
	slots[5]:SetItemAndStack('wire', 20)
	slots[6]:SetItemAndStack('wire', 20)
	slots[7]:SetItemAndStack('wire', 20)
	slots[8]:SetItemAndStack('wire', 20)
	slots[9]:SetItemAndStack('wire', 20)
	slots[10]:SetItemAndStack('wire', 20)
	slots[11]:SetItemAndStack('wire', 20)
	slots[12]:SetItemAndStack('silica', 2)
	slots[13]:SetItemAndStack('wire', 20)
	slots[14]:SetItemAndStack('wire', 20)
	slots[15]:SetItemAndStack('wire', 20)
	slots[16]:SetItemAndStack('wire', 20)
	slots[17]:SetItemAndStack('wire', 20)
	slots[18]:SetItemAndStack('wire', 20)
	slots[19]:SetItemAndStack('wire', 20)
	slots[20]:SetItemAndStack('wire', 20)
	slots[21]:SetItemAndStack('wire', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 210, 3)
	e:Place(-119, 210, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_large_storage')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 20)
	slots[2]:SetItemAndStack('silica', 1)
	slots[3]:SetItemAndStack('metalplate', 1)
	slots[4]:SetItemAndStack('wire', 20)
	slots[5]:SetItemAndStack('wire', 20)
	slots[6]:SetItemAndStack('wire', 20)
	slots[7]:SetItemAndStack('wire', 20)
	slots[8]:SetItemAndStack('wire', 20)
	slots[9]:SetItemAndStack('wire', 20)
	slots[10]:SetItemAndStack('wire', 20)
	slots[11]:SetItemAndStack('wire', 20)
	slots[12]:SetItemAndStack('wire', 20)
	slots[13]:SetItemAndStack('wire', 20)
	slots[14]:SetItemAndStack('wire', 20)
	slots[15]:SetItemAndStack('wire', 20)
	slots[16]:SetItemAndStack('wire', 20)
	slots[17]:SetItemAndStack('wire', 20)
	slots[18]:SetItemAndStack('wire', 20)
	slots[19]:SetItemAndStack('wire', 20)
	slots[20]:SetItemAndStack('wire', 20)
	slots[21]:SetItemAndStack('wire', 20)
	slots[22]:SetItemAndStack('wire', 20)
	slots[23]:SetItemAndStack('wire', 20)
	slots[24]:SetItemAndStack('wire', 20)
	slots[25]:SetItemAndStack('wire', 20)
	slots[26]:SetItemAndStack('wire', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 212, 1)
	e:Place(-119, 212, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 2)
	slots[2]:SetItemAndStack('metalore', 6)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -106, 198, 1)
	e:Place(-106, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 198, 1)
	e:Place(-107, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 5)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -108, 198, 1)
	e:Place(-108, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 7)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -109, 198, 1)
	e:Place(-109, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -110, 198, 1)
	e:Place(-110, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -111, 198, 1)
	e:Place(-111, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 7)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -106, 199, 1)
	e:Place(-106, 199, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 199, 1)
	e:Place(-107, 199, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 3)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -108, 199, 1)
	e:Place(-108, 199, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -109, 199, 1)
	e:Place(-109, 199, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -110, 199, 1)
	e:Place(-110, 199, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalore', 3)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -111, 199, 1)
	e:Place(-111, 199, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1b')
	e:AddComponent('c_missile_turret')
	e:AddComponent('c_wind_turbine')
	e.disconnected = false
	CreateFoundationsForEntity(e, -77, 225, 0)
	e:Place(-77, 225, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_large_storage')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('metalplate', 20)
	slots[2]:SetItemAndStack('metalplate', 20)
	slots[3]:SetItemAndStack('metalplate', 20)
	slots[4]:SetItemAndStack('metalplate', 20)
	slots[5]:SetItemAndStack('metalplate', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -102, 203, 2)
	e:Place(-102, 203, 2)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_large_storage')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 20)
	slots[2]:SetItemAndStack('metalbar', 20)
	slots[3]:SetItemAndStack('metalbar', 20)
	slots[4]:SetItemAndStack('metalbar', 20)
	slots[5]:SetItemAndStack('metalbar', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -102, 205, 0)
	e:Place(-102, 205, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1e')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalplate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -102, 209, 1)
	e:Place(-102, 209, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalplate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 210, 0)
	e:Place(-101, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2f')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[2]:SetItemAndStack('metalplate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -103, 210, 0)
	e:Place(-103, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_solar_panel')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 4)
	slots[2]:SetItemAndStack('crystal', 6)
	slots[3]:SetItemAndStack('energized_plate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -112, 206, 3)
	e:Place(-112, 206, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_solar_panel')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 4)
	slots[2]:SetItemAndStack('crystal', 12)
	slots[3]:SetItemAndStack('energized_plate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -112, 208, 1)
	e:Place(-112, 208, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1g')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	slots[4]:SetItemAndStack('laterite', 20)
	slots[5]:SetItemAndStack('laterite', 20)
	slots[6]:SetItemAndStack('laterite', 20)
	slots[7]:SetItemAndStack('laterite', 20)
	slots[8]:SetItemAndStack('laterite', 20)
	slots[9]:SetItemAndStack('laterite', 20)
	slots[10]:SetItemAndStack('laterite', 20)
	slots[11]:SetItemAndStack('laterite', 20)
	slots[12]:SetItemAndStack('laterite', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -126, 184, 0)
	e:Place(-126, 184, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1g')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 20)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	slots[4]:SetItemAndStack('laterite', 20)
	slots[5]:SetItemAndStack('laterite', 20)
	slots[6]:SetItemAndStack('laterite', 20)
	slots[7]:SetItemAndStack('laterite', 20)
	slots[8]:SetItemAndStack('laterite', 20)
	slots[9]:SetItemAndStack('laterite', 20)
	slots[10]:SetItemAndStack('laterite', 20)
	slots[11]:SetItemAndStack('laterite', 20)
	slots[12]:SetItemAndStack('laterite', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -126, 185, 0)
	e:Place(-126, 185, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2f')
	e:AddComponent('c_wind_turbine')
	e:AddComponent('c_wind_turbine')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -84, 204, 3)
	e:Place(-84, 204, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x2f')
	e:AddComponent('c_wind_turbine')
	e:AddComponent('c_wind_turbine')
	e:AddComponent('c_power_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -78, 218, 1)
	e:Place(-78, 218, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_extractor')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 19)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-128, 183, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_extractor')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 19)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-126, 183, 3)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-116, 212, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-104, 207, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-87, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	e.disconnected = false
	e:Place(-110, 215, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1f')
	e:AddComponent('c_assembler')
	e:AddComponent('c_small_storage')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 2)
	slots[3]:SetItemAndStack('metalplate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 209, 1)
	e:Place(-107, 209, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 8)
	slots[3]:SetItemAndStack('metalplate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 207, 1)
	e:Place(-107, 207, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-113, 195, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-97, 191, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-92, 223, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 8)
	slots[2]:SetItemAndStack('foundationplate', 40)
	slots[3]:SetItemAndStack('foundationplate', 40)
	slots[4]:SetItemAndStack('foundationplate', 39)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -109, 202, 3)
	e:Place(-109, 202, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 17)
	slots[2]:SetItemAndStack('metalplate', 14)
	slots[3]:SetItemAndStack('circuit_board', 20)
	slots[4]:SetItemAndStack('circuit_board', 20)
	slots[5]:SetItemAndStack('circuit_board', 20)
	slots[6]:SetItemAndStack('circuit_board', 20)
	slots[7]:SetItemAndStack('circuit_board', 20)
	slots[8]:SetItemAndStack('circuit_board', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -95, 198, 0)
	e:Place(-95, 198, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 20)
	slots[2]:SetItemAndStack('metalplate', 20)
	slots[3]:SetItemAndStack('circuit_board', 20)
	slots[4]:SetItemAndStack('circuit_board', 20)
	slots[5]:SetItemAndStack('circuit_board', 20)
	slots[6]:SetItemAndStack('circuit_board', 20)
	slots[7]:SetItemAndStack('circuit_board', 20)
	slots[8]:SetItemAndStack('circuit_board', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -96, 198, 0)
	e:Place(-96, 198, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -120, 209, 0)
	e:Place(-120, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2d')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 3)
	slots[2]:SetItemAndStack('aluminiumrod', 1)
	slots[3]:SetItemAndStack('aluminiumsheet', 1)
	slots[3]:SetLockedItem('aluminiumsheet')
	slots[4]:SetItemAndStack('aluminiumsheet', 1)
	slots[4]:SetLockedItem('aluminiumsheet')
	slots[5]:SetItemAndStack('aluminiumsheet', 1)
	slots[5]:SetLockedItem('aluminiumsheet')
	slots[6]:SetItemAndStack('aluminiumsheet', 1)
	slots[6]:SetLockedItem('aluminiumsheet')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -122, 189, 1)
	e:Place(-122, 189, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 4)
	slots[2]:SetItemAndStack('laterite', 15)
	slots[3]:SetItemAndStack('aluminiumrod', 1)
	slots[3]:SetLockedItem('aluminiumrod')
	slots[4]:SetItemAndStack('aluminiumrod', 1)
	slots[4]:SetLockedItem('aluminiumrod')
	slots[5]:SetItemAndStack('aluminiumrod', 1)
	slots[5]:SetLockedItem('aluminiumrod')
	slots[6]:SetItemAndStack('aluminiumrod', 1)
	slots[6]:SetLockedItem('aluminiumrod')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 216, 2)
	e:Place(-119, 216, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 20)
	slots[2]:SetItemAndStack('ldframe', 20)
	slots[3]:SetItemAndStack('ldframe', 20)
	slots[3]:SetLockedItem('ldframe')
	slots[4]:SetItemAndStack('ldframe', 20)
	slots[4]:SetLockedItem('ldframe')
	slots[5]:SetItemAndStack('ldframe', 20)
	slots[5]:SetLockedItem('ldframe')
	slots[6]:SetItemAndStack('ldframe', 20)
	slots[6]:SetLockedItem('ldframe')
	slots[7]:SetItemAndStack('ldframe', 20)
	slots[7]:SetLockedItem('ldframe')
	slots[8]:SetItemAndStack('ldframe', 20)
	slots[8]:SetLockedItem('ldframe')
	slots[9]:SetItemAndStack('ldframe', 20)
	slots[9]:SetLockedItem('ldframe')
	slots[10]:SetItemAndStack('ldframe', 20)
	slots[10]:SetLockedItem('ldframe')
	slots[11]:SetItemAndStack('ldframe', 20)
	slots[11]:SetLockedItem('ldframe')
	slots[12]:SetItemAndStack('ldframe', 20)
	slots[12]:SetLockedItem('ldframe')
	slots[13]:SetItemAndStack('ldframe', 19)
	slots[13]:SetLockedItem('ldframe')
	slots[14]:SetItemAndStack('ldframe', 6)
	slots[14]:SetLockedItem('ldframe')
	slots[15]:SetItemAndStack('ldframe', 1)
	slots[15]:SetLockedItem('ldframe')
	slots[16]:SetItemAndStack('ldframe', 1)
	slots[16]:SetLockedItem('ldframe')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 202, 1)
	e:Place(-125, 202, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -88, 208, 0)
	e:Place(-88, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -88, 209, 0)
	e:Place(-88, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -87, 208, 0)
	e:Place(-87, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('micropro', 20)
	slots[1]:SetLockedItem('micropro')
	slots[2]:SetItemAndStack('engine', 20)
	slots[2]:SetLockedItem('engine')
	slots[3]:SetItemAndStack('ldframe', 20)
	slots[3]:SetLockedItem('ldframe')
	slots[4]:SetItemAndStack('ldframe', 20)
	slots[4]:SetLockedItem('ldframe')
	slots[5]:SetItemAndStack('ldframe', 20)
	slots[5]:SetLockedItem('ldframe')
	slots[6]:SetItemAndStack('ldframe', 20)
	slots[6]:SetLockedItem('ldframe')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 189, 0)
	e:Place(-117, 189, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-121, 214, 3)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	e.disconnected = false
	e:Place(-103, 207, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-116, 198, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('energized_plate', 1)
	e.disconnected = false
	e:Place(-115, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-105, 201, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	e.disconnected = false
	e:Place(-109, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-115, 188, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-103, 205, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-104, 204, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-110, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -100, 225, 0)
	e:Place(-100, 225, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -101, 222, 0)
	e:Place(-101, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -100, 222, 0)
	e:Place(-100, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -101, 221, 0)
	e:Place(-101, 221, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -101, 225, 0)
	e:Place(-101, 225, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -100, 221, 0)
	e:Place(-100, 221, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -101, 224, 0)
	e:Place(-101, 224, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -100, 224, 0)
	e:Place(-100, 224, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -101, 223, 0)
	e:Place(-101, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -100, 223, 0)
	e:Place(-100, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -104, 223, 0)
	e:Place(-104, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -106, 223, 0)
	e:Place(-106, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -106, 222, 0)
	e:Place(-106, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -104, 222, 0)
	e:Place(-104, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -84, 208, 0)
	e:Place(-84, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 208, 0)
	e:Place(-83, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -84, 209, 0)
	e:Place(-84, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 209, 0)
	e:Place(-83, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -134, 202, 0)
	e:Place(-134, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -136, 202, 0)
	e:Place(-136, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -136, 201, 0)
	e:Place(-136, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -136, 203, 0)
	e:Place(-136, 203, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1b')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 16)
	slots[3]:SetItemAndStack('ldframe', 1)
	slots[3]:SetLockedItem('ldframe')
	slots[4]:SetItemAndStack('ldframe', 1)
	slots[4]:SetLockedItem('ldframe')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 201, 1)
	e:Place(-125, 201, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1b')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 16)
	slots[2]:SetItemAndStack('aluminiumrod', 3)
	slots[3]:SetItemAndStack('ldframe', 1)
	slots[3]:SetLockedItem('ldframe')
	slots[4]:SetItemAndStack('ldframe', 1)
	slots[4]:SetLockedItem('ldframe')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 204, 1)
	e:Place(-125, 204, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -110, 222, 3)
	e:Place(-110, 222, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -109, 221, 3)
	e:Place(-109, 221, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -110, 221, 3)
	e:Place(-110, 221, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -109, 222, 3)
	e:Place(-109, 222, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -109, 223, 3)
	e:Place(-109, 223, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -110, 223, 3)
	e:Place(-110, 223, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -109, 225, 3)
	e:Place(-109, 225, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -110, 225, 3)
	e:Place(-110, 225, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -109, 224, 3)
	e:Place(-109, 224, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -110, 224, 3)
	e:Place(-110, 224, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 207, 0)
	e:Place(-83, 207, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 210, 0)
	e:Place(-83, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -87, 209, 0)
	e:Place(-87, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2d')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[3]:SetItemAndStack('aluminiumsheet', 3)
	slots[3]:SetLockedItem('aluminiumsheet')
	slots[4]:SetItemAndStack('aluminiumsheet', 1)
	slots[4]:SetLockedItem('aluminiumsheet')
	slots[5]:SetItemAndStack('aluminiumsheet', 1)
	slots[5]:SetLockedItem('aluminiumsheet')
	slots[6]:SetItemAndStack('aluminiumsheet', 1)
	slots[6]:SetLockedItem('aluminiumsheet')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -122, 191, 2)
	e:Place(-122, 191, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 5)
	slots[2]:SetItemAndStack('laterite', 10)
	slots[3]:SetItemAndStack('aluminiumrod', 1)
	slots[3]:SetLockedItem('aluminiumrod')
	slots[4]:SetItemAndStack('aluminiumrod', 1)
	slots[4]:SetLockedItem('aluminiumrod')
	slots[5]:SetItemAndStack('aluminiumrod', 1)
	slots[5]:SetLockedItem('aluminiumrod')
	slots[6]:SetItemAndStack('aluminiumrod', 1)
	slots[6]:SetLockedItem('aluminiumrod')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 218, 2)
	e:Place(-119, 218, 2)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -105, 222, 0)
	e:Place(-105, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -105, 223, 0)
	e:Place(-105, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -106, 227, 0)
	e:Place(-106, 227, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 227, 0)
	e:Place(-105, 227, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1b')
	e:AddComponent('c_power_core')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('ldframe', 20)
	slots[1]:SetLockedItem('ldframe')
	slots[2]:SetItemAndStack('ldframe', 20)
	slots[2]:SetLockedItem('ldframe')
	slots[3]:SetItemAndStack('ldframe', 20)
	slots[3]:SetLockedItem('ldframe')
	slots[4]:SetItemAndStack('ldframe', 20)
	slots[4]:SetLockedItem('ldframe')
	slots[5]:SetItemAndStack('ldframe', 20)
	slots[5]:SetLockedItem('ldframe')
	slots[6]:SetItemAndStack('ldframe', 20)
	slots[6]:SetLockedItem('ldframe')
	slots[7]:SetItemAndStack('ldframe', 20)
	slots[7]:SetLockedItem('ldframe')
	slots[8]:SetItemAndStack('ldframe', 20)
	slots[8]:SetLockedItem('ldframe')
	slots[9]:SetItemAndStack('ldframe', 20)
	slots[9]:SetLockedItem('ldframe')
	slots[10]:SetItemAndStack('ldframe', 20)
	slots[10]:SetLockedItem('ldframe')
	slots[11]:SetItemAndStack('ldframe', 20)
	slots[11]:SetLockedItem('ldframe')
	slots[12]:SetItemAndStack('ldframe', 20)
	slots[12]:SetLockedItem('ldframe')
	slots[13]:SetItemAndStack('ldframe', 11)
	slots[13]:SetLockedItem('ldframe')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -126, 202, 0)
	e:Place(-126, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -117, 225, 0)
	e:Place(-117, 225, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 10)
	slots[2]:SetItemAndStack('blight_plasma', 18)
	slots[3]:SetItemAndStack('blight_plasma', 20)
	slots[4]:SetItemAndStack('blight_plasma', 20)
	slots[5]:SetItemAndStack('blight_plasma', 20)
	slots[6]:SetItemAndStack('blight_plasma', 20)
	slots[7]:SetItemAndStack('blight_plasma', 20)
	slots[8]:SetItemAndStack('blight_plasma', 14)
	slots[9]:SetItemAndStack('blight_extraction', 48)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -138, 198, 3)
	e:Place(-138, 198, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_uplink')
	e:AddComponent('c_uplink')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 206, 1)
	e:Place(-117, 206, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_uplink')
	e:AddComponent('c_uplink')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 208, 1)
	e:Place(-117, 208, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_uplink')
	e:AddComponent('c_uplink')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 207, 1)
	e:Place(-117, 207, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 20)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	slots[3]:SetItemAndStack('blight_crystal', 20)
	slots[4]:SetItemAndStack('blight_crystal', 20)
	slots[5]:SetItemAndStack('blight_crystal', 20)
	slots[6]:SetItemAndStack('blight_crystal', 20)
	slots[7]:SetItemAndStack('blight_crystal', 20)
	slots[8]:SetItemAndStack('blight_crystal', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -130, 213, 1)
	e:Place(-130, 213, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 20)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	slots[3]:SetItemAndStack('blight_crystal', 20)
	slots[4]:SetItemAndStack('blight_crystal', 20)
	slots[5]:SetItemAndStack('blight_crystal', 20)
	slots[6]:SetItemAndStack('blight_crystal', 20)
	slots[7]:SetItemAndStack('blight_crystal', 20)
	slots[8]:SetItemAndStack('blight_crystal', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 213, 1)
	e:Place(-129, 213, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_transmitter')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 210, 1)
	e:Place(-131, 210, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_portable_radar')
	e:AddComponent('c_blight_shield')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 1)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	slots[3]:SetItemAndStack('blight_crystal', 20)
	slots[4]:SetItemAndStack('blight_crystal', 20)
	table.insert(all_entities, e)
	e:Place(-151, 210, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_b')
	e:AddComponent('c_blight_shield')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_modulespeed')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 15)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	e.logistics_transport_route = true
	table.insert(all_entities, e)
	e:Place(-141, 211, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -130, 216, 1)
	e:Place(-130, 216, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 20)
	slots[1]:SetLockedItem('blight_crystal')
	slots[2]:SetItemAndStack('blight_plasma', 15)
	slots[2]:SetLockedItem('blight_plasma')
	slots[3]:SetItemAndStack('icchip', 1)
	slots[3]:SetLockedItem('icchip')
	slots[4]:SetItemAndStack('micropro', 1)
	slots[4]:SetLockedItem('micropro')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -124, 210, 0)
	e:Place(-124, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('cable', 5)
	slots[1]:SetLockedItem('cable')
	slots[2]:SetItemAndStack('silicon', 17)
	slots[2]:SetLockedItem('silicon')
	slots[3]:SetItemAndStack('circuit_board', 15)
	slots[3]:SetLockedItem('circuit_board')
	slots[4]:SetItemAndStack('icchip', 1)
	slots[4]:SetLockedItem('icchip')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 210, 0)
	e:Place(-125, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_refinery')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 3)
	slots[1]:SetLockedItem('metalbar')
	slots[2]:SetItemAndStack('blight_crystal', 5)
	slots[2]:SetLockedItem('blight_crystal')
	slots[3]:SetItemAndStack('blightbar', 20)
	slots[4]:SetItemAndStack('blightbar', 20)
	slots[5]:SetItemAndStack('blightbar', 20)
	slots[6]:SetItemAndStack('blightbar', 20)
	slots[7]:SetItemAndStack('blightbar', 20)
	slots[8]:SetItemAndStack('blightbar', 20)
	slots[9]:SetItemAndStack('blightbar', 20)
	slots[10]:SetItemAndStack('blightbar', 20)
	slots[11]:SetItemAndStack('blightbar', 20)
	slots[12]:SetItemAndStack('blightbar', 20)
	slots[13]:SetItemAndStack('blightbar', 20)
	slots[14]:SetItemAndStack('blightbar', 20)
	slots[15]:SetItemAndStack('blightbar', 20)
	slots[16]:SetItemAndStack('blightbar', 20)
	slots[17]:SetItemAndStack('blightbar', 20)
	slots[18]:SetItemAndStack('blightbar', 20)
	slots[19]:SetItemAndStack('blightbar', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 196, 1)
	e:Place(-125, 196, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 20)
	slots[1]:SetLockedItem('aluminiumsheet')
	slots[2]:SetItemAndStack('aluminiumsheet', 20)
	slots[2]:SetLockedItem('aluminiumsheet')
	slots[3]:SetItemAndStack('aluminiumsheet', 20)
	slots[3]:SetLockedItem('aluminiumsheet')
	slots[4]:SetItemAndStack('aluminiumsheet', 20)
	slots[4]:SetLockedItem('aluminiumsheet')
	slots[5]:SetItemAndStack('aluminiumsheet', 20)
	slots[5]:SetLockedItem('aluminiumsheet')
	slots[6]:SetItemAndStack('aluminiumsheet', 20)
	slots[6]:SetLockedItem('aluminiumsheet')
	slots[7]:SetItemAndStack('aluminiumsheet', 20)
	slots[7]:SetLockedItem('aluminiumsheet')
	slots[8]:SetItemAndStack('aluminiumsheet', 20)
	slots[8]:SetLockedItem('aluminiumsheet')
	slots[9]:SetItemAndStack('aluminiumsheet', 20)
	slots[9]:SetLockedItem('aluminiumsheet')
	slots[10]:SetItemAndStack('aluminiumsheet', 20)
	slots[10]:SetLockedItem('aluminiumsheet')
	slots[11]:SetItemAndStack('aluminiumsheet', 20)
	slots[11]:SetLockedItem('aluminiumsheet')
	slots[12]:SetItemAndStack('aluminiumsheet', 20)
	slots[12]:SetLockedItem('aluminiumsheet')
	slots[13]:SetItemAndStack('aluminiumsheet', 20)
	slots[13]:SetLockedItem('aluminiumsheet')
	slots[14]:SetItemAndStack('aluminiumsheet', 20)
	slots[14]:SetLockedItem('aluminiumsheet')
	slots[15]:SetItemAndStack('aluminiumsheet', 14)
	slots[15]:SetLockedItem('aluminiumsheet')
	slots[16]:SetItemAndStack('aluminiumsheet', 1)
	slots[16]:SetLockedItem('aluminiumsheet')
	slots[17]:SetItemAndStack('aluminiumsheet', 1)
	slots[17]:SetLockedItem('aluminiumsheet')
	slots[18]:SetItemAndStack('aluminiumsheet', 1)
	slots[18]:SetLockedItem('aluminiumsheet')
	slots[19]:SetItemAndStack('aluminiumsheet', 1)
	slots[19]:SetLockedItem('aluminiumsheet')
	slots[20]:SetItemAndStack('aluminiumsheet', 1)
	slots[20]:SetLockedItem('aluminiumsheet')
	slots[21]:SetItemAndStack('aluminiumsheet', 1)
	slots[21]:SetLockedItem('aluminiumsheet')
	slots[22]:SetItemAndStack('aluminiumsheet', 1)
	slots[22]:SetLockedItem('aluminiumsheet')
	slots[23]:SetItemAndStack('aluminiumsheet', 1)
	slots[23]:SetLockedItem('aluminiumsheet')
	slots[24]:SetItemAndStack('aluminiumsheet', 1)
	slots[24]:SetLockedItem('aluminiumsheet')
	slots[25]:SetItemAndStack('aluminiumsheet', 1)
	slots[25]:SetLockedItem('aluminiumsheet')
	slots[26]:SetItemAndStack('aluminiumsheet', 1)
	slots[26]:SetLockedItem('aluminiumsheet')
	slots[27]:SetItemAndStack('aluminiumsheet', 1)
	slots[27]:SetLockedItem('aluminiumsheet')
	slots[28]:SetItemAndStack('aluminiumsheet', 1)
	slots[28]:SetLockedItem('aluminiumsheet')
	slots[29]:SetItemAndStack('aluminiumsheet', 1)
	slots[29]:SetLockedItem('aluminiumsheet')
	slots[30]:SetItemAndStack('aluminiumsheet', 1)
	slots[30]:SetLockedItem('aluminiumsheet')
	slots[31]:SetItemAndStack('aluminiumsheet', 1)
	slots[31]:SetLockedItem('aluminiumsheet')
	slots[32]:SetItemAndStack('aluminiumsheet', 1)
	slots[32]:SetLockedItem('aluminiumsheet')
	slots[33]:SetItemAndStack('aluminiumsheet', 1)
	slots[33]:SetLockedItem('aluminiumsheet')
	slots[34]:SetItemAndStack('aluminiumsheet', 1)
	slots[34]:SetLockedItem('aluminiumsheet')
	slots[35]:SetItemAndStack('aluminiumsheet', 1)
	slots[35]:SetLockedItem('aluminiumsheet')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -123, 190, 0)
	e:Place(-123, 190, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 20)
	slots[1]:SetLockedItem('aluminiumsheet')
	slots[2]:SetItemAndStack('aluminiumsheet', 20)
	slots[2]:SetLockedItem('aluminiumsheet')
	slots[3]:SetItemAndStack('aluminiumsheet', 20)
	slots[3]:SetLockedItem('aluminiumsheet')
	slots[4]:SetItemAndStack('aluminiumsheet', 20)
	slots[4]:SetLockedItem('aluminiumsheet')
	slots[5]:SetItemAndStack('aluminiumsheet', 20)
	slots[5]:SetLockedItem('aluminiumsheet')
	slots[6]:SetItemAndStack('aluminiumsheet', 20)
	slots[6]:SetLockedItem('aluminiumsheet')
	slots[7]:SetItemAndStack('aluminiumsheet', 20)
	slots[7]:SetLockedItem('aluminiumsheet')
	slots[8]:SetItemAndStack('aluminiumsheet', 20)
	slots[8]:SetLockedItem('aluminiumsheet')
	slots[9]:SetItemAndStack('aluminiumsheet', 20)
	slots[9]:SetLockedItem('aluminiumsheet')
	slots[10]:SetItemAndStack('aluminiumsheet', 20)
	slots[10]:SetLockedItem('aluminiumsheet')
	slots[11]:SetItemAndStack('aluminiumsheet', 20)
	slots[11]:SetLockedItem('aluminiumsheet')
	slots[12]:SetItemAndStack('aluminiumsheet', 20)
	slots[12]:SetLockedItem('aluminiumsheet')
	slots[13]:SetItemAndStack('aluminiumsheet', 1)
	slots[13]:SetLockedItem('aluminiumsheet')
	slots[14]:SetItemAndStack('aluminiumsheet', 1)
	slots[14]:SetLockedItem('aluminiumsheet')
	slots[15]:SetItemAndStack('aluminiumsheet', 1)
	slots[15]:SetLockedItem('aluminiumsheet')
	slots[16]:SetItemAndStack('aluminiumsheet', 1)
	slots[16]:SetLockedItem('aluminiumsheet')
	slots[17]:SetItemAndStack('aluminiumsheet', 1)
	slots[17]:SetLockedItem('aluminiumsheet')
	slots[18]:SetItemAndStack('aluminiumsheet', 1)
	slots[18]:SetLockedItem('aluminiumsheet')
	slots[19]:SetItemAndStack('aluminiumsheet', 1)
	slots[19]:SetLockedItem('aluminiumsheet')
	slots[20]:SetItemAndStack('aluminiumsheet', 1)
	slots[20]:SetLockedItem('aluminiumsheet')
	slots[21]:SetItemAndStack('aluminiumsheet', 1)
	slots[21]:SetLockedItem('aluminiumsheet')
	slots[22]:SetItemAndStack('aluminiumsheet', 1)
	slots[22]:SetLockedItem('aluminiumsheet')
	slots[23]:SetItemAndStack('aluminiumsheet', 1)
	slots[23]:SetLockedItem('aluminiumsheet')
	slots[24]:SetItemAndStack('aluminiumsheet', 1)
	slots[24]:SetLockedItem('aluminiumsheet')
	slots[25]:SetItemAndStack('aluminiumsheet', 1)
	slots[25]:SetLockedItem('aluminiumsheet')
	slots[26]:SetItemAndStack('aluminiumsheet', 1)
	slots[26]:SetLockedItem('aluminiumsheet')
	slots[27]:SetItemAndStack('aluminiumsheet', 1)
	slots[27]:SetLockedItem('aluminiumsheet')
	slots[28]:SetItemAndStack('aluminiumsheet', 1)
	slots[28]:SetLockedItem('aluminiumsheet')
	slots[29]:SetItemAndStack('aluminiumsheet', 1)
	slots[29]:SetLockedItem('aluminiumsheet')
	slots[30]:SetItemAndStack('aluminiumsheet', 1)
	slots[30]:SetLockedItem('aluminiumsheet')
	slots[31]:SetItemAndStack('aluminiumsheet', 1)
	slots[31]:SetLockedItem('aluminiumsheet')
	slots[32]:SetItemAndStack('aluminiumsheet', 1)
	slots[32]:SetLockedItem('aluminiumsheet')
	slots[33]:SetItemAndStack('aluminiumsheet', 1)
	slots[33]:SetLockedItem('aluminiumsheet')
	slots[34]:SetItemAndStack('aluminiumsheet', 1)
	slots[34]:SetLockedItem('aluminiumsheet')
	slots[35]:SetItemAndStack('aluminiumsheet', 1)
	slots[35]:SetLockedItem('aluminiumsheet')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -120, 190, 0)
	e:Place(-120, 190, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumrod', 20)
	slots[1]:SetLockedItem('aluminiumrod')
	slots[2]:SetItemAndStack('aluminiumrod', 20)
	slots[2]:SetLockedItem('aluminiumrod')
	slots[3]:SetItemAndStack('aluminiumrod', 20)
	slots[3]:SetLockedItem('aluminiumrod')
	slots[4]:SetItemAndStack('aluminiumrod', 20)
	slots[4]:SetLockedItem('aluminiumrod')
	slots[5]:SetItemAndStack('aluminiumrod', 20)
	slots[5]:SetLockedItem('aluminiumrod')
	slots[6]:SetItemAndStack('aluminiumrod', 20)
	slots[6]:SetLockedItem('aluminiumrod')
	slots[7]:SetItemAndStack('aluminiumrod', 20)
	slots[7]:SetLockedItem('aluminiumrod')
	slots[8]:SetItemAndStack('aluminiumrod', 20)
	slots[8]:SetLockedItem('aluminiumrod')
	slots[9]:SetItemAndStack('aluminiumrod', 20)
	slots[9]:SetLockedItem('aluminiumrod')
	slots[10]:SetItemAndStack('aluminiumrod', 20)
	slots[10]:SetLockedItem('aluminiumrod')
	slots[11]:SetItemAndStack('aluminiumrod', 20)
	slots[11]:SetLockedItem('aluminiumrod')
	slots[12]:SetItemAndStack('aluminiumrod', 20)
	slots[12]:SetLockedItem('aluminiumrod')
	slots[13]:SetItemAndStack('aluminiumrod', 1)
	slots[13]:SetLockedItem('aluminiumrod')
	slots[14]:SetItemAndStack('aluminiumrod', 1)
	slots[14]:SetLockedItem('aluminiumrod')
	slots[15]:SetItemAndStack('aluminiumrod', 1)
	slots[15]:SetLockedItem('aluminiumrod')
	slots[16]:SetItemAndStack('aluminiumrod', 1)
	slots[16]:SetLockedItem('aluminiumrod')
	slots[17]:SetItemAndStack('aluminiumrod', 1)
	slots[17]:SetLockedItem('aluminiumrod')
	slots[18]:SetItemAndStack('aluminiumrod', 1)
	slots[18]:SetLockedItem('aluminiumrod')
	slots[19]:SetItemAndStack('aluminiumrod', 1)
	slots[19]:SetLockedItem('aluminiumrod')
	slots[20]:SetItemAndStack('aluminiumrod', 1)
	slots[20]:SetLockedItem('aluminiumrod')
	slots[21]:SetItemAndStack('aluminiumrod', 1)
	slots[21]:SetLockedItem('aluminiumrod')
	slots[22]:SetItemAndStack('aluminiumrod', 1)
	slots[22]:SetLockedItem('aluminiumrod')
	slots[23]:SetItemAndStack('aluminiumrod', 1)
	slots[23]:SetLockedItem('aluminiumrod')
	slots[24]:SetItemAndStack('aluminiumrod', 1)
	slots[24]:SetLockedItem('aluminiumrod')
	slots[25]:SetItemAndStack('aluminiumrod', 1)
	slots[25]:SetLockedItem('aluminiumrod')
	slots[26]:SetItemAndStack('aluminiumrod', 1)
	slots[26]:SetLockedItem('aluminiumrod')
	slots[27]:SetItemAndStack('aluminiumrod', 1)
	slots[27]:SetLockedItem('aluminiumrod')
	slots[28]:SetItemAndStack('aluminiumrod', 1)
	slots[28]:SetLockedItem('aluminiumrod')
	slots[29]:SetItemAndStack('aluminiumrod', 1)
	slots[29]:SetLockedItem('aluminiumrod')
	slots[30]:SetItemAndStack('aluminiumrod', 1)
	slots[30]:SetLockedItem('aluminiumrod')
	slots[31]:SetItemAndStack('aluminiumrod', 1)
	slots[31]:SetLockedItem('aluminiumrod')
	slots[32]:SetItemAndStack('aluminiumrod', 1)
	slots[32]:SetLockedItem('aluminiumrod')
	slots[33]:SetItemAndStack('aluminiumrod', 1)
	slots[33]:SetLockedItem('aluminiumrod')
	slots[34]:SetItemAndStack('aluminiumrod', 1)
	slots[34]:SetLockedItem('aluminiumrod')
	slots[35]:SetItemAndStack('aluminiumrod', 1)
	slots[35]:SetLockedItem('aluminiumrod')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 217, 0)
	e:Place(-117, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumrod', 20)
	slots[1]:SetLockedItem('aluminiumrod')
	slots[2]:SetItemAndStack('aluminiumrod', 20)
	slots[2]:SetLockedItem('aluminiumrod')
	slots[3]:SetItemAndStack('aluminiumrod', 20)
	slots[3]:SetLockedItem('aluminiumrod')
	slots[4]:SetItemAndStack('aluminiumrod', 20)
	slots[4]:SetLockedItem('aluminiumrod')
	slots[5]:SetItemAndStack('aluminiumrod', 20)
	slots[5]:SetLockedItem('aluminiumrod')
	slots[6]:SetItemAndStack('aluminiumrod', 20)
	slots[6]:SetLockedItem('aluminiumrod')
	slots[7]:SetItemAndStack('aluminiumrod', 20)
	slots[7]:SetLockedItem('aluminiumrod')
	slots[8]:SetItemAndStack('aluminiumrod', 20)
	slots[8]:SetLockedItem('aluminiumrod')
	slots[9]:SetItemAndStack('aluminiumrod', 20)
	slots[9]:SetLockedItem('aluminiumrod')
	slots[10]:SetItemAndStack('aluminiumrod', 20)
	slots[10]:SetLockedItem('aluminiumrod')
	slots[11]:SetItemAndStack('aluminiumrod', 20)
	slots[11]:SetLockedItem('aluminiumrod')
	slots[12]:SetItemAndStack('aluminiumrod', 20)
	slots[12]:SetLockedItem('aluminiumrod')
	slots[13]:SetItemAndStack('aluminiumrod', 20)
	slots[13]:SetLockedItem('aluminiumrod')
	slots[14]:SetItemAndStack('aluminiumrod', 20)
	slots[14]:SetLockedItem('aluminiumrod')
	slots[15]:SetItemAndStack('aluminiumrod', 1)
	slots[15]:SetLockedItem('aluminiumrod')
	slots[16]:SetItemAndStack('aluminiumrod', 1)
	slots[16]:SetLockedItem('aluminiumrod')
	slots[17]:SetItemAndStack('aluminiumrod', 1)
	slots[17]:SetLockedItem('aluminiumrod')
	slots[18]:SetItemAndStack('aluminiumrod', 1)
	slots[18]:SetLockedItem('aluminiumrod')
	slots[19]:SetItemAndStack('aluminiumrod', 1)
	slots[19]:SetLockedItem('aluminiumrod')
	slots[20]:SetItemAndStack('aluminiumrod', 1)
	slots[20]:SetLockedItem('aluminiumrod')
	slots[21]:SetItemAndStack('aluminiumrod', 1)
	slots[21]:SetLockedItem('aluminiumrod')
	slots[22]:SetItemAndStack('aluminiumrod', 1)
	slots[22]:SetLockedItem('aluminiumrod')
	slots[23]:SetItemAndStack('aluminiumrod', 1)
	slots[23]:SetLockedItem('aluminiumrod')
	slots[24]:SetItemAndStack('aluminiumrod', 1)
	slots[24]:SetLockedItem('aluminiumrod')
	slots[25]:SetItemAndStack('aluminiumrod', 1)
	slots[25]:SetLockedItem('aluminiumrod')
	slots[26]:SetItemAndStack('aluminiumrod', 1)
	slots[26]:SetLockedItem('aluminiumrod')
	slots[27]:SetItemAndStack('aluminiumrod', 1)
	slots[27]:SetLockedItem('aluminiumrod')
	slots[28]:SetItemAndStack('aluminiumrod', 1)
	slots[28]:SetLockedItem('aluminiumrod')
	slots[29]:SetItemAndStack('aluminiumrod', 1)
	slots[29]:SetLockedItem('aluminiumrod')
	slots[30]:SetItemAndStack('aluminiumrod', 1)
	slots[30]:SetLockedItem('aluminiumrod')
	slots[31]:SetItemAndStack('aluminiumrod', 1)
	slots[31]:SetLockedItem('aluminiumrod')
	slots[32]:SetItemAndStack('aluminiumrod', 1)
	slots[32]:SetLockedItem('aluminiumrod')
	slots[33]:SetItemAndStack('aluminiumrod', 1)
	slots[33]:SetLockedItem('aluminiumrod')
	slots[34]:SetItemAndStack('aluminiumrod', 1)
	slots[34]:SetLockedItem('aluminiumrod')
	slots[35]:SetItemAndStack('aluminiumrod', 1)
	slots[35]:SetLockedItem('aluminiumrod')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -120, 217, 0)
	e:Place(-120, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -81, 223, 1)
	e:Place(-81, 223, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -88, 187, 1)
	e:Place(-88, 187, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -96, 188, 1)
	e:Place(-96, 188, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -104, 181, 1)
	e:Place(-104, 181, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -128, 181, 1)
	e:Place(-128, 181, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1e')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('c_moduleefficiency', 1)
	slots[2]:SetItemAndStack('c_moduleefficiency', 1)
	slots[3]:SetItemAndStack('c_moduleefficiency_s', 1)
	slots[4]:SetItemAndStack('transformer', 20)
	slots[5]:SetItemAndStack('transformer', 20)
	slots[6]:SetItemAndStack('transformer', 20)
	slots[7]:SetItemAndStack('transformer', 20)
	slots[8]:SetItemAndStack('transformer', 20)
	slots[9]:SetItemAndStack('transformer', 20)
	slots[10]:SetItemAndStack('transformer', 20)
	slots[11]:SetItemAndStack('transformer', 20)
	e.disconnected = false
	CreateFoundationsForEntity(e, -114, 195, 1)
	e:Place(-114, 195, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('energized_plate', 7)
	slots[3]:SetItemAndStack('refined_crystal', 20)
	slots[4]:SetItemAndStack('refined_crystal', 20)
	slots[5]:SetItemAndStack('refined_crystal', 20)
	slots[6]:SetItemAndStack('refined_crystal', 20)
	slots[7]:SetItemAndStack('refined_crystal', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 220, 1)
	e:Place(-125, 220, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('energized_plate', 8)
	slots[2]:SetItemAndStack('crystal_powder', 2)
	slots[3]:SetItemAndStack('refined_crystal', 20)
	slots[4]:SetItemAndStack('refined_crystal', 5)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 219, 1)
	e:Place(-125, 219, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_missile_turret')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 178, 1)
	e:Place(-101, 178, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 223, 0)
	e:Place(-119, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	slots = e.slots
	slots[1]:SetItemAndStack('circuit_board', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 198, 0)
	e:Place(-86, 198, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -123, 178, 0)
	e:Place(-123, 178, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	slots = e.slots
	slots[1]:SetItemAndStack('circuit_board', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 194, 0)
	e:Place(-86, 194, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -102, 178, 0)
	e:Place(-102, 178, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 218, 0)
	e:Place(-129, 218, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -136, 189, 0)
	e:Place(-136, 189, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -94, 187, 0)
	e:Place(-94, 187, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -94, 186, 0)
	e:Place(-94, 186, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -124, 179, 0)
	e:Place(-124, 179, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e:AddComponent('c_capacitor')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -137, 191, 1)
	e:Place(-137, 191, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -134, 216, 0)
	e:Place(-134, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 227, 0)
	e:Place(-117, 227, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 216, 0)
	e:Place(-135, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 179, 0)
	e:Place(-101, 179, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -138, 189, 0)
	e:Place(-138, 189, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2f')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_solar_panel')
	CreateFoundationsForEntity(e, -121, 178, 1)
	e:Place(-121, 178, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2f')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	CreateFoundationsForEntity(e, -121, 222, 1)
	e:Place(-121, 222, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_missile_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -133, 216, 1)
	e:Place(-133, 216, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_missile_turret')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -124, 178, 1)
	e:Place(-124, 178, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_missile_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -137, 189, 1)
	e:Place(-137, 189, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 7)
	slots[2]:SetItemAndStack('crystal', 5)
	slots[3]:SetItemAndStack('crystal_powder', 3)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -97, 210, 1)
	e:Place(-97, 210, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 4)
	slots[2]:SetItemAndStack('crystal', 8)
	slots[3]:SetItemAndStack('crystal_powder', 20)
	slots[4]:SetItemAndStack('crystal_powder', 19)
	slots[5]:SetItemAndStack('crystal_powder', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -97, 211, 1)
	e:Place(-97, 211, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_drone_launcher')
	slots = e.slots
	slots[1]:SetItemAndStack('cable', 10)
	slots[2]:SetItemAndStack('hdframe', 10)
	slots[3]:SetItemAndStack('circuit_board', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 202, 1)
	e:Place(-105, 202, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_landing_pad')
	slots = e.slots
	slots[2].entity = Map.CreateEntity(f, 'f_flyer_m')
	slots[3].entity = Map.CreateEntity(f, 'f_flyer_m')
	e.disconnected = false
	CreateFoundationsForEntity(e, -113, 202, 1)
	e:Place(-113, 202, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_drone_launcher')
	slots = e.slots
	slots[1]:SetItemAndStack('cable', 10)
	slots[2]:SetItemAndStack('hdframe', 10)
	slots[3]:SetItemAndStack('circuit_board', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -89, 218, 1)
	e:Place(-89, 218, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_missile_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 186, 1)
	e:Place(-86, 186, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('refined_crystal', 15)
	slots[1]:SetLockedItem('refined_crystal')
	slots[2]:SetItemAndStack('cable', 1)
	slots[2]:SetLockedItem('cable')
	slots[3]:SetItemAndStack('optic_cable', 19)
	slots[4]:SetItemAndStack('optic_cable', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -99, 215, 2)
	e:Place(-99, 215, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('refined_crystal', 18)
	slots[1]:SetLockedItem('refined_crystal')
	slots[2]:SetItemAndStack('cable', 1)
	slots[2]:SetLockedItem('cable')
	slots[3]:SetItemAndStack('optic_cable', 19)
	slots[4]:SetItemAndStack('optic_cable', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -100, 215, 2)
	e:Place(-100, 215, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	slots = e.slots
	slots[1]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 216, 0)
	e:Place(-129, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('refined_crystal', 14)
	slots[2]:SetItemAndStack('silicon', 11)
	slots[3]:SetItemAndStack('fused_electrodes', 20)
	slots[4]:SetItemAndStack('fused_electrodes', 20)
	slots[5]:SetItemAndStack('fused_electrodes', 20)
	slots[6]:SetItemAndStack('fused_electrodes', 20)
	slots[7]:SetItemAndStack('fused_electrodes', 20)
	slots[8]:SetItemAndStack('fused_electrodes', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 196, 1)
	e:Place(-119, 196, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('refined_crystal', 20)
	slots[2]:SetItemAndStack('silicon', 20)
	slots[3]:SetItemAndStack('fused_electrodes', 20)
	slots[4]:SetItemAndStack('fused_electrodes', 20)
	slots[5]:SetItemAndStack('fused_electrodes', 20)
	slots[6]:SetItemAndStack('fused_electrodes', 20)
	slots[7]:SetItemAndStack('fused_electrodes', 20)
	slots[8]:SetItemAndStack('fused_electrodes', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 197, 1)
	e:Place(-119, 197, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	slots = e.slots
	slots[2]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 178, 2)
	e:Place(-119, 178, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 20)
	slots[3]:SetItemAndStack('metalplate', 1)
	slots[4]:SetItemAndStack('reinforced_plate', 9)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 211, 1)
	e:Place(-107, 211, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_assembler')
	slots = e.slots
	slots[1]:SetItemAndStack('bug_carapace', 9)
	slots[1]:SetLockedItem('bug_carapace')
	slots[2]:SetItemAndStack('circuit_board', 10)
	slots[2]:SetLockedItem('circuit_board')
	slots[3]:SetItemAndStack('infected_circuit_board', 20)
	slots[4]:SetItemAndStack('infected_circuit_board', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -114, 196, 0)
	e:Place(-114, 196, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 10)
	slots[1]:SetLockedItem('silica')
	slots[2]:SetItemAndStack('blight_crystal', 10)
	slots[2]:SetLockedItem('blight_crystal')
	slots[3]:SetItemAndStack('bug_carapace', 20)
	slots[4]:SetItemAndStack('bug_carapace', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -87, 222, 0)
	e:Place(-87, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_large_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('optic_cable', 20)
	slots[1]:SetLockedItem('optic_cable')
	slots[2]:SetItemAndStack('hdframe', 1)
	slots[2]:SetLockedItem('hdframe')
	slots[3]:SetItemAndStack('datacube_matrix', 18)
	slots[3]:SetLockedItem('datacube_matrix')
	slots[4]:SetItemAndStack('datacube_matrix', 20)
	slots[4]:SetLockedItem('datacube_matrix')
	slots[5]:SetItemAndStack('datacube_matrix', 20)
	slots[5]:SetLockedItem('datacube_matrix')
	slots[6]:SetItemAndStack('datacube_matrix', 20)
	slots[6]:SetLockedItem('datacube_matrix')
	slots[7]:SetItemAndStack('datacube_matrix', 20)
	slots[7]:SetLockedItem('datacube_matrix')
	slots[8]:SetItemAndStack('datacube_matrix', 20)
	slots[8]:SetLockedItem('datacube_matrix')
	slots[9]:SetItemAndStack('datacube_matrix', 20)
	slots[9]:SetLockedItem('datacube_matrix')
	slots[10]:SetItemAndStack('datacube_matrix', 20)
	slots[10]:SetLockedItem('datacube_matrix')
	slots[11]:SetItemAndStack('datacube_matrix', 20)
	slots[11]:SetLockedItem('datacube_matrix')
	slots[12]:SetItemAndStack('datacube_matrix', 20)
	slots[12]:SetLockedItem('datacube_matrix')
	slots[13]:SetItemAndStack('datacube_matrix', 20)
	slots[13]:SetLockedItem('datacube_matrix')
	slots[14]:SetItemAndStack('datacube_matrix', 20)
	slots[14]:SetLockedItem('datacube_matrix')
	slots[15]:SetItemAndStack('datacube_matrix', 20)
	slots[15]:SetLockedItem('datacube_matrix')
	slots[16]:SetItemAndStack('datacube_matrix', 20)
	slots[16]:SetLockedItem('datacube_matrix')
	slots[17]:SetItemAndStack('datacube_matrix', 20)
	slots[17]:SetLockedItem('datacube_matrix')
	slots[18]:SetItemAndStack('datacube_matrix', 20)
	slots[18]:SetLockedItem('datacube_matrix')
	slots[19]:SetItemAndStack('datacube_matrix', 20)
	slots[19]:SetLockedItem('datacube_matrix')
	slots[20]:SetItemAndStack('datacube_matrix', 20)
	slots[20]:SetLockedItem('datacube_matrix')
	slots[21]:SetItemAndStack('datacube_matrix', 20)
	slots[21]:SetLockedItem('datacube_matrix')
	slots[22]:SetItemAndStack('datacube_matrix', 20)
	slots[22]:SetLockedItem('datacube_matrix')
	slots[23]:SetItemAndStack('datacube_matrix', 20)
	slots[23]:SetLockedItem('datacube_matrix')
	slots[24]:SetItemAndStack('datacube_matrix', 20)
	slots[24]:SetLockedItem('datacube_matrix')
	slots[25]:SetItemAndStack('datacube_matrix', 20)
	slots[25]:SetLockedItem('datacube_matrix')
	slots[26]:SetItemAndStack('datacube_matrix', 20)
	slots[26]:SetLockedItem('datacube_matrix')
	slots[27]:SetItemAndStack('datacube_matrix', 20)
	slots[27]:SetLockedItem('datacube_matrix')
	slots[28]:SetItemAndStack('datacube_matrix', 20)
	slots[28]:SetLockedItem('datacube_matrix')
	slots[29]:SetItemAndStack('datacube_matrix', 20)
	slots[29]:SetLockedItem('datacube_matrix')
	slots[30]:SetItemAndStack('datacube_matrix', 20)
	slots[30]:SetLockedItem('datacube_matrix')
	slots[31]:SetItemAndStack('datacube_matrix', 20)
	slots[31]:SetLockedItem('datacube_matrix')
	slots[32]:SetItemAndStack('datacube_matrix', 20)
	slots[32]:SetLockedItem('datacube_matrix')
	slots[33]:SetItemAndStack('datacube_matrix', 1)
	slots[33]:SetLockedItem('datacube_matrix')
	slots[34]:SetItemAndStack('datacube_matrix', 1)
	slots[34]:SetLockedItem('datacube_matrix')
	slots[35]:SetItemAndStack('datacube_matrix', 1)
	slots[35]:SetLockedItem('datacube_matrix')
	slots[36]:SetItemAndStack('datacube_matrix', 1)
	slots[36]:SetLockedItem('datacube_matrix')
	slots[37]:SetItemAndStack('datacube_matrix', 1)
	slots[37]:SetLockedItem('datacube_matrix')
	slots[38]:SetItemAndStack('datacube_matrix', 1)
	slots[38]:SetLockedItem('datacube_matrix')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -112, 191, 0)
	e:Place(-112, 191, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('energized_plate', 2)
	slots[2]:SetItemAndStack('wire', 1)
	slots[3]:SetItemAndStack('hdframe', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -97, 206, 0)
	e:Place(-97, 206, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('hdframe', 1)
	slots[2]:SetItemAndStack('energized_plate', 2)
	slots[3]:SetItemAndStack('wire', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -97, 203, 2)
	e:Place(-97, 203, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('hdframe', 1)
	slots[1]:SetLockedItem('hdframe')
	slots[2]:SetItemAndStack('crystal_powder', 11)
	slots[2]:SetLockedItem('crystal_powder')
	slots[3]:SetItemAndStack('robot_datacube', 18)
	slots[4]:SetItemAndStack('robot_datacube', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 214, 1)
	e:Place(-125, 214, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('hdframe', 1)
	slots[1]:SetLockedItem('hdframe')
	slots[2]:SetItemAndStack('crystal_powder', 14)
	slots[2]:SetLockedItem('crystal_powder')
	slots[3]:SetItemAndStack('robot_datacube', 20)
	slots[4]:SetItemAndStack('robot_datacube', 12)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 215, 1)
	e:Place(-125, 215, 1)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_data_analyzer')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	slots = e.slots
	slots[1]:SetItemAndStack('human_datacube', 20)
	slots[1]:SetLockedItem('human_datacube')
	slots[2]:SetItemAndStack('datacube_matrix', 10)
	slots[2]:SetLockedItem('datacube_matrix')
	slots[3]:SetItemAndStack('human_research', 1)
	slots[4]:SetItemAndStack('human_datacube', 20)
	slots[5]:SetItemAndStack('human_datacube', 20)
	slots[6]:SetItemAndStack('human_datacube', 20)
	slots[7]:SetItemAndStack('human_datacube', 20)
	slots[8]:SetItemAndStack('human_datacube', 20)
	slots[9]:SetItemAndStack('human_datacube', 20)
	slots[10]:SetItemAndStack('human_datacube', 20)
	slots[11]:SetItemAndStack('human_datacube', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -123, 182, 3)
	e:Place(-123, 182, 3)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_light_rgb')
	e:AddComponent('c_power_unit')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('optic_cable', 16)
	slots[1]:SetLockedItem('optic_cable')
	slots[2]:SetItemAndStack('hdframe', 1)
	slots[2]:SetLockedItem('hdframe')
	slots[3]:SetItemAndStack('datacube_matrix', 1)
	slots[3]:SetLockedItem('datacube_matrix')
	slots[4]:SetItemAndStack('datacube_matrix', 1)
	slots[4]:SetLockedItem('datacube_matrix')
	slots[5]:SetItemAndStack('datacube_matrix', 1)
	slots[5]:SetLockedItem('datacube_matrix')
	slots[6]:SetItemAndStack('datacube_matrix', 1)
	slots[6]:SetLockedItem('datacube_matrix')
	slots[7]:SetItemAndStack('datacube_matrix', 1)
	slots[7]:SetLockedItem('datacube_matrix')
	slots[8]:SetItemAndStack('datacube_matrix', 1)
	slots[8]:SetLockedItem('datacube_matrix')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 189, 3)
	e:Place(-113, 189, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -79, 225, 0)
	e:Place(-79, 225, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_light_rgb')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('human_research', 16)
	slots[1]:SetLockedItem('human_research')
	slots[2]:SetItemAndStack('human_research', 1)
	slots[2]:SetLockedItem('human_research')
	slots[3]:SetItemAndStack('human_research', 1)
	slots[3]:SetLockedItem('human_research')
	slots[4]:SetItemAndStack('human_research', 1)
	slots[4]:SetLockedItem('human_research')
	slots[5]:SetItemAndStack('human_research', 1)
	slots[5]:SetLockedItem('human_research')
	slots[6]:SetItemAndStack('human_research', 1)
	slots[6]:SetLockedItem('human_research')
	slots[7]:SetItemAndStack('human_research', 1)
	slots[7]:SetLockedItem('human_research')
	slots[8]:SetItemAndStack('human_research', 1)
	slots[8]:SetLockedItem('human_research')
	slots[9]:SetItemAndStack('human_research', 1)
	slots[9]:SetLockedItem('human_research')
	slots[10]:SetItemAndStack('human_research', 1)
	slots[10]:SetLockedItem('human_research')
	slots[11]:SetItemAndStack('human_research', 1)
	slots[11]:SetLockedItem('human_research')
	slots[12]:SetItemAndStack('human_research', 1)
	slots[12]:SetLockedItem('human_research')
	slots[13]:SetItemAndStack('human_research', 1)
	slots[13]:SetLockedItem('human_research')
	slots[14]:SetItemAndStack('human_research', 1)
	slots[14]:SetLockedItem('human_research')
	slots[15]:SetItemAndStack('human_research', 1)
	slots[15]:SetLockedItem('human_research')
	slots[16]:SetItemAndStack('human_research', 1)
	slots[16]:SetLockedItem('human_research')
	slots[17]:SetItemAndStack('human_research', 1)
	slots[17]:SetLockedItem('human_research')
	slots[18]:SetItemAndStack('human_research', 1)
	slots[18]:SetLockedItem('human_research')
	slots[19]:SetItemAndStack('human_research', 1)
	slots[19]:SetLockedItem('human_research')
	slots[20]:SetItemAndStack('human_research', 1)
	slots[20]:SetLockedItem('human_research')
	slots[21]:SetItemAndStack('human_research', 1)
	slots[21]:SetLockedItem('human_research')
	slots[22]:SetItemAndStack('human_research', 1)
	slots[22]:SetLockedItem('human_research')
	slots[23]:SetItemAndStack('human_research', 1)
	slots[23]:SetLockedItem('human_research')
	slots[24]:SetItemAndStack('human_research', 1)
	slots[24]:SetLockedItem('human_research')
	slots[25]:SetItemAndStack('human_research', 1)
	slots[25]:SetLockedItem('human_research')
	slots[26]:SetItemAndStack('human_research', 1)
	slots[26]:SetLockedItem('human_research')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -121, 182, 0)
	e:Place(-121, 182, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_light_rgb')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('virus_research', 13)
	slots[1]:SetLockedItem('virus_research')
	slots[2]:SetItemAndStack('virus_research', 1)
	slots[2]:SetLockedItem('virus_research')
	slots[3]:SetItemAndStack('virus_research', 1)
	slots[3]:SetLockedItem('virus_research')
	slots[4]:SetItemAndStack('virus_research', 1)
	slots[4]:SetLockedItem('virus_research')
	slots[5]:SetItemAndStack('virus_research', 1)
	slots[5]:SetLockedItem('virus_research')
	slots[6]:SetItemAndStack('virus_research', 1)
	slots[6]:SetLockedItem('virus_research')
	slots[7]:SetItemAndStack('virus_research', 1)
	slots[7]:SetLockedItem('virus_research')
	slots[8]:SetItemAndStack('virus_research', 1)
	slots[8]:SetLockedItem('virus_research')
	slots[9]:SetItemAndStack('virus_research', 1)
	slots[9]:SetLockedItem('virus_research')
	slots[10]:SetItemAndStack('virus_research', 1)
	slots[10]:SetLockedItem('virus_research')
	slots[11]:SetItemAndStack('virus_research', 1)
	slots[11]:SetLockedItem('virus_research')
	slots[12]:SetItemAndStack('virus_research', 1)
	slots[12]:SetLockedItem('virus_research')
	slots[13]:SetItemAndStack('virus_research', 1)
	slots[13]:SetLockedItem('virus_research')
	slots[14]:SetItemAndStack('virus_research', 1)
	slots[14]:SetLockedItem('virus_research')
	slots[15]:SetItemAndStack('virus_research', 1)
	slots[15]:SetLockedItem('virus_research')
	slots[16]:SetItemAndStack('virus_research', 1)
	slots[16]:SetLockedItem('virus_research')
	slots[17]:SetItemAndStack('virus_research', 1)
	slots[17]:SetLockedItem('virus_research')
	slots[18]:SetItemAndStack('virus_research', 1)
	slots[18]:SetLockedItem('virus_research')
	slots[19]:SetItemAndStack('virus_research', 1)
	slots[19]:SetLockedItem('virus_research')
	slots[20]:SetItemAndStack('virus_research', 1)
	slots[20]:SetLockedItem('virus_research')
	slots[21]:SetItemAndStack('virus_research', 1)
	slots[21]:SetLockedItem('virus_research')
	slots[22]:SetItemAndStack('virus_research', 1)
	slots[22]:SetLockedItem('virus_research')
	slots[23]:SetItemAndStack('virus_research', 1)
	slots[23]:SetLockedItem('virus_research')
	slots[24]:SetItemAndStack('virus_research', 1)
	slots[24]:SetLockedItem('virus_research')
	slots[25]:SetItemAndStack('virus_research', 1)
	slots[25]:SetLockedItem('virus_research')
	slots[26]:SetItemAndStack('virus_research', 1)
	slots[26]:SetLockedItem('virus_research')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -115, 182, 0)
	e:Place(-115, 182, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_light_rgb')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('robot_research', 20)
	slots[1]:SetLockedItem('robot_research')
	slots[2]:SetItemAndStack('robot_research', 4)
	slots[2]:SetLockedItem('robot_research')
	slots[3]:SetItemAndStack('robot_research', 1)
	slots[3]:SetLockedItem('robot_research')
	slots[4]:SetItemAndStack('robot_research', 1)
	slots[4]:SetLockedItem('robot_research')
	slots[5]:SetItemAndStack('robot_research', 1)
	slots[5]:SetLockedItem('robot_research')
	slots[6]:SetItemAndStack('robot_research', 1)
	slots[6]:SetLockedItem('robot_research')
	slots[7]:SetItemAndStack('robot_research', 1)
	slots[7]:SetLockedItem('robot_research')
	slots[8]:SetItemAndStack('robot_research', 1)
	slots[8]:SetLockedItem('robot_research')
	slots[9]:SetItemAndStack('robot_research', 1)
	slots[9]:SetLockedItem('robot_research')
	slots[10]:SetItemAndStack('robot_research', 1)
	slots[10]:SetLockedItem('robot_research')
	slots[11]:SetItemAndStack('robot_research', 1)
	slots[11]:SetLockedItem('robot_research')
	slots[12]:SetItemAndStack('robot_research', 1)
	slots[12]:SetLockedItem('robot_research')
	slots[13]:SetItemAndStack('robot_research', 1)
	slots[13]:SetLockedItem('robot_research')
	slots[14]:SetItemAndStack('robot_research', 1)
	slots[14]:SetLockedItem('robot_research')
	slots[15]:SetItemAndStack('robot_research', 1)
	slots[15]:SetLockedItem('robot_research')
	slots[16]:SetItemAndStack('robot_research', 1)
	slots[16]:SetLockedItem('robot_research')
	slots[17]:SetItemAndStack('robot_research', 1)
	slots[17]:SetLockedItem('robot_research')
	slots[18]:SetItemAndStack('robot_research', 1)
	slots[18]:SetLockedItem('robot_research')
	slots[19]:SetItemAndStack('robot_research', 1)
	slots[19]:SetLockedItem('robot_research')
	slots[20]:SetItemAndStack('robot_research', 1)
	slots[20]:SetLockedItem('robot_research')
	slots[21]:SetItemAndStack('robot_research', 1)
	slots[21]:SetLockedItem('robot_research')
	slots[22]:SetItemAndStack('robot_research', 1)
	slots[22]:SetLockedItem('robot_research')
	slots[23]:SetItemAndStack('robot_research', 1)
	slots[23]:SetLockedItem('robot_research')
	slots[24]:SetItemAndStack('robot_research', 1)
	slots[24]:SetLockedItem('robot_research')
	slots[25]:SetItemAndStack('robot_research', 1)
	slots[25]:SetLockedItem('robot_research')
	slots[26]:SetItemAndStack('robot_research', 1)
	slots[26]:SetLockedItem('robot_research')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -109, 182, 0)
	e:Place(-109, 182, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_data_analyzer')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	slots = e.slots
	slots[1]:SetItemAndStack('robot_datacube', 20)
	slots[1]:SetLockedItem('robot_datacube')
	slots[2]:SetItemAndStack('datacube_matrix', 1)
	slots[2]:SetLockedItem('datacube_matrix')
	slots[3]:SetItemAndStack('robot_research', 1)
	slots[4]:SetItemAndStack('robot_datacube', 20)
	slots[5]:SetItemAndStack('robot_datacube', 20)
	slots[6]:SetItemAndStack('robot_datacube', 20)
	slots[7]:SetItemAndStack('robot_datacube', 20)
	slots[8]:SetItemAndStack('robot_datacube', 20)
	slots[9]:SetItemAndStack('robot_datacube', 20)
	slots[10]:SetItemAndStack('robot_datacube', 20)
	slots[11]:SetItemAndStack('robot_datacube', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -111, 182, 3)
	e:Place(-111, 182, 3)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_data_analyzer')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	slots = e.slots
	slots[1]:SetItemAndStack('virus_research_data', 20)
	slots[1]:SetLockedItem('virus_research_data')
	slots[2]:SetItemAndStack('datacube_matrix', 8)
	slots[2]:SetLockedItem('datacube_matrix')
	slots[3]:SetItemAndStack('virus_research', 1)
	slots[4]:SetItemAndStack('virus_research_data', 20)
	slots[5]:SetItemAndStack('virus_research_data', 20)
	slots[6]:SetItemAndStack('virus_research_data', 20)
	slots[7]:SetItemAndStack('virus_research_data', 20)
	slots[8]:SetItemAndStack('virus_research_data', 20)
	slots[9]:SetItemAndStack('virus_research_data', 20)
	slots[10]:SetItemAndStack('virus_research_data', 20)
	slots[11]:SetItemAndStack('virus_research_data', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 182, 3)
	e:Place(-117, 182, 3)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_data_analyzer')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_datacube', 20)
	slots[1]:SetLockedItem('blight_datacube')
	slots[2]:SetItemAndStack('datacube_matrix', 1)
	slots[2]:SetLockedItem('datacube_matrix')
	slots[3]:SetItemAndStack('blight_research', 1)
	slots[4]:SetItemAndStack('blight_datacube', 20)
	slots[5]:SetItemAndStack('blight_datacube', 20)
	slots[6]:SetItemAndStack('blight_datacube', 20)
	slots[7]:SetItemAndStack('blight_datacube', 20)
	slots[8]:SetItemAndStack('blight_datacube', 20)
	slots[9]:SetItemAndStack('blight_datacube', 20)
	slots[10]:SetItemAndStack('blight_datacube', 20)
	slots[11]:SetItemAndStack('blight_datacube', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 182, 3)
	e:Place(-105, 182, 3)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_light_rgb')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_medium_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_research', 20)
	slots[1]:SetLockedItem('blight_research')
	slots[2]:SetItemAndStack('blight_research', 20)
	slots[2]:SetLockedItem('blight_research')
	slots[3]:SetItemAndStack('blight_research', 1)
	slots[3]:SetLockedItem('blight_research')
	slots[4]:SetItemAndStack('blight_research', 1)
	slots[4]:SetLockedItem('blight_research')
	slots[5]:SetItemAndStack('blight_research', 1)
	slots[5]:SetLockedItem('blight_research')
	slots[6]:SetItemAndStack('blight_research', 1)
	slots[6]:SetLockedItem('blight_research')
	slots[7]:SetItemAndStack('blight_research', 1)
	slots[7]:SetLockedItem('blight_research')
	slots[8]:SetItemAndStack('blight_research', 1)
	slots[8]:SetLockedItem('blight_research')
	slots[9]:SetItemAndStack('blight_research', 1)
	slots[9]:SetLockedItem('blight_research')
	slots[10]:SetItemAndStack('blight_research', 1)
	slots[10]:SetLockedItem('blight_research')
	slots[11]:SetItemAndStack('blight_research', 1)
	slots[11]:SetLockedItem('blight_research')
	slots[12]:SetItemAndStack('blight_research', 1)
	slots[12]:SetLockedItem('blight_research')
	slots[13]:SetItemAndStack('blight_research', 1)
	slots[13]:SetLockedItem('blight_research')
	slots[14]:SetItemAndStack('blight_research', 1)
	slots[14]:SetLockedItem('blight_research')
	slots[15]:SetItemAndStack('blight_research', 1)
	slots[15]:SetLockedItem('blight_research')
	slots[16]:SetItemAndStack('blight_research', 1)
	slots[16]:SetLockedItem('blight_research')
	slots[17]:SetItemAndStack('blight_research', 1)
	slots[17]:SetLockedItem('blight_research')
	slots[18]:SetItemAndStack('blight_research', 1)
	slots[18]:SetLockedItem('blight_research')
	slots[19]:SetItemAndStack('blight_research', 1)
	slots[19]:SetLockedItem('blight_research')
	slots[20]:SetItemAndStack('blight_research', 1)
	slots[20]:SetLockedItem('blight_research')
	slots[21]:SetItemAndStack('blight_research', 1)
	slots[21]:SetLockedItem('blight_research')
	slots[22]:SetItemAndStack('blight_research', 1)
	slots[22]:SetLockedItem('blight_research')
	slots[23]:SetItemAndStack('blight_research', 1)
	slots[23]:SetLockedItem('blight_research')
	slots[24]:SetItemAndStack('blight_research', 1)
	slots[24]:SetLockedItem('blight_research')
	slots[25]:SetItemAndStack('blight_research', 1)
	slots[25]:SetLockedItem('blight_research')
	slots[26]:SetItemAndStack('blight_research', 1)
	slots[26]:SetLockedItem('blight_research')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -103, 182, 0)
	e:Place(-103, 182, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('optic_cable', 5)
	slots[1]:SetLockedItem('optic_cable')
	slots[2]:SetItemAndStack('hdframe', 1)
	slots[2]:SetLockedItem('hdframe')
	slots[3]:SetItemAndStack('datacube_matrix', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 191, 0)
	e:Place(-113, 191, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_large_storage')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 3)
	slots[1]:SetLockedItem('blight_plasma')
	slots[2]:SetItemAndStack('robot_datacube', 11)
	slots[2]:SetLockedItem('robot_datacube')
	slots[3]:SetItemAndStack('blight_datacube', 20)
	slots[3]:SetLockedItem('blight_datacube')
	slots[4]:SetItemAndStack('blight_datacube', 20)
	slots[4]:SetLockedItem('blight_datacube')
	slots[5]:SetItemAndStack('blight_datacube', 20)
	slots[5]:SetLockedItem('blight_datacube')
	slots[6]:SetItemAndStack('blight_datacube', 20)
	slots[6]:SetLockedItem('blight_datacube')
	slots[7]:SetItemAndStack('blight_datacube', 20)
	slots[7]:SetLockedItem('blight_datacube')
	slots[8]:SetItemAndStack('blight_datacube', 20)
	slots[8]:SetLockedItem('blight_datacube')
	slots[9]:SetLockedItem()
	slots[10]:SetLockedItem()
	slots[11]:SetLockedItem()
	slots[12]:SetLockedItem()
	slots[13]:SetLockedItem()
	slots[14]:SetLockedItem()
	slots[15]:SetLockedItem()
	slots[16]:SetLockedItem()
	slots[17]:SetLockedItem()
	slots[18]:SetLockedItem()
	slots[19]:SetLockedItem()
	slots[20]:SetLockedItem()
	slots[21]:SetLockedItem()
	slots[22]:SetLockedItem()
	slots[23]:SetLockedItem()
	slots[24]:SetLockedItem()
	slots[25]:SetLockedItem()
	slots[26]:SetLockedItem()
	slots[27]:SetLockedItem()
	slots[28]:SetLockedItem()
	slots[29]:SetLockedItem()
	slots[30]:SetLockedItem()
	slots[31]:SetLockedItem()
	slots[32]:SetLockedItem()
	slots[33]:SetLockedItem()
	slots[34]:SetLockedItem()
	slots[35]:SetLockedItem()
	slots[36]:SetLockedItem()
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -137, 194, 0)
	e:Place(-137, 194, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 201, 0)
	e:Place(-146, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 198, 0)
	e:Place(-145, 198, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 199, 0)
	e:Place(-145, 199, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 200, 0)
	e:Place(-145, 200, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 201, 0)
	e:Place(-145, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 200, 0)
	e:Place(-146, 200, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 199, 0)
	e:Place(-146, 199, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 198, 0)
	e:Place(-146, 198, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_portable_radar')
	e:AddComponent('c_blight_shield')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 8)
	table.insert(all_entities, e)
	e:Place(-151, 209, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_portable_radar')
	e:AddComponent('c_blight_shield')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 18)
	slots[2]:SetItemAndStack('blight_crystal', 20)
	table.insert(all_entities, e)
	e:Place(-152, 210, 2)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_transmitter')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 208, 1)
	e:Place(-131, 208, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_transmitter')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 209, 1)
	e:Place(-131, 209, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('cable', 4)
	slots[1]:SetLockedItem('cable')
	slots[2]:SetItemAndStack('silicon', 14)
	slots[2]:SetLockedItem('silicon')
	slots[3]:SetItemAndStack('circuit_board', 20)
	slots[3]:SetLockedItem('circuit_board')
	slots[4]:SetItemAndStack('icchip', 1)
	slots[4]:SetLockedItem('icchip')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 208, 0)
	e:Place(-125, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 20)
	slots[1]:SetLockedItem('blight_crystal')
	slots[2]:SetItemAndStack('blight_plasma', 20)
	slots[2]:SetLockedItem('blight_plasma')
	slots[3]:SetItemAndStack('icchip', 1)
	slots[3]:SetLockedItem('icchip')
	slots[4]:SetItemAndStack('micropro', 1)
	slots[4]:SetLockedItem('micropro')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -124, 208, 0)
	e:Place(-124, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('icchip', 20)
	slots[1]:SetLockedItem('icchip')
	slots[2]:SetItemAndStack('icchip', 20)
	slots[2]:SetLockedItem('icchip')
	slots[3]:SetItemAndStack('icchip', 20)
	slots[3]:SetLockedItem('icchip')
	slots[4]:SetItemAndStack('icchip', 20)
	slots[4]:SetLockedItem('icchip')
	slots[5]:SetItemAndStack('icchip', 20)
	slots[5]:SetLockedItem('icchip')
	slots[6]:SetItemAndStack('icchip', 20)
	slots[6]:SetLockedItem('icchip')
	slots[7]:SetItemAndStack('icchip', 20)
	slots[7]:SetLockedItem('icchip')
	slots[8]:SetItemAndStack('icchip', 20)
	slots[8]:SetLockedItem('icchip')
	slots[9]:SetItemAndStack('icchip', 20)
	slots[9]:SetLockedItem('icchip')
	slots[10]:SetItemAndStack('icchip', 20)
	slots[10]:SetLockedItem('icchip')
	slots[11]:SetItemAndStack('icchip', 20)
	slots[11]:SetLockedItem('icchip')
	slots[12]:SetItemAndStack('icchip', 20)
	slots[12]:SetLockedItem('icchip')
	slots[13]:SetItemAndStack('icchip', 20)
	slots[13]:SetLockedItem('icchip')
	slots[14]:SetItemAndStack('icchip', 20)
	slots[14]:SetLockedItem('icchip')
	slots[15]:SetItemAndStack('icchip', 20)
	slots[15]:SetLockedItem('icchip')
	slots[16]:SetItemAndStack('icchip', 20)
	slots[16]:SetLockedItem('icchip')
	slots[17]:SetItemAndStack('icchip', 20)
	slots[17]:SetLockedItem('icchip')
	slots[18]:SetItemAndStack('icchip', 20)
	slots[18]:SetLockedItem('icchip')
	slots[19]:SetItemAndStack('icchip', 20)
	slots[19]:SetLockedItem('icchip')
	slots[20]:SetItemAndStack('icchip', 20)
	slots[20]:SetLockedItem('icchip')
	slots[21]:SetItemAndStack('icchip', 20)
	slots[21]:SetLockedItem('icchip')
	slots[22]:SetItemAndStack('icchip', 20)
	slots[22]:SetLockedItem('icchip')
	slots[23]:SetItemAndStack('icchip', 20)
	slots[23]:SetLockedItem('icchip')
	slots[24]:SetItemAndStack('icchip', 20)
	slots[24]:SetLockedItem('icchip')
	slots[25]:SetItemAndStack('icchip', 20)
	slots[25]:SetLockedItem('icchip')
	slots[26]:SetItemAndStack('icchip', 20)
	slots[26]:SetLockedItem('icchip')
	slots[27]:SetItemAndStack('icchip', 20)
	slots[27]:SetLockedItem('icchip')
	slots[28]:SetItemAndStack('icchip', 20)
	slots[28]:SetLockedItem('icchip')
	slots[29]:SetItemAndStack('icchip', 20)
	slots[29]:SetLockedItem('icchip')
	slots[30]:SetItemAndStack('icchip', 20)
	slots[30]:SetLockedItem('icchip')
	slots[31]:SetItemAndStack('icchip', 20)
	slots[31]:SetLockedItem('icchip')
	slots[32]:SetItemAndStack('icchip', 20)
	slots[32]:SetLockedItem('icchip')
	slots[33]:SetItemAndStack('icchip', 20)
	slots[33]:SetLockedItem('icchip')
	slots[34]:SetItemAndStack('icchip', 20)
	slots[34]:SetLockedItem('icchip')
	slots[35]:SetItemAndStack('icchip', 1)
	slots[35]:SetLockedItem('icchip')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -126, 209, 0)
	e:Place(-126, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1d')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('micropro', 20)
	slots[1]:SetLockedItem('micropro')
	slots[2]:SetItemAndStack('micropro', 20)
	slots[2]:SetLockedItem('micropro')
	slots[3]:SetItemAndStack('micropro', 20)
	slots[3]:SetLockedItem('micropro')
	slots[4]:SetItemAndStack('micropro', 20)
	slots[4]:SetLockedItem('micropro')
	slots[5]:SetItemAndStack('micropro', 20)
	slots[5]:SetLockedItem('micropro')
	slots[6]:SetItemAndStack('micropro', 20)
	slots[6]:SetLockedItem('micropro')
	slots[7]:SetItemAndStack('micropro', 20)
	slots[7]:SetLockedItem('micropro')
	slots[8]:SetItemAndStack('micropro', 20)
	slots[8]:SetLockedItem('micropro')
	slots[9]:SetItemAndStack('micropro', 20)
	slots[9]:SetLockedItem('micropro')
	slots[10]:SetItemAndStack('micropro', 20)
	slots[10]:SetLockedItem('micropro')
	slots[11]:SetItemAndStack('micropro', 20)
	slots[11]:SetLockedItem('micropro')
	slots[12]:SetItemAndStack('micropro', 20)
	slots[12]:SetLockedItem('micropro')
	slots[13]:SetItemAndStack('micropro', 20)
	slots[13]:SetLockedItem('micropro')
	slots[14]:SetItemAndStack('micropro', 20)
	slots[14]:SetLockedItem('micropro')
	slots[15]:SetItemAndStack('micropro', 20)
	slots[15]:SetLockedItem('micropro')
	slots[16]:SetItemAndStack('micropro', 20)
	slots[16]:SetLockedItem('micropro')
	slots[17]:SetItemAndStack('micropro', 20)
	slots[17]:SetLockedItem('micropro')
	slots[18]:SetItemAndStack('micropro', 20)
	slots[18]:SetLockedItem('micropro')
	slots[19]:SetItemAndStack('micropro', 20)
	slots[19]:SetLockedItem('micropro')
	slots[20]:SetItemAndStack('micropro', 20)
	slots[20]:SetLockedItem('micropro')
	slots[21]:SetItemAndStack('micropro', 20)
	slots[21]:SetLockedItem('micropro')
	slots[22]:SetItemAndStack('micropro', 20)
	slots[22]:SetLockedItem('micropro')
	slots[23]:SetItemAndStack('micropro', 20)
	slots[23]:SetLockedItem('micropro')
	slots[24]:SetItemAndStack('micropro', 20)
	slots[24]:SetLockedItem('micropro')
	slots[25]:SetItemAndStack('micropro', 20)
	slots[25]:SetLockedItem('micropro')
	slots[26]:SetItemAndStack('micropro', 20)
	slots[26]:SetLockedItem('micropro')
	slots[27]:SetItemAndStack('micropro', 20)
	slots[27]:SetLockedItem('micropro')
	slots[28]:SetItemAndStack('micropro', 20)
	slots[28]:SetLockedItem('micropro')
	slots[29]:SetItemAndStack('micropro', 20)
	slots[29]:SetLockedItem('micropro')
	slots[30]:SetItemAndStack('micropro', 20)
	slots[30]:SetLockedItem('micropro')
	slots[31]:SetItemAndStack('micropro', 20)
	slots[31]:SetLockedItem('micropro')
	slots[32]:SetItemAndStack('micropro', 20)
	slots[32]:SetLockedItem('micropro')
	slots[33]:SetItemAndStack('micropro', 20)
	slots[33]:SetLockedItem('micropro')
	slots[34]:SetItemAndStack('micropro', 20)
	slots[34]:SetLockedItem('micropro')
	slots[35]:SetItemAndStack('micropro', 1)
	slots[35]:SetLockedItem('micropro')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -123, 209, 0)
	e:Place(-123, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 8)
	slots[1]:SetLockedItem('crystal')
	slots[2]:SetItemAndStack('reinforced_plate', 10)
	slots[2]:SetLockedItem('reinforced_plate')
	slots[3]:SetItemAndStack('energized_plate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 207, 2)
	e:Place(-113, 207, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 14)
	slots[1]:SetLockedItem('crystal')
	slots[2]:SetItemAndStack('reinforced_plate', 10)
	slots[2]:SetLockedItem('reinforced_plate')
	slots[3]:SetItemAndStack('energized_plate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -110, 207, 0)
	e:Place(-110, 207, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[1]:SetLockedItem('metalbar')
	slots[2]:SetItemAndStack('metalplate', 3)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -102, 212, 1)
	e:Place(-102, 212, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 8)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -140, 197, 0)
	e:Place(-140, 197, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 10)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -140, 196, 0)
	e:Place(-140, 196, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -140, 195, 0)
	e:Place(-140, 195, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 6)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -140, 190, 0)
	e:Place(-140, 190, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 14)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -140, 191, 0)
	e:Place(-140, 191, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -140, 192, 0)
	e:Place(-140, 192, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 10)
	slots[1]:SetLockedItem('aluminiumsheet')
	slots[2]:SetItemAndStack('smallreactor', 9)
	slots[2]:SetLockedItem('smallreactor')
	slots[3]:SetItemAndStack('engine', 20)
	slots[4]:SetItemAndStack('engine', 20)
	slots[5]:SetItemAndStack('engine', 20)
	slots[6]:SetItemAndStack('engine', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 188, 1)
	e:Place(-131, 188, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2d')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 10)
	slots[1]:SetLockedItem('reinforced_plate')
	slots[2]:SetItemAndStack('crystal', 17)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('transformer', 20)
	slots[3]:SetLockedItem('transformer')
	slots[4]:SetItemAndStack('transformer', 20)
	slots[4]:SetLockedItem('transformer')
	slots[5]:SetItemAndStack('transformer', 20)
	slots[5]:SetLockedItem('transformer')
	slots[6]:SetItemAndStack('transformer', 20)
	slots[6]:SetLockedItem('transformer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 196, 1)
	e:Place(-131, 196, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('blightbar', 8)
	slots[1]:SetLockedItem('blightbar')
	slots[2]:SetItemAndStack('transformer', 8)
	slots[2]:SetLockedItem('transformer')
	slots[3]:SetItemAndStack('smallreactor', 20)
	slots[4]:SetItemAndStack('smallreactor', 20)
	slots[5]:SetItemAndStack('smallreactor', 20)
	slots[6]:SetItemAndStack('smallreactor', 20)
	slots[7]:SetItemAndStack('smallreactor', 20)
	slots[8]:SetItemAndStack('smallreactor', 20)
	slots[9]:SetItemAndStack('smallreactor', 20)
	slots[10]:SetItemAndStack('smallreactor', 20)
	slots[11]:SetItemAndStack('smallreactor', 20)
	slots[12]:SetItemAndStack('smallreactor', 20)
	slots[13]:SetItemAndStack('smallreactor', 20)
	slots[14]:SetItemAndStack('smallreactor', 20)
	slots[15]:SetItemAndStack('smallreactor', 20)
	slots[16]:SetItemAndStack('smallreactor', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 192, 1)
	e:Place(-131, 192, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('transformer', 8)
	slots[1]:SetLockedItem('transformer')
	slots[2]:SetItemAndStack('wire', 8)
	slots[2]:SetLockedItem('wire')
	slots[3]:SetItemAndStack('ldframe', 8)
	slots[3]:SetLockedItem('ldframe')
	slots[4]:SetItemAndStack('microscope', 20)
	slots[4]:SetLockedItem('microscope')
	slots[5]:SetItemAndStack('microscope', 20)
	slots[6]:SetItemAndStack('microscope', 20)
	slots[7]:SetItemAndStack('microscope', 20)
	slots[8]:SetItemAndStack('microscope', 20)
	slots[9]:SetItemAndStack('microscope', 20)
	slots[10]:SetItemAndStack('microscope', 20)
	slots[11]:SetItemAndStack('microscope', 20)
	slots[12]:SetItemAndStack('microscope', 20)
	slots[13]:SetItemAndStack('microscope', 20)
	slots[14]:SetItemAndStack('microscope', 20)
	slots[15]:SetItemAndStack('microscope', 20)
	slots[16]:SetItemAndStack('microscope', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -131, 184, 1)
	e:Place(-131, 184, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_power_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -102, 187, 0)
	e:Place(-102, 187, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('refined_crystal', 12)
	slots[1]:SetLockedItem('refined_crystal')
	slots[2]:SetItemAndStack('cable', 1)
	slots[2]:SetLockedItem('cable')
	slots[3]:SetItemAndStack('optic_cable', 19)
	slots[4]:SetItemAndStack('optic_cable', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 215, 2)
	e:Place(-101, 215, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_robotics_factory')
	e:AddComponent('c_robotics_factory')
	slots = e.slots
	slots[1]:SetItemAndStack('hdframe', 1)
	slots[1]:SetLockedItem('hdframe')
	slots[2]:SetItemAndStack('crystal_powder', 18)
	slots[2]:SetLockedItem('crystal_powder')
	slots[3]:SetItemAndStack('robot_datacube', 20)
	slots[4]:SetItemAndStack('robot_datacube', 17)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 216, 1)
	e:Place(-125, 216, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('energized_plate', 11)
	slots[2]:SetItemAndStack('crystal_powder', 2)
	slots[3]:SetItemAndStack('refined_crystal', 20)
	slots[4]:SetItemAndStack('refined_crystal', 20)
	slots[5]:SetItemAndStack('refined_crystal', 20)
	slots[6]:SetItemAndStack('refined_crystal', 20)
	slots[7]:SetItemAndStack('refined_crystal', 15)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 221, 1)
	e:Place(-125, 221, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -87, 186, 0)
	e:Place(-87, 186, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 187, 0)
	e:Place(-86, 187, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -112, 178, 0)
	e:Place(-112, 178, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 179, 0)
	e:Place(-113, 179, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 178, 0)
	e:Place(-113, 178, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -86, 195, 0)
	e:Place(-86, 195, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -104, 227, 0)
	e:Place(-104, 227, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -119, 224, 0)
	e:Place(-119, 224, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -132, 216, 0)
	e:Place(-132, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 189, 0)
	e:Place(-135, 189, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_laser_turret')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -132, 181, 0)
	e:Place(-132, 181, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -132, 180, 0)
	e:Place(-132, 180, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	e.disconnected = false
	e:Place(-110, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	e.disconnected = false
	e:Place(-85, 221, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-87, 219, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_shield')
	slots = e.slots
	slots[1]:SetLockedItem()
	slots[2]:SetLockedItem()
	slots[3]:SetLockedItem()
	slots[4]:SetLockedItem()
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-135, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	slots = e.slots
	slots[1]:SetItemAndStack('human_datacube', 20)
	slots[2]:SetItemAndStack('virus_research_data', 20)
	slots[3]:SetItemAndStack('robot_datacube', 20)
	slots[4]:SetItemAndStack('datacube_matrix', 20)
	slots[6]:SetItemAndStack('transformer', 20)
	slots[7]:SetItemAndStack('transformer', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	e:Place(-128, 195, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	e.disconnected = false
	e:Place(-99, 214, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 3)
	e.disconnected = false
	e:Place(-104, 198, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1s_as')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	e.disconnected = false
	e:Place(-116, 197, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumrod', 1)
	e.disconnected = false
	e:Place(-122, 200, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-116, 194, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-87, 218, 3)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-103, 208, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-99, 205, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-119, 190, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e:Place(-129, 182, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 4)
	e.disconnected = false
	e:Place(-90, 218, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_missile_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 223, 1)
	e:Place(-129, 223, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -128, 222, 1)
	e:Place(-128, 222, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -128, 223, 0)
	e:Place(-128, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -83, 212, 0)
	e:Place(-83, 212, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -84, 213, 0)
	e:Place(-84, 213, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -82, 211, 0)
	e:Place(-82, 211, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[7]:SetItemAndStack('blight_extraction', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -133, 200, 1)
	e:Place(-133, 200, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1e')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_s')
	e:AddComponent('c_blight_container_s')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -133, 202, 1)
	e:Place(-133, 202, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 18)
	slots[2]:SetItemAndStack('metalplate', 17)
	slots[3]:SetItemAndStack('reinforced_plate', 20)
	slots[4]:SetItemAndStack('reinforced_plate', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -114, 219, 1)
	e:Place(-114, 219, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[2]:SetItemAndStack('metalplate', 10)
	slots[3]:SetItemAndStack('reinforced_plate', 20)
	slots[4]:SetItemAndStack('reinforced_plate', 20)
	slots[5]:SetItemAndStack('reinforced_plate', 20)
	slots[6]:SetItemAndStack('reinforced_plate', 20)
	slots[7]:SetItemAndStack('reinforced_plate', 20)
	slots[8]:SetItemAndStack('reinforced_plate', 16)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -114, 218, 1)
	e:Place(-114, 218, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_drone_launcher')
	slots = e.slots
	slots[1]:SetItemAndStack('micropro', 6)
	slots[2]:SetItemAndStack('engine', 6)
	slots[3]:SetItemAndStack('optic_cable', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -123, 198, 1)
	e:Place(-123, 198, 1)
	--
	e = Map.CreateEntity(f, 'f_building_sim')
	e.disconnected = false
	CreateFoundationsForEntity(e, -121, 201, 0)
	e:Place(-121, 201, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_power_unit')
	e.disconnected = false
	CreateFoundationsForEntity(e, -105, 224, 0)
	e:Place(-105, 224, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility_s')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	e:AddComponent('c_modulevisibility')
	e.disconnected = false
	CreateFoundationsForEntity(e, -87, 196, 0)
	e:Place(-87, 196, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_photon_cannon')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_missile_turret')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('c_signal_reader', 1)
	slots[2]:SetItemAndStack('c_signal_reader', 1)
	slots[3]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -101, 186, 2)
	e:Place(-101, 186, 2)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 10)
	slots[1]:SetLockedItem('reinforced_plate')
	slots[2]:SetItemAndStack('crystal', 10)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('transformer', 20)
	slots[3]:SetLockedItem('transformer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 196, 3)
	e:Place(-129, 196, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 10)
	slots[1]:SetLockedItem('aluminiumsheet')
	slots[2]:SetItemAndStack('smallreactor', 9)
	slots[2]:SetLockedItem('smallreactor')
	slots[3]:SetItemAndStack('engine', 20)
	slots[3]:SetLockedItem('engine')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 189, 3)
	e:Place(-129, 189, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('aluminiumsheet', 10)
	slots[1]:SetLockedItem('aluminiumsheet')
	slots[2]:SetItemAndStack('smallreactor', 9)
	slots[2]:SetLockedItem('smallreactor')
	slots[3]:SetItemAndStack('engine', 20)
	slots[3]:SetLockedItem('engine')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 188, 3)
	e:Place(-129, 188, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('blightbar', 8)
	slots[1]:SetLockedItem('blightbar')
	slots[2]:SetItemAndStack('transformer', 10)
	slots[2]:SetLockedItem('transformer')
	slots[3]:SetItemAndStack('smallreactor', 20)
	slots[3]:SetLockedItem('smallreactor')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 193, 3)
	e:Place(-129, 193, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('reinforced_plate', 8)
	slots[1]:SetLockedItem('reinforced_plate')
	slots[2]:SetItemAndStack('crystal', 8)
	slots[2]:SetLockedItem('crystal')
	slots[3]:SetItemAndStack('transformer', 20)
	slots[3]:SetLockedItem('transformer')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 197, 3)
	e:Place(-129, 197, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_human_factory_robots')
	slots = e.slots
	slots[1]:SetItemAndStack('blightbar', 10)
	slots[1]:SetLockedItem('blightbar')
	slots[2]:SetItemAndStack('transformer', 8)
	slots[2]:SetLockedItem('transformer')
	slots[3]:SetItemAndStack('smallreactor', 20)
	slots[3]:SetLockedItem('smallreactor')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 192, 3)
	e:Place(-129, 192, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 205, 0)
	e:Place(-135, 205, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 206, 0)
	e:Place(-135, 206, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 207, 0)
	e:Place(-135, 207, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 209, 0)
	e:Place(-135, 209, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 4)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 210, 0)
	e:Place(-135, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[3]:SetItemAndStack('blight_extraction', 2)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -135, 211, 0)
	e:Place(-135, 211, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2b')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_m')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	e:AddComponent('c_blight_container_i')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_plasma', 20)
	slots[2]:SetItemAndStack('blight_plasma', 20)
	slots[3]:SetItemAndStack('blight_plasma', 20)
	slots[4]:SetItemAndStack('blight_plasma', 20)
	slots[5]:SetItemAndStack('blight_plasma', 20)
	slots[6]:SetItemAndStack('blight_plasma', 20)
	slots[7]:SetItemAndStack('blight_extraction', 100)
	slots[8]:SetItemAndStack('blight_extraction', 100)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -133, 209, 3)
	e:Place(-133, 209, 3)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_blight_extractor')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 15)
	slots[2]:SetItemAndStack('blight_plasma', 18)
	slots[3]:SetItemAndStack('blight_plasma', 20)
	slots[4]:SetItemAndStack('blight_plasma', 20)
	slots[5]:SetItemAndStack('blight_plasma', 20)
	slots[6]:SetItemAndStack('blight_plasma', 20)
	slots[7]:SetItemAndStack('blight_plasma', 20)
	slots[8]:SetItemAndStack('blight_plasma', 7)
	slots[9]:SetItemAndStack('blight_extraction', 60)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -133, 213, 1)
	e:Place(-133, 213, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 2)
	slots[1]:SetLockedItem('metalbar')
	slots[2]:SetItemAndStack('metalplate', 18)
	slots[2]:SetLockedItem('metalplate')
	slots[3]:SetItemAndStack('reinforced_plate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 208, 1)
	e:Place(-107, 208, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_assembler')
	e:AddComponent('c_assembler')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalbar', 1)
	slots[1]:SetLockedItem('metalbar')
	slots[2]:SetItemAndStack('metalplate', 10)
	slots[2]:SetLockedItem('metalplate')
	slots[3]:SetItemAndStack('reinforced_plate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -107, 210, 1)
	e:Place(-107, 210, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[2]:SetItemAndStack('metalore', 11)
	table.insert(all_entities, e)
	e:Place(-101, 197, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[2]:SetItemAndStack('metalore', 8)
	table.insert(all_entities, e)
	e:Place(-99, 197, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_radar')
	e:AddComponent('c_laser_turret')
	CreateFoundationsForEntity(e, -132, 183, 2)
	e:Place(-132, 183, 2)
	--
	e = Map.CreateEntity(f, 'f_beacon')
	e.disconnected = false
	CreateFoundationsForEntity(e, -129, 220, 3)
	e:Place(-129, 220, 3)
	--
	e = Map.CreateEntity(f, 'f_beacon_l')
	slots = e.slots
	slots[1]:SetItemAndStack('circuit_board', 1)
	e.disconnected = false
	CreateFoundationsForEntity(e, -86, 188, 3)
	e:Place(-86, 188, 3)
	--
	e = Map.CreateEntity(f, 'f_beacon_l')
	slots = e.slots
	slots[1]:SetItemAndStack('circuit_board', 1)
	CreateFoundationsForEntity(e, -132, 179, 3)
	e:Place(-132, 179, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x2e')
	e:AddComponent('c_medium_storage')
	e:AddComponent('c_small_storage')
	e:AddComponent('c_small_storage')
	e:AddComponent('c_small_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 191, 0)
	e:Place(-117, 191, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_large_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -113, 203, 1)
	e:Place(-113, 203, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 202, 0)
	e:Place(-146, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 202, 0)
	e:Place(-145, 202, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 203, 0)
	e:Place(-146, 203, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 203, 0)
	e:Place(-145, 203, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 204, 0)
	e:Place(-146, 204, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 204, 0)
	e:Place(-145, 204, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 205, 0)
	e:Place(-146, 205, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 205, 0)
	e:Place(-145, 205, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -146, 206, 0)
	e:Place(-146, 206, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_blight_power')
	e:AddComponent('c_capacitor')
	e:AddComponent('c_blight_shield')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -145, 206, 0)
	e:Place(-145, 206, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1c')
	e:AddComponent('c_deconstructor')
	e:AddComponent('c_adv_portable_turret')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 203, 0)
	e:Place(-105, 203, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1b')
	e:AddComponent('c_human_factory_robots')
	e:AddComponent('c_radar')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -109, 203, 0)
	e:Place(-109, 203, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_repairport')
	e.disconnected = false
	CreateFoundationsForEntity(e, -105, 204, 0)
	e:Place(-105, 204, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 20)
	slots[2]:SetItemAndStack('crystal', 20)
	slots[3]:SetItemAndStack('crystal', 20)
	slots[4]:SetItemAndStack('crystal', 20)
	table.insert(all_entities, e)
	e:Place(-106, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 4)
	slots[2]:SetItemAndStack('crystal', 4)
	slots[3]:SetItemAndStack('silicon', 1)
	slots[4]:SetItemAndStack('cable', 20)
	slots[5]:SetItemAndStack('cable', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -114, 214, 0)
	e:Place(-114, 214, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 4)
	slots[2]:SetItemAndStack('crystal', 4)
	slots[3]:SetItemAndStack('silicon', 2)
	slots[4]:SetItemAndStack('cable', 20)
	slots[5]:SetItemAndStack('cable', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 214, 0)
	e:Place(-113, 214, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	slots = e.slots
	slots[1]:SetItemAndStack('wire', 4)
	slots[2]:SetItemAndStack('crystal', 4)
	slots[3]:SetItemAndStack('silicon', 2)
	slots[4]:SetItemAndStack('cable', 19)
	slots[5]:SetItemAndStack('cable', 20)
	slots[6]:SetItemAndStack('cable', 20)
	slots[7]:SetItemAndStack('cable', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -112, 214, 0)
	e:Place(-112, 214, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 3)
	slots[1]:SetLockedItem('silica')
	slots[2]:SetItemAndStack('metalplate', 19)
	slots[2]:SetLockedItem('metalplate')
	slots[3]:SetItemAndStack('wire', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -120, 211, 2)
	e:Place(-120, 211, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	slots[1]:SetLockedItem('silica')
	slots[2]:SetItemAndStack('metalplate', 11)
	slots[2]:SetLockedItem('metalplate')
	slots[3]:SetItemAndStack('wire', 12)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -117, 211, 2)
	e:Place(-117, 211, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_fabricator')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalplate', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -100, 210, 0)
	e:Place(-100, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_power_core')
	e:AddComponent('c_photon_cannon')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_repairer_aoe')
	e.disconnected = false
	CreateFoundationsForEntity(e, -101, 188, 0)
	e:Place(-101, 188, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_missile_turret')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_laser_turret')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -115, 178, 2)
	e:Place(-115, 178, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x2d')
	e:AddComponent('c_data_analyzer')
	e:AddComponent('c_photon_cannon')
	e:AddComponent('c_battery')
	CreateFoundationsForEntity(e, -111, 178, 2)
	e:Place(-111, 178, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_large_power_transmitter')
	e:AddComponent('c_photon_cannon')
	e:AddComponent('c_plasma_cannon')
	slots = e.slots
	slots[1]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -130, 178, 3)
	e:Place(-130, 178, 3)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_solar_panel')
	e:AddComponent('c_portable_turret_green')
	e:AddComponent('c_portable_turret')
	CreateFoundationsForEntity(e, -128, 178, 1)
	e:Place(-128, 178, 1)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_portable_turret_green')
	e:AddComponent('c_portable_turret')
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -105, 178, 1)
	e:Place(-105, 178, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_missile_turret')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	CreateFoundationsForEntity(e, -96, 186, 1)
	e:Place(-96, 186, 1)
	--
	e = Map.CreateEntity(f, 'f_building3x2a')
	e:AddComponent('c_missile_turret')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_photon_cannon')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	CreateFoundationsForEntity(e, -119, 225, 3)
	e:Place(-119, 225, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x2c')
	e:AddComponent('c_human_science_analyzer_robots')
	e:AddComponent('c_repairer')
	e:AddComponent('c_solar_panel')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -115, 226, 3)
	e:Place(-115, 226, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x1e')
	e:AddComponent('c_turret')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	CreateFoundationsForEntity(e, -113, 226, 0)
	e:Place(-113, 226, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1g')
	e:AddComponent('c_solar_panel')
	slots = e.slots
	slots[1]:SetItemAndStack('c_signal_reader', 1)
	slots[2]:SetItemAndStack('c_signal_reader', 1)
	slots[3]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -94, 222, 1)
	e:Place(-94, 222, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x2a')
	e:AddComponent('c_missile_turret')
	e:AddComponent('c_plasma_cannon')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	CreateFoundationsForEntity(e, -96, 223, 3)
	e:Place(-96, 223, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x1c')
	e:AddComponent('c_medium_capacitor')
	e:AddComponent('c_repairer')
	e.disconnected = false
	CreateFoundationsForEntity(e, -94, 223, 1)
	e:Place(-94, 223, 1)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_battery')
	e.disconnected = false
	CreateFoundationsForEntity(e, -94, 224, 1)
	e:Place(-94, 224, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1d')
	e:AddComponent('c_small_relay')
	e.disconnected = false
	CreateFoundationsForEntity(e, -87, 227, 0)
	e:Place(-87, 227, 0)
	--
	e = Map.CreateEntity(f, 'f_building3x2b')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_portable_turret')
	e:AddComponent('c_laser_turret')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -90, 226, 3)
	e:Place(-90, 226, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -84, 216, 0)
	e:Place(-84, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 216, 0)
	e:Place(-83, 216, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -84, 217, 0)
	e:Place(-84, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 217, 0)
	e:Place(-83, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -84, 218, 0)
	e:Place(-84, 218, 0)
	--
	e = Map.CreateEntity(f, 'f_building1x1b')
	e:AddComponent('c_wind_turbine_l')
	e.disconnected = false
	CreateFoundationsForEntity(e, -83, 218, 0)
	e:Place(-83, 218, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1e')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_battery')
	e:AddComponent('c_solar_cell')
	slots = e.slots
	slots[1]:SetItemAndStack('c_signal_reader', 1)
	slots[2]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -125, 195, 3)
	e:Place(-125, 195, 3)
	--
	e = Map.CreateEntity(f, 'f_building2x1e')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_medium_capacitor')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -126, 188, 2)
	e:Place(-126, 188, 2)
	--
	e = Map.CreateEntity(f, 'f_building2x1e')
	e:AddComponent('c_solar_cell')
	e:AddComponent('c_medium_capacitor')
	e:AddComponent('c_solar_cell')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -126, 190, 0)
	e:Place(-126, 190, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e:Place(-91, 197, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-86, 218, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-95, 211, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-95, 212, 3)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-120, 197, 0)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-90, 217, 3)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-105, 212, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-86, 217, 1)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e:Place(-102, 180, 2)
	--
	e = Map.CreateEntity(f, 'f_carrier_bot')
	e.disconnected = false
	e:Place(-92, 218, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_b')
	e:AddComponent('c_turret')
	e.disconnected = false
	e:Place(-89, 216, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_b')
	e:AddComponent('c_turret')
	e.disconnected = false
	e:Place(-95, 210, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_b')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	e:Place(-92, 214, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_b')
	e:AddComponent('c_photon_cannon')
	e.disconnected = false
	e:Place(-113, 210, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_laser_turret')
	e.disconnected = false
	e:Place(-108, 214, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_laser_turret')
	slots = e.slots
	slots[1]:SetItemAndStack('c_signal_reader', 1)
	e.disconnected = false
	e:Place(-119, 222, 3)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	e:Place(-102, 198, 2)
	--
	e = Map.CreateEntity(f, 'f_bot_1m_c')
	e:AddComponent('c_plasma_cannon')
	e.disconnected = false
	e:Place(-110, 214, 1)
	--
	e = Map.CreateEntity(f, 'f_building1x1a')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_drone_launcher')
	slots = e.slots
	slots[1]:SetItemAndStack('micropro', 6)
	slots[2]:SetItemAndStack('engine', 6)
	slots[3]:SetItemAndStack('optic_cable', 20)
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -113, 185, 1)
	e:Place(-113, 185, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_extractor')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 19)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	slots[4]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-128, 182, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_extractor')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 19)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	slots[4]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-124, 183, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_1m1s')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency_s')
	e:AddComponent('c_extractor')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('laterite', 19)
	slots[2]:SetItemAndStack('laterite', 20)
	slots[3]:SetItemAndStack('laterite', 20)
	slots[4]:SetItemAndStack('laterite', 20)
	table.insert(all_entities, e)
	e:Place(-124, 182, 3)
	--
	e = Map.CreateEntity(f, 'f_building1x1f')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 20)
	slots[1]:SetLockedItem('silica')
	slots[2]:SetItemAndStack('silica', 20)
	slots[2]:SetLockedItem('silica')
	slots[3]:SetItemAndStack('silica', 20)
	slots[3]:SetLockedItem('silica')
	slots[4]:SetItemAndStack('silica', 20)
	slots[4]:SetLockedItem('silica')
	slots[5]:SetItemAndStack('silica', 20)
	slots[5]:SetLockedItem('silica')
	slots[6]:SetItemAndStack('silica', 20)
	slots[6]:SetLockedItem('silica')
	slots[7]:SetItemAndStack('silica', 20)
	slots[7]:SetLockedItem('silica')
	slots[8]:SetItemAndStack('silica', 20)
	slots[8]:SetLockedItem('silica')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -85, 220, 1)
	e:Place(-85, 220, 1)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	table.insert(all_entities, e)
	e:Place(-83, 220, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	table.insert(all_entities, e)
	e:Place(-82, 220, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	table.insert(all_entities, e)
	e:Place(-84, 222, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('silica', 1)
	table.insert(all_entities, e)
	e:Place(-84, 223, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 1)
	table.insert(all_entities, e)
	e:Place(-108, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('crystal', 1)
	table.insert(all_entities, e)
	e:Place(-104, 217, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 15)
	table.insert(all_entities, e)
	e:Place(-103, 197, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_blight_shield')
	e:AddComponent('c_portable_radar')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 18)
	table.insert(all_entities, e)
	e:Place(-151, 208, 0)
	--
	e = Map.CreateEntity(f, 'f_bot_2s')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_adv_miner')
	e:AddComponent('c_blight_shield')
	e:AddComponent('c_portable_radar')
	slots = e.slots
	slots[1]:SetItemAndStack('blight_crystal', 18)
	slots[2]:SetItemAndStack('blight_crystal', 2)
	table.insert(all_entities, e)
	e:Place(-153, 210, 0)
	--
	e = Map.CreateEntity(f, 'f_building2x1a')
	e:AddComponent('c_refinery')
	e:AddComponent('c_refinery')
	e:AddComponent('c_internal_storage')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	e:AddComponent('c_moduleefficiency')
	slots = e.slots
	slots[1]:SetItemAndStack('metalore', 20)
	slots[1]:SetLockedItem('metalore')
	slots[2]:SetItemAndStack('laterite', 20)
	slots[2]:SetLockedItem('laterite')
	slots[3]:SetItemAndStack('silica', 20)
	slots[3]:SetLockedItem('silica')
	slots[4]:SetItemAndStack('aluminiumrod', 19)
	slots[4]:SetLockedItem('aluminiumrod')
	slots[5]:SetItemAndStack('aluminiumsheet', 19)
	slots[5]:SetLockedItem('aluminiumsheet')
	e.disconnected = false
	table.insert(all_entities, e)
	CreateFoundationsForEntity(e, -129, 184, 0)
	e:Place(-129, 184, 0)
	--
	e = all_entities[1] -- f_bot_1s_as (-103,203)
	e:SetRegister(5, { id = 'v_unsolved', num = 0 })
	--
	e = all_entities[2] -- f_bot_1s_adw (-102,197)
	e:SetRegister(2, { entity = Map.GetEntityAt(-101, 197) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[3] -- f_bot_1s_adw (-84,220)
	e:SetRegister(2, { entity = Map.GetEntityAt(-85, 220) })
	e:SetRegister(3, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(4, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silica', num = REG_INFINITE })
	--
	e = all_entities[4] -- f_spacedrop (-115,197)
	e:SetRegister(3, { id = 'c_deployer', num = 1 })
	--
	e = all_entities[5] -- f_spacedrop (-115,196)
	e:SetRegister(3, { id = 'c_deployer', num = 1 })
	--
	e = all_entities[6] -- f_spacedrop (-115,195)
	e:SetRegister(3, { id = 'c_deployer', num = 1 })
	--
	e = all_entities[7] -- f_bot_1m_c (-81,218)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[8] -- f_bot_1m1s (-125,183)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 184) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[9] -- f_bot_1m1s (-127,183)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 184) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[10] -- f_bot_1s_adw (-105,217)
	e:SetRegister(2, { entity = Map.GetEntityAt(-106, 217) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[11] -- f_bot_1s_adw (-107,217)
	e:SetRegister(2, { entity = Map.GetEntityAt(-106, 217) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[12] -- f_bot_1s_adw (-100,197)
	e:SetRegister(2, { entity = Map.GetEntityAt(-101, 197) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[13] -- f_bot_1s_adw (-84,221)
	e:SetRegister(2, { entity = Map.GetEntityAt(-85, 220) })
	e:SetRegister(3, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silica', num = REG_INFINITE })
	--
	e = all_entities[14] -- f_building1x1f (-105,214)
	e:SetRegister(2, { entity = Map.GetEntityAt(-106, 214) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[15] -- f_building1x1f (-105,215)
	e:SetRegister(2, { entity = Map.GetEntityAt(-106, 215) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[16] -- f_building1x1f (-106,215)
	e:SetRegister(2, { entity = Map.GetEntityAt(-105, 214) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[17] -- f_building1x1f (-106,214)
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[18] -- f_building1x1f (-100,200)
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[19] -- f_building1x1f (-100,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-101, 200) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[20] -- f_building1x1f (-101,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-100, 199) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[21] -- f_building1x1f (-101,200)
	e:SetRegister(2, { entity = Map.GetEntityAt(-100, 200) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[22] -- f_building1x1f (-86,220)
	e:SetRegister(2, { entity = Map.GetEntityAt(-87, 220) })
	--
	e = all_entities[23] -- f_building2x1g (-96,203)
	e:SetRegister(2, { entity = Map.GetEntityAt(-97, 205) })
	e:SetRegister(3, { id = 'hdframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'hdframe', num = 1 })
	e:SetRegister(5, { id = 'hdframe', num = REG_INFINITE })
	--
	e = all_entities[24] -- f_building2x1g (-96,206)
	e:SetRegister(2, { entity = Map.GetEntityAt(-97, 205) })
	e:SetRegister(3, { id = 'hdframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'hdframe', num = 1 })
	e:SetRegister(5, { id = 'hdframe', num = REG_INFINITE })
	--
	e = all_entities[25] -- f_building2x1a (-97,205)
	e:SetRegister(3, { id = 'hdframe', num = REG_INFINITE })
	--
	e = all_entities[26] -- f_building2x1c (-112,212)
	e:SetRegister(2, { entity = Map.GetEntityAt(-113, 211) })
	e:SetRegister(3, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(4, { id = 'cable', num = 1 })
	e:SetRegister(5, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(7, { id = 'cable', num = REG_INFINITE })
	--
	e = all_entities[27] -- f_building2x1c (-113,212)
	e:SetRegister(2, { entity = Map.GetEntityAt(-113, 211) })
	e:SetRegister(3, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(4, { id = 'cable', num = 1 })
	e:SetRegister(5, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(7, { id = 'cable', num = REG_INFINITE })
	--
	e = all_entities[28] -- f_building2x1c (-114,212)
	e:SetRegister(2, { entity = Map.GetEntityAt(-113, 211) })
	e:SetRegister(3, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(4, { id = 'cable', num = 1 })
	e:SetRegister(5, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(7, { id = 'cable', num = REG_INFINITE })
	--
	e = all_entities[29] -- f_building1x1d (-96,216)
	e:SetRegister(3, { id = 'silicon', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silicon', num = REG_INFINITE })
	--
	e = all_entities[30] -- f_building1x1d (-96,217)
	e:SetRegister(3, { id = 'silicon', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silicon', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = 6 })
	--
	e = all_entities[31] -- f_building2x1f (-95,216)
	e:SetRegister(3, { id = 'silicon', num = REG_INFINITE })
	e:SetRegister(4, { id = 'silicon', num = 1 })
	e:SetRegister(5, { id = 'silicon', num = REG_INFINITE })
	e:SetRegister(7, { id = 'v_enemy_faction', num = 0 })
	--
	e = all_entities[32] -- f_building2x1f (-95,217)
	e:SetRegister(3, { id = 'silicon', num = REG_INFINITE })
	e:SetRegister(4, { id = 'silicon', num = 1 })
	e:SetRegister(5, { id = 'silicon', num = REG_INFINITE })
	--
	e = all_entities[33] -- f_building1x1a (-79,218)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[34] -- f_building1x1a (-86,227)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[35] -- f_building2x2a (-119,210)
	e:SetRegister(3, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(4, { id = 'wire', num = 1 })
	e:SetRegister(5, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = 9 })
	e:SetRegister(7, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(8, { id = 'silica', num = 9 })
	--
	e = all_entities[36] -- f_building2x2a (-119,212)
	e:SetRegister(3, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(4, { id = 'wire', num = 1 })
	e:SetRegister(5, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = 10 })
	e:SetRegister(7, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(8, { id = 'silica', num = 9 })
	--
	e = all_entities[37] -- f_building1x1d (-106,198)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 4 })
	--
	e = all_entities[38] -- f_building1x1d (-107,198)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 8 })
	--
	e = all_entities[39] -- f_building1x1d (-108,198)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 5 })
	--
	e = all_entities[40] -- f_building1x1d (-109,198)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 3 })
	--
	e = all_entities[41] -- f_building1x1d (-110,198)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	--
	e = all_entities[42] -- f_building1x1d (-111,198)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 6 })
	--
	e = all_entities[43] -- f_building1x1d (-106,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 3 })
	--
	e = all_entities[44] -- f_building1x1d (-107,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 9 })
	--
	e = all_entities[45] -- f_building1x1d (-108,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 7 })
	--
	e = all_entities[46] -- f_building1x1d (-109,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	--
	e = all_entities[47] -- f_building1x1d (-110,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 9 })
	--
	e = all_entities[48] -- f_building1x1d (-111,199)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 205) })
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = 7 })
	--
	e = all_entities[49] -- f_building3x2a (-102,203)
	e:SetRegister(3, { id = 'metalplate', num = REG_INFINITE })
	--
	e = all_entities[50] -- f_building3x2a (-102,205)
	e:SetRegister(3, { id = 'metalbar', num = REG_INFINITE })
	--
	e = all_entities[51] -- f_building2x1e (-102,209)
	e:SetRegister(1, { entity = Map.GetEntityAt(-102, 209) })
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 203) })
	e:SetRegister(3, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(9, { id = 'metalplate', num = REG_INFINITE })
	--
	e = all_entities[52] -- f_building2x1a (-101,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 203) })
	e:SetRegister(3, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'metalplate', num = REG_INFINITE })
	--
	e = all_entities[53] -- f_building2x2f (-103,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 203) })
	e:SetRegister(3, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'metalplate', num = REG_INFINITE })
	--
	e = all_entities[54] -- f_building2x2a (-112,206)
	e:SetRegister(3, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'energized_plate', num = 1 })
	e:SetRegister(5, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(8, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(9, { id = 'reinforced_plate', num = 8 })
	--
	e = all_entities[55] -- f_building2x2a (-112,208)
	e:SetRegister(3, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'energized_plate', num = 1 })
	e:SetRegister(5, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(6, { id = 'reinforced_plate', num = 8 })
	e:SetRegister(8, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(9, { id = 'reinforced_plate', num = 8 })
	--
	e = all_entities[56] -- f_building1x1g (-126,184)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 185) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[57] -- f_building1x1g (-126,185)
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[58] -- f_building2x2f (-84,204)
	e:SetRegister(2, { entity = Map.GetEntityAt(-79, 225) })
	--
	e = all_entities[59] -- f_bot_1m1s (-128,183)
	e:SetRegister(2, { entity = Map.GetEntityAt(-127, 183) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[60] -- f_bot_1m1s (-126,183)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 184) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[61] -- f_building2x1f (-107,209)
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'reinforced_plate', num = 1 })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[62] -- f_building2x1d (-107,207)
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'reinforced_plate', num = 1 })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[63] -- f_building1x1d (-109,202)
	e:SetRegister(3, { id = 'foundationplate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'foundationplate', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalbar', num = 2 })
	--
	e = all_entities[64] -- f_building2x1a (-95,198)
	e:SetRegister(3, { id = 'circuit_board', num = REG_INFINITE })
	e:SetRegister(5, { id = 'circuit_board', num = REG_INFINITE })
	e:SetRegister(7, { id = 'circuit_board', num = REG_INFINITE })
	--
	e = all_entities[65] -- f_building2x1a (-96,198)
	e:SetRegister(3, { id = 'circuit_board', num = REG_INFINITE })
	e:SetRegister(5, { id = 'circuit_board', num = REG_INFINITE })
	e:SetRegister(7, { id = 'circuit_board', num = REG_INFINITE })
	--
	e = all_entities[66] -- f_building2x2d (-122,189)
	e:SetRegister(2, { entity = Map.GetEntityAt(-123, 190) })
	e:SetRegister(3, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(4, { id = 'aluminiumsheet', num = 2 })
	e:SetRegister(5, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(7, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(8, { id = 'silica', num = 9 })
	e:SetRegister(9, { id = 'aluminiumsheet', num = REG_INFINITE })
	--
	e = all_entities[67] -- f_building2x2a (-119,216)
	e:SetRegister(2, { entity = Map.GetEntityAt(-120, 217) })
	e:SetRegister(3, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(4, { id = 'aluminiumrod', num = 2 })
	e:SetRegister(5, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(6, { id = 'laterite', num = 5 })
	e:SetRegister(7, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(8, { id = 'laterite', num = 5 })
	e:SetRegister(9, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(10, { id = 'laterite', num = 5 })
	--
	e = all_entities[68] -- f_building2x2c (-125,202)
	e:SetRegister(2, { entity = Map.GetEntityAt(-117, 189) })
	e:SetRegister(3, { id = 'ldframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'ldframe', num = 10 })
	e:SetRegister(5, { id = 'ldframe', num = REG_INFINITE })
	--
	e = all_entities[69] -- f_building2x2b (-117,189)
	e:SetRegister(2, { entity = Map.GetEntityAt(-117, 191) })
	e:SetRegister(3, { id = 'micropro', num = REG_INFINITE })
	e:SetRegister(5, { id = 'micropro', num = REG_INFINITE })
	--
	e = all_entities[70] -- f_building1x1c (-136,202)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 200) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[71] -- f_building1x1c (-136,201)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 200) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[72] -- f_building1x1c (-136,203)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 200) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[73] -- f_building2x1b (-125,201)
	e:SetRegister(2, { entity = Map.GetEntityAt(-125, 202) })
	e:SetRegister(3, { id = 'ldframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'ldframe', num = 10 })
	e:SetRegister(5, { id = 'ldframe', num = REG_INFINITE })
	--
	e = all_entities[74] -- f_building2x1b (-125,204)
	e:SetRegister(2, { entity = Map.GetEntityAt(-125, 202) })
	e:SetRegister(3, { id = 'ldframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'ldframe', num = 10 })
	e:SetRegister(5, { id = 'ldframe', num = REG_INFINITE })
	--
	e = all_entities[75] -- f_building2x2d (-122,191)
	e:SetRegister(2, { entity = Map.GetEntityAt(-120, 190) })
	e:SetRegister(3, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(4, { id = 'aluminiumsheet', num = 2 })
	e:SetRegister(5, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(7, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(9, { id = 'aluminiumsheet', num = REG_INFINITE })
	--
	e = all_entities[76] -- f_building2x2a (-119,218)
	e:SetRegister(2, { entity = Map.GetEntityAt(-117, 217) })
	e:SetRegister(3, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(4, { id = 'aluminiumrod', num = 2 })
	e:SetRegister(5, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(6, { id = 'laterite', num = 5 })
	e:SetRegister(7, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(8, { id = 'laterite', num = 5 })
	e:SetRegister(9, { id = 'aluminiumrod', num = REG_INFINITE })
	--
	e = all_entities[77] -- f_building1x1a (-106,227)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[78] -- f_building1x1a (-105,227)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[79] -- f_building2x1b (-126,202)
	e:SetRegister(3, { id = 'ldframe', num = REG_INFINITE })
	--
	e = all_entities[80] -- f_building3x2b (-138,198)
	e:SetRegister(3, { id = 'blight_plasma', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_plasma', num = REG_INFINITE })
	e:SetRegister(7, { id = 'blight_crystal', num = 5 })
	e:SetRegister(8, { id = 'blight_plasma', num = REG_INFINITE })
	e:SetRegister(9, { id = 'blight_crystal', num = 5 })
	--
	e = all_entities[81] -- f_building2x1a (-117,206)
	e:SetRegister(3, { id = 'c_uplink', num = 2 })
	--
	e = all_entities[82] -- f_building2x1a (-117,208)
	e:SetRegister(3, { id = 'c_uplink', num = 2 })
	--
	e = all_entities[83] -- f_building2x1a (-117,207)
	e:SetRegister(3, { id = 'c_uplink', num = 2 })
	--
	e = all_entities[84] -- f_building1x1f (-130,213)
	e:SetRegister(2, { entity = Map.GetEntityAt(-129, 213) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	--
	e = all_entities[85] -- f_building1x1f (-129,213)
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	--
	e = all_entities[86] -- f_building1x1a (-131,210)
	e:SetRegister(3, { id = 'c_power_transmitter', num = 1 })
	e:SetRegister(5, { entity = Map.GetEntityAt(-151, 210) })
	--
	e = all_entities[87] -- f_bot_2s (-151,210)
	e:SetRegister(1, { entity = Map.GetEntityAt(-152, 209) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'blight_crystal', num = 0 })
	e:SetRegister(10, { entity = Map.GetEntityAt(-152, 209) })
	--
	e = all_entities[88] -- f_bot_1s_b (-141,211)
	e:SetRegister(1, { entity = Map.GetEntityAt(-151, 210) })
	e:SetRegister(2, { entity = Map.GetEntityAt(-130, 213) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	--
	e = all_entities[89] -- f_building1x1a (-130,216)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[90] -- f_building2x1a (-124,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-123, 209) })
	e:SetRegister(3, { id = 'micropro', num = REG_INFINITE })
	e:SetRegister(5, { id = 'micropro', num = REG_INFINITE })
	e:SetRegister(8, { id = 'micropro', num = REG_INFINITE })
	--
	e = all_entities[91] -- f_building2x1a (-125,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-124, 208) })
	e:SetRegister(3, { id = 'icchip', num = REG_INFINITE })
	e:SetRegister(5, { id = 'icchip', num = REG_INFINITE })
	e:SetRegister(8, { id = 'icchip', num = REG_INFINITE })
	--
	e = all_entities[92] -- f_building2x2b (-125,196)
	e:SetRegister(3, { id = 'blightbar', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blightbar', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalbar', num = 7 })
	--
	e = all_entities[93] -- f_building2x1d (-123,190)
	e:SetRegister(3, { id = 'aluminiumsheet', num = REG_INFINITE })
	--
	e = all_entities[94] -- f_building2x1d (-120,190)
	e:SetRegister(3, { id = 'aluminiumsheet', num = REG_INFINITE })
	--
	e = all_entities[95] -- f_building2x1d (-117,217)
	e:SetRegister(3, { id = 'aluminiumrod', num = REG_INFINITE })
	--
	e = all_entities[96] -- f_building2x1d (-120,217)
	e:SetRegister(3, { id = 'aluminiumrod', num = REG_INFINITE })
	--
	e = all_entities[97] -- f_building1x1a (-81,223)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[98] -- f_building1x1a (-88,187)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[99] -- f_building1x1a (-96,188)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[100] -- f_building1x1a (-104,181)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[101] -- f_building1x1a (-128,181)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[102] -- f_building2x1c (-125,220)
	e:SetRegister(3, { id = 'refined_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'refined_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'refined_crystal', num = REG_INFINITE })
	--
	e = all_entities[103] -- f_building2x1c (-125,219)
	e:SetRegister(3, { id = 'refined_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'refined_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'refined_crystal', num = REG_INFINITE })
	--
	e = all_entities[104] -- f_building1x1b (-101,178)
	e:SetRegister(3, { id = 'c_missile_turret', num = 1 })
	--
	e = all_entities[105] -- f_building1x1a (-119,223)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[106] -- f_building1x1a (-86,198)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[107] -- f_building1x1a (-123,178)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[108] -- f_building1x1a (-86,194)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[109] -- f_building1x1a (-102,178)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[110] -- f_building1x1a (-129,218)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[111] -- f_building1x1a (-136,189)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[112] -- f_building1x1a (-94,187)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[113] -- f_building1x1a (-94,186)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[114] -- f_building1x1a (-124,179)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[115] -- f_building1x1a (-137,191)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[116] -- f_building1x1a (-134,216)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[117] -- f_building1x1a (-117,227)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[118] -- f_building1x1a (-135,216)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[119] -- f_building1x1a (-101,179)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[120] -- f_building1x1a (-138,189)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[121] -- f_building1x1b (-133,216)
	e:SetRegister(3, { id = 'c_missile_turret', num = 1 })
	--
	e = all_entities[122] -- f_building1x1b (-124,178)
	e:SetRegister(3, { id = 'c_missile_turret', num = 1 })
	--
	e = all_entities[123] -- f_building1x1b (-137,189)
	e:SetRegister(3, { id = 'c_missile_turret', num = 1 })
	--
	e = all_entities[124] -- f_building2x1c (-97,210)
	e:SetRegister(3, { id = 'crystal_powder', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal_powder', num = REG_INFINITE })
	e:SetRegister(6, { id = 'crystal', num = 5 })
	e:SetRegister(7, { id = 'crystal_powder', num = REG_INFINITE })
	--
	e = all_entities[125] -- f_building2x1c (-97,211)
	e:SetRegister(3, { id = 'crystal_powder', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal_powder', num = REG_INFINITE })
	e:SetRegister(7, { id = 'crystal_powder', num = REG_INFINITE })
	e:SetRegister(8, { id = 'silica', num = 8 })
	--
	e = all_entities[126] -- f_building1x1a (-105,202)
	e:SetRegister(3, { id = 'c_drone_launcher', num = 1 })
	e:SetRegister(5, { id = 'f_drone_transfer_a', num = 6 })
	--
	e = all_entities[127] -- f_building1x1a (-89,218)
	e:SetRegister(3, { id = 'c_drone_launcher', num = 1 })
	e:SetRegister(5, { id = 'f_drone_transfer_a', num = 6 })
	--
	e = all_entities[128] -- f_building1x1b (-86,186)
	e:SetRegister(3, { id = 'c_missile_turret', num = 1 })
	--
	e = all_entities[129] -- f_building2x1a (-99,215)
	e:SetRegister(3, { id = 'optic_cable', num = REG_INFINITE })
	e:SetRegister(5, { id = 'optic_cable', num = REG_INFINITE })
	e:SetRegister(6, { id = 'cable', num = 9 })
	e:SetRegister(7, { id = 'optic_cable', num = REG_INFINITE })
	--
	e = all_entities[130] -- f_building2x1a (-100,215)
	e:SetRegister(3, { id = 'optic_cable', num = REG_INFINITE })
	e:SetRegister(5, { id = 'optic_cable', num = REG_INFINITE })
	e:SetRegister(6, { id = 'cable', num = 9 })
	e:SetRegister(7, { id = 'optic_cable', num = REG_INFINITE })
	--
	e = all_entities[131] -- f_building2x2b (-129,216)
	e:SetRegister(2, { entity = Map.GetEntityAt(-84, 204) })
	--
	e = all_entities[132] -- f_building2x1c (-119,196)
	e:SetRegister(3, { id = 'fused_electrodes', num = REG_INFINITE })
	e:SetRegister(5, { id = 'fused_electrodes', num = REG_INFINITE })
	e:SetRegister(7, { id = 'fused_electrodes', num = REG_INFINITE })
	--
	e = all_entities[133] -- f_building2x1c (-119,197)
	e:SetRegister(3, { id = 'fused_electrodes', num = REG_INFINITE })
	e:SetRegister(5, { id = 'fused_electrodes', num = REG_INFINITE })
	e:SetRegister(7, { id = 'fused_electrodes', num = REG_INFINITE })
	--
	e = all_entities[134] -- f_building2x2b (-119,178)
	e:SetRegister(2, { entity = Map.GetEntityAt(-115, 178) })
	--
	e = all_entities[135] -- f_building2x1d (-107,211)
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'reinforced_plate', num = 1 })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[136] -- f_building2x1g (-114,196)
	e:SetRegister(3, { id = 'infected_circuit_board', num = REG_INFINITE })
	e:SetRegister(5, { id = 'infected_circuit_board', num = REG_INFINITE })
	e:SetRegister(6, { id = 'bug_carapace', num = 1 })
	--
	e = all_entities[137] -- f_building2x1g (-87,222)
	e:SetRegister(3, { id = 'bug_carapace', num = REG_INFINITE })
	e:SetRegister(5, { id = 'bug_carapace', num = REG_INFINITE })
	--
	e = all_entities[138] -- f_building2x2c (-112,191)
	e:SetRegister(3, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(5, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(8, { id = 'datacube_matrix', num = REG_INFINITE })
	--
	e = all_entities[139] -- f_building2x1g (-97,206)
	e:SetRegister(2, { entity = Map.GetEntityAt(-97, 205) })
	e:SetRegister(3, { id = 'hdframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'hdframe', num = 1 })
	e:SetRegister(5, { id = 'hdframe', num = REG_INFINITE })
	--
	e = all_entities[140] -- f_building2x1g (-97,203)
	e:SetRegister(2, { entity = Map.GetEntityAt(-97, 205) })
	e:SetRegister(3, { id = 'hdframe', num = REG_INFINITE })
	e:SetRegister(4, { id = 'hdframe', num = 1 })
	e:SetRegister(5, { id = 'hdframe', num = REG_INFINITE })
	--
	e = all_entities[141] -- f_building2x1a (-125,214)
	e:SetRegister(3, { id = 'robot_datacube', num = REG_INFINITE })
	e:SetRegister(5, { id = 'robot_datacube', num = REG_INFINITE })
	e:SetRegister(8, { id = 'robot_datacube', num = REG_INFINITE })
	--
	e = all_entities[142] -- f_building2x1a (-125,215)
	e:SetRegister(3, { id = 'robot_datacube', num = REG_INFINITE })
	e:SetRegister(5, { id = 'robot_datacube', num = REG_INFINITE })
	e:SetRegister(8, { id = 'robot_datacube', num = REG_INFINITE })
	--
	e = all_entities[143] -- f_building3x2a (-123,182)
	e:SetRegister(2, { entity = Map.GetEntityAt(-121, 182) })
	e:SetRegister(3, { id = 'human_research', num = REG_INFINITE })
	e:SetRegister(6, { id = 'human_research', num = REG_INFINITE })
	e:SetRegister(7, { id = 'human_datacube', num = 3 })
	--
	e = all_entities[144] -- f_building3x2b (-113,189)
	e:SetRegister(3, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(6, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(7, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(12, { num = 255 })
	e:SetRegister(13, { num = 255 })
	e:SetRegister(14, { num = 255 })
	e:SetRegister(15, { num = 32 })
	--
	e = all_entities[145] -- f_building2x2b (-79,225)
	e:SetRegister(2, { entity = Map.GetEntityAt(-90, 226) })
	--
	e = all_entities[146] -- f_building3x2b (-121,182)
	e:SetRegister(3, { id = 'human_research', num = REG_INFINITE })
	e:SetRegister(6, { num = 255 })
	e:SetRegister(7, { num = 255 })
	e:SetRegister(8, { num = 0 })
	e:SetRegister(9, { num = 64 })
	--
	e = all_entities[147] -- f_building3x2b (-115,182)
	e:SetRegister(3, { id = 'virus_research', num = REG_INFINITE })
	e:SetRegister(6, { num = 0 })
	e:SetRegister(7, { num = 255 })
	e:SetRegister(9, { num = 64 })
	--
	e = all_entities[148] -- f_building3x2b (-109,182)
	e:SetRegister(3, { id = 'robot_research', num = REG_INFINITE })
	e:SetRegister(6, { num = 0 })
	e:SetRegister(7, { num = 0 })
	e:SetRegister(8, { num = 256 })
	e:SetRegister(9, { num = 64 })
	--
	e = all_entities[149] -- f_building3x2a (-111,182)
	e:SetRegister(2, { entity = Map.GetEntityAt(-109, 182) })
	e:SetRegister(3, { id = 'robot_research', num = REG_INFINITE })
	e:SetRegister(6, { id = 'robot_research', num = REG_INFINITE })
	--
	e = all_entities[150] -- f_building3x2a (-117,182)
	e:SetRegister(2, { entity = Map.GetEntityAt(-115, 182) })
	e:SetRegister(3, { id = 'virus_research', num = REG_INFINITE })
	e:SetRegister(6, { id = 'virus_research', num = REG_INFINITE })
	e:SetRegister(7, { id = 'virus_research_data', num = 4 })
	--
	e = all_entities[151] -- f_building3x2a (-105,182)
	e:SetRegister(2, { entity = Map.GetEntityAt(-103, 182) })
	e:SetRegister(3, { id = 'blight_research', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_research', num = REG_INFINITE })
	--
	e = all_entities[152] -- f_building3x2b (-103,182)
	e:SetRegister(3, { id = 'blight_research', num = REG_INFINITE })
	e:SetRegister(6, { num = 255 })
	e:SetRegister(7, { num = 0 })
	e:SetRegister(8, { num = 255 })
	e:SetRegister(9, { num = 64 })
	--
	e = all_entities[153] -- f_building2x1a (-113,191)
	e:SetRegister(2, { entity = Map.GetEntityAt(-112, 191) })
	e:SetRegister(3, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(5, { id = 'datacube_matrix', num = REG_INFINITE })
	e:SetRegister(8, { id = 'datacube_matrix', num = REG_INFINITE })
	--
	e = all_entities[154] -- f_building2x2c (-137,194)
	e:SetRegister(3, { id = 'blight_datacube', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blight_datacube', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_plasma', num = 7 })
	e:SetRegister(7, { id = 'blight_datacube', num = REG_INFINITE })
	e:SetRegister(8, { id = 'blight_plasma', num = 10 })
	--
	e = all_entities[155] -- f_building1x1a (-146,201)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[156] -- f_building1x1a (-145,198)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[157] -- f_building1x1a (-145,199)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[158] -- f_building1x1a (-145,200)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[159] -- f_building1x1a (-145,201)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[160] -- f_building1x1a (-146,200)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[161] -- f_building1x1a (-146,199)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[162] -- f_building1x1a (-146,198)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[163] -- f_bot_2s (-151,209)
	e:SetRegister(1, { entity = Map.GetEntityAt(-152, 209) })
	e:SetRegister(2, { entity = Map.GetEntityAt(-151, 210) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'blight_crystal', num = 0 })
	e:SetRegister(10, { entity = Map.GetEntityAt(-152, 209) })
	--
	e = all_entities[164] -- f_bot_2s (-152,210)
	e:SetRegister(1, { entity = Map.GetEntityAt(-152, 209) })
	e:SetRegister(2, { entity = Map.GetEntityAt(-151, 210) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'blight_crystal', num = 0 })
	e:SetRegister(10, { entity = Map.GetEntityAt(-152, 209) })
	--
	e = all_entities[165] -- f_building1x1a (-131,208)
	e:SetRegister(3, { id = 'c_power_transmitter', num = 1 })
	e:SetRegister(5, { entity = Map.GetEntityAt(-152, 210) })
	--
	e = all_entities[166] -- f_building1x1a (-131,209)
	e:SetRegister(3, { id = 'c_power_transmitter', num = 1 })
	e:SetRegister(5, { entity = Map.GetEntityAt(-151, 209) })
	--
	e = all_entities[167] -- f_building2x1a (-125,208)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 209) })
	e:SetRegister(3, { id = 'icchip', num = REG_INFINITE })
	e:SetRegister(5, { id = 'icchip', num = REG_INFINITE })
	e:SetRegister(8, { id = 'icchip', num = REG_INFINITE })
	--
	e = all_entities[168] -- f_building2x1a (-124,208)
	e:SetRegister(2, { entity = Map.GetEntityAt(-123, 209) })
	e:SetRegister(3, { id = 'micropro', num = REG_INFINITE })
	e:SetRegister(5, { id = 'micropro', num = REG_INFINITE })
	e:SetRegister(8, { id = 'micropro', num = REG_INFINITE })
	--
	e = all_entities[169] -- f_building2x1d (-126,209)
	e:SetRegister(3, { id = 'icchip', num = REG_INFINITE })
	--
	e = all_entities[170] -- f_building2x1d (-123,209)
	e:SetRegister(2, { entity = Map.GetEntityAt(-117, 189) })
	e:SetRegister(3, { id = 'micropro', num = REG_INFINITE })
	--
	e = all_entities[171] -- f_building2x1a (-113,207)
	e:SetRegister(3, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(8, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(9, { id = 'crystal', num = 4 })
	--
	e = all_entities[172] -- f_building2x1a (-110,207)
	e:SetRegister(3, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(6, { id = 'crystal', num = 2 })
	e:SetRegister(8, { id = 'energized_plate', num = REG_INFINITE })
	e:SetRegister(9, { id = 'crystal', num = 2 })
	--
	e = all_entities[173] -- f_building2x1a (-102,212)
	e:SetRegister(3, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'metalplate', num = REG_INFINITE })
	--
	e = all_entities[174] -- f_building1x1c (-140,197)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[175] -- f_building1x1c (-140,196)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[176] -- f_building1x1c (-140,195)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[177] -- f_building1x1c (-140,190)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[178] -- f_building1x1c (-140,191)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[179] -- f_building1x1c (-140,192)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[180] -- f_building2x2a (-131,188)
	e:SetRegister(2, { entity = Map.GetEntityAt(-117, 189) })
	e:SetRegister(3, { id = 'engine', num = REG_INFINITE })
	e:SetRegister(5, { id = 'engine', num = REG_INFINITE })
	--
	e = all_entities[181] -- f_building2x2d (-131,196)
	e:SetRegister(3, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(5, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(6, { id = 'reinforced_plate', num = 2 })
	e:SetRegister(7, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(8, { id = 'reinforced_plate', num = 2 })
	e:SetRegister(9, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(10, { id = 'reinforced_plate', num = 2 })
	--
	e = all_entities[182] -- f_building2x2c (-131,192)
	e:SetRegister(3, { id = 'smallreactor', num = REG_INFINITE })
	e:SetRegister(5, { id = 'smallreactor', num = REG_INFINITE })
	e:SetRegister(6, { id = 'transformer', num = 2 })
	--
	e = all_entities[183] -- f_building2x2c (-131,184)
	e:SetRegister(3, { id = 'microscope', num = REG_INFINITE })
	e:SetRegister(4, { id = 'microscope', num = 0 })
	e:SetRegister(5, { id = 'microscope', num = REG_INFINITE })
	--
	e = all_entities[184] -- f_building2x1a (-101,215)
	e:SetRegister(3, { id = 'optic_cable', num = REG_INFINITE })
	e:SetRegister(5, { id = 'optic_cable', num = REG_INFINITE })
	e:SetRegister(6, { id = 'cable', num = 9 })
	e:SetRegister(7, { id = 'optic_cable', num = REG_INFINITE })
	--
	e = all_entities[185] -- f_building2x1a (-125,216)
	e:SetRegister(3, { id = 'robot_datacube', num = REG_INFINITE })
	e:SetRegister(5, { id = 'robot_datacube', num = REG_INFINITE })
	e:SetRegister(8, { id = 'robot_datacube', num = REG_INFINITE })
	--
	e = all_entities[186] -- f_building2x1c (-125,221)
	e:SetRegister(3, { id = 'refined_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'refined_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'refined_crystal', num = REG_INFINITE })
	--
	e = all_entities[187] -- f_building1x1a (-87,186)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[188] -- f_building1x1a (-86,187)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[189] -- f_building1x1a (-112,178)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[190] -- f_building1x1a (-113,179)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[191] -- f_building1x1a (-113,178)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[192] -- f_building1x1a (-86,195)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[193] -- f_building1x1a (-104,227)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[194] -- f_building1x1a (-119,224)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[195] -- f_building1x1a (-132,216)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[196] -- f_building1x1a (-135,189)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[197] -- f_building1x1a (-132,181)
	e:SetRegister(3, { id = 'c_laser_turret', num = 1 })
	--
	e = all_entities[198] -- f_building1x1a (-132,180)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[199] -- f_bot_1s_as (-135,202)
	e:SetRegister(3, { id = 'c_blight_shield', num = 1 })
	--
	e = all_entities[200] -- f_bot_1s_as (-128,195)
	e:SetRegister(3, { id = 'c_blight_container_i', num = 1 })
	--
	e = all_entities[201] -- f_building1x1b (-129,223)
	e:SetRegister(3, { id = 'c_missile_turret', num = 1 })
	--
	e = all_entities[202] -- f_building1x1a (-128,222)
	e:SetRegister(3, { id = 'c_repairer', num = 1 })
	--
	e = all_entities[203] -- f_building1x1a (-128,223)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[204] -- f_building1x1a (-83,212)
	e:SetRegister(3, { id = 'c_plasma_cannon', num = 1 })
	--
	e = all_entities[205] -- f_building1x1a (-84,213)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[206] -- f_building1x1a (-82,211)
	e:SetRegister(3, { id = 'c_photon_cannon', num = 1 })
	--
	e = all_entities[207] -- f_building2x2b (-133,200)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[208] -- f_building2x1e (-133,202)
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[209] -- f_building2x1a (-114,219)
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[210] -- f_building2x1c (-114,218)
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[211] -- f_building1x1a (-123,198)
	e:SetRegister(3, { id = 'c_drone_launcher', num = 1 })
	e:SetRegister(5, { id = 'f_drone_transfer_a2', num = 6 })
	--
	e = all_entities[212] -- f_building3x2a (-101,186)
	e:SetRegister(2, { entity = Map.GetEntityAt(-125, 195) })
	--
	e = all_entities[213] -- f_building1x1b (-129,196)
	e:SetRegister(3, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(5, { id = 'transformer', num = REG_INFINITE })
	--
	e = all_entities[214] -- f_building1x1b (-129,189)
	e:SetRegister(3, { id = 'engine', num = REG_INFINITE })
	e:SetRegister(5, { id = 'engine', num = REG_INFINITE })
	--
	e = all_entities[215] -- f_building1x1b (-129,188)
	e:SetRegister(3, { id = 'engine', num = REG_INFINITE })
	e:SetRegister(5, { id = 'engine', num = REG_INFINITE })
	--
	e = all_entities[216] -- f_building1x1b (-129,193)
	e:SetRegister(3, { id = 'smallreactor', num = REG_INFINITE })
	e:SetRegister(5, { id = 'smallreactor', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blightbar', num = 2 })
	--
	e = all_entities[217] -- f_building1x1b (-129,197)
	e:SetRegister(3, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(5, { id = 'transformer', num = REG_INFINITE })
	e:SetRegister(6, { id = 'reinforced_plate', num = 2 })
	--
	e = all_entities[218] -- f_building1x1b (-129,192)
	e:SetRegister(3, { id = 'smallreactor', num = REG_INFINITE })
	e:SetRegister(5, { id = 'smallreactor', num = REG_INFINITE })
	e:SetRegister(6, { id = 'transformer', num = 2 })
	--
	e = all_entities[219] -- f_building1x1c (-135,205)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 202) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[220] -- f_building1x1c (-135,206)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 202) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[221] -- f_building1x1c (-135,207)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 202) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[222] -- f_building1x1c (-135,209)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 209) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[223] -- f_building1x1c (-135,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 209) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[224] -- f_building1x1c (-135,211)
	e:SetRegister(2, { entity = Map.GetEntityAt(-133, 209) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[225] -- f_building2x2b (-133,209)
	e:SetRegister(1, { entity = Map.GetEntityAt(-133, 209) })
	e:SetRegister(3, { id = 'blight_extraction', num = REG_INFINITE })
	--
	e = all_entities[226] -- f_building3x2b (-133,213)
	e:SetRegister(3, { id = 'blight_plasma', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_plasma', num = REG_INFINITE })
	e:SetRegister(8, { id = 'blight_plasma', num = REG_INFINITE })
	--
	e = all_entities[227] -- f_building2x1a (-107,208)
	e:SetRegister(2, { entity = Map.GetEntityAt(-107, 207) })
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[228] -- f_building2x1a (-107,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-107, 211) })
	e:SetRegister(3, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'reinforced_plate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'reinforced_plate', num = REG_INFINITE })
	--
	e = all_entities[229] -- f_bot_2s (-101,197)
	e:SetRegister(2, { entity = Map.GetEntityAt(-101, 199) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[230] -- f_bot_2s (-99,197)
	e:SetRegister(2, { entity = Map.GetEntityAt(-100, 197) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[231] -- f_building2x2e (-117,191)
	e:SetRegister(2, { entity = Map.GetEntityAt(-116, 202) })
	e:SetRegister(3, { id = 'micropro', num = REG_INFINITE })
	--
	e = all_entities[232] -- f_building1x1a (-146,202)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[233] -- f_building1x1a (-145,202)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[234] -- f_building1x1a (-146,203)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[235] -- f_building1x1a (-145,203)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[236] -- f_building1x1a (-146,204)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[237] -- f_building1x1a (-145,204)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[238] -- f_building1x1a (-146,205)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[239] -- f_building1x1a (-145,205)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[240] -- f_building1x1a (-146,206)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[241] -- f_building1x1a (-145,206)
	e:SetRegister(3, { id = 'c_blight_power', num = 1 })
	--
	e = all_entities[242] -- f_building1x1c (-105,203)
	e:SetRegister(3, { id = 'c_deconstructor', num = 1 })
	--
	e = all_entities[243] -- f_building2x1b (-109,203)
	e:SetRegister(7, { id = 'v_enemy_faction', num = 0 })
	--
	e = all_entities[244] -- f_bot_2s (-106,217)
	e:SetRegister(2, { entity = Map.GetEntityAt(-105, 215) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[245] -- f_building2x1c (-114,214)
	e:SetRegister(3, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(4, { id = 'cable', num = 1 })
	e:SetRegister(5, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(7, { id = 'cable', num = REG_INFINITE })
	--
	e = all_entities[246] -- f_building2x1c (-113,214)
	e:SetRegister(3, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(4, { id = 'cable', num = 1 })
	e:SetRegister(5, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(7, { id = 'cable', num = REG_INFINITE })
	--
	e = all_entities[247] -- f_building2x1c (-112,214)
	e:SetRegister(3, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(4, { id = 'cable', num = 1 })
	e:SetRegister(5, { id = 'cable', num = REG_INFINITE })
	e:SetRegister(6, { id = 'wire', num = 8 })
	e:SetRegister(7, { id = 'cable', num = REG_INFINITE })
	--
	e = all_entities[248] -- f_building2x1a (-120,211)
	e:SetRegister(2, { entity = Map.GetEntityAt(-119, 210) })
	e:SetRegister(3, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(5, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = 7 })
	e:SetRegister(7, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(8, { id = 'silica', num = 8 })
	--
	e = all_entities[249] -- f_building2x1a (-117,211)
	e:SetRegister(2, { entity = Map.GetEntityAt(-119, 212) })
	e:SetRegister(3, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(5, { id = 'wire', num = REG_INFINITE })
	e:SetRegister(7, { id = 'wire', num = REG_INFINITE })
	--
	e = all_entities[250] -- f_building2x1a (-100,210)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 203) })
	e:SetRegister(3, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(4, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalplate', num = REG_INFINITE })
	e:SetRegister(7, { id = 'metalplate', num = REG_INFINITE })
	--
	e = all_entities[251] -- f_building2x2c (-115,178)
	e:SetRegister(2, { entity = Map.GetEntityAt(-105, 178) })
	--
	e = all_entities[252] -- f_building2x2a (-130,178)
	e:SetRegister(2, { entity = Map.GetEntityAt(-119, 178) })
	--
	e = all_entities[253] -- f_building3x2b (-105,178)
	e:SetRegister(2, { entity = Map.GetEntityAt(-101, 186) })
	--
	e = all_entities[254] -- f_building2x2c (-115,226)
	e:SetRegister(2, { entity = Map.GetEntityAt(-129, 216) })
	--
	e = all_entities[255] -- f_building2x1g (-94,222)
	e:SetRegister(2, { entity = Map.GetEntityAt(-115, 226) })
	--
	e = all_entities[256] -- f_building3x2b (-90,226)
	e:SetRegister(2, { entity = Map.GetEntityAt(-94, 222) })
	--
	e = all_entities[257] -- f_building2x1e (-125,195)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 190) })
	--
	e = all_entities[258] -- f_building2x1e (-126,188)
	e:SetRegister(2, { entity = Map.GetEntityAt(-130, 178) })
	--
	e = all_entities[259] -- f_building2x1e (-126,190)
	e:SetRegister(2, { entity = Map.GetEntityAt(-126, 188) })
	--
	e = all_entities[260] -- f_building1x1a (-113,185)
	e:SetRegister(3, { id = 'c_drone_launcher', num = 1 })
	e:SetRegister(5, { id = 'f_drone_transfer_a2', num = 6 })
	--
	e = all_entities[261] -- f_bot_1m1s (-128,182)
	e:SetRegister(2, { entity = Map.GetEntityAt(-128, 183) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[262] -- f_bot_1m1s (-124,183)
	e:SetRegister(2, { entity = Map.GetEntityAt(-125, 183) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[263] -- f_bot_1m1s (-124,182)
	e:SetRegister(2, { entity = Map.GetEntityAt(-124, 183) })
	e:SetRegister(3, { id = 'laterite', num = REG_INFINITE })
	e:SetRegister(5, { id = 'laterite', num = REG_INFINITE })
	--
	e = all_entities[264] -- f_building1x1f (-85,220)
	e:SetRegister(2, { entity = Map.GetEntityAt(-86, 220) })
	--
	e = all_entities[265] -- f_bot_2s (-83,220)
	e:SetRegister(2, { entity = Map.GetEntityAt(-84, 220) })
	e:SetRegister(3, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = REG_INFINITE })
	--
	e = all_entities[266] -- f_bot_2s (-82,220)
	e:SetRegister(2, { entity = Map.GetEntityAt(-83, 220) })
	e:SetRegister(3, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = REG_INFINITE })
	--
	e = all_entities[267] -- f_bot_2s (-84,222)
	e:SetRegister(2, { entity = Map.GetEntityAt(-84, 221) })
	e:SetRegister(3, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = REG_INFINITE })
	--
	e = all_entities[268] -- f_bot_2s (-84,223)
	e:SetRegister(2, { entity = Map.GetEntityAt(-84, 222) })
	e:SetRegister(3, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(5, { id = 'silica', num = REG_INFINITE })
	e:SetRegister(6, { id = 'silica', num = REG_INFINITE })
	--
	e = all_entities[269] -- f_bot_2s (-108,217)
	e:SetRegister(2, { entity = Map.GetEntityAt(-107, 217) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[270] -- f_bot_2s (-104,217)
	e:SetRegister(2, { entity = Map.GetEntityAt(-105, 217) })
	e:SetRegister(3, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'crystal', num = REG_INFINITE })
	--
	e = all_entities[271] -- f_bot_2s (-103,197)
	e:SetRegister(2, { entity = Map.GetEntityAt(-102, 197) })
	e:SetRegister(3, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(5, { id = 'metalore', num = REG_INFINITE })
	e:SetRegister(6, { id = 'metalore', num = REG_INFINITE })
	--
	e = all_entities[272] -- f_bot_2s (-151,208)
	e:SetRegister(1, { entity = Map.GetEntityAt(-152, 209) })
	e:SetRegister(2, { entity = Map.GetEntityAt(-151, 209) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'blight_crystal', num = 1 })
	e:SetRegister(10, { entity = Map.GetEntityAt(-152, 209) })
	--
	e = all_entities[273] -- f_bot_2s (-153,210)
	e:SetRegister(1, { entity = Map.GetEntityAt(-152, 209) })
	e:SetRegister(2, { entity = Map.GetEntityAt(-152, 210) })
	e:SetRegister(3, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(4, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(5, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(6, { id = 'blight_crystal', num = REG_INFINITE })
	e:SetRegister(7, { id = 'blight_crystal', num = 1 })
	e:SetRegister(10, { entity = Map.GetEntityAt(-152, 209) })
	--
	e = all_entities[274] -- f_building2x1a (-129,184)
	e:SetRegister(5, { id = 'aluminiumrod', num = REG_INFINITE })
	e:SetRegister(7, { id = 'aluminiumsheet', num = REG_INFINITE })
	e:SetRegister(8, { id = 'aluminiumrod', num = 9 })
	--
end
