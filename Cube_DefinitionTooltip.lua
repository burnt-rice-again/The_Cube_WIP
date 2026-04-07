local reserve_labels<const> = {
	["StackForTransfer"]      = "reserved for outgoing order",
	["StackForCarry"]         = "reserved for delivery",
	["StackForLoading"]       = "reserved by",
	["StackForConsume"]       = "reserved by",
	["StackForDrop"]          = "reserved for dropping",
	["FreeSpaceForReceive"]   = "space for receiving order",
	["FreeSpaceForCarry"]     = "space for delivery pick-up",
	["FreeSpaceForGenerate"]  = "space for output of",
	["FreeSpaceForLoading"]   = "space for order by",
	["FreeSpaceForRedocking"] = "Dock reserved for a drone entity",
	["LoadFromGenerate"]      = "production output reserved by"
}

local socket_sizes<const> = { "Large", "Medium", "Small", "Internal" }
local socket_icons<const> = { "icon_l_socket", "icon_m_socket", "icon_s_socket", "icon_i_socket" }

local stat_layout<const> = [[
	<HorizontalList child_align=center margin_left=16>
		<Image image={icon} color=ui_light margin_right=8/>
		<Text text={value} fill=true margin_right=16/>
		<Text text={name} color=ui_light margin_right=16/>
	</HorizontalList>
]]

