data.world_events = {}

-------- DEBUG
local debugevent = {}
function debugevent:GetPossibility() print("GetPossibility") return 999999.0 end
function debugevent:Init(event) print("Init") return 50 end
function debugevent:Start(event) print("Start") end
function debugevent:SimulationTick(event_data) print("SimulationTick") return false end

-------- EMPTY
local empty = {}
function empty:GetPossibility() return 10.0 end
function empty:SimulationTick(event_data) return false end

-------- DUST STORM
local dust_storm = {}
function dust_storm:GetPossibility()
	local chance = 1.0
	local stability = StabilityGet()
	if stability > 6000 then chance = 3.0
	elseif stability > 3000 then chance = 2.0
	end

	return(Map.GetTotalDays() > 10) and chance or 0.0
end

function dust_storm:Init(event_data)
	event_data.timer = 0
	local stability = StabilityGet() // 10
	event_data.duration = math.min(1000 + stability, 500)
	UI.Run("NotifyDust", "Blight Storm Approaching")
	return 300
end
function dust_storm:Start(event)
	Map.GetSave().dust_storm = true
	UI.Run("NotifyDust", "Blight Storm Imminent")
end
function dust_storm:SimulationTick(event_data)
	local t = event_data.timer + 1
	event_data.timer = t
	local eff = 0.2
	local bseff = 0.01
	if t < 10 then
		-- fading in
		eff = (t/10)*eff
		bseff = eff * 0.03
	elseif event_data.duration - t < 10 then
		-- fading out
		eff = (((event_data.duration - t))/50)*eff
		bseff = eff * 0.03
	end

	--print(t .. " - " .. bseff)

	if event_data.timer <= 0 then
		event_data.mode = event_data.mode + 1
	end

	UI.Run(function() View.SetPostProcess("BlightStorm", bseff) end)
	if event_data.timer >= event_data.duration then
		Map.GetSave().dust_storm = false
		return false
	end

	return true
end

------ ROAMING BOT
local roaming_bot = {}
function roaming_bot:GetPossibility()
	local robot_base = Map.GetSave().robot_base
	if not robot_base or not robot_base:ExistsOnFaction("anomaly") then return 0.0 end

	-- occur more when unstable
	local stability = StabilityGet()
	if stability < -6000 then return 4.0 end
	if stability < -3000 then return 2.0 end
	if stability < -0 then return 1.0 end
	return 0.5
end
function roaming_bot:SimulationTick(event) return false end
function roaming_bot:Init(event)
	local robot_base = Map.GetSave().robot_base
	UI.Run("NotifyAnomaly", robot_base and robot_base:ExistsOnFaction("anomaly") and robot_base or nil, true)
	return 100
