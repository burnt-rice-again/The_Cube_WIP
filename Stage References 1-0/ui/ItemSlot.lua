local ItemSlotBase_layout<const> = [[
	<Image id=bg width=56 height=56 image=item_default/>
	<Image id=image width=52 height=52 dock=top margin_top=2/>
	<Image id=lockimg image=item_lock halign=left hidden=true/>
	<Box id=numbox bg=label_left color=ui_bg dock=top-left margin_top=39 height=16 blocking=false hidden=true>
		<Text id=numtxt size=10 valign=center margin_left=2 margin_right=3 margin_bottom=1/>
	</Box>
	<Box id=resbox bg=label_right color=ui_light dock=top-right margin_right=2 margin_top=39 height=16 blocking=false hidden=true>
		<Text id=restxt size=10 valign=center color=ui_bg margin_left=3 margin_right=2 margin_bottom=1/>
	</Box>
	<Box id=cmpbox bg=component_base width=56 height=56 blocking=false hidden=true>
		<Text id=cmptxt dock=bottom x=-16 y=-2/>
	</Box>
]]

local ItemSlot_layout<const> = [[
	<Canvas margin=2 width=56 height=56 dragtype=ITEM>
		]] .. ItemSlotBase_layout .. [[
	</Canvas>
]]

local ItemSlotWithBar_layout<const> = [[
	<Canvas margin=2 width=56 height=72 dragtype=ITEM>
		<Image id=progressbg width=56 height=72 image=item_disabled/>
		]] .. ItemSlotBase_layout .. [[
		<Progress id=resspacebar width=50 height=10 dock=bottom margin_bottom=3 bg=false color=ui_dark/>
		<Progress id=progressbar width=50 height=10 dock=bottom margin_bottom=3 bg=false color=ui_light/>
		<Progress id=reservebar  width=50 height=10 dock=bottom margin_bottom=3 bg=false color=ui_light bar=progress_mask/>
	</Canvas>
]]

local function docked_progressbar_update(progressbar)
	local docked_slot = progressbar.parent.slot
	local ent = docked_slot and (docked_slot.entity or docked_slot.reserved_entity)
	if ent and ent.exists then
		progressbar.progress = ent.health / ent.max_health
	else
		progressbar.update = nil
		progressbar.color = 'ui_light'
		progressbar.opacity = 1
	end
end

local ItemSlot = {}
UI.Register("ItemSlot", ItemSlot_layout, ItemSlot)
UI.Register("ItemSlotWithBar", ItemSlotWithBar_layout, ItemSlot)

function ItemSlot:UpdateInfo()
	local slot, bg, image, progressbg = self.slot, self.bg, self.image, self.progressbg
	local id, def, num, type, reserved_stack, reserved_space, locked = slot.id, slot.def, slot.stack, slot.type, slot.reserved_stack, slot.reserved_space, slot.locked
	self.id, self.def, self.num, self.type, self.reserved_stack, self.reserved_space, self.locked = id, def, num, type, reserved_stack, reserved_space, locked
	if def == nil then
		bg.image = "item_empty"
		image.opacity = 1
		image.image = slot and data.item_slot_icons[slot.type] or "icon_inventory"

		image.color = 'ui_light'
		self.numbox.hidden = true
		self.resbox.hidden = true
		self.cmpbox.hidden = true
		if progressbg then
			progressbg.hidden = true
			self.progressbar.hidden = true
			self.resspacebar.hidden = true
			self.reservebar.hidden = true
		end
	else
		local ss = (def.stack_size or 1)

		bg.image = "item_default"
		image.image = def and def.texture or (def.attachment_size and "component_base") or false
		image.color = 'white'
		image.opacity = num == 0 and 0.3 or 1

		local hidenum = (reserved_space + reserved_stack + num == 0 and not locked) or (ss == 1 and num == ss)
		self.numbox.hidden = hidenum
		if not hidenum then
			local red_text = (reserved_space > 0) and (reserved_stack == 0) and (num == 0)
			self.numtxt.color = red_text and 'red' or 'white'
			self.numtxt.text = num
		end

		local hideres = (reserved_stack == 0)
		self.resbox.hidden = hideres
		if not hideres then
			self.restxt.text = reserved_stack
		end

		local attachment_size = def.attachment_size
		self.cmpbox.hidden = not attachment_size
		if attachment_size then
			self.cmptxt.text = NOLOC(attachment_size:sub(1, 1))
			if def.race then
				bg.image = GetComponentRaceBG(def.race)
			end
		end

		if progressbg then
			progressbg.hidden = false
			local progressbar, reservebar, resspacebar = self.progressbar, self.reservebar, self.resspacebar
			local docked_slot, ent, outside = def.data_name == 'frames' and self.slot
			if docked_slot then
				ent, outside = docked_slot.entity
				if not ent then
					ent, outside = docked_slot.reserved_entity, true
				end
			end
			if ent then
				progressbar.hidden = not ent
				progressbar.progress = ent.health / ent.max_health
				progressbar.color = 'healthbar'
				progressbar.opacity = outside and 0.5 or 1
				progressbar.update = docked_progressbar_update

				reservebar.hidden = true
				resspacebar.hidden = true
			else
				progressbar.hidden = num == 0
				progressbar.progress = (num > reserved_stack) and ((num-reserved_stack) / ss) or 0

				reservebar.hidden = reserved_stack == 0
				reservebar.progress = num / ss

				resspacebar.hidden = reserved_space == 0
				resspacebar.progress = ((num + reserved_space) / ss)
			end
		end
	end

	self.lockimg.hidden = not locked
