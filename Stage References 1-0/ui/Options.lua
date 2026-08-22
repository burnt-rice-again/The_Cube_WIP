local layout<const> =
[[
	<HorizontalList child_padding=12 child_align=top>
		<Box bg=popup_box_bg padding=10 blur=true>
			<VerticalList id=tabs child_padding=4 child_fill=true width=175>
				<Button text="Video"  on_click={on_click_tab} tab_layout=Options_Video/>
				<Button text="Audio"  on_click={on_click_tab} tab_layout=Options_Audio/>
				<Button text="Game"   on_click={on_click_tab} tab_layout=Options_Game />
				<Button text="Input"  on_click={on_click_tab} tab_layout=Options_Input/>
				<Button text="System" on_click={on_click_tab} tab_layout=Options_System/>
				<Button text="Mods"   on_click={on_click_tab} tab_layout=Options_Mods id=modsbtn/>
			</VerticalList>
		</Box>
		<Spacer id=details/>
	</HorizontalList>
]]

local Options<const> = {}
UI.Register("Options", layout, Options)
local function SetButtonActive(w, a) w.active, w.disabled = a, a end

function Options:construct()
	self:on_click_tab(self.tabs:GetChild())
	self:TweenFromTo("sy", 0.01, 1, 80, 'OutQuad')
	UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN")

	local is_frontend, mod_with_options = Map.IsFrontEnd()
	for i,mod in ipairs(Game.GetInstalledMods()) do
		if mod.has_options and ((is_frontend and mod.is_enabled) or mod.is_loaded) then
			mod_with_options = true
			break
		end
	end
	if not mod_with_options then self.modsbtn.hidden = true end
end

function Options:on_close()
	UI.PlaySound("fx_ui_WINDOW_GENERIC_CLOSE")
	self:TweenFromTo("sx", 1, 0.01, 80, 'InQuad')
	self:TweenFromTo("sy", 1, 0.01, 40, 'InQuad', function() self:RemoveFromParent() end)
end

function Options:on_click_tab(btn)
	self.details:Clear()
	self.details:SetContent(btn.tab_layout)
	for i,v in ipairs(self.tabs) do
		SetButtonActive(v, (v == btn))
	end
end

