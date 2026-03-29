local package = ...

-- files loaded when mod is initializing
package.includes = {
	"utilities.lua",
	"library.lua",
	"actions.lua",
	"biomes.lua",
	"values.lua",
	"behaviors.lua",
	"items.lua",
	"components.lua",
	"puzzles.lua",
	"frames.lua",
	"cliffs.lua",
	"landfeatures.lua",
	"techs.lua",
	"tech/tech_robots.lua",
	"tech/tech_blight.lua",
	"tech/tech_alien.lua",
	"tech/tech_human.lua",
	"tech/tech_virus.lua",
	"codex.lua",
	"visualassets.lua",
	"visuals.lua",
	"instructions.lua",
	"effects.lua",
	"explorables.lua",
	"explorables/ai_base.lua", -- ai base mission 1
	"explorables/alien_a.lua", -- alien ruins
	"explorables/alien_unit.lua", -- random alien soldier
	"explorables/blight_a.lua", -- disappearing alien mission 1
	"explorables/human_a.lua", -- broken explorer mission 1
	"explorables/human_b.lua", -- elevator mission 1
	"explorables/human_building_blight.lua", -- data complex in blight
	"explorables/human_c.lua", -- human timescape mission 1
	"explorables/robot_base.lua", -- robot anomaly resim mission 1
	"explorables/spawn_base_human.lua", -- human base
	"explorables/spawn_base_alien.lua", -- alien base
	"explorables/alien_artifact.lua",
	"explorables/alien_building.lua", -- blight alien buildings
	"explorables/broken_ship.lua", -- rusted buildings in desert
	"explorables/crashed_ship.lua", -- crashed robot mothership
	"explorables/enemy_unit.lua", -- alien hives
	"explorables/giant_enemy.lua", -- gigakaiju
	"explorables/human_building.lua", -- human ruined city
	"explorables/mining_base.lua", -- destroyed mining base 1
	"explorables/roaming_bot.lua", -- glitch bot
	"explorables/ruined_components.lua", -- random robot ruined components
	"explorables/world_a.lua", -- silica tree mission 1
	"stability.lua",
}

function package:setup_scenario(settings)
	if settings.elevation_params_scale then
		settings.elevation_params.scale = settings.elevation_params_scale
		settings.elevation_params_scale = nil
	end
	if settings.elevation_params_freq then
		settings.elevation_params.frequency = settings.elevation_params_freq
		settings.elevation_params_freq = nil
	end
end

