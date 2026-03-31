local robot_base = {
	name = "Robot Base",
	singular = true,
	race = "robot",
}

function robot_base:GetRelevancy(x, y, info)
	-- don't spawn if it exists
	local save_robot_base = info.save.robot_base
	if (save_robot_base and save_robot_base:ExistsOnFaction("anomaly")) then return 0.0 end

	-- check location
	if info.blightness_delta >= -0.05 or info.elevation_delta >= -0.05 then return 0.0 end

	-- check if an anomaly was cured
	if info.save.robot_spawn then return 5.0 end

	-- check if its a player faction
	if not info.player_faction then return 0.0 end

	-- don't spawn too early
	if math.abs(x) + math.abs(y) < 400 then return 0.0 end

	-- don't spawn for factions that have finished the mission
	if (info.faction_counters.m_anomaly_a or 0) >= 6 then return 0.0 end -- got far enough

	if info.faction_level < 4 then return 0.0 end

	if math.random(2) == 1 then return 0.0 end

	return 1.0
end

function robot_base:SpawnExplorable(x, y)
	-- foundations
	local anomaly_faction = GetAnomalyFaction()
	for _x=-6,6 do
		for _y=-6,6 do
			Map.CreateEntity(anomaly_faction, "f_foundation"):Place(x+_x, y+_y)
		end
	end

	local base = Map.CreateEntity(anomaly_faction, "f_landingpod")
	base:Place(x+math.random(-3, 3), y+math.random(-3, 3), math.random(4)-1)
	base:AddComponent("c_fabricator"):SetRegister(1, { id = "metalbar", amount = -1 })

	local radar = base:AddComponent("c_portable_radar")
	radar:SetRegister(1, { id = "v_enemy_faction" })
	radar:LinkRegisterFromRegister(FRAMEREG_SIGNAL, 4)

	local storage = Map.CreateEntity(anomaly_faction, "f_building1x1f")
	storage:Place(x+math.random(-3, 3), y+math.random(-3, 3), math.random(4)-1)
	storage:AddComponent("c_power_cell", "hidden")

	local resimulator = Map.CreateEntity(anomaly_faction, "f_anomaly_sim")
	resimulator:Place(x+math.random(-3, 3), y+math.random(-3, 3), math.random(4)-1)

	Map.GetSave().robot_base = resimulator

	-- scout turrets
	for i=1,math.random(2, 4) do
		local guard = Map.CreateEntity(anomaly_faction, "f_bot_1s_as")
		guard:Place(x+math.random(-3, 3), y+math.random(-3, 3))
		guard:AddComponent("c_portable_turret"):LinkRegisterFromRegister(1, FRAMEREG_GOTO)
		guard:SetRegister(2, {entity = base})
		local signal_reader = guard:AddComponent("c_signal_reader")
		signal_reader:SetRegister(1, { entity = base })
		signal_reader:LinkRegisterFromRegister(FRAMEREG_GOTO, 2)
	end

	-- mark V
	for i=1,math.random(1, 2) do
		local guard = Map.CreateEntity(anomaly_faction, "f_bot_1m_c")
		guard:Place(x+math.random(-3, 3), y+math.random(-3, 3))
		local turret = math.random() > 0.5 and "c_laser_turret" or "c_turret"
		guard:AddComponent(turret):LinkRegisterFromRegister(1, FRAMEREG_GOTO)
		guard:SetRegister(2, {entity = base})
		local signal_reader = guard:AddComponent("c_signal_reader")
		signal_reader:SetRegister(1, { entity = base })
		signal_reader:LinkRegisterFromRegister(FRAMEREG_GOTO, 2)
	end

	local worker = Map.CreateEntity(anomaly_faction, "f_bot_1s_a")
	worker:Place(x+math.random(-3, 3), y+math.random(-3, 3))
	worker:AddComponent("c_miner"):SetRegister(1, { id = "metalore", amount = REG_INFINITE })
	worker:SetRegister(2, {entity = storage})

	anomaly_faction:Unlock("metalbar")
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

