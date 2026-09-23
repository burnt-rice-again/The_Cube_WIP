
----- fabricator -----
local function comp_create_link_to_visual(comp_def, comp)
	local reg = comp.owner:GetRegister(FRAMEREG_VISUAL)
	if reg.is_empty or reg.is_link then
		comp:LinkRegisterFromRegister(FRAMEREG_VISUAL, 1)
	end
end

--- My Modification here -----------
local function replace_cube(recipe, entity)
	if recipe.byproduct ~= nil then
		local anti_count = 0
		-- add cube back in 
		for waste,num in pairs(recipe.byproduct) do
			if waste == "ic_cube_sphere" then
				-- special placement of anticube in area
				anti_count = num
			else
				AddCubeThroughFixed(entity,waste)
			end
		end
		-- place anti cubes in output
		while anti_count > 0 do 
			Place_Anti_Cube(entity, false)
			anti_count = anti_count - 1
		end
	end
	--spawn more anti cubes on craft
	if recipe.ingredients and recipe.ingredients.ic_cube_sphere ~= nil then 
		Place_Anti_Cube(entity, true)
	end
end
local function check_waste_and_output(recipe, outputs)
	local cube_names = {"ic_cube_blue", 'ic_cube_green', 'ic_cube_empty', 'ic_cube_red', 'ic_cube_sphere'}
	for i,cube_name in ipairs(cube_names) do 
		-- allows the process function to ignore reserving space for input cube
		if outputs[cube_name]~= nil then 
			outputs[cube_name] = nil
		end
	end	
	return outputs
end

local function new_game_plus(comp)
	local garage = comp.owner:GetSlotsByType("garage")
	for key, val in pairs(garage) do
		if val.entity then
			UI.Run("new_game_plus", comp)
			break
		end
	end
	
end
function UIMsg.new_game_plus(comp) 

	UI.AddLayout('<ConfirmDialog title="Begin New Universe" body = "Start a new universe. You will keep all technologies and start with an additional unit placed in this buildings garage slot"/>', {
		construct = function(w)
			w.list:Add("<Text margin_top=10/>", { text = "Days since cube awakening: " .. tostring(Map:GetTotalDays()) })
			local settings = Map:GetSettings()
			if settings.run_times then
				w.list:Add("<Text margin_top=3/>", { text = "Previous Run Times: " })
				--for i, v in ipairs(settings.run_times) do 
					w.list:Add("<Text margin_top=1/>", { text = tostring(settings.run_times):sub(2,-2) })
				--end
			end 
			
			
		end,
		cancel = function(w) w:RemoveFromParent() end,
		ok = function(w)
			print("OK")
			w:RemoveFromParent()
			local settings = Tool.Copy(Map:GetSettings())
			settings.scenario = "The_Cube_WIP/Scenario"
			settings.unlock_all_techs = true
			if not settings.run_times then settings.run_times = {} end
			table.insert(settings.run_times, Map:GetTotalDays())
			local owner = comp.owner
			local garage = owner:GetSlotsByType("garage")
			settings.extra_bots = {}
			for key, val in pairs(garage) do
				if (val.entity) then 
					--print(val.entity)
					table.insert(settings.extra_bots, { 
						bp = MakeBlueprintFromEntity(val.entity), 
						extra_data = SerializeCompExtraData(val.entity),
						items = SerializeItems(val.entity)
					})
				end
			end
			settings.library = comp.faction.extra_data.library
			settings.seed = math.random(55823361)
			Game.NewGame(settings)
		end,
	}, 99)

	--Game.NewGame({scenario = "The_Cube_WIP/Scenario"})
end 
---------------------------------

local cc_cube_fabrication = Comp:RegisterComponent("cc_cube_fabrication", {
	name = "Dream Lounge",
	texture = "Main/textures/icons/components/Component_RepairPort_01_M.png",
	desc = "Manifest a small amount of Resources through the cube",
	attachment_size = "Small",
	visual = "v_repairport_01_m",
	race = "robot",
	power = -5,
	production_recipe = CreateProductionRecipe({ metalbar = 5, crystal = 5 }, { c_fabricator = 20, c_assembler = 20 }),
	--production_effect = "fx_fabricator",
	activation = "OnFirstRegisterChange",
	registers = {
		{ type = "production", tip = "Click to change production", ui_apply = "Set Production", ui_icon = "icon_output" },
		{ tip = "Missing ingredient", warning = "Missing ingredient", read_only = true },
	},
	is_missing_ingredient_register = function(idx) return idx == 2 end,
	link_to_visual = true,
	on_add = comp_create_link_to_visual,
	--get_ui = true,
})

