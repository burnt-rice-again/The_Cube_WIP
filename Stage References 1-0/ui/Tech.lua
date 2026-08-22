local BOXCOLOR_LOCKED<const>        = '#354756'
local BOXCOLOR_RESEARCHABLE<const>  = 'ui_dark'
local BOXCOLOR_UNLOCKED<const>      = 'ui_light'

-- A visible but still locked tech showing required ingredients
-- A researchable tech showing required ingredients or a progress bar
-- An unlocked tech node with a checkmark
local NODETECH_WIDTH<const>  = 32+250+32
local NODETECH_HEIGHT<const> = 16+116+16
local NodeTech_layout<const> =
[[
<Box padding=8 margin_left=32 width=250 margin_right=32 margin_top=16 height=116 margin_bottom=16 hover=tech_selected_bg on_mouse_button_down={node_press} on_mouse_button_up={node_release} node_click=technode_on_click on_double_click={technode_on_double_click}>
	<Canvas>
		<Image dock=top-left width=96 height=96 image={image}/>
		<Text dock=bottom-left width=96 hidden={still_locked} text="<bl>Researched</>" size=10 y=-5 textalign=center/>
		<Text text={name} wrap=true size=10 dock=top-right width=114 height=35 x=-10 y=-5/>
		<HorizontalList id=reqs dock=right width=128 y=6/>
		<Image image=icon_small_duration width=24 height=24 x=104 y=82/>
		<Text id=research_time size=9 x=128 y=86/>
		<Box id=next width=48 height=48 x=-6 y=-6 bg=true color=ui_bg>
			<Image image=icon_small_next color=ui_light/>
		</Box>
	</Canvas>
</Box>
]]

-- Revealed discovery tech node (clickable small icon)
local NodeDiscoveryTech_layout<const> =
[[
<Box padding=8 width=64 height=64 margin_left=125 margin_right=125 hover=tech_selected_bg on_mouse_button_down={node_press} on_mouse_button_up={node_release} node_click=technode_on_click>
	<Image dock=center width=48 height=48 image={image} color=ui_dark/>
</Box>
]]

-- A not yet discovered category entry tech on the top row of the tech tree (smaller darkened icon)
local NodeUndiscoveredTech_layout<const> =
[[
<Box padding=8 width=64 height=64 margin_left=125 margin_right=125 bg=tech_not_researched_catergory_bg valign=center on_mouse_button_down={node_press} on_mouse_button_up={node_release}>
	<Image dock=center width=48 height=48 image={image} color=ui_dark/>
</Box>
]]

-- A category where none of the contained techs are researchable/unlocked yet (just darkened icon)
local NodeLockedCategory_layout<const> =
[[
<Box padding=8 width=96 height=96 margin_left=109 margin_right=109 bg=tech_not_researched_catergory_bg valign=center on_mouse_button_down={node_press} on_mouse_button_up={node_release}>
	<Image dock=center width=64 height=64 image={image} color=ui_dark/>
</Box>
]]

-- A tech category with the thumbnail that shows boxes for all the contained techs
local NodeCategoryCollapsed_layout<const> =
[[
	<Box width=176 height=128 margin_left=69 margin_right=69 bg=tech_category_bg hover=tech_category_bg_hover on_mouse_button_down={node_press} on_mouse_button_up={node_release} node_click=categorynode_on_click>
		<Canvas>
			<Image image={image} color=ui_light x=4 y=4 width=22 height=22/>
			<Text text={name} x=30 y=4/>
			<Box dock=center width=165 height=93 y=12 bg=tech_opened_category_bg blocking=false>
				<HorizontalList dock=center child_align=top id=list/>
			</Box>
		</Canvas>
	</Box>
]]

local NodeCategoryExpanded_layout<const> =
[[
	<Box width=162 height=152 margin_left=76 margin_right=76 margin_bottom=-24 bg=tech_category_bg hover=tech_category_bg_hover on_mouse_button_down={node_press} on_mouse_button_up={node_release} node_click=categorynode_close_on_click>
		<Canvas>
			<Image dock=center width=96 height=96 image={image} color=ui_light y=-24/>
			<Text text={name} dock=bottom y=-20/>
		</Canvas>
	</Box>
]]

local NodeHidden_layout<const> =
[[
	<Canvas width=162 margin_left=76 margin_right=76/>
]]

local ExpandedCategory_layout<const> =
[[
	<Canvas width=162 margin_left=76 margin_right=76 valign=fill>
		<Box bg=tech_opened_category_bg halign=center width=0 height=0 id=box on_mouse_button_down={node_press} on_mouse_button_up={node_release}>
			<HorizontalList id=list/>
		</Box>
	</Canvas>
]]

local QueueEntry_layout<const> =
[[
	<Box bg=popup_additional_bg padding=4 on_click={on_click_queue_goto}>
		<VerticalList child_padding=4>
			<HorizontalList child_padding=4>
				<VerticalList>
					<Button on_click={on_click_queue_up}   disabled={updisabled}   icon=icon_small_output width=28 height=28/>
					<Button on_click={on_click_queue_down} disabled={downdisabled} icon=icon_small_input  width=28 height=28/>
				</VerticalList>
				<Image width=56 height=56 image={image} tooltip={imgtooltip} valign=top/>
				<VerticalList fill=true>
					<Text text={title} wrap=true wrapsize=180/>
					<Wrap id=unlocks wrapsize=180/>
				</VerticalList>
			</HorizontalList>
			<ProgressDualPip id=progress height=12/>
		</VerticalList>
	</Box>
]]

