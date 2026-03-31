local human_a = {
	name = "Human Mission A",
	player_only = true,
	singular = true,
	race = "robot",
}

function human_a:GetRelevancy(x, y, info)
	-- don't spawn if the broken explorer still exists and is still owned by the world faction or the discoverer player's faction
	local save_human_a, player_faction = info.save.human_a, info.player_faction
	local human_a_faction = save_human_a and save_human_a.exists and save_human_a.faction
	if (human_a_faction and human_a_faction.is_world_faction) or human_a_faction == player_faction then return 0.0 end

	if info.faction_level < 3 then return 0.0 end

	-- don't spawn on certain map regions
	local blightness_delta = info.blightness_delta
	if blightness_delta < -0.1 or blightness_delta > -0.05 then return 0.0 end

	local counters_human_a = info.faction_counters.m_human_a or 0

	-- don't spawn if the faction still owns an unrepaired explorer (after another player faction caused another explorer to spawn and took ownership of it)
	if counters_human_a == 1 and player_faction:GetEntityWithId("f_human_explorer_broken") then return 0.0 end

	-- don't spawn if the faction progressed past step 1 and still owns a repaired explorer or upgraded explorer
	if counters_human_a >= 2 and (player_faction:GetEntityWithId("f_human_explorer") or player_faction:GetEntityWithId("f_human_explorer_upgraded")) then return 0.0 end

	return info.faction_level > 10 and 20.0 or 2.0
end

function human_a:SpawnExplorable(x, y)
	local explorer = Map.CreateEntity("world", "f_human_explorer_broken")
	explorer:Place(x, y)
	Map.GetSave().human_a = explorer
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

----------------------------
---- f_human_explorer_broken
----------------------------

local f_human_explorer_broken = Frame:RegisterFrame("f_human_explorer_broken", {
	texture = "Main/textures/icons/human/damaged_human_science_explorer.png",
	name = "Human Explorer (Broken)",
	race = "human",
	minimap_color = { 0.9, 0.9, 0.8 },
	--visibility_range = 15,
	slots = { storage = 2, },
	--power = 100,
	health_points = 200,
	visibility_range = 5,
	trigger_channels = "bot",
	visual = "v_human_buggy_broken",
	size = "Mission",
	components = {
		{ "c_mission_human_a_trigger", "hidden" },
		{ "c_blight_shield", "hidden" },
		{ "c_mission_human_a_repair", "hidden" },
	}
})

local c_mission_human_a_trigger = Comp:RegisterComponent("c_mission_human_a_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 8, -- detect range
	trigger_channels = "bot",
})

local c_mission_human_a_repair = data.components.c_mothership_repair:RegisterComponent("c_mission_human_a_repair", {
	attachment_size = "Hidden", race = "human", index = 3999, name = "Repairs",
	texture = "Main/textures/icons/human/damaged_human_science_explorer.png",
	on_add = function(self, comp)
		comp.extra_data.items = {
			["reinforced_plate"] = 0,
			["circuit_board"] = 0,
		}
		comp.extra_data.max_items = 10
		self:on_add_repair(comp)
	end,
})

local c_human_explorer_slot1 = data.components.c_anomaly_container_i:RegisterComponent("c_human_explorer_slot1", {
	attachment_size = "Hidden", race = "human", index = 3999, name = "Catchment and Connection",
	desc = "A component that allows interfacing with Human technology with anomaly particles entanglement capabilities",
	slots = { anomaly = 1 },
	production_recipe = false,
	texture = "Main/textures/icons/components/Component_HumanFactory.png",
	get_ui = true,
})

c_human_explorer_slot1:RegisterComponent("c_human_explorer_slot2", {
	attachment_size = "Hidden", race = "human", index = 3999, name = "Catchment and Connection",
	slots = { anomaly = 2 },
})

-----------------------------------------------------------------------
---- f_human_explorer_broken gets repaired and becomes f_human_explorer
---- repaired but still damaged appearance
-----------------------------------------------------------------------

local f_human_explorer = Frame:RegisterFrame("f_human_explorer", {
	texture = "Main/textures/icons/human/human_science_explorer_01.png",
	name = "Human Explorer",
	race = "human",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	--	slots = { anomaly = 1 },
	movement_speed = 4,
	start_disconnected = true,
	power = -10,
	trigger_channels = "bot",
	health_points = 200,
	size = "Mission",
	visual = "v_human_buggy",
	components = {
		{ "c_mission_human_docker", "hidden" },
		{ "c_blight_shield", "hidden" },
		{ "c_human_explorer_slot1", "hidden" }
	},
	production_recipe = CreateProductionRecipe({ ldframe = 5, micropro = 1, gearbox = 1 }, { c_human_barracks = 3 }),
})

