local BuildView_layout<const> =
[[
	<VerticalList>
		<TextSearch id=search on_refresh={on_search}/>
		<Box bg=popup_pattern padding=4>
			<ScrollList id=list width=596 max_height=650/>
		</Box>
		<Box bg=popup_additional_bg padding=6>
			<VerticalList child_fill=true child_padding=4 id=tablist width=596/>
		</Box>
	</VerticalList>
]]

local BuildViewCategoryTitle_layout<const> = "<Text color=ui_light height=24/>"

local BuildViewCategoryWrap_layout<const> = "<Wrap child_padding=4 wrapsize=596/>"

local BuildViewItem_layout<const> = "<Reg bg=item_default icon={icon} on_click={building_on_click}/>"
local BuildViewBlueprint_layout<const> =
[[
	<Box bg=blueprint_bg on_click={building_on_click}>
		<Canvas>
			<Preview id=prev visual={visual} quality=200 width=56 height=56 components={components}/>
			<RegNoNum id=bpicon width=36 height=36 bg=black_bg no_interact=true dock=bottom-right/>
		</Canvas>
	</Box>
]]

local BuildView = {}
local buildview_open, buildview_folder
UI.Register("BuildView", BuildView_layout, BuildView)

function BuildView:construct()
	buildview_open = self

	local tablist, folders, currenttab = self.tablist, {}
	tablist:Clear()

	local tabs = tablist:Add("<HorizontalList child_fill=true child_padding=4/>")
	if not BuildView.hide_default then
		currenttab = tabs:Add('<Button on_click={on_switch_tab} clip=true text="Default"/>')
	end

	local faction_library = Game.GetLocalPlayerFaction().extra_data.library
	if not self.library then self.library = faction_library end

	local process = function(id, def, category, bp_frame_def, bp_multi)
		if (not bp_frame_def or not bp_frame_def.construction_recipe) and not bp_multi then return end -- not a building
		folders[(def.folder or ""):match('[^/]*')] = true
	end
	ProcessUnlockedDefinitions(process, data.frames, self.library)

	for k,v in SortedPairs(folders) do
		local folder = k ~= "" and k or nil
		if #tabs >= 5 then
			tabs = self.tablist:Add("<HorizontalList child_fill=true child_padding=4/>")
		end
		local newtab = tabs:Add('<Button on_click={on_switch_tab} clip=true/>', { text = folder and NOLOC(k) or (self.library == faction_library and "Library" or "Favorites"), icon = folder and "icon_small_folder", library = true, folder = folder })
		if (folder or true) == buildview_folder then currenttab = newtab end
	end

	UILibraryLoadButton(tabs, self.library, false, 'B')

	if not currenttab then return end
	self:on_switch_tab(currenttab)
end

function BuildView:on_library_loaded(btn, bp)
	buildview_folder = bp.folder
	self:finish(bp, bp.id, bp.frame)
end

function BuildView:destruct()
	buildview_open = nil
end

function BuildView:on_switch_tab(tabbtn)
	for _,tabs in ipairs(self.tablist) do
		for _,v in ipairs(tabs) do
			v.active, v.disabled = (v == tabbtn), (v == tabbtn)
		end
	end
	buildview_folder = tabbtn.library and (tabbtn.folder or true) or nil
	self.active_tabbtn = tabbtn
	self:RefreshList()
end

