local Reg_layout<const> = [[
	<Canvas width=56 height=56 show_race_bg=true clip=true>
		<Image id=base dock=fill hide_no_image=true/>
		<Image id=image dock=fill hide_no_image=true/>
		<Box id=numbox dock=bottom-left margin_left=1 margin_bottom=1 blocking=false bg=label_left color=ui_bg>
			<Text id=numtxt size=10 margin_left=3 margin_right=4 margin_bottom=1/>
		</Box>
	</Canvas>
]]

local RegNoNum_layout<const> = [[
	<Canvas width=56 height=56>
		<Image id=base dock=fill hide_no_image=true/>
		<Image id=image dock=fill hide_no_image=true/>
	</Canvas>
]]

local MiniReg_layout<const> = [[
	<Canvas width=36 height=36>
		<Image id=base dock=fill hide_no_image=true/>
		<Image id=image dock=fill margin=2 hide_no_image=true/>
		<Box id=numbox dock=bottom-left margin_left=1 margin_bottom=1 blocking=false bg=label_left color=ui_bg>
			<Text id=numtxt size=8 margin_left=2 margin_right=3/>
		</Box>
	</Canvas>
]]

local Reg = {}
UI.Register("Reg", Reg_layout, Reg)
UI.Register("MiniReg", MiniReg_layout, Reg)
UI.Register("RegNoNum", RegNoNum_layout, Reg)

function Reg:construct()
	if self.reg_index then
		local comp = self.comp
		if comp then
			local reg_defs = comp.def.registers
			local reg_def = reg_defs and reg_defs[self.reg_index]
			if reg_def then
				if reg_def.read_only then self.read_only = true end
				if reg_def.ui_icon then self.ui_icon = reg_def.ui_icon end
				if reg_def.click_action then self.click_action = reg_def.click_action end
				if reg_def.type == "production" then self.is_production = true end
			end
			self.ent = comp.owner
			self.abs_index = self.reg_index + comp.register_index - 1
		elseif self.ent then
			self.abs_index = self.reg_index
		else
			print("<Reg> missing comp or ent parameter")
		end
		self.render = nil
	else
		if self.update == Reg.update then
			self.update = nil
		end
		if self.on_mouse_wheel == Reg.on_mouse_wheel and (not self.on_set or self.read_only) then
			self.on_mouse_wheel = nil
		end
		if self.on_click == Reg.on_click then
			self.read_only = true
		end
	end

	if self.bg == nil then
		self.base.image = self.read_only and "reg_base_ro" or "reg_base"
	elseif self.bg ~= false then
		self.base.image = self.bg
	else
		local numbox = self.numbox
		if numbox then numbox.bg = false self.numtxt.style = "outline" end
	end

	self.image.image = self.ui_icon
	self.image.color = "ui_light"

	if self.no_interact then
		self.on_click = nil
		self.on_mouse_wheel = nil
		self.on_mouse_enter = nil
		self.on_mouse_leave = nil
		self.tooltip = nil
	elseif self.no_modify then
		self.on_click = nil
		self.on_mouse_wheel = nil
	end
end

function Reg:ChangeSource(entity, comp, reg_index)
	self.ent                = entity
	self.reg_index          = entity and reg_index
	self.abs_index          = entity and reg_index + (comp and (comp.register_index - 1) or 0)
	self.update             = entity and Reg.update
	self.on_mouse_wheel     = entity and Reg.on_mouse_wheel
	self.on_click           = entity and Reg.on_click
	self.comp               = comp
	self.render             = not entity and Reg.render
	self.read_only          = not entity
	self.hash               = nil
	if self.background then self.background.color   = "white" end
end

function Reg:SetNum(n)
	local numbox = self.numbox
	if not numbox then return end
	if not n or n == "" then
		local no_num_txt = self.no_num_txt
		if no_num_txt then
			numbox.hidden = false
			self.numtxt.text = no_num_txt
			return
		end
		numbox.hidden = true
	else
		numbox.hidden = false
		self.numtxt.text = (n == REG_INFINITE and "∞") or (n == REG_NOT and "≠") or tostring(n)
	end
end

