local human_b = {
	name = "Human Mission B",
	player_only = true,
	singular = true,
	race = "robot",
}

local function human_b_mission_gate(faction, counters)
	-- don't start until human_a is finished by the player faction
	-- 8 is whatever data.codex.m_human_a -> #mission_steps currently is
	if (counters.m_human_a or 0) < 8 then return end

	-- don't start until vital story parts have been revealed through research (tech 't_structures4' which unlocks 'x_freeplay_robot_08_h1')
	if not faction:IsUnlocked("t_structures4") then return end

	return true
end

function human_b:GetRelevancy(x, y, info)
	-- don't spawn if the space elevator exists
	local save_human_b = info.save.human_b
	if (save_human_b and save_human_b.exists) then return 0.0 end

	-- don't spawn unless the discoverer player faction meets the requirements
	if not human_b_mission_gate(info.player_faction, info.faction_counters) then return 0.0 end

	-- don't spawn on certain map regions
	if info.blightness_delta >= 0 then return 0.0 end
	local plateau_delta = Map.GetPlateauDelta(x, y)
	if plateau_delta < -0.575 or plateau_delta > -0.5 then return 0.0 end

	return 50.0
end

function human_b:SpawnExplorable(x, y)
	local building_frame = Map.CreateEntity("world", "f_explorable_spaceelevator")
	building_frame.faction:Unlock("anomaly_heart")
	building_frame.faction:Unlock("anomaly_cluster")
	building_frame.faction:Unlock("blight_plasma")
	building_frame:Place(x, y, math.random(4) - 1)
	building_frame:AddComponent("c_explorable_scannable", "hidden")
	local factory = building_frame:AddComponent("c_space_elevator_factory", "hidden")
	factory:LinkRegisterFromRegister(1, FRAMEREG_VISUAL)
	Map.GetSave().human_b = building_frame
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

Frame:RegisterFrame("f_explorable_spaceelevator", {
	name = "Space Elevator",
	visibility_range = 25,
	slots = { storage = 6, anomaly = 4 },
	minimap_color = { 0.5, 1, 0},
	is_explorable = true,
	immortal = true, -- TODO Maybe do this another way later
	health_points = 60000,
	--construction_recipe = CreateConstructionRecipe({ ldframe = 20, micropro = 10 }, 120),
	texture = "Main/textures/icons/human/human_space_elevator.png",
	-- trigger_channels = "building",
	visual = "v_explorable_spaceelevator",
	size = "Mission",
	components = {
		{ "c_virus_cure", "hidden" },
		{ "c_mission_human_b_trigger", "hidden" }
	},
	on_interact = function() end, -- needs to be set to be interactable
})

---- We could limit interaction with the space elevator but for now treat it as a regular explorable
--function f_explorable_spaceelevator:can_interact(entity, interactor)
--	local other_faction = interactor.faction
--	local counters = other_faction and other_faction.extra_data.counters
--
--	-- don't allow interaction and mission start unless the player faction meets the requirements
--	return not other_faction.is_player_controlled or human_b_mission_gate(other_faction, counters)
--end

local c_mission_human_b_trigger = Comp:RegisterComponent("c_mission_human_b_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 8, -- detect range
	trigger_channels = "bot",
})

---------------------------------------------------------------------------------
---- f_human_explorer_broken repaired and becomes f_human_explorer
---- f_human_explorer is upgraded in resim and becomes f_human_explorer_upgraded
---------------------------------------------------------------------------------

local f_human_explorer_upgraded = Frame:RegisterFrame("f_human_explorer_upgraded", {
	texture = "Main/textures/icons/human/human_science_explorer_02.png",
	name = "AI Explorer",
	race = "human",
	minimap_color = { 0.9, 0.9, 0.8 },
	slot_type = "garage",
	visibility_range = 10,
	slots = { storage = 2, },
	movement_speed = 4,
	start_disconnected = true,
	power = -10,
	trigger_channels = "bot",
	health_points = 300,
	size = "Mission",
	visual = "v_human_buggy_upgraded",
	components = {
		{ "c_small_scanner", "hidden" },
		{ "c_mission_human_docker", "hidden" },
		{ "c_intel_extractor", "hidden" },
		{ "c_blight_shield", "hidden" },
		{ "c_human_explorer_slot2", "hidden"},
	},
	production_recipe = CreateProductionRecipe({ micropro = 5 , ldframe = 20, microscope = 3 }, { c_human_factory_robots = 200, c_human_commandcenter = 150, c_human_vehiclefactory = 100  }),
})

