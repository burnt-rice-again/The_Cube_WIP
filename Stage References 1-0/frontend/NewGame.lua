local ScenarioSelector_layout<const> =
[[
	<HorizontalList child_padding=12 child_align=top>
		<Box bg=popup_box_bg blur=true padding=10 margin_bottom=20>
			<ScrollList id=list width=250/>
		</Box>
		<Spacer id=newgame/>
	</HorizontalList>
]]

local ScenarioSelector<const> = {}
UI.Register("ScenarioSelector", ScenarioSelector_layout, ScenarioSelector)

function ScenarioSelector:construct()
	local active_scenario, list = self.active_scenario, {}
	for _,mod in ipairs(Game.GetInstalledMods()) do
		if mod.is_enabled then
			for _,pkg in ipairs(Game.GetInstalledModPackages(mod.id)) do
				if not pkg.is_missing_dependencies and not pkg.hidden_from_selector and (pkg.type == "Scenario" or pkg.type == "Challenge") and pkg.id ~= 'FrontEnd' and pkg.id ~= "Credits" then
					list[#list+1] = mod
					list[#list+1] = pkg
				end
			end
		end
	end

	local function AddScenarios(filter_mod, filter_pkg, filter_type, hide)
		for i=1,#list,2 do
			local mod, pkg = list[i], list[i+1]
			if mod and mod.id == filter_mod and (not filter_pkg or pkg.id == filter_pkg) and (not filter_type or pkg.type == filter_type) then
				local modpkg = mod.id .. "/" .. pkg.id
				self.list:Add("<Button on_click={on_select} on_double_click={on_run} tooltip={scenario_tooltip} margin_bottom=4/>",
					{ text = pkg.name, pkg = pkg, modpkg = modpkg, active = (active_scenario == modpkg), hidden = hide })
				list[i] = false -- list only once
				if list[i+2] ~= mod then return end
			end
		end
	end

	self.list:Add("<Text style=bl margin_bottom=5 margin_top=7/>").text = "Scenarios"
	AddScenarios("Main", "Freeplay", nil, not self.on_scenario_selected)
	AddScenarios("Main", nil, "Scenario")
	self.list:Add("<Text style=bl margin_bottom=5 margin_top=7/>").text = "Challenge Scenarios"
	AddScenarios("Main", nil, "Challenge")
	for i=1,#list,2 do
		local mod = list[i]
		if mod and mod.id ~= "Main" and (i == 1 or list[i-2] ~= mod) then
			local txt = self.list:Add("<Text style=bl margin_bottom=5 margin_top=7/>")
			txt.text, txt.tooltip = L("Mod: %s", mod.name), mod.description
			AddScenarios(mod.id)
		end
	end

	self:TweenFromTo("sx", 0.01, 1, 40, 'OutQuad')
	self:TweenFromTo("sy", 0.01, 1, 80, 'OutQuad')
	UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN")
end

function ScenarioSelector:on_select(btn)
	if self.on_scenario_selected then
		self.on_scenario_selected(btn.modpkg)
		return
	end
	if btn.active then return end
	for _,w in ipairs(self.list) do if w.active then w.active = false end end
	btn.active = true
	self.newgame:SetContent("NewGame", { scenario = btn.modpkg })
end

function ScenarioSelector:on_run(btn)
	self.newgame[1]:on_start()
end

function ScenarioSelector:scenario_tooltip(btn)
	local res = UI.New([[<Box bg=popup_box_bg blur=true padding=8 max_width=500><VerticalList child_padding=8>
			<Text size=16 text={scenario_name} color=title/>
			<Text text="<hl>Description:</>"/>
			<Text text={desc} wrap=true/>
			<Text text="<hl>Based On:</>"/>
			<VerticalList id=dependencies margin_left=4/>
		</VerticalList></Box>]])
	res.scenario_name = btn.pkg.name
	res.desc = btn.pkg.description
	for _,v in ipairs(btn.pkg.dependencies) do
		if v ~= "Main/Data" then
			res.dependencies:Add("Text", { text = v })
		end
	end
	res.dependencies.previous_sibling.hidden = #res.dependencies == 0
	return res
end

---------------------------------------------------------------------------------------------------------------------------

local NewGame_layout<const> =
[[
	<HorizontalList child_padding=12 child_align=top>
		<Box bg=popup_box_bg blur=true id=mover padding=10 width=500>
			<ScrollList>
				<VerticalList child_padding=8 margin_bottom=8 id=scenariodetails hidden=true>
					<Text id=scenarioname style=hl wrap=true textalign=center/>
					<Text id=scenariodesc wrap=true/>
				</VerticalList>

				<HorizontalList child_align=center child_padding=1 margin_bottom=4 id=scenariorow>
					<Text text="Scenario" fill=true/>
					<Text id=scenariotxt textalign=center width=213 style=hl/>
					<Button width=32 height=34 icon=icon_edit on_click={on_scenario}/>
				</HorizontalList>

				<HorizontalList child_align=center child_padding=1 margin_bottom=4>
					<Text text="Seed" fill=true/>
					<InputText id=seed width=213 height=34 textalign=center on_change={on_seed_changed}/>
					<Button width=32 height=34 icon=icon_refresh on_click={randomize_seed}/>
				</HorizontalList>

				<ServerSettings id=server margin_bottom=10/>

				<HorizontalList halign=fill>
					<Button id=custom_btn width=36 height=36 valign=bottom on_click={toggle_custom} noclicksound=true icon=icon_cog tooltip="Custom Game Settings"/>
					<Image id=custom_star image=icon_achieved width=32 height=32 color=title valign=bottom margin_bottom=3 hidden=true/>
					<Spacer fill=true/>
					<Button on_click={on_start} noclicksound=true padding=0><HorizontalList child_align=center><Image image=icon_play width=56 height=56 margin=-4 color=ui_light/><Text text="Play" margin_left=4 margin_right=12/></HorizontalList></Button>
				</HorizontalList>

				<VerticalList id=custom_game hidden=true child_padding=5 margin_top=10>
					<Text color=ui_light text="Game Settings:"/>
					<Text style=desc text="These settings change the intended gameplay experience" textalign=center/>
					<VerticalList child_padding=4 id=custom_list/>
				</VerticalList>
			</ScrollList>
		</Box>
		<Box bg=popup_box_bg blur=true id=mapbox padding=16>
			<Minimap id=prvmap width=480 height=480 is_map_preview=true/>
		</Box>
		<Spacer id=select/>
	</HorizontalList>
]]

local NewGame<const> = {}
UI.Register("NewGame", NewGame_layout, NewGame)

function NewGame:construct()
	self.mover:TweenFromTo("sy", 0.01, 1, 80, 'OutQuad')
	UI.PlaySound("fx_ui_WINDOW_GENERIC_OPEN")

	self.seed.text = tostring(math.random(0xFFFFFFFF))
	self.server.hidden = not self.start_online_session
	self.scenariorow.hidden = not self.start_online_session
	self.custom_star.hidden = not self.show_custom_star

	self:update_scenario(self.scenario or 'Main/Freeplay')

	--[[DEBUG VIEW
	self:Add("Spacer", { construct = function(w) w.b = UI.AddLayout("<Box width=300 dock=left><ScrollList max_height=800><Text text={txt}/></ScrollList></Box>", { every_frame_update = function(wb) local s = Tool.Copy(self.settings) for _,w in ipairs(self.custom_list) do w.fFillSettings(s, w) end wb.txt = tostring(s) end }) end, destruct = function(w) w.b:RemoveFromParent() end })
	--]]
end

function NewGame:update_scenario(scenario)
	local package, mod = Game.GetInstalledModPackage(scenario)
	local no_map_settings = package.no_map_settings
	self.scenariotxt.text = package.name
	self.scenariotxt.tooltip = mod.id ~= "Main" and L("Mod: %s", mod.name)
	self.server.scenario = scenario
	self.custom_btn.hidden = no_map_settings
	self.seed.parent.hidden = no_map_settings
	self.mapbox.hidden = package.no_map_preview
	self.no_map_preview = package.no_map_preview

	local custom_list = self.custom_list
	local settings = { scenario = scenario }
	self.settings = settings

	if no_map_settings then
		self.custom_game.hidden = true
		self.custom_btn.active = false
		custom_list:Clear()
	else
		settings.seed = tonumber(self.seed.text, 10)
		for _,w in ipairs(custom_list) do
			w.fFillSettings(settings, w)
		end
		custom_list:Clear()
		for _,v in ipairs(UI.GetMapSettingsArray(scenario)) do
			local fFillInputList, fFillSettings, fFillPreviewSettings = v.FillInputList, v.FillSettings, v.FillPreviewSettings
			local vl = fFillInputList and fFillSettings and custom_list:Add("<VerticalList child_padding=4/>", { fFillSettings = fFillSettings, fFillPreviewSettings = fFillPreviewSettings })
			if vl then fFillInputList(settings, vl) end
		end
	end

	if self.scenario and not self.start_online_session then
		self.scenariodetails.hidden = false
		self.scenarioname.text = package.name
		self.scenariodesc.text = (package.description or "")
		self.scenariodesc.hidden = (package.description or "") == ""
	end
end

function NewGame:toggle_custom(btn)
	btn.active = self.custom_game.hidden
	self.custom_game.hidden = not self.custom_game.hidden
	if not btn.active then
		-- reset settings to defaults
		self.custom_list:Clear()
		self:update_scenario(self.settings.scenario)
	end
end

function NewGame:on_seed_changed(input, value)
	self.settings.seed = math.min(tonumber(string.gsub(value, "%D", ""), 10) or 0, 0xFFFFFFFF)
	self.seed.text = tostring(self.settings.seed)
end

function NewGame:randomize_seed()
	self:on_seed_changed(nil, tostring(math.random(0xFFFFFFFF)))
end

function NewGame:on_scenario(btn)
	if btn.active then
		self.select:Clear()
		btn.active = false
		self.mapbox.hidden = self.no_map_preview
		return
	end
	btn.active = true
	self.mapbox.hidden = true
	self.select:SetContent("ScenarioSelector", {
		filter = "Scenario",
		on_scenario_selected = function(selection)
			self.select:Clear()
			btn.active = false
			self.mapbox.hidden = self.no_map_preview
			self:update_scenario(selection)
		end,
		active_scenario = self.settings.scenario,
	})
end

function NewGame:on_start()
	if not Game.GetProfile().tutorial_ask then
		Game.GetProfile().tutorial_ask = true
		ConfirmBox("Desynced is quite unique in its core mechanics. We highly recommend playing through the tutorial if that's your first time. Would you like to play the tutorial mode?",
			function() Game.NewGame({ seed = 22, scenario = 'Main/Freeplay', tutorial = true }) end, -- play tutorial
			function() self:on_start() end -- continue as normal
		)
		return
	end

	local settings = self.settings
	for _,w in ipairs(self.custom_list) do
		w.fFillSettings(settings, w)
	end
	self.every_frame_update = false -- stop updating preview

	local session_settings = self.start_online_session and self.server:get_session_settings_table() or nil
	Game.NewGame(settings, session_settings)
	UI.PlaySound("fx_ui_BUTTON_START_GAME")
end

function NewGame:every_frame_update()
	if self.no_map_preview then return end
	local settings = self.settings
	for _,w in ipairs(self.custom_list) do
		local fFillPreviewSettings = w.fFillPreviewSettings
		if fFillPreviewSettings then fFillPreviewSettings(settings, w) end
	end
	local previewhash = Tool.Hash(settings)
	if self.previewhash == previewhash then return end
	self.previewhash = previewhash
	self.prvmap:MapPreview(settings)
end
