local ai_base = {
	name = "AI Base",
	player_only = true,
	singular = true,
	race = "robot",
}

function ai_base:GetRelevancy(x, y, info)
	-- don't spawn too early
	if math.abs(x) + math.abs(y) < 400 then return 0.0 end

	-- only spawn if robot base exists
	local robot_base = info.save.robot_base
	if not robot_base or not robot_base:ExistsOnFaction("anomaly") then return 0.0 end

	-- don't spawn if it exists
	local save_ai_base = info.save.ai_base
	if (save_ai_base and save_ai_base:ExistsOnFaction("anomaly")) then return 0.0 end

	if info.faction_level < 5 then return 0.0 end

	-- don't spawn for factions that have finished the mission
	if (info.faction_counters.m_aibase_a or 0) >= 2 then return 0.0 end

	if math.random(2) == 1 then return 0.0 end
	return info.blightness_delta < -0.05 and info.elevation_delta < -0.1 and 100.05 or 0.0
end

function ai_base:SpawnExplorable(x, y)
	-- foundations
	local anomaly_faction = GetAnomalyFaction()
	for _x=-5,5 do
		for _y=-5,5 do
			Map.CreateEntity(anomaly_faction, "f_foundation_basic"):Place(x+_x, y+_y)
		end
	end

	local base = Map.CreateEntity(anomaly_faction, "f_landingpod")
	base:Place(x, y, math.random(4)-1)
	base:AddComponent("c_fabricator")
	local autobase = base:AddComponent("c_autobase")
	anomaly_faction.home_entity = base

	--UploadBehavior(autobase, Tool.StringToTable("1Ge2iqTH61BbRzr1aSXsu4URl7a35UrTl0m3a2K46wvlR2fVNqA3ejZHX21zKdZ2gGBqG0HDdnv2Pv2e24Z8UsQ2tmSId2WPXm40SIAuZ0aP9xs15qf9F4Vq0jf433sHD2MGpfG1YjbsT29EjHV2VWmpV1Ts03X2ZzVoe1YfgjL0Ueysg2esODS2gXngn0CtLBg15BGw34Vp2984QgYCf19au5R1VCifp0CmiCC2iMnxu3dGICP4HWpoN2HzdwH36tytB3bzxWU1oq2uH16CIHd3sDD2a2C9WcE3ThYz104Lm0r3W9MuR2gaaPj04KzE603yG1L1jv4lb1V0yUC4SMMJk0HPSWF3YRYuC3fSnVe0xhPMJ0SSoFC0xQq1P04DFmS4FjNl81wYrsI0RrAGI2v6bmF2cbmgr0oS2YE0wsMul4KZKNv1i4UXi3nlgHE03b4JS273CzR1EZUHF2QjhXQ3NWMUB2P3Faf2rtnMD1PwxKd2D1Iak3EJMlF4WSl6b1KMvm02nQ44X1hjdnz1aN1451Bzi272JqhD03NtuQY1wSj1G2ZcV1N1ADkBs3wHibz2AO47M4aWroR06cnme2oaOfO0eD7N82sMVv00HucrJ3oaHy72L4b3F4LTGZJ3jRmI94PJfW50G5ZCu4OKznP3UpANV1ZrLQ43sf5Cf2x8PL30jiW0O0FXCq629iojS0aiINV2XWcws1mdrXA2c2w7p2WOJz51rrkzy0Tzj9Z2gaJkh1aUTHZ0UqBdz486fT10UwDTs3CLTv00BlwWt4Qj56G43OHtA22kKId1hPqcl1qXKzz2ENFPJ2qJq4o01ABq94EZ3OH3auQLz0crems0nFIgv2jJmJm0mcNFV2sZm7E3J9mZr0GsHQT08VfIo4K8D5f2FeHWI04GezP4RBGQA00zUEO4Obxbud"))
	--UploadBehavior(autobase, Tool.StringToTable("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"))
	UploadBehavior(autobase, Tool.StringToTable("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"))
	base:AddComponent("c_aibase_trigger", "hidden")
	base:AddComponent("c_power_cell")
	--base:AddItem("metalore", 26)
	base:AddItem("metalbar", 20)
	base:AddItem("metalplate", 20)
	base:AddItem("crystal", 40)
	base:AddItem("robot_datacube", 5)

	Map.GetSave().ai_base = base

	anomaly_faction:Unlock("t_robot_tech_basic")
	anomaly_faction:Unlock("c_behavior")
	anomaly_faction:Unlock("c_autobase")
	anomaly_faction:Unlock("robot_datacube")

	local metalorenode = Map.CreateEntity("world", "f_resourcenode_metal", "v_metalrich1")
	metalorenode:SetRegister(FRAMEREG_GOTO, { id = "metalore", num = 8200 })
	metalorenode:Place(x+9, y+2)

	local crystalnode = Map.CreateEntity("world", "f_resourcenode_crystal", "v_crystal_rich1")
	crystalnode:SetRegister(FRAMEREG_GOTO, { id = "crystal", num = 8200 })
	crystalnode:Place(x-7, y-9)

	local silicanode = Map.CreateEntity("world", "f_resourcenode_silica", "v_big_daikon")
	silicanode:SetRegister(FRAMEREG_GOTO, { id = "silica", num = 5200 })
	silicanode:Place(x-6, y+9)

	local bot1 = Map.CreateEntity(anomaly_faction, "f_bot_1s_adw")
	bot1:AddComponent("c_adv_miner", 1)
	bot1:Place(x+1, y+3)
	bot1.disconnected = false
	bot1.logistics_carrier = false

	local bot2 = Map.CreateEntity(anomaly_faction, "f_bot_1s_adw")
	bot2:AddComponent("c_adv_miner", 1)
	bot2:Place(x-1, y+3)
	bot2.disconnected = false
	bot2.logistics_carrier = false

	local bot3 = Map.CreateEntity(anomaly_faction, "f_bot_1s_adw")
	bot3:AddComponent("c_adv_miner", 1)
	bot3:Place(x+0, y+3)
	bot3.disconnected = false
	bot3.logistics_carrier = false

	-- Defence Bot
	local bot5 = Map.CreateEntity(anomaly_faction, "f_bot_1s_as")
	bot5:AddComponent("c_portable_turret", 1)
	bot5:Place(x-2, y+2)
	bot5.disconnected = false
	bot5.logistics_carrier = false
