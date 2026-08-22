local TutorialContent<const> = [[
	<Box halign=left width=535 padding=12>
		<VerticalList child_padding=8>
			<Box color=ui_dark padding=2 blocking=false>
				<HorizontalList>
					<Text color=ui_light size=14 id=headertext fill=true valign=center margin_left=8/>
					<HorizontalList id=tutnavi child_padding=5>
						<Button icon=icon50_Codex height=28 id=learnmore hidden=true on_click={on_codex}/>
					</HorizontalList>
				</HorizontalList>
			</Box>
			<VerticalList id=textlist width=680 clip=true>
				<Text id=detailtext style=bl wrap=true/>
			</VerticalList>
			<HorizontalList min_height=22>
				<Image image="Main/textures/codex/icons/name_icon.png" dock=left margin_left=2 width=20 height=20 hide_no_image=true/>
				<Text style=bl valign=center id=mintxt margin_left=10/>
			</HorizontalList>
		</VerticalList>
	</Box>
]]
local TutorialNotification_layout<const> = [[
	<Box dock=top-right width=535 x=-320 y=5 blur=true padding=12 hidden=true>
		<VerticalList child_padding=8>
			<Box color=ui_dark padding=2 blocking=false>
				<HorizontalList>
					<Text color=ui_light size=14 id=headertext fill=true valign=center margin_left=8/>
					<HorizontalList id=tutnavi child_padding=5>
						<Button icon=icon50_Codex height=28 id=learnmore hidden=true on_click={on_codex}/>
						<Button on_click={do_prev} id=prev text="<"/>
						<Button on_click={do_next} id=next text=">"/>
					</HorizontalList>
				</HorizontalList>
			</Box>
			<VerticalList id=textlist width=680 clip=true>
				<Text id=detailtext style=bl wrap=true/>
			</VerticalList>
			<HorizontalList min_height=22>
				<Canvas valign=center width=20 height=20>
					<Image image="Main/textures/codex/icons/name_icon.png" dock=left margin_left=2 width=20 height=20 hide_no_image=true/>
					<Text id=check text="✓" dock=left size=18 hidden=true/>
				</Canvas>
				<Text style=bl valign=center id=mintxt margin_left=10/>
			</HorizontalList>
			<HorizontalList child_padding=8>
				<Spacer fill=true/>
				<Button text="Understood" id=understood hidden=true on_click={on_understood}/>
			</HorizontalList>
			<Image dock=bottom-right id=downarrow image=icon_left_mouse opacity=0.5 hidden=true/>
			<Text textalign=center margin=12 margin_bottom=16 size=8 style=desc id=clickmin text="click anywhere to minimize" hidden=true/>
		</VerticalList>
	</Box>
]]

local tut_list
local TutorialNotification<const> = {}
UI.Register("TutorialNotification", TutorialNotification_layout, TutorialNotification)

local function StartupTutorialNotification(skip_paused_check)
	if not TutorialIsAvailable() then return end
	if TutorialNotification.open then return end

	local _save = Game.GetLocalPlayerFaction().extra_data._save
	if not skip_paused_check and _save and _save.paused then return end

	UI.AddLayout("TutorialNotification", 5)

	-- verify that check and min_txt are always specified together
	for _,tut in ipairs(tut_list) do if (not tut.check) ~= (not tut.min_txt) then error("Tutorial step is missing check or min_txt: " .. tostring(tut)) end end
end

local function TutorialOnMultiplayerChangeFaction()
	if TutorialNotification.open then
		TutorialNotification.open:RemoveFromParent()
	end
	StartupTutorialNotification()
end

function TutorialNotification:construct()
	self.cache = {}
	self.class.open = self
	UIMsg:Bind("OnMultiplayerChangeFaction", TutorialOnMultiplayerChangeFaction)
end

function TutorialNotification:destruct()
	UIMsg:Unbind("OnMultiplayerChangeFaction", TutorialOnMultiplayerChangeFaction)
	self.class.open = nil
	if self.glow_box then self.glow_box:RemoveFromParent() end
	RefreshGoals(true)
end

