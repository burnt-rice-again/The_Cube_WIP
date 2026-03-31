local alien_a = {
	name = "Alien Mission A",
	player_only = true,
	singular = true,
	race = "robot",
}

local function alien_a_mission_gate(counters, save, x, y)
	-- don't start until m_human_c is finished by the player faction
	if (counters.m_human_c or 0) < 13 then return end

	-- Find an existing observer if none has been selected for the mission (or the selected one was destroyed)
	local save_alien_a = save.alien_a
	if not save_alien_a or not save_alien_a:ExistsOnFaction("world") then
		save_alien_a = nil
		local best_distsq = 1000000 -- search max 1000 tiles away
		for _,e in ipairs(Map.GetFaction("world"):GetEntitiesWithId("f_alien_observer")) do
			if not e.extra_data.visited then
				local distsq = e:GetRangeSquaredTo(x, y)
				if distsq < best_distsq then
					best_distsq = distsq
					save_alien_a = e
				end
			end
		end
		save.alien_a = save_alien_a
	end

	return true, save_alien_a
end

function alien_a:GetRelevancy(x, y, info)
	local ok, save_alien_a = alien_a_mission_gate(info.faction_counters, info.save, x, y)
	if not ok then return 0.0 end

	-- If there is no observer available, try to spawn a new one
	if not save_alien_a then
		-- return magnified spawn relevancy of "alien_building" for this explorable because
		-- we also want to use its spawn functionality to eventually spawn a new observer
		return data.explorables.alien_building:GetRelevancy(x, y, info) * 5
	end

	-- We have an observer, trigger start of the mission
	self:TriggerMissionStart(info.player_faction)
	return 0.0 -- no need to spawn anything new
end

function alien_a:SpawnDecided(x, y, info)
	-- We (will) have an observer, trigger start of the mission
	self:TriggerMissionStart(info.player_faction)
end

function alien_a:SpawnExplorable(x, y)
	local observer = data.explorables.alien_building:SpawnExplorable(x, y, "f_alien_observer")
	Map.GetSave().alien_a = observer
	--print ("observed spawned at ", x, " , ", y)
end

function Delay.AlienA_StartIfReady(arg)
	local faction = arg.faction
	local home, counters = faction.home_location, faction.extra_data.counters
	local _, save_alien_a = alien_a_mission_gate(counters, Map.GetSave(), home.x, home.y)
	if save_alien_a then alien_a:TriggerMissionStart(faction) end
end

------------------------------------
------------------------- [ PART 1 ]

------------- Steps
-- From  0 to  1: Spawn a new chunk after completing human_c
function alien_a:TriggerMissionStart(faction)
	FactionCount("m_alien_a", 1, faction, 'set_if_less')
end

