function Inherit(parent, child)
	for k, v in pairs(parent) do
		if type(child[k]) == nil then
			child[k] = v
		end
	end
	return child
end

function EmptyTableAsNil(tbl)
	return next(tbl) and tbl
end

---@param ingredients table Table with ingredient item id and amount
---@param producers table Table with production component id and ticks
---@param amount? number Amount of items produced in one step (defaults 1)
function CreateProductionRecipe(ingredients, producers, amount)
	if type(ingredients) ~= "table" then Debug.Assert(false, "List of production ingredients must be defined") ingredients = {} end
	if type(producers) ~= "table" then Debug.Assert(false, "List of production producers must be defined") producers = {} end
	return { ingredients = ingredients, producers = producers, amount = amount or 1 }
end

---@param miners table Table with miner component id and ticks
function CreateMiningRecipe(miners)
	if type(miners) ~= "table" then Debug.Assert(false, "List of mining miners must be defined") miners = {} end
	return miners
end

---@param ingredients table Table with ingredient item id and amount
---@param ticks number Ticks required for uplink
function CreateUplinkRecipe(ingredients, ticks)
	if type(ingredients) ~= "table" then Debug.Assert(false, "List of uplink ingredients must be defined") ingredients = {} end
	return { ingredients = ingredients, ticks = ticks or 1 }
end

---@param ingredients table Table with ingredient item id and amount
---@param ticks number Ticks required for construction
function CreateConstructionRecipe(ingredients, ticks)
	if type(ingredients) ~= "table" then Debug.Assert(false, "List of construction ingredients must be defined") ingredients = {} end
	return { ingredients = ingredients, ticks = ticks or 1 }
end

-- When calling from UI context pass nil as faction
-- Mode is only valid if num_or_true has a number passed, it can be 'add', 'increment_if_less', 'set_if_less', 'set_if_one_less' (defaults to 'add')
function FactionCount(counter_name, num_or_true, faction, mode)
	local faction_data = (faction or Game.GetLocalPlayerFaction()).extra_data
	local faction_counters = faction_data.counters
	if num_or_true == true and faction_counters and faction_counters[counter_name] then return end -- already done
	if faction then
		if not faction_counters then faction_counters = {} faction_data.counters = faction_counters end
		local old_value, new_value = num_or_true ~= true and (faction_counters[counter_name] or 0)
		if num_or_true == true then             new_value = true
		elseif mode == 'increment_if_less' then new_value = num_or_true > old_value and old_value + 1
		elseif mode == 'set_if_less' then       new_value = num_or_true > old_value and num_or_true
		elseif mode == 'set_if_one_less' then   new_value = num_or_true == old_value + 1 and num_or_true
		else                                    new_value = (old_value == true and 1 or old_value) + (num_or_true or 1)
		end
		if not new_value then return end
		faction_counters[counter_name] = new_value
		Map.Run("OnFactionCount", faction, counter_name, old_value, new_value)
		return new_value -- count was updated
	end
	Action.SendForLocalFaction("DoFactionCount", { name = counter_name, val = num_or_true, mode = mode })
end

function FactionAction.DoFactionCount(faction, arg)
	FactionCount(arg.name, arg.val, faction, arg.mode)
end

function GetProduction(id, src, get_deployer_bp)
	local def = data.all[id]
	if def and def.data_name == "frames" then
		local bp = src and src.has_extra_data and (src.extra_data.custom_blueprint or (get_deployer_bp and src.extra_data.bp))
		if bp and bp.frame == id then return def, bp end -- custom blueprint
	end
	return def
end

function GetBuiltFrameDef(entity, include_deployer)
	if not entity.is_construction then -- regular entities
		return entity.def
	elseif entity:CountComponents("c_construction", true) > 0 then -- handles buildings, upgrades and relocations
		return data.frames[entity:GetRegisterId(FRAMEREG_GOTO)]
	elseif include_deployer then -- handles deployers
		local depcon = entity:FindComponent("c_deploy_construction")
		local depcon_bp = depcon and depcon.extra_data.bp
		local depcon_lander = not depcon_bp and depcon and depcon.extra_data.lander
		return data.frames[(depcon_bp and depcon_bp.frame) or (depcon_lander and depcon_lander:FindComponent("c_deployment", true).def.deployment_frame)]
	end
end

function GetConstructionSiteIdOrBP(entity, include_deployer, include_relocation) -- returns reference to unmutable simulation data
	local depcon = include_deployer and entity:FindComponent("c_deploy_construction")
	local relcon = include_relocation and not depcon and entity:FindComponent("c_relocation")
	if depcon then
		local depcon_bp = depcon and depcon.extra_data.bp
		local depcon_lander = not depcon_bp and depcon and depcon.extra_data.lander
		return (not depcon_bp and depcon_lander and depcon_lander:FindComponent("c_deployment", true).def.deployment_frame), depcon_bp, true
	elseif relcon then
		local relcon_slot = entity:GetSlot(1)
		local relcon_slot_ed = relcon_slot and relcon_slot.extra_data
		local relcon_order = not relcon_slot_ed and relcon_slot and entity.faction:GetActiveOrders(entity, relcon_slot)[1]
		local relcon_order_entity = relcon_order and (relcon_order.source_entity or relcon_order.carry_entity)
		local relcon_order_slot = relcon_order_entity and relcon_order_entity:FindSlot("c_deployer")
		local relcon_order_slot_ed = relcon_order_slot and relcon_order_slot.extra_data
		return nil, ((relcon_slot_ed and relcon_slot_ed.bp) or (relcon_order_slot_ed and relcon_order_slot_ed.bp)), true
	end
	local bp = entity.has_extra_data and entity.extra_data.custom_blueprint
	local frame_id = not bp and entity:GetRegisterId(FRAMEREG_GOTO)
	return (not bp and frame_id and data.frames[frame_id] and frame_id), bp
