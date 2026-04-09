local Program_layout<const> = [[
<Modal dock=fill>
	<Canvas>
		<Image dock=fill image=tech_tree_pattern_bg/>
		<Image dock=fill image=tech_tree_pattern/>
		<VerticalList fill=true margin=2 child_padding=6>
			<HorizontalList child_padding=8 child_align=top>
				<VerticalList child_padding=2>
					<Image id=imgicon width=56 height=56 on_click={on_icon} tooltip="Click to change icon"/>
					<Button id=btnoptions width=28 height=28 halign=center icon=icon_cog tooltip="Behavior Options" on_click={on_click_options} zoom=-1/>
				</VerticalList>
				<VerticalList fill=true>
					<Text text={title} size=24 style=bl on_click={on_rename} tooltip="Click to rename"/>
					<Text text={desc} size=12 style=bl on_click={on_edit_desc} tooltip="Click to edit description" margin_left=3 height=19 clip=true/>
					<Text id=txtactive size=12 style=gl margin_top=5 margin_left=4/>
				</VerticalList>
				<HorizontalList>
					<Text id=pausedbox hidden=true dock=center text="Game is Paused" margin_right=24 style=notify_info/>
					<Box padding=2>
						<HorizontalList child_padding=2>
							<Button width=50 height=50 icon=icon_save on_click={on_click_savenew} tooltip="Save As New Behavior" id=btnsavenew/>
							<Button width=50 height=50 icon=icon_remove on_click={on_click_clear} tooltip="Clear Behavior"/>
							<Button width=50 height=50 icon=icon_question on_click={on_click_help} tooltip="Show Help"/>
						</HorizontalList>
					</Box>
				</HorizontalList>
			</HorizontalList>
			<ScrollList orientation=horizontal height=90 child_padding=6 child_align=top>
				<Box padding=4>
					<VerticalList child_padding=4>
						<Text text="Base Registers" height=18 textalign=center/>
						<HorizontalList id=reglist child_padding=4/>
					</VerticalList>
				</Box>
				<HorizontalList id=paramlist child_padding=4 on_drop={param_on_drop} on_drag_over={param_on_drag_over} on_drag_leave={param_on_drag_leave} child_align=top/>
			</ScrollList>
			<HorizontalList fill=true child_padding=6>
				<Box padding=4 width=240 bg=card_box_bg>
					<VerticalList child_padding=4>
						<TextSearch on_refresh={on_filter}/>
						<ScrollList fill=true id=toolbox/>
						<Camera id=dbgcam width=200 height=200 hidden=true/>
					</VerticalList>
				</Box>
				<VerticalList fill=true child_padding=6>
					<Canvas fill=true>
						<Box fill=true bg=card_box_bg>
							<PanView margin=2 id=pan on_mouse_button_down={graph_on_mouse_button_down} on_mouse_button_up={graph_on_mouse_button_up} on_drag_start={graph_on_drag_start} on_drag_cancel={graph_on_drag_cancel} on_drop={graph_on_drop} on_drag_over={graph_on_drag_over} on_drag_leave={graph_on_drag_leave} on_mouse_wheel={on_pan_mouse_wheel} zoom=1>
								<Canvas id=graph/>
								<Draw id=draw/>
								<Draw id=drawdrag/>
							</PanView>
						</Box>
						<Button width=32 height=32 halign=right margin_top=4 margin_right=4 icon=icon_small_zoom_in tooltip="Zoom In" on_click={on_click_zoom} zoom=1/>
						<Button width=32 height=32 halign=right margin_top=4 margin_right=40 icon=icon_small_zoom_out tooltip="Zoom Out" on_click={on_click_zoom} zoom=-1/>
						<Box id=help_popup padding=8 width=450 dock=bottom-left blur=true hidden=true>
							<ScrollList id=help_scrolllist max_height=400 padding=8 margin_bottom=20>
								<HorizontalList>
									<Canvas><Image image={help_popup_img} width=56 max_height=56 color=ui_light/></Canvas>
									<VerticalList halign=left fill=true width=400>
										<Text size=16 text={help_popup_name}/>
										<Text text={help_popup_desc} wrap=true wrapwidth=400 style=bl/>
									</VerticalList>
								</HorizontalList>
								<Canvas id=explain width=450 height=200>
									<Image dock=fill image=tech_tree_pattern_bg/>
									<Image dock=fill image=tech_tree_pattern/>
									<PanView width=450 height=200 id=explain_panview on_mouse_wheel={on_pan_mouse_wheel}>
										<Canvas id=explain_graph/>
										<Draw id=explain_draw/>
									</PanView>
									<Button icon=icon_paste dock=top-right width=32 height=32 on_click={on_explain_insert} tooltip="Append Code to Behavior"/>
								</Canvas>
								<VerticalList id=argslist child_padding=4 padding=8/>
								<Text margin_top=18 text={help_popup_explain} wrap=true/>
							</ScrollList>
						</Box>
					</Canvas>
					<HorizontalList>
						<HorizontalList id=help_panel child_padding=16>
							<Button id=help_button on_click={on_help_popup} icon=icon_question color= tooltip="Show Explanation" active=true/>
							<Text size=20 valign=center id=help_inst_name text="Select Node for help on that instruction" margin_right=8/>
						</HorizontalList>
						<Spacer fill=true/>
						<Box padding=2 margin_right=6 id=dbgsel_box>
							<HorizontalList child_padding=2>
								<Button icon=icon_test id=dbgvalues on_click={on_click_debug_values} tooltip="View Current Values" disabled=true/>
								<Button icon=icon_small_view_list width=52 height=52 id=dbgarray on_click={on_click_debug_array} tooltip="Memory Viewer" disabled=true/>
								<Button icon=icon_map id=dbgtarget on_click={on_click_debug_target} tooltip="Inspect Running Behavior"/>
							</HorizontalList>
						</Box>
						<Box padding=2 margin_right=24 id=dbgbtn_box disabled=true opacity=0.5>
							<HorizontalList child_padding=2>
								<Button icon=icon_stop       id=btndbgstop     on_click={on_click_run} debug=STOP     tooltip="Stop Program"/>
								<Canvas>
									<Button icon=icon_play   id=btndbgstart    on_click={on_click_run} debug=CONTINUE tooltip="Start Program"/>
									<Button icon=icon_pause  id=btndbgpause    on_click={on_click_run} debug=PAUSE    tooltip="Pause Program"/>
									<Button icon=icon_play   id=btndbgcontinue on_click={on_click_run} debug=CONTINUE tooltip="Continue Program"/>
									<Image image=icon_small_day color="#E41400" dock=top-right hidden={hide_bpntlight}/>
								</Canvas>
								<Button icon=icon_next       id=btndbgstep     on_click={on_click_run} debug=STEP     tooltip="Step"/>
							</HorizontalList>
						</Box>
						<Box padding=2 margin_right=6 id=undoredo_box>
							<HorizontalList child_padding=2>
								<Button icon=icon_undo on_click={on_click_undoredo} id=btnundo tooltip="Undo"/>
								<Button icon=icon_undo on_click={on_click_undoredo} id=btnredo tooltip="Redo" redo=true sx=-1/>
							</HorizontalList>
						</Box>
						<Box padding=2 id=remoteconfirm_box>
							<HorizontalList child_padding=2>
								<Button icon=icon_save on_click={remote_apply} tooltip="Apply" id=btnremoteapply disabled=true/>
								<Button icon=icon_deny on_click={remote_cancel} tooltip="Close" id=btnremotecancel/>
								<Button icon=icon_confirm on_click={close} tooltip="Apply and Close" id=btnremoteconfirm disabled=true/>
							</HorizontalList>
						</Box>
						<Box padding=2 id=localconfirm_box>
							<Button icon=icon_confirm on_click={close} tooltip="Close"/>
						</Box>
					</HorizontalList>
				</VerticalList>
			</HorizontalList>
		</VerticalList>
	</Canvas>
</Modal>
]]

local Options_layout<const> = [[
	<Canvas>
		<Box bg=popup_box_bg padding=16 blur=true x=16>
			<VerticalList child_padding=16 width=700>
				<Text text="Behavior Options" halign=center margin_top=4/>
				<HorizontalList child_padding=3>
					<Text width=160 valign=center text="Variables" margin_left=11/>
					<Combo fill=true id=variables on_change={on_change}/>
				</HorizontalList>
				<HorizontalList child_padding=3>
					<Text width=160 valign=center text="Memory Arrays" margin_left=11/>
					<Combo fill=true id=arrays on_change={on_change}/>
				</HorizontalList>
			</VerticalList>
		</Box>
		<Image valign=top image=popup_pointer id=triangle/>
	</Canvas>
]]

local TemplateLibraryItem_layout<const> = [[
	<Box padding=6>
		<HorizontalList child_align=top child_padding=3>
			<Image image=icon_behavior color=ui_light/>
			<VerticalList child_padding=3 child_align=top fill=true>
				<Text text={name} size=25 style=bl/>
				<Text text={info} size=10 style=bl/>
			</VerticalList>
			<Button icon=icon_comp on_click={on_load} tooltip={load_text} id=btnload/>
		</HorizontalList>
	</Box>
]]

local Register_layout<const> = [[
	<Reg width=48 height=48 on_drag_start={reg_on_drag_start} on_click={reg_on_click} on_drop={reg_on_drop} tooltip={reg_tooltip}/>
]]

local Parameter_layout<const> = [[
	<Box padding=4 width=120 height=78 on_drag_start={param_on_drag_start}>
		<Canvas>
			<Text text={header} height=18 dock=top textalign=center width=120 clip=true tooltip="Set the parameter name" on_click={param_on_rename} on_drag_start={param_name_on_drag_start}/>
			<Button icon=icon_remove dock=bottom-left width=24 height=24 tooltip="Remove" on_click={param_on_remove}/>
		</Canvas>
	</Box>
]]

local ParamAddButton_layout<const> = [[
	<Box padding=4 width=120 height=78 on_click={param_add_on_click} opacity=0.5 tooltip="Add Parameter">
		<VerticalList child_padding=4>
			<Text text="Add Parameter" height=18 textalign=center/>
		</VerticalList>
	</Box>
]]

local NODEW<const> = 200
local NODEGAP<const> = 300
local Node_layout<const> = [[
	<Box bg=tech_disabled_bg width=200 height=60 padding=0 on_mouse_button_down={node_on_mouse_button_down} on_mouse_button_up={node_on_mouse_button_up} on_double_click={node_on_double_click} on_mouse_enter={node_on_mouse_enter} on_mouse_leave={node_on_mouse_leave} on_drag_start={node_on_drag_start} on_drag_cancel={graph_on_drag_cancel}>
		<Canvas>
			<Box blocking=false color={title_color}>
				<HorizontalList>
					<Image image={icon} width=30 height=30 valign=center color=ui_light/>
					<Text text={title} tooltip={instruction_tooltip} width=166 wrap=true margin=2 valign=center />
				</HorizontalList>
			</Box>
		</Canvas>
	</Box>
]]

local NodeButtons_layout<const> = [[
	<HorizontalList halign=right y=-31>
		<Button id=lockbtn icon=icon_small_locked active=true on_click={nodebtn_lock_on_click}/>
		<Button id=cmtbtn icon=icon_small_edit on_click={nodebtn_comment_on_click} tooltip="Set Comment"/>
		<Button id=extrabtn icon=icon_small_behavior on_click={nodebtn_extra_on_click} tooltip="Toggle Extra Options"/>
		<Button id=nextbtn icon=icon_small_next on_click={nodebtn_setnext_on_click} tooltip="Set Next Instruction"/>
		<Button id=bpntbtn icon=icon_small_day on_click={nodebtn_setbpnt_on_click} tooltip="Set Debug Breakpoint"/>
		<Button icon=icon_small_deny on_click={nodebtn_delete_on_click} tooltip="Remove"/>
	</HorizontalList>
]]

local Argument_layout<const> = [[
	<Reg width=40 height=40 on_click={argument_on_click} on_drag_start={reg_on_drag_start} on_drop={reg_on_drop} tooltip={argument_tooltip}/>
]]

local PINSZ<const>, PINSZ_HOVER<const> = 7, 12
local ExecOutPin_layout<const> = [[
	<Image halign=right x=15 width=30 height=30 tooltip={connection_tooltip} on_mouse_enter={connection_on_mouse_enter} on_mouse_leave={connection_on_mouse_leave} on_drag_start={connection_on_drag_start} on_drag_cancel={connection_on_drag_cancel} color=transparent is_out=true/>
]]

local ExecInPin_layout<const> = [[
	<Image halign=left x=-15 width=30 height=30 on_drag_over={connection_on_drag_over} on_drag_leave={connection_on_drag_leave} on_drop={connection_on_drop} color=transparent is_in=true/>
]]

local Category_layout<const> = [[
	<VerticalList margin_top=5>
		<Button id=catb text={text} icon={icon} on_click={category_on_click} height=32 textalign=left/>
		<VerticalList id=inst_list/>
	</VerticalList>
]]

local Instruction_layout<const> = [[
	<Box on_click={toolbox_item_on_click} on_drag_start={toolbox_on_drag_start} on_drag_cancel={graph_on_drag_cancel} tooltip={instruction_tooltip}>
		<HorizontalList>
			<Image image={icon} width=30 height=30 valign=center color=ui_light/>
			<Text text={title} width=186 wrap=true margin=2 valign=center/>
		</HorizontalList>
	</Box>
]]

local RegDrag_layout<const> = [[
	<Reg width=32 height=32/>
]]

local RegTooltip_layout<const> = [[
	<Box bg=popup_box_bg padding=12 blur=true>
		<VerticalList>
			<Text text={title} margin_bottom=6 textalign=center/>
			<HorizontalList child_align=center hidden={hide_default} margin_bottom=6>
				<Text text="Behavior Initial Value:" margin_right=16 fill=true/>
				<Reg def_id={val_id} num={val_num} entity={val_entity} coord={val_coord}/>
			</HorizontalList>
			<HorizontalList child_align=center hidden={hide_inspect}>
				<Text text="Inspected Current Value:" margin_right=16 fill=true/>
				<Reg comp={inspect_comp} ent={inspect_entity} reg_index={inspect_reg_index} read_only=true/>
			</HorizontalList>
		</VerticalList>
	</Box>
]]

local InputArgument_layout<const> = [[
	<Box bg=popup_pattern padding=4>
		<VerticalList child_padding=4>
			<Text text="Read from Base Register" textalign=center/>
			<HorizontalList id=frameregs child_padding=4/>
			<Text text="Read from Parameter" textalign=center margin_top=10/>
			<ScrollList orientation=horizontal id=params child_padding=4/>
			<Text text="Read from Variable" textalign=center margin_top=10/>
			<ScrollList orientation=horizontal id=vars child_padding=4/>
			<Text text="Read from Faction Register" textalign=center margin_top=10/>
			<ScrollList orientation=horizontal id=fregs child_padding=4/>
			<Text id=fixed_lbl text="Set to Fixed Value" textalign=center margin_top=10/>
			<Button id=clear_btn text="Clear" on_click={on_select} hidden=true/>
		</VerticalList>
	</Box>
]]

local OutputArgument_layout<const> = [[
	<Box bg=popup_pattern padding=4>
		<VerticalList child_padding=4>
			<Text text="Write Result to Base Register" textalign=center/>
			<HorizontalList id=frameregs child_padding=4/>
			<Text text="Write Result to Parameter" textalign=center margin_top=10/>
			<ScrollList orientation=horizontal id=params child_padding=4/>
			<Text text="Write Result to Variable" textalign=center margin_top=10/>
			<ScrollList orientation=horizontal id=vars child_padding=4/>
			<Text text="Write Result to Faction Register" textalign=center margin_top=10/>
			<ScrollList orientation=horizontal id=fregs child_padding=4/>
			<Button text="Clear" on_click={on_select}/>
		</VerticalList>
	</Box>
]]

local Program = {}
UI.Register("Program", Program_layout, Program)

function EntityAction.Behavior(entity, arg)
	--print("[EntityAction.Behavior] entity: " .. tostring(entity):gsub("\n", "") .. " - arg: " .. tostring(arg):gsub("\n", ""), arg.debug)
	local code, comp = arg.code, arg.comp
	if not comp then
		local frame_def = arg.add_integrated and entity.def
		if frame_def and not frame_def.type and frame_def.race == "robot" and not frame_def.no_integrated_behavior then
			if not entity:FindComponent("c_integrated_behavior") then comp = entity:AddComponent("c_integrated_behavior") end
		elseif arg.remove_integrated then
			comp = entity:FindComponent("c_integrated_behavior")
			if comp then comp:Destroy() comp = nil end
		else
			comp = entity:FindComponent("c_behavior", true)
		end

		if not comp then return end
	end

	local library = code and code.id and code.rev and entity.faction.extra_data.library
	if library then
		local id, rev = code.id, code.rev
		ClearFactionBehaviorCache(id, rev)
		code.rev = (rev or 0) + 1
		library[id] = code
	end

	local ed, debug, counter, breakpoints = comp.has_extra_data and comp.extra_data, arg.debug, arg.counter, arg.breakpoints
	if type(comp) ~= "userdata" or entity ~= comp.owner then return end
	if debug and type(debug) ~= "string" then return end

	local set_id, create = library and ed and ed.main_id == code.id and code.id or arg.set_id, arg.create
	if create then
		set_id, debug = (Map.GetSave().library_id_count or 0) + 1, "STOP"
		FactionAction.FactionLibrary(entity.faction, { folder = arg.folder, mode = 'create', item = {}, type = 'C' })
	end

	if set_id then
		SetBehavior(comp, set_id, debug, counter, breakpoints)
	else
		DebugBehavior(comp, debug, counter, breakpoints)
	end

	if arg.reset_reg then
		local main_id = set_id or (comp.has_extra_data and comp.extra_data.main_id) or 0
		if not code then code = entity.faction.extra_data.library[main_id] end
		for i=(arg.reset_reg or 1),math.min(comp.register_count, (code and code.id == main_id and arg.reset_reg_max or 0)) do
			comp:SetRegister(i, code.pinits and code.pinits[i] or nil)
		end
	end

	if create then
		library = entity.faction.extra_data.library
		Action.RunUI(function() OpenMainWindow("Program", { comp = comp, code = Tool.Copy(library[set_id]), is_remote = true, library = library, }) end)
	end
