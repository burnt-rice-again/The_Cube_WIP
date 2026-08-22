local package = ...

-- called before init when starting a new game
function package:setup_scenario(settings)
	settings.seed = 2
	--settings.blightness_params = { frequency = 0, scale = -0.3, bias = 0.0 } =  -- make lots of forest
	settings.blightness_params = { scale = 0, bias = -1.0 }
	settings.is_challenge = true
end

function UIMsg.OnSetupInputMapping()
	Input.RemoveActionBinding("Build") -- remove build menu
	Input.BindAction("Build", "Pressed", function() Notification.Warning("Build Menu disabled for this challenge") end)
end

-- called when challenge is initializing
function package:init()
	-- remove build instruction
	data.instructions.build = nil
	for _,v in pairs(data.frames) do
		v.construction_recipe = nil
	end
	data.techs.t_research1.uplink_recipe.ingredients.robot_datacube = nil

	Comp:RegisterComponent("c_challenge_tester", {
		nName = "Tester",
		slot_type = "storage",
		activation = "Always",
		on_update = function(self, comp, trigger)

			local num_plates = comp.faction:GetItemAmount("hdframe")
			if num_plates < 50 then
				return comp:SetStateSleep(1)
			end

			Map.SetGameSpeed(0)
			UI.Run("EndChallenge", "nomad1_best_tick", "Challenge Complete!", "Main/textures/icons/items/high_density_frame.png")
		end,
	})
end

function UIMsg.OnSetup(faction)
	UI.Run("StartChallenge", "Nomad Challenge", "Main/textures/icons/items/high_density_frame.png", "Store 50 High Density Frames without constructing buildings")
	-- remove build button
	local build_button = UI.FindWidgetWithProperty("id", "btn_build")
	if build_button then build_button.disabled = true end
end

function package:post_init()
	data.explorables = {}
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

	Map.CreateEntity(faction, "f_empty"):AddComponent("c_challenge_tester", "hidden")
end
