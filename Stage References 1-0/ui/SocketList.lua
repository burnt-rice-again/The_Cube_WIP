local SocketBox_layout<const> =
[[
	<Canvas dragtype=COMPONENT width=56 height=56>
		<Image id=race_img image=component_bg dock=fill/>
		<Image id=image dock=fill margin=3 hide_no_image=true/>
		<Box id=framebox bg=component_base dock=fill blocking=false>
			<Text id=sizetxt dock=bottom x=-16 y=-2/>
		</Box>
	</Canvas>
]]

local ComponentBlock_layout<const> =
[[
	<Box padding=5 margin_bottom=2>
		<HorizontalList child_align=top>
			<Canvas width=24 id=cnvs on_drop={cnvs_on_drop} tooltip={cnvs_tooltip}>
				<Image id=hlimg color=ui_bg width=22 height=56/>
				<Text id=sizetext textalign=center width=0 x=11 y=36/>
				<Image id=progressbg image="Main/skin/Assets/component_progress.png" width=20 height=20 x=1 y=2 color=#808080A0 hidden=true/>
				<ProgressCircle id=progress image="Main/skin/Assets/component_progress.png" width=20 height=20 x=1 y=2 hidden=true/>
			</Canvas>
			<SocketBox id=box entity={entity} socket={socket} socket_size={socket_size} halign=center margin_right=2/>
			<Wrap id=regs wrapsize=240 child_padding=4 valign=center/>
		</HorizontalList>
	</Box>
]]

local ComponentColumn_layout<const> =
[[
<VerticalList valign=bottom>
	<HorizontalList halign=right margin_bottom=4>
		<VerticalList id=regs valign=bottom child_padding=4/>
		<VerticalList id=regs2 valign=bottom child_padding=4/>
	</HorizontalList>
	<VerticalList halign=right id=customui child_padding=4 margin_bottom=4/>
	<Box padding=5>
		<HorizontalList child_align=top>
			<Canvas width=24 id=cnvs on_drop={cnvs_on_drop} tooltip={cnvs_tooltip}>
				<Image id=hlimg color=ui_bg width=22 height=56/>
				<Text id=sizetext textalign=center width=0 x=11 y=36/>
				<Image id=progressbg image="Main/skin/Assets/component_progress.png" width=20 height=20 x=1 y=2 color=#808080A0 hidden=true/>
				<ProgressCircle id=progress image="Main/skin/Assets/component_progress.png" width=20 height=20 x=1 y=2 hidden=true tooltip={progress_tooltip}/>
			</Canvas>
			<SocketBox id=box entity={entity} socket={socket} socket_size={socket_size} halign=center margin_right=2/>
		</HorizontalList>
	</Box>
</VerticalList>
]]

local ComponentBlock<const> = {}
UI.Register("ComponentBlock", ComponentBlock_layout, ComponentBlock)
UI.Register("ComponentColumn", ComponentColumn_layout, ComponentBlock)

function ComponentBlock:construct()
	local sz = self.socket_size
	if sz and sz ~= "Hidden" then
		self.sizetext.text = NOLOC(sz:sub(1, 1))
	end
end

function ComponentBlock:SetComp(comp)
	if comp then
		self.compname = comp.def.name
		self.compimg = comp.def.texture
	end
	self.comp = comp
	self.box:SetComp(comp)
end

function ComponentBlock:cnvs_tooltip(cnvs)
	local sz = self.socket_size
	if not sz or sz == "Hidden" then return "Integrated Component" end
	local header = not self.comp and not self.box.comp_def and "Empty Socket"
	local info = L(sz == "Internal" and "<desc>This socket only accepts </><bl>%s</><desc> sized Components</>" or "<desc>This socket only accepts components of size </><bl>%s</><desc> or smaller</>", sz)
	local dropdesc = self.on_drop and "Drag Component here to Equip"
	return L("<header>%s</>%S<bl>%s</>\n<desc>%s</>%S%s", header or "", header and "\n" or "", header and sz or L("%s Socket", sz), dropdesc or "", dropdesc and "\n" or "", info)
end

