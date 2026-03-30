local layout =
[[
	<HorizontalList child_align=top dock=top-fill margin_left=4 margin_top=4 margin_right=312 child_padding=4>
		<VerticalList child_padding=4>
			<Box padding=4>
				<Canvas on_click={show_power} tooltip={power_tooltip} min_width=84>
					<Image margin_left=-5 id=powerimg image=icon_small_energy color=ui_light/>
					<Text halign=fill margin_left=24 textalign=right y=0  id=produced/>
					<Text halign=fill margin_left=24 textalign=right y=15 id=required/>
					<Progress halign=fill margin_top=40 height=12 id=powerprogress color=ui_light/>
					<Image halign=fill margin=2 margin_top=42 height=8 id=powerexcess color=ui_light image=progress_mask/>
				</Canvas>
			</Box>
			<TechNotify/>
			<ProgressNotifications/>
		</VerticalList>
		<VerticalList child_padding=4>
			<Box padding=2>
				<Button width=24 height=24 icon=icon50_ItemNum on_click={on_click_listbtn} tooltip="Items available in your logistics network"/>
			</Box>
			<Box padding=2>
				<Button width=24 height=24 icon=icon_question on_click={on_click_systemindex} tooltip='System Index (<Key action="SystemIndex"/>)'/>
			</Box>
		</VerticalList>
		<VerticalList fill=true>
			<Wrap id=amountlists child_padding=2>
				<HorizontalList on_mouse_enter={on_enter_amounts} on_mouse_leave={on_leave_amounts} id=list_resource          tag=resource/>
				<HorizontalList on_mouse_enter={on_enter_amounts} on_mouse_leave={on_leave_amounts} id=list_simple_material   tag=simple_material/>
				<HorizontalList on_mouse_enter={on_enter_amounts} on_mouse_leave={on_leave_amounts} id=list_advanced_material tag=advanced_material default_hidden=true/>
				<HorizontalList on_mouse_enter={on_enter_amounts} on_mouse_leave={on_leave_amounts} id=list_hitech_material   tag=hitech_material default_hidden=true/>
				<HorizontalList on_mouse_enter={on_enter_amounts} on_mouse_leave={on_leave_amounts} id=list_research          tag=research default_hidden=true/>
			</Wrap>
			<ShortcutBar id=shortcuts halign=right y=-46/>
		</VerticalList>
	</HorizontalList>
]]

local ResourceBar = {}

UI.Register("ResourceBar", layout, ResourceBar)

local function GetFilteredLocalPowerGrid()
	local filter_grid_index = Faction_PowerGridFilterIndex()
	return filter_grid_index and Game.GetLocalPlayerFaction():GetPowerGrid(filter_grid_index)
end

