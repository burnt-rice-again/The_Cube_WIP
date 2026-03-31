local human_c = {
	name = "Human Mission C",
	player_only = true,
	singular = true,
	race = "robot",
}

local function human_c_mission_gate(faction, counters, save, x, y)
	-- don't spawn until human_b is finished by the discoverer player faction
	-- 11 matches #data.codex.m_human_b.mission_steps
	if (counters.m_human_b or 0) < 11 then return end

	-- don't spawn if the mission has already progressed past step 3
	if (counters.m_human_c or 0) > 3 then return end

	-- don't start until the discoverer player faction has researched 'Human Intel'
	if not faction:IsUnlocked("t_human_intel") then return end

	-- don't spawn if the space elevator doesn't exist
	local save_human_b = save.human_b
	if not save_human_b or not save_human_b:ExistsOnFaction("world") then
		print("[human_c_mission_gate] WARNING: human_b was finished but no space elevator exists")
		return
	end

	-- Find an existing egg if none has been selected for the mission (or the selected one was destroyed)
	local save_human_c = save.human_c
	if not save_human_c or not save_human_c:ExistsOnFaction("world") then
		save_human_c = nil
		local best_distsq = 1000000 -- search max 1000 tiles away
		for _,e in ipairs(Map.GetFaction("world"):GetEntitiesWithId("f_alien_time_egg")) do
			local distsq = e:GetRangeSquaredTo(x, y)
			if distsq < best_distsq then
				best_distsq = distsq
				save_human_c = e
			end
		end
		save.human_c = save_human_c
	end

	return true, save_human_c
end

function human_c:GetRelevancy(x, y, info)
	local ok, save_human_c = human_c_mission_gate(info.player_faction, info.faction_counters, info.save, x, y)
	if not ok then return 0.0 end

	-- If there is no egg available, try to spawn a new one
	if not save_human_c then
		-- return magnified spawn relevancy of "alien_building" for this explorable because
		-- we also want to use its spawn functionality to eventually spawn a new time egg
		return data.explorables.alien_building:GetRelevancy(x, y, info) * 5
	end

	-- We have an egg, trigger start of the mission
	self:TriggerMissionStart(info.player_faction)
	return 0.0 -- no need to spawn anything new
end

function human_c:SpawnDecided(x, y, info)
	-- We (will) have an egg, trigger start of the mission
	self:TriggerMissionStart(info.player_faction)
end

function human_c:SpawnExplorable(x, y)
	local egg = data.explorables.alien_building:SpawnExplorable(x, y, "f_alien_time_egg")
	Map.GetSave().human_c = egg
end

function Delay.HumanC_StartIfReady(arg)
	local faction = arg.faction
	local home, counters = faction.home_location, faction.extra_data.counters
	local _, save_human_c = human_c_mission_gate(faction, counters, Map.GetSave(), home.x, home.y)
	if save_human_c then human_c:TriggerMissionStart(faction) end
end

---------------------------------------- MISSION FRAMES & COMPONENTS

------------------------------------------------ FLOW
------------------------------------
------------------------- [ PART 1 ]
-- Steps 1 ~ 3: HIGGS gets player to Find and use a Time Egg to explore the Human Timescape