end

function ItemSlot:tooltip()
	local slot = self.slot
	if not slot or not slot.exists then return end

	if self.def == nil then return L("No Item\n\n<hl>Type: </>%s", slot.type) end
	return BuildDefinitionTooltip(self.def, { slot = slot, entity = slot.entity or slot.reserved_entity })
end

function ItemSlot:on_drag_start()
	local slot = self.slot
	local foreign = slot.owner.faction ~= Game.GetLocalPlayerFaction()
	if not slot or not slot.exists then return false end
	if slot.id == nil then return end
	if foreign and not slot.owner.lootable then return end
	local stack = foreign and slot.stack or slot.unreserved_stack
	local dragall = not Input.IsShiftDown()
	local dragnum = dragall and stack or math.ceil((stack/2))
	if dragnum == 0 and not dragall then return end -- can still drag 0 to swap slots
	UI.PlaySound("fx_ui_ELEMENT_DRAG")
	return UI.New("Reg", { id = slot.id, icon = self.image.image, num = (not dragall or dragnum > 0) and dragnum or 0, bg = false, dragall = dragall, dragnone = dragnum == 0 })
end

function ItemSlot:on_drag_cancel(cursor, drag_was_aborted)
	if UI.IsMouseOverUI() or not self:IsValid() or drag_was_aborted then return end
	local slot, hover_entity = self.slot, View.GetHoveredEntity()
	local owner = slot.owner
	if hover_entity == owner then
		-- same entity, try equipping
		local is_comp = data.components[slot.id] ~= nil
		if not is_comp then
			Notification.Error("Item already exists on unit or building")
			return
		end
		local empty_slot = owner:GetFreeSocket(slot.id)
		if empty_slot then
			Action.SendForEntity("InvToComp", owner, { slot = slot, comp_index = empty_slot })
		else

			Notification.Error("No available socket for component")
		end
		return
	end

	-- Non docked, non placed units can't interact with anything on the map
	if not owner.exists or not owner.is_on_map then return end

	if hover_entity and not IsDroppedItem(hover_entity) then
		ActionTransfer(hover_entity, slot, cursor.dragnone and 0 or cursor.num)
	elseif IsBot(slot.entity) then
		if slot.unreserved_stack == 0 then
			Notification.Error("Cannot undock busy unit")
		else
			Action.SendForEntity("Undock", slot.entity, { moveto = not hover_entity and { View.GetHoveredTilePosition() }  })
		end
	elseif IsBot(owner) or owner.has_crane then
		if cursor.dragnone then
			Notification.Error("No items available to drop")
		else
			local x, y = View.GetHoveredTilePosition()
			Action.SendForEntity("DropItem", owner, { slot = slot, num = cursor.num, x = x, y = y })
		end
	else
		Notification.Error("Buildings cannot drop items directly")
	end
