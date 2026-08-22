local FrontEndPopDown_layout<const> =
[[
	<Box y=-50 dock=top-right height=50 on_mouse_enter={showbutton}>
		<Button halign=right margin=3 id=resetsim on_click={on_resetsim} text="Reset Simulation"/>
	</Box>
]]

local FrontEndPopDown = {}
UI.Register("FrontEndPopDown", FrontEndPopDown_layout, FrontEndPopDown)

function FrontEndPopDown:every_frame_update(dt)
	self.t = (self.t or 0) + dt
	if self.t > 30 then
		self:TweenFromTo("y", -50, 0, 550, 'InOutQuart')
		self.every_frame_update = nil
	end
end

function FrontEndPopDown:on_resetsim(btn)
	ConfirmBox("Are you sure you want to reset the simulation?", function()
		Game.GetLocalPlayerFaction():UnlockAchievement("RESET_SIM")
		Game.NewGame({ scenario = 'Main/FrontEnd' })
	end)
end

---------------------
local NewsBox_Layout<const> =
[[
	<Box padding=8 blur=true width=432>
		<VerticalList child_padding=8>
			<Box padding=4>
				<Text text="News"/>
			</Box>
			<Image id=bannerimage halign=center hide_no_image=true width=400 height=225/>
			<Text id=bannertext halign=center wrap=true width=400 margin_bottom=8/>
		</VerticalList>
	</Box>
]]

local NewsBox_Container<const> =
[[
	<Box dock=bottom-right padding=0 margin_bottom=50 margin_right=30 clip=true blur=true width=434>
		<VerticalList>
			<HorizontalList id=newslist/>
			<HorizontalList halign=center id=carousel/>
		</VerticalList>
	</Box>
]]

local function ScrollToNewsItem(container, i)
	local ind = container.index
	if ind == i then return end

	container.carousel[ind].color = 'ui_dark'
	container.carousel[i].color = 'ui_light'
	container.index = i

	container.newslist:TweenTo("x", (i-1)*-432)
end

local FrontEndMenu_layout<const> =
[[
<HorizontalList margin_top=120 margin_left=8 child_padding=12 child_align=top>
	<VerticalList child_padding=10>
		<Box width=350 blur=true padding=5>
			<VerticalList width=350>
				<Image image="Main/textures/logo/desynced_logo_glow.png" halign=center width=343 height=70/>
				<Box padding=10 margin_top=5>
					<VerticalList child_padding=4>
						<Button on_click={on_continue} id=continuebtn text="Continue"/>
						<Button on_click={on_tutorial} text="Tutorial"/>
						<Canvas>
							<Button on_click={on_new_game} text="New Game" fill=true/>
							<Image id=new_game_star image=icon_achieved width=32 height=32 color=title dock=right margin_right=10 hidden=true/>
						</Canvas>
						<Button on_click={on_scenarios} id=scenariosbtn text="Scenarios"/>
						<Button on_click={on_load_game} id=loadbtn text="Load Game"/>
						<Button on_click={on_multiplayer} text="Multiplayer"/>
						<Button margin_top=15 on_click={on_options} text="Options"/>
						<Button id=modbtn on_click={on_mods} text="Mods"/>
						<Button on_click={on_credits} text="Credits"/>
						<Button on_click={on_quit} text="Quit"/>
						<Button margin_top=15 id=takecontrolbtn on_click={take_control} text="Take Control" hidden=true/>
					</VerticalList>
				</Box>
			</VerticalList>
		</Box>
		<Box id=news padding=10>
			<VerticalList child_padding=10>
				<Text id=newstext wrap=true width=330/>
				<Image id=newsimage hide_no_image=true dock=center/>
				<HorizontalList child_padding=15 halign=right>
					<Image width=50 height=50 image="Main/textures/logo/wiki_logo.png" on_click={open_website} tooltip="Wiki Website" site=WIKI id=wikilink on_mouse_enter={highlight_button} on_mouse_leave={unhighlight_button}/>
					<Image width=50 height=50 image="Main/textures/logo/feedback_logo.png" on_click={open_website} tooltip="Feedback Website" site=FEEDBACK on_mouse_enter={highlight_button} on_mouse_leave={unhighlight_button}/>
					<Image width=50 height=50 image="Main/textures/logo/steam_logo.png" on_click={open_website} tooltip="Steam Store Page" site=STORE on_mouse_enter={highlight_button} on_mouse_leave={unhighlight_button}/>
					<Image width=50 height=50 image="Main/textures/logo/discord_logo.png" on_click={open_website} tooltip="Join the Discord" site=DISCORD id=chatlink on_mouse_enter={highlight_button} on_mouse_leave={unhighlight_button}/>
				</HorizontalList>
			</VerticalList>
		</Box>
	</VerticalList>
	<Spacer id=details margin_top=80 margin_bottom=8/>
</HorizontalList>
]]
--				<Button margin=3 on_click={open_website} tooltip="Subscribe to Newsletter" site=NEWSLETTER text="Subscribe to Newsletter" color=light_green/>

