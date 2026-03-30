local RegisterSelection_layout<const> =
[[
	<VerticalList>
		<Canvas id=warnbox hidden=true height=56 clip=true>
			<Image color="#5CEBA319" dock=fill/>
			<Image image=warning_pattern color="#60D4A2" dock=top-right/>
			<Image image=icon_warning color="#FFFF00" dock=left/>
			<Text id=warntxt dock=left margin_left=56 margin_right=12/>
		</Canvas>
		<Box bg=popup_pattern padding=4 id=listbox fill=true>
			<VerticalList>
				<TextSearch id=inst_search margin=4 margin_right=0 on_refresh={on_filter}/>
				<Text margin_bottom=10 id=title textalign=center/>
				<ScrollList id=list fill=true/>
			</VerticalList>
		</Box>
		<Box bg=popup_pattern padding=8 id=listworld fill=true>
			<VerticalList child_padding=16>
				<HorizontalList>
					<VerticalList child_padding=8 hidden={hide_entity_panel} fill=true>
						<Text text="World Object" textalign=center/>
						<Reg width=60 height=60 id=entityreg halign=center on_click={entityreg_on_click}/>
					</VerticalList>
					<Image id=entitycoordline width=2 color=ui_light height=108/>
					<VerticalList child_padding=4 hidden={hide_coord_panel} fill=true>
						<Text text="World Coordinate" textalign=center/>
						<HorizontalList halign=center child_padding=4 on_mouse_wheel={on_coord_mouse_wheel} axis=x>
							<Text text="X" width=30 valign=center/>
							<Button icon=icon_minus width=32 height=32 on_click={on_coord_shift} amount=-1 axis=x/>
							<InputText id=coordx on_change={on_coord_change} on_enter={on_ui_accept} textalign=center width=128 height=32/>
							<Button icon=icon_add width=32 height=32 on_click={on_coord_shift} amount=1 axis=x/>
						</HorizontalList>
						<HorizontalList halign=center child_padding=4 on_mouse_wheel={on_coord_mouse_wheel} axis=y>
							<Text text="Y" width=30 valign=center/>
							<Button icon=icon_minus width=32 height=32 on_click={on_coord_shift} amount=-1 axis=y/>
							<InputText id=coordy on_change={on_coord_change} on_enter={on_ui_accept} textalign=center width=128 height=32/>
							<Button icon=icon_add width=32 height=32 on_click={on_coord_shift} amount=1 axis=y/>
						</HorizontalList>
					</VerticalList>
				</HorizontalList>
				<Button halign=center width=200 icon=icon_map text="Select on Map" on_click={select_on_map_on_click} hidden={hide_entity_panel}/>
			</VerticalList>
		</Box>
		<VerticalList child_padding=2 on_mouse_wheel={on_value_mouse_wheel} margin_top=10>
			<Box id=tabbox bg=popup_additional_bg padding=6>
				<HorizontalList id=tabs child_padding=5 child_fill=true>
					<Button text="Inventory Item" tab=item   on_click={tab_on_click}/>
					<Button text="World"          tab=world  on_click={tab_on_click}/>
					<Button text="Types"          tab=frame  on_click={tab_on_click}/>
					<Button text="Information"    tab=value  on_click={tab_on_click}/>
				</HorizontalList>
			</Box>
			<Box bg=popup_additional_bg padding=6 id=production hidden=true>
				<HorizontalList halign=right child_align=top>
					<Wrap id=ingredients child_padding=4/>
					<Text width=56 y=10 id=txttime textalign=center/>
					<Text width=56 y=10 text="→" size=20  textalign=center/>
					<Reg id=select on_click={reg_on_click} on_mouse_wheel={on_value_mouse_wheel} clearreg=true/>
					<Button id=editbtn on_click={edit_on_click} icon=icon_edit margin_left=4 tooltip="Unit Editor" hidden=true/>
				</HorizontalList>
			</Box>
			<Box bg=popup_additional_bg padding=6>
				<HorizontalList child_padding=5 height=56>
					<VerticalList id=barnumber fill=true>
						<HorizontalList child_padding=5 height=28>
							<Button width=64 text="-10" on_click={minus_ten} noclicksound=true/>
							<Button width=64 text="-1"  on_click={minus_one} noclicksound=true/>
							<InputText width=64 padding=0 id=input on_change={on_input_change} on_enter={on_ui_accept} textalign=center fill=true/>
							<Button width=64 text="+1"  on_click={plus_one} noclicksound=true/>
							<Button width=64 text="+10" on_click={plus_ten} noclicksound=true/>
							<Button id=notbtn text="≠" width=32 on_click={set_not} on_double_click={on_ui_accept_not} noclicksound=true tooltip="Set not equal - Double click to apply"/>
							<Button id=infbtn text="∞" width=32 on_click={set_inf} on_double_click={on_ui_accept_inf} noclicksound=true tooltip="Set infinite - Double click to apply"/>
						</HorizontalList>
						<Canvas>
							<Image id=zeroindicator width=2 height=28 dock=center color=gray hidden=true/>
							<Slider id=slider min=1 max=126 on_change={on_slider_change} height=32 halign=fill margin_left=20 margin_right=20/>
							<Text id=slidermintxt dock=left color=gray width=20 textalign=center/>
							<Text id=slidermaxtxt dock=right color=gray width=20 textalign=center/>
						</Canvas>
					</VerticalList>
					<Button id=barnot icon=icon_deny on_click={set_not} text="Toggle Reverse Filter" tooltip="When active, returns the opposite result" fill=true hidden=true/>
					<Button icon=icon_remove on_click={on_clear} tooltip="Clear the value and close" id=clearbtn hidden={hide_clear_button}/>
					<Button icon=icon_confirm on_click={on_ui_accept} tooltip="Set the value and close" id=applybtn/>
				</HorizontalList>
			</Box>
			</VerticalList>
	</VerticalList>
]]