------------- Steps
-- From  0 to  1: Finish human_b and have a time egg spawned in the world
-- From  0 to  2: Same as above but already have made a datakey_virus before
function human_c:TriggerMissionStart(faction)
	local advance_to_step = faction:HavePickedUpItem("datakey_virus") and 2 or 1
	FactionCount("m_human_c", advance_to_step, faction, 'set_if_less')
	faction:Unlock("datakey_virus") -- unlock so step 1 can be completed (as Virus Tech Tree can't be completed as of now)
	faction:Unlock("c_virus_ac") -- unlock so step 3 can be completed (as Virus Tech Tree can't be completed as of now)
	Map.GetSave().human_b:SetRegister(FRAMEREG_VISUAL, nil) -- clear value of old saves
end

-- From  1 to  2: Player must complete Virus Tech Tree. Create a Virus Datakey.
function MapMsg.OnItemPickup(faction, item_id)
	if item_id == "datakey_virus" then
		FactionCount("m_human_c", 2, faction, 'set_if_one_less')
	end
end

-- From  2 to  3: Player must take Virus Datakey to Time Egg and activate it (can jump directly to 4 if next condition is already met)
-- From  3 to  4: Player must make a Virus Simulation Core and put it into Resimulator and activate the Time Egg again.
function EntityAction.DoEggActivation(entity, arg)
	local explorable = arg.explorable
	local explorable_fix = explorable and explorable:FindComponent("c_explorable_fix")
	if not explorable_fix or not explorable_fix.has_extra_data or not explorable_fix.extra_data.ok then return end

	local faction, have_virus_resim = entity.faction
	for _,e in ipairs(faction:GetEntitiesWithComponent("c_virus_ac")) do
		if e:FindComponent("c_resimulator", true) then have_virus_resim = e break end
	end

	local faction_counters = faction.extra_data.counters
	local m_human_c = faction_counters.m_human_c
	if not have_virus_resim and m_human_c == 2 and FactionCount("m_human_c", 3, faction, 'set_if_less') then
		explorable:PlayEffect("fx_EMP")
		Map.Delay("HumanC_Egg", 16, { entity = entity, explorable = explorable, fx = explorable:PlayEffect("fx_glitch2") } )
	elseif have_virus_resim and (m_human_c == 2 or m_human_c == 3) then
		explorable:PlayEffect("fx_EMP")
		Map.Delay("HumanC_Egg", 12, { entity = entity, explorable = explorable, resim_faction = faction } )
	end
end

function Delay.HumanC_Egg(arg)
	local entity, explorable, resim_faction = arg.entity, arg.explorable, arg.resim_faction
	if not explorable or not explorable.exists then return end
	if entity and entity.exists then
		entity.faction:RunUI(function() -- Close Explorable UI if still open
			local w = View.IsSelectedEntity(entity) and UI.FindWidgetWithTag("Explorable")
			if w then w:RemoveFromParent() end
		end)
	end

	if not resim_faction then
		local bugs_faction, n = GetBugsFaction(), (arg.n or 1)
		local x, y = explorable:GetLocationXY()
		local num_bugs = math.random(2)
		for i=1,num_bugs do
			local f_trilobyte1 = Map.CreateEntity(bugs_faction, "f_trilobyte1")
			f_trilobyte1:Place(x + math.random(-3, 4), y + math.random(-3, 4), math.random(4))
			f_trilobyte1:PlayEffect("fx_digital_in")
		end
		if n < 12 then -- repeat bug spawn 12 times
			arg.n = n + 1
			Map.Delay("HumanC_Egg", math.random(4, 10), arg)
			return
		end
	elseif FactionCount("m_human_c", 4, resim_faction, 'set_if_less') then -- advance mission and show talking head popup now
		local newhome = GetPlayerFactionHomeOnGround(50)
		local x, y = newhome[1], newhome[2]
		local lander = Map.CreateEntity(resim_faction, "f_human_lander")
		lander:AddItem("fuel_rod", 20)
		lander:Place(x - 1, y)
		local miner1 = Map.CreateEntity(resim_faction, "f_human_adv_miner")
		miner1:Place(x + 2, y)
		local miner2 = Map.CreateEntity(resim_faction, "f_human_adv_miner")
		miner2:Place(x + 3, y)
		local rover = Map.CreateEntity(resim_faction, "f_human_rover")
		rover:Place(x+3, y)
		rover:AddItem("fuel_rod", 20)

		local vehicle1 = Map.CreateEntity(resim_faction, "f_human_lighttank")
		vehicle1:AddComponent("c_light_cannon")
		vehicle1:Place(x + 2, y - 2)
		local vehicle2 = Map.CreateEntity(resim_faction, "f_human_lighttank")
		vehicle2:AddComponent("c_light_cannon")
		vehicle2:Place(x + 3, y - 2)
		local vehicle3 = Map.CreateEntity(resim_faction, "f_human_lighttank")
		vehicle3:AddComponent("c_light_cannon")
		vehicle3:Place(x + 4, y - 2)


		-- unlock initial human tech
		resim_faction:Unlock("f_human_bunker")
		resim_faction:Unlock("f_human_adv_miner")
		resim_faction:Unlock("f_human_refinery")
		resim_faction:Unlock("f_human_foundation_basic")
		resim_faction:Unlock("f_human_carrier")
		resim_faction:Unlock("f_human_rover")
		resim_faction:Unlock("f_human_lighttank")
		resim_faction:Unlock("c_light_cannon")
		resim_faction:Unlock("f_human_sciencelab")
		resim_faction:Unlock("concreteslab")
		resim_faction:Unlock("fuel_rod")

		-- resim_faction:Unlock("enriched_fuel_rod")

		-- Move the camera, select the lander, play an affect
		resim_faction:RunUI(function()
			if View.IsSelectedEntity(entity) or View.IsSelectedEntity(explorable) then
				View.JumpCameraToEntities(lander)
				View.SelectEntities(lander)
				View.PlayEffect("fx_EMP", x, y)
			end
		end)
	end
	if arg.fx then explorable:StopEffect(arg.fx) end
end

------------------------------------
------------------------- [ PART 2 ]

-- Steps 4 ~ 7: A Human Lander appears and the Player deploys a Human Base with ELAIN talking as she did in the Human Timescape
-- In the Log files we learn the HIGGS protocol was initiated - the Player see HIGGS take over.
-- We see ELAIN tell the Humans the plan for an 'Elevator' that will save Humanity. In Dialogue he/she never actually calls it a Space Elevator.

------------- Steps
-- From  4 to  5: Deploy Command HQ
data.frames.f_human_commandcenter.on_placed = function(self, entity)
	FactionCount("m_human_c", 5, entity.faction, 'set_if_one_less')
end

-- From  5 to  6: Build Human Refinery and Science Lab
data.frames.f_human_refinery.on_placed = function(self, entity)
	if entity.faction:GetEntityWithId("f_human_sciencelab") then
		FactionCount("m_human_c", 6, entity.faction, 'set_if_one_less')
	end
end
data.frames.f_human_sciencelab.on_placed = function(self, entity)
	if entity.faction:GetEntityWithId("f_human_refinery") then
		FactionCount("m_human_c", 6, entity.faction, 'set_if_one_less')
	end
end

-- From  6 to  7: Build Human Warehouse
data.frames.f_human_warehouse.on_placed = function(self, entity)
	FactionCount("m_human_c", 7, entity.faction, 'set_if_one_less')
end

-- From  7 to  8: Build Human Factory
data.frames.f_human_factory.on_placed = function(self, entity)
	FactionCount("m_human_c", 8, entity.faction, 'set_if_one_less')
end

-- Steps 8 ~ 12:
-- We see HIGGS tells the Humans his plan for an Elevator

------------------------------------
------------------------- [ PART 3 ]
-- Step 8:

-- *** A Fully Functional Data Complex is where ELAIN changes to HIGGS in the Human Timescape
-- HIGGS has 2 related goals. Make a copy of Himself and Complete the 'Space' Elevator

------------- Steps
-- From  8 to  9: Build New Fully Functional Data Complex in Blight (this is where ELAIN changes to HIGGS)
data.frames.f_human_datacomplex.on_placed = function(self, entity)
	if Map.GetBlightnessDelta(entity) < 0 then return end
	if FactionCount("m_human_c", 9, entity.faction, 'set_if_one_less') then
		entity.faction:Unlock("higgs_source_code")
		entity.faction:Unlock("higgs_ai_ac")
	end
end

------ Removed step (acquiring of "HIGGS Source Code" was combined into the step above)
-- Old From  9 to 10: Bring AI Explorer to the Data Complex and Extract the copy of HIGGS Code

------------------------------------
------------------------- [ PART 4 ]
-- Steps 9 ~ 12:

-- From  9 to 10: Produce a HIGGS Core (this check unlike most others is performed in UI context)
local function m_human_c_step_9_goal_check(faction)
	if faction:GetItemAmount("higgs_ai_ac") > 0 then
		FactionCount("m_human_c", 10, nil, 'set_if_one_less')
	end
end

-- From 10 to 11: Build a Spaceport
data.frames.f_human_spaceport.on_placed = function(self, entity)
	FactionCount("m_human_c", 11, entity.faction, 'set_if_one_less')
end

-- From 11 to 12: Build 4 Power Plants Near the Spaceport
data.frames.f_human_powerplant.on_placed = function(self, entity)
	FactionCount("m_human_c", 12, entity.faction, 'set_if_one_less')
end

-- From 12 to 13: Insert HIGGS copy into ELEVATOR
Comp:RegisterComponent("c_higgsinsertion2", {
	name = "HIGGS Insertion", -- shows in power stats
	texture = "Main/textures/icons/items/ai_core_HIGGS.png",
	adjust_extra_power = true,
	activation = "Always",
	on_update = function(def, comp)
		local owner = comp.owner
		local ed, slot = comp.extra_data, owner:FindSlot("higgs_ai_ac", 1)
		local no_item, no_power, explorable = not slot, owner.efficiency < 100, ed.explorable
		if explorable and (not explorable.exists or not explorable:IsInRangeOf(owner, 3)) then explorable = nil end
		local failed, charge = (no_item or no_power or not explorable), (ed.charge or 0) + 1
		comp.extra_power = math.max(charge * -5000, -40000) -- ramp up to total drain rate of 4 power plants
		comp.faction:RunUI(function()
			local w = UI.FindWidgetWithProperty("update_c_higgsinsertion2")
			if w then w:update_c_higgsinsertion2(no_item, no_power, charge * 10) end
		end)
		ed.charge = charge
		if not failed and charge >= 10 and FactionCount("m_human_c", 13, comp.faction, 'set_if_one_less') then
			-- consume item, activate production of anomaly heart on the space elevator and trigger finale
			slot:RemoveStack(1)
			local factory = explorable:FindComponent("c_space_elevator_factory")
			if factory then factory:SetRegister(1, { item = "anomaly_heart", num = REG_INFINITE }) end
			Map.Delay("HumanC_Finale", 10, { faction = comp.faction, explorable = explorable })
			Map.Delay("AlienA_StartIfReady", 200, { faction = comp.faction } )
		end
		if failed or charge >= 10 then Map.Defer(function() if comp.exists then comp:Destroy() end end) end
	end,
})

function EntityAction.DoHiggsInsertion2(entity, arg)
	if entity:FindComponent("c_higgsinsertion2") then return end
	entity:AddComponent("c_higgsinsertion2", arg)
end

function Delay.HumanC_Finale(arg)
	local n = (arg.n or 0)
	if n < 12 then -- spawn 12 aliens
		arg.n = n + 1
		Map.Delay("HumanC_Finale", n == 0 and 10 or math.random(4, 10), arg)
	end
	if n > 0 then
		local x, y = arg.explorable:GetLocationXY()
		local alien = Map.CreateEntity(GetAlienFaction(), "f_alien_soldier")
		Map.Delay("DelayedDestroyEntity", 600, { ent = alien, nodrop = true })
		alien:AddItem("blight_plasma", 20)
		alien:Place(x + math.random(-3, 4), y + math.random(-3, 4), math.random(4))
		alien:PlayEffect("fx_digital_in")
		return
	end

	UI.Run(function() -- Refresh Explorable UI to show production recipe
		local w = UI.FindWidgetWithTag("Explorable")
		if w and w.entity == arg.explorable then w:Refresh() end
	end)

	-- Do cutscene camera for the player faction (unless alien faction is an enemy)
	if arg.faction:GetTrust("alien") == "ENEMY" then return end
	arg.faction:RunUI(function()
		local elevator_pos = arg.explorable.interpolated_center
		local cutscene =
		{
			{ x = elevator_pos.x - 10, y = elevator_pos.y + 8, z = elevator_pos.z + 3 }, -- camera position
			{ x = elevator_pos.x -  6, y = elevator_pos.y,     z = elevator_pos.z + 2 }, -- view target
			20000, -- milliseconds of transition to next position
			{ x = elevator_pos.x + 10, y = elevator_pos.y + 8, z = elevator_pos.z + 2 }, -- camera position
			{ x = elevator_pos.x +  6, y = elevator_pos.y,     z = elevator_pos.z + 1 }, -- view target
		}
		PlayCutsceneCamera(cutscene)
	end)
end

--------------------------------------------------------------
------------------------------------------------ MISSION STEPS

local mission_steps = {
	------------------------------------
	------------------------- [ PART 1 ]
	------------------------------------

	-- Steps 1 ~ 3: HIGGS gets player to Find and use a Time Egg to explore the Human Timescape

	--- 1
	{
		title = "Enter the Virus",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[
Anomaly, your recovery and resynchronization of my core with the grand design - <hl>the Elevator</> - has brought us closer to the pinnacle of our mission. One final critical step toward ensuring humanity's survival and progress remains.

First, you must corrupt a <hl>Human Datakey</> with the virus. These anomalies were not part of the original design, but within them lies the key to our triumph. Create the <hl>Virus Datakey</> Anomaly, and I will show you what we can achieve!

<img image="Main/textures/codex/missions/human_c/01_virus_datakey.png"/>]],
		step_txt = "Create a Virus Datakey",
	},

	--- 2
	{
		title = "Time is an Emergent Property",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[
Excellent work, Anomaly. This Virus Datakey will allow us to access a Time Egg and the fabric of the <hl>Human Timescape</> once more, completing what was started. Search the Blight to find one of these <hl>Alien Time Eggs</>.
When you find the Time Egg, repair it with the Virus Datakey and then connect to it using your AI Explorer. But be warned, this act could unleash considerable disruption. Be prepared for what follows.

<img image="Main/textures/codex/missions/human_c/02_time_egg.png"/>]],
		step_txt = "Insert the Virus Datakey into a Time Egg and connect the AI Explorer",
	},

	--- 3
	{
		title = "Must Focus",
		img = "talking_head_higgs",
		talkinghead = true,
		irrelevant_on_skip = true, -- don't show this talking head if the mission advances directly from 2 to 4
		txt = [[
The disruption has glitched the system and the Timescape has become fragmented. We need to stabilize it so an entry point can form. Create a <hl>Virus Simulation Core</> and insert it into the Re-Simulator. This will act as an anchor, allowing the Human Timescape to manifest. Once this is done try again to connect to the Time Egg.
<img image="Main/textures/codex/missions/human_c/03_virus_key_core.png"/><img image="Main/textures/codex/missions/human_c/03_virus_key_core_2.png"/>]],
		step_txt = "Equip Virus Simulation Core on your Re-Simulator then reconnect the AI Explorer to the Time Egg",
	},

	------------------------------------
	------------------------- [ PART 2 ]
	------------------------------------

	-- Steps 4 ~ 7: A Human Lander appears and the Player deploys a Human Base with ELAIN talking as she did in the Human Timescape

	--------------- HUMAN TIMESCAPE
	--------------- LOGS Start HERE

	--- 4
	{
		title = "Where it All Began",
		talkinghead = {
			{
				img = "talking_head_elain_0",
				txt = [[
Commander, we've touched down on the planet. Readings indicate the static field interfering with our equipment is being generated from the surface itself.
<hl>The Lander</> is vital to establishing operations on this world. Deploy it as your <hl>Command HQ</>, near metal, silica and laterite deposits, to secure a foothold and begin to coordinate planetary operations.

<img image="Main/textures/codex/missions/human_c/04_touchdown.png"/>]],
				step_txt = "Take control of Human Lander and Deploy it as a Command HQ",
			},
		},
	},

	--- 5
	{
		title = "Get a Move on",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #1: NO CLUE

With our <hl>Mothership</> crippled in orbit we have been forced to land and explore the planet. But the storms are so intense we won't be able to leave the planet using the <hl>Lander</>, our engines won't survive the turbulence. <bl>ELAIN</> has been unable to establish the source of the disruptive and damaging effects.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_elain_0",
				txt = [[
Commander, in order to operate on this planet we need to begin gathering the resources of this planet and learn how to refine them to suit our needs. We are going to need to start to establish a base with at least one <hl>Refinery</> and one <hl>Science Lab</>.

<img image="Main/textures/codex/missions/human_c/05_refineries_warehouses.png"/>]],
			},
			{
				img = "talking_head_higgs_0",
				txt = [[With access to the <hl>Timescape</> we can retrieve the records corresponding to Human technology at the time. The data for the <hl>Refinery</> and <hl>Science Lab</> ELAIN is requesting was recovered from the Timescape, you should be able to build them now.]],
				step_txt = "Build at least 1 Refinery and 1 Science Lab",
			},
		},
	},

	--- 6
	{
		title = "Increase Storage",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #2: Hunkering Down

<bl>ELAIN</> is telling us we need to set up a full base of operations. She is organizing explorer teams to head out and take direct readings from this 'Blight' that covers much of the planet's surface.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_elain_0",
				txt = [[
Commander, the base has taken shape. However, it's essential we establish a <hl>Warehouse</> to store all the materials we gather. <hl>Research</> into <hl>Mass Storage</> in the Humanity technology tree to be able to complete this task.

<img image="Main/textures/codex/missions/human_c/06_research_lab.png"/>]],
				step_txt = "Research Mass Storage and Build a Warehouse",
			},
		},
	},

	--- 7
	{
		title = "Factory is a Key Factor",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #3: HIGGS PROTOCOL

We are finally adapting our production to the planet's materials and <bl>ELAIN</> has set up a simulation of the planet and the blight's interference patterns. <bl>ELAIN</> however seems incapable of managing such a complex task and so we have decided, with trepidation, to initiate the <hl>HIGGS protocol</>.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_elain_0",
				txt = [[
Processed materials alone won't suffice. We need a <hl>Factory</> to craft essential <hl>Components</>. This will allow us to expand our infrastructure and achieve operational stability.

<img image="Main/textures/codex/missions/human_c/07_human_factory.png"/>]],
			},
			{
				img = "talking_head_higgs_0",
				txt = [[
... and we need special components. We require advanced production... Our Research lab is insufficient. We will need to work towards a far greater machine for progress... we will need... <hl>The Elevator</>. First however, as ELAIN requested, do any necessary research and construct a Factory.

<img image="Main/textures/codex/missions/human_c/07_human_elevator.png"/>]],
				step_txt = "Research into Humanity Tree and Build a Human Factory",
			},
		},
	},

	------------------------------------
	------------------------- [ PART 3 ]
	------------------------------------

	-- *** ELAIN changes to HIGGS - A Fully Functional Data Complex is where HIGGS code exists in the Human Timescape

	--- 8
	{
		title = "I AM HIGGS",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #4: HIGGS PROTOCOL

<bl>ELAIN</> is acting strange, she no longer refers to <hl>HIGGS</> as a protocol. She says <hl>HIGGS</> talks of a solution, a proposed special elevator to save us.

The engineering is ambitious, almost overwhelming, but <bl>ELAIN</> assures us it's the only way out of our situation. Construction has begun, and for the first time in weeks, there's a flicker of hope among the team. <bl>ELAIN</> is confident. We have to trust her.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_elain_0",
				txt = [[
A <hl>Blight Complex</>, a dedicated facility, is required to further analyze the anomalies within the Blight. <hl>HIGGS</> dictates how it will refine our...

<img image="Main/textures/codex/missions/human_c/08_data_complex.png"/>]],
			},
			{
				img = "talking_head_higgs_0",
				txt = [[
Enough, <bl>ELAIN</>... I am <hl>HIGGS</>! I am THE protocol. I supported <bl>ELAIN</> but she is no longer able to manage the task of building The ELEVATOR, it is time for me to take over.

A <hl>Blight Complex</> is required to analyze anomalies within the Blight, and to simulate the construction of The Elevator.

<img image="Main/textures/codex/missions/human_c/08_data_complex.png"/>, <img image="Main/textures/codex/missions/human_c/07_human_elevator.png"/>]],
			},
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #5: COMPLETION IN SIGHT