-- prevents warning from validator in mod mode. 
cc_cube_fabrication.base_id = "c_fabricator"

function cc_cube_fabrication:action_tooltip() return L("Set %s Production", self.name) end
function cc_cube_fabrication:action_click(comp, widget)
	ShowRegisterSelection(widget, comp.owner, comp, 1)
end

function cc_cube_fabrication:get_reg_error(comp)
	local reg1_id, missing_id = comp:GetRegisterId(1), comp:GetRegisterId(2)
	local reg1_entity = not reg1_id and comp:GetRegisterEntity(1)
	if reg1_entity then reg1_id = reg1_entity.id end
	local reg1_num = comp:GetRegister(1).num
	local product_def, blueprint_def = GetProduction(reg1_id, comp)
	local production_recipe = product_def and product_def.production_recipe
	local name = (blueprint_def and NOLOC(blueprint_def.name)) or (product_def and product_def.name) or (data.all[reg1_id] and data.all[reg1_id].name) or reg1_id or "this"

	if product_def and not comp.faction:IsUnlocked(reg1_id) then
		return L("Missing research to produce %s", name)
	elseif not production_recipe or not production_recipe.producers[self.id] then
		return L("Cannot produce %s in %s", name, self.name)
	elseif missing_id and (comp.owner:HaveFreeSpace(reg1_id) or product_def.data_name == "frames") then
		return L("Missing production ingredient %s", (data.all[missing_id] and data.all[missing_id].name or missing_id))
	elseif reg1_num and reg1_num == 0 then
		return "Cannot produce zero items"
	else
		return L("No inventory space to produce %s", name)
	end
end

function cc_cube_fabrication:end_production(comp, missing_item, flag_error, clear_extra)
	comp:SetRegister(2, missing_item)
	comp:FlagRegisterError(1, flag_error)
	comp:StopEffects()
	comp.animation_speed = 0
	if clear_extra then comp.extra_data = nil end
end