function Reg:SetCoord(coord)
	local coordbox = self.coordbox
	if coord then
		if not coordbox then
			coordbox = self:Add("<Box dock=top-right x=-2 y=2 padding=2 blocking=false bg=label_left color=ui_bg><Text size=10 textalign=right/></Box>")
			self.coordbox = coordbox
		else
			self.coordbox.hidden = false
		end
		coordbox[1].text = coord.x .. "\n" .. coord.y
	elseif coordbox then
		self.coordbox.hidden = true
	end
end

function Reg:render()
	local img, def, entity = self.icon, self.def
	if not img then
		entity = self.entity
		def = def or data.all[self.def_id]
		img = def and def.texture or (entity and entity.exists and entity.def.texture)
	end
	if not img and self.ui_icon then
		self.image.image = self.ui_icon
		self.image.color = "ui_light"
	else
		self.image.image = img
		self.image.color = "white"
	end
	if self.bg == nil then
		self.base.image = self.read_only and "reg_base_ro" or (entity and "reg_entity" or "reg_base")
	elseif self.bg ~= false then
		self.base.image = self.bg
	end
	self:SetNum(self.num)
	self:SetCoord(self.coord)
	if self.show_race_bg then
		self:SetRaceBg((self.show_blueprint_bg and "blueprint_bg") or (def and def.race and GetComponentRaceBG(def.race)))
	end
end

function Reg:on_mouse_wheel(wheel)
	if self.read_only then return end
	local ctrl, shift = Input.IsControlDown(), Input.IsShiftDown()
	local change = (wheel > 0 and 1 or -1) * (ctrl and 10 or 1) * (shift and 5 or 1)
	local n = math.max(math.max(self.num or 0, -1) + change, -1)
	if n < 0 then n = REG_INFINITE end
	if n == self.num then return end
	UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_INCREMENT")
	self:SendSet({ id = self.def_id, entity = self.entity, coord = self.coord, num = n }, false)
end

function Reg:SetRaceBg(racebg)
	local img = self.racebg
	if not img and not racebg then return end
	if not img then
		img = self:Add("<Image dock=fill hide_no_image=true/>")
		img.child_index = self.image.child_index
		self.racebg = img
	end
	img.image = racebg
end

local function ClickOnCoordOrEntity(regw, mousebtn, shift, ctrl, on_clear, no_append)
	if shift then
		local entity = regw.entity
		if entity and entity.exists then
			SelectEntity(entity, mousebtn, no_append)
		elseif regw.coord then
			View.PlayEffect("fx_ping", regw.coord.x, regw.coord.y)
			View.MoveCamera(regw.coord.x, regw.coord.y, false)
		end
	else
		if not ctrl and regw.entity and regw.entity.exists then
			UI.MenuPopup([[<Box padding=5><VerticalList>
						<Button text='Select Unit/Building (Shift+<key id="LEFTMOUSEBUTTON"/>)' on_click={on_select}/>
						<Button text='View Unit/Building (Shift+<key id="RIGHTMOUSEBUTTON"/>)' on_click={on_camera} hidden={unplaced}/>
						<Button text='Clear Value (Ctrl+<key id="RIGHTMOUSEBUTTON"/>)' on_click={on_clear} hidden={read_only}/>
					</VerticalList></Box>]], { read_only = regw.read_only, unplaced = not regw.entity.is_on_map,
				construct = function(menu) menu:TweenFromTo("sy", 0, 1, 100) end,
				on_select = function(menu) UI.CloseMenuPopup(menu) View.SelectEntities(regw.entity) end,
				on_camera = function(menu) UI.CloseMenuPopup(menu) View.JumpCameraToEntities(regw.entity) end,
				on_clear = function(menu)  UI.CloseMenuPopup(menu) on_clear() end,
			}, regw, "UP")
		elseif not ctrl and regw.coord then
			UI.MenuPopup([[<Box padding=5><VerticalList>
						<Button text='View Coordinate (Shift+<key id="RIGHTMOUSEBUTTON"/>)' on_click={on_camera}/>
						<Button text='Clear Value (Ctrl+<key id="RIGHTMOUSEBUTTON"/>)' on_click={on_clear} hidden={read_only}/>
					</VerticalList></Box>]], {
				construct = function(menu) menu:TweenFromTo("sy", 0, 1, 100) end, read_only = regw.read_only,
				on_camera = function(menu) UI.CloseMenuPopup(menu) View.MoveCamera(regw.coord.x, regw.coord.y, false) end,
				on_clear = function(menu)  UI.CloseMenuPopup(menu) on_clear() end,
			}, regw, "UP")
		else
			on_clear()
		end
	end
