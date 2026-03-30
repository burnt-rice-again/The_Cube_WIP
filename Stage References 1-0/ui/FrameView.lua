--local BOX_PADDING<const> = 10
--local BOX_MARGIN<const> = 4
--local BOX_FRAME_WIDTH<const> = 284
--local BOX_FRAMEREGS_WIDTH<const> = 260
--local BOX_BEHAVIOR_WIDTH<const> = 200
local ITEMSLOT_WIDTH<const> = 63
local REG_WIDTH<const> = 60

local FrameViewInfoBoxLayout<const> =
[[
<Box padding=4 blur=true width=260>
	<VerticalList>
		<HorizontalList child_padding=2>
			<Button id=framename on_click={on_click_framename} fill=true height=27 hidden=false textalign=left clip=true/>
			<InputText id=framename_input on_commit={on_commit_framename} fill=true height=27 textalign=left hidden=true padding=3/>
			<Button id=menubtn width=27 height=27 on_click={on_click_options} tooltip="Options" icon=icon_menu/>
		</HorizontalList>
		<Canvas height=101>
			<Image id=frame_image on_mouse_enter={hlent} on_mouse_leave={unhlent} on_click={on_click_frame_image} dock=center width=80 height=80/>
			<Canvas id=logibtns dock=bottom-right width=68 height=68 on_mouse_enter={on_actionbuttons_enter} on_mouse_leave={on_actionbuttons_leave}>
				<Button dock=top-right width=32 height=32 on_click={toggle_transfer} id=action_transport icon=icon_transport/>
				<Button dock=bottom-left width=32 height=32 on_click={toggle_power} id=action_power icon=icon_power/>
				<Button dock=bottom-right width=32 height=32 on_click={toggle_disconnected} id=action_connect icon=icon_carry/>
			</Canvas>
			<Text id=mode size=10 color=light_gray tooltip={mode_tooltip} clip=true margin=4/>
			<Wrap margin=4 margin_top=24 id=stateicons child_padding=2/>
		</Canvas>
		<Canvas id=health height=25 margin_top=4 child_fill=true tooltip={healthbar_tooltip} on_mouse_button_down={start_deconstruct} on_mouse_button_up={stop_deconstruct} on_mouse_enter={show_deconstruct} on_mouse_leave={hide_deconstruct}>
			<Image color=ui_bg/>
			<Progress id=healthbar margin=3 bg=false color=healthbar/>
			<Text id=healthnum y=-1 style=bl color=healthbar size=16 textalign=center opacity=0.8/>
		</Canvas>
		<Canvas id=battery height=25 margin_top=4 child_fill=true tooltip={powerbar_tooltip} on_mouse_enter={on_actionbuttons_enter} on_mouse_leave={on_actionbuttons_leave}>
			<Image color=ui_bg/>
			<Progress id=batterybar margin=3 bg=false color=powerbar/>
			<Text id=batterynum y=-1 style=bl color=powerbar size=16 textalign=center opacity=0.8/>
		</Canvas>
	</VerticalList>
</Box>
]]

local FrameViewLayout<const> =
[[
<Canvas>
	<HorizontalList id=bottombar dock=bottom margin_bottom=4 child_padding=4 child_align=bottom min_width=1522>
		<VerticalList id=bigbtns min_width=240 child_padding=12 child_align=right/>
		<VerticalList child_padding=4>
			<Box padding=4 id=adv1 on_mouse_enter={frameregs_mouse_enter} on_mouse_leave={frameregs_mouse_leave}>
				<HorizontalList id=frameregs child_padding=2>
					<VerticalList child_padding=2 child_fill=true height=56>
						<Button width=20 id=linkedbtn tooltip="Link Editor" icon=icon_small_arrow_up on_click={toggle_side}/>
						<Button width=20 id=movebtn tooltip="Move Interface" icon=icon_small_arrow_left on_click={toggle_leftframeview}/>
					</VerticalList>
				</HorizontalList>
			</Box>
			<FrameViewInfoBox id=infobox entity={entity}/>
		</VerticalList>
		<VerticalList id=inventories child_padding=4>
			<HorizontalList id=components/>
			<Box padding=4 blur=true id=inventorybox halign=left>
				<Box bg=tech_tree_pattern>
					<VerticalList min_width=233>
						<HorizontalList child_padding=3 child_align=center margin_bottom=8 on_click={on_click_inventory_box_icon} tooltip="<hl>Right-Click</> Inventory Context Menu">
							<HorizontalList id=inv_counts/>
							<Text text="Inventory" textalign=center fill=true/>
							<Button width=32 height=32 id=dockbtn icon=icon_small_arrow_up tooltip="Toggle Docked" on_click={toggle_side}/>
							<Button width=32 height=32 id=selectalldockedbtn icon=icon_small_cursor_area tooltip="Select All Docked Units" on_click={selectall_docked}/>
							<Button width=32 height=32 id=sendtosharedbtn icon=icon_small_inventory tooltip="Send to Shared Storage" on_click={send_to_shared}/>
							<Button width=32 height=32 id=requestbtn icon=icon_small_request tooltip="Request Item" on_click={request_items}/>
							<Button width=32 height=32 id=sortinvbtn icon=icon_small_sort tooltip="Sort Items" on_click={sort_items}/>
						</HorizontalList>
						<Wrap id=inv_list child_padding=3 min_height=72 halign=center/>
					</VerticalList>
				</Box>
			</Box>
		</VerticalList>
	</HorizontalList>
	<HorizontalList id=side dock=left margin_left=4 child_padding=4/>
	<Draw id=links fill=true/>
</Canvas>
]]

local DockedBox_Layout<const> =
[[
<Box>
	<Scale scale=0.75>
		<HorizontalList>
			<Canvas width=64 height=64 on_click={select_docked_unit}>
				<Image width=60 height=60 image={unitimg} tooltip={unittt} on_drop={docked_on_drop}/>
				<Image id=visual dock=bottom-right width=40 height=40/>
			</Canvas>
			<Progress id=hlt color=healthbar orientation=vertical width=16/>
			<VerticalList child_padding=3 child_align=center margin_bottom=8 on_click={select_docked_unit}>
				<Button width=32 height=32 on_click={toggle_docked_disconnected} id=action_docked_manual icon=icon_carry/>
				<Spacer width=10/>
			</VerticalList>
			<VerticalList id=frameregs wrapsize=166/>
			<Inventory id=inventory entity={entity}/>
		</HorizontalList>
	</Scale>
</Box>
]]

local InventoryCountIcon_Layout<const> =
[[
	<Box>
		<HorizontalList on_click={on_click_inventory_box_icon}>
			<Image width=32 height=32 image={icon}/>
			<Text id=count margin_right=8 text="0" valign=center/>
		</HorizontalList>
	</Box>
]]

-- actions
function EntityAction.ChangeName(entity, arg)
	local ed = entity.extra_data
	ed.name = arg.name
	if not next(ed) then entity.extra_data = nil end
end

function EntityAction.SetPowerDown(entity, arg)
	entity.powered_down = arg.val
end

function EntityAction.SetDisconnected(entity, arg)
	entity.disconnected = arg.val
end

