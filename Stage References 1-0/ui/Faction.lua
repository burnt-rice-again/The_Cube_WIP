local Faction_layout<const> =
[[
	<VerticalList child_padding=4>
		<Box bg=popup_pattern padding=4 id=window width=744 height=900/>
		<Box bg=popup_additional_bg padding=6>
			<HorizontalList child_padding=4>
				<HorizontalList id=tabbuttons fill=true child_fill=true child_padding=4>
					<Button text="Power"      on_click={switch_tab} tab=power/>
					<Button text="Base"       on_click={switch_tab} tab=base/>
					<Button text="Items"      on_click={switch_tab} tab=items/>
					<Button text="Orders"     on_click={switch_tab} tab=orders/>
					<Button text="Faction"    on_click={switch_tab} tab=faction/>
				</HorizontalList>
				<Button id=pinbtn icon=icon_pin height=32 width=32 on_click={pin}/>
			</HorizontalList>
		</Box>
	</VerticalList>
]]
local Faction = {}
local npts<const> = 150 -- number of points on graph
UI.Register("Faction", Faction_layout, Faction)

function FactionAction.CancelOrder(faction, arg)
	faction:CancelOrder(arg.id)
end

function FactionAction.SetFactionName(faction, arg)
	if not arg.name or string.len(arg.name) < 3 or string.len(arg.name) > 64 then return end
	faction.name = arg.name
end

function FactionAction.SetFactionColor(faction, arg)
	faction.color = arg.color
end

function FactionAction.SetFactionLock(faction, arg)
	faction.extra_data.locked = not not arg.lock
end

function FactionAction.SetFactionReplaceBuildings(faction, arg)
	if arg.val ~= nil and arg.val ~= 0 and arg.val ~= 2 then return end
	faction.extra_data.replace_buildings = arg.val
end

function FactionAction.SetFactionTrust(faction, arg)
	faction:SetTrust(arg.faction_id, arg.trust)
end