function ResourceBar:power_tooltip()
	return UI.New("<Box bg=popup_box_bg padding=12 blur=true><VerticalList width=300/></Box>", {
		update = function(tt)
			local faction = Game.GetLocalPlayerFaction()
			local grids = faction:GetPowerGrids()
			local list = tt[1]
			list:Clear()

			if #grids == 0 then
				list:Add('<Text text="No Power Grid" textalign=center color=red/>')
				return
			end

			local sum_unused, sum_efficiency, num_grids = 0, 0.0, 0
			for i,grid in ipairs(grids) do
				if grid.total > 0 or grid.received > 0 or grid.load > 0 or grid.unused > 0 then
					sum_unused = sum_unused + grid.unused
					sum_efficiency = sum_efficiency + math.min(1, grid.available / math.max(grid.load, 1))
					num_grids = num_grids + 1
				end
			end

			local function add_entry(title, val)
				list:Add("<Canvas><Text text={title}/><Text text={val} color=title halign=right/></Canvas>", { title = title, val = val })
			end

			local local_grid = GetFilteredLocalPowerGrid()
			if local_grid then
				local gtotal, greceived, gload, gunused = local_grid.total, local_grid.received, local_grid.load, local_grid.unused
				list:Add('<Text text="Local Power Grid" textalign=center color=ui_light/>')
				add_entry("Generated",    string.format("+%d", gtotal*TICKS_PER_SECOND))
				if greceived > 0 then
					add_entry("Received", string.format("+%d", greceived*TICKS_PER_SECOND ))
				end
				add_entry("Load",         string.format("-%d", gload*TICKS_PER_SECOND))
				local charge_or_transmit = local_grid.available - gload - gunused
				if charge_or_transmit > 0 then
					add_entry("Batteries/Transmitters", string.format("-%d", charge_or_transmit*TICKS_PER_SECOND))
				end
				add_entry("Unused",       string.format("%d", gunused*TICKS_PER_SECOND))
				add_entry("Efficiency",   string.format("%d%%", local_grid.efficiency))
				list:Add('<Image height=2 color=ui_light margin=12/>')
			end

			local pwr = faction:GetPowerHistory(1, 1)
			add_entry("Total Generated", string.format("+%d", pwr.total_produced * TICKS_PER_SECOND))
			add_entry("Total Load", string.format("-%d", pwr.total_consumed * TICKS_PER_SECOND))
			add_entry("Total Unused", string.format("%d", sum_unused * TICKS_PER_SECOND))
			add_entry("Average Efficiency", string.format("%.0f%%", sum_efficiency * 100.0 / (num_grids or 1)))

			list:Add('<Image height=2 color=ui_light margin=12/>')
			list:Add('<Text text="Largest Power Grids" textalign=center color=ui_light/>')
			table.sort(grids, function (a,b) return a.available > b.available end)
			for i=1,math.min(#grids, 3) do
				local grid = grids[i]
				local gtotal, greceived, gload, gunused = grid.total, grid.received, grid.load, grid.unused
				if gtotal > 0 or greceived > 0 or gload > 0 or gunused > 0 then
					list:Add('<Image height=2 color=ui_light margin=12/>')
					if gtotal > 0 then
						add_entry("Generated",  string.format("+%d", gtotal*TICKS_PER_SECOND))
					end
					if greceived > 0 then
						add_entry("Received",   string.format("+%d", greceived*TICKS_PER_SECOND ))
					end
					if gload > 0 then
						add_entry("Load",       string.format("-%d", gload*TICKS_PER_SECOND))
					end
					local charge_or_transmit = grid.available - gload - gunused
					if charge_or_transmit > 0 then
						add_entry("Batteries/Transmitters", string.format("-%d", charge_or_transmit*TICKS_PER_SECOND))
					end
					if gunused > 0 then
						add_entry("Unused",     string.format("%d", gunused*TICKS_PER_SECOND))
					end
					add_entry("Efficiency",     string.format("%d%%", grid.efficiency))
				end
			end
		end,
	})
end

function ResourceBar:show_power()
	OpenMainWindow("Faction", { show_tab = "power" })
end

function ResourceBar:on_enter_amounts()
	self.amounts_hovered = true
end

function ResourceBar:on_leave_amounts()
	self.amounts_hovered = nil
end

local function MakeNumString(num)
	if num <= 9999 then return tostring(num) end
	if num <= 99999 then return string.format("%d.%dK", (num // 1000), (num // 100) % 10) end
	if num <= 999999 then return string.format("%dK", (num // 1000)) end
	if num <= 9999999 then return string.format("%d.%02dM", (num // 1000000), (num // 10000) % 100) end
	if num <= 99999999 then return string.format("%d.%dM", (num // 1000000), (num // 100000) % 10) end
	if num <= 999999999 then return string.format("%dM", (num // 1000000)) end
	if num <= 9999999999 then return string.format("%d.%02dG", (num // 1000000000), (num // 10000000) % 100) end
	if num <= 99999999999 then return string.format("%d.%dG", (num // 1000000000), (num // 100000000) % 10) end
	if num <= 999999999999 then return string.format("%dG", (num // 1000000000)) end
	return string.format("%dG", (num // 1000000000))
end

function ResourceBar:construct()
	local resourcebar_hides = Game.GetLocalPlayerExtra().resourcebar_hides
	for _,hl in ipairs(self.amountlists) do
		hl.hidden = (resourcebar_hides and resourcebar_hides[hl.tag]) or (not resourcebar_hides and hl.default_hidden)
	end
end

function ResourceBar:on_click_systemindex(btn)
	OpenSystemIndex()
end

function ResourceBar:on_click_listbtn(btn, mousebtn)
	local amountlists = self.amountlists
	if mousebtn == "LEFTMOUSEBUTTON" then
		amountlists.hidden = not amountlists.hidden
		btn.opacity = amountlists.hidden and 0.3 or 1
		self:update()
		return
	end

	amountlists.hidden = false
	btn.opacity = 1
	UI.MenuPopup([[<Box padding=10>
			<VerticalList child_padding=4>
				<CheckBox id=list_resource          tag=resource          on_change={on_change_list_setting} text="Show Resources"          check=true/>
				<CheckBox id=list_simple_material   tag=simple_material   on_change={on_change_list_setting} text="Show Simple Materials"   check=true/>
				<CheckBox id=list_advanced_material tag=advanced_material on_change={on_change_list_setting} text="Show Advanced Materials" check=true/>
				<CheckBox id=list_hitech_material   tag=hitech_material   on_change={on_change_list_setting} text="Show Hi-Tech Materials"  check=true/>
				<CheckBox id=list_research          tag=research          on_change={on_change_list_setting} text="Show Research Data"      check=true/>
			</VerticalList>
		</Box>]], {
		construct = function(popup)
			for _,hl in ipairs(amountlists) do
				popup[hl.id].hidden = #hl == 0
				popup[hl.id].check = not hl.hidden
			end
			popup:TweenFromTo("sy", 0, 1, 100)
			btn.active = true
		end,
		destruct = function()
			if btn:IsValid() then btn.active = false end
		end,
		on_change_list_setting = function(popup, cb, value)
			self[cb.id].hidden = not value
			local resourcebar_hides, non_default = Game.GetLocalPlayerExtra().resourcebar_hides
			if not resourcebar_hides then
				resourcebar_hides = {}
				for _,hl in ipairs(amountlists) do
					if hl.default_hidden then resourcebar_hides[hl.tag] = true end
				end
			end
			resourcebar_hides[cb.tag] = not value or nil
			for _,hl in ipairs(amountlists) do
				if hl.default_hidden ~= resourcebar_hides[hl.tag] then non_default = true break end
			end
			Game.GetLocalPlayerExtra().resourcebar_hides = non_default and resourcebar_hides or nil
			self:update()
		end,
	}, btn)
end

local achievement_triggered
function ResourceBar:update()
	local faction = Game.GetLocalPlayerFaction()
	local local_grid, power_produced, power_required = GetFilteredLocalPowerGrid()

	local sum_unused, sum_efficiency = 0, 0.0

	if local_grid == false then -- false means show global grid, nil means no local power grid found
		local pwr = faction:GetPowerHistory(1, 1)
		power_produced = pwr.total_produced
		power_required = pwr.total_consumed

		local grids = faction:GetPowerGrids()
		local num_grids = 0
		for _,grid in ipairs(grids or {}) do
			if grid.total > 0 or grid.received > 0 or grid.load > 0 or grid.unused > 0 then
				sum_unused = sum_unused + grid.unused
				sum_efficiency = sum_efficiency + math.min(1, grid.available / math.max(grid.load, 1))
				num_grids = num_grids + 1
			end
		end
		sum_efficiency = sum_efficiency * 100.0 / (num_grids or 1)
	else
		power_produced = local_grid and ((local_grid.total or 0) + (local_grid.received or 0)) or 0
		power_required = local_grid and local_grid.load or 0
		sum_efficiency = local_grid and local_grid.efficiency or 0
	end
	if not achievement_triggered and power_produced > 200000 then
		faction:UnlockAchievement("HIGH_POWER")
		achievement_triggered = true
	end

	local ratio = math.min(power_produced, power_required) / math.max(power_produced, power_required, 0.1)
	self.produced.text = "+"..math.ceil(power_produced*TICKS_PER_SECOND)
	self.required.text = "-"..math.ceil(power_required*TICKS_PER_SECOND)
	self.powerprogress.progress = ratio
	self.powerexcess.hidden = math.ceil(power_produced) <= math.ceil(power_required)

	--string.format("%.0f%%", all_eff)
	self.powerimg.color = sum_efficiency < 50 and "red" or (sum_efficiency < 100 and "yellow") or "ui_light"
	if power_produced > power_required then
		self.powerprogress.color = "ui_light"
	else
		self.powerprogress.color = self.powerimg.color
	end

	local amountlists, lastlist = self.amountlists
	if not amountlists.hidden then
		local item_amounts = faction.all_items
		for _,l in ipairs(amountlists) do
			local ltag, skipupdate, sort = l.tag, l.hidden
			for i=l.child_count,1,-1 do
				local wid = l[i]
				local item_id = wid.id
				local amount = item_amounts[item_id]
				item_amounts[item_id] = nil
				if not amount then -- or amount == 0 then
					wid:RemoveFromParent()
				elseif skipupdate then
					amount = nil
				elseif wid.amount ~= amount then
					-- amount changed
					if wid.amount < amount then
						wid:TweenFromTo("sx", 1.15, 1, 300, "InOutBounce")
						wid:TweenFromTo("sy", 1.15, 1, 300, "InOutBounce")
						wid.flash.color = "ui_light"
						wid.flash:TweenFromTo("opacity", 0.2, 0, 300, "InOutBounce")
					else
						wid.flash.color = "red"
						if amount == 0 then
							wid.flash:TweenFromTo("opacity", 0.3, 0.3, 300, "InOutBounce")
						else
							wid.flash:TweenFromTo("opacity", 0.2, 0, 300, "InOutBounce")
						end
					end

					wid.amount = amount
					wid.numtext = MakeNumString(amount)
					sort = true
				end

				if amount then
					-- update trend text
					local itemhist = faction:GetItemHistory(wid.id, 2, 1)
					local diff = itemhist.total_added-itemhist.total_removed
					if diff > 0 then
						if diff > 10 then
							wid.trendtxt.text = "⇑⇑"
						else
							wid.trendtxt.text = "⇑"
						end

						wid.trendtxt.style = "res_arrow_green"
						--wid.trendtxt.color = "green"
					elseif diff < 0 then
						if diff < -10 then
							wid.trendtxt.text = "⇓⇓"
						else
							wid.trendtxt.text = "⇓"
						end
						--wid.trendtxt.color = "red"
						wid.trendtxt.style = "res_arrow_red"
					else
						wid.trendtxt.text = ""
					end
				end
			end
			for item_id,amount in pairs(item_amounts) do
				local def = data.all[item_id]
				if def.tag == ltag then
					l:Add([[
						<Box padding=4 margin_right=2>
							<Canvas>
								<Image image=item_default width=38 height=38/>
								<Image id=flash width=38 height=38 opacity=0/>
								<Image image={icon} width=38 height=38/>
								<Text id=trendtxt width=36 textalign=right y=-2/>
								<Text style=res size=10 text={numtext} dock=bottom/>
							</Canvas>
						</Box>
						]], {
						icon = def and def.texture,
						numtext = MakeNumString(amount),
						amount = amount,
						id = def.id,
						tooltip = DefinitionTooltip(def),
						on_click = function(wid) OpenMainWindow("Faction", { show_item_id = wid.id }) end,
					})
					sort = true
				end
			end
			if sort and not self.amounts_hovered then
				l:SortChildren(function(a,b)
					return a.amount > b.amount or (a.amount == b.amount and a.id < b.id)
				end)
				if lastlist then lastlist.margin_right = 8 end
			end
			lastlist = not skipupdate and l.child_count ~= 0 and l or lastlist
		end
	end

	local shortcuts = self.shortcuts
	local scx, scy, scw, sch = shortcuts:GetViewportPosition()
	if scw then
		local x, y, w, h, listx, listy, listw, listh = self:GetViewportPosition()
		if lastlist then listx, listy, listw, listh = lastlist:GetViewportPosition() end
		local move_up = listx and listx + listw + 8 + scw < x + w
		shortcuts.y = (move_up and (listy == y and -46 or -44)) or (listy and 4 or 0)
	end
end