local RegisterSelectionCategoryTitle_layout<const> = "<Text height=24/>"

local RegisterSelectionCategoryWrap_layout<const> = "<Wrap child_padding=5 wrapsize=605/>"

local RegisterSelectionItem_layout<const> =
[[
	<Box width=56 height=56 bg=item_default>
		<Canvas child_fill=true>
			<Image image={racebg} hide_no_image=true margin=2/>
			<Image image={icon} id=iconimg color="#D0" margin=3/>
			<Image image=icon_small_durability color=ui_light id=newicon width=16 height=16 dock=top-right hidden=true />
		</Canvas>
	</Box>
]]

local RegisterSelectionBP_layout<const> =
[[
	<Box width=56 height=56 bg=item_default>
		<Canvas child_fill=true>
			<Image image={racebg} hide_no_image=true margin=2/>
			<Preview id=iconimg margin=3 visual={visual} components={components}/>
			<Image image=icon_small_input color=ui_light id=newicon width=16 height=16 dock=top-right hidden=true />
			<RegNoNum def_id={bpicon_id} hidden={bpicon_hidden} width=36 height=36 bg=black_bg no_interact=true dock=bottom-right />
		</Canvas>
	</Box>
]]


local function FillDB(rs)
	local is_production, is_miner, producer_id, def_filter = rs.is_production, rs.is_miner, rs.producer_id, rs.def_filter

	local function on_click_def_id(w, mbtn) w.newicon.hidden=true rs:SetDefId(w.def_id, nil, nil, (mbtn == "RIGHTMOUSEBUTTON")) end
	local function on_click_blueprint(w, mbtn) rs:SetDefId(w.bp.frame, w, nil, (mbtn == "RIGHTMOUSEBUTTON")) end
	local function on_tooltip_def(w) return BuildDefinitionTooltip(w.def, is_production and { reg_comp = rs.component } or nil) end
	local function on_tooltip_bp(w) return BuildDefinitionTooltip(w.bp) end
	local on_double_click = rs.on_ui_accept and function(w) if rs.register.id == w.def_id or rs.selected_bp == w.bp then rs:on_ui_accept() end end

	local db, db_defs, bpfolders, last_bp_cat_idx, last_bp_cat_name = { item = {}, frame = {}, value = {} }, {}, {}

	local function add_definition(id, def, category, bp_frame_def, bp_multi, catidx)
		local cat_tab = category.tab
		if not cat_tab then return end

		if def_filter and not def_filter(def, category) then return end

		if is_production then
			local production_recipe = (bp_frame_def or def).production_recipe
			if producer_id and (not production_recipe or not production_recipe.producers[producer_id]) then return end
			cat_tab = "item"
		elseif is_miner then
			local mining_recipe = def.mining_recipe
			if not mining_recipe or not mining_recipe[producer_id] then return end
			cat_tab = "item"
		end

		local tab_db = db[cat_tab]
		db_defs[def] = cat_tab

		if not bp_frame_def then
			tab_db[#tab_db+1] = {
				def = def, def_id = id,
				icon = def.texture,
				tooltip = on_tooltip_def,
				on_click = on_click_def_id,
				on_double_click = on_double_click,
				cat_name = category.name,
				sort_key = string.format("%03d%05d%s", catidx, def.index or 99999, id),
				racebg = def.race and GetComponentRaceBG(def.race),
			}
		else -- blueprint (id is numerical id of library, -1 means coming from clipboard)
			if bp_multi then error("should not list multi blueprint") end
			local i, bpcatidx, bpfolder = #tab_db+1, catidx, def.folder
			if bpfolder then
				local folder_idx = bpfolders[bpfolder]
				if not folder_idx then bpfolders[bpfolder], folder_idx = i*1000, i*1000 end
				bpcatidx = folder_idx + bpcatidx
			end
			if bpcatidx ~= last_bp_cat_idx then
				last_bp_cat_name = (id > 0 and L("%s Blueprint", category.name) or category.name)
				if bpfolder then last_bp_cat_name = L("%s (%S)", last_bp_cat_name, bpfolder) end
			end
			tab_db[i] = {
				bp = def, library_id = id,
				icon = def.texture or bp_frame_def and bp_frame_def.texture,
				tooltip = on_tooltip_bp,
				on_click = on_click_blueprint,
				on_double_click = on_double_click,
				cat_name = last_bp_cat_name,
				sort_key = string.format("|%08d%017.8f", bpcatidx, (def.order and (def.order * 2 + 1) or (id * 2))),
				racebg = "blueprint_bg", --bp_frame_def and bp_frame_def.race and GetComponentRaceBG(bp_frame_def.race),
			}
		end
	end

	local faction, show_extra = Game.GetLocalPlayerFaction(), not is_production and not is_miner
	if is_production and not rs.library then rs.library = faction.extra_data.library end
	ProcessUnlockedDefinitions(add_definition, nil, rs.library, is_production and rs.index, show_extra)

	-- Add tech definitions
	local tech_reg_cat = show_extra and { tab = "value", is_tech = true }
	if tech_reg_cat and (not def_filter or def_filter({}, tech_reg_cat)) then
		local seen_tech, tech_categories = Tech_GetSeenTech(), data.tech_categories
		for i=1,#tech_categories+1 do
			local tech_category = tech_categories[i]
			tech_reg_cat.name = tech_category and L("%s Research", tech_category.name) or "Research"
			for tech_id,tech_category_num in pairs(seen_tech) do
				if tech_categories[tech_category_num] == tech_category then -- match generic "Research" undefined category with nil == nil
					add_definition(tech_id, data.techs[tech_id], tech_reg_cat, nil, nil, 100 + tech_category_num)
				end
			end
		end
	end

	for _,regs in pairs(db) do
		table.sort(regs, function (a,b) return a.sort_key < b.sort_key end)
	end
	return db, db_defs
