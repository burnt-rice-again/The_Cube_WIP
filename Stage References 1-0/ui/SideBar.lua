local SideBar_layout<const> =
[[
<Canvas>
	<VerticalList dock=top-right margin=4 width=300 child_padding=2>
		<HorizontalList child_padding=2>
			<Box padding=5 fill=true tooltip={time_tooltip}>
				<Canvas>
					<Image id=sunrise_icon image=icon_small_day   width=20 height=20 color=ui_light/>
					<Image id=sunset_icon  image=icon_small_night width=20 height=20 color=ui_light/>
					<Progress id=time_bar progress=0.5 y=24 height=16 width=120 color=ui_light/>
					<Image id=sunrise_arrow width=2 height=18 y=20 color=ui_light/>
					<Image id=sunset_arrow  width=2 height=18 y=20 color=ui_light/>
					<Text id=txt_pause text="Paused" width=0 textalign=center hidden=true/>
					<Text id=time_day width=0 textalign=center x=164 y=-2/>
					<Text id=time_txt width=0 textalign=center x=164 y=18/>
					<Button dock=right id=btn_pause width=40 height=40 icon=icon_pause on_click={on_click_pause}/>
					<HorizontalList y=42 height=8 width=290>
						<Progress id=leftbar height=10 valign=center sx=-1 fill=true color=virus/>
						<Image width=2 height=8 valign=center color=ui_dark/>
						<Progress id=rightbar height=10 valign=center fill=true color=blight/>
					</HorizontalList>
				</Canvas>
			</Box>
			<Box padding=4>
				<Button dock=center width=40 height=40 icon=icon_menu id=btn_menu window=InGameMenu on_click={on_open_window}/>
			</Box>
		</HorizontalList>
		<VerticalList id=sidebar child_padding=4>
			<Box padding=4>
				<VerticalList>
					<Canvas id=mapbox margin_bottom=5 py=0 height=290>
						<VerticalList id=bigmapbuttons child_padding=5 valign=fill>
							<Button width=32 height=32 icon=icon_small_zoom_in tooltip="Zoom In" on_click={on_map_zoomin}/>
							<Button width=32 height=32 icon=icon_small_zoom_out tooltip="Zoom Out" on_click={on_map_zoomout}/>
							<Spacer fill=true/>
							//<Button width=32 height=32 icon=icon_small_sort tooltip="Filter" on_click={on_map_filter}/>
							<Button width=32 height=32 icon=icon_small_edit tooltip="Edit Pins" on_click={on_map_pin}/>
							<Button id=mapbtnunits width=32 height=32 icon=icon_small_object tooltip="Show Units/Buildings on Minimap" on_click={on_map_units}/>
							<Button id=mapbtnpower width=32 height=32 icon=icon_carry tooltip="Show Networks on Minimap" on_click={on_map_power}/>
							<Button id=mapbtnfollow1 width=32 height=32 icon=icon_small_stick_to tooltip="Minimap Follows Camera" on_click={on_map_focuscamera}/>
						</VerticalList>
						<Minimap id=minimap on_follow_camera_changed={on_follow_camera_changed} width=294 height=294 dock=top-left/>
						<HorizontalList id=textoverlay fill=true>
							<Text id=mapcoords margin_left=6/>
							<Spacer fill=true/>
							<Text id=timeplayed margin_right=6 textalign=right/>
						</HorizontalList>
					</Canvas>
					<HorizontalList child_padding=3 margin_top=3>
						<Button width=32 height=32 icon=icon_small_navigation tooltip="Reset Camera" on_click={on_reset_rotation}/>
						<Button id=overlaybtn width=32 height=32 icon=icon_small_visual on_click={on_open_overlay_options}/>
						<Button id=camfollowbtn width=32 height=32 icon=icon_small_camera on_click={on_toggle_follow}/>
						<Spacer fill=true/>
						<Button id=bigmapbtn width=32 height=32 icon=icon_remote on_click={on_map_fullscreen}/>
						<Button id=zoominbtn width=32 height=32 icon=icon_small_zoom_in tooltip="Zoom In" on_click={on_map_zoomin}/>
						<Button id=zoomoutbtn width=32 height=32 icon=icon_small_zoom_out tooltip="Zoom Out" on_click={on_map_zoomout}/>
						<Button id=editpinbtn width=32 height=32 icon=icon_small_edit tooltip="Edit Pins" on_click={on_map_pin}/>
						<Button id=mapbtnfollow2 width=32 height=32 icon=icon_small_stick_to tooltip="Minimap Follows Camera" on_click={on_map_focuscamera}/>
					</HorizontalList>
					<Button height=16 icon=icon_small_arrow_up margin_top=4 on_click={on_map_collapse}/>
				</VerticalList>
			</Box>
			<Notifications/>
		</VerticalList>
	</VerticalList>
	<Box id=sidebuttons padding=4 dock=bottom-right margin=4>
		<VerticalList child_padding=4>
			<Button width=50 height=50 icon=icon50_Tech     id=btn_tech     window=Tech         on_click={on_open_window}/>
			<Button width=50 height=50 icon=icon50_Build    id=btn_build    window=BuildView    on_click={on_open_window}/>
			<Button width=50 height=50 icon=icon50_Progress id=btn_progress window=ProgressView on_click={on_open_window}/>
			<Button width=50 height=50 icon=icon50_Codex    id=btn_codex    window=Codex        on_click={on_open_window}/>
			<Button width=50 height=50 icon=icon50_Library  id=btn_library  window=Library      on_click={on_open_window}/>
			<Button width=50 height=50 icon=icon50_Faction  id=btn_faction  window=Faction      on_click={on_open_window}/>
		</VerticalList>
	</Box>
</Canvas>
]]