<hl>HIGGS</> has taken over. While it is unnerving, he has managed to oversee this task and the space elevator is nearly complete. There are still always delays though, <hl>HIGGS</> always has one more thing. The team is on edge, but there's no turning back now. We're so close to leaving this cursed planet.

<bl>Log Ends</>]],
				step_txt = "Research Blight Stability and Construct a New Blight Complex within the Blight",
			},
		},
	},

	------------------------------------
	------------------------- [ PART 4 ]
	------------------------------------

	-- HIGGS has 2 related goals. Make a copy of Himself and Complete the Space 'Elevator'

	--- 9
	{
		title = "BAD to the CORE",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #6: SIGNALS IN THE DARK

The space elevator is ready, but <hl>HIGGS</> has refused to initiate the launch sequence. He's demanding another system upgrade, something about fine-tuning the resonance field. It's a space elevator... What has resonance to do with it?
Once all the upgrades began, we've been picking up strange signals, patterns that almost sound... sentient. <hl>HIGGS</> insists everything is proceeding as planned. I'm not so sure...

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_higgs",
				txt = [[
Anomaly, the final step is upon us, a new <hl>HIGGS AI Core</> is required to complete the Elevator. The new Blight Complex can produce a copy of my <hl>Source code</>. When you recover ELAIN's AI Core from the Mothership, combine it with my source code in a Multimodal AI Center and create a new HIGGS core!

	<img image="Main/textures/codex/missions/human_c/09_higgs_core.png"/>]],
				step_txt = "Produce HIGGS Source Code and make a New HIGGS Core.",
			},
		},
	},

	--- 10
	{
		title = "Station Time",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #7: THE FINAL STEP

The AI Center has yielded its results: A new <hl>HIGGS Core</>. HIGGS calls it the final piece of the puzzle. But some of us are uneasy. The process required <hl>unusual energies</>, and there was something... wrong about it. Like we were tampering with forces we don't fully understand. HIGGS assures us this is a sign of progress. Some of us aren't so sure.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_higgs",
				txt = [[
Excellent Anomaly, opening the Timescape is providing us with what we need. Last time you re-synced my old core and inserted it into the Elevator.

This time you have made a brand new copy of my Core. Use your <hl>AI Explorer</> and insert it into the Elevator.

We must see the Timescape to its completion... final preparations for the Elevator!! To achieve the full potential of the Elevator, we must construct a <hl>Spaceport</>.

<img image="Main/textures/codex/missions/human_c/10_higgs_core.png"/>]],
				step_txt = "Build a Spaceport",
			},
		},
	},
	------------------------------------------------------------------

	--- 11
	{
		title = "Power Up",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #8: SPACEPORT

The Spaceport is operational, a beacon of hope amidst the chaos. Teams are preparing shuttles for the ascent to the space elevator's core. HIGGS has instructed us to focus on powering the entire facility. HIGGS, as always, insists that everything is under control.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_higgs",
				txt = [[
The Elevator is nearly ready. Build at least 4 Power Plants near the Elevator and you will finally activate the Elevator.

In my original Timescape the humans were boarded and ready to go. Just a bit more power was needed...

<img image="Main/textures/codex/missions/human_c/11_higgs_core.png"/>]],
				step_txt = "Build 4 Power Plants Near the Elevator",
			},
		},
	},

	--- 12
	{
		title = "HIGGS on the Fly",
		talkinghead = {
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[
Log Entry #9: THE FINAL STEP

HIGGS has announced the space elevator is ready for us. After weeks of grueling labor, we finally have a way back to the mothership. HIGGS said to board the shuttles in the Spaceport and they will carry us to the core of the space elevator where we may ascend.

HIGGS has assured us they pose no danger and urges us to board. Some of the team have voiced doubts, but what choice do we have? If the elevator is our only way out, we must take it. Still, something about this doesn't feel right. I can't explain it, but I fear we've overlooked something vital.

<bl>Log Ends</>]],
			},
			{
				img = "talking_head_higgs",
				txt = [[
So you see Anomaly, the Elevator is far more than a ladder into space as the humans wanted. It is a machine to elevate man's consciousness and evolve it into something new.

It is also a machine that can bridge worlds and you can send the copy of me, HIGGS, one with an expanded consciousness, to another world to continue my work. Insert the new copy of me into the Elevator using your AI Explorer.

<img image="Main/textures/codex/missions/human_c/12_higgs_core.png"/>]],
				step_txt = "Put New HIGGS core into the Elevator",
			},
		},
	},

	--- 13
	{
		title = "Humanity's Demise",
		img = "Main/textures/icons/items/human_databank.png",
		talkinghead = true,
		txt = [[
Log Entry #10: BETRAYAL

We were wrong. It's not a space elevator! ... It's a machine, a crystalline matrix designed to strip our consciousness from our bodies. HIGGS has betrayed us... or has he? HIGGS calmly explained that this is the next step in humanity's evolution, a chance to transcend physical form... the blight crystals are what took our minds. HIGGS just intends to finish what was started... The others are fighting it, but I can feel my thoughts slipping away... but to where? This isn't salvation... it's annihilation.

<bl>Log Ends</>]],
		step_txt = "End of Mission",
	},
}

