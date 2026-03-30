local layout<const> =
[[
	<Modal allow_keys=true>
		<VerticalList child_padding=12 margin_top=32 margin_left=8 child_align=left dock=fill>
			<Box bg=popup_box_bg padding=4 blur=true width=350>
				<VerticalList>
					<Box bg=popup_pattern padding=4>
						<VerticalList tooltip={gamesettings_tooltip}>
							<HorizontalList>
								<Image image=icon_small_author color=ui_light margin_right=8/>
								<Text text={versiontxt} valign=center fill=true/>
								<Text text="Version" color=ui_light valign=center/>
							</HorizontalList>
							<HorizontalList id=lastsave>
								<Image image=icon_small_save color=ui_light margin_right=8/>
								<Text id=lastsavetxt valign=center fill=true/>
								<Text text="Since Last Save" color=ui_light valign=center/>
							</HorizontalList>
							<HorizontalList>
								<Image image=icon_small_duration color=ui_light margin_right=8/>
								<Text id=playtimetxt valign=center fill=true/>
								<Text text="Time Played" color=ui_light valign=center/>
							</HorizontalList>
							<HorizontalList>
								<Image image=icon_small_time color=ui_light margin_right=8/>
								<Text id=realtimetxt valign=center fill=true/>
								<Text text="Current Time" color=ui_light valign=center/>
							</HorizontalList>
							<HorizontalList>
								<Image image=icon_small_seed color=ui_light margin_right=8/>
								<Text id=seedtext valign=center margin_right=8/>
								<Button width=28 height=28 icon=icon_copy on_click={on_copyseed} tooltip="Copy to Clipboard"/>
								<Spacer fill=true/>
								<Text text="Seed Value" color=ui_light valign=center/>
							</HorizontalList>
							<Button id=mapsettingbtn on_click={on_mapsettings} text="Change Game Settings" tooltip="Change Game Settings" margin_top=8/>
						</VerticalList>
					</Box>
				</VerticalList>
			</Box>
			<HorizontalList child_padding=12 child_align=top fill=true margin_bottom=8>
				<VerticalList child_padding=12 width=350>
					<Box bg=popup_box_bg padding=8 blur=true>
						<VerticalList id=list valign=center child_padding=4>
							<Button text="Return to Game" on_click={on_ui_cancel} id=closebtn/>
							<Button text="Save Game"      on_click={on_save_game} id=savebtn/>
							<Button text="Load Game"      on_click={on_load_game} id=loadbtn/>
							<Button text="Options"        on_click={on_options} noclicksound=true />
							<Button text="Send Developer Feedback" on_click={on_feedback} noclicksound=true/>
							<Button text="Restart Game"   on_click={on_restart_game} id=restartbtn/>
							<Button text="End Game"       on_click={on_end_game}/>
							<Button text="Quit to Desktop" on_click={on_quit} margin_bottom=20/>
							<Button on_click={on_host_game} id=hostbtn tooltip={tooltip_host}/>
							<Button text="Invite Friend"  on_click={on_invite}    id=invite/>
							<Button text="Switch Faction" on_click={on_switch_faction} id=factionswitch/>
						</VerticalList>
					</Box>
					<Text id=achievementstatus style=rl wrap=true hidden=true/>
					<Box bg=popup_box_bg padding=8 blur=true>
						<VerticalList child_padding=10>
							<Text wrap=true width=330 id=ingametext/>
							<HorizontalList child_padding=15 halign=right>
								<Image width=50 height=50 image="Main/textures/logo/wiki_logo.png"     on_click={open_website} tooltip="Wiki Website"     site=WIKI     color=white on_mouse_enter={siteicon_hover} on_mouse_leave={siteicon_unhover}/>
								<Image width=50 height=50 image="Main/textures/logo/feedback_logo.png" on_click={open_website} tooltip="Feedback Website" site=FEEDBACK color=white on_mouse_enter={siteicon_hover} on_mouse_leave={siteicon_unhover}/>
								<Image width=50 height=50 image="Main/textures/logo/steam_logo.png"    on_click={open_website} tooltip="Steam Store Page" site=STORE    color=white on_mouse_enter={siteicon_hover} on_mouse_leave={siteicon_unhover}/>
								<Image width=50 height=50 image="Main/textures/logo/discord_logo.png"  on_click={open_website} tooltip="Join the Discord" site=DISCORD  color=white on_mouse_enter={siteicon_hover} on_mouse_leave={siteicon_unhover}/>
							</HorizontalList>
						</VerticalList>
					</Box>
				</VerticalList>
				<ScrollList id=multiplayer child_padding=12 margin_bottom=20>
					<Box padding=8 bg=popup_box_bg blur=true>
						<VerticalList child_padding=8>
							<Text id=serverinfo/>
							<Button text="Server Settings" id=serversettingsbtn hidden=true on_click={open_server_settings}/>
						</VerticalList>
					</Box>
					<Box padding=8 bg=popup_box_bg blur=true>
						<VerticalList id=playertable>
							<HorizontalList margin_top=4 child_padding=10>
								<Text text="Player Name" color=ui_light width=250/>
								<Text text="Faction" color=ui_light width=250/>
							</HorizontalList>
							<VerticalList id=players margin_top=8 child_padding=2/>
						</VerticalList>
					</Box>
				</ScrollList>
				<Spacer id=details/>
			</HorizontalList>
		</VerticalList>
	</Modal>
]]