end

function GetIngredients(recipe, blueprint_def)
	local ingredients, bp_components = recipe and recipe.ingredients, blueprint_def and blueprint_def.components
	if bp_components and recipe then
		ingredients = Tool.Copy(ingredients) or {}
		for i,v in ipairs(bp_components) do
			-- ignore components without a socket index like inhereted or hidden ones
			if type(v[2]) == "number" and v[1] ~= "c_integrated_behavior" then ingredients[v[1]] = (ingredients[v[1]] or 0) + 1 end
		end
	end
	return ingredients
end

function CreateConstructionSite(faction, frame_id, x, y, rotation, upgrade_mode)
	local e = Map.CreateEntity(faction, "f_construction", frame_id)
	local comp = e:AddComponent("c_construction")
	e.logistics_channel_2, e.logistics_channel_3, e.logistics_channel_4 = true, true, true
	e:SetRegisterId(FRAMEREG_GOTO, frame_id, upgrade_mode)
	e:SetRegisterId(FRAMEREG_VISUAL, frame_id)
	e:Place(x, y, rotation or 0)
	return e, comp
end

local race_foundations = {
	robot = "f_foundation",
	human = "f_human_foundation_basic",
}
function CreateFoundationsForEntity(entity, x, y, rotation)
	if entity.has_movement then return end
	local def = entity.def
	local foundation_id = race_foundations[def.race]
	if not foundation_id or def.type or def.no_foundations then return end
	local faction, size_x, size_y = entity.faction, entity:GetSizeAtRotation(rotation)
	local l, r = x - 1, x + size_x
	for y = y - 1, y + size_y do
		for x = l, r do
			if not Map.GetFoundationEntityAt(x, y) and faction:CanPlace(foundation_id, x, y) then
				Map.CreateEntity(faction, foundation_id):Place(x, y)
			end
		end
	end
end

local prep_filters<const> = {
	-- Faction filters
	v_own_faction = FF_OWNFACTION|FF_ALL, v_enemy_faction = FF_ENEMYFACTION|FF_ALL, v_ally_faction = FF_ALLYFACTION|FF_ALL, v_world_faction = FF_WORLDFACTION|FF_ALL,

	-- Generic operating entity filters
	v_solved = FF_WORLDFACTION|FF_OPERATING, v_unsolved = FF_OPERATING, v_bot = FF_OPERATING, v_building = FF_OPERATING, v_infected = FF_OPERATING,
	v_anomaly = FF_WORLDFACTION|FF_OPERATING, v_unpowered = FF_OPERATING, v_moving = FF_OPERATING, v_pathblocked = FF_OPERATING, v_idle = FF_OPERATING,

	-- Specific frame type filters
	v_is_foundation = FF_FOUNDATION, v_construction = FF_CONSTRUCTION, v_droppeditem = FF_DROPPEDITEM, v_mineable = FF_RESOURCE, v_wall = FF_WALL|FF_GATE,

	-- Combined frame type filters
	v_can_loot = FF_OPERATING|FF_DROPPEDITEM, v_powereddown = FF_OPERATING|FF_CONSTRUCTION, v_resource = FF_RESOURCE|FF_DROPPEDITEM,
}