end

function ItemSlot:on_drop(payload, cursor)
	local slot, payload_slot, payload_comp = self.slot, payload.slot, payload.comp
	if not slot or not slot.exists then return end
	local entity = slot.owner

	if payload_comp and payload.dragtype == "COMPONENT" and payload_comp.exists then
		if entity ~= payload_comp.owner then
			ActionTransfer(entity, payload_comp)
		elseif slot.component == payload_comp then
			Notification.Error("Unable to store into itself")
		elseif slot:GetUnreservedSpaceFor(payload_comp.id) > 0 then
			Action.SendForEntity("CompToInv", entity, { comp = payload_comp, slot = slot })
		else
			local swap_id = slot.unreserved_stack == 1 and data.components[slot.id] and slot.id
			local deployer_ed = not swap_id and payload_comp.id == "c_deployer" and payload_comp.has_extra_data and payload_comp.extra_data
			local deployer_bp_def = deployer_ed and deployer_ed.onetime and deployer_ed.bp and data.frames[deployer_ed.bp.frame]
			if swap_id and not entity:CheckSocketSize(swap_id, payload_comp.socket_index) then
				Notification.Error("Component doesn't fit into socket")
			elseif (swap_id and (not slot.locked or slot.id == payload_comp.id)) or (deployer_bp_def and deployer_bp_def.slot_type == slot.type and slot:GetUnreservedSpaceFor(deployer_bp_def.id) == 1) then
				Action.SendForEntity("CompToInv", entity, { comp = payload_comp, slot = slot })
			else
				Notification.Error("Unable to place into full or locked item slot")
			end
		end
	elseif payload_slot and payload.dragtype == 'ITEM' and payload_slot.exists and payload_slot ~= slot then
		if entity ~= payload_slot.owner then
			if payload_slot.locked and not slot.locked and not slot.id and payload_slot.owner.faction == entity.faction then
				-- copy slot lock state onto another entity
				Action.SendForEntity("SetSlotLock", entity, { slot = slot, item_id = payload_slot.id })
				if cursor.num == 0 then return end -- set lock only
			end
			ActionTransfer(entity, payload_slot, cursor.num)
		elseif entity.faction ~= Game.GetLocalPlayerFaction() then
			Notification.Error("Unable to transfer to this unit or building") -- TODO: better message
		elseif payload_slot.type == slot.type then
			Action.SendForEntity("InvToInv", entity, { slot1 = payload_slot, slot2 = slot, num = not cursor.dragall and cursor.num })
		else
			local deployer_ed = payload_slot.id == "c_deployer" and payload_slot.has_extra_data and payload_slot.extra_data
			local deployer_bp_def = deployer_ed and deployer_ed.onetime and deployer_ed.bp and data.frames[deployer_ed.bp.frame]
			local pack_satellite = payload_slot.entity and slot.type == "storage" and payload_slot.def.flags == "Space"
			local swap_id = (pack_satellite and "c_deployer") or (deployer_bp_def and deployer_bp_def.slot_type == slot.type and deployer_bp_def.id)
			if not swap_id then
				Notification.Error("Slots are not compatible")
			elseif slot:GetUnreservedSpaceFor(swap_id) == 0 then
				Notification.Error("Unable to place into full or locked item slot")
			else
				Action.SendForEntity("InvToInv", entity, { slot1 = payload_slot, slot2 = slot, num = not cursor.dragall and cursor.num })
			end
		end
	elseif payload.ent and payload.reg_index and payload.abs_index and not payload.read_only and (slot.entity or slot.reserved_entity) then
		Action.SendForEntity("SetRegister", payload.ent, { idx = payload.abs_index, reg = { entity = (slot.entity or slot.reserved_entity) } })
	elseif payload ~= self then
		if entity.faction == Game.GetLocalPlayerFaction() and slot.id ~= payload.def_id and (not slot.id or slot.stack == 0) then
			-- Set slot locked to what the dragged source represents (i.e. a register)
			Action.SendForEntity("SetSlotLock", entity, { slot = slot, item_id = payload.def_id })
		end
		if payload.root.dragsource then payload.root.dragsource = nil end -- prevent dragged register from changing
		return false -- don't accept this generic drag, could be something unrelated
	end