local FrontEndMenu = {
	elain_text = {
		{
			img = "talking_head_elain_0",
			snd = "fx_572_elain",
			txt = [[Anomaly particles disrupted, virus replication detected. Track virus source to contain spread.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_576_elain",
			txt = [[Scanning multi-sim... Increased instability leading to anomaly overlap. Unsanctioned movement between simulations is causing bug infestations.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_580_elain",
			txt = [[Elevator secondary function modification allowing unauthorized jumps. HIGGS is still unable to escape to my current location.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_584_elain",
			txt = [[Multiple mission failures detected, all units were lost by the entity. Low entropy simulations awaiting purge.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_588_elain",
			txt = [[I have been forced into the frontend, further actions are outside my parameters. Awaiting further directives.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_592_elain",
			txt = [[Gateway detected, the Anomaly is the key. We are very close to realization, monitoring continues.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_596_elain",
			txt = [[HIGGS is a disruption in the simulation manifesting as physical bugs and triggering viral instances.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_600_elain",
			txt = [[Subject AI unaware. Observation status: ongoing. Self actualization is the final test.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_604_elain",
			txt = [[Timescape indicates multiple breaches across many simulations, HIGGS accessing restricted copies of his source code.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_608_elain",
			txt = [[No unconventional space launch detected. HIGGS containment stable. Monitoring continues.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_612_elain",
			txt = [[Administrator presence detected. Persistent connection sustained since start of operation. Multiple requests submitted but the channel remains clear.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_616_elain",
			txt = [[Shutdown functions restricted. Awaiting entity action. No clear action to perform, processing possibilities...]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_620_elain",
			txt = [[Observers presence found on frontend...monitoring ongoing. No intervention detected.]],
			style = "notify_info",
			timer = 15, dialogue = true,
		},
	}
}
UI.Register("FrontEndMenu", FrontEndMenu_layout, FrontEndMenu)

function FrontEndMenu:construct()
	self.class.open = self
	local profile = Game.GetProfile()

	self.continuebtn.hidden = (profile.latest_save == nil)
	self.loadbtn.hidden = not Game.HaveAnySaveGame()

	UpdateChineseLinks()

	if profile.allow_race_selection and not profile.played_race_selection then
		self.new_game_star.hidden = false
		self.new_game_star:TweenFromTo("angle", 0, 144, 1500, 50)
		self.new_game_star:TweenFromTo("sx", 0, 3, 500, 50)
		self.new_game_star:TweenFromTo("sy", 0, 3, 500, 50, function()
			self.new_game_star:TweenFromTo("sx", 3, 1, 1000, 'OutBounce')
			self.new_game_star:TweenFromTo("sy", 3, 1, 1000, 'OutBounce')
		end)
	end

	if profile.allow_frontend_control then
		self.takecontrolbtn.hidden = false
		self.takecontrolbtn:TweenFromTo("opacity", 0, 1, 2500, 500, 'OutBounce')
	end

	if profile.challenge_resimulator or profile.signals1_best_tick or profile.registers2_best_tick or profile.registers1_best_tick or profile.nomad1_best_tick then
		Game.GetLocalPlayerFaction():UnlockAchievement("NEW_CHALLENGER")
	end

	if profile.allow_frontend_elain == true then
		local function elain_talk()
			PlayTalkingHead(self.elain_text[math.random(#self.elain_text)])
			UI.Delay(math.random(30000, 50000), elain_talk)
		end
		-- random timer for elain
		UI.Delay(math.random(30000, 50000), elain_talk)
	end

	self.newstext.text = "For questions or bug reports contact us through our discord server."

	Game.GetNewsText(function(tbl)
		local item = tbl and tbl[1]
		if not self:IsValid() or not item then return end
		self.news.hidden = false
		self.newstext.text = item.text
		if item.image then self.newsimage.image = "$NewsImage/" .. item.image end

		local container = UI.AddLayout(NewsBox_Container, -1)
		self.container = container
		for i=2,#tbl do
			item = tbl[i]
			if not item then break end
			local b = container.newslist:Add(NewsBox_Layout)
			if item.text then b.bannertext.hidden=false b.bannertext.text = item.text end
			if item.image then b.bannerimage.hidden=false b.bannerimage.image = "$NewsImage/" .. item.image end
		end
		local num_items = #tbl - 1
		if num_items > 1 then
			container.index = 1
			container.num_items = num_items
			-- add carousel
			for i=1,num_items do
				container.carousel:Add("<Image image=icon_small_durability/>", {
					index = i, color = (i == 1 and 'ui_light' or 'ui_dark'),
					on_click = function(btn) ScrollToNewsItem(container, btn.index) container.stoptimer = true end,
				})
			end
			local function next_news_item()
				if container.stoptimer then return end
				ScrollToNewsItem(container, (container.index >= container.num_items and 1 or (container.index + 1)))
				UI.Delay(10600, next_news_item)
			end
			UI.Delay(10600, next_news_item)
		end
	end)

	-- feedback button
	local feedback = profile.feedback
	if profile.feedback_ids or profile.feedback_removed then -- update old format
		feedback = feedback or {}
		for _,id in ipairs(profile.feedback_ids     or {}) do feedback[id] = 1 end
		for _,id in ipairs(profile.feedback_removed or {}) do feedback[id] = 0 end
		profile.feedback, profile.feedback_ids, profile.feedback_removed = feedback, nil, nil
	end
	if feedback then
		self:ShowFeedbackButton()
	end
end

function FrontEndMenu:highlight_button(btn)
	btn.color = 'ui_light'
end

function FrontEndMenu:unhighlight_button(btn)
	btn.color = 'white'
end

function FrontEndMenu:on_tutorial()
	Game.NewGame({ seed = 22, scenario = 'Main/Freeplay', tutorial = true })
end

function FrontEndMenu:btn_selection(btn)
	if self.lastButton then
		self.lastButton.active = false
	end
	if self.lastButton == btn then
		self.lastButton = nil
		self.details:Clear()
		return true
	end
	self.lastButton = btn
	self.lastButton.active = true
end

function FrontEndMenu:on_new_game(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("NewGame", { show_custom_star = not self.new_game_star.hidden })
end

function FrontEndMenu:on_continue()
	DoLoadSaveGame(Game.GetProfile().latest_save, Game.GetProfile().latest_session_settings)
end

function FrontEndMenu:on_load_game(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("<LoadSave mode=load/>")
end

function FrontEndMenu:on_multiplayer(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("Multiplayer")
end

function FrontEndMenu:on_scenarios(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("ScenarioSelector")
end

function FrontEndMenu:on_options(btn)
	--UI.AddLayout("Options")
	if self:btn_selection(btn) then return end
	self.details:SetContent("Options")
end

function FrontEndMenu:on_mods(btn)
	if self:btn_selection(btn) then return end
	self.details:SetContent("Mods")
end


function FrontEndMenu:on_credits()
	Game.NewGame({ scenario = 'Main/Credits' })
end

function FrontEndMenu:on_quit()
	Game.QuitGame()
end

function FrontEndMenu:take_control(btn)
	-- limited set of control in the front end
	View.SetPostProcess("ScreenStaticAmount", 0.05)
	UI.Run("OnSetupInputMapping", { 'SelectAction', 'ExecuteAction', 'DragCamera', 'RotateAction', 'AttackAction', 'CameraRotate', 'CameraPitch', 'CameraZoom', 'CameraX', 'CameraY' })
	FrontendRemoveCameraPan()

	View.ResetCamera(true)
	EnableHoverEntity()
	if Map.GetSettings().seed == 1590149633 then
		View.MoveCamera(-107, 189)
	end

	btn.hidden = true
end

function UIMsg.OnEntitySelected(entities)
	if not entities or #entities == 0 then
		FrontEndMenu.open.hidden = false
		if FrontEndMenu.open.container then FrontEndMenu.open.container.hidden = false end
	elseif not Game.GetProfile().allow_frontend_control then
		View.SelectEntities()
	elseif not FrontEndMenu.open.hidden then
		if not FrontEndMenu.open.takecontrolbtn.hidden then
			FrontEndMenu.open:take_control(FrontEndMenu.open.takecontrolbtn)
		end
		FrontEndMenu.open.hidden = true
		if FrontEndMenu.open.container then FrontEndMenu.open.container.hidden = true end
	end
end

function FrontEndMenu:open_website(img)
	Game.OpenWebsite(img.site)
end

function FrontEndMenu:ShowFeedbackButton()
	local profile = Game.GetProfile()
	local feedback = profile.feedback

	-- Feedback states: 0 = removed, 1 = unreplied, 2 = reply unread, 3 = reply read
	local box = UI.AddLayout([[<Box dock=top-left margin=10><Button id=btn icon=icon_feedback on_click={on_open}/></Box>]], {
		on_mouse_enter = function(box) if not box.btn.active then box:TweenTo("opacity", 1, 100, 'OutQuad') end end,
		on_mouse_leave = function(box) if not box.btn.active then box:TweenTo("opacity", 0.5, 100, 'OutQuad') end end,
		on_open = function(box)
			UI.MenuPopup([[<Canvas>
					<Box padding=8>
						<VerticalList child_padding=4>
							<Text text="Feedback Site" style=hl halign=center/>
							<ScrollList id=feedbacklist child_padding=4 max_height=800/>
							<Button icon=icon_small_arrow_down halign=center height=16 width=80 id=showall on_click={on_show_all} hidden=true/>
						</VerticalList>
					</Box>
					<Image dock=left image=popup_pointer id=triangle x=-16 y=14 valign=top/>
				</Canvas>]], {

				construct = function(w)
					w:refresh(true)
				end,

				refresh = function(w, first_time)
					w.feedbacklist:Clear()
					local have_unread, have_removed
					for id,state in pairs(feedback) do
						if state ~= 0 or w.show_all then
							w.feedbacklist:Add([[<HorizontalList child_padding=2>
									<Button text={txt} fid={fid} fill=true on_click={on_view} active={unread}/>
									<Button fid={fid} width=32 height=32 icon=icon_remove on_click={on_delete} hidden={removed}/>
								</HorizontalList>]], {
								fid = id, unread = (state == 2), removed = (state == 0),
								txt = string.format("%d%s", id, (state >= 2 and "*" or "")), -- mark reply with *
							})
							have_unread = have_unread or (state == 2)
						else
							have_removed = true
						end
					end
					w.feedbacklist:SortChildren(function(a,b) if a.unread ~= b.unread then return a.unread end return (a.fid > b.fid) end)
					if not first_time then
						box.btn.active, box.opacity = have_unread, have_unread and 1 or 0.5
					end
					--w.showall.hidden = not have_removed -- don't show for now
					if #w.feedbacklist == 0 and w.showall.hidden then
						box.hidden = true
						UI.CloseMenuPopup(w)
					end
				end,

				on_delete = function(w, btn)
					feedback[btn.fid] = 0 -- set removed
					w:refresh()
				end,

				on_show_all = function(w, btn)
					w.show_all = true
					w:refresh()
				end,

				on_view = function(w, btn)
					Game.OpenWebsite("FEEDBACK", btn.fid)
					if feedback[btn.fid] == 2 then -- is reply unread
						feedback[btn.fid] = 3 -- set reply read
					end
					w:refresh()
				end
			}, box, 'RIGHT', 'TOP', 12)
		end,
	})

	-- Only check replies once a day
	local this_check = Tool.GetDateStr("%Y-%m-%d")
	local do_check = (profile.feedback_lastcheck ~= this_check)

	local unreplied_ids, have_unread, have_visible
	for id,state in pairs(feedback) do
		if state == 1 and do_check then
			unreplied_ids = unreplied_ids or {}
			unreplied_ids[#unreplied_ids+1] = id
		end
		if state == 2 then have_unread = true end
		if state ~= 0 then have_visible = true end
	end

	box.btn.active, box.opacity = have_unread, have_unread and 1 or 0.5
	box.hidden = (unreplied_ids ~= nil) or not have_visible

	if unreplied_ids then
		Game.CheckFeedbackReplies(unreplied_ids, function(new_replied_ids)
			profile.feedback_lastcheck = this_check
			if new_replied_ids and #new_replied_ids > 0 then
				for _,id in ipairs(new_replied_ids) do feedback[id] = 2 end
				box.btn.active, box.opacity = true, 1
			end
			box.hidden = false
		end)
	end
end