-- called when mod is initializing
function package:init()
	data.settings.world_faction = "world"
	data.settings.foundation_frame = "f_foundation"
	data.settings.dropped_item_frame = "f_dropped_item"
	data.settings.dropped_item_visual = "v_dropped_item"
	data.settings.dropped_item_slots = 4
	data.settings.dropped_item_distance = 3
	data.settings.inventory_item_visual = "v_default_item"
	data.settings.inventory_component_visual = "v_default_component"
	data.settings.click_sound_effect = "fx_ui_MOUSE_HOVER"
	data.settings.added_component_effect = "fx_digital_in"
	data.settings.removed_component_effect = "fx_digital"
	data.settings.default_faction_colors = {
		bugs = { 1.00, 0.00, 0.00 },
	}
	data.settings.player_colors = {
		{ 1.00, 0.30, 0.00 }, -- orange red
		{ 1.00, 0.00, 0.00 }, -- red
		{ 0.00, 0.55, 1.00 }, -- deep sky blue
		{ 0.00, 1.00, 1.00 }, -- cyan
		{ 1.00, 0.64, 0.00 }, -- orange
		{ 0.00, 1.00, 0.52 }, -- spring green
		{ 1.00, 1.00, 0.00 }, -- yellow
		{ 0.87, 0.00, 1.00 }, -- electric purple
	}
	data.settings.state_priority_list = {
		"LuaCustom1",
		"Broken",
		"Unpowered",
		"Emergency",
		"PoweredDown",
		"PathBlocked",
		"Inefficient",
		"LuaCustom2",
		"Idle",
	}
	data.settings.key_names = {
		MouseX                    = "Mouse Horizontal Move",
		MouseY                    = "Mouse Vertical Move",
		MouseScrollUp             = "Mouse Wheel Up",
		MouseScrollDown           = "Mouse Wheel Down",
		MouseWheelAxis            = "Mouse Wheel",
		LeftMouseButton           = "Left Mouse Button",
		RightMouseButton          = "Right Mouse Button",
		MiddleMouseButton         = "Middle Mouse Button",
		ThumbMouseButton          = "Thumb Mouse Button",
		ThumbMouseButton2         = "Thumb Mouse Button 2",
		BackSpace                 = "Backspace",
		Tab                       = "Tab",
		Enter                     = "Enter",
		Pause                     = "Pause",
		CapsLock                  = "Caps Lock",
		Escape                    = "Escape",
		SpaceBar                  = "Space Bar",
		PageUp                    = "Page Up",
		PageDown                  = "Page Down",
		End                       = "End",
		Home                      = "Home",
		Left                      = "Left",
		Up                        = "Up",
		Right                     = "Right",
		Down                      = "Down",
		Insert                    = "Insert",
		Delete                    = "Delete",
		Zero                      = "0",
		One                       = "1",
		Two                       = "2",
		Three                     = "3",
		Four                      = "4",
		Five                      = "5",
		Six                       = "6",
		Seven                     = "7",
		Eight                     = "8",
		Nine                      = "9",
		NumPadZero                = "Numpad 0",
		NumPadOne                 = "Numpad 1",
		NumPadTwo                 = "Numpad 2",
		NumPadThree               = "Numpad 3",
		NumPadFour                = "Numpad 4",
		NumPadFive                = "Numpad 5",
		NumPadSix                 = "Numpad 6",
		NumPadSeven               = "Numpad 7",
		NumPadEight               = "Numpad 8",
		NumPadNine                = "Numpad 9",
		Multiply                  = "Numpad *",
		Add                       = "Numpad +",
		Subtract                  = "Numpad -",
		Decimal                   = "Numpad .",
		Divide                    = "Numpad /",
		NumLock                   = "Num Lock",
		ScrollLock                = "Scroll Lock",
		LeftShift                 = "Left Shift",
		RightShift                = "Right Shift",
		LeftControl               = "Left Ctrl",
		RightControl              = "Right Ctrl",
		LeftAlt                   = "Left Alt",
		RightAlt                  = "Right Alt",
		LeftCommand               = "Left Command",
		RightCommand              = "Right Command",
		Semicolon                 = "Semicolon ;",
		Equals                    = "Equals =",
		Comma                     = "Comma ,",
		Underscore                = "Underscore _",
		Hyphen                    = "Minus -",
		Period                    = "Period .",
		Slash                     = "Slash /",
		Tilde                     = "Tilde ~",
		LeftBracket               = "Left Bracket [",
		LeftParantheses           = "Left Parenthesis (",
		Backslash                 = "Backslash \\",
		RightBracket              = "Right Bracket ]",
		RightParantheses          = "Right Parenthesis )",
		Apostrophe                = "Apostrophe '",
		Quote                     = "Double Quote \"",
		Asterix                   = "Asterisk *",
		Ampersand                 = "Ampersand &",
		Caret                     = "Caret ^",
		Dollar                    = "Dollar $",
		Exclamation               = "Exclamation !",
		Colon                     = "Colon :",
		A_AccentGrave             = "A Accent Grave",
		E_AccentGrave             = "E Accent Grave",
		E_AccentAigu              = "E Accent Aigu",
		C_Cedille                 = "C Cedille",
		Section                   = "Section",
		Gamepad_LeftX             = "Left Stick Horizontal",
		Gamepad_LeftY             = "Left Stick Vertical",
		Gamepad_RightX            = "Right Stick Horizontal",
		Gamepad_RightY            = "Right Stick Vertical",
		Gamepad_LeftStick_Left    = "Left Stick Left",
		Gamepad_LeftStick_Right   = "Left Stick Right",
		Gamepad_LeftStick_Up      = "Left Stick Up",
		Gamepad_LeftStick_Down    = "Left Stick Down",
		Gamepad_RightStick_Left   = "Right Stick Left",
		Gamepad_RightStick_Right  = "Right Stick Right",
		Gamepad_RightStick_Up     = "Right Stick Up",
		Gamepad_RightStick_Down   = "Right Stick Down",
		Gamepad_LeftTriggerAxis   = "Left Trigger",
		Gamepad_RightTriggerAxis  = "Right Trigger",
		Gamepad_LeftThumbstick    = "Left Stick Press",
		Gamepad_RightThumbstick   = "Right Stick Press",
		Gamepad_FaceButton_Bottom = "A Button",
		Gamepad_FaceButton_Right  = "B Button",
		Gamepad_FaceButton_Left   = "X Button",
		Gamepad_FaceButton_Top    = "Y Button",
		Gamepad_LeftShoulder      = "Left Shoulder (L1)",
		Gamepad_RightShoulder     = "Right Shoulder (R1)",
		Gamepad_LeftTrigger       = "Left Trigger (L2)",
		Gamepad_RightTrigger      = "Right Trigger (R2)",
		Gamepad_DPad_Up           = "D-Pad Up",
		Gamepad_DPad_Down         = "D-Pad Down",
		Gamepad_DPad_Right        = "D-Pad Right",
		Gamepad_DPad_Left         = "D-Pad Left",
		Gamepad_Special_Left      = "Gamepad Special Left",
		Gamepad_Special_Right     = "Gamepad Special Right",
	}
	data.settings.key_icons =
	{
		LeftMouseButton           = "Main/skin/Assets/LeftMouseButton.png",
		RightMouseButton          = "Main/skin/Assets/RightMouseButton.png",
		MiddleMouseButton         = "Main/skin/Assets/MiddleMouseButton.png",
	}
	data.logistics_flags = {
		{ flag = "carrier",         default = true,  label = "Deliver Items",          tooltip = "Carry out orders of the logistics network" },
		{ flag = "supplier",        default = true,  label = "Supply Items",           tooltip = "Supply items to the logistics network" },
		{ flag = "requester",       default = true,  label = "Request Items",          tooltip = "Receive required items from the logistics network" },
		{ },
		{ flag = "high_priority",   default = false, label = "High Priority",          tooltip = "Item requests and supplies are high priority" },
		{ flag = "crane_only",      default = false, label = "Only Item Transporters", tooltip = "Allow only Item Transporter components to pass items" },
		{ flag = "flying_only",     default = false, label = "Only Flying Carriers",   tooltip = "Allow only flying carriers to pass items" },
		{ },
		{ flag = "transport_route", default = false, label = "Transport Route",        tooltip = "Continually pick up from <hl>Goto</> and deliver to <hl>Store</>\nRequires both <hl>Goto Register</> and <hl>Store Register</> to be set" },
		{ flag = "channel_1",       default = true,  label = "On Channel 1",           tooltip = "Only interact with units/buildings that are also on channel 1" },
		{ flag = "channel_2",       default = false, label = "On Channel 2",           tooltip = "Only interact with units/buildings that are also on channel 2" },
		{ flag = "channel_3",       default = false, label = "On Channel 3",           tooltip = "Only interact with units/buildings that are also on channel 3" },
		{ flag = "channel_4",       default = false, label = "On Channel 4",           tooltip = "Only interact with units/buildings that are also on channel 4" },
		{ flag = "can_construction",default = true,  label = "Can Serve Construction", tooltip = "Allow serving construction sites" },
	}