end

function ItemSlot:on_clipboard_copy()
	Notification.Warning("Copied slot value")
	local slot = self.slot
	return { id = slot.id or nil, slot.entity or slot.reserved_entity or nil, num = slot.stack }, 'R'
end

function ItemSlot:on_clipboard_paste(table, prefix)
	if self.slot.owner.faction ~= Game.GetLocalPlayerFaction() then return end
	if prefix == 'R' then
		Notification.Warning("Applied slot value")
		Action.SendForEntity("SetSlotLock", self.slot.owner, { slot = self.slot, item_id = table.id })
		return true
	end
end

function ItemSlot:specific_amount()
	local slot = self.slot
	UI.MenuPopup([[<Box padding=5><HorizontalList child_align=center>
			<ItemSlotWithBar id=slot on_drag_start={slot_on_drag_start} tooltip="Drag this item to transfer" dragtype=ITEM/>
			<VerticalList>
				<InputText id=inp on_change={on_change} textalign=center/>
				<Slider id=sli width=100 min=1 step=1 on_change={on_change}/>
			</VerticalList>
		</HorizontalList></Box>]], {
		construct = function(popup)
			popup.slot.image.image = self.image.image
			popup.slot.resbox.hidden = true
		end,
		update = function(popup)
			local oldmax, newmax = popup.sli.max or 0, slot.exists and slot.unreserved_stack or 0
			if newmax == 0 then return UI.CloseMenuPopup() end
			if oldmax ~= newmax then
				popup.sli.max = newmax
				if oldmax == 0 or newmax < popup.sli.value then
					popup:on_change(nil, newmax)
					popup.inp:Focus()
				end
			end
		end,
		on_change = function(popup, _, value)
			local num = math.min(math.max(string.gsub("0"..value, "[^%d.]", "")//1|0, 1), popup.sli.max)
			if tostring(popup.inp.text) ~= tostring(num) then popup.inp.text = tostring(num) end
			if popup.sli.value ~= num then popup.sli.value = num end
			popup.slot.numtxt.text = tostring(num)
			popup.slot.progressbar.progress = (num or 0) / popup.sli.max
		end,
		on_mouse_wheel = function(popup, wheel)
			local ctrl, shift = Input.IsControlDown(), Input.IsShiftDown()
			popup:on_change(nil, popup.sli.value + (wheel > 0 and 1 or -1) * (ctrl and 10 or 1) * (shift and 5 or 1))
		end,
		slot_on_drag_start = function(popup, payload)
			-- because we close the parent widget now this callback needs to be created on the payload which continues to exist in the drag operation
			payload.on_drag_cancel = function(w, ...) self:on_drag_cancel(...) end
			payload.slot = slot
			UI.PlaySound("fx_ui_ELEMENT_DRAG")
			UI.CloseMenuPopup()
			return UI.New("Reg", { id = slot.id, icon = data.all[slot.id].texture, num = popup.sli.value, bg = false })
		end,
	})
end

function ItemSlot:on_click(button)
	local slot = self.slot
	if not slot or not slot.exists or slot.owner.faction ~= Game.GetLocalPlayerFaction() then return end

	if Input.IsControlDown() and slot.unreserved_stack > 0 then
		if data.components[slot.id] then
			-- try to equip component
			local socket = slot.owner:GetFreeSocket(slot.id)
			if socket then
				Action.SendForEntity("InvToComp", slot.owner, { slot = slot, comp_index = socket })
				UI.PlaySound("fx_ui_COMPONENT_EQUIP")
			else
				Notification.Error("No socket available to equip this component")
			end
		end
		return
	end

	if Input.IsShiftDown() then
		-- toggle slot fixed state
		Action.SendForEntity("SetSlotLock", slot.owner, { slot = slot, lock = not slot.locked })
		return
	end

	UI.MenuPopup([[<Box padding=5><VerticalList>
			<Button id=amount text="Specific Amount" on_click={on_amount}/>
			<Button id=cancel text="Cancel Orders" on_click={on_cancel}/>
			<Button id=fixthis text="Lock Slot to this Item" on_click={on_fixthis}/>
			<Button id=fixany text="Lock Slot to an Item" on_click={on_fixany}/>
			<Button id=fixempty text="Lock Empty Slot" on_click={on_fixempty}/>
			<Button id=unfix text="Unlock Slot" on_click={on_unfix}/>
			<Button id=select text="Select" on_click={on_select}/>
			<Button id=drop text="Drop Item" on_click={on_drop}/>
			<Button id=equip text="Equip Component" on_click={on_equip}/>
			<Button id=undock text="Undock" on_click={on_undock}/>
		</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
		end,
		update = function(menu)
			if not slot.exists then return UI.CloseMenuPopup() end
			local item_id, locked = slot.id, slot.locked
			local available = item_id and slot.unreserved_stack > 0
			local empty = slot.stack == 0 and slot.reserved_space == 0
			local hide_drop       = empty or (not IsBot(slot.owner) and not slot.owner.has_crane)
			local hide_equip      = not data.components[item_id] or empty
			menu.amount.hidden    = slot.stack == 0 or slot.max_stack == 1
			menu.amount.disabled  = empty or not available or slot.unreserved_stack == 1
			menu.cancel.hidden    = empty or not slot.has_order
			menu.fixthis.hidden   = not item_id or locked
			menu.fixany.hidden    = not empty
			menu.fixempty.hidden  = not empty or (locked and not item_id)
			menu.unfix.hidden     = not locked
			menu.drop.hidden      = hide_drop
			menu.drop.disabled    = hide_drop or not available
			menu.equip.hidden     = hide_equip
			menu.undock.hidden    = empty or not slot.entity or not slot.entity.has_movement
			menu.equip.disabled   = hide_equip or not available or not slot.owner:GetFreeSocket(item_id)
			menu.select.hidden    = empty or not (slot.entity or slot.reserved_entity)
		end,
		on_amount = function()
			self:specific_amount()
		end,
		on_undock = function()
			if slot.entity then
				Action.SendForEntity("Undock", slot.entity)
			end
			UI.CloseMenuPopup()
		end,
		on_cancel = function()
			Action.SendForEntity("CancelSlotOrders", slot.owner, { slot = slot })
			UI.CloseMenuPopup()
		end,
		on_fixthis = function()
			Action.SendForEntity("SetSlotLock", slot.owner, { slot = slot, lock = true })
			UI.CloseMenuPopup()
		end,
		on_fixany = function()
			local slot_type = slot.type
			UI.MenuPopup([[
					<Box bg=popup_box_bg padding=8 blur=true>
						<VerticalList child_padding=8>
							<Text text="Lock Slot to an Item" halign=center/>
							<SimpleRegisterSelection width=626 max_height=536 on_select_id={on_select} def_filter={def_filter}/>
						</VerticalList>
					</Box>
				]], {
				construct = function(menu)
					menu:TweenFromTo("sy", 0, 1, 100)
				end,
				def_filter = function(def)
					return def.slot_type == slot_type and def.attachment_size ~= "Hidden"
				end,
				on_select = function(menu, regsel, id)
					Action.SendForEntity("SetSlotLock", slot.owner, { slot = slot, item_id = id })
					UI.CloseMenuPopup()
				end,
			}, self, 'UP')
		end,
		on_fixempty = function()
			Action.SendForEntity("SetSlotLock", slot.owner, { slot = slot })
			UI.CloseMenuPopup()
		end,
		on_unfix = function()
			Action.SendForEntity("SetSlotLock", slot.owner, { slot = slot, lock = false })
			UI.CloseMenuPopup()
		end,
		on_select = function()
			View.SelectEntities(slot.entity or slot.reserved_entity)
		end,
		on_drop = function()
			Action.SendForEntity("DropItem", slot.owner, { slot = slot })
			UI.CloseMenuPopup()
		end,
		on_equip = function()
			Action.SendForEntity("InvToComp", slot.owner, { slot = slot, comp_index = slot.owner:GetFreeSocket(slot.id) })
			UI.PlaySound("fx_ui_COMPONENT_EQUIP")
			UI.CloseMenuPopup()
		end,
	}, self, 'UP')
end