local Paused_layout<const> =
[[
	<Canvas dock=center y=-350>
		<Box dock=fill opacity=0.7/>
		<Image color="#5CEBA319" dock=fill/>
		<Image image=warning_pattern color="#60D4A2" dock=top-right/>
		<Text textalign=center text="Paused" style=notify_info width=446 wrap=true fill=true valign=center/>
	</Canvas>
]]

local SideBar<const> = {}
local SideBarOpen, MinimapCoordsOpen, PausedOpen
local timestr_sunrise, timestr_sunset
local season_names = { "Winter", "Spring", "Summer", "Fall" }

UI.Register("SideBar", SideBar_layout, SideBar)

function SideBar:construct()
	SideBarOpen, MinimapCoordsOpen = self, self.mapcoords

	local timebarwidth = self.time_bar.width - 4
	local sunrise, sunset = Map.GetSunriseAndSunset()
	self.sunrise_icon.x, self.sunrise_arrow.x = 2 + sunrise * timebarwidth - 10, 2 + sunrise * timebarwidth - 1
	self.sunset_icon.x,  self.sunset_arrow. x = 2 + sunset  * timebarwidth - 10, 2 + sunset  * timebarwidth - 1
	self.txt_pause.x = (self.sunrise_arrow.x + self.sunset_arrow.x) / 2 + 1
	timestr_sunrise = string.format("%02d:%d0", math.floor(sunrise * 24), math.floor(sunrise * 144 % 6))
	timestr_sunset = string.format("%02d:%d0", math.floor(sunset * 24), math.floor(sunset * 144 % 6))

	local mapfollow = self.minimap.follow_camera
	self.mapbtnfollow1.active = mapfollow
	self.mapbtnfollow2.active = mapfollow
	self.mapbtnunits.active = not self.minimap.hide_entities
	self.mapbtnpower.active = self.minimap.show_power_grid
	self:RefreshTooltips()
	self:RefreshMapPins()
	SideBar.RefreshToggles()
end

function SideBar:RefreshTooltips()
	local mapttfmt, ttfmt = '%s (<Key action="%S"/>)', '<header>%s (</><Key action="%S" style="Header"/><header>)</>'
	self.overlaybtn.tooltip   = L(mapttfmt, "Overlay Settings",       "OverlaySettings")
	self.camfollowbtn.tooltip = L(mapttfmt, "Follow Camera",          "Camera_FollowTarget")
	self.bigmapbtn.tooltip    = L(mapttfmt, "Toggle full screen map", "Map")
	self.btn_pause.tooltip    = L(ttfmt, "Pause",                "PauseGame")
	self.btn_menu.tooltip     = L(ttfmt, "Menu",                 "InGameMenu")
	self.btn_tech.tooltip     = L(ttfmt, "Research",             "Tech")
	self.btn_build.tooltip    = L(ttfmt, "Build",                "Build")
	self.btn_codex.tooltip    = L(ttfmt, "Codex",                "Codex")
	self.btn_progress.tooltip = L(ttfmt, "Progress",             "Progress")
	self.btn_library.tooltip  = L(ttfmt, "Library",              "Library")
	self.btn_faction.tooltip  = L(ttfmt, "Control Center",       "FactionView")
