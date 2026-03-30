local Library_layout<const> = [[
	<HorizontalList>
		<Box bg=popup_pattern id=editorbox width=820 hidden=true/>
		<VerticalList child_padding=4>
			<Box bg=popup_additional_bg padding=6>
				<VerticalList child_padding=6>
					<HorizontalList height=33 child_align=center>
						<Button id=viewmode on_click={on_viewmode} tooltip="Switch Icon/List View" margin_right=16/>
						<Text text="Filter:" margin_right=8/>
						<Button id=filterblueprint on_click={on_filter} tooltip="Show Blueprints" icon=icon_small_blueprint active=true margin_right=4/>
						<Button id=filterbehavior on_click={on_filter}  tooltip="Show Behaviors" icon=icon_small_behavior active=true margin_right=16/>
						<TextSearch id=search on_refresh={on_search} fill=true/>
					</HorizontalList>
					<HorizontalList height=33 child_align=center child_fill=true child_padding=6>
						<Button id=createitem text="Create Item" icon=icon_new height=32 on_click={item_new}/>
						<Button id=createfolder text="Create Folder" icon=icon_folder height=32 on_click={folder_new} on_drop={folder_drop} on_drag_enter={folder_drag_enter} on_drag_leave={folder_drag_leave}/>
						<Button id=createpaste text="Paste Item" icon=icon_paste height=32 on_click={paste_new} tooltip={paste_tooltip}/>
					</HorizontalList>
				</VerticalList>
			</Box>
			<Box bg=popup_pattern padding=4 on_drop={list_drop} margin_bottom=5>
				<ScrollList id=list height=800 width=580/>
			</Box>
			<Box bg=popup_additional_bg padding=6>
				<HorizontalList id=tabbuttons child_fill=true child_padding=6>
					<Button icon=icon_remote   height=32 text="Library"   on_click={switch_tab} remote=true/>
					<Button icon=icon_achieved height=32 text="Favorites" on_click={switch_tab} remote=false/>
				</HorizontalList>
			</Box>
		</VerticalList>
	</HorizontalList>
]]

local Folder_layout<const> = [[
	<HorizontalList on_drop={folder_drop} on_drag_enter={folder_drag_enter} on_drag_leave={folder_drag_leave} on_drag_start={folder_drag_start} on_click={folder_box_on_click} child_padding=4 margin_bottom=2>
		<Image image=order_thumb width=20 height=36 valign=center color=ui_light opacity=0.5/>
		<Button id=folderbtn icon=icon_folder on_click={folder_gointo} fill=true textalign=left height=36 text={text}/>
		<Button id=btnmenu icon=icon_menu on_click={folder_menu_on_click} width=36 height=36 tooltip="Options"/>
	</HorizontalList>
]]

local Icon_Folder_layout<const> = [[
	<Canvas render={on_icon_folder_render} on_drop={folder_drop} on_drag_enter={folder_drag_enter} on_drag_leave={folder_drag_leave} on_drag_start={folder_drag_start} on_click={folder_box_on_click} width=80 height=90 clip=true>
		<Box bg=popup_box_bg dock=top blocking=false><Image image=icon_folder color=ui_light dock=top width=72 height=72/></Box>
		<Text text={text} dock=bottom max_width=80 textalign=left size=10 tooltip={text}/>
	</Canvas>
]]

local Selection_Folder_layout<const> = [[
	<Button icon=icon_folder on_click={folder_gointo} fill=true textalign=left height=36 text={text}/>
]]

local DirHead_layout<const> = [[
	<HorizontalList child_padding=4 height=36 margin_bottom=2 isdirhead=true>
		<Button text={txt} on_click={folder_goup} tooltip="Go Up" on_drop={folder_drop} on_drag_enter={folder_drag_enter} on_drag_leave={folder_drag_leave}/>
		<InputText text={sub} on_commit={folder_renamed} tooltip="Rename" fill=true/>
	</HorizontalList>
]]

local Selection_DirHead_layout<const> = [[
	<HorizontalList child_padding=4 height=36 margin_bottom=2>
		<Button text={txt} on_click={folder_goup} tooltip="Go Up"/>
		<Text text={sub} fill=true valign=center/>
	</HorizontalList>
]]

local Item_layout<const> = [[
	<Box padding=6 on_drag_start={list_drag_start} on_drag_over={item_drag_over} on_click={item_box_on_click}>
		<HorizontalList child_padding=3>
			<Image image=order_thumb width=20 height=36 valign=center color=ui_light opacity=0.5/>
			<Box bg=reg_base_ro><Image id=icon width=36 height=36 on_click={item_on_click} tooltip={item_tooltip}/></Box>
			<Button id=namebtn text={name} active={nameactive} textalign=left style=default_style on_click={item_on_click} height=36 tooltip="Edit" fill=true/>
			<Button id=btnmenu icon=icon_menu on_click={item_menu_on_click} width=36 height=36 tooltip="Options"/>
		</HorizontalList>
	</Box>
]]

local Icon_Item_layout<const> = [[
	<Canvas on_drag_start={list_drag_start} on_drag_over={item_drag_over} on_click={item_box_on_click} width=80 height=90 clip=true>
		<Box bg={boxbg} dock=top blocking=false><Image id=icon width=72 height=72 tooltip={item_tooltip}/></Box>
		<Text text={name} dock=bottom max_width=80 textalign=left size=10 tooltip={name}/>
	</Canvas>
]]

local Selection_Item_layout<const> = [[
	<HorizontalList child_padding=3>
		<Box bg=reg_base_ro><Image id=icon width=36 height=36 on_click={click} tooltip={icon_tooltip}/></Box>
		<Button text={name} active={nameactive} textalign=left style=default_style on_click={click} height=36 fill=true/>
	</HorizontalList>
]]

local function LibraryGetItemName(item, type)
	if item.name then return item.name end
	if not type then type = item.type end
	if type == 'B' then return NOLOC(L(item.multi and "New Multi Blueprint" or "New Blueprint")) end
	if type == 'C' then return NOLOC(L("New Behavior")) end
	error('Unknown library item '..tostring(item))
end

local function LibraryGetTypeName(item)
	if item.type == 'B' then return "Blueprint" end
	if item.type == 'C' then return "Behavior" end
	error('Unknown library type '..tostring(item.type))
end

local function LibraryGetLibraryName(remote)
	return remote and "Library" or "Favorites"
end

local function LibraryNewId(remote)
	local tbl = (remote and Map.GetSave() or Game.GetProfile())
	local id_count = (tbl.library_id_count or 0) + 1
	tbl.library_id_count = id_count
	return id_count
end

local function LibraryMoveItem(library, item, folder, above_order, below_order)
	if not above_order or not below_order then
		local max, max_order = math.max, 0
		for _,v in pairs(library) do if v.folder == folder then max_order = max(max_order, v.order or v.id or 0) end end
		if not above_order then above_order = max_order end
		if not below_order then below_order = max(max_order + 1, item.id or 0) end
	end
	item.order, item.folder = ((item.id < above_order or item.id > below_order) and ((above_order + below_order) / 2.0) or nil), folder