end

function Reg:on_click(mousebtn)
	local abs_index, ctrl, shift = self.abs_index, Input.IsControlDown(), Input.IsShiftDown()
	if self.click_action and mousebtn == "LEFTMOUSEBUTTON" and not ctrl and not shift then
		self.comp.def:action_click(self.comp, self)
	elseif self.read_only or shift then
		ClickOnCoordOrEntity(self, mousebtn, true, ctrl, nil, not self.read_only)
	elseif mousebtn == "RIGHTMOUSEBUTTON" then
		ClickOnCoordOrEntity(self, mousebtn, false, ctrl, function() self:SendSet(nil) end)
		self:on_mouse_leave()
	elseif (abs_index == -FRAMEREG_STORE or abs_index == -FRAMEREG_GOTO or self.queueicon) and not ctrl then
		self:ShowQueuePopup()
	elseif abs_index == -FRAMEREG_GOTO and not ctrl and self.on_drag_start then
		Notification.Warning("Select unit to set as Goto target")
		local visual = self:SendEvent("on_drag_start")
		UI.StartDrag(self, visual)
	else
		ShowRegisterSelection(self, self.ent, self.comp, self.reg_index)
	end
end

function Reg:tooltip()
	local comp = self.comp
	local comp_def = comp and self.reg_index and comp.def
	local warning = self.warning or (comp_def and comp:RegisterIsError(self.reg_index) and comp_def.get_reg_error and comp_def:get_reg_error(comp))

	if self.abs_index then
		local regval = self.ent:GetRegister(self.abs_index)
		local id, entity = regval.id, regval.entity
		local product_def, blueprint_def = GetProduction(id, comp, true)
		local def = blueprint_def or product_def or entity and entity.def
		local behavior_code = comp and comp.base_id == "c_behavior" and comp.has_extra_data and GetFactionBehaviorAsmById(comp.faction, comp.extra_data.main_id)
		behavior_code = behavior_code and behavior_code.code
		local behavior_pnames = behavior_code and behavior_code.pnames
		local regname = behavior_pnames and behavior_pnames[self.reg_index]

		if def then
			if not warning and comp_def and comp_def.registers then
				local regind = comp_def.registers[self.reg_index]
				warning = regind and regind.warning
			end
			return BuildDefinitionTooltip(def, { clearreg = not self.read_only or nil, entity = entity, warning = warning, regname = regname, reg_comp = comp })
		elseif regname then
			return regname
		end
	else
		local entity = self.entity
		local def = self.def_blueprint or self.def or data.all[self.def_id] or (entity and entity.def)
		if def then return BuildDefinitionTooltip(def, { clearreg = self.clearreg or nil, entity = entity, warning = warning }) end
	end

	-- empty
	if warning then
		return UI.New([[
			<Box bg=popup_box_bg padding=12>
				<VerticalList>
					<Canvas height=56 clip=true margin=-12 margin_bottom=4>
						<Image color="#5CEBA319" dock=fill/>
						<Image image=warning_pattern color="#60D4A2" dock=top-right/>
						<Image image=icon_warning color="#FFFF00" dock=left/>
						<Text wrap=true halign=fill valign=center margin_left=56 margin_right=12 text={txt}/>
					</Canvas>
					<Text text={empty_tooltip}/>
				</VerticalList>
			</Box>
		]], {
			txt = warning,
			empty_tooltip = self.empty_tooltip
		})
	end
	if self.empty_tooltip then return self.empty_tooltip end
end

