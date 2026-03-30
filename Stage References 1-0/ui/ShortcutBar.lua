local layout =
[[
	<HorizontalList child_padding=4/>
]]

local ShortcutItem_layout =
[[
	<Canvas width=56 height=56 on_click={on_click_shortcut} tooltip={group_tooltip}>
		<Image image=corner_box_bg dock=fill/>
		<Image image={img} dock=fill/>
		<Box dock=top-left blocking=false bg=label_left color=ui_dark padding=1>
			<Text text={numtxt} size=10 margin_left=3 margin_right=4 margin_bottom=1/>
		</Box>
		<Reg id=vreg bg=false show_race_bg=false no_interact=true dock=bottom-right width=40 height=40 hidden=true/>
	</Canvas>
]]

local ShortcutBar, shortcut_row, shortcut_groups, ShortcutBar_open = {}, 1
UI.Register("ShortcutBar", layout, ShortcutBar)

function ShortcutBar_UpdateLocalFaction()
	local extra, faction_id = Game.GetLocalPlayerExtra(), Game.GetLocalPlayerFaction().id
	local all_shortcut_groups = extra.shortcut_groups
	if not all_shortcut_groups then
		if not extra.ShortcutFrames then return end -- handle old format
		all_shortcut_groups = { [faction_id] = extra.ShortcutFrames }
		extra.shortcut_groups, extra.ShortcutFrames = all_shortcut_groups, nil
	end
	shortcut_groups = all_shortcut_groups[faction_id]
end

function ShortcutBar:construct()
	ShortcutBar_open = self
	ShortcutBar_UpdateLocalFaction()
	self.chk = 0
	self:refresh()
end

function ShortcutBar:destruct()
	ShortcutBar_open = nil
end

local function ShortcutBar_FilterEntities(entities, group_num)
	if not entities or #entities == 0 then return end
	local local_player_faction, changed = Game.GetLocalPlayerFaction()

	-- check for destroyed or not seen
	for i=#entities,1,-1 do
		local entity = entities[i]
		local entfac = entity.exists and entity.faction
		local visible = entfac and (entfac == local_player_faction or local_player_faction:IsSeen(entity) or (not entfac.is_player_controlled and not entity.def.movement_speed and local_player_faction:IsDiscovered(entity)))
		if not visible then
			changed = true
			table.remove(entities, i)
		end
	end
	if group_num and #entities == 0 then
		shortcut_groups[group_num] = nil
	end
	return changed
end

function ShortcutBar:update()
	local chk = self.chk + 1
	local do_refresh = ShortcutBar_FilterEntities(shortcut_groups and shortcut_groups[chk], chk)
	if do_refresh then self:refresh() end
	self.chk = chk % 10

	local chkreg = self[chk]
	local chkgroup = chkreg and shortcut_groups and shortcut_groups[chkreg.num]
	if not chkgroup or chkgroup.icon then return end
	local chkvreg, chkentity = chkreg.vreg, chkreg.entity
	local chkentity_exists = chkentity.exists
	if chkentity_exists then chkreg.img = chkentity.def.texture end
	local visualval = chkentity_exists and chkentity:GetRegister(FRAMEREG_VISUAL)
	local visualempty = not visualval or visualval.is_empty or chkentity.faction:GetTrust(Game.GetLocalPlayerFaction()) ~= "ALLY"
	chkvreg.hidden = visualempty
	if visualempty then return end
	local vregid, vregnum = visualval.id, visualval.num
	if vregnum == REG_INFINITE and vregid then vregnum = chkentity:CountItem(vregid) end
	chkvreg.def_id = vregid or (visualval.entity and visualval.entity.id)
	chkvreg.num = vregnum == 0 and "" or vregnum
end