function BuildView:RefreshList()
	local tabbtn, list, wrap = self.active_tabbtn, self.list
	local is_library, folder = tabbtn.library, (tabbtn.folder or "")
	local filter = self.search.inp.text
	if filter == "" then filter = nil end
	local ContainsStringNoCase = filter and Tool.ContainsStringNoCase

	-- TODO: Maybe show locked blueprints as well? gray them out with a tooltip?
	list:Clear()
	local category_w = {}
	local function add_definition(id, def, category, bp_frame_def, bp_multi)
		if not is_library == (type(id) == "number" and id > 0) then return end -- wrong tab
		local def_folder = is_library and (def.folder or "")
		if def_folder and def_folder:match('[^/]*') ~= folder then return end -- wrong tab

		local frame_def = not bp_multi and (bp_frame_def or def)
		if frame_def then
			if not frame_def.construction_recipe then return end -- not a building
			if not bp_frame_def and not def.visual then return end -- no default visual
		end

		if filter and not ContainsStringNoCase(((bp_frame_def or bp_multi) and def.name or (frame_def and L(frame_def.name or "")) or ""), filter) then return end

		if def_folder and def_folder:find('/') then
			category = { name = NOLOC(def_folder:match('/(.*)')) }
		end

		local category_name = category.name
		if not category_w[category_name] then
			list:Add(BuildViewCategoryTitle_layout, { text = category_name })
			wrap = list:Add(BuildViewCategoryWrap_layout)
			category_w[category_name] = wrap
		else
			wrap = category_w[category_name]
		end

		if bp_multi then
			wrap:Add(UI.New(BuildViewItem_layout, {
				icon = def.icon and data.all[def.icon] and data.all[def.icon].texture or 'icon_blueprint',
				tooltip = DefinitionTooltip(def),
				library_id = id,
				id_or_custom = def,
				sort_key = string.format("|%017.8f", (def.order and (def.order * 2 + 1) or (id * 2))),
			}))
		elseif bp_frame_def then
			local can_use_preview = bp_frame_def.type ~= "Wall" and bp_frame_def.type ~= "Foundation" and bp_frame_def.type ~= "Gate"
			wrap:Add(UI.New(can_use_preview and BuildViewBlueprint_layout or BuildViewItem_layout, {
				icon = bp_frame_def.texture,
				visual = frame_def.visual,
				components = def.components,
				tooltip = DefinitionTooltip(def),
				construct = function(w)
					if w.bpicon then
						w.bpicon.def_id = def.icon
						w.bpicon.hidden = def.icon == nil
					end
				end,
				library_id = id,
				id_or_custom = def,
				sort_key = string.format("|%017.8f", (def.order and (def.order * 2 + 1) or (id * 2))),
			}))
		else
			wrap:Add(UI.New(BuildViewItem_layout, {
				icon = def.texture or frame_def.texture,
				tooltip = DefinitionTooltip(def),
				frame_id = id,
				id_or_custom = id,
				sort_key = string.format("%05d%s", def.index or 99999, id),
				no_customize = def.type ~= nil or nil,
			}))
		end
	end
	ProcessUnlockedDefinitions(add_definition, data.frames, is_library and self.library, not is_library and not self.on_select)

	for _,wrap in ipairs(list) do
		if wrap[1] and wrap[1].sort_key then
			wrap:SortChildren(function(a,b) return a.sort_key < b.sort_key end)
		end
	end
end

function BuildView:on_search()
	self:RefreshList()
end

function BuildView:finish(id_or_custom, library_id, frame_id, show_bp_edit, w)
	if self.on_select then
		self:SendEvent("on_select", library_id, frame_id)
	elseif library_id == -1 then
		UILibraryImportBlueprint(id_or_custom, function(mapped_bp) if self:IsValid() then self:finish(mapped_bp, nil, nil, show_bp_edit, w) end end, w)
	elseif type(id_or_custom) ~= "string" and id_or_custom.params then
		UILibraryAssignBlueprintParams(id_or_custom, function(bpp) if self:IsValid() then self:finish(bpp, nil, nil, show_bp_edit, w) end end, w)
	elseif show_bp_edit then
		local pop = UI.MenuPopup("<Box bg=popup_box_bg padding=4 blur=true/>", w)
		if pop then pop:Add("BlueprintEditor", { source_bp = id_or_custom, library = self.library or {}, on_ok = function(pp, bp) if self:IsValid() then self:finish(bp, nil, nil, nil, w) end end, want_similar = true }) end
	else
		StartBuildCursor(id_or_custom)
	end
end

