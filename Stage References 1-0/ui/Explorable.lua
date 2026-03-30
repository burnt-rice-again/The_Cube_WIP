local Explorable_layout<const> =
[[
	<Box bg=popup_box_bg padding=4 blur=true min_width=840 dock=center y=-50>
		<VerticalList child_padding=4 on_ui_cancel={close} on_ui_accept={close}>
			<Box bg=popup_additional_bg padding=8>
				<HorizontalList child_padding=4>
					<RegNoNum bg=item_default def={def} no_interact=true/>
					<VerticalList fill=true>
						<Text text={title} size=16 margin_top=4/>
						<Spacer fill=true/>
						<Text text={info} color=ui_light  margin_bottom=4/>
					</VerticalList>
					<HorizontalList id=header/>
					<Canvas height=0 clip=true>
						<Image color="#5CEBA319" dock=fill/>
						<Image image=warning_pattern color="#60D4A2" dock=top-right/>
						<HorizontalList dock=fill child_padding=8>
							<Image id=warnimg image=icon_warning color="#FFFF00"/>
							<Text id=warntxt width=446 wrap=true fill=true valign=center/>
						</HorizontalList>
					</Canvas>
					<Button icon=icon_deny on_click={close} tooltip="Close"/>
				</HorizontalList>
			</Box>
			<Box bg=popup_additional_bg height=188 padding=32>
				<Canvas>
					<HorizontalList dock=center child_padding=100 id=puzzles/>
					<Draw id=draw/>
				</Canvas>
			</Box>
			<Box bg=popup_pattern padding=4 id=consolebox height=0 hidden=true>
				<HorizontalList>
					<Spacer margin_left=60 id=console fill=true/>
					<Box padding=4 id=consolehelpbox hidden=true>
						<VerticalList>
							<Text id=consolehelptxt width=240 wrap=true fill=true/>
							<Button halign=right icon=icon_question active=true on_click={on_console_help_click}/>
						</VerticalList>
					</Box>
					<Button id=consolehelpbtn valign=bottom margin=4 icon=icon_question on_click={on_console_help_click}/>
				</HorizontalList>
			</Box>
			<Box bg=popup_pattern padding=4 id=inventorybox min_height=0 hidden=true>
				<HorizontalList halign=center child_padding=8>
					<Inventory entity={entity} halign=center on_slot_click={on_inventory_slot_click}/>
					<Button icon=icon_cmd_pickup margin_left=40 color=white tooltip="Take All" on_click={on_take_all_click} id=take_all_btn/>
				</HorizontalList>
			</Box>
		</VerticalList>
	</Box>
]]

local ExplorablePuzzle_layout<const> =
[[
	<Box valign=center padding=8 bg=card_box_bg min_height=78>
		<HorizontalList child_padding=8 margin_left=8 margin_right=8 child_align=center>
			<RegNoNum id=reg bg=false/>
			<RegNoNum id=overloadbtn hidden=true/>

			<VerticalList child_padding=4>
				<Text text={title}/>
				<Button id=btn on_click={on_button}/>
				<HorizontalList id=list/>
			</VerticalList>
		</HorizontalList>
	</Box>
]]

local ExplorableLock_layout<const> =
[[
	<Box valign=center padding=8 bg=card_box_bg>
		<Image image={img}/>
	</Box>
]]

local ExplorablePuzzle = {}
UI.Register("ExplorablePuzzle", ExplorablePuzzle_layout, ExplorablePuzzle)