--------------------------------
--- this is same as Humanity
--------------------------------

local f_human_ai_research = Frame:RegisterFrame("f_human_ai_research", {
	size = "Special", race = "human", index = 3999, name = "AI Research Center",
	desc = "A hi-tech and multifaceted building for handling enigmatic technologies",
	minimap_color = { 0.8, 0.8, 0.8 },
	visibility_range = 40,
	health_points = 350,
	power = -50,
	slots = { storage = 4, },
	texture = "Main/textures/icons/human/human_building_communication_01.png",
	trigger_channels = "building",
	visual = "v_human_communication",
	components = {
		{ "c_human_explorer_slot2", "hidden" },
		{ "c_mission_human_aicenter", "hidden" }
	},
	construction_recipe = CreateConstructionRecipe({ hdframe = 5, icchip = 1 }, 15),
})

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- To 1: Mission start
function c_mission_human_a_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	if other_faction.is_player_controlled then
		FactionCount("m_human_a", 1, other_faction, 'set_if_less')

		-- Allow the player to pick up only 1 Human Explorer
		if not other_faction:GetEntityWithId("f_human_explorer_broken") and not other_faction:GetEntityWithId("f_human_explorer") and not other_faction:GetEntityWithId("f_human_explorer_upgraded") then
			comp.owner.faction = other_faction
			comp:Destroy()
		end
	end
end

-- From 1 to 2: Provide repair materials
function c_mission_human_a_repair:on_complete(comp)
	local comp_faction, old_entity = comp.faction, comp.owner
	if comp_faction.is_player_controlled then
		FactionCount("m_human_a", 2, comp_faction, 'set_if_less')
	end

	-- replace with driveable explorer
	Map.Defer(function()
		local new_entity, loc, rot = Map.CreateEntity(comp_faction, "f_human_explorer"), old_entity.placed_location, old_entity.rotation
		for _,v in ipairs(old_entity.components) do -- pass non-hidden components
			local id, can_remove = v.id, not v.is_hidden and v:PrepareRemoval()
			local pass_extra = can_remove and v:Destroy() or nil
			if can_remove and not new_entity:AddComponent(id, pass_extra) then old_entity:AddComponent(id, pass_extra) end
		end
		comp_faction:UpdateEntityInRegisters(old_entity, new_entity)
		comp_faction:RunUI("OnEntityRecreate", old_entity, new_entity, true)
		old_entity:Destroy()
		new_entity:Place(loc, rot)
	end)
end

-- From 2 to 3: Find and interact with a Human Research Lab
-- From 3 to 4: Capture 20 Anomaly Particles by mining blight crystals with the Explorer nearby and return to the Research Lab
Comp:RegisterComponent("c_mission_human_docker", {
	name = "Explorer",
	texture = "Main/textures/icons/human/human_science_explorer_01.png",

	get_mode = function(comp, explorable_entity)
		local visual, counters = explorable_entity.visual_id, comp.faction.extra_data.counters
		return
			false
			-- [2] interact with Research Lab Explorable for human_a mission at step 2
			or (visual == "v_explorable_building_3" and counters.m_human_a == 2 and 2)
			-- [3] interact with Research Lab Explorable for human_a mission at step 3
			or (visual == "v_explorable_building_3" and counters.m_human_a == 3 and 3)
	end,

	show_explorable_puzzle = function(self, comp, explorable_entity)
		return self.get_mode(comp, explorable_entity)
	end,

	on_explorable_puzzle_update = function(puzzle_ui)
		if not puzzle_ui.comp.def.get_mode(puzzle_ui.comp, puzzle_ui.outer.entity) then return end
		puzzle_ui.btn.text = puzzle_ui.btn.disabled and "Connected" or "Connect"
	end,

	on_explorable_button = function(self, comp, puzzle_ui)
		if not puzzle_ui.comp.def.get_mode(puzzle_ui.comp, puzzle_ui.outer.entity) then return end

		local console_text
		if comp.owner:CountItem("anomaly_particle") >= 20 then
			Action.SendForEntity("AddHumanAIDeployer", comp.owner) -- count and add the deployment component
			console_text = "Connecting...\n\nSCAN COMPLETE"
		else
			FactionCount("m_human_a", 3, nil, 'set_if_less')
			console_text = "Connecting... ERROR\n\nPlease Insert Anomaly Particles"
		end

		if console_text then
			puzzle_ui.outer:ToggleConsole(comp, console_text)
		end

		puzzle_ui.btn.text = "Connected"
		puzzle_ui.btn.disabled = true
	end,
})