function ConstructionAction.SetConstructionPause(entity, arg)
	local val, entities, faction = arg.val, arg.entities, entity.faction
	for i=1,(entities and #entities or 1) do
		local e = entities and entities[i] or entity
		if not entities or (e.exists and e.faction == faction and e.is_construction) then
			e.powered_down = val
			e:SetRegister(FRAMEREG_VISUAL, val and { id = "v_alert" } or e:GetRegister(1))
		end
	end
end

function ConstructionAction.SetConstructionPriority(entity, arg)
	local val, entities, faction = arg.val, arg.entities, entity.faction
	for i=1,(entities and #entities or 1) do
		local e = entities and entities[i] or entity
		if not entities or (e.exists and e.faction == faction and e.is_construction) then
			e.logistics_high_priority = val
		end
	end
end

function ConstructionAction.AbortConstruction(entity, arg)
	local entities, faction = (arg and arg.entities), entity.faction
	for i=1,(entities and #entities or 1) do
		local e = entities and entities[i] or entity
		if not entities or (e.exists and e.faction == faction and e.is_construction) then
			e:Destroy()
		end
	end
end

function ConstructionAction.SetSkipComponent(entity, arg)
	local id, comp = arg.id, entity:FindComponent("c_construction")
	if comp and id and not comp.is_working then
		comp.extra_data.skip = comp.extra_data.skip or {}
		comp.extra_data.skip[id] = arg.skip and true or nil
	end
end

function ConstructionAction.SetNotifyOnCompletion(entity, arg)
	local comp = entity:FindComponent("c_construction", true)
	if comp then comp.extra_data.notifyoncompletion = arg.val and true or nil end
end

function EntityAction.SortInventory(entity, arg)
	entity:AutoMergeSlots() -- merge first, then sort
	local function GetCat(def)
		if not def then return nil end
		local tag = def.tag
		if tag == "resource"             then return 9 end
		if tag == "simple_material"      then return 8 end
		if tag == "advanced_material"    then return 7 end
		if tag == "hitech_material"      then return 6 end
		if tag == "research"             then return 5 end
		local attachment_size = def.attachment_size
		if attachment_size == "Internal" then return 4 end
		if attachment_size == "Small"    then return 3 end
		if attachment_size == "Medium"   then return 2 end
		if attachment_size == "Large"    then return 1 end
		return 10
	end
	local all_slots, all_locked, slot_type, slots, cats, keys, nums, types = entity.slots or {}, true, arg and arg.slot_type, {}, {}, {}, {}, {}

	if slot_type then
		for _,v in ipairs(all_slots) do
			if v.type == slot_type and not v.locked then
				all_locked = false
				break
			end
		end
	else
		all_locked = false
	end
	for _,v in ipairs(all_slots) do
		if (not slot_type and true or (v.type == slot_type)) and v.locked == all_locked then
			local n, def = #slots+1, v.def
			slots[n], cats[n], keys[n], nums[n], types[n] = v, GetCat(def), (def and ((def.tag or "") .. def.id)), v.stack, v.type
		end
	end

	for i=1,#slots do
		local i_type, t, t_cat, t_key, t_num = types[i]
		for j=i,#slots do
			if cats[j] then -- checks if empty
				local j_cat, j_key, j_num, j_type = cats[j], keys[j], nums[j], types[j]
				if not t or j_cat > t_cat or (j_cat == t_cat and (j_key < t_key or (j_key == t_key and j_num > t_num))) then
					if j_type == i_type then
						t, t_cat, t_key, t_num = j, j_cat, j_key, j_num
					end
				end
			end
		end
		if t and i ~= t then
			slots[i]:Swap(slots[t])
			cats[i], keys[i], nums[i], types[i], cats[t], keys[t], nums[t], types[t] = cats[t], keys[t], nums[t], types[t], cats[i], keys[i], nums[i], types[i]
		end
	end
end

-- instance
local open_frame_view

local function CheckExplorableWidget(parent, explorable_entity)
	if parent.explorable_window then
		parent.explorable_window:RemoveFromParent()
		parent.explorable_window = nil
	end
	if explorable_entity then
		parent.explorable_window = parent:Add("Explorable", { entity = explorable_entity })
	end
end

function ShowLogisticsSettings(button, entity, entities)
	local have_construction
	for i=1,(entities and #entities or 1) do if (entities and entities[i] or entity).is_construction then have_construction = true break end end
	local function check(btn, on) btn.on, btn.icon = on, (on == true and "icon_small_confirm") or (on == 2 and "icon_small_durability") or nil end
	local function send(action, arg)
		if have_construction then
			local action_construction = action .. "Construction"
			for i=1,(entities and #entities or 1) do
				local e = (entities and entities[i] or entity)
				if e.is_construction then
					Action.SendForConstruction(action_construction, e, arg)
				else
					Action.SendForEntity(action, e, arg)
				end
			end
		elseif entities then
			Action.SendForEntities(action, entities, arg)
		else
			Action.SendForEntity(action, entity, arg)
		end
	end

	UI.MenuPopup([[
	<Box bg=popup_box_bg padding=4 blur=true>
		<VerticalList child_padding=4>
			<Box bg=popup_pattern padding=4>
				<Text text="Logistics Settings" style=hl textalign=center/>
			</Box>
			<Box bg=popup_additional_bg padding=8 id=transportbox>
				<VerticalList child_padding=4 id=list2/>
			</Box>
			<Box bg=popup_additional_bg padding=8>
				<VerticalList child_padding=4>
					<HorizontalList child_padding=8 id=connectbox><Text fill=true text="Connect to Logistics Network" on_click={connect}/><Button width=24 height=24 id=togglebtn on_click={connect}/></HorizontalList>
					<Box margin=4 padding=6 id=logisticsbox>
						<VerticalList child_padding=4 id=list/>
					</Box>
				</VerticalList>
			</Box>
		</VerticalList>
	</Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			local list, list2, btns = menu.list, menu.list2, {}
			menu.btns = btns

			for _,v in ipairs(data.logistics_flags) do
				local flag = v.flag
				if flag then
					local hl = (flag == "transport_route" and list2 or list):Add("<HorizontalList child_padding=8><Text fill=true on_click={toggle}/><Button width=24 height=24 id=togglebtn on_click={toggle}/></HorizontalList>")
					hl.flag, hl.tooltip, hl[1].text = flag, v.tooltip, v.label
					btns[flag] =  hl[2]
				else
					list:Add("Spacer", { height= 10 })
				end
			end

			local can_carry = IsBot(entity) or entity.has_crane
			if not can_carry then btns.can_construction.parent.hidden = true end

			for i=2,(entities and #entities or 0) do
				if can_carry ~= (IsBot(entities[i]) or entities[i].has_crane) then can_carry = 2 break end
			end
			if not can_carry then btns.carrier.parent.hidden, menu.transportbox.hidden = true, true end
			if can_carry == 2 then btns.carrier.parent.disabled, menu.transportbox.disabled = true, true end

			if have_construction then
				for i,hl in ipairs(list) do if hl.flag == "high_priority" then break else hl.hidden = true end end -- hide up until high priority
				menu.connectbox.hidden = true
			end

			list:Add('<Button text="Reset Settings" on_click={reset}/>')
		end,
		connect = function(menu, btn)
			send("SetDisconnected", { val = not not btn.on })
		end,
		toggle = function(menu, hl, btn)
			local newval, flag = not btn.on, hl.flag
			if newval then
				if flag == "transport_route" and menu.togglebtn.on then
					send("SetDisconnected", { val = true })
				end
				if flag == "crane_only" then
					if IsBuilding(entity) and not entity.has_crane then
						Notification.Warning("Building does not have an Item Transporter equipped")
					end
				end
			end

			send("SetLogisticsFlag", { flag = flag, set = newval })
		end,
		reset = function(menu)
			for _,v in ipairs(data.logistics_flags) do
				if v.flag then
					if v.flag ~= "transport_route" and menu.btns[v.flag].on ~= v.default then
						send("SetLogisticsFlag", { flag = v.flag, set = v.default })
					end
				end
			end
		end,
		update = function(menu)
			local val = not entity.disconnected
			for i=2,(entities and #entities or 0) do
				if entities[i].disconnected == val then val = 2 break end
			end
			menu.togglebtn.active = val == true
			check(menu.togglebtn, val)
			menu.logisticsbox.opacity = val and 1 or 0.5

			for flag,btn in pairs(menu.btns) do
				local logistics_flag = "logistics_" .. flag
				local val = entity[logistics_flag]
				for i=2,(entities and #entities or 0) do
					if entities[i][logistics_flag] ~= val then val = 2 break end
				end
				check(btn, val)
				btn.active = val == true and flag == "transport_route"
			end
		end,
	}, button, "UP")
end

local FrameViewInfoBox = {}
UI.Register("FrameViewInfoBox", FrameViewInfoBoxLayout, FrameViewInfoBox)
function FrameViewInfoBox:construct()
	local entity = self.entity
	local construction = entity.is_construction
	local foreign = (entity.faction ~= Game.GetLocalPlayerFaction())
	if foreign then self.foreign = true end

	self.menubtn.hidden = foreign
	self.logibtns.hidden = foreign
	self.framename.disabled = construction or foreign

	-- set frame Image
	local frame_def = GetBuiltFrameDef(entity) or entity.def
	self.frame_image.image = frame_def.texture
	self.frame_image.tooltip = DefinitionTooltip(frame_def, { entity = entity })

	if foreign or construction then self.show_deconstruct = nil end
end

function FrameViewInfoBox:update(first_update, force_update)
	local entity, foreign = self.entity, self.foreign

	-- Frame Name
	self.framename.text = GetEntityName(entity)
	self.healthnum.text = self.deconstruct_text or string.format("%d", entity.health)
	self.healthbar.progress = self.deconstruct_timer or (entity.health / entity.max_health)
	self:powerbar_refresh()

	if not foreign then
		-- Update mode text
		local mode, queue_length = entity.idle_mode, entity:RegisterQueueLength(FRAMEREG_GOTO)
		local idlehash, modetxt = Tool.Hash(mode, queue_length)
		if self.idlehash ~= idlehash then
			self.idlehash = idlehash
			if mode == "IDLE" or mode == nil then
				local def = entity.def
				if (def.movement_speed or 0) > 0 then modetxt = "Idle"
				elseif def.type                  then modetxt = def.name
				else                                  modetxt = "Building"
				end
			elseif mode == "STORE"     then modetxt = (entity.logistics_transport_route and "Transport Route" or "Store Inventory")
			elseif mode == "MOVE"      then modetxt = "Moving"
			elseif mode == "RETURN"    then modetxt = "Returning Home"
			elseif mode == "COMPONENT" then modetxt = "Controlled by Component"
			elseif mode == "DROP"      then modetxt = "Dropping item"
			elseif mode == "ORDER"     then
				local active_order = entity.active_order
				modetxt = not active_order and "" or (active_order.target_entity ~= entity
					and L("Order Delivery to %s", GetEntityName(active_order.target_entity))
					or L("Order Pickup from %s", GetEntityName(active_order.source_entity)))
			elseif mode == "INTERACT"  then
				local goto_entity = entity:GetRegisterEntity(FRAMEREG_GOTO)
				if goto_entity and goto_entity.exists then
					modetxt = L(entity.is_moving and "Moving to %s" or "Interacting with %s", GetEntityName(goto_entity))
				end
			end
			if queue_length and queue_length > 1 then
				modetxt = L("[%s:%d] %s", "Queue", queue_length, modetxt or "Moving")
			end
			self.mode.text = modetxt or ""
		end

		-- update state icons
		local all_states = entity.all_states
		local allstateshash = Tool.Hash(all_states)
		if allstateshash ~= self.allstateshash then
			local stateicons = self.stateicons
			self.allstateshash = allstateshash
			stateicons:Clear()
			for i,v in ipairs(entity.all_states) do
				local tip, order = data.state_names[v], (v == "StaleOrder")
				stateicons:Add("<Image width=25 height=25/>", {
					image = data.state_icons[v], tooltip = order and L("%s (%s)", tip, "Click for more details") or tip,
					on_click = order and function() OpenMainWindow("Faction", { show_entity_orders = true }) end,
				})
			end
			stateicons.width = 27 * ((#stateicons + 2) // 3) -- use 2 columns if more than 3 states
		end
	else
		self.mode.text = entity.faction.name
	end
	if self.last_power ~= entity.powered_down then
		self.last_power = entity.powered_down
		self.action_power.active = not entity.powered_down
		self.action_power.tooltip = L('%s <hl>Ctrl-</><Key action="QuickAction" style="hl"/>\n\nPowered down units and buildings stop functioning and\ndo not consume power.', entity.powered_down and "Power On" or "Shutdown")
		self.action_power.hidden = entity.component_count == 0 and self.powerhash == 0 and not entity.powered_down
	end

	if self.last_manual ~= entity.disconnected then
		self.last_manual = entity.disconnected
		self.action_connect.active = not entity.disconnected
		self.action_connect.tooltip = L('%s (Logistics Network)<hl>Shift-</><Key action="QuickAction" style="hl"/>\n\nUnits and buildings connected to the logistics network will\nautomatically deliver requested items and\nmake their own inventory items available to\nthe network', entity.disconnected and "Connect" or "Disconnect")
		self.action_connect.hidden = entity.slot_count == 0 and not entity.is_construction
	end

	if self.last_transport ~= entity.logistics_transport_route then
		self.last_transport = entity.logistics_transport_route
		self.action_transport.active = entity.logistics_transport_route
		self.action_transport.tooltip = L('%s (Transport Route)\n\nCarry items from the Goto sources to the Store targets', entity.logistics_transport_route and "Transferring" or "Not Transferring")
		self.action_transport.hidden = not entity.def.movement_speed and not entity.has_crane
	end
end

function FrameViewInfoBox:hlent()
	View.HighlightEntity(self.entity)
end

function FrameViewInfoBox:unhlent()
	View.HighlightEntity(nil)
end

function FrameViewInfoBox:on_click_options(w, btn)
	if self.foreign then return end
	Frameview_OpenContextMenu(self.entity, w)
end

function FrameViewInfoBox:on_click_frame_image(w, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" and not self.foreign then
		Frameview_OpenContextMenu(self.entity, w)
	else
		View.JumpCameraToEntities(self.entity)
	end
end

function FrameViewInfoBox:on_clipboard_copy()
	return UnitCopyPaste.ClipboardCopyReference(self.entity)
end

function FrameViewInfoBox:on_drop(payload, visual)
	if not payload.ent or not payload.reg_index or not payload.abs_index or payload.read_only then return false end
	payload:SendSet({ entity = self.entity })
end

function FrameViewInfoBox:on_click_framename()
	-- For editing, we use the raw name string which means localizing the definition name with L and then treating it as a raw string with NOLOC
	local entity = self.entity
	local extraname, defname = entity.has_extra_data and entity.extra_data.name, NOLOC(L(entity.visual_def.explorable_name or entity.def.name or ""))
	self.framename.hidden = true
	self.framename_input.text = (extraname or defname)
	self.framename_input.hidden = false
	self.framename_input:Focus()
end

function FrameViewInfoBox:on_commit_framename(input, newname)
	local entity = self.entity
	local oldname, defname = NOLOC(L(self.framename.text or "")), NOLOC(L(entity.visual_def.explorable_name or entity.def.name or ""))
	local was_custom_name = oldname ~= "" and oldname ~= defname
	local is_custom_name = newname ~= "" and newname ~= defname
	if (was_custom_name and oldname) ~= (is_custom_name and newname) then
		Action.SendForEntity("ChangeName", entity, { name = is_custom_name and newname or nil } )
	end

	self.framename_input.hidden = true
	self.framename.text = is_custom_name and NOLOC(newname) or entity.visual_def.explorable_name or entity.def.name
	self.framename.hidden = false
	input:Unfocus()
end

function FrameViewInfoBox:mode_tooltip()
	local entity = self.entity
	local reg_detail = '<HorizontalList child_align=center><Text text={text} width=150/><Reg entity={entity} def_id={def_id} num={num} width=48 height=48/></HorizontalList>'
	local text_detail = '<Text halign=center color=light_gray/>'
	return UI.New("<Box bg=popup_box_bg padding=12 blur=true><VerticalList child_padding=4><Text id=mode color=title halign=center/><VerticalList id=details child_padding=4/></VerticalList></Box>", {
		update = function(w)
			local mode, disconnected, active_order, controlling_component, goto_entity, store_entity = entity.idle_mode, entity.disconnected, entity.active_order, entity.controlling_component, entity:GetRegisterEntity(FRAMEREG_GOTO), entity:GetRegisterEntity(FRAMEREG_STORE)
			local queue = entity:HaveRegisterQueue(FRAMEREG_GOTO) and entity:RegisterQueueGetAll(FRAMEREG_GOTO)
			local hash = Tool.Hash(mode, disconnected, active_order, controlling_component, goto_entity, store_entity, queue)
			if w.hash == hash then return end
			w.hash = hash
			w.hidden = mode == "IDLE"
			w.details:Clear()
			if mode == "STORE" then
				w.mode.text = "Storing Inventory"
				if store_entity and store_entity.exists then w.details:Add(reg_detail, { text = "Store:", entity = store_entity }) end
			elseif mode == "MOVE" then
				w.mode.text = "Moving"
				-- print(w.details:Add(text_detail, { text = "Moving to designated location" }))
			elseif mode == "RETURN" then
				w.mode.text = "Returning Home"
			elseif mode == "COMPONENT" then
				w.mode.text = "Controlled by Component"
				w.details:Add(reg_detail, { text = "Component:", def_id = controlling_component.id })
			elseif mode == "DROP" then
				w.mode.text = "Dropping item"
			elseif mode == "ORDER" then
				w.mode.text = "Order Delivery"
				w.details:Add(text_detail, { text = (active_order.source_entity and "Picking up item from source" or "Dropping off item at target") })
				w.details:Add(reg_detail, { text = "Item:", def_id = active_order.item_id, num = active_order.amount })
				if active_order.source_entity then w.details:Add(reg_detail, { text = "Source:", entity = active_order.source_entity }) end
				if active_order.target_entity then w.details:Add(reg_detail, { text = "Target:", entity = active_order.target_entity }) end
			elseif mode == "INTERACT" then
				w.mode.text = goto_entity and goto_entity.exists and L(entity.is_moving and "Moving to %s" or "Interacting with %s", GetEntityName(goto_entity)) or ""
				w.details:Add(reg_detail, { text = "Goto:", entity = goto_entity })
			end
			if queue and #queue > 0 then
				if mode == "IDLE" then
					w.mode.text = "Moving"
					w.hidden = false
				end
				w.details:Add("<Image height=2 color=ui_light margin=8/>")
				w.details:Add(text_detail, { text = "Action Queue:" })
				for _,q in ipairs(queue) do
					if q.entity then
						w.details:Add(reg_detail, { text = "Goto:", entity = q.entity })
					elseif q.coord then
						w.details:Add(reg_detail, { text = "Move:", num = q.coord.x .. "\n" .. q.coord.y })
					end
				end
			end
			w.hidden = #w.details == 0
		end,
	})
end

function FrameViewInfoBox:show_deconstruct()
	self.deconstruct_err = CheckDeconstruct(self.entity)
	if self.deconstruct_err then return end
	self.healthnum.text, self.deconstruct_text = "DECONSTRUCT", "DECONSTRUCT"
end

function FrameViewInfoBox:hide_deconstruct()
	if not self.deconstruct_text or not self.entity.exists then return end
	self.healthnum.text, self.deconstruct_text = string.format("%d", self.entity.health), nil
	self:stop_deconstruct()
end

function FrameViewInfoBox:start_deconstruct()
	if not self.deconstruct_text or self.entity.is_damaged then return end
	self.deconstruct_timer = 0.0
	self.healthnum.color, self.healthbar.color, self.healthbar.every_frame_update = "red", "red", function(healthbar, dt)
		self.deconstruct_timer = self.deconstruct_timer + (dt * 0.5)
		healthbar.progress = self.deconstruct_timer
		if self.entity.is_damaged then
			self:stop_deconstruct()
		elseif self.deconstruct_timer >= 1.0 then
			Action.SendForEntity("Deconstruct", self.entity)
			healthbar.every_frame_update = nil
		end
	end
end

function FrameViewInfoBox:stop_deconstruct()
	if not self.healthbar.every_frame_update or not self.entity.exists then return end
	self.healthnum.color, self.healthbar.color, self.healthbar.progress, self.healthbar.every_frame_update = "healthbar", "healthbar", (self.entity.health / self.entity.max_health), nil
	self.deconstruct_timer = nil
end

function FrameViewInfoBox:healthbar_tooltip()
	local entity = self.entity
	return UI.New("<Box bg=popup_box_bg padding=12 blur=true><Text text={txt}/></Box>", { update = function(w)
		if not entity.exists then return end
		local deconstruct_err = self.deconstruct_err
		w.txt = L("%s: %d/%d%s", "Health", entity.health, entity.max_health,
			deconstruct_err and L("\n%s: %s", "Deconstruction unavailable", deconstruct_err) or "")
	end })
end

function FrameViewInfoBox:powerbar_tooltip()
	local tooltip = UI.New("<Box bg=popup_box_bg padding=12 blur=true><VerticalList width=320 child_padding=4/></Box>", { destruct = function() self.powerbar_tooltip_list = nil end })
	self.powerbar_tooltip_list = tooltip[1]
	self:powerbar_refresh(true)
	return tooltip
end

function FrameViewInfoBox:powerbar_refresh(force_refresh)
	local entity, tooltip_list = self.entity, self.powerbar_tooltip_list
	local powered_down, battery_stored, battery_total, details = entity.powered_down, entity.battery_stored, entity.battery_total

	details = entity.power_details
	if not details then
		details = { grid_index = entity.power_grid_index, produced = 0, received = 0, required = 0, consumed = 0 }
	end
	if tooltip_list and not powered_down then
		for _,comp in ipairs(entity.components or {}) do
			local comp_details = comp.power_details
			if comp_details then
				table.insert(details, comp)
				table.insert(details, comp_details)
			end
		end
		details.grid = details.grid_index and entity.faction:GetPowerGrid(details.grid_index)
	end

	local efficiency = details and details.efficiency or entity.efficiency
	local hash = Tool.Hash(efficiency, powered_down, battery_stored, battery_total, details)
	if hash == self.powerhash and not force_refresh then return end
	self.powerhash = hash

	local batterycolor = (powered_down and "red" or (efficiency and ((efficiency < 20) and "red" or (efficiency < 100 and "yellow"))))
	self.batterybar.color = batterycolor or "powerbar"
	self.batterynum.color = batterycolor or "powerbar"
	if battery_total > 0 then
		self.batterybar.progress = battery_stored / battery_total
		self.batterynum.text = string.format("%d", battery_stored)
	elseif powered_down then
		self.batterybar.progress, self.batterynum.text = 0, "Powered Down"
	elseif efficiency and efficiency ~= 100 then
		self.batterybar.progress, self.batterynum.text = 0, (efficiency == 0 and "Unpowered" or L("Efficiency at %d%%", efficiency))
	elseif (details and not details.grid_index) or (not details and not entity.power_grid_index) then
		self.batterybar.progress, self.batterynum.text = 0, "Not In Power Grid"
	else
		self.batterybar.progress, self.batterynum.text = efficiency and 1 or 0, efficiency and "Powered" or "No Power Used"
	end

	if not tooltip_list then return end
	tooltip_list:Clear()
	local function add_entry(list, title, val)
		list:Add("<Canvas><Text text={title}/><Text text={val} color=title halign=right/></Canvas>", { title = title, val = val })
	end

	if powered_down then
		tooltip_list:Add("<Text text='Powered Down' textalign=center color=red/>")
		return
	end

	-- Add per component power details
	local total_change = 0
	for i=1,#details,2 do
		local comp, comp_def, comp_details = details[i], details[i].def, details[i+1]
		if tooltip_list then
			local sublist = tooltip_list:Add('<HorizontalList child_padding=4><Reg def={def} bg=item_default valign=center/><VerticalList id=sublist fill=true valign=center/></HorizontalList>', { def = comp_def }).sublist
			if comp_details.power > 0 then
				add_entry(sublist, "Producing", string.format("%d", comp_details.power*TICKS_PER_SECOND))
			elseif comp_details.power < 0 then
				add_entry(sublist, "Requiring", string.format("%d", (comp_details.is_active and -comp_details.power*TICKS_PER_SECOND or 0)))
				local boost = comp_details.boost or 100
				if comp_def.uplink_rate then boost = boost + (1 / comp_def.uplink_rate) * 100 end
				if boost ~= 100 then add_entry(sublist, boost > 100 and "Overclocked" or "Underclocked", string.format("%d%%", boost)) end
				add_entry(sublist, "Active", comp_details.is_active and "Yes" or "No")
			elseif comp_def.adjust_extra_power then
				add_entry(sublist, "Active", "No")
			end
			if (comp_details.stored > 0 and comp_def.power_storage) or comp_details.change ~= 0 or comp_def.power_storage then
				add_entry(sublist, "Stored", string.format((comp_details.change ~= 0 and "%d/%d (%+.0f)" or "%d/%d"), comp_details.stored, comp_def.power_storage, comp_details.change*TICKS_PER_SECOND))
				total_change = total_change + comp_details.change
			end
			if comp_details.transmitted > 0 then
				add_entry(sublist, "Transmitting", string.format("%d", comp_details.transmitted*TICKS_PER_SECOND))
			end
			local comp_target = comp_details.target
			if comp_target and comp_target.exists then
				add_entry(sublist, "Target", GetEntityName(comp_target) or "Frame")
				if comp_details.transmitted < comp_def.bandwidth and comp_target.is_placed then
					local target_grid_index = comp_target.power_grid_index or comp_target.faction:GetPowerGridIndexAt(comp_target)
					local target_grid = target_grid_index and comp_target.faction:GetPowerGrid(target_grid_index)
					if target_grid and target_grid.efficiency < 100 then
						add_entry(sublist, "Insufficient power for transmission", "")
					end
				end
			end
			if comp_details.transfer_radius > 0 then
				add_entry(sublist, "Transfer Radius", string.format("%d", comp_details.transfer_radius))
			end
			if #sublist == 0 then
				add_entry(sublist, "Active", "No")
			end
		end
	end

	-- Add overall frame power details
	if details.produced > 0 then
		add_entry(tooltip_list, "Producing", string.format("%d", details.produced*TICKS_PER_SECOND))
	end
	if details.received > 0 then
		add_entry(tooltip_list, "Receiving", string.format("%d", details.received*TICKS_PER_SECOND))
	end
	if details.required > 0 then
		add_entry(tooltip_list, "Requiring", string.format("%d", details.required*TICKS_PER_SECOND))
	end
	if efficiency then
		add_entry(tooltip_list, "Efficiency", string.format("%d%%", efficiency))
	end
	if details.consumed > 0 then
		add_entry(tooltip_list, "Consuming", string.format("%d", details.consumed*TICKS_PER_SECOND))
	end

	local grid = details.grid
	if grid then
		if #tooltip_list > 0 then tooltip_list:Add('<Image height=2 color=ui_light margin_top=12/>') end
		tooltip_list:Add('<Text text="Local Power Grid Stats:" color=ui_light margin_top=6/>')
		if grid.total > 0 then
			add_entry(tooltip_list, "Generated", string.format("+%d", grid.total*TICKS_PER_SECOND))
		end
		if grid.received > 0 then
			add_entry(tooltip_list, "Received",  string.format("+%d", grid.received*TICKS_PER_SECOND))
		end
		if grid.load > 0 then
			add_entry(tooltip_list, "Load",      string.format("-%d", grid.load*TICKS_PER_SECOND))
		end
		local charge_or_transmit = grid.available - grid.load - grid.unused
		if charge_or_transmit > 0 then
			add_entry(tooltip_list, "Batteries/Transmitters", string.format("-%d", charge_or_transmit*TICKS_PER_SECOND))
		end
		if grid.unused > 0 then
			add_entry(tooltip_list, "Unused",    string.format("%d", grid.unused*TICKS_PER_SECOND))
		end
		add_entry(tooltip_list, "Efficiency",    string.format("%d%%", grid.efficiency))
	end

	if details.grid_index then
		tooltip_list:Add("<Text text='In Power Grid' color=yellow halign=center/>")
	else
		tooltip_list:Add("<Text text='Not In Power Grid' color=red halign=center/>")
	end
end

-------------------------------------------- regular frame view
local show_visibility_range, show_power_range
local FrameView = { }
UI.Register("Frameview", FrameViewLayout, FrameView)

function FrameView:construct()
	local interface_settings = Game.GetProfile().interface_settings
	if interface_settings and interface_settings.leftframeview then
		self.leftframeview = true
		self.movebtn.icon = 'icon_small_arrow_right'
		self.bottombar.dock = 'bottom-left'
		self.bottombar.margin_left = 4
		self.bigbtns.child_index = self.inventories.child_index -- swap to right
	end

	local entity = self.entity
	self.foreign = entity.faction ~= Game.GetLocalPlayerFaction()

	-- add component socket blocks to reg panel
	for i,v in ipairs(entity.visual_def.sockets or {}) do
		self.components:Add("ComponentColumn", { entity = entity, socket = i, socket_size = v[2]}) --, hidden = not entity:GetComponent(i) })
	end

	self.regs = {}
	if entity.register_count > 0 then
		-- add frame registers to reg panel
		for i,v in ReverseIPairs(data.frame_regs) do
			self.regs[i] = self.frameregs:Add("<Reg on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_drag_complete={link_on_drag_complete} on_drop={link_on_drop}/>", {
				ent = entity,
				reg_index = i,
				empty_tooltip = v.tooltip,
				no_modify = self.foreign,
				ui_icon = v.bg,
			})
		end
	else
		-- hide frame registers and logistics buttons on wall entities
		self.frameregs.parent.hidden = true
		self.infobox.logibtns.hidden = true
	end

	self:toggle_side(nil, nil, true)
end

function FrameView:destruct()
	self:UpdateEffects(true)
end

function FrameView:toggle_side(btn, mousebtn, load_profile)
	if self.foreign then return end

	local profile = Game.GetProfile()
	local linkedbtn, dockbtn, leftframeview = self.linkedbtn, self.dockbtn, self.leftframeview
	local offer_linkeditor = self.entity.register_count ~= 0

	if not load_profile then
		if btn == linkedbtn then
			if not offer_linkeditor then return end
			local newval = linkedbtn.icon == "icon_small_arrow_up" or not self.link_editor or nil
			profile.adv_view = newval
		end
		if btn == dockbtn then
			local newval = dockbtn.icon == "icon_small_arrow_up" or not self.dock_boxes or nil
			profile.docked_ui = newval
		end
	end

	local side, show_link_editor, show_dock_boxes = self.side, profile.adv_view and offer_linkeditor, profile.docked_ui
	side:Clear()
	self.link_editor = show_link_editor and side:Add('<LinkEditor entity={entity} compact={leftframeview} valign=center/>') or nil
	self.dock_boxes = show_dock_boxes and side:Add('<VerticalList child_padding=4 child_align=left valign=center/>') or nil

	linkedbtn.icon = profile.adv_view and "icon_small_arrow_down" or "icon_small_arrow_up"
	dockbtn.icon = profile.docked_ui and "icon_small_arrow_down" or "icon_small_arrow_up"

	if leftframeview then
		for i,w in ipairs(self.frameregs) do w.hidden = show_link_editor and i > 1 end
		side.dock, side.margin_bottom = 'bottom-left', show_link_editor and 206 or 318
		if show_link_editor and show_dock_boxes then side[1].valign, side[2].valign, side[2].margin_left, side[2].margin_bottom = "bottom", "bottom", 4, 107 end
	end

	if load_profile then return end
	self:update(false)
	if offer_linkeditor then self.links.on_draw = function(draw) self:UpdateLinks(draw) end end
end

function FrameView:toggle_leftframeview()
	local profile = Game.GetProfile()
	local interface_settings = profile.interface_settings
	if not interface_settings then interface_settings = {} end
	interface_settings.leftframeview = not interface_settings.leftframeview or nil
	profile.interface_settings = EmptyTableAsNil(interface_settings)

	local entities = View.GetSelectedEntities()
	View.SelectEntities({})
	View.SelectEntities(entities)
end

function FrameView:update(first_update, force_update)
	local entity, foreign = self.entity, self.foreign
	if not entity.exists then
		-- close the Window
		self:RemoveFromParent()
		open_frame_view = nil
		return
	end

	if force_update then
		local new_regs = {}
		for i=1,#data.frame_regs do
			new_regs[i] = self.regs[i]
		end
		self.regs = new_regs
	end

	if not foreign then
		-- show/hide explorable window
		local explorable_entity = GetInteractingExplorable(entity)
		if explorable_entity ~= self.explorable_entity then
			self.explorable_entity = explorable_entity
			CheckExplorableWidget(self, explorable_entity)
		end
	end

	-- add blocks for hidden components (including ones added after the frameview was already open)
	local hiddencomps, hiddencount
	for i=1,999 do
		local comp = entity:GetHiddenComponent(i)
		if not comp then break end
		local comp_def = comp.def
		if comp_def.get_ui or (comp_def.attachment_size and comp_def.attachment_size ~= "Hidden") then
			if not hiddencomps then hiddencomps = self.hiddencomps if not hiddencomps then hiddencomps = {} self.hiddencomps = hiddencomps end end
			hiddencount = (hiddencount or 0) + 1
			local compblock = hiddencomps[i]
			if not compblock or not compblock:IsValid() then
				compblock = self.components:Add("ComponentColumn", { entity = entity, hiddencomp = i, socket_size = "hidden", })
				compblock.child_index = hiddencount
				hiddencomps[i] = compblock
			end
		end
	end

	-- Fill out changed components at the bottom and in the register panel
	local components, noregs, changed_components, removed_compblocks = self.components, self.link_editor and true

	--local collapsed_component = Game.GetLocalPlayerExtra().collapsed_component or {}
	for i,v in ipairs(components) do
		local socket = v.socket
		local comp = (socket and entity:GetComponent(socket)) or (not socket and entity:GetHiddenComponent(v.hiddencomp))
		local hash = (comp and Tool.Hash(comp, comp.register_index, comp.register_count, noregs) or 0) -- , collapsed_component[comp.id]

		if (v.hash ~= hash or force_update) then
			v.hash = hash

			-- force update effects/inventory slot hovers
			if self.hovering_component then
				self:on_hover_component(false, nil)
			end

			v:SetComp(comp)
			v.progress.hidden, v.progressbg.hidden = true, true
			v.regs:Clear()
			v.regs2:Clear()
			if v.bigbtn then v.bigbtn:RemoveFromParent() v.bigbtn = nil end
			v.customui:Clear()
			v.customui.hidden = true
			if comp and comp.exists then
				local comp_def, hideregs, reg_ui = comp.def
				local get_ui = not foreign and comp_def.get_ui
				if get_ui and get_ui ~= true then
					local compcol_ui, sidebigbtn_ui
					reg_ui, compcol_ui, hideregs, sidebigbtn_ui = comp_def:get_ui(comp, noregs)
					if compcol_ui then
						v.customui.hidden = false
						v.customui:Add(compcol_ui)
						compcol_ui.compbox = v
					end
					if sidebigbtn_ui then
						v.bigbtn = self.bigbtns:Add(sidebigbtn_ui)
						sidebigbtn_ui.compbox = v
					end
				end

				if not hideregs and not noregs then
					local regdefs = comp_def.registers
					local abs_index = comp.register_index - 1
					local regcnt = math.min(comp.register_count, 10)
					local behavior_asm = comp.base_id == "c_behavior" and comp.has_extra_data and GetFactionBehaviorAsmById(comp.faction, comp.extra_data.main_id)
					local behavior_pnames = behavior_asm and behavior_asm.code.pnames
					local reglayout = "<Reg on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_drag_complete={link_on_drag_complete} on_drop={link_on_drop}/>"
					local regminilayout = "<MiniReg on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_drag_complete={link_on_drag_complete} on_drop={link_on_drop}/>"
					for j=regcnt,1,-1 do
						local regdef = regdefs and regdefs[j]
						local tt = regdef and regdef.tip
						self.regs[abs_index + j] = (j>4 and v.regs2 or v.regs):Add(j>4 and regminilayout or reglayout, {
							ent = entity,
							comp = comp,
							comp_index = i,
							reg_index = j,
							empty_tooltip = tt and L("%s\n\n<desc>A Register that holds a value</>", tt),
							no_modify = foreign,
							no_num_txt = (behavior_pnames and NOLOC(behavior_pnames[j])) or (behavior_asm and NOLOC("P" .. j)) or nil,
						})
					end
				end

				if reg_ui then v.regs:Add(reg_ui) end

				if hideregs and type(hideregs) == "table" then
					-- hook up regs
					local abs_index = comp.register_index - 1
					for _,reg in ipairs(hideregs) do
						self.regs[abs_index + reg.reg_index] = reg
					end
				end

				v.on_mouse_enter = function(w) self:on_hover_component(true, w.comp) end
				v.on_mouse_leave = function(w) self:on_hover_component(false, w.comp) end
			elseif v.hiddencomp then
				removed_compblocks = removed_compblocks or {}
				removed_compblocks[#removed_compblocks+1] = v
				self.hiddencomps[v.hiddencomp] = nil
			end

			changed_components = true
		end
		v.regs.margin_right = (#v.regs2 > 0 and 0 or 8)
		v.regs2.hidden = #v.regs2 == 0
		if comp and comp.is_working and v.progress.hidden then
			v.progress.hidden, v.progressbg.hidden = false, false
			v.progress.every_frame_update = function(p) p.progress = comp.interpolated_progress end
			v.progress.progress = comp.interpolated_progress
		elseif not v.progress.hidden and (not comp or not comp.is_working) then
			v.progress.hidden, v.progressbg.hidden = true, true
		end
	end

	-- Check if components changed
	if changed_components or first_update then
		if removed_compblocks then
			for _,v in ipairs(removed_compblocks) do v:RemoveFromParent() end
		end
	end

	-- If links changed, queue redrawing of lines and set margins to make room for the lines
	local entity_links = entity:GetRegisterLinks()
	if entity_links then
		local links_hash = Tool.Hash(entity_links)
		if self.links_hash ~= links_hash or changed_components then
			self.links_hash = links_hash
			self.links.on_draw = function(draw) self:UpdateLinks(draw) end
		end
	end

	-- count docked entities
	local entity_slots, dock_count = (entity.slots or {}), 0
	for _,v in ipairs(entity_slots) do
		if (v.entity or v.reserved_entity) then dock_count = dock_count + 1 end
	end

	-- Check if inventory slots changed
	local inv_list, dock_boxes, numslots = self.inv_list, self.dock_boxes, #entity_slots
	local inv_hash = Tool.Hash(#entity_slots, entity_slots[numslots], dock_boxes, dock_boxes and dock_count)
	if inv_hash ~= self.inv_hash then
		self.inv_hash = inv_hash
		local inv_counts, allslottypes, lastcomp, counttxt, countslottypes = self.inv_counts, {}, false
		self.inventorybox.hidden = numslots == 0
		self.inventorybox.min_width = (#components * (56+36))
		self.allslottypes = allslottypes
		if dock_boxes then dock_boxes:Clear() end
		inv_list:Clear()
		inv_counts:Clear()

		for i,slot in ipairs(entity_slots) do
			if lastcomp ~= slot.component then
				lastcomp = slot.component
				local icon = lastcomp and lastcomp.def.texture or entity.def.texture
				countslottypes = {}
				counttxt = inv_counts:Add(InventoryCountIcon_Layout, {
					icon = icon,
					comp = lastcomp,
					tooltip = "Number of Inventory slots\n\n<hl>Shift-Click</> to toggle locking of slots",
					countslottypes = countslottypes,
					on_mouse_enter = function(img) self:on_hover_component(true, img.comp) end,
					on_mouse_leave = function(img) self:on_hover_component(false, img.comp) end,
				}).count
			end
			counttxt.text = tostring(counttxt.text + 1)

			local slot_type = slot.type
			countslottypes[slot_type] = true
			allslottypes[slot_type] = true

			inv_list:Add("ItemSlotWithBar", {
				slot = slot,
				orig_i = i,
				on_mouse_enter = function(img) self:on_hover_itemslot(true, img) end,
				on_mouse_leave = function(img) self:on_hover_itemslot(false, img) end,
			})

			-- add docked inventory boxes
			local dent = dock_boxes and (slot.entity or slot.reserved_entity)
			if dent then
				local box = dock_boxes:Add(DockedBox_Layout, {
					slot_type = slot.type,
					entity = dent,
					tooltip = dent.def.name,
					unitimg = dent.def.texture,
					unittt = dent.def.name,
					select_docked_unit = function(btn)
						if btn.entity then
							View.SelectEntities(btn.entity)
						end
					end,
					update = function(dbox)
						local visual_id = dbox.entity:GetRegisterId(FRAMEREG_VISUAL)
						if visual_id then
							dbox.visual.image = data.all[visual_id].texture
							dbox.visual.hidden = false
						else
							dbox.visual.hidden = true
						end
						-- update logistics button
						dbox.action_docked_manual.active = not dbox.entity.disconnected
						dbox.hlt.progress = (entity.health / entity.max_health)
					end
				})

				-- add context and store frame registers to reg panel
				for i=2,1,-1 do
					local v = data.frame_regs[i]
					box.frameregs:Add("<Reg on_drag_start={link_on_drag_start} width=32 height=32 on_drag_cancel={link_on_drag_cancel} on_drag_complete={link_on_drag_complete} on_drop={link_on_drop}/>", {
						ent = dent,
						entity = dent,
						reg_index = i,
						drag_index = #self.regs+1,
						empty_tooltip = v.tooltip,
						ui_icon = v.bg,
					})
				end
			end
		end

		-- sort slots
		local typeorder = data.item_slot_order
		inv_list:SortChildren(function(a,b)
			local at, bt = a.slot.type, b.slot.type
			local ao, bo = typeorder[at] or 999, typeorder[bt] or 999
			return (ao == bo and a.orig_i < b.orig_i) or (ao < bo)
		end)

		-- Try to use as much horizontal screen space for inventory boxes while keeping them as low as possible
		--local other_width = BOX_FRAME_WIDTH + BOX_MARGIN + BOX_FRAMEREGS_WIDTH
		--local available_width = UI.GetScreenSize() - other_width
		local n, max_slots = numslots, 16
		inv_list.wrapsize = ITEMSLOT_WIDTH * ((n <= max_slots and n) or (n <= max_slots*2 and (n+1)//2) or (n <= max_slots*3 and (n+2)//3) or max_slots)
		self.dockbtn.hidden = foreign or dock_count == 0
		self.selectalldockedbtn.hidden = foreign or dock_count == 0
		self.sendtosharedbtn.hidden = foreign
		self.requestbtn.hidden = foreign
		self.sortinvbtn.hidden = foreign or n <= 1
	end

	-- update slots
	for i,w in ipairs(inv_list) do
		local slot = w.slot
		if w.num ~= slot.stack or w.id ~= slot.id or w.reserved_stack ~= slot.reserved_stack or w.reserved_space ~= slot.reserved_space or slot.locked ~= w.locked or w.type ~= slot.type then
			w:UpdateInfo()
		end
	end

	-- update particle effects
	local fxhash = Tool.Hash(show_visibility_range and entity.visibility_range, show_power_range and entity.power_range)
	if self.fxhash ~= fxhash then
		self.fxhash = fxhash
		self:UpdateEffects()
	end
end

function FrameView:UpdateEffects(clear)
	if self.fxvis    then View.StopEffect(self.fxvis)   self.fxvis   = nil end
	if self.fxpower  then View.StopEffect(self.fxpower) self.fxpower = nil end
	if self.fxrange  then View.StopEffect(self.fxrange) self.fxrange = nil end
	if self.fxrangem then View.StopEffect(self.fxrangem) self.fxrangem = nil end
	if self.order_in then for _,k in ipairs(self.order_in) do View.StopEffect(k) end self.order_in = nil end

	if clear then return end

	local entity = self.entity
	if not entity.exists then return end

	if show_visibility_range then
		local vis_range = entity.visibility_range
		if vis_range and vis_range > 0 then
			self.fxvis = View.PlayEffect("fx_range", entity, { Color = "#AAAA00", Range = vis_range })
		end
	end

	if show_power_range then
		local power_range = entity.power_range
		if power_range and power_range > 0 then
			self.fxpower = View.PlayEffect("fx_range", entity, { Color = "#00AAAA", Range = power_range })
		end
	end

	if self.hovering_component and self.hovering_component.exists then
		local def = self.hovering_component.def
		local comprange = def.range or def.attack_radius or def.trigger_radius or def.transfer_radius or def.light_radius or def.terraforming_range
		if comprange then
			self.fxrange = View.PlayEffect("fx_range", entity, { Color = "#00AA22", Range = comprange })
			if def.minimum_range then
				self.fxrangem = View.PlayEffect("fx_range", entity, { Color = "#00AA22", Range = def.minimum_range })
			end
		end
	end

	local hovering_itemslot = self.hovering_itemslot
	local drone_ent = hovering_itemslot and (hovering_itemslot.slot.entity or hovering_itemslot.slot.reserved_entity)
	if drone_ent then
		local range = drone_ent.def.drone_range
		if range then
			self.fxrange = View.PlayEffect("fx_range", entity, { Color = "#00AA22", Range = range })
		end
	elseif hovering_itemslot then
		-- show line
		local orders = Game.GetLocalPlayerFaction():GetActiveOrders(entity)
		local e_pairs = {}
		for i,o in ipairs(orders) do
			if o.target_entity == entity and o.source_entity and not e_pairs[o.source_entity.key] then
				e_pairs[o.source_entity.key] = true
				if not self.order_in then self.order_in = {} end
				self.order_in[#self.order_in+1] = View.PlayEffect("fx_line", o.source_entity, entity, { Color = "#009A13" })
			end
		end
	end
end

function FrameView:selectall_docked()
	local docked_entities = {}
	for i,v in ipairs(self.entity.slots or {}) do
		local docked_entity = v.entity or v.reserved_entity
		if docked_entity then docked_entities[#docked_entities+1] = docked_entity end
	end
	if #docked_entities then
		View.SelectEntities(docked_entities)
	end
end

function FrameView:send_to_shared()
	Action.SendForEntity("IssueDumpingOrders", self.entity)
end

function EntityAction.IssueDumpingOrders(entity, arg)
	entity:IssueDumpingOrders()
end

function FrameView:request_items(btn)
	local filter_slot_type, entity = self.allslottypes, self.entity
	local largest_socket, currsize = 0
	for i,v in ipairs(entity.visual_def.sockets or {}) do
		-- get free sockets only
		if not entity:GetComponent(i) then
			currsize = GetAttachmentSize(v[2])
			if largest_socket < currsize then
				largest_socket = currsize
			end
		end
	end
	UI.MenuPopup([[
			<Box bg=popup_box_bg padding=4 blur=true>
				<VerticalList>
					<VerticalList id=activebox>
						<Text text="Active Requests (click to cancel)" halign=center/>
						<Wrap margin_left=4 id=orders min_height=60 child_padding=4/>
						<Image height=2 color=ui_light margin=8/>
					</VerticalList>
					<Text text="Request an Item to be Delivered" halign=center/>
					<Box bg=popup_pattern id=listbox>
						<VerticalList>
							<HorizontalList child_padding=8 margin_top=8 margin_left=8 margin_right=4>
								<Text valign=center text="Request Type:" min_width=160/>
								<Combo id=type fill=true/>
							</HorizontalList>
							<HorizontalList child_padding=8 margin_top=8 margin_left=8 margin_right=4>
								<Text valign=center text="Request Channel:" min_width=160/>
								<Combo id=channel fill=true/>
							</HorizontalList>
						</VerticalList>
					</Box>
					<RegisterSelection width=626 max_height=600 on_set={on_request} def_filter={def_filter} hide_clear_button=true apply_text="Request Item - Hold Shift to keep window open"/>
				</VerticalList>
			</Box>
		]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			menu.type.texts = { "Single Request", "Recurring Request (Keep Filled Up to Amount)" }
			menu.channel.texts = { "Default Channel(s)", "On Channel 1", "On Channel 2", "On Channel 3", "On Channel 4" }
		end,
		update = function(menu)
			local e = self.entity
			local orders = Game.GetLocalPlayerFaction():GetActiveOrders(e)
			for _,o in ipairs(orders) do o.age = 0 end -- exclude age from hash
			local hash = Tool.Hash(orders)
			if hash == menu.hash then return end
			menu.hash = hash
			menu.orders:Clear()
			for i,o in ipairs(orders) do
				if o.source_entity == e or o.carry_entity == e or o.target_entity == e then
					local r = menu.orders:Add("Reg", {
						def_id = o.item_id, num = o.amount,
						bg = o.carry_entity and "item_default" or "item_disabled",
						on_click = function(reg)
							Action.SendForLocalFaction("CancelOrder", { id = o.id })
							reg:RemoveFromParent()
						end,
					})
					if o.recurring then r:Add('<Image dock=top-right width=22 height=22 color=ui_light image=icon_processing tooltip="Recurring Request (Keep Filled Up to Amount)"/>') end
					if o.channel_bitmask then r:Add('<Image dock=top-left width=22 height=22 color=ui_light/>', data.order_channel_bit_images[o.channel_bitmask]) end
				end
			end
			menu.activebox.hidden = #menu.orders == 0
		end,
		def_filter = function(def, cat)
			return (filter_slot_type[def.slot_type] and cat.defs ~= data.frames and def.attachment_size ~= "Hidden") or cat.number_panel or (largest_socket and def.attachment_size and (GetAttachmentSize(def.attachment_size) <= largest_socket))
		end,
		on_request = function(menu, regsel, res)
			local id = res.id
			local item_def = data.all[id]
			if not item_def then return end
			local num = (res.num and res.num > 0 and res.num) or 1
			local slot_type, stack_size = item_def.slot_type or "storage", item_def.stack_size or 1
			local entity_slots, have_partial_space = self.entity:GetSlotsByType(slot_type) or {}
			local channel = menu.channel.value and menu.channel.value > 1 and (menu.channel.value - 1) or nil
			if menu.type.value == 2 then
				local max = #entity_slots * stack_size
				if num > max then num = max end
				if num > 0 then Action.SendForEntity("ManualReserveItem", self.entity, { id = id, num = num, channel = channel, recurring = true }) end
			else
				for _,v in ipairs(entity_slots) do
					local unreserved_space = (v.id == id and v.unreserved_space or 0)
					if (unreserved_space > 0 and unreserved_space >= math.min(num, stack_size)) or (v.id == nil and v.type == slot_type and not v.locked) then
						Action.SendForEntity("ManualReserveItem", self.entity, { id = id, num = math.min(num, stack_size), slot = v, channel = channel })
						num = num - math.min(num, stack_size)
						if num == 0 then break end
					elseif unreserved_space > 0 then
						have_partial_space = true
					end
				end
				if num > 0 and have_partial_space then
					for _,v in ipairs(entity_slots) do
						local unreserved_space = (v.id == id and v.unreserved_space or 0)
						if unreserved_space > 0 then
							Action.SendForEntity("ManualReserveItem", self.entity, { id = id, num = math.min(num, unreserved_space), slot = v, channel = channel })
							num = num - math.min(num, unreserved_space)
							if num == 0 then break end
						end
					end
				end
				if num == 1 and self.entity:GetFreeSocket(id) then
					Action.SendForEntity("ManualReserveItem", self.entity, { id = id, num = math.min(num, stack_size), channel = channel })
					num = 0
				end
				if num == 0 then
					Notification.Warning(L("Requested %s", item_def.name))
				else
					Notification.Error("No free slots available for reservation")
				end
			end
			if not Input.IsShiftDown() then
				UI.CloseMenuPopup()
			end
		end,
	}, btn, "UP")
end

function FrameView:sort_items()
	Action.SendForEntity("SortInventory", self.entity)
end

function FrameView:on_actionbuttons_enter() Quickview_ShowPower() end

function FrameView:on_actionbuttons_leave() Quickview_HidePower() end

function FrameViewInfoBox:toggle_power()
	if self.foreign then return end
	local entity = self.entity
	if entity.is_construction then
		Action.SendForConstruction("SetConstructionPause", entity, { val = not entity.powered_down })
	else
		Action.SendForEntity("SetPowerDown", entity, { val = not entity.powered_down })
	end
end

function FrameViewInfoBox:toggle_disconnected(button, mousebtn)
	if self.foreign then return end
	local entity = self.entity
	if mousebtn == "LEFTMOUSEBUTTON" and not entity.is_construction then
		Action.SendForEntity("SetDisconnected", entity, { val = not entity.disconnected })
	else
		ShowLogisticsSettings(button, entity)
	end
end

function FrameView:toggle_docked_disconnected(box, button, mousebtn)
	if self.foreign then return end

	local entity = box.entity
	if mousebtn == "LEFTMOUSEBUTTON" then
		Action.SendForEntity("SetDisconnected", entity, { val = not entity.disconnected })
		return
	end

	ShowLogisticsSettings(button, entity)
end

function FrameViewInfoBox:toggle_transfer(button, mousebtn)
	if self.foreign then return end
	local entity = self.entity

	if mousebtn == "LEFTMOUSEBUTTON" then
		if not entity.logistics_transport_route then
			Action.SendForSelectedEntities("SetDisconnected", { val = true })
		end
		Action.SendForSelectedEntities("SetLogisticsFlag", { flag = "transport_route", set = not entity.logistics_transport_route })
		if not entity.logistics_transport_route then
			local function SelectStoreReg()
				if entity:GetRegisterEntity(FRAMEREG_STORE) == nil then
					CursorChooseEntity("Select Storage Location", function (target)
						if target and target.faction == entity.faction then
							Action.SendForEntity("SetRegister", entity, { idx = FRAMEREG_STORE, reg = { entity = target }})
						end
					end, nil, 2, false)
				end
			end
			if entity:GetRegisterEntity(FRAMEREG_GOTO) == nil then
				CursorChooseEntity("Select Transfer From Location", function (target)
					if target and target.faction == entity.faction then
						Action.SendForEntity("SetRegister", entity, { idx = FRAMEREG_GOTO, reg = { entity = target }})
					end
					SelectStoreReg()
				end, nil, 1, false)
			else SelectStoreReg()
			end
		end
		return
	end

	ShowLogisticsSettings(button, entity)
end

function FrameView:on_hover_component(lit, comp)
	self.hovering_component = lit and comp or nil

	local have_slots
	for i,w in ipairs(self.inv_list) do
		local match = w.slot.component == comp
		w.bg.color = (match and lit and "highlight" or "white")
		have_slots = have_slots or match
	end

	-- Only highlight components with slots, registers or a range effect
	if lit and not have_slots and comp and comp.register_count == 0 then
		local def = comp.def
		local comprange = def.range or def.attack_radius or def.trigger_radius or def.transfer_radius or def.light_radius or def.terraforming_range
		if not comprange then comp = nil end
	end

	for _,v in ipairs(self.components) do
		local vcomp = lit and v.comp
		v.hlimg.color = vcomp and vcomp == comp and "ui_dark" or "ui_bg"
	end

	self:UpdateEffects()
	self.links.on_draw = function(draw) self:UpdateLinks(draw) end
end

function FrameView:on_hover_itemslot(lit, itemslot)
	self.hovering_itemslot = lit and itemslot or nil
	self:UpdateEffects()
end

function FrameView:frameregs_mouse_enter()
	self.showlinks = true
	self.links.on_draw = function(draw) self:UpdateLinks(draw) end
end

function FrameView:frameregs_mouse_leave()
	self.showlinks = nil
	self.links.on_draw = function(draw) self:UpdateLinks(draw) end
end

function FrameView:on_click_inventory_box_icon(counticon)
	if self.foreign then return end
	local entity, comp, slot_type = self.entity, counticon.comp
	local filter_slot_type = counticon.countslottypes or self.allslottypes
	if not counticon.countslottypes then comp = false end -- signify to act on all slots

	if Input.IsShiftDown() then
		Action.SendForEntity("ItemSlotGroup", entity, { comp = comp, toggle = true })
		return
	end

	UI.MenuPopup([[<Box padding=5><VerticalList>
			<Button id=cancel text="Cancel Orders" on_click={on_cancel}/>
			<Button id=fix text="Lock All Slots" on_click={on_fix}/>
			<Button id=fixto text="Lock Slots to an Item" on_click={on_fixto}/>
			<Button id=unfix text="Unlock All Slots" on_click={on_unfix}/>
			<Button id=drop text="Drop All Items" on_click={on_drop}/>
		</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
		end,
		update = function(menu)
			if not entity.exists then return UI.CloseMenuPopup() end

			local has_locked, has_unlocked, has_available, has_empty, has_nonempty, has_order
			for i,w in ipairs(self.inv_list) do
				local slot = w.slot
				if slot.component == comp or comp == false then
					local locked, empty = slot.locked, slot.stack == 0 and slot.reserved_space == 0
					has_locked    = has_locked    or locked
					has_unlocked  = has_unlocked  or not locked
					has_available = has_available or (slot.id and slot.unreserved_stack > 0)
					has_empty     = has_empty     or empty
					has_nonempty  = has_nonempty  or not empty
					has_order     = has_order     or not empty and slot.has_order
					slot_type     = slot_type     or slot.type
				end
			end

			local hide_drop    = not has_nonempty or (not IsBot(entity) and not entity.has_crane)
			menu.cancel.hidden = not has_order
			menu.fix.hidden    = not has_unlocked
			menu.fixto.hidden  = not has_empty
			menu.unfix.hidden  = not has_locked
			menu.drop.hidden   = hide_drop
			menu.drop.disabled = hide_drop or not has_available
		end,
		on_cancel = function()
			Action.SendForEntity("ItemSlotGroup", entity, { comp = comp, cancel = true })
			UI.CloseMenuPopup()
		end,
		on_fix = function()
			Action.SendForEntity("ItemSlotGroup", entity, { comp = comp, lock = true })
			UI.CloseMenuPopup()
		end,
		on_fixto = function()
			UI.MenuPopup([[
					<Box bg=popup_box_bg padding=8 blur=true>
						<VerticalList child_padding=8>
							<Text text="Lock Slots to an Item" halign=center/>
							<SimpleRegisterSelection width=626 max_height=536 on_select_id={on_select} def_filter={def_filter}/>
						</VerticalList>
					</Box>
				]], {
				construct = function(menu)
					menu:TweenFromTo("sy", 0, 1, 100)
				end,
				def_filter = function(def)
					return filter_slot_type[def.slot_type] and def.attachment_size ~= "Hidden"
				end,
				on_select = function(menu, regsel, id)
					Action.SendForEntity("ItemSlotGroup", entity, { comp = comp, lockto = id })
					UI.CloseMenuPopup()
				end,
			}, counticon, "UP")
		end,
		on_unfix = function()
			Action.SendForEntity("ItemSlotGroup", entity, { comp = comp, unlock = true })
			UI.CloseMenuPopup()
		end,
		on_drop = function()
			Action.SendForEntity("ItemSlotGroup", entity, { comp = comp, drop = true })
			UI.CloseMenuPopup()
		end,
	}, counticon, "UP")
end

-- This function is also used in LinkEditor (so self can be FrameView or LinkEditor)
function FrameView:link_on_drag_start(payload, is_click_drag)
	if is_click_drag then return end
	if self.foreign then return end

	UI.PlaySound("fx_ui_ELEMENT_DRAG")
	if Input.IsControlDown() then
		return UI.New("Reg", { icon = payload.icon or "reg_base_ro", num = payload.num, coord = payload.coord, bg = false })
	end

	-- start line drawing
	self.dragsource = payload
	self.links.on_draw = function(draw) self:UpdateLinks(draw) end
	return UI.New("Spacer") -- empty drag visual
end

-- This function is also used in LinkEditor (so self can be FrameView or LinkEditor)
function FrameView:link_on_drag_cancel(payload, visual, drag_was_aborted)
	if not self.dragsource then return end -- copy value
	self.dragsource = nil
	if drag_was_aborted then return end -- drag aborted by pressing right-click
	if payload.read_only then return Notification.Error("Can't set a read-only register") end

	local entity, hover_entity = self.entity, View.GetHoveredEntity()
	if hover_entity and not Input.IsAltDown() then
		if LocationBlockedByBlight(hover_entity, "cannot lock on to target inside the blight", entity) then return end
		payload:SendSet({ entity = hover_entity })
	else
		if UI.IsMouseOverUI() then return end
		local x, y = View.GetHoveredTilePosition()
		local coord = { x = x, y = y }
		if LocationBlockedByBlight(coord, "cannot lock on to target inside the blight", entity) then return end
		payload:SendSet({ coord = coord })
	end
end

-- This function is also used in LinkEditor (so self can be FrameView or LinkEditor)
function FrameView:link_on_drag_complete(payload, recipient, visual)
	self.dragsource = nil
end

-- This function is also used in LinkEditor (so self can be FrameView or LinkEditor)
function FrameView:link_on_drop(droppedon, payload, visual)
	if visual.icon then
		-- copy value
		if droppedon.read_only then return Notification.Error("Can't set a read-only register") end
		local dragtype = payload.dragtype
		local payload_slot = dragtype == "ITEM" and payload.slot
		local set_id = (payload_slot and payload_slot.id) or (dragtype == "COMPONENT" and payload.comp and payload.comp.id) or payload.def_id
		local set_entity = (dragtype ~= "COMPONENT" and payload.entity) or (payload_slot and (payload_slot.entity or payload_slot.reserved_entity))
		droppedon:SendSet({ id = (not set_entity and set_id or nil), entity = (set_entity or nil), num = payload.num or 1, coord = payload.coord })
	else
		if not payload.abs_index then return false end -- not dragging a register
		if droppedon.abs_index == payload.abs_index then return end -- dragging onto itself, probably aborting
		if droppedon.read_only then return Notification.Error("Can't link to a read-only register") end
		if payload.ent == droppedon.ent and droppedon.abs_index then
			Action.SendForEntity("DraggedLink", droppedon.ent, { to = droppedon.abs_index, from = payload.abs_index })
		elseif droppedon.ent and droppedon.reg_index and droppedon.abs_index and not droppedon.read_only then
			droppedon:SendSet({ id = payload.def_id, entity = payload.entity, num = payload.num, coord = payload.coord })
		end
	end
end

function FrameView:docked_on_drop(dockedbox, droppedon, payload, visual)
	if not payload.ent or not payload.reg_index or not payload.abs_index or payload.read_only or not dockedbox.entity then return false end
	payload:SendSet({ entity = dockedbox.entity })
end

function FrameView:on_viewport_resize()
	if #self.regs == 0 then return end
	self.links.on_draw = function(draw) self:UpdateLinks(draw) end
end

function FrameView:UpdateLinks(draw)
	-- This function is called via the on_draw callback which gets called when the draw widget is being painted.
	-- Because the draw widget is last in the parent canvas, all the GetViewportPosition calls are done on widgets that have already been laid out.

	local reg_conns, targets = {}, {}
	local function ConnOffset(idx, skip_increment)
		local conns = reg_conns[idx] or 0
		if not skip_increment then conns = conns + 1 reg_conns[idx] = conns end
		if conns <= 1 then return 0.500 end
		if conns == 2 then return 0.675 end
		if conns == 3 then return 0.325 end
		if conns == 4 then return 0.850 end
		if conns == 5 then return 0.150 end
		return 1.4 - conns * 0.125
	end

	local draw_entity_links = not self.link_editor
	local entity_links = draw_entity_links and self.entity:GetRegisterLinks() or {}
	table.sort(entity_links, function (a,b) return a.source_index > b.source_index end)

	draw:Reset()
	local regs, showall = self.regs, self.showlinks
	local link_colors, col_idx, numtargets, source = data.link_colors, 0, 0
	for i=1,#entity_links+1 do
		local link = entity_links[i]
		local next_source, link_index = link and link.source_index, link and link.index
		if source ~= next_source and source then
			local sreg = regs[source]
			if sreg and sreg:IsValid() then
				local sx, sy, sw = sreg:GetViewportPosition(draw)
				if sx then
					if source > 4 then
						sy = sy + sw * ConnOffset(source)
					else
						sx = sx + sw * ConnOffset(source)
					end

					for pass=1,2 do
						local thick = (pass == 1 and 2.0 or 0.0)
						local col = (pass == 1 and "#44EE" or "white")
						if pass == 2 then
							col = link_colors[1 + (col_idx % #link_colors)]
							col_idx = col_idx + 1
						end

						draw:AddTriangle(sx, sy, 7.5+thick, source > 4 and 90 or 0, col)

						for j=1,numtargets do
							local target = targets[j]
							local treg, tx, ty, tw = regs[target]
							local draw_line = showall or self.hovering_component ~= nil
							if treg then
								tx, ty, tw = treg:GetViewportPosition(draw)
								draw_line = draw_line and (showall or sreg.comp == self.hovering_component or treg.comp == self.hovering_component)
								if tx then
									if target > 4 then
										ty = ty + tw * ConnOffset(target, thick == 0)
									else
										tx = tx + tw * ConnOffset(target, thick == 0)
									end
								end
							else
								draw_line = false
								ty = false
							end
							if ty then
								draw:AddTriangle(tx, ty, 5.5+thick, target > 4 and 270 or 180, col)
								if draw_line then
									local offset = (source > 4) and (sy == ty) and 30 or 0
									draw:AddBezierCurve(sx, sy,
										sx - (source > 4 and 100 or 0),
										sy - ((source <= 4) and 100 or offset),

										tx - (target > 4 and 100 or 0),
										ty - (target <= 4 and 100 or offset),

										tx, ty, col, 2+thick)
								end
							end
						end
					end
				end
			end
			numtargets = 0
		end

		if next_source and regs[link_index] then
			source = next_source
			numtargets = numtargets + 1
			targets[numtargets] = link_index
		end
	end

	local dragsource = self.dragsource
	if dragsource then
		local onui, tx, ty = UI.IsMouseOverUI(), UI.GetMousePosition(draw)
		local flip, sx, sy, sw, sh = onui and 0 or 180, dragsource:GetViewportPosition(draw)
		if sx and tx then
			sx = sx + (sw / 2)
			local curve = math.max(50, math.abs(sx - tx) / 5)

			for pass=1,2 do
				local col = (pass == 1 and "#44EE" or "white")
				local thick = (pass == 1 and 2.0 or 0.0)
				draw:AddTriangle(sx,     sy, 12.5+thick, 0 + flip, col)
				draw:AddTriangle(tx - 1, ty,  8.5+thick, 180, col)
				draw:AddBezierCurve(sx, sy,
					sx, sy - curve,
					tx, ty + (onui and -curve or curve),
					tx, ty, col, 3+thick)
			end
		end
	else
		draw.on_draw = nil
	end
end

-------------------------------------------- construction site frame view
local FrameviewConstructionLayout =
[[
<Canvas>
	<HorizontalList dock=bottom margin_bottom=4 child_padding=4 child_align=bottom min_width=1522>
		<FrameViewInfoBox id=infobox entity={entity} margin_left=244/>
		<Box padding=8 blur=true>
			<VerticalList min_width=500 child_padding=4>
				<Text id=txtframename textalign=center style=hl/>
				<Text text="Requirements"/>
				<Wrap id=recipe wrapsize=1000/>
				<Box><Progress height=8 bg=false id=recipeprog color=green/></Box>
				<HorizontalList id=btns height=32>
					<Button text="Pause Construction" on_click={on_click_pause} id=pausebtn fill=true margin_right=4/>
					<Button text="Abort Construction" on_click={on_click_abort} fill=true/>
				</HorizontalList>
				<HorizontalList id=chkboxes child_padding=4 halign=center child_align=center>
					<Text text="High Priority" on_click={on_click_priority}/>
					<Button id=highpriobtn width=24 height=24 on_click={on_click_priority} margin_right=32/>
					<Text text="Notify On Completion" on_click={on_click_notify}/>
					<Button id=notifyoncompletionbtn width=24 height=24 on_click={on_click_notify}/>
				</HorizontalList>
			</VerticalList>
		</Box>
	</HorizontalList>
</Canvas>
]]

local FrameviewConstruction = {}
UI.Register("FrameviewConstruction", FrameviewConstructionLayout, FrameviewConstruction)

function FrameviewConstruction:construct()
	local foreign = (self.entity.faction ~= Game.GetLocalPlayerFaction())
	self.btns.hidden = foreign
	self.chkboxes.hidden = foreign
end

function FrameviewConstruction:update()
	local entity = self.entity
	local con_comp = entity:FindComponent("c_construction", true)
	local reloc_comp = con_comp.id == "c_relocation" and con_comp
	local con_ed = con_comp.has_extra_data and con_comp.extra_data
	local list = self.recipe
	if #list == 0 then
		local foreign = (entity.faction ~= Game.GetLocalPlayerFaction())
		local frame_def, blueprint_def = GetProduction(entity:GetRegisterId(FRAMEREG_GOTO), entity)
		local ingredients = frame_def and GetIngredients((frame_def.construction_recipe or frame_def.production_recipe), blueprint_def)
		if not ingredients then return end
		self.txtframename.text = blueprint_def and blueprint_def.name or frame_def.name

		-- create recipe widgets
		local items, con_skip = {}, (con_ed and con_ed.skip)
		local function AddItem(item_id, need, overwrite_need)
			if not item_id then return end
			local hl = items[item_id]
			if hl then hl.need = (overwrite_need and 0 or hl.need) + need return end
			local item = data.all[item_id]
			local can_skip = (need > 0 and item.data_name == 'components' and con_comp.id == "c_construction") and not foreign
			local skip = can_skip and con_skip and con_skip[item_id]
			local tooltip_options = can_skip and { warning = "Click to toggle required component" } or nil
			hl = list:Add("HorizontalList", {
				item_id = item_id, have = -1, need = need,
				tooltip_options = tooltip_options,
				opacity = skip and 0.4 or 1,
			})
			hl.reg = hl:Add("<Reg bg=item_default/>", {
				icon = item.texture,
				tooltip = DefinitionTooltip(item, tooltip_options),
				on_click = can_skip and function(reg)
					if not con_comp.is_working then
						skip = not skip
						reg.parent.opacity = skip and 0.4 or 1
						Action.SendForConstruction("SetSkipComponent", entity, { id = item_id, skip = skip or nil })
					end
				end,
			})
			hl.txt = hl:Add("<Text margin_left=4 margin_right=8 valign=center/>")
			items[item_id] = hl
		end

		for _,slot in pairs(entity.slots) do AddItem(slot.id, slot.stack + slot.reserved_space) end
		if not reloc_comp then
			for k,v in pairs(ingredients) do AddItem(k, v, true) end
		end

		list:SortChildren(function(a, b) return a.need > b.need end)
	end

	-- update texts
	for i,w in ipairs(list) do
		local have = entity:CountItem(w.item_id)
		if w.have ~= have then
			local need = w.need
			w.have = have
			w.hidden = need == 0 and (have == 0 or i > 6)
			w.disabled = (have >= need)
			w.txt.text = have .. "/" .. need
			if have >= need and w.tooltip_options then w.tooltip_options.warning = nil end
		end
	end

	-- update pause button
	local powered_down = entity.powered_down
	if powered_down ~= self.paused then
		self.paused = powered_down
		self.pausebtn.hidden = not not reloc_comp
		self.pausebtn.active = powered_down
		self.pausebtn.text = powered_down and "Resume Construction" or "Pause Construction"
	end

	-- update high priority check
	local highprio = entity.logistics_high_priority
	if highprio ~= self.highprio then
		self.highprio = highprio
		self.highpriobtn.active = highprio
		self.highpriobtn.icon = highprio and "icon_small_confirm" or nil
	end

	-- update on notify on completion check
	local notifyoncompletion = con_ed and con_ed.notifyoncompletion
	if notifyoncompletion ~= self.notifyoncompletion then
		self.notifyoncompletion = notifyoncompletion
		self.notifyoncompletionbtn.active = notifyoncompletion
		self.notifyoncompletionbtn.icon = notifyoncompletion and "icon_small_confirm" or nil
	end
end

function FrameviewConstruction:every_frame_update()
	-- update progress bar
	local entity = self.entity
	local con_comp = entity:FindComponent("c_construction", true)
	local working = con_comp and con_comp.is_working
	self.recipeprog.progress =  working and ((con_comp.has_active_effects or entity.powered_down) and con_comp.interpolated_progress or 1.0) or 0.0
end

function FrameviewConstruction:on_click_pause()
	Action.SendForConstruction("SetConstructionPause", self.entity, { val = not self.entity.powered_down })
end

function FrameviewConstruction:on_click_abort()
	Action.SendForConstruction("AbortConstruction", self.entity)
end

function FrameviewConstruction:on_click_priority()
	local val = not self.highpriobtn.active
	self.highpriobtn.active = val
	self.highpriobtn.icon = val and "icon_small_confirm" or nil
	Action.SendForConstruction("SetConstructionPriority", self.entity, { val = val })
end

function FrameviewConstruction:on_click_notify()
	local val = not self.notifyoncompletionbtn.active
	self.notifyoncompletionbtn.active = val
	self.notifyoncompletionbtn.icon = val and "icon_small_confirm" or nil
	Action.SendForConstruction("SetNotifyOnCompletion", self.entity, { val = val })
end

-------------------------------------------- deploy site frame view
local FrameviewDeploymentLayout =
[[
	<Box dock=bottom padding=12 margin_bottom=4>
		<HorizontalList child_padding=12>
			<Image image={frame_img} tooltip={framedef_tt} width=80 height=80/>
			<VerticalList valign=center min_width=500>
				<Text style=header text={frame_name} textalign=center/>
				<HorizontalList height=32 id=btns margin_top=8>
					<Button text="Pause Deployment" on_click={on_click_pause} id=pausebtn fill=true margin_right=4/>
					<Button text="Cancel Deployment" on_click={on_click_abort} fill=true/>
				</HorizontalList>
			</VerticalList>
		</HorizontalList>
	</Box>
]]

local FrameviewDeployment = {}
UI.Register("FrameviewDeployment", FrameviewDeploymentLayout, FrameviewDeployment)

function FrameviewDeployment:update()
	local entity = self.entity
	local id, bp = GetConstructionSiteIdOrBP(entity, true)
	local frame_def = data.frames[bp and bp.frame or id]
	local texture = frame_def and frame_def.texture or entity.def.texture
	if self.frame_img ~= texture then
		self.frame_img = texture
		self.frame_name = frame_def and frame_def.name or "Deployment Site"
		self.framedef_tt = frame_def and DefinitionTooltip(bp or frame_def)
		self.btns.hidden = not frame_def
	end

	-- update pause button
	local powered_down = entity.powered_down
	if powered_down ~= self.paused then
		self.paused = powered_down
		self.pausebtn.active = powered_down
		self.pausebtn.text = powered_down and "Resume Deployment" or "Pause Deployment"
	end
end

function FrameviewDeployment:on_click_pause()
	Action.SendForConstruction("SetConstructionPause", self.entity, { val = not self.entity.powered_down })
end

function FrameviewDeployment:on_click_abort()
	Action.SendForConstruction("AbortConstruction", self.entity)
end
-------------------------------------------- dropped item frame view
local layout_droppeditem_view =
[[
	<Box dock=bottom padding=12 margin_bottom=4>
		<VerticalList child_padding=8 child_align=center min_width=115>
			<Text style=hl text="Dropped Items"/>
			<Inventory entity={entity}/>
		</VerticalList>
	</Box>
]]

-------------------------------------------- explorable frame view
local FrameViewExplorableLayout =
[[
	<Box dock=bottom padding=12 margin_bottom=4>
		<VerticalList child_padding=8>
			<Text style=hl text="Explorable"/>
			<Inventory id=inventory entity={entity} hidden=true/>
			<Text id=hint text="Right click to investigate"/>
		</VerticalList>
	</Box>
]]

local FrameViewExplorable = {}
UI.Register("FrameViewExplorable", FrameViewExplorableLayout, FrameViewExplorable)

function FrameViewExplorable:update()
	if not self.entity.exists then
		-- close the Window
		self:RemoveFromParent()
		open_frame_view = nil
		return
	end
	self.inventory.hidden = not self.entity.lootable
	self.hint.hidden = self.entity.extra_data.solved
end

-------------------------------------------- other faction frame view
local FrameViewOtherFactionLayout =
[[
	<Box dock=bottom padding=12 margin_bottom=4>
		<HorizontalList child_padding=12>
			<Image image={frame_img} tooltip={framedef_tt} width=64 height=64/>
			<VerticalList valign=center>
				<Text style=header text={frame_name}/>
				<Text textalign=center id=fnametxt text={faction_name}/>
			</VerticalList>
		</HorizontalList>
	</Box>
]]

local FrameViewOtherFaction = {}
UI.Register("FrameViewOtherFaction", FrameViewOtherFactionLayout, FrameViewOtherFaction)

local DefaultFactionNames = {
	alien = "Aliens",
	bugs = "Bugs",
	anomaly = "Anomaly",
	world = "",
}

function FrameViewOtherFaction:construct()
	local entity = self.entity
	local faction_name = entity.faction.name
	faction_name = DefaultFactionNames[faction_name] or faction_name
	if faction_name == "" then
		self.fnametxt.hidden = true
	else
		self.faction_name = faction_name
	end

	local frame_def = entity.def
	self.frame_name = entity.visual_def.explorable_name or frame_def.name
	self.frame_img = frame_def.texture
	self.framedef_tt = DefinitionTooltip(frame_def)
end

-------------------------------------------- multiple frame selection
local layout_multi =
[[
	<Canvas>
		<VerticalList id=list dock=left child_padding=4 child_align=left margin_left=4/>
		<Wrap id=listwrap dock=left child_padding=4 margin_left=4/>

		<HorizontalList dock=bottom margin_bottom=4 child_align=bottom min_width=1522>
			<Box id=panel padding=8 blur=true margin_left=244 width=260>
				<VerticalList child_align=center child_padding=4>
					<Text text={selected_txt} style=hl/>
					<HorizontalList child_align=center id=frameregs child_padding=4 hidden=true/>
					<HorizontalList id=buttons child_padding=4/>
					<HorizontalList margin=4 child_padding=4 halign=right id=controlbox hidden=true on_mouse_enter={on_actionbuttons_enter} on_mouse_leave={on_actionbuttons_leave}>
						<Button width=44 height=44 icon=icon_stop on_click={run_behaviors} tooltip="Stop All Behaviors" id=behav_stop hidden=true/>
						<Button width=44 height=44 icon=icon_play on_click={run_behaviors} tooltip="Start All Behaviors" id=behav_start hidden=true/>
						<Button width=44 height=44 icon=icon_small_request on_click={request_items} tooltip="Request Item" id=requestbtn/>
						<Button width=44 height=44 on_click={toggle_power} id=action_power icon=icon_power/>
						<Button width=44 height=44 on_click={toggle_disconnected} id=action_connect icon=icon_carry/>
					</HorizontalList>
					<Canvas id=deconbox height=25 tooltip="Hold to deconstruct" hidden=true halign=fill child_fill=true on_mouse_button_down={start_deconstruct} on_mouse_button_up={stop_deconstruct}>
						<Image color=ui_bg/>
						<Progress progress=0 margin=3 bg=false color=red id=deconbar/>
						<Text text="DECONSTRUCT" y=-1 style=bl color=ui_dark size=16 textalign=center opacity=0.8/>
					</Canvas>
				</VerticalList>
			</Box>
			<HorizontalList id=components hidden=true margin_left=4 child_align=bottom/>
			<Box id=constructionbox padding=8 blur=true hidden=true margin_left=508>
				<VerticalList min_width=500 child_padding=4>
					<Text id=txtconstruction margin_bottom=4/>
					<HorizontalList height=32>
						<Button text="Pause Constructions" on_click={on_click_pause} id=pausebtn fill=true margin_right=4/>
						<Button text="Abort Constructions" on_click={on_click_abort} fill=true/>
					</HorizontalList>
					<HorizontalList child_padding=4 halign=center>
						<Text text="High Priority Construction Sites" on_click={on_click_priority}/>
						<Button id=highpriobtn width=24 height=24 on_click={on_click_priority}/>
					</HorizontalList>
				</VerticalList>
			</Box>
		</HorizontalList>
		<Draw id=links fill=true/>
	</Canvas>
]]

local layout_multi_child =
[[
	<Box>
		<Scale scale=0.75>
			<HorizontalList>
				<Canvas width=64 height=64 on_click={frame_on_click} on_clipboard_copy={frame_on_clipboard_copy}>
					<Image imageid={frameid} x=4 y=4 width=60 height=60 tooltip={imgtip}/>
					<Image id=visual dock=bottom-right width=40 height=40/>
					<Image id=state width=18 height=18/>
				</Canvas>
				<Progress id=bat color=powerbar orientation=vertical width=16/>
				<Progress id=hlt color=healthbar orientation=vertical width=16/>
			</HorizontalList>
		</Scale>
	</Box>
]]

local FrameViewMulti = {}
UI.Register("FrameviewMulti", layout_multi, FrameViewMulti)

function FrameViewMulti:construct()
	local player_faction, all = Game.GetLocalPlayerFaction(), self.all_entities
	local all_count = #all
	local compressed = all_count > 20
	if not compressed then
		-- also check slots
		local rows = 0
		for _,entity in ipairs(all) do local slots = entity.slot_count rows = rows + (slots == 0 and 1 or ((slots + 9) // 10)) end
		if rows > 20 then compressed = true end
	end
	local addlist = compressed and self.listwrap or self.list
	local comparrays, constructions, walls, bots, buildings, have_foreign, have_behavior, have_registers, can_deconstruct = {}, 0, 0, 0, 0
	for i,entity in ipairs(all) do
		local entity_faction = entity.faction
		local is_owned, is_construction = entity_faction == player_faction, entity.is_construction
		if not is_owned then
			have_foreign = true
		elseif is_construction then
			local con_comp = entity:FindComponent("c_construction", true)
			if con_comp then
				constructions = constructions + 1
				if constructions == 1 then self.first_construction = entity end
				if con_comp.id == "c_relocation" then self.pausebtn.hidden = true end
			end
		else
			have_behavior = have_behavior or (entity:FindComponent("c_behavior", true) ~= nil)
			can_deconstruct = can_deconstruct or not CheckDeconstruct(entity)

			local entity_def = entity.def
			if entity_def.type then -- walls, gates
				walls = walls + 1
			elseif (entity_def.movement_speed or 0) > 0 then
				bots = bots + 1
			else
				buildings = buildings + 1
			end

			if not have_registers and entity.register_count > 0 then
				have_registers = true
				self.frameregsentity = entity
				for idx,v in ReverseIPairs(data.frame_regs) do
					local regw = self.frameregs:Add("<Reg on_click={reg_on_click} on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_set={reg_on_set}/>")
					regw.frameidx, regw.empty_tooltip, regw.ui_icon = idx, v.tooltip, v.bg
				end
			end

			if entity.has_component_list then
				for _,comp in ipairs(entity.components) do
					local comp_reg_count = comp.register_count
					if comp_reg_count > 0 then
						local comp_def = comp.def
						local key = comp_def.base_id == "c_behavior" and comp.extra_data.main_id or comp_def
						local comparr = comparrays[key]
						if comparr then comparr[#comparr+1] = comp -- add this to list
						elseif comparr == false then -- known as not shown
						elseif not comp_def.get_ui and comp.is_hidden then comparrays[key] = false -- remember as not shown
						else
							comparrays[key] = { comp, comp_def = comp_def, key = key, reg_count = comp_reg_count }
							have_behavior = have_behavior or (key ~= comp_def)
						end
					end
				end
			end
		end

		if #addlist < 120 then -- limit to some number to not slow down and because more don't fit on the screen anyway
			local newentry = addlist:Add(layout_multi_child, { entity = entity, frameid = entity.id })
			local faction_access = (is_owned or entity_faction:GetTrust(player_faction) == "ALLY")
			local may_see_inventory = (faction_access or entity.lootable) and not is_construction
			if not may_see_inventory then
				newentry.visual:RemoveFromParent()
				newentry.state:RemoveFromParent()
			elseif not compressed then
				newentry.inventory = newentry.hlt.parent:Add("<Inventory entity={entity}/>")
			end
		end
	end

	local addlistcount = #addlist
	if compressed then addlist.wrapsize = 80 * ((addlistcount + 9) // 10) end
	if can_deconstruct then self.deconbox.hidden = false end
	if have_foreign then self.have_foreign = true end

	if next(comparrays) then
		local sortedcomps = {}
		for key,v in pairs(comparrays) do if v then sortedcomps[#sortedcomps+1] = v end end
		table.sort(sortedcomps, function (a,b) return #a > #b end)
		table.move(sortedcomps, #sortedcomps+1, #sortedcomps+#sortedcomps-10, 10+1) -- trim to 10 items
		for _,comparr in ipairs(sortedcomps) do
			local comp_def, key, compcol = comparr.comp_def, comparr.key, self.components:Add([[<VerticalList>
					<VerticalList id=regs halign=right child_padding=4 margin_bottom=4/>
					<Box padding=5>
						<HorizontalList>
							<Image id=hlimg color=ui_bg width=22 height=56 margin_left=1 margin_right=1/>
							<SocketBox id=box entity={entity} socket_size=false halign=center margin_right=2 tooltip={comp_tooltip} on_click={comp_on_click}/>
						</HorizontalList>
					</Box>
				</VerticalList>]])
			local compbox = compcol.box
			compbox:SetCompDef(comp_def)
			compbox.comps = comparr
			local behavior_code = key ~= comp_def and player_faction.extra_data.library[key]
			local behavior_pnames = behavior_code and behavior_code.pnames
			if behavior_code then compbox.behavior_code = behavior_code end
			local comp_regdefs = comp_def.registers
			for idx=comparr.reg_count,1,-1 do
				local regdef = comp_regdefs and comp_regdefs[idx]
				local read_only = (regdef and regdef.read_only)
				local regw = compcol.regs:Add(read_only and "<Reg read_only=true/>" or "<Reg on_click={reg_on_click} on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_set={reg_on_set}/>")
				regw.compidx, regw.compbox = idx, compbox
				regw.ui_icon = (regdef and regdef.ui_icon)
				regw.comp = #comparr == 1 and comparr[1]
				regw.warning = (regdef and regdef.warning)
				regw.empty_tooltip = (regdef and regdef.tip and L("%s\n\n<desc>A Register that holds a value</>", regdef.tip)) or (behavior_pnames and behavior_pnames[idx])
				regw.no_num_txt = (behavior_pnames and behavior_pnames[idx]) or (behavior_code and NOLOC("P" .. idx)) or nil
			end
		end
		self.components.hidden = (#self.components == 0)
	end

	if constructions > 0 and constructions == all_count then
		self.txtconstruction.text = L("Selected %d construction sites", constructions)
		self.constructionbox.hidden = false
		self.panel.hidden = true
	end

	if have_registers then
		self.frameregs.hidden = false
		self.controlbox.hidden = false
		self.behav_stop.hidden, self.behav_start.hidden = not have_behavior, not have_behavior
	end

	self.selected_txt = L(((all_count ~= (bots + buildings) or bots > 0 and buildings > 0) and "%d units/buildings selected") or (bots > 0 and "%d units selected") or "%d buildings selected", all_count)

	if bots > 0 and bots ~= all_count then
		self.buttons:Add("<Canvas width=48 height=48><Button dock=fill width=48 height=48 on_click={on_click} icon={img}/><Text dock=bottom-right text={count} size=20/></Canvas>", {
			img = "Main/textures/icons/values/unit.png",
			count = tostring(bots),
			tooltip = L("Select %d Bots", bots),
			on_click = function() self:select_units(true, false, false) end,
		})
	end
	if buildings > 0 and buildings ~= all_count then
		self.buttons:Add("<Canvas width=48 height=48><Button dock=fill width=48 height=48 on_click={on_click} icon={img}/><Text dock=bottom-right text={count} size=20/></Canvas>", {
			img = "Main/textures/icons/values/building.png",
			count = tostring(buildings),
			tooltip = L("Select %d Buildings", buildings),
			on_click = function() self:select_units(false, true, false) end,
		})
	end
	if constructions > 0 and constructions ~= all_count then
		self.buttons:Add("<Canvas width=48 height=48><Button dock=fill width=48 height=48 on_click={on_click} icon={img}/><Text dock=bottom-right text={count} size=20/></Canvas>", {
			img = "Main/textures/icons/values/construction.png",
			count = tostring(constructions),
			tooltip = L("Select %d Construction Sites", constructions),
			on_click = function() self:select_units(false, false, true) end,
		})
	end
	if walls > 0 and walls ~= all_count then
		self.buttons:Add("<Canvas width=48 height=48><Button dock=fill width=48 height=48 on_click={on_click} icon={img}/><Text dock=bottom-right text={count} size=20/></Canvas>", {
			img = "Main/textures/icons/values/wall.png",
			count = tostring(walls),
			tooltip = L("%d %s", walls, "Walls"),
			on_click = function() self:select_units(false, false, false, true) end,
		})
	end
	self.buttons.hidden = #self.buttons == 0
end

function FrameViewMulti:start_deconstruct()
	local deconstruct_timer = 0.0
	self.deconbar.every_frame_update = function(bar, dt)
		deconstruct_timer = deconstruct_timer + (dt * 0.5)
		bar.progress = deconstruct_timer
		if deconstruct_timer >= 1.0 then
			Action.SendForSelectedEntities("Deconstruct")
			bar.every_frame_update = nil
		end
	end
end

function FrameViewMulti:stop_deconstruct()
	self.deconbar.progress, self.deconbar.every_frame_update = 0, nil
end

function FrameViewMulti:select_units(bots, buildings, constructions, walls)
	local player_faction, invert, select = Game.GetLocalPlayerFaction(), Input.IsShiftDown(), {}
	for i,entity in ipairs(self.all_entities) do
		local use
		if entity.faction ~= player_faction then
		elseif entity.is_construction then               use = constructions and entity:CountComponents("c_construction", true) > 0
		elseif entity.def.type then                      use = walls
		elseif (entity.def.movement_speed or 0) > 0 then use = bots
		else                                             use = buildings
		end
		if invert then use = not use end
		if use then select[#select+1] = entity end
	end
	View.SelectEntities(select)
end

function FrameViewMulti:toggle_power()
	Action.SendForSelectedEntities("SetPowerDown", { val = self.action_power.active })
end

function FrameViewMulti:toggle_disconnected(button, mousebtn)
	local all_entities = self.all_entities

	if mousebtn == "LEFTMOUSEBUTTON" then
		Action.SendForSelectedEntities("SetDisconnected", { val = button.active })
		return
	end

	ShowLogisticsSettings(button, all_entities[1], all_entities)
end

function FrameViewMulti:request_items(btn)
	UI.MenuPopup([[
			<Box bg=popup_box_bg padding=4 blur=true>
				<VerticalList>
					<Text text="Request an Item to be Delivered" halign=center/>
					<RegisterSelection width=626 max_height=600 on_set={on_request} def_filter={def_filter} hide_clear_button=true apply_text="Request Item"/>
				</VerticalList>
			</Box>
		]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
		end,
		def_filter = function(def, cat)
			return (cat.defs ~= data.frames and def.attachment_size ~= "Hidden") or cat.number_panel
		end,
		on_request = function(menu, regsel, res)
			local id = res.id
			local item_def = data.all[id]
			if not item_def then return end
			local stack_size = item_def.stack_size or 1
			local num = (res.num and res.num > 0 and res.num) or (res.num and res.num < 0 and stack_size) or 1

			Action.SendForSelectedEntities("ManualReserveItem", { id = id, num = math.min(num, stack_size) })
			UI.CloseMenuPopup()
		end,
	}, btn, "UP")
end

function FrameViewMulti:on_actionbuttons_enter() Quickview_ShowPower() end

function FrameViewMulti:on_actionbuttons_leave() Quickview_HidePower() end

function FrameViewMulti:run_behaviors(btn)
	local player_faction, stopping, arg = Game.GetLocalPlayerFaction(), (btn.icon == "icon_stop"), { comp = false, debug = btn.icon == "icon_stop" and "STOP" or nil }
	for _,entity in ipairs(self.all_entities) do
		for i=1,(entity.faction ~= player_faction and 0 or 999) do
			local comp = entity:FindComponent("c_behavior", true, i)
			if not comp then break end
			local state = comp and comp.has_extra_data and comp.extra_data
			local debug = state and state.debug
			local is_paused = not comp.is_active or (debug ~= nil and debug ~= 'BREAKPOINT')
			if stopping ~= is_paused then
				arg.comp = comp
				Action.SendForEntity("Behavior", entity, arg)
			end
		end
	end
	self.behav_stop.disabled, self.behav_start.disabled = false, false
	btn.disabled = true
end

function FrameViewMulti:on_click_pause()
	Action.SendForConstruction("SetConstructionPause", self.first_construction, { val = not self.pausebtn.active, entities = self.all_entities })
end

function FrameViewMulti:on_click_abort()
	Action.SendForConstruction("AbortConstruction", self.first_construction, { entities = self.all_entities })
end

function FrameViewMulti:on_click_priority()
	local val = not self.highpriobtn.active
	self.highpriobtn.active = val
	self.highpriobtn.icon = val and "icon_small_confirm" or nil
	Action.SendForConstruction("SetConstructionPriority", self.first_construction, { val = val, entities = self.all_entities })
end

function FrameViewMulti:update()
	local all = self.all_entities
	if not self.frameregs.hidden then
		local firstent, all_owned = self.frameregsentity, not self.have_foreign
		local regs, regdiffs, num_frame_reg = {}, {}, #data.frame_regs
		local powerdown, disconnected, powerdownsame, disconnectedsame = firstent.powered_down, firstent.disconnected, true, true
		local check_behav, player_faction, have_paused, have_running = not self.behav_stop.hidden, Game.GetLocalPlayerFaction()
		local check_explorable, explorable_entity, explorable_count = true

		for _,entity in ipairs(all) do
			if all_owned or entity.faction == player_faction then
				local gotoreg = entity:GetRegister(FRAMEREG_GOTO)
				for i=1,num_frame_reg do
					if not regdiffs[i] then
						local reg, ereg = regs[i], (i == -FRAMEREG_GOTO and gotoreg or entity:GetRegister(i))
						if ereg and reg ~= ereg then
							regdiffs[i] = reg
							if not reg or reg.is_empty then regs[i] = ereg end
						end
					end
				end
				if (powerdownsame or powerdown) and entity.powered_down ~= powerdown then
					powerdownsame = false
					if powerdown then powerdown = false end
				end
				if (disconnectedsame or disconnected) and entity.disconnected ~= disconnected then
					disconnectedsame = false
					if disconnected then disconnected = false end
				end
				if check_behav then
					for i=1,999 do
						local comp = entity:FindComponent("c_behavior", true, i)
						if not comp then break end
						local state = comp and comp.has_extra_data and comp.extra_data
						local debug = state and state.debug
						local is_paused = not comp.is_active or (debug ~= nil and debug ~= 'BREAKPOINT')
						if is_paused then have_paused = true else have_running = true end
					end
				end
				if check_explorable then
					local this_explorable = gotoreg and gotoreg.entity and GetInteractingExplorable(entity)
					if not explorable_entity then
						explorable_entity, explorable_count = this_explorable, 1
					elseif this_explorable and explorable_entity == this_explorable then
						explorable_count = explorable_count + 1
					elseif this_explorable then
						explorable_entity, explorable_count, check_explorable = nil, nil, false
					end
				end
			end
		end

		-- set frame registers
		for _,w in ipairs(self.frameregs) do
			local reg, opacity = regs[w.frameidx], regdiffs[w.frameidx] and 0.4 or 1.0
			if reg and not reg.is_empty then w.def_id, w.entity, w.coord, w.num = reg.id, reg.entity, reg.coord, reg.num else w.def_id, w.entity, w.coord, w.num = nil end
			w.image.opacity, w.numbox.opacity = opacity, opacity
		end

		-- set power/disconnect buttons
		self.action_power.active = not powerdown
		local powerTooltip = L('%s <hl>Ctrl-</><Key action="QuickAction" style="hl"/>\n\nPowered down units stop functioning and\ndo not consume power.', powerdown and "Power On" or "Shutdown")
		self.action_power.tooltip = powerTooltip --powerdown and "Power On<hl>Ctrl-E</>" or "Shut Down<hl>Ctrl-E</>"
		self.action_power.opacity = powerdownsame and 1.0 or (powerdown and 0.2 or 0.5)

		self.action_connect.active = not disconnected
		local manualTooltip = L('%s (Logistics Network)<hl>Shift-</><Key action="QuickAction" style="hl"/>\n\nUnits Connected to the logistics network will\nautomatically deliver requested items and\nmake their own inventory items available to\nthe network', disconnected and "Connect" or "Disconnect")
		self.action_connect.tooltip = manualTooltip
		self.action_connect.opacity = disconnectedsame and 1.0 or (disconnected and 0.2 or 0.5)

		-- set behavior buttons
		self.behav_stop.disabled, self.behav_start.disabled = not have_running, not have_paused

		-- show/hide explorable window
		if explorable_entity ~= self.explorable_entity then
			self.explorable_entity, self.explorable_count = explorable_entity, explorable_count
			CheckExplorableWidget(self, explorable_entity)
		elseif explorable_entity and explorable_count ~= self.explorable_count then
			self.explorable_count = explorable_count
			self.explorable_window:Refresh() -- to update show_explorable_puzzle on interactor components
		end

		-- set component registers
		for _,compcol in ipairs(self.components) do
			local comparr = compcol.box.comps
			for _,w in ipairs(compcol.regs) do
				local idx, reg, regdiff = w.compidx
				for _,comp in ipairs(comparr) do
					local creg = comp:GetRegister(idx)
					if reg ~= creg then
						regdiff = reg
						if not reg or reg.is_empty then reg = creg end
						if regdiff then break end
					end
				end
				if reg and not reg.is_empty then w.def_id, w.entity, w.coord, w.num = reg.id, reg.entity, reg.coord, reg.num else w.def_id, w.entity, w.coord, w.num = nil end
				w.image.opacity, w.numbox.opacity = regdiff and 0.4 or 1.0, regdiff and 0.4 or 1.0
			end
		end

	elseif not self.constructionbox.hidden then
		local powerdown, highprio, powerdowndiff, highpriodiff = self.first_construction.powered_down, self.first_construction.logistics_high_priority

		for _,entity in ipairs(all) do
			if entity.powered_down ~= powerdown and entity.is_construction then
				powerdowndiff = true
			end
			if entity.logistics_high_priority ~= highprio and entity.is_construction then
				highpriodiff = true
			end
		end

		self.pausebtn.active = powerdown and not powerdowndiff
		self.pausebtn.text = (powerdown and not powerdowndiff) and "Resume Constructions" or "Pause Constructions"
		self.pausebtn.opacity = powerdowndiff and 0.5 or 1.0

		self.highpriobtn.active = highprio and not highpriodiff
		self.highpriobtn.icon = highpriodiff and "icon_small_durability" or highprio and "icon_small_confirm" or nil
	end

	for _,multi_child in ipairs(#self.listwrap > 0 and self.listwrap or self.list) do
		local entity = multi_child.entity
		if multi_child.visual:IsValid() then
			local visual_id = entity:GetRegisterId(FRAMEREG_VISUAL)
			local v_def = visual_id and data.all[visual_id]
			if v_def then
				multi_child.visual.image = v_def.texture
				multi_child.visual.hidden = false
			else
				multi_child.visual.hidden = true
			end

			local state = entity.most_relevant_state
			if state then
				multi_child.state.image = data.state_icons[state]
				multi_child.state.hidden = false
			else
				multi_child.state.hidden = true
			end

			multi_child.bat.progress = entity.battery_percent / 100.0
		end
		multi_child.hlt.progress = (entity.health / entity.max_health)
	end
end

function FrameViewMulti:imgtip(multi_child)
	return BuildDefinitionTooltip(multi_child.entity.def, { entity = multi_child.entity, highlight = multi_child.entity })
end

function FrameViewMulti:frame_on_click(multi_child, canvas, mousebtn)
	SelectEntity(multi_child.entity, mousebtn)
end

function FrameViewMulti:frame_on_clipboard_copy(multi_child)
	return UnitCopyPaste.ClipboardCopyReference(multi_child.entity)
end

function FrameViewMulti:comp_tooltip(box)
	local comps, count = box.comps, 1
	for n=2,#comps do if comps[n-1].owner ~= comps[n].owner then count = count + 1 end end
	return BuildDefinitionTooltip(box.comp_def, { behavior_code = box.behavior_code, warning = L("%d units/buildings selected", count) })
end

function FrameViewMulti:comp_on_click(box, mousebtn, hashfilter)
	if mousebtn == 'RIGHTMOUSEBUTTON' then
		local pop = UI.MenuPopup([[<Box padding=5><ScrollList max_height=900/></Box>]], {
			item_on_click = function(pop,btn)
				self:comp_on_click(box, nil, btn.hash)
			end,
		}, box)
		if not pop then return end
		local comps, list, count, seen = box.comps, pop[1], 0, {}
		list:Add("<Button on_click={item_on_click} order=999999999/>")

		for n,comp in ipairs(comps) do
			local do_count = ((n == 1 or comps[n-1].owner ~= comps[n].owner) and 1 or 0)
			count = count + do_count
			local reg = comp:GetRegister(1)
			local hash = Tool.Hash(reg)
			local thisseen = seen[hash]
			if thisseen then
				seen[hash] = thisseen + do_count
			elseif not reg.is_empty then
				seen[hash] = 1
				local btn = list:Add('<Button on_click={item_on_click}><HorizontalList><Text text="Select" valign=center margin=8/><MiniReg no_interact=true/><Text valign=center margin=8/></HorizontalList></Button>')
				local w = btn[1][2]
				btn.hash, w.def_id, w.entity, w.coord, w.num = hash, reg.id, reg.entity, reg.coord, reg.num
			end
		end

		for i,btn in ipairs(list) do
			if i == 1 then
				btn.text = L("Select %s", L("%s (%d)", "All", count))
			else
				local num = seen[btn.hash]
				btn.order, btn[1][3].text = num, L("(%d)", num)
			end
		end
		list:SortChildren(function(a,b) return a.order > b.order end)
		return
	end
	local select, comps, skip = {}, box.comps, Input.IsShiftDown() and {}
	for _,comp in ipairs(comps) do
		if not hashfilter or Tool.Hash(comp:GetRegister(1)) == hashfilter then
			if skip then skip[comp.owner.key] = true else select[#select+1] = comp.owner end
		end
	end
	if skip then
		for _,e in ipairs(View.GetSelectedEntities()) do
			if not skip[e.key] then select[#select+1] = e end
		end
	end
	View.SelectEntities(select)
end

function FrameViewMulti:reg_on_click(regw, mousebtn)
	if Input.IsShiftDown() then
		regw.class.on_click(regw, mousebtn) -- go to entity/coord
	elseif mousebtn == "RIGHTMOUSEBUTTON" then
		self:reg_on_set(regw, nil)
	elseif regw and (regw.frameidx == -FRAMEREG_GOTO or regw.frameidx == -FRAMEREG_STORE) and not Input.IsControlDown() then
		CursorChooseEntity((regw.frameidx == -FRAMEREG_GOTO and "Select what to set as Goto target" or "Select what to set as Store target"), function (target)
			self:reg_on_set(regw, { entity = target })
		end,
		nil, regw.frameidx)
	elseif regw then
		local function register_on_set(rsel, new_reg_val)
			self:reg_on_set(regw, new_reg_val)
		end
		local compbox = regw.compbox
		local comp_def = compbox and compbox.comp_def
		local comp_regdefs = comp_def and comp_def.registers
		local regdef = comp_regdefs and comp_regdefs[regw.compidx]
		if regdef and regdef.click_action and regw.comp and not Input.IsControlDown() then
			comp_def:action_click(regw.comp, regw)
		else
			local rsel = ShowRegisterSelection(regw, register_on_set, nil, nil, { comp_def = comp_def, register_def = regdef })
			if rsel then rsel:SetRegister({ id = regw.def_id, num = regw.num, entity = regw.entity, coord = regw.coord }) end
		end
	end
end

function FrameViewMulti:reg_on_set(regw, new_reg_val)
	if regw.frameidx then
		Action.SendForSelectedEntities("SetRegister", { idx = regw.frameidx, reg = new_reg_val })
	else -- component
		local idx, vreg = regw.compidx, Tool.NewRegisterObject(new_reg_val)
		for _,comp in ipairs(regw.compbox.comps) do
			local creg = comp:GetRegister(idx)
			if vreg ~= creg then
				Action.SendForSelectedEntities("SetRegister", { idx = idx, reg = new_reg_val, comp = comp })
			end
		end
	end
end

function FrameViewMulti:link_on_drag_start(payload, is_click_drag)
	if is_click_drag then return end

	UI.PlaySound("fx_ui_ELEMENT_DRAG")

	-- start line drawing
	self.dragsource = payload
	self.links.on_draw = function(draw) self:UpdateLinks(draw) end
	return UI.New("Spacer") -- empty drag visual
end

function FrameViewMulti:link_on_drag_cancel(payload, visual, drag_was_aborted, a, b, c)
	if not self.dragsource then return end
	self.dragsource = nil
	if drag_was_aborted then return end -- drag aborted by pressing right-click
	if UI.IsMouseOverUI() then return end
	if payload.read_only then return Notification.Error("Can't set a read-only register") end

	local firstent, hover_entity = self.all_entities[1], View.GetHoveredEntity()
	if hover_entity and not Input.IsAltDown() then
		if LocationBlockedByBlight(hover_entity, "cannot lock on to target inside the blight", firstent) then return end
		self:reg_on_set(payload, { entity = hover_entity })
	else
		local x, y = View.GetHoveredTilePosition()
		local coord = { x, y }
		if LocationBlockedByBlight(coord, "cannot lock on to target inside the blight", firstent) then return end
		self:reg_on_set(payload, { coord = coord })
	end
end

function FrameViewMulti:UpdateLinks(draw)
	draw:Reset()
	local source = self.dragsource
	if not source then draw.on_draw = nil return end

	local tx, ty = UI.GetMousePosition(draw)
	local sreg = source
	if sreg then
		local sx, sy = sreg:GetViewportPosition(draw)
		sx = sx + (REG_WIDTH / 2)

		for pass=1,2 do
			local col = (pass == 1 and "#44EE" or "white")
			local thick = (pass == 1 and 2.0 or 0.0)
			draw:AddTriangle(sx, sy, 12.5+thick, 180, col)
			draw:AddTriangle(tx - 1, ty, 8.5+thick, 180, col)
			draw:AddBezierCurve(sx, sy, sx, sy - 100, tx, ty + 100, tx, ty, col, 3+thick)
		end
	end
end

function UIMsg.OnEntitySelected(entities)
	local old_open_frame_view = open_frame_view
	if open_frame_view then
		open_frame_view:RemoveFromParent()
		open_frame_view = nil
	end

	if entities and #entities > 0 then
		if #entities == 1 then
			local entity = entities[1]
			local entity_faction, player_faction = entity.faction, Game.GetLocalPlayerFaction()
			if entity_faction == player_faction or entity_faction:GetTrust(player_faction) == "ALLY" then
				if entity.is_construction then
					if entity:CountComponents("c_construction", true) > 0 then
						open_frame_view = UI.AddLayout("FrameviewConstruction", { entity = entity })
					else
						open_frame_view = UI.AddLayout("FrameviewDeployment", { entity = entity })
					end
				else
					open_frame_view = UI.AddLayout("FrameView", { entity = entity })
				end
			elseif IsDroppedItem(entity) then
				open_frame_view = UI.AddLayout(layout_droppeditem_view, { entity = entity })
			elseif IsExplorable(entity) then
				open_frame_view = UI.AddLayout("FrameViewExplorable", { entity = entity })
			else --if not entity_faction.is_world_faction then
				open_frame_view = UI.AddLayout("FrameViewOtherFaction", { entity = entity })
			end
		else
			open_frame_view = UI.AddLayout("FrameviewMulti", { all_entities = entities })
		end
	end

	if open_frame_view then
		UI.PlaySound("fx_ui_WINDOW_INFO_POPUP")
	elseif old_open_frame_view then
		UI.PlaySound("fx_ui_WINDOW_INFO_POPOUT")
	end
end

function UIMsg.OnEntityRecreate(old_entity, new_entity)
	if not open_frame_view then return end
	if open_frame_view.entity == old_entity then View.SelectEntities(new_entity) return end
	local entities = open_frame_view.all_entities or View.GetSelectedEntities()
	if not entities then return end
	local updated
	for i,e in ipairs(entities) do if e == old_entity then entities[i], updated = new_entity, true end end
	if updated then View.SelectEntities(entities) end
end

function UIMsg.OnViewportResize(w, h)
	if open_frame_view and open_frame_view.on_viewport_resize then open_frame_view:on_viewport_resize() end
end

function UIMsg.OnOverlayChanged(modetbl)
	show_visibility_range = modetbl.ranges and modetbl.ranges.visibility or nil
	show_power_range = modetbl.ranges and modetbl.ranges.power or nil
end

function CursorChooseEntity(msg, on_select, on_abort, reg_idx, include_foundations)
	if reg_idx and open_frame_view and open_frame_view.regs then
		local link_editor = open_frame_view.link_editor
		local reg = (link_editor and link_editor.regs or open_frame_view.regs)[reg_idx]
		if reg then
			open_frame_view.dragsource = reg
			open_frame_view.links.on_draw = function(draw) open_frame_view:UpdateLinks(draw) end
		end
	end
	View.StartCursorChooseEntity(
		function(target) -- success
			if reg_idx and open_frame_view then open_frame_view.dragsource = nil end
			View.StopCursor()
			Notification.Warning(L("Selected %s", (target and (target.visual_def.explorable_name or target.def.name) or "None")))
			if on_select(target) == false and on_abort then on_abort() end
		end,
		function() -- abort
			if reg_idx and open_frame_view then open_frame_view.dragsource = nil end
			Notification.Warning("Aborted")
			if on_abort then on_abort() end
		end,
		include_foundations)
	Notification.Warning(msg)
end

local function IsBuiltNonMoving(entity)
	local d = GetBuiltFrameDef(entity)
	return d and (d.movement_speed or 0) == 0
end

function Frameview_OpenContextMenu(entity_or_entities, open_above, focused_entity)
	if type(entity_or_entities) == "table" then -- show menu for multiple entities
		local entities, player_faction, relocatable, duplicatable, deconstructable, has_nonmoving, has_focused = entity_or_entities, Game.GetLocalPlayerFaction(), 0, 0, 0
		for i,entity in ipairs(entities) do
			if entity.faction == player_faction and entity.is_placed then
				local deconstruct_err, is_construction, is_nonmoving, is_focused = CheckDeconstruct(entity), entity.is_construction, IsBuiltNonMoving(entity), entity == focused_entity
				local can_relocate    = is_nonmoving and not is_construction and (not deconstruct_err or not CheckDeconstruct(entity, nil, true))
				local can_duplicate   = is_nonmoving and not deconstruct_err
				local can_deconstruct = not deconstruct_err and not is_construction
				relocatable     = relocatable     + (can_relocate    and 1 or (is_focused and -9999999 or 0))
				duplicatable    = duplicatable    + (can_duplicate   and 1 or (is_focused and -9999999 or 0))
				deconstructable = deconstructable + (can_deconstruct and 1 or (is_focused and -9999999 or 0))
				has_nonmoving   = has_nonmoving or is_nonmoving
				has_focused     = has_focused or is_focused
				if has_focused and relocatable >= 1 and duplicatable >= 1 and deconstructable >= 1 then break end
			end
		end
		if not has_nonmoving or (relocatable < 1 and duplicatable < 1 and deconstructable < 1) then return end -- nothing to show a menu for
		UI.MenuPopup([[<Box padding=5><VerticalList>
				<Button text='Copy Settings (<Key action="UnitCopy"/>)' on_click={on_copy}/>
				<Button id=relocatebtn text="Relocate" on_click={on_relocate}/>
				<Button id=duplicatebtn text="Duplicate" on_click={on_duplicate}/>
				<Button id=deconstructbtn text="Deconstruct" on_click={on_deconstruct}/>
			</VerticalList></Box>]], {
			construct = function(menu)
				menu.relocatebtn.hidden = relocatable < 1
				menu.duplicatebtn.hidden = duplicatable < 1
				menu.deconstructbtn.hidden = deconstructable < 1
			end,
			update = function(menu)
				for i,entity in ipairs(entities) do if not entity.exists then UI.CloseMenuPopup() Frameview_OpenContextMenu(entity_or_entities, open_above, focused_entity) break end end
			end,
			on_copy = function(menu, b)
				UI.CloseMenuPopup()
				UnitCopyPaste.Copy(entities)
			end,
			on_deconstruct = function(menu, b)
				UI.CloseMenuPopup()
				local list = {}
				for _,entity in ipairs(entities) do
					if entity.faction == player_faction and entity.is_placed and not entity.is_construction and not CheckDeconstruct(entity) then list[#list+1] = entity end
				end
				ConfirmBox(L("Are you sure you want to deconstruct %d unit(s) or building(s)?", #list), function() Action.SendForEntities("Deconstruct", list) end)
			end,
			on_relocate = function(menu, b)
				UI.CloseMenuPopup()
				StartRelocateCursor(entities)
			end,
			on_duplicate = function(menu, b)
				UI.CloseMenuPopup()
				local list = {}
				for _,entity in ipairs(entities) do
					if entity.faction == player_faction and entity.is_placed and IsBuiltNonMoving(entity) and not CheckDeconstruct(entity) then list[#list+1] = entity end
				end
				local bp = MakeBlueprintFromEntity(#list > 1 and list or list[1], true, false, true)
				if not bp then return Notification.Warning("Unable to copy settings") end
				StartBuildCursor(bp, #list > 1 and 0 or list[1].rotation)
			end,
		}, open_above, open_above and "UP" or "DOWN")
		return
	end

	local entity = entity_or_entities
	UI.MenuPopup([[<Box padding=5><VerticalList>
			<Button id=editbtn text="Edit" on_click={on_edit}/>
			<Button id=camerabtn text="Center Camera" on_click={on_camera}/>
			<Button id=ordersbtn text="Show Orders" on_click={on_orders}/>
			<Button id=rotatebtn text='Rotate Building (<Key action="RotateConstructionSite"/>)' on_click={on_rotate}/>
			<Button id=copybtn text='Copy Settings (<Key action="UnitCopy"/>)' on_click={on_copy}/>
			<Button id=pastebtn text='Paste Settings (<Key action="UnitPaste"/>)' on_click={on_paste}/>
			<Button id=upgradebtn text='Upgrade with Copied Settings' on_click={on_upgrade}/>
			<Button id=addbehaviorbtn text='Set Integrated Behavior' hidden=true on_click={on_click_add_behavior}/>
			<Button id=removebehaviorbtn text='Remove Integrated Behavior' hidden=true on_click={on_click_remove_behavior}/>
			<Button id=gotobtn text="Select Goto Targets" entities_field=goto_entities on_click={on_select}/>
			<Button id=storebtn text="Select Store Targets" entities_field=store_entities on_click={on_select}/>
			<Button id=eggbtn text="Select Sending Time Eggs" entities_field=egg_entities on_click={on_select}/>
			<Button id=garagebtn text="Select Dock" on_click={on_garage}/>
			<Button id=relocatebtn text="Relocate" on_click={on_relocate}/>
			<Button id=duplicatebtn text="Duplicate" on_click={on_duplicate}/>
			<Button id=deconstructbtn text="Deconstruct" on_click={on_deconstruct}/>
		</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			local faction, is_construction, is_placed, is_on_map, is_docked = entity.faction, entity.is_construction, entity.is_placed, entity.is_on_map, entity.is_docked
			local clipboard_bp = UnitCopyPaste.GetItem('B')
			local deconstruct_err = CheckDeconstruct(entity)
			local upgrade_err = not clipboard_bp or deconstruct_err or CheckDeconstruct(entity, clipboard_bp.frame)
			local can_rotate = not IsBot(entity) and is_placed
			local can_relocate = can_rotate and not is_construction and (not deconstruct_err or not CheckDeconstruct(entity, nil, true))
			local frame_def = entity.def
			local can_have_integrated_behavior = not frame_def.type and frame_def.race == "robot" and not frame_def.no_integrated_behavior
			local have_integrated_behavior = can_have_integrated_behavior and entity:CountComponents("c_integrated_behavior") > 0
			local have_eggs
			if frame_def.id == "f_alien_time_egg" then
				local eggs = {}
				menu.egg_entities = eggs
				for _,e in ipairs(faction:GetEntitiesWithId("f_alien_time_egg")) do
					if e:FindComponent("c_time_egg_transference"):GetRegisterEntity(1) == entity then
						eggs[#eggs+1] = e
					end
				end
				have_eggs = #eggs > 0
			end
			menu.hash = Tool.Hash(faction, is_construction, is_placed, is_on_map, is_docked)
			menu.camerabtn.hidden = not is_on_map
			menu.ordersbtn.hidden = faction:GetNumActiveOrders(entity) == 0
			menu.rotatebtn.hidden = not can_rotate
			menu.editbtn.hidden = is_construction and (entity:CountComponents("c_construction") == 0 or GetBuiltFrameDef(entity).type == "Foundation")
			menu.pastebtn.hidden = not clipboard_bp
			menu.upgradebtn.hidden = upgrade_err ~= nil
			menu.removebehaviorbtn.hidden = not can_have_integrated_behavior or not have_integrated_behavior
			menu.addbehaviorbtn.hidden = not can_have_integrated_behavior or have_integrated_behavior
			menu.goto_entities = faction:GetEntitiesWithRegister(FRAMEREG_GOTO, entity)
			menu.gotobtn.hidden = #menu.goto_entities == 0
			menu.gotobtn.text = L("%s (%d)", menu.gotobtn.text, #menu.goto_entities)
			menu.store_entities = faction:GetEntitiesWithRegister(FRAMEREG_STORE, entity)
			menu.storebtn.hidden = #menu.store_entities == 0
			menu.storebtn.text = L("%s (%d)", menu.storebtn.text, #menu.store_entities)
			menu.eggbtn.hidden = not have_eggs
			menu.garagebtn.hidden = not is_docked
			menu.relocatebtn.hidden = not can_relocate
			menu.duplicatebtn.hidden = deconstruct_err ~= nil or not IsBuiltNonMoving(entity)
			menu.deconstructbtn.hidden = deconstruct_err ~= nil or is_construction
		end,
		update = function(menu)
			if not entity.exists then return UI.CloseMenuPopup() end
			if menu.hash ~= Tool.Hash(entity.faction, entity.is_construction, entity.is_placed, entity.is_on_map, entity.is_docked) then UI.CloseMenuPopup() Frameview_OpenContextMenu(entity, open_above, focused_entity) end
		end,
		on_edit = function()
			UI.CloseMenuPopup()
			StartCustomConstruction(entity)
		end,
		on_camera = function()
			UI.CloseMenuPopup()
			View.JumpCameraToEntities(entity)
		end,
		on_orders = function()
			OpenMainWindow("Faction", { show_entity_orders = true })
		end,
		on_rotate = function()
			if entity.is_construction then
				Action.SendForConstruction("RotateEntityConstruction", entity, { reverse = Input.IsShiftDown() or nil })
			else
				Action.SendForEntity("RotateEntity", entity, { reverse = Input.IsShiftDown() or nil })
			end
		end,
		on_copy = function()
			UI.CloseMenuPopup()
			UnitCopyPaste.Copy(entity)
		end,
		on_paste = function(menu)
			UI.CloseMenuPopup(menu)
			UnitCopyPaste.Paste({entity})
		end,
		on_upgrade = function(menu)
			UI.CloseMenuPopup(menu)
			UnitCopyPaste.Upgrade(entity)
		end,
		on_click_add_behavior = function(menu, btnselect)
			UILibrarySelect(btnselect, 'C',
				function(item) Action.SendForEntity("Behavior", entity, { add_integrated = true, set_id = item.id, debug = "STOP" }) UI.CloseMenuPopup() end, -- select
				nil, -- no clear option
				function(folder) Action.SendForEntity("Behavior", entity, { folder = folder, add_integrated = true, create = true }) UI.CloseMenuPopup() end, -- create
				nil, 'c_integrated_behavior')
		end,
		on_click_remove_behavior = function()
			Action.SendForEntity("Behavior", entity, { remove_integrated = true })
			UI.CloseMenuPopup()
		end,
		on_select = function(menu, b)
			UI.CloseMenuPopup()
			View.SelectEntities(menu[b.entities_field])
		end,
		on_garage = function(menu, b)
			UI.CloseMenuPopup()
			View.SelectEntities(entity.docked_garage)
		end,
		on_deconstruct = function(menu, b)
			ConfirmBox("Are you sure you want to deconstruct this unit or building?", function() Action.SendForEntity("Deconstruct", entity) end)
		end,
		on_relocate = function(menu, b)
			UI.CloseMenuPopup()
			StartRelocateCursor(entity)
		end,
		on_duplicate = function(menu, b)
			UI.CloseMenuPopup()
			local bp = MakeBlueprintFromEntity(entity, true, false, true)
			if not bp then return Notification.Warning("Unable to copy settings") end
			StartBuildCursor(bp, entity.rotation)
		end,
	}, open_above, open_above and "UP" or "DOWN")
end

function FrameView_BlockGotoAction(args)
	if not open_frame_view or not open_frame_view.explorable_window or not open_frame_view.explorable_window:has_other_players_interacting() then return end
	ConfirmBox("Another player in your faction is also viewing this explorable, are you sure you want to end the interaction and close the window?", function()
		if not open_frame_view or not open_frame_view.explorable_window then return end
		Action.SendForLocalFaction("Goto", args)
	end)
	return true
end

Input.BindAction("QuickAction", "Released", function()
	local local_faction = Game.GetLocalPlayerFaction()
	local hovered = View.GetHoveredEntity()
	local entity = View.GetSelectedEntity() or hovered
	if Input.IsShiftDown() then
		local widget = UI.FindWidgetWithProperty("id", "action_connect")
		if hovered and not widget then
			if hovered.faction ~= local_faction then
				Notification.Warning("Hovered unit or building is not yours")
			else
				ShowLogisticsSettings(nil, entity)
			end
		elseif entity and entity.faction == local_faction then
			ShowLogisticsSettings(widget, entity, View.GetSelectedEntities())
		end
	elseif Input.IsControlDown() then
		if hovered then
			if hovered.faction ~= local_faction then
				Notification.Warning("Hovered unit is not yours")
			elseif hovered.is_construction then
				Action.SendForConstruction("SetConstructionPause", hovered, { val = not hovered.powered_down })
			else
				Action.SendForEntity("SetPowerDown", hovered, { val = not hovered.powered_down })
			end
		elseif open_frame_view and open_frame_view.infobox then
			open_frame_view.infobox:toggle_power()
		elseif entity and entity.faction == local_faction then
			Action.SendForSelectedEntities("SetPowerDown", { val = not entity.powered_down })
		end
	elseif open_frame_view and open_frame_view.entity and open_frame_view.toggle_side then
		open_frame_view:toggle_side(open_frame_view.linkedbtn)
	elseif hovered and hovered.faction == local_faction and not hovered.is_construction and hovered.register_count > 0 then
		UI.MenuPopup("LinkEditor", { entity = hovered, }, nil, "RIGHT", "BOTTOM")
	else
		UI.CloseMenuPopup()
	end
end)

Input.BindAction("RotateConstructionSite", "Released", function()
	UI.PlaySound("fx_ui_BUILD_ADD_ROTATE")
	if View.InConstructionMode() then
		TransformConstructionCursor()
	elseif open_frame_view and open_frame_view.hovering_component then
		local comp = open_frame_view.hovering_component
		if comp and comp.exists then
			Action.SendForEntity("RotateComponent", comp.owner, { comp = comp, reverse = Input.IsShiftDown() or nil })
		end
	else
		local hover_entity = View.GetHoveredEntity()
		if hover_entity then
			local hover_faction, hover_def = hover_entity.faction, hover_entity.def
			if hover_faction == Game.GetLocalPlayerFaction() and (hover_def.movement_speed or 0) == 0 and hover_def.type ~= "Wall" then
				if hover_entity.is_construction then
					Action.SendForConstruction("RotateEntityConstruction", hover_entity, { reverse = Input.IsShiftDown() or nil })
				else
					Action.SendForEntity("RotateEntity", hover_entity, { reverse = Input.IsShiftDown() or nil })
				end
			end
		end
	end
end)

Input.BindAction("Relocate", "Released", function()
	local hover = View.GetHoveredEntity()
	StartRelocateCursor(hover and not View.IsSelectedEntity(hover) and { hover } or View.GetSelectedEntities())
end)