function BuildView:building_on_click(w, mbtn)
	local customize_bp = (mbtn == 'RIGHTMOUSEBUTTON' and ((w.library_id and w.id_or_custom) or (not w.no_customize and { frame = w.frame_id })))
	if mbtn == 'RIGHTMOUSEBUTTON' and not customize_bp then return end
	self:finish(customize_bp or w.id_or_custom, w.library_id, w.frame_id, customize_bp, w)
end

local context_keys_building = { "Construction Site Placement",
	'<Key action="SelectAction"/>',                               "Place construction",
	'Ctrl+<Key action="SelectAction"/>',                          "Customize construction or upgrade",
	'Shift+<Key action="SelectAction"/>',                         "Place multiple constructions",
	'Ctrl+Shift+<Key action="SelectAction"/>',                    "Upgrade multiple buildings",
	'<Key action="SelectAction"/>+Drag',                          "Place a block of construction sites",
	'<Key action="RotateConstructionSite"/>',                     "Rotate construction site",
	'<Key action="ExecuteAction"/> / <Key action="InGameMenu"/>', "Cancel placement",
}
local context_keys_multibp = { "Layout Placement",
	'<Key action="SelectAction"/>',                               "Place construction",
	'Ctrl+<Key action="SelectAction"/>',                          "Customize construction or upgrade",
	'Shift+<Key action="SelectAction"/>',                         "Place multiple constructions",
	'Ctrl+Shift+<Key action="SelectAction"/>',                    "Upgrade multiple buildings",
	'<Key action="SelectAction"/>+Drag',                          "Place a block of construction sites",
	'<Key action="RotateConstructionSite"/>',                     "Rotate layout",
	'Ctrl+<Key action="RotateConstructionSite"/>',                "Mirror layout horizontally",
	'Ctrl+Shift+<Key action="RotateConstructionSite"/>',          "Flip layout vertically",
	'<Key action="ExecuteAction"/> / <Key action="InGameMenu"/>', "Cancel placement",
}
local context_keys_botupgrade = { "Unit Upgrade",
	'<Key action="SelectAction"/>',                               "Upgrade unit",
	'Ctrl+<Key action="SelectAction"/>',                          "Skip upgrade confirmation",
	'Ctrl+Shift+<Key action="SelectAction"/>',                    "Upgrade multiple units",
	'<Key action="ExecuteAction"/> / <Key action="InGameMenu"/>', "Cancel upgrade",
}
local context_keys_relocate_one = { "Relocate",
	'<Key action="SelectAction"/>',                               "Confirm",
	'<Key action="RotateConstructionSite"/>',                     "Rotate construction site",
	'<Key action="ExecuteAction"/> / <Key action="InGameMenu"/>', "Cancel placement",
}
local context_keys_relocate_many = { "Relocate",
	'<Key action="SelectAction"/>',                               "Confirm",
	'<Key action="RotateConstructionSite"/>',                     "Rotate layout",
	'Ctrl+<Key action="RotateConstructionSite"/>',                "Mirror layout horizontally",
	'Ctrl+Shift+<Key action="RotateConstructionSite"/>',          "Flip layout vertically",
	'<Key action="ExecuteAction"/> / <Key action="InGameMenu"/>', "Cancel placement",
}

local construction_custom_blueprint, construction_frame_id, construction_multi
local construction_transform_func, construction_is_bot_upgrade, construction_area
local function OnCancelConstruction()
	Quickview_HideGrid()
	ShowContextKeyPanel(nil) -- close
	construction_transform_func = nil
end

