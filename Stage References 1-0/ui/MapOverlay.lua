local overlay_mode_names =
{
	"Clear", "Basic", "Everything"
}

local function GetOverlayDefaults(mode)
	local tbl =
	{
		bars = { faction = true, enemy = true, ally = true, neutral = true, world = true },
		ranges = { visibility = true, power = true },
		icons = { Inefficient = true, Unpowered = true, Emergency = true, Broken = true, StaleOrder = true, LuaCustom1 = true },
		visual_register = true,
	}
	if mode == 1 then -- show only health bars and visual register on hovered unit
		tbl.hover_only_icons, tbl.disable_icons, tbl.disable_ranges = true, true, true
	elseif mode == 2 then -- show health bars and visual registers
		tbl.disable_ranges = true
		tbl.selected = { stores = true, gotos = true, transport_routes = true, power_transmitters = true, portals = true, orders = true }
	else -- show everything
		tbl.icons = { Idle = true, PoweredDown = true, PathBlocked = true, Inefficient = true, Unpowered = true, Emergency = true, Broken = true, StaleOrder = true, LuaCustom2 = true, LuaCustom1 = true, LogisticsConnected = true, LogisticsDisconnected = true, LogisticsTransportRoute = true, LogisticsCraneOnly = true, LogisticsHighPriority = true }
		tbl.global = { stores = true, gotos = true, transport_routes = true, power_transmitters = true, portals = true, orders = true, paths = true }
		tbl.damage, tbl.power, tbl.grid = true, true, true
	end
	return tbl
end

local function ApplyOverlayOptions(edit_func, set_mode, reset_settings)
	local profile = Game.GetProfile()
	local os = profile.overlay_settings
	local mode = (type(os) == "table" and os.mode or 2)
	if type(os) ~= "table" or not os.mode then os, profile.overlay_settings = nil, nil end

	if set_mode then
		if not os then os = {} Game.GetProfile().overlay_settings = os end
		mode, os.mode = set_mode, set_mode
	end

	if reset_settings and os and os[mode] then
		os[mode] = nil
	end

	local modetbl = os and os[mode] or GetOverlayDefaults(mode)

	if edit_func then
		edit_func(modetbl)
		if not os then os = { mode = mode } end
		if not os[mode] then os[mode] = modetbl end
		if not profile.overlay_settings then profile.overlay_settings = os end
		if Tool.Hash(modetbl) == Tool.Hash(GetOverlayDefaults(mode)) then os[mode] = nil end
	end

	local connections_global, connections_selected, icons, bars, ranges = modetbl.global, modetbl.selected, modetbl.icons, modetbl.bars, modetbl.ranges
	if modetbl.disable_connections then modetbl.global, modetbl.selected = nil, nil end
	if modetbl.disable_icons       then modetbl.icons = nil end
	if modetbl.disable_bars        then modetbl.bars = nil end
	if modetbl.disable_ranges      then modetbl.ranges = nil end
	View.SetVisualizations(modetbl)
	UI.Run("OnOverlayChanged", modetbl)
	modetbl.global, modetbl.selected, modetbl.icons, modetbl.bars, modetbl.ranges = connections_global, connections_selected, icons, bars, ranges
end