end
function roaming_bot:Start(event)
	for _,faction in ipairs(Map.GetFactions()) do
		if faction.is_player_controlled then
			local loc_x, loc_y = faction:FindClosestHiddenTile(faction.home_location.x+math.random(-30, 30), faction.home_location.y+math.random(-30, 30), 5000, true)
			if loc_x then
				local rnd = math.random(3)
				local bots = { "v_robot_s", "v_robot2", "v_robot3", "v_robot4", "v_explorable_bot", "v_explorable_bot2" }
				local cube_reward = { 'robot_datacube', 'human_datacube', 'alien_datacube', 'virus_research_data', 'blight_datacube' }
				local rewards = {}
				for k,v in ipairs(cube_reward) do
					if faction:IsUnlocked(v) then
						rewards[#rewards+1] = v
					end
				end
				local reward = #rewards > 0 and rewards[math.random(1, #rewards)] or 'robot_datacube'
				if rnd == 1 then
					-- hostile bot
					rnd = math.random(#bots)
					local bot = Map.CreateEntity("world", "f_roamingbot", bots[rnd])
					bot:Place(loc_x, loc_y)
					bot:AddComponent("c_glitch", "hidden")
					bot:AddComponent("c_virus_protection", "hidden")

					local ai_comp = bot:AddComponent("c_ai_bot_behavior", "hidden")
					ai_comp.extra_data.last_trigger_time = Map.GetTick()
					local player_lvl = GetPlayerFactionLevel(faction) - math.random(-1,5)
					local counters = faction.extra_data.counters
					--[[
					local bugs_killed = (counters and counters.BugsKilled)
					if bugs_killed then player_lvl = player_lvl + (bugs_killed // 10) end
					--]]

					local stability = StabilityGet()
					if stability < -6000 then bot:AddComponent("c_virus_jamming", "hidden")
					elseif stability < -3000 then bot:AddComponent("c_virus_bitlock", "hidden")
					end

					if player_lvl < 30 then bot:AddComponent("c_portable_turret", "hidden")
					elseif player_lvl < 60 then bot:AddComponent("c_turret", "hidden")
					elseif player_lvl < 80 then bot:AddComponent("c_laser_turret", "hidden")
					elseif player_lvl < 140 then bot:AddComponent("c_alien_attack", "hidden")
					end
					bot:AddItem(reward, 1)
					faction:RunUI("NotifyAnomaly", bot)
				elseif rnd == 2 then
					-- random bot that follows you
					rnd = math.random(#bots)
					local bot = Map.CreateEntity("world", "f_roamingbot", bots[rnd])
					bot:Place(loc_x, loc_y)
					bot:AddComponent("c_glitch", "hidden")
					bot:AddComponent("c_ai_bot_behavior", "hidden")
					bot:AddComponent("c_virus_protection", "hidden")
					bot:AddItem(reward, 1)

					bot:MoveTo(faction.home_location)
					faction:RunUI("NotifyAnomaly", bot)
				elseif rnd == 3 then -- random building
					local random_building = { "v_explorable_glitchbuilding", "v_energystorage" }
					rnd = math.random(#random_building)

					local building = Map.CreateEntity("world", "f_explorable", random_building[rnd])
					building:Place(loc_x, loc_y)

					--building.lootable = true
					building:AddComponent("c_glitch", "hidden")
					building:AddComponent("c_disappear_empty", "hidden")
					building:AddComponent("c_explorable_autosolve", "hidden"):SetRegister(1, { id = 'robot_datacube', num = 1})
					building:AddComponent("c_virus_protection", "hidden")
					Map.Delay("DelayedDestroyEntity", 500, { ent = building, nodrop = true })
					faction:RunUI("NotifyAnomaly", building)
				end

				--local ai = bot:AddComponent("c_ai_bot_behavior", "hidden")
				--ai.extra_data.target = faction.home_entity
				--bot:AddItem("robot_datacube", 2)
				--bot:MoveTo(faction.home_location)
				--print("[roaming_bot] ", bot)
			end
		end
	end
end


------ CRAZY BUG
local crazy_bug = {}
function crazy_bug:GetPossibility()
	if Map.GetSettings().peaceful ~= 3 then return 0.0 end
	local next_bugs = Map.GetSave().next_bugs
	if not next_bugs then Map.GetSave().next_bugs = 4000 next_bugs = 4000 end
	--print(Map.GetSave().next_bugs, Map.GetTick())
	if Map.GetTick() < next_bugs then return 0.0 end
	-- its time
	return 160.0
end

function crazy_bug:SimulationTick(event) return false end

function crazy_bug:Init(event) return 50 end

function crazy_bug:Start(event)
	--print("crazybug")
	local waittime = 2000
	local bugs = GetBugsFaction()
	local max = ((Map.GetTotalDays() // 3) +1) * Map.GetPlayerFactionCount()
	local max_bugs = 2000 * Map.GetPlayerFactionCount()
	local all_large = bugs:GetEntitiesWithId("f_bug_hive_large")
	if #all_large < max and bugs.num_entities < 2000 then
		-- find a hidden
		local all_hives = bugs:GetEntitiesWithId("f_bug_hive")
		if #all_hives == 0 then all_hives = bugs:GetEntitiesWithId("f_bug_hole") end
		if #all_hives > 0 then
			local spawn_at = all_hives[math.random(1, #all_hives)]
			Map.Defer(function()
				--print("- scout")
				local scout = Map.CreateEntity(bugs, "f_triloscout")
				scout:Place(spawn_at.location)
				scout:FindComponent("c_bug_harvest").extra_data.home = spawn_at
			end)
		else
			-- no more bugs, spawn a new chunk?
			--print("- new chunk")
			local x, y = Map.GetUndiscoveredLocation()
			Map.SpawnChunks(x, y)
		end
	else
		--print("already enough hives", #all_large, bugs.num_entities)
		waittime = 4000
	end
	Map.GetSave().next_bugs = Map.GetTick() + waittime
end

data.world_events.crazy_bug = crazy_bug

-----------------------------------------------------------------
------ WORLD EVENTS TICKER

local function SelectWorldEvents()
	local all_possibilities = {}
	local total_possibility = 0.0
	local events = Map.GetSave().world_events
	local lastevent = events and events.lastEvent
	if lastevent == "empty" then lastevent = nil end
	for name, event in pairs(data.world_events) do
		local possibility = event:GetPossibility()
		if name ~= lastevent and possibility > 0.0 then
			all_possibilities[#all_possibilities + 1] = { name, possibility }
			total_possibility = total_possibility + possibility
		end
	end

	if total_possibility > 0.0 then
		local random = math.random() * total_possibility
		local temp_v = 0.0
		local result_event = nil
		for i, v in ipairs(all_possibilities) do
			local name, possibility = table.unpack(v)
			temp_v = temp_v + possibility
			if temp_v >= random then
				result_event = name
				break
			end
		end
		return result_event
	end
end

function MapMsg.OnTick()
	local events = Map.GetSave().world_events
	if not events or type(events) ~= "table" then
		events = {}
		Map.GetSave().world_events = events
	end

	if not events.tick_list or type(events.tick_list) ~= "table" then
		events.tick_list = {}
	end
	local tickList = events.tick_list

	if not events.timer or type(events.timer) ~= "number" then
		events.timer = 8000 -- first event happens after this many ticks
	end

	--for debug
	if not events.count or type(events.count) ~= "number" then
		events.count = 0
	end

	events.timer = events.timer - 1
	--print(events.timer)
	if events.timer <= 0 then
		local nextEvent = SelectWorldEvents()
		if nextEvent then
			local newTick = { name = nextEvent, data = { count = events.count } }
			tickList[#tickList + 1] = newTick

			local next_timer
			if data.world_events[nextEvent].Init then
				tickList[#tickList].starttimer, next_timer = data.world_events[nextEvent]:Init(tickList[#tickList].data) or 1 -- data = event instance
			end
			events.count = events.count + 1
			events.timer = next_timer or math.random(500, 1000) -- how often to have a world event
			events.lastEvent = nextEvent
		end
	end

	for i = #tickList, 1, -1 do
		local def = data.world_events[tickList[i].name]
		if not def then
			table.remove(tickList, i)
		elseif tickList[i].starttimer and tickList[i].starttimer > 0 then
			tickList[i].starttimer = tickList[i].starttimer - 1
			if tickList[i].starttimer == 0 and def.Start then
				def:Start(tickList[i].data)
			end
		else
			if not def:SimulationTick(tickList[i].data) then
				table.remove(tickList, i)
			end
		end
	end
end

local cache_drop = {}

function cache_drop:GetPossibility()
	local stability = StabilityGet()
	-- Lower stability = more frequent drops
	if stability < -6000 then return 2.5
	elseif stability < -3000 then return 2.0
	elseif stability < -1000 then return 1.0
	elseif stability < 1000 then return 0.0
	elseif stability < 3000 then return 1.0
	elseif stability < 6000 then return 2.0
	else return 2.5 end
end

function cache_drop:Init(event) return 1 end

function cache_drop:Start(event_data)
	local stability = StabilityGet()
	local valid_factions = {}
	for _, faction in ipairs(Map.GetFactions()) do
		if faction.has_logged_in_player and faction:IsUnlocked("t_blight_protection") then
			valid_factions[#valid_factions + 1] = faction
		end
	end

	if #valid_factions == 0 then return end
	local faction = valid_factions[math.random(#valid_factions)]

	local loc_x, loc_y = faction:FindClosestHiddenTile(faction.home_location.x + math.random(-50, 50), faction.home_location.y + math.random(-50, 50), 10000, true)
	if loc_x and loc_y then
		if stability > 0 then
			local unit = Map.CreateEntity(GetAlienFaction(), "f_alien_scout_probe")
			unit:Place(loc_x, loc_y)
			unit:AddComponent("c_virus_protection", "hidden")
			unit:AddComponent("c_alien_scout_terraformer", "hidden")
			unit:AddItem("blight_plasma", 10)
			local duration = (stability//20)+1
			Map.Delay("DelayedDestroyEntity", duration, { ent = unit, nodrop = true })
			local loc2_x = faction.home_location.x - (loc_x-faction.home_location.x) + math.random(-400, 400)
			local loc2_y = faction.home_location.y - (loc_y-faction.home_location.y) + math.random(-400, 400)
			unit:MoveTo(loc2_x , loc2_y)
			UI.Run(function()
				local loc = unit.location
				Notification.Add("scout_drop", "info", "Particle clusters gathering", "Blight Detected", {
					duration = 10.0,
					on_click = function() View.MoveCamera(loc.x, loc.y) end,
				})
			end)
		else
			local drop = Map.CreateEntity("world", "f_explorable", "v_explorable_brokenship_1")
			drop:AddComponent("c_glitch", "hidden")  -- Optional flair
			drop:AddComponent("c_disappear_empty", "hidden")
			drop:AddComponent("c_explorable_autosolve", "hidden"):SetRegister(1, { id = 'virus_research_data', num = 1})
			drop:AddComponent("c_virus_protection", "hidden")
			Map.Delay("DelayedDestroyEntity", 1000, { ent = drop, nodrop = true })

			drop:Place(loc_x, loc_y)
			local level = math.min(math.abs(stability//1000)+1, 3)
			drop:AddItem(GenerateRobotRewardComp(level), 1)
			UI.Run(function()
				Notification.Add("cache_drop", "info", "Particle clusters gathering", "Glitch Detected", {
					duration = 10.0,
					on_click = function() if drop.exists then View.JumpCameraToEntities(drop) end end,
				})
			end)
		end
	end
end

function cache_drop:SimulationTick(event_data)
	-- No ongoing simulation needed
	return false
end

data.world_events.cache_drop = cache_drop
--data.world_events.debugevent = debugevent
data.world_events.empty = empty
data.world_events.dust_storm = dust_storm
data.world_events.roaming_bot = roaming_bot


function FreeplayEvent_DebugForceEvent(id)
	local events = Map.GetSave().world_events
	events.timer = 999
	events.tick_list = {}
	events.tick_list[1] = { starttimer = 1, name = id, data = { count = events.count } }
	data.world_events[id]:Init(events.tick_list[1].data)
	print("forcing event ", id)
end

-- blight storm
-- wind events