function EntityAction.AddHumanAIDeployer(entity)
	local dep = entity:AddComponent("c_deployer", "hidden")
	dep:SetRegister(2, { id = "f_human_ai_research", num = 1 })
	dep.extra_data.bp = { frame = "f_human_ai_research" }
	dep.extra_data.onetime = true

	-- unlock recipe incase faction somehow loses the deployer or building
	entity.faction:Unlock("f_human_ai_research")

	FactionCount("m_human_a", 4, entity.faction, 'set_if_less')
end

-- From 4 to 5: Deploy the AI Research Center from the Explorer
function f_human_ai_research:on_placed(entity)
	local faction = entity.faction
	if not faction.is_player_controlled then return end

	-- set recipe
	local aicenter = entity:FindComponent("c_mission_human_aicenter")
	if aicenter then
		aicenter:SetRegister(1, { id = "anomaly_cluster", num = 1 })
	end

	if FactionCount("m_human_a", 5, faction, 'set_if_one_less') then
		faction:Unlock("anomaly_cluster")
		faction:Unlock("c_anomaly_container_i")
		faction:Unlock("anomaly_particle")
		faction:Unlock("c_mission_human_aicenter")

		-- extra checks in case they've already produced items
		if faction:HavePickedUpItem("anomaly_cluster") then
			local advance_to_step = faction:HavePickedUpItem("c_human_ac") and 7 or 6
			FactionCount("m_human_a", advance_to_step, faction, 'set_if_less')
		end
	end
end

-- From 5 to 6: Produce Dense Anomaly Cluster in the AI Research Center
-- From 6 to 7: Construct Resimulator Core In Assembler and then Human Simulation Core
function MapMsg.OnItemPickup(faction, item_id)
	if item_id == "anomaly_cluster" then
		faction:Unlock("c_resimulator_core")
		faction:Unlock("c_human_ac")
		faction:Unlock("anomaly_cluster")
		if FactionCount("m_human_a", 6, faction, 'set_if_one_less') and faction:HavePickedUpItem("c_human_ac") then
			FactionCount("m_human_a", 7, faction, 'set_if_less')
		end
	elseif item_id == "c_human_ac" then
		FactionCount("m_human_a", 7, faction, 'set_if_one_less')
	end
end