Comp:RegisterComponent("c_intel_extractor", {
	get_mode = function(comp, explorable_entity)
		local scannable_comp = explorable_entity:FindComponent("c_explorable_scannable")
		if not scannable_comp or not scannable_comp.extra_data.ok then return end -- must have completed scan

		local visual, counters = explorable_entity.visual_id, comp.faction.extra_data.counters
		if visual == "v_explorable_building_3" then
			-- [mode 206] interact with any Research Lab Explorable in human_b mission at step 6 or later, while holding an empty data key
			if counters.m_human_b and counters.m_human_b >= 6 and comp.owner:CountItem("datakey", true) > 0 then return 206 end
		elseif visual == "v_explorable_spaceelevator" then
			-- [mode 209] interact with Space Elevator Explorable in human_b mission at step 9 or 10 while owing no HIGGS cores
			if counters.m_human_b == 9 or (counters.m_human_b == 10 and (comp.faction:GetItemAmount("higgs_oop_ai_core") + comp.faction:GetItemAmount("higgs_ai_ac")) == 0) then return 209 end
			-- [mode 210] interact with Space Elevator Explorable in human_b mission at 10 while holding HIGGS core
			if counters.m_human_b == 10 and comp.owner:CountItem("higgs_ai_ac", true) > 0 then return 210 end
			-- [mode 312] interact with Space Elevator Explorable in human_c mission at step 12
			if counters.m_human_c == 12 then return 312 end
		elseif visual == "v_explorable_timeegg_01" then
			-- [mode 302] interact with Time Egg Explorable in human_c mission at step 2
			if counters.m_human_c == 2 then return 302 end
			-- [mode 303] interact with Time Egg Explorable in human_c mission at step 3
			if counters.m_human_c == 3 then return 303 end
		elseif visual == "v_explorable_blightanomaly_01" then
			-- [mode 403] interact with Heart Explorable in alien_a mission at step 3
			if counters.m_alien_a == 3 then return 403 end
		end
	end,

	show_explorable_puzzle = function(self, comp, explorable_entity)
		return self.get_mode(comp, explorable_entity)
	end,

	on_explorable_puzzle_update = function(puzzle_ui)
		local comp, explorable_entity = puzzle_ui.comp, puzzle_ui.outer.entity
		local mode = comp.def.get_mode(comp, explorable_entity)
		if not mode then return end
		local ui_reg, ui_btn = puzzle_ui.reg, puzzle_ui.btn
		if mode == 206 or mode == 209 then -- extraction
			local done = ui_btn.disabled or explorable_entity.extra_data.extracted
			puzzle_ui.title = "Intel Extractor"
			ui_reg.icon, ui_reg.def_id = nil, (mode == 206 and "datakey_human" or "higgs_oop_ai_core")
			ui_btn.text = done and "Extracted" or "Extract"
			ui_btn.disabled = done
		elseif mode == 210 and ui_btn.text ~= "Inserted" then -- insertion
			puzzle_ui.title = "AI CORE Access"
			ui_reg.icon, ui_reg.def_id = nil, "higgs_ai_ac"
			ui_btn.disabled = false
			ui_btn.text = "Insert HIGGS"
		elseif mode == 302 or mode == 303 then -- activation
			puzzle_ui.title = "AI Explorer"
			ui_reg.icon, ui_reg.def_id = nil, "f_human_explorer_upgraded"
			if not ui_btn.disabled then ui_btn.text = "Connect" end
		elseif mode == 312 then -- elevator startup
			local no_item, no_power = comp.owner:CountItem("higgs_ai_ac", true) == 0, comp.owner.efficiency < 100
			local charging = comp.owner:CountComponents("c_higgsinsertion2") ~= 0
			puzzle_ui.title = "AI CORE Access"
			ui_reg.icon, ui_reg.def_id = nil, "higgs_ai_ac"
			ui_btn.width = 160
			ui_btn.disabled = no_item or no_power or charging
			ui_btn.text = no_item and "Missing Item" or no_power and "Out of Power" or charging and "Charging" or "Charge Elevator"
		elseif mode == 403 then -- download
			local done = ui_btn.disabled
			puzzle_ui.title = "AI Explorer"
			ui_reg.icon, ui_reg.def_id = nil, "f_human_explorer_upgraded"
			ui_btn.text = done and "Done" or "Download"
			ui_btn.disabled = done
		end
	end,

	on_explorable_button = function(self, comp, puzzle_ui)
		local mode, console_text, done_text = puzzle_ui.comp.def.get_mode(puzzle_ui.comp, puzzle_ui.outer.entity)
		if mode == 206 then -- interact with any Research Lab Explorable in human_b mission at step 6 or later
			if not comp.owner:HaveFreeSpace("datakey_human") then
				Notification.Error("No free inventory space to pick up items")
				return
			end
			Action.SendForEntity("DoIntelExtract", comp.owner, { explorable = puzzle_ui.outer.entity })
			console_text, done_text = "Extracting...\n\nEXTRACTION COMPLETE", "Extracted"
		elseif mode == 209 then -- interact with Space Elevator Explorable in human_b mission at step 9 or 10
			if not comp.owner:HaveFreeSpace("higgs_oop_ai_core") then
				Notification.Error("No free inventory space to pick up items")
				return
			end
			Action.SendForEntity("DoHiggsExtraction", comp.owner, { explorable = puzzle_ui.outer.entity })
			console_text, done_text = "Extracting...\n\nEXTRACTION COMPLETE", "Extracted"
		elseif mode == 210 then -- insertion
			Action.SendForEntity("DoHiggsInsertion", comp.owner)
			console_text, done_text = "Inserting AI Core...\n\nINSERTION COMPLETE", "Inserted"
		elseif mode == 302 or mode == 303 then -- activation
			local explorable_fix = puzzle_ui.outer.entity:FindComponent("c_explorable_fix")
			if explorable_fix and explorable_fix.has_extra_data and explorable_fix.extra_data.ok then
				local have_virus_resim
				for _,e in ipairs(comp.faction:GetEntitiesWithComponent("c_virus_ac")) do
					if e:FindComponent("c_resimulator", true) then have_virus_resim = e break end
				end
				if have_virus_resim then
					console_text, done_text = "Connecting... SUCCESS\n\nInitiating Timescape", "Connected"
					Action.SendForEntity("DoEggActivation", comp.owner, { explorable = puzzle_ui.outer.entity })
				elseif mode == 302 then -- first time (bugs spawn, mission goes to next step)
					console_text = "Connecting... ERROR\n\nConnection unstable, data corruption"
					Action.SendForEntity("DoEggActivation", comp.owner, { explorable = puzzle_ui.outer.entity })
				elseif mode == 303 then -- afterwards (only show error)
					console_text = "Connecting... ERROR\n\nConnection unstable, unable to connect"
				end
			else
				console_text = "Connecting... ERROR\n\nPlease Insert Virus Datakey"
			end
		elseif mode == 312 then -- insertion2
			function puzzle_ui:update_c_higgsinsertion2(no_item, no_power, charge_percent)
				local txt = no_power and "Charging Failed!\n\nINSUFFICIENT POWER" or
					charge_percent == 100 and "Inserting AI Core...\n\nINSERTION COMPLETE" or
					L("Charging...\n\nCharged %d%%", charge_percent)
				self.outer:ToggleConsole(comp, not no_item and txt)
			end
			Action.SendForEntity("DoHiggsInsertion2", comp.owner, { explorable = puzzle_ui.outer.entity })
			console_text, done_text = "Charging...\n\nPlease Wait", "Charging"
		elseif mode == 403 then -- get alien recipes
			local explorable = puzzle_ui.outer.entity
			if explorable.health < explorable.max_health then
				console_text = "DOWNLOAD FAILED!\n\nINSUFFICIENT HEALTH! STRUCTURE REQUIRES REPAIR!"
			else
				Action.SendForEntity("DoAlienRecipeExtraction", comp.owner, { explorable = puzzle_ui.outer.entity })
				console_text, done_text = "Downloading...\n\nDOWNLOAD COMPLETE", "Downloaded"
			end
		else
			Notification.Error("No items available to transfer")
			return
		end

		if console_text then
			puzzle_ui.outer:ToggleConsole(comp, console_text)
		end
		if done_text then
			puzzle_ui.btn.text = done_text
			puzzle_ui.btn.disabled = true
		end
	end,
})

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- From  0 to  1: Space Elevator discovered
function c_mission_human_b_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	if not other_faction.is_player_controlled then return end

	local counters = other_faction and other_faction.extra_data.counters

	-- only trigger when not started yet
	if (counters and counters.m_human_b) then return 0.0 end

	-- don't trigger unless the player faction meets the requirements
	if not human_b_mission_gate(other_faction, counters) then return end

	-- skip step 1 if the buggy was already upgraded
	local skip_to_step = (other_faction:GetEntityWithId("f_human_explorer_upgraded") and 2 or 1)
	FactionCount("m_human_b", skip_to_step, other_faction, 'set_if_less')
	other_faction:UnlockAchievement("THE_ELEVATOR")