local function OnCheckConstruction(x, y, rotation, is_visible, can_place, is_powered, size_x, size_y, frame_id, visual_id)
	if construction_is_bot_upgrade then
		local e = Map.GetEntityAt(x, y)
		local d = e and GetBuiltFrameDef(e)
		return d and d.type == nil and (d.movement_speed or 0) > 0 and e.faction == Game.GetLocalPlayerFaction() or false
	elseif not can_place and (is_visible or is_powered) and Input.IsControlDown() then
		-- recheck CanPlace with building upgrading
		local upgrade_can_place, upgrades = Game.GetLocalPlayerFaction():CanPlace(frame_id, x, y, rotation, visual_id, true, true, true)
		if not upgrade_can_place then return false end
		if upgrades then for _,e in ipairs(upgrades) do if e.is_damaged then return false end end end
		can_place = true
	end
	if not can_place or (not is_visible and not is_powered) then return false end
	construction_area = { x, y, size_x, size_y }
	local blight = Map.GetBlightnessDelta(x, y, size_x, size_y, -1)
	if blight >= 0 and not Game.GetLocalPlayerFaction().has_blight_shield then return false end
	return construction_is_bot_upgrade or blight >= 0 or data.all[frame_id].size ~= "Alien"
end

local function OnConfirmConstruction(loc, rotation, is_valid, unplacable_count, do_solo_edit)
	local ctrl_upgrade, multi_build, solo_edit_entity = not do_solo_edit and Input.IsControlDown(), not do_solo_edit and Input.IsShiftDown()
	if construction_is_bot_upgrade then
		-- loc is just a single element (not an array) on bot upgrade (due to no dragging multiple construction sites)
		local e = is_valid and Map.GetEntityAt(loc.x, loc.y)
		if not e then return Notification.Warning("Must select unit or building to upgrade") end
		local err = CheckDeconstruct(e, construction_frame_id)
		if err then return Notification.Warning(L("%s: %s", "Unit upgrade unavailable", err)) end
		solo_edit_entity = e
	elseif not construction_multi and #loc == 1 and (not is_valid or do_solo_edit or ctrl_upgrade) then
		local can_upgrade, upgrades = Game.GetLocalPlayerFaction():CanPlace(construction_frame_id, loc[1].x, loc[1].y, rotation, true, true, true)
		solo_edit_entity = (#loc == 1 and upgrades and #upgrades == 1 and upgrades[1])
		if not can_upgrade or (not is_valid and not solo_edit_entity) then return Notification.Warning("Cannot build here") end
		if upgrades then
			for _,e in ipairs(upgrades) do
				local err = CheckDeconstruct(e, construction_frame_id)
				if err then return Notification.Warning(L("%s: %s", "Unit upgrade unavailable", err)) end
			end
		end
		local solo_area = solo_edit_entity and solo_edit_entity.area
		local new_fits = solo_area and (construction_area[3]*construction_area[4]) <= (solo_area[3]*solo_area[4])
		if do_solo_edit and new_fits then loc, rotation = nil, nil end -- upgrade solo entity in place
		if ctrl_upgrade and solo_edit_entity and Tool.Hash(construction_area) ~= Tool.Hash(solo_area) then solo_edit_entity = nil end -- place upgrade construction site at chosen location
	elseif not is_valid then
		return Notification.Warning("Cannot build here")
	end

	if do_solo_edit or ctrl_upgrade then
		StartCustomConstruction(solo_edit_entity, construction_custom_blueprint or { frame = construction_frame_id }, (loc and #loc > 0 and loc or nil), rotation, multi_build)
	elseif solo_edit_entity then
		View.StopCursor() -- prevent UI calling OnCancelConstruction
		ConfirmBox("Do you want to upgrade this unit or building?\n\nHold down the Ctrl key to skip this confirmation.",
			function()
				OnConfirmConstruction(loc, rotation, true, 0, true)
			end,
			function()
				View.StartCursorConstruction(construction_frame_id or construction_custom_blueprint.multi, nil, OnConfirmConstruction, OnCancelConstruction, OnCheckConstruction, not construction_is_bot_upgrade)
			end
		)
		return
	elseif construction_is_bot_upgrade then
		error("bot upgrade should be handled above")
	elseif construction_custom_blueprint then
		ProcessLibraryBlueprint(construction_custom_blueprint, function(pbp)
			Action.SendForLocalFaction("PlaceConstruction", { locations = loc, rotation = rotation, custom_blueprint = pbp })
		end)
	elseif data.frames[construction_frame_id] then
		Action.SendForLocalFaction("PlaceConstruction", { locations = loc, rotation = rotation, id = construction_frame_id })
	else
		error("Invalid construction")
	end

	UI.PlaySound("fx_ui_BUILD_COMPLETE")

	if not multi_build then
		View.StopCursor()
		OnCancelConstruction()
	end
end

local function OnTransformMultiConstruction(rotate, flipx, flipy)
	construction_custom_blueprint = Tool.Copy(construction_custom_blueprint)
	construction_multi = construction_custom_blueprint.multi
	BlueprintTransform(construction_multi, rotate, flipx, flipy)
	View.StopCursor() -- prevent next line calling OnCancelConstruction
	View.StartCursorConstruction(construction_multi, nil, OnConfirmConstruction, OnCancelConstruction, OnCheckConstruction, true)
end

function StartBuildCursor(id_or_custom, force_rotation)
	View.StopCursor(true) -- call OnCancelConstruction before setting these variables
	local id = type(id_or_custom) == "string" and id_or_custom
	construction_custom_blueprint = not id and id_or_custom
	construction_frame_id = construction_custom_blueprint and construction_custom_blueprint.frame or id
	construction_multi = not construction_frame_id and construction_custom_blueprint.multi
	construction_transform_func = construction_multi and OnTransformMultiConstruction
	if not construction_frame_id and not construction_multi then error("invalid custom blueprint for build cursor") end
	if construction_custom_blueprint then
		if construction_custom_blueprint.params then error("custom blueprint for build cursor needs applied parameters") end
		if construction_custom_blueprint.dependencies then error("custom blueprint for build cursor needs to have dependencies imported") end
		if not BlueprintIsCustomized(construction_custom_blueprint) then construction_custom_blueprint = nil end
	end

	local frame_def = construction_frame_id and data.frames[construction_frame_id]
	construction_is_bot_upgrade = frame_def and (frame_def.movement_speed or 0) > 0

	View.StartCursorConstruction(construction_frame_id or construction_multi, not construction_multi and force_rotation or nil, OnConfirmConstruction, OnCancelConstruction, OnCheckConstruction, not construction_is_bot_upgrade)
	UI.CloseMenuPopup()
	Quickview_ShowGrid()
	ShowContextKeyPanel((construction_is_bot_upgrade and context_keys_botupgrade) or (construction_multi and context_keys_multibp) or context_keys_building)

	--[[DEBUG VIEW
	UI.AddLayout("<Box width=300 dock=left><ScrollList max_height=800><Text text={txt}/></ScrollList></Box>", { every_frame_update = function(wb) if not View.InConstructionMode() then wb:RemoveFromParent() return end wb.txt = tostring(construction_custom_blueprint or construction_frame_id) end, on_mouse_button_down = function(wb) print(wb.txt) end })
	--]]
end

function StartRelocateCursor(entity_or_entities)
	local single_entity, faction = (type(entity_or_entities) ~= "table" and entity_or_entities), Game.GetLocalPlayerFaction()
	if not single_entity and #entity_or_entities == 0 then return end

	-- Filter invalid entities and abort if none left
	for i=(single_entity and 1 or #entity_or_entities),1,-1 do
		local e = single_entity or entity_or_entities[i]
		if e.faction ~= faction or not e.is_placed or e.is_construction or (e.def.movement_speed or 0) ~= 0 or CheckDeconstruct(e, nil, true) then
			if single_entity or #entity_or_entities == 1 then return end
			entity_or_entities[i] = entity_or_entities[#entity_or_entities]
			entity_or_entities[#entity_or_entities] = nil
		end
	end
	if not single_entity and #entity_or_entities == 1 then single_entity, entity_or_entities = entity_or_entities[1], entity_or_entities[1] end

	local first_entity, multi_rot, multi_flipx, multi_flipy = single_entity or entity_or_entities[1]
	local bp = MakeBlueprintFromEntity(entity_or_entities, false, true)
	if not bp then error("failed to create blueprint from building") end

	local have_shuttles = faction:IsUnlocked("t_shuttles")

	local function onConfirm(location, rotation, is_valid, unplacable)
		View.StopCursor(true) -- call onAbort
		if not is_valid then return end
		local args = { entity = single_entity, entities = not single_entity and entity_or_entities or nil, location = location, rotation = rotation + (multi_rot or 0), flipx = multi_flipx, flipy = multi_flipy }
		if unplacable > 0 then
			ConfirmBox(L("Are you sure you want to relocate %d out of %d units/buildings?", #entity_or_entities - unplacable, #entity_or_entities), function() Action.SendForLocalFaction("Relocate", args) end)
		else
			Action.SendForLocalFaction("Relocate", args)
		end
	end
	local function onAbort()
		Quickview_HideGrid()
		ShowContextKeyPanel(nil) -- close
		construction_transform_func = nil
	end
	local function onCheck(x, y, rotation, is_visible, can_place, is_powered, size_x, size_y, frame_id, visual_id)
		if is_visible and not can_place then
			local upgrade_can_place, upgrades = Game.GetLocalPlayerFaction():CanPlace(frame_id, x, y, rotation, visual_id, true, true, true)
			if not upgrade_can_place or not upgrades then return false end
			if single_entity then
				if #upgrades ~= 1 or upgrades[1] ~= single_entity then return false end
			else
				for _,u in ipairs(upgrades) do local ok for _,e in ipairs(entity_or_entities) do if u == e then ok = true break end end if not ok then return false end end
			end
		end
		local res = is_visible
		local old_grid_index = res and faction:GetPowerGridIndexAt(first_entity)
		res = res and (not old_grid_index or old_grid_index == faction:GetPowerGridIndexAt(x, y, size_x, size_y) or have_shuttles)
		res = res and not LocationBlockedByBlight({x, y, size_x, size_y})
		return res
	end
	construction_transform_func = not single_entity and function(rotate, flipx, flipy)
		BlueprintTransform(bp.multi, rotate, flipx, flipy)
		View.StopCursor() -- prevent UI calling OnCancelConstruction
		View.StartCursorConstruction(bp.multi, 0, onConfirm, onAbort, onCheck)
		if rotate and rotate ~= 0 then
			multi_rot = (((multi_rot or 0) + rotate) % 4)
			if (rotate & 1) == 1 then multi_flipx, multi_flipy = multi_flipy, multi_flipx end
		end
		if flipx or flipy then
			multi_flipx, multi_flipy = (((multi_flipx and 1 or 0) + (flipx and 1 or 0)) == 1 or nil), (((multi_flipy and 1 or 0) + (flipy and 1 or 0)) == 1 or nil)
			if multi_flipx and multi_flipy then multi_rot, multi_flipx, multi_flipy = (((multi_rot or 0) + 2) % 4), nil, nil end
		end
		if multi_rot == 0 then multi_rot = nil end
	end

	if single_entity then
		View.StartCursorConstruction(bp.frame, bp.visual or bp.frame, single_entity.rotation, onConfirm, onAbort, onCheck)
	else
		View.StartCursorConstruction(bp.multi, 0, onConfirm, onAbort, onCheck)
	end
	Quickview_ShowGrid()
	ShowContextKeyPanel(single_entity and context_keys_relocate_one or context_keys_relocate_many)

	--[[DEBUG VIEW
	UI.AddLayout("<Box width=300 dock=left><ScrollList max_height=800><Text text={txt}/></ScrollList></Box>", { every_frame_update = function(wb) if not View.InConstructionMode() then wb:RemoveFromParent() return end wb.txt = tostring(bp) end, on_mouse_button_down = function(wb) print(wb.txt) end })
	--]]
end

function TransformConstructionCursor()
	if not construction_transform_func then
		View.RotateConstructionSite(not Input.IsShiftDown())
	else
		local flip, invert = Input.IsControlDown(), Input.IsShiftDown()
		construction_transform_func(not flip and (invert and 3 or 1), flip and not invert, flip and invert)
	end
end

function UIMsg.OnTechResearch(id)
	if buildview_open then
		buildview_open:RefreshList()
	end
end