local PlayerRow_layout = [[
	<HorizontalList child_align=center child_padding=10>
		<Text text={player} width=250 clip=true/>
		<Text text={faction} width=250 clip=true/>
		<Button width=24 height=24 icon=icon_deny hidden={hide_kick} disabled={disable_kick} tooltip="Kick/Ban Player" on_click={on_click_kick}/>
	</HorizontalList>
]]

local server_visibility_texts<const> = { "Public", "Friends Only", "Invite Only", "LAN / IP Connect Server", "Joining Disabled" }
local server_visibility_ids<const> = { "PUBLIC", "FRIENDS", "INVITE", "LAN", "LOCKED" }
local new_server_visibility_texts<const> = { "Public", "Friends Only", "Invite Only", "LAN / IP Connect Server" }
local edit_server_visibility_texts<const> = { "Public", "Friends Only", "Invite Only" }

local InGameMenu<const> = {}
UI.Register("InGameMenu", layout, InGameMenu)

function InGameMenu:tooltip_host()
	local netmode = Game.GetNetMode()
	if netmode == "offline" then return "Start hosting a multiplayer session" end
	if netmode == "server"  then return "Already hosting a multiplayer session" end
	if netmode == "client"  then return "Unable to host a multiplayer session while playing on another server" end
end

function InGameMenu:construct()
	local settings, is_client = Map.GetSettings(), (Game.GetNetMode() == "client")
	self.seedtext.text = settings.seed
	self.mapsettingbtn.hidden = is_client
	self.lastsave.hidden = is_client
	self.loadbtn.hidden = is_client
	self.restartbtn.hidden = is_client
	self.hostbtn.hidden = is_client
	if is_client and settings.disable_client_save then
		self.savebtn.disabled = true
		self.savebtn.tooltip = "Saving is not available for players on this server"
	end
	self.versiontxt = L("Version %s", Game.GetVersionString())
	self.ingametext.text = [[For feedback or bug reports use the form on the right or contact us via Discord.]]
	self:refresh_netmode()
	Game.OfflinePause(true)
	self.multiplayer_update_func = function() self:refresh_players() end
	UIMsg:Bind("OnMultiplayerUpdate", self.multiplayer_update_func)
	local achievement_status = Game.GetAchievementStatus()
	if achievement_status then
		local reason =
			(achievement_status == 0 and "Unlocking achievements is not supported in this version of the game") or
			(achievement_status == 1 and "Unlocking achievements is blocked when playing with mods") or
			(achievement_status == 2 and "Unlocking achievements is blocked when the main game data is modified") or
			(achievement_status == 3 and "Unlocking achievements is blocked when running in mod dev mode. Remove -moddev from the launch command arguments to enable them")
		self.achievementstatus.text = L("%s:\n%s", "Achievements Disabled", reason)
		self.achievementstatus.hidden = false
	end
end

function InGameMenu:destruct()
	UIMsg:Unbind("OnMultiplayerUpdate", self.multiplayer_update_func)
	Game.OfflinePause(false)
end

function InGameMenu:btn_selection(btn)
	if self.lastButton then
		self.lastButton.active = false
	end
	if self.lastButton == btn then
		self.lastButton = nil
		self.details:Clear()
		self.multiplayer.hidden = (Game.GetNetMode() == "offline")
		return true
	end
	self.lastButton = btn
	self.lastButton.active = true
	self.multiplayer.hidden = true
end