end

function SideBar:destruct()
	SideBarOpen, MinimapCoordsOpen = nil, nil
end

function SideBar:update()
	local total = Map.GetTotalDays()
	self.time_day.text = L("Day %d", math.floor(total + 1))
	self.time_txt.text = string.format("%02d:%d0", math.floor(total * 24 % 24), math.floor(total * 144 % 6))
	self.time_bar.progress = (total % 1.0)

	local pause = (Map.GetGameSpeed() == 0)
	if self.lastpause ~= pause then
		self.lastpause = pause
		self.txt_pause.hidden = not pause
		self.btn_pause.active = pause
		if pause and not PausedOpen then
			PausedOpen = UI.AddLayout(Paused_layout)
		elseif PausedOpen then
			PausedOpen:RemoveFromParent()
			PausedOpen = nil
		end
		--View.SetPostProcess("ScreenStaticAmount", pause and 0.15 or 0)
	end
	self.timeplayed.text = Tool.GetTimeDurationStr(Game.GetGameDuration())
	local v = StabilityGet()
	self.leftbar.progress = (v < 0 and (v / -10000.0) or 0)
	self.rightbar.progress = (v > 0 and (v / 10000.0) or 0)
end

function SideBar:on_click_pause()
	Action.SendFromPlayer("PauseGame", { pause = (Map.GetGameSpeed()>0) })
end

function SideBar:time_tooltip()
	return UI.New([[<Box padding=8 bg=popup_box_bg blur=true><VerticalList>
			<HorizontalList child_align=center><Image image=icon_tiny_day      color=ui_light margin_right=4/><Text id=sunrise width=100/><Text text="Sunrise"         color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_night    color=ui_light margin_right=4/><Text id=sunset  width=100/><Text text="Sunset"          color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_calendar color=ui_light margin_right=4/><Text id=year    width=100/><Text text="Year"            color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_calendar color=ui_light margin_right=4/><Text id=season  width=100/><Text text="Season"          color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_calendar color=ui_light margin_right=4/><Text id=next    width=100/><Text id=labelnext           color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_tick     color=ui_light margin_right=4/><Text id=tick    width=100/><Text text="Simulation Tick" color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_save     color=ui_light margin_right=4/><Text id=save    width=100/><Text text="Since Last Save" color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_duration color=ui_light margin_right=4/><Text id=played  width=100/><Text text="Time Played"     color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_time     color=ui_light margin_right=4/><Text id=current width=100/><Text text="Current Time"    color=ui_light fill=true textalign=right/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_energy_up  color=ui_light margin_right=4/><Text id=stability width=100/><Text text="Stability"    color=ui_light fill=true textalign=right/></HorizontalList>
		</VerticalList></Box>]], {
		update = function(w)
			w.sunrise.text = timestr_sunrise
			w.sunset.text = timestr_sunset

			local season = Map.GetYearSeason()
			local season_no = (math.floor((season + 0.125) * 4.0) % 4) + 1
			local daysremain = (0.25 - ((season + 0.125) % 0.25)) * Map.GetSettings().days_per_year -- days until next season
			w.year.text = Map.GetYear() + 1
			w.season.text = season_names[season_no]
			if daysremain >= 1 then
				w.next.text = string.format("%d", math.floor(daysremain))
				w.labelnext.text = L("Days until %s", season_names[(season_no % 4) + 1])
			else
				w.next.text = string.format("%d", math.floor(daysremain * 24))
				w.labelnext.text = L("Hours until %s", season_names[(season_no % 4) + 1])
			end

			w.tick.text = Map.GetTick()
			w.save.text = Tool.GetTimeDurationStr(Game.GetTimeSinceSave())
			w.played.text = Tool.GetTimeDurationStr(Game.GetGameDuration())
			w.current.text = NOLOC(Tool.GetDateStr("%X"))
			w.stability.text = StabilityGet()
		end
	})