local prep_filters_not<const> = {
	-- Faction filters
	v_own_faction = FF_ENEMYFACTION|FF_NEUTRALFACTION|FF_ALLYFACTION|FF_WORLDFACTION|FF_ALL,
	v_enemy_faction = FF_OWNFACTION|FF_NEUTRALFACTION|FF_ALLYFACTION|FF_WORLDFACTION|FF_ALL,
	v_ally_faction = FF_OWNFACTION|FF_ENEMYFACTION|FF_NEUTRALFACTION|FF_WORLDFACTION|FF_ALL,

	-- World filter still needs to include world faction (see FilterEntity)
	v_world_faction = FF_ALL,

	-- Generic operating entity filters (can't just be negated)
	v_solved = FF_ALL, v_unsolved = FF_ALL, v_bot = FF_ALL, v_building = FF_ALL, v_infected = FF_ALL,
	v_anomaly = FF_ALL, v_unpowered = FF_ALL, v_moving = FF_ALL, v_pathblocked = FF_ALL, v_idle = FF_ALL,

	-- Specific frame type filters
	v_is_foundation = FF_ALL - FF_FOUNDATION, v_construction = FF_ALL - FF_CONSTRUCTION, v_droppeditem = FF_ALL - FF_DROPPEDITEM, v_mineable = FF_ALL - FF_RESOURCE, v_wall = FF_ALL - (FF_WALL|FF_GATE),

	-- Combined frame type filters (can't just be negated)
	v_can_loot = FF_ALL, v_powereddown = FF_ALL, v_resource = FF_ALL,
}

function PrepareFilterEntity(filters)
	local frametype, faction, range = FF_ALL, FF_OWNFACTION|FF_ENEMYFACTION|FF_NEUTRALFACTION|FF_ALLYFACTION|FF_WORLDFACTION
	for i=1, #filters, 2 do
		local f, num = filters[i], filters[i+1]
		local prepf = (num == REG_NOT and prep_filters_not or prep_filters)[f]
		if prepf then
			frametype = frametype & prepf
			if prepf > FF_ALL then faction = faction & prepf end
		else
			if f == "v_maxrange" then
				range = num
			elseif num ~= REG_NOT then
				local fdef = data.all[f]
				local fdataname = fdef and fdef.data_name
				if fdataname == 'items' then
					prepf = (FF_RESOURCE|FF_DROPPEDITEM)
				elseif fdataname == 'frames' and fdef.type == "Foundation" then
					prepf = FF_FOUNDATION
				end
			end
		end
	end
	return (frametype ~= 0 and faction ~= 0 and (frametype | faction) or 0), range
end

local FilterStringToNum =
{
	v_own_faction   =  0, v_enemy_faction =  0, v_ally_faction  =  0,
	v_world_faction =  1, v_robot_faction =  2, v_bug_faction   =  3, v_human_faction =  4,
	v_alien_faction =  5, v_anomaly       =  6, v_resource      =  7, v_is_grounded   =  8, v_is_flying     =  9,
	v_unsolved      = 10, v_solved        = 11, v_can_loot      = 12, v_bot           = 13, v_building      = 14,
	v_is_foundation = 15, v_wall          = 16, v_construction  = 17, v_droppeditem   = 18, v_mineable      = 19,
	v_damaged       = 20, v_infected      = 21, v_unpowered     = 22, v_powereddown   = 23, v_in_powergrid  = 24,
	v_plateau       = 25, v_valley        = 26, v_not_blight    = 27, v_blight        = 28, v_is_flower     = 29,
	v_moving        = 30, v_pathblocked   = 31, v_idle          = 32, v_emergency     = 33, v_broken        = 34,
	v_setnum        = 35, v_maxrange      = 36,
}

function FilterEntity(bounds_entity, e, filters)
	local retnum = nil
	for i=1, #filters, 2 do
		local f, num, ok = filters[i], filters[i+1]
		local fnum = FilterStringToNum[f]
		if not fnum then
			local fdef = data.all[f]
			local fdataname = fdef and fdef.data_name
			if fdataname == 'items' then
				local edeftype = e.def.type
				if edeftype == 'Resource' then
					ok = f == e:GetRegisterId(FRAMEREG_GOTO)
					-- Could additionally test GetResourceHarvestItemAmount(e) against num
				elseif edeftype == 'DroppedItem' then
					ok = e:CountItem(f) > 0
				end
			elseif fdataname == 'frames' then
				ok = e.id == f
			elseif fdataname == 'components' then
				if e.def.type == 'DroppedItem' then
					ok = e:CountItem(f) > 0
				else
					ok = e.faction == bounds_entity.faction and e:FindComponent(f)
				end
			end
		elseif fnum < 10 then
			if fnum == 0 then -- v_own_faction or v_enemy_faction or v_ally_faction
				goto PREPARED_FILTER -- Handled by PrepareFilterEntity
			elseif fnum == 1 then -- v_world_faction
				-- Handled by PrepareFilterEntity, but also skip dropped items and resource nodes (faction check is to support NOT)
				local edef = e.def
				ok = e.faction.is_world_faction and edef.type ~= "DroppedItem" and edef.type ~= "Resource"
			elseif fnum == 2 then -- v_robot_faction
				ok = (e.visual_def.explorable_race or e.def.race) == "robot"
			elseif fnum == 3 then -- v_bug_faction
				ok = (e.visual_def.explorable_race or e.def.race) == "virus"
			elseif fnum == 4 then -- v_human_faction
				ok = (e.visual_def.explorable_race or e.def.race) == "human"
			elseif fnum == 5 then -- v_alien_faction
				ok = (e.visual_def.explorable_race or e.def.race) == "alien"
			elseif fnum == 6 then -- v_anomaly
				ok = (e.visual_def.explorable_race or e.def.race) == "anomaly" or e:FindComponent("c_anomaly_event")
			elseif fnum == 7 then -- v_resource
				-- Handled by PrepareFilterEntity, additionally check for specific type of dropped item
				local edef = e.def
				ok = edef.type == "Resource" or edef.name == "Scattered Resource"
			elseif fnum == 8 then -- v_is_grounded
				ok = e.def.cost_modifier ~= 0
			else --if fnum == 9 then -- v_is_flying
				ok = e.def.cost_modifier == 0
			end
		elseif fnum < 20 then
			if fnum == 10 then -- v_unsolved
				ok = e.def.is_explorable and e.faction.is_world_faction and (not e.has_extra_data or e.extra_data.solved ~= true)
			elseif fnum == 11 then -- v_solved
				ok = e.faction.is_world_faction and e.has_extra_data and e.extra_data.solved == true
			elseif fnum == 12 then -- v_can_loot
				ok = e.lootable and HasAvailableItems(e)
			elseif fnum == 13 then -- v_bot
				local edef = e.def
				ok = not edef.type and (edef.movement_speed or 0) > 0
			elseif fnum == 14 then -- v_building
				local edef = e.def
				ok = not edef.type and (edef.movement_speed or 0) <= 0
			elseif fnum == 15 then -- v_is_foundation
				-- Handled by PrepareFilterEntity, but unless using NOT, ignore any foundations with buildings on top
				if num == REG_NOT then goto PREPARED_FILTER end -- with NOT just match everything else
				local x, y = e:GetLocationXY()
				local entat = Map.GetEntityAt(x, y)
				ok = not entat or not IsBuilding(entat)
			elseif fnum == 16 then -- v_wall
				goto PREPARED_FILTER -- Handled by PrepareFilterEntity
			elseif fnum == 17 then -- v_construction
				goto PREPARED_FILTER -- Handled by PrepareFilterEntity
			elseif fnum == 18 then -- v_droppeditem
				goto PREPARED_FILTER -- Handled by PrepareFilterEntity
			else --if fnum == 19 then -- v_mineable
				goto PREPARED_FILTER -- Handled by PrepareFilterEntity
				-- Could additionally test GetResourceHarvestItemAmount(e) against num
			end
		elseif fnum < 30 then
			if fnum == 20 then -- v_damaged
				ok = e.is_damaged
			elseif fnum == 21 then -- v_infected
				ok = e.state_custom_1
			elseif fnum == 22 then -- v_unpowered
				ok = e.faction == bounds_entity.faction and e.state_unpowered
			elseif fnum == 23 then -- v_powereddown
				ok = e.faction == bounds_entity.faction and e.powered_down
			elseif fnum == 24 then -- v_in_powergrid
				ok = bounds_entity.faction:GetPowerGridIndexAt(e)
			elseif fnum == 25 then -- v_plateau
				ok = Map.GetPlateauDelta(e) >= 0
			elseif fnum == 26 then -- v_valley
				ok = Map.GetPlateauDelta(e) < 0
			elseif fnum == 27 then -- v_not_blight
				ok = Map.GetBlightnessDelta(e) < 0
			elseif fnum == 28 then -- v_blight
				ok = Map.GetBlightnessDelta(e) >= 0
			else --if fnum == 29 then -- v_is_flower
				ok = e.def.is_flower
			end
		else
			if fnum == 30 then -- v_moving
				ok = e.faction == bounds_entity.faction and e.is_moving
			elseif fnum == 31 then -- v_pathblocked
				ok = e.faction == bounds_entity.faction and e.state_path_blocked
			elseif fnum == 32 then -- v_idle
				ok = e.faction == bounds_entity.faction and e.state_idle
			elseif fnum == 33 then -- v_emergency
				ok = e.state_emergency
			elseif fnum == 34 then -- v_broken
				ok = e.state_broken
			elseif fnum == 35 then -- v_setnum
				retnum = num
				goto PREPARED_FILTER -- always matches (can't be NOT)
			else --if fnum == 36 then -- v_maxrange
				goto PREPARED_FILTER -- Handled outside (can't be NOT)
			end
		end
		if num == REG_NOT then ok = not ok end -- NOT
		if not ok then return end
		::PREPARED_FILTER::
		--print("[FilterEntity] Test " .. tostring(e) .. " (" .. (e.def.type or "UNKNOWN") .. ") @ " .. tostring(e.location):gsub("\n", ""))
		--print("[FilterEntity]   Entity matched filter!")
	end
	return true, retnum
end

function FreeplaySpawnPlayer(faction, loc)
	-- lander bot
	local lander = Map.CreateEntity(faction, "f_bot_2m_as")
	lander:AddComponent("c_deployment", "hidden")
	lander:AddComponent("c_power_cell")
	lander:AddItem("c_fabricator", 1)
	lander:AddItem("c_adv_portable_turret", 1)
	lander:Place(loc.x, loc.y)
	lander.disconnected = false

	local bots = {}
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_as")
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw")
	bots[#bots+1] = Map.CreateEntity(faction, "f_bot_1s_adw")
	local radar = bots[1]:AddComponent("c_scout_radar", 2)
	radar:SetRegister(1, { id = "v_unsolved" })

	bots[1]:Place(loc.x-2, loc.y+3)
	bots[1].disconnected = false

	bots[2]:AddComponent("c_adv_miner", 1)
	bots[2]:Place(loc.x+3, loc.y+4)
	bots[2].disconnected = false

	bots[3]:AddComponent("c_adv_miner", 1)
	bots[3]:Place(loc.x+1, loc.y+2)
	bots[3].disconnected = false

	return lander, bots
end

function FreeplaySpawnPlayerHuman(faction, loc)
	local newhome = GetPlayerFactionHomeOnGround(50)
	local x, y = newhome[1], newhome[2]
	local lander = Map.CreateEntity(faction, "f_human_lander")
	lander:AddItem("fuel_rod", 20)
	lander:Place(x - 1, y)
	local miner1 = Map.CreateEntity(faction, "f_human_adv_miner")
	miner1:Place(x + 2, y)
	local miner2 = Map.CreateEntity(faction, "f_human_adv_miner")
	miner2:Place(x + 3, y)
	local rover = Map.CreateEntity(faction, "f_human_rover")
	rover:Place(x+3, y)
	rover:AddItem("fuel_rod", 20)

	local vehicle1 = Map.CreateEntity(faction, "f_human_lighttank")
	vehicle1:AddComponent("c_light_cannon")
	vehicle1:Place(x + 2, y - 2)
	local vehicle2 = Map.CreateEntity(faction, "f_human_lighttank")
	vehicle2:AddComponent("c_light_cannon")
	vehicle2:Place(x + 3, y - 2)
	local vehicle3 = Map.CreateEntity(faction, "f_human_lighttank")
	vehicle3:AddComponent("c_light_cannon")
	vehicle3:Place(x + 4, y - 2)


	-- unlock initial human tech
	faction:Unlock("f_human_bunker")
	faction:Unlock("f_human_adv_miner")
	faction:Unlock("f_human_refinery")
	faction:Unlock("f_human_carrier")
	faction:Unlock("f_human_rover")
	faction:Unlock("f_human_lighttank")
	faction:Unlock("c_light_cannon")
	faction:Unlock("f_human_sciencelab")
	faction:Unlock("concreteslab")
	faction:Unlock("fuel_rod")
	return lander
end

function FreeplaySpawnPlayerAlien(faction, loc)
	local heart_shard = Map.CreateEntity(faction, "f_alien_heart_shard")
	heart_shard:Place(loc.x, loc.y)

	local building = Map.CreateEntity(faction, "f_alien_feeder")
	building:Place(loc.x+3, loc.y-3)

	building = Map.CreateEntity(faction, "f_alien_miner")
	building:Place(loc.x, loc.y-5)

	building = Map.CreateEntity(faction, "f_alien_miner")
	building:Place(loc.x+5, loc.y-5)

	building = Map.CreateEntity(faction, "f_alien_extractor")
	building:Place(loc.x-4, loc.y-4)

	building = Map.CreateEntity(faction, "f_alien_scout")
	building:Place(loc.x+8, loc.y)

	----- WORKERS
	local alien = Map.CreateEntity(faction, "f_alien_worker")
	alien:Place(loc.x + 6, loc.y)
	local bot = Map.CreateEntity(faction, "f_alien_worker")
	bot:Place(loc.x+3, loc.y)
	--local bot = Map.CreateEntity(faction, "f_alien_worker")
	--bot:Place(loc.x+4, loc.y-1)

	----- DEFENCE
	alien = Map.CreateEntity(faction, "f_alien_pincer")
	alien:Place(loc.x+6, loc.y-2)

	return heart_shard
end

function GetPlayerFactionHomeOnGround(undiscovered_chunk_num)
	local mapsettings = Map.GetSettings()
	local min_level, max_level = mapsettings.water_level, mapsettings.plateau_level - 0.3
	for num = (undiscovered_chunk_num or 1),15000 do
		-- get an unspawned 60x60 chunk and check 9 spots inside of it (check a 20x20 grid)
		local loc_x, loc_y = Map.GetUndiscoveredLocation(num)
		--print("FINDHOME - chunk:", num, " - loc:", loc_x..","..loc_y)
		for x = loc_x - 20, loc_x + 20, 20 do
			for y = loc_y - 20, loc_y + 20, 20 do
				local elv = Map.GetElevation(x, y)
				--print("    - tile:", x..","..y, " - elv:", elv, " - blight:", Map.GetBlightness(x, y))
				if elv > min_level and elv < max_level then
					if Map.GetBlightness(x, y) < -0.3 then
						--print("        - VALID spot:", x..","..y)
						return { x, y }
					end
				end
			end
		end
	end
	return { 0, 0 }
end

function GetRelativelySafeGround(owner, loc_x, loc_y, has_blight_shield)
	local mapsettings = Map.GetSettings()
	local water_level = mapsettings.water_level

	-- First check if we're spawning directly into danger
	if (has_blight_shield or (not has_blight_shield and Map.GetBlightness(loc_x, loc_y) < -0.3))
		and #Map.GetEntitiesInRange({x=loc_x, y=loc_y}, 10, FF_ENEMYFACTION, owner.faction) == 0 then return { x = loc_x, y = loc_y }end

	local start_loop = 1
	-- Ignore the first loop if safe to spawn in the Blight
	if has_blight_shield then start_loop = 2 end

	for ii=start_loop, 2 do
		for x = loc_x - 20, loc_x + 20, 20 do
			for y = loc_y - 20, loc_y + 20, 20 do
				local elv = Map.GetElevation(x, y)

				local valid_tile

				if ii == 1 then
					-- First loop checks for safe tiles outside the Blight
					valid_tile = elv > water_level and Map.GetBlightness(x, y) < -0.3
				else -- ii == 2 then
					-- Second loop ignores Blight, either from Blight Stablity unlocked or just that we found no safe tiles in the first loop
					valid_tile = elv > water_level
				end

				if valid_tile then
					-- Do expensive GetEntitiesInRange check last
					local result = Map.GetEntitiesInRange( { x = x, y = y }, 5, FF_ENEMYFACTION, owner.faction)
					if #result == 0 then loc_x = x loc_y = y goto finished end
				end
			end
		end
	end
	::finished::

	return { x = loc_x, y = loc_y }
end

-- helper functions
function IsBuilding(entity)      local d = entity and entity.def return d and d.type == nil and (d.movement_speed or 0) == 0 end
function IsBot(entity)           local d = entity and entity.def return d and d.type == nil and (d.movement_speed or 0) > 0 end
function IsBotOrBuilding(entity) local d = entity and entity.def return d and d.type == nil end
function IsHackable(entity)      local d = entity and entity.def return d and d.type == nil and not d.immortal and d.flags ~= "NonSelectable" end
function IsFoundation(entity)    local d = entity and entity.def return d and d.type == "Foundation" end
function IsWall(entity)          local d = entity and entity.def return d and d.type == "Wall" end
function IsDroppedItem(entity)   local d = entity and entity.def return d and d.type == "DroppedItem" end
function IsResource(entity)      local d = entity and entity.def return d and d.type == "Resource" end
function IsConstruction(entity)  local d = entity and entity.def return d and d.type == "Construction" end
function IsExplorable(entity)    local d = entity and entity.def return d and d.is_explorable and entity.faction.is_world_faction end
function IsFlyingUnit(entity)    return entity.def.cost_modifier == 0 end

function CheckDeconstruct(entity, upgrade_frame_id, allow_unknown)
	if not entity.exists                          then return "Unit/building has been destroyed" end
	if entity:FindComponent("c_deployment", true) then return "Unit has deployment functionality" end -- check first (before not buildiable)
	local d, fac = GetBuiltFrameDef(entity), entity.faction
	if not allow_unknown then
		local production_unknown = not d or not (d.construction_recipe or d.production_recipe)
		if production_unknown                     then return "No construction or production recipe available" end
		if not fac:IsUnlocked(d.id)               then return "Research required" end
	end
	local is_infected = (entity.state_custom_1 and not fac:IsUnlocked("t_robots_virus_vaccine")) or entity:FindComponent("c_virus_entity_holder")
	if is_infected                                then return "Infected" end
	if entity.is_damaged                          then return "Damaged" end
	if not entity.is_on_map                       then return "Inaccessible" end
	local ed = entity.has_extra_data and entity.extra_data
	local spawned = ed and ed.auto_destroy
	if spawned                                    then return "Unstable" end
	if not upgrade_frame_id then return end -- upgrade checks follow
	if d.type == "Foundation"                     then return "Cannot upgrade a foundation" end
	local resimulated_from = ed and ed.resimulated
	if resimulated_from                           then return "Cannot upgrade resimulated unit/building" end
	local new_d = upgrade_frame_id ~= d.id and data.frames[upgrade_frame_id]
	if not new_d then return end
	if new_d.type == "Foundation"                 then return "Cannot upgrade to a foundation" end
	local is_bot, new_is_bot = (d.movement_speed or 0) > 0, ((new_d.movement_speed or 0) > 0)
	if is_bot ~= new_is_bot                       then return "Cannot upgrade between units and buildings" end
	if not is_bot then return end -- bot only upgrade checks follow
	local new_v, recipe, new_recipe = new_d and data.visuals[new_d.visual], d.production_recipe, new_d.production_recipe
	local producers, new_producers, share_producer = recipe and recipe.producers, new_recipe and new_recipe.producers
	if producers and new_producers then for k,_ in pairs(producers) do if new_producers[k] then share_producer = true break end end end
	if (d.cost_modifier == 0) ~= (new_d.cost_modifier == 0)                  then return "Cannot upgrade between flying and grounded units" end
	if (entity.socket_count == 0) ~= (#(new_v and new_v.sockets or "") == 0) then return "Cannot upgrade between units with and without sockets" end
	if not share_producer                                                    then return "Cannot upgrade between units produced in a different place" end
end

function GetResourceHarvestItemId(entity) return entity:GetRegisterId(FRAMEREG_GOTO) end
function GetResourceHarvestItemAmount(entity) return entity:GetRegisterNum(FRAMEREG_GOTO) end
function AddResourceHarvestItemAmount(entity, amt, max) -- make sure result is > 0!!
	local num = entity:GetRegisterNum(FRAMEREG_GOTO)
	if num > 0 and num <= max then
		num = num + amt
		entity:SetRegisterNum(FRAMEREG_GOTO, num > max and max or num)
		return true
	end
end

function SumModuleBoosts(owner, id, remove_comp)
	local sum = 0
	for i=1,999 do
		local boost_comp = owner:FindComponent(id, true, i)
		if not boost_comp then break end
		if boost_comp ~= remove_comp then sum = sum + boost_comp.def.boost end
	end

	return sum
end

function HasAvailableItems(entity) for _,s in ipairs(entity.slots) do if s.unreserved_stack > 0 then return true end end return false end

function GetAnomalyFaction()
	local faction, is_new = Map.CreateFaction("anomaly")
	if is_new then
		faction:SetTrust("bugs", "NEUTRAL", true)
		faction:SetTrust("alien", "ENEMY", true)
		faction.extra_data.hack_code = math.random(1000, 9999)
		faction.has_blight_shield = true
		faction.color = { 0.0, 0.5, 1.0 }
	end
	return faction
end

function GetHumanFaction()
	local faction, is_new = Map.CreateFaction("human")
	if is_new then
		faction:SetTrust("bugs", "ENEMY", true)
		faction.extra_data.hack_code = math.random(1000, 9999)
		faction.has_blight_shield = true
		faction.color = { 1.0, 1.0, 0.0 }
	end
	return faction
end

function GetAlienFaction()
	local faction, is_new = Map.CreateFaction("alien")
	if is_new then
		faction:SetTrust("bugs", "ENEMY", true)
		faction:SetTrust("anomaly", "ENEMY", true)
		faction.extra_data.hack_code = math.random(1000, 9999)
		faction.has_blight_shield = true
		faction.color = { 1.0, 0.0, 1.0 }
	end
	return faction
end

function GetBugsFaction()
	local faction, is_new = Map.CreateFaction("bugs")
	if is_new then
		if (Map.GetSettings().peaceful or 2) > 1 then
			faction.default_trust = "ENEMY"
			faction:SetTrust("anomaly", "NEUTRAL", true)
		else
			faction:SetTrust("alien", "ENEMY", true)
			faction:SetTrust("human", "ENEMY", true)
		end
		faction.extra_data.hack_code = math.random(1000, 9999)
		faction.has_blight_shield = true
		faction.color = { 1.0, 0.0, 0.0 }
	end
	return faction
end

function GetInteractingExplorable(entity)
	local ctx = entity:GetRegisterEntity(FRAMEREG_GOTO)
	return ctx and IsExplorable(ctx) and entity:IsInRangeOf(ctx, entity.crane_range) and ctx -- ctx:IsTouching(entity)
end

function GetPlayerFactionLevel(faction)
	local difficulty_scaling = Map.GetSettings().difficulty or 1.0
	local lvl = faction.num_unlocked_techs + (faction.num_operating_entities // 30)
	return math.ceil(lvl * difficulty_scaling)
end

local bugframes = { "f_trilobyte1", "f_gastarias1", "f_trilobyte1a", "f_scaramar1", "f_trilobyte1b", "f_wasp1", "f_scaramar2", "f_gastarias2", "f_gastarid1", "f_scaramar1_egg", "f_larva1", "f_tetrapuss1", "f_tripodonte1", "f_worm1" }

function GetBugsForLevel(player_level)
	local list = { "f_trilobyte1", "f_gastarias1", }
	if player_level >= 20 then list[#list+1] = "f_scaramar1" end
	if player_level >= 28 then list[#list+1] = "f_wasp1" end
	if player_level >= 38 then list[#list+1] = "f_gastarias2"end
	if player_level >= 42 then list[#list+1] = "f_gastarid1" list[#list+1] = "f_luanops_egg" end
	if player_level >= 59 then list[#list+1] = "f_tripodonte1" end
	if player_level >= 81 then list[#list+1] = "f_worm1" end
	if player_level >= 65 then list[#list+1] = "f_larva1" end
	if player_level >= 81 then list[#list+1] = "f_tetrapuss1" end
	return list
end

function GetBugCountsForLevel(player_level, total_bugs, was_forced)
	local bug_counts = { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 } -- always at least 2 trilobyte
	for i=1,(total_bugs or 1) do
		local r = (player_level > 10 and math.random(0, player_level - 1) or 0)
		if r < 10 then     -- "f_trilobyte1"
			bug_counts[1] = bug_counts[1] + 2
		elseif r < 17 then -- "f_gastarias1"
			bug_counts[2] = bug_counts[2] + 1
		elseif r < 20 then  -- "f_trilobyte1a"
			bug_counts[3] = bug_counts[3] + 1
		elseif r < 24 then
			if was_forced and player_level > 60 and bug_counts[10] == 0 and math.random() > 0.7 then -- "f_scaramar1_egg"
				bug_counts[10] = bug_counts[10] + 1
			else -- "f_scaramar1"
				bug_counts[4] = bug_counts[4] + 1
			end
		elseif r < 28 then  -- "f_trilobyte1b"
			bug_counts[5] = bug_counts[5] + 1
		elseif r < 32 then  -- "f_wasp1"
			bug_counts[6] = bug_counts[6] + 4
		elseif r < 38 then  -- "f_scaramar2"
			bug_counts[7] = bug_counts[7] + 1
		elseif r < 41 then -- "f_gastarias2"
			bug_counts[8] = bug_counts[8] + 1
		else
			local rnd = math.random()
			if     player_level > 85 and rnd < 0.3 and r < 50 and not was_forced then -- "f_worm1"
				bug_counts[14] = bug_counts[14] + 1
			elseif player_level > 58 and rnd > 0.7 then -- "f_tripodonte1"
				bug_counts[13] = bug_counts[13] + 1
			elseif player_level > 80 and rnd > 0.5 then -- "f_tetrapuss1"
				bug_counts[12] = bug_counts[12] + 1
			elseif player_level > 64 and rnd > 0.6 then -- "f_larva1"
				bug_counts[11] = bug_counts[11] + 1
			elseif player_level > 80 and rnd < 0.15 and not was_forced then -- "f_worm1"
				bug_counts[14] = bug_counts[14] + 1
			else -- "f_gastarid1"
				bug_counts[9] = bug_counts[9] + 1
			end
		end
	end
	return bug_counts
end

function CreateBugForBugLevel(lvl, f)
	local thislevel = math.min(lvl, #bugframes)
	return Map.CreateEntity(f or GetBugsFaction(), bugframes[thislevel])
end

function GenerateRobotRewardItem(lvl)
	local level = math.min(lvl or 1, 3)
	local rnditem = {
		{
			"metalbar", "metalplate", "crystal", "cable",
			"silicon", "reinforced_plate",
		},
		{
			"energized_plate", "circuit_board", "circuit_board",
			"robot_datacube", "hdframe",
		},
		{
			"crystal_powder", "refined_crystal",
			"datacube_matrix"
		},
	}
	local index = math.random(#rnditem[level])
	return rnditem[level][index]
end

local robot_reward_comps = {
	-- 1 --
	{
		"c_behavior", "c_capacitor", "c_miner", "c_fabricator", "c_portable_relay", "c_portable_radar",
		"c_small_battery", "c_small_relay", "c_solar_cell", "c_portable_turret", "c_shared_storage",
		"c_small_storage", "c_signpost", "c_signal_reader", "c_assembler", "beacon_frame", "c_wind_turbine",
	},
	-- 2 --
	{
		"c_adv_miner",
		"c_solar_cell", "c_small_storage", "beacon_frame",
		"c_power_transmitter", "c_capacitor", "c_portable_relay",
		"c_turret", "c_repairer", "c_repairkit", "c_small_relay",
		"c_wind_turbine", "c_internal_storage", "c_robotics_factory", "c_portablecrane", "c_wind_turbine_l",
	},
	-- 3 --
	{
		"c_adv_miner",
		"c_power_transmitter", "c_capacitor", "c_power_transmitter", "c_medium_capacitor",
		"c_power_relay", "c_shield_generator", "c_solar_panel", "c_portablecrane",
		"c_turret", "c_wind_turbine_l", "c_internal_storage", "c_robotics_factory", "c_refinery",
		"c_advanced_assembler", "c_advanced_refinery", "c_crane"
	},
	-- 4 --
	{
		"c_adv_miner", "c_missile_turret", "c_power_unit", "c_advanced_assembler", "c_advanced_refinery",
		"c_alien_stealth", "c_extractor", "c_shield_generator3", "c_crane", "c_power_cell", "c_repairer_aoe",
		"c_photon_beam",
	},
}

function GenerateRobotRewardComp(lvl)
	local level = math.min(lvl or 1, #robot_reward_comps)
	local index = math.random(#robot_reward_comps[level])
	return robot_reward_comps[level][index]
end

data.damage_reduction_table = {
	-- human/bugs standard damage
	["physical_damage"] = {     -- incoming damage
		["carapace"] = 1.25,    --inc_d
		["alloy"] = 1,
		["obsidian"] = 1.25,
		["energy"] = 0.5,
		["shield"] = 0.75,      --dec_d

		--------------
	},
	-- blight/alien standard damage
	["plasma_damage"] = {       -- incoming damage
		["carapace"] = 1.25,
		["alloy"] = 1.25,
		["obsidian"] = 1,
		["energy"] = 1,
		["shield"] = 1,
		--------------
	},
	-- robot standard damage
	["energy_damage"] = {       -- incoming damage
		["carapace"] = 1,
		["alloy"] = 1,
		["obsidian"] = 0.75,
		["energy"] = 1.25,
		["shield"] = 1.25,
		--------------
	},
	["full"] = {        -- full damage type
		["carapace"] = 1,
		["alloy"] = 1,
		["obsidian"] = 1,
		["energy"] = 1,
		["shield"] = 1,
		--------------
	},
	-- specific electromagnetic damage to shields  -- (for disrupter attack)
	["electromag_damage"] = {
		["carapace"] = 0,
		["alloy"] = 0,
		["obsidian"] = 0,
		["energy"] = 0,
		["shield"] = 1,
	},
	["none"] = {},
}

data.damage_names = {
	physical_damage = "Physical",
	plasma_damage = "Plasma",
	energy_damage = "Energy",
	electromag_damage = "Electromagnetic",
}

function CalcDamageReduction(damage, shield_type, damage_type)
	local shield = shield_type or "alloy" -- default to physical shield type
	local dr = data.damage_reduction_table[damage_type or "none"][shield] or 1
	return damage*dr
end

-- Deprecated function not to be used in new code (use Tool.Copy directly)
function DeepCopy(val)
	return Tool.Copy(val)
end