local function CacheWidget(canvas, cache, layout)
	local used = cache.used
	if used == #cache then
		cache[#cache+1] = canvas:Add(layout)
		cache[#cache]:SetIgnoreHitTest()
		if #cache == 1 then
			cache.w, cache.h = cache[1]:GetDesiredSize()
		end
	end
	used = used + 1
	if used > cache.shown then
		cache[used].hidden = false
	end
	cache.used = used
	return cache[used], cache.w, cache.h
end

local function CacheHideUnused(cache)
	if cache.used >= cache.shown then return end
	for i = cache.used + 1, cache.shown do
		cache[i].hidden = true
	end
end

local state_filter, trust_filter, state_strings = 0, 0, { }
local show_visual_register, hover_only_icons, show_damage
local temp_powerdisplay, temp_griddisplay, temp_gridrange, resview, ignorescale

function UIMsg.OnOverlayChanged(modetbl)
	state_filter = modetbl.icons and Tool.EncodeEntityStates(GetSortedTableKeys(modetbl.icons)) or 0
	trust_filter = modetbl.bars and Tool.EncodeTrustLevels(GetSortedTableKeys(modetbl.bars)) or 0
	state_strings = { }
	show_visual_register = modetbl.visual_register or nil
	hover_only_icons = modetbl.hover_only_icons or nil
	show_damage = modetbl.damage or nil

	local power_display = ((modetbl.power and 1 or 0) + (temp_powerdisplay or 0))
	local grid_display = (temp_gridrange and (temp_griddisplay and 1 or 0) or (modetbl.grid and 1 or 0))
	View.SetPostProcess("PowerDisplay", power_display)
	View.SetPostProcess("HoverDisplay", grid_display)
	if grid_display > 0 then
		View.SetPostProcess("HoverRange", temp_gridrange or 4)
		if temp_gridrange == 0 then grid_display = 0 end -- no resource overview with 0 range
	end

	if grid_display > 0 and not resview then
		resview = UI.AddLayout("<Text textalign=center dock=top y=75/>", { every_frame_update = function(v, dt)
			local x, y = View.GetHoveredTilePosition()
			local faction, resources = Game.GetLocalPlayerFaction(), {}
			Map.FindClosestEntity(x, y, temp_gridrange or 4, function(e)
				if not faction:IsDiscovered(e) then return end
				local id, amt = GetResourceHarvestItemId(e), GetResourceHarvestItemAmount(e)
				if id and resources[id] ~= REG_INFINITE then
					resources[id] = (amt ~= REG_INFINITE and resources[id] or 0) + amt
				elseif not id then
					for _,slot in ipairs(e.slots or {}) do
						local slot_def = slot.def
						id = slot_def and slot_def.mining_recipe and slot_def.id
						if id and resources[id] ~= REG_INFINITE then
							resources[id] = (resources[id] or 0) + slot.stack
						end
					end
				end
			end, FF_RESOURCE|FF_DROPPEDITEM)

			local txt = ""
			if next(resources) then
				if txt == "" then txt = L("%s<notify_info>%s:</>\n", txt, "Resources") end
				for id,count in SortedPairs(resources) do
					txt = L("%s<outline>%s: %S</>\n", txt, data.items[id].name, count == REG_INFINITE and "∞" or tostring(count))
				end
			end

			if faction:IsDiscovered(x, y) then
				local innetwork = faction:GetPowerGridIndexAt(x, y)
				local plateau, blight = Map.GetPlateauDelta(x, y), Map.GetBlightnessDelta(x, y)
				local onplateau, inblight = plateau >= 0, blight >= 0
				local windbonus = not onplateau and plateau >= -0.1 and faction:IsUnlocked("c_wind_turbine")
				local blightextract = not inblight and blight >= -0.02 and faction:IsUnlocked("c_blight_extractor")
				if innetwork or onplateau or inblight or windbonus or blightextract then
					txt = L("%s\n", txt)
					if innetwork then txt = L("%s<outline>%s</>\n", txt, "Location is in the logistics network") end
					if onplateau then txt = L("%s<outline>%s</>\n", txt, "Location is on the plateau") end
					if inblight then txt = L("%s<outline>%s</>\n", txt, "Location is in the blight") end
					if windbonus then txt = L("%s<outline>%s</>\n", txt, "Location is high enough for increased wind power") end
					if blightextract then txt = L("%s<outline>%s</>\n", txt, "Blight gas can be extracted at this location") end
				end
			end

			v.text = txt
		end })
	elseif grid_display == 0 and resview then
		resview:RemoveFromParent()
		resview = nil
	end
end

function MapOverlayIgnoreScaling(newscale)
	ignorescale = newscale
end

local MapOverlay<const> = {}
local mapoverlay_instance
UI.Register("MapOverlay", "Canvas", MapOverlay)

function MapOverlay:construct()
	self.caches = {}
	for i=1,5 do self.caches[i] = { shown = 0, used = 0 } end
	ApplyOverlayOptions()
	mapoverlay_instance = self
end

function MapOverlay:destruct()
	mapoverlay_instance = nil
end

local enttable_cache = { }
local healthbar_colors = {
	faction = "#000000",
	world   = "#6E1878", --"#DD85E7",
	ally    = "#187869", --"#85E7DA",
	neutral = "#785318", --"#E7C385",
	enemy   = "#78181A", --"#E78587",
}

local DamageText = {
	color_table = {
		energy_damage = "cyan",
		physical_damage = "orange",
		full_damage = "white",
		plasma_damage = "light_purple",
		electromag_damage = "light_blue",
	}
}
UI.Register("DamageText", "Text", DamageText)

function DamageText:construct()
	self.size = 28
	self.style = "damage"
	self.t = 0
	self.oy = self.y
	self.rndx = math.random(-15, 15)
	self.rndy = math.random(-15, 15)
	local color = self.color_table[self.damage_type]
	if color == nil then
		print("unknown damage type", self.damage_type)
	end
	self.color = color or "red"
end

function DamageText:every_frame_update(dt)
	self.t = self.t + dt
	local t = self.t
	self.opacity = 1.0-t

	if self.entity.exists then
		local faction = self.entity.faction
		if faction then
			local enttable, enttablecount = faction:GetVisibleEntities(self.entity)
			for i=1,enttablecount,7 do
				local x, y= enttable[i+1], enttable[i+2]
				self.x = self.rndx + x
				self.y = self.rndy + y - (t*130.0)
			end
		end
	end

	if t > 1 then self:RemoveFromParent() end
end
function AddDamagedEnemy(entity, damage, damage_type)
	if show_damage and mapoverlay_instance then
		UI.Run(function()
			local flag, x, y = UI.EntityLocationOnScreen(entity, true)
			if flag then
				mapoverlay_instance:Add("DamageText", { x = x, y = y, text = tostring(damage), entity = entity, damage_type = damage_type })
			end
		end)
	end
end

function MapOverlay:every_frame_update(dt)
	local caches = self.caches
	for _,c in ipairs(caches) do c.shown, c.used = c.used, 0 end

	local enttable, enttablecount, entity_filter
	if hover_only_icons then
		entity_filter = View.GetHoveredEntity()
		if not entity_filter then enttablecount = 0 end
	end
	if not enttablecount then
		enttable, enttablecount = Game.GetLocalPlayerFaction():GetVisibleEntities(enttable_cache, true, entity_filter, state_filter)
	end

	local c_signpost = data.components.c_signpost
	local single_reg, regtable, regtablecount = { 0, 0, 0 }
	for i=1,enttablecount,6 do
		local entity, x, y, z, reg, states = enttable[i], enttable[i+1], enttable[i+2], enttable[i+3], enttable[i+4], enttable[i+5]
		local state_string = state_strings[states]
		if state_string == nil then
			local states_names, data_state_icons = Tool.ParseEntityStates(states), data.state_icons
			state_string = false
			for _,s in ipairs(states_names) do
				state_string = (state_string or "") .. string.format('<img image="%s" width="32" height="32"/>', data_state_icons[s])
			end
			state_strings[states] = state_string
		end

		if reg and show_visual_register then
			if type(reg) ~= "table" then
				-- showing a single visual reg
				regtable, regtablecount, single_reg[1], single_reg[2], single_reg[3] = single_reg, 3, reg, x, y
			else
				-- showing multiple visual regs
				regtable, regtablecount = reg, #reg
			end
		elseif state_string then
			-- state icons only
			regtable, regtablecount, single_reg[1], single_reg[2], single_reg[3] = single_reg, 3, false, x, y
		else
			-- nothing to show
			regtablecount = 0
		end

		local scale = ignorescale and 1 or math.max(1.0 - ((z - 1900) / 4000.0), 0.3)
		for j=1,regtablecount,3 do
			local reg, ofs_x, ofs_y = regtable[j], regtable[j+1], regtable[j+2]
			local item = reg and (data.all[reg.id] or (reg.entity and reg.entity.def))
			if item or (state_string and j == 1) then
				local ui, w, h
				if item == c_signpost and entity.extra_data.signpost then
					ui, w, h = CacheWidget(self, caches[4], "<Scale><Text style=res id=txt size=20 textalign=center width=0 y=-20/></Scale>")
					ui.txt.text = NOLOC(entity.extra_data.signpost)
				elseif item and state_string and j == 1 then
					ui, w, h = CacheWidget(self, caches[1], "<Scale><VerticalList y=-16><Text text={txt} textalign=center width=0/><Reg bg=black_bg icon={icon} num={regnum} valign=center width=48 height=48 y=-6/></VerticalList></Scale>")
					ui.txt = state_string
					ui.icon = (item.texture or (item.frame and data.frames[item.frame].texture))
					local regnum = reg.num == REG_INFINITE and entity:CountItem(item.id) or reg.num
					ui.regnum = regnum ~= 0 and regnum or ""
				elseif item then
					ui, w, h = CacheWidget(self, caches[2], "<Scale><Reg bg=black_bg icon={icon} num={regnum} width=48 height=48/></Scale>")
					ui.icon = (item.texture or (item.frame and data.frames[item.frame].texture))
					local regnum = reg.num == REG_INFINITE and entity:CountItem(item.id) or reg.num
					ui.regnum = regnum ~= 0 and regnum or ""
				else
					ui, w, h = CacheWidget(self, caches[3], "<Scale><Text text={txt} textalign=center width=0/></Scale>")
					ui.txt = state_string
				end
				ui.scale = scale
				ui:SetPosition(ofs_x - w * scale * 0.5, ofs_y - h * scale * 0.5, -z)
			end
		end
	end

	enttable, enttablecount = View.GetVisibleEntities(enttable_cache, true, true, trust_filter)
	for i=1,enttablecount,7 do
		local x, y, z, trust, health, health_max = enttable[i+1], enttable[i+2], enttable[i+3], enttable[i+4], enttable[i+5], enttable[i+6]
		local ui, w, h = CacheWidget(self, caches[5], '<Scale><Progress height=10 width=50 progress={progress} color=#95E787 bgcolor={bgcolor}/></Scale>')
		ui.progress = health / health_max
		ui.bgcolor = healthbar_colors[trust] or "#FFFFFF"
		local scale = math.max(1.0 - ((z - 1900) / 4000.0), 0.3)
		ui.scale = scale
		ui:SetPosition(x - w * scale * 0.5, y - (h-60) * scale * 0.5, -z)
	end

	for _,c in ipairs(caches) do CacheHideUnused(c) end
end

--------------------------------------------------------------------------------------------------

local OverlayOptions_layout<const> =
[[
<Box bg=popup_box_bg padding=4 blur=true>
	<Canvas>
		<VerticalList child_padding=4>
			<Box bg=popup_additional_bg padding=6>
				<VerticalList child_padding=20>
					<Text text='Switch overlay mode in-game by pressing <Key action="MapOverlay" style="Header"/>' textalign=center/>
					<HorizontalList id=tabbuttons child_fill=true child_padding=4/>
				</VerticalList>
			</Box>
			<Box bg=popup_pattern padding=5>
				<HorizontalList child_padding=8>
					<VerticalList>
						<Box bg=popup_box_bg padding=0>
							<CheckBox group_key=disable_connections group_box=box_connections on_change={on_click_group} text="Connections" margin=5 halign=center/>
						</Box>
						<Box id=box_connections bg=popup_box_bg padding=10 y=-1>
							<VerticalList child_padding=4 width=230>
								<HorizontalList child_padding=11 halign=right margin_top=-5>
									<Image image=icon_remote color=ui_light width=32 height=32 tooltip="Show for all units and buildings on screen"/>
									<Image image=icon_map color=ui_light width=32 height=32 tooltip="Show only for selected units and buildings"/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Stores" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=stores width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=stores width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Gotos" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=gotos width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=gotos width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Transport Routes" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=transport_routes width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=transport_routes width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Power Transmitters" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=power_transmitters width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=power_transmitters width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Teleporters" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=portals width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=portals width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Orders" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=orders width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=orders width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Path Lines" fill=true on_click={on_click_itemtext}/>
									<Button tbl=global key=paths width=32 height=32 on_click={on_click_groupitem}/>
									<Button tbl=selected key=paths width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
							</VerticalList>
						</Box>

						<Box bg=popup_box_bg padding=0 margin_top=6>
							<CheckBox group_key=disable_bars group_box=box_bars on_change={on_click_group} text="Health Bars" margin=5 halign=center/>
						</Box>
						<Box id=box_bars bg=popup_box_bg padding=10 y=-1>
							<VerticalList child_padding=4 width=230>
								<HorizontalList child_padding=10 child_align=center>
									<Image width=16 height=16 color=#000000/>
									<Text text="Owned" fill=true on_click={on_click_itemtext}/>
									<Button tbl=bars key=faction width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Image width=16 height=16 color=#78181A/>
									<Text text="Enemy" fill=true on_click={on_click_itemtext}/>
									<Button tbl=bars key=enemy width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Image width=16 height=16 color=#187869/>
									<Text text="Ally" fill=true on_click={on_click_itemtext}/>
									<Button tbl=bars key=ally width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Image width=16 height=16 color=#785318/>
									<Text text="Neutral" fill=true on_click={on_click_itemtext}/>
									<Button tbl=bars key=neutral width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Image width=16 height=16 color=#6E1878/>
									<Text text="Environment" fill=true on_click={on_click_itemtext}/>
									<Button tbl=bars key=world width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
							</VerticalList>
						</Box>
						<Box bg=popup_box_bg padding=0 y=-2>
							<VerticalList>
								<CheckBox solo_key=damage on_change={on_click_solo} text="Show Damage Numbers" tooltip="Show damage numbers for attacks" margin=5 halign=left/>
							</VerticalList>
						</Box>
						<Box bg=popup_box_bg padding=8 margin_top=5>
							<VerticalList child_padding=4>
								<CheckBox solo_key=hover_only_icons on_change={on_click_solo} text="Limit Icons to Hovered" tooltip="Show enabled icons only for the unit or building hovered over with the mouse" halign=left/>
								<CheckBox solo_key=power on_change={on_click_solo} text="Show Logistics Network" halign=left/>
								<CheckBox solo_key=grid on_change={on_click_solo} text="Show Grid Cursor" halign=left/>
							</VerticalList>
						</Box>
						<Button text="Reset Mode Settings" fill=true margin_top=7 on_click={on_click_reset}/>
					</VerticalList>
					<VerticalList>
						<Box bg=popup_box_bg padding=0>
							<CheckBox solo_key=visual_register on_change={on_click_solo} text="Visual Register Icon" margin=5 halign=center/>
						</Box>

						<Box bg=popup_box_bg padding=0 margin_top=9>
							<CheckBox group_key=disable_icons group_box=box_icons on_change={on_click_group} text="State Icons" margin=5 halign=center/>
						</Box>
						<Box id=box_icons bg=popup_box_bg padding=8 y=-1>
							<VerticalList child_padding=5 width=230/>
						</Box>

						<Box bg=popup_box_bg padding=0 margin_top=8>
							<CheckBox group_key=disable_ranges group_box=box_ranges on_change={on_click_group} text="Range Indicators" tooltip="Only for the currently selected unit or building" margin=5 halign=center/>
						</Box>
						<Box id=box_ranges bg=popup_box_bg padding=8 y=-1>
							<VerticalList child_padding=6 width=230>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Visibility Range" fill=true on_click={on_click_itemtext}/>
									<Button tbl=ranges key=visibility width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
								<HorizontalList child_padding=10 child_align=center>
									<Text text="Power Range" fill=true on_click={on_click_itemtext}/>
									<Button tbl=ranges key=power width=32 height=32 on_click={on_click_groupitem}/>
								</HorizontalList>
							</VerticalList>
						</Box>
					</VerticalList>
				</HorizontalList>
			</Box>
		</VerticalList>
		<Image dock=right image=popup_pointer id=triangle x=20 y=-495 sx=-1 valign=bottom/>
	</Canvas>
</Box>
]]

local OverlayIcon_layout = [[
	<HorizontalList child_padding=10 child_align=center height=32>
		<Image image={icon} width=32 height=32/>
		<Text text={name} fill=true wrap=true/>
		<Button id=btn tbl=icons key={key} width=32 height=32 on_click={on_click}/>
	</HorizontalList>
]]

local OverlayOptions_open
local OverlayOptions<const> = {}

function OverlayOptions:on_popup_shift(shift_x, shift_y)
	self.triangle.y = self.triangle.y - shift_y
end

function OverlayOptions:construct()
	Quickview_SetOverlayOptionsButton(true)
	OverlayOptions_open = self

	for i,v in ipairs(overlay_mode_names) do
		self.tabbuttons:Add("<Button on_click={on_click_modetab}/>").text = v
	end

	local icon_list = self.box_icons[1]
	for i,v in ipairs(data.state_order) do
		icon_list:Add(OverlayIcon_layout, { key = v, icon = data.state_icons[v], name = data.state_names[v], tooltip = data.state_descriptions[v], on_click = function(row) self:on_click_groupitem(row.btn) end })
	end

	self:refresh()

	--[[DEBUG VIEW
	self[1]:Add("<Box width=300 x=-320 height=900><ScrollList><Text text={txt}/></ScrollList></Box>", { every_frame_update = function(w) w.txt = tostring(Game.GetProfile().overlay_settings) end })
	--]]
end

function OverlayOptions:destruct()
	Quickview_SetOverlayOptionsButton(false)
	OverlayOptions_open = nil
end

function OverlayOptions:refresh()
	local os = Game.GetProfile().overlay_settings
	local mode = (type(os) == "table" and os.mode or 2)
	local modetbl = type(os) == "table" and os[mode] or GetOverlayDefaults(mode)

	for _,w in ipairs(self.tabbuttons) do w.active = (w.child_index == mode) end

	local function check_widgets(w)
		if w.tbl and w.key then
			w.check = modetbl[w.tbl] and modetbl[w.tbl][w.key]
			w.icon = w.check and "icon_small_confirm" or "icon_small_empty"
		elseif w.group_box and w.group_key then
			w.check = not modetbl[w.group_key]
			self[w.group_box].disabled = modetbl[w.group_key]
		elseif w.solo_key then
			w.check = modetbl[w.solo_key]
		else
			for _,v in ipairs(w) do check_widgets(v) end
		end
	end
	check_widgets(self)
end

function OverlayOptions:on_click_modetab(btn)
	ApplyOverlayOptions(nil, btn.child_index)
	self:refresh()
end

function OverlayOptions:on_click_reset()
	ApplyOverlayOptions(nil, nil, true)
	self:refresh()
end

function OverlayOptions:on_click_solo(cb, value)
	ApplyOverlayOptions(function (modetbl) modetbl[cb.solo_key] = value or nil end)
end

function OverlayOptions:on_click_group(cb, value)
	self[cb.group_box].disabled = not value
	ApplyOverlayOptions(function (modetbl) modetbl[cb.group_key] = not value or nil end)
end

function OverlayOptions:on_click_groupitem(btn)
	btn.check = not btn.check
	btn.icon = btn.check and "icon_small_confirm" or "icon_small_empty"
	ApplyOverlayOptions(function (modetbl)
		local tbl, key, val = btn.tbl, btn.key, btn.check or nil
		if not modetbl[tbl] then modetbl[tbl] = {} end
		modetbl[tbl][key] = val
		if not val then modetbl[tbl] = EmptyTableAsNil(modetbl[tbl]) end
	end)
end

function OverlayOptions:on_click_itemtext(txt)
	self:on_click_groupitem(txt.next_sibling)
end

function OpenOverlayOptions(btn)
	UI.MenuPopup(OverlayOptions_layout, OverlayOptions, btn, "LEFT", "BOTTOM", -10, 500)
end

function Quickview_ToggleMovePaths()
	UI.PlaySound("fx_ui_GRID_SELECT")
	ApplyOverlayOptions(function (modetbl)
		if not modetbl.global then modetbl.global = {} end
		local val = not modetbl.global.paths or nil
		modetbl.global.paths = val
		if not val then modetbl.global = EmptyTableAsNil(modetbl.global) end
		if val then modetbl.disable_connections = nil end
	end)
	if OverlayOptions_open then OverlayOptions_open:refresh() end
end

function Quickview_ToggleMapOverlay()
	UI.PlaySound("fx_ui_GRID_SELECT")
	local os = Game.GetProfile().overlay_settings
	local mode = 1 + (((type(os) == "table" and os.mode or 2) + (Input.IsShiftDown() and #overlay_mode_names - 2 or 0)) % #overlay_mode_names)
	Notification.Info(L("Overlay display changed to '%s'", overlay_mode_names[mode]))
	ApplyOverlayOptions(nil, mode)
	if OverlayOptions_open then OverlayOptions_open:refresh() end
end

function Quickview_SetMapOverlayActive(state, force_state)
	if state then
		ApplyOverlayOptions() -- reset
	else
		if not force_state then force_state = {} end
		View.SetVisualizations(force_state)
		UI.Run("OnOverlayChanged", force_state)
	end
end

function Quickview_TogglePower()
	UI.PlaySound("fx_ui_GRID_SELECT")
	ApplyOverlayOptions(function (modetbl)
		modetbl.power = not modetbl.power or nil
	end)
	if OverlayOptions_open then OverlayOptions_open:refresh() end
end

function Quickview_ShowPower()
	temp_powerdisplay = (temp_powerdisplay or 0) + 1
	ApplyOverlayOptions()
end

function Quickview_HidePower()
	temp_powerdisplay = temp_powerdisplay and (temp_powerdisplay > 1) and (temp_powerdisplay - 1) or nil
	ApplyOverlayOptions()
end

function Quickview_ToggleGrid()
	UI.PlaySound("fx_ui_GRID_SELECT")
	if temp_gridrange then
		temp_griddisplay = not temp_griddisplay and 1 or nil -- toggle temp display
		ApplyOverlayOptions()
	else
		ApplyOverlayOptions(function (modetbl)
			modetbl.grid = not modetbl.grid or nil
		end)
		if OverlayOptions_open then OverlayOptions_open:refresh() end
	end
end

function Quickview_ShowGrid(range, size_x, size_y)
	temp_griddisplay = (temp_griddisplay or 0) + 1
	temp_gridrange = range or temp_gridrange or 4
	ApplyOverlayOptions()
	View.SetPostProcess("HoverSizeX", size_x or 1)
	View.SetPostProcess("HoverSizeY", size_y or 1)
end

function Quickview_HideGrid()
	temp_griddisplay = temp_griddisplay and (temp_griddisplay > 1) and (temp_griddisplay - 1) or nil
	if not temp_griddisplay then temp_gridrange = nil end
	ApplyOverlayOptions()
	View.SetPostProcess("HoverSizeX", 1)
	View.SetPostProcess("HoverSizeY", 1)
end