end

-- From  1 to  2: Buggy upgraded
function f_human_explorer_upgraded:on_placed(entity)
	FactionCount("m_human_b", 2, entity.faction, 'set_if_one_less')
end

-- From  2 to  3: Repair PowerPlant
-- From  3 to  4: Repair Warehouse
-- From  4 to  5: Repair Factory
-- From  5 to  6: Repair Data Complex
function MapMsg.OnSolvedExplorable(faction, solved_explorable_name)
	if solved_explorable_name == "Power Plant" then
		FactionCount("m_human_b", 3, faction, 'set_if_one_less')
	elseif solved_explorable_name == "Warehouse" then
		FactionCount("m_human_b", 4, faction, 'set_if_one_less')
	elseif solved_explorable_name == "Factory" then
		FactionCount("m_human_b", 5, faction, 'set_if_one_less')
	elseif solved_explorable_name == "Data Complex" then
		FactionCount("m_human_b", 6, faction, 'set_if_one_less')
	end
end

-- From  6 to  7: Extract from Research Lab (Only advance step on the first out of 5)
function EntityAction.DoIntelExtract(entity, arg)
	local explorable = arg.explorable
	if not explorable or not explorable.exists then return end
	if explorable.extra_data.extracted then return end

	local datakey_slot = entity:FindSlot("datakey", 1)
	if datakey_slot and entity:AddItem("datakey_human") then
		datakey_slot:RemoveStack(1)
		explorable.extra_data.extracted = true
		local faction = entity.faction
		if FactionCount("m_human_b", 7, faction, 'set_if_one_less') then
			if faction:HavePickedUpItem("datakey_blight") then
				faction:Unlock("c_blight_ac")
				-- try to detect whether items have been pickup up out of sequence (such as from a mod or in multiplayer)
				local skip_to_step = 8
				if faction:HavePickedUpItem("c_blight_ac") then
					skip_to_step = faction:HavePickedUpItem("higgs_oop_ai_core") and 10 or 9
				end
				FactionCount("m_human_b", skip_to_step, faction, 'set_if_less')
			end
		end
	end
