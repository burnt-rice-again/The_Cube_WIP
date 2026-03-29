function PlayerAction.PauseGame(player_id, faction, arg)
	if not Game.IsHostPlayer(player_id) then return end
	Map.SetGameSpeed(not arg.pause and 1 or 0)
end

function PlayerAction.SwitchFaction(player_id, old_faction, arg)
	if Map.GetSettings().allow_faction_switch then
		Map.SetPlayerFaction(player_id, arg.faction_id)
	end
end

function EntityAction.Deconstruct(entity)
	if not CheckDeconstruct(entity) then
		local frame_def = entity.extra_data.resimulated and data.all[entity.extra_data.resimulated] or entity.def
		local recipe = frame_def.production_recipe or frame_def.construction_recipe
		entity:Destroy(true, recipe.ingredients)
	end
end

function EntityAction.SwapSockets(entity, arg)
	entity:SwapSockets(arg.socket1, arg.socket2)
end

function EntityAction.ManualReserveItem(entity, arg)
	local slot, id, num, channel = arg.slot, arg.id, arg.num, arg.channel
	if slot then
		if slot.owner ~= entity then error("Invalid item slot") end
		slot:OrderItem(id, num, "ManualOrder", channel and (1 << (channel-1)) or nil)
	else
		entity:OrderItem(id, num, (arg.recurring and "Recurring" or "ManualOrder"), channel and (1 << (channel-1)) or nil)
	end
end

function EntityAction.CancelSlotOrders(entity, arg)
	local slot = arg.slot
	if not slot or not slot.exists or slot.owner ~= entity then return end
	slot:CancelOrders()
end

function EntityAction.Undock(entity, arg)
	if arg and arg.moveto then
		entity:MoveTo(arg.moveto)
	else
		entity:Undock()
	end
	entity:SetRegister(FRAMEREG_GOTO)
end

function EntityAction.SetSlotLock(entity, arg)
	local slot = arg.slot
	if not slot or not slot.exists or slot.owner ~= entity then return end
	if type(arg.lock) == "boolean" then
		slot.locked = arg.lock
	else
		slot:SetLockedItem(arg.item_id)
	end
end

local function SetLogisticsFlag(entity, arg)
	entity["logistics_" .. arg.flag] = arg.set
end
EntityAction.SetLogisticsFlag = SetLogisticsFlag
ConstructionAction.SetLogisticsFlagConstruction = SetLogisticsFlag

function EntityAction.ItemSlotGroup(entity, arg)
	local comp, toggle, lockto, cancel, drop, setlock = arg.comp, arg.toggle, arg.lockto, arg.cancel, arg.drop
	if arg.lock   then toggle, setlock = true, true  end
	if arg.unlock then toggle, setlock = true, false end
	for i,slot in ipairs(entity.slots) do
		if slot.component == comp or comp == false then
			if toggle then
				if setlock == nil then setlock = not slot.locked end
				slot.locked = setlock
			elseif lockto then
				slot:SetLockedItem(lockto)
			elseif cancel then
				slot:CancelOrders()
			elseif drop and slot.unreserved_stack > 0 then
				entity:DropItem(slot)
			end
		end
	end

	-- if visual register isnt set then set to item
	if lockto and entity:GetRegister(FRAMEREG_VISUAL).is_empty then
		entity:SetRegister(FRAMEREG_VISUAL, { id = lockto, num = REG_INFINITE })
	end
end

local function ActionPrepareComponentRemoval(comp, keep_slot_empty)
	if comp:PrepareRemoval(keep_slot_empty) then return true end
	Action.RunUI(function() Notification.Error("Unable to remove component while it still contains items") end)
	return false
end

function EntityAction.InvToComp(entity, arg)
	local slot, socket_index = arg.slot, arg.comp_index
	if not slot or not slot.exists then return end -- slot was destroyed

	-- check id is a component
	local comp_id = slot.id
	if entity ~= slot.owner then print("cannot equip item from another entity") return end
	if not data.components[comp_id] then print("item is not a component") return end
	if slot.unreserved_stack < 1 then print("cannot equip reserved component") return end
	if not entity:CheckSocketSize(comp_id, socket_index) then print("component doesn't fit into socket") return end

	-- check if theres a component here already
	local oldcomp, oldcompid, oldcompextra = entity:GetComponent(socket_index)

	if oldcomp then
		-- Don't allow swapping to a locked slot or a storage slot of itself. -- TODO: Find a valid slot to place the item for swap?
		if slot.component == oldcomp then print("cannot unequip component into its own slot") return end
		if slot.locked and slot.def.id ~= oldcomp.id then print("cannot unequip component into locked slot") return end
		if not ActionPrepareComponentRemoval(oldcomp) then return end
		-- store old type and destroy the component
		oldcompid = oldcomp.id
		oldcompextra = oldcomp:Destroy()
	end

	-- remove the inventory component item and add the new component
	local new_comp = entity:AddComponent(comp_id, socket_index, slot:Clear())
	if not new_comp then
		-- shouldn't be possible, if it did, should put old comp back
		return print("Failed to equip component - something went wrong...")
	end

	if oldcompid then
		-- place swapped out component into item slot
		slot:SetItemAndStack(oldcompid, 1, oldcompextra)
	end