function Reg:update()
	local comp, ent, abs_index, show_race_bg, wait = self.comp, self.ent, self.abs_index, self.show_race_bg, self.wait
	if not comp and not ent then return end
	if not (comp or ent).exists then return end
	local regval = ent:GetRegister(abs_index)
	if not regval then return end

	-- If the player modifies the register locally, wait with updating the register until all the players "SetRegister" actions have been executed
	if wait and not Action.HasPendingAction("SetRegister") then wait, self.wait = nil, nil end

	local entity, is_error, is_queue = regval.entity, regval.is_error, regval.is_queue
	local newhash = Tool.Hash(regval, entity) -- include entity in hash to update on entity destruction
	if newhash ~= self.hash and not wait then
		self.hash = newhash

		local id, num, is_empty, def = not entity and regval.id, regval.num, regval.is_empty
		local coord = not id and not entity and regval.coord

		local dropimgs, dropidx = self.dropimgs, 1
		if id then
			def = data.all[id]
			self.image.image = def and def.texture
			self.image.color = "white"
		elseif entity then
			local entity_def = entity.def
			self.image.image = entity_def.texture or (entity.is_construction and data.values.v_construction.texture)
			self.image.color = "white"

			if entity_def.type == "DroppedItem" then
				if not dropimgs then
					dropimgs = {
						self:Add("<Image margin=8 width=22 height=22 hide_no_image=true dock=top-left/>"),
						self:Add("<Image margin=8 width=22 height=22 hide_no_image=true dock=top-right/>"),
						self:Add("<Image margin=8 width=22 height=22 hide_no_image=true dock=bottom-left/>"),
						self:Add("<Image margin=8 width=22 height=22 hide_no_image=true dock=bottom-right/>"),
					}
					self.dropimgs = dropimgs
				end
				for _,v in ipairs(entity.slots) do
					if v.stack > 0 then
						local vtex = v.def.texture
						for i=1,dropidx-1 do if dropimgs[i].image == vtex then goto have_item end end
						dropimgs[dropidx].image = vtex
						dropidx = dropidx + 1
						if dropidx == 5 then break end
						::have_item::
					end
				end
			end
		else
			self.image.image = self.ui_icon
			self.image.color = "ui_light"
		end

		if dropimgs then
			for i=dropidx,4 do dropimgs[i].image = nil end
		end

		if self.bg == nil then
			self.base.image = self.read_only and (entity and "reg_entity_ro" or "reg_base_ro") or (entity and "reg_entity" or "reg_base")
		elseif self.bg ~= false then
			self.base.image = self.bg
		else
			local numbox = self.numbox
			if numbox then numbox.bg = false self.numtxt.style = "outline" end
		end

		self.icon = (id or entity) and self.image.image
		self.num = num
		self.def_id = id
		self.entity = entity
		self.coord = coord

		self:SetNum(not is_empty and num)
		self:SetCoord(coord)

		if show_race_bg then
			local racebg
			if comp then
				local product_def, blueprint_def = GetProduction(id, comp, true)
				if blueprint_def then racebg = "blueprint_bg" end
			end
			if not racebg then
				racebg = def and def.race and GetComponentRaceBG(def.race)
			end
			self:SetRaceBg(racebg)
		end
		self:SendEvent("on_change", regval)
	end

	if is_queue ~= (self.is_queue or false) then
		self.is_queue = is_queue
		local img = self.queueicon
		if not img and is_queue then
			self.queueicon = self:Add("<Box dock=top-left padding=-2 bg=popup_box_bg><Image image=icon_add width=16 height=16 color=ui_light/></Box>")
		elseif img and not is_queue then
			self.queueicon:RemoveFromParent()
			self.queueicon = nil
		end
	end

	if show_race_bg then
		local errimg = self.errimg
		if is_error or errimg then
			if not errimg then
				errimg = self:Add("<Image image=icon_small_warning color=yellow dock=bottom-right/>")
				self.errimg = errimg
			end
			errimg.hidden = not is_error
		end
	end
end

function Reg:on_mouse_enter()
	local regentity = self.entity
	if regentity and regentity.exists then
		View.HighlightEntity(regentity)
		self.hl = true
	elseif self.coord then
		View.PlayEffect("fx_ping", self.coord.x, self.coord.y)
	end

	if not self.read_only and self.on_click then
		local hoverimg = self.hoverimg
		if not hoverimg then
			hoverimg = self:Add("<Image image=reg_hover dock=fill hidden=false/>")
			self.hoverimg = hoverimg
		end
		hoverimg.hidden = false
	end