end

function UIMsg.OnBehaviorBreakpoint(comp)
	for i,program_ui in ipairs(UI.FindWidgetsWithTag("Program")) do
		if program_ui.comp == comp then return end
	end
	Notification.Add('BREAKPOINT', data.components.c_behavior.texture, "Behavior Breakpoint", "Debug breakpoint was hit and behavior was paused", {
		on_click = function() if comp.exists then View.JumpCameraToEntities(comp.owner) View.SelectEntities(comp.owner) end return true end,
	})
end

function Program:construct()
	if not self.code then error("missing code") end
	local outer_ui = self.outer_ui
	if outer_ui then
		outer_ui.dbgcam.hidden = true
		if outer_ui.dirtybpnts then outer_ui:remote_do_save(true) end -- save breakpoints
		self.comp, self.is_remote, self.library = outer_ui.comp, outer_ui.is_remote, outer_ui.library
		self[1].margin_left, self[1].margin_right, self[1].margin_top, self[1].margin_bottom = 5, 5, 20, 0
		self.btnoptions.hidden = true -- all current behavior options are only relevant for a main program
	end
	self.selection = {}
	self:PrepareToolBox(self.toolbox)
	self:Refresh(nil, true)
	self:RefreshActive()
	self.dbgsel_box.hidden = not self.is_remote
	self.dbgbtn_box.hidden = not self.is_remote
	self.remoteconfirm_box.hidden = not self.is_remote
	self.localconfirm_box.hidden = self.is_remote
	self.btnsavenew.hidden = not self.is_remote
	self.hide_bpntlight = true
	if self.comp then self:set_debug_target(self.comp) end
	if not Game.GetProfile().behaviors_welcomed then
		self:on_click_help(nil, nil, true)
		Game.GetProfile().behaviors_welcomed = true
	elseif not self.code.name and not self.code[1] and not (self.code.parameters and self.code.parameters[1]) then
		self:on_rename()
	end
end

function Program:destruct()
	self:remote_do_save(true)
end