local Tech_layout<const> =
[[
	<Box dock=fill padding=2 margin_left=-4 margin_right=-4 margin_bottom=-4>
		<Canvas on_ui_cancel={close} on_ui_accept={close}>
			<Image dock=fill image=tech_tree_pattern_bg/>
			<Image dock=fill image=tech_tree_pattern/>
			<PanView id=pan fill=true on_click={on_click_pan}>
				<VerticalList halign=fill child_align=center margin_top=100 id=list/>
				<Draw id=drawbg on_draw_lines={on_draw_lines}/>
			</PanView>
			<TextSearch margin=10 bg=popup_box_bg id=search width=428 opacity=0.3 on_mouse_enter={on_search_enter} on_mouse_leave={on_search_leave} on_refresh={on_search_change}/>
			<Box padding=15 margin_left=8 margin_top=54 bg=popup_box_bg id=details blur=true hidden=true>
				<VerticalList width=400>
					<HorizontalList child_padding=4>
						<Box width=128 height=128 bg=popup_box_bg padding=1>
							<Image id=details_image/>
						</Box>
						<VerticalList fill=true>
							<Text id=details_name size=15/>
							<Text id=details_desc wrap=true wrapsize=260/>
						</VerticalList>
					</HorizontalList>
					<Text text="Unlocks:" color=ui_light margin_top=8/>
					<Wrap id=details_unlocks wrapsize=400 child_padding=4/>
					<VerticalList id=details_research>
						<Text text="Requirements (Remaining Total):" color=ui_light margin_top=8/>
						<Wrap id=details_reqs wrapsize=336 child_padding=4/>
						<Text text="Progress:" color=ui_light margin_top=8/>
						<ProgressDualPip dock=fill id=details_progress height=20/>
						<Text id=details_steps/>
						<Text id=details_txt textalign=center margin_top=8/>
						<Button id=details_add_btn on_click={on_click_research_add} margin_top=8/>
					</VerticalList>
				</VerticalList>
			</Box>
			<HorizontalList child_padding=4 dock=top-right margin=8>
				<Box id=pause_box bg=popup_box_bg padding=4 blur=true valign=top>
					<Button id=pause_btn on_click={on_click_pause_btn} icon=icon_pause/>
				</Box>
				<VerticalList child_padding=4>
					<Box id=active_box bg=popup_box_bg padding=4 blur=true>
						<VerticalList width=280>
							<Box bg=popup_pattern>
								<Text text="Active Research" color=ui_light margin_bottom=4/>
							</Box>
							<VerticalList id=active_list/>
						</VerticalList>
					</Box>
					<Box id=queue_box bg=popup_box_bg padding=4 blur=true>
						<VerticalList width=280>
							<Box bg=popup_pattern>
								<Text text="Research Queue" color=ui_light margin_bottom=4/>
							</Box>
							<VerticalList child_padding=2 id=queue_list/>
						</VerticalList>
					</Box>
				</VerticalList>
			</HorizontalList>
			<Box bg=popup_box_bg padding=4 blur=true dock=bottom-right margin=8>
				<Button icon=icon_confirm on_click={close}/>
			</Box>
		</Canvas>
	</Box>
]]

local function ArrayContains(arr, val)
	if not arr then return end
	for _,v in ipairs(arr) do
		if v == val then return true end
	end
end