end

---------------------------------------- MISSION FRAMES & COMPONENTS ------------------------------------------------------

local c_aibase_trigger = Comp:RegisterComponent("c_aibase_trigger", {
	texture = "Main/textures/icons/components/int.png",
	power = 0,
	trigger_radius = 12,
	trigger_channels = "bot",
})

------------------------------------------------ FLOW ---------------------------------------------------------------------

-- To 1: Mission Start
-- From 1 to 2: Observe the AI base
function c_aibase_trigger:on_trigger(comp, other_entity)
	local other_faction = other_entity.faction
	local other_extra_data = other_faction.extra_data
	if other_faction.is_player_controlled then
		if FactionCount("m_aibase_a", 1, other_faction, 'set_if_less') then
			other_extra_data.aibase = { Map.GetTick() + 600 }
		elseif other_extra_data.aibase and Map.GetTick() > other_extra_data.aibase[1] and FactionCount("m_aibase_a", 2, other_faction, 'set_if_less') then
			other_faction:Unlock("c_autobase")
			other_faction:Unlock("anomaly_cluster")
			other_extra_data.aibase = nil
		end
	end
end

-- Optional from 1 to 2: Destroy the base and take the c_autobase component
function MapMsg.OnItemPickup(faction, item_id)
	if item_id == "c_autobase" and faction.is_player_controlled and FactionCount("m_aibase_a", 2, faction, 'set_if_one_less') then
		faction.extra_data.aibase = nil
	end
end

------------------------------------------------ INFO ---------------------------------------------------------------------

local mission_steps = {
	-- 1 -- discover the ai base
	{
		title = "AI",
		talkinghead = true,
		txt = [[There appears to be an AI core controlling this base. To what purpose we cannot but sure. Let us monitor the situation before planning our next course of action.]],
		step_txt = "Observe the AI base",
	},
	-- 2 -- discover AI core
	{
		title = "AI Behaviors",
		talkinghead = true,
		txt = [[The AI Core at the heart of the base is an advanced version of our own Behavior Controllers. We should be able to modify them using similar means. With this new technology we will be able to set up fully automated remote bases.]],
		step_txt = "AI Behavior Controllers have been unlocked - End of Mission",
	},
}

data.codex.m_aibase_a = {
	category = "Mission", index = 5, title = "AI Base",
	steps = #mission_steps,
	goalicon = "Main/textures/icons/items/ai_core_ALIEN.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_aibase_a
	end,
	mission_steps = mission_steps,
	mission_get_entity = function()
		local e = Map.GetSave().ai_base
		return e and e:ExistsOnFaction("anomaly") and e
	end,
	mission_location_text_exists = "AI Signature identified at %d, %d", -- shown in the codex window
	mission_location_text_destroyed = "AI Signature Lost", -- shown in the codex window
	mission_minimap_pin = "Main/textures/icons/items/ai_core.png",
	mission_start_notification_title = "AI Signature Found",
	mission_start_notification_text = "AI Signature identified at %d, %d",
	mission_lost_notification_title = "AI Signature Lost",
	mission_lost_notification_text = "AI Signature disappeared at %d, %d",
}

data.explorables.ai_base = ai_base