function TutorialNotification:ShowTutorial(progress)
	local tut = tut_list[progress]
	if not tut then return end
	if tut.txt then self.detailtext.hidden = false self.detailtext.text = tut.txt
	else self.detailtext.hidden = true end
	self.headertext.text = L("%d - %s", progress, tut.headertxt)
	self.mintxt.text = tut.min_txt or "Click Understood to Continue"
	--self.voicetext.text = tut.voicetxt
	--if tut.voice then UI.PlaySound(tut.voice) end

	self.textlist.hidden = false
	self.downarrow.hidden = true
	--self.clickmin.hidden = self.codex or false
	--self.mintxt.hidden = true

	local is_review = self.codex or progress < self.progress
	self.check.hidden = not is_review or progress >= #tut_list
	self.understood.hidden = is_review or tut.check ~= nil
	-- configure Learn More button with codex title
	if tut.codex_id and not self.codex then
		local codex_def = data and data.codex and data.codex[tut.codex_id]
		local codex_title = codex_def and codex_def.title or tut.codex_id
		--self.learnmore.text = ""
		self.learnmore.tooltip = L("Learn More: %s", codex_title)
		self.learnmore.hidden = false
	else
		self.learnmore.hidden = true
	end
	self.prev.opacity = progress == 1 and 0.5 or 1.0
	self.next.opacity = (not is_review or progress >= #tut_list) and 0.5 or 1.0
	self.review = is_review and progress or nil
end

function TutorialNotification:do_prev(btn)
	if btn.opacity < 1.0 then return end
	self:ShowTutorial((self.review or self.progress) - 1)
end

function TutorialNotification:do_next(btn)
	if btn.opacity < 1.0 then return end
	self:ShowTutorial(self.review + 1)
end

function TutorialNotification:AdvanceTutorial(progress)
	self.progressing = true
	if not tut_list[progress] then
		self:RemoveFromParent() -- tutorial finished
		return
	end

	self:GlowUIWidget(nil) -- clear talk_icon glow
	self.help_timer = 20.0
	if tut_list[progress].begin then
		tut_list[progress].begin()
	end
	self.progress = progress
	self:ShowTutorial(progress)
	self:TweenFromTo("sy", 0, 1, 200, function() self.progressing = false end)
end

function TutorialNotification:on_understood()
	Action.SendForLocalFaction("TutorialSetProgress", { progress = self.progress + 1 })
	if tut_list[self.progress].done then tut_list[self.progress].done(self.cache) end
	self:GlowUIWidget(nil)
	self:AdvanceTutorial(self.progress + 1)
end

function TutorialNotification:on_codex()
	local progress = self.review or self.progress
	local tut = tut_list[progress]
	if tut and tut.codex_id then
		OpenMainWindow("Codex", { scroll = 0, param = tut.codex_id })
	end
end

function TutorialNotification:every_frame_update(dt)
	local faction = Game.GetLocalPlayerFaction()
	local _save = faction.extra_data._save
	if _save and _save.paused then
		self:RemoveFromParent() -- tutorial paused
		return
	end

	if self.glow_box and self.glow_start then
		self.glow_start = self.glow_start - (dt)
		if self.glow_start <= 0.0 then
			self.glow_start = 5.0
			self.glow_box:RemoveFromParent()
			self.glow_box = nil
			self.glow_widget = nil
		end
	end

	if IsTalkingHeadActive() then
		self:GlowUIWidget("id", "talk_icon")
		self.hidden = true
	else
		local faction_progress = _save and _save.progress or 0
		local ui_progress = self.progress or 0
		local progress = (ui_progress > faction_progress and ui_progress or faction_progress)
		local tut, precheck_progress = tut_list[progress], progress
		if not self.progressing and tut and tut.tick then
			tut.tick(faction)
		end
		if not self.progressing and tut and tut.check and tut.check(faction, self.cache) then
			if tut.done then tut.done(self.cache) end
			self:GlowUIWidget(nil)

			self.progressing = true
			self.check.hidden = false
			self.check:TweenFromTo("sx",      0, 1, 1000, 'OutBack')
			self.check:TweenFromTo("sy",      0, 1, 1000, 'OutBack')
			self.check:TweenFromTo("angle", 180, 0, 1000, 500, 'OutBack', function()
				Action.SendForLocalFaction("TutorialSetProgress", { progress = progress + 1 })
				self:AdvanceTutorial(progress + 1)
				self.check.hidden = true
			end)
			return
		end
		if progress > ui_progress then
			self:AdvanceTutorial(progress)
			return
		end
		--[[
		if progress > precheck_progress then
			print("precheck tutorialsetprogress", progress, precheck_progress)
			Action.SendForLocalFaction("TutorialSetProgress", { progress = progress })
		end
		--]]
		self.hidden = progress == 0
	end

	-- If the player is stuck, guide them to the codex button
	if self.help_timer and self.help_timer > 0.0 then
		self.help_timer = self.help_timer - dt
		if self.help_timer <= 0.0 then
			self.glow_prop_name = "id"
			self.glow_prop_value = "learnmore"
			self.glow_start = 5.0
		end
	end

	local glow_widget, glow_x, glow_y, glow_w, glow_h = self.glow_prop_name and UI.FindWidgetWithProperty(self.glow_prop_name, self.glow_prop_value) or nil
	if glow_widget and glow_widget:IsVisible() then
		glow_x, glow_y, glow_w, glow_h = glow_widget:GetViewportPosition()
	end
	if not glow_w or glow_w < 1 then
		glow_widget = nil -- position on screen not determined yet, wait until next frame
	end

	if glow_widget == self.glow_widget then
		local box = self.glow_box
		if not glow_widget or not box or box:GetTweenTarget("x") or box:GetTweenTarget("y") then return end -- still animating
		box.x, box.y, box.width, box.height = glow_widget:GetViewportPosition()
		return
	end
	if self.glow_widget then
		self.glow_box:TweenFromTo("opacity", 1, 0, 200, function (gb) gb:RemoveFromParent() end)
		self.glow_box = nil
	end
	self.glow_widget = glow_widget
	if glow_widget then
		local box = UI.AddLayout("<Box dock=top-left bg=tutorial_highlight/>", 9999998)
		box:SetIgnoreHitTest()
		box:TweenFromTo("x", glow_x - 100, glow_x, 800)
		box:TweenFromTo("y", glow_y - 100, glow_y, 800)
		box:TweenFromTo("width", glow_w + 200, glow_w, 800)
		box:TweenFromTo("height", glow_h + 200, glow_h, 800)
		box:TweenFromTo("opacity", 0, 1, 800)
		self.glow_box = box
		self.glow_start = 5.0
	end
end

function TutorialNotification:GlowUIWidget(prop_name, prop_value)
	self.glow_prop_name, self.glow_prop_value = prop_name, prop_value
end

local function PanTo(entity, zoom_level, pingit)
	local start_cam_pos, start_cam_trg = View.GetCamera3DPosition()
	local hx, hy = View.GetHoveredTilePosition() -- need the tile you are current looking at
	local ex, ey = entity:GetLocationXY()
	local p1, p2, t1, t2
	p1, t1 = start_cam_pos, start_cam_trg
	p2, t2 = {
		x = ex,
		y = ey+5,
		z = zoom_level,
	}, {
		x = ex,
		y = ey,
		z = 0
	}
	UI.AddLayout('<Canvas fill=true/>', {
		construct = function(w)
			w.f = 0
			w:TweenFromTo("f", 0, 1, 800, 0, function()
				if pingit then
					View.PlayEffect("fx_ping", t2.x, t2.y)
				end
				w:RemoveFromParent()
			end)
		end,
		every_frame_update = function(w)
			local f = math.min(1, math.max(0, w.f))
			local pos = { p1.x + (p2.x - p1.x) * f, p1.y + (p2.y - p1.y) * f, p1.z + (p2.z - p1.z) * f }
			local trg = { t1.x + (t2.x - t1.x) * f, t1.y + (t2.y - t1.y) * f, t1.z + (t2.z - t1.z) * f }
			View.SetCamera3DPosition(pos, trg)
		end
	})
	--]]
end

function TutorialNotification:DrawLineEntity(from, to)
	if self.hint_line then View.StopEffect(self.hint_line) self.hint_line = nil end
	if from and to then
		self.hint_line = View.PlayEffect("fx_line", from, to, { Color = "#ffaa00" })
	end
end

function UIMsg.OnSetup()
	StartupTutorialNotification()
end

function FactionAction.TutorialSetPaused(faction, arg)
	local extra_data = faction.extra_data
	extra_data._save = extra_data._save or {}
	extra_data._save.paused = arg.paused or nil
	faction:RunUI(function ()
		if not arg.paused then
			StartupTutorialNotification()
		elseif TutorialNotification.open then
			TutorialNotification.open:RemoveFromParent()
		end
	end)
end

function FactionAction.TutorialSetProgress(faction, arg)
	local extra_data = faction.extra_data
	extra_data._save = extra_data._save or {}
	extra_data._save.progress = arg.progress
end

function Delay.TutorialBegin(arg)
	if not Map.GetSettings().tutorial then return end
	local extra_data = arg.faction.extra_data
	extra_data._save = extra_data._save or {}
	extra_data._save.progress = 1
end

function TutorialToggle(on)
	Action.SendForLocalFaction("TutorialSetPaused", { paused = not on })
	if on then
		StartupTutorialNotification(true)
	elseif TutorialNotification.open then
		TutorialNotification.open:RemoveFromParent()
	end
end

function TutorialIsAvailable()
	if not Map.GetSettings().tutorial then return false end
	if Action.IsReplayPlayback() then return false end
	local _save = Game.GetLocalPlayerFaction().extra_data._save
	local faction_progress = _save and _save.progress or 0
	return faction_progress == 0 or tut_list[faction_progress] ~= nil
end

function TutorialIsActive()
	local _save = Game.GetLocalPlayerFaction().extra_data._save
	return _save and tut_list[_save.progress or 0] and not _save.paused
end