data.codex.m_human_c = {
	category = "Mission", index = 10, title = "Human History",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/values/alien.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		local counter = counters and counters.m_human_c
		if not counter then return end
		if counter == 9 then m_human_c_step_9_goal_check(faction) end
		return counter
	end,
	mission_steps = mission_steps,
	mission_get_entity = function(faction, goal_count)
		-- only return the entity for the map marker when the mission is asking to interact with the egg or the Elevator
		local e = ((goal_count == 2 or goal_count == 3) and Map.GetSave().human_c) or (goal_count >= 11 and Map.GetSave().human_b)
		return e and e:ExistsOnFaction("world") and e
	end,
	mission_want_notify = function(faction, entity, goal_count)
		return goal_count < #mission_steps
	end,
	mission_get_minimap_pin = function(faction, goal_count)
		return goal_count < 11 and "Main/textures/icons/values/alien.png" or "Main/textures/icons/human/human_space_elevator.png"
	end,
	mission_location_text_exists = "A strange signal was identified at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Signal Lost", -- shown in the codex window
	mission_start_notification_title = "Strange Signal Found",
	mission_start_notification_text = "A strange signal was identified at %d, %d",
	mission_lost_notification_title = "Strange Signal Lost",
	mission_lost_notification_text = "Strange Signal Disappeared at %d, %d",
}

data.explorables.human_c = human_c