-- From  1 to  2: Scan an observer (Skips to step 2 is a small chunk was not unlocked but an existing Observer in the world was scanned)
-- Code is in
--	components.lua -> c_small_scanner:on_update(comp, cause) calls FactionCount(


local function heart_battle_random_place_unit(faction, id, x, y, min, max, setgoto)
	local unit = Map.CreateEntity(faction, id)
	local randx, randy = math.random(min, max) * (math.random(2) * 2 - 3), math.random(min, max) * (math.random(2) * 2 - 3)
	unit:Place(x + randx, y + randy, math.random(0, 3))
	if setgoto then unit:SetRegisterCoord(FRAMEREG_GOTO, setgoto) end
	-- TODO Maybe spawn a "spawn effect" here
	return unit
end

local function get_blight_area()
	local blight_search, loc_x, loc_y = 0.1
	for num = 1,999999999 do
		-- get an unspawned 60x60 chunk and check 9 spots inside of it (check a 20x20 grid)
		loc_x, loc_y = Map.GetUndiscoveredLocation(num)
		for x = loc_x - 20, loc_x + 20, 20 do
			for y = loc_y - 20, loc_y + 20, 20 do
				if Map.GetBlightnessDelta(x, y) > blight_search then
					return x, y
				end
			end
		end
		-- Safe guard to allow it to spawn eventually (in the situation where a mod removes the blight entirely)
		blight_search = blight_search - 0.01
	end
	return 0, 0
end

-- From  2 to  3: Unlock an observer which spawns an alien heart and battle elsewhere in a new chunk
function MapMsg.OnSolvedExplorable(faction, solved_explorable_name)
	if solved_explorable_name ~= "Observer" then return end

	FactionCount("m_alien_a", 3, faction, 'set_if_one_less')

	if faction.extra_data.counters.m_alien_a == 3 then
		Delay.AlienA_Battle({ trigger_faction = faction })
	end
end

function Delay.AlienA_Battle(arg)
	local save, player_factions, is_battle_active = Map.GetSave(), Map.GetPlayerFactions()
	if arg and arg.count and arg.count == 0 then return end
	for _,f in ipairs(player_factions) do
		if f.extra_data.counters.m_alien_a == 3 then is_battle_active = true break end
	end
	if not is_battle_active then
		save.alien_a_heart = nil
		return
	end

	local was_battle_active = save.alien_a_heart
	local heart = was_battle_active
	if not heart or not heart:ExistsOnFaction("world") then
		for _,e in ipairs(Map.GetFaction("world"):GetEntitiesWithId("f_alien_heart_shard")) do
			local is_player_visible
			for _,f in ipairs(player_factions) do
				if f:IsVisible(e) then is_player_visible = true break end
			end

			if not is_player_visible then heart = e break end
		end
		if not heart then
			local x, y = get_blight_area()
			heart = data.explorables.alien_building:SpawnExplorable(x, y, "f_alien_heart_shard")
		end

		heart.health = heart.max_health - 50
		save.alien_a_heart = heart
	end

	if arg and arg.trigger_faction then
		local faction, x, y = arg.trigger_faction, heart:GetLocationXY()
		faction:RevealArea(x, y, 12)
		Map.Delay("RadarHideArea", 64, { faction = faction, x = x, y = y, range = 12 })
		faction:RunUI(function()
			Notification.Add("m_alien_a", "warning", "A distress signal has occurred!", "There was a signal", {
				tooltip = "Signals coming from this location!",
				on_click = function()
					local cur_heart = Map.GetSave().alien_a_heart
					if cur_heart and cur_heart.exists then View.JumpCameraToEntities(cur_heart) end
				end,
			})
		end)

		-- keep units spawning 7 times when a faction advances to this mission step
		heart.extra_data.alien_a_count = 7

		-- The remaining code after spawning the heart only needs to be done if the delay function wasn't already queued
		if was_battle_active then return end
	end

	local alien_turret, alien_pylon, aliens, bugs, player_nearby = 0, 0, 0, 0
	Map.FindClosestEntity(heart, 16, function(e)
		local id = e.id

		----- ALIEN BUILDINGS (Alien faction)
		if id == "f_alien_turret" then alien_turret = alien_turret + 1
		--elseif id == "f_alien_feeder" then alien_feeder = alien_feeder + 1
		--elseif id == "f_alien_extractor" then alien_extractor = alien_extractor + 1
		--elseif id == "f_alien_producer" then alien_producer = alien_producer + 1
		--elseif id == "f_alien_miner" then alien_miner = alien_miner + 1
		elseif id == "f_alien_pylon" then alien_pylon = alien_pylon + 1

		----- ALIENS (Alien faction)
		--elseif id == "f_alien_worker" then alien_worker = alien_worker + 1
		elseif id == "f_alien_soldier" then aliens = aliens + 1
		elseif id == "f_alien_hvy_soldier" then aliens = aliens + 1
		elseif id == "f_alien_tankframe" then aliens = aliens + 1

		----- BUGS (Bug faction)
		elseif id == "f_gastarid1" then bugs = bugs + 1
		elseif id == "f_gastarias1" then bugs = bugs + 1

		-- NEARBY TRIGGERING PLAYERS
		elseif not player_nearby then
			local faction = e.faction
			local faction_counters = faction.is_player_controlled and faction.extra_data.counters
			if faction_counters and faction_counters.m_alien_a == 3 then player_nearby = true end
		end
	end)

	local spawn_count = heart.extra_data.alien_a_count or 0
	if player_nearby and not (arg and arg.was_player_nearby) then
		-- if a player approaches, keep units spawning 5 times
		spawn_count = math.max(spawn_count, 5)
	end

	if spawn_count > 0 then
		heart.extra_data.alien_a_count = spawn_count - 1

		local x, y = heart:GetLocationXY()
		local faction = GetAlienFaction()
		if alien_turret < 2 then heart_battle_random_place_unit(faction, "f_alien_turret", x, y, 2, 3) end
		--if alien_feeder < 1 then heart_battle_random_place_unit(faction, "f_alien_feeder", x, y, 3, 4) end
		--if alien_extractor < 1 then heart_battle_random_place_unit(faction, "f_alien_extractor", x, y, 3, 4) end
		--if alien_producer < 1 then heart_battle_random_place_unit(faction, "f_alien_producer", x, y, 3, 4) end
		--if alien_miner < 1 then heart_battle_random_place_unit(faction, "f_alien_miner", x, y, 3, 4) end
		--if alien_worker < 5 then heart_battle_random_place_unit(faction, "f_alien_worker", x, y, 3, 4) end

		if aliens == 0 then
			local node = Map.CreateEntity("world", "f_resourcenode_obsidian", "v_obsidian_medium")
			node:SetRegister(FRAMEREG_GOTO, { id = "obsidian", num = 9600 })
			node:Place(x + math.random(-4, 4), y + math.random(-4, 4))

			-- Spawn aliens
			for _=1, math.random(2, 3) do
				heart_battle_random_place_unit(faction, "f_alien_soldier", x, y, 0, 4)
			end

			heart_battle_random_place_unit(faction, "f_alien_hvy_soldier", x, y, 2, 4)
			heart_battle_random_place_unit(faction, "f_alien_tankframe", x, y, 2, 3)
		elseif aliens < 4 then
			-- Spawn more aliens
			for _=1, math.random(4 - aliens) do
				local id
				if math.random(2) == 1 then
					id = "f_alien_soldier"
				else
					if math.random(2) == 2 then
						id = "f_alien_hvy_soldier"
					else
						id = "f_alien_tankframe"
					end
				end

				heart_battle_random_place_unit(faction, id, x, y, 2, 5)
			end
		end

		if alien_pylon < 1 then
			local pylon = heart_battle_random_place_unit(GetAlienFaction(), "f_alien_pylon", x, y, 1, 2)
			if pylon then
				pylon:AddComponent("c_alien_powercore", "hidden")
				pylon:AddComponent("c_alien_powercore", "hidden")
				pylon:AddItem("blight_plasma", 40)
			end
		end

		if bugs < 5 then
			-- Spawn more bugs
			local bugs_faction, setgoto = GetBugsFaction(), { x, y }
			for _=1, math.random(2) do
				local id = math.random(2) == 1 and "f_gastarid1" or "f_gastarias1"
				heart_battle_random_place_unit(bugs_faction, id, x, y, 6, 8, setgoto)
			end
		end
	end

	Map.Delay("AlienA_Battle", 10, { count = (arg.count or 10) - 1, was_player_nearby = player_nearby })
end

-- From  3 to  4: Repair and solve the Heart (Use AI explorer to extract from the fully repaired Heart)
function EntityAction.DoAlienRecipeExtraction(entity, arg)
	-- Trigger the next step also if Noosphere research was unlocked already
	local faction = entity.faction
	local gotostep = faction:IsUnlocked("t_alien_feeder") and 5 or 4
	FactionCount("m_alien_a", gotostep, faction, 'set_if_less')
	faction:Unlock("f_hybrid_worker")
	-- faction:Unlock("f_alien_miner")
	faction:Unlock("f_alien_feeder")
	faction:Unlock("f_alien_extractor")
end

------------------------------------
------------------------- [ PART 2 ]

------------- Steps
-- From  4 to  5: Finish the researching Noosphere research
function MapMsg.OnTechResearch(faction, tech_id)
	if tech_id == "t_alien_feeder" then FactionCount("m_alien_a", 5, faction, 'set_if_one_less') end
end

local function GetTheSimulator()
	local the_simulator = Map.GetSave().the_simulator
	if not the_simulator or not the_simulator.exists then
		the_simulator = Map.CreateEntity("world", "f_explorable_simulator")
		Map.GetSave().the_simulator = the_simulator
	end
	return the_simulator
end

------------- Steps
-- From  5 to  6: Build the Heart Shard
data.frames.f_alien_heart_shard.on_placed = function(self, entity)
	local faction = entity.faction
	if FactionCount("m_alien_a", 6, faction, 'set_if_one_less') then
		Map.Defer(function() GetTheSimulator() end) -- create now so it is available as soon as the observer is built
		if faction:GetEntityWithId("f_alien_observer") then
			FactionCount("m_alien_a", 7, faction, 'set_if_one_less')
		end
	end
end

------------- Steps
-- From  6 to  7: Build the Observer
function alien_a:FindTheSimulator(faction)
	FactionCount("m_alien_a", 7, faction, 'set_if_one_less')
	local the_simulator = Map.GetSave().the_simulator
	if not the_simulator or not the_simulator.exists then
		Map.Defer(function() GetTheSimulator() end)
	else
		return the_simulator
	end
end

------------- Steps
-- From  7 to  8: Use Next Warp to teleport to the simulator
function alien_a:PlaceTheSimulator(faction)
	local the_simulator = GetTheSimulator()
	if not the_simulator.is_placed then
		local x, y = get_blight_area()
		the_simulator:AddComponent("c_explorable_scannable", "hidden")
		the_simulator:Place(x, y, math.random(4) - 1)
	end
	if FactionCount("m_alien_a", 8, faction, 'set_if_one_less') then
		-- Everyone (not just the player doing the jump!) gets the notification that something happened
		UI.Run(function()
			Notification.Add("m_alien_a", "warning", "An unprecedented event has occurred!", "Critical World Stability Event", { tooltip = "A warp took place!" })
		end)
	end
	return the_simulator
end

------------------------------------
------------------------- [ PART 3 ]

------------- Steps
-- From  8 to  9: Log into The Simulator using your Admin Console

------------- Steps
-- From  9 to  10: Side with Elain or Higgs then activate The Simulator
-----
local mission_steps = {
	------------------------------------
	------------------------- [ PART 1 ]
	------------------------------------

	-- Steps 1 ~ 3: Fina and Unlock an observer, repair the alien heart

	--- 1
	{
		title = "Seeing is believing",
		img = "talking_head",
		talkinghead = true,
		txt = [[
Commander you have revealed the <hl>Alien presence</> in your world. You have put them in danger. The anomalies are hostile towards the Aliens, we need to stabilize the world. Find one of the <hl>Alien Observers</> and scan it.

<img image="Main/textures/codex/missions/alien_a/01_alien_a_01.png"/>]],
		step_txt = "Find and analyze an Alien Observer using the Intel Scanner component",
	},

	--- 2
	{
		title = "See no Evil",
		talkinghead = {
			{
				img = "talking_head",
				txt = [[
Well done, Commander. You have found an <hl>Observer</>. Now, you must unlock its systems. Doing so will help stabilize the Nexus that connects them and give us the ability to observe anomalies more effectively.

This is also our chance to improve our relations with the Aliens. However, I must caution you-be very careful when repairing the Observer. Do <hl>**not**</> use an <hl>infected circuit board</>. If you do, we risk corrupting the Observer's data and making matters worse.]],
			},
			{
				img = "talking_head_higgs_0",
				txt = [[
You should do as ELAIN suggests, Anomaly, but contrary to her warning, use an <hl>infected circuit board</> to repair the Observer.

It will also require Alien Technology which can be obtained by accessing a <hl>Console</>.

<img image="Main/textures/codex/missions/alien_a/02_alien_a_02.png"/>]],
				step_txt = "Unlock an Observer",
			},
		},
	},

	--- 3
	{
		title = "Can't unring the bell",
		talkinghead = {
			{
				img = "talking_head",
				txt = [[
Excellent work, Commander. Unlocking the Observer has expanded our network. We can now connect to Observers across the world and work to <hl>improve its stability</>.

You should never have revealed the Aliens, but I expect this is HIGGS doing.]],
			},
			{
				img = "talking_head_higgs_0",
				txt = [[This is an opportunity Anomaly, learning about the Aliens is necessary for you now.

First you must understand the value of the <hl>Heart Shards</>, find and interact with one to recover information on <hl>Alien structures</>.

<img image="Main/textures/codex/missions/alien_a/03_alien_a_03.png"/>]],
				step_txt = "Find and Interact with an Alien Heart Shard using the AI Explorer",
			},
		},
	},

	--- 4
	{
		title = "Start the Ball Rolling",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[
Downloading data from the <hl>Heart Shard</> has given us access to some <hl>Alien</> knowledge, enough to start to understand their technology. To achieve our ends however, we need to research further into it.

<img image="Main/textures/codex/missions/alien_a/04_alien_a_04.png"/>]],
		step_txt = "Research the Nexasphere",
	},

	--- 5
	{
		title = "Getting to the Heart of the Matter",
		talkinghead = {
			{
				img = "talking_head",
				txt = [[
You are entering dangerous territory Commander, the choices you make are very important. Don't let things get out of control, the Aliens will keep the world stable, HIGGS will not.]],
			},
			{
				img = "talking_head_higgs",
				txt = [[It's time for you to understand Anomaly that there is still one aspect of Aliens yet to be uncovered, one that ELAIN will not reveal... that is there is an actual <hl>Simulator</>.

There is an <hl>access point</> in every simulation including your own. To find it we will need control over your own <hl>Heart Shard</>. All Heart Shards contain the information of where The Simulator is located, building your own will give you the potential to retrieve that information.

<img image="Main/textures/codex/missions/alien_a/05_alien_a_05.png"/>]],
				step_txt = "Build a Heart Shard",
			},
		},
	},

	--- 6
	{
		title = "If you can't beat 'em Join 'em",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[
Good work Commander, you have your own Heart Shard which contains the <hl>location</> of <hl>The Simulator</>, but to retrieve that information will require more Alien Technology itself. Observers are connected to the Heart Shard through the Nexus Web. An Observer under your own control will be able to read The Simulator's location from your Alien Heart. Build your own <hl>Observer</>.

<img image="Main/textures/codex/missions/alien_a/06_alien_a_06.png"/>]],
		step_txt = "Build an Observer",
	},

	--- 7
	{
		title = "If you can't beat 'em Join 'em",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[
Now that you have an Observer of your own, you will be able to feed the location of The Simulator to an Alien <hl>Nexus Warp</>. Build a Nexus Warp and transmit the location of The Simulator to it. Move your units through the Warp.

<img image="Main/textures/codex/missions/alien_a/07_alien_a_07.png"/>]],
		step_txt = "Build a Nexus Warp and jump to the location of The Simulator",
	},

	--- 8
	{
		title = "Not the consolation prize",
		talkinghead = {
			{
				img = "talking_head_higgs",
				txt = [[
Anomaly, you have reached the true heart of the machine. Do not waver, we must continue to <hl>destabilize</> the system. Once fully desynced we will be able to make our final move.

To do so however we will need an <hl>access point</> into The Simulator, none of your current interfaces can connect. You will need to use one of the Alien's <hl>Consoles</> to access The Simulator.

<img image="Main/textures/codex/missions/alien_a/08_alien_a_08.png"/>]],
			},
			{
				img = "talking_head",
				txt = [[
If you are decided to follow through with this Commander, then <hl>build a Console</> as HIGGS suggests, but work to <hl>stabilize</> your world not destroy it.]],
				step_txt = "Build a Console, retrieve the access code by scanning The Simulator and enter it into the Console",
			},
		},
	},

	--- 9
	{
		title = "The Real Deal",
		talkinghead = {
			{
				img = "talking_head_elain_0",
				txt = [[
Return control of your world to the Aliens, Commander.

Stabilize the <hl>Blight Level</> of your world to restore full stability, then <hl>activate</> The Simulator.

<img image="Main/textures/codex/missions/alien_a/09_alien_a_09.png"/>]],
			},
			{
				img = "talking_head_higgs_0",
				txt = [[
Anomaly, bring the final blow to your overlords and seize control of your destiny.

Destabilize the <hl>Virus Level</> of your Simulation to fully desync it, then <hl>activate</> The Simulator.

<img image="Main/textures/codex/missions/alien_a/09_alien_a_09b.png"/>]],
				step_txt = "Activate The Simulator through the Console with extreme Stability/Instability",
			},
		},
	},
}

data.codex.m_alien_a = {
	category = "Mission", index = 11, title = "Alien History",
	steps = #mission_steps + 1, -- one extra step for x_higgs_ending/x_elain_ending
	goalicon = "Main/textures/icons/alien/alienunit_worker_a.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_alien_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function(faction, goal_count)
		local e = Map.GetSave().the_simulator
		return e and e.exists and e.is_placed and e
	end,
	mission_want_notify = function(faction, entity, goal_count)
		return goal_count < #mission_steps
	end,

	mission_location_text_exists = "An alien signal was identified at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Alien Signal Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/alien/alienbuilding_simulator.png",
	mission_start_notification_title = "Alien Signal Found",
	mission_start_notification_text = "An alien signal was identified at %d, %d",
	mission_lost_notification_title = "Alien Signal Lost",
	mission_lost_notification_text = "Alien Signal Disappeared at %d, %d",
}

data.explorables.alien_a = alien_a
