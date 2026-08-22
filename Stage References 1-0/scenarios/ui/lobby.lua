local VersusLobby_layout<const> =
[[
	<Box dock=fill padding=2 margin_left=-4 margin_right=-4 margin_bottom=-4>
		<Canvas>
			<Image dock=fill image=tech_tree_pattern_bg/>
			<Image dock=fill image=tech_tree_pattern/>
			<HorizontalList margin=40 fill=true child_padding=40>
				<VerticalList fill=true child_padding=20>
					<Text style=hl text="PLAYERS" size=38/>
					<Box fill=true padding=10>
						<ScrollList height=350 id=players child_padding=5/>
					</Box>
					<Text style=hl text="CHAT" size=38/>
					<Box fill=true padding=10>
						<VerticalList child_padding=10>
							<ScrollList id=chatlist child_align=bottom fill=true/>
							<InputText on_change={chat_on_change} on_enter={chat_on_commit}/>
						</VerticalList>
					</Box>
				</VerticalList>
				<VerticalList child_padding=20>
					<Text style=hl text="MAP" size=38/>
					<Box padding=10>
						<VerticalList child_padding=10>
							<Combo id=map_list textsize=28 on_change={on_change_map}/>
							<Image width=350 height=350 id=mapimg/>
						</VerticalList>
					</Box>
					<Text id=settingslbl style=hl text="SETTINGS" size=38/>
					<Box id=settingsbox padding=10>
						<VerticalList child_padding=10>
							<CheckBox id=allow_join text="Allow New Players Joining"/>
							<CheckBox id=allow_faction_switch text="Allow Faction Switching"/>
						</VerticalList>
					</Box>
					<Spacer fill=true/>
					<Button id=readybtn textsize=28 on_click={on_click_ready}/>
					<Button text="End Game" textsize=28 on_click={on_click_leave}/>
				</VerticalList>
			</HorizontalList>
		</Canvas>
	</Box>
]]

local VersusPlayer_layout<const> =
[[
	<Box padding=8>
		<HorizontalList child_padding=15 child_align=center>
			<Button id=kick icon=icon_small_deny on_click={kickplayer} hidden=true width=32 height=32 tooltip="Kick/Ban Player"/>
			<Text id=txtname clip=true fill=true size=28/>
			<Text id=readylbl size=20 text="READY" style=hl hidden=true/>
			<Combo id=faction_list textsize=28 width=300 size=28 tooltip="Being on the same faction will share unit control and start in the same base" on_change={on_change_faction}/>
			<Combo id=team_list textsize=28 width=300 size=28 tooltip="Being in the same team will share visibility" on_change={on_change_team}/>
		</HorizontalList>
	</Box>
]]

local VersusLobby = {}
local team_labels = { "Team 1", "Team 2", "Team 3", "Team 4" }

local VersusPlayer = {}
UI.Register("VersusPlayer", VersusPlayer_layout, VersusPlayer)

function VersusPlayer:construct()
	local player = self.player
	local faction = Map.GetFaction(player.faction_id)
	local faction_num = tonumber(player.faction_id:match('_(%d+)')) or 1
	self.txtname.text = NOLOC(player.name)
	self.faction_list.texts = VersusLobby.open.faction_labels
	self.faction_list.value = faction_num
	self.team_list.texts = team_labels
	self.team_list.value = faction.extra_data.team or faction_num
	self.team_list.hidden = (Map.GetTick() > 0) -- hide when late joining
	self.disabled = not player.is_local and not Game.IsHostPlayer()
	self.kick.disabled = player.is_host
	self.kick.hidden = not Game.IsHostPlayer()
	self.readylbl.hidden = not self.ready
end

function VersusPlayer:kickplayer(btn)
	btn.disabled = true -- avoid clicking twice
	if self.ai_num then
		Action.SendFromPlayer("LobbyRemoveAIPlayer", { ai_num = self.ai_num })
	else
		UI.AddLayout('<ConfirmDialog title="Kick Player" body="Do you want to remove this player from the server?"/>', {
			construct = function(w)
				w.ban = w.list:Add('<CheckBox text="Ban Player (lasts until game on server is restarted)" halign=center/>')
			end,
			cancel = function(w) w:RemoveFromParent() end,
			ok = function(w)
				Game.KickPlayer(self.player.id, w.ban.check)
				w:RemoveFromParent()
			end,
		}, 99)
	end