local function ExplorableGetInteractors(explorable_entity, get_all_selected)
	local res, extra = {}
	for _,e in ipairs(View.GetSelectedEntities()) do
		if e:GetRegisterEntity(FRAMEREG_GOTO) == explorable_entity and e:IsInRangeOf(explorable_entity, e.crane_range) then -- and e:IsTouching(explorable_entity)
			res[#res + 1] = e
		elseif get_all_selected and IsBot(e) then
			extra = extra or {}
			extra[#extra + 1] = e
		end
	end
	if extra then for _,e in ipairs(extra) do res[#res + 1] = e end end
	return res
end

function ExplorablePuzzle:add_override(override_item_id, interactor)
	if not data.all[override_item_id] then print("invalid override item: ", override_item_id) return end
	self.overloadbtn.tooltip = function()
		return BuildDefinitionTooltip(override_item_id, { warning = "Override available" })
	end
	self.reg.hidden = true
	self.overloadbtn.hidden = false
	self.overloadbtn.def_id = override_item_id
	self.update = function(self)
		local comp, slot = self.comp
		for _,e in ipairs(ExplorableGetInteractors(comp.owner)) do
			slot = e:FindSlot(override_item_id, 1)
			if slot then break end
		end

		if not slot then
			self.overloadbtn.disabled = true
			self.overloadbtn.on_click = nil
		else
			self.overloadbtn.disabled = false
			self.overloadbtn.on_click = function()
				self.overloadbtn.disabled = true
				local arg = { comp = comp, consume_slot = slot }
				if interactor then arg.interactor = interactor end
				Action.SendForLocalFaction("ExplorableSolvePuzzle", arg)
			end
		end
	end
end

function ExplorablePuzzle:construct()
	local comp = self.comp
	local comp_id, comp_def, comp_solved = comp.id, comp.def, comp.extra_data.ok

	if comp_def.explorable_game then
		-- puzzle type is a minigame
		self.reg.icon = "icon_key"
		self.title = "Disconnected Circuit"
		self.btn.text, self.btn.disabled = (comp_solved and "Complete" or (Map.GetSettings().disable_minigames and "Connect" or "View Console")), (comp_solved == true)

		if not comp_solved and comp_def.explorable_override and Game.GetLocalPlayerFaction():IsUnlocked(comp_def.explorable_override) then
			self:add_override(comp_def.explorable_override)
		end
		self.on_button = function()
			if Map.GetSettings().disable_minigames then
				-- just solve it
				Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = comp } )
			else
				self.outer:ToggleConsole(comp, comp_def.explorable_game, comp_def.explorable_help, true)
			end
		end
	elseif comp_def.explorable_fix then
		local fix_item = comp.extra_data.explorable_fix or comp_def.explorable_fix
		-- puzzle type is needs item
		self.title = comp_def.name -- "Insert Item to Repair",
		self.reg.def_id = fix_item
		if comp_solved then
			self.btn.text, self.btn.disabled = "Complete", true
		else
			self.update = function(self)
				if not comp.exists or comp.extra_data.ok then
					self.btn.text, self.btn.disabled = "Complete", true
					self.update = nil
					return
				end

				local slot
				for _,e in ipairs(ExplorableGetInteractors(comp.owner)) do
					slot = e:FindSlot(fix_item, 1)
					if slot then break end
				end
				if not slot then
					self.btn.text, self.btn.disabled = "Missing Item", true
				else
					self.btn.text, self.btn.disabled = "Transfer Item", false
					self.on_button = function()
						self.btn.disabled = true
						Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = self.comp, consume_slot = slot } )
						self.outer:ToggleConsole() -- close console if open
					end
				end
			end
		end
	elseif comp_id == "c_explorable_scannable" then
		-- scannable with intel scanner
		self.reg.def_id = "c_small_scanner"
		self.title = "System Scan" -- "Scan to interact"
		if comp_solved then
			self.btn.text, self.btn.disabled = "Complete", true
		else
			local owner = comp.owner
			local is_alien_explorable = owner.visual_def.explorable_race == "alien"
			if not owner.def.immortal then
				for _,e in ipairs(ExplorableGetInteractors(owner)) do
					if e.def.race == "alien" then
						self.btn.hidden, self.btn.disabled = true, false
						self:add_override(is_alien_explorable and "energized_artifact" or "crystalized_obsidian", e)
						return
					end
				end
			end

			self.update = function(self)
				if not comp.exists or comp.extra_data.ok then
					self.btn.text, self.btn.disabled = "Complete", true
					self.update = nil
					return
				end

				local working_scanner, unpowered_scanner, unset_scanner
				for _,e in ipairs(ExplorableGetInteractors(owner, true)) do
					local scanner = e:FindComponent("c_small_scanner")
					if not scanner then
					elseif scanner:GetRegisterEntity(1) ~= owner then unset_scanner = scanner
					elseif not e.has_power then unpowered_scanner = scanner
					elseif working_scanner and working_scanner.interpolated_progress > scanner.interpolated_progress then
					else working_scanner = scanner end
				end

				if working_scanner then
					self.btn.text, self.btn.disabled = string.format("%d%%", math.max(math.floor(working_scanner.interpolated_progress * 100 + .49), 0)), true
				elseif unpowered_scanner then
					self.btn.text, self.btn.disabled = "Need Power", true
				elseif unset_scanner then
					self.btn.text, self.btn.disabled = "Scan", false
					self.on_button = function()
						self.btn.disabled = true
						Action.SendForEntity("SetRegister", unset_scanner.owner, { comp = unset_scanner, idx = 1, reg = { entity = self.comp.owner } })
						self.outer:ToggleConsole() -- close console if open
					end
				else
					self.btn.text = "Need Intel Scanner"
					self.btn.disabled = true
				end
			end
		end
	elseif comp_id == "c_alien_lock" then
		if comp_solved then
			self.reg.icon, self.title, self.tooltip, self.btn.hidden = "icon_unlocked", "Decrypted", "Solved", true
		elseif not self.allsolved then
			self.reg.icon, self.title, self.tooltip, self.btn.hidden = "icon_question", "Access Denied", "Decryption Key required", true
		else
			self.update = function(self)
				local comp_solved = not comp.exists or comp.extra_data.ok
				local counters = comp_solved and Game.GetLocalPlayerFaction().extra_data.counters
				if comp_solved then
					self.reg.icon, self.title, self.tooltip, self.btn.hidden = "icon_unlocked", "Decrypted", "Solved", true
					self.update = nil
					return
				end

				self.reg.icon, self.title, self.tooltip, self.btn.hidden = "icon_question", "Encrypted", "Decryption Key required", true

				local key
				for _,e in ipairs(ExplorableGetInteractors(comp.owner)) do
					key = e:FindComponent("c_alien_key")
					if key then break end
				end
				if key then
					self.btn.text, self.btn.disabled, self.btn.hidden, self.tooltip = "Decrypt", false, false, nil
					self.on_button = function()
						self.btn.disabled = true
						Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = self.comp } )
						self.outer:ToggleConsole() -- close console if open
					end
				end
			end
		end
	--[[
	elseif comp_id == "c_human_factory" or comp_id == "c_space_elevator_factory" then
		--self.bg = "warning_pattern2"
		self.bg = "warning_pattern2"
		self.color = "ui_dark"
		--self.title = comp_def.name--"Human Factory"
		self.btn.hidden = true

		self.reg.def = comp_def
		self.title = comp_def.name--"Human Factory"
		self.list:Add("<RegNoNum comp={comp} reg_index=1 no_modify=true/>")
		self.list:Add('<Text valign=center text="←" size=20/>')
		self.list:Add('<Reg comp={comp} reg_index=2 no_modify=true/>')
	--]]
	elseif comp_id == "c_explorable_autosolve" then
		self.reg.icon = "icon_question"
		self.title = ""
		self.btn.text = ""
		self.btn.width = 100
		if comp.extra_data.ok then
			self.btn.text, self.btn.disabled = "Opened", true
		else
			self.list:Add("<Spacer hidden=true/>", {
				every_frame_update = function()
					local rndchrs = "[&4+~HA#z.."
					local currstr = ""
					for i=1,6 do
						local rndnum = math.random(#rndchrs)
						local rndchr = rndchrs:sub(rndnum,rndnum)
						currstr = currstr .. rndchr
					end
					self.btn.text = currstr
				end
			})
			self.on_button = function()
				self.on_update = nil
				self.btn.disabled = true
				Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = self.comp } )
				self.outer:ToggleConsole() -- close console if open
			end
		end
	elseif comp_def.on_explorable_button then
		self.title = comp_def.name
		self.btn.text = comp_def.desc
		self.on_button = function() comp_def:on_explorable_button(self.comp, self) end
		self.reg.icon = comp_def.texture
		self.btn.entity = comp.owner
		self.btn.width = 100
		self.update = comp.def.on_explorable_puzzle_update
	elseif not comp_solved then
		-- automatically mark this puzzle as solved
		Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = comp })
		print("unknown explorable puzzle " .. comp_id)
	end