end

function Reg:on_mouse_leave()
	if self.hl then View.HighlightEntity(nil) self.hl = nil end

	local hoverimg = self.hoverimg
	if hoverimg then hoverimg.hidden = true end
end

function Reg:SendSet(reg, custom_blueprint)
	local ent, new_num, new_id, new_entity, new_coord = self.ent
	if not ent then
		self:SendEvent("on_set", reg)
	else
		if custom_blueprint ~= false then -- when set to false, keep any custom_blueprint already set
			Action.SendForEntity("SetRegister", self.ent, { idx = self.reg_index, comp = self.comp, reg = reg, custom_blueprint = custom_blueprint })
		else
			Action.SendForEntity("SetRegister", self.ent, { idx = self.abs_index, reg = reg })
		end
		self.wait = true -- wait until the action is processed to avoid UI flicker
		self.hash = false -- force next update to catch the register changing separately in the same tick
	end

	if reg then new_num, new_id, new_entity, new_coord = reg.num, reg.id, reg.entity, reg.coord end
	if not new_num and (new_id or new_entity or new_coord) then new_num = 0 end
	if self.num ~= new_num or (new_num and self.numbox and self.numbox.hidden) then
		self.num = new_num
		self:SetNum(new_num)
	end
	if self.def_id ~= new_id or self.entity ~= new_entity or self.coord ~= new_coord then
		if self.coord ~= new_coord then self:SetCoord(new_coord) end
		self.def_id, self.entity, self.coord = new_id, new_entity, new_coord
		if new_id then
			local def = data.all[new_id]
			self.image.image = def and def.texture
			self.image.color = "white"
		elseif new_entity then
			self.image.image = new_entity.def.texture or (new_entity.is_construction and data.values.v_construction.texture)
			self.image.color = "white"
		else
			self.image.image = self.ui_icon
			self.image.color = "ui_light"
		end
		if self.bg == nil then self.base.image = new_entity and "reg_entity" or "reg_base" end
	end
end

