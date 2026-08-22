local package = ...

-- called before init when starting a new game
function package:setup_scenario(settings)
	settings.seed = 2
	--settings.blightness_params = { frequency = 0, scale = -0.3, bias = 0.0 } =  -- make lots of forest
	settings.blightness_params = { scale = 0, bias = -1.0 }
	settings.is_challenge = true
end

-- called when challenge is initializing
function package:init()
	UIMsg:UnbindAll("OnExecuteAction")
	UIMsg:Bind("OnExecuteAction", function() Notification.Warning("This action is disabled for this challenge") end)

	Comp:RegisterComponent("c_challenge_tester", {
		nName = "Tester",
		slot_type = "storage",
		activation = "Always",
		on_update = function(self, comp, trigger)

			local num_plates = comp.owner.faction:GetItemAmount("hdframe")
			if num_plates < 50 then
				return comp:SetStateSleep(1)
			end

			Map.SetGameSpeed(0)
			UI.Run("EndChallenge", "registers2_best_tick", "Registers Challenge 2 Complete!", "Main/textures/icons/items/high_density_frame.png", 'Main/Signals')
		end,
	})
end

function UIMsg.OnSetup(faction)
	UI.Run("StartChallenge", "Register Challenge 2", "Main/textures/icons/items/high_density_frame.png", "Store 50 High Density Frames by setting registers")
end

function package:post_init()
	data.explorables = {}
	data.techs.t_research1.uplink_recipe.ingredients.robot_datacube = nil
end

function package:on_world_spawn()
	local resource = Map.CreateEntity("world", "f_resourcenode_crystal", "v_crystalmedium1a")
	resource:SetRegister(1, { item = 'crystal', amount = 80 })
	resource:Place(-4, 30)

	local resource = Map.CreateEntity("world", "f_resourcenode_metal", "v_metalmedium2a")  --"v_metalmedium1a"
	resource:SetRegister(1, { item = 'metalore', amount = 80 })
	resource:Place(4, 30)
end

function package:on_player_faction_spawn(faction)
	faction.home_location = {0,9}
	local loc = faction.home_location

	-- unlock starting tech/codex for this scenario for the local player (unlocked by default)
	faction:Unlock("t_robot_tech_basic")
	faction:Unlock("c_portable_radar")
	faction:Unlock("c_behavior")

	-- lander bot
	local lander = Map.CreateEntity(faction, "f_bot_2m_as")
	lander:AddComponent("c_power_cell")
	lander:AddItem("c_adv_miner", 1)
	lander:AddItem("c_fabricator", 1)
	lander:AddItem("c_portable_radar", 1)
	lander:AddItem("c_behavior", 1)
	--lander:AddItem("c_portable_radar", 1)
	lander:Place(loc.x, loc.y)
	lander.extra_data.name = 'ChallengeBot'
	faction.home_entity = lander

	--local bot1 = Map.CreateEntity(faction, "f_bot_1s_as")
	--bot1:Place(loc.x-2, loc.y+3)

	--local bot2 = Map.CreateEntity(faction, "f_bot_1s_as")
	--bot2:Place(loc.x+3, loc.y+4)

	Map.CreateEntity(faction, "f_empty"):AddComponent("c_challenge_tester", "hidden")
end
