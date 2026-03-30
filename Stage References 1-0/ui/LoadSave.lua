local LoadSave_layout<const> =
[[
	<HorizontalList child_padding=12 child_align=top>
		<Box padding=10 bg=popup_box_bg blur=true>
			<VerticalList child_padding=10>
				<TextSearch id=search on_refresh={on_filter}/>
				<ScrollList child_padding=2 id=list width=300 fill=true/>
			</VerticalList>
		</Box>
		<Spacer id=gamedetail/>
	</HorizontalList>
]]

local detail_layout<const> =
[[
	<Box padding=8 bg=popup_box_bg blur=true width=480>
		<ScrollList child_padding=4>
			<Image width=480 height=270 halign=center image={image}/>
			<HorizontalList hidden={isnewsave}>
				<Text text="Name:" color=ui_light margin_right=5/>
				<Text text={save_title_txt}/>
			</HorizontalList>
			<HorizontalList hidden={isnewsave}>
				<Text text="Saved:" color=ui_light margin_right=5/>
				<Text text={save_time} fill=true/>
				<Text text={save_version}/>
			</HorizontalList>
			<HorizontalList>
				<Text text="Time Played:" color=ui_light margin_right=5/>
				<Text text={save_time_played} fill=true/>
				<Text text={save_scenario}/>
			</HorizontalList>
			<HorizontalList margin_top=10 child_align=bottom>
				<VerticalList fill=true child_padding=4 hidden={hidesave} margin_right=4>
					<Text text="Name:" color=ui_light/>
					<InputText text={save_title} on_enter={on_click_save} id=text_title height=36/>
				</VerticalList>
				<Button width=36 height=36 on_click={on_click_options} tooltip="Options" icon=icon_menu hidden={hidesave} id=optionsbtn margin_right=4/>
				<HorizontalList fill=true hidden={hideload} child_padding=4>
					<Button width=36 height=36 on_click={on_click_delete} tooltip="delete"><Image color=light_red image=icon_remove/></Button>
					<Button width=36 height=36 on_click={on_click_rename} tooltip="Rename" icon=icon_rename/>
					<Button width=36 height=36 on_click={on_click_replay} tooltip="Replay" icon=icon_replay hidden={hidereplay} disabled={disablereplay}/>
				</HorizontalList>
				<Button icon=icon_play on_click={on_click_load} tooltip="Play" hidden={hideload}/>
				<Button icon=icon_save on_click={on_click_save} tooltip="Save" hidden={hidesave}/>
			</HorizontalList>
			<ServerSettings id=server margin_top=10 hidden={hideserver}/>
		</ScrollList>
	</Box>
]]

local LoadSave<const> = {}
UI.Register("LoadSave", LoadSave_layout, LoadSave)

function LoadSave:construct()
	self:TweenFromTo("sy", 0.001, 0.01, 1, "OutQuad", function(w) w:TweenFromTo("sy", 0.01, 1, 80, "OutQuad") end)
	self:Refresh()
	if self.list[1] ~= nil then
		self:on_click_item(self.list[1])
	end

	UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN")
end

function LoadSave:on_ui_accept()
	if self.selected and self.mode == "save" then self:on_click_save() return end
	if self.selected and self.mode ~= "save" then self:on_click_load(true) return end
	return false
end

function LoadSave:Refresh(select_slot_name)
	self.selected = nil
	self.gamedetail:Clear()
	self.list:Clear()
	if self.mode == "save" then
		self.list:Add('<Button on_click={on_click_item} on_double_click={on_double_click_item} text="[Save New]"/>')
	end
	local selectbtn
	for i, v in ipairs(Game.GetSaveGameList()) do
		local auto_save_number = v.save_title:match("^Auto Save (%d+)$")
		local show_name = (auto_save_number and L("%s %d", "Auto Save", auto_save_number) or NOLOC(v.save_title))
		local btn = self.list:Add("<Button on_click={on_click_item} on_double_click={on_double_click_item}/>", { text = show_name, data = v })
		if select_slot_name and select_slot_name == v.slot_name then selectbtn = btn end
	end
	if (self.search.inp.text or "") ~= "" then
		self:on_filter(self.search, self.search.inp.text)
	end
	if selectbtn then self:on_click_item(selectbtn) end