end

local function LibraryClearEntityReferences(item)
	local regs = item.regs
	if not regs then
		local multi = item.multi
		if multi then
			for _,bp in ipairs(multi) do
				LibraryClearEntityReferences(bp)
			end
		end
		return
	end
	for k,reg in pairs(regs) do
		if type(reg) == "table" then
			local reg_queue = reg.queue
			for q=(reg_queue and #reg_queue or 0),0,-1 do
				local r = (q == 0 and reg or reg_queue[q])
				if r.entity and type(r.entity) == "userdata" then -- keep numerical references to entities in a multi-blueprint
					r.entity = nil
					r.num = r.num ~= 0 and r.num or nil
					if not next(r) then
						if q > 0 then table.remove(reg_queue, q) if not next(reg_queue) then reg.queue = nil end end
						if not next(reg) then regs[k] = nil if not next(regs) then item.regs = nil return end end
					end
				end
			end
		end
	end
end

local function LibraryModifyItemExecute(library, arg, remote)
	local mode = arg.mode
	if mode == 'create' then
		local item, item_id = (remote and arg.item) or Tool.Copy(arg.item) or {}, LibraryNewId(remote)
		item.id, item.rev, item.type, item.folder = item_id, 1, arg.type or item.type, arg.folder or item.folder
		library[item_id] = item
		if not remote and item.type == 'B' then LibraryClearEntityReferences(item) end
		return item_id
	elseif mode == 'name' then
		library[arg.id].name = arg.name
	elseif mode == 'delete' then
		local item = library[arg.id]
		if remote and item.type == 'C' then ClearFactionBehaviorCache(item.id, item.rev) end
		library[item.id] = nil
	elseif mode == 'data' then
		local arg_item, old_item = remote and arg.item or Tool.Copy(arg.item), library[arg.item.id]
		if remote and old_item.type == 'C' then
			ClearFactionBehaviorCache(old_item.id, old_item.rev)
		end
		arg_item.rev = old_item.rev + 1
		library[arg_item.id] = arg_item
		if not remote and arg_item.type == 'B' then LibraryClearEntityReferences(arg_item) end
	elseif mode == 'move' then
		LibraryMoveItem(library, library[arg.id], arg.folder, arg.above, arg.below)
	elseif mode == 'duplicate' then
		local item, item_id = Tool.Copy(library[arg.id]), LibraryNewId(remote)
		library[item_id], item.id, item.rev, item.order = item, item_id, 1, (item.order or item.id) + 0.1
	elseif mode == 'import' then
		local arr, mapping, folder = arg.arr, arg.mapping, arg.folder
		if not remote then arr = Tool.Copy(arr) arg.arr = arr end -- avoid modifying references (but return changes via arg for CallLibraryImport)
		for _,aitem in ipairs(arr) do
			local aitem_id = aitem.id
			local mapped_id = mapping[aitem_id]
			if mapped_id then
				local old_item = library[mapped_id]
				if remote and old_item.type == 'C' then
					ClearFactionBehaviorCache(old_item.id, old_item.rev)
				end
				aitem.id, aitem.rev = mapped_id, old_item.rev + 1
			else
				mapped_id = LibraryNewId(remote)
				mapping[aitem_id] = mapped_id
				aitem.id, aitem.rev = mapped_id, 1
				if folder then aitem.folder = folder end
			end
			library[mapped_id] = aitem
			if not remote and aitem.type == 'B' then LibraryClearEntityReferences(aitem) end
			if remote then -- validate potentially tampered data coming from local library
				if aitem.type == 'B' then ProcessLibraryBlueprint(aitem, function (bp) ValidateCustomBlueprint(bp) end) end
				if aitem.type == 'C' then ProcessLibraryBlueprint(aitem, function (bp) ValidateCustomBehavior(bp) end) end
			end
		end
		for _,aitem in ipairs(arr) do LibraryApplyMapping(aitem, mapping) end -- apply final mapping
		return arr[1].id
	elseif mode == 'folder_name' then
		local old_folder, new_folder = arg.old, arg.new
		local match, match_len = old_folder .. '/', #old_folder + 1
		for _,fitem in pairs(library) do
			local fitemfolder = fitem.folder
			if fitemfolder == old_folder then
				fitem.folder = new_folder
			elseif fitemfolder and fitemfolder:find(match, 1, true) == 1 then
				fitem.folder = new_folder .. fitemfolder:sub(match_len)
			end
		end
		return nil, old_folder, new_folder
	elseif mode == 'folder_delete' then
		local folder, type = arg.folder, arg.type
		local match, parent = folder .. '/', folder:match('(.*)/')
		for _,item in pairs(library) do
			local item_folder = item.folder
			if item_folder and (item_folder == folder or item_folder:find(match, 1, true) == 1) and (not type or item.type == type) then
				if remote and item.type == 'C' then ClearFactionBehaviorCache(item.id, item.rev) end
				library[item.id] = nil
			end
		end
		return nil, folder, parent
	end
end

local action_library, action_callback
function FactionAction.FactionLibrary(faction, arg)
	local library = faction.extra_data.library
	if not library then library = {} faction.extra_data.library = library end
	local new_item_id, old_folder, new_folder = LibraryModifyItemExecute(library, arg, true)
	faction:RunUI(function() if action_library then action_library:refresh_list(new_item_id, old_folder, new_folder) end end)
	Action.RunUI(function() if action_callback then action_callback(arg) action_callback = nil end end)
end

local function CallLibraryImport(arr, mapping, folder, target_remote, on_done)
	local arg = { mode = 'import', arr = arr, mapping = mapping, folder = folder }
	if target_remote then
		action_callback = on_done
		Action.SendForLocalFaction("FactionLibrary", arg)
	else
		LibraryModifyItemExecute(Game.GetProfile().library, arg)
		on_done(arg)
	end
end

local function UILibraryPrepareImport(src_library, trg_library, item_or_folder, exists_cb, confirm_cb, only_dependencies, popup_next_to, folder_limit_type)
	-- Hash the incoming item and its dependencies (and get the list of dependencies)
	local item, src_dep_hashes, item_hash = (type(item_or_folder) ~= "string" and item_or_folder), {}
	if item then
		if only_dependencies then src_dep_hashes.out_recursion = {} end
		item_hash = LibraryHashItem(src_library, item, src_dep_hashes)
		if only_dependencies then
			only_dependencies = not src_dep_hashes.out_recursion[item.id]
			src_dep_hashes.out_recursion = nil
			if only_dependencies and not next(src_dep_hashes) then exists_cb() return end -- no dependencies, leave early
		end
	end

	-- Hash the entire target library
	local name_trgs, imports, mapping = {B={},C={}}, {}, {}
	local hash_trgs = LibraryGetAllHashes(trg_library, name_trgs)

	-- Match up incoming item and its dependencies with the target library
	local folder = not item and item_or_folder
	if only_dependencies then
		imports[1] = false
	elseif item then
		imports[1] = { item, (hash_trgs[item_hash] or false), (name_trgs[item.type][item.name] or false) }
	else -- folder
		imports[1] = false
		local match = folder .. '/'
		for i,v in pairs(src_library) do
			local vfolder = v.folder
			if vfolder and (vfolder == folder or vfolder:find(match, 1, true) == 1) and (not folder_limit_type or v.type == folder_limit_type) then
				src_dep_hashes[v.id] = LibraryHashItem(src_library, v, src_dep_hashes)
			end
		end
	end

	for src_dep_id, src_dep_hash in pairs(src_dep_hashes) do
		if src_dep_hash ~= false then -- existing item
			local dep_item = src_library[src_dep_id]
			imports[#imports + 1] = { dep_item, (hash_trgs[src_dep_hash] or false), (name_trgs[dep_item.type][dep_item.name] or false) }
		else -- deleted item
			mapping[src_dep_id] = 0
		end
	end

	-- Check if their same content already exists in target library
	if not imports[1] or imports[1][2] then
		local refsmatch = true
		for i=2,#imports do if not imports[i][2] then refsmatch = false break end end
		if refsmatch then
			for i=2,#imports do mapping[imports[i][1].id], imports[i] = imports[i][2], false end
			return exists_cb(imports[1] and trg_library[imports[1][2]], mapping)
		end
	end

	local function CheckNextImport(i)
		local import_ref, props = imports[i]
		if not import_ref then
			local arr = {}
			for k,v in ipairs(imports) do
				if v then
					arr[#arr+1] = v[1]
				end
			end
			if #arr == 0 then -- can happen on folder import if nothing is to be overwritten/added
				return exists_cb(imports[1] and trg_library[imports[1][2]], mapping)
			end
			local confirm_overwrite = not folder and not only_dependencies and imports[1][3]
			local is_remote = trg_library ~= Game.GetProfile().library
			local destination_name = LibraryGetLibraryName(is_remote)
			props = confirm_cb({
				body =
					(folder and L("Are you sure you want to add %s '%S' to %s?", "Folder", folder, destination_name))
					or (only_dependencies and L("Are you sure you want to add related items to %s?", destination_name))
					or L(confirm_overwrite
						and "%s '%S' already exists in %s but with different content, do you want to:"
						or "Are you sure you want to add %s '%S' to %s?", LibraryGetTypeName(item), LibraryGetItemName(item), destination_name),
				construct = function(cd)
					cd.list[2].width = 800
					if confirm_overwrite then
						cd.list:Add("<Button on_click={accept} text='Create a new entry with the same name'/>")
						if arr[1].type == 'C' and is_remote then
							cd.list:Add("<Button on_click={overwrite} text='Overwrite existing entry (running behaviors will be affected)'/>")
						else
							cd.list:Add("<Button on_click={overwrite} text='Overwrite the existing entry'/>")
						end
					end
					local mains = not folder and not only_dependencies and 1 or 0
					if #arr > mains then
						cd.list:Add("<Text margin_top=10 wrap=true textalign=center/>").text = mains == 1
							and L("Additionally %d related items will also be added:", (#arr - 1))
							or L("%d items will be added:", #arr)
						local addlist = cd.list:Add("<ScrollList child_padding=4 max_height=600 halign=center/>")
						for j=mains+1,#arr do
							addlist:Add("Text").text = L("- %s: %S", LibraryGetTypeName(arr[j]), LibraryGetItemName(arr[j]))
						end
					end
				end,
				ok = not confirm_overwrite and function(cd) cd:accept() end,
				accept = function(cd) local oa = cd.on_accept cd:cancel() oa() end,
				overwrite = function(cd) mapping[imports[1][1].id] = imports[1][3] cd:accept() end,
			}, arr, mapping, confirm_overwrite)
		elseif import_ref[2] then -- use reference with same content already existing in target library
			mapping[import_ref[1].id], imports[i] = import_ref[2], false
			return CheckNextImport(i + 1)
		elseif import_ref[3] then -- reference with the same name but different content exists
			local is_remote = trg_library ~= Game.GetProfile().library
			props = confirm_cb({
				body = L("%s '%S' dependency already exists in %s but with different content, do you want to:", LibraryGetTypeName(import_ref[1]), LibraryGetItemName(import_ref[1]), LibraryGetLibraryName(trg_library ~= Game.GetProfile().library)),
				construct = function(cd)
					cd.list[2].width = 800
					cd.list:Add("<Button on_click={accept} text='Create a new entry with the same name'/>")
					if import_ref[1].type == 'C' and is_remote then
						cd.list:Add("<Button on_click={overwrite} text='Overwrite existing entry (running behaviors will be affected)'/>")
						cd.list:Add("<Button on_click={use_existing} text='Use existing entry (behavior might fail if input or output parameters are different)'/>")
					else
						cd.list:Add("<Button on_click={overwrite} text='Overwrite the existing entry'/>")
						cd.list:Add("<Button on_click={use_existing} text='Use existing entry'/>")
					end
				end,
				accept = function(cd) cd:cancel() CheckNextImport(i + 1) end,
				overwrite = function(cd) mapping[import_ref[1].id] = import_ref[3] cd:accept() end,
				use_existing = function(cd) mapping[import_ref[1].id], imports[i] = import_ref[3], false cd:accept() end,
			})
		else
			return CheckNextImport(i + 1)
		end
		if props then
			props.cancel = function(cd) UI.CloseMenuPopup(cd) end
			UI.MenuPopup("ConfirmDialog", props, popup_next_to)
		end
	end
	return CheckNextImport(2)
end

local function UILibraryRefreshItem(w, temp_item)
	local item, type = temp_item or w.item, w.type
	local name, default_icon, default_imageid = LibraryGetItemName(item, type)
	w.name = NOLOC(name)
	w.order = item.order or item.id
	if type == 'B' then -- blueprints
		local frame_def = data.frames[item.frame]
		default_icon, default_imageid = 'icon_small_blueprint', frame_def and frame_def.id
	elseif type == 'C' then -- behavior
		default_icon = 'icon_small_behavior'
	end
	w.icon.imageid = item.icon or default_imageid
	w.icon.image = not w.icon.imageid and default_icon or nil
	w.icon.color = not w.icon.imageid and 'ui_light' or 'white'
end

local function UILibraryRefreshList(list, dirhead_layout, folder_layout, item_layout, library, folder, filter_type, filter_string, edit_item_id, tmpfolder)
	local sub_counts, base_len, base = {}, folder and (#folder + 2), folder and folder .. '/'
	local function GetSubName(ffolder)
		return ffolder and (not base or ffolder:find(base, 1, true) == 1) and ffolder:match('[^/]*', (base_len or 1))
	end
	for _,v in pairs(library) do
		local vfolder = (not filter_type or v.type == filter_type) and v.folder
		local sub = vfolder and GetSubName(vfolder)
		if sub then sub_counts[sub] = (sub_counts[sub] or 0) + 1 end
	end

	local tmpfolder_sub = tmpfolder and GetSubName(tmpfolder)
	if tmpfolder_sub and not sub_counts[tmpfolder_sub] then sub_counts[tmpfolder_sub] = 0 end

	if filter_string == "" then filter_string = nil end
	local ContainsStringNoCase = filter_string and Tool.ContainsStringNoCase

	list:Clear()
	if folder then
		local parent, sub = folder:match('(.*)/(.*)')
		list:Add(dirhead_layout, { txt = L("%s /%S%S", "Folder:", (parent or ''), (parent and '/' or '')), sub = sub or folder, order = -90001 })
	end
	if not filter_string then
		for i,sub in ipairs(GetSortedTableKeys(sub_counts)) do
			local count = sub_counts[sub]
			list:Add(folder_layout, { text = L("%S (%d)", sub, count), sub = sub, count = count, order = -90000 + i })
		end
	end
	if #list > 0 then list:Add("<Spacer height=16 order=-1/>") end

	local edit_w
	for id,item in pairs(library) do
		if id ~= item.id then library[id] = nil error('deleting library item '..tostring(id)..' with id mismatch: '..tostring(item)) end
		if not item.type then library[id] = nil error('deleting library item '..tostring(id)..' with invalid type: '..tostring(item.type)) end
		if not filter_type or item.type == filter_type then
			local item_folder, match = item.folder
			if filter_string then
				match = (not base or item_folder == folder or (item_folder and item_folder:find(base, 1, true) == 1)) and ContainsStringNoCase(LibraryGetItemName(item), filter_string)
			else
				match = item.folder == folder
			end
			if match then
				local w = list:Add(item_layout, { type = item.type, item = item, boxbg = "reg_base_ro" })
				UILibraryRefreshItem(w)
				if edit_item_id == id then edit_w = w end
			end
		end
	end

	list:SortChildren(function(a, b) return a.order < b.order end)

	return edit_w, sub_counts
end

local last_tab, library_folder, library_tmpfolder, library_type, library_table, library_remote, library_last_edit_id, library_viewmode
local Library<const> = {}
UI.Register("Library", Library_layout, Library)

function Library:construct()
	if not library_viewmode then library_viewmode = "icon_small_view_list" end
	self.viewmode.icon = library_viewmode
	self.filterblueprint.active = library_type ~= 'C'
	self.filterbehavior.active = library_type ~= 'B'
	self:switch_tab(self.tabbuttons[last_tab or 1])
	action_library = self
end

function Library:destruct()
	action_library = nil
end

function Library:switch_tab(btn)
	local lastbtn = last_tab and self.tabbuttons[last_tab]
	if lastbtn and lastbtn.active then
		lastbtn.active, lastbtn.disabled = false, false
		library_folder, library_tmpfolder = nil, nil
	end
	btn.active, btn.disabled = true, true
	last_tab = btn.child_index
	library_remote = btn.remote
	self:refresh_list()
end

function Library:editorbox_close()
	self.editorbox.hidden = true
	self.editorbox:Clear()
	self.edit_bp_w = nil
	library_last_edit_id = nil
end

function Library:on_filter(w)
	w.active = not w.active
	local blueprint, behavior = self.filterblueprint, self.filterbehavior
	if not blueprint.active and not behavior.active then
		if w == blueprint then behavior.active = true else blueprint.active = true end
	end
	library_type = blueprint.active ~= behavior.active and (blueprint.active and 'B' or 'C') or nil
	self:refresh_list()
end

function Library:refresh_list(edit_item_id, old_folder, new_folder)
	library_table = (library_remote and Game.GetLocalPlayerFaction().extra_data or Game.GetProfile()).library or {}

	if old_folder then
		if library_folder == old_folder then library_folder = new_folder end
		if library_tmpfolder == old_folder then library_tmpfolder = new_folder end
		if library_tmpfolder and library_tmpfolder:find(old_folder .. '/', 1, true) == 1 then
			library_tmpfolder = (new_folder or "") .. library_tmpfolder:sub(#old_folder + (new_folder and 1 or 2))
		end
	end

	if not library_tmpfolder then library_tmpfolder = library_folder end -- maybe folder was cleared out, keep it as tmpfolder
	if library_tmpfolder then
		for _,v in pairs(library_table) do
			local vfolder = v.folder
			if vfolder then
				local matchfrom, tmplen = vfolder:find(library_tmpfolder)
				if matchfrom == 1 and (#vfolder == tmplen or vfolder:find('/', tmplen+1) == tmplen+1) then library_tmpfolder = nil break end -- new folder exists now, so clear it
			end
		end
	end

	if not edit_item_id or not self.editorbox.hidden then edit_item_id = library_last_edit_id end
	self:enddrag() -- after clearing the list an active drag becomes invalid
	local list, edit_w, sub_counts = self.list
	if self.viewmode.icon == "icon_small_view_list" then
		edit_w, sub_counts = UILibraryRefreshList(list, DirHead_layout, Folder_layout, Item_layout, library_table, library_folder, library_type, self.search.inp.text, edit_item_id, library_tmpfolder)
	else
		list:Clear()
		local wrap = list:Add("<Wrap child_padding=8/>")
		wrap.wrapsize = list.width
		edit_w, sub_counts = UILibraryRefreshList(wrap, DirHead_layout, Icon_Folder_layout, Icon_Item_layout, library_table, library_folder, library_type, self.search.inp.text, edit_item_id, library_tmpfolder)
	end

	if not library_remote then
		list:Add('<Text textalign=center style=hl text="Use your Favorites to transfer items to other save games and multiplayer sessions" size=10 margin_top=4 margin_bottom=12/>').child_index = 1
	end

	local cur_open_edit_id = not self.editorbox.hidden and library_last_edit_id
	local new_open_edit_id = edit_w and edit_w.type == 'B' and not edit_w.hidden and edit_item_id
	if cur_open_edit_id ~= new_open_edit_id then
		if cur_open_edit_id then self:editorbox_close() end
		if new_open_edit_id then self:item_on_click(edit_w) end
	elseif new_open_edit_id then
		self.edit_bp_w = edit_w
		edit_w.nameactive = true
		edit_w.boxbg = "reg_base"
	end

	self.createpaste.hidden = not UnitCopyPaste.GetItem('B', 'C')

	for i=1,999 do
		local newfoldername = (i == 1 and NOLOC(L("New Folder")) or NOLOC(L("%s %d", "New Folder", i)))
		if (sub_counts[newfoldername] or 0) == 0 then
			self.createfolder.sub = newfoldername
			break
		end
	end
end

function Library:on_viewmode(btn)
	library_viewmode = library_viewmode == "icon_small_view_list" and "icon_small_view_icon" or "icon_small_view_list"
	btn.icon = library_viewmode
	self:refresh_list()
end

function Library:on_search()
	self:refresh_list()
end

function Library:item_new(btn)
	UI.MenuPopup([[
		<Box bg=popup_box_bg padding=4 blur=true>
			<VerticalList child_padding=4 margin=8>
				<Button on_click={createnew} type=B textalign=left icon=icon_blueprint text="Create New Blueprint" height=36/>
				<Button on_click={createnew} type=C textalign=left icon=icon_behavior text="Create New Behavior" height=36/>
				<Button on_click={selection} id=btnsel textalign=left icon=icon_target2 text="Create Blueprint from Current Selection" height=36/>
			</VerticalList>
		</Box>
	]], {
		construct = function(popup)
			local faction, entities = Game.GetLocalPlayerFaction(), View.GetSelectedEntities()
			for i=entities and #entities or 0,1,-1 do
				if entities[i].faction ~= faction or (#entities > 1 and IsBot(entities[i])) then
					entities[i] = entities[#entities]
					entities[#entities] = nil
				end
			end
			local selected_bp = entities and #entities > 0 and MakeBlueprintFromEntity(entities, true)
			local show_selection = selected_bp and ValidateCustomBlueprint(selected_bp)
			popup.btnsel.hidden = not show_selection
			popup.btnsel.tooltip = show_selection and DefinitionTooltip(selected_bp)
			popup.selected_bp = show_selection and selected_bp
		end,
		createnew = function(popup, menubtn)
			local type = menubtn.type
			UI.CloseMenuPopup(popup)
			self:modify_item({ mode = 'create', type = type, folder = library_folder })
		end,
		selection = function(popup)
			local temp_library = {}
			UnpackCompactedItemToLibraryTable(popup.selected_bp, 'B', temp_library)
			UI.CloseMenuPopup(popup)
			self:perform_import(temp_library, library_table, temp_library[1], "Import %s to %s", false, btn, nil, library_folder)
		end,
	}, btn)
end

function Library:paste_new(btn)
	local temp_library, item, type = {}, UnitCopyPaste.GetItem('B', 'C')
	if not item then return end
	UnpackCompactedItemToLibraryTable(Tool.Copy(item), type, temp_library)
	self:perform_import(temp_library, library_table, temp_library[1], "Import %s to %s", false, btn, true, library_folder)
end

function Library:paste_tooltip()
	local item = UnitCopyPaste.GetItem('B', 'C')
	return item and BuildDefinitionTooltip(item)
end

function Library:modify_item(arg, target_other_library)
	local open_editor = self.editorbox[1]
	if open_editor and arg.mode == 'delete' and arg.id == open_editor.bp.id then open_editor:cancel_changes() end
	if open_editor then open_editor:issue_on_change() end
	if library_remote == not target_other_library then
		Action.SendForLocalFaction("FactionLibrary", arg)
	else
		local new_item_id, old_folder, new_folder = LibraryModifyItemExecute(Game.GetProfile().library, arg)
		self:refresh_list(new_item_id, old_folder, new_folder)
	end
end

function Library:item_tooltip(w)
	local item = w.item
	return (item.type ~= 'B' or item.frame or item.multi) and BuildDefinitionTooltip(item)
end

function Library:item_on_click(w, btn, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" then return self:item_menu_on_click(w, btn) end

	if w.type == 'B' then
		if self.edit_bp_w then
			self.edit_bp_w.nameactive = false
			self.edit_bp_w.boxbg = "reg_base_ro"
			if self.edit_bp_w == w then
				self:editorbox_close()
				return
			end
		end
		w.nameactive = true
		w.boxbg = "reg_base"
		self.editorbox.hidden = false
		self.edit_bp_w = w

		local bp = w.item
		library_last_edit_id = bp.id
		self.editorbox:SetContent("BlueprintEditor", {
			bp = library_remote and Tool.Copy(bp) or bp,
			is_remote = library_remote,
			library = library_table,
			on_change = function(editor, changed_bp)
				if editor.is_remote then
					Action.SendForLocalFaction("FactionLibrary", { mode = 'data', item = changed_bp })
				else
					if w:IsValid() then UILibraryRefreshItem(w, changed_bp) end
				end
			end,
			on_refresh = function(editor, bp)
				UILibraryRefreshItem(self.edit_bp_w, bp)
			end,
		})
	elseif w.type == 'C' then
		OpenMainWindow("Program", {
			code = library_remote and Tool.Copy(w.item) or w.item,
			is_remote = library_remote,
			library = library_table,
			on_closed = function() OpenMainWindow("Library") end
		})
	end
end

function Library:item_box_on_click(w, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" then return self:item_menu_on_click(w, w.namebtn or w) end
	if not w.namebtn then self:item_on_click(w) end
end

function Library:item_menu_on_click(w, btn)
	local type = w.type
	UI.MenuPopup([[
			<Box bg=popup_box_bg padding=4 blur=true>
				<VerticalList child_padding=4 margin=8>
					<Button id=btnselect textalign=left on_click={select_on_click} icon=icon_test text="Select" height=36 tooltip="Select all units and buildings with this behavior"/>
					<Button id=btnrun textalign=left on_click={run_on_click} icon=icon_target2 text="Run on Selection" height=36 tooltip="Run behavior on all selected units and buildings"/>
					<Button id=btnlibrary textalign=left on_click={library_on_click} icon=icon_remote text="Copy to Library" height=36/>
					<Button id=btnfavorite textalign=left on_click={favorite_on_click} icon=icon_achieved text="Save to Favorites" height=36/>
					<Button icon=icon_copy textalign=left on_click={copy_on_click} text="Copy to Clipboard" height=36/>
					<Button icon=icon_new textalign=left on_click={duplicate_on_click} text="Duplicate" height=36/>
					<Button icon=icon_remove textalign=left on_click={delete_on_click} text="Delete" height=36/>
					<Button id=btnfolder icon=icon_folder textalign=left on_click={folder_on_click} text="Go to Folder" height=36/>
				</VerticalList>
			</Box>
		]], {
		construct = function(popup)
			popup:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
			popup:TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
			UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
			if w.btnmenu then w.btnmenu.active = true end
			popup.btnselect.hidden = not library_remote or type ~= 'C'
			popup.btnrun.hidden = not library_remote or type ~= 'C' or not View.GetSelectedEntity()
			popup.btnfavorite.hidden = not library_remote
			popup.btnlibrary.hidden = library_remote
			popup.btnfolder.hidden = (self.search.inp.text or "") == ""
		end,
		destruct = function()
			if w:IsValid() and w.btnmenu then w.btnmenu.active = false end
		end,
		loadtooltip = function() return L(library_remote and "Download to '%s'" or "Upload to '%s'", LibraryGetLibraryName(not library_remote)) end,
		folder_on_click = function()
			library_folder = w.item.folder
			self.search:SetText("")
			self:refresh_list()
		end,
		delete_on_click = function()
			local msg
			if type == 'B' then -- blueprints
				msg = "Are you sure you want to delete the blueprint '%S'?"
			elseif type == 'C' then -- behaviors
				msg = "Are you sure you want to delete the behavior '%S'?"
			end
			ConfirmPopup(btn, L(msg, w.name), function()
				self:modify_item({ mode = 'delete', id = w.item.id })
			end)
		end,
		duplicate_on_click = function()
			self:modify_item({ mode = 'duplicate', id = w.item.id })
		end,
		copy_on_click = function()
			local packed_item = PackLibraryItemToCompactedItem(library_table, w.item, type)

			local msg
			if type == 'B' then -- blueprints
				packed_item.prefab, packed_item.race, packed_item.texture, packed_item.num = nil -- old prefab fields
				msg = "Blueprint copied to clipboard"
			elseif type == 'C' then -- behaviors
				msg = "Behavior copied to clipboard"
			end

			Tool.SetClipboard(packed_item, type)
			self.createpaste.hidden = false
			MessagePopup(btn, msg)
		end,
		favorite_on_click = function()
			self:perform_import(library_table, Game.GetProfile().library, w.item, "Add %s to %s", true, btn, true)
		end,
		library_on_click = function()
			self:perform_import(library_table, Game.GetLocalPlayerFaction().extra_data.library, w.item, "Add %s to %s", true, btn, true)
		end,
		run_on_click = function(popup)
			Action.SendForSelectedEntities("Behavior", { set_id = w.item.id })
			UI.CloseMenuPopup(popup)
		end,
		select_on_click = function(popup)
			local item_id, entities = w.item.id, {}
			for _,comp in ipairs(Game.GetLocalPlayerFaction():GetComponents("c_behavior", true)) do
				local ed = comp.has_extra_data and comp.extra_data
				if ed and ed.main_id == item_id then
					entities[#entities+1] = comp.owner
				end
			end
			View.SelectEntities(entities)
			UI.CloseMenuPopup(popup)
		end,
	}, btn)
end

function Library:perform_import(src_library, trg_library, item_or_folder, mode_title, target_other_library, btn, confirm_import, default_folder)
	local item = type(item_or_folder) ~= "string" and item_or_folder
	local msg_title = L(mode_title, (item and LibraryGetTypeName(item) or "Folder"), LibraryGetLibraryName(not library_remote ~= not target_other_library))

	local function do_import(arr, mapping)
		self:modify_item({ mode = 'import', arr = arr, mapping = mapping, folder = (default_folder or nil) }, target_other_library)
	end
	local function on_exists(trg_bp, src_mapping)
		if item then
			if not confirm_import then return do_import({item}, src_mapping) end -- allow creating another new item even if the name is the same
			UI.MenuPopup("ConfirmDialog", { title = msg_title, body = L("%s '%S' already exists", LibraryGetTypeName(item), LibraryGetItemName(item)), ok = function(cd) UI.CloseMenuPopup(cd) end }, btn)
		else
			UI.MenuPopup("ConfirmDialog", { title = msg_title, body = L("%s '%S' already exists", "Folder", item_or_folder), ok = function(cd) UI.CloseMenuPopup(cd) end }, btn)
		end
	end
	local function on_confirm(props, arr, mapping)
		if arr and not confirm_import then do_import(arr, mapping) return end
		props.on_accept = arr and function() do_import(arr, mapping) end
		props.title = msg_title
		return props
	end
	UILibraryPrepareImport(src_library, trg_library, item_or_folder, on_exists, on_confirm, false, btn, library_type)
end

function Library:list_drag_start(payload, is_click_drag)
	if is_click_drag and library_viewmode ~= "icon_small_view_list" then return end
	if self.edit_bp_w == payload then self:item_on_click(payload) return end -- unselect and close blueprint editor first (wait for potential changes to be saved)

	local list = self.list
	if library_viewmode == "icon_small_view_list" then
		local x, y, w, h = payload:GetViewportPosition()
		self.dragline = list:Add("<Spacer><Image height=2 valign=center/></Spacer>")
		self.dragline.height = h
	else
		self.dragline = list[#list]:Add("<Image width=80 height=90 color=#FFFFFF20/>") -- add to wrap
	end

	self.dragline.order = payload.order
	self.dragline.child_index, self.dragline.start_child_index = payload.child_index, payload.child_index
	self.dragline.on_drag_over = function (dl) dl.opacity = 1.0 end

	payload:RemoveFromParent()
	payload.dragtype, payload.sx, payload.sy, payload.opacity = "LIBRARYITEM", 0.7, 0.7, 0.8

	-- Can't use {attribute parent reference} for cancel because while dragging payload no longer has a parent
	payload.on_drag_cancel = function() if self:IsValid() then self:enddrag() self:refresh_list() end end
	return payload
end

function Library:enddrag()
	if self.dragactive then self.dragactive.active = false self.dragactive = nil end
	if self.dragline then self.dragline:RemoveFromParent() self.dragline = nil end
end

function Library:folder_drag_start(folder_row, is_click_drag)
	if is_click_drag and library_viewmode ~= "icon_small_view_list" then return end
	folder_row.dragtype = "LIBRARYFOLDER"
	return UI.New('<Button icon=icon_folder color=ui_light height=32/>', { text = folder_row.text })
end

function Library:folder_drag_enter(w, ...)
	local folderbtn, payload = select(w.isdirhead and 2 or 1, w.folderbtn or w, ...)
	if payload.dragtype ~= "LIBRARYITEM" and payload.dragtype ~= "LIBRARYFOLDER" then return false end
	if self.dragline then self.dragline.opacity = 0.0 end
	if self.dragactive then self.dragactive.active, self.dragactive = false, nil end
	if w == payload then return end
	self.dragactive = folderbtn
	folderbtn.active = true
end

function Library:folder_drag_leave(w)
	if self.dragactive then self.dragactive.active, self.dragactive = false, nil end
end

function Library:item_drag_over(over, payload, visual, x, y)
	if self.dragactive then self.dragactive.active, self.dragactive = false, nil end
	if payload.dragtype ~= "LIBRARYITEM" then return false end
	if not self.dragline then return false end -- abort drag (maybe library got re-opened)
	local into_previous = (library_viewmode == "icon_small_view_list" and y or x) < 0.5
	self.dragline.child_index = over.child_index - (over.child_index > self.dragline.child_index and 1 or 0) + (into_previous and 0 or 1)
	self.dragline.opacity = 1.0
end

function Library:list_drop(scroll_list, payload)
	if payload.dragtype ~= "LIBRARYITEM" or not self.dragline then return false end
	if self.dragline.child_index == self.dragline.start_child_index then return false end
	local above_w, below_w = self.dragline.previous_sibling, self.dragline.next_sibling
	local above_item, below_item, payload_item = above_w and above_w.item, below_w and below_w.item, payload.item
	local above_order = (above_item and (above_item.order or above_item.id) or 0)
	local below_order = (below_item and (below_item.order or below_item.id) or nil) -- nil is converted to max by 'move'
	self:enddrag()
	self:modify_item({ mode = 'move', id = payload_item.id, folder = payload_item.folder, above = above_order, below = below_order })
end

function Library:folder_drop(w, ...)
	local payload = select(w.isdirhead and 2 or 1, ...)
	local base = (library_folder and (library_folder .. '/') or "")
	local new = not w.isdirhead and (base .. w.sub) or library_folder:match('(.*)/')
	self:enddrag()
	if payload.dragtype == "LIBRARYITEM" then
		self:modify_item({ mode = 'move', id = payload.item.id, folder = new })
	elseif payload.dragtype == "LIBRARYFOLDER" and payload ~= w then
		self:modify_item({ mode = 'folder_name', old = base .. payload.sub, new = (new and (new .. '/') or "") .. payload.sub })
	else return false end
end

function Library:on_icon_folder_render(folder)
	folder[1].bg = folder.active and 'popup_button_bg' or 'popup_box_bg'
end

function Library:folder_gointo(folderw, btn, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" then return self:folder_menu_on_click(folderw, btn) end
	library_folder = (library_folder and (library_folder .. '/') or "") .. folderw.sub
	self:refresh_list()
end

function Library:folder_goup()
	library_folder = library_folder:match('(.*)/')
	self:refresh_list()
end

function Library:folder_renamed(folderinside, input, text)
	if #text == 0 or text:find('/') then
		text = (#text == 0 and '_' or text:gsub('/','_'))
		input.text = text
	end
	local oldname = library_folder
	local newname = (oldname:match('.*/') or "") .. text
	if oldname ~= newname then
		library_folder = newname
		if library_tmpfolder and library_tmpfolder == oldname then
			library_tmpfolder = newname
			self:refresh_list(nil, oldname, newname) -- to merge with an already existing folder
			return
		end
		self:modify_item({ mode = 'folder_name', old = oldname, new = newname })
	end
end

function Library:folder_new(newfolder)
	library_tmpfolder = (library_folder and (library_folder .. '/') or "") .. newfolder.sub
	library_folder = library_tmpfolder
	self:refresh_list()
end

function Library:folder_box_on_click(folderw, mousebtn)
	if mousebtn == "RIGHTMOUSEBUTTON" then return self:folder_menu_on_click(folderw, folderw.folderbtn or folderw) end
	if not folderw.folderbtn then self:folder_gointo(folderw) end
end

function Library:folder_menu_on_click(folder_row, btn)
	local folder_path = (library_folder and (library_folder .. '/') or "") .. folder_row.sub
	UI.MenuPopup([[
			<Box bg=popup_box_bg padding=4 blur=true>
				<VerticalList child_padding=4 margin=8>
					<Button id=btnlibrary textalign=left on_click={library_on_click} icon=icon_remote text="Copy to Library" height=36/>
					<Button id=btnfavorite textalign=left on_click={favorite_on_click} icon=icon_achieved text="Save to Favorites" height=36/>
					<Button icon=icon_remove textalign=left on_click={delete_on_click} text="Delete" height=36/>
				</VerticalList>
			</Box>
		]], {
		construct = function(popup)
			popup:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
			popup:TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
			UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
			if folder_row.btnmenu then folder_row.btnmenu.active = true end
			popup.btnfavorite.hidden = not library_remote
			popup.btnlibrary.hidden = library_remote
		end,
		destruct = function()
			if folder_row:IsValid() and folder_row.btnmenu then folder_row.btnmenu.active = false end
		end,
		loadtooltip = function() return L(library_remote and "Download to '%s'" or "Upload to '%s'", LibraryGetLibraryName(not library_remote)) end,
		favorite_on_click = function()
			self:perform_import(library_table, Game.GetProfile().library, folder_path, "Add %s to %s", true, btn, true)
		end,
		library_on_click = function()
			self:perform_import(library_table, Game.GetLocalPlayerFaction().extra_data.library, folder_path, "Add %s to %s", true, btn, true)
		end,
		delete_on_click = function()
			local del_folder = (library_folder and (library_folder .. '/') or "") .. folder_row.sub
			if del_folder == library_tmpfolder or folder_row.count == 0 then
				library_tmpfolder = del_folder ~= library_tmpfolder and library_folder or nil
				self:refresh_list()
				return
			end
			ConfirmPopup(btn, L("Are you sure you want to remove the folder '%S'?\n\n%d contained items will be deleted.", folder_row.sub, folder_row.count), function()
				self:modify_item({ mode = 'folder_delete', folder = del_folder, type = library_type })
			end)
		end,
	}, btn)
end

function UILibraryImportBlueprint(bp, done_cb, popup_next_to, target_library) -- references in bp must be packed dependencies
	local function on_done(res, mapping) -- res should be a independent copy not a reference
		if mapping then LibraryApplyMapping(res, mapping) end
		res.id, res.rev, res.type, res.folder, res.order, res.num = nil, nil, nil, nil, nil, nil -- library/register fields
		done_cb(res)
	end

	local root_bp, library = Tool.Copy(bp), {}
	UnpackCompactedItemToLibraryTable(root_bp, 'B', library)

	-- Import blueprint dependencies
	local function on_exists(trg_bp, src_mapping)
		on_done(trg_bp and Tool.Copy(trg_bp) or root_bp, not trg_bp and src_mapping)
	end
	local function on_confirm(props, arr, mapping)
		if arr then -- final confirmation, not asking about a dependency
			props.on_accept = function()
				CallLibraryImport(arr, mapping, "Import", (target_library ~= Game.GetProfile().library), function(arg) on_done(root_bp, arg.mapping) end)
			end
		end
		props.title = L("Add %s to %s", "Items", "Library")
		return props
	end
	UILibraryPrepareImport(library, (target_library or Game.GetLocalPlayerFaction().extra_data.library), root_bp, on_exists, on_confirm, true, popup_next_to)
end

function UILibraryAssignBlueprintParams(bp, done_cb, popup_next_to)
	if not bp or not bp.params then return done_cb(bp) end
	local param_vals = {}
	UI.MenuPopup("ConfirmDialog", {
		title = "Blueprint Parameter",
		body = "Choose the values to use for the parameters of this blueprint.",
		construct = function(cd)
			cd.list[2].width = 400
			for i,entry in ipairs(bp.params) do
				local name, val = entry[1], entry[2]
				cd.list:Add([[<HorizontalList child_align=center>
					<MiniReg def_id=v_blueprint_param num={num}/>
					<Text text="Name:" margin_left=16 margin_right=8/>
					<Text fill=true text={name}/>
					<Text text="Value:" margin_left=16 margin_right=8/>
					<Reg on_click={on_val_click} def_id={val_id} entity={val_entity} coord={val_coord} num={val_num}/>
				</HorizontalList>]], { num = i, name = name, val_id = val and val.id, val_entity = val and val.entity, val_coord = val and val.coord, val_num = val and val.num  })
				param_vals[i] = val or false
			end
		end,
		on_val_click = function(cd, regw)
			local row = regw.parent
			local function register_on_set(rsel, val)
				if not val or not next(val) then val = nil elseif val.num == 0 and (val.id or val.entity or val.coord) then val.num = nil end
				param_vals[row.num], row.val_id, row.val_entity, row.val_coord, row.val_num = val, val and val.id, val and val.entity, val and val.coord, val and val.num
			end
			local rsel = ShowRegisterSelection(regw, register_on_set)
			if rsel then rsel:SetRegister({ id = regw.def_id, entity = regw.entity, coord = regw.coord, num = regw.num }) end
		end,
		ok = function(cd)
			UI.CloseMenuPopup(cd)
			bp = Tool.Copy(bp)
			SetLibraryBlueprintParams(bp, param_vals)
			done_cb(bp)
		end,
		cancel = function(cd) UI.CloseMenuPopup(cd) end,
	}, popup_next_to, "UP")
end

function UILibrarySaveBehaviorAsNew(code, done_cb) -- references in code must be to the remote library (not packed dependencies)
	action_callback = function(arg) done_cb(arg.item) end -- apply final mapping after import
	Action.SendForLocalFaction("FactionLibrary", { mode = 'create', item = code })
end

function UILibrarySelect(btn, type, on_select, on_clear, on_create, active_id, filter_comp_id, library, is_load_into_library)
	if not library then library = Game.GetLocalPlayerFaction().extra_data.library end
	local remote = library ~= (Game.GetProfile().library)
	return UI.MenuPopup([[
			<Box bg=popup_box_bg padding=8 blur=true>
				<VerticalList child_padding=4>
					<TextSearch id=search on_refresh={filter} fill=true/>
					<ScrollList id=list child_padding=2 width=400 height=700 margin_top=12/>
					<Button id=clearbtn on_click={clear} text="None"/>
					<Button id=createbtn on_click={create} text="Create New Behavior"/>
				</VerticalList>
			</Box>
		]], {
		construct = function(popup)
			popup:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
			popup:TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
			UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
			btn.active = true
			local active_item = active_id and library[active_id]
			popup.clearbtn.hidden = on_clear == nil
			popup.clearbtn.active = not active_item
			popup.createbtn.hidden = on_create == nil
			popup.folder = active_item and active_item.folder or nil
			popup:refresh()
			if not is_load_into_library then UILibraryLoadButton(popup[1], library, true, type, filter_comp_id) end
		end,
		refresh = function(popup)
			local list, comp_def = popup.list, filter_comp_id and data.components[filter_comp_id]
			local active_w = UILibraryRefreshList(list, Selection_DirHead_layout, Selection_Folder_layout, Selection_Item_layout, library or {}, popup.folder, type, popup.search.inp.text, active_id)
			if active_w then active_w.nameactive = true end

			local comp_key, faction = comp_def and comp_def.key, Game.GetLocalPlayerFaction()
			for i=#list,1,-1 do
				local w = list[i]
				local item = w.item
				if item and w ~= active_w then
					local item_frame_def, incompatible
					if type == 'C' and filter_comp_id then
						for _,v in ipairs(item) do
							local inst = data.instructions[v.op]
							if inst and inst.key and inst.key ~= comp_key then incompatible = true break end
						end
					elseif type == 'B' and filter_comp_id then
						item_frame_def = data.frames[item.frame]
						incompatible = not item_frame_def or not item_frame_def.production_recipe or (filter_comp_id ~= true and not item_frame_def.production_recipe.producers[filter_comp_id]) or not FactionHasUnlockedCustomBlueprint(faction, item)
					elseif type == 'B' then
						item_frame_def = data.frames[item.frame]
						incompatible = (item_frame_def and item_frame_def.production_recipe) or (not item_frame_def and not item.multi) or not FactionHasUnlockedCustomBlueprint(faction, item)
					end
					if incompatible then w:RemoveFromParent() end
				end
			end
		end,
		icon_tooltip = function(popup, row)
			local item = row.item
			return (item.type ~= 'B' or item.frame or item.multi) and BuildDefinitionTooltip(item)
		end,
		destruct = function()
			if btn:IsValid() then btn.active = false end
		end,
		filter = function(popup, search, filter)
			popup:refresh()
		end,
		folder_goup = function(popup)
			popup.folder = popup.folder:match('(.*)/')
			popup:refresh()
		end,
		folder_gointo = function(popup, folder_row)
			popup.folder = (popup.folder and (popup.folder .. '/') or "") .. folder_row.sub
			popup:refresh()
		end,
		on_library_loaded = function(popup, btn, item)
			UI.CloseMenuPopup(popup)
			on_select(item)
		end,
		click = function(popup, clickedbtn)
			local item = clickedbtn.item
			if is_load_into_library then
				local folder = popup.folder
				local target_remote = not remote
				local on_done = function(res)
					UI.CloseMenuPopup(popup)
					on_select(res)
				end
				local function on_confirm(props, arr, mapping, confirm_overwrite)
					props.on_accept = arr and function()
						CallLibraryImport(arr, mapping, folder, target_remote, function(arg) on_done(arg.arr[1]) end)
					end
					if arr and #arr == 1 and not confirm_overwrite then props.on_accept() return end
					props.title = L("Add %s to %s", (item and LibraryGetTypeName(item) or "Folder"), LibraryGetLibraryName(target_remote))
					return props
				end
				UILibraryPrepareImport(library, (target_remote and Game.GetLocalPlayerFaction().extra_data or Game.GetProfile()).library, item, on_done, on_confirm, false, clickedbtn)
			else
				UI.CloseMenuPopup(popup)
				on_select(item)
			end
		end,
		clear = function(popup) on_clear() UI.CloseMenuPopup(popup) end,
		create = function(popup) on_create(popup.folder) UI.CloseMenuPopup(popup) end,
	}, btn, "RIGHT")
end

function UILibraryLoadButton(list, target_library, wide_button, type, filter_comp_id, halign)
	local profile = Game.GetProfile()
	local from_local = (target_library ~= profile.library)
	local src_library = (from_local and profile or Game.GetLocalPlayerFaction().extra_data).library
	if not src_library or not next(src_library) then return end -- empty library, show no button
	local txt = from_local and "Load from Favorites" or "Load from Library"
	list:Add(wide_button and '<Button height=32 ok={on_library_loaded}/>' or '<Button height=32 fill=false ok={on_library_loaded}/>', {
		icon = from_local and "icon_achieved" or "icon_remote", tooltip = not wide_button and txt, text = wide_button and txt, halign = halign,
		on_click = function(btn) UILibrarySelect(btn, type, function (i) btn:SendEvent("ok", i) end, nil, nil, nil, filter_comp_id, src_library, true) end,
	})
end