end

local OpenRegisterSelection

local SimpleRegisterSelection_layout<const> =
[[
	<VerticalList>
		<TextSearch id=inst_search margin=5 on_refresh={on_filter}/>
		<ScrollList id=list fill=true/>
	</VerticalList>
]]
local SimpleRegisterSelection = {}
UI.Register("SimpleRegisterSelection", SimpleRegisterSelection_layout, SimpleRegisterSelection)
function SimpleRegisterSelection:construct()
	OpenRegisterSelection = self
	self:Refresh()
	if self.is_production then
		UILibraryLoadButton(self, self.library, true, 'B', self.producer_id or true, "right")
	end
end

function SimpleRegisterSelection:destruct()
	OpenRegisterSelection = nil
end

function SimpleRegisterSelection:on_filter(btn, filter)
	self:Refresh(filter)
end

function SimpleRegisterSelection:Refresh(filter)
	local outlined_def = self.current_id and data.all[self.current_id]
	self.list:Clear()

	if filter == "" then filter = nil end
	local ContainsStringNoCase = filter and Tool.ContainsStringNoCase
	local last_cat_name, regs_list

	for _,tabdb in pairs(FillDB(self)) do
		for _,reg in ipairs(tabdb) do
			local show = not filter or
			(reg.def and ContainsStringNoCase(L(reg.def.name or ""), filter)) or
			(reg.bp  and ContainsStringNoCase(reg.bp.name or "", filter))
			reg.hidden = not show
			if show then
				if last_cat_name ~= reg.cat_name then
					last_cat_name = reg.cat_name
					self.list:Add(RegisterSelectionCategoryTitle_layout, { text = last_cat_name })
					regs_list = self.list:Add(RegisterSelectionCategoryWrap_layout)
				end
				local bp, new_reg = reg.bp
				if bp then
					local frame_def = data.frames[bp.frame]
					if frame_def then
						reg.components = bp.components
						reg.visual = frame_def.visual
						if bp.icon then reg.bpicon_id = bp.icon else reg.bpicon_hidden = true end
						new_reg = regs_list:Add(RegisterSelectionBP_layout, reg)
					end
				else
					new_reg = regs_list:Add(RegisterSelectionItem_layout, reg)
				end
				if (reg.bp or reg.def) == outlined_def then
					new_reg.bg = "item_active"
					new_reg.iconimg.margin = 0
					new_reg.iconimg.color = "#FF"
				end
			end
		end
	end
end

function SimpleRegisterSelection:on_library_loaded(btn, bp)
	self:SendEvent("on_select_id", nil, bp.id)
end

function SimpleRegisterSelection:SetDefId(id, bp_widget, in_num)
	local library_id = bp_widget and bp_widget.library_id
	if library_id and library_id < 0 then error("SimpleRegisterSelection doesn't handle clipboard blueprint") end
	self:SendEvent("on_select_id", id, library_id)
end