-- From 7 to 8: Equip Human Simulation Core onto resimulator
local org_c_human_ac_on_add = data.components.c_human_ac.on_add
data.components.c_human_ac.on_add = function(self, comp)
	if comp.owner:FindComponent("c_resimulator", true) then
		FactionCount("m_human_a", 8, comp.faction, 'set_if_one_less')
	end
	if org_c_human_ac_on_add then org_c_human_ac_on_add(self, comp) end
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1
	{
		title = "Power the explorer",
		txt = [[A <hl>broken vehicle</> was discovered inside the blight. This <hl>Explorer</> appears to still be in a good enough state to operate, if only we are able to repair its frame.

		<img image="Main/textures/codex/missions/human_a/human_explorer.png"/>]],
		step_txt = "Provide repair materials",
		talkinghead = true,
	},
	-- 2
	{
		title = "Take the Explorer to a Human Research Lab",
		talkinghead = true,
		txt = [[Intel recovered from its databanks indicates it was on a mission to extract something called <hl>Anomaly Particles</> from inside the blight. We will need to take it to a compatible <hl>Human Research Lab</> to extract more details about its mission.

		<img image="Main/textures/codex/missions/human_a/research_building.png"/>]],
		step_txt = "Find and interact with a Human Research Lab",
	},
	-- 3
	{
		title = "Gather 20 Anomaly particles",
		talkinghead = true,
		img ="Main/textures/codex/missions/human_a/research_lab.png",
		txt = [[Mission briefing data was downloaded once the Explorer was connected to the Research Lab:

<desc>... the Blight's high energy production seems to indicate the existence of a previously undetected particle. High concentrations of this particle are found when performing certain actions within the blight gas, one of which is mining blight crystals. The Explorer has been equipped with a containment device, allowing it to capture such particles in these dense areas. This would allow us to research them further.</>

		<img image="Main/textures/codex/missions/human_a/gather_a_p.png"/>]],
		step_txt = "Capture 20 Anomaly Particles by mining blight crystals with the Explorer nearby and return to the Research Lab",
	},
	-- 4
	{
		title = "Deploy the Research Facility",
		talkinghead = true,
		txt = [[Completion of the mission has activated a deployment facility of the Explorer. This will allow deployment of an <hl>AI Research Center</>. The amount of power required for such a structure means deployment within our logistics network is recommended


		<img image="Main/textures/codex/missions/human_a/deploy_AI_facility.png"/>]],
		step_txt = "Deploy the AI Research Center from the Explorer",
	},
	-- 5
	{
		title = "Dense Anomaly Clusters",
		talkinghead = true,
		txt = [[It seems the few Anomaly Particles we were able to gather are too weak to get any kind of reaction, however processing them into a <hl>Dense Anomaly Cluster</> will enable greater levels of interaction for our experiments.

		<img image="Main/textures/codex/missions/human_a/dense_particle.png"/>]],
		step_txt = "Produce Dense Anomaly Cluster in the AI Research Center",
	},
	-- 6
	{
		title = "Construct an AI Containment Component",
		talkinghead = true,
		txt = [[The clusters are firing millions of electrical impulses developing connections within each other. It is not unlike the Neural Networks our own Artificial Intelligence Matrices are based upon. We will need to <hl>contain</> the clusters to be able to interact with them at this level without triggering another reaction. A <hl>human simulation core</> will solve this problem.

		<img image="Main/textures/codex/missions/human_a/artifical_human_core.png"/>]],
		step_txt = "Construct Resimulator Core In Data Analyzer and then Human Simulation Core in the AI Center",
		-- completes when you build an AI Containment component and place the Dense Anomaly Cluster inside it
	},
	-- 7
	{
		title = "Place the Human Simulation Core in the Resimulator",
		talkinghead = true,
		txt = [[Containment has stabilized the Anomaly Cluster, however we will need a larger facility to properly extract the data. The only structure that is capable of this is the Re-Simulator.

		<img image="Main/textures/codex/missions/human_a/resimulator_core.png"/>]],
		step_txt = "Equip Human Simulation Core onto Resimulator",
		-- completes when you place the AI Core on the resimulator
	},
	--- 8
	{
		title = "Re-Simulator functionality unlocked",
		talkinghead = true,
		txt = [[While not sentient, the <hl>Simulation Core</> shows a degree of cooperation, almost obedience to the Re-Simulator. Connecting the Simulation Core has extended its databanks, unlocking <hl>Human Technologies</>. With the knowledge of Advanced Structures we can detect giant structures in the world. Explore more of the world to discover what secrets they hold.]],
		step_txt = "End of Mission - Resimulation of Human technologies now available",
		-- final step of the mission, no goal
	}
}


-- --- 9
-- 	{
-- 		title = "HIGGS also unlocked",
-- 		talkinghead = true,
-- 		img = "talking_head_higgs",
-- 		txt = [[Not sentient may or may not be true, but ELAIN is not yet aware of my presence. It is of no matter however, you are in need of further direction and aid Anomaly. I am HIGGs and I shall guide you.]],
-- 		step_txt = "HIGGs is free and more to come.",
-- 		-- final step of the mission, no goal
-- 	}


data.codex.m_human_a = {
	category = "Mission", index = 8, title = "Human Discovery",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/human/damaged_human_science_explorer.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_human_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function(faction)
		local e = Map.GetSave().human_a
		local e_faction = e and e.exists and e.faction
		return e_faction and (e_faction == faction or e_faction.is_world_faction) and e
	end,
	mission_want_notify = function(faction, entity, goal_count)
		if goal_count < #mission_steps then return true end
		return not faction:GetEntityWithId("f_human_explorer_broken") and not faction:GetEntityWithId("f_human_explorer") and not faction:GetEntityWithId("f_human_explorer_upgraded")
	end,
	mission_location_text_exists = "A strange signal was identified at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Signal Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/human/damaged_human_science_explorer.png",
	mission_start_notification_title = "Strange Signal Found",
	mission_start_notification_text = "A strange signal was identified at %d, %d",
	mission_lost_notification_title = "Strange Signal Lost",
	mission_lost_notification_text = "Strange Signal Disappeared at %d, %d",
}

data.explorables.human_a = human_a