local function GetTechProgress(faction, research_progress, uplinks, def, inactive)
	if not def then return end
	local id, progress_count, uplink_recipe = def.id, def.progress_count, def.uplink_recipe
	local is_unlocked = faction:IsUnlocked(id)
	local progress = (is_unlocked and progress_count) or (research_progress and research_progress[id]) or 0
	local progress_fine, partial_steps, partial_maxremain, active_uplinks, active_rate = progress, 0, 0, 0, 0
	if not inactive and not is_unlocked then
		for _,uplink in ipairs(uplinks) do
			if uplink:GetRegisterId(1) == id then
				local interpolated, boost, raw_efficiency = math.max(uplink.interpolated_progress, 0.0), uplink.effective_boost, (uplink.owner.efficiency or 100)
				local rate = (uplink.def.uplink_rate or 1) / (boost / 100) / (raw_efficiency == 0 and 1 or (raw_efficiency / 100))
				if interpolated > 0 then
					local step_remain = rate * (1 - interpolated)
					progress_fine = progress_fine + interpolated
					partial_steps = partial_steps + 1
					if partial_maxremain < step_remain then partial_maxremain = step_remain end
				end
				active_uplinks = active_uplinks + 1
				active_rate = active_rate + (1 / rate)
			end
		end
	end
	if active_uplinks == 0 then
		active_uplinks = (#uplinks == 0 and 1 or #uplinks)
		active_rate = active_uplinks -- assume rate of 1
	end
	local full_steps = progress_count - progress - partial_steps
	local active_steps = full_steps // active_uplinks * active_uplinks
	local remain_steps = partial_maxremain + (active_steps / active_rate) + (active_steps ~= full_steps and 1 or 0)
	local remain_seconds = remain_steps * (uplink_recipe and uplink_recipe.ticks or 1) / TICKS_PER_SECOND
	return progress/progress_count, progress_fine/progress_count, active_uplinks, remain_seconds
end

local function GetRequireTech(race, def)
	return def.require_tech[race] or def.require_tech[1]
end

local function GetTechCategories()
	return data.tech_categories_race[Game.GetLocalPlayerFaction().extra_data.race or "robot"]
end

local TechsPerCategory
local function FillTechsPerCategory()
	local race = Game.GetLocalPlayerFaction().extra_data.race or "robot"
	local ShownCategories = {}
	local HiddenCategories = {}
	for _,cat in ipairs(GetTechCategories()) do
		for _,sub_cat in ipairs(cat.sub_categories) do ShownCategories[sub_cat] = true end
		for _,sub_cat in ipairs(cat.hidden_categories or {}) do HiddenCategories[sub_cat] = cat.is_shown end
	end

	TechsPerCategory = {}
	for id,def in pairs(data.techs) do
		local cat = def.category
		if not cat or not ShownCategories[cat] then
			-- not shown in tech tree
		elseif not def.progress_count then
			print("Missing progress_count on tech " .. id)
		else
			local techs = TechsPerCategory[cat]
			if not techs then
				techs = { is_shown = HiddenCategories[cat]  }
				TechsPerCategory[cat] = techs
			end
			techs[#techs+1] = def
		end
	end
	-- Now Sort the techs arrays so that the first element is one that doesn't require any of the others
	-- followed by techs that require it, then techs that require the second and so until that full
	-- branch has been added. After that start again with the next tech that doesn't require any other.
	for cat,techs in pairs(TechsPerCategory) do
		local i, reindex = 1, 1
		local function ReIndex(src)
			local count, src_id = 1, techs[src].id
			techs[reindex], techs[src], reindex = techs[src], techs[reindex], reindex + 1
			for j=reindex,#techs do
				if GetRequireTech(race, techs[j]) == src_id then
					count = count + ReIndex(j)
				end
			end
			return count
		end
		local function IsChildTech(require_tech)
			if not require_tech then return end
			if ArrayContains(techs, data.techs[require_tech]) then return true end
		end
		while i <= #techs do
			local best_order, next_order = 999
			for j=i,#techs do
				local order = techs[j].order or 999
				if order < best_order then
					best_order, next_order = order, j
				end
			end
			if next_order and not IsChildTech(GetRequireTech(race, techs[next_order])) then
				ReIndex(next_order)
			elseif not IsChildTech(GetRequireTech(race, techs[i])) then
				ReIndex(i)
			end
			i = (reindex > i and reindex or i + 1)
		end
		--print(cat) for i,t in ipairs(techs) do print("     ",i,t.id) end
	end
end

local BaseUnlocks
local function GetFactionBaseUnlocks()
	if BaseUnlocks then return BaseUnlocks end
	BaseUnlocks = {}
	local f, unlocks_by_tech, data_all = Game.GetLocalPlayerFaction(), {}, data.all
	for _,tech_id in ipairs(f.unlocked_techs) do
		for _,id in ipairs(data.techs[tech_id].unlocks or {}) do
			unlocks_by_tech[id] = true
		end
	end
	for _,id in ipairs(f.unlocks) do
		local def = not unlocks_by_tech[id] and data_all[id]
		local dn = def and def.data_name
		if dn and dn ~= 'techs' and dn ~= 'values' and dn ~= 'techs' and dn ~= 'codex' and (dn ~= 'components' or def.attachment_size ~= "Hidden") then
			BaseUnlocks[#BaseUnlocks+1] = id
		end
	end
	return BaseUnlocks
end

local function WillBeResearchableTech(faction, queue, def)
	local require_tech = GetRequireTech(faction.extra_data.race or "robot", def)
	if not require_tech then return true end
	local unlocked = faction.unlocked_techs
	for i,v in ipairs(unlocked) do unlocked[v] = true end
	for i,v in ipairs(queue)    do unlocked[v] = true end
	if not unlocked[require_tech] then return end
	return true
end

local function Tech_DrawLines(draw)
	draw:SendEvent("on_draw_lines")
end

local Tech, OpenSubCat, OpenTechDef = {}
UI.Register("Tech", Tech_layout, Tech)

function Tech:close()
	CloseMainWindowAndPopup()
end

function Tech:construct()
	BaseUnlocks = nil -- force refresh on open, new things might have unlocked since last viewed

	if not TechsPerCategory then FillTechsPerCategory() end
	if self.param then
		local def = data.all[self.param]
		if def.data_name == 'techs' then
			self:SetVisibleTech(data.techs[self.param])
		else
			self.search:SetText(NOLOC(L(def.name or "")))
			self:on_search_change(self.search, self.search.inp.text)
		end
	end

	local f = Game.GetLocalPlayerFaction()
	local race = f.extra_data.race or "robot"
	if race == "robot" then
		FactionCount("opened_tech", true)
	end
end

function Tech:update()
	local f = Game.GetLocalPlayerFaction()
	local ed = f.extra_data
	local hash = Tool.Hash(ed.research_queue, ed.research_paused, ed.research_progress, f.unlocked_techs)

	if self.hash ~= hash then
		self.hash = hash
		self:Refresh()
		self.drawbg.on_draw = Tech_DrawLines
	end
end

function Tech:on_click_pan()
	self:HideDetails()
	self:CloseExpandedCategory()
end

function Tech:on_click_detailreq(reg)
	self.search:SetText(NOLOC(L(data.all[reg.def_id].name or "")))
	self:on_search_change(self.search, self.search.inp.text)
end

function Tech:on_search_enter(search)
	search:TweenTo("opacity", 0.7)
end

function Tech:on_search_leave(search)
	search:TweenTo("opacity", (search.inp.text or "") == "" and 0.3 or 1.0)
end

function Tech:on_search_change(search, txt)
	search:TweenTo("opacity", (txt or "") == "" and 0.3 or 1.0)
	self:Refresh()
	self.drawbg.on_draw = Tech_DrawLines
	if self.details.hidden then return end
	local show_again = not self.details_node.opacity and self.details_node
	self:HideDetails()
	if show_again then self:ShowDetails(show_again) end -- re-open and refresh search filter
end

function Tech:SetVisibleTech(tech_def)
	for sub_cat,techs in pairs(TechsPerCategory) do
		if ArrayContains(techs, tech_def) then
			OpenTechDef = tech_def
			OpenSubCat = sub_cat
			return
		end
	end
	local id = tech_def.id
	for _,cat in ipairs(GetTechCategories()) do
		if id == cat.discovery_tech or id == cat.initial_tech then
			OpenTechDef = data.techs[id]
			OpenSubCat = nil
			return
		end
	end
end

function Tech:RefreshProgressBars()
	local faction = Game.GetLocalPlayerFaction()
	local research_progress = faction.extra_data.research_progress
	local uplinks = Game.GetLocalPlayerFaction():GetComponents("c_uplink", true)

	local cur_progress, cur_progress_fine, cur_uplinks, cur_remain_seconds
	for i=1,2 do
		for _,entry in ipairs(i == 1 and self.active_list or self.queue_list) do
			local progress, progress_fine, uplinks, remain_seconds = GetTechProgress(faction, research_progress, uplinks, entry.def)
			entry.progress.progress, entry.progress.darkprogress = progress, progress_fine
			if entry.def == OpenTechDef then cur_progress, cur_progress_fine, cur_uplinks, cur_remain_seconds = progress, progress_fine, uplinks, remain_seconds end
		end
	end
	if OpenTechDef and OpenTechDef.progress_count then
		if not cur_progress then cur_progress, cur_progress_fine, cur_uplinks, cur_remain_seconds = GetTechProgress(faction, research_progress, uplinks, OpenTechDef, true) end
		self.details_progress.progress, self.details_progress.darkprogress = cur_progress, cur_progress_fine
		self.cur_uplinks, self.cur_remain_seconds = cur_uplinks, cur_remain_seconds
	end
end

function Tech:RefreshDetails()
	local def = OpenTechDef
	local id, progress_count = def.id, def.progress_count
	local faction = Game.GetLocalPlayerFaction()
	local is_unlocked = faction:IsUnlocked(id)
	local faction_data = faction.extra_data
	local research_progress = faction_data.research_progress

	if not progress_count then self.details_research.hidden = true return end
	self.details_research.hidden = false
	local progress = (is_unlocked and progress_count) or (research_progress and research_progress[id]) or 0
	local remain = progress_count - progress
	self.details_steps.text = L("%d/%d steps done", progress, progress_count)

	local details_reqs = self.details_reqs
	details_reqs:Clear()
	for ing_id, num in pairs(def.uplink_recipe.ingredients or {}) do
		local warning = not faction:IsUnlocked(ing_id) and (data.all[ing_id].locked_desc or "Research Required") or nil
		local reg = details_reqs:Add("<Reg bg=item_default read_only=true on_click={on_click_detailreq}/>", { def_id = ing_id, num = num*remain, warning = warning })
		if warning then reg:Add("<Image image=icon_small_warning color=yellow dock=bottom-right/>") end
	end
	local timebox = details_reqs:Add('<VerticalList width=56 height=56><Text textalign=left text="Time"/><Text textalign=left text={time}/></VerticalList>', {
		time = L("<hl>%.1f</>s (<hl>%.1f</>s / step)", (def.uplink_recipe.ticks*remain/TICKS_PER_SECOND), def.uplink_recipe.ticks/TICKS_PER_SECOND):gsub("%.?0+$", ""),
	})

	local remain_time_tooltip = function()
		local tt = UI.New(data.tooltip_layout)
		tt.update = function(tt) if self:IsValid() then tt.txt = L("Estimated time with %d Uplink(s): %.1fs", self.cur_uplinks or 0, self.cur_remain_seconds or 0) end end
		return tt
	end
	timebox.tooltip, self.details_progress.tooltip = remain_time_tooltip, remain_time_tooltip

	local research_queue = faction_data.research_queue
	local queue = research_queue or faction_data.research_paused or {}
	local queue_idx = -1
	for i,v in ipairs(queue) do if v == id then queue_idx = i break end end

	local add_btn, txt, btn_text, btn_icon, txt_text, txt_color = self.details_add_btn, self.details_txt
	if is_unlocked and queue_idx == -1 then
		txt_text, txt_color = "Research Complete", 'ui_light'
	elseif #queue == 0 and not GetResearchableTech(faction)[id] then
		txt_text, txt_color = "Missing Required Tech", 'red'
	else
		if not GetResearchableTech(faction)[id] then
			txt_text, txt_color = "Missing Required Tech", 'red'
		end
		if #queue == 0 or queue_idx ~= -1 or not txt_text or WillBeResearchableTech(faction, queue, def) then
			btn_text = (queue_idx == 1 or queue_idx > 1) and "Remove from Queue" or #queue > 0 and "Add to Queue" or "Set Research"
			btn_icon = (queue_idx == 1 or queue_idx > 1) and "icon_minus"        or #queue > 0 and "icon_add"     or "icon_confirm"
		end
	end
	add_btn.disabled, add_btn.hidden, add_btn.text, add_btn.icon = false, not btn_text, btn_text, btn_icon
	txt.hidden, txt.text, txt.color = not txt_text, txt_text, txt_color
end

function Tech:HideDetails()
	if self.details.hidden then return end
	self.details.hidden = true
	self.details_node.bg = self.details_node_basebg
	self.details_def, OpenTechDef = nil, nil
end

function Tech:ShowDetails(node)
	local def = node.def
	if self.details_def == def then
		self.details_node = node
		if node.bg ~= "tech_selected_bg" then self.details_node_basebg, node.bg = node.bg, "tech_selected_bg" end
		return
	end

	self:HideDetails()
	if not node.sub_cat then
		self:CloseExpandedCategory()
	end

	local filter = self.search.inp.text
	if filter == "" then filter = nil end
	local MatchLocalizedRichText = filter and Tool.MatchLocalizedRichText

	local details_unlocks = self.details_unlocks
	local faction = Game.GetLocalPlayerFaction()
	details_unlocks:Clear()
	for _,unlock_id in ipairs(def.unlocks or {}) do
		if not data.values[unlock_id] and not data.codex[unlock_id] then
			local is_unlocked = node.still_locked and faction:IsUnlocked(unlock_id)
			local reg = details_unlocks:Add("<Reg bg=item_default/>", { warning = is_unlocked and "Technology Already Obtained" })
			if is_unlocked then reg:Add("<Image image=icon_small_warning color=yellow dock=bottom-right/>") end

			reg.def_id = unlock_id
			if filter and not MatchLocalizedRichText(data.all[unlock_id].name or "", filter) then reg.opacity = 0.3 end
		end
	end
	local starter_base_unlocks = node.starter_tech and GetFactionBaseUnlocks()
	if starter_base_unlocks and #starter_base_unlocks > 0 then
		details_unlocks:Add('<Text text="Story Unlocks:" color=ui_light margin_top=8 width=400/>')
		for _,unlock_id in ipairs(starter_base_unlocks) do
			local reg = details_unlocks:Add("<Reg bg=item_default/>")
			reg.def_id = unlock_id
			if filter and not MatchLocalizedRichText(data.all[unlock_id].name or "", filter) then reg.opacity = 0.3 end
		end
	end
	self.details_image.tooltip = DefinitionTooltip(def)
	self.details_image.image = def.texture
	self.details_name.text = def.name
	self.details_desc.text = def.desc
	self.details_progress.pips = def.progress_count

	self.details.hidden = false
	self.details_node = node
	self.details_node_basebg, node.bg = node.bg, "tech_selected_bg"
	self.details_def, OpenTechDef = def, def
end

function Tech:node_press(w, mousebtn_or_node, mousebtn_or_nil)
	if (mousebtn_or_nil or mousebtn_or_node) == 'RIGHTMOUSEBUTTON' then return false end -- always allow scrolling
	self.pressed_w = w
end

function Tech:node_release(w, mousebtn_or_node, mousebtn_or_nil)
	if (mousebtn_or_nil or mousebtn_or_node) == 'RIGHTMOUSEBUTTON' then return false end -- always allow scrolling
	if self.pressed_w == w and w.node_click then self[w.node_click](self, w) end
	self.pressed_w = nil
end

function Tech:technode_on_click(node)
	self:ShowDetails(node)
	self:RefreshDetails()
	self:RefreshProgressBars()
	local x, y, w, h = node:GetViewportPosition(self.drawbg)
	self.pan:PanIntoView(x - 450, y - 40, x + w + 40, y + h)
end

function Tech:technode_on_double_click(node, btn)
	if btn == 'RIGHTMOUSEBUTTON' then return false end
	if not self.details_add_btn.hidden and not self.details_add_btn.disabled then
		self:on_click_research_add(self.details_add_btn)
	end
end

function Tech:AnimateExpandedCategory(open, callback)
	self.drawbg:Reset()
	local category = self.expanded_category
	local height, row = category.box.height, category.parent
	category:TweenFromTo("y", (open and -height/2 or 0), (open and 0 or -height/2), 200, 'OutQuad')
	row:TweenFromTo("height", (open and 0 or height),    (open and height or 0),    200, 'OutQuad', function() if open then self.drawbg.on_draw = Tech_DrawLines end end)
	row:TweenFromTo("sy",     (open and 0 or 1),         (open and 1 or 0),         200, 'OutQuad', callback)
end

function Tech:CloseExpandedCategory(node_open_next)
	if not self.expanded_category then return end
	self:HideDetails()
	self:AnimateExpandedCategory(false, function()
		if node_open_next then
			self:categorynode_on_click(node_open_next)
		else
			self:Refresh()
		end
	end)
	self.expanded_category = false
	OpenSubCat = nil
	return true
end

function Tech:categorynode_close_on_click()
	self:CloseExpandedCategory()
end

function Tech:categorynode_on_click(node)
	if self:CloseExpandedCategory(node) then return end
	self:HideDetails()

	local x, y, w, h = node:GetViewportPosition(self.drawbg)

	OpenSubCat = node.sub_cat
	self:Refresh()
	self:AnimateExpandedCategory(true)

	local categorybox = self.expanded_category.box
	local boxw, boxh = categorybox.width, categorybox.height
	self.pan:PanIntoView(
		x + w*0.5 - boxw*0.5 - 40, y - 40,
		x + w*0.5 + boxw*0.5 + 40, y + h + boxh + 40)
end

function Tech:Refresh()
	local faction = Game.GetLocalPlayerFaction()
	local faction_data = faction.extra_data
	local faction_unpaused_queue = faction_data.research_queue
	local faction_queue = faction_unpaused_queue or faction_data.research_paused or {}
	local race = faction_data.race or "robot"

	local unlocked, researchable = {}, {}
	for _,v in ipairs(faction.unlocked_techs)       do unlocked[v]     = true end
	for _,v in ipairs(GetResearchableTech(faction)) do researchable[v] = true end

	local function FillCategoryThumbnail(list, techs)
		local lastid, col
		for _,def in ipairs(techs) do
			local show = not def.race or def.race == race
			if show then
				if not lastid or GetRequireTech(race, def) ~= lastid then
					col = list:Add("VerticalList")
				end
				lastid = def.id

				local img = col:Add("<Image width=13 height=13 margin=2/>")
				img.tech_id = lastid
				img.color =
					unlocked[lastid]     and BOXCOLOR_UNLOCKED
					or researchable[lastid] and BOXCOLOR_RESEARCHABLE
					or                          BOXCOLOR_LOCKED
			end
		end
	end

	local function FillTechNode(list, tech_id, tech_def, sub_cat, header_cat_def)
		local is_header = header_cat_def and tech_id == (header_cat_def.discovery_tech or header_cat_def.initial_tech)
		local tech_unlocked = unlocked[tech_id]
		local props = { image = tech_def.texture, name = tech_def.name, def = tech_def, sub_cat = sub_cat, still_locked = not tech_unlocked, unknown = not tech_unlocked and not researchable[tech_id] }

		if tech_unlocked then
			props.bg = is_header and "tech_next_to_research_bg" or "tech_researched_bg"
		elseif researchable[tech_id] then
			props.bg = "tech_next_to_research_bg"
		elseif not header_cat_def then
			props.bg = "tech_disabled_bg"
		else
			props.tooltip = tech_def.tooltip or tech_def.name
			props.image = header_cat_def.texture
			list:Add(tech_id == header_cat_def.discovery_tech and NodeUndiscoveredTech_layout or NodeLockedCategory_layout, props)
			return
		end

		props.tooltip = DefinitionTooltip(tech_def)
		local node = list:Add(is_header and NodeDiscoveryTech_layout or NodeTech_layout, props)

		if not is_header then
			if tech_unlocked then node.color = "#BBBBBB" end

			local progress_count, uplink_recipe = tech_def.progress_count, tech_def.uplink_recipe
			for k,v in pairs(uplink_recipe and uplink_recipe.ingredients or {}) do
				node.reqs:Add("<MiniReg bg=item_default no_modify=true/>", { def_id = k, num = v*progress_count })
			end
			if uplink_recipe then
				local numstr = string.format("%.1f", (uplink_recipe.ticks*progress_count/TICKS_PER_SECOND)):gsub("%.?0+$", "")
				node.research_time.text = L("%Ss", numstr)
			end

			node.next.hidden = not ArrayContains(faction_queue, tech_id)
		else
			node.starter_tech = header_cat_def.discovery_tech == nil or nil
		end

		if OpenTechDef == tech_def then
			self:ShowDetails(node)
		end
		return node
	end

	local function FillCategoryGroup(list, box, techs, sub_cat)
		local ret = {}
		local ncol, nrow, col, lastid = 0, 0
		for _,def in ipairs(techs) do
			local show = not def.race or def.race == race
			if show then
				if not lastid or GetRequireTech(race, def) ~= lastid then
					nrow = math.max(nrow, col and #col or 0)
					col = list:Add("VerticalList")
					ncol = ncol + 1
				end
				lastid = def.id
				ret[lastid] = FillTechNode(col, lastid, def, sub_cat)
			end
		end
		nrow = math.max(nrow, col and #col or 0)
		box.width = ncol*NODETECH_WIDTH-32
		box.height = nrow*NODETECH_HEIGHT
		list.x = -16
		return ret
	end

	self.nodelist = nil
	self.list:Clear()
	for rown=1,999 do
		local morerows
		local row = self.list:Add("<HorizontalList margin=10/>")
		for i,cat in ipairs(GetTechCategories()) do
			local discovery_tech, initial_tech = cat.discovery_tech, cat.initial_tech
			local sub_idx = rown - (discovery_tech and 2 or 1)
			local sub_cat = cat.sub_categories[sub_idx]
			if rown == 1 then -- Top row shows discovery or initial tech
				local tech_id = discovery_tech or initial_tech
				FillTechNode(row, tech_id, data.techs[tech_id], nil, cat)
			elseif sub_idx == 0 then -- Second row shows initial tech if there is discovery tech above
				local tech_id = initial_tech
				FillTechNode(row, tech_id, data.techs[tech_id], nil, cat)
			elseif sub_cat then -- Category box
				local techs = TechsPerCategory[sub_cat]
				if techs and techs.is_shown and not techs.is_shown(sub_cat) then
				else
					local cat_tex = cat.textures and cat.textures[sub_idx] or cat.texture
					local props = { image = cat_tex, name = cat.name, tooltip = cat.name }
					if techs and techs[1] and (unlocked[techs[1].id] or researchable[techs[1].id]) then
						props.name = sub_cat
						props.sub_cat = sub_cat
						if sub_cat == OpenSubCat then
							local category = UI.New(ExpandedCategory_layout, { cat = sub_cat })
							self.nodelist = FillCategoryGroup(category.list, category.box, techs, sub_cat)
							self.expanded_category = category
							local categoryrow = self.list:Add("<HorizontalList margin=10/>", { height = category.box.height })
							for j=1,#GetTechCategories() do
								categoryrow:Add(i == j and category or NodeHidden_layout)
							end
							row:Add(NodeCategoryExpanded_layout, props)
						else
							FillCategoryThumbnail(row:Add(NodeCategoryCollapsed_layout, props).list, techs)
						end
					else
						props.tooltip = sub_cat
						row:Add(NodeLockedCategory_layout, props)
					end
				end
			else -- Empty cell
				row:Add(NodeHidden_layout)
			end
			if cat.sub_categories[sub_idx + 1] then morerows = true end
		end
		if not morerows then break end
	end

	if not self.details.hidden then
		self:RefreshDetails()
	end

	self.active_box.hidden = #faction_queue == 0
	self.queue_box.hidden = #faction_queue <= 1
	self.pause_box.hidden = #faction_queue == 0
	self.pause_btn.active = not faction_unpaused_queue
	self.pause_btn.tooltip = faction_unpaused_queue and "Pause Research" or "Resume Research"

	self.queue_list:Clear()
	self.active_list:Clear()
	for i,v in ipairs(faction_queue) do
		local tech_def = data.techs[v]
		if tech_def then
			local entry = (i == 1 and self.active_list or self.queue_list):Add(QueueEntry_layout, {
				def = tech_def,
				image = tech_def.texture,
				title = tech_def.name,
				updisabled = i == 1,
				downdisabled =i == #faction_queue,
				imgtooltip = DefinitionTooltip(tech_def),
			})
			entry.progress.pips = tech_def.progress_count
			for _,unlock_id in ipairs(tech_def.unlocks or {}) do
				if not data.values[unlock_id] and not data.codex[unlock_id] then -- skip
					entry.unlocks:Add("<MiniReg bg=item_default/>", { def_id = unlock_id })
				end
			end
		end
	end

	self:RefreshProgressBars()
	self.every_frame_update = #faction_queue > 0 and Tech.RefreshProgressBars or nil

	local filter = self.search.inp.text
	if not filter or filter == "" then return end
	local MatchLocalizedRichText = Tool.MatchLocalizedRichText

	local function MatchTechDef(def, is_starter_tech)
		if MatchLocalizedRichText(def.name or "", filter) then return true end
		local data_all = data.all
		for _,id in ipairs(def.unlocks or {}) do
			local unlock_def = data_all[id]
			local data_name = unlock_def.data_name
			if data_name ~= 'values' and data_name ~= 'techs' and data_name ~= 'codex' and MatchLocalizedRichText(unlock_def.name or "", filter) then return true end
		end
		if is_starter_tech then
			for _,id in ipairs(GetFactionBaseUnlocks()) do
				if MatchLocalizedRichText(data_all[id].name or "", filter) then return true end
			end
		end
	end

	for y,row in ipairs(self.list) do
		for x,node in ipairs(row) do
			if node.list then
				local is_thumbnail, matched = node.sub_cat
				for caty,catrow in ipairs(node.list) do
					for catx,catnode in ipairs(catrow) do
						if MatchTechDef(catnode.def or data.techs[catnode.tech_id]) then
							matched = true
						else
							catnode.opacity = is_thumbnail and 0.001 or 0.2
						end
					end
				end
				if not matched then
					if is_thumbnail then node.opacity = 0.2
					else row.previous_sibling[x].opacity = 0.2 node.box.bg = "tech_disabled_bg" end
				end
			elseif not node.sub_cat then
				if not node.def or node.unknown or not MatchTechDef(node.def, node.starter_tech) then node.opacity = 0.15 end
			end
		end
	end
end

function Tech:on_draw_lines(draw)
	-- draw lines
	local faction = Game.GetLocalPlayerFaction()
	local race = faction.extra_data.race or "robot"
	if self.nodelist then
		for tid,twid in pairs(self.nodelist) do
			local reqid = GetRequireTech(race, twid.def)
			if reqid then
				local reqnode = self.nodelist[reqid]
				--print(tid, reqid)
				if reqnode then
					-- draw line from top of current node to bottom of previous node
					local p1x, p1y = reqnode:GetViewportPosition(draw)
					local p1w, p1h = reqnode:GetDesiredSize(draw)

					local p2x, p2y = twid:GetViewportPosition(draw)
					local p2w, p2h = twid:GetDesiredSize(draw)

					if p2x ~= nil then
						local line_color = twid.opacity == 0.2 and 'ui_bg' or faction:IsUnlocked(tid) and 'ui_light' or 'ui_dark'
						draw:AddLine(p1x+(p1w*0.5), p1y+p1h, p2x+(p2w*0.5), p2y-2, line_color, 3, true)
					end
				end
			end
		end
	end
	self.nodelist = nil
	self.drawbg.on_draw = nil
end

function Tech:on_click_research_add(btn)
	if not OpenTechDef then return end
	local faction_data = Game.GetLocalPlayerFaction().extra_data
	local faction_queue = faction_data.research_queue or faction_data.research_paused
	if faction_queue and #faction_queue >= 3 and not ArrayContains(faction_queue, OpenTechDef.id) then
		Notification.Warning("Can only queue up to three research items")
		return
	end
	Action.SendForLocalFaction("SetResearch", { id = OpenTechDef.id })
	self.details_add_btn.disabled = true
end

function Tech:on_click_pause_btn(btn)
	Action.SendForLocalFaction("SetResearch", { toggle_paused = true })
	btn.active = not btn.active
end

function Tech:on_click_queue_up(entry, btn)
	Action.SendForLocalFaction("SetResearch", { id = entry.def.id, queue_up = true })
	btn.disabled = true
end

function Tech:on_click_queue_down(entry, btn)
	Action.SendForLocalFaction("SetResearch", { id = entry.def.id, queue_down = true })
	btn.disabled = true
end

function Tech:on_click_queue_goto(entry)
	self:SetVisibleTech(entry.def)
	self:Refresh()
end

--------------------------------------------------------------------------------------------------------------

function FactionAction.SetResearch(faction, arg)
	local faction_data = faction.extra_data
	if arg.toggle_paused then
		-- pause/resume research
		faction_data.research_queue, faction_data.research_paused = faction_data.research_paused, faction_data.research_queue
	else
		local tech_id = arg.id
		if not tech_id or not data.techs[tech_id] then return end

		local queue, queue_idx = faction_data.research_queue or faction_data.research_paused, -1
		if not queue then queue = {} faction.extra_data.research_queue = queue end
		for i,v in ipairs(queue) do if v == tech_id then queue_idx = i break end end

		if #queue == 0 then
			-- start research
			queue[1] = tech_id

			if Map.GetSettings().cheat_free_research then
				faction:Unlock(tech_id)
				queue[1] = nil
				return
			end
		elseif queue_idx == -1 then
			-- add to end of queue
			table.insert(queue, tech_id)
		else
			-- modify queue
			table.remove(queue, queue_idx)
			if arg.queue_up and queue_idx > 1 then
				table.insert(queue, queue_idx - 1, tech_id)
			elseif arg.queue_down and queue_idx <= #queue then
				table.insert(queue, queue_idx + 1, tech_id)
			end

			-- if queue has been fully cleared set research to be not paused
			if #queue == 0 then
				faction_data.research_queue, faction_data.research_paused = queue, nil
			end
		end
	end

	-- Trigger uplink updates
	for _,c in ipairs(faction:GetComponents("c_uplink", true)) do
		c:Activate()
	end
end

--------------------------------------------------------------------------------------------------------------

local TechNotify_layout<const> =
[[
	<Box hidden=true padding=4>
		<Canvas on_click={on_click_tech}>
			<Image margin_left=2 margin_top=6 image=icon_uplink color=ui_light width=32 height=32 halign=center margin_right=26/>
			<Box bg=popup_box_bg padding=1 width=46 height=46 halign=right blocking=false>
				<Image width=44 height=44 id=techimg/>
			</Box>
			<ProgressDualPip id=progress halign=fill margin_top=50 height=10 color=ui_light tooltip={remain_time_tooltip}/>
		</Canvas>
	</Box>
]]

local TechNotify = {}
UI.Register("TechNotify", TechNotify_layout, TechNotify)

function TechNotify:on_click_tech()
	OpenMainWindow("Tech", { param = self.tech_id })
end

function TechNotify:update(first_update)
	local faction = Game.GetLocalPlayerFaction()
	if not IsShowNotification("tech_progress") then
		self.hidden = true
		return
	end

	local faction_data = faction.extra_data
	local research_queue = faction_data.research_queue
	local tech_id = research_queue and research_queue[1]
	local tech_def = data.techs[tech_id]
	if not tech_def then tech_id = nil end

	if self.tech_id ~= tech_id then
		self.tech_id = tech_id
		if not tech_id then
			self.hidden = true
			return
		end

		local count = tech_def.progress_count
		self.hidden = false
		self.techimg.image = tech_def.texture
		self.tooltip = DefinitionTooltip(tech_def)
		self.progress.pips = count // (count > 20 and count // 10 or 1)
	end

	if tech_id then
		local research_progress = faction_data.research_progress
		local all_uplinks = Game.GetLocalPlayerFaction():GetComponents("c_uplink", true)
		local progress, progress_fine, uplinks, remain_seconds = GetTechProgress(faction, research_progress, all_uplinks, tech_def)
		self.progress.progress, self.progress.darkprogress = progress, progress_fine
		self.uplinks, self.remain_seconds = uplinks, remain_seconds
	end
end

function TechNotify:remain_time_tooltip()
	local tt = UI.New(data.tooltip_layout)
	tt.update = function(tt)
		tt.hidden = not self.tech_id
		tt.txt = L("Estimated time with %d Uplink(s): %.1fs", self.uplinks or 0, self.remain_seconds or 0)
	end
	return tt
end

--------------------------------------------------------------------------------------------------------------

local ResearchPopup_layout<const> =
[[
	<Box dock=top margin_top=40 bg=popup_box_bg padding=4 blur=true>
		<Box bg=popup_pattern padding=4>
			<VerticalList child_padding=8>
				<VerticalList id=list child_padding=8/>
				<HorizontalList child_padding=4 fill=true>
					<Button icon=icon50_Tech text="Open Research" on_click={on_click_openresearch} height=32 fill=true/>
					<Canvas>
						<ProgressCircle id=prog image="Main/skin/Assets/component_progress.png" opacity=0.75 color=ui_light width=32 height=32/>
						<Button icon=icon_confirm tooltip="Close" on_click={close} width=32 height=32/>
					</Canvas>
				</HorizontalList>
			</VerticalList>
		</Box>
	</Box>
]]

local ResearchPopup = {}
local ResearchPopupOpen
UI.Register("ResearchPopup", ResearchPopup_layout, ResearchPopup)

function ResearchPopup:construct()
	if ResearchPopupOpen then ResearchPopupOpen:RemoveFromParent() end
	ResearchPopupOpen = self

	local faction = Game.GetLocalPlayerFaction()
	local queue = faction.extra_data.research_queue
	local id = self.id -- i == 1 and self.id or (queue and queue[1])
	local tech_def = id and data.techs[id]
	--if not id then break end

	--if i == 2 then self.list:Add("<Image width=2 color=ui_light margin=12/>") end
	if not id then return end

	local part = self.list:Add([[
		<Canvas>
			<VerticalList child_padding=4>
				<HorizontalList child_padding=8>
					<Box id=imgbox width=60 height=60 padding=1>
						<Image id=img/>
					</Box>
					<VerticalList>
						<Text size=16 id=title color=ui_light/>
						<Text size=16 id=name/>
					</VerticalList>
				</HorizontalList>
				<Text size=12 id=desc color=white wrap=true wrapsize=300 width=300/>
				<Wrap id=unlocks child_padding=4 wrapsize=300/>
			</VerticalList>
		</Canvas>
	]])

	part.title.text = "Research Complete" --i == 1 and "Research Complete" or "Next in Queue"
	part.name.text = tech_def.name
	part.desc.text = tech_def.desc
	part.desc.hidden = true--not tech_def.desc

	local tech_icon_def = (tech_def.texture and tech_def) or (tech_def.unlocks and tech_def.unlocks[1] and data.all[tech_def.unlocks[1]])
	part.img.image = tech_icon_def and tech_icon_def.texture
	part.img.tooltip = DefinitionTooltip(tech_def)
	part.imgbox.bg = "tech_researched_bg"-- or "tech_next_to_research_bg"

	for _,ul in ipairs(tech_def.unlocks or {}) do
		if not data.values[ul] and not data.codex[ul] then
			part.unlocks:Add("<MiniReg bg=item_default/>", { def_id = ul })
		end
	end

	tech_def = queue and queue[1]
	tech_def = tech_def and data.techs[tech_def]
	if tech_def then
		self.list:Add("<Image height=1 color=ui_light margin=4/>")
		part = self.list:Add([[
		<Box padding=4>
			<VerticalList child_padding=4 fill=true>
				<HorizontalList child_padding=8>
					<Box id=imgbox width=38 height=32 padding=1>
						<Image id=img/>
					</Box>
					<VerticalList>
						<Text size=12 id=title color=ui_light/>
						<Text size=12 id=name/>
					</VerticalList>
				</HorizontalList>
			</VerticalList>
		</Box>]])

		part.title.text = "Next in Queue"
		part.name.text = tech_def.name

		local tech_icon_def = (tech_def.texture and tech_def) or (tech_def.unlocks and tech_def.unlocks[1] and data.all[tech_def.unlocks[1]])
		part.img.image = tech_icon_def and tech_icon_def.texture
		part.img.tooltip = DefinitionTooltip(tech_def)
		part.imgbox.bg =  "tech_next_to_research_bg"
	end

	self:TweenFromTo("sy", 0.5, 1, 200, 'OutQuad')
	self:TweenFromTo("x", -1000, 0, 200, 'OutQuad')
end

function ResearchPopup:every_frame_update(dt)
	self.prog.progress = (self.prog.progress or 0) + dt * (1/30) -- close in 30 seconds
	if self.prog.progress < 1 then return end
	self.every_frame_update = false
	self:close()
end

function ResearchPopup:close()
	self.close = function() end
	self:TweenFromTo("sy", 1, 0.5, 200, 'InQuad')
	self:TweenFromTo("x", 0, 1000, 200, 'InQuad', function() self:RemoveFromParent() ResearchPopupOpen = nil end)
end

function ResearchPopup:on_click_openresearch()
	OpenMainWindow("Tech", { param = self.id })
	self:close()
end

local SeenUnlocks, ExtraKnownThings, ExtraKnownThings_PlayerLevel
local default_extra_known = {
	-- flowers
	"f_damage_plant", "f_phase_plant",
	-- resource nodes
	"f_resourcenode_obsidian", "f_resourcenode_laterite", "f_resourcenode_metal", "f_resourcenode_crystal", "f_resourcenode_silica", "f_resourcenode_blightcrystal", "f_resourcenode_tree",
}

local function AddSeen(id, tech_def, also_extra)
	SeenUnlocks[id] = true
	if tech_def and tech_def.unlocks then
		for _,v in ipairs(tech_def.unlocks) do SeenUnlocks[v] = true end
	end
	if also_extra then ExtraKnownThings[id] = true end
end

local function RefreshSeenAndKnown()
	local faction = Game.GetLocalPlayerFaction()
	local lvl = GetPlayerFactionLevel(faction)
	SeenUnlocks, ExtraKnownThings, ExtraKnownThings_PlayerLevel = {}, {}, lvl

	-- Add unlocks and owned entity frames
	local data_techs = data.techs
	for _,v in ipairs(faction.unlocks) do AddSeen(v, data_techs[v]) end
	for _,e in ipairs(faction.entities) do AddSeen(e.id, nil, true) end

	-- Add integrated components shown in the frame view on owned/unlocked frames
	local data_components = data.components
	for frame_id,frame_def in pairs(data.frames) do
		if SeenUnlocks[frame_id] and frame_def.components then
			for _,v in ipairs(frame_def.components) do
				local comp_def = v[2] == "hidden" and data_components[v[1]]
				if comp_def and comp_def.get_ui then AddSeen(v[1], nil, true) end
			end
		end
	end

	-- Add researchable techs and items picked up (except hidden components not shown in the frame view)
	for _,v in ipairs(GetResearchableTech(faction)) do AddSeen(v, data_techs[v]) end
	for _,v in ipairs(faction.items_picked_up) do
		local comp_def = data_components[v]
		if not comp_def or comp_def.attachment_size ~= "Hidden" or comp_def.get_ui then AddSeen(v, nil, true) end
	end

	-- Add revealed tech trees and all its unlocks
	if not TechsPerCategory then FillTechsPerCategory() end
	for cat,techs in pairs(TechsPerCategory) do
		if techs[1] and SeenUnlocks[techs[1].id] then
			for _,tech_def in ipairs(techs) do AddSeen(tech_def.id, tech_def) end
		end
	end

	-- Add known bugs and defaults to extra known list
	for _,v in ipairs(GetBugsForLevel(lvl)) do ExtraKnownThings[v] = true end
	for _,v in ipairs(default_extra_known)  do ExtraKnownThings[v] = true end
end

-- Extra known are things not unlocked but still listed in the register selection
function Tech_GetExtraKnownThings()
	if SeenUnlocks and ExtraKnownThings_PlayerLevel == GetPlayerFactionLevel(Game.GetLocalPlayerFaction()) then return ExtraKnownThings end
	RefreshSeenAndKnown()
	return ExtraKnownThings
end

-- Seen unlocks are unlocks, owned frames/items and things seen in the tech tree
function Tech_GetSeenUnlocks()
	if SeenUnlocks then return SeenUnlocks end
	RefreshSeenAndKnown()
	return SeenUnlocks
end

local SeenTech
function Tech_GetSeenTech()
	if SeenTech then return SeenTech end

	local initial_tech_map = {}
	local category_map = {}

	for category_num,v in ipairs(GetTechCategories()) do
		if v.initial_tech then
			initial_tech_map[v.initial_tech] = category_num
		end
		if v.discovery_tech then
			initial_tech_map[v.discovery_tech] = category_num
		end
		for _,sub in ipairs(v.sub_categories) do
			category_map[sub] = category_num
		end
	end

	SeenTech = {}
	local function AddSeen(id, tech_def)
		if initial_tech_map[id] then
			SeenTech[id] = initial_tech_map[id]
		elseif tech_def.category then
			SeenTech[id] = category_map[tech_def.category]
		end
	end

	if not TechsPerCategory then FillTechsPerCategory() end
	local faction, data_techs = Game.GetLocalPlayerFaction(), data.techs
	for _,v in ipairs(faction.unlocked_techs) do AddSeen(v, data_techs[v]) end
	for _,v in ipairs(GetResearchableTech(faction)) do AddSeen(v, data_techs[v]) end

	for cat,techs in pairs(TechsPerCategory) do
		if techs[1] and SeenTech[techs[1].id] then
			for _,tech_def in ipairs(techs) do AddSeen(tech_def.id, tech_def) end
		end
	end

	return SeenTech
end

local FramesWithIntegrated
function Tech_GetFramesWithIntegrated(id)
	if not FramesWithIntegrated then
		FramesWithIntegrated = {}
		local seen = Tech_GetSeenUnlocks()
		for frame_id,frame_def in pairs(data.frames) do
			if seen[frame_id] and frame_def.components then
				for i,v in ipairs(frame_def.components) do
					local frame_ids = FramesWithIntegrated[v[1]]
					if not frame_ids then
						FramesWithIntegrated[v[1]] = { frame_id }
					elseif frame_ids[#frame_ids] ~= frame_id then
						frame_ids[#frame_ids+1] = frame_id
					end
				end
			end
		end
	end
	return FramesWithIntegrated[id]
end

function UIMsg.OnTechResearch(id, notify)
	BaseUnlocks, SeenUnlocks, SeenTech, FramesWithIntegrated = nil, nil, nil, nil -- force refresh everything
	if not notify or not IsShowNotification("tech_complete") then return end
	if not data.techs[id].category then return end -- don't pop up internal techs
	if Action.IsReplayPlayback() then return end -- no popups while playing back replay

	UI.AddLayout("ResearchPopup", { id = id })
end

function UIMsg.OnItemPickup(id)
	SeenUnlocks = nil -- force refresh seen unlocks
end

function UIMsg.OnFactionRespawn()
	SeenUnlocks, SeenTech, FramesWithIntegrated = nil, nil, nil -- force refresh seen unlocks and techs
end

function UIMsg.OnLocalFactionChanged(old_faction, new_faction)
	SeenUnlocks, SeenTech, FramesWithIntegrated, TechsPerCategory = nil, nil, nil, nil -- force refresh seen unlocks and techs
end