local RegisterSelection = {}
UI.Register("RegisterSelection", RegisterSelection_layout, RegisterSelection)
function RegisterSelection:construct()
	OpenRegisterSelection = self

	local comp, entity, comp_def, register_def, def_filter, is_production, any_value, prod_or_miner = self.component, self.entity
	if type(comp) == "function" then
		def_filter, self.def_filter, comp, self.component = comp, comp, nil, nil
	else
		def_filter = self.def_filter
	end
	if type(entity) == "function" then
		self.on_set, entity, self.entity = entity, nil, nil
	end
	if comp then
		entity, comp_def = comp.owner, comp.def
		register_def = not Input.IsControlDown() and comp_def.registers and comp_def.registers[self.index]
		any_value = not register_def or register_def.any_value
		self.entity = entity
	else
		comp_def, register_def = self.comp_def, not Input.IsControlDown() and self.register_def
		any_value = not def_filter and (not register_def or register_def.any_value)
	end

	local title1, title2 = comp_def and comp_def.name ~= comp_def.id and comp_def.name, register_def and register_def.tip
	if title1 or title2 then
		self.title.text = ((title1 and title2 and L("%s - %s", title1, title2)) or title1 or title2)
	else
		self.title.hidden = true
	end

	if register_def then
		if register_def.type == "production" then
			self.production.hidden = false
			self.is_production, is_production, prod_or_miner = true, true, true
			self.producer_id = comp_def and comp_def.id
		elseif register_def.type == "miner" then
			self.is_miner, prod_or_miner = true, true
			self.producer_id = comp_def and comp_def.id
		elseif register_def.type == "radar" then
			self.is_radar = true
			def_filter = data.instruction_argument_filters.radar
			self.def_filter = def_filter
		elseif register_def.filter then
			def_filter = data.component_register_filters[register_def.filter]
			self.def_filter = def_filter
		end
	end

	local self_hide_number_panel = self.hide_number_panel
	local hide_number_panel = self_hide_number_panel or (def_filter and not def_filter({}, { number_panel = true }))
	if hide_number_panel then self.barnumber.hidden = true if not self_hide_number_panel then self.hide_number_panel = true end end

	local self_hide_entity_panel = self.hide_entity_panel
	local hide_entity_panel = self_hide_entity_panel or is_production or (def_filter and not def_filter({}, { entity_panel = true }))
	if hide_entity_panel and not self_hide_entity_panel then self.hide_entity_panel = true end

	local hide_coord_panel = prod_or_miner or (def_filter and not def_filter({}, { coord_panel = true }))
	if hide_coord_panel then self.hide_coord_panel = true end

	if hide_entity_panel or hide_coord_panel then self.entitycoordline.hidden = true end

	self.notbtn.hidden = not any_value and (not def_filter or not def_filter({}, { allow_not = true }))
	self.infbtn.hidden = not any_value and not prod_or_miner and (not def_filter or not def_filter({}, { allow_infinite = true }))

	local mintxt, maxtxt = self.slidermintxt, self.slidermaxtxt
	if not hide_number_panel and (any_value or self.allow_negative or (def_filter and def_filter({}, { allow_negative = true }))) then
		self.allow_negative = true
		self.slider.min = -125
		self.zeroindicator.hidden = false
		mintxt.text, mintxt.size, mintxt.y = "-", 16, -2
		maxtxt.text, maxtxt.size, maxtxt.y = "+", 16, -2
	else
		self.slider.min = prod_or_miner and 1 or 0
		self.slider.max = self.infbtn.hidden and 125 or 126
		mintxt.text, mintxt.size, mintxt.y = prod_or_miner and "1" or "0", 11, -1
		maxtxt.text, maxtxt.size, maxtxt.y = self.infbtn.hidden and "+" or "∞", 16, -2
	end

	if self.apply_text then
		self.applybtn.tooltip = self.apply_text
	end

	-- setup current register state
	if self.register and not self.register.num then self.register.num = 0 end
	self.register = (self.register) or (comp and comp:GetRegister(self.index)) or (entity and entity:GetRegister(self.index)) or { num = 1 }

	if self.register.id then
		self.input:Focus()
	end

	self:Refresh()

	local reg_bp, product_def = not comp and self.reg_bp
	if is_production and comp then
		product_def, reg_bp = GetProduction(self.register.id, comp)
	end
	if reg_bp then
		-- For producing blueprints we need to match a library item with the production blueprint
		local reg_bp_hash
		ProcessLibraryBlueprint(reg_bp, function(clean_reg_bp) reg_bp_hash = Tool.Hash(clean_reg_bp) end)
		for _,w in ipairs(self.db["item"] or {}) do
			local w_bp = w.bp
			if w_bp and w_bp.frame == reg_bp.frame and w_bp.name == reg_bp.name then
				local w_bp_hash
				ProcessLibraryBlueprint(w_bp, function(clean_w_bp) w_bp_hash = Tool.Hash(clean_w_bp) end)
				if reg_bp_hash == w_bp_hash then
					self.selected_bp, self.library_id = w_bp, w.library_id
					break
				end
			end
		end
		if not self.selected_bp then self.edited_bp = Tool.Copy(reg_bp) end
	end

	self:UpdateVisuals(true)

	if comp and comp:RegisterIsError(self.index) and comp_def.get_reg_error and self.warnbox.hidden then
		self.warnbox.hidden = false
		self.warntxt.text = comp_def:get_reg_error(comp)
	end

	--[[DEBUG VIEW
	self:Add("Spacer", { construct = function(w) w.b = UI.AddLayout("<Box width=400 dock=top-left><ScrollList max_height=800><Text text={txt}/></ScrollList></Box>", { every_frame_update = function(wb) wb.txt = string.format("Reg: %s - Library ID: %s\n%s\n%s", tostring(self.register), tostring(self.library_id), (self.edited_bp and 'edited_bp') or (self.selected_bp and 'selected_bp') or '', tostring(self.edited_bp or self.selected_bp)) end, on_mouse_button_down = function(wb) print(wb.txt) end }) end, destruct = function(w) w.b:RemoveFromParent() end })
	--]]
end

function RegisterSelection:destruct()
	OpenRegisterSelection = nil
end

function RegisterSelection:on_filter(btn, filter)
	self:RefreshTab(self.tab, filter)
	self:UpdateVisuals()
end

function RegisterSelection:Refresh()
	self.db, self.db_defs = FillDB(self)
	self:RefreshTab()
	self:UpdateVisuals()
end

