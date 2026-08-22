local BlueprintEditor_layout<const> = [[
	<Canvas child_fill=true width=1000>
		<VerticalList>
			<Box bg=popup_additional_bg padding=6 id=bptitlerow>
				<HorizontalList child_padding=8 child_align=top height=72>
					<Image width=56 height=56 id=imgicon on_click={icon_on_click} on_drop={icon_on_drop} tooltip="Click to change icon"/>
					<VerticalList fill=true>
						<Text text={name} size=32 style=bl on_click={on_textedit} field=name tooltip="Click to rename"/>
						<Text text={desc} size=12 style=bl on_click={on_textedit} field=desc tooltip="Click to edit description" margin_left=4 height=19 clip=true/>
					</VerticalList>
				</HorizontalList>
			</Box>
			<HorizontalList margin=4>
				<VerticalList id=complist fill=true valign=bottom/>
				<Box padding=0 valign=top>
					<Preview id=preview width=410 height=410 valign=center rotate=true/>
				</Box>
			</HorizontalList>
			<HorizontalList child_padding=8 fill=true margin=4>
				<VerticalList child_padding=6 width=200>
					<HorizontalList child_padding=2>
						<InputText id=unitname fill=true height=27 on_change={on_unitname} textalign=left padding=3/>
						<Button id=optionbtn width=27 height=27 on_click={on_click_options} tooltip="Options" icon=icon_menu/>
					</HorizontalList>
					<Image id=frameimg on_click={on_change_frame} image={image} halign=center width=100 height=100/>
					<Button id=changeframe icon=icon_edit text="Change Type" on_click={on_change_frame} height=34/>
				</VerticalList>
				<VerticalList child_padding=8>
					<HorizontalList id=frameregs child_padding=3/>
					<HorizontalList id=logibtns child_padding=3>
						<Button width=32 height=32 id=btnpower on_click={toggle_power} icon=icon_power tooltip="Power On"/>
						<Button width=32 height=32 id=btndisconnected on_click={toggle_disconnected} icon=icon_carry tooltip="Connect to Logistics Network"/>
						<Button width=32 height=32 id=btnrequest on_click={on_click_request} icon=icon_small_request tooltip="Request Item"/>
					</HorizontalList>
					<Button id=paramsbtn icon=icon_key text="Blueprint Parameter" on_click={on_click_params} margin_top=35 height=34 hidden=true/>
				</VerticalList>
				<ScrollList fill=true height=115>
					<Wrap id=slotwrap child_padding=3/>
				</ScrollList>
			</HorizontalList>
			<Box bg=popup_additional_bg padding=6 id=siterow hidden=true margin_top=8>
				<HorizontalList child_padding=32 >
					<Text text={siteinfo} valign=center fill=true/>
					<Button text={siteapply} width=162 height=32 on_click={on_ui_accept} disabled={disableapply}/>
					<Button text="Cancel" width=162 height=32 on_click={on_ui_cancel}/>
				</HorizontalList>
			</Box>
			<Box bg=popup_additional_bg padding=6 id=okrow hidden=true>
				<Button text="OK" halign=right width=162 height=32 on_click={on_ui_accept}/>
			</Box>
		</VerticalList>
		<Draw id=links/>
	</Canvas>
]]

local BlueprintEditorReg_layout<const> = [[
	<Reg on_set={reg_apply} dragtype=BPREGISTER on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_drop={link_on_drop} on_click={reg_on_click} on_mouse_enter={reg_on_enter} on_mouse_leave={reg_on_leave} tooltip={reg_tooltip}/>
]]

local BlueprintEditor = {}

UI.Register("BlueprintEditor", BlueprintEditor_layout, BlueprintEditor)

function BlueprintEditor:construct()
	local bp
	if self.library_item then -- editing via the library
		bp = Tool.Copy(self.library_item)
	elseif self.source_entity then -- upgrade/modify entity (optionally with a source bp)
		local entity, source_bp = self.source_entity, self.source_bp
		local entity_bp = MakeBlueprintFromEntity(entity, true, false, true)
		if not entity_bp then self:Clear() self.root:RemoveFromParent() error("Missing bp in BlueprintEditor") end
		if not self.build_locations then
			self.build_locations, self.build_rotation = { entity.placed_location }, entity.rotation
			if source_bp then self:fix_build_rotation(entity_bp.frame, source_bp.frame) end
		end
		if entity.is_construction then
			local paused = entity.powered_down
			if not paused then Action.SendForConstruction("SetConstructionPause", entity, { val = true }) end
			if paused then self.build_paused = true end
		end
		local upgrade_err = CheckDeconstruct(entity, (source_bp or entity_bp).frame)
		if upgrade_err then
			self.changeframe.disabled = true
			self.changeframe.tooltip = L("%s: %s", "Upgrade unavailable", upgrade_err)
		end
		if not self.library then self.library, self.is_remote = Game.GetLocalPlayerFaction().extra_data.library or {}, true end
		bp, self.source_bp = Tool.Copy(source_bp or entity_bp), entity_bp -- keep entity bp to check if modified
	elseif self.source_bp then -- editing via build menu or register selection
		bp = Tool.Copy(self.source_bp)
	end

	if not bp           then self:Clear() self.root:RemoveFromParent() error("Missing bp in BlueprintEditor") end
	if not self.library then self:Clear() self.root:RemoveFromParent() error("Missing library in BlueprintEditor") end
	if bp.dependencies  then self:Clear() self.root:RemoveFromParent() error("Blueprint in BlueprintEditor needs to have dependencies imported") end
	if self.bp          then self:Clear() self.root:RemoveFromParent() error("BP passed directly to BlueprintEditor") end
	if self.is_remote == nil then self.is_remote = (self.library ~= Game.GetProfile().library) end
	if self.source_bp then
		if bp.params then self:Clear() self.root:RemoveFromParent() error("Custom blueprint for BlueprintEditor needs applied parameters") end
		self.bptitlerow.hidden, self.siterow.hidden, self.okrow.hidden = true, not self.is_site, not self.on_ok
	end
	self.bp = bp
	self:init()

	--[[DEBUG VIEW
	self:Add("Spacer", { construct = function(w) w.b = UI.AddLayout("<Box width=300 dock=left><ScrollList max_height=800><Text text={txt}/></ScrollList></Box>", { every_frame_update = function(wb) wb.txt = tostring(self.bp) end, on_mouse_button_down = function(wb) print(wb.txt) end }) end, destruct = function(w) w.b:RemoveFromParent() end })
	--]]
end