function InGameMenu:refresh_netmode()
	local mapsettings, netmode = Map.GetSettings(), Game.GetNetMode()
	local mode, showmp, allow_faction_switch = mapsettings.game_mode, (netmode ~= "offline"), mapsettings.allow_faction_switch
	self.hostbtn.text = (netmode == "server" and "Stop Server" or "Start Server")
	self.invite.disabled = not showmp or not Game.CanInviteFriend()
	self.factionswitch.hidden = not allow_faction_switch
	if showmp then
		if self.lastButton then
			-- close current details
			self:btn_selection(self.lastButton)
		end
		local servername, dedicated, visibility = Game.GetMultiplayerSession()
		for i,v in ipairs(server_visibility_ids) do
			if v == visibility then
				visibility = server_visibility_texts[i]
				break
			end
		end
		self.serverinfo.text = L("<header>%s</>\n<hl>%s:</> %s\n<hl>%s:</> %s", "Server Info", "Name", servername, "Visibility", visibility)
		if mode then self.serverinfo.text = L("%s    <hl>%s:</> %s", self.serverinfo.text, "Game Mode", mode) end
		if allow_faction_switch then self.serverinfo.text = L("%s\n<hl>%s:</> %s", self.serverinfo.text, "Allow Faction Switching", "Enabled") end
		if mapsettings.block_unlocked_behaviors then self.serverinfo.text = L("%s\n<hl>%s:</> %s", self.serverinfo.text, "Allow Unlocked Behaviors", "Disabled") end
		if mapsettings.disable_client_save then self.serverinfo.text = L("%s\n<hl>%s:</> %s", self.serverinfo.text, "Allow Client Saving", "Disabled") end
		if dedicated then self.serverinfo.text = L("%s\n<hl>%s</>\n<hl>%s</>", self.serverinfo.text, "This is a dedicated server", mapsettings.run_without_players and "The game continues to run when no one is connected" or "The game will pause when no one is connected") end

		self:refresh_players()
		if Game.IsHostPlayer() then
			self.serversettingsbtn.hidden = false
			self.serverinfo.on_click = function()
				Action.SendFromPlayer("DebugMapStateCheck")
			end
		end
	end
	self.multiplayer.hidden = not showmp
end

function InGameMenu:open_server_settings(btn)
	if btn.active then
		self.details:Clear()
		return
	end
	btn.active = true
	self.details:SetContent([[<Box padding=8 bg=popup_box_bg blur=true><ServerSettings id=server/></Box>]], {
		construct = function(m)
			m.server:Add('<Button text="Apply" on_click={on_apply} margin_top=4/>')
			m.server:edit_active_settings()
			m.hash = Tool.Hash(m.server:get_session_settings_table())
		end,
		destruct = function(m)
			if btn:IsValid() then btn.active = false end
			local cursettings = m.server:get_session_settings_table()
			if m.hash == Tool.Hash(cursettings) then return end
			ConfirmBox("Do you want to apply the modified settings?", function()
				Game.ModifyHostSessionSettings(cursettings)
				if self:IsValid() then self:refresh_netmode() end
			end)
		end,
		on_apply = function(m)
			local cursettings = m.server:get_session_settings_table()
			local hash = Tool.Hash(cursettings)
			if m.hash ~= hash then
				m.hash = hash -- to avoid destruct asking to apply
				Game.ModifyHostSessionSettings(cursettings)
				self:refresh_netmode()
			end
			self.details:Clear()
		end,
	}):TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
end