end

function EntityAction.CompToInv(entity, arg)
	--print("transferring " .. arg.comp.id .. " to " .. (arg.slot.stack>0 and "non empty slot" or "empty slot"))
	local slot, comp = arg.slot, arg.comp
	if not slot or not comp or not slot.exists or not comp.exists then return end -- slot or component was destroyed

	local swap_id = slot.unreserved_stack == 1 and data.components[slot.id] and slot.id
	if entity ~= slot.owner or entity ~= comp.owner then print("cannot move components between entities") return end
	if (slot.stack > 0 and not swap_id) or slot.reserved_space > 0 then print("cannot unequip component into non empty slot") return end
	if slot.component == comp then print("cannot unequip component into its own slot") return end
	if slot.type ~= comp.def.slot_type then
		-- a one-time-use deployer can be dragged into a fitting docking garage slot
		local deployer_ed = not swap_id and comp.id == "c_deployer" and comp.has_extra_data and comp.extra_data
		local deployer_bp_def = deployer_ed and deployer_ed.onetime and deployer_ed.bp and data.frames[deployer_ed.bp.frame]
		if not deployer_bp_def or deployer_bp_def.slot_type ~= slot.type then
			return print("ERR: Slots are not compatible")
		elseif slot:GetUnreservedSpaceFor(deployer_bp_def.id) == 0 then
			return print("ERR: Unable to place into full or locked item slot")
		end
		local deployed_entity = CreateFrameOrBlueprint(entity.faction, deployer_ed.bp, true, nil, nil, true)
		if not deployed_entity then
			return print("ERR: Invalid blueprint")
		end
		slot.entity = deployed_entity
		comp:Destroy()
		return
	end
	if slot.locked and (slot.def == nil or slot.def.id ~= comp.id) then print("cnnot insert component into locked slot") return end
	if not ActionPrepareComponentRemoval(comp, slot) then return end
	if slot.stack > 0 and not swap_id then print("cannot unequip component into non empty slot") return end -- slot was somehow filled by ActionPrepareComponentRemoval

	if swap_id then
		if not entity:CheckSocketSize(swap_id, comp.socket_index) then return print("component doesn't fit into socket") end
		local swap_index, swap_extra = comp.socket_index, slot:Clear()
		slot:SetItemAndStack(comp.id, 1, comp:Destroy())
		entity:AddComponent(swap_id, swap_index, swap_extra)
	else
		slot:SetItemAndStack(comp.id, 1, comp:Destroy())
	end
end

function EntityAction.InvToInv(entity, arg)
	local slot1, slot2 = arg.slot1, arg.slot2
	if not slot1 or not slot2 or not slot1.exists or not slot2.exists or not slot1.id then return end -- slot already empty
	if entity ~= slot1.owner or entity ~= slot2.owner then print("cannot move item between entities") return end

	local slot1id, slot1max, slot2id, slot2type = slot1.id, slot1.max_stack, slot2.id, slot2.type

	if slot1.type ~= slot2type then
		-- can convert between a one-time-use deployer component and a docked satellite
		local deployer_ed = slot1.id == "c_deployer" and slot1.has_extra_data and slot1.extra_data
		local deployer_bp_def = deployer_ed and deployer_ed.onetime and deployer_ed.bp and data.frames[deployer_ed.bp.frame]
		local pack_satellite = slot1.entity and slot2.type == "storage" and slot1.def.flags == "Space"
		local swap_id = (pack_satellite and "c_deployer") or (deployer_bp_def and deployer_bp_def.slot_type == slot2.type and deployer_bp_def.id)
		if not swap_id then
			return print("ERR: Slots are not compatible")
		elseif slot2:GetUnreservedSpaceFor(swap_id) == 0 then
			return print("ERR: Unable to place into full or locked item slot")
		elseif deployer_ed then
			local deployed_entity = CreateFrameOrBlueprint(entity.faction, deployer_ed.bp, true, nil, nil, true)
			if not deployed_entity then
				return print("ERR: Invalid blueprint")
			end
			slot2.entity = deployed_entity
			slot1:Clear()
		else
			slot2:SetItemAndStack('c_deployer', 1, { bp = MakeBlueprintFromEntity(slot1.entity, false, true), onetime = true })
			slot1.entity:Destroy()
		end
	elseif (slot1id == slot2id and slot1max > 1) or not slot2id then
		-- both have the same item in it or the target slot is empty, move over as much as possible
		slot1:Move(slot2, arg.num)
	elseif not arg.num or arg.num >= slot1max then
		-- move everything in slot 1 was requested and second slot is empty or has a different item, swap contents
		slot1:Swap(slot2)
	else
		print("unable to combine two different item stacks")
	end