local function BuildBlueprintVarArgList(params)
	if not params then return 0 end
	local res = {}
	for i,v in ipairs(params) do
		res[#res+1] = v[1] or ('\b'..i)
	end
	return res
end

function BlueprintEditor:destruct()
	if self.library_item and Tool.Hash(self.bp) ~= Tool.Hash(self.library_item) then
		UILibrarySaveItem(self.library, self.bp, nil, BuildBlueprintVarArgList(self.library_item.params), BuildBlueprintVarArgList(self.bp.params))
	elseif self.on_changed and Tool.Hash(self.bp) ~= Tool.Hash(self.source_bp) then
		self:SendEvent("on_changed", self.bp)
	end
end

function BlueprintEditor:close_site_popup(do_resume_construction)
	if do_resume_construction and self.source_entity and not self.build_paused and self.source_entity.exists and self.source_entity.is_construction and self.source_entity.powered_down then
		Action.SendForConstruction("SetConstructionPause", self.source_entity, { val = false })
	end
	self.root:RemoveFromParent()
end

function BlueprintEditor:update()
	if self.source_entity and not self.source_entity.exists then self:close_site_popup(false) end
end

function BlueprintEditor:Refresh()
	local bp_multi = self.bp.multi
	if bp_multi then
		self.preview.multi = bp_multi
	else
		self.preview.components = self.unit.components
	end
	self:slots_refresh()
	self:links_refresh()

	self:SendEvent("on_refresh", self.bp)
end

function BlueprintEditor:RefreshSocketRegisters(set_block)
	local comp_def, unit_regs, behavior_bpcomp, regs, bpcomp_idx = set_block.box.comp_def, self.unit.regs, set_block.behavior_bpcomp, set_block.regs, set_block.bpcomp_idx
	local comp_def_regs = not behavior_bpcomp and comp_def and comp_def.registers
	local behavior_code = behavior_bpcomp and self.library[behavior_bpcomp[3]]
	local behavior_params = behavior_code and (behavior_code.parameters and #behavior_code.parameters or 0)
	local behavior_pnames = behavior_code and behavior_code.pnames
	local comp_reg_count, old_reg_count = (behavior_params or (comp_def_regs and #comp_def_regs) or 0), #regs
	local unit_links, linksremoved = old_reg_count > comp_reg_count and self.unit.links

	regs:Clear()
	for i=1,math.max(comp_reg_count, old_reg_count) do
		local regkey = bpcomp_idx and string.format('%d|%d', bpcomp_idx, i)
		if i <= comp_reg_count then
			local regdef = comp_def_regs and comp_def_regs[i]
			local read_only = (regdef and regdef.read_only or nil)
			local regw = regs:Add(BlueprintEditorReg_layout, {
				comp_def = comp_def, register_def = regdef, key = regkey,
				ui_icon = regdef and regdef.ui_icon,
				read_only = read_only,
				on_click = read_only and false, -- if not false, pass nil which makes it use the default defined in the layout on_click={reg_on_click}
				empty_tooltip = regdef and regdef.tip and L("%s\n\n<desc>A Register that holds a value</>", regdef.tip),
				no_num_txt = (behavior_pnames and NOLOC(behavior_pnames[i])) or (behavior_code and NOLOC("P" .. i)) or nil,
			})
			if regkey then
				self.regwidgets[regkey] = regw
				self:reg_set(regw, unit_regs and unit_regs[regkey], -1)
			end
		elseif regkey then
			self.regwidgets[regkey] = nil
			if unit_regs and unit_regs[regkey] then
				unit_regs[regkey] = nil
				if not next(unit_regs) then self.unit.regs = nil end
			end
			if unit_links then
				for l,v in ReverseIPairs(unit_links) do
					if v[1] == regkey or v[2] == regkey then table.remove(unit_links, l) linksremoved = true end
				end
			end
		end
	end
	local comp_regs_per_row = comp_reg_count > 15 and ((comp_reg_count + 2) // 3) or 5
	regs.wrapsize = comp_regs_per_row * 56 + (comp_regs_per_row - 1) * 4
	if linksremoved then
		if #unit_links == 0 then self.unit.links = nil end
		self:inherent_refresh()
	end
end

function BlueprintEditor:SetSocketBPCompIdx(block, set_bpcomp_idx)
	block.bpcomp_idx = set_bpcomp_idx
	local regwidgets = self.regwidgets
	for i,w in ipairs(block.regs) do
		local oldkey, newkey = w.key, set_bpcomp_idx and string.format('%d|%d', set_bpcomp_idx, i)
		if oldkey then regwidgets[oldkey] = nil end
		w.key = newkey
		if newkey then regwidgets[newkey] = w end
	end
end

function BlueprintEditor:SetSocket(block, set_comp_def, set_bpcomp_idx, refresh)
	block.box:SetCompDef(set_comp_def)
	block.bpcomp_idx = set_bpcomp_idx
	block.behavior_bpcomp = set_comp_def and set_comp_def.base_id == 'c_behavior' and self.unit.components and self.unit.components[set_bpcomp_idx]
	block.production_bpcomp = set_comp_def and set_comp_def.base_id == 'c_fabricator' and self.unit.components and self.unit.components[set_bpcomp_idx]
	self:RefreshSocketRegisters(block)
	if refresh then self:Refresh() end
end

function BlueprintEditor:RemoveComponentEntry(bpcomp_idx)
	local unit = self.unit
	table.remove(unit.components, bpcomp_idx)
	if #unit.components == 0 then unit.components = nil end

	local function NewKey(k)
		local c = type(k) == "string" and string.match(k, '%d+')*1
		return (not c or c < bpcomp_idx) and k or (c ~= bpcomp_idx) and string.gsub(k, '%d+|', (c-1)..'|') or nil
	end

	-- Shift bpcomp_idx in component blocks and registers (need clearing in one loop and setting in another due to unknown order)
	for _,otherblock in ipairs(self.complist) do
		local other_bpcomp_idx = otherblock.bpcomp_idx
		if other_bpcomp_idx and other_bpcomp_idx >= bpcomp_idx then
			self:SetSocketBPCompIdx(otherblock, nil) -- clear .key and regwidgets
			if other_bpcomp_idx ~= bpcomp_idx then otherblock.bpcomp_idx = other_bpcomp_idx end -- keep for the loop below
		end
	end
	for _,otherblock in ipairs(self.complist) do
		if otherblock.bpcomp_idx and otherblock.bpcomp_idx > bpcomp_idx then
			self:SetSocketBPCompIdx(otherblock, otherblock.bpcomp_idx - 1) -- set .key and regwidgets
		end
	end

	-- remove registers, links related to this component and fix indices of others
	local unit_regs, unit_links, linksremoved = unit.regs, unit.links
	if unit_regs then
		local new_regs = {}
		for k,v in pairs(unit_regs) do
			local newk = NewKey(k)
			if newk then new_regs[newk] = v end
		end
		unit.regs = EmptyTableAsNil(new_regs)
	end
	if unit_links then
		for i,v in ReverseIPairs(unit_links) do
			v[1], v[2] = NewKey(v[1]), NewKey(v[2])
			if not v[1] or not v[2] then table.remove(unit_links, i) linksremoved = true end
		end
		if #unit_links == 0 then unit.links = nil end
	end
	if linksremoved then self:inherent_refresh() end
end

function BlueprintEditor:ClearBlock(block)
	-- remove slot locks related to this component
	if block.slot_first > 0 and self.unit.locks then
		local slot_from, slot_count = block.slot_first, block.slot_count
		local unit_locks, slot_end = self.unit.locks, slot_from + slot_count
		for k,_ in pairs(unit_locks) do if k >= slot_from and k < slot_end then unit_locks[k] = nil end end
		for k,v in pairs(unit_locks) do if k >= slot_end then unit_locks[k], unit_locks[k - slot_count] = nil, v end end
		if not next(unit_locks) then self.unit.locks = nil end
	end

	self:RemoveComponentEntry(block.bpcomp_idx)
	self:SetSocket(block, nil, nil, true)
end

function BlueprintEditor:init()
	local bp, source_entity = self.bp, self.source_entity
	local unitbasename = source_entity and (source_entity.visual_def.explorable_name or source_entity.def.name or "")
	local defaultname = unitbasename or (bp.multi and "New Multi Blueprint" or "New Blueprint")
	if self.on_refresh then self.paramsbtn.hidden, self.paramsbtn.active = false, bp.params ~= nil end -- show only when opening via library

	self:icon_refresh()
	self.defaultname = NOLOC(L(defaultname))
	self.name = bp.name and NOLOC(bp.name) or defaultname
	self.desc = bp.desc and NOLOC(bp.desc) or "Description"

	local bp_multi = bp.multi
	if bp_multi and bp_multi[1] then
		local select_idx, hover_idx, hover_regkey = 1
		self.preview.on_click = function(preview, mousebtn)
			local multi_idx = preview:GetMultiAt(UI.GetMousePosition(preview))
			if multi_idx and select_idx ~= multi_idx then
				preview:SetMultiHighlight(select_idx, nil)
				preview:SetMultiHighlight(multi_idx, 'yellow', 2)
				self.unit, hover_idx, select_idx = bp_multi[multi_idx], multi_idx, multi_idx
				self:setup_unit()
			end
			if multi_idx and mousebtn == 'RIGHTMOUSEBUTTON' then
				self:on_click_options()
			end
		end
		self.preview.on_hover_reg = function(preview, regkey)
			hover_regkey = regkey
		end
		self.preview.every_frame_update = function(preview)
			local multi_idx
			if hover_regkey then
				local val = self.unit and self.unit.regs and self.unit.regs[hover_regkey]
				if val and type(val) ~= "number" and type(val.entity) == "number" then multi_idx = val.entity end
			else
				local x, y = UI.GetMousePosition(preview)
				if x then multi_idx = preview:GetMultiAt(x, y) end
			end
			if multi_idx == hover_idx then return end
			if select_idx ~= multi_idx then preview:SetMultiHighlight(select_idx, 'ui_light', 3) end
			if hover_idx and hover_idx ~= select_idx then preview:SetMultiHighlight(hover_idx, nil) end
			if multi_idx then preview:SetMultiHighlight(multi_idx, 'yellow', 2) end
			hover_idx = multi_idx
		end
		self.preview.on_drop = function(preview, payload)
			if payload.dragtype ~= 'BPREGISTER' or not self.dragsource then return false end
			local multi = preview:GetMultiAt(UI.GetMousePosition(preview))
			if not multi then return false end
			self.dragsource = nil
			self:reg_set(payload, { entity = multi }, nil, true)
		end
		self.preview.on_clipboard_copy = function(preview)
			local multi = preview:GetMultiAt(UI.GetMousePosition(preview))
			if not multi then return Notification.Warning("Must focus unit or building to copy settings from") end
			self:copy(bp_multi[multi])
		end
		self.preview.on_clipboard_paste = function(preview, table, prefix)
			local multi = preview:GetMultiAt(UI.GetMousePosition(preview))
			if not multi then return end
			self:paste(bp_multi[multi])
		end
		self.preview:SetMultiHighlight(select_idx, 'ui_light', 3)
		self.unit = bp_multi[select_idx]
	else
		if bp_multi then bp.multi = nil end
		ConvertOldBlueprint(bp.components, bp.regs, bp.links)
		if bp.reg_values then bp.reg_values = nil end -- old format
		if bp.lock_values then bp.lock_values = nil end -- old format

		self.preview.tooltip = DefinitionTooltip(bp)
		self.unit = bp
	end
	self:setup_unit()
end

function BlueprintEditor:setup_unit()
	local unit = self.unit
	if not unit.frame then
		self:select_base_frame()
		return
	end

	local source_entity = unit == self.bp and self.source_entity
	if source_entity and source_entity.id ~= unit.frame then source_entity = nil end
	local frame_def = source_entity and source_entity.def or data.frames[unit.frame]
	local visual_def = frame_def and ((source_entity and source_entity.visual_def) or (type(frame_def.visual) == "table" and frame_def.visual or data.visuals[frame_def.visual]))
	local complist, frameregs, preview = self.complist, self.frameregs, self.preview
	local unitbasename = frame_def and (visual_def and visual_def.explorable_name) or frame_def.name or ""
	complist:Clear()
	frameregs:Clear()
	self.frameimg.image = frame_def.texture
	self.frameimg.tooltip = DefinitionTooltip(unit)
	self.unitname.text = unit.name or NOLOC(L(unitbasename))

	if not self.bp.multi then
		local show_preview = visual_def and visual_def.mesh and frame_def.flags ~= "Space"
		preview.hidden = not show_preview
		preview.visual = show_preview and visual_def.id
	end

	-- Add frame registers
	local show_regs, unit_regs, regwidgets = not frame_def.type, unit.regs, {false,false,false,false}
	self.regwidgets = regwidgets
	self.frameregs.hidden, self.logibtns.hidden = not show_regs, not show_regs
	if show_regs then -- not for walls/gates
		for regkey,v in ReverseIPairs(data.frame_regs) do
			local regw = frameregs:Add(BlueprintEditorReg_layout, { key = regkey, empty_tooltip = v.tooltip, ui_icon = v.bg })
			regwidgets[regkey] = regw
			self:reg_set(regw, unit_regs and unit_regs[regkey])
		end

		-- Set power and logistics button states
		local unit_disconnected, start_disconnected = unit.disconnected, frame_def.start_disconnected
		self.btnpower.active = not unit.powered_down
		self.btndisconnected.nil_value = start_disconnected or false
		self.btndisconnected.active = not (unit_disconnected or (unit_disconnected == nil and start_disconnected))
		self.btnrequest.active = unit.recurring_orders ~= nil
	end

	local can_have_integrated_behavior = not frame_def.type and frame_def.race == "robot" and not frame_def.no_integrated_behavior
	self.optionbtn.hidden = not can_have_integrated_behavior

	-- Fill out list of built-in frame component blocks
	local integrated_count
	if frame_def.components then
		for i,v in ipairs(frame_def.components) do
			local comp_def = data.components[v[1]]
			if comp_def.get_ui then
				integrated_count = (integrated_count or 0) + 1
				local block = complist:Add("<ComponentBlock halign=left socket_size=Hidden/>")
				self:SetSocket(block, comp_def)
				block.box.block, block.regs.block = block, block
			end
		end
	end

	-- Fill out list of component blocks
	local sockets, max_socket_sizenum, no_modify_comp = visual_def and visual_def.sockets or {}, 0, self.changeframe.disabled
	for i,v in ipairs(sockets) do
		local socket_sizenum = GetAttachmentSize(v[2])
		if socket_sizenum > max_socket_sizenum then max_socket_sizenum = socket_sizenum end
		local block = complist:Add("<ComponentBlock halign=left/>", { socket_size = v[2] })
		local box = block.box
		box.block, block.regs.block, block.socket_index, block.socket_sizenum = block, block, i, socket_sizenum
		box:SetCompDef(nil)
		if no_modify_comp then
			box.tooltip = self.changeframe.tooltip
			box.opacity = 0.5
		else
			box.tooltip = function()
				local behavior_bpcomp = block.behavior_bpcomp
				if behavior_bpcomp then
					return BuildDefinitionTooltip(box.comp_def, { behavior_code = behavior_bpcomp[3] and self.library[behavior_bpcomp[3]] })
				elseif box.comp_def then
					return BuildDefinitionTooltip(box.comp_def)
				else
					local info = L(box.socket_size == "Internal" and "<desc>This socket only accepts </><bl>%s</><desc> sized Components</>" or "<desc>This socket only accepts components of size </><bl>%s</><desc> or smaller</>", box.socket_size)
					return L("<header>%s</>\n<bl>%s</>\n<desc>%s</>\n%s", "Empty Socket", box.socket_size, "Drag Component here to Equip", info)
				end
			end
			box.on_click = function(box, mousebtn)
				if mousebtn ~= 'RIGHTMOUSEBUTTON' and (mousebtn ~= 'LEFTMOUSEBUTTON' or box.comp_def) then return end
				local block = box.block
				local function set_comp_callback(rself, newval)
					local def = data.all[newval.id]

					if box.comp_def then
						self:ClearBlock(block)
					end

					if newval and newval.id then
						-- components array might have been set to nil during ClearBlock
						if not unit.components then unit.components = {} end
						local bpcomp_idx = block.bpcomp_idx or (#unit.components+1)
						unit.components[bpcomp_idx] = { newval.id, block.socket_index }
						self:SetSocket(block, def, bpcomp_idx, true)
						if def.link_to_visual and not (unit.regs and unit.regs[3]) then
							self:link_create(block.regs[1], regwidgets[3])
						end
					end
				end

				if box.comp_def then
					local behavior_bpcomp = block.behavior_bpcomp
					self:ComponentPopup(behavior_bpcomp, block, socket_sizenum, set_comp_callback)
				elseif not block.bpcomp_idx then
					local comp_filter = function(def, cat) return def.attachment_size and (GetAttachmentSize(def.attachment_size)) <= socket_sizenum end
					local rsel = ShowRegisterSelection(box, set_comp_callback, comp_filter)
					if rsel then rsel:SetRegister({ id = box.comp_def and box.comp_def.id }) end
				end
			end
			box.on_drag_start = function(box)
				if not box.block.bpcomp_idx then return end
				box.dragtype = 'BPCOMPONENT'
				local res = UI.New("Reg", { icon = box.image.image, num = (Input.IsControlDown() and 1 or nil), drag_def = box.comp_def, bg = false } )
				return res
			end
			box.on_drag_cancel = function(box, cursor)
				if not cursor.num then -- not a ctrl+drag copy
					self:ClearBlock(box.block)
				end
			end
			box.on_drop = function(box, payload, cursor)
				local drag_def = data.components[self:GetDragId(payload, cursor)]
				if not drag_def then return false end
				local block, payload_block = box.block, payload.dragtype == 'BPCOMPONENT' and payload.block
				local src_comp_sizenum = (GetAttachmentSize(drag_def.attachment_size))
				local trg_comp_sizenum = box.comp_def and (GetAttachmentSize(box.comp_def.attachment_size))
				local drag_ok = (payload.dragtype ~= 'BPREGISTER') -- abort register link drag
				if src_comp_sizenum > block.socket_sizenum or (trg_comp_sizenum and payload_block and payload_block.socket_index and trg_comp_sizenum > payload_block.socket_sizenum) then
					MessagePopup(box, "Component doesn't fit into socket")
					return drag_ok
				end
				local bpcomps, drop_bpcomp_idx, move_bpcomp_idx = unit.components, block.bpcomp_idx, payload_block and not cursor.num and payload_block.bpcomp_idx
				if drop_bpcomp_idx and not move_bpcomp_idx then return drag_ok end -- can't add/copy, already filled
				if move_bpcomp_idx and drop_bpcomp_idx == move_bpcomp_idx then return drag_ok end -- dropped in place
				UI.PlaySound("fx_ui_COMPONENT_EQUIP")
				if not move_bpcomp_idx then -- add / copy
					if not bpcomps then bpcomps = {} unit.components = bpcomps end
					local new_bpcomp_idx = #bpcomps + 1
					bpcomps[new_bpcomp_idx] = (payload_block and Tool.Copy(bpcomps[payload_block.bpcomp_idx]) or { drag_def.id })
					bpcomps[new_bpcomp_idx][2] = block.socket_index
					self:SetSocket(block, drag_def, new_bpcomp_idx, true)
				elseif drop_bpcomp_idx then -- swap
					bpcomps[drop_bpcomp_idx][2], bpcomps[move_bpcomp_idx][2] = payload_block.socket_index, block.socket_index -- swap socket indices
					self:SetSocket(payload_block, box.comp_def, drop_bpcomp_idx)
					self:SetSocket(block, drag_def, move_bpcomp_idx, true)
				else -- move to different socket
					bpcomps[move_bpcomp_idx][2] = block.socket_index
					self:SetSocket(payload_block, nil, nil)
					self:SetSocket(block, drag_def, move_bpcomp_idx, true)
				end
				return drag_ok
			end
		end
	end

	-- Assign the components in the blueprint to the component blocks
	local has_integrated_behavior
	for bpcomp_idx,v in ReverseIPairs(unit.components) do
		local comp_def, socket_index = data.components[v[1]], type(v[2]) == "number" and v[2] or false
		for _,block in ipairs(complist) do
			if block.socket_index == socket_index or (not socket_index and not block.bpcomp_idx and block.box.comp_def == comp_def) then
				self:SetSocket(block, comp_def, bpcomp_idx)
				if not socket_index then v[2] = 'inherent' end -- switch "hidden" to "inherent"
				goto found_block
			end
		end
		if v[1] == 'c_integrated_behavior' and not has_integrated_behavior then --v[2] can be "hidden" or -1 (backwards compatibility)
			if v[2] ~= "hidden" then v[2] = "hidden" end -- fix broken old blueprint so it works with BlueprintEditor:switch_frame
			has_integrated_behavior = true
			integrated_count = (integrated_count or 0) + 1
			local block = complist:Add("<ComponentBlock halign=left socket_size=Hidden/>")
			block.child_index = integrated_count
			local box = block.box
			box.block, block.regs.block = block, block
			self:SetSocket(block, comp_def, bpcomp_idx)
			box.on_click = function(box, mousebtn)
				if mousebtn ~= 'RIGHTMOUSEBUTTON' then return end
				local behavior_bpcomp = box.block.behavior_bpcomp
				self:ComponentPopup(behavior_bpcomp, box.block)
			end
			box.tooltip = function(box)
				local behavior_bpcomp = box.block.behavior_bpcomp
				return BuildDefinitionTooltip(box.comp_def, { behavior_code = behavior_bpcomp[3] and self.library[behavior_bpcomp[3]] })
			end
			goto found_block
		end
		self:RemoveComponentEntry(bpcomp_idx) -- cleanup invalid data
		::found_block::
	end

	if integrated_count then complist[integrated_count].margin_bottom = 20 end

	self:Refresh()

	-- Cleanup existing invalid data
	local unit_links, unit_locks, refresh_inherent = unit.links, unit.locks
	if unit_links then
		for i,v in ReverseIPairs(unit_links) do
			if not regwidgets[v[1]] or not regwidgets[v[2]] or #v ~= 2 then
				table.remove(unit_links, i)
				refresh_inherent = true
			end
		end
		if not next(unit_links) then unit.links = nil end
	end
	if unit_regs then
		for k,v in pairs(unit_regs) do
			local regwidget = regwidgets[k]
			if not regwidget or regwidget.read_only then
				unit_regs[k] = nil
				refresh_inherent = true
			end
		end
		if not next(unit_regs) then unit.regs = nil end
	end
	if unit_locks then
		local slotcount = #self.slotwrap
		for k,_ in pairs(unit_locks) do
			if k > slotcount then
				unit_locks[k] = nil
			end
		end
		if not next(unit_locks) then unit.locks = nil end
	end
	if refresh_inherent then self:inherent_refresh() end
end

function BlueprintEditor:ComponentPopup(behavior_bpcomp, block, socket_sizenum, set_comp_callback)
	local box = block.box
	UI.MenuPopup([[<Box padding=5><VerticalList>
			<Button id=selectbtn text="Select behavior" on_click={on_select_behavior}/>
			<Button id=startbtn text="Stop behavior" on_click={on_start_behavior} height=32/>
			<Button id=switchbtn text="Switch Component" on_click={on_switch_component}/>
			<Button id=removebtn text="Remove Component" on_click={on_remove_component}/>
			</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			menu.selectbtn.hidden = not behavior_bpcomp
			--menu.editbtn.hidden = not behavior_bpcomp or not behavior_bpcomp[3]
			menu.startbtn.hidden = not behavior_bpcomp or not behavior_bpcomp[3]
			menu.startbtn.text = behavior_bpcomp and behavior_bpcomp[4] and "Start behavior" or "Stop behavior"
			menu.startbtn.icon = behavior_bpcomp and behavior_bpcomp[4] and "icon_play" or "icon_stop"
			if not socket_sizenum then menu.switchbtn.hidden = true menu.removebtn.hidden = true end
		end,
		on_select_behavior = function(menu, b)
			UI.CloseMenuPopup(menu)
			UILibrarySelect(box, 'C',
				function(item) behavior_bpcomp[3] = item.id self:RefreshSocketRegisters(block) self:Refresh() end, -- select
				function() behavior_bpcomp[3], behavior_bpcomp[4] = nil, nil self:RefreshSocketRegisters(block) self:Refresh() end, -- clear
				nil, behavior_bpcomp[3], behavior_bpcomp[1], self.library)
		end,
		on_start_behavior = function(menu, b)
			behavior_bpcomp[4] = b.icon == 'icon_stop' or nil
			b.text = behavior_bpcomp[4] and "Start behavior" or "Stop behavior"
			b.icon = behavior_bpcomp[4] and "icon_play" or "icon_stop"
		end,
		on_switch_component = function(menu, b)
			UI.CloseMenuPopup(menu)
			local comp_filter = function(def, cat) return def.attachment_size and (GetAttachmentSize(def.attachment_size)) <= socket_sizenum end
			local rsel = ShowRegisterSelection(box, set_comp_callback, comp_filter)
			if rsel then rsel:SetRegister({ id = box.comp_def and box.comp_def.id }) end
		end,
		on_remove_component = function(menu)
			UI.CloseMenuPopup(menu)
			self:ClearBlock(block)
		end,
	}, box)
end

function BlueprintEditor:icon_refresh(set_new_icon, new_icon)
	if set_new_icon then self.bp.icon = new_icon or nil self:SendEvent("on_refresh", self.bp) end
	self.imgicon.imageid = self.bp.icon or self.bp.frame
	self.imgicon.image = not self.imgicon.imageid and 'icon_blueprint' or nil
	self.imgicon.color = not self.imgicon.imageid and 'ui_light' or 'white'
end

function BlueprintEditor:icon_on_click(iconw, mousebtn)
	local function on_set(rsel, val)
		self:icon_refresh(true, val and val.id)
	end
	if mousebtn == 'RIGHTMOUSEBUTTON' then on_set(nil, nil) return end
	local rsel = ShowRegisterSelection(iconw, on_set, nil, nil, { hide_coord_panel = true, hide_number_panel = true, hide_entity_panel = true })
	if rsel then rsel:SetRegister({ id = self.bp.icon }) end
end

function BlueprintEditor:GetDragId(payload, cursor)
	if payload.dragtype == 'BPCOMPONENT' or payload.dragtype == 'BPSLOT' then
		return cursor.drag_def.id, 1
	elseif payload.dragtype == 'BPREGISTER' then
		return payload.entity and payload.entity.id or payload.def_id, payload.num or 0
	end
end

function BlueprintEditor:icon_on_drop(iconw, payload, cursor)
	local drag_id, drag_num = self:GetDragId(payload, cursor)
	if not drag_num then return false end
	self:icon_refresh(true, drag_id)
	return payload.dragtype ~= 'BPREGISTER' -- abort register link drag
end

function BlueprintEditor:on_textedit(txt)
	local inp = txt.parent:Add(txt.field == 'desc' and "<MultiLineInputText/>" or "<InputText/>")
	inp.child_index = txt.child_index
	inp.padding = 1
	inp.text = self.bp[txt.field] or ""
	inp.height = txt.field == 'desc' and 48 or select(2, txt:GetDesiredSize())
	inp:Focus()
	inp.on_ui_cancel = function()
		txt.hidden = false
		inp:RemoveFromParent()
	end
	inp.on_enter = function()
		local default = txt.field == 'desc' and NOLOC(L("Description")) or self.defaultname
		local t = inp.text and inp.text ~= "" and inp.text ~= default and inp.text or nil
		self.bp[txt.field], self[txt.field] = t, t or NOLOC(default)
		if txt.field == 'name' and not self.bp.multi then
			local frame_def = data.frames[self.bp.frame]
			self.unitname.text = t or NOLOC(L(frame_def and frame_def.name or ""))
		end
		self:SendEvent("on_refresh", self.bp)
		inp.on_ui_cancel()
	end
	inp.on_leave = inp.on_enter
	txt.hidden = true
end

function BlueprintEditor:slots_refresh()
	local typeorder, slotwrap, unit_locks, data_all, knowntypes, typecount = data.item_slot_order, self.slotwrap, self.unit.locks, data.all, {}, 0
	local function AddSlotsOfType(slottype, num)
		local kt, idx = knowntypes[slottype], #slotwrap
		if not kt then
			kt, knowntypes[slottype], typecount = typecount, typecount, typecount + 1
		end
		for i=1,num do
			local lock = unit_locks and unit_locks[idx+i]
			local slotw = slotwrap:Add([[<Canvas width=56 height=56 tooltip={slot_tooltip} on_click={slot_on_click} dragtype=BPSLOT on_drag_start={slot_on_drag_start} on_drop={slot_on_drop} on_clipboard_copy={slot_on_clipboard_copy} on_clipboard_paste={slot_on_clipboard_paste}>
				<Image id=bg width=56 height=56 image=item_default/>
				<Image id=image width=52 height=52 dock=top margin_top=2 image={slot_icon} color=ui_light/>
				<Image id=lockimg image=item_lock halign=left hidden={hidelock}/>
			</Canvas>]], { sortkey = (typeorder[slottype] or 999)*10000+idx+i, slot_icon = data.item_slot_icons[slottype] or "icon_inventory", type = slottype, idx = idx+i, hidelock = not lock })

			local lock_def = lock and data_all[lock]
			if lock_def then
				slotw.image.image = lock_def.texture
				slotw.image.opacity = 0.5
				slotw.image.color = nil
			elseif type(lock) == "number" then -- blueprint parameter index
				slotw.image.image = data.values.v_blueprint_param.texture
				slotw.image.opacity = 0.5
				slotw:Add("<Text dock=bottom-left margin_left=4 margin_bottom=2 size=10/>").text = tostring(lock)
			end
		end
	end

	slotwrap:Clear()
	local slots = data.frames[self.unit.frame].slots
	if slots and slots.storage then
		AddSlotsOfType("storage", slots.storage)
	end
	for type,num in SortedPairs(data.frames[self.unit.frame].slots) do
		if type ~= "storage" then AddSlotsOfType(type, num) end
	end
	for _,block in ipairs(self.complist) do
		local box = block.box
		local comp_def = box and box.comp_def
		if comp_def then
			block.slot_first = #slotwrap + 1
			for type,num in SortedPairs(comp_def and comp_def.slots) do
				AddSlotsOfType(type, num)
			end
			block.slot_count = #slotwrap - block.slot_first + 1
		end
	end
	slotwrap:SortChildren(function (a, b) return a.sortkey < b.sortkey end)

	if self.is_site then
		local e, upgrade = self.source_entity, self:site_need_upgrade()
		local def, change_construction = (e and GetBuiltFrameDef(e)), (e and e.is_construction)

		self.siteinfo =
			(change_construction and L("Modifying Construction Site of %s", def.name or "Unit"))
			or (e and upgrade and L("Upgrading %s", e.visual_def.explorable_name or def.name or "Unit"))
			or (e and L("Modifying %s", e.visual_def.explorable_name or def.name or "Unit"))
			or (#self.build_locations > 1 and L("Customizing %d Constructions", #self.build_locations) or "Customizing Construction")

		self.siteapply = e and (upgrade and not change_construction and "Apply Upgrade" or "Apply Modification") or "Start Construction"
		self.disableapply = e and upgrade and not change_construction and self.changeframe.disabled
	end
end

function BlueprintEditor:slot_tooltip(slotw)
	local lock = self.unit.locks and self.unit.locks[slotw.idx]
	if type(lock) == "number" then return L("%s: %S", "Blueprint Parameter", (self.bp.params[lock][1] or "")) end
	local def = lock and lock ~= true and data.all[lock]
	if not def then return L("No Item\n\n<hl>Type: </>%s", slotw.type) end
	return BuildDefinitionTooltip(def)
end

function BlueprintEditor:slot_on_click(slotw, mousebtn)
	if self.changeframe.disabled then return end -- can only change locks when upgrade is possible
	local slot_idx = slotw.idx
	local locks = self.unit.locks
	local lock = locks and locks[slot_idx]

	local function set_lock(id)
		if not self.unit.locks then self.unit.locks = {} end
		self.unit.locks[slot_idx] = id
		if id == nil then self.unit.locks = EmptyTableAsNil(self.unit.locks) end
		self:slots_refresh()
	end

	if Input.IsShiftDown() then
		set_lock(not lock and true or nil)
		return
	end

	local function set_locks_all(id)
		if not self.unit.locks then self.unit.locks = {} end
		locks = self.unit.locks
		local current_type = slotw.type
		for _,v in ipairs(self.slotwrap) do
			if v.type == current_type then locks[v.idx] = id end
		end
		self.unit.locks = EmptyTableAsNil(locks)
		self:slots_refresh()
	end

	local function fixto_popup(index, is_all)
		UI.MenuPopup([[
				<Box bg=popup_box_bg padding=8 blur=true>
					<VerticalList>
						<Text text="Lock Slot to Blueprint Parameter" halign=center margin_bottom=8/>
						<ScrollList orientation=horizontal id=params child_padding=4 margin_bottom=16/>
						<Text text="Lock Slot to an Item" halign=center margin_bottom=8/>
						<SimpleRegisterSelection width=626 max_height=536 on_select_id={on_select} def_filter={def_filter}/>
					</VerticalList>
				</Box>
			]], {
			construct = function(menu)
				menu:TweenFromTo("sy", 0, 1, 100)
				for i,entry in ipairs(self.bp.params or {}) do
					local name = entry[1]
					local paramregw = menu.params:Add("<Reg def_id=v_blueprint_param on_click={on_click_param}/>")
					paramregw.num = i
					paramregw.tooltip = NOLOC(name)
				end
				menu.params.hidden, menu.params.previous_sibling.hidden = #menu.params == 0, #menu.params == 0
			end,
			def_filter = function(def)
				return def.slot_type == slotw.type and def.attachment_size ~= "Hidden"
			end,
			on_select = function(menu, regsel, id)
				if is_all then set_locks_all(id) else set_lock(id) end
			end,
			on_click_param = function(menu, paramregw)
				if is_all then set_locks_all(paramregw.num) else set_lock(paramregw.num) end
			end
		}, slotw, 'UP')
	end

	UI.MenuPopup([[<Box padding=5><VerticalList>
		<Button id=fix text="Lock Empty Slot" on_click={on_fix}/>
		<Button id=fixto text="Lock Slot to an Item" on_click={on_fixto}/>
		<Button id=unfix text="Unlock Slot" on_click={on_unfix}/>
		<Button id=fix_all text="Lock All Slots" on_click={on_fix_all}/>
		<Button id=fixto_all text="Lock All Slots to an Item" on_click={on_fixto_all}/>
		<Button id=unfix_all text="Unlock All Slots" on_click={on_unfix_all}/>
	</VerticalList></Box>]], {
		construct = function(menu)
			menu.fix.hidden, menu.fix_all.hidden = lock == true, lock == true
			menu.unfix.hidden, menu.unfix_all.hidden = not lock, not lock
			menu:TweenFromTo("sy", 0, 1, 100)
		end,
		on_fix = function() set_lock(true) end,
		on_fixto = function() fixto_popup(slotw.idx) end,
		on_fixto_all = function() fixto_popup(slotw.idx, true) end,
		on_fix_all = function() set_locks_all(true) end,
		on_unfix_all = function() set_locks_all(nil) end,
		on_unfix = function() set_lock(nil) end,
	}, slotw, 'UP')
end

function BlueprintEditor:slot_on_drag_start(slotw)
	local def = data.all[self.unit.locks and self.unit.locks[slotw.idx]]
	if not def then return end
	UI.PlaySound("fx_ui_ELEMENT_DRAG")
	return UI.New("Reg", { icon = def.texture, bg = false, drag_def = def }) -- dragtype BPSLOT
end

function BlueprintEditor:slot_on_drop(slotw, payload, cursor)
	local drag_id, drag_num = self:GetDragId(payload, cursor)
	if not drag_num then return false end
	self:slot_on_clipboard_paste(slotw, { id = drag_id, num = drag_num }, 'R')
	return (payload.dragtype ~= 'BPREGISTER') -- abort register link drag
end

function BlueprintEditor:slot_on_clipboard_copy(slotw)
	Notification.Warning("Copied slot value")
	local lock = self.unit.locks and self.unit.locks[slotw.idx]
	return (lock == true and { num = 1 })
		or (type(lock) == "number" and { id = "v_blueprint_param", num = lock })
		or (lock and { id = lock, num = 1 }) or {}, 'R'
end

function BlueprintEditor:slot_on_clipboard_paste(slotw, table, prefix)
	if prefix ~= 'R' then return end
	local id, num = table.id, table.num
	local def = data.all[id]
	local locks = self.unit.locks or {}
	if id == "v_blueprint_param" then
		locks[slotw.idx] = self.bp.params and math.min(#self.bp.params, math.max(1, num or 1)) or nil
	elseif not def or def.slot_type ~= slotw.type then
		locks[slotw.idx] = (num or 0) > 0 or nil
	else
		locks[slotw.idx] = id
	end
	self.unit.locks = EmptyTableAsNil(locks)
	self:slots_refresh()
	return true
end

function BlueprintEditor:inherent_refresh()
	for _,block in ipairs(self.complist) do
		if block.socket_size ~= "Hidden" then return end -- inherent components are at the top, no need to continue further
		if block.bpcomp_idx then
			local bpcomp_idx, unit_regs, unit_links = block.bpcomp_idx, self.unit.regs, self.unit.links
			if unit_regs then for k,v in pairs(unit_regs) do if type(k) == "string" and string.match(k, '%d+')*1 == bpcomp_idx then goto is_used end end end
			if unit_links then for k,v in ipairs(unit_links) do if (type(v[1]) == "string" and string.match(v[1], '%d+')*1 == bpcomp_idx) or (type(v[2]) == "string" and string.match(v[2], '%d+')*1 == bpcomp_idx) then goto is_used end end end
			if block.behavior_bpcomp and block.behavior_bpcomp[1] == "c_integrated_behavior" then goto is_used end
			self:RemoveComponentEntry(bpcomp_idx) -- won't recursively call us because we know there aren't any links on this bpcomp
			::is_used::
		end
	end
end

function BlueprintEditor:allocate_inherent_component(regw)
	local block = regw.parent.block
	if not self.unit.components then self.unit.components = {} end
	local bpcomp_idx = #self.unit.components+1
	self.unit.components[bpcomp_idx] = { block.box.comp_def.id, 'inherent' }
	self:SetSocketBPCompIdx(block, bpcomp_idx)
	return regw.key
end

function BlueprintEditor:reg_apply(regw, val)
	local regkey, unit_regs = regw.key, self.unit.regs
	if not regkey then regkey = self:allocate_inherent_component(regw) end
	if not unit_regs then unit_regs = {} self.unit.regs = unit_regs end
	if type(val) == "table" then -- not a numeric blueprint parameter index
		if val.id == "v_blueprint_param" then -- pasted, dragged, mouse wheel change
			if self.bp.params then val.num = math.min(#self.bp.params or 1, math.max(1, val.num or 1)) else val.id, val.num = nil, nil end
			self:reg_set(regw, val.num or nil, nil, true)
			return
		end
		local num, id, coord, entity = val.num, val.id, val.coord, (self.is_remote or type(val.entity) == "number") and val.entity -- disallow world entity reference in favorites
		local icon_unit_reg = not (id or coord or entity) and regw.icon and unit_regs[regkey]
		if icon_unit_reg then entity = icon_unit_reg.entity end
		val = { id = id, coord = coord, entity = entity, num = ((num or 0) ~= 0 or not (id or coord or entity)) and (num or 0) or nil }
	end
	unit_regs[regkey] = val
	if not val and not next(unit_regs) then self.unit.regs = nil end

	local unit_links, linksremoved = self.unit.links
	for i=(unit_links and #unit_links or 0),1,-1 do
		if unit_links[i][1] == regkey then table.remove(unit_links, i) linksremoved = true end
	end
	if unit_links and #unit_links == 0 then self.unit.links = nil end
	if linksremoved then self:links_refresh() end
	if not val or linksremoved then self:inherent_refresh() end
end

function BlueprintEditor:get_production_bpcomp(regw)
	local block = regw.child_index == 1 and regw.parent.block
	local prod_bpcomp = block and block.production_bpcomp
	if not prod_bpcomp then return end
	local prod_payload = prod_bpcomp and prod_bpcomp[3]
	return (prod_payload and self.library[prod_payload] or prod_payload), prod_bpcomp
end

function BlueprintEditor:reg_set(regw, val, library_id, call_reg_apply)
	local entity = val and type(val) ~= "number" and val.entity
	if type(entity) == "number" then -- multi blueprint entity reference
		local entityref = self.bp.multi[entity]
		local entitydef = entityref and data.frames[entityref.frame]
		regw.def_id, regw.num, regw.coord, regw.entity, regw.bg, regw.icon = nil, val and (val.num or 0), nil, nil, "reg_entity", entitydef and entitydef.texture or "reg_entity"
	elseif type(val) == "number" then -- blueprint parameter index
		regw.def_id, regw.num, regw.coord, regw.entity, regw.bg, regw.icon = "v_blueprint_param", val, nil, nil, nil, nil
	else
		if val and val.id == "v_blueprint_param" then self:reg_apply(regw, val) return end -- have it clean it up
		regw.def_id, regw.num, regw.coord, regw.entity, regw.bg, regw.icon = val and val.id, val and (val.num or 0), val and val.coord, entity, nil, nil
	end

	local prod_bp, prod_bpcomp = self:get_production_bpcomp(regw)
	if prod_bpcomp then
		if library_id == -1 then library_id = prod_bpcomp[3] end -- use current
		regw.show_blueprint_bg = library_id ~= nil
		prod_bpcomp[3] = library_id
	end
	if call_reg_apply then self:reg_apply(regw, val) end
end

function BlueprintEditor:reg_on_click(regw, mousebtn)
	if mousebtn == 'RIGHTMOUSEBUTTON' then
		self:reg_set(regw, nil, nil, true)
		return
	end

	local function on_set(rsel, val, library_id)
		local unit_regs = self.unit.regs
		local unit_reg = unit_regs and unit_regs[regw.key]
		if unit_reg and type(unit_reg) ~= "number" and type(val) ~= "number" and type(unit_reg.entity) == "number" and not (val.id or val.coord or val.entity) then
			val.entity = unit_reg.entity -- if nothing was selected, keep the multi blueprint entity reference and accept the incoming number
		end
		self:reg_set(regw, type(val) == "number" and val or EmptyTableAsNil(val), library_id, true)
	end

	-- check if the register has a filter otherwise just remove entity panel
	local register_def = regw.register_def
	local prod_bp = self:get_production_bpcomp(regw)
	local rsel = ShowRegisterSelection(regw, on_set, nil, nil,
		{ comp_def = regw.comp_def, register_def = register_def, hide_entity_panel = not self.is_remote, reg_bp = prod_bp, library = self.library }
	)
	if not rsel then return end

	local params = self.bp.params
	if params then
		local content = rsel:Add([[<Box bg=popup_pattern padding=4><VerticalList>
				<Text text="Use Blueprint Parameter" textalign=center margin_bottom=8/>
				<ScrollList orientation=horizontal id=params child_padding=4 margin_bottom=16/>
				<Text text="Set to Fixed Value" textalign=center/>
			</VerticalList></Box>]],{
			on_click_param = function(c,paramregw)
				local i = paramregw.num
				on_set(nil, i)
				UI.CloseMenuPopup(c)
			end,
		})
		content.child_index = 1
		for i,entry in ipairs(params) do
			local name = entry[1]
			local paramregw = content.params:Add("<Reg def_id=v_blueprint_param on_click={on_click_param}/>")
			paramregw.num = i
			paramregw.tooltip = NOLOC(name)
		end
	end

	if not prod_bp then rsel:SetRegister({ id = regw.def_id, num = regw.num, coord = regw.coord, entity = regw.entity }) end
end

function BlueprintEditor:reg_tooltip(regw)
	local val = self.unit.regs and self.unit.regs[regw.key]
	if type(val) == "number" then return L("%s: %S", "Blueprint Parameter", (self.bp.params[val][1] or "")) end
	local val_entity = val and val.entity
	local refentity = type(val_entity) == 'userdata' and val_entity
	local refbp = type(val_entity) == "number" and self.bp.multi and self.bp.multi[val_entity]
	local prod_bp = self:get_production_bpcomp(regw)
	local def = (refentity and refentity.def) or refbp or prod_bp or regw.def or data.all[regw.def_id]
	if def then return BuildDefinitionTooltip(def, { clearreg = not regw.read_only or nil, entity = refentity or nil }) end
	if regw.empty_tooltip then return regw.empty_tooltip end
end

function BlueprintEditor:reg_on_enter(regw)
	if self.preview.on_hover_reg then self.preview:on_hover_reg(regw.key) end
end

function BlueprintEditor:reg_on_leave(regw)
	if self.preview.on_hover_reg then self.preview:on_hover_reg(nil) end
end

function BlueprintEditor:links_on_draw(draw)
	local regsz<const> = 56
	local regwidgets, unit_links, link_colors = self.regwidgets, self.unit.links, data.link_colors
	local sreg, tx, ty = self.dragsource
	if sreg then tx, ty = UI.GetMousePosition(draw) end
	if not sreg then draw.on_draw = nil end

	draw:Reset()
	for i=(sreg and 0 or 1),(unit_links and #unit_links or 0) do
		if i >= 1 then
			local treg = regwidgets[unit_links[i][1]]
			tx, ty = treg:GetViewportPosition(draw)
			tx = tx + (regsz / 2)
			sreg = regwidgets[unit_links[i][2]]
		end
		local sx, sy = sreg:GetViewportPosition(draw)
		sx = sx + (regsz / 2)

		local soff = (ty <= sy+regsz and -50 or 50)
		local toff = (ty < sy-regsz and 50 or -50)
		if soff > 0 then sy = sy + regsz end
		if toff > 0 and i >= 1 then ty = ty + regsz end

		for pass=1,2 do
			local col = (pass == 1 and "#44EE" or (i >= 1 and link_colors[1 + ((i-1) % #link_colors)] or 'white'))
			local thick = (pass == 1 and 2.0 or 0.0)
			draw:AddTriangle(sx, sy, 12.5+thick, (soff < 0 and 0 or 180), col)
			draw:AddTriangle(tx, ty, 8.5+thick, (toff > 0 and 0 or 180), col)
			draw:AddBezierCurve(sx, sy + (soff < 0 and -9 or 9), sx, sy + soff, tx, ty + toff, tx, ty + (toff < 0 and -4 or 4), col, 3+thick)
		end
	end
end

function BlueprintEditor:links_refresh()
	self.links.on_draw = function(draw) self:links_on_draw(draw) end
end

function BlueprintEditor:link_on_drag_start(payload, is_click_drag)
	if is_click_drag then return end

	UI.PlaySound("fx_ui_ELEMENT_DRAG")
	if Input.IsControlDown() then
		return UI.New("Reg", { icon = payload.def_id and payload.image.image, coord = payload.coord, entity = payload.entity, num = payload.num, bg = not payload.def_id and "reg_base_ro" or false })
	end

	-- start line drawing
	self.dragsource = payload
	self:links_refresh()
	return UI.New("Spacer") -- empty drag visual
end

function BlueprintEditor:link_on_drag_cancel(payload, visual, drag_was_aborted)
	if not self.dragsource then return end -- copy value
	self.dragsource = nil
	if drag_was_aborted then return end -- drag aborted by pressing right-click

	local entity, hover_entity = self.entity, View.GetHoveredEntity()
	if hover_entity and not Input.IsAltDown() then
		if not self.is_remote then return end -- can't make entity references in local library
		if LocationBlockedByBlight(hover_entity, "cannot lock on to target inside the blight", entity) then return end
		self:reg_set(payload, { entity = hover_entity }, nil, true)
	else
		if UI.IsMouseOverUI() then return end
		local x, y = View.GetHoveredTilePosition()
		local coord = { x = x, y = y }
		if LocationBlockedByBlight(coord, "cannot lock on to target inside the blight", entity) then return end
		self:reg_set(payload, { coord = coord }, nil, true)
	end
end

function BlueprintEditor:link_create(src, trg)
	if trg == src then return end -- dragging onto itself, probably aborting
	if trg.read_only then return MessagePopup(trg, "Can't link to a read-only register") end

	local tkey, skey, unit_links = trg.key, src.key, self.unit.links
	if not tkey then tkey = self:allocate_inherent_component(trg) end
	if not skey then skey = self:allocate_inherent_component(src) end
	if not unit_links then unit_links = {} end

	local function HasConnection(a, b)
		for i,v in ipairs(unit_links) do
			if v[1] == a and (v[2] == b or HasConnection(v[2], b)) then return true end
			if v[1] == b and (v[2] == a or HasConnection(v[2], a)) then return true end
		end
	end

	local existing = (function() for i,v in ipairs(unit_links) do if v[1] == tkey and v[2] == skey then return i end end end)()
	if existing then
		table.remove(unit_links, existing)
		if #unit_links == 0 then self.unit.links = nil end
		self:inherent_refresh()
	elseif not HasConnection(tkey, skey) then
		unit_links[#unit_links + 1] = { tkey, skey }
		if #unit_links == 1 then self.unit.links = unit_links end
		local unit_regs = self.unit.regs
		if unit_regs and unit_regs[tkey] then
			self:reg_set(trg) -- skip reg_apply to avoid that calling self:inherent_refresh()
			unit_regs[tkey] = nil
			if not next(unit_regs) then self.unit.regs = nil end
		end
	else
		return MessagePopup(trg, "Can't create circular link connection")
	end
	self:links_refresh()
end

function BlueprintEditor:link_on_drop(droppedon, payload, cursor)
	if self.dragsource then -- make link
		self.dragsource = nil
		self:link_create(payload, droppedon)
	elseif payload.dragtype == 'BPREGISTER' then -- copy register
		if droppedon.read_only then return MessagePopup(droppedon, "Can't set a read-only register") end
		local payload_id, payload_num, payload_coord, payload_entity = payload.def_id, payload.num, payload.coord, payload.entity
		local payload_reg = (payload_id or payload_num or payload_coord or payload_entity) and { id = payload_id, num = payload_num, coord = payload_coord, entity = payload_entity } or nil
		self:reg_set(droppedon, payload_reg, nil, true)
	else -- copy other value
		local drag_id, drag_num = self:GetDragId(payload, cursor)
		if drag_num and droppedon.read_only then return MessagePopup(droppedon, "Can't set a read-only register") end
		if drag_num then self:reg_set(droppedon, { id = drag_id, num = drag_num }, nil, true) end
	end
end

function BlueprintEditor:toggle_power(btn)
	self.unit.powered_down = btn.active or nil
	btn.active = not btn.active
end

function BlueprintEditor:toggle_disconnected(btn, mousebtn)
	if mousebtn ~= 'RIGHTMOUSEBUTTON' then
		local disconnect = btn.active
		btn.active = not disconnect
		if disconnect == btn.nil_value then disconnect = nil end
		self.unit.disconnected = disconnect
		return
	end

	local function check(btn, state) btn.icon = state and "icon_small_confirm" or nil end

	local logistics = self.unit.logistics
	if not logistics then logistics = {} end

	UI.MenuPopup([[<Box padding=8><VerticalList id=logilist child_padding=4><Text text="Logistics Network Configuration" style=hl textalign=center margin_bottom=16/></VerticalList></Box>]], {
		construct = function(w)
			for _,v in ipairs(data.logistics_flags) do
				if v.flag then
					local hl = w.logilist:Add("<HorizontalList child_padding=8><Text fill=true/><Button width=24 height=24/></HorizontalList>")
					local flag, val, txt, btn = v.flag, logistics[v.flag], hl[1], hl[2]
					if val == nil then val = v.default end
					local function click()
						val = not val
						check(btn, val)
						if val == v.default then logistics[v.flag] = nil else logistics[v.flag] = val end
						self.unit.logistics = EmptyTableAsNil(logistics)
					end
					txt.text, txt.on_click, btn.on_click = v.label, click, click
					check(btn, val)
				else
					w.logilist:Add("<Spacer height=10/>")
				end
			end
		end,
	}, btn)
end

function BlueprintEditor:on_click_request(btn)
	local filter_slot_type = {}
	for i,w in ipairs(self.slotwrap) do
		filter_slot_type[w.type] = true
	end
	local largest_socket = 0
	for i,w in ipairs(self.complist) do
		largest_socket = math.max(largest_socket, (w.socket_sizenum or 0))
	end
	UI.MenuPopup([[<Box bg=popup_box_bg padding=4 blur=true>
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
							<Combo id=type fill=true disabled=true/>
						</HorizontalList>
						<HorizontalList child_padding=8 margin_top=8 margin_left=8 margin_right=4>
							<Text valign=center text="Request Channel:" min_width=160/>
							<Combo id=channel fill=true/>
						</HorizontalList>
					</VerticalList>
				</Box>
				<Text text="Request by Blueprint Parameter" halign=center margin_bottom=8 margin_top=16/>
				<ScrollList orientation=horizontal id=params child_padding=4 margin_bottom=16/>
				<RegisterSelection width=626 max_height=600 on_set={on_request} def_filter={def_filter} hide_clear_button=true apply_text="Request Item - Hold Shift to keep window open"/>
			</VerticalList>
		</Box>]], {
		def_filter = function(def, cat)
			return (filter_slot_type[def.slot_type] and cat.defs ~= data.frames and def.attachment_size ~= "Hidden") or cat.number_panel or (largest_socket and def.attachment_size and (GetAttachmentSize(def.attachment_size) <= largest_socket))
		end,
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			menu.type.texts = { "Recurring Request (Keep Filled Up to Amount)" }
			menu.channel.texts = { "Default Channel(s)", "On Channel 1", "On Channel 2", "On Channel 3", "On Channel 4" }
			menu:refresh()
			for i,entry in ipairs(self.bp.params or {}) do
				local name = entry[1]
				local paramregw = menu.params:Add("<Reg def_id=v_blueprint_param on_click={on_click_param}/>")
				paramregw.num = i
				paramregw.tooltip = NOLOC(name)
			end
			menu.params.hidden, menu.params.previous_sibling.hidden = #menu.params == 0, #menu.params == 0
		end,
		refresh = function(menu)
			menu.orders:Clear()
			for i,o in ipairs(self.unit.recurring_orders or {}) do
				local r = menu.orders:Add("<Reg on_click={on_remove} bg=item_disabled/>", {
					def_id = type(o[1]) == "number" and "v_blueprint_param" or o[1], num = type(o[1]) == "number" and o[1] or o[2],
				})
				r:Add('<Image dock=top-right width=22 height=22 color=ui_light image=icon_processing tooltip="Recurring Request (Keep Filled Up to Amount)"/>')
				if o[3] then r:Add('<Image dock=top-left width=22 height=22 color=ui_light/>', data.order_channel_bit_images[o[3]]) end
			end
			menu.activebox.hidden = #menu.orders == 0
		end,
		on_remove = function(menu, reg)
			table.remove(self.unit.recurring_orders, reg.child_index)
			self.unit.recurring_orders = EmptyTableAsNil(self.unit.recurring_orders)
			btn.active = self.unit.recurring_orders ~= nil
			menu:refresh()
		end,
		on_request = function(menu, regsel, res)
			local id, num
			if type(res) == "number" then -- blueprint parameter index
				id, num = res, false
			elseif res.id then
				id, num = res.id, (res.num and res.num > 0 and res.num) or 1
			else return end
			local channel = menu.channel.value and menu.channel.value > 1 and (menu.channel.value - 1) or nil
			self.unit.recurring_orders = self.unit.recurring_orders or {}
			self.unit.recurring_orders[#self.unit.recurring_orders+1] = { id, num, (channel and (1 << (channel-1)) or nil) }
			btn.active = true
			if Input.IsShiftDown() then
				menu:refresh()
			else
				UI.CloseMenuPopup(menu)
			end
		end,
		on_click_param = function(menu, paramregw)
			menu:on_request(nil, paramregw.num)
		end
	}, btn, 'UP')
end

function BlueprintEditor:on_click_params(btn)
	local bp = self.bp
	UI.MenuPopup([[<Box bg=popup_box_bg padding=12 blur=true>
			<VerticalList>
				<ScrollList id=list width=600 min_height=200 max_height=500 child_padding=8/>
				<Button text="Add New Parameter" on_click={on_click_add} margin_top=8/>
			</VerticalList>
		</Box>]], {
		construct = function(menu)
			menu:refresh()
		end,
		refresh = function(menu)
			menu.list:Clear()
			for i,entry in ipairs(bp.params or {}) do
				local name, val = entry[1], entry[2]
				menu.list:Add([[<HorizontalList child_align=center>
					<MiniReg def_id=v_blueprint_param num={num}/>
					<Text text="Name:" margin_left=16 margin_right=8/>
					<InputText fill=true height=27 on_change={on_change_name} textalign=left padding=3 text={name}/>
					<Text text="Default Value:" margin_left=16 margin_right=8/>
					<Reg on_click={on_val_click} def_id={val_id} entity={val_entity} coord={val_coord} num={val_num}/>
					<Button margin_left=16 id=delbtn icon=icon_remove on_click={on_remove_click} tooltip="Remove"/>
				</HorizontalList>]], { num = i, name = name, val_id = val and val.id, val_entity = val and val.entity, val_coord = val and val.coord, val_num = val and val.num  })
			end
		end,
		on_click_add = function(menu)
			bp.params = bp.params or {}
			bp.params[#bp.params+1] = {}
			menu:refresh()
			menu.list:SetScrollOffset(999999)
			menu.list[#bp.params][3]:Focus()
			self.paramsbtn.active = true
		end,
		on_change_name = function(menu, row, inp, name)
			bp.params[row.num][1] = name ~= "" and name or nil
		end,
		on_val_click = function(menu, regw)
			local row = regw.parent
			local function register_on_set(rsel, val)
				if not val or not next(val) then val = nil elseif val.num == 0 and (val.id or val.entity or val.coord) then val.num = nil end
				bp.params[row.num][2], row.val_id, row.val_entity, row.val_coord, row.val_num = val, val and val.id, val and val.entity, val and val.coord, val and val.num
			end
			local rsel = ShowRegisterSelection(regw, register_on_set)
			if rsel then rsel:SetRegister({ id = regw.def_id, entity = regw.entity, coord = regw.coord, num = regw.num }) end
		end,
		on_remove_click = function(menu, row)
			local n, multi, self_unit = row.num, bp.multi, self.unit
			row:RemoveFromParent()
			table.remove(bp.params, n)
			bp.params = EmptyTableAsNil(bp.params)
			self.paramsbtn.active = bp.params ~= nil

			for m=1,(multi and #multi or 1) do
				local unit = multi and multi[m] or bp
				for regkey,v in pairs(unit.regs or {}) do
					if type(v) == "number" and v >= n then
						unit.regs[regkey] = (v > n and v - 1 or nil)
						if unit == self_unit then self:reg_set(self.regwidgets[regkey], unit.regs[regkey]) end
					end
				end
				for i,v in pairs(unit.locks or {}) do
					if type(v) == "number" and v >= n then
						unit.locks[i] = (v > n and v - 1 or nil)
						unit.locks = EmptyTableAsNil(unit.locks)
						if unit == self_unit then self:slots_refresh() end
					end
				end
				for i=(unit.recurring_orders and #unit.recurring_orders or 0),1,-1 do
					local v = unit.recurring_orders[i][1]
					if type(v) == "number" and v >= n then
						if v == n then table.remove(unit.recurring_orders, i)
						else unit.recurring_orders[i][1] = v - 1 end
						unit.recurring_orders = EmptyTableAsNil(unit.recurring_orders)
						if unit == self_unit then self.btnrequest.active = unit.recurring_orders ~= nil end
					end
				end
			end
		end
	}, btn, 'UP')
end

function BlueprintEditor:on_unitname(input, text)
	local solo, frame_def = (self.unit == self.bp), data.frames[self.unit.frame]
	if text and (#text == 0 or text == self.defaultname) then text = nil end
	if solo then
		self.bp.name = text
		self:SendEvent("on_refresh", self.bp)
		self.name = NOLOC(text or self.defaultname)
	else
		if text and text == NOLOC(L(frame_def and frame_def.name or "")) then text = nil end
		self.unit.name = text
	end
end

function BlueprintEditor:site_need_upgrade()
	if self.source_entity and self.source_entity.is_construction then return true end
	local old_bp, new_bp = self.source_bp, self.bp
	if old_bp.frame ~= new_bp.frame then return true end
	local old_components, new_components, i, j = old_bp.components, new_bp.components, 1, 1
	while true do
		local oldc, newc = old_components and old_components[i], new_components and new_components[j]
		if not oldc and not newc then break
		elseif oldc and type(oldc[2]) ~= "number" then i = i + 1
		elseif newc and type(newc[2]) ~= "number" then j = j + 1
		elseif oldc and newc and oldc[1] == newc[1] and oldc[2] == newc[2] then i, j = i + 1, j + 1
		else return true end
	end
	return Tool.Hash(old_bp.locks) ~= Tool.Hash(new_bp.locks)
end

function BlueprintEditor:on_ui_cancel()
	if not self.is_site then return false end
	self:close_site_popup(true)
end

function BlueprintEditor:on_ui_accept()
	if self.on_ok then
		self:SendEvent("on_ok", self.bp)
		return
	end
	if not self.is_site then return false end
	local bp, source_entity, rotation, bot_upgrade = self.bp, self.source_entity, self.build_rotation
	if source_entity then
		local new_id = bp.frame
		if not self:site_need_upgrade() then
			Notification.Warning(L("Apply settings onto %s", GetEntityName(source_entity)))
			if Tool.Hash(self.source_bp) == Tool.Hash(bp) then bp = nil end
			if rotation == source_entity.rotation then rotation = nil end
			if bp or rotation then
				ProcessLibraryBlueprint(bp, function(pbp) Action.SendForLocalFaction("ApplySettings", { entity = source_entity, bp = pbp or nil, rotation = rotation }) end)
			end
			self:close_site_popup(true)
			return
		end

		local upgrade_err = CheckDeconstruct(source_entity, new_id)
		if upgrade_err then return Notification.Warning(L("%s: %s", "Unit upgrade unavailable", upgrade_err)) end

		local source_def = GetBuiltFrameDef(source_entity)
		bot_upgrade = source_def and source_def.type == nil and (source_def.movement_speed or 0) > 0 and source_entity
	end

	local args = { custom_blueprint = true, start_paused = self.build_paused }
	if bot_upgrade then args.bot_upgrade = bot_upgrade else args.locations, args.rotation, args.upgrade = self.build_locations, rotation, true end
	ProcessLibraryBlueprint(bp, function(pbp) args.custom_blueprint = pbp Action.SendForLocalFaction("PlaceConstruction", args) end)
	self:close_site_popup(false)
end

function BlueprintEditor:switch_frame(frame_id)
	local old_components, new_components = self.unit.components
	if old_components then
		local new_frame_def = data.frames[frame_id]
		local new_sockets = Tool.Copy((type(new_frame_def.visual) == "table" and new_frame_def.visual or data.visuals[new_frame_def.visual]).sockets) or {}

		-- First unassign any components that don't have the same size at the same socket index anymore
		new_components = Tool.Copy(old_components)
		for _,unit_comp in ipairs(new_components) do
			local comp_def = data.components[unit_comp[1]]
			local new_socket = type(unit_comp[2]) == "number" and new_sockets[unit_comp[2]]
			if new_socket and GetAttachmentSize(new_socket[2]) == (comp_def and GetAttachmentSize(comp_def.attachment_size)) then
				new_sockets[unit_comp[2]] = false -- remember as used
			elseif unit_comp[2] ~= "hidden" then
				unit_comp[2] = false -- try to find a new socket below
			end
		end

		-- Then try to assign inherent frame components first directly then via base_id
		if new_frame_def.components then
			for _,new_inherent_comp in ipairs(new_frame_def.components) do
				for _,unit_comp in ipairs(new_components) do
					if unit_comp[2] == false and unit_comp[1] == new_inherent_comp[1] then unit_comp[2] = 'inherent' goto assigned end
				end
				local inherent_comp_def = data.components[new_inherent_comp[1]]
				local inherent_base_id = inherent_comp_def and inherent_comp_def.base_id
				for _,unit_comp in ipairs(new_components) do
					local unit_comp_def = unit_comp[2] == false and data.components[unit_comp[1]]
					if unit_comp_def and unit_comp_def.base_id == inherent_base_id then unit_comp[1], unit_comp[2] = new_inherent_comp[1], 'inherent' goto assigned end
				end
				::assigned::
			end
		end

		-- Last try to find any matching socket for the remaining components
		for _,unit_comp in ipairs(new_components) do
			if unit_comp[2] == false then
				local comp_def = data.components[unit_comp[1]]
				local comp_size, best_size_diff, best_socket_index = (comp_def and GetAttachmentSize(comp_def.attachment_size)), 999
				for socket_index,new_socket in ipairs(new_sockets) do
					local size_diff = (new_socket and GetAttachmentSize(new_socket[2]) or 0) - comp_size
					if size_diff >= 0 and size_diff < best_size_diff then
						best_size_diff, best_socket_index = size_diff, socket_index
					end
				end
				if best_socket_index then
					new_sockets[best_socket_index] = false -- remember as used
					unit_comp[2] = best_socket_index
				end
			elseif unit_comp[1] == "c_integrated_behavior" and (new_frame_def.race ~= "robot" or new_frame_def.no_integrated_behavior) then
				unit_comp[2] = false
			end
		end

		local has_unassigned
		for _,unit_comp in ipairs(new_components) do if unit_comp[2] == false then has_unassigned = true break end end
		if not has_unassigned then old_components = nil end
	end

	local function do_switch()
		local locks = self.bp.locks
		if locks then -- for locking, check "storage" slots only
			local old_slots = data.all[self.unit.frame].slots
			if old_slots then old_slots = old_slots.storage end
			local new_slots = data.all[frame_id].slots
			if new_slots then new_slots = new_slots.storage end

			-- Do nothing is old and new slots are same size or less
			if old_slots and new_slots and new_slots > old_slots then
				local first_lock = locks[1]
				local last_lock = locks[old_slots]
				-- For certain somewhere is locked, so start off with just a regular lock
				local new_lock = true
				-- If exists, try to lock to item found in last slot first and then first slot second
				if last_lock then new_lock = last_lock
				elseif first_lock then new_lock = first_lock end
				-- lock all the new slots
				for i=(old_slots+1),new_slots do locks[i] = new_lock end
			end
		end

		-- calling setup_unit() will clean up any unassigned components (those still marked with unit_comp[2] == false)
		self:fix_build_rotation(self.unit.frame, frame_id)
		self.unit.frame = frame_id
		self.unit.components = new_components and EmptyTableAsNil(new_components)
		self:setup_unit()
		self:icon_refresh()
	end

	if old_components then
		ConfirmPopup(self.frameimg, L("%s\n%s", "The new frame is unable to hold all components.", "Are you sure you want to continue?"), function() do_switch() end)
	else
		do_switch()
	end
end

local function get_visual_size(frame_def)
	local visual = frame_def and frame_def.visual
	local visual_def = visual and (type(visual) == "table" and visual or data.visuals[visual])
	local tile_size = visual_def and visual_def.tile_size
	return tile_size and tile_size[1] or 1, tile_size and tile_size[2] or 1, visual_def
end

local function get_frame_similar_filters(cur_frame_def)
	local cur_tx, cur_ty, cur_visual_def = get_visual_size(cur_frame_def)
	local cur_frame_bot = (cur_frame_def.movement_speed or 0) > 0
	local cur_frame_flying = (cur_frame_def.cost_modifier == 0)
	local cur_bot_socketed = (cur_frame_bot and #(cur_visual_def and cur_visual_def.sockets or "") > 0)
	local cur_bot_producers = (cur_frame_bot and cur_frame_def.production_recipe and cur_frame_def.production_recipe.producers)
	return cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers
end

local function match_frame_def(cur_frame_def, cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers, frame_def, want_similar, anysize)
	local frame_type = frame_def ~= cur_frame_def and (frame_def.production_recipe or frame_def.construction_recipe) and frame_def.visual and (frame_def.type or true)
	if not frame_type or frame_type == "Foundation" or (not want_similar and frame_type ~= true) then return end
	local match_bot = anysize or cur_frame_bot == ((frame_def.movement_speed or 0) > 0)
	local match_flying = anysize or cur_frame_flying == (frame_def.cost_modifier == 0)
	local match_slot_type = anysize or frame_def.slot_type == cur_frame_def.slot_type
	if not match_bot or not match_flying or not match_slot_type then return end
	local tx, ty, visual_def = get_visual_size(frame_def)
	local match_size = anysize or (tx == cur_tx and ty == cur_ty) or (tx == cur_ty and ty == cur_tx)
	local match_bot_socketed = anysize or not cur_frame_bot or (visual_def and cur_bot_socketed == (#(visual_def.sockets or "") > 0))
	if cur_frame_bot and want_similar and match_size then
		local bot_producers = frame_def.production_recipe and frame_def.production_recipe.producers
		match_size = false
		if cur_bot_producers and bot_producers then for k,_ in pairs(cur_bot_producers) do if bot_producers[k] then match_size = true break end end end
	end
	return match_size and match_bot_socketed
end

local function is_compatible_frame(cur_frame_id, frame_id, want_similar)
	if cur_frame_id == frame_id then return true end
	local cur_frame_def, frame_def, anysize = data.frames[cur_frame_id], data.frames[frame_id], not want_similar
	if not cur_frame_def or not frame_def then return false end
	local cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers = get_frame_similar_filters(cur_frame_def)
	return match_frame_def(cur_frame_def, cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers, frame_def, want_similar, anysize)
end

local function list_frames(cur_frame_def, want_similar)
	local res, anysize, cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers = {}, not want_similar
	if want_similar then cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers = get_frame_similar_filters(cur_frame_def) end
	for _, frame_id in ipairs(Game.GetLocalPlayerFaction().unlocked_frames) do
		local frame_def = data.frames[frame_id]
		if match_frame_def(cur_frame_def, cur_tx, cur_ty, cur_frame_bot, cur_frame_flying, cur_bot_socketed, cur_bot_producers, frame_def, want_similar, anysize) then
			res[frame_def] = true
		end
	end
	return res
end

function BlueprintEditor:on_change_frame()
	if self.changeframe.disabled then return end

	local cur_frame_id = self.unit.frame
	local cur_frame_def = data.frames[cur_frame_id]
	local frames = list_frames(cur_frame_def, self.is_site or self.bp.multi ~= nil or self.want_similar)
	frames[cur_frame_def] = true
	UI.MenuPopup([[<Box bg=popup_box_bg padding=8 blur=true>
			<VerticalList child_padding=8>
				<Text text="Change Frame" halign=center/>
				<SimpleRegisterSelection width=626 max_height=536 on_select_id={on_select} def_filter={def_filter} current_id={current_id}/>
			</VerticalList>
		</Box>]], {
		current_id = cur_frame_id, def_filter = function(def) return frames[def] end,
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
		end,
		on_select = function(menu, regsel, id)
			UI.CloseMenuPopup(menu)
			self:switch_frame(id)
		end,
	}, self.changeframe, 'UP')
end

function BlueprintEditor:select_base_frame()
	self[1].hidden = true
	local frames = list_frames()
	self:Add([[<VerticalList dock=fill margin=8 child_padding=8>
			<Text textalign=center text="Select Blueprint Base"/>
			<SimpleRegisterSelection width=626 max_height=536 on_select_id={on_select} def_filter={def_filter}/>
		</VerticalList>]], {
		def_filter = function(def) return frames[def] end,
		on_select = function(w, regsel, id)
			w:RemoveFromParent()
			self[1].hidden = false
			self:switch_frame(id)
		end,
	})
end

function BlueprintEditor:fix_build_rotation(old_id, new_id) -- Fix for "v_base3x2b" which is actually a 2x3
	if old_id == new_id or not self.build_rotation then return end
	local old_tx, old_ty = get_visual_size(data.frames[old_id])
	local new_tx, new_ty = get_visual_size(data.frames[new_id])
	if old_tx ~= new_tx or old_ty ~= new_ty then self.build_rotation = (self.build_rotation + 4 + (new_tx > old_tx and 1 or -1)) % 4 end
end

function BlueprintEditor:copy(unit)
	local item = PackLibraryItemToCompactedItem(self.library, unit, 'B') -- copy
	item.desc, item.icon, item.x, item.y, item.rotation = nil, nil, nil, nil, nil -- meta and multi blueprint fields
	item.params = Tool.Copy(self.bp.params) -- store params if copying a multi blueprint unit
	Tool.SetClipboard(item, 'B')

	local frame_def = data.frames[item.frame]
	local frame_name = NOLOC(item.name) or (frame_def and frame_def.name) or "Unnamed"
	Notification.Warning(L("Copied settings from %s", frame_name))
end

function BlueprintEditor:paste(unit)
	local item = UnitCopyPaste.GetItem('B')
	if not item or item.multi or not item.frame then return Notification.Warning("Need to copy settings first") end
	if not is_compatible_frame(unit.frame, item.frame, self.is_site or self.bp.multi ~= nil or self.want_similar) then return Notification.Warning("Invalid Target") end

	local frame_def = data.frames[unit.frame]
	local frame_name = NOLOC(unit.name) or (frame_def and frame_def.name) or "Unnamed"
	Notification.Warning(L("Apply settings onto %s", frame_name))

	UILibraryImportBlueprint(item, function(item_bp)
		local bp = self.bp
		local params, desc, icon, name, x, y, rotation = bp.params, bp.desc, bp.icon, bp.name, unit.x, unit.y, unit.rotation -- params, meta and multi blueprint fields
		if item_bp.params then
			params = params or {}
			for i,v in ipairs(item_bp.params) do params[i] = params[i] or v end
		end
		for k,_ in pairs(unit) do unit[k] = nil end
		for k,v in pairs(item_bp) do unit[k] = v end
		bp.params, bp.desc, bp.icon, bp.name, unit.x, unit.y, unit.rotation = params, desc, icon, name, x, y, rotation
		self:setup_unit() -- always call to refresh multi preview if needed
		self.paramsbtn.active = params ~= nil -- refresh button active state
	end, nil, self.library)
end

function BlueprintEditor:on_click_options(w)
	local unit = self.unit

	UI.MenuPopup([[<Box padding=5><VerticalList child_padding=-1>
		<Button id=copybtn text='Copy Settings (<Key action="UnitCopy"/>)' on_click={on_copy}/>
		<Button id=pastebtn text='Paste Settings (<Key action="UnitPaste"/>)' on_click={on_paste}/>
		<Button id=addbtn text="Set Integrated Behavior" on_click={on_click_add_behavior}/>
		<Button id=removebtn text="Remove Integrated Behavior" on_click={on_click_remove_behavior}/>
		</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			local integrated_behavior
			for _,comp in ipairs(unit.components or {}) do
				if comp[1] == "c_integrated_behavior" then integrated_behavior = true break end
			end
			menu.addbtn.hidden = integrated_behavior
			menu.removebtn.hidden = not integrated_behavior
			local clipboard_bp = UnitCopyPaste.GetItem('B')
			menu.pastebtn.hidden = not (clipboard_bp and is_compatible_frame(unit.frame, clipboard_bp.frame, self.is_site or self.bp.multi ~= nil or self.want_similar))
		end,
		on_copy = function()
			UI.CloseMenuPopup()
			self:copy(unit)
		end,
		on_paste = function()
			UI.CloseMenuPopup()
			self:paste(unit)
		end,
		on_click_add_behavior = function(menu, btnselect)
			UILibrarySelect(btnselect, 'C',
				function(item)
					if not unit.components then unit.components = {} end
					table.insert(unit.components, { "c_integrated_behavior", "hidden", item.id })
					self:setup_unit()
					UI.CloseMenuPopup(menu)
				end, -- select option
				nil, -- no clear option
				nil, -- no create option
				nil, 'c_integrated_behavior', self.library)
		end,
		on_click_remove_behavior = function(menu)
			for i,comp in ipairs(unit.components or {}) do
				if comp[1] == "c_integrated_behavior" then self:RemoveComponentEntry(i) break end
			end
			self:setup_unit()
			UI.CloseMenuPopup(menu)
		end,
	}, w, w and 'UP' or 'DOWN')
end

local open_bp_edit_box
function StartCustomConstruction(source_entity, source_bp, build_locations, build_rotation, auto_apply)
	if open_bp_edit_box and open_bp_edit_box:IsValid() then open_bp_edit_box:RemoveFromParent() end
	local editor = UI.New("BlueprintEditor", {
		source_entity = source_entity,
		source_bp = source_bp,
		build_locations = build_locations,
		build_rotation = build_rotation,
		library = Game.GetLocalPlayerFaction().extra_data.library or {},
		is_remote = true,
		is_site = true,
	})
	if auto_apply then
		editor:construct()
		editor:on_ui_accept()
	else
		open_bp_edit_box = UI.AddLayout("<Box dock=center bg=popup_box_bg padding=4 blur=true/>")
		open_bp_edit_box:Add("<Box bg=popup_pattern/>"):Add(editor)
	end
end