end

function LoadSave:on_filter(search, filter)
	if not filter or filter=="" then
		for _,btn in ipairs(self.list) do
			btn.hidden = false
		end
		return
	end

	if filter == "" then filter = nil end
	local ContainsStringNoCase = filter and Tool.ContainsStringNoCase
	for _,btn in ipairs(self.list) do
		btn.hidden = true
		local foundname = filter and ContainsStringNoCase(L(btn.text or ""), filter)
		local foundtext = filter and btn.def and ContainsStringNoCase(L(btn.def.text or ""), filter)
		if not filter or foundname or foundtext then
			btn.hidden = false
		end
	end
end

function LoadSave:on_double_click_item(button)
	if self.selected ~= button then self:on_click_item(button) end
	if self.selected and self.mode == "save" then self:on_click_save() return end
	if self.selected and self.mode ~= "save" then self:on_click_load(true) return end
end

function LoadSave:on_click_item(button)
	if self.selected then
		self.selected.active = false
	end
	if self.selected == button then
		self.selected = nil
		self.gamedetail:Clear()
		return
	end
	self.selected = button
	button.active = true
	local data, detail = button.data
	if data then
		local modpack = Game.GetInstalledModPackage(data.scenario)
		detail = self.gamedetail:SetContent(detail_layout, {
			image = "$SaveGameImage/" .. data.slot_name,
			save_title_txt = button.text,
			save_title = data.save_title,
			save_time = NOLOC(Tool.GetDateStr(data.save_time, "%x %X")),
			save_version = data.version and data.version > 0 and string.format("%d.%d.%d", (data.version>>48), (data.version>>32&0xffff), (data.version&0xffffffff)) or "",
			save_time_played = Tool.GetTimeDurationStr(data.game_duration),
			--save_time_played = tostring(math.floor(data.game_duration * TICKS_PER_SECOND + 0.5)), -- show as tick count
			save_scenario = modpack and modpack.name or data.scenario,
			hideserver = (self.mode ~= "hostload"),
			hidesave = (self.mode ~= "save"),
			hideload = (self.mode == "save"),
			hidereplay = (self.mode == "hostload"),
			disablereplay = not data.has_replay,
		})
		detail.server.scenario = data.scenario
	else
		local scenario = Map.GetSettings().scenario
		local modpack = Game.GetInstalledModPackage(scenario)
		detail = self.gamedetail:SetContent(detail_layout, {
			image = "$ScreenShot", isnewsave = true, hideserver = true, hideload = true,
			save_title = LoadSave.GetDefaultSaveTitle(),
			save_time_played = Tool.GetTimeDurationStr(Game.GetGameDuration()),
			save_scenario = modpack and modpack.name or scenario,
		})
	end
	if self.mode == "save" then
		self.recording_active, self.have_snapshot, self.replay_size, self.snapshot_size, self.snapshot_time, self.snapshot_optional = Action.GetReplayRecordingState()
		self.set_recording_active, self.set_have_snapshot = self.recording_active, self.have_snapshot
		detail.optionsbtn.hidden = Action.IsReplayPlayback()
	end
end

