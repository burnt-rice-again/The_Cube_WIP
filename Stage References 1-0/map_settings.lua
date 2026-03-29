local plateau_level_labels    = { "TX_AMT_LOW", "TX_AMT_MEDIUM", "TX_AMT_HIGH" }
local plateau_level_values    = { 0.2, 0.15, 0 }
local landscape_labels        = { "Normal", "Flat" }
local landscape_values        = { "normal", "flat" }
local day_period_labels       = { "Short", "Normal", "Long" }
local day_period_values       = { 500, 1000, 1500 }
local days_per_year_labels    = { "Off", "Short", "Normal", "Long" }
local days_per_year_values    = { 0, 10, 20, 50 }
local peaceful_labels         = { "None", "Passive", "Aggressive", "Swarm" }
local old_resource_richness   = { 0.5, 1.0, 4.0, 1.0 }

local peaceful_tooltip        = [[
<hl>None</> - Enemy bugs will not spawn
<hl>Passive</> - Enemy bugs will become hostile if attacked
<hl>Aggressive</> - Enemy bugs will attack if you get close
<hl>Swarm</> - Enemy bugs will spread and attack discovered players]]

local landscape_tooltip       = [[
<hl>Normal</> - Normal bumpy landscape generation
<hl>Flat</> - Flat desert and grasslands to make building bases easier]]

local day_period_tooltip       = [[
<hl>Short</> - Days are quicker, half the time as <bl>Normal</>
<hl>Normal</> - Default day length, around 17 minutes in real time
<hl>Long</> - Days are 1.5 times longer than <bl>Normal</>]]

local days_per_year_tooltip       = [[
A year is a full cycle of four seasons. Seasons can affect different game mechanics.
For example, solar panels produce more power in summer and enemy bugs will hibernate in winter.
<hl>Off</> - Eternal summer
<hl>Short</> - 10 days per yearly cycle
<hl>Normal</> - 20 days per yearly cycle (Default)
<hl>Long</> - 50 days per yearly cycle]]

local blight_threshold_to_percent = function(v) return (.3001 + v) * 100 end

local function find_index(val, vals)
	for i,v in ipairs(vals) do if val == v then return i end end
	return 1
end

local function find_threshold_index(val, vals)
	for i=1,#vals-1 do
		local up, mid = vals[i+1] > vals[i], (vals[i] + vals[i+1]) / 2
		if (up and val < mid) or (not up and val > mid) then return i end
	end
	return #vals
end

local function nil_on_similar(val, default, keep_existing)
	return (math.abs(val - default) >= 0.001 and val) or (keep_existing == default and default) or nil
end

local function nil_on_default(val, default, keep_existing)
	if val ~= default then return val end -- val can be false
	if keep_existing == default then return default end -- default can be false
	return nil
end

local function AddSlider(list, text, tooltip, min, max, step, value, to_percent)
	local hl = list:Add("<HorizontalList child_align=center child_fill=true height=32><Text/><HorizontalList><Slider fill=true/><Text width=50 textalign=right/></HorizontalList></HorizontalList>")
	local lbl, sli, valtxt = hl[1], hl[2][1], hl[2][2]
	lbl.text, lbl.tooltip, sli.min, sli.max, sli.step, sli.value = text, tooltip, min, max, step, value
	sli.on_change = function(_,v) valtxt.text = string.format("%.0f%%", to_percent and to_percent(v) or (v * 100)) end
	sli:on_change(value)
	return sli
end

local function AddCombo(list, text, tooltip, labels, value)
	local hl = list:Add("<HorizontalList child_align=center child_fill=true height=32><Text/><Combo/></HorizontalList>")
	hl[1].text, hl[1].tooltip, hl[2].texts, hl[2].value = text, tooltip, labels, value
	return hl[2]
end

local function AddCheckbox(list, text, tooltip, value)
	local hl = list:Add("<HorizontalList child_align=center child_fill=true height=32><Text/><CheckBox/></HorizontalList>")
	hl[1].text, hl[1].tooltip, hl[2].check = text, tooltip, value
	return hl[2]
end

local function AddInfo(list, label, value)
	local c = list:Add("<Canvas><Text/><Text color=ui_light halign=right/></Canvas>")
	c[1].text, c[2].text = value, label