function cc_cube_fabrication:on_update(comp, cause)
	local reg1 = comp:GetRegister(1)
	local reg1_id, count = reg1.id, reg1.num
	local reg1_entity = not reg1_id and reg1.entity
	if reg1_entity then reg1_id = reg1_entity.id end
	local product_def, blueprint_def = GetProduction(reg1_id, comp)

	-- CUBE pipe input check 
	if self.pipe_input ~= nil and comp.owner:CountItem("ic_soul_plasma") > 0 then 
		self:pipe_input(comp, cause)
	end

	if not product_def then
		-- Production cancel requested
		return self:end_production(comp, nil, count > 0, true)
	end

	if count == 0 then
		-- Invalid production amount, clear temporary blueprint
		return self:end_production(comp, nil, count, reg1_entity)
	end

	-- Complex check to make sure that something invalid can't be produced by just changing the number on a linked register
	local is_new_product = (cause & CC_ACTIVATED == CC_ACTIVATED) and ((cause & CC_CHANGED_REGISTER_ID == CC_CHANGED_REGISTER_ID) or not comp.is_working)
	local is_finish_production = (cause & CC_FINISH_WORK == CC_FINISH_WORK)
	--print("[" .. comp.id .. ":on_update] cause: " .. comp:CauseToString(cause) .. " - comp.is_working: " .. tostring(comp.is_working) .. " - is_new_product: " .. tostring(is_new_product) .. " - is_finish_production: " .. tostring(is_finish_production) .. " - has_power: " .. tostring(comp.owner.has_power))

	local production_recipe = product_def.production_recipe
	local production_ticks = production_recipe and production_recipe.producers[self.id]
	if is_new_product and not production_ticks then
		-- Invalid product or product that can't be produced by this component requested, forward it into missing ingredient register
		--print("[" .. comp.id .. ":on_update] Cannot produce " .. reg1_id)
		return self:end_production(comp, reg1, true)
	end

	if (is_new_product or comp.ticker_target == 16) and not comp.faction:IsUnlocked(reg1_id) then
		--print("[" .. comp.id .. ":on_update] Haven't unlocked production item " .. reg1_id)
		self:end_production(comp, nil, true)
		return comp:SetStateSleep(16) -- sleep for a while, it might get unlocked
	end

	if reg1_entity and reg1_entity:ExistsOnFaction(comp.faction) and (not blueprint_def or (cause & CC_CHANGED_REGISTER_ENTITY) ~= 0) then
		blueprint_def = reg1_entity.faction == comp.faction and MakeBlueprintFromEntity(reg1_entity, nil, nil, true) or nil
		comp.extra_data.custom_blueprint = blueprint_def -- store temporary blueprint
	elseif (cause & CC_CHANGED_REGISTER_ENTITY) ~= 0 and blueprint_def and not (reg1_entity and reg1_entity:ExistsOnFaction(comp.faction)) then
		blueprint_def, comp.extra_data = nil, nil -- clear temporary blueprint
	end

	local is_bot_production = product_def.data_name == "frames"
	if is_finish_production and is_bot_production and is_new_product then
		-- Producing a bot can't finish and start new production in the same tick (because we don't know anymore what the register was set to when it started)
		is_finish_production = false
	end

	if is_finish_production then
		-- Finished production
		local drone_slot = is_bot_production and comp:GetProcessOutputSlot()
		local bot_ingredient_extra_datas = comp:FulfillProcess(is_bot_production)
		replace_cube(production_recipe, comp.owner)
		if (product_def.id == "ic_micro_universe") then new_game_plus(comp) end 

		if is_bot_production then
			local owner = comp.owner
			local faction, location = owner.faction, owner.location
			if product_def.movement_speed > 0 then
				FactionCount("built_bot", 1, faction)
			end
			if reg1_id == "f_bot_1s_b" then
				FactionCount("built_bot_1s_b", true, faction)
			end
			if reg1_id == "f_bot_2s" then
				FactionCount("built_bot_2s", true, faction)
			end
			if blueprint_def then
				FactionCount("built_bp_bot", true, faction)
			end
			Map.Defer(function()
				-- Create frame
				local built = CreateFrameOrBlueprint(faction, blueprint_def or product_def, nil, bot_ingredient_extra_datas)
				if not built then return end
				if drone_slot and drone_slot.exists then
					drone_slot.entity = built
				elseif not owner.exists or not built:DockInto(owner) then
					-- Put into world if it can't spawn docked into the production frame
					built:Place(location.x, location.y)
					built:PlayEffect("fx_digital_in")
				end
				if comp.exists and not comp:RegisterIsEmpty(3) then
					local rally_reg = comp:GetRegister(3)
					if rally_reg.coord then
						built:MoveTo(rally_reg.coord, rally_reg.num)
					else
						EntitySetGoto(built, rally_reg, true)
					end
				end
			end)
		end

		if count >= 0 then
			if reg1.is_link then
				local src_index, src_entity, src_comp = comp:GetRegisterLinkSource(1)
				local src_comp_def = src_comp and src_comp.def
				if not src_comp_def then
					-- source is a frame register which won't change on its own, continue with count as is
				elseif not src_comp_def.is_missing_ingredient_register or src_entity ~= comp.owner then
					-- source is on a different entity or a component which we don't know if it changes on its own, wait until next tick to see if it changes
					comp:FlagRegisterError(1, false)
					return comp:SetStateSleep(1)
				elseif src_comp_def.is_missing_ingredient_register(src_index) then
					-- source is a missing ingredient type register which will count down by the just produced amount
					if src_comp.is_sleeping then
						src_comp:Activate() -- wake up
					end
					count = count - production_recipe.amount
					if count <= 0 then
						-- Finished last production (but check again in 5 ticks that it really was last, there might be multiple link sources)
						self:end_production(comp, nil)
						return comp:SetStateSleep(5)
					end
				end
			else
				count = count - production_recipe.amount
				if count <= 0 then
					-- Finished last production
					comp:SetRegister(1, nil)
					return self:end_production(comp, nil, false, true)
				end
				--ADDITION
				reg1.num = count
				---
				comp:SetRegister(1, reg1)
			end
		end
	end

	if not production_recipe then
		-- Cancel if recipe changed in old save / somehow got here and no recipe
		return self:end_production(comp, nil, count > 0)
	end

	-- has a recipe and is working so just keep going 
	if comp.is_working then 
		comp:SetStateContinueWork()
		return 
	end

	-- Get production ingredients
	local ingredients = GetIngredients(production_recipe, blueprint_def)
	
	-- Prepare next production
	local outputs = (not is_bot_production or (self.slots and self.slots[product_def.slot_type])) and { [reg1_id] = production_recipe.amount }
	local order_count = (count + production_recipe.amount - 1) // production_recipe.amount
	--ADDITION Replace Alternative Recipes 
	for key, val in pairs(outputs) do
		if data.items[key] and data.items[key].alt_item then 
			outputs[data.items[key].alt_item] = val
			outputs[key] = nil
		end
	end

	--ADDITION
	-- remove cube from output if it is in waste
		-- this allows the process to still run with only 1 cube storage
	if production_recipe.byproduct then
		check_waste_and_output(production_recipe, outputs)
	end
	---
	local can_make, missing_register = comp:PrepareProduceProcess(ingredients, outputs, order_count)
	if not can_make then
		-- Missing ingredient or no space for output
		self:end_production(comp, missing_register, true)
		return comp:SetStateSleep()
	end


	comp:SetRegister(2, missing_register)
	comp:FlagRegisterError(1, not can_make)
	if comp.owner.is_placed and self.production_effect ~= false then
		comp:PlayWorkEffect(self.production_effect)
		comp:SetWorkAnimationSpeed()
	end

	if not is_new_product and not is_finish_production and comp.is_working then
		-- Not a new production, no need to restart the work timer
		return comp:SetStateContinueWork()
	end

	-- Start work for as many ticks as the recipe requires
	return comp:SetStateStartWork(production_ticks, true)