function GetCodexTutorial()
	local ret = UI.New("VerticalList", { child_padding=20, })
	for i,tut in ipairs(tut_list) do
		local c = ret:Add(TutorialContent)

		if tut.txt then c.detailtext.hidden = false c.detailtext.text = tut.txt
		else c.detailtext.hidden = true end

		if tut.codex_id then
			local codex_def = data and data.codex and data.codex[tut.codex_id]
			local codex_title = codex_def and codex_def.title or tut.codex_id
			c.learnmore.tooltip = L("Learn More: %s", codex_title)
			c.codex_id = tut.codex_id
			c.learnmore.hidden = false
		else
			c.learnmore.hidden = true
		end

		c.headertext.text = L("%d - %s", i, tut.headertxt)
		c.mintxt.text = tut.min_txt or "Click Understood to Continue"
	end
	return ret
end

-- tutorial flow
local function GetEntityWithFrame(faction, frame_id, filter)
	for _,e in ipairs(faction.entities) do
		if e.id == frame_id then
			if not filter or filter(e) then return e end
		end
	end
end

local function ExplainInterface(help_array, on_done)
	UI.AddLayout([[<Canvas>
			<Image color="#00000088"/><Image color="#00000088"/><Image color="#00000088"/><Image color="#00000088"/><Box bg=tutorial_highlight blocking=false/>
			<Canvas width=0 height=0><Canvas>
				<Box bg=popup_box_bg blur=true padding=32 blocking=false><Text wrap=true width=500 text={txt}/></Box>
				<Image dock=bottom-right x=4 y=-3 color=ui_light image=icon_left_mouse opacity=0.5 sx=0.75 sy=0.75/>
			</Canvas></Canvas>
		</Canvas>]], {
		on_ui_cancel = function(cnvs) cnvs:on_click() end,
		on_ui_accept = function(cnvs) cnvs:on_click() end,
		construct = function(cnvs) cnvs:on_click() end,
		on_click = function(cnvs)
			cnvs.n = (cnvs.n or -1) + 2
			local glow_widget, popup_text = rawget(help_array, cnvs.n), rawget(help_array, cnvs.n+1)
			if not popup_text then cnvs:RemoveFromParent() on_done() return end -- finished
			if not glow_widget or glow_widget.hidden then return cnvs:on_click() end -- skip
			local gx, gy, gw, gh = glow_widget:GetViewportPosition()
			if not gx then cnvs.n = cnvs.n - 2 UI.Delay(function() cnvs:on_click() end) return end -- wait for layout

			-- Show darkened areas around the highlighted area
			local gr, gd, gmidx, cw, ch = gx+gw, gy+gh, gx+gw*.5, UI.GetScreenSize()
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

			-- Position and setup the text box (optimized towards our UI)
			local pos = (gd<200 and 'top') or (gr>cw-250 and 'right') or (gd>ch-400 and 'bottom') or (gx<250 and 'left')
			if pos == 'top' or pos == 'bottom' then -- near top/bottom of screen - position below/above it smartly aligned horizontally
				pop_anchor.x     = (gmidx<250 and   gx+5 or gmidx>cw-250 and    gr-5 or    gmidx)
				pop_inner.halign = (gmidx<250 and 'left' or gmidx>cw-250 and 'right' or 'center')
				pop_anchor.y, pop_inner.valign = pos == 'top' and gd+20 or gy-20, pos
			elseif pos == 'left' or pos == 'right' then -- near left/right side of screen - position to the left/right of it centered vertically
				local gmidy, popmidh = gy+gh*.5, 15 * (1+select(2, string.gsub(popup_text, "\n", "\n"))) -- estimate
				pop_anchor.y     = (gmidy-popmidh<0 and  gy+5 or gmidy+popmidh>ch and     gd-5 or    gmidy)
				pop_inner.valign = (gmidy-popmidh<0 and 'top' or gmidy+popmidh>ch and 'bottom' or 'center')
				pop_anchor.x, pop_inner.halign = pos == 'left' and gr+20 or gx-20, pos
			else -- center of screen - position above it centered horizontally
				pop_anchor.x, pop_inner.halign, pop_anchor.y, pop_inner.valign = gmidx, 'center', gy-20, 'bottom'
			end
			pop_inner:TweenFromTo("opacity", 0, 1, 800)
			cnvs.txt = popup_text
		end,
	}, 9999999)
end

local function TutorialEntitySelected()
	local frameview = UI.FindWidgetWithTag("FrameView")
	if not frameview or not frameview.components or #frameview.components == 0 then return end

	local interface_help = {
		-- Information Box --
		---------------------
		-- <yl>*</>  <bl> a unit or connecting/ disconnecting to the </>
		frameview.infobox,[[
<hl>Information</>

<yl>></> Health - Click and hold the mouse button on it to deconstruct the selected unit or building.
<yl>></> Battery - Hover the mouse for details on power consumption and production of this unit.]],

		----- Logistics -----
		---------------------
		frameview.infobox.logibtns, [[
<hl>Logistics</>

<img image="Main/textures/codex/icons/power_button_ON.png" width="20" height="20"/>  <bl>Power on/off</>
<img image="Main/textures/codex/icons/network_button_ON.png" width="20" height="20"/>  <bl>Logistics settings</>
<img image="Main/textures/codex/icons/transport_route.png" width="20" height="20"/>  <bl>Transport route</>]],
		--In addition there are more advanced Logistics Settings that allow you to customize how your units perform actions and <hl>Fulfill Orders</> on the logistics network.]],

		----- Inventory -----
		---------------------
		frameview.inventorybox, [[
<hl>Inventory</>

During gameplay you can right click inventory item slots for more options.]],
		--<bl>Inventory slots show what items are stored in the unit.</>
		--There can be multiple inventory types separated by component and slot type.
		--Items can be dragged out of inventory and onto other buildings and your units will perform the transfer for you.
		--You can also right click items in inventory for more item options.]],

		------ Sockets ------
		---------------------
		-- <nt>Components provide functionality to Units but are produced separately.</>
		frameview.components, [[
<hl>Component Sockets</>

Sockets and components come in four sizes, <hl>internal</>, <hl>small</>, <hl>medium</> and <hl>large</>.]],
		--<bl>Components are equipped into Sockets</>
		--Your Units <bl>(Bots and Buildings)</> gain functionality via <hl>Components</>
	}
	ExplainInterface(interface_help, function() TutorialNotification.open.overview_done = true end)
end