end

function VersusPlayer:on_change_faction(btn)
	Action.SendFromPlayer("LobbySwitchFaction", { faction_id = "faction_" .. btn.value, player_id = self.player.id, ai_num = self.ai_num })
end

function VersusPlayer:on_change_team(btn)
	Action.SendFromPlayer("LobbySwitchTeam", { team = btn.value, player_id = self.player.id, ai_num = self.ai_num})
end

UI.Register("VersusLobby", VersusLobby_layout, VersusLobby)

function VersusLobby:construct()
	self.class.open = self

	local map_names, map_id_to_index, map_index_to_id = {}, {}, {}
	for map_id,md in pairs(data.map_data) do
		map_names[#map_names+1] = md.name
		map_id_to_index[map_id] = #map_names
		map_index_to_id[#map_names] = map_id
	end
	self.map_list.texts = map_names

	local is_host, is_server, already_started = Game.IsHostPlayer(), (Game.GetNetMode() == "server")
	for _,f in ipairs(Map.GetPlayerFactions()) do
		if f.extra_data.started then already_started = true break end
	end

	self.map_list.disabled = not is_host or already_started
	self.map_id_to_index = map_id_to_index
	self.map_index_to_id = map_index_to_id
	self.settingslbl.hidden = not is_server
	self.settingsbox.hidden = not is_server
	self.show_add_player = is_host and not already_started
	if is_server then
		-- Keep allow_join to default to false whe closing the lobby UI but take the faction switch option from the host settings
		self.allow_faction_switch.check = Map.GetSettings().allow_faction_switch == true
	end
	self:refresh()

	self.multiplayer_update = function() self:refresh() end
	UIMsg:Bind("OnMultiplayerUpdate", self.multiplayer_update)
end

function VersusLobby:destruct()
	if Game.GetNetMode() == "server" then
		Game.ModifyHostSessionSettings({ block_join = not self.allow_join.check, allow_faction_switch = self.allow_faction_switch.check })
	end

	UIMsg:Unbind("OnMultiplayerUpdate", self.multiplayer_update)
	self.class.open = nil
end

function VersusLobby:refresh()
	local save_lobby = Map.GetSave().lobby
	local md = data.map_data[save_lobby.map_id]

	local faction_labels = {}
	for i=1,#md.faction_info do
		faction_labels[#faction_labels+1] = L("Faction %d", i)
	end
	self.faction_labels = faction_labels

	self.map_list.value = self.map_id_to_index[save_lobby.map_id] or 1
	self.mapimg.image = md.image
	self.readybtn.disabled = false
	self.readybtn.text = Game.GetLocalPlayer().ready and "UNREADY" or "READY"

	self.players:Clear()
	for i,v in ipairs(Game.GetAllPlayers()) do
		self.players:Add("VersusPlayer", { player = v, ready = v.ready })
	end

	for i,v in ipairs(save_lobby.ai or {}) do
		if v then
			self.players:Add("VersusPlayer", { player = v, ready = true, ai_num = i })
		end
	end

	if self.show_add_player then
		self.players:Add('<Button text="Add AI Player" on_click={on_click_addai}/>')
	end
end

function VersusLobby:on_click_addai(btn)
	Action.SendFromPlayer("LobbyAddAIPlayer")
end

function VersusLobby:on_change_map(btn, value)
	Action.SendFromPlayer("LobbySetMap", { map_id = self.map_index_to_id[value] })
end

function VersusLobby:on_click_ready(btn)
	btn.disabled = true
	Action.SetPlayerReady(not Game.GetLocalPlayer().ready)
end

function VersusLobby:on_click_leave(btn)
	ConfirmBox("Are you sure you want to abort the scenario and return to the main menu?", function()
		Game.EndGame()
	end)
end

function VersusLobby:chat_on_change(input, value)
	local trunc = Tool.TruncateString(value, 2048)
	if #trunc ~= #value then input.text = trunc end
end

function VersusLobby:chat_on_commit(input, value)
	if not value or value == "" then return end
	UI.SendChatGlobal("Text", { txt = Tool.TruncateString(value, 2048) })
	input.text = ""
end

function PlayerAction.LobbyAddAIPlayer(player_id)
	if not Game.IsHostPlayer(player_id) then return end
	local save_lobby = Map.GetSave().lobby
	save_lobby.ai = save_lobby.ai or {}
	for i=1,#save_lobby.ai + 1 do
		if not save_lobby.ai[i] then
			Map.CreateFaction("faction_2", true) -- make sure it exists
			save_lobby.ai[i] = { name = string.format("AI %d", i), faction_id = "faction_2", team = 2 }
			break
		end
	end
	UI.Run("OnMultiplayerUpdate")
end

function PlayerAction.LobbyRemoveAIPlayer(player_id, faction, arg)
	if not Game.IsHostPlayer(player_id) then return end
	Map.GetSave().lobby.ai[arg.ai_num] = false
	UI.Run("OnMultiplayerUpdate")
end

function PlayerAction.LobbySetMap(player_id, faction, arg)
	if not Game.IsHostPlayer(player_id) then return end
	Map.GetSave().lobby.map_id = arg.map_id
	local max_faction = #data.map_data[arg.map_id].faction_info
	for i,player in ipairs(Game.GetAllPlayers()) do
		if (tonumber(player.faction_id:match('_(%d+)')) or 0) > max_faction then
			Map.SetPlayerFaction(player.id, 'faction_' .. max_faction)
		end
	end
	UI.Run("OnMultiplayerUpdate")
end

function PlayerAction.LobbySwitchFaction(player_id, faction, arg)
	if arg.ai_num and Game.IsHostPlayer(player_id) then
		Map.CreateFaction(arg.faction_id, true) -- make sure it exists
		Map.GetSave().lobby.ai[arg.ai_num].faction_id = arg.faction_id
		UI.Run("OnMultiplayerUpdate")
	elseif arg.player_id and Game.IsHostPlayer(player_id) then
		Map.SetPlayerFaction(arg.player_id, arg.faction_id)
	else
		Map.SetPlayerFaction(player_id, arg.faction_id)
	end
end

function PlayerAction.LobbySwitchTeam(player_id, faction, arg)
	if arg.ai_num and Game.IsHostPlayer(player_id) then
		faction = Map.GetFaction(Map.GetSave().lobby.ai[arg.ai_num].faction_id)
	elseif arg.player_id and Game.IsHostPlayer(player_id) then
		faction = Map.GetFaction(Game.GetPlayerById(arg.player_id).faction_id)
	end
	faction.extra_data.team = arg.team
	UI.Run("OnMultiplayerUpdate")
end

function UIMsg.OnSetup()
	if Action.IsReplayPlayback() or Game.GetLocalPlayer().ready then return end

	UI.FindWidgetWithTag("SideBar"):RemoveFromParent() -- remove until OnCloseVersusLobby
	UIMsg:UnbindAll("OnGameOver") -- ignore until OnCloseVersusLobby
	UI.AddLayout("VersusLobby", 1)

	if Game.GetNetMode() == "offline" then
		MessageBox("This scenario is intended for multiplayer")
	end
end

function UIMsg.OnCloseVersusLobby()
	if not VersusLobby.open then return end -- can be called multiple times

	VersusLobby.open:RemoveFromParent()
	UI.AddLayout("SideBar")

	function UIMsg.OnGameOver()
		ConfirmBox("You have been Defeated. Leave the game?", function()
			Game.EndGame()
		end)
	end

	View.ResetCamera(true)

	if Game.GetLocalPlayerFaction().num_entities == 0 then
		UI.Run("OnGameOver")
	end
end

function UIMsg.OnReceivedChat(arg)
	if VersusLobby.open then
		local txt = L("%S[%S]</> %S", (Game.IsLocalPlayer(arg.player_id) and "-> <bl>" or "<hl>"), Game.GetPlayerName(arg.player_id), Tool.TruncateString(arg.txt, 2048))
		VersusLobby.open.chatlist:Add("<Text style=outline wrap=true/>").text = txt
		VersusLobby.open.chatlist:ScrollToEnd()
	end
end