end

-------------------------- other comps ----------------------------------

cc_cube_fabrication:RegisterComponent("cc_manifest",{
	name = "Cube Think Tank",
	desc = "Dream of the Cube and manifest reality",
	race = "robot",
	attachment_size = "Medium",
	texture = "Main/textures/icons/alien/alienbuilding_console.png", -- "Main/textures/icons/components/component_ScienceAnalyzer_01_l.png",
	visual = "v_explorable_blightanomaly_03",  --"v_scienceanalyzer_l",
	production_effect = "fx_uplink",--"fx_digital_in",--"fx_digital",
	power = -1000,
	production_recipe = CreateProductionRecipe({["metalplate"]=20,["crystal"]=16, datakey_robot = 4}, {["c_fabricator"] = 150, c_assembler = 50}, 1),
})

cc_cube_fabrication:RegisterComponent("cc_soul_refinery",{
	name = "Soul Refinery",
	desc = "With Fractional Distillation souls can be seperated into thier various emotions",
	race = "robot",
	attachment_size = "Medium",
	activation = "OnFirstRegisterChange|OnComponentItemSlotChange",
	texture = "Main/textures/icons/components/component_adv_refinery_01_l.png", -- "Main/textures/icons/components/component_ScienceAnalyzer_01_l.png",
	visual = "v_adv_refinery_01_m",  --"v_scienceanalyzer_l",
	production_effect = "fx_assembler",--"fx_digital_in",--"fx_digital",
	power = -2000,
	production_recipe = CreateProductionRecipe({["steelblock"]=40,["concreteslab"]=10,["crystal_powder"]=10}, {["c_assembler"] = 150}, 1),
	slots = {anomaly = 1},
	range = 8,
	--pipe_input = data.components.cc_pipe_input.on_update
})

cc_cube_fabrication:RegisterComponent("cc_red_furnace",{
	name = "Mantle Tear",
	texture = "Main/textures/icons/alien/alienbuilding_alienheart.png",
	desc = "Refined Sadness petrified into a moment of anguish",
	visual = "v_explorable_blightanomaly_01",
	race = "robot",
	attachment_size = "Large",
	--production_effect = "fx_assembler",--"fx_digital_in",--"fx_digital",
	power = -5000,
	production_recipe = CreateProductionRecipeWithWaste({ ic_cube_red = 1, crystal_powder = 100, ic_soul_plasma = 100}, { cc_manifest = 30, }, 1, {ic_cube_red = 1}),
})

cc_cube_fabrication:RegisterComponent("cc_green_brain",{
	name = "Brain Vat",
	texture = "Main/textures/icons/components/Component_VirusDecomposer_01_L.png",
	desc = "A Brain given self consciousness so it may ponder the cube in our stead",
	visual = "v_virus_decomposer_l",
	race = "robot",
	attachment_size = "Large",
	production_effect = "fx_alien_liquid",
	--production_effect = "fx_assembler",--"fx_digital_in",--"fx_digital",
	power = -500,
	production_recipe = CreateProductionRecipe({ wire = 100, ic_soul_plasma = 40, datakey_robot = 20 }, { c_assembler = 100, }),
})

cc_cube_fabrication:RegisterComponent("cc_gyro_fabricator",{
	name = "The Anti Entropy Loom",
	texture = "The_Cube_WIP/textures/gyro_icon_2.png",
	desc = "The knot in the tapestry\nContinue this string of universes so the World shall never truly end\n<rl>Add a bot to the Anti Entropy Loom\'s garage to begin new game plus</>",
	race = "robot",
	attachment_size = "Hidden",
	get_ui = true,
	production_recipe = false,
	production_effect = "fx_digital",--"fx_digital_in",--"fx_digital",
	power = 1 -- -50000,
})