local function AddStats(max_lines, list, header_type, def, comp, entity, faction)
	if max_lines < 0 then return max_lines end

	local function AddStat(icon, value, name)
		max_lines = max_lines - 1
		if max_lines < 0 then return true end
		if header_type then
			if header_type == 'STAT_MAIN' then
				list:Add("<Image height=2 color=ui_light margin=8/>")
				list:Add('<Text text="Stats:" color=ui_light/>')
			elseif header_type == 'STAT_ADDITIONAL' then
				list:Add('<Text text="Stats:" color=ui_light/>')
			elseif header_type == 'STAT_COMPONENT' then
				list:Add("<Text halign=center color=title onclickreg={onclickreg}/>", {
					text = L('<img id="%S"/> %s', def.id, def.name), tooltip = DefinitionTooltip(def.id),
					on_click = function(sb) sb:SendEvent("onclickreg", "LEFTMOUSEBUTTON", def.id) end,
				})
			end
			header_type = nil
		end
		list:Add(stat_layout, { icon = icon, value = tostring(value), name = name })
	end

	-- Add item stats
	if def.stack_size and def.stack_size > 1 then
		if AddStat("icon_tiny_inventory", def.stack_size, "Maximum Stack") then goto full end
	end

	-- Add component stats
	if def.attachment_size or def.registers or def.get_ui then
		local range = def.range or def.attack_radius or def.trigger_radius or def.transfer_radius or def.light_radius or def.terraforming_range
		if range then
			if AddStat("icon_tiny_range", range, "Range") then goto full end
		end
		if def.minimum_range and def.minimum_range > 0 then
			if AddStat("icon_tiny_range", def.minimum_range, "Min. Range") then goto full end
		end
		if def.repair then
			local boost, rpsval = (comp and comp.effective_boost) or (entity and faction and faction.component_boost) or 100, def.repair*(TICKS_PER_SECOND/def.duration)
			if boost > 100 then
				if AddStat("icon_tiny_damage", string.format("%.1f <gl>(%.1f)</>", rpsval, math.floor(boost * 0.01 * rpsval + 0.5)), "Repair/sec") then goto full end
			elseif boost < 100 then
				if AddStat("icon_tiny_damage", string.format("%.1f <rl>(%.1f)</>", rpsval, math.floor(boost * 0.01 * rpsval + 0.5)), "Repair/sec") then goto full end
			else
				if AddStat("icon_tiny_damage", string.format("%.1f", rpsval), "Repair/sec") then goto full end
			end
		end
		if def.shoot_speed then
			local boost, dpsval = (comp and comp.effective_boost) or (entity and faction and faction.component_boost) or 100, def.damage*(TICKS_PER_SECOND/def.duration)
			if boost > 100 then
				if AddStat("icon_tiny_damage", string.format("%.f <gl>(%.f)</>", dpsval, math.floor(boost * 0.01 * dpsval + 0.5)), "DPS") then goto full end
			elseif boost < 100 then
				if AddStat("icon_tiny_damage", string.format("%.f <rl>(%.f)</>", dpsval, math.floor(boost * 0.01 * dpsval + 0.5)), "DPS") then goto full end
			else
				if AddStat("icon_tiny_speed", string.format("%.f", dpsval), "DPS") then goto full end
			end
		end
		if def.shoot_while_moving then
			if AddStat("icon_tiny_damage", "Yes", "Move and Fire") then goto full end
		end
		if def.damage_type then
			if AddStat("icon_tiny_damage", data.damage_names[def.damage_type] or def.damage_type, "Damage Type") then goto full end
		end

		if def.blast then
			if AddStat("icon_tiny_damage", def.blast, "Blast Radius") then goto full end
		end

		if def.shoot_target then
			local target = def.shoot_target == "ground" and "Ground Only" or (def.shoot_target == "air" and "Air Only") or "Air/Ground"
			if AddStat("icon_tiny_damage", target, "Targeting") then goto full end
		end

		if def.damage then
			if AddStat("icon_tiny_damage", def.damage, "Damage") then goto full end
			local attack_pattern = "Single Target"
			if def.blast then attack_pattern = "Blast"
			elseif def.beam_range then attack_pattern = "Beam"
			elseif def.pulse then attack_pattern = "Pulse"
			end
			if AddStat("icon_tiny_damage", attack_pattern, "Attack Pattern") then goto full end
		end
		if def.extra_effect_name then
			if AddStat("icon_tiny_damage", def.extra_effect_name, "Effect") then goto full end
		end
		if def.power and def.power > 0 then
			if AddStat("icon_tiny_energy_up", def.power*TICKS_PER_SECOND, "Power Production") then goto full end
		end
		if def.power and def.power < 0 then
			local boost, pwr = (comp and comp.effective_boost) or (entity and faction and faction.component_boost) or 100, -def.power
			if boost > 100 then
				if AddStat("icon_tiny_damage", string.format("%.f <gl>(%.f)</>", pwr * TICKS_PER_SECOND, math.floor(boost * 0.01 * pwr +0.5) * TICKS_PER_SECOND), "Power Usage") then goto full end
			elseif boost < 100 then
				if AddStat("icon_tiny_damage", string.format("%.f <rl>(%.f)</>", pwr * TICKS_PER_SECOND, math.floor(boost * 0.01 * pwr +0.5) * TICKS_PER_SECOND), "Power Usage") then goto full end
			else
				if AddStat("icon_tiny_energy_down", string.format("%.f", pwr * TICKS_PER_SECOND), "Power Usage") then goto full end
			end
		end
		if def.power_storage then
			if AddStat("icon_tiny_energy", def.power_storage, "Power Storage") then goto full end
		end
		if def.drain_rate then
			if AddStat("icon_tiny_battery_down", def.drain_rate*TICKS_PER_SECOND, "Drain Rate") then goto full end
		end
		if def.charge_rate then
			if AddStat("icon_tiny_battery_up", def.charge_rate*TICKS_PER_SECOND, "Charge Rate") then goto full end
		end
		if def.bandwidth then
			if AddStat("icon_tiny_energy_transmit", def.bandwidth*TICKS_PER_SECOND, "Bandwidth") then goto full end
		end
		if def.uplink_rate then
			if AddStat("icon_tiny_energy_transmit", string.format("%d%%", 100.0//def.uplink_rate), "Uplink Speed") then goto full end
		end
	end

	if def.extra_stat then
		for _,v in ipairs(def.extra_stat) do
			if AddStat(v[1], v[2], v[3]) then goto full end
		end
	end

	-- Add frame stats if blueprint or frame definition
	if def.visibility_range or def.cost_modifier or def.health_points then
		local health_boost = entity and SumModuleBoosts(entity, "c_modulehealth") or 0
		if health_boost > 0 then
			if AddStat("icon_tiny_durability", string.format("%d <gl>(+%d)</>", (def.health_points or 100), (def.health_points or 100)+health_boost), "Durability") then goto full end
		else
			if AddStat("icon_tiny_durability", def.health_points or 100, "Durability") then goto full end
		end
		if def.visibility_range then
			local vis_boost = entity and SumModuleBoosts(entity, "c_modulevisibility") or 0
			if vis_boost > 0 then
				if AddStat("icon_tiny_visibility_range", string.format("%d <gl>(%d)</>", def.visibility_range, def.visibility_range+vis_boost), "Visibility Range") then goto full end
			else
				if AddStat("icon_tiny_visibility_range", def.visibility_range , "Visibility Range") then goto full end
			end
		end
		if def.drone_range then
			if AddStat("icon_tiny_durone_range", def.drone_range, "Drone Range") then goto full end
		end
		if def.movement_speed then
			local move_boost = entity and SumModuleBoosts(entity, "c_modulespeed") or 0
			if move_boost > 0 then
				if AddStat("icon_tiny_movement_speed", string.format("%.f <gl>(%.f)</>", def.movement_speed, def.movement_speed+math.floor((move_boost*0.01*def.movement_speed)+0.5)), "Movement Speed") then goto full end
			elseif move_boost < 0 then
				if AddStat("icon_tiny_movement_speed", string.format("%.f <rl>(%.f)</>", def.movement_speed, def.movement_speed+math.floor((move_boost*0.01*def.movement_speed)+0.5)), "Movement Speed") then goto full end
			else
				if AddStat("icon_tiny_movement_speed", ((def.movement_speed*100+.499999)//1/100), "Movement Speed") then goto full end
			end
		end
		local base_boost, mod_boost, faction_boost = (def.component_boost or 0), (entity and SumModuleBoosts(entity, "c_moduleefficiency") or 0), (entity and faction and faction.component_boost-100) or 0
		if base_boost > 0 or mod_boost > 0 or faction_boost > 0 then
			if mod_boost > 0 or faction_boost > 0 then
				if AddStat("icon_tiny_speed", string.format("%d%% <gl>(%d%%)</>", 100 + base_boost, 100 + base_boost + mod_boost + faction_boost), "Component Efficiency") then goto full end
			else
				if AddStat("icon_tiny_speed", string.format("<gl>%d%%</>", 100 + base_boost), "Component Efficiency") then goto full end
			end
		end
		if def.power and def.power > 0 then
			if AddStat("icon_tiny_energy_up", def.power*TICKS_PER_SECOND, "Power Production") then goto full end
		end
		if def.power and def.power < 0 then
			if AddStat("icon_tiny_energy_down", -def.power*TICKS_PER_SECOND, "Power Usage") then goto full end
		end
		if def.cost_modifier and def.cost_modifier > 0 and def.cost_modifier < 1 then
			if AddStat("icon_tiny_speed", string.format("%d%%", math.floor(100 / def.cost_modifier + 0.5)), "Movement Speed Increase") then goto full end
		end
	end

	do
		-- add storage slot type
		local slot_type = def.slot_type
		if slot_type ~= "storage" and slot_type then
			if AddStat("icon_tiny_inventory", slot_type, "Slot Type") then goto full end
		end
	end

	::full::
	return max_lines
end

local function ProductionBreakdownGraph(list, def_id, bp, ingredients, amount)
	local function add_ingredient(id, num, lvl, parent, ingredients, amount, bp_components)
		local vl = parent:Add("<VerticalList valign=bottom/>") 
		if ingredients  then -- ~def_id:find('ic_cube')
			local hl = vl:Add("<HorizontalList halign=center valign=bottom child_padding=4/>")
			for sub_id, sub_num in pairs(ingredients) do
				if sub_id:find('ic_cube') == nil then 
					local recipe = data.all[sub_id].production_recipe
					add_ingredient(sub_id, sub_num * num / (amount or 1), lvl + 1, hl, recipe and recipe.ingredients, recipe and recipe.amount)
				end
			end
			if bp_components then
				for i,v in ipairs(bp.components) do
					if type(v[2]) == "number" and v[1] ~= "c_integrated_behavior" then
						local recipe = data.all[v[1]].production_recipe
						add_ingredient(v[1], 1, lvl + 1, hl, recipe and recipe.ingredients, recipe and recipe.amount)
					end
				end
			end
			vl:Add("<Image height=4 color=ui_dark margin=4/>")
		end
		--local ticks = recipe and (recipe.ticks or 1) or 0
		--vl:Add("<Text textalign=center width=64/>", { text = string.format("%3.1fs", ticks * num / TICKS_PER_SECOND) })
		vl:Add("<Reg width=48 height=48 bg=item_default halign=center on_click={onclickreg}/>", { def_id = id, num = num })
	end
	list:Add('<Text text="Individual ingredient production breakdown" halign=center color=light_gray margin=8/>')
	local hl = list:Add('<HorizontalList halign=center/>')
	add_ingredient(def_id, 1, 1, hl, ingredients, amount, (bp and bp.components))
end

local function IngredientRequirementsGraph(list, def_id, bp, seen_unlocks)
	local data_all, counts, durations, producers, levels, maxlevels = data.all, {}, {}, {}, {}, {}
	local function add_ingredient(id, num, lvl, bp_components)
		local def, ingredients, amount, defproducers, producer, ticks = data_all[id]
		if     def.production_recipe   then defproducers, ingredients, amount = def.production_recipe.producers, def.production_recipe.ingredients, def.production_recipe.amount
		elseif def.mining_recipe       then defproducers = def.mining_recipe
		elseif def.construction_recipe then ingredients, producer, ticks = def.construction_recipe.ingredients, "v_construction", def.construction_recipe.ticks
		elseif def.uplink_recipe       then ingredients, producer, ticks = def.uplink_recipe.ingredients, "c_uplink", def.uplink_recipe.ticks
		else return lvl end

		if def_id:find('ic_cube')then return lvl end 

		if defproducers then
			local seenpid, anypid, seenticks, anyticks
			for pid,pticks in pairs(defproducers) do
				local seen = seen_unlocks[pid]
				if seen and (not seenticks or pticks < seenticks) and not data_all[pid].disregard_tooltip then
					seenpid, seenticks = pid, pticks
				elseif not seen and (not anyticks or pticks < anyticks) and not data_all[pid].disregard_tooltip then
					anypid, anyticks = pid, pticks
				end
			end
			producer, ticks = seenpid or anypid, seenticks or anyticks
		end

		counts[id], durations[id], producers[id], levels[id] = (counts[id] or 0) + num, ticks / (amount or 1), producer or "v_lock_locked", lvl

		lvl = math.max(levels[id] or 0, lvl)
		local maxlvl = lvl
		if ingredients then -- ~def_id:find('ic_cube')
			for sub_id, sub_num in pairs(ingredients) do
				if sub_id:find('ic_cube') == nil then
					maxlvl = math.max(maxlvl, add_ingredient(sub_id, sub_num * num / (amount or 1), lvl + 1))
				end
			end
		end
		if bp_components then
			for i,v in ipairs(bp.components) do
				if type(v[2]) == "number" and v[1] ~= "c_integrated_behavior" then
					maxlvl = math.max(maxlvl, add_ingredient(v[1], 1, lvl + 1))
				end
			end
		end

		maxlevels[id] = math.max(maxlevels[id] or 0, maxlvl)
		return maxlvl
	end

	local maxlvl = add_ingredient(def_id, 1, 1, (bp and bp.components))
	for id,v in pairs(maxlevels) do
		if v < maxlvl and v == levels[id] then
			levels[id] = levels[id] + (maxlvl - v)
		end
	end

	list:Add('<Text text="Requirements for a constant production" halign=center color=light_gray margin=8/>')
	for i=maxlvl,1,-1 do
		local hl = list:Add("<HorizontalList halign=center margin_top=6/>")
		for id,level in pairs(levels) do
			if level == i then
				hl:Add("<Reg width=48 height=48 bg=item_default margin_left=8 on_click={onclickreg}/>", { def_id = id, num = counts[id] })
				hl:Add("<Reg width=48 height=48 bg=item_default margin_right=8 on_click={onclickreg}/>", { def_id = producers[id], num = string.format("x%3.1f", durations[id] * counts[id] / durations[def_id]) })
			end
		end
	end
end

local function HaveSeenAnyProducer(seen_unlocks, producers)
	for producer_id,ticks in pairs(producers) do if seen_unlocks[producer_id] then return true end end
end

local function ShowProducers(list, options, faction, seen_unlocks, producer_txt, producers, show_per_minute, amount)
	local reg_comp = options and options.reg_comp
	local comp_boost = reg_comp and reg_comp.effective_boost or faction.component_boost
	for producer_id,ticks in pairs(producers) do
		local ttime = ticks / TICKS_PER_SECOND
		if seen_unlocks[producer_id] then
			if producer_txt then
				list:Add("Text").text = producer_txt
				producer_txt = nil
			end
			local producer_def = data.all[producer_id]
			if comp_boost and comp_boost ~= 100 then
				local tick_boost = ((ticks * 100 + comp_boost - 1) // comp_boost) / TICKS_PER_SECOND
				local boost_color = comp_boost > 100 and "gl" or "rl"
				list:Add("<HorizontalList child_align=center child_padding=10><Reg bg=card_box_bg def={def} on_click={onclickreg}/><Text size=12 text={txt}/></HorizontalList>", {
					def = producer_def,
					txt = show_per_minute
						and L("<bl>%s</>\n<%s>%.1f</>/min (<hl>%.1fs</>→<%s>%.1fs</>)", (producer_def.name or "Unknown"), boost_color, (amount or 1)*60.0/tick_boost, ttime, boost_color, tick_boost)
						or L("<bl>%s</>\n<hl>%.1fs</> (<gl>%.1fs</>)", (producer_def.name or "Unknown"), ttime, tick_boost)
				})
			else
				list:Add("<HorizontalList child_align=center child_padding=10><Reg bg=card_box_bg def={def} on_click={onclickreg}/><Text size=12 text={txt}/></HorizontalList>", {
					def = producer_def,
					txt = show_per_minute
						and L("<bl>%s</>\n<hl>%.1f</>/min (<hl>%.1fs</>)", (producer_def.name or "Unknown"), (amount or 1)*60.0/ttime, ttime)
						or L("<bl>%s</>\n<hl>%.1fs</>", (producer_def.name or "Unknown"), ttime)
				})
			end
		end
	end

	if producer_txt then -- none known in tech tree, show locked
		list:Add("Text").text = producer_txt
		list:Add("<HorizontalList child_align=center child_padding=10><Reg bg=card_box_bg def_id=v_lock_locked/><Text size=12 text={txt}/></HorizontalList>").txt = "<bl>Unknown</>\nin <hl>???</> seconds"
		return true
	end
end

local function ShowIngredient(ingredient_list, seen_unlocks, id, num)
	if not seen_unlocks[id] then
		ingredient_list:Add("<Reg bg=item_default/>", { def_id = "v_lock_locked" })
		return true
	end
	ingredient_list:Add("<Reg bg=item_default on_click={onclickreg}/>", { def_id = id, num = num })
end

local function ShowIngredients(list, seen_unlocks, ingredients, def, amount, bp)
	local ingredient_list, have_locks = list:Add("<HorizontalList child_align=center child_padding=4/>")
	for id, num in pairs(ingredients) do have_locks = ShowIngredient(ingredient_list, seen_unlocks, id, num) or have_locks end
	if bp and bp.components then
		-- Also add blueprint components ingredients if applicable
		for i,v in ipairs(bp.components) do if type(v[2]) == "number" and v[1] ~= "c_integrated_behavior" then have_locks = ShowIngredient(ingredient_list, seen_unlocks, v[1], 1) or have_locks end end
	end
	ingredient_list:Add("<Image image=icon_small_arrow/>")
	ingredient_list:Add("<Reg bg=item_default on_click={onclickreg}/>", { def = def, num = (amount or 1) })
	-- show byproducts
	if def.production_recipe and def.production_recipe.byproduct then 
		for id, num in pairs(def.production_recipe.byproduct) do 
			if def.id ~= id then
				have_locks = ShowIngredient(ingredient_list, seen_unlocks, id, num) or have_locks end
		end
	end
	-- if def.has_alt ~= nil and seen_unlocks[def.has_alt] ~= nil then 
	-- 	-- has an alternative production recipe and it is seen
	-- 	local faction = Game.GetLocalPlayerFaction()
	-- 	if faction:IsUnlocked(def.has_alt) then 
	-- 		local def_2 = data.items[def.has_alt]
	-- 		ShowIngredients(list, seen_unlocks, def_2.production_recipe.ingredients, def_2, amount, bp)
	-- 	else
	-- 		list:Add("Text").text = "Unresearched alternative recipe"
	-- 	end 
	-- end
	return have_locks
end

local extraction_recipes, conversion_recipes, resim_recipes, ingredient_of, product_of
local function BuildExtraRecipeTables()
	extraction_recipes, conversion_recipes, resim_recipes, ingredient_of, product_of = {}, {}, {}, {}, {}

	local function DefineIngredient(ingredient_id, make_id, requirement_id)
		ingredient_of[ingredient_id] = ingredient_of[ingredient_id] or {}
		ingredient_of[ingredient_id][make_id] = requirement_id
	end

	local function DefineProduct(producer_id, product_id, requirement_id)
		product_of[producer_id] = product_of[producer_id] or {}
		product_of[producer_id][product_id] = requirement_id
	end

	for comp_id,comp_def in pairs(data.components) do
		if comp_def.extracts and comp_def.extraction_time then
			local extracts = comp_def.extracts
			extraction_recipes[extracts] = extraction_recipes[extracts] or { }
			extraction_recipes[extracts][comp_id] = comp_def.extraction_time
			DefineProduct(comp_id, extracts, comp_id)
		end
		if comp_def.conversion_recipes then
			for _, v in ipairs(comp_def.conversion_recipes) do
				local v_t, v_id = v.t, v.id
				for make_id, make_amount in pairs(v.to) do
					conversion_recipes[make_id] = conversion_recipes[make_id] or { }
					conversion_recipes[make_id][comp_id] = math.min(conversion_recipes[make_id][comp_id] or 9999, v_t / make_amount)
					DefineIngredient(v_id, make_id, comp_id)
					DefineProduct(comp_id, make_id, comp_id)
				end
			end
		end
		if comp_def.resim_recipes then
			for src,recipe in pairs(comp_def.resim_recipes) do
				local resim_to = recipe.to
				if resim_to then
					local producer_id = recipe.requires or comp_id
					resim_recipes[resim_to] = CreateProductionRecipe({ [src] = 1 }, { [producer_id] = recipe.time })
					DefineIngredient(src, resim_to, producer_id)
					DefineProduct(producer_id, resim_to, producer_id)
				end
			end
		end
	end
	for prod_id,prod_def in pairs(data.all) do
		local production_recipe = prod_def.production_recipe
		local prod_recipe = production_recipe or prod_def.construction_recipe
		local prod_ingredients = prod_recipe and prod_recipe.ingredients
		if prod_ingredients then
			for ingredient_id,_ in pairs(prod_ingredients) do
				DefineIngredient(ingredient_id, prod_id, true)
				if production_recipe then
					for comp_id,_ in pairs(production_recipe.producers) do
						DefineProduct(comp_id, prod_id, true)
					end
				end
			end
		end
		if prod_def.mining_recipe then
			for comp_id,_ in pairs(prod_def.mining_recipe) do
				DefineProduct(comp_id, prod_id, true)
			end
		end
	end
end

local function UpdateDefinitionTooltip(deftooltip)
	local mode = deftooltip.mode
	
	if mode == "all" then
		deftooltip.every_frame_update = nil
	else
		mode = (Input.IsShiftDown() and "stats") or (Input.IsAltDown() and "summed")
		if deftooltip.mode == mode then return end
		deftooltip.mode = mode
	end

	local def, list, options, bp, name, desc, tex = deftooltip.def, deftooltip.list, deftooltip.options
	local def_id, faction, entity, slot, comp, lootable = def.id, Game.GetLocalPlayerFaction()
	if type(def_id) == "string" then -- library items have numerical ids
		desc, tex, entity = def.desc, def.texture, (options and options.entity)
		slot = not entity and options and options.slot
		comp = not entity and not slot and options and options.comp
		if not entity or not entity.exists then
			name, entity = (def.name or "Unknown"), nil
		elseif entity.faction == faction then
			name = GetEntityName(entity)
		else
			name, entity, lootable = (def.name or "Unknown"), nil, (entity.lootable and entity)
		end
	elseif def.frame then -- blueprint
		bp, def_id = def, def.frame
		def = data.frames[def_id]
		if not def then return end
		name, desc, tex = NOLOC(bp.name) or (def.name or "New Blueprint"), (bp.desc or def.desc or "Blueprint"), def.texture
	elseif def.multi then -- multi blueprint
		local icon_def = data.all[def.icon]
		name, desc, tex, def_id = NOLOC(def.name) or "New Multi Blueprint", def.desc or "Multi Blueprint", icon_def and icon_def.texture or "icon_blueprint", nil
	else -- behavior
		local icon_def = data.all[def.icon]
		name, desc, tex, def_id = NOLOC(def.name) or "New Behavior", def.desc or "Behavior", icon_def and icon_def.texture or "icon_behavior", nil
	end

	list:Clear()

	-- add warning message
	if options and options.warning then
		list:Add([[
			<Canvas height=56 clip=true margin=-12 margin_bottom=4>
				<Image color="#5CEBA319" dock=fill/>
				<Image image=warning_pattern color="#60D4A2" dock=top-right/>
				<Image image=icon_warning color="#FFFF00" dock=left/>
				<Text wrap=true halign=fill valign=center margin_left=56 margin_right=12 text={txt}/>
			</Canvas>
		]]).txt = options.warning
	end

	if options and options.regname then
		list:Add("<Text size=16 color=ui_light halign=center/>").text = options.regname
		list:Add("<Image height=2 color=ui_light margin=8/>")
	end

	-- add name
	list:Add("<Text size=16 color=title halign=center/>").text = name

	-- add item category
	for _, category in ipairs(data.categories) do
		if def[category.filter_field] == category.filter_val then
			list:Add("<Text size=12 color=ui_light halign=center/>").text = category.name
			break
		end
	end

	local is_behavior = options and def.base_id == "c_behavior" and (slot or comp or options.behavior_code)
	if is_behavior then
		local ed = type(is_behavior) ~= "table" and is_behavior.has_extra_data and is_behavior.extra_data
		local asm = ed and ed.main_id and GetFactionBehaviorAsmById(faction, ed.main_id)
		local code = type(is_behavior) == "table" and is_behavior or (asm and asm.code)
		local beh_name = code and (code.name or "New Behavior")
		if beh_name then list:Add("<Text size=12 color=green halign=center/>").text = beh_name end
		desc = code and code.desc or desc
	end

	local def_visual = def.visual
	local visual_def = (entity and entity.visual_def) or (def_visual and (type(def_visual) == "table" and def_visual or data.visuals[def_visual]))
	if bp and def.type ~= "Wall" and def.type ~= "Foundation" and def.type ~= "Gate" and def.flags ~= "Space" and visual_def and visual_def.mesh then
		list:Add("<Preview width=128 height=128 halign=center quality=150 rotate=true/>", { visual = def_visual, components = bp.components })
	elseif tex then
		list:Add("<Image width=128 height=128 halign=center/>").image = tex
	end

	-- Add description line
	if desc then
		list:Add("<Text margin_bottom=8 halign=center wrapsize=300 wrap=true style=desc/>").text = desc
	end

	local locked_desc, is_unlocked, seen_unlocks = def.locked_desc, def_id and faction:IsUnlocked(def_id), Tech_GetSeenUnlocks()
	if locked_desc and not is_unlocked then
		list:Add("<Text margin_bottom=8 halign=center wrapsize=300 wrap=true style=rl/>").text = locked_desc
	end

	-- add entity warnings
	if entity then
		local warning_layout = [[<HorizontalList><Image image="icon_warning" width=25 height=25 color="yellow"/><Text valign=center text={err} style="hl"/></HorizontalList>]]
		for k,v in ipairs(entity.components or {}) do
			if v.register_count > 0 and v.def.get_reg_error and v:GetRegister(1).is_error then
				list:Add(warning_layout, { err = v.def:get_reg_error(v) })
			end
		end

		-- check store target
		local store = entity:GetRegisterEntity(FRAMEREG_STORE)
		if store and store.faction == faction then
			local store_full = true
			for k,v in ipairs(store.slots or {}) do
				if (not v.id or (v.id and v.unreserved_space > 0)) and not v.entity then store_full = false break end
			end
			if store_full then
				list:Add(warning_layout, { err = "Store target has no free slots" })
			end
		end

		-- check logistics network
		if entity.disconnected then list:Add(warning_layout, { err = "Not connected to Logistics network" }) end
		if not entity.logistics_carrier then list:Add(warning_layout, { err = "Does not deliver orders" }) end

		if not entity.logistics_supplier then list:Add(warning_layout, { err = "Supply items disabled" }) end
		if not entity.logistics_requester then list:Add(warning_layout, { err = "Request items disabled" }) end
		if entity.logistics_high_priority then list:Add(warning_layout, { err = "High Priority" }) end
		if entity.logistics_crane_only then list:Add(warning_layout, { err = "Only Item Transporters" }) end
		if entity.logistics_flying_only then list:Add(warning_layout, { err = "Only Flying Carriers" }) end

		-- Add entity state(s)
		for i,v in ipairs(entity.all_states) do
			list:Add("<HorizontalList><Image width=25 height=25 image={img}/><Text text={text} style='hl'/></HorizontalList>", { img = data.state_icons[v], text = data.state_names[v] })
		end

		-- Add sockets and inventory if showing for an entity
		if not entity.is_construction then
			local socketlist = list:Add("<Wrap child_padding=3 wrapsize=756/>")
			for i,v in ipairs(visual_def.sockets or {}) do
				socketlist:Add("<SocketBox update=false on_drag_start=false on_drop=false onclickreg={onclickreg}/>", {
					socket_size = v[2], entity = entity, socket = i,
					on_click = function(sb) sb:SendEvent("onclickreg", "LEFTMOUSEBUTTON", sb.comp and sb.comp.id) end,
				}):SetComp(entity:GetComponent(i))
			end
		end
	end

	-- add inventory
	if entity or lootable then
		local slotlist = list:Add("<Wrap child_padding=3 wrapsize=756/>")
		for i,slot in ipairs((entity or lootable).slots or {}) do
			if not lootable or not slot.component then -- dont show comp slots on explorables
				slotlist:Add("<ItemSlot update=false on_drag_start=false on_drop=false onclickreg={onclickreg}/>", {
					slot = slot,
					on_click = function(is) is:SendEvent("onclickreg", "LEFTMOUSEBUTTON", is.id) end,
				}):UpdateInfo()
			end
		end
	end

	-- show resimulated
	local options_esc = options and (entity or slot or comp)
	if options_esc and options_esc.has_extra_data and options_esc.extra_data.resimulated then
		local txt = entity and "Re-simulated unit" or "Re-simulated component"
		list:Add([[<HorizontalList><Image image="icon_warning" width=25 height=25 color="yellow"/><Text valign=center text={txt} style="hl"/></HorizontalList>]]).txt = txt
	end

	-- add producers/uplinks/miners/ingredients
	if not extraction_recipes then BuildExtraRecipeTables() end
	local show_all_stats = (mode == "all" or mode == "stats")
	local data_name, is_seen, producer_lists, ingredients, amount, have_locks = def.data_name, is_unlocked or seen_unlocks[def_id], 0
	if is_seen then
		if def.production_recipe then
			ingredients, amount = def.production_recipe.ingredients, def.production_recipe.amount
			producer_lists, have_locks = 1, ShowProducers(list, options, faction, seen_unlocks, "Produced by", def.production_recipe.producers, (data_name ~= "frames"), amount) or have_locks
		elseif def.construction_recipe then
			local build_boost, recipe = faction.component_boost, def.construction_recipe
			local ticks = recipe.ticks
			if build_boost ~= 100 then
				local tick_boost = ((ticks * 100 + build_boost - 1) // build_boost) / TICKS_PER_SECOND
				list:Add("Text", { text = L("%s: <hl>%.1fs</> (<gl>%.1fs</>)", "Build time", ticks / TICKS_PER_SECOND, tick_boost) })--/min
			else
				list:Add("Text", { text = L("%s: <hl>%.1fs</>", "Build time", ticks / TICKS_PER_SECOND) })--/min
			end
			ingredients = recipe.ingredients
		elseif def.mining_recipe then
			producer_lists, have_locks = 1, ShowProducers(list, options, faction, seen_unlocks, "Mined by", def.mining_recipe, true) or have_locks
		elseif def.uplink_recipe then
			local reg_comp = options and options.reg_comp
			local comp_boost, uplink_rate = (reg_comp and reg_comp.effective_boost or faction.component_boost), (reg_comp and reg_comp.def.uplink_rate or 1)
			local ul_tick = def.uplink_recipe.ticks
			if comp_boost ~= 100 or uplink_rate ~= 1 then
				local tick_boost = (ul_tick * uplink_rate * 100 + comp_boost - 1) // comp_boost
				local ttime = tick_boost / TICKS_PER_SECOND
				list:Add("Text", { text = L("%s: <gl>%.1f</>/min (<hl>%.1fs</>→<gl>%.1fs</>)", "Uplink time", 60.0 / ttime, def.uplink_recipe.ticks / TICKS_PER_SECOND, ttime) })
				if uplink_rate ~= 1 then list:Add("Text", { text = L("%s: <hl>%.0f</>%%", "Uplink rate", (1 / uplink_rate) * 100) }) end
			else
				local ttime = ul_tick / TICKS_PER_SECOND
				list:Add("Text", { text = L("%s: <hl>%.1f</>/min (<hl>%.1fs</>)", "Uplink time", 60.0 / ttime, ttime) })
			end
			ingredients = def.uplink_recipe.ingredients
		end
		if ingredients then
			have_locks = ShowIngredients(list, seen_unlocks, ingredients, def, amount, bp) or have_locks
		end

		local extractors, convertors, resim_recipe = extraction_recipes[def_id], conversion_recipes[def_id], resim_recipes[def_id]
		if extractors and HaveSeenAnyProducer(seen_unlocks, extractors) then
			producer_lists = producer_lists + 1
			if producer_lists == 1 or show_all_stats then
				ShowProducers(list, options, faction, seen_unlocks, "Extracted by", extractors, true)
			end
		end
		if convertors and HaveSeenAnyProducer(seen_unlocks, convertors) then
			producer_lists = producer_lists + 1
			if producer_lists == 1 or show_all_stats then
				ShowProducers(list, options, faction, seen_unlocks, "Converted by", convertors, true)
			end
		end
		if resim_recipe and HaveSeenAnyProducer(seen_unlocks, resim_recipe.producers) then
			producer_lists = producer_lists + 1
			if producer_lists == 1 or show_all_stats then
				ShowProducers(list, options, faction, seen_unlocks, "Re-Simulated by", resim_recipe.producers, (data_name ~= "frames"))
				ShowIngredients(list, seen_unlocks, resim_recipe.ingredients, def)
			end
		end
	end

	-- show research required message
	if (not is_unlocked and not locked_desc) or have_locks then
		if def.production_recipe or def.construction_recipe then
			list:Add('<Text size=12 style=rl text="Research Required"/>')
		elseif def.uplink_recipe and not GetResearchableTech(faction)[def_id] then
			list:Add('<Text size=12 style=rl text="Missing Required Tech"/>')
		elseif def.uplink_recipe then
			for ing_id, num in pairs(def.uplink_recipe.ingredients or {}) do
				local warning = not faction:IsUnlocked(ing_id) and (data.all[ing_id].locked_desc or "Research Required") or nil
				if warning then list:Add('<Text size=12 style=rl/>').text = L("%s: %s", data.all[ing_id].name or ing_id, warning) end
			end
		end
	end

	-- show item slot reserve status or total storage amount
	local is_inventory_item = is_seen and (data_name == "items" or data_name == "components")
	if options and slot and slot.id then
		-- Add reserve info if this is for an item slot
		list:Add("Text", { text = L("<hl>%d</> %s", slot.unreserved_stack, "Available") })
		local reserves = {}
		for i,v in ipairs(slot:GetReserveInfo()) do
			local key = L("<rl>%s</> <hl>%s</>", reserve_labels[v.mode], (v.component and v.component.def.name or ""))
			reserves[key] = (reserves[key] or 0) + v.amount
		end
		for key,amount in pairs(reserves) do
			list:Add("Text", { text = L("<hl>%d</> %s", amount, key) })
		end
	elseif is_inventory_item then
		-- Everywhere else show the total amount held by the faction
		local owned_amount = faction:GetItemAmount(def_id)
		if owned_amount and owned_amount > 0 then
			list:Add("Text", { text = L("<hl>%d</> %s", owned_amount, "Total Storage") })
		end
	end

	-- add tech unlocks
	if is_seen and def.unlocks then
		list:Add("<Image height=2 color=ui_light margin=8/>")
		list:Add('<Text text="Tech Unlocks:" color=ui_light/>')
		local unlocklist = list:Add("<Wrap width=296 wrap=true child_padding=4/>")
		for _,unlock_id in ipairs(def.unlocks) do
			if not data.values[unlock_id] and not data.codex[unlock_id] then
				unlocklist:Add("<Reg bg=item_default on_click={onclickreg}/>", { def_id = unlock_id })
			end
		end

		local progress = faction.extra_data.research_progress and faction.extra_data.research_progress[def_id] or 0
		local remain = (def.progress_count and def.progress_count or progress) - progress
		if not is_unlocked and remain > 0 and ingredients then
			list:Add("Text", { text = "Remaining Research:", color = "ui_light" })
			local horiz = list:Add("<HorizontalList child_padding=4/>")
			for id, num in pairs(ingredients) do
				horiz:Add("<Reg bg=item_default on_click={onclickreg}/>", { def_id = id, num = num*remain })
			end
		end

		-- check if its being research
		local uplinks, uplinkwrap = faction:GetComponents("c_uplink", true)
		for _,uplink_comp in ipairs(uplinks) do
			if uplink_comp:GetRegisterId(1) == def_id then
				if not uplinkwrap then
					list:Add("Text", { text = "Researched at:", color = "ui_light" })
					uplinkwrap = list:Add("<Wrap width=296 wrap=true child_padding=4/>")
				end
				uplinkwrap:Add("<Reg bg=item_default/>", { entity = uplink_comp.owner, coord = uplink_comp.owner.location })
			end
		end
	end

	-- Add frame socket and inventory slot stats
	local show_sockets_and_slots = (not entity or entity.is_construction) and is_seen
	local show_sockets = show_sockets_and_slots and visual_def and visual_def.sockets
	local show_slots = show_sockets_and_slots and def.slots
	if show_sockets or show_slots then
		list:Add("<Image height=2 color=ui_light margin=8/>")
		local wrap = list:Add('<Wrap halign=center wrapsize=320 child_padding=8/>')
		if show_sockets then
			for i,sz in ipairs(socket_sizes) do
				local n = 0
				for _,v in ipairs(show_sockets) do if v[2] == sz then n = n + 1 end end
				if n > 0 then
					local hl = wrap:Add([[<HorizontalList child_align=center child_padding=3>
							<Image width=32 height=32 color=ui_light/>
							<Text/>
						</HorizontalList>]])
					hl.order = #wrap
					hl.tooltip = L("%s Socket", sz)
					hl[1].image = socket_icons[i]
					hl[2].text = string.format("×%d", n)
				end
			end
		end
		if show_slots then
			local order_add = #wrap + 1
			for k,v in pairs(show_slots) do
				local hl = wrap:Add([[<HorizontalList child_align=center child_padding=3>
						<Canvas>
							<Image width=32 height=32 image=item_default/>
							<Image width=32 height=32 image={icon} color="#B6EEFC"/>
							<Image width=32 height=32 image={icon} color="ui_light" x=1/>
						</Canvas>
						<Text/>
					</HorizontalList>]])
				hl.order = order_add + (data.item_slot_order[k] or 999)
				hl.tooltip = L("%s\n%s: %s", "Item Slots", "Type", k)
				hl.icon = data.item_slot_icons[k] or "icon_inventory"
				hl[2].text = string.format("×%d", v)
			end
		end
		wrap:SortChildren(function(a,b) return a.order < b.order end)
	end

	local can_alt = (ingredients and not have_locks)
	if not can_alt and mode == "summed" then mode = false end
	local show_no_stats = (mode == "summed")
	local remain_stat_lines = (show_all_stats and 10002) or (show_no_stats and -1) or 3
	remain_stat_lines = AddStats(remain_stat_lines, list, 'STAT_MAIN', def, options and comp, entity, faction)

	local additional_title, additional_stats
	local deployer_slot_or_comp = def_id == "c_deployer" and options and (slot or comp)
	local deployer_ed = deployer_slot_or_comp and deployer_slot_or_comp.has_extra_data and deployer_slot_or_comp.extra_data
	local dep_bp = deployer_ed and deployer_ed.bp
	if dep_bp then
		additional_title, additional_stats = "Contained:", data.frames[dep_bp.frame]
	end

	if additional_stats then
		list:Add("<Image height=2 color=ui_light margin=8/>")
		list:Add('<Text color=ui_light/>').text = additional_title
		list:Add("<Text size=14 color=title halign=center/>").text = additional_stats.name
		if deployer_ed and deployer_ed.onetime then
			list:Add("<Text size=14 color=red halign=center/>").text = "One-Time Use"
		end
		if dep_bp and additional_stats.visual and additional_stats.type ~= "Wall" and additional_stats.type ~= "Foundation" and additional_stats.type ~= "Gate" and additional_stats.flags ~= "Space" then
			list:Add("<Preview width=104 height=104 halign=center quality=150 rotate=true/>", { visual = additional_stats.visual, components = dep_bp.components })
		else
			list:Add("<Image width=96 height=96 halign=center/>").image = additional_stats.texture
		end
	end

	if remain_stat_lines >= 0 and additional_stats then
		remain_stat_lines = AddStats(remain_stat_lines, list, 'STAT_ADDITIONAL', additional_stats, nil, nil, faction)
	elseif remain_stat_lines >= 0 and def.components then
		local hidden_count = 1
		for i,v in ipairs(def.components) do
			local comp_def = data.all[v[1]]
			local stat_comp = entity and entity:GetHiddenComponent(hidden_count)
			stat_comp = stat_comp and stat_comp.id == v[1] and stat_comp
			if stat_comp then hidden_count = hidden_count + 1 end
			remain_stat_lines = v[2] == "hidden" and comp_def.get_ui and AddStats(remain_stat_lines, list, 'STAT_COMPONENT', comp_def, stat_comp, entity, faction) or remain_stat_lines
			if remain_stat_lines < 0 then break end
		end
	end

	if remain_stat_lines < 0 and not show_no_stats then
		list:Add('<Text text="・ ・ ・ ・ ・" color=light_gray size=8 textalign=center/>')
	end

	local can_shift = (remain_stat_lines < 0 or (show_all_stats and remain_stat_lines < 10000) or producer_lists > 1)
	if not can_shift and mode == "stats" then mode = nil end

	if not mode then
		local modemsg = can_shift and (can_alt and "Hold Shift/Alt for Details" or "Hold Shift for Details") or (can_alt and "Hold Alt for Details")
		local sysindexmsg = 'Press <Key action="SystemIndex"/> /<Key id="MiddleMouseButton"/> for More Info'
		list:Add("<Text color=light_gray size=8 halign=center margin_top=4/>").text = modemsg and L("%s・%s", modemsg, sysindexmsg) or sysindexmsg
		if options and options.clearreg then
			list:Add('<Text color=light_gray size=8 halign=center/>').text = options and options.entity and "Right-Click to open menu" or "Right-Click to clear value"
		end
	end

	-- List all frames that have this component integrated
	if mode == "all" and data_name == "components" then
		local frames_with =  Tech_GetFramesWithIntegrated(def_id)
		if frames_with then
			list:Add("<Image height=2 color=ui_light margin=8/>")
			list:Add('<Text text="Integrated On:" color=ui_light/>')
			local unlocklist = list:Add("<Wrap width=296 wrap=true child_padding=4/>")
			for _,frame_id in ipairs(frames_with) do
				unlocklist:Add("<Reg bg=item_default on_click={onclickreg}/>", { def_id = frame_id })
			end
		end
	end

	-- List all things that use this as an ingredient and all things that can be produced/generated in this
	for productof_or_ingredientof=1,2 do
		local def_of = mode == "all" and ((productof_or_ingredientof == 1 and product_of[def_id]) or (productof_or_ingredientof == 2 and ingredient_of[def_id]))
		if def_of then
			local data_categories, data_all, vl = data.categories, data.all
			for prod_id,prod_req in pairs(def_of) do
				if ((prod_req == true and seen_unlocks[prod_id] and faction:IsUnlocked(prod_id)) or (prod_req ~= true and seen_unlocks[prod_req])) then
					local prod_def = data_all[prod_id]
					for category_idx, category in ipairs(data_categories) do
						if prod_def[category.filter_field] == category.filter_val then
							if not vl then
								list:Add("<Image height=2 color=ui_light margin=8/>")
								if productof_or_ingredientof == 1 then
									list:Add('<Text text="Product Output:" color=ui_light/>')
									list:Add('<Text text="Products produced or generated by this component" color=light_gray margin_bottom=6/>')
								else
									list:Add('<Text text="Is Ingredient Of:" color=ui_light/>')
									list:Add('<Text text="Products using this item as ingredient" color=light_gray margin_bottom=6/>')
								end
								vl = list:Add("<VerticalList child_padding=8 margin_left=12/>")
							end
							local catwrap = vl[category.name]
							if not catwrap then
								local row = vl:Add("<HorizontalList><Text fill=1 valign=top y=8 color=ui_light textalign=right margin_right=12/><Wrap fill=2 child_padding=4/></HorizontalList>")
								row.cat = category_idx
								row[1].text = category.name
								catwrap = row[2]
								vl[category.name] = catwrap
							end

							catwrap:Add("<Reg width=36 height=36 bg=item_default on_click={onclickreg}/>",
								{ def = prod_def, name = prod_def.name or "Unknown", cat = category_idx, idx = (prod_def.index or 9999) })
							break
						end
					end
				end
			end
			if vl then
				vl:SortChildren(function(a, b) return a.cat < b.cat end)
				for _,row in ipairs(vl) do row[2]:SortChildren(function(a, b) return a.idx < b.idx end) end
			end
		end
	end
	--mode = 'summed'
	if mode == "summed" and ingredients and not have_locks then
		-- Add summed up ingredient requirements and list how many producers are required to meet a constant production
		list:Add("<Image height=2 color=ui_light margin=8/>")
		list:Add('<Text text="Ingredient Requirements:" color=ui_light/>')
		IngredientRequirementsGraph(list, def_id, bp, seen_unlocks)
	elseif mode == "all" and ingredients and not have_locks then
		-- Add summed up ingredient requirements and list how many producers are required to meet a constant production
		list:Add("<Image height=2 color=ui_light margin=8/>")

		local prop = { onbtn = function(hl, btn)
			local pop = UI.MenuPopup("<Box blur=true padding=10><VerticalList/></Box>", btn)
			if not pop then return end
			if btn.ir then
				IngredientRequirementsGraph(pop[1], def_id, bp, seen_unlocks)
			else
				ProductionBreakdownGraph(pop[1], def_id, bp, ingredients, amount)
			end
			function pop:onclickreg(...) list:SendEvent("onclickpopreg", ...) end
		end }
		list:Add('<HorizontalList child_align=center child_padding=16><Text text="Ingredient Requirements:" color=ui_light min_width=200/><Button icon=icon_small_find text="Click for more details" height=32 on_click={onbtn} ir=true/></HorizontalList>', prop)
		list:Add('<HorizontalList child_align=center child_padding=16><Text text="Production Breakdown:" color=ui_light min_width=200/><Button icon=icon_small_find text="Click for more details" height=32 on_click={onbtn}/></HorizontalList>', prop)
	end
end

local tooltip_window, system_index

OpenSystemIndex = function()
	local id = tooltip_window and tooltip_window.def.id
	if type(id) ~= "string" then id = tooltip_window and tooltip_window.def.frame end -- library items have numerical ids
	if not system_index then
		local x, y, w, h
		if id then x, y, w, h = tooltip_window:GetViewportPosition() end
		UI.MenuPopup("SystemIndex", { id = id, animw = w, animh = h, options = id and tooltip_window.options }, (w and "TOOLTIP" or "SCREEN"))
	elseif id then
		system_index:selectid(id)
	elseif system_index.listbox.hidden then
		system_index:showlist()
	end

	-- If the mouse is still triggering the definition tooltip, hide it until it is opened the next time
	if id then
		UI.RefreshTooltip()
		if tooltip_window then tooltip_window.hidden = true tooltip_window = nil end
	end
end

local function DefinitionTooltipMouseButtonDown(w, mousebtn) -- tooltip mouse handler must specifically return true if handled
	--if mousebtn == "MIDDLEMOUSEBUTTON" and tooltip_window and not tooltip_window.hidden then OpenSystemIndex() return true end
	-- replace with false?
	if mousebtn == "MIDDLEMOUSEBUTTON" and tooltip_window and not tooltip_window.hidden then OpenSystemIndex() return true end

end


BuildDefinitionTooltip = function(def_or_id, options)
	local def = type(def_or_id) ~= "string" and def_or_id or data.all[def_or_id]
	if not def then return end
	--print("Build Definition New")
	return UI.New("<Box bg=popup_box_bg padding=12 blur=true><VerticalList id=list child_padding=4/></Box>", {
		def = def,
		options = options,
		construct = function(w)
			tooltip_window = w
			if options and options.highlight then View.HighlightEntity(options.highlight) end
		end,
		destruct = function(w)
			if tooltip_window == w then tooltip_window = nil end
			if options and options.highlight then View.HighlightEntity(nil) end
		end,
		every_frame_update = UpdateDefinitionTooltip,
		on_mouse_button_down = DefinitionTooltipMouseButtonDown,
	})
end


data.tooltip_definition = BuildDefinitionTooltip

-- Return a function that creates a tooltip for any id or definition
DefinitionTooltip = function (def_or_id, options)
	return function() return BuildDefinitionTooltip(def_or_id, options) end
end

Input.RemoveActionBinding("SystemIndex")

Input.BindAction("SystemIndex", "Released", OpenSystemIndex)

local SystemIndex_2 = UI.GetRegisteredLayoutClass("SystemIndex")
SystemIndex_2.on_item_tooltip = function(itemw)
	return BuildDefinitionTooltip(itemw.def)
end



UI.Register("SystemIndex_2",UI.GetRegisteredLayoutString("SystemIndex"),SystemIndex_2)

local ResourceBar = UI.GetRegisteredLayoutClass("ResourceBar")
ResourceBar.on_click_systemindex = function(btn)
	OpenSystemIndex()
end

SystemIndex_2.selectid = function(self, id, go_back, go_forward)
	local scrollpos, lastid = 0, self.lastid
	if lastid then
		if lastid == id then return end
		local history, historypos = self.history, self.historypos
		if not history then history, historypos = { }, 1 self.history = history end
		history[historypos], history[historypos+1] = lastid, self.details:GetScrollOffset()
		if go_back or go_forward then
			historypos = historypos + (go_forward and 2 or -2)
			id, scrollpos = history[historypos], history[historypos+1]
		else
			local clear = #history - (historypos+1)
			if clear > 0 then table.move(history, #history+1, #history+1+clear, historypos+2) end
			historypos = historypos + 2
			self.backbtn.hidden = false
			self.forwardbtn.hidden = false
		end
		self.historypos = historypos
		self.backbtn.disabled = historypos == 1
		self.forwardbtn.disabled = not go_back and (not go_forward or (historypos+1) == #history)
	end
	self.lastid = id
	local def = data.all[id]
	if not def then return end
	local options = self.options
	local defspacer = self.details:SetContent("<Spacer><VerticalList id=list onclickpopreg={onclickpopreg} child_padding=4/></Spacer>", {
		def = def,
		mode = "all",
		options = options and (self.backbtn.hidden or self.backbtn.disabled) and options,
	})
	UpdateDefinitionTooltip(defspacer)
	self.details:SetScrollOffset(scrollpos)
	local data_name = def.data_name
	local itemorframe = (data_name == "items" or data_name == "frames" or data_name == "components")
	local islocked = itemorframe and Game.GetLocalPlayerFaction():IsUnlocked(id)
	self.factionbtn.hidden = not itemorframe or not islocked
	self.techbtn.hidden = not itemorframe or islocked
	self.closebtn.hidden = false

	if not self.listbox.hidden then
		if self.listbox.width ~= 368 then
			self.listbox.width = 368
			for _,w in ipairs(self.defs) do w.width = 368 end
		end
		self:sethighlight(id)
	end
end


-- local SystemIndex_layout<const> = [[
-- 	<Box bg=popup_box_bg padding=12 blur=true width=936 height=600>
-- 		<HorizontalList>
-- 			<Canvas id=listbox width=368 margin_right=8 clip=true>
-- 				<TextSearch id=search halign=fill on_refresh={on_search}/>
-- 				<ScrollList id=defs dock=fill margin_top=40/>
-- 			</Canvas>
-- 			<VerticalList fill=true child_padding=8>
-- 				<ScrollList id=details fill=true/>
-- 				<HorizontalList id=buttons child_padding=8 height=32>
-- 					<Button id=backbtn icon=icon_previous tooltip="Back" on_click={back} height=32 hidden=true/>
-- 					<Button id=forwardbtn icon=icon_next tooltip="Forward" on_click={forward} height=32 hidden=true/>
-- 					<Spacer fill=true/>
-- 					<Button id=selecbtn icon=icon50_Library text="Object List" on_click={showlist} height=32 hidden=true/>
-- 					<Button id=factionbtn icon=icon50_Faction text="Control Center" on_click={gofaction} height=32 hidden=true/>
-- 					<Button id=techbtn icon=icon50_Tech text="Research" on_click={gotech} height=32 hidden=true/>
-- 					<Button id=closebtn icon=icon_deny text="Close" on_click={close} height=32 hidden=true/>
-- 				</HorizontalList>
-- 			</VerticalList>
-- 		</HorizontalList>
-- 	</Box>
-- ]]

-- local SystemIndexItem_layout<const> =
-- [[
-- 	<Box width=56 height=56 bg=item_default on_click={on_item_click} tooltip={on_item_tooltip}>
-- 		<Canvas child_fill=true>
-- 			<Image image={racebg} hide_no_image=true margin=2/>
-- 			<Image image={icon} id=iconimg color="#D0" margin=3/>
-- 		</Canvas>
-- 	</Box>
-- ]]



-- local SystemIndex = UI.GetRegisteredLayoutClass("SystemIndex")

-- print(SystemIndex)

-- SystemIndex.on_item_tooltip = function(itemw) return BuildDefinitionTooltip_local(itemw.def) end

-- print(SystemIndex)

-- UI.SetRegisteredLayoutClass("SystemIndex", SystemIndex)

----------------------------

-- local SystemIndex = {}

-- function SystemIndex:construct()
-- 	system_index = self
-- 	if self.animw then
-- 		self.listbox.hidden = true
-- 		self:TweenFromTo("width", self.animw, math.max(self.animw, 600), 250)
-- 		self:TweenFromTo("height", self.animh, math.max(self.animh + 40, 600), 250)
-- 		self.buttons:TweenFromTo("height", 0, 32, 250)
-- 		self.selecbtn.hidden = false
-- 	end
-- 	if self.id then
-- 		self:selectid(self.id)
-- 	else
-- 		self:refreshlist()
-- 		self.search:Focus()
-- 		self.listbox.width = 912
-- 		for _,w in ipairs(self.defs) do w.width = 912 end
-- 	end
-- end

-- function SystemIndex:destruct()
-- 	system_index = nil
-- end

-- function SystemIndex:showlist()
-- 	self:refreshlist()
-- 	self.selecbtn.hidden = true
-- 	self.listbox.hidden = false
-- 	self.listbox:TweenFromTo("width", 0, 368, 250)
-- 	self.listbox:TweenFromTo("margin_right", 0, 8, 250)
-- 	self:TweenFromTo("width", 600, 936, 250)
-- end

-- function SystemIndex:selectid(id, go_back, go_forward)
-- 	local scrollpos, lastid = 0, self.lastid
-- 	if lastid then
-- 		if lastid == id then return end
-- 		local history, historypos = self.history, self.historypos
-- 		if not history then history, historypos = { }, 1 self.history = history end
-- 		history[historypos], history[historypos+1] = lastid, self.details:GetScrollOffset()
-- 		if go_back or go_forward then
-- 			historypos = historypos + (go_forward and 2 or -2)
-- 			id, scrollpos = history[historypos], history[historypos+1]
-- 		else
-- 			local clear = #history - (historypos+1)
-- 			if clear > 0 then table.move(history, #history+1, #history+1+clear, historypos+2) end
-- 			historypos = historypos + 2
-- 			self.backbtn.hidden = false
-- 			self.forwardbtn.hidden = false
-- 		end
-- 		self.historypos = historypos
-- 		self.backbtn.disabled = historypos == 1
-- 		self.forwardbtn.disabled = not go_back and (not go_forward or (historypos+1) == #history)
-- 	end
-- 	self.lastid = id
-- 	local def = data.all[id]
-- 	if not def then return end
-- 	local options = self.options
-- 	local defspacer = self.details:SetContent("<Spacer><VerticalList id=list onclickpopreg={onclickpopreg} child_padding=4/></Spacer>", {
-- 		def = def,
-- 		mode = "all",
-- 		options = options and (self.backbtn.hidden or self.backbtn.disabled) and options,
-- 	})
-- 	UpdateDefinitionTooltip(defspacer)
-- 	self.details:SetScrollOffset(scrollpos)
-- 	local data_name = def.data_name
-- 	local itemorframe = (data_name == "items" or data_name == "frames" or data_name == "components")
-- 	local islocked = itemorframe and Game.GetLocalPlayerFaction():IsUnlocked(id)
-- 	self.factionbtn.hidden = not itemorframe or not islocked
-- 	self.techbtn.hidden = not itemorframe or islocked
-- 	self.closebtn.hidden = false

-- 	if not self.listbox.hidden then
-- 		if self.listbox.width ~= 368 then
-- 			self.listbox.width = 368
-- 			for _,w in ipairs(self.defs) do w.width = 368 end
-- 		end
-- 		self:sethighlight(id)
-- 	end
-- end

-- function SystemIndex:back() self:selectid(nil, true) end
-- function SystemIndex:forward() self:selectid(nil, nil, true) end

-- function SystemIndex:sethighlight(id)
-- 	local last_reg, reg = self.last_reg, self.regs[id]
-- 	if last_reg then
-- 		last_reg.bg, last_reg.iconimg.margin, last_reg.iconimg.color = "item_default", 3, "#D0"
-- 	end
-- 	if reg then
-- 		reg.bg, reg.iconimg.margin, reg.iconimg.color = "item_active", 0, "#FF"
-- 		self.defs:ScrollIntoView(reg)
-- 	end
-- 	self.last_reg = reg
-- end

-- function SystemIndex:refreshlist(filter)
-- 	if filter == "" then filter = nil end
-- 	local ContainsStringNoCase = filter and Tool.ContainsStringNoCase
-- 	local list, regs, lastcat, catwrap = self.defs, {}
-- 	local RaceTagOrder = data.RaceTagOrder
-- 	self.regs, self.last_reg = regs, nil
-- 	list:Clear()
-- 	ProcessUnlockedDefinitions(function(id, def, category)
-- 		local found = not filter or ContainsStringNoCase(L(def.name or ""), filter) -- filter by text
-- 		if not found then return end
-- 		if lastcat ~= category then
-- 			lastcat = category
-- 			list:Add("<Text height=24/>").text = category.name
-- 			catwrap = list:Add("<Wrap child_padding=4 width=368/>")
-- 		end
-- 		regs[def.id] = catwrap:Add(SystemIndexItem_layout, {
-- 			def_id = def.id, def = def, icon = def.texture,
-- 			racebg = def.race and GetComponentRaceBG(def.race),
-- 			sortkey = string.format("%03d%s", RaceTagOrder[def.race or def.tag] or 999, id)
-- 		})
-- 	end, nil, nil, nil, true)
-- 	for _,w in ipairs(list) do
-- 		if not w.text then w:SortChildren(function(a, b) return a.sortkey < b.sortkey end) end
-- 	end
-- 	self:sethighlight(self.lastid)
-- end

-- function SystemIndex:on_search(w, txt)
-- 	self:refreshlist(txt)
-- end

-- function SystemIndex:close()
-- 	UI.CloseMenuPopup(self)
-- end

-- function SystemIndex:on_item_click(itemw)
-- 	self:selectid(itemw.def_id)
-- end

-- function SystemIndex:on_item_tooltip(itemw)
-- 	return BuildDefinitionTooltip_local(itemw.def)
-- end

-- function SystemIndex:gofaction()
-- 	local id = self.lastid
-- 	local is_frame = (data.all[id].data_name == "frames")
-- 	UI.CloseMenuPopup()
-- 	OpenMainWindow("Faction", { show_item_id = not is_frame and id or nil, show_frame_id = is_frame and id or nil }, false, true) -- pass no_close so it can be used even in tech tree or behavior editor
-- end

-- function SystemIndex:gotech()
-- 	local id = self.lastid
-- 	UI.CloseMenuPopup()
-- 	OpenMainWindow("Tech", { param = id })
-- end

-- function SystemIndex:onclickreg(reg, mousebutton, set_id)
-- 	local id = set_id or reg.def_id or (reg.def and reg.def.id)
-- 	if id then self:selectid(id) end
-- end

-- function SystemIndex:onclickpopreg(defspacer, list, reg, mousebutton, set_id)
-- 	self:onclickreg(reg, mousebutton, set_id)
-- end

-- UI.SetRegisteredLayoutClass("SystemIndex", SystemIndex)
-- --`

-- print('Overide SystemIndex Success')

-- local ResourceBar = UI.GetRegisteredLayoutClass("ResourceBar")

-- local old_on_click_systemindex = ResourceBar.on_click_systemindex
-- ResourceBar.on_click_systemindex = function (self, btn) OpenSystemIndex() end 

-- UI.SetRegisteredLayoutClass('ResourceBar', ResourceBar)