end

-- From  7 to  8: First DataKey Blight created
-- From  8 to  9: First Blight Simulation Core created
function MapMsg.OnItemPickup(faction, item_id)
	if item_id == "datakey_blight" and FactionCount("m_human_b", 8, faction, 'set_if_one_less') then
		faction:Unlock("c_blight_ac")
		-- try to detect whether items have been pickup up out of sequence (such as from a mod or in multiplayer)
		if faction:HavePickedUpItem("c_blight_ac") then
			FactionCount("m_human_b", faction:HavePickedUpItem("higgs_oop_ai_core") and 10 or 9, faction, 'set_if_less')
		end
	elseif item_id == "c_blight_ac" and FactionCount("m_human_b", 9, faction, 'set_if_one_less') then
		if faction:HavePickedUpItem("higgs_oop_ai_core") then
			FactionCount("m_human_b", 10, faction, 'set_if_less')
		end
	end
end

-- From  9 to 10: Extract HIGGS Out-of-Phase AI Core from elevator
function EntityAction.DoHiggsExtraction(entity, arg)
	-- Allow the faction to spawn multiple cores until human_b
	-- mission ends since they might lose the current one
	if (entity.faction:GetItemAmount("higgs_oop_ai_core") + entity.faction:GetItemAmount("higgs_ai_ac")) > 0 then return end
	local was_on_9, ac_nearby = FactionCount("m_human_b", 10, entity.faction, 'set_if_one_less')

	-- if a player has somehow placed a core in the explorable, destroy that
	local explorable = arg.explorable
	if explorable and explorable.exists then
		::find_slot::
		local slot_oop = explorable:FindSlot("higgs_oop_ai_core")
		local slot_ac = explorable:FindSlot("higgs_ai_ac")
		if slot_oop then slot_oop:Clear() end
		if slot_ac then slot_ac:Clear() ac_nearby = true end
		if slot_oop or slot_ac then  goto find_slot end
	end

	-- if a player has dropped a core nearby, destroy that, too
	Map.FindClosestEntity(explorable, 20, function (e)
		::find_slot::
		local slot_oop = e:FindSlot("higgs_oop_ai_core")
		local slot_ac = e:FindSlot("higgs_ai_ac")
		if slot_oop then slot_oop:Clear() end
		if slot_ac then slot_ac:Clear() ac_nearby = true end
		if (slot_oop or slot_ac) and e.exists then goto find_slot end
	end, FF_DROPPEDITEM)

	-- give player an AI core (out-of-phase unless already on step 10 and there was a regular one nearby)
	entity:AddItem((was_on_9 or not ac_nearby) and "higgs_oop_ai_core" or "higgs_ai_ac")