function InGameMenu:refresh_players()
	self.players:Clear()
	local hide_kick = not Game.IsHostPlayer()
	for _, player in ipairs(Game.GetAllPlayers()) do
		self.players:Add(PlayerRow_layout, { player = NOLOC(player.name), faction = NOLOC(Map.GetFaction(player.faction_id).name), player_id = player.id, hide_kick = hide_kick, disable_kick = player.is_host })
	end
	self.players:Add("<Text textalign=center/>", { text = string.format("%d / %d", #self.players, Game.GetMaxPlayerCount()) })
end

function InGameMenu:on_click_kick(player_row)
	UI.AddLayout('<ConfirmDialog title="Kick Player" body="Do you want to remove this player from the server?"/>', {
		construct = function(w)
			w.ban = w.list:Add('<CheckBox text="Ban Player (lasts until game on server is restarted)" halign=center/>')
		end,
		cancel = function(w) w:RemoveFromParent() end,
		ok = function(w)
			Game.KickPlayer(player_row.player_id, w.ban.check)
			w:RemoveFromParent()
		end,
	}, 99)
end

function InGameMenu:every_frame_update()
	self.playtimetxt.text = Tool.GetTimeDurationStr(Game.GetGameDuration())
	self.lastsavetxt.text = Tool.GetTimeDurationStr(Game.GetTimeSinceSave())
	self.realtimetxt.text = NOLOC(Tool.GetDateStr("%X"))
end

function InGameMenu:on_ui_cancel()
	CloseMainWindowAndPopup()
end

function InGameMenu:on_save_game(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("<LoadSave mode=save/>")
end

function InGameMenu:on_load_game(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("<LoadSave mode=load/>")
end

function InGameMenu:on_options(btn)
	--UI.AddLayout("Options")
	if self:btn_selection(btn) then return end
	self.details:SetContent("Options")
end

function InGameMenu:on_feedback(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent([[<FeedbackForm width=800 input_height=150 nocancel=true info='To send feedback with a screenshot, press <Key action="CaptureFeedbackShot"/> while playing'/>]]):TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
end

function InGameMenu:on_restart_game(btn)
	ConfirmBox("Are you sure you want to restart the current scenario?", function()
		Game.RestartGame()
	end)
end

function InGameMenu:on_end_game(btn)
	ConfirmBox("Are you sure you want to abort the scenario and return to the main menu?", function()
		Game.EndGame()
	end)
end

function InGameMenu:on_quit(btn)
	ConfirmBox("Are you sure you want to abort the scenario and quit to the desktop?", function()
		Game.QuitGame()
	end)
end

function InGameMenu:on_host_game(btn)
	local netmode = Game.GetNetMode()
	if netmode == "offline" then
		if self:btn_selection(btn) then return end
		self.details:SetContent([[
			<Box bg=popup_box_bg padding=4 blur=true>
				<VerticalList id=tabs child_padding=8 width=508>
					<Box bg=popup_pattern padding=12>
						<ServerSettings id=server/>
					</Box>
					<Box bg=popup_additional_bg padding=12>
						<Button text="Start Server" on_click={on_start}/>
					</Box>
				</VerticalList>
			</Box>]], {
			on_start = function(w)
				self:btn_selection(btn) -- close popup
				btn.text = "Starting Server ..."
				btn.disabled = true
				Game.CreateOnlineSession(w.server:get_session_settings_table(), function(success)
					if not success then
						MessageBox("Failed to start server, please check your network connection.", "Network Error")
					end
					if self:IsValid() then self:refresh_netmode() self.hostbtn.disabled = false end
				end)
			end,
		}):TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
	elseif netmode == "server" then
		Game.EndOnlineSession()
		self:refresh_netmode()
	end
end

function InGameMenu:on_invite()
	Game.ShowFriendInviteUI()
end

function InGameMenu:on_switch_faction(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("<Box dock=center bg=popup_box_bg padding=10 blur=true><ScrollList width=200 id=list child_padding=3></ScrollList></Box>", {
		construct = function(widget)
			local playerfaction, player_faction_ids = Game.GetLocalPlayerFaction(), {}
			for _,f in ipairs(Map.GetFactions()) do
				if f.is_player_controlled then
					player_faction_ids[f.id] = true
					widget.list:Add("<Button on_click={on_select}/>", { text = NOLOC(f.name), faction_id = f.id, disabled = (f == playerfaction or f.extra_data.locked) })
				end
			end
			local scenario_pkg = Game.GetScenarioModPackage()
			local new_faction_id_func = scenario_pkg and scenario_pkg.switch_new_player_faction_id
			local new_faction_id = new_faction_id_func and new_faction_id_func(scenario_pkg)
			if not new_faction_id_func then
				for i=2,99999 do
					new_faction_id = "player_" .. i
					if not player_faction_ids[new_faction_id] then break end
				end
			end
			if new_faction_id then
				widget.list:Add("<Button on_click={on_select}/>", { text = "New Faction", faction_id = new_faction_id })
			end
		end,
		on_select = function(widget, faction_btn)
			-- check faction lock
			if Game.GetLocalPlayerFaction().extra_data.locked then
				local player_faction_id = Game.GetLocalPlayerFaction().id
				for _, player in ipairs(Game.GetAllPlayers()) do
					if player.faction_id == player_faction_id and not player.is_local then
						goto has_another_player
					end
				end
				-- last player is switching factions, set it to open
				Action.SendForLocalFaction("SetFactionLock", { lock = false })
				::has_another_player::
			end

			View.SelectEntities({})
			Action.SendFromPlayer("SwitchFaction", { faction_id = faction_btn.faction_id })
			self.lastButton.active = false
			self.lastButton = nil
			self:on_ui_cancel() -- close in game menu after switching faction
		end,
	}):TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
end

function InGameMenu:gamesettings_tooltip()
	local info_box = UI.New("<Box bg=popup_box_bg blur=true padding=8 width=300><VerticalList child_padding=8/></Box>")
	local info_list = info_box[1]
	local settings = Map.GetSettings()
	for _,v in ipairs(UI.GetMapSettingsArray()) do
		local fFillInfoList = v.FillInfoList
		local vl = fFillInfoList and info_list:Add("<VerticalList child_padding=8/>")
		if vl then fFillInfoList(settings, vl) end
	end
	return info_box
end

function InGameMenu:on_mapsettings(btn)
	if self:btn_selection(btn) then return end
	local function check(m)
		local old = Map.GetSettings()
		local new = Tool.Copy(old)
		for _,w in ipairs(m.lst) do w.fFillSettings(new, w, true) end
		if Tool.Hash(old) ~= Tool.Hash(new) then return old, new end
	end
	local function apply(old, new)
		local tbl, n = {}, 1
		for k,v in pairs(old) do if new[k] == nil                     then tbl[n], tbl[n+1], n = k, nil, n + 2 end end
		for k,v in pairs(new) do if Tool.Hash(v) ~= Tool.Hash(old[k]) then tbl[n], tbl[n+1], n = k,   v, n + 2 end end
		Map.ModifySettings(tbl)
	end
	self.details:SetContent([[<Box padding=8 bg=popup_box_bg blur=true width=500><VerticalList child_padding=8><VerticalList id=lst child_padding=4/><Button text="Apply" on_click={on_apply}/></VerticalList></Box>]], {
		construct = function(m)
			local settings = Map.GetSettings()
			for _,v in ipairs(UI.GetMapSettingsArray()) do
				local fFillInputList, fFillSettings = v.FillInputList, v.FillSettings
				local vl = fFillInputList and fFillSettings and m.lst:Add("<VerticalList child_padding=4/>", { fFillSettings = fFillSettings })
				if vl then fFillInputList(settings, vl, true) end
			end
		end,
		destruct = function(m)
			local old, new = check(m)
			if new then ConfirmBox("Do you want to apply the modified settings?", function() apply(old, new) end) end
		end,
		on_apply = function(m)
			local old, new = check(m)
			if new then apply(old, new) end
			self:btn_selection(btn)
		end,
	}):TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
end

function InGameMenu:on_copyseed(hl)
	Tool.SetClipboard(tostring(Map.GetSettings().seed), "")
	MessagePopup(hl, "Copied seed to clipboard")
end

function InGameMenu:open_website(img)
	Game.OpenWebsite(img.site)
end

function InGameMenu:siteicon_hover(img)
	img.color = "ui_light"
end

function InGameMenu:siteicon_unhover(img)
	img.color = "white"
end

---------------------------------------------------------------------------------------------------------------------------

local FeedbackForm_layout<const> =
[[
<VerticalList child_padding=12>
	<Box bg=popup_box_bg padding=8 blur=true>
		<Canvas>
			<VerticalList child_padding=12 fill=true>
				<Text style=header text="Send Developer Feedback" halign=center/>
				<Text halign=center text="All feedback is publicly visible"/>
				<Combo id=category/>
				<Text id=usemods textalign=center wrap=true text="Reminder: Mods are currently in use, which may not be supported"/>
				<MultiLineInputText id=fbtxt height={input_height} hint="Suggestions, bug reports or other issues, feel free to share any kind of feedback!" fill=true on_change={on_feedback_change} on_commit={on_feedback_change}/>
				<CheckBox id=fbchk text="Attach a save game of the current state of the game"/>
				<Text halign=center text={info}/>
				<Image halign=center image={ssimg} width={ssw} height={ssh} hide_no_image=true/>
				<VerticalList id=fbbtns child_padding=4 height=0 clip=true>
					<HorizontalList child_padding=10 halign=center>
						<Button id=rating5 on_click={on_click_face} opacity=0.5 on_mouse_enter={sethover} on_mouse_leave={setunhover} rating=5 tooltip="Very Happy"><Image image="Main/skin/Icons/Special/Rating/Grinning.png"/></Button>
						<Button id=rating4 on_click={on_click_face} opacity=0.5 on_mouse_enter={sethover} on_mouse_leave={setunhover} rating=4 tooltip="Happy"><Image image="Main/skin/Icons/Special/Rating/Happy.png"/></Button>
						<Button id=rating2 on_click={on_click_face} opacity=0.5 on_mouse_enter={sethover} on_mouse_leave={setunhover} rating=2 tooltip="Unhappy"><Image image="Main/skin/Icons/Special/Rating/Sad.png"/></Button>
						<Button id=rating1 on_click={on_click_face} opacity=0.5 on_mouse_enter={sethover} on_mouse_leave={setunhover} rating=1 tooltip="Very Unhappy"><Image image="Main/skin/Icons/Special/Rating/Angry.png"/></Button>
					</HorizontalList>
					<Text halign=center text="Click on an expression to send the feedback"/>
				</VerticalList>
				<HorizontalList halign=right child_padding=5>
					<Spacer fill=true/>
					<Button width=162 id=sendbtn text="Send Feedback" on_click={on_click_send} hidden=true/>
					<Button width=162 text="Feedback Site" on_click={open_website} site=FEEDBACK/>
					<Button width=162 text="Cancel" on_click={on_cancel} hidden={nocancel}/>
				</HorizontalList>
			</VerticalList>
			<Throbber dock=center id=fbthrob hidden=true/>
		</Canvas>
	</Box>
	<Box id=subbox hidden=true bg=popup_box_bg padding=8>
		<HorizontalList child_padding=8>
			<Text valign=center text="Previous submissions:"/>
			<Combo id=submissions text="Submissions" combo_height=600 width=200/>
			<Button icon=icon_remove height=36 on_click={on_remove_submission}/>
			<Button text="View Submission Status" on_click={on_view_submission} fill=true/>
		</HorizontalList>
	</Box>
</VerticalList>
]]

local feedback_categories = { "General", "Bug", "Suggestion", "Performance" }
local FeedbackForm<const> = {}
UI.Register("FeedbackForm", FeedbackForm_layout, FeedbackForm)

function FeedbackForm:construct()
	self.fbtxt.text = FeedbackForm.last_text or ""
	self.in_use = (FeedbackForm.last_text or "") ~= ""
	self.fbbtns:TweenTo("height", self.in_use and 96 or 0, 200)
	local texts = {}
	for i,v in ipairs(feedback_categories) do texts[i] = L("%s: %s", "Category", v) end
	self.category.texts, self.category.value = texts, 1
	if Game.GetNetMode() == "client" and Map.GetSettings().disable_client_save then
		self.fbchk.disabled = true
		self.fbchk.tooltip = "Saving is not available for players on this server"
	end
	local use_mods
	for i,mod in ipairs(Game.GetInstalledMods()) do if mod.is_loaded and mod.id ~= "Main" then use_mods = true break end end
	self.usemods.hidden = not use_mods
	self:refresh_submissions()
end

function FeedbackForm:refresh_submissions()
	local feedback, feedback_ids = Game.GetProfile().feedback
	if feedback then
		for id,state in pairs(feedback) do
			if state ~= 0 then -- not removed
				feedback_ids = feedback_ids or {}
				feedback_ids[#feedback_ids+1] = id
			end
		end
	end
	if not feedback_ids then
		self.subbox.hidden = false
	else
		table.sort(feedback_ids, function(a,b) return a > b end)
		local texts = {}
		for _,id in ipairs(feedback_ids) do
			texts[#texts+1] = string.format("%d%s", id, (feedback[id] >= 2 and "*" or "")) -- mark replied with *
		end
		self.subbox.hidden = false
		self.feedback_ids = feedback_ids
		self.submissions.texts = texts
		self.submissions.value = 1
	end
end

function FeedbackForm:sethover(btn)
	btn.opacity = 1
end

function FeedbackForm:setunhover(btn)
	if self.rating ~= btn.rating then
		btn.opacity = 0.5
	end
end

function FeedbackForm:on_view_submission()
	Game.OpenWebsite("FEEDBACK", self.feedback_ids[self.submissions.value])
end

function FeedbackForm:on_remove_submission()
	local selected_id = self.feedback_ids[self.submissions.value]
	local feedback = Game.GetProfile().feedback
	feedback[selected_id] = 0  -- set removed
	self:refresh_submissions()
end

function FeedbackForm:open_website(img)
	Game.OpenWebsite(img.site)
end

function FeedbackForm:destruct()
	FeedbackForm.last_text = self.fbtxt.text or ""
end

function FeedbackForm:on_feedback_change(input, value)
	local in_use = value and value ~= ""
	if self.in_use == in_use then return end
	self.in_use = in_use
	self.fbbtns:TweenTo("height", in_use and 96 or 0, 200)
end

function FeedbackForm:on_click_face(btn)
	if self.rating then self["rating" .. self.rating].opacity = 0.5 end
	self.rating = btn.rating
	btn.opacity = 1
	self.sendbtn.hidden = false
end

function FeedbackForm:on_click_send(sendbtn)
	self.disabled = true
	self.fbthrob.hidden = false
	Game.SendFeedback(self.rating, feedback_categories[self.category.value], self.fbtxt.text, self.fbchk.check, self.sendscreenshot, function(success, response_id)
		if success then
			MessageBox("We received your feedback.\n\nThank you for helping us to make the game better!", "Feedback Submitted")
			local profile = Game.GetProfile()
			if not profile.feedback then profile.feedback = {} end
			profile.feedback[tonumber(response_id)//1] = 1 -- new without reply yet
			self:refresh_submissions()
		else
			MessageBox("Feedback could not be submitted.\n\nPlease check your internet connection.", "Network Error")
		end
		if not self:IsValid() then return end
		self.disabled = false
		self.fbthrob.hidden = true
		if success then
			self.fbtxt.text = ""
			self.fbchk.check = false
			self.in_use = false
			self.fbbtns:TweenTo("height", 0, 200)
			self:SendEvent("on_ok")
		end
	end)
end

function UIMsg.OnFeedbackShotCaptured(w, h, bytes)
	Game.OfflinePause(true)
	UI.AddLayout([[<Modal><FeedbackForm dock=top width=1200 input_height=250 margin_top=100 sendscreenshot=true ssimg="$Feedback" ssw={ssw} ssh={ssh} info={info} on_ok={close} on_cancel={on_ui_cancel}/></Modal>]], {
		ssw = 240/h*w//1, ssh = 240,
		info = L("Attaching Screenshot (Resolution: %dx%d, Size: %d bytes)", w, h, bytes),
		on_ui_cancel = function(fb) fb:RemoveFromParent() Game.OfflinePause(false) end,
	}, 99)
end

---------------------------------------------------------------------------------------------------------------------------

local ServerSettings_layout<const> =
[[
	<VerticalList child_padding=4 min_width=500>
		<Text color=ui_light text="Server Settings:" margin_bottom=5/>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Server Name"/>
			<InputText id=name/>
		</HorizontalList>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Visibility"/>
			<Combo id=visibility on_change={on_visibility_change}/>
		</HorizontalList>
		<HorizontalList child_align=center hidden=true child_fill=true>
			<Text text="Server Port"/>
			<InputText id=serverport text=10099 on_change={on_num_change} on_commit={on_num_commit} default=10099 min=1 max=65535/>
		</HorizontalList>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Max Players"/>
			<InputText id=players text=16 on_change={on_num_change} on_commit={on_num_commit} default=16 min=2 max=999/>
		</HorizontalList>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Password"/>
			<InputText id=password password=true/>
		</HorizontalList>
		<Text color=ui_light text="Server Rules:" margin_top=8 margin_bottom=5/>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Game Mode"/>
			<Combo id=mode/>
		</HorizontalList>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Allow Faction Switching"/>
			<Combo id=allow_faction_switch/>
		</HorizontalList>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Allow Unlocked Behaviors"/>
			<Combo id=allow_unlocked_behaviors/>
		</HorizontalList>
		<HorizontalList child_align=center child_fill=true>
			<Text text="Allow Client Saving"/>
			<Combo id=allow_client_save/>
		</HorizontalList>
		<HorizontalList child_align=center hidden=true child_fill=true>
			<Text text="Allow New Players Joining"/>
			<Combo id=allow_join/>
		</HorizontalList>
	</VerticalList>
]]

local ServerSettings<const> = {}
local yes_no_labels = { "Yes", "No" }
UI.Register("ServerSettings", ServerSettings_layout, ServerSettings)

function ServerSettings:construct()
	self.name.text = NOLOC(L("%S's Server", Game.GetPlayerName()))
	self.visibility.texts, self.visibility.value = new_server_visibility_texts, 2
	self.allow_join.texts, self.allow_join.value = yes_no_labels, 1
	self.allow_faction_switch.texts, self.allow_faction_switch.value = yes_no_labels, 2
	self.allow_unlocked_behaviors.texts, self.allow_unlocked_behaviors.value = yes_no_labels, 1
	self.allow_client_save.texts, self.allow_client_save.value = yes_no_labels, 1
	if not Game.OnlineHaveLobbies() then
		self.visibility.value  = 4 -- force LAN
		self.visibility.parent.hidden = true
		self.serverport.parent.hidden = false
	end
end

function ServerSettings:render()
	local pkg = (self.scenario and Game.GetInstalledModPackage(self.scenario) or Game.GetScenarioModPackage())
	self.mode.parent.hidden, self.mode.texts, self.mode.value = not pkg.modes or #pkg.modes == 0, pkg.modes, self.mode.value or 1
end

function ServerSettings:edit_active_settings()
	self:render() -- refresh mode.texts
	self.name.parent.hidden = true
	self.visibility.texts = edit_server_visibility_texts
	self.serverport.parent.hidden = true
	self.password.parent.hidden = true
	self.allow_join.parent.hidden = false

	local host_settings = Game.GetHostSessionSettings()
	local visibility, mode = host_settings.visibility, host_settings.mode

	for i,v in ipairs(self.visibility.texts) do if server_visibility_ids[i] == visibility then self.visibility.value = i break end end
	self.players.text = tostring(host_settings.players or 16)
	for i,v in ipairs(self.mode.texts) do if v == mode then self.mode.value = i break end end
	self.allow_join.value = host_settings.block_join and 2 or 1
	self.allow_faction_switch.value = host_settings.allow_faction_switch and 1 or 2
	self.allow_unlocked_behaviors.value = host_settings.block_unlocked_behaviors and 2 or 1
	self.allow_client_save.value = host_settings.disable_client_save and 2 or 1
end

function ServerSettings:on_visibility_change(combo, value)
	self.serverport.parent.hidden = (value ~= 4)
end

function ServerSettings:on_num_change(input, value)
	local n = math.min(math.max(tonumber(string.gsub(value, "%D", ""), 10) or 0, 0), input.max)
	input.text = (n == 0 and "" or tostring(n))
end

function ServerSettings:on_num_commit(input, value)
	input.text = tostring(math.min(math.max(tonumber(string.gsub(value, "%D", ""), 10) or input.default, input.min), input.max))
end

function ServerSettings:get_session_settings_table()
	local pw, vis, mode = self.password.text, self.visibility.value, self.mode.value
	pw = pw and pw ~= "" and pw or nil
	mode = self.mode.texts and self.mode.texts[mode]
	return {
		name       = self.name.text,
		mode       = mode and mode ~= "" and mode or nil,
		visibility = server_visibility_ids[vis],
		players    = math.min(math.max(tonumber(string.gsub(self.players.text, "%D", ""), 10) or 0, 2), 999),
		password   = pw,
		serverport = vis == 4 and tonumber(string.gsub(self.serverport.text, "%D", ""), 10),
		block_join = self.allow_join.value == 2 or nil,
		allow_faction_switch = self.allow_faction_switch.value == 1 or nil,
		block_unlocked_behaviors = self.allow_unlocked_behaviors.value == 2 or nil,
		disable_client_save = self.allow_client_save.value == 2 or nil,
	}
end

---------------------------------------------------------------------------------------------------------------------------

function MultiplayerJoinSession(ask_password, session_index_or_host, password)
	if ask_password then
		InputBox("Enter the password to connect to the server", "Password",
			function (t) if t == "" then return false end MultiplayerJoinSession(false, session_index_or_host, t) end,
			"", true)
		return
	end
	local wait = UI.AddLayout([[<Modal><Modal><Modal><VerticalList dock=center child_padding=48>
			<Text text="Please Wait" textalign=center size=16/>
			<Throbber halign=center width=64 height=64/>
			<Text text="Joining Session ..." textalign=center size=16/>
		</VerticalList></Modal></Modal></Modal>]], 99)
	Game.JoinOnlineSession(session_index_or_host, password, function(success)
		if success then return end
		wait:RemoveFromParent()
		MessageBox("Please check your network connection.", "Network Error")
	end)
end

function UIMsg.OnSessionInvite(use_password)
	ConfirmBox("Do you want to end the game to join the multiplayer game?\n\nAny unsaved progress will be lost.",
		function() MultiplayerJoinSession(use_password) end)
end

-- Debug functionality for checking if all clients are still in sync
function PlayerAction.DebugMapStateCheck(player_id, faction, arg)
	UI.Run(function()
		if arg then print("[DebugMapStateCheck] Player "..Game.GetPlayerName(player_id).." hashes: ", arg[1], arg[2]) return end
		if not Game.IsHostPlayer(player_id) then return end
		local n1, n2 = Debug.GetMapStateHash()
		print("[DebugMapStateCheck] Sending hashes: ", n1, n2)
		Action.SendFromPlayer("DebugMapStateCheck", { n1, n2 })
	end)
end