end

---------------------------------------------------------------------------------------------------------------------

local Explorable = {}
UI.Register("Explorable", Explorable_layout, Explorable)

function Explorable:construct()
	local entity = self.entity
	local race = entity.visual_def.explorable_race
	local lrace = race and NOLOC(L(race))
	self.title = entity.visual_def.explorable_name or entity.def.name or "Unnamed"
	self.info = race and L("%S%S", string.upper(string.sub(lrace, 1, 1)), string.sub(lrace, 2)) or ""
	self.def = entity.def
	self:Refresh(true)
	UI.PlaySound("fx_ui_INVENTORY_POPUP")
end

function Explorable:Refresh(is_construct)
	self.puzzles:Clear()
	self.header:Clear()

	-- check if it needs to be scanned first
	local entity = self.entity
	local hasscannable = entity:FindComponent("c_explorable_scannable")
	local needsscan = hasscannable and not hasscannable.extra_data.ok
	local haspuzzle
	if hasscannable then
		haspuzzle = true
		self.puzzles:Add("ExplorablePuzzle", { comp = hasscannable, last_ok = hasscannable.extra_data.ok, outer = self })
	end
	local allsolved = not needsscan
	if not needsscan then
		for _,v in ipairs(entity.components or {}) do
			if v ~= hasscannable and v.def.type == "Puzzle" then
				haspuzzle = true
				self.puzzles:Add("ExplorablePuzzle", { comp = v, last_ok = v.extra_data.ok, outer = self, allsolved = allsolved  })
				allsolved = allsolved and v.has_extra_data and v.extra_data.ok or false
			end
		end
	end

	-- add any interactor functions
	for _,e in ipairs(ExplorableGetInteractors(entity)) do
		for _,c in ipairs(e.components or {}) do
			if c.def.show_explorable_puzzle then
				if c.def:show_explorable_puzzle(c, entity) then
					self.puzzles:Add("ExplorablePuzzle", { comp = c, outer = self, allsolved = allsolved })
					allsolved = allsolved and c.has_extra_data and c.extra_data.ok or false
				end
			end
		end
	end

	local solved = entity.extra_data.solved
	if not solved and (not haspuzzle or allsolved) then
		Action.SendForLocalFaction("ExplorableSetSolved", { entity = entity })
		solved = true
	end

	if not needsscan then
		local lock = self.puzzles:Add(ExplorableLock_layout, { img = solved and "icon_unlocked" or "icon_locked" })

		self.draw.on_draw = function(draw)
			draw:Reset()
			local lastx, lasty, lastok, incomplete
			for i,p in ipairs(self.puzzles) do
				local px, py, pw, ph = p:GetViewportPosition(draw)
				if lastx then
					local col = (lastok and not incomplete and "ui_light" or "ui_dark")
					draw:AddCircle(lastx, lasty, 8, "ui_bg")
					draw:AddCircle(lastx, lasty, 6, col)
					draw:AddCircle(px, lasty, 8, "ui_bg")
					draw:AddCircle(px, lasty, 6, col)
					draw:AddLine(lastx + (lastok and 0 or 15), lasty, px, lasty, col, 3, true)
					if not lastok then incomplete = true end
				end
				if p == lock then break end
				lastx, lasty, lastok = px + pw, py + ph * 0.5, (p.last_ok or p.comp.def.type ~= "Puzzle")
			end
			draw.on_draw = nil
		end

		local fabricator = entity:FindComponent("c_fabricator", true)
		local production = fabricator and fabricator:GetRegisterId(1)
		if production then
			local list = self.header:Add("<HorizontalList height=56 child_padding=4 child_align=center valign=center padding=2 margin_left=60 margin_right=60/>")
			for ing,amt in pairs(data.all[production].production_recipe.ingredients) do
				list:Add('<Reg bg=item_default/>', { def_id = ing, num = amt })
			end
			list:Add('<Image image=icon_small_arrow/>')
			list:Add('<Reg bg=item_default/>', { def_id = production })
			list:Add('<ProgressCircle image="Main/skin/Assets/component_progress.png" width=20 height=20 x=1 y=2/>',
				{ every_frame_update = function(p) p.progress = fabricator.interpolated_progress end })
		end
	end

	local lootable = entity.lootable
	if solved then
		self.warnimg.image = "icon_confirm"
		self.warnimg.color = "white"

		if hasscannable and hasscannable.extra_data.hack_code then
			self.warntxt.text = L("%s [%d]",  "Access Granted!", hasscannable.extra_data.hack_code)
		else
			self.warntxt.text = "Access Granted!"
		end
	elseif lootable then
		self.warntxt.text = "Limited Access Granted!"
	elseif needsscan then
		self.warntxt.text = "This structure has an unknown security system. Research and develop scanning technology to gain access to the unlock mechanism."
	else
		self.warntxt.text = "To unlock access, please complete the requirements chain."
	end

	if lootable and self.inventorybox.hidden then
		self.inventorybox.hidden = false
		if entity.slot_count == 0 then self.take_all_btn.hidden = true end
		if not is_construct then
			-- inventory doesn't have the correct size until the first update() call, but we only play the animation if not during construct
			local cx, cy = self.inventorybox[1]:GetDesiredSize()
			self.inventorybox:TweenFromTo("sy", 0, 1, 500, "InOutQuart")
			self.inventorybox:TweenFromTo("height", 1, cy + 8, 500, "InOutQuart")
		end
	end