end

return {
	FillInputList = function(settings, list, in_game)
		local val_world_freq       = nil_on_similar(settings.elevation_params_freq  or 0.8, 0.8) or 0.8
		local val_world_scale      = nil_on_similar(settings.elevation_params_scale or 1.0, 1.0) or 1.0
		local val_blight_threshold =-(nil_on_similar(settings.blight_threshold      or 0.1, 0.1) or 0.1)
		local val_plateau_level    = find_threshold_index(settings.plateau_level    or 0.15, plateau_level_values)
		local val_landscape        = find_index(settings.landscape                  or "normal", landscape_values)
		local val_resource_amt     = nil_on_similar(settings.resource_amt           or 1.0, 1.0) or 1.0
		local val_resource_inf     = settings.resource_inf or false
		local val_enable_day_night = not (settings.enable_day_night == false)
		local val_day_period       = find_threshold_index(settings.day_period       or 1000, day_period_values)
		local val_days_per_year    = find_threshold_index(settings.days_per_year    or 20, days_per_year_values)
		local val_peaceful         = (settings.peaceful or 2) + 1
		local val_difficulty       = settings.difficulty or 1.0
		local val_creep            = val_peaceful > 3 or (val_peaceful == 3 and settings.creep)
		local val_minigames        = not settings.disable_minigames
		local val_allow_race_selection = settings.allow_race_selection or false

		if not in_game then
			list.world_freq             = AddSlider(list, "Biome Density", "How sparse biomes are generated", 0.2, 1.5, 0.1, val_world_freq)
			list.world_scale            = AddSlider(list, "Water/Plateau Density", "Water and plateau density", 0.2, 1.5, 0.1, val_world_scale)
			list.blight_threshold       = AddSlider(list, "Blight Corruption", "Amount of blight corruption spawned within the world", -0.2, -0.01, 0.01, val_blight_threshold, blight_threshold_to_percent)
			list.plateau_level          = AddCombo(list, "Plateau Amounts", "Plateau density", plateau_level_labels, val_plateau_level)
			list.landscape              = AddCombo(list, "Landscape", landscape_tooltip, landscape_labels, val_landscape)
			list.resource_amt           = AddSlider(list, "Resource Richness", "Amount of resources spawned in a single resource node", 0.5, 4.0, 0.1, val_resource_amt)
			list.resource_inf           = AddCheckbox(list, "Infinite Rich Resources", "Rich resource nodes are infinite", val_resource_inf)
			list.enable_day_night       = AddCheckbox(list, "Day/Night Cycle", "Turn off to disable night", val_enable_day_night)
			list.day_period             = AddCombo(list, "Day Length", day_period_tooltip, day_period_labels, val_day_period)
			list.days_per_year          = AddCombo(list, "Year Length", days_per_year_tooltip, days_per_year_labels, val_days_per_year)
		end
		do
			list.peaceful               = AddCombo(list, "Hostility Level", peaceful_tooltip, peaceful_labels, val_peaceful)
			list.peaceful.on_change     = function(cmb, val) list.creep.check, list.creeprow.disabled = val > 3, val ~= 3 end
			list.difficulty             = AddSlider(list, "Difficulty", "Affects number and types of bugs that spawn", 0.2, 4.0, 0.1, val_difficulty)
			list.creep                  = AddCheckbox(list, "Bug Hive Evolution", "Bugs will spread throughout the world", val_creep)
			list.creeprow               = list.creep.parent
			list.creeprow.disabled      = list.peaceful.value ~= 3
			list.minigames              = AddCheckbox(list, "Minigames", "Enables/Disables minigames when <bl>manually</> solving puzzles", val_minigames)
		end
		if not in_game and Game.GetProfile().allow_race_selection then
			local hl = list:Add([[<HorizontalList child_align=center child_fill=true height=32>
					<HorizontalList child_align=center><Text/><Image image=icon_achieved width=32 height=32 color=title/></HorizontalList>
					<CheckBox/>
				</HorizontalList>]])
			hl[1][1].text, hl[1].tooltip, hl[2].check = "Allow Race Selection", "Allow players to select their starting race", val_allow_race_selection
			hl[1][2].hidden = Game.GetProfile().played_race_selection
			list.allow_race_selection = hl[2]
		end
	end,

	FillPreviewSettings = function(settings, list)
		settings.elevation_params_freq  = nil_on_similar(list.world_freq.value,                           0.8)
		settings.elevation_params_scale = nil_on_similar(list.world_scale.value,                          1.0)
		settings.blight_threshold       = nil_on_similar(-list.blight_threshold.value,                    0.1)
		settings.plateau_level          = nil_on_default(plateau_level_values[list.plateau_level.value],  0.15)
		settings.landscape              = nil_on_default(landscape_values[list.landscape.value],          "normal")
	end,

	FillSettings = function(settings, list, in_game)
		if not in_game then
			settings.elevation_params_freq  = nil_on_similar(list.world_freq.value,                           0.8)
			settings.elevation_params_scale = nil_on_similar(list.world_scale.value,                          1.0)
			settings.blight_threshold       = nil_on_similar(-list.blight_threshold.value,                    0.1)
			settings.plateau_level          = nil_on_default(plateau_level_values[list.plateau_level.value],  0.15)
			settings.landscape              = nil_on_default(landscape_values[list.landscape.value],          "normal")
			settings.resource_amt           = nil_on_similar(list.resource_amt.value,                         1.0)
			settings.resource_inf           = nil_on_default(list.resource_inf.check,                         false)
			settings.enable_day_night       = nil_on_default(list.enable_day_night.check == true,             true)
			settings.day_period             = nil_on_default(day_period_values[list.day_period.value],        1000)
			settings.days_per_year          = nil_on_default(days_per_year_values[list.days_per_year.value],  20)
		end
		do
			settings.peaceful               = nil_on_default((list.peaceful.value or 2)-1,                    2,     settings.peaceful)
			settings.difficulty             = nil_on_similar(list.difficulty.value,                           1.0,   settings.difficulty)
			settings.creep                  = nil_on_default(not list.creeprow.disabled and list.creep.check, false, settings.creep)
			settings.disable_minigames      = nil_on_default(list.minigames.check == false,                   false, settings.disable_minigames)
			settings.allow_race_selection   = nil_on_default(list.allow_race_selection and list.allow_race_selection.check, false, settings.allow_race_selection)
		end
	end,

	FillInfoList = function(settings, list)
		AddInfo(list, "Biome Density",           string.format("%.0f%%", 100 * (settings.elevation_params.frequency or 1)))
		AddInfo(list, "Water/Plateau Density",   string.format("%.0f%%", 100 * (settings.elevation_params.scale or 1)))
		AddInfo(list, "Blight Corruption",       string.format("%.0f%%", blight_threshold_to_percent(-settings.blight_threshold)))
		AddInfo(list, "Plateau Amounts",         plateau_level_labels[find_threshold_index(settings.plateau_level, plateau_level_values)])
		AddInfo(list, "Landscape",               landscape_labels[find_index(settings.landscape, landscape_values)])
		AddInfo(list, "Resource Richness",       settings.resource_richness and tostring(old_resource_richness[settings.resource_richness]) or string.format("%.0f%%", (settings.resource_amt or 1.0) * 100))
		AddInfo(list, "Infinite Rich Resources", settings.resource_richness and (settings.resource_richness==4 and "Yes" or "No") or (settings.resource_inf and "Yes" or "No"))
		AddInfo(list, "Day/Night Cycle",         settings.enable_day_night and "Yes" or "No")
		AddInfo(list, "Day Length",              day_period_labels[find_threshold_index(settings.day_period, day_period_values)])
		AddInfo(list, "Year Length",             day_period_labels[find_threshold_index(settings.days_per_year, days_per_year_values)])
		AddInfo(list, "Hostility Level",         peaceful_labels[(settings.peaceful or 2)+1])
		AddInfo(list, "Difficulty",              string.format("%.0f%%", (settings.difficulty or 1.0) * 100))
		AddInfo(list, "Bug Hive Evolution",      ((settings.peaceful or 2) > 2 or ((settings.peaceful or 2) == 2 and settings.creep)) and "Yes" or "No")
		AddInfo(list, "Minigames",               settings.disable_minigames and "No" or "Yes")
		if settings.allow_race_selection then
			AddInfo(list, "Allow Race Selection", "Yes")
		end
	end,
}