end

function data.text_vars.seed()
	return tostring(Map.GetSeed())
end

-- called after loading when running with mod dev mode
function package:validate_data()
	local function CheckIngredients(id, ingredients)
		for ingredient_id, ingredient_amount in pairs(ingredients) do
			Debug.Assert(data.items[ingredient_id] or data.components[ingredient_id], "DEFINITION WARNING: Unknown ingredient id ", ingredient_id, " in ", id)
			Debug.Assert(ingredient_amount >= 1, "DEFINITION WARNING: invalid production amount on recipe of ", id)
		end
	end
	local function CheckRecipe(id, def, can_have_production, can_have_mining, can_have_uplink, can_have_construction)
		if def.production_recipe then
			Debug.Assert(can_have_production, "DEFINITION WARNING: definition has production_recipe but it shouldn't: ", id)
			for producer_id, producer_time in pairs(def.production_recipe.producers) do
				local producer_def = data.components[producer_id]
				Debug.Assert(producer_def, "DEFINITION WARNING: Unknown producer id ", producer_id, " in ", id)
				Debug.Assert(producer_time >= 1, "DEFINITION WARNING: invalid production duration on recipe of ", id)
				Debug.Assert(not producer_def or producer_def.base_id == "c_fabricator", "DEFINITION WARNING: Production component of ", id, " is not based on c_fabricator (", producer_id, " based on ", producer_def.base_id,")")
			end
			Debug.Assert(def.production_recipe.amount >= 1, "DEFINITION WARNING: invalid production amount on recipe of ", id)
			CheckIngredients(id, def.production_recipe.ingredients)
		end
		if def.mining_recipe then
			Debug.Assert(can_have_mining, "DEFINITION WARNING: definition has mining_recipe but it shouldn't: ", id)
			for miner_id, mining_time in pairs(def.mining_recipe) do
				local miner_def = data.components[miner_id]
				Debug.Assert(miner_def, "DEFINITION WARNING: Unknown miner id", miner_id, " in ", id)
				Debug.Assert(mining_time >= 1, "DEFINITION WARNING: invalid mining duration on recipe of ", id)
				Debug.Assert(not miner_def or miner_def.base_id == "c_miner", "DEFINITION WARNING: Mining component of ", id, " is not based on c_miner (", miner_id, " based on ", miner_def.base_id,")")
			end
		end
		if def.uplink_recipe then
			Debug.Assert(can_have_uplink, "DEFINITION WARNING: definition has uplink_recipe but it shouldn't: ", id)
			CheckIngredients(id, def.uplink_recipe.ingredients)
			Debug.Assert(def.uplink_recipe.ticks >= 1, "DEFINITION WARNING: invalid uplink duration on recipe of ", id)
		end
		if def.construction_recipe then
			Debug.Assert(can_have_construction, "DEFINITION WARNING: definition has construction_recipe but it shouldn't: ", id)
			CheckIngredients(id, def.construction_recipe.ingredients)
			Debug.Assert(def.construction_recipe.ticks >= 1, "DEFINITION WARNING: invalid uplink duration on recipe of ", id)
		end
	end
	for id,frame_def in pairs(data.frames) do
		local frame_components, n = frame_def.components, 0
		if frame_components then for k,v in pairs(frame_components) do n = n + 1 Debug.Assert(#v == 2 and type(v[1]) == "string" and type(v[2]) == "string", "DEFINITION WARNING: Frame has invalid component defined: ", id) end end
		Debug.Assert(not frame_def.production_recipe or not frame_def.construction_recipe, "DEFINITION WARNING: Frame has both production and construction recipe: ", id)
		Debug.Assert(not frame_def.construction_recipe or not frame_def.movement_speed, "DEFINITION WARNING: Frame has both construction recipe and movement: ", id)
		Debug.Assert(not frame_def.production_recipe or frame_def.movement_speed or frame_def.flags == "Space", "DEFINITION WARNING: Frame has both production recipe and no movement: ", id)
		Debug.Assert(n == (frame_components and #frame_components or 0), "DEFINITION WARNING: Frame has invalid components table: ", id)
		CheckRecipe(id, frame_def, true, false, false, true)
		if frame_components then
			for k,v in pairs(frame_components) do
				local frame_component_def = data.components[v[1]]
				local comp_def_hidden, comp_add_hidden = (frame_component_def and frame_component_def.attachment_size or "Hidden") == "Hidden", (v[2] == "hidden")
				Debug.Assert(not comp_def_hidden or comp_add_hidden, "DEFINITION WARNING: Integrated component is added to frame as non-hidden: ", id, " - ", v[1])
				--if not comp_def_hidden and comp_add_hidden then print("DEFINITION WARNING: Non-integrated component is added to frame as hidden: ", v[1], " @ ", id) end
				--if frame_component_def and (frame_component_def.power or 0) ~= 0 and ((frame_component_def.activation or "None") == "None" or frame_component_def.activation == "Always") then print("DEFINITION WARNING: Component with power comes with frame: ", v[1], " @ ", id) end
				--if frame_component_def and frame_component_def.slots then print("DEFINITION WARNING: Component with slots comes with frame: ", v[1], " @ ", id) end
			end
		end
		--if frame_def.type == nil and frame_def.flags == "NonSelectable" then print("FRAME INFO: Frame is non selectable but appears as building: " .. tostring(id)) end
		--if not frame_def.visual then print("FRAME INFO: Frame without default visual: " .. tostring(id)) end
	end
	local function TestFX(fx)
		if not fx then return end
		local d = data.fx[fx]
		Debug.Assert(d, "COMPONENT ERROR: Missing effect: ", fx)
		--if d and d.sound and not d.sound_concurrency then print("COMPONENT INFO: Sound effect on component has no sound_concurrency: " .. tostring(fx)) end
	end
	for id,comp_def in pairs(data.components) do
		local size = comp_def.attachment_size
		Debug.Assert(not comp_def.production_recipe or (size and size ~= "Hidden"), "DEFINITION WARNING: Hidden component with a production recipe:", id, comp_def.production_recipe)
		Debug.Assert(comp_def.name ~= comp_def.id or not size or size == "Hidden", "DEFINITION WARNING: Component with no name: ", id)
		Debug.Assert(comp_def.activation ~= 'None', "DEFINITION WARNING: Component contains default value 'None' in activation field: ", id)
		Debug.Assert(comp_def.base_id ~= comp_def.id or size ~= "Hidden" or comp_def.get_ui, "DEFINITION WARNING: Component has attachment_size set to Hidden where unnecessary: ", id)
		Debug.Assert(size ~= "Internal" or comp_def.visual == "v_generic_i", "DEFINITION WARNING: Internal component has visual not set to 'v_generic_i': ", id, comp_def.visual)
		Debug.Assert(not size or size == "Hidden" or size == "Internal" or size == "Small" or size == "Medium" or size == "Large", "DEFINITION WARNING: Component with invalid attachment_size: ", id, size)
		TestFX(comp_def.miner_effect) TestFX(comp_def.effect) TestFX(comp_def.production_effect) TestFX(comp_def.repair_fx) TestFX(comp_def.shoot_fx) TestFX(comp_def.blast_fx)
		CheckRecipe(id, comp_def, true, false, false, false)
		--if (not comp_def.attachment_size or comp_def.attachment_size == "Hidden") and comp_def.on_remove then print("COMPONENT INFO: Hidden component has on_remove: ", id) end
		--if (not comp_def.attachment_size or comp_def.attachment_size == "Hidden") and (comp_def.registers or comp_def.get_ui) then print("COMPONENT INFO: Non-integrated component specifies Hidden size: ", id) end
		--if not comp_def.attachment_size and (comp_def.get_ui or comp_def.registers) then print("COMPONENT INFO: Component shown in UI without attachment size (maybe unintended integrated): ", id) end
	end
	for id,def in pairs(data.items) do
		CheckRecipe(id, def, true, true, false, false)
		Debug.Assert(def.index, "DEFINITION WARNING: Missing index in item definition ", id)
	end
	for id,def in pairs(data.techs) do
		CheckRecipe(id, def, false, false, true, false)
		for _,require_id in ipairs(def.require_tech or {}) do
			Debug.Assert(data.techs[require_id], "DEFINITION WARNING: Unknown require_tech id ", require_id, " in ", id)
			Debug.Assert(require_id ~= id, "DEFINITION WARNING: Tech lists itself in require_tech: ", id)
		end
	end
	for id,visual_def in pairs(data.visuals) do
		local visual_sockets, n = visual_def.sockets, 0
		if visual_sockets then for k,v in pairs(visual_sockets) do n = n + 1 Debug.Assert(#v == 2 and type(v[1]) == "string" and type(v[2]) == "string", "DEFINITION WARNING: Visual has invalid socket defined: ", id) end end
		Debug.Assert(n == (visual_sockets and #visual_sockets or 0), "DEFINITION WARNING: Visual has invalid visual_sockets table: ", id)
		--if not visual_def.mesh and not visual_def.frame_class and not visual_def.meshes then print("VISUAL INFO: Visual has no mesh: ", id) end
	end
end

-- called when a mod is upgrading from a previous version
function package:on_update(ver)
	if ver == 7 then -- Removed packages, replace them with one-time-use deployers
		local packages = { 'drone_transfer_package', 'drone_transfer_package2', 'drone_miner_package', 'drone_adv_miner_package', 'drone_defense_package1', 'flyer_package_m', 'satellite_package', 'space_satellite_package' }
		local frames   = { 'f_drone_transfer_a',     'f_drone_transfer_a2',     'f_drone_miner_a',     'f_drone_adv_miner',       'f_drone_defense_a',      'f_flyer_m',       'f_satellite',       'f_space_satellite' }
		for _,faction in ipairs(Map.GetFactions()) do
			for _,entity in ipairs(faction.entities) do
				for i,id in ipairs(packages) do
					for _=1,9999 do
						local slot = entity:FindSlot(id)
						if not slot then break end
						for _,v in ipairs(slot:GetReserveInfo()) do
							if v.component then v.component:CancelProcess() end -- clean up process reserves
							slot:CancelOrders() -- clean up order reserves
							entity:Cancel() -- clean up drop item reserves
						end
						if slot.stack == 0 then
							if slot.locked then slot:SetLockedItem(nil) end
						else
							slot:Clear()
							if slot.locked then slot:SetLockedItem('c_deployer') end
							slot:SetItemAndStack('c_deployer', 1, { bp = { frame = frames[i] }, onetime = true })
						end
					end
				end
			end
		end
	elseif ver == 6 then -- Goto queue was moved from extra_data into register queue
		for _,faction in ipairs(Map.GetFactions()) do
			for _,entity in ipairs(faction.entities) do
				if entity._deprecated_want_goto_callback then
					entity._deprecated_want_goto_callback = false -- clear deprecated flag
					local goto_queue = entity.extra_data.goto_queue
					entity.extra_data.goto_queue = nil
					entity.extra_data = EmptyTableAsNil(entity.extra_data)
					if goto_queue and #goto_queue > 0 then
						for _,val in ipairs(goto_queue) do entity:RegisterQueueInsert(FRAMEREG_GOTO, val) end
					end
				end
			end
		end
	elseif ver == 5 then
		local save_robot_base, anomaly_faction = Map.GetSave().robot_base, Map.GetFaction("anomaly")
		if save_robot_base == true then
			local anomaly_sim = anomaly_faction and anomaly_faction:GetEntityWithId("f_anomaly_sim")
			local old_sim = anomaly_faction and not anomaly_sim and anomaly_faction:GetEntityWithId("f_building_sim")
			Map.GetSave().robot_base = anomaly_sim or (old_sim and Map.RecreateEntity(old_sim, "f_anomaly_sim")) or nil
		end
		local save_human_b = Map.GetSave().human_b
		if save_human_b then save_human_b:SetRegister(FRAMEREG_VISUAL, nil) end
		local save_human_b_factory = save_human_b and save_human_b.exists and save_human_b:FindComponent("c_space_elevator_factory")
		if save_human_b_factory then save_human_b_factory:SetRegister(1, { item = "anomaly_heart", num = REG_INFINITE }) end
	elseif ver == 4 then
		LibraryUpgradeOldSave()
	elseif ver == 3 then
		for _,comp in ipairs(Map.GetComponents("c_shield_generator", true)) do
			comp:StopEffects()
			comp:Activate()
		end
	elseif ver == 2 then
		-- to avoid EntityAction.SetRegister affecting deployers, switch extra data field custom_blueprint to bp
		for _,comp in ipairs(Map.GetComponents("c_deployer")) do
			if comp.has_extra_data and comp.extra_data.custom_blueprint then
				if not comp.extra_data.bp then comp.extra_data.bp = comp.extra_data.custom_blueprint end
				comp.extra_data.custom_blueprint = nil
			end
		end
	elseif ver == 1 then
		for _,faction in ipairs(Map.GetFactions()) do
			-- update faction blight protection
			if faction:IsUnlocked("t_blight_protection") then
				faction.has_blight_shield = true
			end
			-- hack code
			if faction.id ~= "world" and not faction.extra_data.hack_code then
				faction.extra_data.hack_code = math.random(1000, 9999)
			end
		end

		local alien_faction = Map.GetFaction("alien")
		local bugs_faction = Map.GetFaction("bugs")
		local anomaly_faction = Map.GetFaction("anomaly")

		-- fix trusts
		if alien_faction and anomaly_faction then alien_faction:SetTrust(anomaly_faction, "NEUTRAL", true) end
		if alien_faction and bugs_faction    then alien_faction:SetTrust(bugs_faction, "ENEMY", true)      end
		if bugs_faction  and anomaly_faction then bugs_faction:SetTrust(anomaly_faction, "NEUTRAL", true)  end

		-- add blight protection
		if alien_faction   then alien_faction.has_blight_shield = true   end
		if bugs_faction    then bugs_faction.has_blight_shield = true    end
		if anomaly_faction then anomaly_faction.has_blight_shield = true end
	end
end

function package:get_new_player_faction_id()
	-- For all scenarios that support the 'Separate/Versus' game mode, handle faction id selection here
	if Map.GetSettings().game_mode == "Separate/Versus" then
		local players = Game.GetAllPlayers()
		for i=1,99999 do
			local faction_id = i == 1 and "player" or ("player_" .. i)
			if not Map.GetFaction(faction_id) then
				for _, player in ipairs(players) do
					if player.faction_id == faction_id then goto try_next_faction_id end
				end
				return faction_id
			end
			::try_next_faction_id::
		end
	else
		for i=1,99999 do
			local faction_id = i == 1 and "player" or ("player_" .. i)
			local f = Map.GetFaction(faction_id)
			if not f or not f.extra_data.locked then
				return faction_id
			end
		end
	end
end

function package:on_player_faction_spawn(faction, is_respawn, player_faction_num)
	math.randomseed(faction.seed)
	faction.extra_data.hack_code = math.random(1000, 9999)
	faction.extra_data.started = Map.GetTick()

	if not is_respawn then
		-- Set faction color
		local player_colors = data.settings.player_colors
		faction.color = player_colors[1 + ((player_faction_num - 1) % #player_colors)]
	end
end

function MapMsg.OnSettingChanged(key_name, old_value, new_value)
	local notify_name, notify_value
	if key_name == 'peaceful' then
		notify_name = "Hostility Level"
		notify_value = (new_value == 0 and "None") or (new_value == 1 and "Passive") or ((new_value or 2) == 2 and "Aggressive" or "Swarm")
		local bugs_faction = Map.GetFaction("bugs")
		if bugs_faction then
			-- Going to None: Destroy all entities of the bugs faction
			-- Going to Passive: Make all factions except alien bidirectionally NEUTRAL towards the bugs faction, stop all weapon components of the bugs faction
			-- Going to Hostile/Aggressive: Make all factions except anomaly bidirectionally ENEMY towards the bugs faction
			local destroy_bugs = new_value == 0
			local disarm_bugs = new_value == 1
			local reset_trust = ((new_value or 2) > 1) and "ENEMY" or "NEUTRAL"
			bugs_faction.default_trust = reset_trust
			bugs_faction:ResetTrust()
			if reset_trust ~= "NEUTRAL" then bugs_faction:SetTrust("anomaly", "NEUTRAL", true) end
			if reset_trust ~= "ENEMY" then bugs_faction:SetTrust("alien", "ENEMY", true) end
			if destroy_bugs or disarm_bugs then
				for k,v in ipairs(bugs_faction.entities) do
					if destroy_bugs then
						v:Destroy()
					else -- disarm
						local turret = v:FindComponent("c_turret", true)
						if turret then
							turret:SetRegister(1, nil)
							turret:SetRegister(2, nil)
							turret.extra_data = nil
						end
					end
				end
			end
		end
	elseif key_name == 'creep' and (Map.GetSettings().peaceful or 2) == 2 then
		notify_name, notify_value = "Bug Hive Evolution", new_value and "Yes" or "No"
	elseif key_name == 'disable_minigames' then
		notify_name, notify_value = "Minigames", new_value and "No" or "Yes"
	end
	if notify_name then
		UI.Run(function()
			if Game.IsHostPlayer() then return end
			Notification.Add("mapsettings_" .. key_name, "info", "Game Settings", L("%s was changed to %s", notify_name, notify_value))
		end)
	end
end