function LoadSave:on_click_options(detail, btn)
	UI.MenuPopup([[<Box padding=5><VerticalList child_padding=4>
		<CheckBox id=chkreplay text="Store Replay Data" on_change={on_change_replaydata} tooltip="Store a history of player inputs to enable replay playback"/>
		<CheckBox id=chksnapshot text="Store Replay Snapshot" on_change={on_change_snapshot} tooltip="Store a snapshot of the state from when the game or a mod was last updated (without it replay playback likely goes out of sync)"/>
		</VerticalList></Box>]], {
		construct = function(menu)
			menu:TweenFromTo("sy", 0, 1, 100)
			if self.recording_active then
				menu.chkreplay.text = L("%s (~ %.1f %S%S)", menu.chkreplay.text, self.replay_size / 1024.0, "M", "B")
			end
			if self.have_snapshot then
				menu.chksnapshot.text = L("%s (~ %.1f %S%S @ %S)", menu.chksnapshot.text, self.snapshot_size / 1024.0, "M", "B", Tool.GetTimeDurationStr(self.snapshot_time))
			end
			menu:refresh()
		end,
		refresh = function(menu)
			menu.chkreplay.check = self.set_recording_active
			menu.chksnapshot.check = self.set_recording_active and (self.set_have_snapshot or not self.recording_active)
			menu.chksnapshot.disabled = not self.have_snapshot or not self.set_recording_active or not self.snapshot_optional
		end,
		on_change_replaydata = function(menu, chk, check) self.set_recording_active = check menu:refresh() end,
		on_change_snapshot = function(menu, chk, check) self.set_have_snapshot = check end,
	}, btn, "DOWN")
end

function LoadSave:on_click_save()
	local save_title = self.gamedetail:GetChild().text_title.text
	if save_title == "" then
		MessageBox("Save name missing")
		return
	end

	local overwrite, slotname = self.selected.data ~= nil
	local savetitle = overwrite and self.selected.data.save_title
	if save_title ~= savetitle then -- different name or new save, check if there are no existing slots with that name
		overwrite = false
		for i, v in ipairs(Game.GetSaveGameList()) do
			if save_title == v.save_title then
				savetitle = v.save_title
				slotname = v.slot_name
				overwrite = true -- found one with the same name
				break
			end
		end
	end

	if overwrite then
		local msg = "Are you sure you want to overwrite this save game?"
		if not slotname then slotname = self.selected.data.slot_name end
		if Game.IsSaveGameOldVersion(slotname) then
			msg = L("%s\n\n%s", msg, "Note: This save game was made with an older version (of the game or a mod) and this new save will not be backwards compatible with that version.")
		end
		ConfirmBox(msg, function()
			self:SaveToSlot(savetitle, slotname)
		end)
	else
		self:SaveToSlot(save_title)
	end
end

function LoadSave:SaveToSlot(save_title, slot_name)
	if self.set_recording_active ~= self.recording_active or self.set_have_snapshot ~= self.have_snapshot then
		Action.SetReplayRecordingState(self.set_recording_active, self.set_have_snapshot)
	end

	slot_name = Game.SaveGame(save_title, slot_name)
	if not slot_name then
		MessageBox("Error during save operation")
		return
	end
	Game.GetProfile().latest_save = slot_name
	Game.GetProfile().latest_session_settings = Game.GetHostSessionSettings()
	self:Refresh(slot_name)
	MessageBox("Game Saved")
end

function LoadSave:on_click_load(confirm)
	if confirm and not Map.IsFrontEnd() then
		ConfirmBox("Are you sure you want to load this save game?", function() self:on_click_load() end)
	else
		local session_settings = self.mode == "hostload" and self.gamedetail:GetChild().server:get_session_settings_table()
		DoLoadSaveGame(self.selected.data.slot_name, session_settings)
	end
end

function LoadSave:on_click_replay(confirm)
	if confirm and not Map.IsFrontEnd() then
		ConfirmBox("Are you sure you want to load this save game?", function() self:on_click_replay() end)
	else
		if not Game.ReplayGame(self.selected.data.slot_name) then
			MessageBox("Error during load operation")
		end
	end
end

function LoadSave:on_click_rename()
	InputBox("Enter a new name for this save game", "Rename", function (t)
		if t == "" then
			MessageBox("Name can't be empty")
			return false
		end
		local old_slot_name = self.selected.data.slot_name
		if old_slot_name == t then return end -- didn't change
		local new_slot_name = Game.RenameGame(old_slot_name, t)
		if not new_slot_name then
			MessageBox("Error during rename operation")
			return false
		end
		if Game.GetProfile().latest_save == old_slot_name then
			Game.GetProfile().latest_save = new_slot_name
		end
		self:Refresh(new_slot_name)
		MessageBox("Save Game Renamed")
	end, self.selected.data.slot_name)
end