end

function Explorable:update()
	if not self.entity.exists then
		self:RemoveFromParent()
		return
	end

	local is_lootable = self.entity.lootable
	local was_lootable = not self.inventorybox.hidden
	if is_lootable then
		local disable_take_all = true
		for _,srcslot in ipairs(self.entity.slots or {}) do
			if srcslot.unreserved_stack > 0 then disable_take_all = nil break end
		end
		self.take_all_btn.disabled = disable_take_all
	end

	local change = (is_lootable ~= was_lootable)
	for _,puzzle in ipairs(self.puzzles) do
		if puzzle.comp and puzzle.last_ok ~= puzzle.comp.extra_data.ok then
			puzzle.last_ok = puzzle.comp.extra_data.ok
			change = true
			if self.console_comp == puzzle.comp then
				self:ToggleConsole() -- close console
			end
		end
	end
	if change then
		UI.PlaySound("fx_ui_RIDDLE_SOLVED")
		self:Refresh()
	end
end

function Explorable:has_other_players_interacting()
	for _,entity in ipairs(ExplorableGetInteractors(self.entity)) do
		if Game.GetEntitySelectedPlayerId(entity) then return true end
	end
end

function Explorable:close()
	local interactors = ExplorableGetInteractors(self.entity)
	for _,entity in ipairs(interactors) do
		if Game.GetEntitySelectedPlayerId(entity) then
			ConfirmBox("Another player in your faction is also viewing this explorable, are you sure you want to end the interaction and close the window?", function()
				if not self:IsValid() then return end
				for _,e in ipairs(interactors) do
					Action.SendForEntity("SetRegister", e, { idx = FRAMEREG_GOTO })
				end
			end)
			return
		end
	end

	for _,e in ipairs(interactors) do
		Action.SendForEntity("SetRegister", e, { idx = FRAMEREG_GOTO })
	end