function FactionAction.FactionRegister(faction, arg)
	local radio_storage = faction.extra_data.radio_storage
	if not radio_storage then
		radio_storage = Map.CreateEntity(faction, "f_empty"):AddComponent("c_radio_storage", "hidden")
		radio_storage.extra_data = { bands = {}, conns = {} }
		faction.extra_data.radio_storage = radio_storage
	end
	local radio_storage_ed = radio_storage.extra_data
	local bands, conns, names = radio_storage_ed.bands, radio_storage_ed.conns, radio_storage_ed.names
	if arg.set_value and names and names[arg.set_value] then
		if not radio_storage:RegisterIsLink(names[arg.set_band]) then -- can't overwrite value if linked from a Radio Transmitter component
			radio_storage:SetRegister(names[arg.set_value], arg.value)
		end
	elseif arg.set_band and names and names[arg.set_band] and type(arg.band) == "table" and next(arg.band) then
		local old_idx, new_band, new_idx = names[arg.set_band], Tool.NewRegisterObject(arg.band)
		local value, free_idx = radio_storage:GetRegister(old_idx), conns[old_idx] == 1 and old_idx
		for i=1,#bands do
			if new_band == bands[i] then new_idx = i break end
			if not conns[i] and not free_idx then free_idx = i end
		end
		if not new_idx then
			new_idx = free_idx or (#bands + 1)
			if not free_idx then radio_storage.register_count = new_idx end
		end
		names[arg.set_band] = new_idx
		bands[new_idx] = new_band
		if old_idx ~= new_idx then
			conns[old_idx] = (conns[old_idx] > 1 and (conns[old_idx] - 1) or nil)
			conns[new_idx] = (conns[new_idx] or 0) + 1
			if not radio_storage:RegisterIsLink(old_idx) then radio_storage:SetRegister(old_idx, nil) end
			if not radio_storage:RegisterIsLink(new_idx) then radio_storage:SetRegister(new_idx, value) end
		end
	elseif arg.set_name and names and names[arg.set_name] and arg.set_name ~= arg.name then
		for n=1,999999 do
			local new_name = n > 1 and string.format("%s (%d)", arg.name, n) or arg.name
			if not names[new_name] then
				names[new_name], names[arg.set_name] = names[arg.set_name], nil
				break
			end
		end
	elseif arg.remove and names and names[arg.remove] then
		local idx = names[arg.remove]
		conns[idx] = (conns[idx] > 1 and (conns[idx] - 1) or nil)
		names[arg.remove] = nil
		if not radio_storage:RegisterIsLink(idx) then radio_storage:SetRegister(idx, nil) end
	elseif arg.create then
		local create_name = arg.name or ""
		if not names then names = {} radio_storage_ed.names = names end
		for n=1,999999 do
			local new_name, band_num, free_idx = (n > 1 and string.format("%s (%d)", create_name, n) or create_name), 0
			if not names[new_name] then
				for i=1,#bands do
					if bands[i].id == 'v_letter_R' and conns[i] then band_num = math.max(band_num, bands[i].num) end
					if not conns[i] and not free_idx then free_idx = i end
				end
				local idx = free_idx or (#bands + 1)
				if not free_idx then radio_storage.register_count = idx end
				names[new_name] = idx
				bands[idx] = Tool.NewRegisterObject({ id = 'v_letter_R', num = band_num + 1 })
				conns[idx] = 1
				break
			end
		end
	else error("Unknown call to FactionAction.FactionRegister") end
end

local function GetAllianceFactions(faction)
	local result = {}
	for _,f in ipairs(Map.GetPlayerFactions()) do
		if faction ~= f and faction:IsSharingVisibilityWith(f) then
			result[#result+1] = f
		end
	end
	return result
end

function FactionAction.JoinAlliance(invited_faction, arg)
	local inviting_faction_id = arg.faction_id
	local inviting_faction = Map.GetFaction(inviting_faction_id)
	if invited_faction == inviting_faction or invited_faction:IsSharingVisibilityWith(inviting_faction) then return end

	-- Check if the invite exists
	local invites, have_invite = invited_faction.extra_data.alliance_invites
	if not invites then return end
	for i,id in ipairs(invites) do
		if id == inviting_faction_id then
			have_invite = true
			break
		end
	end
	if not have_invite then return end

	-- Set everyone already in the alliance to trust level ally towards the newly joining member
	local alliance = GetAllianceFactions(inviting_faction)
	alliance[#alliance+1] = inviting_faction
	for _,f in ipairs(alliance) do
		f:SetTrust(invited_faction, 'ALLY', true)
	end

	-- Share visibility between the inviting faction (and everyone already in the alliance) with the newly joining member
	invited_faction:ShareVisibility(inviting_faction)

	-- Remove all invites of factions now sharing visibility
	for i=#invites,1,-1 do
		if invited_faction:IsSharingVisibilityWith(invites[i]) then
			table.remove(invites, i)
		end
	end
	if #invites == 0 then invited_faction.extra_data.alliance_invites = nil end

	-- Show the alliance changed notification to everyone in the alliance including the newly joined member
	alliance[#alliance+1] = invited_faction
	for _,f in ipairs(alliance) do
		f:RunUI(function()
			Notification.Add("alliance_changed", "warning", "Alliance Changed", L("%S has joined the alliance", invited_faction.name), {
				on_click = function(id)
					OpenMainWindow("Faction", { show_tab = 'faction' })
					return true
				end
			})
		end)
	end
end

function FactionAction.LeaveAlliance(faction)
	local alliance_factions = GetAllianceFactions(faction)
	for _,other_faction in ipairs(alliance_factions) do
		other_faction:RunUI(function()
			Notification.Add("alliance_changed", "warning", "Alliance Changed", L("%S has left the alliance", faction.name), {
				on_click = function(id)
					OpenMainWindow("Faction", { show_tab = 'faction' })
					return true
				end
			})
		end)
	end
	faction:UnshareVisibility()
end

function FactionAction.InviteToAlliance(inviting_faction, arg)
	local invited_faction = Map.GetFaction(arg.faction_id)

	-- Abort if the invited faction already is in an alliance (maybe with the inviting faction, maybe with others)
	if #GetAllianceFactions(invited_faction) > 0 then return end

	-- Add a invitate entry (or do nothing if it already exists)
	local inviting_faction_id = inviting_faction.id
	local invites = invited_faction.extra_data.alliance_invites
	if not invites then invites = {} invited_faction.extra_data.alliance_invites = invites end
	for i,invite in ipairs(invites) do
		if invite == inviting_faction_id then goto invite_exists end
	end
	invites[#invites+1] = inviting_faction_id
	::invite_exists::

	Action.RunUI(function()
		MessagePopup(nil, L("Alliance invitation sent to faction %S", invited_faction.name), "Invitation Sent")
	end)

	invited_faction:RunUI(function()
		Notification.Add("alliance_invite", "warning", "Alliance Invite", L("%S sent you an alliance invitation", inviting_faction.name), {
			on_click = function(id)
				ConfirmBox(L("Are you sure you want to join an alliance with %S?", inviting_faction.name), function()
					for i,invite in ipairs(Game.GetLocalPlayerFaction().extra_data.alliance_invites or {}) do -- make sure the invite still exists
						if invite == inviting_faction.id then
							Action.SendForLocalFaction("JoinAlliance", { faction_id = inviting_faction.id })
							OpenMainWindow("Faction", { show_tab = 'faction' })
							return
						end
					end
					Notification.Error("Invitation no longer exists")
				end)
				return true
			end,
		})
	end)
end

function Faction:construct()
	self.faction = Game.GetLocalPlayerFaction()
	if self.show_item_id then
		self:switch_tab('items')
		self.window[1]:show_item(self.show_item_id)
	elseif self.show_frame_id then
		self:switch_tab("base")
		self.window[1]:show_frame(self.show_frame_id)
	elseif self.show_entity_orders then
		self:switch_tab("orders")
	elseif self.show_tab then
		self:switch_tab(self.show_tab)
	elseif Faction.last_tab then
		self:switch_tab(self.tabbuttons[Faction.last_tab])
	else
		self:switch_tab("power")
	end
end

function Faction:pin(btn)
	TogglePinMainWindow(self, "Faction")
end

function Faction:switch_tab(btn_or_tab)
	for _,v in ipairs(self.tabbuttons) do
		if v.tab == btn_or_tab then btn_or_tab = v end
		v.active, v.disabled = (v == btn_or_tab), (v == btn_or_tab)
	end
	self["activate_tab_" .. btn_or_tab.tab](self)
	Faction.last_tab = btn_or_tab.child_index
end

local Faction_filter_power
function Faction_PowerGridFilterIndex()
	if not Faction_filter_power then return false end
	local entity, local_player_faction = View.GetSelectedEntity() or View.GetHoveredEntity(), Game.GetLocalPlayerFaction()
	if (entity and entity.faction) == local_player_faction then
		return entity.power_grid_index
	end
	local x, y = View.GetHoveredTilePosition()
	return local_player_faction:GetPowerGridIndexAt(x, y)
end

local sorts = {
	{ "None", function (a, b) return (a.def.id > b.def.id) end },
	{ "Descending", function (a, b) if (a.prog == b.prog) then return (a.def.id > b.def.id) end return (a.prog > b.prog) end },
	{ "Ascending", function (a, b) if (a.prog == b.prog) then return (a.def.id > b.def.id) end return (a.prog < b.prog) end },
}
function Faction:activate_tab_power()
	self.window:SetContent([[
		<VerticalList>
			<HorizontalList height=45 child_align=center>
				<Text text="Filter:" margin_right=8/>
				<Button id=sortbtn icon=icon_small_sort margin=6 width=32 height=32 on_click={on_change_sort}/>
				<Button id=showzerobtn icon=icon_small_view_icon margin=6 width=32 height=32 on_click={on_change_show_zero_producing}/>
			</HorizontalList>
			<Box>
				<HorizontalList fill=true>
					<VerticalList margin_left=6 margin_top=6 margin_bottom=6 margin_right=6 fill=true>
						<HorizontalList halign=left>
							<Image image=icon_small_battery color=ui_light margin_right=10/>
							<Text dock=center id=battery/>
						</HorizontalList>
						<Progress id=stored color=ui_light height=16 tooltip="Total Battery Power"/>
					</VerticalList>
					<VerticalList margin_top=6 margin_right=6 margin_bottom=6 margin_left=6 fill=true>
						<HorizontalList halign=left>
							<Image image=icon_small_energy color=ui_light margin_right=10/>
							<Text dock=center id=energy/>
						</HorizontalList>
						<Progress id=consumed color={color} height=16 tooltip="Total Energy Used"/>
					</VerticalList>
				</HorizontalList>
			</Box>
			<ScrollList fill=true>
				<HorizontalList fill=true>
					<VerticalList fill=true margin_right=6>
						<Text text="<bl>Producing</>" height=26 margin_top=6/>
						<VerticalList child_padding=5 id=listprod/>
						<Text text="<bl>Batteries</>" margin_top=10 margin_bottom=6/>
						<VerticalList child_padding=5 id=listbatt/>
						<Text text="<bl>Shields</>" margin_top=10 margin_bottom=6/>
						<VerticalList child_padding=5 id=listshld/>
						<Text text="<bl>Transmitters</>" margin_top=10 margin_bottom=6/>
						<VerticalList child_padding=5 id=listtran/>
					</VerticalList>
					<VerticalList fill=true margin_left=6>
						<HorizontalList fill=true><Text text="<bl>Consuming</>" height=26 margin_top=6/></HorizontalList>
						<VerticalList child_padding=5 id=listcons/>
					</VerticalList>
				</HorizontalList>
			</ScrollList>
			<VerticalList id=graphbox>
				<Text id=info_graph textalign=right margin=4/>
				<Canvas height=200>
					<Image color="#00B3" fill=true/>
					<Draw id=graph_draw fill=true/>
					<Button x=4 y=4  id=graph_zoom_in  icon=icon_small_zoom_in  on_click={on_graph_zoom} zoom=-1 tooltip="Zoom In"/>
					<Button x=4 y=40 id=graph_zoom_out icon=icon_small_zoom_out on_click={on_graph_zoom} zoom=1  tooltip="Zoom Out"/>
					<Text x=4 y=78 id=zoomlvl text="1h"/>
					<Text x=50 y=2 id=graph_max/>
					<Text x=50 y=180 text="0"/>
				</Canvas>
			</VerticalList>
			<HorizontalList height=32 child_padding=5 child_align=center>
				<Button id=filter on_click={on_click_filter} width=24 height=24/>
				<Text valign=center text="Show local power grid of selection" on_click={on_click_filter}/>
			</HorizontalList>
		</VerticalList>
	]], {
		construct = function(view)
			view.graph =
			{
				field_in = "total_produced",
				field_out = "total_consumed",
				color_in = "#7CFF7C",
				color_out = "#FFCC7C",
				graph_draw = view.graph_draw,
				graph_max = view.graph_max,
				scale = TICKS_PER_SECOND,
			}
			self:graph_init(view.graph)
			-- start with descending
			view.sortid = 1
			view.sortbtn.tooltip = "Order : " .. sorts[view.sortid+1][1]

			view.show_zero_producing = false
			view.showzerobtn.tooltip = "Hide Zero Producing Components"

			view.info_graph.text = L('<img id="v_color_green"/> %s / <img id="v_color_yellow"/> %s', "Produced", "Required")
			view.lastfilter = true -- force refresh
		end,

		on_change_sort = function(view, btn)
			view.sortid = ((view.sortid + 1) % #sorts)
			view.sortbtn.tooltip = "Order : " .. sorts[view.sortid+1][1]
		end,

		on_change_show_zero_producing = function(view, btn)
			view.show_zero_producing = not view.show_zero_producing
			if view.show_zero_producing then view.showzerobtn.tooltip = "Show Zero Producing Components"
			else view.showzerobtn.tooltip = "Hide Zero Producing Components" end
		end,

		on_click_filter = function(view)
			Faction_filter_power = not Faction_filter_power
			view.lastfilter = true -- force refresh
			view:update()
		end,

		update = function(view)
			local filter_grid_index = Faction_PowerGridFilterIndex()
			if view.lastfilter ~= filter_grid_index or view.lastshow_zero_producing ~= view.show_zero_producing then
				view.lastfilter = filter_grid_index
				view.lastshow_zero_producing = view.show_zero_producing
				view.filter.text = Faction_filter_power and "X" or ""
				view.graphbox.hidden = Faction_filter_power
				view.listprod:Clear()
				view.listcons:Clear()
				view.listbatt:Clear()
				view.listshld:Clear()
				view.listtran:Clear()
				view.prodwidgets, view.conswidgets, view.battwidgets, view.shldwidgets, view.tranwidgets = {}, {}, {}, {}, {}
			end

			local total_stored, total_capacity = 0, 0
			local prod, prodnum, cons, consnum, batt, battnum, shld, shldnum, tran, trannum = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
			for _,e in ipairs(self.faction.entities) do
				local efficiency = e.efficiency
				if efficiency and efficiency > 0 and not e.powered_down and (not Faction_filter_power or e.power_grid_index == filter_grid_index) then
					local epower, frame_id, lastcons = e.def.power, e.id, 0
					if epower then
						if epower > 0 then
							prod[frame_id] = (prod[frame_id] or 0) + epower
							prodnum[frame_id] = (prodnum[frame_id] or 0) + 1
						elseif epower < 0 then
							lastcons = -epower * efficiency + (lastcons % 100)
							cons[frame_id] = (cons[frame_id] or 0) + (lastcons // 100)
							consnum[frame_id] = (consnum[frame_id] or 0) + 1
						end
					end
					for _,c in ipairs(e.components) do
						local cdetails = c.power_details
						if cdetails then
							if c.def.power_storage then
								total_stored = total_stored + cdetails.stored
								total_capacity = total_capacity + c.def.power_storage
							end
							local cpower, comp_id = cdetails.power, c.id
							if (view.show_zero_producing and cpower >= 0) or (not view.show_zero_producing and cpower > 0) then
								prod[comp_id] = (prod[comp_id] or 0) + cpower
								prodnum[comp_id] = (prodnum[comp_id] or 0) + 1
							end
							if cpower < 0 and cdetails.is_active then
								lastcons = -cpower * efficiency + (lastcons % 100)
								cons[comp_id] = (cons[comp_id] or 0) + (lastcons // 100)
								consnum[comp_id] = (consnum[comp_id] or 0) + 1
							end
							if cdetails.change ~= 0 then
								if (c.def.drain_rate or 0) > 0 then
									batt[comp_id] = (batt[comp_id] or 0) + cdetails.change
									battnum[comp_id] = (battnum[comp_id] or 0) + 1
								else
									shld[comp_id] = (shld[comp_id] or 0) + cdetails.change
									shldnum[comp_id] = (shldnum[comp_id] or 0) + 1
								end
							end
							if filter_grid_index and cdetails.transmitted ~= 0 then
								tran[comp_id] = (tran[comp_id] or 0) + cdetails.transmitted
								trannum[comp_id] = (trannum[comp_id] or 0) + 1
							end
						end
					end
				end
			end

			if filter_grid_index then
				local griddetails = self.faction:GetPowerGrid(filter_grid_index)
				local gridreceived = griddetails and griddetails.received
				if gridreceived and gridreceived > 0 then
					prod[true] = (prod[true] or 0) + gridreceived
				end
			end

			local total_produced, total_consumed, total_battery, total_shield, total_transmit = 0, 0, 0, 0, 0
			for k,v in pairs(prod) do total_produced = total_produced + v end
			for k,v in pairs(cons) do total_consumed = total_consumed + v end
			for k,v in pairs(batt) do total_battery = total_battery + v end
			for k,v in pairs(shld) do total_shield = total_shield + v end
			for k,v in pairs(tran) do total_transmit = total_transmit + v end

			local filllists = {
				{ view.listprod,view.prodwidgets,prod,prodnum,total_produced,"+" },
				{ view.listcons,view.conswidgets,cons,consnum,total_consumed,"-" },
				{ view.listbatt,view.battwidgets,batt,battnum,total_battery, ""  },
				{ view.listshld,view.shldwidgets,shld,shldnum,total_shield, ""  },
				{ view.listtran,view.tranwidgets,tran,trannum,total_transmit,"-" },
			}
			for _,ll in ipairs(filllists) do
				local list, widgets, vals, nums, total, sign = ll[1], ll[2], ll[3], ll[4], ll[5], ll[6]

				for k,v in pairs(widgets) do
					local val = vals[k]
					if val then
						v.num, v.value, v.prog = nums[k], sign .. (val * TICKS_PER_SECOND), val / total
						vals[k] = nil
					else
						v.num, v.value, v.prog = 0, sign .. 0, 0
					end
				end
				for k,v in pairs(vals) do
					local def = data.all[k]
					widgets[k] = list:Add([[
						<Box>
							<HorizontalList child_padding=6 child_align=center>
								<Reg def={def} num={num} on_click=false/>
								<VerticalList child_padding=6>
									<HorizontalList><Text text={name} fill=true/><Text text={value}/></HorizontalList>
									<Progress width=290 height=16 progress={prog}/>
								</VerticalList>
							</HorizontalList>
						</Box>]],
						{
							def = def or data.values.v_power_production, name = (def and def.name or "Receiving"), num = nums[k],
							value = sign .. (v * TICKS_PER_SECOND), prog = v / total,
							on_click = def and function(w)
								if data.frames[w.def.id] then
									self:switch_tab("base")
									self.window[1]:show_frame(w.def.id)
								else
									self:switch_tab('items')
									self.window[1]:show_item(w.def.id)
								end
							end,
						})
				end
				list:SortChildren(sorts[view.sortid+1][2])
			end

			view.listbatt.previous_sibling.hidden = #view.listbatt == 0
			view.listshld.previous_sibling.hidden = #view.listshld == 0
			view.listtran.previous_sibling.hidden = #view.listtran == 0

			view.battery.text = L("%d / %d", total_stored, total_capacity)
			view.energy.text = L("%d / %d", total_consumed * TICKS_PER_SECOND, total_produced * TICKS_PER_SECOND)
			view.stored.progress = (total_capacity > 0 and total_stored / total_capacity or 0)
			view.consumed.progress = (total_produced > 0 and total_consumed / total_produced or 0)
			if view.consumed.progress > 0.60 and view.consumed.progress < 0.99 then
				view.consumed.color = "#F6E268"
			elseif view.consumed.progress > 1 or view.consumed.progress == "Infinity" then
				view.consumed.color = "#FF957C"
			else
				view.consumed.color = "#67dcf8"
			end
		end,

		on_graph_zoom = function(view, btn)
			view.graph.res = (view.graph.res or 2) + btn.zoom
			view.graph_zoom_in.disabled = view.graph.res == 1
			view.graph_zoom_out.disabled = view.graph.res == 3
			local restxt =  { "30s", "1h", "10h" }
			view.zoomlvl.text = restxt[view.graph.res]
		end,
	})
end

local base_last_string_filter, base_last_entity_filters, base_last_visual_filter, base_hide_buildings, base_hide_units, base_hide_satellites
local function base_regsel_entityfilter(def) return def and (def.data_name == 'frames' or def.tag == 'entityfilter' or def.data_name == 'components') and def ~= data.values.v_setnum end
local function base_regsel_visualfilter(def, cat) return not (cat.entity_panel or cat.number_panel or cat.coord_panel) end

function Faction:activate_tab_base()
	self.window:SetContent([[
		<VerticalList child_padding=10>
			<Box padding=2>
				<HorizontalList child_align=center margin_top=6 margin_left=6 margin_bottom=6>
					<TextSearch id=search on_refresh={on_search_change} fill=7/>
					<Text id=totaltxt style=header textalign=right fill=4 margin_right=10/>
					<Button icon=icon_small_cursor_area on_click={select_all} width=28 height=28 tooltip="Select"/>
				</HorizontalList>
			</Box>
			<Box on_click={collapsefilter} arrow=filters_icon list=filterlist>
				<HorizontalList height=34 child_align=center child_padding=10>
					<Image id=filters_icon color=ui_light image=icon_small_arrow_down/>
					<Text text="Filters" style=header/>
				</HorizontalList>
			</Box>
			<HorizontalList id=filterlist child_align=center child_padding=4>
				<Reg filtertype=e on_click={reg_on_click} clearreg=true/>
				<Reg filtertype=e on_click={reg_on_click} clearreg=true/>
				<Reg filtertype=e on_click={reg_on_click} clearreg=true/>
				<Text textalign=right style=hl margin_right=10 text="Visual" fill=true/>
				<Reg filtertype=v on_click={reg_on_click} clearreg=true/>
				<Spacer fill=true/>
				<Button icon=icon_deny on_click={clear_filters} tooltip="Clear Filters"/>
			</HorizontalList>
			<ScrollList fill=true child_padding=10 margin_left=8>
				<VerticalList child_padding=4 id=buildingsrow>
					<Box on_click={collapselist} arrow=buildings_icon list=buildinglist padding=2>
						<HorizontalList child_align=center child_padding=10>
							<Image id=buildings_icon color=ui_light image=icon_small_arrow_down/>
							<Text id=totalbuildingtxt style=header fill=true/>
							<Button icon=icon_small_cursor_area on_click={select_all} list=buildinglist width=28 height=28 tooltip="Select All Buildings"/>
						</HorizontalList>
					</Box>
					<Wrap child_padding=4 id=buildinglist/>
				</VerticalList>
				<VerticalList child_padding=4>
					<Box on_click={collapselist} arrow=units_icon list=unitlist padding=2>
						<HorizontalList child_align=center child_padding=10>
							<Image id=units_icon color=ui_light image=icon_small_arrow_down/>
							<Text id=totalunittxt style=header fill=true/>
							<Button icon=icon_small_cursor_area on_click={select_all} list=unitlist width=28 height=28 tooltip="Select"/>
						</HorizontalList>
					</Box>
					<Wrap child_padding=4 id=unitlist/>
				</VerticalList>
				<VerticalList child_padding=4>
					<Box on_click={collapselist} arrow=satellites_icon list=satellitelist padding=2>
						<HorizontalList child_align=center child_padding=10>
							<Image id=satellites_icon color=ui_light image=icon_small_arrow_down/>
							<Text id=totalsatellitetxt style=header fill=true/>
							<Button icon=icon_small_cursor_area on_click={select_all} list=satellitelist width=28 height=28 tooltip="Select"/>
						</HorizontalList>
					</Box>
					<Wrap child_padding=4 id=satellitelist/>
				</VerticalList>
			</ScrollList>
		</VerticalList>
	]], {
		construct = function(view)
			view.search:SetText(base_last_string_filter or "")
			if base_last_entity_filters or base_last_visual_filter then
				local efidx
				for _,w in ipairs(view.filterlist) do
					if w.filtertype == 'e' then
						efidx = (efidx or -1) + 2 -- store id and number pair
						w.def_id = base_last_entity_filters and base_last_entity_filters[efidx] or nil
						w.num = base_last_entity_filters and base_last_entity_filters[efidx+1] or nil
					elseif w.filtertype == 'v' then
						w.def_id = base_last_visual_filter
					end
				end
			else
				view:collapselist(view.filterlist.previous_sibling)
			end
			if base_hide_buildings  then view:collapselist(view.buildinglist.previous_sibling)  end
			if base_hide_units      then view:collapselist(view.unitlist.previous_sibling)      end
			if base_hide_satellites then view:collapselist(view.satellitelist.previous_sibling) end

			Game.GetLocalPlayerExtra().unit_filters = nil -- clear old field
		end,

		destruct = function(view)
			base_hide_buildings  = view.buildinglist.hidden
			base_hide_units      = view.unitlist.hidden
			base_hide_satellites = view.satellitelist.hidden
		end,

		reg_on_click = function(view, reg, key)
			if key == 'RIGHTMOUSEBUTTON' then
				reg.def_id, reg.num = nil, nil
				view:update(true)
				return
			end
			local function register_on_set(rsel, new_reg_val)
				reg.def_id, reg.num = new_reg_val.id, (new_reg_val.num ~= 0 and new_reg_val.num or nil)
				view:update(true)
			end
			local rsel = ShowRegisterSelection(reg, register_on_set, (reg.filtertype == 'e' and base_regsel_entityfilter or base_regsel_visualfilter), nil, { is_radar = reg.filtertype == 'e' } )
			if rsel then rsel:SetRegister({ id = reg.def_id, num = reg.num }) end
		end,

		clear_filters = function(view)
			for _,w in ipairs(view.filterlist) do
				if w.filtertype then w.def_id, w.num = nil, nil end
			end
			view:update(true)
		end,

		collapselist = function(view, box)
			local list, arrow = view[box.list], view[box.arrow]
			list.hidden = not list.hidden
			arrow.image = list.hidden and "icon_small_arrow_right" or "icon_small_arrow_down"
		end,

		collapsefilter = function(view, box)
			view:collapselist(box)
			view:update(true)
		end,

		on_search_change = function(view, search, txt)
			view:update(true)
		end,

		update = function(view, force_update)
			local faction = self.faction
			force_update = force_update or faction.num_entities ~= view.last_num_ents
			if not force_update then return end
			view.last_num_ents = faction.num_entities

			local buildinglist, unitlist, satellitelist = view.buildinglist, view.unitlist, view.satellitelist
			local total_entities, total_buildings, total_units, total_satellites = 0, 0, 0, 0
			local filters_enabled, entity_filters, prepared_filter, filter_range, visual_filter = not view.filterlist.hidden

			if filters_enabled then
				for _,w in ipairs(view.filterlist) do
					if w.filtertype == 'v' then
						visual_filter = w.def_id or nil
					elseif w.filtertype == 'e' and w.def_id then
						if not entity_filters then entity_filters = {} end
						entity_filters[#entity_filters+1] = w.def_id
						entity_filters[#entity_filters+1] = w.num or 0
					end
				end
				if entity_filters then prepared_filter, filter_range = PrepareFilterEntity(entity_filters) end
			end

			local string_filter = view.search.inp.text
			if string_filter == "" then string_filter = nil end
			local ContainsStringNoCase = string_filter and Tool.ContainsStringNoCase

			satellitelist:Clear()
			buildinglist:Clear()
			unitlist:Clear()

			local faction_home = filter_range and (faction.home_entity or faction.home_location)
			for _,v in ipairs(faction.entities) do
				local vdef, ignore = v.def
				if not vdef.type and (v.is_on_map or vdef.flags == "Space") then -- ignore walls, gates and non-space entities not on the map
					if filters_enabled then
						if entity_filters and (not v:MatchFilter(prepared_filter, faction) or not FilterEntity(v, v, entity_filters)) then
							ignore = true
						elseif visual_filter and v:GetRegisterId(FRAMEREG_VISUAL) ~= visual_filter then
							ignore = true
						elseif filter_range and faction_home and not v:IsInRangeOf(faction_home, filter_range) then
							ignore = true
						end
					end

					if not ignore and (not string_filter or ContainsStringNoCase(v.extra_data.name or L(v.visual_def.explorable_name or v.def.name or ""), string_filter)) then
						total_entities = total_entities + 1
						local is_space, no_movement, list = (vdef.flags == "Space"), ((vdef.movement_speed or 0) == 0)
						if     is_space    then list, total_satellites = satellitelist, total_satellites + 1
						elseif no_movement then list, total_buildings  = buildinglist,  total_buildings  + 1
						else                    list, total_units      = unitlist,      total_units      + 1 end
						local canvas = list:Add([[<Canvas width=56 height=56 on_click={ent_click} on_mouse_enter={ent_enter} on_mouse_leave={ent_leave} on_clipboard_copy={ent_copy} tooltip={ent_tooltip}><Image image=item_default dock=fill/><Image dock=fill image={img}/></Canvas>]], { entity = v, img = vdef.texture })
						local visual = not v:RegisterIsEmpty(FRAMEREG_VISUAL) and v:GetRegister(FRAMEREG_VISUAL)
						if visual then
							canvas:Add("<Reg bg=false no_interact=true dock=bottom-right width=40 height=40 update=false/>", { def_id = visual.id, coord = visual.coord, entity = visual.entity, num = (visual.num ~= 0 and visual.num or nil) })
						end
					end
				end
			end

			view.totaltxt.text          = L("Total: %d",            total_entities)
			view.totalbuildingtxt.text  = L("Total Buildings: %d",  total_buildings)
			view.totalunittxt.text      = L("Total Units: %d",      total_units)
			view.totalsatellitetxt.text = L("Total Satellites: %d", total_satellites)

			buildinglist.parent.hidden  = total_buildings  == 0
			unitlist.parent.hidden      = total_units       == 0
			satellitelist.parent.hidden = total_satellites == 0

			base_last_string_filter  = string_filter
			base_last_entity_filters = entity_filters
			base_last_visual_filter  = visual_filter
		end,

		ent_click = function(view, cnvs, mousebtn)
			SelectEntity(cnvs.entity, mousebtn)
		end,
		ent_enter = function(view, cnvs)
			View.HighlightEntity(cnvs.entity)
			cnvs.hl = true
		end,
		ent_leave = function(view, cnvs)
			if cnvs.hl then cnvs.hl = false View.HighlightEntity(nil) end
		end,
		ent_copy = function(view, cnvs)
			return UnitCopyPaste.ClipboardCopyReference(cnvs.entity)
		end,
		ent_tooltip = function(view, cnvs)
			local entity = cnvs.entity
			local def = entity.def
			if def then return BuildDefinitionTooltip(def, { clearreg = self.clearreg or nil, entity = entity }) end
		end,

		select_all = function(view, btn)
			local bl, res = btn.list, btn.list and (Input.IsShiftDown() or Input.IsControlDown()) and View.GetSelectedEntities() or {}
			local list1, list2, list3 = bl and view[bl] or view.buildinglist, not bl and view.unitlist, not bl and view.satellitelist
			if list1 then for _,v in ipairs(list1) do res[#res+1] = v.entity end end
			if list2 then for _,v in ipairs(list2) do res[#res+1] = v.entity end end
			if list3 then for _,v in ipairs(list3) do res[#res+1] = v.entity end end
			View.SelectEntities(res)
		end,

		show_frame = function(view, frame_id)
			view.search:SetText("")
			for _,w in ipairs(view.filterlist) do
				if w.filtertype then w.def_id, frame_id = frame_id, nil end
			end
			if view.filterlist.hidden then view:collapselist(view.filterlist.previous_sibling) end
		end,
	})
end

function Faction:activate_tab_items()
	self.window:SetContent([[
		<VerticalList>
			<VerticalList id=item_list child_padding=10 fill=true hidden=false>
				<Box padding=8>
					<TextSearch on_refresh={update}/>
				</Box>
				<ScrollList fill=true child_padding=5 id=list/>
			</VerticalList>
			<VerticalList id=item_details fill=true hidden=true>
				<HorizontalList>
					<Button icon=icon_back on_click={on_return} margin_right=6 valign=top tooltip="Back"/>
					<VerticalList fill=true>
						<HorizontalList margin_bottom=20>
							<Reg id=item_icon margin_right=6/>
							<VerticalList margin_top=6>
								<Text id=item_name margin_bottom=6 size=16/>
								<Text id=item_cat/>
							</VerticalList>
						</HorizontalList>
						<Text id=item_desc wrap=true/>
					</VerticalList>
				</HorizontalList>
				<Image height=2 color=ui_light margin=8/>
				<HorizontalList id=graphlabels margin=4>
					<Text id=info_totals fill=true/>
					<Text id=info_graph/>
				</HorizontalList>
				<Canvas id=graphbox height=200>
					<Image color="#00B3" fill=true/>
					<Draw id=graph_draw fill=true/>
					<Button x=4 y=4  id=graph_zoom_in  icon=icon_small_zoom_in  on_click={on_graph_zoom} zoom=-1 tooltip="Zoom In"/>
					<Button x=4 y=40 id=graph_zoom_out icon=icon_small_zoom_out on_click={on_graph_zoom} zoom=1  tooltip="Zoom Out"/>
					<Text x=4 y=78 id=zoomlvl text="1h"/>
					<Text x=50 y=2 id=graph_max/>
					<Text x=50 y=180 text="0"/>
				</Canvas>
				<ScrollList fill=true>
					<HorizontalList margin_top=6 child_align=center child_padding=8><Text text="Stored" size=16/><Button list=wrap_stored icon=icon_small_cursor_area on_click={select_all} width=28 height=28 tooltip="Select"/></HorizontalList>
					<Wrap id=wrap_stored child_padding=4 margin_top=6/>
					<HorizontalList margin_top=6 child_align=center child_padding=8><Text text="Installed" size=16/><Button list=wrap_installed icon=icon_small_cursor_area on_click={select_all} width=28 height=28 tooltip="Select"/></HorizontalList>
					<Wrap id=wrap_installed child_padding=4 margin_top=6/>
					<HorizontalList margin_top=6 child_align=center child_padding=8><Text text="Being Produced in" size=16/><Button list=wrap_used icon=icon_small_cursor_area on_click={select_all} width=28 height=28 tooltip="Select"/></HorizontalList>
					<Wrap id=wrap_used child_padding=4 margin_top=6/>
					<HorizontalList margin_top=6 child_align=center child_padding=8><Text id=text_prod size=16/><Button list=wrap_prod icon=icon_small_cursor_area on_click={select_all} width=28 height=28 tooltip="Select"/></HorizontalList>
					<Wrap id=wrap_prod child_padding=4 margin_top=6/>
				</ScrollList>
			</VerticalList>
		</VerticalList>
	]], {
		construct = function(view)
			view.reg_list = {}
			view.wrap_list = {}
			view.graph =
			{
				field_in = 'total_added',
				field_out = 'total_removed',
				color_in = 'yellow',
				color_out = 'red',
				graph_draw = view.graph_draw,
				graph_max = view.graph_max,
			}
		end,

		update = function(view, search, filter)
			if filter then view.filter = filter
			else filter = view.filter end
			if type(filter) ~= "string" or filter == "" then filter = nil end
			local MatchLocalizedRichText = filter and Tool.MatchLocalizedRichText

			local item_amounts = self.faction.all_items
			for _,c in ipairs(self.faction:GetComponents()) do
				if not c.is_hidden then
					item_amounts[c.id] = (item_amounts[c.id] or 0) + 1
				end
			end

			local sort
			local detail_item_id = view.graph and view.graph.item_id
			local reg_list = view.reg_list
			for _,reg in ipairs(reg_list) do
				local reg_def = reg.def
				local reg_def_id = reg_def.id
				local found = not filter or MatchLocalizedRichText(reg_def.name or "", filter)
				reg.hidden = not found

				local amount = item_amounts[reg_def_id] or 0
				item_amounts[reg_def_id] = nil

				if reg.num ~= amount then
					reg.num = amount
					if detail_item_id == reg_def_id then
						view:refresh_holders(reg_def)
					end
					sort = true
				end
			end

			local wrap_list = view.wrap_list
			for catidx, category in ipairs(data.categories) do
				if category.defs ~= data.frames then
					local wrap = wrap_list[catidx]
					local cat_filter_field, cat_filter_val = category.filter_field, category.filter_val
					for item_id, amount in pairs(item_amounts) do
						local def = category.defs[item_id]
						if def and def[cat_filter_field] == cat_filter_val then
							local found = not filter or MatchLocalizedRichText(def.name or "", filter)
							if not wrap then
								view.list:Add("<Text height=24 margin_top=10/>", { text = category.name })
								wrap = view.list:Add("<Wrap child_padding=4 wrapsize=716/>")
								wrap_list[catidx] = wrap
							end
							reg_list[#reg_list + 1] = wrap:Add("Reg", {
								num = amount,
								def = def,
								hidden = not found,
								on_click = function(w) view:show_item(w.def.id) end, --Calls the graph/info to open
							})
							sort = true
						end
					end
				end
			end

			if sort then
				for _,wrap in pairs(wrap_list) do
					wrap:SortChildren(function(a,b) return a.num > b.num or (a.num == b.num and a.def.id > b.def.id) end)
				end
			end
		end,

		show_item = function(view, item_id)
			local item_def = data.all[item_id]
			view.item_list.hidden = true
			view.item_details.hidden = false

			view.item_name.text = item_def.name
			view.item_desc.text = item_def.desc
			view.item_icon.def = item_def

			local item_cat
			for catidx, category in ipairs(data.categories) do
				if item_def[category.filter_field] == category.filter_val then
					item_cat = category.name
					break
				end
			end
			view.item_cat.text = item_cat or ""

			--Production Item
			if item_def.production_recipe then
				view.text_prod.text = "Can be Produced by"
			elseif item_def.mining_recipe then
				view.text_prod.text = "Can be Mined by"
			elseif item_def.extracted_by then
				view.text_prod.text = "Can be Extracted by"
			end

			--Graph setup
			view.graph.item_id = item_id
			self:graph_init(view.graph)

			view:refresh_holders(item_def)
		end,

		refresh_holders = function(view, item_def)
			--Stored
			view.wrap_stored:Clear()
			for e,v in pairs(self.faction:GetItemAvailability(item_def.id) or {}) do
				view.wrap_stored:Add("<Reg bg=item_default/>", { entity = e, num = v })
			end
			view.wrap_stored:SortChildren(function(a,b) return a.num > b.num or (a.num == b.num and a.entity.key > b.entity.key) end)
			view.wrap_stored.previous_sibling.hidden = #view.wrap_stored == 0

			--Installed
			view.wrap_installed:Clear()
			for _,entity in ipairs(self.faction:GetEntitiesWithComponent(item_def.id)) do
				view.wrap_installed:Add("<Reg bg=item_default/>", { entity = entity, num = entity:CountComponents(item_def.id) })
			end
			view.wrap_installed.previous_sibling.hidden = #view.wrap_installed == 0

			--Produced
			view.wrap_prod:Clear()
			view.wrap_used:Clear()
			local producer = item_def.production_recipe and item_def.production_recipe.producers
			local miner = not producer and item_def.mining_recipe
			local generators = producer or miner or (item_def.extracted_by)
			if generators then
				for k,_ in pairs(generators) do
					for _,entity in ipairs(self.faction:GetEntitiesWithComponent(k)) do
						local usedin = entity:FindComponent(k)
						if usedin and usedin.register_count > 0 and usedin:GetRegisterId(1) == item_def.id then
							view.wrap_used:Add("<Reg bg=item_default/>", { entity = entity })
						else
							view.wrap_prod:Add("<Reg bg=item_default/>", { entity = entity })
						end
					end
				end
			end
			view.wrap_used.previous_sibling.hidden = #view.wrap_used == 0
			view.wrap_prod.previous_sibling.hidden = #view.wrap_prod == 0

			--Graph Details
			local generated, required = self.faction:GetItemTotals(item_def.id)
			local label_in       = (producer and "Produced"       or miner and "Mined"       or generators and "Extracted"       or "Acquired")
			local label_total_in = (producer and "Produced Total" or miner and "Mined Total" or generators and "Extracted Total" or "Acquired Total")
			view.info_graph.text = L('<img id="v_color_yellow"/> %s / <img id="v_color_red"/> %s', label_in, "Consumed")
			view.info_totals.text = L("%s: %d - %s: %d", label_total_in, generated, "Consumed Total", required)
		end,

		select_all = function(view, btn)
			local res = (Input.IsShiftDown() or Input.IsControlDown()) and View.GetSelectedEntities() or {}
			for _,v in ipairs(view[btn.list]) do res[#res+1] = v.entity end
			View.SelectEntities(res)
		end,

		on_graph_zoom = function(view, btn)
			view.graph.res = (view.graph.res or 2) + btn.zoom
			view.graph_zoom_in.disabled = view.graph.res == 1
			view.graph_zoom_out.disabled = view.graph.res == 3
			local restxt =  { "30s", "1h", "10h" }
			view.zoomlvl.text = restxt[view.graph.res]
		end,

		on_return = function(view, btn)
			view.item_list.hidden = false
			view.item_details.hidden = true
			local restxt =  { "30s", "1h", "10h" }
			view.zoomlvl.text = restxt[view.graph.res]
		end,
	})
end

function Faction:graph_init(g)
	g.lastres = nil
	g.graph_draw.on_draw = function(draw, w, h)
		local res, history, history_in, history_out = (g.res or 2) -- default to 1h scale
		if g.lastres ~= res then
			history = (g.item_id and self.faction:GetItemHistory(g.item_id, res, npts) or self.faction:GetPowerHistory(res, npts))
			history_in, history_out = history[g.field_in], history[g.field_out]
			g.res, g.lastres = res, res
			g.history_in = history_in
			g.history_out = history_out
			draw:Reset()
		else
			history = (g.item_id and self.faction:GetItemHistory(g.item_id, g.res, 1) or self.faction:GetPowerHistory(g.res, 1))
			if history.tick == g.tick then return end
			history_in, history_out = g.history_in, g.history_out
			table.remove(history_in, 1)
			table.insert(history_in, history[g.field_in])
			table.remove(history_out, 1)
			table.insert(history_out, history[g.field_out])
		end

		local day_width = w / npts * Map.GetSettings().day_period * TICKS_PER_SECOND / history.step
		local time_x = w - day_width * (Map.GetTotalDays() % 1.0)
		local day_count = 1 + w // day_width
		for i=1,day_count do
			local x = time_x - (i-1) * day_width
			draw:SetLine(i, x, 0, x, x > 0 and h or 0, 'gray', 1)
		end

		local max_y = 10
		for i = 1, npts do
			max_y = math.max(max_y, history_in[i], history_out[i])
		end
		draw:SetGraph(day_count + 1, g.history_in, g.color_in, 3, max_y)
		draw:SetGraph(day_count + 2, g.history_out, g.color_out, 2, max_y)
		g.graph_max.text = math.ceil(max_y * (g.scale or 1))
		g.tick = history.tick
	end
end

local Faction_filter_orders = false
function Faction:activate_tab_orders()
	self.window:SetContent([[
		<VerticalList>
			<Text id=orders_info style=hl/>
			<VerticalList id=warnings margin_bottom=4/>
			<ScrollList id=list fill=true/>
			<HorizontalList height=32 child_padding=5 child_align=center margin_top=4>
				<Button id=filter on_click={on_click_filter} width=24 height=24/>
				<Text valign=center text="Show only order related to selection" on_click={on_click_filter}/>
			</HorizontalList>
		</VerticalList>
	]], {
		construct = function(view)
			if self.show_entity_orders then
				Faction_filter_orders = true
				self.show_entity_orders = nil
			end
			view.filter.text = Faction_filter_orders and "X" or ""
		end,
		every_frame_update = function(view)
			view:refresh(true)
		end,
		update = function(view)
			view:refresh()
			view.warnings:Clear()
			if not Faction_filter_orders then return end
			local disconnected, powered_down
			for _,v in ipairs(View.GetSelectedEntities() or {}) do
				disconnected = disconnected or v.disconnected
				powered_down = powered_down or v.powered_down
			end
			if disconnected then view.warnings:Add('<Text text="Selection is disconnected from logistics network" color=yellow/>') end
			if powered_down then view.warnings:Add('<Text text="Selection is powered down" color=yellow/>') end
		end,
		refresh = function(view, only_if_scrolled)
			local list = view.list
			local ofs = 1 + list:GetScrollOffset() // 36
			local cnt = 2 + (select(4, list:GetViewportPosition(view)) or 1080) // 36
			local scrollhash = (ofs << 30) | cnt
			if only_if_scrolled and view.scrollhash == scrollhash then return end
			view.scrollhash = scrollhash

			-- Get number of orders total and then get the array with items currently on screen
			local faction, filter = self.faction, (Faction_filter_orders and (View.GetSelectedEntities() or {}) or nil)
			local total = faction:GetNumActiveOrders(filter)
			if cnt > total       then cnt = total           end
			if ofs > total - cnt then ofs = total - cnt + 1 end
			local orders = faction:GetActiveOrders(filter, true, ofs, cnt)

			-- Create items as needed, but never delete, only hide unused ones
			local listn, lastshown = #list, view.lastshown
			for i=listn+1,total do
				local item = list:Add("<Box bg=popup_additional_bg hover=highlight_additional_bg height=36 hidden=false/>")
				if i % 2 == 0 then item.bg = "alt_additional_bg" end
			end
			if total ~= lastshown then
				for i=total+1,(lastshown or total) do list[i].hidden = true end
				for i=(lastshown or total)+1,total do list[i].hidden = false end
				view.lastshown = total
				view.orders_info.text = L("Orders: %d", total)
			end

			local order_channel_bit_images = data.order_channel_bit_images
			for i=ofs,(ofs + cnt - 1) do
				local item = list[i]
				local hl = item[1]
				if not hl then
					hl = item:SetContent([[<HorizontalList child_align=center child_padding=4 fill=true order_id=0>
							<Button margin_left=4 icon=icon_remove on_click={on_click_cancel} height=22 tooltip="Cancel"/>
							<MiniReg/>
							<RegNoNum width=36 height=36/><Image image=icon_small_arrow_right/><RegNoNum width=36 height=36/><RegNoNum width=36 height=36 ui_icon=icon_docarry/>
							<Text margin_left=16 width=80 text="0"/>
							<Image hidden=true width=22 height=22 image=icon_processing color=ui_light tooltip="Recurring Request (Keep Filled Up to Amount)"/>
							<Image hidden=true width=22 height=22 color=ui_light/>
							<Image hidden=true width=22 height=22 image=icon_carry color=red tooltip="Disconnected"/>
							<Image hidden=true width=22 height=22 image=icon_power color=red tooltip="Powered Down"/>
							<Text text="" color=white/>
						</HorizontalList>]])
				end
				local o = orders[i - ofs + 1]
				local reg_item, reg_src, reg_trg, reg_carry, txt_age, img_recur, img_channel, img_disconn, img_powerdown, txt_msg = hl[2], hl[3], hl[5], hl[6], hl[7], hl[8], hl[9], hl[10], hl[11], hl[12]
				local source_entity, target_entity, carry_entity, item_id, amount = o.source_entity, o.target_entity, o.carry_entity, o.item_id, o.amount
				local channel_image = order_channel_bit_images[o.channel_bitmask]
				local item_avail = carry_entity

				local msg, msgcolor = "", 'white'
				if not carry_entity then
					item_avail = (source_entity or faction:GetItemAmount(item_id) > 0)
					if not target_entity.is_placed then
						msg, msgcolor = "Target is docked", 'red'
					elseif source_entity and not source_entity.is_placed then
						msg, msgcolor = "Source is docked", 'red'
					elseif o.recurring and target_entity:CountItem(item_id, true) >= amount then
						msg, msgcolor = "Target is filled up to amount", 'white'
					elseif target_entity.logistics_crane_only or (source_entity and source_entity.logistics_crane_only) then
						msg, msgcolor = "Only Item Transporters", 'yellow'
					elseif target_entity.logistics_flying_only or (source_entity and source_entity.logistics_flying_only) then
						msg, msgcolor = "Only Flying Carriers", 'yellow'
					elseif not item_avail then
						msg, msgcolor = "Item not available", 'yellow'
					elseif source_entity then
						msg, msgcolor = "No Carrier assigned", 'white'
					else
						msg, msgcolor = "No Carrier or source available", 'white'
					end
				elseif carry_entity.state_path_blocked then
					msg, msgcolor = "Carry Unit Blocked", 'yellow'
				end

				hl.order_id = o.id
				reg_item.def_id, reg_item.num, reg_item.numtxt.color = item_id, amount, item_avail and 'white' or 'red'
				reg_src.entity = source_entity
				reg_trg.entity = target_entity
				reg_carry.entity, reg_carry.disabled = carry_entity, not carry_entity
				txt_age.text = Tool.GetTimeDurationStr(o.age//TICKS_PER_SECOND)
				img_recur.hidden = not o.recurring
				img_channel.hidden, img_channel.image, img_channel.tooltip = not channel_image, channel_image and channel_image.image, channel_image and channel_image.tooltip
				img_disconn.hidden = carry_entity ~= nil or not target_entity.disconnected
				img_powerdown.hidden = carry_entity ~= nil or not target_entity.powered_down
				txt_msg.text, txt_msg.color = msg, msgcolor
			end
		end,
		on_click_filter = function(view)
			Faction_filter_orders = not Faction_filter_orders
			view.filter.text = Faction_filter_orders and "X" or ""
			view:update()
		end,
		on_click_cancel = function(view, hl)
			Action.SendForLocalFaction("CancelOrder", { id = hl.order_id })
		end,
	})
end

function Faction:activate_tab_faction()
	self.window:SetContent(
		[[
			<VerticalList child_padding=8>
				<HorizontalList child_padding=20 child_align=center>
					<Text text="Faction Name:" width=160 textalign=right/>
					<InputText text={name} id=txtname fill=true on_change={on_change_name} on_enter={on_set_name}/>
					<Button text="Change Name" id=btnchange disabled=true on_click={on_set_name}/>
					<Button icon=icon_locked id=btnlock on_click={on_lock} tooltip="Lock switching to this faction"/>
				</HorizontalList>
				<HorizontalList child_padding=20 child_align=center>
					<Text text="Faction Color:" width=160 textalign=right/>
					<ColorPicker color={color} on_change={on_color_change} color_mapping=true fill=true/>
				</HorizontalList>
				<HorizontalList child_padding=20 child_align=center>
					<Text text="Faction Registers:" width=160 textalign=right/>
					<Button text="Manage Faction Registers" on_click={on_registers} fill=true/>
				</HorizontalList>
				<HorizontalList child_padding=20 child_align=center>
					<Text text="Replace Buildings:" width=160 textalign=right/>
					<Combo on_change={on_buildings} texts={buildings_texts} value={buildings_value} fill=true/>
				</HorizontalList>
				<VerticalList id=alliancebox child_padding=5>
					<HorizontalList child_padding=20>
						<Text text="Alliance:" width=160 textalign=right/>
						<Text id=self_alliance_info wrap=true fill=true/>
					</HorizontalList>
					<Button text="Leave Alliance" on_click={on_click_leave_alliance} margin_left=180/>
				</VerticalList>
				<Image width=300 height=2 margin_top=4 margin_bottom=4 color=ui_light/>
				<ScrollList child_padding=5 id=factions fill=true/>
			</VerticalList>
		]],
		{
			own_faction = self.faction,
			name = self.faction.name,
			buildings_texts = { "Don't replace destroyed buildings with construction sites", "Replace destroyed buildings with paused construction sites", "Replace destroyed buildings with active construction sites" },
			buildings_value = (self.faction.extra_data.replace_buildings or 1) + 1,
			update = function(view)
				local faction, trusts = view.own_faction, {}
				local faction_extra_data = faction.extra_data
				local invites = faction_extra_data.alliance_invites
				view.btnlock.icon = faction_extra_data.locked and "icon_locked" or "icon_unlocked"
				for _,f in ipairs(Map.GetFactions()) do
					if not f.is_world_faction and f ~= faction then
						trusts[f.id] = { faction:GetTrust(f), f:GetTrust(faction), f.name, f.color, f:GetSharedVisibilityCount() }
					end
				end
				local hash = Tool.Hash(trusts, invites, faction.color)
				if hash == view.hash then return end
				view.hash = hash
				view.color = faction.color
				view.alliancebox.hidden = true
				view.self_alliance_info.text = ""

				for i,f in ipairs(GetAllianceFactions(Map.GetFaction(faction.id))) do
					if i==1 then
						view.alliancebox.hidden = false
						view.self_alliance_info.text = L("%S", faction.name)
					end
					view.self_alliance_info.text = L("%s, %S", view.self_alliance_info.text, f.name)
				end

				view.factions:Clear()
				for faction_id,trust in SortedPairs(trusts) do
					local hlist = view.factions:Add([[
						<Box child_padding=6>
							<VerticalList>
								<HorizontalList child_padding=6>
									<Image image={faction_icon} width=56 height=56/>
									<VerticalList margin_top=6>
										<HorizontalList child_padding=6>
											<Image color={faction_color} width=20 height=20 valign=bottom/>
											<Text text={faction_name} color={faction_title} style=header/>
										</HorizontalList>
										<HorizontalList margin_top=6>
											<Text text="Trust towards you:" margin_right=4 style=hl/>
											<Text id=trust text={other_trust} style={aaa} margin_top=1/>
										</HorizontalList>
									</VerticalList>
								</HorizontalList>
								<HorizontalList child_align=center child_padding=4 child_fill=true margin=6>
									<Button text=Ally    id=btn_ally    trust=ALLY    on_click={on_click_set_trust} tooltip="<hl>Ally</> - Enable viewing and some inter-unit interactions"/>
									<Button text=Neutral id=btn_neutral trust=NEUTRAL on_click={on_click_set_trust} tooltip="<hl>Neutral</> - Don't automatically attack"/>
									<Button text=Enemy   id=btn_enemy   trust=ENEMY   on_click={on_click_set_trust} tooltip="<hl>Enemy</> - Attack automatically"/>
								</HorizontalList>
								<HorizontalList id=alliancelist child_align=center child_padding=6>
									<Image id=imgalliance width=56 height=56/>
									<Button id=btn_alliance_invite text="Invite To Alliance" on_click={on_click_alliance_invite}/>
									<Button id=btn_alliance_accept text="Accept Alliance Invite" on_click={on_click_alliance_accept} hidden=true/>
									<Text id=alliance_info wrap=true fill=true/>
								</HorizontalList>
							</VerticalList>
						</Box>
					]], { faction_id = faction_id, faction_name = NOLOC(trust[3]), other_trust = trust[2], faction_color = trust[4] })

					hlist.imgalliance.image = "Main/skin/Assets/alliance_no.png"
					local this_faction = Map.GetFaction(faction_id)
					for i,r in ipairs(GetAllianceFactions(this_faction)) do
						if i==1 then
							hlist.btn_alliance_invite.hidden = true
							hlist.imgalliance.image = "Main/skin/Assets/alliance.png"
							hlist.alliance_info.text = L("%s %S", "Alliance:", this_faction.name)
						end
						hlist.alliance_info.text = L("%s, %S", hlist.alliance_info.text, r.name)
					end

					-- Check if an invite exists
					if invites then
						for i,id in ipairs(invites) do
							if id == faction_id then
								hlist.btn_alliance_accept.hidden = false
								break
							end
						end
					end

					if faction_id == "bugs" then
						hlist.faction_name = "Bugs"
						hlist.faction_icon = "Main/textures/icons/values/bug.png"
						hlist.alliancelist.hidden = true
						--hlist.hidden = true --Currently set to hidden, will be changed once discovered in the story
					elseif faction_id == "alien" then
						hlist.faction_name = "Aliens"
						hlist.faction_icon = "Main/textures/icons/values/alien.png"
						hlist.alliancelist.hidden = true
						--hlist.hidden = hlist.other_trust ~= 'ENEMY'
					elseif faction_id == "anomaly" then
						hlist.faction_name = "Anomaly"
						hlist.faction_icon = "Main/textures/icons/values/anomaly.png"
						hlist.alliancelist.hidden = true
						--hlist.hidden = hlist.other_trust ~= 'ENEMY'
					elseif faction_id == "human" then
						hlist.faction_name = "Human"
						hlist.faction_icon = "Main/textures/icons/values/human.png"
						hlist.alliancelist.hidden = true
					else
						hlist.faction_icon = "Main/textures/icons/values/human.png"
						if not this_faction.is_player_controlled or not faction.is_player_controlled then hlist.alliancelist.hidden = true end
					end

					if hlist.other_trust == 'ENEMY' then
						hlist.trust.style = 'rl'
					elseif hlist.other_trust == 'ALLY' then
						hlist.trust.style = 'gl'
					elseif hlist.other_trust == 'NEUTRAL' then
						hlist.trust.style = 'bl'
					end

					hlist.btn_ally.disabled    = (trust[1] == 'ALLY'   )
					hlist.btn_neutral.disabled = (trust[1] == 'NEUTRAL')
					hlist.btn_enemy.disabled   = (trust[1] == 'ENEMY'  )
				end
			end,

			on_click_set_trust = function(view, hlist, btn)
				Action.SendForLocalFaction("SetFactionTrust", { faction_id = hlist.faction_id, trust = btn.trust })
			end,

			on_click_leave_alliance = function()
				ConfirmBox("Are you sure you want to leave the alliance?", function()
					local faction = Game.GetLocalPlayerFaction()
					Action.SendForLocalFaction("LeaveAlliance", { faction = faction })
				end)
			end,
			on_click_alliance_invite = function(view, hlist, btn)
				Action.SendForLocalFaction("InviteToAlliance", { faction_id = hlist.faction_id })
			end,
			on_click_alliance_accept = function(view, hlist, btn)
				Action.SendForLocalFaction("JoinAlliance", { faction_id = hlist.faction_id })
				Notification.Clear("alliance_invite")
			end,
			on_change_name = function(view, txt, value)
				view.btnchange.disabled = (string.len(value) < 3 or string.len(value) > 64 or value == view.own_faction.name)
			end,
			on_set_name = function(view)
				-- check faction names
				local new_name = view.txtname.text
				for _,f in ipairs(Map.GetFactions()) do
					if new_name == f.id or new_name == f.extra_data.name or new_name=="alien" or new_name=="bugs" then
						Notification.Warning("Faction name already exists")
						return
					end
					--if not f.is_world_faction and f ~= view.own_faction then
				end

				if view.btnchange.disabled then return end
				Action.SendForLocalFaction("SetFactionName", { name = new_name })
				view.btnchange.disabled = true
			end,
			on_color_change = function(view, picker, color)
				-- delay sending of update action for 0.5 seconds after last change
				view:TweenFromTo("_", 0, 1, 0, 500, function()
					Action.SendForLocalFaction("SetFactionColor", { color = color })
				end)
			end,
			on_lock = function(view, btn)
				Action.SendForLocalFaction("SetFactionLock", { lock = not view.own_faction.extra_data.locked })
			end,
			on_registers = function(view)
				self.window:SetContent([[
					<VerticalList>
						<HorizontalList>
							<Button icon=icon_back on_click={on_return} margin_right=12 valign=top tooltip="Back"/>
							<Text text="Manage Faction Registers" valign=center size=16/>
						</HorizontalList>
						<Image height=2 color=ui_light margin=8/>
						<ScrollList id=list child_padding=8 max_height=775 margin_bottom=8/>
						<Button text="Add New Register" on_click={on_create_click}/>
					</VerticalList>]], {
					own_faction = self.faction,
					update = function(view)
						local radio_storage = view.own_faction.extra_data.radio_storage
						local radio_storage_ed = radio_storage and radio_storage.extra_data
						local hash = Tool.Hash(radio_storage_ed)
						if view.hash == hash then return end
						view.hash = hash
						local list, bands, names = view.list, radio_storage_ed and radio_storage_ed.bands, radio_storage_ed and radio_storage_ed.names
						list:Clear()
						for name,idx in pairs(names or {}) do
							local band, shared = bands[idx], radio_storage:RegisterIsLink(idx)
							local row = list:Add([[<HorizontalList child_align=center child_padding=8>
								<Text text="Name:"/><InputText fill=true text={name} on_commit={on_name_commit} on_change={on_name_change}/>
								<Text text="Radio Band:" margin_left=10/><Reg on_click={on_band_click} def_id={band_id} entity={band_entity} coord={band_coord} num={band_num}/>
								<Text text="Current Value:" margin_left=10/><Reg comp={val_comp} reg_index={val_idx} read_only={shared}/>
								<Button id=delbtn icon=icon_remove on_click={on_remove_click} tooltip="Remove"/></HorizontalList>]], {
								name = name, val_comp = radio_storage, val_idx = idx, shared = shared,
								band_id = band.id, band_entity = band.entity, band_coord = band.coord, band_num = band.num,
							})
							if name == "" or name:match('^ %(%d+%)$') then row[2]:Focus() end
							if shared then row[6].on_click = function(reg) MessagePopup(reg, "Cannot set value of register controlled by one or more Radio Transmitter components") end end
						end
						list:SortChildren(function(a,b)
							if a.band_entity or b.band_entity then
								local a_key, b_key = (a.band_entity and a.band_entity.key), (b.band_entity and b.band_entity.key)
								if a_key ~= b_key then return not b_key or (a_key and a_key < b_key) end
							elseif a.band_coord or b.band_coord then
								local a_x, a_y, b_x, b_y = (a.band_coord and a.band_coord.x), (a.band_coord and a.band_coord.y), (b.band_coord and b.band_coord.x), (b.band_coord and b.band_coord.y)
								if a_x ~= b_x or a_y ~= b_y then return not b_x or (a_x and (a_x < b_x or (a_x == b_x and a_y < b_y))) end
							elseif a.band_id or b.band_id then
								local a_id, b_id = a.band_id, b.band_id
								if a_id ~= b_id then return not b_id or (a_id and a_id < b_id) end
							end
							return a.band_num < b.band_num or (a.band_num == b.band_num and a.name < b.name)
						end)
					end,
					on_name_change = function(view, row, inp, new_name)
						row.delbtn.disabled = row.name ~= new_name
					end,
					on_name_commit = function(view, row, inp, new_name)
						if row.name == new_name then return end
						Action.SendForLocalFaction("FactionRegister", { set_name = row.name, name = new_name })
					end,
					on_band_click = function(view, reg)
						local name = reg.parent.name
						local function register_on_set(rsel, new_val) Action.SendForLocalFaction("FactionRegister", { set_band = name, band = new_val }) end
						local rsel = ShowRegisterSelection(reg, register_on_set)
						if rsel then rsel.hide_clear_button = true rsel:SetRegister({ id = reg.def_id, entity = reg.entity, coord = reg.coord, num = reg.num }) end
					end,
					on_remove_click = function(view, row, btn)
						Action.SendForLocalFaction("FactionRegister", { remove = row.name })
						btn.disabled = true
					end,
					on_create_click = function(view)
						Action.SendForLocalFaction("FactionRegister", { create = true })
					end,
					on_return = function(view)
						self:activate_tab_faction()
					end,
				})
			end,
			on_buildings = function(view, cmb, new_val)
				Action.SendForLocalFaction("SetFactionReplaceBuildings", { val = (new_val ~= 2 and (new_val - 1) or nil) })
			end,
		})
end