local layout_video<const> =
[[
	<Box bg=popup_box_bg width=624 padding=8 blur=true>
		<ScrollList child_padding=6 id=list>
			<HorizontalList id=safemode_hl child_padding=3 margin_bottom=10 hidden=true>
				<Text width=200 valign=center text="Safe Mode" margin_left=11/>
				<CheckBox fill=true check=true text="Active (Change Requires Restart)" on_change={on_safemode_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=window_mode margin_bottom=10>
				<Text width=200 valign=center text="Mode" margin_left=11/>
				<Combo fill=true height=32 id=window_mode on_change={on_window_mode_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 margin_bottom=10>
				<Text width=200 valign=center text="Resolution" margin_left=11/>
				<Combo fill=true height=32 id=video_res on_change={on_video_res_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 halign=right margin_bottom=10>
			<Button text="Apply" on_click={on_click_apply} tooltip="Confirm" id=apply width=120/>
			</HorizontalList>
			<Image height=2 color=ui_dark/>
			<HorizontalList id=screen_scaling_hl child_padding=3 video_setting=screen_scaling>
				<Text width=200 valign=center text="Resolution Scaling" margin_left=11/>
				<Slider fill=true height=32 step=5 id=screen_scaling_sli on_change={on_video_slider_changed} clearval=100 showfmt="%.0f%%"/>
				<Text valign=center textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button icon=icon_undo width=32 height=32 tooltip="Default" on_click={on_click_clear}/>
			</HorizontalList>
			<HorizontalList id=upscaling_hl child_padding=3 video_setting=upscaling>
				<Text width=200 valign=center text="Upscaling" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList id=dlss_quality_hl child_padding=3 video_setting=dlss_quality hidden=true>
				<Text width=200 valign=center text="DLSS Quality" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList id=nis_quality_hl child_padding=3 video_setting=nis_quality hidden=true>
				<Text width=200 valign=center text="NIS Quality" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList id=upscaling_sharpness_hl child_padding=3 hidden=true video_setting=upscaling_sharpness>
				<Text width=200 wrap=true valign=center text="Sharpness" margin_left=11/>
				<Slider fill=true height=32 min=-1.0 max=1.0 step=0.1 on_change={on_video_slider_changed} clearval=0 showfmt="%.0f" showfactor=0.1/>
				<Text valign=center textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button icon=icon_undo width=32 height=32 tooltip="Default" on_click={on_click_clear}/>
			</HorizontalList>
			<HorizontalList id=dlss_fg_hl child_padding=3 video_setting=dlss_fg hidden=true>
				<Text width=200 valign=center text="Frame Generation" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList id=dlss_reflex_hl child_padding=3 video_setting=dlss_reflex hidden=true>
				<Text width=200 valign=center text="Reflex" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<Image height=2 color=ui_dark/>
			<HorizontalList id=vsync_hl child_padding=3 video_setting=vsync tooltip="Vertical Synchronization Rate" hidden=false>
				<Text width=200 valign=center text="VSync" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 child_align=center video_setting=frame_rate_limit tooltip="Limits the framerate">
				<Text width=200 wrap=true text="Frame Rate Limit" margin_left=11/>
				<Slider fill=true height=32 min=0 max=240 step=5 on_change={on_video_slider_changed} isfps=true clearval=0/>
				<Text textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button text="∞" width=32 height=32 on_click={on_click_clear} tooltip="Infinity"/>
			</HorizontalList>
			<HorizontalList child_padding=3 child_align=center video_setting=background_limit tooltip="Limits the framerate while using another program">
				<Text width=200 wrap=true text="Background Limit" margin_left=11/>
				<Slider fill=true height=32 min=0 max=240 step=5 on_change={on_video_slider_changed} isfps=true clearval=0/>
				<Text textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button text="∞" width=32 height=32 on_click={on_click_clear} tooltip="Infinity"/>
			</HorizontalList>
			<Image height=2 color=ui_dark/>
			<HorizontalList child_padding=3 id=hdr_output_hl video_setting=hdr_output tooltip="High Dynamic Range - *** Exclusive Fullscreen Only ***">
				<Text width=200 valign=center text="HDR Output" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=view_distance>
				<Text width=200 wrap=true valign=center text="View Distance" margin_left=11/>
				<Slider fill=true height=32 min=5000 max=25000 step=500 id=view_distance_sli on_change={on_video_slider_changed} showfactor=100/>
				<Text valign=center textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button icon=icon_undo width=32 height=32 tooltip="Default" on_click={on_click_clear}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=shadow_distance>
				<Text width=200 wrap=true valign=center text="Shadow Distance" margin_left=11/>
				<Slider fill=true height=32 min=5000 max=25000 step=500 id=shadow_distance_sli on_change={on_video_slider_changed} showfactor=100/>
				<Text valign=center textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button icon=icon_undo width=32 height=32 tooltip="Default" on_click={on_click_clear}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=overall_quality tooltip="Quality Presets">
				<Text width=200 valign=center text="Quality" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=effect_quality tooltip="Fog, Cloud & Effect Quality">
				<Text width=200 valign=center text="Effect Quality" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=shadow_quality tooltip="Shadow Quality">
				<Text width=200 valign=center text="Shadow Quality" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=anti_alias_method tooltip="Anti-Aliasing Method">
				<Text width=200 valign=center text="Anti-Aliasing Method" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList id=anti_alias_quality_hl child_padding=3 video_setting=anti_alias_quality tooltip="Anti-Aliasing" hidden=true>
				<Text width=200 valign=center text="Anti-Aliasing" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=bloom_quality tooltip="Bloom Quality">
				<Text width=200 valign=center text="Bloom Quality" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=depth_of_field_quality tooltip="Depth Of Field">
				<Text width=200 valign=center text="Depth Of Field" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<HorizontalList id=dofstr_hl child_padding=3 tooltip="Depth Of Field Strength" video_setting=depth_of_field_strength>
				<Text width=200 wrap=true valign=center text="DOF Strength" margin_left=11/>
				<Slider fill=true height=32 min=4 max=1000 step=5 on_change={on_video_slider_changed} clearval=130/>
				<Text valign=center textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button icon=icon_undo width=32 height=32 tooltip="Default" on_click={on_click_clear}/>
			</HorizontalList>
			<HorizontalList child_padding=3 video_setting=gamma>
				<Text width=200 wrap=true valign=center text="Gamma" margin_left=11/>
				<Slider fill=true height=32 min=0.66 max=4.4 step=0.05 on_change={on_video_slider_changed} showfactor=0.022 clearval=2.2 showfmt="%.0f%%"/>
				<Text valign=center textalign=right margin_right=5 width=40 on_click={enable_slider_input}/>
				<Button icon=icon_undo width=32 height=32 tooltip="Default" on_click={on_click_clear}/>
			</HorizontalList>
			<Image height=2 color=ui_dark/>
			<HorizontalList id=rhi_hl child_padding=3 video_setting=rhi tooltip="Used Rendering API (Change requires game restart)">
				<Text width=200 valign=center text="Rendering API" margin_left=11/>
				<Combo fill=true height=32 on_change={on_video_combo_change}/>
			</HorizontalList>
			<Text id=need_restart_lbl text="Please Restart the Game to Apply the Settings" textalign=center style=rl/>
		</ScrollList>
	</Box>
]]

local Options_Video<const> = { }
UI.Register("Options_Video", layout_video, Options_Video)

function Options_Video:construct()
	local low_ultra<const> = { "TX_QUALITY_LOW", "TX_QUALITY_MEDIUM", "TX_QUALITY_HIGH", "Ultra" }
	local med_ultra<const> = { "TX_QUALITY_MEDIUM", "TX_QUALITY_HIGH", "Ultra" }
	local off_ultra<const> = { "Off", "TX_QUALITY_MEDIUM", "TX_QUALITY_HIGH", "Ultra" }
	local off_high<const>  = { "Off", "TX_QUALITY_MEDIUM", "TX_QUALITY_HIGH", }
	local disabled_enabled<const> = { "Disabled", "Enabled" }
	local upscaling_modes = Game.GetSupportedUpscalingModes()
	self.upscaling_support = upscaling_modes.upscaling_support
	self.streamline_support = upscaling_modes.streamline_support
	self.reflex_support = upscaling_modes.reflex_support
	self.combo_values = {
		window_mode            = { "windowed", "borderless", "fullscreen" },
		vsync                  = { false, true },
		hdr_output             = { false, true },
		overall_quality        = { 0, 1, 2, 3 },
		effect_quality         = { 0, 1, 2, 3 },
		shadow_quality         = { 0, 1, 2, 3 },
		anti_alias_method      = { 0, 1, 2 },
		anti_alias_quality     = { 1, 2, 3 },
		bloom_quality          = { 0, 4, 5 },
		depth_of_field_quality = { 0, 1, 2, },
		rhi                    = { "d3d11", "d3d12" },

		upscaling              = upscaling_modes.upscaling_values,
		dlss_quality           = upscaling_modes.dlss_quality_values,
		nis_quality            = upscaling_modes.nis_quality_values,
		dlss_fg                = { 0, 1 },
		dlss_reflex            = { 0, 1, 3 },
	}
	local combo_texts = {
		window_mode            = { "Windowed", "Borderless", "Fullscreen" },
		vsync                  = disabled_enabled,
		hdr_output             = disabled_enabled,
		overall_quality        = low_ultra,
		effect_quality         = low_ultra,
		shadow_quality         = off_ultra,
		anti_alias_method      = { "Off", "FXAA", "Temporal AA" },
		anti_alias_quality     = med_ultra,
		bloom_quality          = off_high,
		depth_of_field_quality = off_high,
		rhi                    = { "DirectX 11 (Default)", "DirectX 12" },

		upscaling              = upscaling_modes.upscaling_strings,
		dlss_quality           = upscaling_modes.dlss_quality_strings,
		nis_quality            = upscaling_modes.nis_quality_strings,
		dlss_fg                = disabled_enabled,
		dlss_reflex            = { "Off", "On", "On + Boost" },
	}
	for _,hl in ipairs(self.list) do
		local video_setting = hl.video_setting
		local cmb_texts = video_setting and combo_texts[video_setting]
		if cmb_texts then
			local cmb = hl[2]
			cmb.texts = cmb_texts
		end
	end

	self:refresh()
end

function Options_Video:destruct()
	if Game.ApplyScreenModeRequired() then
		Game.RevertScreenMode()
	end
end

function Options_Video:refresh()
	local mode = Game.GetFullscreenMode()
	local mode_val = mode == "windowed" and 1 or (mode == "borderless" and 2 or 3)
	self.window_mode.value = mode_val

	local resolutions, current_x, current_y = Game.GetScreenResolutions(), Game.GetScreenResolution()
	if #resolutions == 1 then current_x, current_y = resolutions[1].x, resolutions[1].y end

	self.vid_res = resolutions

	self.resolutions = {}
	local cur_res
	for i,res in ipairs(resolutions) do
		self.resolutions[i] = res.x .. " x " .. res.y
		if (current_x == res.x and current_y == res.y) then cur_res = i end
	end
	self.video_res.texts = self.resolutions
	self.video_res.value = cur_res
	self.apply.disabled = not Game.ApplyScreenModeRequired()

	local video_settings = Game.GetVideoSettings()
	local upscaling = video_settings.upscaling

	if video_settings.safe_mode then self.safemode_hl.hidden, self.rhi_hl.hidden = false, true end

	self.screen_scaling_sli.min, self.screen_scaling_sli.max = ((upscaling or 0) == 0 and 20 or 50), ((upscaling or 0) == 0 and 200 or 100)
	video_settings.screen_scaling = math.min(self.screen_scaling_sli.max, math.max(self.screen_scaling_sli.min, video_settings.screen_scaling or 100))

	self.view_distance_sli.clearval   = video_settings.default_view_distance
	self.shadow_distance_sli.clearval = video_settings.default_shadow_distance

	self.hdr_output_hl.hidden         = not (video_settings.hdr_support and mode == "fullscreen")
	self.anti_alias_quality_hl.hidden = video_settings.anti_alias_method == 0
	self.dofstr_hl.hidden             = video_settings.depth_of_field_quality == 0
	self.need_restart_lbl.hidden      = not video_settings.need_restart

	for _,hl in ipairs(self.list) do
		local video_setting = hl.video_setting
		if video_setting then
			local val = video_settings[video_setting]
			if self.combo_values[video_setting] then
				local cmb, setval = hl[2]
				for i,v in ipairs(self.combo_values[video_setting]) do
					if v == val then setval = i break end
				end
				if setval ~= nil then
					cmb.value = setval
				end
			else
				local sli, txt = hl[2], hl[3]
				sli.value = val
				txt.text = val == 0 and sli.isfps and "∞" or string.format(sli.showfmt or "%.0f", val / (sli.showfactor or 1))
			end
		end
	end

	if self.upscaling_support then
		self.upscaling_hl.hidden = false
		self.dlss_quality_hl.hidden = upscaling ~= 1
		self.nis_quality_hl.hidden = upscaling ~= 2
		self.upscaling_sharpness_hl.hidden = (upscaling or 0) == 0
	end
	if self.streamline_support then
		self.dlss_fg_hl.hidden = false
		self.vsync_hl.hidden = (video_settings.dlss_fg ~= 0)
	end
	if self.reflex_support then
		self.dlss_reflex_hl.hidden = false
	end
end

function Options_Video:on_safemode_change(chk, val)
	Game.SetVideoSettings({ safe_mode = val })
end

function Options_Video:on_window_mode_change(cmb, val)
	Game.SetFullscreenMode(self.combo_values.window_mode[val])
	self:refresh()
end

function Options_Video:on_video_res_change(cmb, val)
	local res = self.vid_res[val]
	Game.SetScreenResolution(res.x, res.y)
	self:refresh()
end

function Options_Video:on_video_combo_change(cmb, val)
	local setting = cmb.parent.video_setting
	local newval = val
	if self.combo_values[setting] then newval = self.combo_values[setting][val] end
	Game.SetVideoSettings({ [setting] = newval })
	self:refresh() -- quality levels can affect multiple things
end

function Options_Video:on_video_slider_changed(sli, val, via_text_input)
	local setting, txt, isfps = sli.parent.video_setting, sli.parent[3], sli.isfps
	if val == 145 and isfps and not via_text_input then val = 144 end
	if val < 5 and isfps then val = 0 end
	Game.SetVideoSettings({ [setting] = val })
	txt.text = val == 0 and isfps and "∞" or string.format(sli.showfmt or "%.0f", val / (sli.showfactor or 1))
end

function Options_Video:on_click_clear(btn)
	local sli = btn.parent[2]
	if sli.value ~= sli.clearval then sli.value = sli.clearval sli:SendEvent("on_change", sli.value) end
end

function Options_Video:enable_slider_input(txt)
	local hl = txt.parent
	if not hl[5] then hl:Add("<InputText textalign=right margin_right=5 width=40 height=30 padding=0 hidden=true on_change={slider_input_on_change} on_commit={slider_input_on_commit}/>").child_index = 4 end
	local inp = hl[4]
	inp.hidden, txt.hidden, inp.text, inp.has_change = false, true, txt.text:gsub("%%",""), false
	inp:Focus()
end

function Options_Video:slider_input_on_change(inp, val)
	local val_num, sli = tonumber(val) or 0, inp.parent[2]
	local sli_val = math.max(sli.min, math.min(sli.max, (tonumber(val_num) or 0) * (sli.showfactor or 1)))
	inp.text = sli.isfps and val_num == 0 and "∞" or tostring(val_num)
	if sli.value ~= sli_val then sli.value, inp.has_change = sli_val, true end
end

function Options_Video:slider_input_on_commit(inp)
	local sli, txt = inp.parent[2], inp.parent[3]
	inp.hidden, txt.hidden = true, false
	if inp.has_change then sli:SendEvent("on_change", sli.value, true) inp.has_change = false end
end

function Options_Video:on_click_apply()
	if Game.ApplyScreenModeNeedConfirm() then
		ConfirmBox("Do you want to keep the new mode?",
			function()
				Game.ConfirmScreenMode()
				self:refresh()
			end,
			function()
				Game.RevertScreenMode()
				self:refresh()
			end)
	else
		self:refresh()
	end
end

local layout_audio<const> =
[[
	<Box bg=popup_box_bg width=624 padding=8 blur=true>
		<VerticalList>
			<HorizontalList child_align=center>
				<Text fill=true text="Volume" margin_left=11/>
				<Text id=master_txt margin_right=5/>
				<Slider width=500 height=42 min=0 max=100 step=1 id=master on_change={on_volume_changed}/>
			</HorizontalList>
			<HorizontalList child_align=center>
				<Text fill=true text="Effects" margin_left=11/>
				<Text id=effect_txt margin_right=5/>
				<Slider width=500 height=42 min=0 max=100 step=1 id=effect on_change={on_volume_changed}/>
			</HorizontalList>
			<HorizontalList child_align=center>
				<Text fill=true text="Music" margin_left=11/>
				<Text id=music_txt margin_right=5/>
				<Slider width=500 height=42 min=0 max=100 step=1 id=music on_change={on_volume_changed}/>
			</HorizontalList>
			<HorizontalList child_align=center>
				<Text fill=true text="Voice" margin_left=11/>
				<Text id=voice_txt margin_right=5/>
				<Slider width=500 height=42 min=0 max=100 step=1 id=voice on_change={on_volume_changed}/>
			</HorizontalList>
			<HorizontalList child_align=center>
				<Text fill=true text="Menu" margin_left=11/>
				<Text id=ui_txt margin_right=5/>
				<Slider width=500 height=42 min=0 max=100 step=1 id=ui on_change={on_volume_changed}/>
			</HorizontalList>
			<CheckBox id=mutebg text="Mute in background" on_change={on_change_mutebg} margin_top=25 margin_bottom=25/>
			<Button text="Reset To Default Volume" on_click={on_default_volume} />
		</VerticalList>
	</Box>
]]

local Options_Audio<const> = {}
UI.Register("Options_Audio", layout_audio, Options_Audio)

function Options_Audio:construct()
	for i, id in ipairs({"master", "effect", "music", "voice", "ui"}) do
		local val = Game.GetVolume(id)
		self[id].value = val
		self[id.."_txt"].text = string.format("%.0f%%", val)
	end
	self.mutebg.check = Game.GetUnfocusedVolume() == 0
end

function Options_Audio:on_volume_changed(slider, val)
	Game.SetVolume(slider.id, val)
	self[slider.id.."_txt"].text = string.format("%.0f%%", val)
end

function Options_Audio:on_change_mutebg(chk, value)
	Game.SetUnfocusedVolume(value == false and 100 or 0)
end

function Options_Audio:on_default_volume(btn)
	local default_volumes<const> = { 50, 50, 50, 80, 50 }
	for i, id in ipairs({"master", "effect", "music", "voice", "ui"}) do
		local val = default_volumes[i]
		Game.SetVolume(id, val)
		self[id].value = val
		self[id.."_txt"].text = string.format("%.0f%%", val)
	end
end

-- REMOVED
-- <CheckBox key=order_aborted on_change={on_change_notification} text="Disable Order Aborted Notifications" halign=left/>

local layout_game<const> =
[[
	<Box bg=popup_box_bg padding=6 width=792 blur=true>
		<ScrollList child_padding=10>
			<Box padding=10>
				<HorizontalList>
					<Text width=250 text="Language" margin_top=8/>
					<VerticalList fill=true id=languages child_padding=3/>
				</HorizontalList>
			</Box>
			<Box padding=10>
				<VerticalList>
					<HorizontalList child_align=center>
						<Text width=250 text="Interface Scale"/>
						<Text id=scale_txt margin_right=5/>
						<Slider fill=true height=42 min=0.3 max=1.2 step=0.01 id=scale on_change={on_scale_changed}/>
					</HorizontalList>
					<Button icon=icon_confirm tooltip="Confirm" on_click={on_click_scale_apply} id=scale_apply disabled=true halign=right/>
				</VerticalList>
			</Box>
			<Box padding=10>
				<HorizontalList>
					<Text width=250 text="Notifications" margin_top=8/>
					<VerticalList child_padding=3 id=notificationsettings>
						<CheckBox key=attack on_change={on_change_notification} text="Disable Attack Notification" halign=left/>
						<CheckBox key=resource on_change={on_change_notification} text="Disable Resource Notification" halign=left/>
						<CheckBox key=joining_leaving on_change={on_change_notification} text="Disable Player Joining/Leaving Notifications" halign=left/>
						<CheckBox key=switching_faction on_change={on_change_notification} text="Disable Player Switching Faction Notifications" halign=left/>
						<CheckBox key=multiplayer_ping on_change={on_change_notification} text="Disable Multiplayer Ping Notifications" halign=left/>
						<CheckBox key=mission on_change={on_change_notification} text="Disable Mission Notifications" halign=left/>
						<CheckBox key=mission_progress on_change={on_change_notification} text="Disable Mission Progress Notification" halign=left/>
						<CheckBox key=milestone on_change={on_change_notification} text="Disable Milestone Notifications" halign=left/>
						<CheckBox key=tech_complete on_change={on_change_notification} text="Disable Tech Complete Notifications" halign=left/>
						<CheckBox key=tech_progress on_change={on_change_notification} text="Disable Tech Progress Notifications" halign=left/>
						<CheckBox key=virus_in_network on_change={on_change_notification} text="Disable Virus Notifications" halign=left/>
						<CheckBox key=anomaly on_change={on_change_notification} text="Disable Anomaly Notifications" halign=left/>
						<CheckBox key=auto_save on_change={on_change_notification} text="Disable Auto Save Notifications" halign=left/>
						<CheckBox key=blight_storm_warning on_change={on_change_notification} text="Disable Blight Storm Notifications" halign=left/>
						<CheckBox key=mission_pins on_change={on_change_notification} text="Disable Mission Pins" halign=left/>
					</VerticalList>
				</HorizontalList>
			</Box>
			<Box padding=10>
				<VerticalList child_padding=8>
					<HorizontalList child_align=center id=tutorial_option>
						<Text width=250 text="Tutorials"/>
						<Button id=tutorial_btn on_click={on_toggle_tutorials} width=32 height=32/>
					</HorizontalList>
					<HorizontalList child_align=center>
						<Text width=250 text="Story Popups"/>
						<CheckBox id=story_popups on_change={on_change_story_popups} text="Disable Story Popups" halign=left/>
					</HorizontalList>
					<HorizontalList child_align=center>
						<Text width=250 text="Auto Save"/>
						<Text id=autosave_txt margin_right=5/>
						<Slider fill=true height=42 min=0 max=30 step=1 id=autosave on_change={on_autosave_changed}/>
					</HorizontalList>
					<HorizontalList child_align=center>
						<Text width=250 text="Color Blind Mode"/>
						<HorizontalList id=colorblind_modes fill=true child_fill=true child_padding=3>
							<Button text="Normal" on_click={on_click_colorblindmode} mode=normal/>
							<Button text="Deuteranopia" tooltip="Green-Blind" on_click={on_click_colorblindmode} mode=deuteranopia/>
							<Button text="Protanopia" tooltip="Red-Blind" on_click={on_click_colorblindmode} mode=protanopia/>
							<Button text="Tritanopia" tooltip="Blue-Blind" on_click={on_click_colorblindmode} mode=tritanopia/>
						</HorizontalList>
					</HorizontalList>
				</VerticalList>
			</Box>
		</ScrollList>
	</Box>
]]

local Options_Game<const> = {}
UI.Register("Options_Game", layout_game, Options_Game)

function Options_Game:construct()
	local scale = UI.GetScale()
	self.scale.value = scale
	self.scale_txt.text = string.format("%.0f%%", scale * 100)

	local options = Game.GetProfile().options
	self.story_popups.check = options.disable_story_popups

	local autosavetime = Game.GetAutoSaveTime()
	self.autosave.value = autosavetime
	self.autosave_txt.text = (autosavetime > 0 and L("%d min", autosavetime) or "(disabled)")

	local hidden_notifications = Game.GetProfile().hidden_notifications
	for _,v in ipairs(self.notificationsettings) do
		v.check = hidden_notifications and hidden_notifications[v.key]
	end

	self:refresh()
end

function Options_Game:refresh()
	self.languages:Clear()
	local current, languages, codes = UI.GetLanguageCode(), UI.GetLanguages(), {}
	for k,v in pairs(languages) do codes[#codes+1] = k end
	table.sort(codes)
	for i = 1, #codes, 3 do
		local list = self.languages:Add("<HorizontalList child_padding=3/>")
		for j = 0, 2 do
			local code = codes[i + j]
			if not code then break end
			SetButtonActive(list:Add("<Button width=165 on_click={on_click_language}/>", { text = languages[code], code = code }), (current == code))
		end
	end
	local colorblind_mode = Game.GetProfile().options.colorblind_mode or "normal"
	for _,v in ipairs(self.colorblind_modes) do
		if v.mode then
			SetButtonActive(v, v.mode == colorblind_mode)
		end
	end

	if not TutorialIsAvailable or not TutorialIsAvailable() then
		self.tutorial_option.hidden = true
	else
		local tutorial = TutorialIsActive()
		self.tutorial_btn.icon = tutorial and "icon_small_confirm" or nil
		self.tutorial_btn.active = tutorial
	end
end

function Options_Game:on_click_language(btn)
	UI.SetLanguageCode(btn.code)
	self:refresh()
end

function Options_Game:on_toggle_tutorials(btn)
	local tutorial = not btn.active
	btn.icon = tutorial and "icon_small_confirm" or nil
	btn.active = tutorial
	TutorialToggle(tutorial)
end

function Options_Game:on_change_story_popups(cb, value)
	Game.GetProfile().options.disable_story_popups = value or nil
	if value and StopTalkingHead then StopTalkingHead() end
end

function Options_Game:on_scale_changed(slider, val)
	self.scale_txt.text = string.format("%.0f%%", val * 100)
	self.scale_apply.disabled = (val == UI.GetScale())
end

function Options_Game:on_click_scale_apply(btn)
	UI.SetScale(self.scale.value)
	View.SelectEntities({})
	btn.disabled = true
end

function Options_Game:on_change_notification(cb, value)
	local profile = Game.GetProfile()
	local hidden_notifications = profile.hidden_notifications

	if not hidden_notifications then hidden_notifications = {} end
	local key = cb.key
	hidden_notifications[key] = value or nil
	profile.hidden_notifications = EmptyTableAsNil(hidden_notifications)

	if key == "tech_progress" then
		local tech_notify = UI.FindWidget("TechNotify")
		if tech_notify then tech_notify:update(false) end
	end

	if key == "mission_progress" then
		local progress_notifications = UI.FindWidget("ProgressNotifications")
		if progress_notifications then progress_notifications:refresh() end
	end
end

function Options_Game:on_autosave_changed(slider, val)
	self.autosave_txt.text = (val > 0 and L("%d min", val) or "(disabled)")
	Game.SetAutoSaveTime(val)
end

function Options_Game:on_click_colorblindmode(btn)
	Game.GetProfile().options.colorblind_mode = btn.mode
	Game.SetColorMapping(btn.mode)
	self:refresh()
end

local layout_input<const> =
[[
	<HorizontalList child_padding=8>
		<Box dock=center valign=top bg=popup_box_bg padding=6 blur=true margin_bottom=20>
			<ScrollList width=950 child_padding=4>
				<Box padding=10>
					<VerticalList child_padding=8>
						<HorizontalList child_align=center>
							<Text width=200 wrap=true text="Scrolling Speed"/>
							<Text id=scroll_speed_txt margin_right=5 width=40/>
							<Slider fill=true height=42 min=0.1 max=10 step=0.01 id=scroll_speed on_change={on_scroll_speed}/>
						</HorizontalList>
						<HorizontalList child_align=center>
							<Text width=200 wrap=true text="Right-Click Drag Scrolling"/>
							<Button id=drag_scrolling_btn on_click={on_drag_scrolling} width=32 height=32/>
						</HorizontalList>
						<HorizontalList child_align=center>
							<Text width=200 wrap=true text="Screen Edge Scrolling"/>
							<Button id=edge_scrolling_btn on_click={on_edge_scrolling} width=32 height=32/>
						</HorizontalList>
						<HorizontalList child_align=center>
							<Text width=200 wrap=true text="Lock Mouse to Window"/>
							<Button id=mouse_lock_btn on_click={on_mouse_lock} width=32 height=32/>
						</HorizontalList>
					</VerticalList>
				</Box>
				<Button icon=icon_deny text="Reset All Key Bindings" on_click={on_click_reset}/>
				<VerticalList id=hotkeys child_padding=4/>
			</ScrollList>
		</Box>
		<Spacer id=config/>
	</HorizontalList>
]]


local layout_single_add<const> =
[[
	<HorizontalList width=300>
		<Image image=icon_add color=ui_light width=32 height=32 opacity=0/>
		<Button fill=true on_click={on_click_hotkey}/>
	</HorizontalList>
]]

local layout_single_key<const> =
[[
	<HorizontalList width=300>
		<Image image={image} color=ui_light width=32 height=32/>
		<Button text={text} fill=true on_click={on_click_hotkey}/>
	</HorizontalList>
]]
local layout_action<const> =
[[
		<HorizontalList>
			<Text width=300 text={lbl} style=hl wrap=true tooltip={text_tooltip}/>
			<Wrap wrapsize=700 id=list child_padding=6/>
		</HorizontalList>
]]

local layout_axis<const> =
[[
		<VerticalList child_padding=8>
			<HorizontalList margin_top=8><Text width=300 text={lbl_pos} wrap=true style=hl/><Wrap wrapsize=700 id=list_pos child_padding=6/></HorizontalList>
			<HorizontalList><Text width=300 text={lbl_neg} wrap=true style=hl/><Wrap wrapsize=700 id=list_neg child_padding=6/></HorizontalList>
			<HorizontalList><Text width=300 text={lbl_var} wrap=true style=hl/><Wrap wrapsize=700 id=list_var child_padding=6/></HorizontalList>
			<HorizontalList child_align=center>
				<Text width=100 text="Sensitivity"/>
				<Text width=222 id=senstxt textalign=right margin_right=10/>
				<Slider width=574 id=sens height=32 min=0.01 max=5 value=0.5 step=0.01 on_change={on_sensitivity_changed}/>
			</HorizontalList>
			<Image height=2 color=ui_dark/>
		</VerticalList>
]]

local layout_config_input<const> =
[[
	<Box dock=center valign=top bg=popup_box_bg padding=6 blur=true margin_bottom=20>
		<ScrollList width=300 child_padding=4>
			<HorizontalList hidden={combo_hidden} child_fill=true>
				<CheckBox text="Shift" on_change={on_change_combo} shift=true />
				<CheckBox text="Ctrl"  on_change={on_change_combo} ctrl=true/>
				<CheckBox text="Alt"   on_change={on_change_combo} alt=true/>
			</HorizontalList>
			<VerticalList id=list>
				<Button on_click={on_click_config} icon=icon_button text="Set by Input" is_byinput=true/>
				<Button on_click={on_click_config} icon=icon_keyboard text="Keyboard" category=KEYBOARD/>
				<Button on_click={on_click_config} icon=icon_mouse text="Mouse" category=MOUSE/>
				<Button on_click={on_click_config} icon=icon_gamepad text="Gamepad" category=GAMEPAD/>
				<Button on_click={on_click_config} icon=icon_deny text="Remove Binding" is_delete=true hidden={delete_hidden}/>
			</VerticalList>
		</ScrollList>
	</Box>
]]

local Options_Input<const> = {}
UI.Register("Options_Input", layout_input, Options_Input)

local function split_binding(binding)
	local combinations = { shift = false, ctrl = false, alt = false }
	local key = ""
	for s in string.gmatch(binding, "[^+]+") do
		if     s == "SHIFT" then combinations.shift = true
		elseif s == "CTRL"  then combinations.ctrl = true
		elseif s == "ALT"   then combinations.alt = true
		else
			key = s
		end
	end
	return key, combinations
end

local function combinations_to_string(combinations)
	return (combinations.shift and "SHIFT".."+" or "") .. (combinations.ctrl and "CTRL".."+" or "") .. (combinations.alt and "ALT".."+" or "")
end

local function combinations_to_localized(combinations)
	return (combinations.shift and NOLOC(L("%s+", "Shift")) or "") .. (combinations.ctrl and NOLOC(L("%s+", "Ctrl")) or "") .. (combinations.alt and NOLOC(L("%s+", "Alt")) or "")
end

function Options_Input:construct()
	local scroll_speed, drag_scrolling, edge_scrolling, mouse_lock = Game.GetScrollSpeed(), Game.GetDragScrolling(), Game.GetEdgeScrolling(), Game.GetMouseLock()
	self.scroll_speed.value = scroll_speed
	self.scroll_speed_txt.text = string.format("%d%%", math.floor(scroll_speed * 100 + 0.49))
	self.drag_scrolling_btn.icon = drag_scrolling and "icon_small_confirm" or nil
	self.drag_scrolling_btn.active = drag_scrolling
	self.edge_scrolling_btn.icon = edge_scrolling and "icon_small_confirm" or nil
	self.edge_scrolling_btn.active = edge_scrolling
	self.mouse_lock_btn.icon = mouse_lock and "icon_small_confirm" or nil
	self.mouse_lock_btn.active = mouse_lock

	self:refresh()
end

function Options_Input:on_scroll_speed(slider, scroll_speed)
	Game.SetScrollSpeed(scroll_speed)
	self.scroll_speed_txt.text = string.format("%d%%", math.floor(scroll_speed * 100 + 0.49))
end

function Options_Input:on_drag_scrolling(btn)
	local drag_scrolling = not btn.active
	Game.SetDragScrolling(drag_scrolling)
	btn.icon = drag_scrolling and "icon_small_confirm" or nil
	btn.active = drag_scrolling
end

function Options_Input:on_edge_scrolling(btn)
	local edge_scrolling = not btn.active
	Game.SetEdgeScrolling(edge_scrolling)
	btn.icon = edge_scrolling and "icon_small_confirm" or nil
	btn.active = edge_scrolling
end

function Options_Input:on_mouse_lock(btn)
	local mouse_lock = not btn.active
	Game.SetMouseLock(mouse_lock)
	btn.icon = mouse_lock and "icon_small_confirm" or nil
	btn.active = mouse_lock
end

function Options_Input:refresh()
	self.config:Clear()
	self.hotkeys:Clear()
	local key_names = Input.GetBindingNames("KEYBOARD")
	local mouse_names = Input.GetBindingNames("MOUSE")
	local gamepad_names = Input.GetBindingNames("GAMEPAD")
	local overrides = Game.GetProfile().options.action_mappings or {}

	local axis_lookup = { list_pos = 3, list_neg = 4, list_var = 2 }
	for axis,default in pairs(InputDefaultAxisMappings) do
		local tt = InputTooltips[axis]
		local widget = self.hotkeys:Add(layout_axis, { axis = axis,
			lbl_pos = tt and tt.label_pos or axis,
			lbl_neg = tt and tt.label_neg or axis,
			lbl_var = tt and tt.label_var or axis,
			sort = tt and tt.sort or (100 + #self.hotkeys)
		})
		local v = overrides[axis] or default
		for list_id, dir in pairs(axis_lookup) do
			local num = 0
			for _,binding in ipairs(type(v[dir]) == "table" and v[dir] or {v[dir]}) do
				num = num + 1
				widget[list_id]:Add(layout_single_key, {
					axis = axis, dir = dir, binding = binding,
					text = NOLOC(key_names[binding] or mouse_names[binding] or gamepad_names[binding] or Input.GetUnknownKeyBindingName(binding) or binding),
					image = (key_names[binding] and "icon_keyboard") or (mouse_names[binding] and "icon_mouse") or (gamepad_names[binding]and "icon_gamepad") or "icon_keyboard",
				})
			end
			while num < 2 do
				widget[list_id]:Add(layout_single_add, { axis = axis, dir = dir })
				num = num + 1
			end
		end
		widget.sens.value = v[1] / default[1]
		widget.senstxt.text = string.format("%.0f%%", 100 * widget.sens.value)
	end

	for action,default in pairs(InputDefaultActionMappings) do
		local tt = InputTooltips[action]
		local widget = self.hotkeys:Add(layout_action, {
			lbl = tt and tt.label or action,
			text_tooltip = tt and tt.tooltip or action,
			sort = 1000 + (tt and tt.sort or (1000 + #self.hotkeys))
		})
		local v = overrides[action] or default
		local num = 0
		for _,binding in ipairs(type(v) == "table" and v or {v}) do
			num = num + 1
			local key, combinations = split_binding(binding)
			widget.list:Add(layout_single_key, {
				action = action, binding = binding,
				text = L("%S%S", combinations_to_localized(combinations), (key_names[key] or mouse_names[key] or gamepad_names[key] or Input.GetUnknownKeyBindingName(key) or key)),
				image = (key_names[key] and "icon_keyboard") or (mouse_names[key] and "icon_mouse") or (gamepad_names[key]and "icon_gamepad") or "icon_keyboard",
			})
		end
		while num < 2 do
			widget.list:Add(layout_single_add, { action = action })
			num = num + 1
		end
	end

	self.hotkeys:SortChildren(function(a, b) return a.sort < b.sort end)

	self.last_hotkey_btn = nil
end

function Options_Input:on_sensitivity_changed(widget, sens, val)
	local axis = widget.axis
	local options = Game.GetProfile().options
	options.action_mappings = options.action_mappings or {}
	local overrides = options.action_mappings
	local v = overrides[axis] or Tool.Copy(InputDefaultAxisMappings[axis])
	v[1] = val * InputDefaultAxisMappings[axis][1]
	widget.senstxt.text = string.format("%.0f%%", 100 * val)
	self:update_axis_mappings(axis, v)
	overrides[axis] = v
end

function Options_Input:on_click_hotkey(btn)
	if self.last_hotkey_btn then
		self.last_hotkey_btn.active = false
	end
	self.last_hotkey_btn = btn
	self.last_hotkey_btn.active = true
	self.combinations = { shift = false, ctrl = false, alt = false }

	local config_input = self.config:SetContent(layout_config_input)
	config_input.combo_hidden = true
	config_input.delete_hidden = not btn.binding
end

function Options_Input:on_change_combo(checkbox, value)
	if checkbox.shift then
		self.combinations.shift = value
	elseif checkbox.ctrl then
		self.combinations.ctrl = value
	elseif checkbox.alt then
		self.combinations.alt = value
	end
end

function Options_Input:on_click_config(config_widget, btn)
	local axis, action, old_binding = self.last_hotkey_btn.axis, self.last_hotkey_btn.action, self.last_hotkey_btn.binding
	local mapping = axis or action
	local options = Game.GetProfile().options
	options.action_mappings = options.action_mappings or {}
	local overrides = options.action_mappings
	local v = overrides[mapping] or Tool.Copy(InputDefaultActionMappings[action] or InputDefaultAxisMappings[axis])
	local list = not axis and v or v[self.last_hotkey_btn.dir]
	list = type(list) == "table" and list or {list}
	config_widget.combo_hidden = not action and true or false

	local function update()
		list = (#list == 1 and list[1] or list)
		if axis then
			v[self.last_hotkey_btn.dir] = list
			self:update_axis_mappings(axis, v)
		elseif action then
			v = list
			self:update_action_mappings(action, v)
		end
		overrides[mapping] = v
		self:refresh()
	end

	local function assign_binding(key)
		local new_binding = self.last_hotkey_btn.axis and key or combinations_to_string(self.combinations) .. key
		for i,binding in ipairs(list) do
			if binding == new_binding then
				self:refresh()
				return
			end
		end
		if old_binding then
			--Editing Existing Binding
			for i,binding in ipairs(list) do
				if binding == old_binding then
					list[i] = new_binding
					break
				end
			end
		else
			--Adding New Binding
			list[#list+1] = new_binding
		end
		update()
	end

	if btn.is_delete then
		for i,binding in ipairs(list) do
			if binding == old_binding then
				table.remove(list, i)
				break
			end
		end
		return update()
	end

	if btn.is_byinput then
		btn.active = true
		local info = UI.AddLayout([[<Modal><Modal><Box dock=center padding=24><Text text="Press any key or button"/></Box></Modal></Modal>]], 99)
		Input.SetInputProcessor(function(key_name, is_down, axis)
			if key_name == 'LEFTSHIFT'   or key_name == 'RIGHTSHIFT'   then self.combinations.shift = is_down end
			if key_name == 'LEFTCONTROL' or key_name == 'RIGHTCONTROL' then self.combinations.ctrl = is_down end
			if key_name == 'LEFTALT'     or key_name == 'RIGHTALT'     then self.combinations.alt = is_down end
			if is_down or axis then return end
			Input.ClearInputProcessor()
			info:RemoveFromParent()
			assign_binding(key_name)
		end)
		return
	end

	local function on_select(key_btn)
		assign_binding(key_btn.key_id)
	end

	local list = axis and v[self.last_hotkey_btn.dir] or v
	if type(list) ~= "table" then list = {list} end
	config_widget.list:Clear()
	config_widget.list.child_padding = 2
	for key_id,name in SortedPairs(Input.GetBindingNames(btn.category)) do
		local exists = false
		for i, id in ipairs(list) do
			if id == key_id then
				exists = true
				break
			end
		end
		if not exists then
			config_widget.list:Add("Button", { text = name, key_id = key_id, on_click = on_select })
		end
	end
end

function Options_Input:on_click_reset(btn)
	local overrides = Game.GetProfile().options.action_mappings or {}
	ConfirmBox("Are you sure you want to reset all key bindings?", function()
		for axis,v in pairs(InputDefaultAxisMappings) do
			overrides[axis] = nil
			self:update_axis_mappings(axis, v)
		end
		for action,v in pairs(InputDefaultActionMappings) do
			overrides[action] = nil
			self:update_action_mappings(action, v)
		end
		self:refresh()
	end)
end

local function SetActionMappings(action, v)
	for _,binding in ipairs(type(v) == "table" and v or {v}) do
		Input.AddActionMapping(action, binding)
	end
end

local function SetAxisMappings(axis, v)
	for i=2,4 do
		local sens = v[1] * (i == 4 and -1 or 1)
		for _,binding in ipairs(type(v[i]) == "table" and v[i] or {v[i]}) do
			Input.AddAxisMapping(axis, binding, sens)
		end
	end
end

local frontend_actions = { CaptureFeedbackShot = true, Accept = true, InGameMenu = true }

function Options_Input:update_axis_mappings(axis, v)
	if Map.IsFrontEnd() and not frontend_actions[axis] then return end
	Input.RemoveAxisMapping(axis)
	SetAxisMappings(axis, v)
end

function Options_Input:update_action_mappings(action, v)
	if Map.IsFrontEnd() and not frontend_actions[action] then return end
	Input.RemoveActionMapping(action)
	SetActionMappings(action, v)
end

function UIMsg.OnSetupInputMapping(expand_frontend_actions)
	if expand_frontend_actions then
		for _,v in ipairs(expand_frontend_actions) do frontend_actions[v] = true end
	end
	local allows = Map.IsFrontEnd() and frontend_actions or nil

	local overrides = Game.GetProfile().options.action_mappings or {}
	for axis, defaults in pairs(InputDefaultAxisMappings) do
		if not allows or allows[axis] then
			SetAxisMappings(axis, overrides[axis] or defaults)
		end
	end
	for action, defaults in pairs(InputDefaultActionMappings) do
		if not allows or allows[action] then
			SetActionMappings(action, overrides[action] or defaults)
		end
	end
end

local layout_system<const> =
[[
	<Box bg=popup_box_bg padding=12 blur=true>
		<ScrollList child_padding=3>
			<Button width=350 text="Open Save Games Folder" on_click={on_click_folder} folder=SAVEGAMES />
			<Button width=350 text="Open Mods Folder"       on_click={on_click_folder} folder=MODS />
		</ScrollList>
	</Box>
]]

local Options_System<const> = {}
UI.Register("Options_System", layout_system, Options_System)

function Options_System:on_click_folder(btn)
	Game.ExploreFolder(btn.folder)
end

local layout_mods<const> =
[[
	<Box bg=popup_box_bg padding=12 blur=true height=800>
		<HorizontalList child_padding=8>
			<Box padding=8 width=200>
				<ScrollList child_padding=3 id=list/>
			</Box>
			<Box padding=8 width=600 id=content/>
		</HorizontalList>
	</Box>
]]

local Options_Mods<const> = {}
UI.Register("Options_Mods", layout_mods, Options_Mods)

function Options_Mods:construct()
	local is_frontend = Map.IsFrontEnd()
	for i,mod in ipairs(Game.GetInstalledMods()) do
		if mod.has_options and ((is_frontend and mod.is_enabled) or mod.is_loaded) then
			self.list:Add("<Button on_click={on_click_mod} clip=true/>", { text = mod.name, mod_id = mod.id })
		end
	end
end

function Options_Mods:on_click_mod(btn)
	for _,w in ipairs(self.list) do
		w.active = w == btn
	end
	self.content:SetContent(UI.MakeModOptionsWidget(btn.mod_id))
end
