local layout =
[[
	<HorizontalList child_padding=12 child_align=top>
		<Box bg=popup_box_bg blur=true padding=10>
			<VerticalList child_padding=4>
				<HorizontalList child_fill=true child_padding=4>
					<Button id=newgame on_click={on_host_new} text="Host New Game" textwrap=true width=220/>
					<Button id=loadgame on_click={on_host_load} text="Host Load Game" textwrap=true width=220/>
				</HorizontalList>
				<HorizontalList child_fill=true>
					<Button on_click={on_search} text="Find LAN Games" textwrap=true width=220 id=refreshlanbtn margin_right=4/>
					<Button on_click={on_connect_ip} text="Connect to IP..." textwrap=true width=220/>
				</HorizontalList>
				<HorizontalList child_fill=true child_padding=4>
					<Button id=refreshbtn on_click={on_search} icon=icon_refresh text="Refresh List"/>
					<Button id=join on_click={on_join} icon=icon_play text="Join Game"/>
				</HorizontalList>
				<Text text="Sessions:" color=ui_light/>
				<VerticalList min_height=64>
					<Throbber id=throbber halign=center hidden=true/>
					<ScrollList id=sessions max_height=400/>
					<TextSearch margin_top=5 id=session_filter on_refresh={on_session_filter} hidden=true/>
				</VerticalList>
			</VerticalList>
		</Box>
		<Spacer id=loadmenu/>
	</HorizontalList>
]]

local session_layout =
[[
	<Box bg=popup_box_bg blur=true height=32 color=light_gray on_mouse_enter={on_session_enter} on_mouse_leave={on_session_leave} on_mouse_button_down={on_session_select} on_double_click={on_join} tooltip={on_session_tooltip} padding=1 margin_bottom=2>
		<HorizontalList fill=true child_align=center>
			<Image image=icon_small_author color=ui_light/>
			<Text text={text} color=ui_light textalign=center size=10/>
			<Spacer fill=true/>
			<Text text={textinfo} size=10 margin_right=10/>
		</HorizontalList>
	</Box>
]]

local Multiplayer = {}
UI.Register("Multiplayer", layout, Multiplayer)

function Multiplayer:construct()
	self:TweenFromTo("sx", 0.01, 1, 40, 'OutQuad')
	self:TweenFromTo("sy", 0.01, 1, 80, 'OutQuad')
	UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN")
	self:on_search() -- automatically search sessions on open
	self.refreshlanbtn.hidden = not Game.OnlineHaveLobbies()
end

function Multiplayer:on_host_new(btn)
	if btn.active then
		btn.active = false
		self.loadmenu:Clear()
		return
	end
	btn.active = true
	self.loadgame.active = false
	self.loadmenu:SetContent("NewGame", { start_online_session = true })
end

function Multiplayer:on_host_load(btn)
	if btn.active then
		btn.active = false
		self.loadmenu:Clear()
		return
	end
	btn.active = true
	self.newgame.active = false
	self.loadmenu:SetContent("<LoadSave mode=hostload/>")
end

function Multiplayer:on_connect_ip()
	UI.AddLayout("ConfirmDialog", {
		title = "Connect to Host", body = "Enter hostname or IP address to connect to",
		construct = function(w)
			w.serverhost = w.list:Add("<InputText on_enter={ok}/>")
			w.password = w.list:Add('<HorizontalList child_align=center child_padding=8><Text text="Server Password:"/><InputText password=true fill=true id=pw on_enter={ok}/></HorizontalList>').pw
			w.serverhost:Focus()
		end,
		cancel = function(w) w:RemoveFromParent() end,
		ok = function(w)
			if (w.serverhost.text or "") == "" then return end
			MultiplayerJoinSession(false, w.serverhost.text, w.password.text)
			w:RemoveFromParent()
		end,
	}, 99)
end

function Multiplayer:on_session_tooltip(btn)
	local info = btn.info
	local mode, daynight, password, dedicated_server = info.game_mode, info.enable_day_night, info.use_password, info.dedicated_server
	return L("<hl>%s</>\n%s%s%s%s",
		info.name,
		L("%s: %s", "Day/Night Cycle", daynight and "On" or "Off"),
		mode and mode ~= "" and L("\n%s: %s", "Game Mode", mode) or "",
		dedicated_server and L("\n%s", "Dedicated Server") or "",
		password and L("\n%s", "Password Required") or ""
	)
end

function Multiplayer:on_search(btn)
	self.join.disabled = true
	self.sessions:Clear()
	self.sessions.min_height = 0
	self.session_filter.hidden = true
	self.throbber.hidden = false
	self.refreshbtn.disabled = true
	self.refreshlanbtn.disabled = true
	local find_lan = (btn == self.refreshlanbtn)
	Game.FindOnlineSessions(function(success, list)
		if not self:IsValid() then return end
		self.throbber.hidden = true
		self.refreshbtn.disabled = false
		self.refreshlanbtn.disabled = false
		if not success then
			MessageBox("Please check your network connection.", "Network Error")
		end

		for i,v in ipairs(list) do
			local sessionname, truncated = Tool.TruncateString(v.name or v.username, 15)
			self.sessions:Add(session_layout, {
				text = NOLOC(sessionname .. (truncated and '…' or '')),
				textinfo = L("%s - [%d/%d]", v.scenario, v.players, v.players_max),
				index = i,
				info = v,
			})
		end

		if #list > 9 then
			self.sessions.min_height = self.sessions.max_height
			self.session_filter.hidden = false
			self.session_filter:Refresh()
		end
	end, find_lan)
end

function Multiplayer:on_session_filter(search, filter)
	if filter == "" then filter = nil end
	local ContainsStringNoCase = filter and Tool.ContainsStringNoCase
	for i,v in ipairs(self.sessions) do
		v.hidden = filter and not ContainsStringNoCase(v.info.name or "", filter)
	end
end

function Multiplayer:on_session_enter(session)
	session.color = self.session_index == session.index and 'ui_light' or 'gray'
end

function Multiplayer:on_session_leave(session)
	session.color = self.session_index == session.index and 'ui_light' or 'light_gray'
end

function Multiplayer:on_session_select(session)
	if self.session_index then self.sessions[self.session_index].color = 'light_gray' end
	session.color = 'ui_light'
	self.join.disabled = false
	self.session_index = session.index
	self.session_use_password = session.info.use_password
end

function Multiplayer:on_join()
	MultiplayerJoinSession(self.session_use_password, self.session_index)
end