local f_anomaly_sim = data.frames.f_building_sim:RegisterFrame("f_anomaly_sim", {
	size = "Special", race = "robot", index = 1999, name = "Anomaly Resimulator",
	construction_recipe = false,
	components = {
		{ "c_virus_cure", "hidden" },
		{ "c_resimulator", "hidden" },
		{ "c_anomaly_resimulator_trigger", "hidden" },
	},
})

local c_anomaly_resimulator_trigger = Comp:RegisterComponent("c_anomaly_resimulator_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 8,
	trigger_channels = "bot",
})

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- To 1: Mission Start, discover the anomaly base
function c_anomaly_resimulator_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	if other_faction.is_player_controlled then
		FactionCount("m_anomaly_a", 1, other_faction, 'set_if_less')
	end
end

-- From 1 to 2: Interact with the Resimulator in the anomaly base
function f_anomaly_sim:on_interact(entity, interactor_entity, is_retry)
	local interactor_faction = interactor_entity.faction
	if not interactor_faction.is_player_controlled or is_retry then return end
	if interactor_entity:FindComponent("c_anomaly_event") then return end

	-- check if they've already got the virus container or source code somehow and maybe step ahead
	local advance_to_step = 2
	if interactor_faction:HavePickedUpItem("c_virus_container_i") then
		advance_to_step = 3
		if interactor_faction:HavePickedUpItem("virus_source_code") then
			advance_to_step = 4
		end
	end

	-- trigger mission
	if FactionCount("m_anomaly_a", advance_to_step, interactor_faction, 'set_if_less') then
		interactor_faction:Unlock("c_virus_container_i")
		interactor_faction:Unlock("v_anomaly")
	end

	if interactor_entity:CountItem("virus_source_code") > 0 then
		interactor_entity:AddComponent("c_anomaly_event", "hidden")
		UI.Run("NotifyAnomaly", entity, true)
	end
end

-- From 2 to 3: build a virus container
-- From 3 to 4: after capturing the virus
function MapMsg.OnItemPickup(faction, item_id)
	if item_id == "c_virus_container_i" or item_id == "virus_source_code" then
		local counters = faction.extra_data.counters
		local count = counters and counters.m_anomaly_a or 0
		if count >= 2 and count < 4 and (item_id == "c_virus_container_i" or faction:HavePickedUpItem("c_virus_container_i")) then
			local advance_to_step = 3
			if item_id == "virus_source_code" or faction:HavePickedUpItem("virus_source_code") then
				advance_to_step = 4
			end
			FactionCount("m_anomaly_a", advance_to_step, faction, 'set_if_less')
		end
	end
end

-- From 4 to 5: interacting with the resimulator for the first time teleports you (teleporting without a virus protection will result in being infected)
-- From 5 to 6: after it teleports you back the first time
local org_c_anomaly_event_on_update = data.components.c_anomaly_event.on_update
data.components.c_anomaly_event.on_update = function(self, comp, cause)
	local state = comp.extra_data.state
	if not state then -- 1
	elseif state == 2 then -- teleporting
		if FactionCount("m_anomaly_a", 5, comp.faction, 'set_if_one_less') then
			comp.faction:Unlock("c_resimulator_core")
			comp.faction:Unlock("c_virus_ac")
		end
	else -- teleport back
		if FactionCount("m_anomaly_a", 6, comp.faction, 'set_if_one_less') then
			local have_virus_resim
			for _,e in ipairs(comp.faction:GetEntitiesWithComponent("c_virus_ac")) do
				if e:FindComponent("c_resimulator", true) then have_virus_resim = e break end
			end
			if have_virus_resim then
				FactionCount("m_anomaly_a", 7, comp.faction, 'set_if_less')
			end
		end
	end
	org_c_anomaly_event_on_update(self, comp, cause)
end