end

function EntityAction.DockedSlotTransfer(entity, arg)
	local source_slot, target = arg.source_slot, arg.target
	local source = source_slot and source_slot.exists and source_slot.owner
	if source ~= entity then return end -- invalid source
	if not target.exists then return end -- target was destroyed
	if source_slot.stack == 0 then return end -- slot was cleared
	if source.docked_garage ~= target and target.docked_garage ~= source then return end -- not docked

	target:TransferFrom(source, source_slot.id, arg.amount)
end

function FactionAction.OrderTransfer(faction, arg)
	local source_slot, target, source_component = arg.source_slot, arg.target, arg.source_component
	if source_component then
		if not source_component or not source_component.exists then return end -- component was destroyed
		if not ActionPrepareComponentRemoval(source_component) then return end
	end
	if not target.exists then return end -- target was destroyed
	if source_slot and (not source_slot.exists or source_slot.stack == 0) then return end -- slot was cleared
	local source = source_slot and source_slot.owner or source_component and source_component.owner or arg.source

	faction:OrderTransfer(source, target, source_slot or arg.item_id or source_component, arg.amount)
end

function EntityAction.DropItem(entity, arg)
	entity:DropItem(arg.slot, arg.num, arg.x, arg.y)
end

function EntityAction.DropComponent(entity, arg)
	local comp = arg.comp
	if not comp or not comp.exists then return end -- component was destroyed
	if not ActionPrepareComponentRemoval(comp) then return end
	entity:DropComponent(comp, arg.x, arg.y)
end

function EntityAction.DraggedLink(entity, arg)
	local reg_to = entity:GetRegister(arg.to)
	local reg_from = entity:GetRegister(arg.from)
	if entity:RegisterHasConnection(reg_from, reg_to) then
		entity:UnlinkRegisterFromRegister(reg_to, reg_from)
	else
		entity:LinkRegisterFromRegister(reg_to, reg_from)
	end
end

function EntityAction.SetRegister(entity, arg)
	local idx, reg, comp, force_update = arg.idx or 1, arg.reg, arg.comp
	if comp then
		if not comp.exists or comp.owner ~= entity then return end
		if idx == 1 then
			if arg.custom_blueprint and reg then
				reg.id = arg.custom_blueprint.frame
				comp.extra_data.custom_blueprint = arg.custom_blueprint
				force_update = true
			elseif comp.has_extra_data and comp.extra_data.custom_blueprint then
				comp.extra_data.custom_blueprint = nil
				force_update = true
			end
		end
		comp:SetRegister(idx, reg, force_update)
	else
		entity:SetRegister(idx, reg)
	end
end

function EntityAction.SetQueue(entity, arg)
	local idx, set_idx, remove_idx = arg.idx, arg.set_idx, arg.remove_idx
	if idx ~= -FRAMEREG_GOTO and idx ~= -FRAMEREG_STORE then return end -- currently unsupported
	if set_idx then
		entity:RegisterQueueSet(idx, arg.reg, set_idx)
	elseif remove_idx then
		entity:RegisterQueueRemove(idx, remove_idx)
	else
		local obj, toggle_idx = Tool.NewRegisterObject(arg.reg)
		if arg.toggle then for i,v in ipairs(entity:RegisterQueueGetAll(idx)) do if v == obj then toggle_idx = i break end end end
		if toggle_idx then
			entity:RegisterQueueRemove(idx, toggle_idx)
		elseif entity:RegisterIsEmpty(idx) and entity:RegisterQueueLength(idx) == 1 then
			entity:SetRegister(idx, obj)
		else
			entity:RegisterQueueInsert(idx, obj)
		end
	end
end