end

function Explorable:on_inventory_slot_click(inventory, slot)
	local item_id, remain = slot.id, slot.stack
	if not item_id or remain == 0 then return end
	for _,e in ipairs(ExplorableGetInteractors(self.entity, true)) do
		local pass = e:CountFreeSpace(item_id)
		if pass > 0 then
			if pass > remain then pass = remain end
			ActionOrderTransfer(e, slot, pass)
			if pass == remain then return end
			remain = remain - pass
		elseif remain == 1 and e:GetFreeSocket(item_id) then
			ActionOrderTransfer(e, slot)
			return
		end
	end
	Notification.Error("Not enough free space to transfer item")
end

function Explorable:on_take_all_click(take_all_btn)
	local explorable, src, num = self.entity, {}, 0
	for _,srcslot in ipairs(explorable.slots or {}) do
		local remain = srcslot.stack
		if remain > 0 then
			src[#src+1], src[#src+2], src[#src+3], num = srcslot, srcslot.id, remain, num + 1
		end
	end

	local interactors = ExplorableGetInteractors(explorable, true)
	for _,e in ipairs(interactors) do
		for _,trgslot in ipairs(e.slots or {}) do
			local needid
			for i=1,#src,3 do
				local srcslot, id, remain = src[i], src[i+1], src[i+2]
				local pass = remain > 0 and (not needid or needid == id) and trgslot:GetUnreservedSpaceFor(id) or 0
				if pass > 0 then
					if pass > remain then pass = remain end
					ActionOrderTransfer(e, srcslot, pass)
					if pass == remain then num = num - 1 if num == 0 then goto done end end
					src[i+2] = remain - pass
					needid = id
				end
			end
		end
	end

	for i=1,#src,3 do
		local srcslot, id, remain = src[i], src[i+1], src[i+2]
		if remain == 1 and data.components[id] then
			for _,e in ipairs(interactors) do
				if e:GetFreeSocket(id) then
					ActionOrderTransfer(e, srcslot, 1)
					num = num - 1 if num == 0 then goto done end
					break
				end
			end
		end
	end

	::done::
	take_all_btn.disabled = num == 0
	if num > 0 then Notification.Error("Not enough free space to transfer all items") end
end

function Explorable:ToggleConsole(comp, content, help, is_layout)
	if self.console_comp and (not comp or self.console_comp == comp) and (not content or is_layout) then
		self.console_comp = nil
		self.consolebox:TweenTo("sy", 0, 500, "InOutQuart")
		self.consolebox:TweenTo("height", 0, 500, "InOutQuart", function() self.consolebox.hidden = true end)
	elseif content then
		if is_layout then
			math.randomseed(comp.owner.location, comp.id)
			self.console:SetContent(content, { comp = comp, dock = "center", outer = self })
		else
			self.console:SetContent("<Box bg='Main/skin/Assets/Terminal Background.png?tile=true' padding=10 margin_right=60 dock=fill><Text dock=center textalign=center style=console/></Box>")[1].text = content
		end
		local height = select(2, self.console[1]:GetDesiredSize()) + 48
		if (self.consolebox:GetTweenTarget("height") or self.consolebox.height) ~= height then
			self.consolebox.hidden = false
			self.consolebox:TweenFromTo("sy", self.consolebox.height / height, 1, 500, "InOutQuart")
			self.consolebox:TweenTo("height", height, 500, "InOutQuart")
		end
		self.consolehelptxt.text = help or nil
		self.consolehelpbox.hidden = true
		self.consolehelpbtn.hidden = not help
		self.console_comp = comp
	end
end

function Explorable:on_console_help_click()
	local show = self.consolehelpbox.hidden
	self.consolehelpbox.hidden = not show
	self.consolehelpbtn.hidden = show
end

function Explorable:on_console_overload(btn)
	Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = btn.comp, consume_slot = btn.slot } )
end

function Explorable:OnSolve()
	if not self.console_comp then return end

	if self.console_comp.def.explorable_game then
		FactionCount(self.console_comp.def.explorable_game, 1)
	end

	Action.SendForLocalFaction("ExplorableSolvePuzzle", { comp = self.console_comp })
	self:ToggleConsole() -- close console
end