-- From 6 to 7: create the Virus Simulation Core and equip it on the resimulator
local org_c_virus_ac_on_add = data.components.c_virus_ac.on_add
data.components.c_virus_ac.on_add = function(self, comp)
	if comp.owner:FindComponent("c_resimulator", true) then
		local counters = comp.faction.extra_data.counters
		local count = counters and counters.m_anomaly_a or 0
		if count >= 5 and count < 7 then -- handle dying while teleported
			FactionCount("m_anomaly_a", 7, comp.faction, 'set_if_less')
		end
	end
	if org_c_virus_ac_on_add then org_c_virus_ac_on_add(self, comp) end
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1 -- discover the anomaly base
	{
		title = "Robots",
		talkinghead = true,
		txt = [[This outpost utilizes the same technology as our own. This is truly odd. We have discovered much of our own technology on this world even though we have no record of having landed here before. Something seems different with this base's <hl>Resimulator</>, we should investigate it.]],
		step_txt = "Interact with the Resimulator in the anomaly base",
	},
	-- 2 -- interact with the anomaly base
	{
		title = "Anomaly",
		talkinghead = true,
		txt = [[This technology is indeed our own, but it seems out of place and is creating a wormhole-like tear in our world. It appears to be incomplete... There is code missing. I believe this has something to do with the <hl>virus</> infecting our world and I have recovered a <hl>recipe</> for containing it.]],
		step_txt = "Build the virus container",
	},
	-- 3 -- build a virus container
	{
		title = "Containment",
		talkinghead = true,
		txt = [[In order to recover a sample we will need to find bots that have been <hl>glitched</> by the virus. They seem to have been exploring the plateau areas when they got infected, you can use your radar and scan for 'Anomaly' to help locate them. You will need both a <hl>Virus Cure</> component and the <hl>Virus Container</> component. Bring a bot with both these components into close range of a Glitched bot and when it is cured you will be able to extract a part of the <hl>virus code</>.]],
		step_txt = "Scan for 'Anomaly' using a radar to find more infected bots, and then capture the virus while curing them",
	},
	-- 4 -- after capturing the virus
	{
		title = "Virus",
		talkinghead = true,
		txt = [[Excellent, you have extracted a key part of the virus source code. These contaminated units do not appear to be originally from our world. They are nearly the same technology as our own, but have come through a wormhole from an <hl>alternate world</>, possibly through a resimulator. We should head back to the anomaly robot base and insert it into their <hl>resimulator</>.]],
		step_txt = "Interact with the resimulator at the anomaly robot base",
	},
	-- 5 -- interacting with the resimulator for the first time teleports you (teleporting without a virus protection will result in being infected)
	{
		title = "Wormholes",
		talkinghead = true,
		txt = [[Success! With the source code completed you were pulled through the <hl>wormhole</> created by the anomaly resimulator. I was able to analyze the readings I took and have been able to reproduce the phenomenon. Make a <hl>Virus Simulation Core</> in your Data Analyzer and insert it into your resimulator. The virus source code will then produce the same effect with our own tech. The exact application is still uncertain and more experimentation will need to be carried out, but we at least understand now how duplicate technology of our own has entered our world.]],
		step_txt = "Produce the Virus Simulation Core and equip it on the resimulator",
	},
	-- 6 -- after it teleports you back the first time
	{
		title = "Limited edition",
		talkinghead = true,
		txt = [[These do not appear to be full wormholes but rather <hl>tethers</> that allow for limited travel to a location. The tether weakens over time and space is unfolded leaving you at your original location.]],
		step_txt = "Produce the Virus Simulation Core and equip it on the resimulator",
	},
	-- 7 -- create the Virus Simulation Core and equip it on the resimulator
	{
		title = "World virus",
		talkinghead = true,
		txt = [[With this we should now be able to use our own resimulator to travel using these tethered wormholes. Connection of the Virus Simulation Core has also resulted in <hl>new recipes</> being unlocked.]],
		step_txt = "End Of Mission",
	},
}

data.codex.m_anomaly_a = {
	category = "Mission", index = 3, title = "Anomaly Base",
	steps = 7,
	goalicon = "Main/textures/icons/frame/glitchbot.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_anomaly_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function()
		local e = Map.GetSave().robot_base
		return e and e:ExistsOnFaction("anomaly") and e
	end,
	mission_location_text_exists = "A strange signal was identified at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "Strange Signal Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/frame/glitchbot.png",
	mission_start_notification_title = "Strange Signal Found",
	mission_start_notification_text = "A strange signal was identified at %d, %d",
	mission_lost_notification_title = "Strange Signal Lost",
	mission_lost_notification_text = "Strange Signal Disappeared at %d, %d",
}

data.explorables.robot_base = robot_base
