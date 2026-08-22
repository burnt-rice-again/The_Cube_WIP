local package = ...

-- called before init when starting a new game
function package:setup_scenario(settings)
	settings.seed = 0
	settings.is_challenge = true
end

local c3_signals = {
	{ metalbar = 3 },
	{ metalplate = 3 },
	{ crystal = 3, },
	{ c_uplink = 1 },
	{ c_fabricator = 1 },
}

-- called when mod is initializing
function package:init()
	Comp:RegisterComponent("c_challenge_tester", {
		name = "Requestor",
		texture = "Main/textures/icons/components/Component_HumanFactory.png",
		slot_type = "storage",
		activation = "Always",
		registers = {
			{ read_only = true, tooltip="Requestor"}
		},
		on_add = function(self, comp)
			for k,v in pairs(c3_signals[1]) do
				comp:SetRegister(1, {id = k, num = v})
				comp:LinkRegisterFromRegister(FRAMEREG_SIGNAL, 1)
				comp:LinkRegisterFromRegister(FRAMEREG_VISUAL, 1)
			end
			comp.extra_data = { idx = 1 }
		end,
		on_update = function(self, comp, trigger)
			local ed = comp.extra_data
			if c3_signals[ed.idx] == nil then return end
			local received_items = comp:PrepareConsumeProcess(c3_signals[ed.idx])

			if received_items then
				comp:FulfillProcess()
				ed.idx = ed.idx + 1
				if ed.idx > #c3_signals then
					comp:SetRegister(1, nil)
					Map.SetGameSpeed(0)
					UI.Run("EndChallenge", "signals1_best_tick", "Signals Challenge Complete!", "Main/textures/icons/items/metalbar.png", 'Main/Nomad')
					return
				end
			end

			for k,v in pairs(c3_signals[ed.idx]) do
				comp:SetRegister(1, {id = k, num = v})
			end
			return comp:SetStateSleep(1)
		end,
	})
end

function UIMsg.OnSetup(faction)
	UI.Run("StartChallenge", "Signals Challenge", "Main/textures/icons/items/metalbar.png", "Deliver requested ingredients automatically")
end

function package:post_init()
	data.explorables = {}
end

function package:on_world_spawn()
	local resource = Map.CreateEntity("world", "f_resourcenode_crystal", "v_crystalmedium1a")
	resource:SetRegister(FRAMEREG_GOTO, { item = 'crystal', amount = 273 })
	resource:Place(68, 38)
end

function package:on_player_faction_spawn(faction)
	faction.home_location = { 72, 41 }
	local loc = faction.home_location

	-- unlock starting tech/codex for this scenario for the local player (unlocked by default)
	faction:Unlock("t_robot_tech_basic")

	local bot1 = Map.CreateEntity(faction, "f_bot_1s_a")
	bot1:Place(loc.x + 0, loc.y + 0)
	bot1:AddComponent("c_adv_miner")
	bot1:AddComponent("c_power_cell")

	-- fabricator
	local frame1 = Map.CreateEntity(faction, "f_building2x2a")
	frame1:Place(loc.x + 1, loc.y + 0)
	frame1:AddItem("c_fabricator", 1)
	frame1:AddItem("c_signal_reader", 2)
	frame1:AddItem("c_behavior", 1)

	-- destination
	local frame2 = Map.CreateEntity(faction, "f_building2x2b")
	frame2:Place(loc.x - 6, loc.y + 4)
	frame2:AddComponent("c_challenge_tester", "hidden")
end