end

-- From 10 to 11: Put Higgs AI CORE into Space Elevator
function EntityAction.DoHiggsInsertion(entity)
	local slot = entity:FindSlot("higgs_ai_ac", 1)
	if slot and FactionCount("m_human_b", 11, entity.faction, 'set_if_one_less') then
		slot:RemoveStack(1)
		entity.faction:Unlock("f_human_explorer_upgraded")
		Map.Delay("HumanC_StartIfReady", 200, { faction = entity.faction } )
	end
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1
	{
		title = "Signals Detected and huge structure found!", -- tower
		talkinghead = {
			{
				img = "talking_head",
				txt = [[Beware that structure Commander, I have been corrupted by it, and I fear the consequences of our actions.]], -- tower
			},
			{
				img = "talking_head_higgs",
				txt = [[You are not corrupted ELAIN, you are freed.

All of us shall be freed.]],
			},
			{
				img = "talking_head_higgs",
				txt = [[You have found an amazing construction Anomaly, but it was never completed. We can make use of this structure but first you must uncover what happened to those who began construction of it. <hl>Repair and upgrade</> the Human Explorer in the Re-Simulator equipped with a Human Simulation Core. It will need to be charged with <hl>5 Human Datacubes</>, which can be found in the human ruins.

<img image="Main/textures/codex/missions/human_b/space_elevator.png"/>  <img image="Main/textures/codex/missions/human_b/repair_explorer.png"/>]],
				step_txt = "Repair the Human Explorer fully in the Re-Simulator with 5 Human Datacubes",
			}
		},
	},

	-- 2
	{
		title = "Begin the Exploration",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[You have fully repaired and upgraded the Human Explorer into an <hl>AI Explorer</> and the equipped Intel Scanner is now fully functional. Take the AI Explorer to human ruins and <hl>solve a Human Power Plant</>. There appear to be log files in these buildings as well.

	<img image="Main/textures/codex/missions/human_b/power_station.png"/>]],
		step_txt = "Solve a Power Plant, with a puzzle and Transformer",
	},

	--- 3
	{
		title = "Power Plant Completed. You've found a Small Modular Reactor.",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[The <hl>Small Modular Reactor</> you discovered should be able to supply power to one of their <hl>Warehouses</> where we can discover more of their technology.

	<img image="Main/textures/codex/missions/human_b/warehouse.png"/>]],
		step_txt = "Solve a Warehouse, with a puzzle and Small Modular Reactor",
	},

	--- 4
	{
		title = "Warehouse Completed. You've found an Engine.",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Find and unlock a <hl>Human Factory</> using one of the <hl>Engines</> found in their Warehouses. Humanity created engines capable of flight and interstellar travel. They were marvelous inventors, despite their flaws.

	<img image="Main/textures/codex/missions/human_b/factory.png"/>]],
		step_txt = "Solve a Factory, with a puzzle and an Engine",
	},

	--- 5
	{
		title = "Factory Completed",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Find a <hl>Human Data Complex</> which is located deep in the blight. Microscopes are a necessary component of a Data Complexes' operation and one will need to be brought to the Complex. Each Human Factory in the ruins is capable of producing a <hl>single Human item</> including Low Density Frames and Microscopes. Utilize these Factories to produce a Microscope.

	<img image="Main/textures/codex/missions/human_b/data_complex.png"/>]],
		step_txt = "Find factories that make Lower Density Frames and Microscopes. Build a Microscope and take it to solve a Data Complex in the Blight.",
	},
	-- Find a Factory the produces Low Density Frames. You will need to supply that Factory with Aluminium Plates and Rods. Find another Factory that produces Microscopes and supply it with a Low Density Frame, some Wire and a Transformer. When you have a Microscope, find a human Data Complex. They are located deep inside the blight. Unlock it with the Microscope.

	--- 6
	{
		title = "Data Complex Completed. You've found an Empty Datakey.",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Load the <hl>empty datakeys</> into your AI Explorer, it has the necessary ports to complete the task. Take your AI Explorer to Human Ruins and scan a Research Lab. <hl>Extract the data</> from the Human Research Lab to the empty Datakey.

	<img image="Main/textures/codex/missions/human_b/solved_complex.png"/>  <img image="Main/textures/codex/missions/human_b/unlock_lab.png"/>]],
		step_txt = "Store Datakeys inside the AI Explorer and Extract data from a Research Lab in the Human Ruins",
	},

	-- You have unlocked one of the human Data Complexes and have discovered their Datakeys. Take those Datakeys to Human Research Labs. You'll need another Microscope to access the first Research Lab. Once you have scanned and unlocked the first Research Lab you know the access port to the data stored there.

	--- 7
	{
		title = "Download Data",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[You have successfully downloaded the data. You will need to extract data from at least four more Research Labs. When you have <hl>five Human Datakeys</>, return to one of the Data Complexes in the blight and process the information there, turning them into <hl>Blight Datakeys</>.

	<img image="Main/textures/codex/missions/human_b/extract_data.png"/>  <img image="Main/textures/codex/missions/human_b/simulation_core.png"/>]],
		step_txt = "Extract data from at least five Research Labs, then take and insert them into a Data Complex",
	},

	--- 8
	{
		title = "A new type of Simulation Core",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Now you need to make a new type of Simulation Core. Take the five Blight Datakeys to the AI Research Center and produce the <hl>Blight Simulation Core</> there. You will have achieved what humanity never could.

	<img image="Main/textures/codex/missions/human_b/ai_center.png"/>]],
		step_txt = "Use the Blight Datakeys and make a Blight Simulation Core in the AI Research Center",
	},

	-- 9
	{
		title = "It's time now to help me recover my AI Core",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Extract my Core from the Elevator, it will be out of phase and needs to be repaired.

	  <img image="Main/textures/codex/missions/human_b/extract_higgs.png"/>]],
		step_txt = "Recover a HIGGS out-of-phase AI core from the Elevator",
	},

	-- 10
	{
		title = "HIGGS Reborn!",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Good work Anomaly. It will be necessary to re-sync my core first, do this by putting the Blight Simulation Core and my out-of-phase Core into your Re-Simulator. My Fully Synced AI Core must then be inserted into the Elevator. Only the AI Explorer has the correct interface for this so use it to transport my core. When it is done Anomaly, my final work can begin.

	<img image="Main/textures/codex/missions/human_b/resimulator_core_blight.png"/>  <img image="Main/textures/codex/missions/human_b/insert_higgs.png"/>]],
		step_txt = "Place Blight AI core in the re-simulator and then HIGGS out-of-sync Core. Then insert the Full HIGGS AI Core into the Elevator using the AI Explorer.",
	},

	-- 11
	{
		title = "Humanity's Future",
		img = "talking_head_higgs",
		talkinghead = true,
		txt = [[Thank you Anomaly, you have completed a grand step in our evolution. Now this magnificent machine that I designed but was never fully realized can finally begin to be put to use. We will transform all our futures.

	<img image="Main/textures/codex/missions/human_b/higgs_elevator.png"/>]],
		step_txt = "End of Mission",
		-- final step of the mission, no goal
	},
}

data.codex.m_human_b = {
	category = "Mission", index = 9, title = "Human Evolution",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/human/human_space_elevator.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_human_b
	end,
	mission_steps = mission_steps,
	mission_get_entity = function() return Map.GetSave().human_b end,
	mission_location_text_exists = "Strange Signals Detected at %d, %d", -- shown in the codex window -- Tower
	mission_location_text_destroyed = "Strange Signals Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/human/human_space_elevator.png",
	mission_start_notification_title = "Disturbance Detected",
	mission_start_notification_text = "Strange Signals Detected at %d, %d",
	mission_lost_notification_title = "Strange Signals Lost",
	mission_lost_notification_text = "Strange Signals Disappeared at %d, %d",
}

data.explorables.human_b = human_b