function Program:set_dirty(dirty, no_undo_state)
	if self.is_dirty ~= dirty then
		self.is_dirty, self.btnremoteapply.disabled, self.btnremoteconfirm.disabled, self.btnremotecancel.tooltip = dirty, not dirty, not dirty, dirty and "Cancel" or "Close"
		self.dbgvalues.opacity = dirty and 0.5 or 1.0
	end
	if dirty and not no_undo_state then
		local code, undoredostate = self.code, self.undoredostate
		local code_id, code_rev, undo_delta = code.id, code.rev
		if not undoredostate then error("missing undoredostate") return end
		code.id, code.rev = nil, nil -- exclude from undo/redo buffer
		self.undoredostate, undo_delta = Tool.GetTableDelta(code, undoredostate)
		code.id, code.rev = code_id, code_rev

		local undo_buffer, redo_buffer = self.undo_buffer, self.redo_buffer
		if redo_buffer then for i=#redo_buffer,1,-1 do redo_buffer[i] = nil end end
		if not undo_buffer then undo_buffer = {} self.undo_buffer = undo_buffer end
		undo_buffer[#undo_buffer+1] = undo_delta
		self.btnundo.disabled, self.btnredo.disabled = false, true
	end
end

function Program:remote_do_save(no_confirm, is_closing, is_cancel, set_debug, debug_counter)
	local dirty_remote = (self.is_remote and self.is_dirty)
	if dirty_remote or set_debug then
		local comp, code, breakpoints = self.comp, self.code
		if comp then
			-- Build list of breakpoints to send and remove .breakpoint in sent code (which is just for UI)
			if not self.hide_bpntlight or self.dirtybpnts then
				local function FindAllCodeIds(id, ids, library)
					ids[id] = true
					local item = library[id]
					for inst_idx,inst in ipairs(item) do
						local sub = inst.sub
						if sub and not ids[sub] then FindAllCodeIds(sub, ids, library) end
					end
				end
				local ed = comp.has_extra_data and comp.extra_data
				local ids, library = {}, self.library
				local code_id, sendcode, sendbps = code.id, Tool.Copy(code), Tool.Copy(ed and ed.breakpoints) or {}
				FindAllCodeIds(ed and ed.main_id or code_id, ids, library)
				for i,v in pairs(sendbps) do
					if (i >> 16) == code_id or not ids[i >> 16] then sendbps[i] = nil end
				end
				for i,v in ipairs(sendcode) do
					if v.breakpoint then sendbps[(code_id << 16) | i], v.breakpoint = true, nil end
				end
				if next(sendbps) then code, breakpoints = sendcode, sendbps end
			end

			-- If there was no code change, don't send it, same with breakpoints (all breakpoints need to always get sent if code is sent!)
			if not dirty_remote or Tool.Hash(self.library[code.id]) == Tool.Hash(code) then
				local ed_breakpoints = comp.has_extra_data and comp.extra_data.breakpoints
				if ed_breakpoints and not breakpoints then
					breakpoints = {} -- mark to be cleared by DebugBehavior
				elseif Tool.Hash(breakpoints) == Tool.Hash(ed_breakpoints) then
					if not set_debug and not self.reset_reg then goto skip_send end -- no need to do anything
					breakpoints = nil -- no need to update
				end
				code = nil -- no need to update
			end
		elseif Tool.Hash(self.library[code.id]) == Tool.Hash(code) then
			goto skip_send
		end

		if is_cancel then
			if no_confirm then goto skip_send end
			ConfirmBox(L("%s\n%s", "This will discard your changes.", "Are you sure you want to continue?"), function() self:remote_do_save(true, is_closing, true, set_debug, debug_counter) end)
			return
		end

		if not no_confirm and self.remote_running > 0 and code then
			ConfirmBox(L("%s\n%s", L("Saving will affect %d currently running Behavior Controller.", self.remote_running), "Are you sure you want to continue?"), function() self:remote_do_save(true, is_closing, false, set_debug, debug_counter) end)
			return
		end

		if comp then
			local debug = set_debug ~= "CONTINUE" and (set_debug or (comp.is_active and "CONTINUE" or "STOP")) or nil
			Action.SendForEntity("Behavior", comp.owner, { comp = comp, code = code, breakpoints = breakpoints, debug = debug, counter = debug_counter, reset_reg = self.reset_reg, reset_reg_max = self.reset_reg_max })
			self.reset_reg, self.reset_reg_max = nil, nil
		else
			Action.SendForLocalFaction("FactionLibrary", { mode = 'data', item = code })
		end
		::skip_send::
		if dirty_remote then self:set_dirty(false) end
		if dirty_remote and not is_closing and self.dbgvalues.active then self:Refresh(true) end
	end
	if is_closing then
		if self.outer_ui then
			self.outer_ui.dbgcam.hidden = not self.comp
			self:RemoveFromParent()
		else
			CloseMainWindowAndPopup()
		end
		self:SendEvent("on_closed")
	end
end

function Program:remote_apply()
	self:remote_do_save()
end

function Program:remote_cancel()
	self:remote_do_save(false, true, true)
end

function Program:close()
	self:remote_do_save((self.outer_ui ~= nil), true)
end

function Program:RefreshActive()
	if not self.is_remote then self.txtactive.hidden = true return end

	local ids = { [self.code.id] = true }
	self.active_ids = ids
	local nids, lastnids, library = 1, 0, Game.GetLocalPlayerFaction().extra_data.library
	while nids > lastnids do
		lastnids = nids
		for item_id,item in pairs(library) do
			if item.type == 'C' and not ids[item_id] then
				for inst_idx,inst in ipairs(item) do
					if ids[inst.sub] then ids[item_id], nids = true, nids + 1 break end
				end
			end
		end
	end

	local active, running = {}, 0
	for _,comp in ipairs(Game.GetLocalPlayerFaction():GetComponents("c_behavior", true)) do
		local ed = comp.has_extra_data and comp.extra_data
		if ed and ids[ed.main_id] then
			active[#active+1] = comp
			if comp.is_active then running = running + 1 end
		end
	end
	self.active_comps, self.remote_running = active, running
	self.dbgsel_box.disabled = (#active == 0)
	self.txtactive.hidden = (#active == 0)
	self.txtactive.text = L("Loaded in %d Behavior Controllers (%d Running)", #active, running)
end

function Program:SetCompRunning(comp_running)
	local new_running = self.remote_running + (comp_running and 1 or -1)
	self.remote_running, self.comp_running = new_running, comp_running
	self.txtactive.text = L("Loaded in %d Behavior Controllers (%d Running)", #self.active_comps, new_running)
end

function Program:set_debug_target(comp)
	local oldcomp, e, code, breakpoints = self.comp, comp and comp.owner, self.code, comp and comp.has_extra_data and comp.extra_data.breakpoints
	if not self.hide_bpntlight or self.dirtybpnts or breakpoints then
		if self.dirtybpnts then self:remote_do_save(true) end -- save breakpoints
		local code_id = code.id or 0
		for i,v in ipairs(code) do if v.breakpoint then v.breakpoint = nil end end
		for i,v in pairs(breakpoints or {}) do if (i >> 16) == code_id then code[i & 0xffff].breakpoint = true end end
		self.refreshbpnts = true -- force refresh once to clear remaining
	end
	self.dbgtarget.active = e ~= nil
	self.dbgvalues.disabled = e == nil
	self.dbgarray.disabled = e == nil
	self.dbgvalues.opacity = self.is_dirty and 0.5 or 1.0
	self.comp = comp
	self.comp_running = comp and comp.is_active or nil
	self.dbgbtn_box.disabled = not comp
	self.dbgbtn_box.opacity = comp and 1 or 0.5
	if e == nil and self.dbgvalues.active then
		self.dbgvalues.active = false
		self:Refresh(true)
	end
	if (oldcomp and (oldcomp.def.key or true)) ~= (comp and (comp.def.key or true)) then
		self:PrepareToolBox(self.toolbox)
	end
	self.dbgcam.hidden = not comp
	self.dbgcam.every_frame_update = comp and function(w, dt)
		local pos = e.interpolated_location or { x = 0, y = 0, z = 0 }
		w:SetCameraPos(pos.x, pos.y+0.1, pos.z + 8)
		w:SetTargetPos(pos.x, pos.y, pos.z)
		View.SetCamera3DPosition({pos.x, pos.y + 1, pos.z + 15}, pos)
	end
	if self.dbgcam.destruct then return end
	local old_pos, old_trg = View.GetCamera3DPosition()
	self.dbgcam.destruct = function()
		View.SetCamera3DPosition(old_pos, old_trg)
	end
end

function Program:on_click_debug_target(btn)
	local function selected(reg)
		self:set_debug_target(reg.behavior_comp)
		UI.CloseMenuPopup()
	end
	local p = UI.MenuPopup("<Box bg=popup_box_bg padding=4 blur=true><Box bg=popup_pattern padding=4><ScrollList width=428 height=400><Wrap id=wrap child_padding=4/></ScrollList></Box></Box>", btn)
	if not p then return end
	local wrap = p.wrap
	for _,comp in ipairs(self.active_comps) do
		if comp.exists then
			local r = wrap:Add("<Reg bg=item_default/>", { entity = comp.owner, behavior_comp = comp, on_click = selected, bg = comp == self.comp and 'reg_entity' or nil })
			r:Add('<Image color=ui_light width=16 height=16/>').image = comp.is_active and 'icon_play' or 'icon_stop'
		end
	end
	wrap:Add("<Reg bg=item_default/>", { tooltip = "None", on_click = selected })
end

function Program:on_click_debug_array(btn)
	UI.MenuPopup([[
<Box bg=popup_box_bg width=980 padding=10 blur=true>
	<VerticalList child_padding=10>
		<ScrollList id=list child_padding=10 max_height=900/>
		<HorizontalList>
			<CheckBox id=showbeyond on_change={update} text="Show values beyond end of array" halign=left/>
			<Spacer fill=true/>
			<Button text="Clear All" on_click={clear}/>
		</HorizontalList>
	</VerticalList>
</Box>]], {
		construct = function(w)
			btn.active = true
		end,
		update = function(w)
			local c, list = self.comp, w.list
			local ed = c and c.extra_data
			local arr = ed and ed.arrays
			local show_only_array = not w.showbeyond.check
			local newhash = Tool.Hash(arr, show_only_array)
			if w.hash == newhash then return end
			w.hash = newhash
			list:Clear()
			if not arr then list:Add("Text", { text = "Nothing in memory" }) return end
			for key,v in pairs(arr) do
				local row = list:Add([[<HorizontalList>
					<Reg id=keyreg read_only=true valign=top on_click={toggle_array} margin_right=10/>
					<Box padding=10 min_height=76 fill=true><VerticalList id=vl child_padding=10/></Box>
				</HorizontalList>]])
				if type(key) == "string" then
					local x,y = string.match(key, "(%d+):(%d+)")
					if x then
						row.keyreg.coord = { x = x//1, y = y//1 }
					else
						row.keyreg.def_id = key
					end
				else
					row.keyreg.entity = Map.GetEntityFromKey(key)
				end
				local arrayi, hl = 1
				for i,v2 in SortedPairs(v) do
					if show_only_array then
						if i ~= arrayi then break end
						arrayi = arrayi + 1
					end
					if not hl or #hl == 20 then
						hl = row.vl:Add("HorizontalList")
					end
					hl:Add("<Text width=20 textalign=right/>").text = tostring(i)
					hl:Add("<Reg read_only=true margin_right=10/>", { def_id = v2.id, num = v2.num, entity = v2.entity, coord = v2.coord })
				end
			end
		end,
		clear = function()
			Action.SendForEntity("Behavior", self.comp.owner, { comp = self.comp, debug = "WIPEARRAYS" })
		end,
		toggle_array = function(w, keyreg)
			keyreg.parent.children[2].hidden = not keyreg.parent.children[2].hidden
		end,
		destruct = function(w)
			btn.active = false
		end
	}, btn, "UP")
end

function Program:on_click_debug_values(btn)
	btn.active = not btn.active
	self:Refresh(true)
end

function Program:on_pan_mouse_wheel(pan, wheel)
	pan:ZoomTowards(wheel)
end

function Program:on_click_zoom(btn, mousebtn)
	local x, y, w, h = self.pan:GetViewportPosition()
	if mousebtn == "RIGHTMOUSEBUTTON" then
		self.pan.zoom = 1
		self.pan:PanTo(-50, -50)
	else
		self.pan:ZoomTowards(btn.zoom, w * 0.5, h * 0.5)
	end
end

function Program:on_ui_accept()
	if     not self.remoteconfirm_box.hidden and not self.btnremoteapply.disabled then self:remote_apply()
	elseif not self.remoteconfirm_box.hidden and not self.btnremoteconfirm.disabled then self:close()
	elseif not self.remoteconfirm_box.hidden then self:remote_cancel()
	elseif not self.localconfirm_box.hidden then self:close() end
end

function Program:on_ui_cancel()
	if     not self.remoteconfirm_box.hidden then self:remote_cancel()
	elseif not self.localconfirm_box.hidden then self:close() end
end

function Program:on_click_options(btn)
	UI.MenuPopup(Options_layout, {
		on_popup_shift = function(popup, shift_x, shift_y) popup.triangle.y = -shift_y end,
		construct = function(popup)
			local keepvars, keeparrays = self.code.keepvars, self.code.keeparrays
			popup.variables.texts = { "Clear variables when behavior restarts", "Keep variable values across restarts" }
			popup.variables.value = (keepvars and 2) or 1
			popup.arrays.texts = { "Clear memory arrays when behavior restarts", "Clear memory arrays on startup (including code change)", "Keep memory arrays until behavior is switched" }
			popup.arrays.value = (keeparrays == "startup" and 2) or (keeparrays == "store" and 3) or 1
			popup.old_keepvars, popup.old_keeparrays = keepvars, keeparrays
		end,
		destruct = function(popup)
			if self.is_dirty and (popup.old_keepvars ~= self.code.keepvars or popup.old_keeparrays ~= self.code.keeparrays) then
				self:set_dirty(true) -- store undo step
			end
		end,
		on_change = function(popup)
			self.code.keepvars = (popup.variables.value == 2) or nil
			self.code.keeparrays = (popup.arrays.value == 2 and "startup") or (popup.arrays.value == 3 and "store") or nil
			self:Refresh(nil, nil, true) -- clear any values shown with "View Current Values"
		end,
	}, btn, "RIGHT", "TOP", -4)
end

function Program:on_icon(imgicon, mousebtn)
	local function on_set(rsel, val)
		self.code.icon = val and val.id or nil
		self:Refresh()
	end
	if mousebtn == "RIGHTMOUSEBUTTON" then on_set(nil, nil) return end
	local rsel = ShowRegisterSelection(imgicon, on_set, nil, nil, { hide_coord_panel = true, hide_number_panel = true, hide_entity_panel = true })
	if rsel then rsel:SetRegister({ id = self.code.icon }) end
end

function Program:on_rename()
	local defaultname =  NOLOC(L("New Behavior"))
	InputBox("Set the behavior name", "Behavior",
		function (t)
			if t == "" or t == defaultname then t = nil end
			if self.code.name == t then return end
			self.code.name = t
			self:Refresh()
		end,
		self.code.name or defaultname)
end

function Program:on_edit_desc()
	InputBox("Set the behavior description", "Behavior",
		function (t)
			if t == "" then t = nil end
			if self.code.desc == t then return end
			self.code.desc = t
			self:Refresh()
		end,
		self.code.desc or "", false, true)
end

function Program:on_click_savenew()
	if not self.is_remote then return end -- not available in local library
	InputBox("Set the name for the behavior copy", "Behavior",
		function (t)
			if self.comp then self:set_debug_target() end -- disconnect debug
			if t == "" then t = nil end
			local newname = (self.code.name ~= t)
			if newname then self.code.name = t end
			UILibrarySaveBehaviorAsNew(self.code, function (newitem)
				self.code.id, self.code.rev = newitem.id, newitem.rev
				self:Refresh(not newname)
				self:set_dirty(false)
				self:RefreshActive()
			end)
		end,
		self.code.name or "")
end

function Program:on_click_clear()
	local current_empty = not self.code[1] and not (self.code.parameters and self.code.parameters[1])
	if current_empty then return end
	ConfirmBox("Are you sure you want to delete everything in the current behavior?", function()
		local code = self.code
		local org_id, org_rev, org_type, org_folder, org_order = code.id, code.rev, code.type, code.folder, code.order -- library fields
		code.id, code.rev, code.type, code.folder, code.order = nil, nil, nil, nil, nil
		for k in next, code do code[k] = nil end
		code.id, code.rev, code.type, code.folder, code.order = org_id, org_rev, org_type, org_folder, org_order
		self:Refresh()
	end)
end

function Program:instruction_tooltip(w)
	if not w.op and not w.inst_idx then return end
	local inst_def = data.instructions[w.op or self.code[w.inst_idx].op]
	local is_autobase = inst_def.key == "autobase"
	return L("%s%S<hl>%s</>", inst_def.desc, is_autobase and "\n\n" or "", is_autobase and "Available only on AI Behavior Controller" or "")
end

function Program:PrepareToolBox(toolbox)
	local comp_key = self.comp and (self.comp.def.key or true)
	local knowncats = {}
	for _,inst in pairs(data.instructions) do
		if inst.category and not knowncats[inst.category] and (not comp_key or not inst.key or inst.key == comp_key) then
			knowncats[inst.category] = true
		end
	end
	toolbox:Clear()
	toolbox:Add(Category_layout, { title = "Unit", text = "Unit", icon = "icon_small_arrow_right" })
	toolbox:Add(Category_layout, { title = "Move", text = "Move", icon = "icon_small_arrow_right" })
	toolbox:Add(Category_layout, { title = "Component", text = "Component", icon = "icon_small_arrow_right" })
	toolbox:Add(Category_layout, { title = "Flow", text = "Flow", icon = "icon_small_arrow_right" })
	toolbox:Add(Category_layout, { title = "Math", text = "Math", icon = "icon_small_arrow_right" })
	knowncats.Unit, knowncats.Move, knowncats.Component, knowncats.Flow, knowncats.Math = nil
	for _,cat in ipairs(GetSortedTableKeys(knowncats)) do
		toolbox:Add(Category_layout, { title = cat, text = cat, icon = "icon_small_arrow_right" })
	end
	for i,cat in ipairs(toolbox) do
		local cat_title, collapse = cat.title, i~=1
		cat.inst_list.hidden = collapse
		cat.collapsed = collapse
		cat.icon = collapse and "icon_small_arrow_right" or "icon_small_arrow_down"

		for op,inst in SortedPairs(data.instructions) do
			if inst.category == cat_title and not inst.deprecated then
				cat.inst_list:Add(Instruction_layout, { title = inst.name or op, op = op, icon = inst.icon })
			end
		end
	end
end

function Program:on_filter(search, filter, popup_toolbox)
	if filter == "" then filter = nil end
	local MatchLocalizedRichText = filter and Tool.MatchLocalizedRichText
	for _,cat in ipairs(popup_toolbox or self.toolbox) do
		local showcat
		for _,inst in ipairs(cat.inst_list) do
			local show = not filter or MatchLocalizedRichText(inst.title or "", filter)
			inst.hidden = not show
			showcat = showcat or show
		end
		cat.hidden = not showcat
		local collapse = not filter and cat.collapsed -- auto expand all categories when filtering
		cat.inst_list.hidden = collapse
		cat.icon = collapse and "icon_small_arrow_right" or "icon_small_arrow_down"
	end
end

function Program:category_on_click(cat)
	local collapse = not cat.inst_list.hidden
	cat.inst_list.hidden = collapse
	cat.collapsed = collapse
	cat.icon = collapse and "icon_small_arrow_right" or "icon_small_arrow_down"
end

local function GetLevelColor(level)
	if     level == 2 then return '#DAC78E', '#786428' -- yellow
	elseif level == 3 then return '#DA8EB5', '#782851' -- purple
	elseif level == 3 then return '#8EC4DA', '#286278' -- blue
	elseif level == 4 then return '#8EDAA9', '#287844' -- green
	else                   return '#DAA08E', '#783B28' -- red
	end
end

local function DrawConnection(draw, my_y, outx, outy, inx, iny, freeplace, id, linetops, level)
	local fg, bg
	if not level then fg, bg = 'white', 'dark_gray' -- white
	else              fg, bg = GetLevelColor(level)
	end

	if not id then id = draw:Count() + 1 end
	if not freeplace and (inx < outx or inx > outx + NODEGAP) then
		local topy, dist, curve, d = my_y - 25, 25, 20, (inx > outx and 1 or -1)

		if linetops then
			-- Avoid overlapping lines going across nodes by remembering which nodes had lines across which and how high
			local lt_from, lt_to, lt_step = (outx+(d*NODEGAP//2))//NODEGAP*0x1000000000, (inx-(d*NODEGAP//2))//NODEGAP*0x1000000000, d*0x1000000000
			::recheck::
			for lt=lt_from+topy,lt_to+topy,lt_step do
				if linetops[lt] then topy = topy - 8 goto recheck end
			end
			for lt=lt_from+topy,lt_to+topy,lt_step do
				linetops[lt] = true
			end
		end

		local p2x, p2y = outx + dist          , outy - dist
		local p3x, p3y = p2x                  , topy + dist
		local p4x, p4y = p2x + dist*d         , topy
		local p5x, p5y = inx - dist - dist*d  , topy
		local p6x, p6y = p5x + dist*d         , p3y
		local p7x, p7y = p6x                  , iny - dist
		local points = {
			outx,outy ,  outx + curve, outy  ,  p2x, p2y + curve,    -- curve out of pin and up
			p2x, p2y  ,  p2x, p2y            ,  p3x, p3y,            -- straight line up
			p3x, p3y  ,  p3x, p3y - curve    ,  p4x - curve*d, p4y,  -- first curve on top to side
			p4x, p4y  ,  p4x, p4y            ,  p5x, p5y,            -- straight line across
			p5x, p5y  ,  p5x + curve*d, p5y  ,  p6x, p6y - curve,    -- second curve on top downwards
			p6x, p6y  ,  p6x, p6y            ,  p7x, p7y,            -- straight line down
			p7x, p7y  ,  p7x, p7y + curve    ,  inx - curve, iny,    -- curve into pin
			inx, iny }
		draw:SetBezierCurves(id    , points, bg, 6)
		draw:SetBezierCurves(id + 1, points, fg, 2)
	elseif math.abs(outy - iny) > 10 then
		local curve = (math.abs(inx - outx) + NODEW) * 0.25
		draw:SetBezierCurve(id    , outx, outy, outx + curve, outy, inx - curve, iny, inx, iny, bg, 6)
		draw:SetBezierCurve(id + 1, outx, outy, outx + curve, outy, inx - curve, iny, inx, iny, fg, 2)
	elseif inx > outx then
		draw:SetLine(id    , outx, outy, inx, iny, bg, 6)
		draw:SetLine(id + 1, outx, outy, inx, iny, fg, 2)
	else
		draw:SetBezierCurve(id    , outx, outy, outx + 200, outy - 50, inx - 200, iny - 50, inx, iny, bg, 6)
		draw:SetBezierCurve(id + 1, outx, outy, outx + 200, outy - 50, inx - 200, iny - 50, inx, iny, fg, 2)
	end
	return id
end

local function NextIdx(code, inst_idx, arg)
	if arg ~= nil then return arg end
	return inst_idx < #code and inst_idx + 1
end

local function ShiftCode(code, to_idx, from_idx, show_extras, selection) -- Refresh/BuildGraph must be called after this
	local min, max, change = math.min(to_idx, from_idx), math.max(to_idx, from_idx), (to_idx < from_idx and 1 or -1)
	for inst_idx,inst in ipairs(code) do
		local inst_def = data.instructions[inst.op]
		local inst_def_args = inst_def.args
		for i=(inst_def.exec_arg == false and 1 or 0),(inst_def_args and #inst_def_args or 0) do
			local exec_arg = (i == 0 and "next") or (inst_def_args[i] and inst_def_args[i][1] == "exec" and i)
			if exec_arg then
				local next_idx, new_next_idx = NextIdx(code, inst_idx, inst[exec_arg])
				if     next_idx == from_idx                             then new_next_idx = to_idx
				elseif next_idx and next_idx >= min and next_idx <= max then new_next_idx = next_idx + change
				elseif inst_idx >= min and inst_idx <= max and (inst_idx == from_idx or not inst[exec_arg]) then new_next_idx = next_idx and next_idx <= #code and next_idx
				elseif not next_idx and inst_idx == to_idx and inst_idx == #code then new_next_idx = false
				else goto no_change end
				--print("    Change ", exec_arg, " of ", inst_idx, " from ", inst[exec_arg], " (", next_idx, ") to ", new_next_idx)
				inst[exec_arg] = new_next_idx
				::no_change::
			end
		end
	end
	table.insert(code, to_idx, table.remove(code, from_idx))
	if show_extras and min <= #show_extras then
		for i=1,max do show_extras[i] = show_extras[i] or false end -- make sure array is filled
		table.insert(show_extras, to_idx, table.remove(show_extras, from_idx))
	end
	for i=(selection and #selection or 0),1,-1 do
		local s_inst_idx = selection[i].inst_idx
		if     s_inst_idx == from_idx                  then selection[i].inst_idx = to_idx
		elseif s_inst_idx >= min and s_inst_idx <= max then selection[i].inst_idx = s_inst_idx + change end
	end
end

local function BuildGraph(code, graph, draw, program_ui, show_regicons, drag_library)
	local show_extras, selection, reorder_from, reorder_to
	local nodes, pins, regs, vars, linetops = {}, {}, {}, {}, {}
	local parameters, pnames = code.parameters or {}, code.pnames

	for i,v in ReverseIPairs(data.frame_regs) do
		regs[-i] = UI.New(Register_layout, { ui_icon = v.bg, reg_idx = -i })
	end

	for i,param in ipairs(parameters) do
		regs[i] = UI.New(Register_layout, { num = NOLOC("P" .. i), reg_idx = i, dock = 'bottom' })
		parameters[i] = false
	end

	if program_ui then
		show_extras, selection = program_ui.show_extras, program_ui.selection
		if not show_extras then show_extras = {} program_ui.show_extras = show_extras end

		program_ui.reglist:Clear()
		for i,v in ReverseIPairs(data.frame_regs) do program_ui.reglist:Add(regs[-i]) end

		local pinits = code.pinits
		program_ui.paramlist:Clear()
		for i,v in ipairs(parameters) do
			local r = program_ui.paramlist:Add(Parameter_layout, { header = pnames and NOLOC(pnames[i]) or L("Parameter %d", i), param_idx = i })[1]:Add(regs[i])
			local val = pinits and pinits[i]
			if val then
				local val_num, val_id, val_entity, val_coord = val.num, val.id, val.entity, val.coord
				r.num = (val_num ~= 0) and val_num or (not val_id and not val_entity and not val_coord and not val.is_empty and 0) or nil
				r.def_id, r.entity, r.coord = val_id, val_entity, val_coord
			end
		end
		program_ui.paramlist:Add(ParamAddButton_layout)
	end

	local standalone_y = 110
	local node_ui_program_ui = program_ui
	local function BuildNode(inst_idx, auto_x, auto_y, head_idx, block_level)
		local inst, height = code[inst_idx], 60
		local op = inst.op
		local inst_def = data.instructions[op]
		local title = inst_def and inst_def.name or op --L("[%d] %s", inst_idx, inst_def and inst_def.name or op)
		if not inst_def then
			-- Replace unknown instruction with dummy nop instruction
			title = L("%s [%s]", data.instructions["nop"].name, op)
			inst.op, op, inst_def = "nop", "nop", data.instructions["nop"]
		end

		local freeplace, my_x, my_y = inst.nx, auto_x, auto_y
		if freeplace then
			my_x, my_y = freeplace, inst.ny
			if math.abs(my_x - auto_x) < 1 and math.abs(my_y - auto_y) < 1 then
				my_x, my_y, freeplace, inst.nx, inst.ny = auto_x, auto_y, nil, nil, nil
			end
		end

		local inpin_x, inpin_y, first_pin_idx = my_x, my_y + 30, #pins + 1
		local node = graph:Add(Node_layout, { title_color = data.instruction_color[inst_def.category or ""] or "white", icon = inst_def.icon, title = title, x = my_x, y = my_y, height = height, inst_idx = inst_idx, first_pin_idx = first_pin_idx, last_pin_idx = first_pin_idx, level = block_level })
		if head_idx == inst_idx then node.is_head = true end
		nodes[inst_idx] = node
		local nodecnvs = node[1]

		if not inst_def.event_setup then
			node.inpin_id = draw:AddCircle(inpin_x, inpin_y, PINSZ)
			pins[first_pin_idx] = nodecnvs:Add(ExecInPin_layout, { y = 15, pin_id = node.inpin_id, inst_idx = inst_idx })
		end

		local show_extra, arg_defs = show_extras and show_extras[inst_idx], inst_def.args
		if inst_def.node_ui then
			if not node_ui_program_ui then node_ui_program_ui = { code = code, library = drag_library or {} } end -- fake for node_ui
			local add_height = inst_def.node_ui(nodecnvs, inst, node_ui_program_ui, op, show_extra)
			if add_height then height = height + add_height end
		end

		local argc, var_args = arg_defs and #arg_defs or 0
		if inst_def.var_args then
			var_args = inst_def.var_args(inst, code, drag_library or program_ui and program_ui.library or {})
			argc = argc + (var_args and #var_args or 0)//2
		end

		-- cleanup inst if definition or subroutine was changed
		local has_exec, has_extra = inst_def.exec_arg ~= false
		if not has_exec and inst.next ~= nil then inst.next = nil end
		for k,_ in pairs(inst) do if type(k) == "number" and k > argc then inst[k] = nil end end

		local i_next, node_y, above = (inst_def.exec_arg and inst_def.exec_arg[1] - 1 or 0), my_y
		for i=(has_exec and 0 or 1),argc do
			local arg_idx = (i ~= i_next and (i + (i < i_next and 1 or 0)) or "next")
			local val, arg_type, arg_text, arg_desc, arg_extra = inst[arg_idx]
			if not var_args or i == i_next or arg_idx <= (arg_defs and #arg_defs or 0) then
				local arg_def = (i ~= i_next and arg_defs[arg_idx] or inst_def.exec_arg)
				arg_type, arg_text, arg_desc, arg_extra = arg_def and arg_def[1], arg_def and arg_def[2], arg_def and arg_def[3], arg_def and arg_def[5]
			else
				local p = i - (arg_defs and #arg_defs or 0)
				arg_type = var_args[p*2-1] and "out" or "in"
				arg_text, arg_extra = NOLOC(var_args[p*2]) or (arg_type == "out" and "Output" or "Input")
			end
			if i == i_next or arg_type == "exec" then
				local next_idx = NextIdx(code, inst_idx, val)

				-- Fix invalid jumps and modified instruction where a value changed to a exec
				if next_idx and (not code[next_idx] or type(next_idx) == "table") then
					inst[arg_idx], next_idx = false, false
				end

				-- Normalize instruction order so jumps can be simplified
				if next_idx and next_idx > #nodes + 1 and code[next_idx] then
					ShiftCode(code, #nodes + 1, next_idx, show_extras, selection)
					next_idx = #nodes + 1
				end

				-- Simplify jumps (jumps to the next slot and jumps to end of program while the last instruction can be nil)
				if (next_idx == inst_idx + 1) or (next_idx == false and inst_idx == #code) then
					inst[arg_idx] = nil
				end

				if not arg_extra or show_extra or next_idx then
					local piny = 30
					if arg_text then
						piny = height + 20
						nodecnvs:Add("<Text halign=right textalign=right x=-10/>", { text = arg_text, tooltip = arg_desc, y = height + 8, })
						height = height + 40
					end

					-- increase block level if this is a loop instruction (has next callback) and this is the loop exec pin
					local out_level = (inst_def.next and not arg_text) and ((block_level or 1) + 1) or block_level
					local outpin_x, outpin_y, outpin_conn_id, next_y = my_x + NODEW, my_y + piny
					if next_idx then
						local next_node, next_freeplace, next_inpin_x, next_inpin_y = nodes[next_idx]
						if next_node then
							next_freeplace = code[next_idx].nx
							next_inpin_x, next_inpin_y = draw:GetPoint(next_node.inpin_id)
							if next_node.is_head and next_idx > 1 and next_idx ~= head_idx then
								-- Connecting to a standalone node that isn't the start, re-order code so it is after us
								if not reorder_from then reorder_from, reorder_to = next_idx, inst_idx end
								next_node.is_head = nil
							end
							next_y = next_node.y
						else
							next_node, next_freeplace, next_inpin_x, next_inpin_y, node_y = BuildNode(next_idx, my_x + NODEGAP, node_y, head_idx, out_level)
							next_y = node_y
							if not next_freeplace then if above then above.below = next_node end above = next_node end
						end
						outpin_conn_id = DrawConnection(draw, math.min(my_y, next_y), outpin_x, outpin_y, next_inpin_x, next_inpin_y, freeplace or next_freeplace, nil, linetops, out_level)
					end

					local outpin_id = draw:AddCircle(outpin_x, outpin_y, PINSZ, out_level and not next_idx and GetLevelColor(out_level))
					pins[#pins + 1] = nodecnvs:Add(ExecOutPin_layout, { y = piny - 15, pin_id = outpin_id, inst_idx = inst_idx, arg_idx = arg_idx, next_idx = next_idx, conn_id = outpin_conn_id })
				end
				has_extra = has_extra or arg_extra and not next_idx
			elseif not arg_extra or show_extra or val then
				local val_type = type(val)
				local argn, is_out, reg = (val_type == "number" and val), (arg_type == "out")
				if is_out then
					reg = nodecnvs:Add(Argument_layout, { halign="right", y = height, x = -10 })
					nodecnvs:Add("<Text halign=right textalign=right x=-58/>", { text = arg_text, tooltip = arg_desc, y = height + 12 })
				else
					nodecnvs:Add("<Text x=58 />", { text = arg_text, tooltip = arg_desc, y = height + 8 })
					reg = nodecnvs:Add(Argument_layout, { y = height, x = 10 })
				end
				height = height + 48

				regs[#regs + 1] = reg
				reg.is_out, reg.inst, reg.arg_idx, reg.reg_idx = is_out, inst, arg_idx, #regs

				if argn and argn <= #parameters then
					if is_out and argn > 0 then parameters[argn] = true end
					local regsrc = regs[argn]
					reg.num, reg.ui_icon = pnames and NOLOC(pnames[argn]) or regsrc.num, regsrc.ui_icon
					if is_out then
						if show_regicons then reg:Add("<Image image=icon_small_register_out color=#FFFF00 dock=center/>").child_index = 2 end
						regsrc.has_out = true
					else
						if show_regicons then reg:Add("<Image image=icon_small_register_in color=#00FFFF dock=center/>").child_index = 2 end
						regsrc.has_in = true
					end
				elseif val_type == "string" then
					vars[val] = (vars[val] or 0) + 1
					if show_regicons then reg:Add("<Image image=icon_small_register_var color=#FF00FF dock=center/>").child_index = 2 end
					reg.num = val
				elseif val_type == "table" and val.fr then
					if show_regicons then reg:Add("<Image image=icon_small_register_var color=#FF8800 dock=center/>").child_index = 2 end
					reg.num = val.fr
				elseif val_type == "table" then
					reg.def_id = val.id
					reg.coord = val.coord
					reg.num = val.num
				end
				has_extra = has_extra or arg_extra and not val
			else
				has_extra = true
			end
		end

		if has_extra and program_ui then
			node.has_extra = true
			if not show_extra then
				nodecnvs:Add('<Image image=icon_small_arrow_down halign=center tooltip="Extra Options"/>', {
					y = height-8,
					on_click = function(w) program_ui:nodebtn_extra_on_click(node) end
				})
				height = height + 8
			end
		elseif has_extra == false and show_extras and not show_extra then
			for i=1,inst_idx-1 do show_extras[i] = show_extras[i] or false end -- make sure array is filled
			show_extras[inst_idx] = true -- remember that once all extra args were filled and visible
		end

		-- add height for comment
		local buffer_height = 0
		if inst.cmt then
			local cmttxt = nodecnvs:Add('<Text halign=fill wrap=true/>')
			cmttxt.text, cmttxt.y = inst.cmt, height
			buffer_height = (string.len(inst.cmt)//30) * 20
		end

		--[[ -- Show debug panel with current states
		nodecnvs:Add('<Text halign=fill wrap=true/>', { text = string.format("[%d] [ %.0f, %.0f, %.0f, %.0f]\n%s", inst_idx, node.x, node.y, node.width, node.height, tostring(inst)), y = height })
		if graph[node.inst_idx] ~= node then error("index mismatch") end -- code below relies on this being true
		--]]

		node.height = height
		node.last_pin_idx = #pins

		if not freeplace then
			auto_y = math.max(node_y, my_y + height + 50 + buffer_height)
			if inst_idx == head_idx then
				standalone_y = math.max(standalone_y, auto_y)
			end
		end

		return node, freeplace, inpin_x, inpin_y, auto_y
	end

	draw:Reset()
	graph:Clear()

	local above
	for i=1,#code do
		if not nodes[i] then
			local node, freeplace = BuildNode(i, (i == 1 and program_ui and NODEGAP or 0), (i == 1 and 0 or standalone_y), i)
			if not freeplace then if above then above.below = node end above = node end
		end
	end

	if reorder_from then
		-- While building, an unconnected node was placed that was connected later, re-order then refresh
		ShiftCode(code, reorder_to, reorder_from, show_extras, selection)
		return BuildGraph(code, graph, draw, program_ui, show_regicons, drag_library)
	end

	if not program_ui then return end

	local node = graph:Add(Node_layout, { title_color = "green", icon = "Main/skin/Icons/Common/56x56/Play.png", title = "Program Start", x = 0, y = 0, height = 60 })
	local startpin_x, startpin_y = 0 + NODEW, 0 + 30
	local startpin_id = draw:AddCircle(startpin_x, startpin_y, PINSZ)
	local startpin = node[1]:Add(ExecOutPin_layout, { y = 15, pin_id = startpin_id, next_idx = (#nodes > 0 and 1 or nil) })
	pins[#pins+1] = startpin

	if #graph > 1 and graph[1].inpin_id then
		local firstpin_freeplace = code[pins[1].inst_idx].nx
		local firstpin_x, firstpin_y = draw:GetPoint(pins[1].pin_id)
		startpin.conn_id = DrawConnection(draw, 0, startpin_x, startpin_y, firstpin_x, firstpin_y, firstpin_freeplace)
	end

	if show_regicons then
		for _,reg in pairs(regs) do
			local i,o = reg.has_in, reg.has_out
			if i and o then
				reg:Add("<Image image=icon_small_register_in dock=center color=#00FFFF x=-10/>").child_index = 3
				reg:Add("<Image image=icon_small_register_out dock=center color=#FFFF00 x=10/>").child_index = 3
			elseif i then
				reg:Add("<Image image=icon_small_register_in dock=center color=#00FFFF/>").child_index = 3
			elseif o then
				reg:Add("<Image image=icon_small_register_out dock=center color=#FFFF00/>").child_index = 3
			end
		end
	end

	program_ui.pins = pins
	program_ui.regs = regs
	program_ui.vars = vars

	for i=#selection,1,-1 do
		local s, snew = selection[i]
		for _,w in ipairs(nodes) do
			if w.inst_idx == s.inst_idx and w.title == s.title then snew = w break end
		end
		if snew then
			selection[i] = snew
			snew.bg = "tech_next_to_research_bg"
		else
			table.remove(selection, i)
		end
	end
end

function Program:Refresh(rebuild_only, is_initialize, no_undo_state)
	local code = self.code

	self.imgicon.imageid = code.icon
	self.imgicon.image = not self.imgicon.imageid and 'icon_behavior' or nil
	self.imgicon.color = not self.imgicon.imageid and 'ui_light' or 'white'
	self.title = code.name and NOLOC(code.name) or "New Behavior"
	self.desc = code.desc and NOLOC(code.desc) or "Description"

	local was_dirty = self.is_dirty
	local show_regicons = (was_dirty and not is_initialize) or not rebuild_only or not self.dbgvalues.active
	BuildGraph(code, self.graph, self.draw, self, show_regicons)
	self.indicator_lines, self.show_indicator = nil, nil

	if rebuild_only then return end

	if is_initialize then
		local comp = self.comp
		local breakpoints = comp and comp.has_extra_data and comp.extra_data.breakpoints
		if breakpoints then
			local code_id = code.id or 0
			for i,v in pairs(breakpoints) do local inst = (i >> 16) == code_id and code[i & 0xffff] if inst then inst.breakpoint = true end end
		end
		self.pan:PanTo(-50, -50)
		self.undoredostate = Tool.GetTableDelta(code)
		self.undo_buffer, self.redo_buffer = nil, nil
		self.btnundo.disabled, self.btnredo.disabled = true, true
	end
	self:set_dirty(not is_initialize, no_undo_state)
end

function Program:AnimateSelection()
	local selection = self.selection
	for i=#selection,1,-1 do
		local s = selection[i]
		if s then
			s:TweenFromTo("sx", 0.5, 1, 500, "OutBounce")
			s:TweenFromTo("sy", 0.5, 1, 500, "OutBounce")
		end
	end
end

function Program:on_click_undoredo(btn)
	local is_redo, code, undo_buffer, redo_buffer = btn.redo, self.code, self.undo_buffer, self.redo_buffer
	if not redo_buffer then redo_buffer = {} self.redo_buffer = redo_buffer end
	local consume_buffer = is_redo and redo_buffer or undo_buffer
	local insert_buffer  = is_redo and undo_buffer or redo_buffer
	local consume_delta, insert_delta = table.remove(consume_buffer)
	local code_id, code_rev = code.id, code.rev
	code, self.undoredostate, insert_delta = Tool.ApplyTableDelta(self.undoredostate, consume_delta, true)
	code.id, code.rev, self.code = code_id, code_rev, code -- was excluded from undo/redo buffer
	if not self.is_remote then self.library[code_id] = code end -- editing directly in local library
	insert_buffer[#insert_buffer+1] = insert_delta
	self.btnundo.disabled = not undo_buffer or #undo_buffer == 0
	self.btnredo.disabled = not redo_buffer or #redo_buffer == 0
	self.refreshbpnts = true -- might have undo/redo past first breakpoint toggle
	self:Refresh(true)
	if not self.is_dirty then self:set_dirty(true, true) end
end

function Program:update()
	local comp, code = self.comp, self.code
	if not comp and not self.is_remote then return end -- nothing to do for local behaviors

	local has_code, code_id, code_rev = #code > 0, code.id, code.rev
	local ed = comp and comp.exists and comp.has_extra_data and comp.extra_data
	local debug, counter = ed and ed.debug, ed and ed.counter
	local is_running = ed and comp.is_active or nil
	local is_stopped = not has_code or not ed or (counter == 1 and not is_running and debug == nil)
	local is_paused = not is_stopped and debug ~= nil and ((debug ~= 'BREAKPOINT' and debug ~= 'BPHIT') or not is_running)

	self.pausedbox.hidden = (Map.GetGameSpeed() ~= 0)

	self.btndbgstart.hidden = not is_stopped
	self.btndbgstart.disabled = not comp
	self.btndbgcontinue.hidden = is_stopped or is_running
	self.btndbgpause.hidden = is_stopped or not is_running

	self.btndbgstop.disabled = is_stopped
	self.btndbgstep.disabled = not comp or not has_code or (not is_paused and not is_stopped)

	local library_code = self.library[code_id]
	if code_rev ~= library_code.rev then
		local breakpoints = ed and ed.breakpoints
		code_rev, code.rev = library_code.rev, library_code.rev
		local is_new = breakpoints or Tool.Hash(code) ~= Tool.Hash(library_code)
		if is_new then library_code = Tool.Copy(library_code) end
		if breakpoints then
			for i,v in pairs(breakpoints) do if (i >> 16) == code_id then library_code[i & 0xffff].breakpoint = true end end
			is_new = Tool.Hash(code) ~= Tool.Hash(library_code) -- compare with breakpoints applied again
		end
		if is_new then
			code, self.code = library_code, library_code
			self:Refresh(nil, true)
		end
	end

	local have_bpnt
	if self.refreshbpnts then
		local graph, breakpoints, dirtybpnts = self.graph, ed and ed.breakpoints
		for inst_idx,inst in ipairs(code) do
			local bp, node = inst.breakpoint, graph[inst_idx]
			if node and not bp ~= not node.bpnt then -- node can be nil during dragging
				if node.bpnt then self.draw:Remove(node.bpnt) end
				node.bpnt = bp and self.draw:AddCircle(node.x, node.y + 15, 10, "#E41400") or nil
			end
			have_bpnt = have_bpnt or bp
			dirtybpnts = dirtybpnts or bp ~= (breakpoints and breakpoints[(code_id << 16) | inst_idx]) or nil
		end
		if not have_bpnt and breakpoints then for i,v in pairs(breakpoints) do if (i >> 16) ~= code_id then have_bpnt = true break end end end
		self.refreshbpnts, self.dirtybpnts = have_bpnt, dirtybpnts
	end
	self.hide_bpntlight = not have_bpnt

	if is_running ~= self.comp_running then
		self:SetCompRunning(is_running)
	end

	local show_indicator = 0
	if ed and code_rev and not self.is_dirty then
		local revid, return_num = GetLibraryRevId(code_id, code_rev)
		if ed.revid == revid and not is_stopped then
			if is_paused and ed.blocks and #ed.blocks > 0 then
				show_indicator = counter or ed.blocks[#ed.blocks][2]
			elseif is_paused then
				show_indicator = counter or 1
			else
				show_indicator = ed.lastcounter or 0
			end
		elseif ed.returns and #ed.returns > 0 then
			for i,r in ReverseIPairs(ed.returns) do
				if r[1] == revid then
					show_indicator = r[5]
					return_num = i
					break
				end
			end
		end

		if self.dbgvalues.active then
			local dbgasm, dbgstate = GetCachedBehaviorAsm(revid), ed
			if return_num then
				dbgstate = { mem = ed.mem, stk = ed.returns[return_num][2], returns = {} }
				table.move(ed.returns, 1, return_num - 1, 1, dbgstate.returns)
			elseif ed.revid ~= revid then
				dbgstate = nil -- edited sub-routine is not currently running
			end
			if dbgstate then
				for _,r in pairs(self.regs) do
					local reg_idx, arg_idx, val, isconst = r.reg_idx, r.arg_idx
					if reg_idx < 0 then -- frame register
						val = InstGet(comp, dbgstate, reg_idx)
					elseif not arg_idx then -- parameter
						val = InstGet(comp, dbgstate, reg_idx)
					elseif dbgasm then
						local dbgasminst = dbgasm[r.parent.parent.inst_idx]
						val = InstGet(comp, dbgstate, dbgasminst[arg_idx + (data.instructions[dbgasminst[1]].make_asm and 3 or 2)])
						isconst = type(code[r.parent.parent.inst_idx][arg_idx]) == "table"
					end
					if val then
						local val_num, val_id, val_entity, val_coord = val.num, val.id, val.entity, val.coord
						r.num = (val_num ~= 0) and val_num or (not val_id and not val_entity and not val_coord and not val.is_empty and 0) or nil
						r.def_id, r.entity, r.coord = val_id, val_entity, val_coord
					end
					r.bg = (isconst and "reg_value") or (val.entity and "reg_entity") or nil
				end
			end
		end
	end
	self.show_indicator = show_indicator

	--[[ -- Show debug panel with current states
	if not self.watch then
		self.watch = self.pan:Add("<ScrollList width=400 height=600 dock=bottom-left><Text id=watch/></ScrollList>").watch
		self.watch.on_click = function() print(code) end
	end
	self.watch.text =
		"Has Code: "  .. tostring(not not has_code)   .. "\nDirty: "  .. tostring(not not self.is_dirty) .. "\nRunning: "   .. tostring(not not is_running) ..
		"\nStopped: " .. tostring(not not is_stopped) .. "\nPaused: " .. tostring(not not is_paused)     .. "\nIndicator: " .. tostring(show_indicator)    ..
		"\nCounter: " .. tostring(ed and ed.counter)  .. "\nDebug: "  .. tostring(ed and ed.debug)       .. "\nCalldepth: " .. tostring(ed and ed.returns and #ed.returns) ..
		"\nCode ID: " .. tostring(code_id)          .. "\nCode Rev: " .. tostring(code_rev)            .. "\nBehavior ID: " .. tostring((ed and ed.revid or 0) & 0xFFFFFFFF) .. "\nBehavior Rev: " .. tostring((ed and ed.revid or 0) >> 32) ..
		"\n\n<hl>Code</>: " .. tostring(code) .. "\n\n<hl>ASM</>: " .. tostring(self.is_remote and GetFactionBehaviorAsmById(Game.GetLocalPlayerFaction(), code_id)) ..
		"\n\n<hl>Mem</>:"   .. tostring(ed and ed.mem) .. "\n\n<hl>Returns</>:"   .. tostring(ed and ed.returns) .. "\n\n<hl>Blocks</>:"   .. tostring(ed and ed.blocks) .. "\n\n<hl>Stk</>:"   .. tostring(ed and ed.stk) .. "\n\n<hl>Breakpoints</>:"   .. tostring(ed and ed.breakpoints)
	--]]
end

function Program:every_frame_update()
	local show_indicator = self.show_indicator
	local node = show_indicator and self.graph[show_indicator]
	local sx, sy, ex, ey
	if node then
		local x, y, w, h = node:GetViewportPosition(self.graph)
		if x then sx, sy, ex, ey = x - 10, y - 10, x + w + 10, y + h + 10 end
	end

	local draw_idx = self.indicator_lines
	if draw_idx and sx then
		local osx, osy = self.draw:GetPoint(draw_idx, 1)
		local oex, oey = self.draw:GetPoint(draw_idx, 3)
		sx, sy, ex, ey = osx + (sx - osx) * .75, osy + (sy - osy) * .75, oex + (ex - oex) * .75, oey + (ey - oey) * .75
		self.draw:SetLines(draw_idx, sx, sy, ex, sy, ex, ey, sx, ey, sx, sy, "yellow", 2 / self.pan.zoom)
	elseif sx then
		self.indicator_lines = self.draw:AddLines(sx, sy, ex, sy, ex, ey, sx, ey, sx, sy, "yellow", 2 / self.pan.zoom)
	elseif draw_idx then
		self.draw:Remove(draw_idx)
		self.indicator_lines = nil
	end
end

function Program:on_click_run(btn)
	if not self.comp or not self.comp.exists then return end
	self:SendBehavior(btn.debug)
end

function Program:showregvals()
	if self.is_dirty or not self.comp or not self.comp.exists then return end
	for i,v in pairs(self.regs) do
		v.org_icon, v.org_num = v.icon, v.num
		v:ChangeSource(self.comp.owner, i > 0 and self.comp, i * (i > 0 and 1 or -1))
	end
end

function Program:hideregvals()
	for i,v in pairs(self.regs) do
		if v.ent then
			v.icon, v.num, v.org_icon, v.org_num = v.org_icon, v.org_num
			v:ChangeSource(nil, nil, nil)
		end
	end
end

function Program:SendBehavior(debug, counter)
	local comp, is_dirty, need_save = self.comp, self.is_dirty, (debug ~= "STOP" and debug ~= "PAUSE")
	if (is_dirty and need_save) or self.dirtybpnts then
		self:remote_do_save(nil, nil, nil, debug, counter)
	else
		Action.SendForEntity("Behavior", comp.owner, { comp = comp, debug = (debug ~= "CONTINUE" and debug or nil), counter = counter })
	end
end

local function param_set_table_field(tbl, num, newval)
	if not tbl then tbl = {} end
	for i=1,num-1 do tbl[i] = tbl[i] or false end
	tbl[num] = newval
	for i=#tbl,1,-1 do if tbl[i] then break end tbl[i] = nil end
	return EmptyTableAsNil(tbl)
end

function Program:param_on_rename(box)
	local code, num = self.code, box.param_idx
	local pnames, default_pname = code.pnames, NOLOC(L("Parameter %d", num))
	InputBox("Set the parameter name", "Behavior",
		function (t)
			local name = t and t ~= "" and t ~= default_pname and t or nil
			if (pnames and pnames[num] or nil) == name then return end
			code.pnames = param_set_table_field(pnames, num, name)
			self:Refresh()
		end,
		pnames and pnames[num] or default_pname)
end

function Program:param_on_remove(box)
	self:ModifyParameter(box.param_idx)
end

function Program:param_name_on_drag_start(payload, txt, is_click_drag)
	if not is_click_drag then UI.StartDrag(payload, self:param_on_drag_start(payload, is_click_drag)) end
end

function Program:param_on_drag_start(payload, is_click_drag)
	if is_click_drag then return end
	self.dragline = self.paramlist:Add("<Image width=120 height=78 color=#FFFFFF20/>")
	self.dragline.child_index, self.dragline.start_child_index = payload.child_index, payload.child_index

	payload:RemoveFromParent()
	payload.dragtype, payload.sx, payload.sy, payload.opacity = "PROGRAMPARAM", 0.7, 0.7, 0.8

	-- Can't use {attribute parent reference} for cancel because while dragging payload no longer has a parent
	payload.on_drag_cancel = function(payload)
		local from = self.dragline.start_child_index
		self.dragline:RemoveFromParent()
		self.dragline = nil
		self:ModifyParameter(from)
	end
	return payload
end

function Program:param_on_drag_leave(paramlist, payload)
	if payload.dragtype ~= "PROGRAMPARAM" then return false end
	self.dragline.opacity = 0
end

function Program:param_on_drag_over(paramlist, payload, visual, x, y)
	if payload.dragtype ~= "PROGRAMPARAM" then return false end
	self.dragline.opacity = 1
	self.dragline.child_index = math.min(1 + math.floor(x * #paramlist), #paramlist - 1)
end

function Program:param_on_drop(paramlist, payload)
	if payload.dragtype ~= "PROGRAMPARAM" then return false end
	local from, to = self.dragline.start_child_index, self.dragline.child_index
	self.dragline:RemoveFromParent()
	self.dragline = nil
	self:ModifyParameter(from, to) -- call refresh even if equal
end

function Program:param_add_on_click()
	local code = self.code
	if not code.parameters then code.parameters = {} end
	table.insert(code.parameters, false)
	self:Refresh()
end

function Program:ModifyParameter(index, new_index)
	if index == new_index then self:Refresh(true) return end
	local code, comp = self.code, self.comp
	local params, pnames, pinits, data_instructions = code.parameters, code.pnames, code.pinits, data.instructions
	if not params then error("no parameters?") return end

	-- Reorder arrays (supports move forward, backward, removal and arrays that have nil-holes in them)
	local dir, min, max = (new_index and new_index < index and -1 or 1), math.min(index, new_index or #params), math.max(index, new_index or #params)
	for i=index,(new_index or #params + 1) - dir,dir do
		local j = (i ~= index and (i - dir) or new_index)
		do             params[i], params[j or i] = j and params[j], j and params[i] end
		if pnames then pnames[i], pnames[j or i] = j and pnames[j], j and pnames[i] end
		if pinits then pinits[i], pinits[j or i] = j and pinits[j], j and pinits[i] end
	end

	-- Update indices to parameters in code
	for _,inst in ipairs(code) do
		local inst_def_args, inst_pnum = data_instructions[inst.op].args, inst.pnum
		for i=1,(inst_def_args and #inst_def_args or 0) do
			local arg = inst[i]
			if type(arg) == "number" and inst_def_args[i] and inst_def_args[i][1] ~= "exec" and arg >= min and arg <= max then
				inst[i] = (arg ~= index and (arg - dir) or new_index or false)
			end
		end
		if inst_pnum and inst_pnum >= min and inst_pnum <= max then
			inst.pnum = (inst_pnum ~= index and (inst_pnum - dir) or new_index or nil)
		end
	end

	self:Refresh()
	if comp and comp.has_extra_data and comp.extra_data.main_id == code.id then
		self.reset_reg, self.reset_reg_max = math.min(self.reset_reg or min, min), math.max(self.reset_reg_max or max, max)
	end
end

function Program:connection_on_mouse_enter(outpin)
	local outpin_x, outpin_y, outpin_color = self.draw:GetPoint(outpin.pin_id)
	self.draw:SetCircle(outpin.pin_id, outpin_x, outpin_y, PINSZ_HOVER, outpin_color)
	if outpin.conn_id then self.draw:SetStyle(outpin.conn_id, "white", 8) end
end

function Program:connection_on_mouse_leave(outpin)
	local outpin_x, outpin_y, outpin_color = self.draw:GetPoint(outpin.pin_id)
	self.draw:SetCircle(outpin.pin_id, outpin_x, outpin_y, PINSZ, outpin_color)
	if outpin.conn_id then self.draw:SetStyle(outpin.conn_id, "dark_gray", 6) end
end

function Program:connection_tooltip(outpin)
	local outpin_next_idx, outpin_inst_idx = outpin.next_idx, outpin.inst_idx
	if outpin_next_idx then
		return L("Continue to '%s'", self.graph[outpin_next_idx].title)
	end
	local outpin_level = outpin_inst_idx and self.graph[outpin_inst_idx].level
	if outpin_level then
		for i=outpin_inst_idx-1,1,-1 do
			if (self.graph[i].level or 1) < outpin_level then
				return L("Advance '%s'", self.graph[i].title)
			end
		end
	end
	return "Restart behavior"
end

function Program:connection_on_drag_start(outpin)
	local outpin_x, outpin_y = self.draw:GetPoint(outpin.pin_id)
	if outpin.conn_id then
		self.draw:Remove(outpin.conn_id    )
		self.draw:Remove(outpin.conn_id + 1)
	end
	self.drawdrag:Reset()

	local freeplace = outpin.inst_idx and self.code[outpin.inst_idx].nx
	return UI.New("Spacer", { every_frame_update = function()
		local dx, dy = UI.GetMousePosition(self.drawdrag)
		if not dx then return end

		DrawConnection(self.drawdrag, dy - 30, outpin_x, outpin_y, dx, dy, freeplace or dy < 0, 1)
		self.drawdrag:SetCircle(3, dx, dy, 9)
	end })
end

function Program:MakeFreeFloating(inst_idx, setx, sety) -- Refresh/BuildGraph must be called after this
	local inst = self.code[inst_idx]
	if inst.nx then return end
	local node = self.graph[inst_idx]
	inst.nx, inst.ny = setx or node.x, sety or node.y
	while true do
		node = node.below
		if not node then return end
		inst = self.code[node.inst_idx]
		inst.nx, inst.ny = node.x, node.y
	end
end

function Program:connection_on_drag_cancel(outpin)
	self.drawdrag:Reset()
	local was_changed = outpin.inst_idx
	if was_changed then
		if outpin.next_idx then -- make old target free floating to avoid it getting auto rearranged
			self:MakeFreeFloating(outpin.next_idx)
		end
		self.code[outpin.inst_idx][outpin.arg_idx] = false
	end
	self:Refresh(not was_changed)
end

function Program:connection_on_drag_over(inpin, outpin)
	if not outpin.pin_id then return end -- dragged something else
	local inpin_x, inpin_y = self.draw:GetPoint(inpin.pin_id)
	self.draw:SetCircle(inpin.pin_id, inpin_x, inpin_y, PINSZ_HOVER)
end

function Program:connection_on_drag_leave(inpin, outpin)
	if not outpin.pin_id then return end -- dragged something else
	local inpin_x, inpin_y = self.draw:GetPoint(inpin.pin_id)
	self.draw:SetCircle(inpin.pin_id, inpin_x, inpin_y, PINSZ)
end

function Program:connection_on_drop(inpin, outpin)
	if not outpin.pin_id then return false end -- dragged something else
	self.drawdrag:Reset()

	local code, graph, inpin_inst_idx, outpin_inst_idx, outpin_next_idx = self.code, self.graph, inpin.inst_idx, outpin.inst_idx, outpin.next_idx
	local inpin_node, outpin_node = graph[inpin_inst_idx], outpin_inst_idx and graph[outpin_inst_idx]
	local outpin_loop_start = outpin_inst_idx and outpin.arg_idx == "next" and data.instructions[code[outpin_inst_idx].op].next
	local inpin_level, outpin_level =  (inpin_node.level or 1), (outpin_node and outpin_node.level or 1) + (outpin_loop_start and 1 or 0)
	local connect_to_outer_level = inpin_level < outpin_level and (inpin_inst_idx == outpin_inst_idx or self:GetConnectedNodes(inpin_inst_idx, outpin_inst_idx))
	local was_changed = not connect_to_outer_level and outpin_next_idx ~= inpin_inst_idx
	if was_changed then
		if outpin_next_idx then -- make old target free floating to avoid it getting auto rearranged
			self:MakeFreeFloating(outpin_next_idx)
		end

		-- make new target free floating to avoid it getting auto rearranged
		self:MakeFreeFloating(inpin_inst_idx)

		if not outpin_inst_idx then
			ShiftCode(code, 1, inpin_inst_idx, self.show_extras, self.selection)
		else
			code[outpin_inst_idx][outpin.arg_idx] = inpin_inst_idx
		end
	end
	if connect_to_outer_level and inpin_level == outpin_level - 1 and data.instructions[code[inpin_inst_idx].op].next then
		MessagePopup(nil, "It is unnecessary to set the next instruction to the loop start. A loop will automatically continue at the end of the branch.")
	elseif connect_to_outer_level then
		MessagePopup(nil, "Cannot create connection which leaves the loop. Use the 'Break' instruction to exit out of a loop early.")
	end
	self:Refresh(not was_changed)
end

function Program:RemoveCode(remove_single_node) -- Calls Refresh
	local  code, graph, pins, show_extras, selection = self.code, self.graph, self.pins, self.show_extras, self.selection
	if not remove_single_node and #selection > 1 then -- sort by index
		table.sort(selection, function(a, b) return a.inst_idx < b.inst_idx end)
	end

	-- First go over all out exec pins of to be removed nodes, remember the first one in removed_next_idx and set anything connected to others as freely placed
	local numnodes = (remove_single_node and 1 or #selection)
	for i=1,numnodes do
		local removed_node = remove_single_node or selection[i]
		local remove_idx, removed_next_idx = removed_node.inst_idx
		for j=removed_node.first_pin_idx,removed_node.last_pin_idx do
			local pin = pins[j]
			if pin.inst_idx == remove_idx and pin.arg_idx then
				local next_idx = pin.next_idx
				local next_node = next_idx and next_idx ~= remove_idx and graph[next_idx]
				local next_inst_idx = next_node and next_node.inst_idx or false
				if removed_next_idx == nil then
					removed_next_idx = next_inst_idx
				elseif next_inst_idx and not code[next_inst_idx].nx and next_node.x == removed_node.x + NODEGAP and next_node.y > removed_node.y then
					code[next_inst_idx].nx, code[next_inst_idx].ny = next_node.x, next_node.y
				end
			end
		end
		removed_node.removed_next_idx = removed_next_idx or false
	end

	-- After things got freely placed and removed_next_idx was set on all nodes to be removed, fixup connections to those nodes and pass freely placed location to next nodes
	for i=1,numnodes do
		local removed_node = remove_single_node or selection[i]
		local remove_idx, itr, new_next_idx = removed_node.inst_idx, removed_node.removed_next_idx
		local loop_itr = itr
		repeat
			new_next_idx = itr
			if not itr then break end
			itr = graph[itr].removed_next_idx -- can be false
			if itr == loop_itr then break end -- deleting all of a self-looping block
		until itr == nil
		for _,pin in ipairs(pins) do
			if pin.next_idx == remove_idx and pin.inst_idx then
				code[pin.inst_idx][pin.arg_idx] = new_next_idx
			end
		end
		local removed_inst, next_inst = code[remove_idx], new_next_idx and code[new_next_idx]
		if next_inst and removed_inst.nx and not next_inst.nx then
			next_inst.nx, next_inst.ny = removed_inst.nx, removed_inst.ny
		end
	end

	-- After connections are fixed up, decrement pin connections to higher indices (must iterate in reverse order)
	for i=numnodes,1,-1 do
		local removed_node = remove_single_node or selection[i]
		local remove_idx = removed_node.inst_idx
		for _,pin in ipairs(pins) do
			if pin.next_idx then
				local pin_inst, pin_arg_idx = code[pin.inst_idx], pin.arg_idx
				if (pin_inst and pin_inst[pin_arg_idx] or 0) >= remove_idx then
					pin_inst[pin_arg_idx] = pin_inst[pin_arg_idx] - 1
				end
			end
		end
	end

	-- Lastly actually remove table entries (iterate reverse because selection is modified unless remove_single_node)
	for i=numnodes,1,-1 do
		local remove_idx = (remove_single_node or selection[i]).inst_idx
		table.remove(code, remove_idx)
		if show_extras and remove_idx <= #show_extras then
			table.remove(show_extras, remove_idx)
		end
		for j=(selection and #selection or 0),1,-1 do
			local s_inst_idx = selection[j].inst_idx
			if s_inst_idx > remove_idx then selection[j].inst_idx = s_inst_idx - 1
			elseif s_inst_idx == remove_idx then table.remove(selection, j) end
		end
	end

	self:Refresh()
end

local paramicons<const> = {
	["in"] = "icon_small_register_in",
	["out"] = "icon_small_register_out",
	["exec"] = "icon_small_durability",
}
local paramcolors<const> = {
	["in"] = "cyan",
	["out"] = "yellow",
	["exec"] = "white",
}

function Program:ModifySelection(node, toggle, force_add)
	local selection, idx = self.selection
	if not toggle then
		for i=#selection,1,-1 do
			selection[i].bg = "tech_disabled_bg"
			selection[i] = nil
		end
	end
	if node then
		for i,v in ipairs(selection) do if v == node then idx = i break end end
		if not idx then
			selection[#selection+1] = node
			node.bg = "tech_next_to_research_bg"
		elseif toggle and not force_add then
			node.bg = "tech_disabled_bg"
			table.remove(selection, idx)
		end
	end
	if #selection == 1 then
		self.help_panel.hidden = false
		local def = data.instructions[self.code[selection[1].inst_idx].op]
		self.help_inst_name.text = def.name

		self.help_popup.hidden = not self.help_button.active
		if self.help_button.active then
			self.help_popup_img = def.icon
			self.help_popup_name = def.name
			self.help_popup_desc = def.desc
			self.help_popup_explain = def.explain or "" --"No Explanation defined yet"
			self.explain.hidden = not def.sample
			if def.sample then
				local sample = Tool.StringToTable(def.sample)
				sample.parameters = {false,false,false,false,false}
				local explain_panview = self.explain_panview
				local graph, draw = self.explain_graph, self.explain_draw
				graph:SetIgnoreHitTest()
				BuildGraph(sample, graph, draw, nil, true)
				explain_panview:PanTo(-50, -50)
				explain_panview.zoom = 0.5
			end
		end
		self.argslist:Clear()
		local inst_def_args = def.args
		if inst_def_args then
			self.argslist:Add("Spacer", { height=10})
			for i,arg in ipairs(inst_def_args) do
				local argrow = self.argslist:Add("<Canvas><Image id=bgimage opacity=0.5 fill=true/><HorizontalList id=hl child_padding=4 fill=true/></Canvas>")
				local hl = argrow.hl
				local iconw = hl:Add("VerticalList", { valign="center"})
				iconw:Add("Image", { image = paramicons[arg[1]], color = paramcolors[arg[1]], width=28, height=28, margin=4})
				hl:Add("Text", { text = arg[2], width = 100, valign="center", textwrap=100, wrap=true})
				hl:Add("Image", { width=2, color="ui_dark"})
				hl:Add("Text", { text = arg[3], width = 280, valign="center", textwrap=280, wrap=true})
				argrow.bgimage.color = (i&1==0) and "ui_bg" or "ui_dark"
			end
		end

		self.help_scrolllist:ScrollToStart()
	else
		--self.help_panel.hidden = true
		self.help_inst_name.text = "Select Node for help on that instruction"
		self.help_popup.hidden = true
	end
end

function Program:on_explain_insert()
	local selection = self.selection
	if #selection ~= 1 then return end
	local def = data.instructions[self.code[selection[1].inst_idx].op]
	local visual = UI.New("Canvas", { width = NODEW, height = 60, sx = self.pan.zoom, sy = self.pan.zoom, program_drag_create = Tool.StringToTable(def.sample) })
	BuildGraph(visual.program_drag_create, visual:Add("Canvas"), visual:Add("Draw"), nil, true, self.library)
	UI.StartDrag(self.pan, visual, true)
end

function Program:on_help_popup(btn)
	btn.active = not btn.active
	self:ModifySelection(nil, true) -- refresh help box
end

function Program:node_on_mouse_button_down(node, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" or not node.inst_idx then return false end -- allow scrolling
end

function Program:node_on_mouse_button_up(node, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" or not node.inst_idx then return false end
	self:ModifySelection(node, Input.IsControlDown() or Input.IsShiftDown())
end

function Program:node_on_double_click(node)
	for _,v in ipairs(self:GetConnectedNodes(node.inst_idx)) do
		self:ModifySelection(v, true, true)
	end
	if node.inst_idx then self:ModifySelection(node, true, true) end
end

function Program:node_on_mouse_enter(node)
	if not node.inst_idx then return end
	node.btns = nil
	local node_btns, inst_idx = node.btns, node.inst_idx
	if not node_btns then
		node_btns = node[1]:Add(NodeButtons_layout)
		node_btns.inst_idx = inst_idx
		node.btns = node_btns
	end
	local inst = self.code[inst_idx]
	local freeplace = inst.nx
	node_btns.hidden = false
	node_btns.lockbtn.active = not freeplace
	node_btns.lockbtn.tooltip = freeplace and "Node is freely placed, click to auto arrange" or "Node is auto arranged, click to freely place"
	if node_btns.cmtbtn then node_btns.cmtbtn.active = not not inst.cmt end
	node_btns.extrabtn.hidden = not node.has_extra
	node_btns.extrabtn.active = self.show_extras[inst_idx]
	local ed = self.comp and self.comp.exists and self.comp.has_extra_data and self.comp.extra_data
	local debug = ed and ed.debug
	local is_running = ed and self.comp.is_active
	local is_stopped = not ed or (ed.counter == 1 and not is_running and not debug)
	local is_paused = not is_stopped and debug ~= nil
	node_btns.nextbtn.hidden = not ed
	node_btns.nextbtn.disabled = not is_paused and not is_stopped
	node_btns.nextbtn.active = is_paused and node.inst_idx == self.show_indicator
	node_btns.bpntbtn.hidden = not ed or (inst_idx == 1 and not node.bpnt)
	node_btns.bpntbtn.active = node.bpnt and true
end

function Program:node_on_mouse_leave(node)
	if node.btns then node.btns.hidden = true end
end

function Program:nodebtn_comment_on_click(node_btns)
	local inst = self.code[node_btns.inst_idx]
	InputBox("Set the comment", "Behavior",
		function (t)
			if t == "" then t = nil end
			if inst.cmt == t then return end
			inst.cmt = t
			self:Refresh()
		end,
		inst.cmt or "", false, true)
end

function Program:nodebtn_delete_on_click(node_btns)
	self:RemoveCode(self.graph[node_btns.inst_idx])
	self:ModifySelection(nil, true) -- refresh help box
end

function Program:nodebtn_setnext_on_click(node_btns, btn)
	if not self.comp or not self.comp.exists then return end
	self:SendBehavior("SETCOUNTER", node_btns.inst_idx)
	btn.active = true
end

function Program:nodebtn_setbpnt_on_click(node_btns, btn)
	if not self.comp or not self.comp.exists then return end
	local inst_idx, code, val = node_btns.inst_idx, self.code, not btn.active
	btn.active = val
	code[inst_idx].breakpoint = val or nil
	self.refreshbpnts = true
	self:Refresh(nil, nil, true)
end

function Program:nodebtn_lock_on_click(node_btns)
	local inst = self.code[node_btns.inst_idx]
	if inst.nx then
		inst.nx, inst.ny = nil, nil
	else
		local mx, my = node_btns.parent:GetViewportPosition(self.graph)
		self:MakeFreeFloating(node_btns.inst_idx, ((mx + 20) // 1), (my - 20) // 1)
	end
	self:Refresh()
end

function Program:nodebtn_extra_on_click(node_or_btns)
	local show_extras, inst_idx = self.show_extras, node_or_btns.inst_idx
	for i=1,inst_idx-1 do show_extras[i] = show_extras[i] or false end -- make sure array is filled
	show_extras[inst_idx] = not show_extras[inst_idx]
	self:Refresh(true)
end

function Program:GetConnectedNodes(start_inst_idx, is_connected_to_idx)
	local pins, graph, res = self.pins, self.graph, {}
	for i=0,999999999 do
		if i ~= 0 and not res[i] then return not is_connected_to_idx and res end
		local inst_idx = (i == 0 and start_inst_idx or res[i].inst_idx)
		local inst_node = graph[inst_idx]
		for j=inst_node.first_pin_idx,inst_node.last_pin_idx do
			local pin = pins[j]
			local next_idx = pin.inst_idx == inst_idx and pin.next_idx
			local next_node = next_idx and next_idx ~= start_inst_idx and graph[next_idx]
			if next_node then
				if is_connected_to_idx == next_idx then return res end
				for _,v in ipairs(res) do if v == next_node then goto recursion end end
				res[#res+1] = next_node
				::recursion::
			end
		end
	end
end

function Program:graph_on_mouse_button_down(pan, mousebtn)
	if mousebtn ~= "LEFTMOUSEBUTTON" then return end
	pan.down_x, pan.down_y = UI.GetMousePosition(self.graph)
	if not Input.IsControlDown() then self:ModifySelection() end
end

function Program:graph_on_mouse_button_up(pan, mousebtn)
	if mousebtn ~= "RIGHTMOUSEBUTTON" then return end
	local x, y = UI.GetMousePosition(self.draw)
	UI.MenuPopup([[
		<Box padding=4 width=240 height=400 bg=card_box_bg>
			<VerticalList child_padding=4>
				<TextSearch id=filter on_refresh={on_filter}/>
				<ScrollList id=toolbox fill=true/>
			</VerticalList>
		</Box>]],{
		construct = function(pop)
			self:PrepareToolBox(pop.toolbox)
			pop.filter:Focus()
			local function GetSel()
				local sel, next, prev, first, last
				for _,cat in ipairs(pop.toolbox) do
					if not cat.hidden then
						for _,inst in ipairs(cat.inst_list) do
							if not inst.hidden then sel, next, prev, first, last = inst.sel and inst or sel, sel == last and inst or next, inst.sel and last or prev, first or inst, inst end
						end
					end
				end
				return sel, next or first, prev or last
			end
			pop.filter.inp.on_enter = function()
				local sel, next = GetSel()
				if sel or next then pop.toolbox_item_on_click(pop, sel or next) end
			end
			pop.filter.inp.on_escape = function()
				UI.CloseMenuPopup()
			end
			pop.filter.inp.on_key_down = function (inp,key)
				if key ~= 'DOWN' and key ~= 'UP' then return false end
				local sel, next, prev = GetSel()
				local new = key == 'DOWN' and next or prev
				if sel then sel.sel, sel.color = nil, "white" end
				if new then new.sel, new.color = true, "ui_light" pop.toolbox:ScrollIntoView(new) end
			end
		end,
		on_filter = function (pop, search, filter) return self:on_filter(search, filter, pop.toolbox) end,
		category_on_click = function (pop, ...) return self:category_on_click(...) end,
		instruction_tooltip = function (pop, ...) return self:instruction_tooltip(...) end,
		toolbox_item_on_click = function(pop, item)
			local draw, pin = self.draw
			for _,p in ipairs(self.pins) do
				local px, py = draw:GetPoint(p.pin_id)
				if ((px - x)^2 + (py - y)^2) < 225 then pin = p break end
			end
			local visual = UI.New("Canvas", { width = NODEW, height = 60, program_drag_create = { { op = item.op, nx = x, ny = y } }, drag_pin = pin, keepnxy = true })
			BuildGraph(visual.program_drag_create, visual:Add("Canvas"), visual:Add("Draw"))
			self:graph_on_drop(pan, nil, visual)
			UI.CloseMenuPopup()
		end,
	}, "RIGHT", "TOP")
end

function Program:on_key_down(key)
	if key == "DELETE" then
		local selection = self.selection
		if #selection == 0 then return end
		self:RemoveCode()
		self:ModifySelection() -- clear if selection remained due to similar neighbors
	elseif key == "HOME" then
		self.pan.zoom = 1
		self.pan:PanTo(-50, -50)
	elseif key == "Z" and Input.IsControlDown() then
		if not self.btnundo.disabled then self:on_click_undoredo(self.btnundo) end
	elseif key == "Y" and Input.IsControlDown() then
		if not self.btnredo.disabled then self:on_click_undoredo(self.btnredo) end
	elseif key == "A" and Input.IsControlDown() then
		local not_first -- select all
		for i,v in ipairs(self.graph) do if v.inst_idx then self:ModifySelection(v, not_first) not_first = true end end
	elseif Input.IsBoundToAction(key, "UnitCopy") or Input.IsBoundToAction(key, "UnitPaste") or Input.IsBoundToAction(key, "PauseGame") or Input.IsBoundToAction(key, "CaptureFeedbackShot") or Input.IsBoundToAxis(key, "CameraX") or Input.IsBoundToAxis(key, "CameraY") or key == "F11" then
		return false -- let the bound function handle it
	end
end

function Program:on_key_up(key)
	if Input.IsBoundToAction(key, "UnitCopy") or Input.IsBoundToAction(key, "UnitPaste") or Input.IsBoundToAction(key, "PauseGame") or Input.IsBoundToAction(key, "CaptureFeedbackShot") or Input.IsBoundToAxis(key, "CameraX") or Input.IsBoundToAxis(key, "CameraY") or key == "F11" then
		return false -- let the bound function handle it
	end
end

function Program:CopySelection()
	table.sort(self.selection, function(a, b) return a.inst_idx < b.inst_idx end) -- map low to high
	local res, map, nexts, code, min_x, min_y = {}, {}, {1}, self.code
	for _,w in ipairs(self.selection) do
		local inst_idx = w.inst_idx
		local inst = Tool.Copy(code[inst_idx])
		local wx, wy, nx = w.x, w.y, inst.nx
		if not min_x or wx < min_x then min_x = wx end
		if not min_y or wy < min_y then min_y = wy end
		inst.was_auto_arranged, inst.nx, inst.ny = not nx or nil, wx, wy
		res[#res+1] = inst
		map[inst_idx] = #res
	end
	for _,p in ipairs(self.pins) do
		local map_idx = map[p.inst_idx]
		local arg_idx = map_idx and p.arg_idx
		if arg_idx then
			local conn_idx = map[p.next_idx] or false
			if conn_idx and arg_idx == "next" then nexts[conn_idx] = true end
			if not conn_idx and map_idx == #res then conn_idx = nil end
			res[map_idx][arg_idx] = conn_idx
		end
	end
	for new_inst_idx,inst in ipairs(res) do
		local nx, ny = inst.nx - min_x, inst.ny - min_y
		if inst.was_auto_arranged and nexts[new_inst_idx] then nx, ny = nil end
		if inst.was_auto_arranged then inst.was_auto_arranged = nil end
		inst.nx, inst.ny = nx, ny
	end
	return res
end

local ProgramCopySubs, ProgramCopyBPs, ProgramCopyHash, ProgramCopyLibrary
function Program:on_clipboard_copy()
	if #self.selection == 0 then
		Notification.Warning("Select node(s) to copy")
		return false
	end
	Notification.Warning("Copied selected node(s)")
	local table = self:CopySelection()

	-- Instead of trying to embed referenced subs/bps, just remember them in a Lua variable so references are kept locally (until loading another save)
	ProgramCopySubs, ProgramCopyBPs, ProgramCopyHash = nil, nil, nil
	for inst_idx,inst in ipairs(table) do
		if inst.sub or inst.bp then
			ProgramCopySubs, ProgramCopyBPs = ProgramCopySubs or {}, ProgramCopyBPs or {}
			ProgramCopySubs[inst_idx], ProgramCopyBPs[inst_idx], inst.sub, inst.bp = inst.sub, inst.bp, nil, nil
		end
	end
	ProgramCopyHash, ProgramCopyLibrary = ((ProgramCopySubs or ProgramCopyBPs) and Tool.Hash(table)), self.library

	return table, 'C'
end

function Program:on_clipboard_paste(table, prefix)
	if prefix ~= 'C' then return true end -- still return true to avoid map handling blueprint pasting now
	table = Tool.Copy(table)

	-- Reinsert referenced subs/bps if the copy was made locally
	if ProgramCopyHash and Tool.Hash(table) == ProgramCopyHash and ProgramCopyLibrary == self.library then
		for inst_idx,inst in ipairs(table) do
			local sub, bp = ProgramCopySubs[inst_idx], ProgramCopyBPs[inst_idx]
			if sub then inst.sub = sub end
			if bp then inst.bp = bp end
		end
	end

	local visual = UI.New("Canvas", { width = NODEW, height = 60, sx = self.pan.zoom, sy = self.pan.zoom, program_drag_create = table })
	BuildGraph(visual.program_drag_create, visual:Add("Canvas"), visual:Add("Draw"), nil, true, self.library)
	UI.StartDrag(self.pan, visual, true)
	Notification.Warning("Pasting node(s)")
	return true
end

function Program:toolbox_on_drag_start(payload, a, b)
	local visual = UI.New("Canvas", { width = NODEW, height = 60, sx = self.pan.zoom, sy = self.pan.zoom, program_drag_create = { { op = payload.op } } })
	BuildGraph(visual.program_drag_create, visual:Add("Canvas"), visual:Add("Draw"))
	return visual
end

function Program:node_on_drag_start(node, is_click_drag)
	if not node.inst_idx or is_click_drag then return end
	Program:node_on_mouse_leave(node) -- hide button bar

	UI.PlaySound("fx_ui_ELEMENT_DRAG")

	local selection, keep_selection = self.selection
	for i,v in ipairs(selection) do if v == node then keep_selection = true break end end
	if not keep_selection then self:ModifySelection(node) end

	local zoom = self.pan.zoom
	if Input.IsControlDown() then
		local visual = UI.New("Canvas", { width = NODEW, height = 60, sx = zoom, sy = zoom, program_drag_create = self:CopySelection() })
		BuildGraph(visual.program_drag_create, visual:Add("Canvas"), visual:Add("Draw"), nil, true, self.library)
		return visual
	end

	table.sort(selection, function(a, b) return a.inst_idx < b.inst_idx end) -- insert low to high
	local shiftx, shifty, minx, miny = node.x, node.y, math.maxinteger, math.maxinteger --, math.mininteger, math.mininteger
	local visual = UI.New('<Canvas program_drag_node=true/>', { width = NODEW, height = 60, sx = zoom, sy = zoom })
	for i,v in ipairs(selection) do
		v.old_child_index = v.child_index
		v:RemoveFromParent()
		local x, y = v.x, v.y
		v.old_x, v.old_y, v.x, v.y = x, y, x - shiftx, y - shifty
		visual:Add(v)
		minx, miny = math.min(minx, x), math.min(miny, y)
	end
	node.on_drag_cancel = function(...) self:graph_on_drag_cancel(...) end -- must be set like because RemoveFromParent

	local mx, my = UI.GetMousePosition(node)
	visual.dragx, visual.dragy = (0.5 * visual.width - mx), (0.5 * visual.height - my)
	visual.panx, visual.pany = minx, miny
	visual.x, visual.y = (visual.dragx * zoom), (visual.dragy * zoom)
	return visual, true -- true don't animate visual moving to cursor
end

function Program:graph_on_drag_start(pan, is_click_drag)
	if not pan.down_x or is_click_drag then return end
	local visual = UI.New("<Spacer program_drag_select=true/>")
	self:graph_on_drag_over(pan, pan, visual)
	return visual
end

function Program:graph_on_drag_leave(pan)
	self.drawdrag:Reset()
end

function Program:graph_on_drag_cancel(payload, visual, drag_was_aborted)
	self.drawdrag:Reset()
	if visual.program_drag_node then
		if drag_was_aborted then
			self:Refresh(true)
			return
		end
		local selection, graph = self.selection, self.graph
		table.move(selection, #selection+1, #selection+#selection, 1) -- trim to 0
		for i=#visual,1,-1 do
			local v = visual[i]
			graph:Add(v)
			v.x, v.y, v.child_index = v.old_x, v.old_y, v.old_child_index
			selection[#selection+1] = v
		end
		self:RemoveCode()
	end
end

function Program:graph_on_drag_over(pan, payload, visual)
	if visual.program_drag_select then
		local sx, sy, ex, ey = pan.down_x, pan.down_y, UI.GetMousePosition(self.graph)
		self.drawdrag:SetLines(1, sx, sy, ex, sy, ex, ey, sx, ey, sx, sy, "ui_light", 2 / self.pan.zoom)
	elseif visual.program_drag_node or visual.program_drag_create then
		local create_code, draw = visual.program_drag_create, self.draw
		local drag_graph = create_code and visual[1] or visual

		if visual.sx ~= pan.zoom then
			visual.sx, visual.sy = pan.zoom, pan.zoom
			visual.x, visual.y = (visual.dragx or 0) * pan.zoom, (visual.dragy or 0) * pan.zoom
		end
		if not visual.boxw then
			local boxl, boxu, boxr, boxd = math.maxinteger, math.maxinteger, math.mininteger, math.mininteger
			for _,v in ipairs(drag_graph) do
				boxl, boxu, boxr, boxd = math.min(boxl, v.x), math.min(boxu, v.y), math.max(boxr, v.x + v.width), math.max(boxd, v.y + v.height)
			end
			visual.boxw, visual.boxh = (boxr - boxl), (boxd - boxu)
		end

		local pin_dist, pin, pin_x, pin_y = math.huge
		local tx, ty = UI.GetMousePosition(draw)
		for _,p in ipairs(self.pins) do
			local px, py = draw:GetPoint(p.pin_id)
			local dist = (px - tx)^2 + (py - ty)^2
			if dist < pin_dist then pin_dist, pin, pin_x, pin_y = dist, p, px, py end
		end
		if pin and Input.IsShiftDown() then pin = nil end
		if pin and not drag_graph[1].inpin_id then pin = nil end

		local pin_inst_idx, pin_next_idx, disconnected, no_move, chkdist, dir, box_x, box_y, box_w, box_h = (pin and pin.inst_idx), (pin and (pin.next_idx or (pin.is_in and pin.inst_idx - 1)))
		for i,node in ipairs(drag_graph) do
			local inst_idx = node.inst_idx
			if not create_code and inst_idx == pin_inst_idx then no_move, chkdist = true, true end
			if not create_code and inst_idx == pin_next_idx then no_move = true end
			-- Simplified checks to disallow automatic connecting to a pin
			-- It would be better to allow connecting to output pin if there is only one head node, and allow connecting to an input pin if there is only one tail node
			if node.x == 0 and node.y ~= 0 then disconnected = true end -- a node at the most left but not at the top can't connect either in or out
			if pin_next_idx and node.y ~= 0 then disconnected = true end -- a node not at the top can't connect to input pins
		end
		if pin and (not no_move or not chkdist) and (disconnected or pin_dist > (30000 / self.pan.zoom)) then pin = nil end
		if pin then
			dir, box_w, box_h = (pin.is_out and 1 or -1), visual.boxw, visual.boxh
			if not no_move or not chkdist then
				box_x, box_y = pin_x + 50 * dir - (dir < 0 and box_w or 0), pin_y + 20
			else
				dir, box_x, box_y = -dir, visual.panx, visual.pany
				local nx, ny = drag_graph[1]:GetViewportPosition(draw) -- can be nil on the first frame dragged
				if not nx or ((nx - box_x)^2 + (ny - box_y)^2) > 900 then pin = nil end
			end
		end

		visual.drag_pin, visual.drag_no_move = pin, no_move
		if not pin then
			self.drawdrag:Reset()
		else
			if not no_move or not chkdist then
				self.drawdrag:SetCircle(1, pin_x, pin_y, 9, "dark_gray")
				self.drawdrag:SetLine(2, pin_x, pin_y, box_x + (dir < 0 and box_w or 0), box_y, "dark_gray", 2)
			else
				self.drawdrag:Reset()
			end
			self.drawdrag:SetLine(3, box_x, box_y + box_h / 2, box_x + box_w, box_y + box_h / 2, "#40", box_h) -- fill background
			self.drawdrag:SetLines(4, box_x, box_y, box_x + box_w, box_y, box_x + box_w, box_y + box_h, box_x, box_y + box_h, box_x, box_y, "dark_gray", 4) -- outline
		end
	end
end

function Program:graph_on_drop(pan, payload, visual)
	self.drawdrag:Reset()
	if visual.program_drag_select then
		local function IsBoxOverlap(x1, y1, w1, h1, x2, y2, w2, h2) return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1 end
		local sx, sy, ex, ey = pan.down_x, pan.down_y, UI.GetMousePosition(self.graph)
		sx, sy, ex, ey = math.min(sx, ex), math.min(sy, ey), math.max(sx, ex), math.max(sy, ey)
		local w, h = ex - sx, ey - sy
		local toggle, not_first = Input.IsControlDown()
		for i,v in ipairs(self.graph) do
			if IsBoxOverlap(sx, sy, w, h, v.x, v.y, v.width, v.height) and v.inst_idx then
				self:ModifySelection(v, toggle or not_first)
				not_first = true
			end
		end
	elseif visual.program_drag_node or visual.program_drag_create then
		local create_code, drag_no_move, pin, code, draw, selection = visual.program_drag_create, visual.drag_no_move, visual.drag_pin, self.code, self.draw, self.selection
		local drag_code, drag_graph, old_code_num = create_code or code, create_code and visual[1] or visual, #code
		for i,node in ipairs(drag_graph) do
			local inst = drag_code[node.inst_idx]
			if (not pin or (i ~= 1 and inst.nx and not drag_no_move)) and not visual.keepnxy then -- set or update freely placed position
				local nx, ny = node:GetViewportPosition(draw)
				inst.nx, inst.ny = nx // 1, ny // 1
			end

			-- Append instructions newly inserted to end (before hooking them up and having Refresh reorder the program)
			if create_code then
				local inst_def_args = data.instructions[inst.op].args
				for j=0,(inst_def_args and #inst_def_args or 0) do
					local exec_arg = (j == 0 and "next") or (inst_def_args[j][1] == "exec" and j)
					if exec_arg and inst[exec_arg] then inst[exec_arg] = inst[exec_arg] + old_code_num end
				end
				-- Append at the end but don't connect it to the existing graph
				if i == 1 and old_code_num > 0 then
					local last_inst = code[old_code_num]
					local last_def = data.instructions[last_inst.op]
					local last_def_args = last_def.args
					for k=(last_def.exec_arg == false and 1 or 0),(last_def_args and #last_def_args or 0) do
						local last_arg = (k == 0 and "next" or last_def_args[k][1] == "exec" and k)
						if last_arg and last_inst[last_arg] == nil then last_inst[last_arg] = false end
					end
				end
				code[old_code_num + i] = inst
				node.inst_idx = old_code_num + i -- fix up for the code below and to set the selection
			end

			-- Temporary node will be replaced with the actual node on screen by Refresh
			selection[i] = node
		end

		if pin and not drag_no_move then
			local pin_inst_idx, new_connect_idx, new_connect_exec_arg = pin.inst_idx
			if not pin_inst_idx then
				new_connect_idx = old_code_num > 0 and 1 or false
				new_connect_exec_arg = true -- fake start pin
			elseif pin.is_in then
				new_connect_idx = pin_inst_idx
			else
				new_connect_idx = NextIdx(code, pin_inst_idx, code[pin_inst_idx][pin.arg_idx])
				new_connect_exec_arg = pin.arg_idx
			end

			local drag_first_idx, drag_last_idx = drag_graph[1].inst_idx, drag_graph[#drag_graph].inst_idx

			-- Find the index of what the dragged node(s) were connected to (need to check exec_arg being false because NextIdx doesn't do that)
			local old_connect_idx = NextIdx(code, drag_last_idx, code[drag_last_idx].next)
			if old_connect_idx and data.instructions[code[drag_last_idx].op].exec_arg == false then
				old_connect_idx = false
			end

			-- Fix up connections
			for inst_idx,inst in ipairs(code) do
				local inst_def = data.instructions[inst.op]
				local inst_def_args = inst_def.args
				for i=(inst_def.exec_arg == false and 1 or 0),(inst_def_args and #inst_def_args or 0) do
					local exec_arg = (i == 0 and "next") or (inst_def_args[i] and inst_def_args[i][1] == "exec" and i)
					if exec_arg then
						if inst_idx < drag_first_idx or inst_idx > drag_last_idx then
							local next_idx = NextIdx(code, inst_idx, inst[exec_arg])
							if next_idx == drag_first_idx then
								inst[exec_arg] = old_connect_idx
							elseif next_idx == new_connect_idx and (not new_connect_exec_arg or exec_arg == new_connect_exec_arg) and (not new_connect_exec_arg or inst_idx == pin_inst_idx) then
								inst[exec_arg] = drag_first_idx
							end
						elseif inst_idx == drag_last_idx and (not new_connect_idx or not data.instructions[code[new_connect_idx].op].event_setup) then
							inst[exec_arg] = new_connect_idx
							break
						end
					end
				end
			end

			-- Move auto arranged old connected node into place of node that was moved away
			local old_connect_inst, new_connect_inst, drag_first_inst = code[old_connect_idx], code[new_connect_idx], code[drag_first_idx]
			if old_connect_idx and not old_connect_inst.nx and drag_first_inst.nx then
				old_connect_inst.nx, old_connect_inst.ny = drag_first_inst.nx, drag_first_inst.ny
			end

			-- Make newly inserted node auto arranged or move it into place of node whose input pin it was dragged onto
			if pin.is_in then
				drag_first_inst.nx, drag_first_inst.ny, new_connect_inst.nx, new_connect_inst.ny = new_connect_inst.nx, new_connect_inst.ny, nil, nil
			else
				drag_first_inst.nx, drag_first_inst.ny = nil, nil
			end

			-- To connect or disconnect the program entry node, we need to shift the new program entry to index 1
			if new_connect_idx == 1 and (pin.is_in or not pin_inst_idx) then
				ShiftCode(code, 1, drag_first_idx, self.show_extras, self.selection)
			elseif drag_first_idx == 1 and old_code_num > 0 then
				ShiftCode(code, 1, 2, self.show_extras, self.selection)
			end
		end

		self:Refresh()
		self:ModifySelection(nil, true) -- refresh help box
		self:AnimateSelection()
	else
		return false
	end
end

function Program:reg_on_drag_start(payload, is_click_drag)
	if is_click_drag then return end
	return UI.New(RegDrag_layout, { icon = payload.icon, num = payload.num })
end

function Program:reg_on_drop(over, payload)
	if not payload.reg_idx then return false end -- dragged something else
	local set_inst, set_arg, set_val
	if payload.is_out and not over.inst then -- output argument to register/parameter
		set_inst, set_arg, set_val = payload.inst, payload.arg_idx, over.reg_idx
	elseif over.inst and not payload.inst then -- register/parameter to argument
		set_inst, set_arg, set_val = over.inst, over.arg_idx, payload.reg_idx
	elseif over.inst and payload.inst then -- argument to argument
		local val = payload.inst[payload.arg_idx]
		if over.is_out and (not val or (type(val) == "table" and not val.fr)) then
			return Notification.Error("Output parameter cannot be set")
		elseif val or not payload.is_out then -- copy value
			set_inst, set_arg, set_val = over.inst, over.arg_idx, Tool.Copy(val)
		else -- generate next variable to store output
			local vars = self.vars
			for i=0,25 do
				local var = string.format("%c", 65+i)
				if not vars[var] then
					payload.inst[payload.arg_idx] = var
					set_inst, set_arg, set_val = over.inst, over.arg_idx, var
					break
				end
			end
		end
	else
		return Notification.Error("Invalid parameter target")
	end
	local was_changed = set_inst and Tool.Hash(set_inst[set_arg]) ~= Tool.Hash(set_val)
	if was_changed then set_inst[set_arg] = set_val end
	self:Refresh(not was_changed)
end

function Program:reg_on_click(reg, mousebtn)
	local comp, code, reg_idx = self.comp and self.comp.exists and self.comp, self.code, reg.reg_idx
	if reg_idx <= 0 or not self.regs[reg_idx] then return end
	local function on_set(rsel, val)
		code.pinits = param_set_table_field(code.pinits, reg_idx, val and EmptyTableAsNil(val) or nil)
		if comp and reg_idx <= comp.register_count then Action.SendForEntity("SetRegister", comp.owner, { comp = comp, idx = reg_idx, reg = val }) end
		self:Refresh()
	end
	if mousebtn == "RIGHTMOUSEBUTTON" then
		on_set(nil, nil)
	else
		local rsel = ShowRegisterSelection(reg, on_set, data.instruction_argument_filters.any, nil, { hide_entity_panel = true })
		local initval = code.pinits and code.pinits[reg_idx]
		if rsel and initval then rsel:SetRegister(initval) end
	end
end

function Program:reg_tooltip(reg)
	local code, comp, reg_idx = self.code, self.comp, reg.reg_idx
	local framereg = data.frame_regs[-reg_idx]
	local pinit = code.pinits and code.pinits[reg_idx]
	local title = framereg and L("%s '%s'", "Base Register", framereg.name) or L("%s '%S' (%S%d)", code.parameters and code.parameters[reg_idx] and "Output" or "Input", code.pnames and code.pnames[reg_idx] or L("Parameter %d", reg_idx), "P", reg_idx)
	local params = { title = title, hide_default = framereg and true, hide_inspect = true }
	if pinit then
		params.val_id, params.val_num, params.val_entity, params.val_coord = pinit.id, pinit.num, pinit.entity, pinit.coord
	end
	if comp and comp.exists then
		if framereg then
			params.hide_inspect, params.inspect_entity, params.inspect_reg_index = false, comp.owner, -reg_idx
		elseif reg_idx <= comp.register_count then
			params.hide_inspect, params.inspect_comp, params.inspect_reg_index = false, comp, reg_idx
		end
	end
	return UI.New(RegTooltip_layout, params)
end

function Program:argument_tooltip(reg)
	local val, is_out = reg.inst[reg.arg_idx], reg.is_out
	if not val then
		return -- Unset input/output argument
	elseif type(val) == "table" then
		return BuildDefinitionTooltip(data.all[reg.def_id], { clearreg = true }) or "Constant value"
	elseif type(val) == "string" then
		return L("%s '%S'", (is_out and "Write into variable" or "Read from variable"), val)
	elseif val < 0 then
		return L("%s '%s'", (is_out and "Write into base register" or "Read from base register"), data.frame_regs[-val].name)
	else
		return L("%s '%S' (%S%d)", (is_out and "Write into parameter" or "Read from parameter"), self.code.pnames and self.code.pnames[val] or L("Parameter %d", val), "P", val)
	end
end

function Program:argument_on_click(reg, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" then
		reg.inst[reg.arg_idx] = nil
		self:Refresh()
		return
	end

	local reg_inst, reg_arg_idx, reg_is_out = reg.inst, reg.arg_idx, reg.is_out
	local function register_on_set(rsel, new_value)
		local old_value = reg_inst[reg_arg_idx]
		if rsel then
			if new_value and not next(new_value) then new_value = nil end
			if new_value and new_value.num == 0 and next(new_value, next(new_value)) then new_value.num = nil end
			if Tool.Hash(old_value) == Tool.Hash(new_value) then new_value = old_value end
		end
		if old_value == new_value then return UI.CloseMenuPopup() end
		reg_inst[reg_arg_idx] = new_value
		self:Refresh() -- closes the popup because the underlying reg widget is removed
	end

	local props = {
		construct = function(w)
			local regs, parameters, pnames, vars, radio_storage = self.regs, self.code.parameters, self.code.pnames, self.vars, Game.GetLocalPlayerFaction().extra_data.radio_storage
			for i=-4,-1 do
				w.frameregs:Add("<Reg width=48 height=48 on_click={on_select}/>", { ui_icon = regs[i].ui_icon, val = i })
			end
			for i=1,(parameters and #parameters or 0) do
				w.params:Add("<Reg width=48 height=48 on_click={on_select}/>", { num = pnames and NOLOC(pnames[i]) or regs[i].num, val = i })
			end
			w.params.previous_sibling.hidden = #w.params == 0
			for _,var in ipairs(GetSortedTableKeys(vars)) do
				w.vars:Add("<Reg width=48 height=48 on_click={on_var}/>", { num = var, val = var, tooltip = L("'%S' (%s)", var, "Press right click to rename") }):Add("<Image image=icon_small_register_var color=#FF00FF dock=center/>")
			end
			if reg_is_out then
				w.vars:Add('<Reg width=48 height=48 on_click={on_var}/>', { num = '[NEW]' }):Add("<Image image=icon_small_register_var color=#FF00FF dock=center/>")
			end
			w.vars.previous_sibling.hidden = #w.vars == 0
			for name,idx in SortedPairs(radio_storage and radio_storage.extra_data.names) do
				w.fregs:Add('<Reg width=48 height=48 on_click={on_fac}/>', { num = name, freg = name, tooltip = L("'%S'", name) }):Add("<Image image=icon_small_register_var color=#FF8800 dock=center/>")
			end
			w.fregs.previous_sibling.hidden = #w.fregs == 0
		end,
		on_select = function(w, selected)
			register_on_set(nil, selected.val)
		end,
		on_var = function(w, varreg, mousebtn)
			local val = varreg.val
			if val and mousebtn ~= "RIGHTMOUSEBUTTON" then register_on_set(nil, val) return end -- not naming

			local vars, reg_idx, rename_from = self.vars, reg.reg_idx, val
			local function do_set_name(t)
				if not rename_from then register_on_set(nil, t) return end -- just set new name

				for inst_idx,inst in ipairs(self.code) do
					for k,arg in pairs(inst) do
						if arg == rename_from and type(k) == "number" then inst[k] = t end
					end
				end
				self:Refresh()
				if reg_inst[reg_arg_idx] ~= t then UI.Delay(function() self:argument_on_click(self.regs[reg_idx]) end) end -- open pop up again after layout is done
			end
			if not rename_from then
				for i=0,25 do
					val = string.format("%c", 65+i)
					if not vars[val] then break end
				end
			end
			InputBox("Set the variable name", "Behavior",
				function (t)
					if not t or t == "" or (rename_from and t == rename_from) then return end
					if not vars[t] then do_set_name(t) return end
					ConfirmBox(L("The variable name '%S' already exists. Do you want to merge the two variables?", t), function() do_set_name(t) end)
				end, val)
		end,
		on_fac = function(w, fregreg)
			register_on_set(nil, { fr = fregreg.freg })
		end,
	}

	if reg_is_out then
		-- output argument (use empty register selection with dummy set and filter functions)
		local def_filter_all = function() end
		local rsel = ShowRegisterSelection(reg, function() end, def_filter_all)
		if not rsel then return end -- popup was closed

		rsel:SetContent(OutputArgument_layout, props)  -- overwrite content
	else
		-- input argument
		local inst_def = data.instructions[reg_inst.op]
		local inst_def_args = inst_def and inst_def.args
		local arg_def = inst_def_args and inst_def_args[reg_arg_idx]
		local def_filter = data.instruction_argument_filters[arg_def and not Input.IsControlDown() and arg_def[4] or 'any']
		local no_fixed_value = (def_filter == data.instruction_argument_filters.entity)

		local rsel = ShowRegisterSelection(reg, register_on_set, def_filter)
		if not rsel then return end -- popup was closed

		rsel.max_height = 800
		if reg.coord then
			rsel:SetCoord(reg.coord, type(reg.num) == "number" and reg.num or 0)
		else
			rsel:SetDefId(reg.def_id, nil, type(reg.num) == "number" and reg.num or 0)
		end
		if no_fixed_value then rsel:Clear() end

		local content = rsel:Add(InputArgument_layout, props)
		content.child_index = 1
		content.fixed_lbl.hidden = no_fixed_value
		content.clear_btn.hidden = not no_fixed_value
	end
end

function Program:on_click_help(helpbtn, mousebtn, first_time)
	local welcome_text = [[
<hl>Behaviors</> offer means of customized automation of your units and buildings with a simple programming interface.

The game is designed to be enjoyed fully without using behaviors! But give them a go if you are inclined to eradicate a manual process or to maximize throughput in your base.

A <hl>Behavior</> runs <hl>Instructions</> on one of your <hl>Units</> or <hl>Buildings</> in sequential order. <hl>Instructions</> can affect the behavior of <hl>Units</> and <hl>Buildings</>, branch the running sequence based on conditions or modify the value of a <hl>Parameter</> or <hl>Register</>. Check out the help topics for more details on the editor interface and general use of behaviors.]]

	local interface_help = {
		self.imgicon.parent,    [[The customizable icon of the behavior and a button for advanced behavior restart options.]],
		self.txtactive.parent,  [[
The customizable name and description of the behavior.

Below the description you'll find information about how many units and buildings have the behavior loaded and how many are actively running it at the moment.]],
		self.btnsavenew.parent, [[Buttons to save the behavior under a different name, clearing of the entire behavior, and access to this help screen.]],
		self.reglist.parent,    [[The <hl>base registers</> which can be used as input or output values of the behavior. They can also be set via the unit/building interface.]],
		self.paramlist,         [[The list of <hl>parameters</> specific to the behavior. Any parameter can be an input or output value, or both. These correspond to the registers on the behavior controller visible in the unit/building interface.]],
		self.toolbox,           [[The list of available <hl>instructions</> which can be dragged into the working area.]],
		self.pan,               [[
The <hl>working area</> contains the instruction nodes which are connected to form the sequence of performed operations.

You can scroll the area by dragging empty space or by using WASD keys. To zoom it, use the mouse wheel or the buttons in the top right.

It is also possible to use right-click on empty space or on a connection point to quickly find and insert a new instruction.]],
		self.dbgcam,            [[The camera view showing the unit that is currently being inspected.]],
		self.help_panel,        [[The information box for the currently selected instruction. It can be expanded to show more details and example code that can be added to the behavior.]],
		self.dbgsel_box,        [[
The first button here will switch the screen between displaying the active values in the currently inspected behavior controller and the code identifiers for parameters and variables.
The second button lets you select which behavior controller of your units to inspect.]],
		self.dbgbtn_box,        [[Buttons to stop, start, pause, continue or step the behavior. Only available when a specific behavior controller is being inspected.]],
		self.undoredo_box,      [[These buttons undo or redo changes step by step.]],
		self.remoteconfirm_box, [[Buttons to close the editor and to apply or discard changes. Running the behavior will automatically apply any unsaved changes as well.]],
		self.localconfirm_box,  [[A button to close the editor. When editing a behavior in the Favorites (outside the Library), any changes are automatically saved.]],
	}

	local w = UI.AddLayout([[<Modal><Box dock=fill bg=false blur=true><Box dock=center bg=popup_box_bg padding=4 blur=true width=1000><VerticalList>
			<Box bg=popup_additional_bg padding=12>
				<HorizontalList halign=center child_align=center child_padding=20>
					<Image image=icon_behavior color=ui_light/>
					<Text text="Welcome to Behaviors!" size=32 style=bl/>
				</HorizontalList>
			</Box>
			<Box bg=popup_pattern padding=12>
				<VerticalList halign=center>
					<Text wrap=true text={welcome_text} margin=20/>
					<Image height=2 color=ui_light margin=8/>
					<HorizontalList fill=true>
						<VerticalList fill=true>
							<Text text="Help Topics" textalign=center style=bl margin=10/>
							<VerticalList id=topics child_padding=8 margin=10 halign=center>
								<Button icon=icon_question textalign=left  text="Interface Explanation" width=300 on_click={on_click_interface} id=interfacebtn/>
								<Button icon=icon_question textalign=left text="Behavior Controllers" width=300 on_click={on_click_codex} codex_id=x_tc_behaviors/>
								<Button icon=icon_question textalign=left text="Making a Simple Behavior" width=300 on_click={on_click_codex} codex_id=x_behaviors/>
							</VerticalList>
						</VerticalList>
						<VerticalList fill=true>
							<Text text="Get Started with a Template" style=bl textalign=center margin=10/>
							<ScrollList id=templates child_padding=8 margin=10 height=260/>
						</VerticalList>
					</HorizontalList>
					<Image height=2 color=ui_light margin=8/>
				</VerticalList>
			</Box>
			<Box bg=popup_additional_bg padding=12>
				<Button halign=center width=250 icon=icon_deny text="Close Welcome Screen" on_click={on_ui_cancel}/>
			</Box>
		</VerticalList></Box></Box></Modal>]], {
		welcome_text = welcome_text,
		on_ui_accept = function(w) w:RemoveFromParent() end,
		on_ui_cancel = function(w) w:RemoveFromParent() end,
		on_click_codex = function(w, btn)
			local c = UI.AddLayout([[<Modal><Box dock=fill bg=false blur=true><Box dock=center bg=popup_box_bg padding=4 blur=true width=1000><VerticalList>
					<Box bg=popup_additional_bg padding=12><HorizontalList halign=center child_align=center child_padding=12>
						<Image image=icon_question color=ui_light/>
						<Text halign=center text={title} size=32 style=bl/>
					</HorizontalList></Box>
					<Box bg=popup_pattern padding=12><ScrollList child_padding=8 margin=10 height=600><Text text={content} wrap=true/></ScrollList></Box>
					<Box bg=popup_additional_bg padding=12><Button halign=center width=250 icon=icon_deny text="Close" on_click={on_ui_cancel}/></Box>
				</VerticalList></Box></Box></Modal>]], {
				on_ui_accept = function(w) w:RemoveFromParent() end,
				on_ui_cancel = function(w) w:RemoveFromParent() end,
			})
			local codex_def = data.codex[btn.codex_id]
			c.title = codex_def.title
			c.content = codex_def.text
		end,
		on_click_interface = function(w)
			w.every_frame_update = nil
			w:TweenFromTo("opacity", 1, 0, 200)
			UI.AddLayout([[<Canvas>
					<Image color="#00000077"/><Image color="#00000077"/><Image color="#00000077"/><Image color="#00000077"/><Box bg=tutorial_highlight blocking=false/>
					<Canvas width=0 height=0><Canvas>
						<Box bg=popup_box_bg blur=true padding=32 blocking=false><Text wrap=true width=700 text={txt}/></Box>
						<Image dock=bottom-right x=4 y=-3 color=ui_light image=icon_left_mouse opacity=0.5 sx=0.75 sy=0.75/>
					</Canvas></Canvas>
				</Canvas>]], {
				on_ui_cancel = function(cnvs) cnvs:RemoveFromParent() w:TweenFromTo("opacity", 0, 1, 200) end,
				on_ui_accept = function(cnvs) cnvs:on_click() end,
				construct = function(cnvs) cnvs:on_click() end,
				on_click = function(cnvs)
					cnvs.n = (cnvs.n or -1) + 2
					local glow_widget, popup_text = rawget(interface_help, cnvs.n), rawget(interface_help, cnvs.n+1)
					if not popup_text then return cnvs:on_ui_cancel() end -- finished
					if not glow_widget or glow_widget.hidden then return cnvs:on_click() end -- skip
					local gx, gy, gw, gh = glow_widget:GetViewportPosition(self)
					if not gx then cnvs.n = cnvs.n - 2 UI.Delay(function() cnvs:on_click() end) return end -- wait for layout

					-- Show darkened areas around the highlighted area
					local gr, gd, cx, cy, cw, ch = gx+gw, gy+gh, self:GetViewportPosition()
					local i1, i2, i3, i4, box, pop_anchor, pop_inner = cnvs[1], cnvs[2], cnvs[3], cnvs[4], cnvs[5], cnvs[6], cnvs[6][1]
					i1.x, i1.y, i1.width, i1.height = -1000, -1000, 99999, gy + 1000 -- above
					i2.x, i2.y, i2.width, i2.height = -1000, gd, 99999, 99999 -- below
					i3.x, i3.y, i3.width, i3.height = -1000, gy, gx + 1000, gh -- left
					i4.x, i4.y, i4.width, i4.height = gr, gy, 99999, gh -- right

					-- Position and animate the highlight box
					box:TweenFromTo("x", gx - 100, gx, 800)
					box:TweenFromTo("y", gy - 100, gy, 800)
					box:TweenFromTo("width", gw + 200, gw, 800)
					box:TweenFromTo("height", gh + 200, gh, 800)
					box:TweenFromTo("opacity", 0, 1, 800)

					-- Position and setup the text box
					pop_anchor.x = gx + (((gy > 800 or gy < 150) and ((gx < 50 or gr < 500) and -gx or gr > cw-50 and gw or gw*.5)) or (gx < 800 and (gw < 500 and gw+20 or gw*.5)) or -20)
					pop_anchor.y = gy + ((gy > 800 and -20) or (gy < 150 and gh+20) or (gw < 500 and gh*.5) or -20)
					pop_inner.valign = (gy > 800 and "bottom") or (gy < 150 and "top") or "center"
					pop_inner.halign = ((gx < 50 or gr < 500) and "left")  or (gr > cw-50 and gw < 500 and "right") or "center"
					pop_inner:TweenFromTo("opacity", 0, 1, 800)
					cnvs.txt = popup_text
				end,
			}, 999)
		end,
		on_click_template = function(w, t)
			local sample = t.code
			local c = UI.AddLayout([[<Modal><Box dock=fill bg=false blur=true><Box dock=center bg=popup_box_bg padding=4 blur=true width=1600><VerticalList>
					<Box bg=popup_additional_bg padding=12><HorizontalList halign=center child_align=center child_padding=12>
						<Image image=icon_small_behavior color=ui_light/>
						<VerticalList child_padding=3 child_align=top fill=true><Text text={name} size=18 style=bl/><Text text={info} size=10 style=bl/></VerticalList>
					</HorizontalList></Box>
					<Box bg=popup_pattern padding=12 height=700><PanView id=preview_panview on_mouse_wheel={on_pan_mouse_wheel}>
						<Canvas id=preview_graph/>
						<Draw id=preview_draw/>
					</PanView></Box>
					<Box bg=popup_additional_bg padding=12><HorizontalList halign=center child_padding=12>
						<Button icon=icon_comp text="Load as Behavior" on_click={on_load}/>
						<Button icon=icon_paste text="Append Code to Behavior" on_click={on_paste} />
						<Button icon=icon_deny text="Close" on_click={on_ui_cancel}/>
					</HorizontalList></Box>
				</VerticalList></Box></Box></Modal>]], {
				name = sample.name, info = sample.desc,
				on_ui_accept = function() end,
				on_ui_cancel = function(c) c:RemoveFromParent() end,
				on_pan_mouse_wheel = function(c, pan, wheel) pan:ZoomTowards(wheel) end,
				on_load = function(c)
					local function do_load()
						local code = self.code
						local org_id, org_rev, org_type, org_folder, org_order = code.id, code.rev, code.type, code.folder, code.order -- library fields
						code.id, code.rev, code.type, code.folder, code.order = nil, nil, nil, nil, nil
						for k in next, code do code[k] = nil end
						for k,v in pairs(sample) do code[k] = Tool.Copy(v) end
						code.subs = nil -- avoid old subroutines
						code.id, code.rev, code.type, code.folder, code.order = org_id, org_rev, org_type, org_folder, org_order
						self:Refresh()
						c:on_ui_cancel()
						w:on_ui_cancel()
					end
					if not self.code[1] and not (self.code.parameters and self.code.parameters[1]) then
						do_load()
					else
						ConfirmPopup(t, L("Are you sure you want to replace the current behavior with '%S'?", sample.name), function() do_load() end)
					end
				end,
				on_paste = function(c)
					local visual = UI.New("Canvas", { width = NODEW, height = 60, sx = self.pan.zoom, sy = self.pan.zoom, program_drag_create = sample })
					BuildGraph(visual.program_drag_create, visual:Add("Canvas"), visual:Add("Draw"), nil, true, self.library)
					UI.StartDrag(self.pan, visual, true)
					c:on_ui_cancel()
					w:on_ui_cancel()
				end,
			})
			local preview_panview, graph, draw = c.preview_panview, c.preview_graph, c.preview_draw
			BuildGraph(sample, graph, draw, nil, true)
			preview_panview:PanTo(-50, -50)
		end,
		every_frame_update = first_time and function(w, dt)
			w.interfacebtn.color = ((w.hl or 0) % 1) < 0.5 and "white" or "ui_light"
			w.hl = (w.hl or 0) + dt
		end,
	})

	for _,code_str in ipairs(data.behaviors) do
		local sample = Tool.StringToTable(code_str)
		w.templates:Add([[<Button on_click={on_click_template}>
				<HorizontalList halign=left child_align=center child_padding=3>
					<Image image=icon_small_behavior color=/>
					<VerticalList child_padding=3 child_align=top fill=true><Text text={name} size=14 style=bl/><Text text={desc} size=10 style=bl/></VerticalList>
				</HorizontalList>
			</Button>]], { code = sample , load_text = "Load", name = sample.name, desc = sample.desc })
	end
	w:TweenFromTo("opacity", 0, 1, 500)
end