function ComponentBlock:progress_tooltip(prog)
	local comp = self.comp
	return comp and UI.New(data.tooltip_layout, {
		update = function(tt)
			local owner = comp.exists and comp.owner
			if owner and comp.is_working then
				local boost, raw_efficiency = comp.effective_boost, owner.efficiency or 0
				local efficiency = (raw_efficiency == 0 and 100 or raw_efficiency)
				local duration = ((comp.ticker_target * 100 + boost - 1) // boost * 100 + efficiency - 1) // efficiency
				tt.txt = L("%.1fs", ((1.0 - comp.interpolated_progress) * duration + .499) // 1 / TICKS_PER_SECOND)
			else
				UI.CloseTooltip()
			end
		end,
	})
end

function ComponentBlock:cnvs_on_drop(cnvs, payload, cursor)
	return self.box:on_drop(payload, cursor)
end

local SocketBox<const> = {}
UI.Register("SocketBox", SocketBox_layout, SocketBox)

local sockimg<const> = {
	Large    = "icon_l_socket",
	Medium   = "icon_m_socket",
	Small    = "icon_s_socket",
	Internal = "icon_i_socket",
}

function SocketBox:SetComp(comp)
	if comp and not comp.exists then comp = nil end
	self.comp = comp
	local comp_def = comp and comp.def
	if comp_def and comp_def.race then
		self.race_img.image = GetComponentRaceBG(comp_def.race)
	else
		self.race_img.image = 'component_bg'
	end
	self.comp_def = comp_def

	self.image.image = comp and comp_def.texture or sockimg[self.socket_size] or 'icon_component'
	self.image.color = comp and 'white' or 'ui_dark'
	self.framebox.hidden = not comp
	if self.progress then
		self.progress:RemoveFromParent()
		self.progress = nil
	end

	if comp and comp.is_hidden then
		self.framebox.hidden = true
	else
		local this_size = comp and comp_def.attachment_size or self.socket_size or " "
		self.sizetxt.text = NOLOC(this_size:sub(1, 1))
	end
end

function SocketBox:SetCompDef(comp_def)
	self.comp_def = comp_def
	if comp_def and comp_def.race then
		self.race_img.image = GetComponentRaceBG(comp_def.race)
	else
		self.race_img.image = 'component_bg'
	end

	self.image.image = comp_def and comp_def.texture or sockimg[self.socket_size] or 'icon_component'
	self.image.color = comp_def and 'white' or 'ui_dark'
	self.framebox.hidden = not comp_def
	if self.progress then
		self.progress:RemoveFromParent()
		self.progress = nil
	end

	local this_size = comp_def and comp_def.attachment_size or self.socket_size
	if (this_size or "Hidden") == "Hidden" then
		self.framebox.hidden = true
	else
		self.sizetxt.text = NOLOC(this_size:sub(1, 1))
	end
end

function SocketBox:tooltip()
	if self.comp then
		return BuildDefinitionTooltip(self.comp.def, { comp = self.comp })
	elseif self.comp_def then
		return BuildDefinitionTooltip(self.comp_def)
	else
		local info = L(self.socket_size == "Internal" and "<desc>This socket only accepts </><bl>%s</><desc> sized Components</>" or "<desc>This socket only accepts components of size </><bl>%s</><desc> or smaller</>", self.socket_size)
		return L("<header>%s</>\n<bl>%s</>\n<desc>%s</>\n%s", "Empty Socket", self.socket_size, "Drag Component here to Equip", info)
	end
end

function SocketBox:on_click()
	local comp = self.comp
	if not comp or not comp.exists or self.entity.faction ~= Game.GetLocalPlayerFaction() then return end

	if Input.IsControlDown() then
		-- unequip component
		local slot = not comp.is_hidden and comp.owner:GetFreeSlot(comp.id)
		if slot then
			Action.SendForEntity("CompToInv", comp.owner, { comp = comp, slot = slot })
		end
		return
	end

	UI.MenuPopup([[<Box padding=5><VerticalList>
			<Button id=action on_click={on_action}/>
			<Button id=rotate text='Rotate Component (<Key action="RotateConstructionSite"/>)' on_click={on_rotate}/>
			<Button id=drop text="Drop Component" on_click={on_drop}/>
			<Button id=unequip text="Unequip Component" on_click={on_unequip}/>
		</VerticalList></Box>]], {
		construct = function(menu)
			local comp_def, comp_slot_count = comp.def, comp.slot_count
			local tt = comp_def.action_tooltip
			menu:TweenFromTo("sy", 0, 1, 100)
			menu.action.hidden = not comp_def.action_click
			menu.action.text = tt and type(tt) == "function" and tt(comp_def, comp) or tt
			menu.drop.hidden = not IsBot(comp.owner) and not comp.owner.has_crane
			if self.socket_size == "Hidden" then
				menu.drop.hidden = true
				menu.unequip.hidden = true
				menu.rotate.hidden = true
				if menu.action.hidden then menu.hidden = true end
			elseif self.socket_size == "Internal" then
				menu.rotate.hidden = true
			end
		end,
		update = function(menu)
			if not comp.exists then return UI.CloseMenuPopup() end
			menu.unequip.disabled = comp.is_hidden or not comp.owner:GetFreeSlot(comp.id)
		end,
		on_action = function()
			UI.CloseMenuPopup()
			comp.def:action_click(comp, self)
		end,
		on_rotate = function()
			UI.CloseMenuPopup()
			Action.SendForEntity("RotateComponent", comp.owner, { comp = comp, reverse = Input.IsShiftDown() or nil })
		end,
		on_drop = function()
			UI.CloseMenuPopup()
			Action.SendForEntity("DropComponent", comp.owner, { comp = comp })
		end,
		on_unequip = function()
			UI.CloseMenuPopup()
			local slot = comp.owner:GetFreeSlot(comp.id)
			if slot then
				Action.SendForEntity("CompToInv", comp.owner, { comp = comp, slot = slot })
			end
		end,
	}, self)
end

function SocketBox:on_drag_start()
	local payload = self
	if self.comp and self.comp.is_hidden then return false end
	if not payload.comp or not payload.comp.exists then return false end
	if self.entity.faction ~= Game.GetLocalPlayerFaction() then return end
	UI.PlaySound("fx_ui_ELEMENT_DRAG")
	return UI.New("Reg", { icon = payload.image.image, bg=false})
end

function SocketBox:on_drag_cancel(visual, drag_was_aborted)
	local payload = self
	if not payload.comp or not payload.comp.exists or drag_was_aborted then return end
	if UI.IsMouseOverUI() then return end
	local hover_entity = View.GetHoveredEntity()
	if hover_entity == self.entity then return end
	if hover_entity and not IsDroppedItem(hover_entity) then
		ActionTransfer(hover_entity, payload.comp)
	elseif IsBot(self.entity) or self.entity.has_crane then
		local x, y = View.GetHoveredTilePosition()
		Action.SendForEntity("DropComponent", self.entity, { comp = payload.comp, x = x, y = y })
	else
		Notification.Error("Buildings cannot drop items directly")
	end
end

function SocketBox:on_drop(payload, cursor)
	local droppedon = self
	local entity, slot, comp = self.entity, payload.slot, payload.comp
	if not entity then return false end -- not a socket on a live entity
	if self.socket_size == "Hidden" then return false end -- not a equippable socket
	if not entity.exists then return end -- already destroyed
	if entity.faction ~= Game.GetLocalPlayerFaction() then return print("Cannot put onto non-owned faction") end

	if payload.dragtype == 'ITEM' and slot and slot.exists then
		if entity ~= slot.owner then
			ActionTransfer(entity, slot, cursor.num)
		else
			if not data.components[slot.id] then Notification.Error("item is not a component") return end
			if slot.unreserved_stack < 1 then Notification.Error("cannot equip reserved component") return end
			if not entity:CheckSocketSize(slot.id, droppedon.socket) then Notification.Error("Component doesn't fit into socket") return end
			local oldcomp = entity:GetComponent(droppedon.socket)
			if oldcomp then
				if slot.component == oldcomp then Notification.Error("Cannot unequip component into its own slot") return end
				if slot.locked and slot.def.id ~= oldcomp.id then Notification.Error("Cannot unequip component into a locked slot") return end
			end
			Action.SendForEntity("InvToComp", entity, { slot = slot, comp_index = droppedon.socket })
			UI.PlaySound("fx_ui_COMPONENT_EQUIP")
		end
	elseif payload.dragtype == "COMPONENT" and comp and comp.exists and comp ~= droppedon.comp then
		if entity ~= comp.owner then
			ActionTransfer(entity, comp)
		else
			if not droppedon.socket or not entity:CheckSocketSize(comp.id, droppedon.socket) then Notification.Error("Component doesn't fit into socket") return end
			Action.SendForEntity("SwapSockets", entity, { socket1 = comp.socket_index, socket2 = droppedon.socket })
			UI.PlaySound("fx_ui_COMPONENT_EQUIP")
		end
	else
		return false
	end
end

local SocketList = {}
UI.Register("SocketList", "<Wrap child_padding=3 wrapsize=756/>", SocketList)

function SocketList:construct()
	local entity = self.entity
	if not entity or not entity.exists then return end
	local sockets = entity.visual_def.sockets
	if sockets then
		for i,v in ipairs(sockets) do
			self:Add("SocketBox", { socket_size = v[2], entity=entity, socket=i }):SetComp(nil)
		end
	end
end

function SocketList:update()
	local entity = self.entity
	for i,v in ipairs(self) do
		local comp = entity:GetComponent(i)
		if v.comp ~= comp then
			v:SetComp(comp)
		end
	end
end