end
function SideBar:on_reset_rotation(btn, mousebtn)
	View.ResetCamera(mousebtn ~= "LEFTMOUSEBUTTON")
end

function SideBar:on_open_overlay_options(btn)
	OpenOverlayOptions(btn)
end

function SideBar:on_map_collapse(btn)
	local mapbox = self.mapbox
	local new_hidden = not mapbox.hidden
	btn.icon = new_hidden and "icon_small_arrow_down" or "icon_small_arrow_up"
	btn.active = new_hidden
	self.editpinbtn.hidden = new_hidden
	self.zoominbtn.hidden = new_hidden
	self.zoomoutbtn.hidden = new_hidden
	self.mapbtnfollow2.hidden = new_hidden
	if new_hidden then
		mapbox:TweenFromTo("height", 290, 0, 100, "OutQuad")
		mapbox:TweenFromTo("sy", 1, 0.01, 100, "OutQuad", function() mapbox.hidden = true end)
	else
		mapbox.hidden = false
		mapbox:TweenFromTo("height", 0, 290, 100, "OutQuad")
		mapbox:TweenFromTo("sy", 0.01, 1, 100, "OutQuad")
	end
end

function SideBar:on_map_zoomin()
	self.minimap:ZoomIn()
end

function SideBar:on_map_zoomout()
	self.minimap:ZoomOut()
end

local map_pin_indices = {}
function SideBar:RefreshMapPins()
	local map_pins = Game.GetLocalPlayerExtra().MapPins
	for i=1,map_pins and #map_pins or 0 do
		map_pin_indices[i] = self.minimap:AddPin(map_pins[i][1], map_pins[i][2], data.all[map_pins[i][3]].texture)
	end
end