function LoadSave:on_click_delete()
	ConfirmBox("Are you sure you want to delete this save game?", function()
		local slot_name = self.selected.data.slot_name
		if not Game.DeleteGame(slot_name) then
			MessageBox("Error during delete operation")
			return
		end
		if Game.GetProfile().latest_save == slot_name then
			Game.GetProfile().latest_save = nil
		end
		self:Refresh()
		MessageBox("Save Game Deleted")
	end)
end

function LoadSave.GetDefaultSaveTitle()
	local sce = Map.GetSettings().scenario
	local dt = Tool.GetDateStr("%Y-%m-%d %H.%M.%S")
	--return sce:sub(sce:find('/')+1, -1) .. " " .. dt:sub(0, -3)
	return sce:sub(sce:find('/')+1, -1) .. " " .. dt
end

function DoLoadSaveGame(slot_name, session_settings)
	local packages, scenario_error, ask_mods, cant_play_as_is = Game.GetSaveGameModPackages(slot_name)
	for i,v in ipairs(packages) do
		if v.now_disabled or v.now_enabled then
			ask_mods = true
		end
		if     v.error_missing      then v.errmsg = "The package is now missing"
		elseif v.error_dependencies then v.errmsg = "The package is missing another base mod package"
		elseif v.error_version      then v.errmsg = "The package has an older version installed than what was saved with"
		end
		if v.errmsg then
			if v.is_scenario then scenario_error = v end
			if v.now_disabled then cant_play_as_is = true end
		end
	end

	if scenario_error then
		MessageBox(L("Failed to load scenario package '%S' of mod '%S'.\nError: %s",
			scenario_error.name, scenario_error.mod_name, scenario_error.errmsg))
		return
	end

	if not ask_mods or View.IsRunningHeadless() then
		if not Game.LoadGame(slot_name, session_settings or nil) then
			MessageBox("Error during load operation")
		end
		return
	end

	local saved, active
	for i,v in ipairs(packages) do
		if not v.is_scenario then
			local info = L("Addon '%S' of Mod '%S'", v.name, v.mod_name)
			if v.errmsg then info = L("%s (Error: %s)", info, v.errmsg) end
			if not v.now_enabled  then saved  = L("%s%S%s", saved or "", saved and "\n\n" or "", info) end
			if not v.now_disabled then active = L("%s%S%s", active or "", active and "\n\n" or "", info) end
		end
	end

	UI.AddLayout([[<Modal><Box bg=popup_box_bg blur=true dock=center padding=24><VerticalList child_padding=48>
			<Text text="The list of currently active mods is different from what was used when the game was saved." size=16 textalign=center margin_top=24/>
			<HorizontalList child_padding=24>
				<Box bg=popup_box_bg padding=4>
					<VerticalList>
						<Box bg=popup_pattern padding=24 fill=true><ScrollList max_height=600><Text text={saved} width=540 wrap=true textalign=center/></ScrollList></Box>
						<Box bg=popup_additional_bg padding=12><Button on_click={on_load} reset_mods=false icon=icon_confirm text="Play with Mods from Save" disabled={disabledsaved}/></Box>
					</VerticalList>
				</Box>
				<Box bg=popup_box_bg padding=4>
					<VerticalList>
						<Box bg=popup_pattern padding=24 fill=true><ScrollList max_height=600><Text text={active} width=540 wrap=true textalign=center/></ScrollList></Box>
						<Box bg=popup_additional_bg padding=12><Button on_click={on_load} reset_mods=true icon=icon_confirm text="Play with Active Mods"/></Box>
					</VerticalList>
				</Box>
			</HorizontalList>
			<Button id=cancelbtn on_click={on_cancel} icon=icon_deny text="Cancel"/>
		</VerticalList></Box></Modal>]], {
		saved = saved or "No Mods", active = active or "No Mods", disabledsaved = cant_play_as_is,
		on_cancel = function(w) w:RemoveFromParent() end,
		on_load = function(w, btn)
			if not Game.LoadGame(slot_name, session_settings or nil, btn.reset_mods) then
				MessageBox("Error during load operation")
			end
		end,
	}, 99)
end