local function ApplyGotoOnComponents(entity, target_entity, val, skip_cancel)
	local did_set
	for _,comp in ipairs(entity.components or {}) do
		local comp_base_id, comp_id, setreg, setdocked, relevant = comp.base_id, comp.id
		if comp_base_id == "c_miner" then
			local res_id = (val and val.id) or IsResource(target_entity) and GetResourceHarvestItemId(target_entity)
			local res_def = data.all[res_id]
			local res_recipe = res_def and res_def.mining_recipe
			local can_harvest = res_recipe and res_recipe[comp.id]
			setreg, relevant = true, can_harvest
		elseif comp_base_id == "c_small_scanner" then
			setreg, relevant = true, target_entity and IsExplorable(target_entity)
		elseif comp.id == "c_repairer" or comp_base_id == "c_power_transmitter" then
			setreg, relevant = true, target_entity and target_entity.faction == entity.faction
		elseif comp_id == "c_drone_launcher" or comp_id == "c_drone_port" then
			setdocked, relevant = true, target_entity
		elseif (comp_base_id == "c_turret" or comp_base_id == "c_hacking_tool") and comp:GetRegisterId(1) ~= "v_powereddown" then
			local reg1_id = comp:GetRegisterId(1)
			if not data.frames[reg1_id] then
				setreg, relevant = true, target_entity and entity.faction:GetTrust(target_entity.faction) == 'ENEMY'
			end
		end

		if setreg and not comp:RegisterIsLink(1) then
			comp:SetRegister(1, relevant and val, not skip_cancel)
			did_set = true
		elseif setdocked then
			for _,slot in ipairs(entity.slots or {}) do
				local dockedentity = slot.entity or slot.reserved_entity
				if dockedentity then
					EntitySetGoto(dockedentity, val, not skip_cancel)
				end
			end
		end
	end
	return did_set
end

function EntitySetGoto(entity, val, skip_cancel, skip_components)
	local target_entity, did_set = val and val.entity
	if target_entity and not target_entity.exists then target_entity = nil end

	if not entity:RegisterIsLink(FRAMEREG_GOTO) then
		local relevant = target_entity and (target_entity.def.on_interact or target_entity.faction == entity.faction) or (val and val.coord)
		entity:SetRegister(FRAMEREG_GOTO, relevant and val, true)
		did_set = true
	end

	if not skip_components then
		did_set = ApplyGotoOnComponents(entity, target_entity, val, skip_cancel) or did_set
	end

	if did_set and not skip_cancel then
		entity:Cancel()
	end
end

function MapMsg.OnEntityGotoQueue(entity, val)
	if entity:RegisterQueueLength(FRAMEREG_GOTO) ~= 1 or not val.coord then
		ApplyGotoOnComponents(entity, val.entity, val, true)
	else
		EntitySetGoto(entity, nil, true) -- clear coord at end of queue
		entity:MoveTo(val.coord)
	end
end

local function DoGoto(entity, queue, x, y, target)
	if queue then
		if entity:RegisterIsLink(FRAMEREG_GOTO) then return end -- can't queue
		local queue_length, goto_empty = entity:RegisterQueueLength(FRAMEREG_GOTO), entity:RegisterIsEmpty(FRAMEREG_GOTO)
		local keep_move_goal = queue_length == 1 and goto_empty and entity.is_moving and entity.move_goal
		if queue_length > 1 or keep_move_goal or not goto_empty then
			if keep_move_goal then
				if not target and keep_move_goal.x == x and keep_move_goal.y == y then return end -- same coord
				EntitySetGoto(entity, { coord = keep_move_goal })
			end
			local newval = Tool.NewRegisterObject(target and { entity = target } or { coord = { x = x, y = y } })
			if entity:RegisterQueueGet(FRAMEREG_GOTO) == newval then return end -- already queued to go there
			entity:RegisterQueueInsert(FRAMEREG_GOTO, newval)
		else
			queue = false
		end
	end

	if not queue then
		if target then
			EntitySetGoto(entity, { entity = target })
		else
			if not entity.logistics_transport_route then EntitySetGoto(entity, nil, true) end -- clear goto
			entity:MoveTo(x, y)
		end
	end

	if not target then
		Action.RunUI(function() View.PlayEffect("fx_movehere", x, y) end)
	end
end

function FactionAction.Goto(faction, arg)
	local target, x, y, solo, group, queue = arg.target, arg.x, arg.y, arg.solo, arg.group, arg.queue
	local dx, dy, cx, cy = 0, -1, 0, 0
	for i=1,solo and 1 or #group do
		local e = solo or group[i]
		if e.exists and e.faction == faction and not e.is_construction then
			if target then
				DoGoto(e, queue, nil, nil, target)
			else
				if i > 1 then
					-- To spread out movement we spiral out from a center point
					for n=0,1 do -- Advance 2 steps to get checkerboard pattern
						if cx == cy or (cx < 0 and cx == -cy) or (cx > 0 and cx == 1 - cy) then
							dx, dy = -dy, dx -- Reached corner, turn left
						end
						cx, cy = cx + dx, cy + dy
					end
				end
				DoGoto(e, queue, x + cx, y + cy)
			end
		end
	end
	if target and target.exists then
		Action.RunUI(function() View.PlayEffect("fx_interacthere", target) end)
	end
end