function SideBar:on_map_pin(btn)
	local map_pins = Game.GetLocalPlayerExtra().MapPins
	local function on_place_pin(ok, id)
		self.minimap.on_mouse_button_down = nil
		View.StopCursor()
		Quickview_HideGrid()
		if not ok then Notification.Warning("Aborted") return end

		local x, y = View.GetHoveredTilePosition()
		if id then
			if not map_pins then map_pins = {} Game.GetLocalPlayerExtra().MapPins = map_pins end
			map_pins[#map_pins+1] = { x, y, id }
			Notification.Warning(ok and L('Placed pin <img id="%s"/>', id))
			map_pin_indices[#map_pins] = self.minimap:AddPin(x, y, data.all[id].texture)
		elseif map_pins and #map_pins > 0 then
			local function getdist(i) local dx, dy = map_pins[i][1] - x, map_pins[i][2] - y return dx*dx+dy*dy end
			local closest, closest_distsq = 1, getdist(1)
			for i=2,#map_pins do
				local distsq = getdist(i)
				if distsq < closest_distsq then closest, closest_distsq = i, distsq end
			end
			Notification.Warning(ok and L('Removed pin <img id="%s"/>', map_pins[closest][3]))
			self.minimap:RemovePin(map_pin_indices[closest])
			table.remove(map_pins, closest)
			table.remove(map_pin_indices, closest)
		end
	end
	local function on_set_pin(rsel, new_reg_val)
		local id = new_reg_val and new_reg_val.id
		Notification.Warning(id and L('Click on location to place pin <img id="%s"/>', id) or "Click on pin to remove")
		View.StartCursorChooseLocation(function() on_place_pin(true, id) end, function() on_place_pin(false) end)
		Quickview_ShowGrid(0)
		self.minimap.on_mouse_button_down = function(minimap, mousebtn) on_place_pin(mousebtn == "LEFTMOUSEBUTTON", id) end
	end
	local function def_filter(def, cat) return not (cat.number_panel or cat.coord_panel or cat.entity_panel) end
	local rsel = ShowRegisterSelection(btn, on_set_pin, def_filter)
	if not rsel then return end
	rsel.orgUpdateVisuals = rsel.UpdateVisuals
	rsel.UpdateVisuals = function(self, switch_tab) self:orgUpdateVisuals(switch_tab) self.applybtn.disabled = self.register.id == nil end
	rsel.applybtn.disabled = true
	rsel.applybtn.tooltip = "Place new Pin"
	rsel.clearbtn.disabled = not map_pins or #map_pins == 0
	rsel.clearbtn.tooltip = "Remove a Pin"
end

function SideBar:on_map_units()
	self.minimap.hide_entities = not self.minimap.hide_entities
	self.mapbtnunits.active = not self.minimap.hide_entities
end

function SideBar:on_map_power()
	self.minimap.show_power_grid = not self.minimap.show_power_grid
	self.mapbtnpower.active = self.minimap.show_power_grid
end

function SideBar:on_map_focuscamera()
	local mapfollow = not self.minimap.follow_camera
	self.minimap.follow_camera = mapfollow
	self.mapbtnfollow1.active = mapfollow
	self.mapbtnfollow2.active = mapfollow
end

function SideBar:on_follow_camera_changed(a, b, c)
	local mapfollow = self.minimap.follow_camera
	self.mapbtnfollow1.active = mapfollow
	self.mapbtnfollow2.active = mapfollow
end

function SideBar:on_map_fullscreen()
	OpenMainWindow("ScreenMap")
end

function SideBar:on_toggle_follow(btn)
	Quickview_ToggleFollow()
end

function SideBar:on_toggle_mapoverlay(btn)
	Quickview_ToggleMapOverlay()
end

function SideBar:on_open_window(btn)
	OpenMainWindow(btn.window)
end

function SideBar.RefreshToggles()
	if SideBarOpen then
		SideBarOpen.camfollowbtn.active = View.GetFollowEntity() ~= nil
	end
end

function Quickview_ToggleFollow()
	UI.PlaySound("fx_ui_GRID_SELECT")
	local entity = View.GetSelectedEntity()
	if not entity and not View.GetFollowEntity() then
		return Notification.Warning("No unit selected to follow")
	elseif entity and not entity.is_placed and not entity.is_docked then
		return Notification.Warning("Cannot follow unit not on map")
	end
	View.FollowEntity(View.GetFollowEntity() ~= entity and entity)
	if SideBarOpen then SideBarOpen:RefreshToggles() end
end

function Quickview_SetOverlayOptionsButton(active)
	if SideBarOpen then SideBarOpen.overlaybtn.active = active end
end

function Quickview_OpenOverlaySettings()
	if SideBarOpen then SideBarOpen:on_open_overlay_options(SideBarOpen.overlaybtn) end
end

------------------------------------------------------------------------------

local ScreenMap_layout<const> =
[[
<Box dock=fill padding=6>
	<VerticalList child_padding=4 on_ui_cancel={close} on_ui_accept={close}>
		<Canvas id=mapbox fill=true/>
		<Box bg=popup_box_bg padding=4 id=config_box halign=right>
			<Button icon=icon_confirm on_click={close}/>
		</Box>
	</VerticalList>
</Box>
]]

local ScreenMap<const> = {}
UI.Register("ScreenMap", ScreenMap_layout, ScreenMap)

function ScreenMap:construct()
	if not SideBarOpen then return end
	local my_mapbox, side_mapbox, minimap = self.mapbox, SideBarOpen.mapbox, SideBarOpen.minimap
	SideBarOpen.bigmapbuttons.hidden = false
	while side_mapbox.has_children do
		local w = side_mapbox[1]
		w:RemoveFromParent()
		my_mapbox:Add(w)
	end
	self.on_map_zoomin            = function(self, w) SideBarOpen:on_map_zoomin(w) end
	self.on_map_zoomout           = function(self, w) SideBarOpen:on_map_zoomout(w) end
	self.on_map_pin               = function(self, w) SideBarOpen:on_map_pin(w) end
	self.on_map_units             = function(self, w) SideBarOpen:on_map_units(w) end
	self.on_map_power             = function(self, w) SideBarOpen:on_map_power(w) end
	self.on_map_focuscamera       = function(self, w) SideBarOpen:on_map_focuscamera(w) end
	self.on_follow_camera_changed = function(self, w) SideBarOpen:on_follow_camera_changed(w) end
	self.minimap = minimap
	self.txtovl = SideBarOpen.textoverlay
	minimap.dock = 'fill'
	minimap.margin_left = 36
	minimap.margin_right = minimap.x -- must be set after minimap.dock
	self.txtovl.margin_left = 36
end

function ScreenMap:destruct()
	if not SideBarOpen then return end
	local my_mapbox, side_mapbox, minimap = self.mapbox, SideBarOpen.mapbox, SideBarOpen.minimap
	while my_mapbox.has_children do
		local w = my_mapbox[1]
		w:RemoveFromParent()
		side_mapbox:Add(w)
	end
	SideBarOpen.bigmapbuttons.hidden = true
	minimap.dock = 'top-left'
	minimap.margin_left = 0
	minimap.margin_right = 0
	self.txtovl.margin_left = 0
end

function ScreenMap:close()
	CloseMainWindowAndPopup()
end

------------------------------------------------------------------------------

Input.BindAction("PauseGame", "Pressed", function()
	if Game.IsHostPlayer() and SideBarOpen then
		local dopause = (Map.GetGameSpeed()>0)
		Action.SendFromPlayer("PauseGame", { pause = dopause })
	end
end)

function UIMsg.OnEntityHovered(entity, x, y)
	if MinimapCoordsOpen then MinimapCoordsOpen.text = x .. ", " .. y end
end

function UIMsg.OnCameraFollowEntity(entity)
	if SideBarOpen then SideBarOpen:RefreshToggles() end
end

function UIMsg.OnLanguageChanged()
	if SideBarOpen then SideBarOpen:RefreshTooltips() end
end

local pinned, open_window, open_window_name = {}
function CloseMainWindowAndPopup(no_sound, close_only_name)
	local res = not close_only_name and UI.CloseMenuPopup()
	if open_window then
		if not close_only_name or close_only_name == open_window_name then
			if open_window:IsValid() then
				if open_window.can_close and not open_window:can_close() then return false end
				open_window:RemoveFromParent()
				if not no_sound then UI.PlaySound("fx_ui_WINDOW_GENERIC_CLOSE") end
			end
			open_window, open_window_name = nil, nil
			return true
		end
	end
	return res
end

local function GetPopupNextToBtn(name)
	if name == "BuildView"    then return SideBarOpen.btn_build,      0 end
	if name == "Codex"        then return SideBarOpen.btn_codex,    156 end
	if name == "ProgressView" then return SideBarOpen.btn_progress, 104 end
	if name == "Library"      then return SideBarOpen.btn_library,   52 end
	if name == "Faction"      then return SideBarOpen.btn_faction,    0 end
end

local function OpenMainPopup(name, param, popupNextToBtn, popupY, is_unpin)
	return UI.MenuPopup([[
			<Canvas>
				<Box bg=popup_box_bg padding=4 blur=true/>
				<Image dock=right image=popup_pointer id=triangle x=16 y={pointer_y} sx=-1 valign=bottom/>
			</Canvas>]],
		{
			on_popup_shift = function(w, shift_x, shift_y)
				w.triangle.y = w.triangle.y - shift_y
			end,

			construct = not is_unpin and function(w)
				w[1]:SetContent(name, param)
				w:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
				w:TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
				UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
				popupNextToBtn.active = true
			end,

			destruct = not is_unpin and function(w)
				if not popupNextToBtn:IsValid() then return end
				popupNextToBtn.active = false
				UI.PlaySound("fx_ui_WINDOW_GENERIC_CLOSE")
			end,

			pointer_y = -10 - popupY,
			name = name, -- to avoid closing of an already open window if this differs
			--param = param -- commented out but could be enabled if desired (might make the sidebar button re-open an already open popup)
		},
		popupNextToBtn, "LEFT", "BOTTOM", -10, 4+popupY)
end

function OpenMainWindow(name, param, no_sound, no_close)
	if not SideBarOpen and name ~= "InGameMenu" then return end
	local popupNextToBtn, popupY = GetPopupNextToBtn(name)
	if popupNextToBtn then
		local pin = pinned[name]
		if pin and not param then
			pin:RemoveFromParent()
			pinned[name] = nil
		elseif pin then
			pin:SetContent(name, param).pinbtn.active = true
			pin:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
			pin:TweenFromTo("sy", 0.01, 1, 80, "OutQuad")
			UI.PlaySound("fx_ui_WINDOW_SELECTION_MENU_OPEN")
		elseif popupNextToBtn:IsVisible() then
			if open_window and not no_close then CloseMainWindowAndPopup(no_sound, open_window_name) end
			OpenMainPopup(name, param, popupNextToBtn, popupY)
		end
	elseif name == "Chat" then
		UIShowTextChat()
	else -- Tech, Program, ScreenMap, InGameMenu
		local open_new_window = (open_window_name ~= name)
		CloseMainWindowAndPopup(open_new_window or param or no_sound)
		if open_new_window or param then
			if not no_sound then UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN") end
			open_window, open_window_name = UI.AddLayout(name, param, (name == "InGameMenu" and 22 or 0)), name
		end
	end
end

function DropInSidebarButton(name, widget)
	local btn = GetPopupNextToBtn(name)
	if not btn then return false end
	local bx, by, bw, bh = btn:GetViewportPosition()
	if not bw or bw < 1 then return false end
	local wx, wy, ww, wh = widget:GetViewportPosition()
	if not ww or ww < 1 then return false end

	widget:TweenFromTo("x", wx, bx+10, 400, "OutQuad")
	widget:TweenFromTo("y", wy, by+10, 400,  "InQuad", function() end)
	widget:TweenFromTo("width", ww, bw-20,  300, "InOutQuad")
	widget:TweenFromTo("height", wh, bh-20, 300,  "InOutQuad", function()
		widget:TweenFromTo("opacity", 1, 0, 200)
		btn:TweenFromTo("y", 0, 10, 280, "OutBack", function()
			widget:RemoveFromParent()
			btn:TweenFromTo("y", 10, 0, 340, "OutBack")
		end)
	end)
	return true
end

function TogglePinMainWindow(content, name)
	content.pinbtn.active = pinned[name] == nil
	if not pinned[name] then
		pinned[name] = UI.AddLayout("<Box bg=popup_box_bg padding=4 blur=true dock=bottom-right margin_bottom=4 margin_right=68/>", 1)
		pinned[name].destruct, content.root.destruct = content.root.destruct, nil -- take destruct
		pinned[name]:Add(content) -- this moves the widget without calling destruct/construct
		UI.CloseMenuPopup()
	else
		local popupNextToBtn, popupY = GetPopupNextToBtn(name)
		local pop = OpenMainPopup(name, nil, popupNextToBtn, popupY, true)
		if pop then pop[1]:SetContent(content) end
		if pop then pinned[name].destruct, pop.destruct = nil, pinned[name].destruct end -- give back destruct
		pinned[name]:RemoveFromParent()
		pinned[name] = nil
	end
end

local ContextKeys
function ShowContextKeyPanel(list)
	if list then
		if ContextKeys then ContextKeys.box.opacity = 0.25 end
		ContextKeys = UI.AddLayout([[
			<Spacer dock=right opacity=0 x=800 y=40>
				<Box id=box blur=true padding=12 blocking=false x=0>
					<VerticalList>
						<Text text={title} style=header textalign=center margin_bottom=8/>
						<HorizontalList><VerticalList id=keys child_padding=4 child_align=right margin_right=10/><VerticalList id=infos child_padding=4/></HorizontalList>
					</VerticalList>
				</Box>
			</Spacer>]], {
			prev_context_keys = ContextKeys,
			every_frame_update = function(w)
				local x = (UI.GetMousePosition(w) or 0) + 10
				w.box.x = (x < 0 and 0 or x)
			end,
		}, 2)
		ContextKeys:SetIgnoreHitTest()
		ContextKeys.title = list[1]
		ContextKeys:TweenTo("opacity", 0.8, 300, "OutQuad")
		ContextKeys:TweenTo("x", 0, 300, "OutQuad")
		for i=2,#list,2 do
			ContextKeys.keys:Add("<Text height=20 style=hl y=-1/>"). text = list[i]
			ContextKeys.infos:Add("<Text height=20 />").text = list[i+1]
		end
	elseif ContextKeys then
		ContextKeys:TweenTo("x", 800, 300, "OutQuad")
		ContextKeys:TweenTo("opacity", 0, 300, "OutQuad", function (w) w:RemoveFromParent() end)
		ContextKeys = ContextKeys.prev_context_keys
		if ContextKeys then ContextKeys.box.opacity = nil end
	end
end