tut_list = {
	---------------------- INTRODUCTION ----------------------
	------------------------------------------------------
	{
		headertxt = "Introduction",
		txt = [[
<img image="Main/textures/codex/new/INTRODUCTION_codex_button_01.png"/>
The <hl>Codex Button</> opens the in-game Codex which contains more in-depth information. The <hl>Navigation Buttons</> allow you to view previous codex entries.]],

		codex_id = "x_tc_introduction",

		--[[
		check = function(f, cache)
			return Input.IsKeyDown("X")
		end,
		min_txt = "Press X to Continue",
		--]]
	},

	---------------------- CONTROLS ----------------------
	------------------------------------------------------
	{
		headertxt = "Controls",
		txt = [[<hl>Pan the Camera</> using the <Key axis="CameraY" style="hl"/> and <Key axis="CameraX" style="hl"/> keys

or with <Key action="DragCamera" style="hl"/> and dragging.]],

		codex_id = "x_tc_controls",

		check = function(f, cache)
			cache.camera_pos = cache.camera_pos or View.GetCamera3DPosition()
			local current_camera_pos = View.GetCamera3DPosition()
			return math.abs(current_camera_pos.x - cache.camera_pos.x) > 2
		end,
		min_txt = "Pan the camera",
	},

	----------------------- ZOOM -----------------------
	----------------------------------------------------
	{
		headertxt = "Controls",
		--txt = ""
		--txt = [=[<yl>*</> Use the <Key axis="CameraZoom" style="hl"/> to <hl>Zoom</> the camera.]=],

		check = function(f, c) c.zoom = c.zoom or View.GetCameraZoom() return View.GetCameraZoom() < (c.zoom - 200) or View.GetCameraZoom() > (c.zoom + 200) end,
		done = function(c) c.zoom = nil end,
		min_txt = [[Use the <Key axis="CameraZoom" style="hl"/> to <hl>Zoom</> the camera]],
		codex_id = "x_tc_controls",
	},

	-------------------- Game Screen -----------SELECTION Select Scout-------------
	--The <hl>Game Screen</> shows several useful pieces of information. When a unit is selected the Interface will appear
	--
	{
		headertxt = "Game Interface",
		min_txt = [[Follow the prompts]],
		begin = function()
			local resourcebar = UI.FindWidgetWithTag("ResourceBar")
			local sidebar = UI.FindWidgetWithTag("SideBar")
			local interface_help = {
				resourcebar[1],                   [[<img image="icon_small_energy" color="ui_light"/> Power <hl>production</> and <hl>consumption</> of your power grid.]],
				resourcebar.amountlists,          [[<img image="icon50_ItemNum" color="ui_light"/> <hl>Available items</> are shown at the top of the screen.

This can be toggled or filtered by using the button to the left.]],
				--resourcebar.shortcuts,            [[Shortcut groups.]], -- if enabled this only shows when there is at least 1 shortcut group which there likely won't be during the tutorial
				sidebar.sidebar.previous_sibling, [[<img image="icon_tiny_day" color="ui_light"/><img image="icon_tiny_night" color="ui_light"/> <hl>Time indicators</> showing day/night, time of day and the date are shown here.

Buttons to <hl>pause</> the game and open the <hl>in-game menu</> are also here.]],
				sidebar.sidebar,                  [[<img image="icon_remote" color="ui_light"/> An interactive <hl>minimap</>.

<hl>Game notifications</> will appear underneath it. Various notification categories can be disabled in the options.]],
				sidebar.sidebuttons,              data.codex.x_tc_user_interface.sections[2].text,
			}
			local f = Game.GetLocalPlayerFaction()
			local unit = GetEntityWithFrame(f, "f_bot_2m_as") or GetEntityWithFrame(f, "f_landingpod") or GetEntityWithFrame(f, "f_bot_1s_as") or f.entities[1]
			if unit then PanTo(unit, 20) end
			ExplainInterface(interface_help, function() TutorialNotification.open.overview_done = true end)
		end,
		check = function() return TutorialNotification.open.overview_done end,
	},
	--[=[
	{
		headertxt = "Select Scout",
		txt = [[Select the <img id="f_bot_1s_as" width="32" height="32" style="hl"/> with <Key action="SelectAction" style="hl"/>]],
		check = function(f) local sel = View.GetSelectedEntity() return sel and sel.faction == f  end,
		min_txt = "Select the Scout",
		codex_id = "x_tc_unit",
	},
	--]=]

	-------------------- Unit ------------------------
	--  Now that you have basic Camera Controls, let's start looking at units.
	--  in the bottom left of your display.
	{
		headertxt = "Interface",
		min_txt = [[Follow the prompts]],
		begin = function()
			TutorialNotification.open.overview_done = nil
			local f = Game.GetLocalPlayerFaction()
			local unit = GetEntityWithFrame(f, "f_bot_2m_as") or GetEntityWithFrame(f, "f_landingpod") or GetEntityWithFrame(f, "f_bot_1s_as") or f.entities[1]
			View.SelectEntities(unit)
			TutorialEntitySelected()
			PanTo(unit, 5, false)
		end,
		check = function() return TutorialNotification.open.overview_done end,
	},

	-------------------- MOVE UNIT ---------------------
	----------------------------------------------------
	{
		headertxt = "Unit Actions",
		min_txt = [[Move a <hl>unit</> with <Key action="ExecuteAction" style="hl"/>]],
		txt = [[Pressing <Key action="ExecuteAction" style="hl"/> will make the <hl>selected units</> perform various actions based on what components are equipped.]],
		--Select a <hl>Unit</> and order it to move to a nearby location.

		begin = function()
			local f = Game.GetLocalPlayerFaction()
			local unit = GetEntityWithFrame(f, "f_bot_2m_as") or GetEntityWithFrame(f, "f_bot_1s_as") or GetEntityWithFrame(f, "f_bot_1s_adw") or f.entities[1]
			PanTo(unit, 15, false)
		end,
		check = function(f, cache)
			if not cache.moved then
				for _,v in ipairs(f.entities) do
					if v.is_moving then
						cache.moved = true
						return
					end
				end
				return false
			else
				for _,v in ipairs(f.entities) do
					if v.is_moving then
						return
					end
				end
			end
			cache.moved = nil
			return true
		end,
		codex_id = "x_tc_unit",
	},

	-------------- Dragging and Dropping -----------------
	------------------------------------------------------
	{
		headertxt = "Unit Actions",
		min_txt = [[Drag the <img id="c_adv_portable_turret" width="32" height="32" style="hl"/> onto your <img id="f_bot_1s_as" width="32" height="32" style="hl"/>]],
		txt = [[<hl>Items</> can be moved by dragging them onto another unit on the map. <hl>Components</> will automatically get equipped when transferred.
Select your <img id="f_bot_2m_as" width="32" height="32" style="hl"/> to access its inventory]],

		begin = function()
			local f = Game.GetLocalPlayerFaction()
			local lander = GetEntityWithFrame(f, "f_bot_2m_as") or GetEntityWithFrame(f, "f_landingpod")
			local scout = GetEntityWithFrame(f, "f_bot_1s_as")
			TutorialNotification.open:DrawLineEntity(lander, scout)
			--if lander then View.PlayEffect("fx_ping", lander.location.x, lander.location.y) end
		end,
		check = function(f)
			local lander = GetEntityWithFrame(f, "f_bot_2m_as") or GetEntityWithFrame(f, "f_landingpod")
			local entity = View.GetSelectedEntity()
			local slot = lander and lander:FindSlot("c_adv_portable_turret")
			if entity == lander and slot then
				TutorialNotification.open:GlowUIWidget("slot", slot)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end

			local scout = GetEntityWithFrame(f, "f_bot_1s_as")
			if not scout then return true end -- if theres no scout then skip its
			return scout and scout:FindComponent("c_adv_portable_turret")
		end,
		codex_id = "x_tc_the_interface",
	},


	-------------------- DEPLOYMENT --------------------
	----------------------------------------------------
	{
		headertxt = "Deploy Command Center",
		min_txt = [[Deploy it using the <hl>[ Deploy Base ]</> button]],
		txt = [[
Deploy the <img id="f_bot_2m_as" width="32" height="32" style="hl"/> between the resources.
<img width="48" height="48" id="f_resourcenode_metal"/> <img width="48" height="48" id="f_landingpod"/> <img width="48" height="48" id="f_resourcenode_crystal"/>]],

		begin = function()
			TutorialNotification.open:DrawLineEntity()
			TutorialNotification.open:GlowUIWidget("text", "Deploy Base")
			-- ping it
			local landingpod = GetEntityWithFrame(Game.GetLocalPlayerFaction(), "f_bot_2m_as")
			if landingpod then
				PanTo(landingpod, 5)

				View.PlayEffect("fx_ping", 13, 17)
			end
		end,
		check = function(f)
			return not GetEntityWithFrame(f, "f_bot_2m_as")
		end,
		codex_id = "x_tc_deployment",
	},

	-------------------- THE NETWORK ------------------
	----------------------------------------------------
	{
		headertxt = "The Network",
		txt = [[You have a <hl>network</> <img image="Main/textures/codex/icons/network_button.png" width="32" height="32"/> which will handle basic <hl>logistics</> and supply <hl>power</> to units and buildings. Automated delivery of items will only happen inside the network.]],

		check = function(f, cache)
			local profile = Game.GetProfile()
			local os = Game.GetProfile().overlay_settings
			local mode = (type(os) == "table" and os.mode or 2)
			local modetbl = (type(os) == "table" and os[mode])
			local overlay_power = (modetbl and modetbl.power) or  (not modetbl and mode == 3)
			return overlay_power
		end,
		min_txt = [[Toggle the <hl>logistics network</> overlay (<Key action="PowerInfo_Toggle" style="hl"/>)]],
		codex_id = "x_tc_logistics",
	},

	--------------- Production Building -----------------
	-----------------------------------------------------
	{
		headertxt = "Deployable Building",
		min_txt = [[Drag the <img id="c_deployer" width="32" height="32" style="hl"/> onto your <img id="f_bot_1s_as" width="32" height="32" style="hl"/>]],
		txt = [[You have been given a <hl>deployable building</>.

Select the <img id="f_spacedrop" width="32" height="32" style="hl"/> to access its inventory.]],
		check = function(f)
			local droppod = GetEntityWithFrame(f, "f_spacedrop")
			if not droppod then return true end
			local entity = View.GetSelectedEntity()
			local slot = droppod and droppod:FindSlot("c_deployer")
			if entity == droppod and slot then
				TutorialNotification.open:GlowUIWidget("slot", slot)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end

			if f:GetItemAmount("c_deployer") == 0 then return true end -- in case they deployed it early
			local scout = GetEntityWithFrame(f, "f_bot_1s_as")
			if not scout then return true end -- if theres no scout then skip its
			return scout and scout:FindComponent("c_deployer")
		end,
		begin = function()
			local f = Game.GetLocalPlayerFaction()
			local droppod = GetEntityWithFrame(f, "f_spacedrop")
			local scout = GetEntityWithFrame(f, "f_bot_1s_as")
			if not droppod or not scout then return end
			TutorialNotification.open:DrawLineEntity(droppod, scout)
		end,
		codex_id = "x_tc_deployment",
	},

	-------------------- DROP POD ------------------------
	------------------------------------------------------
	{
		headertxt = "Deployable Building",
		min_txt = "Deploy production building",
		txt = [[With the <img id="f_bot_1s_as" width="32" height="32" style="hl"/> selected, click <hl>Deploy</> and place the building in an open area away from your <img id="f_landingpod" width="32" height="32" style="hl"/>.]],
		begin = function()
			TutorialNotification.open:DrawLineEntity()
			TutorialNotification.open:GlowUIWidget("text", "Deploy")
			-- ping scout
			local scout = GetEntityWithFrame(Game.GetLocalPlayerFaction(), "f_bot_1s_as")
			if scout then
				View.PlayEffect("fx_ping", scout.location.x, scout.location.y)
			end
		end,
		check = function(f)
			return GetEntityWithFrame(f, "f_building1x1d")
		end,
		-- codex_id = "x_production",
		codex_id = "x_tc_deployment",
	},

	{
		headertxt = "Start Mining",
		min_txt = [[Start mining <hl>Metal Ore</> and <hl>Crystal Chunks</>]],
		txt = [[Set both <img width="32" height="32" id="f_bot_1s_adw" style="hl"/> to start mining, one on a <img width="32" height="32" id="f_resourcenode_metal" style="hl"/> and one on a <img width="32" height="32" id="f_resourcenode_crystal" style="hl"/> using <Key action="ExecuteAction" style="hl"/>]],

		begin = function()
			local eng = GetEntityWithFrame(Game.GetLocalPlayerFaction(), "f_bot_1s_adw")
			if eng then
				View.PlayEffect("fx_ping", eng.location.x, eng.location.y)
			end
			local metalore = Map.GetEntityAt(10,18)
			if metalore then
				View.PlayEffect("fx_ping", metalore.location.x, metalore.location.y)
			end
		end,

		check = function(f, cache)
			-- Find all engineers
			local hasMetalOre, hasCrystal, idleEngineer = false, false
			for _, entity in ipairs(f.entities) do
				if entity.def.id == "f_bot_1s_adw" then
					local miner = entity:FindComponent("c_miner", true)
					if miner then
						local reg = miner:GetRegister(1)
						if reg.id == 'metalore' or (reg.entity and GetResourceHarvestItemId(reg.entity) == 'metalore') then
							hasMetalOre = entity
						elseif reg.id == 'crystal' or (reg.entity and GetResourceHarvestItemId(reg.entity) == 'crystal') then
							hasCrystal = entity
						elseif not idleEngineer then
							idleEngineer = entity
						end
					end
				end
			end
			if not cache.miner_line or not hasMetalOre then
				-- show metalore line
				if cache.miner_line ~= 'metalore' then
					local metalore = Map.GetEntityAt(10,18)
					TutorialNotification.open:DrawLineEntity(idleEngineer or hasCrystal, metalore)
					cache.miner_line = 'metalore'
				end
			elseif not hasCrystal then
				if cache.miner_line == 'metalore' then
					local crystal = Map.GetEntityAt(20, 20)
					TutorialNotification.open:DrawLineEntity(idleEngineer or hasMetalOre, crystal)
					cache.miner_line = 'crystal'
				end
			end

			return hasMetalOre and hasCrystal
		end,
		done = function(c) c.miner_line = nil TutorialNotification.open:DrawLineEntity() end,

		codex_id = "x_tc_unit",
	},

	-------------------- Equip Fabricator ------------------------
	{
		headertxt = "Equip Fabricator",
		min_txt = [[Equip <img id="c_fabricator" width="32" height="32" style="hl"/> in a medium socket]],
		txt = [[Select the <img id="f_landingpod" width="32" height="32" style="hl"/> and drag the <img id="c_fabricator" width="32" height="32" style="hl"/> from your inventory into a free <hl>medium socket</> <img image="Main/textures/codex/icons/MSocket.png" width="32" height="32"/>.]],
		check = function(f)
			local landingpod = GetEntityWithFrame(f, "f_landingpod")
			local entity = View.GetSelectedEntity()
			local slot = landingpod:FindSlot("c_fabricator")
			if entity == landingpod and slot then
				--TutorialNotification.open:GlowUIWidget("slot", slot)
				TutorialNotification.open:GlowUIWidget("image", "icon_m_socket")
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end
			return not landingpod or landingpod:FindComponent("c_fabricator")
		end,
		codex_id = "x_tc_components",
	},

	-------------------- Production Components --------------------

	{
		headertxt = "Production Components",
		min_txt = [[Set the Command Center to produce <hl>3 Fabricators</>]],
		txt = [[We'll expand production with more <hl>Fabricators</> for our production buildings. Components are required to be built separately.]],
		check = function(f)
			local landingpod = GetEntityWithFrame(f, "f_landingpod")
			local fab = landingpod:FindComponent("c_fabricator", false)
			if fab and fab:GetRegisterId(1) ~= "c_fabricator" then
				TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end
			return not landingpod or landingpod:CountItem("c_fabricator") > 2
		end,
		codex_id = "x_tc_production",
	},

	--------------------          14            ------------------
	-------------------- START A DEDICATED BUILDING  ---------------
	----------------------------------------------------------------
	-- and then resources will be added to complete it.
	{
		headertxt = "Setting up Production",
		min_txt = [[Construct a <img id="f_building1x1d" width="32" height="32" style="hl"/> using the <hl>build menu</> (<Key action="Build" style="hl"/>) <img image="Main/textures/codex/icons/icon_build.png" width="32" height="32"/>]],
		txt = [[Automate production of <img id="metalbar" width="32" height="32" style="hl"/> by constructing a dedicated production building.]],

		check = function(f)
			local mbcount = 0
			for _,v in ipairs(f.entities) do
				if v.id == "f_building1x1d" then
					mbcount = mbcount + 1
					if mbcount == 2 then return true end
				end
			end

			return false
		end,
		begin = function() TutorialNotification.open:GlowUIWidget("id", "btn_build") end,
		done = function() TutorialNotification.open:GlowUIWidget(nil) end,
		--[[
		begin = function()
			local sidebuttons = UI.FindWidgetWithProperty("id", "sidebuttons")
			if sidebuttons then
				sidebuttons:TweenFromTo("opacity", 0, 1, 400, function() TutorialNotification.open:GlowUIWidget("id", "btn_build") end)
				sidebuttons.hidden = false
			end
		end,
		--]]
		codex_id = "x_tc_buildings",
	},

	-------------------------------------------------------- 14-1
	-------------------- USE REQUESTOR  --------------------
	--------------------------------------------------------
	{
		headertxt = "Requesting Component",
		min_txt = [[Request a <img id="c_fabricator" width="32" height="32" style="hl"/>]],
		txt = [[Select the new building and click the <hl>Request Item</> button <img image="Main/textures/codex/icons/request_button.png" color="ui_light" width="32" height="32"/> to request one <hl>Fabricator</>. Requests deliver existing items via the network.]],

		begin = function()
			local f = Game.GetLocalPlayerFaction()
			for _,v in ipairs(f.entities) do
				if v.id == "f_building1x1d" then
					local fab = v:FindComponent("c_fabricator")
					if not fab then
						View.PlayEffect("fx_ping", v.location.x, v.location.y)
						return
					end
				end
			end
		end,

		check = function(f)
			local entity = View.GetSelectedEntity()
			if entity and entity.id == "f_building1x1d" then
				TutorialNotification.open:GlowUIWidget("tooltip", "Request Item")
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end
			local orders = f:GetActiveOrders()
			for i,o in ipairs(orders) do
				if o.target_entity.id == "f_building1x1d" and o.item_id == "c_fabricator" then
					return true
				end
			end
		end,
		codex_id = "x_tc_unit",
	},

	------------------------------------------------------------------ 14-2
	-------------------- Equip Fabricator and set production  -------
	------------------------------------------------------------------
	{
		headertxt = "Production Components",
		min_txt =[[Set production to <img width="32" height="32" id="metalbar" style="hl"/>]],
		txt = [[Set the <hl>production</> register to <img width="32" height="32" id="metalbar" style="hl"/>.]],

		check = function(f)
			--local fabdef = data.components.c_fabricator
			local entity = View.GetSelectedEntity()
			local fab = entity and entity:FindComponent("c_fabricator", false)
			if fab and entity.id == "f_building1x1d"  then
				TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end

			-- find two buildings1x1d with metal bar production
			local mbcount = 0
			for _,v in ipairs(f.entities) do
				if v.id == "f_building1x1d" then
					local fab = v:FindComponent("c_fabricator")
					if fab then
						local reg = fab:GetRegister(1)
						if reg and reg.id == 'metalbar' then mbcount = mbcount + 1 end
					end
				end
			end
			if mbcount >= 2 then return true end
		end,
		codex_id = "x_tc_production",
	},

	--------------------          14            ------------------
	-------------------- START A DEDICATED BUILDING  ---------------
	----------------------------------------------------------------
	{
		headertxt = "Duplicate a Building",
		min_txt = "Copy and paste a production building",
		txt = [[Copy an existing building by pressing <Key style="hl" action="UnitCopy"/>. Move the mouse over an empty tile and activate the build cursor with the copied structure by pressing <Key style="hl" action="UnitPaste"/>. Use <Key action="SelectAction"/> to place a construction site.

You can always <hl>relocate</> buildings from the <hl>unit options</> menu.]],
		check = function(f)
			-- find three buildings1x1d with metal bar production
			local mbcount = 0
			for _,v in ipairs(f.entities) do
				local fab = v:FindComponent("c_fabricator")
				if fab then
					local reg = fab:GetRegister(1)
					if reg and reg.id == 'metalbar' then mbcount = mbcount + 1 end
				end
			end
			if mbcount > 2 then return true end
		end,
		codex_id = "x_tc_buildings",
	},

	{
		headertxt = "Edit and Place a Building",
		min_txt = [[Place another building that produces <img id="metalplate" width="32" height="32" style="hl"/>.]],
		txt = [[Copy one of the <img id="metalbar" width="32" height="32" style="hl"/> production buildings (<Key style="hl" action="UnitCopy"/>), put it in the build cursor (<Key style="hl" action="UnitPaste"/>), then use <hl>Ctrl+</><Key action="SelectAction"/> to show the <hl>construction editor</>.
Set the <hl>production</> register to <img width="32" height="32" id="metalplate" style="hl"/>.

This can also be used to <hl>upgrade</> existing buildings.]],

		check = function(f)
			--[[
			local entity = View.GetSelectedEntity()
			local fab = entity and entity:FindComponent("c_fabricator", false)
			if fab and entity.id == "f_building1x1d"  then
				TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end
			--]]
			return f:GetItemTotals("metalplate") > 0
		end,
		codex_id = "x_tc_buildings",
	},

	----------------- Produce more Runner Bots ----------------
	{
		headertxt = "Integrated Components",
		min_txt = [[Produce two <img width="32" height="32" id="f_carrier_bot" style="hl"/>]],
		txt = [[Use the <img width="32" height="32" id="c_carrier_factory" style="hl"/> in your <img id="f_landingpod" width="32" height="32" style="hl"/> to produce <hl>two</> more Runner bots.]],
		check = function(f)
			local entity = View.GetSelectedEntity()
			local fab = entity and entity:FindComponent("c_carrier_factory", false)
			if fab and entity.id == "f_landingpod"  then
				TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end

			local runners = 0
			for _,v in ipairs(f.entities) do
				if v.id == "f_carrier_bot" then runners = runners + 1 end
			end
			return runners >= 4
		end,
		codex_id = "x_tc_components",
	},

	---------------------------------------------------------
	-- ------------ MAKE An ASSEMBLER -----------------------
	---------------------------------------------------------
	{
		headertxt = "Advanced Production: Assembler",
		min_txt = [[Produce and equip an <img id="c_assembler" width="32" height="32" style="hl"/>]],
		txt = [[On your <img id="f_landingpod" width="32" height="32" style="hl"/> use the <img id="c_fabricator" widht="32" height="32" style="hl"/> to produce an <img id="c_assembler" width="32" height="32" style="hl"/>.]],

		check = function(f)
			local landingpod = GetEntityWithFrame(f, "f_landingpod")
			local entity = View.GetSelectedEntity()
			local slot = landingpod:FindSlot("c_assembler")
			if entity == landingpod and slot then
				TutorialNotification.open:GlowUIWidget("slot", slot)
			else
				local fab = entity == landingpod and landingpod:FindComponent("c_fabricator", false)
				if fab then
					TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
				else
					TutorialNotification.open:GlowUIWidget(nil)
				end
			end

			return not landingpod or landingpod:FindComponent("c_assembler")
		end,
		codex_id = "x_tc_production",
	},

	--------------------------------------------------------------------22
	----------------- MAKE an UPLINK and Start Research ----------------
	--------------------------------------------------------------------
	{
		headertxt = "Equip an Uplink",
		min_txt = [[Produce and equip an <img id="c_uplink" width="30" height="30" style="hl"/> on your Command Center]],
		txt = [[An <img id="c_uplink" width="30" height="30" style="hl"/> is required to access your technology research tree.

You may need to unequip another component to make space for the uplink.]],
		check = function(f)
			local landingpod = GetEntityWithFrame(f, "f_landingpod")
			local entity = View.GetSelectedEntity()
			local slot = landingpod:FindSlot("c_uplink")
			if entity == landingpod and slot then
				TutorialNotification.open:GlowUIWidget("slot", slot)
			else
				local fab = landingpod:FindComponent("c_assembler", false)
				if fab then
					TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
				else
					TutorialNotification.open:GlowUIWidget(nil)
				end
			end

			for _,v in ipairs(f.entities) do
				if v:FindComponent("c_uplink") then return true end
			end
		end,
		codex_id = "x_tc_production",
	},

	---------------------------------------------------------------23
	----------------------- Pick Research  ------------------------
	---------------------------------------------------------------
	{
		headertxt = "Research Basic Structures",
		min_txt = [[Start research on <img width="32" height="32" id="t_structures1" style="hl"/>]],
		txt = [[Open the <hl>research window</> (<Key action="Tech" style="hl"/>) <img image="Main/textures/codex/icons/techtree_icon.png" width="32" height="32"/>.]],

		check = function(f)
			if UI.FindWidgetWithProperty("id", "queue_box") then -- check for tech tree
				TutorialNotification.open:GlowUIWidget("text", "Set Research")
			else
				--[[
				local landingpod = GetEntityWithFrame(f, "f_landingpod")
				local fab = landingpod and View.IsSelectedEntity(landingpod) and landingpod:FindComponent("c_uplink", false)
				if fab then
					TutorialNotification.open:GlowUIWidget("abs_index", fab.register_index)
				else
					--]]
				TutorialNotification.open:GlowUIWidget("id", "btn_tech")
				--end
			end

			local rq = f.extra_data.research_queue
			return rq and rq[1] or f:IsUnlocked("t_structures1")
		end,
		codex_id = "x_tc_research",
	},

	{
		headertxt = "Build Storage and Set Store Location",
		min_txt = "Build <hl>Storage Blocks</> and Set Both Engineer's <hl>Store register</>",
		txt = [[Construct two <img id="f_building1x1f" width="32" height="32" style="hl"/> buildings.

On each of your <img width="32" height="32" id="f_bot_1s_adw" style="hl"/> set their <hl>Store</> <img image="Main/textures/codex/icons/register_store.png" width="32" height="32"/> register to tell them where to store their items.]],

		check = function(f)
			-- Update UI glow based on selected entity
			local entity = View.GetSelectedEntity()
			if entity and entity.id == "f_bot_1s_adw" and entity.def.movement_speed then
				TutorialNotification.open:GlowUIWidget("reg_index", 2)
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end

			-- Count how many miners have store register set
			local minersWithStore = 0
			for _,v in ipairs(f.entities) do
				if v.id == "f_bot_1s_adw" and v:GetRegisterEntity(FRAMEREG_STORE) then
					if minersWithStore >= 1 then return true end
					minersWithStore = minersWithStore + 1
				end
			end

			return false
		end,

		codex_id = "x_tc_registers",
	},

	-------------------------------------------------
	----------Automate Reinforced Plate -------------
	-------------------------------------------------
	{
		headertxt = "Expanding Production",
		min_txt = [[Build Medium Production Building for <img width="32" height="32" id="reinforced_plate" style="hl"/>]],
		txt = [[Construct a <img id="f_building2x1g" width="32" height="32" style="hl"/>, then equip an <img width="32" height="32" id="c_assembler" style="hl"/> and set its production to <img width="32" height="32" id="reinforced_plate" style="hl"/>.

You will need to produce the <hl>Assembler</> separately.]],
		check = function(f)
			-- Check if medium socket building exists
			local hasBuilding = GetEntityWithFrame(f, "f_building2x1f") or GetEntityWithFrame(f, "f_building2x1g")

			if not hasBuilding then
				return false
			end

			-- Check if assembler is producing reinforced plates
			for _,v in ipairs(f.entities) do
				local assembler = v.id ~= "f_landingpod" and v:FindComponent("c_assembler")
				if assembler and assembler:GetRegisterId(1) == 'reinforced_plate' then
					return true
				end
			end

			return false
		end,

		codex_id = "x_tc_buildings",
	},

	----------------------------------------------
	----------Automate Circuit Boards-------------
	----------------------------------------------
	{
		headertxt = "Advanced Materials: Circuit Boards",
		min_txt = [[Start <img id="circuit_board" width="32" height="32" style="hl"/> production]],
		txt = [[Produce another building to produce <img id="circuit_board" width="32" height="32" style="hl"/>.
Remember you can use <hl>Ctrl+</><Key action="SelectAction" style="hl"/> to customize a building before placing it.]],

		check = function(f)
			for _,v in ipairs(f.entities) do
				local assembler = v.id ~= "f_landingpod" and v:FindComponent("c_assembler")
				if assembler and assembler:GetRegisterId(1) == 'circuit_board' then
					return true
				end
			end
		end,
		codex_id = "x_tc_buildings",
	},

	-------- Research/Expand Power Grid to Start Mining Silica --------

	{
		headertxt = "Research Basic Power",
		min_txt = [[Research the basic power technology]],
		txt = [[Open <hl>Research</> and set <img width="32" height="32" id="t_power0" style="hl"/> as your research.]],

		check = function(f)
			if f:IsUnlocked("t_power0") then return true end
			local rq = f.extra_data.research_queue
			if (not rq or rq[1] ~= "t_power0") and not UI.FindWidgetWithProperty("id", "queue_box") then
				TutorialNotification.open:GlowUIWidget("id", "btn_tech")
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end
		end,
		codex_id = "x_tc_research",
	},

	{
		headertxt = "Power",
		txt = [[You will require more <hl>power</> to run more production. Power can be extracted from crystals to help you get started. More power options will become available later.]],
		min_txt = [[Equip a <img id="c_crystal_power" width="32" height="32" style="hl"/> component on a building <img id="f_building1x1d" width="32" height="32"/>]],

		check = function(f)
			for _,v in ipairs(f.entities) do
				local fab = v:FindComponent("c_crystal_power")
				if fab then return true end
			end
			return false
		end,
		codex_id = "x_tc_power",
	},

	{
		headertxt = "Network Expansion",
		min_txt = [[Place a building with a Small Power Field near the plateau]],
		txt = [[Produce and equip a <img id="c_small_relay" width="32" height="32" style="hl"/> on a building near the <img id="f_resourcenode_silica" width="32" height="32" style="hl"/> but still inside your <hl>network</>.]],
		check = function(f)
			local relays = f:GetEntitiesWithComponent("c_small_relay")
			return #relays > 0
		end,
		codex_id = "x_tc_power",
	},

	---------------------------------------------------
	----------------- Start Mine Silica----------------
	---------------------------------------------------
	-- 		-- will continue after mining 1 silica
	{
		headertxt = "Mine Silica Sand",
		min_txt = [[Set a unit to mine <img id="silica" width="32" height="32" style="hl"/>]],
		txt = [[<img id="silica" width="32" height="32" style="hl"/> can be found on the plateau. You can build a <img id="f_bot_1s_a" width="24" height="24" style="hl"/> unit with a <img id="c_miner" width="24" height="24" style="hl"/> component to create a simple mining bot.]],

		check = function(f) return f:GetItemTotals("silica") > 0 end,
		codex_id = "x_tc_resources_mining",
	},

	---------------------------------------------------------
	--------------- Set up Transport Route 1 ----------------
	---------------------------------------------------------
	{
		headertxt = "Set up Transport Route",
		txt = [[Build a <img id="f_building1x1f" width="32" height="32" style="hl"/>, then select a <img id="f_carrier_bot" width="32" height="32" style="hl"/> and activate its <hl>transport route</> button <img image="Main/textures/codex/icons/transport_route.png" width="32" height="32"/>.]],

		check = function(f)
			local entity = View.GetSelectedEntity()
			if entity and entity.id == "f_carrier_bot" then
				TutorialNotification.open:GlowUIWidget("id", "action_transport")
			else
				TutorialNotification.open:GlowUIWidget(nil)
			end

			for _,v in ipairs(f.entities) do
				if v.logistics_transport_route == true then
					return true
				end
			end
		end,
		min_txt = "Build storage and turn on a runner's transport route",
		codex_id = "x_tc_transport_route",
	},

	---------------------------------------------------------
	--------------- Set up Transport Route 2 ----------------
	---------------------------------------------------------
	-- <nt>Note: Alternatively you can drag from the</> <hl>Goto</> button <img image="Main/textures/codex/icons/register_goto.png" width="30" height="30"/> directly to the <hl> Mining Bot</> (or simply click on it with <Key action="ExecuteAction" style="hl"/>)
	{
		headertxt = "Set up Transport Route",
		txt = [[Set the <hl>Goto</> register <img image="Main/textures/codex/icons/register_goto.png" width="30" height="30"/> of the runner to the unit mining silica to pick up from it.]],

		check = function(f)
			for _,v in ipairs(f.entities) do
				if v.logistics_transport_route == true then
					local goto_reg_ent = v:GetRegisterEntity(1)
					if goto_reg_ent and goto_reg_ent:FindComponent("c_miner", true) then
						return true
					end
				end
			end
		end,
		min_txt = "Set the <hl>Unit Mining Silica</> as the <hl>Goto</> point",
		codex_id = "x_tc_transport_route",
	},

	---------------------------------------------------------
	--------------- Set up Transport Route 3 ----------------
	---------------------------------------------------------
	-- <nt>Note: Again you can do this by dragging directly or by clicking on it</> (in this case with <hl>Ctrl +</> <Key action="ExecuteAction" style="hl"/>)
	{
		headertxt = "Set up Transport Route 3",
		txt = [[Set the <hl>Store</> register <img image="Main/textures/codex/icons/register_store.png" width="30" height="30"/> to the <img id="f_building1x1f" width="32" height="32" style="hl"/> to drop off its items.]],

		check = function(f)
			for _,v in ipairs(f.entities) do
				if v.logistics_transport_route == true then
					local goto_reg_ent = v:GetRegisterEntity(2)
					if goto_reg_ent and goto_reg_ent.id == "f_building1x1f" then
						return true
					end
				end
			end
		end,
		min_txt = "Set the <hl>Storage Unit</> as the <hl>Store</> location",
		codex_id = "x_tc_transport_route",
	},

	---------------------------------------------------------------
	----------------------- Completion  ---------------------------
	---------------------------------------------------------------
	{
		headertxt = "Congratulations",
		--voice = "fx_tutor_complete",
		txt = [[Now that you have learnt the basics of base building you are ready to continue with your mission to <hl>repair the Mothership</>.

The tutorial begins in <hl>passive mode</> meaning the native population of bugs will not come out of their <img id="f_bug_hive" width="32" height="32" style="hl"/> or <img id="f_bug_hole" width="32" height="32" style="hl"/> until you attack them.]],
	},

	---------------------------------------------------------20
	------------------ HOSTILITY -------------------------
	---------------------------------------------------------
	-- If you wish to end Passive Mode simply attack one of these.
	{
		headertxt = "Behaviors",
		txt = [[<hl>Behaviors</> are an advanced mechanic for controlling units. To get started, add an <hl>Integrated Behavior</> to a unit via the <hl>unit options</> menu.

More information and story dialogue can be found in the <hl>Codex</> (<Key action="Codex" style="hl"/>).]],
		begin = function() TutorialNotification.open:GlowUIWidget("id", "menubtn") end,
		done = function() TutorialNotification.open:GlowUIWidget(nil) end
	},

	---------------------------------------------------------------24
	----------------------- Continuation  ---------------------------
	---------------------------------------------------------------
	{
		headertxt = "Continuation",
		--voice = "fx_tutor_complete",
		txt = [[You can choose to continue to play this game or start a <hl>new game</> and customize many of the gameplay settings for your playstyle.

Good luck, <hl>Commander</>!]],
	},
}