function RegisterSelection:RefreshTab(new_tab, filter)
	local old_tab, db, hide_world_tab = self.tab, self.db, self.hide_entity_panel and self.hide_coord_panel
	if old_tab ~= new_tab and not filter then self.inst_search:SetText("") self.inst_search:Focus() end
	new_tab = new_tab or old_tab

	local showcount, selectbtn = 0
	for _,btn in ipairs(self.tabs) do
		local btn_tab, show = btn.tab
		if btn_tab == "world" then
			show = not hide_world_tab
		else
			show = #db[btn_tab] > 0
		end
		btn.hidden = not show
		if show then
			showcount = showcount + 1
			if new_tab == btn_tab or not selectbtn then selectbtn = btn end
		end
	end

	for _,btn in ipairs(self.tabs) do
		btn.active, btn.disabled = (btn == selectbtn), (btn == selectbtn)
	end

	if selectbtn then
		self.tab = selectbtn.tab
		self.last_outlined = false

		if filter == "" then filter = nil end
		local ContainsStringNoCase = filter and Tool.ContainsStringNoCase
		local new_tech, listed_defs, last_cat_name, regs_list = Game.GetLocalPlayerExtra().new_tech, {}
		self.list:Clear()
		for _,reg in ipairs(db[self.tab] or {}) do
			local show = not filter or
				(reg.def and ContainsStringNoCase(L(reg.def.name or ""), filter)) or
				(reg.bp  and ContainsStringNoCase(reg.bp.name or "", filter))
			reg.hidden = not show
			if show then
				if last_cat_name ~= reg.cat_name then
					last_cat_name = reg.cat_name
					self.list:Add(RegisterSelectionCategoryTitle_layout, { text = last_cat_name })
					regs_list = self.list:Add(RegisterSelectionCategoryWrap_layout)
				end

				local bp, new_reg = reg.bp
				if bp then
					local frame_def = data.frames[bp.frame]
					if frame_def then
						reg.components = bp.components
						reg.visual = frame_def.visual
						if bp.icon then reg.bpicon_id = bp.icon else reg.bpicon_hidden = true end
						new_reg = regs_list:Add(RegisterSelectionBP_layout, reg)
					end
				else
					new_reg = regs_list:Add(RegisterSelectionItem_layout, reg)
				end
				local new_def = reg.def or bp
				local id = new_def.id
				if new_tech and new_tech[id] then
					new_reg.newicon.hidden = false
				end
				if new_reg then
					listed_defs[new_def] = new_reg
				end
			end
		end
		self.listed_defs = listed_defs
		self.inst_search.hidden = not next(listed_defs) and (self.inst_search.inp.text or "") == ""
	else
		self.listed_defs = {}
		self.inst_search.hidden = (self.inst_search.inp.text or "") == ""
	end

	local hide_tabs, is_world = (showcount <= 1), (new_tab == "world" or (not hide_world_tab and showcount == 1))
	self.tabbox.hidden = hide_tabs
	self.listbox.hidden = is_world
	self.listworld.hidden = not is_world

	if self.is_production then
		UILibraryLoadButton(self.list, self.library, true, 'B', self.producer_id or true, "right")
	end
end

function RegisterSelection:on_library_loaded(btn, bp)
	if btn ~= 123 then self:Refresh() end -- hack for UI.Delay
	local w = self.listed_defs[bp]
	if not w or not w:IsValid() then return end
	self.list:ScrollIntoView(w)
	if w:GetViewportPosition() then self:SetDefId(w.bp.frame, w) else UI.Delay(function() if self:IsValid() then self:on_library_loaded(123, bp) end end) end
end

function RegisterSelection:entityreg_on_click(reg, mousebtn)
	if reg.entity then View.JumpCameraToEntities(reg.entity) end
	if mousebtn == "LEFTMOUSEBUTTON" then self:select_on_map_on_click() end
end

function RegisterSelection:select_on_map_on_click()
	local reg = self.entityreg
	Notification.Warning("Select the object or unit on the map")
	UI.StartDrag(reg, UI.New("<Image image=icon_add/>")) -- use drag to keep popup open on next click
	self.root.hidden = true
	reg.on_drag_cancel = function(reg, visual, drag_was_aborted)
		if not self:IsValid() or not reg:IsValid() then return end
		self.root.hidden = false
		if drag_was_aborted or UI.IsMouseOverUI() then Notification.Warning("Aborted") return end
		local target, x, y = View.GetHoveredEntity(), View.GetHoveredTilePosition()
		if target then self:SetEntity(target) else self:SetCoord({ x = x, y = y }) end
	end
end

function RegisterSelection:tab_on_click(btn)
	self:RefreshTab(btn.tab)
	self:UpdateVisuals()
end

local LOG_25_TO_9900<const> = math.log(9900, 25)
local LOG_9900_TO_25<const> = math.log(25, 9900)
local function SliderToNumber(v)
	if v == 126 then return REG_INFINITE end
	local a = math.abs(v)
	if a > 100 then v = (100 + ((a > 125 and 125 or a) - 100)^LOG_25_TO_9900) * (v < 0 and -1 or 1) end
	return math.modf(v)
end
local function NumberToSlider(slider, n)
	if not n then slider.value = 0 return end
	if n == REG_INFINITE then slider.value = 126 return end
	if n == REG_NOT then slider.value = 0 return end
	local a = math.abs(n)
	if a > 100 then n = (100 + (a - 100)^LOG_9900_TO_25) * (n < 0 and -1 or 1) end
	slider.value = n
end