function Reg:ShowQueuePopup()
	local entity, abs_index =  self.ent, self.abs_index
	UI.MenuPopup([[
		<Box padding=14 blur=true>
			<VerticalList min_width=200>
				<Text text={title} textalign=center margin_bottom=14/>
				<HorizontalList><Button on_click={add} on_drag_cancel={assign} width=56 height=56 valign=top icon=icon_new tooltip={addtt}/><Wrap wrapsize=500 id=lst/></HorizontalList>
			</VerticalList>
		</Box>
	]], {
		construct = function(w)
			w.title = (entity.logistics_transport_route and (abs_index == -FRAMEREG_STORE and "Transport Route Targets" or "Transport Route Sources") or (abs_index == -FRAMEREG_STORE and "Store Targets" or "Goto Queue"))
			w.addtt = L("Add to %s", w.title)
			UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
		end,
		update = function(w)
			local arr = entity:RegisterQueueGetAll(abs_index)
			local hash = Tool.Hash(arr)
			if hash == w.hash then return end
			w.hash = hash
			w.lst:Clear()
			for i,v in ipairs(arr or {}) do
				if i > 1 or not v.is_empty then
					w.lst:Add("<Reg on_click={add} on_drag_cancel={assign} on_set={set}/>", { queue_idx = i, def_id = v.id, entity = v.entity, coord = v.coord, num = v.num })
				end
			end
		end,
		add = function(w, reg, mousebtn, forceadd)
			local ctrl, shift = Input.IsControlDown(), Input.IsShiftDown()
			if forceadd or (not ctrl and not shift and mousebtn == "LEFTMOUSEBUTTON") then
				local msg = (abs_index == -FRAMEREG_GOTO and "Select target to set as Goto") or (abs_index == -FRAMEREG_STORE and "Select target to set as Store") or "Select the object on the map"
				Notification.Warning(msg)
				UI.StartDrag(reg, UI.New("<Image image=icon_add/>")) -- use drag to keep popup open on next click
			elseif ctrl and mousebtn == "LEFTMOUSEBUTTON" then
				local rsel = ShowRegisterSelection(reg, function(rsel, new_reg_val) w:set(reg, new_reg_val) end)
				if rsel then rsel:SetRegister({ id = reg.def_id, entity = reg.entity, coord = reg.coord, num = reg.num }) end
			elseif reg.queue_idx then
				ClickOnCoordOrEntity(reg, mousebtn, shift, ctrl, function() w:set(reg) end)
			end
		end,
		set = function(w, reg, new_reg_val)
			local queue_idx, multi = reg.queue_idx, #w.lst > 0
			if new_reg_val and next(new_reg_val) then
				Action.SendForEntity("SetQueue", entity, { idx = abs_index, set_idx = (queue_idx and (queue_idx > 1 or multi) and queue_idx or nil), reg = new_reg_val })
			elseif queue_idx then
				reg:RemoveFromParent()
				Action.SendForEntity("SetQueue", entity, { idx = abs_index, remove_idx = reg.queue_idx })
			end
		end,
		assign = function(w, reg, visual, drag_was_aborted)
			if not w:IsValid() then return end
			local target, x, y = View.GetHoveredEntity(), View.GetHoveredTilePosition()
			local need_faction_target = (abs_index == -FRAMEREG_STORE) or (abs_index == -FRAMEREG_GOTO and entity.logistics_transport_route)
			if need_faction_target and (not target or not target:ExistsOnFaction(entity) or target == entity) then drag_was_aborted = true end
			if drag_was_aborted or UI.IsMouseOverUI() then Notification.Warning("Aborted") return end
			Notification.Warning(target and L("Selected %s", target.visual_def.explorable_name or target.def.name or "") or L("Selected %d, %d", x, y))
			local newreg = (target and { entity = target } or { coord = { x = x, y = y }})
			local newobj = Tool.NewRegisterObject(newreg)
			for i,v in ipairs(entity:RegisterQueueGetAll(abs_index)) do if v == newobj then return end end -- no duplicates
			local queue_idx, multi = reg.queue_idx, #w.lst > 0
			Action.SendForEntity("SetQueue", entity, { idx = abs_index, set_idx = (queue_idx and (queue_idx > 1 or multi) and queue_idx or nil), reg = newreg })
			if not queue_idx and Input.IsShiftDown() then w:add(reg, nil, true) end -- add another store
		end,
	}, self, "UP")
end

function Reg:on_clipboard_copy()
	Notification.Warning("Copied register value")
	if self.abs_index then
		local r, blueprint_def = self.ent:GetRegister(self.abs_index), self.is_production and select(2, GetProduction(self.def_id, self.comp, true))
		if blueprint_def then
			local bp = PackLibraryItemToCompactedItem(self.ent, blueprint_def, 'B')
			if r.num ~= 1 then bp.num = r.num end -- store number in special 'num' field
			return bp, 'B'
		end
		return r.is_empty and {} or { id = r.id, entity = r.entity, num = r.num, coord = r.coord }, 'R'
	else
		return { id = self.def_id or (self.def and self.def.id) or nil, entity = self.entity, num = self.num, coord = self.coord }, 'R'
	end
end

function Reg:on_clipboard_paste(table, prefix)
	local ent = self.reg_index and self.ent
	if self.read_only or not (ent or self.on_set) then
		Notification.Error("Can't set a read-only register")
	elseif prefix == 'R' then
		self:SendSet(Tool.Copy(table))
		Notification.Warning("Applied register value")
	elseif prefix == 'B' then
		local comp, frame_def, num = self.comp, data.frames[table.frame], table.num
		local reg, production_recipe = { id = table.frame, num = num or 1 }, self.is_production and frame_def and frame_def.production_recipe
		if comp and production_recipe and production_recipe.producers[comp.id] and FactionHasUnlockedCustomBlueprint(Game.GetLocalPlayerFaction(), table) then
			UILibraryImportBlueprint(table, function(res)
				if self:IsValid() then UILibraryAssignBlueprintParams(res, function(bpp)
					if self:IsValid() then self:SendSet(reg, bpp) end
				end) end
			end)
		elseif frame_def then
			self:SendSet(reg)
		end
		Notification.Warning("Applied register value")
	end
	return true -- always signify handled because we accept the 'B' prefix
end