function ShortcutBar:refresh()
	self:Clear()
	local faction = Game.GetLocalPlayerFaction()
	for num=shortcut_row*10-9,shortcut_row*10 do
		local group = shortcut_groups and shortcut_groups[num]
		if not group or #group == 0 then goto skip_entity end
		local entity, icon = group[1], group.icon
		if not entity.exists then
			ShortcutBar_FilterEntities(group, num)
			if #group == 0 then goto skip_entity end
			entity = group[1]
		end
		local btn = self:Add(ShortcutItem_layout, {
			img = icon and data.all[icon].texture or entity.def.texture,
			entity = entity,
			num = num,
			numtxt = tostring(((num - 1) % 10) + 1),
		})
		btn.vreg.base.image = "black_bg" -- set separate because bg=false also hides the number background
		local visualval = entity:GetRegister(FRAMEREG_VISUAL)
		if (visualval and not visualval.is_empty and entity.faction:GetTrust(faction) == "ALLY") and not icon then
			local vregid, vregnum = visualval.id, visualval.num
			if vregnum == REG_INFINITE and vregid then vregnum = entity:CountItem(vregid) end
			btn.vreg.def_id = vregid or (visualval.entity and visualval.entity.id)
			btn.vreg.num = vregnum == 0 and "" or vregnum
			btn.vreg.hidden = false
		end
		::skip_entity::
	end

	if (shortcut_groups and next(shortcut_groups)) or shortcut_row ~= 1 then
		local rowui = self:Add([[<Box height=56 blur=true on_mouse_wheel={row_on_mouse_wheel} width=24 opacity=0.75><VerticalList>
				<Button on_click={row_on_click} icon=icon_small_output height=18/>
				<Box on_click={row_on_click} bg=popup_button_bg fill=true><Text size=10 dock=center y=-1/></Box>
				<Button on_click={row_on_click} icon=icon_small_input height=18/>
			</VerticalList></Box>]])[1]
		rowui[1].tooltip = L('%s (<Key action="ShortcutRowNext"/>)', "Next Shortcut Group Row")
		rowui[2][1].text = tostring(shortcut_row)
		rowui[3].tooltip = L('%s (<Key action="ShortcutRowPrev"/>)', "Previous Shortcut Group Row")
	end
	self.hidden = (#self == 0)
end

local function array_contains(a, b)
	for _,y in ipairs(b) do
		local idx
		for i,x in ipairs(a) do if x == y then idx = i break end end
		if not idx then return false end
	end
	return true
end

local function ShortcutBar_DoSelect(num, ctrl, shift, jumpcam)
	local group = shortcut_groups and shortcut_groups[num] or {}
	local do_refresh = ShortcutBar_FilterEntities(group, num)
	if do_refresh and ShortcutBar_open then ShortcutBar_open:refresh() end

	local selected = View.GetSelectedEntities() or {}
	ShortcutBar_FilterEntities(selected)

	local function array_add(a, b)
		for _,y in ipairs(b) do
			local idx
			for i,x in ipairs(a) do if x == y then idx = i break end end
			if not idx then table.insert(a, y) end
		end
	end
	local function array_remove(a, b)
		for _,y in ipairs(b) do
			local idx
			for i,x in ipairs(a) do if x == y then idx = i break end end
			if idx then table.remove(a, idx) end
		end
	end

	if ctrl then
		if shift and #group > 0 then
			-- Modify existing shortcut group
			if array_contains(group, selected) then
				array_remove(group, selected)
			else
				array_add(group, selected)
			end
		else
			-- Set new shortcut group
			if not shortcut_groups then
				shortcut_groups = {}
				local extra, faction_id = Game.GetLocalPlayerExtra(), Game.GetLocalPlayerFaction().id
				if not extra.shortcut_groups then extra.shortcut_groups = {} end
				extra.shortcut_groups[faction_id] = shortcut_groups
			end
			shortcut_groups[num] = selected
		end
		if ShortcutBar_open then
			ShortcutBar_open:refresh()
		end
	elseif shift then
		-- Modify current selection
		if array_contains(selected, group) then
			array_remove(selected, group)
		else
			array_add(selected, group)
		end
		View.SelectEntities(selected)
	elseif #group > 0 and (jumpcam or (#selected == #group and array_contains(selected, group))) then
		-- Set current selection
		View.JumpCameraToEntities(group[1])
	else
		View.SelectEntities(group)
	end
end

local function ShortcutBar_Select(num)
	if Input.IsAltDown() then
		shortcut_row = num
		if ShortcutBar_open then ShortcutBar_open:refresh() end
	else
		ShortcutBar_DoSelect((shortcut_row - 1) * 10 + num, Input.IsControlDown(), Input.IsShiftDown())
	end
end

local function ShortcutBar_Row(shift)
	shortcut_row = ((shortcut_row + 9 + shift) % 10) + 1
	if ShortcutBar_open then ShortcutBar_open:refresh() end
end

local function ShortcutBar_Title(group, num)
	if num > 10 then
		return L("%s.%d", L("%d Units in Shortcut Group #%d", #group, ((num - 1) // 10) + 1), ((num - 1) % 10) + 1)
	else
		return L("%d Units in Shortcut Group #%d", #group, num)
	end
end

function ShortcutBar:row_on_mouse_wheel(rowui, val)
	ShortcutBar_Row(val >= 0 and 1 or -1)
end

function ShortcutBar:row_on_click(rowui, btn)
	ShortcutBar_Row(btn.child_index == 3 and -1 or 1)
end

function ShortcutBar:group_tooltip(btn)
	local num = btn.num
	local group = shortcut_groups and shortcut_groups[num]
	if #group == 1 and group[1].exists then return BuildDefinitionTooltip(group[1].def, { entity = group[1] }) end
	return ShortcutBar_Title(group, num)
end

function ShortcutBar:on_click_shortcut(btn, key)
	local num = btn.num
	if key ~= "RIGHTMOUSEBUTTON" then
		ShortcutBar_DoSelect(num)
		return
	end

	UI.MenuPopup([[<Box padding=5><VerticalList>
			<Text id=title textalign=center margin_bottom=5/>
			<Button id=ctrlshift on_click={on_ctrlshift}/>
			<Button id=shift     on_click={on_shift}    />
			<Button id=ctrl      on_click={on_ctrl}     />
			<Button id=select    on_click={on_select}   />
			<Button id=camera    on_click={on_camera}   text="Move Camera to Group"/>
			<Button id=clear     on_click={on_clear}    text="Remove Shortcut Group"/>
			<Button id=icon      on_click={on_icon}     text="Set Group Icon"/>
		</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			local group = shortcut_groups and shortcut_groups[num] or {}
			local do_refresh = ShortcutBar_FilterEntities(group, num)
			if do_refresh then self:refresh() end
			local selected = View.GetSelectedEntities() or {}
			ShortcutBar_FilterEntities(selected)
			local selected_in_group = array_contains(group, selected)
			local group_in_selected = array_contains(selected, group)
			local equal = selected_in_group and group_in_selected
			local show_modify = #selected > 0 and not equal

			local key_action = string.format("Select%d", (num % 10))
			menu.title.text = ShortcutBar_Title(group, num)
			menu.ctrlshift.text = L('%s (%S+%S+<Key action="%S"/>)', selected_in_group and "Remove Selection from Group" or "Add Selection to Group", "Ctrl", "Shift", key_action)
			menu.shift.text = L('%s (%S+<Key action="%S"/>)', group_in_selected and "Remove Group from Selection" or "Add Group to Selection", "Shift", key_action)
			menu.ctrl.text = L('%s (%S+<Key action="%S"/>)', "Overwrite Group with Selection", "Ctrl", key_action)
			menu.select.text = L('%s (<Key action="%S"/>)', equal and "Move Camera to Group" or "Select Group", key_action)

			menu.ctrlshift.hidden = not show_modify
			menu.shift.hidden     = not show_modify
			menu.ctrl.hidden      = not show_modify
			menu.camera.hidden    = equal
		end,
		on_ctrlshift = function(menu) ShortcutBar_DoSelect(num,  true,  true) UI.CloseMenuPopup() end,
		on_shift     = function(menu) ShortcutBar_DoSelect(num, false,  true) UI.CloseMenuPopup() end,
		on_ctrl      = function(menu) ShortcutBar_DoSelect(num,  true, false) UI.CloseMenuPopup() end,
		on_select    = function(menu) ShortcutBar_DoSelect(num, false, false) UI.CloseMenuPopup() end,
		on_camera    = function(menu) ShortcutBar_DoSelect(num, false, false, true) UI.CloseMenuPopup() end,
		on_clear     = function(menu)
			shortcut_groups[num] = nil
			if ShortcutBar_open then
				ShortcutBar_open:refresh()
			end
			UI.CloseMenuPopup()
		end,
		on_icon      = function(menu)
			local function on_set(rsel, val)
				local id = val and val.id
				shortcut_groups[num].icon = id
				btn.img = id and data.all[id].texture or btn.entity.def.texture
				if id then btn.vreg.hidden = true end
			end
			local rsel = ShowRegisterSelection(btn, on_set, nil, nil, { hide_coord_panel = true, hide_number_panel = true, hide_entity_panel = true })
			if rsel then rsel:SetRegister({ id = shortcut_groups[num].icon }) end
		end,
	}, btn)
end

Input.BindAction("Select1", "Pressed", function() ShortcutBar_Select(1) end)
Input.BindAction("Select2", "Pressed", function() ShortcutBar_Select(2) end)
Input.BindAction("Select3", "Pressed", function() ShortcutBar_Select(3) end)
Input.BindAction("Select4", "Pressed", function() ShortcutBar_Select(4) end)
Input.BindAction("Select5", "Pressed", function() ShortcutBar_Select(5) end)
Input.BindAction("Select6", "Pressed", function() ShortcutBar_Select(6) end)
Input.BindAction("Select7", "Pressed", function() ShortcutBar_Select(7) end)
Input.BindAction("Select8", "Pressed", function() ShortcutBar_Select(8) end)
Input.BindAction("Select9", "Pressed", function() ShortcutBar_Select(9) end)
Input.BindAction("Select0", "Pressed", function() ShortcutBar_Select(10) end)
Input.BindAction("ShortcutRowNext", "Pressed", function() ShortcutBar_Row(1) end)
Input.BindAction("ShortcutRowPrev", "Pressed", function() ShortcutBar_Row(-1) end)

function UIMsg.OnLocalFactionChanged(old_faction, new_faction)
	if not ShortcutBar_open then return end
	ShortcutBar_UpdateLocalFaction()
	shortcut_row = 1
	ShortcutBar_open:refresh()
end

function UIMsg.OnEntityRecreate(old_entity, new_entity, update_shortcuts)
	if not update_shortcuts or not shortcut_groups then return end

	local do_refresh

	for _,shortcut_group in pairs(shortcut_groups) do
		for i,e in ipairs(shortcut_group) do
			if e == old_entity then shortcut_group[i] = new_entity do_refresh = true break end
		end
	end

	if do_refresh and ShortcutBar_open then ShortcutBar_open:refresh() end
end