function FactionAction.AttackMove(faction, arg)
	local target, x, y, solo, group = arg.target, arg.x, arg.y, arg.solo, arg.group

	-- Set attack move target or coordinate on turret components in the selection
	local last_i, dx, dy, cx, cy, have_turret = (solo and 1 or #group), 0, -1, 0, 0
	for i=1,last_i do
		local e = solo or group[i]
		if e.exists and e.faction == faction and not e.is_construction then
			local turret
			local turret_range
			for i=1,999 do
				local next_turret = e:FindComponent("c_turret", true, i)
				if not next_turret then break end
				local next_range = next_turret.def.attack_radius
				if not turret or next_range > turret_range then
					turret = next_turret
					turret_range = next_range
				end
			end
			if turret then
				if target then
					turret:SetRegisterEntity(1, target)
				elseif x then
					if i > 1 then
						-- To spread out movement we spiral out from a center point
						for n=0,1 do -- Advance 2 steps to get checkerboard pattern
							if cx == cy or (cx < 0 and cx == -cy) or (cx > 0 and cx == 1 - cy) then
								dx, dy = -dy, dx -- Reached corner, turn left
							end
							cx, cy = cx + dx, cy + dy
						end
						arg.x, arg.y = x + cx, y + cy
					end
					turret:SetRegisterCoord(1, arg)
					Action.RunUI(function() View.PlayEffect("fx_movehere", arg.x, arg.y) end)
				else
					turret:SetRegister(1, nil)
				end
				if not e:RegisterIsLink(FRAMEREG_GOTO) then
					e:SetRegister(FRAMEREG_GOTO, nil)
					e:Cancel()
				end
				if not solo then -- remember which entities have weapons for the loop below
					group[i] = false
					group[#group+1] = e
				end
				have_turret = true
			end
		elseif not solo then
			group[i] = false -- exclude invalid entity from loop below
		end
	end

	-- Show attack effect
	if not have_turret then return end
	if target and target.exists then
		Action.RunUI(function() View.PlayEffect("fx_interacthere", target) end)
	end

	-- Set non-combat units to follow the entities with turrets
	if solo then return end
	local turret_count, follower_count = #group - last_i, 0
	for i=1,last_i do
		local e = group[i]
		if e and not e:RegisterIsLink(FRAMEREG_GOTO) then
			e:SetRegister(FRAMEREG_GOTO, { entity = group[last_i + 1 + (follower_count % turret_count)] })
			e:Cancel()
			follower_count = follower_count + 1
		end
	end
end

function FactionAction.HoldPosition(faction, arg)
	local solo, group = arg.solo, arg.group
	for i=1,(solo and 1 or #group) do
		local e, didset = solo or group[i]
		if e.exists and e.faction == faction and not e.is_construction and IsBot(e) then
			-- Clear queue and goto, and stop movement on any bot
			EntitySetGoto(e, nil, true) -- clear goto
			e:Cancel() -- stop movement

			-- Activate position holding on equipped weapon components
			for j=1,999 do
				local turret = e:FindComponent("c_turret", true, j)
				if not turret then break end
				turret:SetRegisterId(1, "v_lock_locked")
				didset = true
			end
			if didset then
				Action.RunUI(function() View.PlayEffect("fx_interacthere", e) end)
			end
		end
	end
end

function FactionAction.ApplySettings(faction, arg)
	local entity, entities, bp, rotation = arg.entity, arg.entities, arg.bp, arg.rotation
	for i=1,((entity and 1) or (entities and #entities) or 0) do
		local e = entity or entities[i]
		if e.exists and e.faction == faction then
			if bp then ApplyBlueprintToEntity(e, bp) end
			if rotation and not e.def.try_rotate then e:SetVisual(e.visual_id, rotation) end
		end
	end
end

local function fill_upgrade_inventory(entity, upgrade_inventory)
	local slots = entity.slots
	if not slots then return end
	for _,slot in ipairs(slots) do
		if slot.stack > 0 then
			local slotent = slot.entity
			if slotent and slotent.def.flags == "Space" then
				upgrade_inventory[#upgrade_inventory+1] = { "c_deployer", 1, { bp = MakeBlueprintFromEntity(slotent, false, true), onetime = true } }
				fill_upgrade_inventory(slotent, upgrade_inventory)
				slotent:Destroy(false)
			elseif slotent then
				slotent:Place(entity.location, entity)
				upgrade_inventory[#upgrade_inventory+1] = slotent
			else
				upgrade_inventory[#upgrade_inventory+1] = { slot.id, slot.stack, slot.has_extra_data and slot.extra_data or nil }
			end
		end
	end
end

function FactionAction.PlaceConstruction(faction, arg)
	local upgrade, start_paused, bot_upgrade, upgrade_inventory, upgrade_error = arg.upgrade, arg.start_paused

	local function DoPlaceConstruction(frame_id, x, y, rotation, bp, bp_need_copy)
		local can_place, upgrade_buildings, dropped_items = faction:CanPlace(frame_id, x, y, rotation, true, true, upgrade, true)
		if not can_place then return end
		if bot_upgrade then upgrade_buildings = { bot_upgrade } end

		local upgrade_high_priority, upgrade_notifycompletion, upgrade_mode
		if upgrade_buildings or dropped_items then
			if not upgrade then dropped_items, upgrade_buildings = upgrade_buildings, nil end -- shift return values
			if not upgrade_inventory then upgrade_inventory = {} end
			for k in next, upgrade_inventory do upgrade_inventory[k] = nil end -- clear array

			if upgrade_buildings then
				upgrade_mode = 1 -- regular upgrade to different frame
				for _,e in ipairs(upgrade_buildings) do
					-- Make sure all upgrade buildings are still at full health
					local err = CheckDeconstruct(e, frame_id)
					if err then upgrade_error = err return end
				end
				for _,e in ipairs(upgrade_buildings) do
					-- get all items in the building recipe
					local e_def, e_components = e.def, e.components
					local recipe = e_def.construction_recipe or (bot_upgrade and e_def.production_recipe)
					local ingredients = recipe and recipe.ingredients
					if ingredients then for k,v in pairs(ingredients) do
						upgrade_inventory[#upgrade_inventory+1] = { k, v }
					end end

					-- get components
					if e_components then for _,comp in ipairs(e_components) do
						if not comp.is_hidden then
							upgrade_inventory[#upgrade_inventory+1] = { comp.id, 1, comp.has_extra_data and comp.extra_data }
						elseif comp.has_extra_data then
							upgrade_inventory[#upgrade_inventory+1] = { comp.id, false, comp.extra_data }
						end
					end end

					-- get all items in inventory
					fill_upgrade_inventory(e, upgrade_inventory)

					-- remember construction site options
					if e_def.type == "Construction" then
						if e.logistics_high_priority then upgrade_high_priority = true end
						local concomp = e:FindComponent("c_construction", true)
						if concomp and concomp.has_extra_data and concomp.extra_data.notifyoncompletion then upgrade_notifycompletion = true end
					end

					if e_def.id == frame_id then
						upgrade_mode = 2 -- simple upgrade to same frame
					end

					e:Destroy(false)
				end
			end

			if dropped_items then for _,e in ipairs(dropped_items) do
				if e.id == "f_dropped_item" then -- don't take in scattered resources
					fill_upgrade_inventory(e, upgrade_inventory)
					e:Destroy(false)
				end
			end end
		end

		local placed, comp = CreateConstructionSite(faction, frame_id, x, y, rotation, upgrade_mode)

		if start_paused then
			placed.powered_down = true
			placed:SetRegister(FRAMEREG_VISUAL, { id = "v_alert" })
		end

		if bp and BlueprintIsCustomized(bp) then -- table with just one field (frame id) does not need storing
			placed.extra_data.custom_blueprint = bp_need_copy and Tool.Copy(bp) or bp
		end

		if upgrade_buildings or dropped_items then
			for _,it in ipairs(upgrade_inventory) do
				if type(it) == "table" then -- item
					local item_def = data.all[it[1]]
					local item_slot_type, item_stack_size = item_def and item_def.slot_type or 'storage', item_def and item_def.stack_size or 1
					if it[2] == false then -- extra data of an integrated component
						if not comp.extra_data.integrated_data then comp.extra_data.integrated_data = {} end
						table.insert(comp.extra_data.integrated_data, { it[1], it[3] })
					else
						while it[2] > 0 and item_def do
							placed:AddSlots(item_slot_type):SetItemAndStack(it[1], math.min(it[2], item_stack_size), it[3])
							it[2] = it[2] - item_stack_size
						end
					end
				elseif it:RegisterIsEmpty(FRAMEREG_GOTO) then -- undocked entity
					it:SetRegisterEntity(FRAMEREG_GOTO, placed)
				end
			end

			if upgrade_buildings then for _,e in ipairs(upgrade_buildings) do
				faction:UpdateEntityInRegisters(e, placed)
				faction:RunUI("OnEntityRecreate", e, placed, true)
			end end

			if upgrade_high_priority then placed.logistics_high_priority = true end
			if upgrade_notifycompletion then comp.extra_data.notifyoncompletion = true end
		end

		return placed
	end

	local id, locations, rotation = arg.id, arg.locations, arg.rotation or 0
	local bp = not id and arg.custom_blueprint
	local frame_id, res = id or bp and bp.frame
	if frame_id then
		bot_upgrade = arg.bot_upgrade
		if bot_upgrade then
			upgrade, locations, rotation = true, { bot_upgrade.placed_location }, bot_upgrade.rotation
		end
		for i,loc in ipairs(locations) do
			res = DoPlaceConstruction(frame_id, loc.x, loc.y, rotation, bp, i < #locations)
		end
	else
		local multi = bp and bp.multi
		if not multi then return end
		for i,mbp in ipairs(multi) do
			multi[i] = { bp = mbp, frame = mbp.frame, x = mbp.x or 0, y = mbp.y or 0, rotation = mbp.rotation or 0, sizex = false, sizey = false, placed = false }
			mbp.x, mbp.y, mbp.rotation = nil, nil, nil -- not stored in construction component
			if not BlueprintIsCustomized(mbp) then multi[i].bp = nil end -- no need to store empty blueprint
		end
		BlueprintTransform(multi, rotation, nil, nil, true) -- shifts x/y to start at 0,0 and clears sizex of invalid frames
		for i,loc in ipairs(locations) do
			local loc_x, loc_y = loc.x, loc.y
			for _,m in ipairs(multi) do
				local x, y = loc_x + m.x, loc_y + m.y
				if m.sizex and faction:IsVisible(x, y, m.sizex, m.sizey, true) then
					m.placed = DoPlaceConstruction(m.frame, x, y, m.rotation or 0, m.bp, i < #locations)
				end
			end
			for _,m in ipairs(multi) do
				local m_regs = m.bp and m.placed and m.placed.extra_data.custom_blueprint.regs
				if m_regs then
					for k,reg in pairs(m_regs) do
						local reg_queue = reg.queue
						for q=0,(reg_queue and #reg_queue or 0) do
							local r = (q == 0 and reg or reg_queue[q])
							local reg_entity = r.entity
							if type(reg_entity) == "number" then
								local reg_multi = multi[reg_entity]
								r.entity = reg_multi and reg_multi.placed or nil
							end
						end
					end
				end
			end
		end
	end

	if upgrade_error then
		Action.RunUI(function() Notification.Warning(L("%s: %s", "Upgrade unavailable", upgrade_error)) end)
	end
	return res -- return value is just for calls to this functions from inside the simulation, not actual actions
end

local function Relocate_Check(faction, e, x, y, sizex, sizey)
	local old_grid_index = faction:GetPowerGridIndexAt(e)
	local power_grid_check = not old_grid_index or old_grid_index == faction:GetPowerGridIndexAt(x, y, sizex, sizey)
	power_grid_check = power_grid_check or faction:IsUnlocked("t_shuttles")
	return faction:IsVisible(x, y, sizex, sizey, true) and power_grid_check and not CheckDeconstruct(e, nil, true)
end

local function Relocate_Entity(faction, e, bp, x, y, rotation, multis)
	local frame_id, visual_or_frame_id = bp.frame, bp.visual or bp.frame
	local upgrade_can_place, upgrades = faction:CanPlace(frame_id, x, y, rotation, visual_or_frame_id, true, true, true)
	if not upgrade_can_place then return end
	if upgrades and not (#upgrades == 1 and upgrades[1] == e) then
		if not multis then return end
		for _,u in ipairs(upgrades) do local ok for _,m in ipairs(multis) do if u == m.e then ok = true break end end if not ok then return false end end
	end

	-- get all items in the building/bot recipe and inventory
	local org_location = e.placed_location
	local deployer_ed = { bp = bp, onetime = true }
	local upgrade_inventory = {{ 'c_deployer', 1, deployer_ed }}
	fill_upgrade_inventory(e, upgrade_inventory)
	e:Destroy(false)

	local newe = Map.CreateEntity(faction, "f_construction", visual_or_frame_id)
	newe.logistics_channel_2, newe.logistics_channel_3, newe.logistics_channel_4, newe.logistics_supplier = true, true, true, false
	newe:SetRegisterId(FRAMEREG_GOTO, frame_id)
	newe:SetRegisterId(FRAMEREG_VISUAL, frame_id)

	local dropped_item_frame, dropped_item_visual, dropped_item_slots = data.settings.dropped_item_frame, data.settings.dropped_item_visual, data.settings.dropped_item_slots
	local drop_entity, drop_count

	for _,it in ipairs(upgrade_inventory) do
		if type(it) == "table" then -- item
			local item_id, item_def, remain = it[1], data.all[it[1]], it[2]
			local item_slot_type, item_stack_size = item_def and item_def.slot_type or 'storage', item_def and item_def.stack_size or 1
			while remain > 0 and item_def do
				if not drop_entity then
					drop_entity, drop_count = Map.CreateEntity("world", dropped_item_frame, dropped_item_visual), 0
					drop_entity:Place(org_location)
				end

				local srcslot, amt = drop_entity:AddSlots(item_slot_type), math.min(remain, item_stack_size)
				srcslot:SetItemAndStack(item_id, amt, it[3])
				newe:AddSlots(item_slot_type):OrderItem(item_id, amt, srcslot)
				remain = remain - amt

				drop_count = drop_count + 1
				if drop_count == dropped_item_slots then drop_entity = nil end
			end
		elseif it:RegisterIsEmpty(FRAMEREG_GOTO) then -- undocked entity
			it:SetRegisterEntity(FRAMEREG_GOTO, newe)
		end
	end
	faction:UpdateEntityInRegisters(e, newe)
	faction:RunUI("OnEntityRecreate", e, newe, true)
	return newe, deployer_ed
end

local function Relocate_Finish(newe, x, y, rotation, deployer_ed)
	newe:AddComponent("c_relocation", { deployer_hash = Tool.Hash(deployer_ed) })
	newe:Place(x, y, rotation)
end

function FactionAction.Relocate(faction, arg)
	local entities, location, rotation = arg.entities, arg.location, arg.rotation
	if not entities then
		local entity = arg.entity
		local bp = not IsBot(entity) and MakeBlueprintFromEntity(entity, true, true)
		if not bp then error("failed to create blueprint from building") end
		local size, cflip = entity.visual_def.tile_size, (rotation & 1) == 1
		local x, y, sizex, sizey = location.x, location.y, size and size[cflip and 2 or 1] or 1, size and size[cflip and 1 or 2] or 1
		if not Relocate_Check(faction, entity, x, y, sizex, sizey) then return end
		local newe, deployer_ed = Relocate_Entity(faction, entity, bp, x, y, rotation)
		Relocate_Finish(newe, x, y, rotation, deployer_ed)
	else
		for i,entity in ipairs(entities) do
			local bp, loc, rot = not IsBot(entity) and MakeBlueprintFromEntity(entity, true, true), entity.placed_location, entity.rotation
			if not bp then error("failed to create blueprint from building") end
			entities[i] = { e = entity, bp = bp, frame = bp.frame, visual = bp.visual, x = loc.x, y = loc.y, rotation = rot, sizex = false, sizey = false, newe = false, deployer_ed = false }
		end
		BlueprintTransform(entities, rotation, arg.flipx, arg.flipy, true) -- shifts x/y to start at 0,0 and clears sizex of invalid frames
		for _,m in ipairs(entities) do -- Unselect entities that can't relocate
			m.x, m.y = m.x + location.x, m.y + location.y
			if not m.sizex or not Relocate_Check(faction, m.e, m.x, m.y, m.sizex, m.sizey) then m.e = false end
		end
		for _,m in ipairs(entities) do -- Create relocate drops, orders and target constructions (not yet placed)
			if m.e then m.newe, m.deployer_ed = Relocate_Entity(faction, m.e, m.bp, m.x, m.y, m.rotation or 0, entities) end
		end
		for _,m in ipairs(entities) do -- Fixup entity references, create relocation components and place target constructions
			if m.newe then
				local m_regs = m.bp.regs -- by now m.bp is same as m.deployer_ed.bp
				if m_regs then
					for k,reg in pairs(m_regs) do
						local reg_queue = reg.queue
						for q=0,(reg_queue and #reg_queue or 0) do
							local r = (q == 0 and reg or reg_queue[q])
							local reg_entity = r.entity
							if reg_entity then
								for _,n in ipairs(entities) do
									if reg_entity == n.e then
										r.entity = n.newe or nil -- this actually modifies deployer_ed
										break
									end
								end
							end
						end
					end
				end
				Relocate_Finish(m.newe, m.x, m.y, m.rotation or 0, m.deployer_ed) -- can only hash deployer_ed after entity fields are set
			end
		end
	end
end

function FactionAction.SetHomeEntity(faction, arg)
	faction.home_entity = arg.e
end

function FactionAction.RespawnPlayerFaction(faction)
	faction:Respawn()
end

function EntityAction.RotateComponent(entity, arg)
	if arg.comp.owner ~= entity then return end
	arg.comp:RotateComponent(arg.reverse and -90 or 90)
end

local function RotateFunction(entity, arg)
	local frame_def = entity.def
	local frame_def_try_rotate = frame_def.try_rotate
	if frame_def_try_rotate then
		-- special handling for walls and gates
		frame_def_try_rotate(frame_def, entity)
	else
		local visual_id, rot = entity.visual_id, entity.rotation
		if not entity:SetVisual(visual_id, (rot + (arg.reverse and 3 or 1)) % 4) then
			entity:SetVisual(visual_id, (rot + 2) % 4)
		end
	end
end
EntityAction.RotateEntity = RotateFunction
ConstructionAction.RotateEntityConstruction = RotateFunction