function RegisterSelection:UpdateVisuals(switch_tab, is_new_selection, new_edited_bp, new_selected_bp, new_library_id)
	local reg, selected_bp, edited_bp = self.register, self.selected_bp, self.edited_bp
	local reg_id, reg_num, reg_entity, reg_coord = reg.id, reg.num, reg.entity, reg.coord
	if reg_num == 0 and reg.is_empty then reg_num = nil end

	if is_new_selection then
		edited_bp, self.edited_bp = new_edited_bp, new_edited_bp
		selected_bp, self.selected_bp = new_selected_bp, new_selected_bp
		self.library_id = new_library_id
	end

	local bp_def = edited_bp or selected_bp
	local item_def = data.all[bp_def and bp_def.frame or reg_id]

	local outlined_def = selected_bp or item_def
	local outlined = self.listed_defs[outlined_def]
	if not outlined and not reg_entity and not reg_coord then
		if switch_tab and not outlined and self.db_defs[outlined_def] then
			self:RefreshTab(self.db_defs[outlined_def])
			outlined = self.listed_defs[outlined_def]
		end
	elseif switch_tab and (reg_entity or reg_coord) and self.tab ~= "world" and not self.tabbox.hidden then
		self:RefreshTab("world")
	end

	local warning
	if self.is_production then
		local recipe = item_def and item_def.production_recipe
		local recipe_amount = recipe and recipe.amount or 1
		local recipe_ticks = recipe and recipe.producers and recipe.producers[self.producer_id]
		local make_steps = ((reg_num and reg_num > 0 and reg_num or 1) + recipe_amount - 1) // recipe_amount
		local boost = (self.component and self.component.effective_boost or Game.GetLocalPlayerFaction().component_boost)
		if boost ~= 100 and recipe_ticks then recipe_ticks = (recipe_ticks * 100 + boost - 1) // boost end
		self.ingredients:Clear()
		if recipe and recipe.ingredients then
			for id, num in pairs(recipe.ingredients) do
				local def, amt = data.all[id], (num * make_steps)
				local ing = self.ingredients:Add('Reg', { def = def, num = amt, bg = "item_default" })
				ing.on_click = function(wid) self:SetDefId(id, nil, amt) end
			end
		end
		for i,v in ipairs(bp_def and bp_def.components or {}) do
			if type(v[2]) == "number" and v[1] ~= "c_integrated_behavior" then
				local ing = self.ingredients:Add('Reg', { def_id = v[1], num = make_steps, bg = "item_default" })
				ing.on_click = function(wid) self:SetDefId(v[1], nil, make_steps) end
			end
		end
		self.ingredients.width = math.min(6, #self.ingredients) * 60 - 4
		self.txttime.text = (reg_num or 1) > 0
			and L("%s\n%.1fs", "Time", recipe_ticks and (recipe_ticks*make_steps/TICKS_PER_SECOND) or 0)
			or L("%.1f\n/%s", recipe_ticks and 60.0/(recipe_ticks*make_steps/TICKS_PER_SECOND) or 0, "min")
		self.recipe_amount = recipe_amount
		self.select.icon = item_def and item_def.texture
		self.select.def = bp_def or item_def
		self.select.num = reg_num and reg_num > 0 and make_steps * recipe_amount or nil
		self.editbtn.hidden = not item_def or item_def.data_name ~= "frames" or not self.index
		if self.entity and self.entity.slot_count < #self.ingredients + (bp_def and 0 or 1) then
			warning = L("Production needs at least %d inventory slots", #self.ingredients + (bp_def and 0 or 1))
		end
	elseif self.is_radar then
		local show_toggle_not = not item_def or not item_def.radar_use_number
		self.barnumber.hidden = show_toggle_not
		self.barnot.hidden = not show_toggle_not
		self.barnot.active = reg_num == REG_NOT
		if show_toggle_not and reg_num and reg_num ~= 0 and reg_num ~= REG_NOT then reg.num = nil end
		if not show_toggle_not and reg_num == REG_NOT then reg_num, reg.num = 0, 0 end
	elseif self.tab == "world" then
		self.entityreg.entity = reg_entity
		self.coordx.text = reg_coord and tostring(reg_coord.x or 0) or ""
		self.coordy.text = reg_coord and tostring(reg_coord.y or 0) or ""
	end

	if warning then
		self.warnbox.hidden = false
		self.warntxt.text = warning
	else
		self.warnbox.hidden = true
	end

	self.input.text = (not reg_num and "") or (reg_num == REG_INFINITE and "∞") or (reg_num == REG_NOT and "≠") or tostring(reg_num)
	self.notbtn.active = reg_num == REG_NOT
	self.infbtn.active = reg_num == REG_INFINITE
	NumberToSlider(self.slider, reg_num)

	local last_outlined = self.last_outlined
	if last_outlined ~= outlined then
		if last_outlined then
			last_outlined.bg = "item_default"
			last_outlined.iconimg.margin = 3
			last_outlined.iconimg.color = "#D0"
		end
		if outlined then
			outlined.bg = "item_active"
			outlined.iconimg.margin = 0
			outlined.iconimg.color = "#FF"
		end
		self.last_outlined = outlined
		if outlined then
			self.list:ScrollIntoView(outlined)
		else
			self.list:ScrollToStart()
		end
	end
end

function RegisterSelection:on_slider_change(slider, value)
	self.register.num = SliderToNumber(value)
	self:UpdateVisuals()
end

function RegisterSelection:on_input_change(input, value)
	local num = (value == "∞" and REG_INFINITE) or (value == "≠" and REG_NOT) or math.max(math.min(tonumber(string.gsub(value or "", "[^%d-]", ""), 10) or 0, 2147483647), (REG_NOT+1))
	if num < 0 and num ~= REG_INFINITE and num ~= REG_NOT and not self.allow_negative then num = REG_INFINITE end
	if num == REG_INFINITE and self.infbtn.hidden then num = 0 end
	if num == REG_NOT and self.notbtn.hidden then num = 0 end
	self.register.num = num
	if value == "-" then return end -- start of inputting negative number
	self:UpdateVisuals()
end

function RegisterSelection:edit_on_click(btn)
	local selected_bp, frame_id, edited_bp = self.selected_bp, self.select.def.id, self.edited_bp
	local pop = UI.MenuPopup("<Box bg=popup_box_bg padding=4 blur=true/>", { destruct = function() if btn:IsValid() then btn.active = false end end, popupid = selected_bp or frame_id }, btn)
	if not pop then return end
	btn.active = true
	pop:Add("BlueprintEditor", {
		source_bp = selected_bp or { frame = frame_id }, bp = edited_bp, library = self.library or {}, is_remote = true, want_similar = true,
		on_ok = function(pp) UI.CloseMenuPopup(pp) end,
		on_change = function(pp, bp) if self:IsValid() then self:UpdateVisuals(false, true, bp, selected_bp, self.library_id) end end,
	})
end

function RegisterSelection:SetDefId(id, bp_widget, in_num, is_right_click, edited_bp)
	local reg, bp = self.register, bp_widget and bp_widget.bp
	if self.is_production and id then
		if bp and self.selected_bp == bp then
			return is_right_click and self:edit_on_click(self.editbtn)
		elseif bp and bp_widget.library_id == -1 and not edited_bp then
			return UILibraryImportBlueprint(bp, function(mapped_bp) if bp_widget:IsValid() then self:SetDefId(id, bp_widget, in_num, is_right_click, mapped_bp) end end, bp_widget)
		elseif bp and (edited_bp or bp).params then
			return UILibraryAssignBlueprintParams(edited_bp or bp, function(bpp) if self:IsValid() then self:SetDefId(id, bp_widget, in_num, is_right_click, bpp) end end, bp_widget)
		end
		local item_def = data.all[id]
		local production_recipe = item_def and item_def.production_recipe
		local recipe_amount = production_recipe and production_recipe.amount or 1
		local copy_num = not reg.id and reg.num ~= 0 and reg.num
		local init_num = item_def and item_def.stack_size and item_def.stack_size > 1 and recipe_amount == 1 and REG_INFINITE
		local set_num = in_num or copy_num or init_num or 1
		reg.num = set_num > 0 and ((set_num + recipe_amount - 1) // recipe_amount * recipe_amount) or set_num
	elseif self.is_miner and (reg.num or 0) == 0 then
		reg.num = in_num or REG_INFINITE
	elseif in_num or not reg.num then
		reg.num = in_num or 0
	end
	reg.entity, reg.coord = nil, nil
	reg.id = id
	local new_tech = id and not bp and Game.GetLocalPlayerExtra().new_tech
	if new_tech then new_tech[id] = nil end
	self:UpdateVisuals(true, true, edited_bp, bp, (bp_widget and bp_widget.library_id))
	if is_right_click and not self.editbtn.hidden then UI.Delay(function() if self:IsValid() then self:edit_on_click(self.editbtn) end end) end
end

function RegisterSelection:SetEntity(entity)
	local reg = self.register
	reg.id, reg.coord = nil, nil
	reg.entity = entity
	self:UpdateVisuals(true, true)
end

function RegisterSelection:SetCoord(coord, in_num)
	local reg = self.register
	reg.num = in_num or reg.num or 0
	reg.id, reg.entity = nil, nil
	reg.coord = coord
	self:UpdateVisuals(true, true)
end

function RegisterSelection:on_coord_mouse_wheel(hl, wheel)
	local coord, ctrl, shift = self.register.coord, Input.IsControlDown(), Input.IsShiftDown()
	self:on_coord_change(hl.axis == 'x' and self.coordx or self.coordy, (coord and coord[hl.axis] or 0) + ((wheel > 0 and 1 or -1) * (ctrl and 10 or 1) * (shift and 5 or 1)))
end

function RegisterSelection:on_coord_shift(btn)
	local coord, ctrl, shift = self.register.coord, Input.IsControlDown(), Input.IsShiftDown()
	self:on_coord_change(btn.axis == 'x' and self.coordx or self.coordy, (coord and coord[btn.axis] or 0) + (btn.amount * (ctrl and 10 or 1) * (shift and 5 or 1)))
end

function RegisterSelection:on_coord_change(input, value)
	if value == "" or value == "-" then return end -- start of inputting negative number
	local num, reg = math.max(math.min(tonumber(string.gsub(value or "", "[^%d-]", ""), 10) or 0, 2147483647), (REG_NOT+1)), self.register
	reg.id, reg.entity = nil, nil
	reg.coord = { x = (input == self.coordx and num) or tonumber(self.coordx.text, 10) or 0, y = (input == self.coordy and num) or tonumber(self.coordy.text, 10) or 0 }
	self:UpdateVisuals(false, true)
end

function RegisterSelection:reg_on_click(reg, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" then
		self.register.num = nil
		self:SetDefId(nil)
	end
end

function RegisterSelection:change_num(change)
	UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_INCREMENT")
	local n, recipe_amount = self.register.num or 0, self.recipe_amount
	if n == REG_INFINITE or n == REG_NOT or (n == 1 and (change > 1 or change < -1)) then
		n = 0
	end
	if recipe_amount and recipe_amount > 1 then
		n = (n + change * recipe_amount) // recipe_amount * recipe_amount
	else
		n = n + change
	end
	if change == REG_INFINITE or change == REG_NOT then
		n = change
	elseif n <= REG_INFINITE or n >= -REG_INFINITE or (n <= 0 and (self.is_production or self.is_miner)) then
		n = (self.infbtn.hidden and (-REG_INFINITE-1) or REG_INFINITE)
	elseif n < 0 and not self.allow_negative then
		n = 0
	end
	self.register.num = n
	self:UpdateVisuals()
end

function RegisterSelection:on_value_mouse_wheel(widget, wheel)
	local ctrl, shift = Input.IsControlDown(), Input.IsShiftDown()
	self:change_num((wheel > 0 and 1 or -1) * (ctrl and 10 or 1) * (shift and 5 or 1))
end

function RegisterSelection:minus_one()
	self:change_num(-1)
end

function RegisterSelection:minus_ten()
	self:change_num(-10)
end

function RegisterSelection:plus_one()
	self:change_num(1)
end

function RegisterSelection:plus_ten()
	self:change_num(10)
end

function RegisterSelection:set_inf()
	self:change_num((self.register.num or 0) == REG_INFINITE and 0 or REG_INFINITE)
end

function RegisterSelection:set_not()
	self:change_num((self.register.num or 0) == REG_NOT and 0 or REG_NOT)
end

function RegisterSelection:on_togglenot()
	UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_INCREMENT")
	self.register.num = (self.register.num or 0) == REG_NOT and 0 or REG_NOT
	self:UpdateVisuals()
end

function RegisterSelection:on_ui_accept_inf()
	self.register.num = REG_INFINITE
	self:on_ui_accept()
end

function RegisterSelection:on_ui_accept_not()
	self.register.num = REG_NOT
	self:on_ui_accept()
end

function RegisterSelection:on_ui_accept()
	UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_APPLY")

	local reg, recipe_amount = self.register, self.recipe_amount or 1
	if recipe_amount > 1 and reg.num and reg.num ~= 0 and reg.num >= 0 then
		reg.num = (reg.num + recipe_amount - 1) // recipe_amount * recipe_amount
	end

	local library_id, index = self.library_id, self.index
	if index then
		local bp = self.edited_bp or (library_id and self.library[library_id])
		if bp then
			ProcessLibraryBlueprint(bp, function(pbp) Action.SendForEntity("SetRegister", self.entity, { idx = index, reg = reg, comp = self.component or nil, custom_blueprint = pbp }) end)
		else
			Action.SendForEntity("SetRegister", self.entity, { idx = index, reg = reg, comp = self.component or nil })
		end
	end

	self:SendEvent("on_set", reg, library_id)
	self:SendEvent("on_close")
end

function RegisterSelection:on_clear()
	local reg = self.register
	reg.id, reg.entity, reg.coord, reg.num = nil, nil, nil, nil
	self:on_ui_accept()
end

function RegisterSelection:SetRegister(reg)
	self.register = reg
	self:UpdateVisuals(true, true)
end

function ShowRegisterSelection(popup_next_to, entity_or_callback, component_or_def_filter, index, regsel_args)
	local w = UI.MenuPopup([[
			<Canvas>
				<Box bg=popup_box_bg padding=4 blur=true/>
				<Image dock=left image=popup_pointer id=triangle x=-16 y=5 valign=bottom/>
			</Canvas>]],
		{
			on_popup_shift = function(w, shift_x, shift_y, anchor_w, anchor_h)
				w.triangle.y = w.triangle.y - shift_y - anchor_h // 2
				if shift_x < 0 then -- flip triangle to other side
					w.x = -24
					w.triangle.x = -shift_x - anchor_w - 1
					w.triangle.sx = -1 -- mirror horizontally
				end
			end,

			construct = function(w)
				--w:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
				--w:TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
				UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
			end,

			on_close = function(w)
				w:TweenFromTo("sx", 1, 0.01, 80, "InQuad")
				w:TweenFromTo("sy", 1, 0.01, 40, "InQuad", function() UI.CloseMenuPopup(w) end)
			end,
		},
		popup_next_to, "RIGHT", "BOTTOM", 12, 12)
	local args = regsel_args or {}
	args.entity, args.component, args.index = entity_or_callback, component_or_def_filter, index
	return w and w[1]:Add("<RegisterSelection width=626 max_height=670 entity={entity} component={component} index={index} on_close={on_close}/>", args)
end

function UIMsg.OnTechResearch(id)
	-- update new markers
	local extra = Game.GetLocalPlayerExtra()
	local new_tech = extra.new_tech
	if not new_tech then new_tech = {} extra.new_tech = new_tech end

	for _,v in ipairs(data.techs[id].unlocks or {}) do
		local def = data.components[v] or data.items[v]
		if def and def.tag ~= "resource" then
			new_tech[v] = true
		end
	end

	if OpenRegisterSelection then
		OpenRegisterSelection:Refresh()
	end
end
