local Codex_layout<const> =
[[
	<HorizontalList child_padding=2>
		<Box bg=popup_additional_bg padding=4>
			<VerticalList child_padding=2>
				<Button text={text} id=jumpbtn y=-3 halign=center hidden=true on_click={on_jump_to_location}/>
				<ScrollList orientation=vertical height=800 width=1024 id=slist>
					<VerticalList halign=center child_padding=5>
						<Text style=header id=mission_status valign=center hidden=true textalign=center/>
					</VerticalList>
					<Video id=video hidden=true width=1024 height=576 halign=center/>
					<Text id=detailtext wrap=true on_link_click={on_link_click}/>
					<VerticalList id=widgetlist/>
				</ScrollList>
			</VerticalList>
		</Box>
		<Box bg=popup_additional_bg padding=4>
			<VerticalList height=800 child_padding=4>
				<TextSearch id=inst_search margin=5 on_refresh={on_filter} width=320/>
				<ScrollList width=320 child_padding=1 orientation=vertical id=list fill=true/>
				<Button text="Mark All Read" on_click={on_mark_all_read}/>
			</VerticalList>
		</Box>
	</HorizontalList>
]]

local CodexButton_layout<const> =
[[
	<Canvas>
		<Button on_click={on_select} halign=fill height=28 text={text} textwrap=true wrapsize=280 textalign=left/>
		<Image id=info width=24 height=24 image=icon_small_warning dock=right hidden={infohidden} margin_right=10/>
	</Canvas>
]]

local Codex<const> = {}
UI.Register("Codex", Codex_layout, Codex)
local codex_collapse = {}
local CodexCategoryOrder =
{
	["Mission"]   = 1,
	["E.L.A.I.N"] = 2,
	["Goals"]     = 3,
	["Codex"]     = 4,
	["How to Play"]  = 5,
}

function Codex:construct()
	local openid, openbtn = self.param or Codex.lastid or "x_tc_controls"

	local headers = {}
	local faction = Game.GetLocalPlayerFaction()
	local read_codex = Game.GetLocalPlayerExtra().read_codex or {}
	local tag = self.limit_tag
	for id, def in pairs(data.codex) do
		local def_category = def.category
		if not CodexCategoryOrder[def_category or 0] then if def_category ~= false then print("Unknown codex category ", def_category, id) end end
		if faction:IsUnlocked(id) and (def.text or def.talkinghead or def.mission_steps or (def.special_tutorials and GetCodexTutorial) or def.special_instructions or def.special_all_unlocks) and (not tag or def[tag]) then
			local cat = def_category or "-"
			local cat_order = (CodexCategoryOrder[cat] or (999 + (Tool.Hash(cat) % 9000)))
			if not headers[cat] then
				headers[cat] = self.list:Add("<Text color=ui_light margin_bottom=5 margin_top=10/>", { text = cat, order = string.format("|%04d", cat_order) })
			end
			local newbutton = self.list:Add(CodexButton_layout, {
				def = def,
				text = def.title, -- .. (def.index or "0"),
				infohidden = read_codex[def.id],
				order = string.format("|%04d%04d%s", cat_order, (def.index or 1), (def.title or "")),
			})
			if openid and openid == def.id then openbtn, openid = newbutton, nil end
		end
	end
	self.list:SortChildren(function(a, b) return a.order < b.order end)
	if tag then openbtn = self.list[2] end -- when filtering by a tag, always open first item
	if openbtn then
		self.list:ScrollIntoView(openbtn)
		self:on_select(openbtn)
		self.slist:SetScrollOffset(((self.scroll ~= nil) and self.scroll) or (self.param and 999999) or Codex.lastscroll or 0)
	end
end

function Codex:destruct()
	Codex.lastscroll = self.slist:GetScrollOffset()
end

function Codex:on_ui_accept()
	UI.CloseMenuPopup(self)
end

function Codex:on_select(btn)
	if self.lastbtn then
		self.lastbtn.x = 0
		self.lastbtn[1].active = false
	end
	local def, showtxt = btn.def
	self.lastbtn = btn
	btn[1].active = true
	self.mission_status.hidden = true
	self.jumpbtn.hidden = true
	Codex.lastid = def.id
	if btn.info then
		btn.info.hidden = true
	end

	self.widgetlist:Clear()

	if def.special_tutorials then
		if TutorialIsActive and TutorialIsActive() then
			showtxt = "Tutorial Currently Active..."
		else
			local s = self
			local tutorial = GetCodexTutorial()
			--local org_show_tutorial = tutorial.ShowTutorial
			self.widgetlist:Add(tutorial)
			tutorial.on_codex = function(a, tut)
				s:on_link_click(nil, tut.codex_id)
			end
		end
	elseif def.mission_steps then
		local faction = Game.GetLocalPlayerFaction()
		local goal_count = def.goal_check(faction) or 0
		local mission_started = goal_count > 0
		local mission_entity = def.mission_get_entity and def.mission_get_entity(faction, goal_count)
		local have_entity = mission_entity and mission_entity.exists or nil
		local location = have_entity and mission_entity.location

		if mission_started then
			local location_text

			if goal_count >= def.steps then
				location_text, goal_count = "MISSION COMPLETE!", def.steps
			else
				location_text = have_entity and def.mission_location_text_exists or def.mission_location_text_destroyed
				if location_text and have_entity then location_text = location and L(location_text, location.x, location.y) end
			end

			if location_text then
				if have_entity then
					self.jumpbtn.hidden = false
					self.jumpbtn.text = location_text
				else
					self.mission_status.hidden = false
					self.mission_status.text = location_text
				end
			end

			local steps = def.mission_steps
			for i=1,math.min(goal_count, #steps) do
				local step = steps[i]
				self.widgetlist:Add('<Image color=ui_light height=4 margin=4/>')
				if step.title then self.widgetlist:Add("<Text style=header textalign=center/>").text = step.title end
				if not step.talkinghead then
					self.widgetlist:Add("<Box bg=popup_box_bg padding=20 margin=10><Text wrap=true/></Box>")[1].text = step.txt
					if step.step_txt then self.widgetlist:Add("<Text style=hl textalign=center wrap=true/>").text = step.step_txt end
				else
					local multi = (type(step.talkinghead) == "table" and step.talkinghead)
					for m=1,(multi and #multi or 1) do
						local head = (multi and multi[m] or step)
						self:AddTalkingHead(head.img, head.txt)
						if head.step_txt then self.widgetlist:Add("<Text style=hl textalign=center wrap=true/>").text = head.step_txt end
					end
				end
			end
		else
			showtxt = "Unknown"
		end
	else
		if def.talkinghead then
			if type(def.talkinghead) == "table" then
				for index,txt in ipairs(def.talkinghead) do
					local tbl = type(txt) == "table" and txt
					self:AddTalkingHead(tbl and tbl.img or def.img, tbl and tbl.txt or txt, (tbl and tbl.sound) or (def.sound and def.sound[index]))
				end
			else
				self:AddTalkingHead(def.img, def.talkinghead, def.sound)
			end
		end
		showtxt = def.text or (not def.talkinghead and "Unknown") or nil
	end

	if def.sections then
		self:build_sections(self.widgetlist, def.sections, 1, 1)
	end
	self.detailtext.text = showtxt
	self.detailtext.hidden = showtxt == nil
	self.detailtext.parent:ScrollToStart()
	self.video.video = def.video
	self.video.hidden = not def.video
	self.video.width = def.video_width or 1024
	self.video.height = def.video_height or 576

	local extra = Game.GetLocalPlayerExtra()
	if not extra.read_codex then extra.read_codex = {} end
	extra.read_codex[def.id] = true
end

function Codex:build_sections(list, sections, n, level)
	local toplevel, sublist = level == 1
	for i=n,#sections do
		local sec = sections[i]
		if (sec.level or 1) < level then return i end
		if (sec.level or 1) > level then
			local sub_level_until = self:build_sections(sublist, sections, i, (sec.level or 1))
			return sub_level_until and self:build_sections(list, sections, sub_level_until, (sections[sub_level_until].level or 1))
		end
		local hdr = list:Add([[<Button on_click={accordion_toggle_block} padding=0><HorizontalList halign=left child_align=center margin_top=0 margin_bottom=0>
				<Image image=icon_small_arrow_down color=#8AFFDC/><Text y=-2/>
			</HorizontalList></Button>]])
		local chevron, title = hdr[1][1], hdr[1][2]
		sublist = list:Add([[<VerticalList hidden=true py=0 sy=0/>]])
		hdr.margin_top = toplevel and 24 or 4
		hdr.color      = toplevel and '#FFFFFFC0' or '#FFFFFF80'
		chevron.width  = toplevel and 32 or 24
		chevron.height = toplevel and 32 or 24
		chevron.angle  = toplevel and -180 or 0
		title.style    = toplevel and "codex_m" or "codex_s"
		sublist.sy     = toplevel and 1 or 0
		sublist.hidden = not toplevel
		sublist.margin_left = level * 20
		title.text = sec.title
		sublist:Add("<Text wrap=true on_link_click={on_link_click} margin_top=4 margin_bottom=8/>").text = sec.text
		if codex_collapse[sec.title] then
			hdr.next_sibling.sy = 0
			hdr.next_sibling.hidden = true
			hdr[1][1].angle = 0
		end
	end
end

function Codex:accordion_toggle_block(hdr)
	local list = hdr.next_sibling
	list.hidden = false
	local up = (list:GetTweenTarget("sy") or list.sy) == 0
	hdr.next_sibling:TweenTo("sy", up and 1 or 0, 250, "OutQuad", not up and function(w) w.hidden = true end)
	hdr[1][1]:TweenTo("angle", up and -180 or 0, 250, "OutQuad")
	if up then
		codex_collapse[hdr[1][2].text] = nil
	else
		codex_collapse[hdr[1][2].text] = true
	end
end

function Codex:on_link_click(txt, link_id)
	for _,lbtn in ipairs(self.list) do
		if lbtn.def and lbtn.def.id == link_id then
			self.list:ScrollIntoView(lbtn)
			self:on_select(lbtn)
			return
		end
	end
end

function Codex:AddTalkingHead(img, txt, snd)
	local hl = self.widgetlist:Add([[
		<HorizontalList halign=center margin=4>
			<Box bg=tech_not_researched_catergory_bg blur=true valign=top y=20>
				<Image image={img} width=160 height=160/>
			</Box>
			<Box bg=popup_box_bg blur=true padding=20>
				<Text id=talkingtext min_height=160 wrap=true width=650 text={txt}/>
			</Box>
		</HorizontalList>
	]])
	hl.img = img or "talking_head"
	if hl.previous_sibling and hl.previous_sibling.img == hl.img then hl[1].opacity = 0 end
	hl.txt = txt
end

function Codex:on_mark_all_read()
	local extra = Game.GetLocalPlayerExtra()
	local read_codex = extra.read_codex
	if not read_codex then read_codex = {} extra.read_codex = read_codex end

	for _,btn in ipairs(self.list) do
		if btn.def and not extra.read_codex[btn.def.id] then
			if btn.info then btn.info.hidden = true end
			read_codex[btn.def.id] = true
		end
	end
end

function Codex:on_jump_to_location()
	local def = self.lastbtn.def
	local faction = Game.GetLocalPlayerFaction()
	local goal_count = def.goal_check(faction) or 0
	local mission_entity = def.mission_get_entity and def.mission_get_entity(faction, goal_count)
	local have_entity = mission_entity and mission_entity.exists or nil
	if have_entity then View.JumpCameraToEntities(mission_entity) end
end

function Codex:on_filter(search, filter)
	if not filter or filter=="" then
		for _,btn in ipairs(self.list) do
			btn.hidden = false
		end
		return
	end

	if filter == "" then filter = nil end
	local MatchLocalizedRichText = filter and Tool.MatchLocalizedRichText
	local faction, last_category_text = filter and Game.GetLocalPlayerFaction()
	for _,btn in ipairs(self.list) do
		local def = filter and btn.def
		if def then
			local show = MatchLocalizedRichText(btn.text or "", filter) or MatchLocalizedRichText(def and def.text or "", filter)

			local sections = not show and def and def.sections
			if sections then
				for i,v in ipairs(sections) do
					show = MatchLocalizedRichText(v.title or "", filter) or MatchLocalizedRichText(v.text or "", filter)
					if show then break end
				end
			end

			local mission_steps = not show and def and def.mission_steps
			if mission_steps then
				local goal_count = def.goal_check(faction) or 0
				local mission_started = goal_count > 0
				if mission_started then
					for i=1,math.min(goal_count, #mission_steps) do
						local step = mission_steps[i]
						if step.title then show = show or MatchLocalizedRichText(step.title, filter) end
						if not step.talkinghead then
							show = show or MatchLocalizedRichText(step.txt or "", filter)
							show = show or MatchLocalizedRichText(step.step_txt or "", filter)
						else
							local multi = (type(step.talkinghead) == "table" and step.talkinghead)
							for m=1,(multi and #multi or 1) do
								local head = (multi and multi[m] or step)
								show = show or MatchLocalizedRichText(head.txt or "", filter)
								show = show or MatchLocalizedRichText(head.step_txt or "", filter)
							end
						end
						if show then break end
					end
				end
			end

			local talkinghead = not show and def and def.talkinghead
			if talkinghead then
				if type(talkinghead) == "table" then
					for _,txt in ipairs(talkinghead) do
						local tbl = type(txt) == "table" and txt
						show = MatchLocalizedRichText(tbl and tbl.txt or txt, filter)
						if show then break end
					end
				else
					show = MatchLocalizedRichText(talkinghead, filter)
				end
			end

			btn.hidden = not show
			if show then last_category_text.hidden = false end
		elseif filter then
			btn.hidden = true
			last_category_text = btn
		else
			btn.hidden = false
		end
	end
end

---------------------------------------------------------------------------------------------------

local milestones_db<const> = {
	{
		type = "ITEM",
		title = "Mine Metal Ore",
		details = "Use a miner component to mine metal ore",
		id = "metalore",
		levels = { 10000, 500000, 1000000 },
		achievement = "MINE_METALORE"
	},
	{
		type = "ITEM",
		title = "Mine Crystal Chunks",
		details = "Use a miner component to mine crystal chunks",
		id = "crystal",
		levels = { 10000, 500000, 1000000 },
		achievement = "MINE_CRYSTAL"
	},
	{
		type = "ITEM",
		title = "Mine Silica Sand",
		details = "Use a miner component to mine silica sand",
		id = "silica",
		levels = { 5000, 50000, 500000 },
	},
	{
		type = "ITEM",
		title = "Mine Laterite Ore",
		details = "Use a laser extractor component to mine laterite ore",
		id = "laterite",
		levels = { 5000, 50000, 500000 },
	},
	{
		type = "ITEM",
		title = "Fabricate Metal Bars",
		details = "Use a fabricator component to fabricate metal bars",
		id = "metalbar",
		levels = { 1000, 10000, 500000 },
	},
	{
		type = "COUNTER",
		title = "Bots Built",
		details = "How many bot units you have produced",
		icon = "Main/textures/icons/values/bot.png",
		counter = "built_bot",
		levels = { 5, 30, 100 },
	},
	{
		type = "COUNTER",
		title = "Buildings Built",
		details = "How many buildings you have built",
		icon = "Main/textures/icons/values/building.png",
		counter = "buildings_built",
		levels = { 10, 50, 200 },
	},
	{
		type = "COUNTER",
		title = "Solve Robot Explorables",
		details = "Visit and solve the challenges on explorables by the robots",
		icon = "Main/textures/icons/values/solved.png",
		counter = "solved_explorable_robot",
		levels = { 5, 10, 100 },
	},
	{
		type = "COUNTER",
		title = "Solved Circuit puzzles",
		details = "Solve Circuit puzzle in ruins",
		icon = "Main/textures/icons/explorablespanel/netwalk/source.png",
		counter = "ExplorableGameNetWalk",
		levels = { 5, 10, 50 },
		hidden = true,
	},
	{
		type = "COUNTER",
		title = "Solved Nine Clicks puzzle",
		details = "Solve Nine Clicks puzzle in ruins",
		icon = "Main/textures/icons/explorablespanel/powerclickpuzzle/powerclickpuzzle-base.png",
		counter = "ExplorableGameNineClicks",
		levels = { 5, 10, 50 },
		hidden = true,
	},
	{
		type = "COUNTER",
		title = "Solved Balance Puzzles",
		details = "Solve Balance puzzle in ruins",
		icon = "Main/textures/icons/alien_text/alien_a.png",
		counter = "ExplorableGameBalance",
		levels = { 5, 10, 50 },
		hidden = true,
	},
	{
		type = "COUNTER",
		title = "Solved Sliding Puzzles",
		details = "Solve Sliding puzzle in ruins",
		icon = "Main/textures/icons/values/number_8.png",
		counter = "ExplorableGameSlide",
		levels = { 5, 10, 50 },
		hidden = true,
	},
	{
		type = "COUNTER",
		title = "Bugs Killed",
		details = "How many alien creatures you've killed",
		icon = "Main/textures/icons/values/bug.png",
		counter = "BugsKilled",
		levels = { 10, 250, 1000 },
		achievement = "BUGS_KILLED",
	},
	{
		type = "COUNTER",
		title = "Satellites launched",
		details = "Launch satellites off the planet",
		icon = "Main/textures/icons/frame/satellite.png",
		counter = "satellites_launched",
		levels = { 1, 10, 100 },
	},
	{
		type = "FIELD",
		title = "Tiles Discovered",
		details = "How many map tiles you've discovered",
		icon = "Main/textures/icons/values/world.png",
		field = "discovered_tiles",
		levels = { 50000, 250000, 1000000 },
		achievement = "WANDERER",
	},
	{
		type = "COUNTER",
		title = "Mothership Repairs",
		details = "How many times the Mothership was repaired",
		icon = "Main/textures/icons/values/mothership_value.png",
		counter = "repaired_mothership",
		levels = { 1, 5, 12 },
		hidden = true,
	},
}

local function GetMilestone(v, faction, counters)
	local count, show
	if v.type == "ITEM" then
		show = faction:IsUnlocked(v.id)
		count = show and faction:GetItemTotals(v.id) or 0
	elseif v.type == "COUNTER" then
		count = counters and counters[v.counter] or 0
		if count == true then count = 1 end
		show = not v.hidden or (count > 0)
	elseif v.type == "FIELD" then
		count = faction[v.field] or 0
		show = not v.hidden or (count > 0)
	end
	return count, show
end

local function IsGoalDone(def, faction)
	local progress = def.goal_check(faction or Game.GetLocalPlayerFaction())
	if type(progress) == "number" then return progress >= (def.steps or 1) end
	return progress
end

local function IsGoalHidden(def, hidden_goals)
	return (hidden_goals or Game.GetLocalPlayerExtra().hidden_goals or {})[def.id]
end

local ProgressNotificationsOpen
local function ShowGoal(id, show)
	local extra = Game.GetLocalPlayerExtra()
	local hidden_goals = extra.hidden_goals or {}
	hidden_goals[id] = not show or nil
	extra.hidden_goals = EmptyTableAsNil(hidden_goals)
	if ProgressNotificationsOpen then ProgressNotificationsOpen:set_goal_visibility(id, show) end
end

---------------------------------------------------------------------------------------------------

local ProgressView_layout<const> =
[[
	<HorizontalList>
		<VerticalList child_padding=4>
			<Box bg=popup_pattern padding=4>
				<VerticalList child_padding=4>
					<HorizontalList child_padding=4>
						<Text id=titletxt text="In Progress" color=ui_light height=24 valign=center fill=true/>
						<Button id=inprogress text="In Progress" active=true disabled=true on_click={select_type}/>
						<Button id=completed text="Completed" on_click={select_type}/>
					</HorizontalList>
					<ScrollList id=list width=596 min_height=100 max_height=874 child_padding=8/>
				</VerticalList>
			</Box>
			<Box bg=popup_additional_bg padding=6>
				<HorizontalList child_fill=true child_padding=4>
					<Button id=btngoals      text="Missions"   on_click={on_switch_tab} active=true disabled=true/>
					<Button id=btnmilestones text="Milestones" on_click={on_switch_tab} active=false disabled=false/>
				</HorizontalList>
			</Box>
		</VerticalList>
	</HorizontalList>
]]

local GoalEntry_layout<const> =
[[
	<Box bg=popup_additional_bg padding=4>
		<Canvas>
			<Image id=hoverimg color=ui_light fill=true opacity=0/>
			<HorizontalList margin=8 child_padding=8>
				<Button id=chkbox valign=center tooltip={checktip} icon={checkicon} active={checkactive} on_click={on_click_goal_toggle}/>
				<Box bg=item_default padding=4 valign=center blocking=false>
					<Image image={icon} width=50 height=50/>
				</Box>
				<VerticalList child_padding=4 valign=center>
					<Text style=hl text={title} wrap=true width=464/>
					<HorizontalList child_align=center child_padding=8>
						<Progress id=bar progress={progress} color=ui_light bg=progress_stroke width=340 height=16/>
						<Text id=txt text={steps}/>
					</HorizontalList>
					<Text text={details} wrap=true width=464/>
				</VerticalList>
			</HorizontalList>
		</Canvas>
	</Box>
]]

local MilestoneEntry_layout<const> =
[[
	<Box bg=popup_additional_bg padding=6>
		<VerticalList child_padding=4>
			<HorizontalList child_padding=4>
				<Reg def_id={reg_item_id} icon={reg_icon} bg=item_default valign=top/>
				<VerticalList fill=true>
					<Text text={title} wrap=true width=340/>
					<Text text={details} wrap=true width=340/>
				</VerticalList>
				<Image color=ui_light tooltip={tooltip1} image={star1}/>
				<Image color=ui_light tooltip={tooltip2} image={star2}/>
				<Image color=ui_light tooltip={tooltip3} image={star3}/>
			</HorizontalList>
			<HorizontalList child_align=center child_padding=8>
				<Progress progress={progress} color=ui_light bg=progress_stroke width=440 height=16/>
				<Text text={steps}/>
			</HorizontalList>
		</VerticalList>
	</Box>
]]

local DoneMilestoneEntry_layout<const> =
[[
	<Box bg=popup_additional_bg padding=6>
		<HorizontalList child_padding=8 child_align=center>
			<Image image=icon_large_medal/>
			<Reg def_id={reg_item_id} icon={reg_icon} bg=item_default/>
			<VerticalList child_padding=4>
				<Text text={title} wrap=true width=420/>
				<Text text={details} wrap=true width=420/>
				<Text text={steps}/>
			</VerticalList>
		</HorizontalList>
	</Box>
]]

local ProgressViewTabIsMilestones
local ProgressView<const> = {}
UI.Register("ProgressView", ProgressView_layout, ProgressView)

function ProgressView:construct()
	if ProgressViewTabIsMilestones and not self.param then
		self:on_switch_tab()
	else
		self:Refresh()
	end
end

function ProgressView:select_type(btn)
	local is_completed = btn.id == "completed"
	self.inprogress.active, self.inprogress.disabled = not is_completed, not is_completed
	self.completed.active, self.completed.disabled = is_completed, is_completed
	self:Refresh()
end

function ProgressView:on_switch_tab()
	local is_milestones = not self.btnmilestones.active
	self.btngoals.active, self.btngoals.disabled = not is_milestones, not is_milestones
	self.btnmilestones.active, self.btnmilestones.disabled = is_milestones, is_milestones
	self:Refresh()
	ProgressViewTabIsMilestones = is_milestones
end

function ProgressView:Refresh()
	self.list:Clear()
	if self.btngoals.active then
		self:ListGoals()
	else
		self:ListMilestones()
	end
	self.titletxt.text = self.completed.active and "Completed" or "In Progress"
end

function ProgressView:ListGoals()
	local faction, hidden_goals = Game.GetLocalPlayerFaction(), Game.GetLocalPlayerExtra().hidden_goals or {}
	local list, show_inprogress, param_id, highlight = self.list, self.inprogress.active, self.param
	for id, def in pairs(data.codex) do
		local show = def.goal_check and faction:IsUnlocked(id)
		local done, hidden = show and IsGoalDone(def, faction), show and hidden_goals[def.id]
		if show and (not done) == show_inprogress then
			local res, steps = def.goal_check(faction), def.steps or 1
			local num = type(res) == "number" and res or not res and 0 or steps
			local step_txt = def.details or def.title
			local step = def.mission_steps and def.mission_steps[num]
			local multi = step and (type(step.talkinghead) == "table" and step.talkinghead)
			local has_codex =  (def.text or def.talkinghead or def.mission_steps)
			if step and not done then
				step_txt = (num and (multi and multi[#multi] or step).step_txt)
			end
			local newentry = list:Add(GoalEntry_layout, {
				goal_def = def,
				icon = def.goalicon,
				title = def.title,
				details = step_txt, -- (res and goal_def.mission_steps and goal_def.mission_steps[num] and goal_def.mission_steps[num].title)
				hidebar = not def.steps,
				progress = num / steps,
				order = string.format("|%04d%04d%s", CodexCategoryOrder[def.category] or 999, (def.index or 1), (def.title or "")),
				steps = string.format("%d / %d", num, steps),
				checktip = def.mission_minimap_pin and "Show on game screen and on minimap" or "Show on game screen",
				checkactive = not hidden,
				checkicon = hidden and "icon_small_empty" or "icon_small_confirm",
				tooltip = has_codex and "Click to view Codex entry",
				on_click = has_codex and function(w) OpenMainWindow("Codex", { param = w.goal_def.id }) end,
				on_mouse_enter = has_codex and function(w) w.hoverimg.opacity = 0.2 end,
				on_mouse_leave = has_codex and function(w) w.hoverimg.opacity = 0 end,
			})
			if done then newentry.chkbox:RemoveFromParent() end
			if def.id == param_id then highlight = newentry end
		end
	end
	list:SortChildren(function(a, b) local p, q = a.progress, b.progress return p > q or (p == q and a.order < b.order) end)
	self.highlight = highlight
	if highlight then self.hl = 1 list:ScrollIntoView(highlight) end
end

function ProgressView:ListMilestones()
	local faction = Game.GetLocalPlayerFaction()
	local counters = faction.extra_data.counters
	local list, show_inprogress = self.list, self.inprogress.active
	for _,v in ipairs(milestones_db) do
		local count, show = GetMilestone(v, faction, counters)
		local done = count >= v.levels[3]
		if show and (not done) == show_inprogress then
			local nextlevel = v.levels[count < v.levels[1] and 1 or (count < v.levels[2] and 2 or 3)]
			list:Add(done and DoneMilestoneEntry_layout or MilestoneEntry_layout, {
				milestone_def = v,
				reg_item_id = v.id,
				reg_icon = v.icon,
				title = v.title,
				details = v.details,
				star1 = count >= v.levels[1] and "icon_achieved" or "icon_achieve",
				star2 = count >= v.levels[2] and "icon_achieved" or "icon_achieve",
				star3 = count >= v.levels[3] and "icon_achieved" or "icon_achieve",
				tooltip1 = L("Reach %d", v.levels[1]),
				tooltip2 = L("Reach %d", v.levels[2]),
				tooltip3 = L("Reach %d", v.levels[3]),
				nextlevel = nextlevel,
				progress = count / nextlevel,
				steps = string.format("%d / %d", count, nextlevel),
			})
		end
	end
end

function ProgressView:update()
	-- flash
	if self.hl then
		if (self.hl % 2) == 0 then self.highlight.bg = "popup_additional_bg"
		else self.highlight.bg = nil
		end
		self.hl = self.hl + 1
		if self.hl == 8 then self.hl = nil end
	end
	local show_inprogress = self.inprogress.active
	if show_inprogress then
		local faction = Game.GetLocalPlayerFaction()
		local counters = faction.extra_data.counters
		for _,w in ipairs(self.list) do
			local goal_def, num, total = w.goal_def
			if goal_def then
				local res = goal_def.goal_check(faction)
				total = goal_def.steps or 1
				num = type(res) == "number" and res or not res and 0 or total
			else
				num, total = GetMilestone(w.milestone_def, faction, counters), w.nextlevel
			end

			if num >= total then
				self:Refresh()
				return
			end
			w.progress = num / total
			w.steps = string.format("%d / %d", num, total)
		end
	end
end

function ProgressView:on_click_goal_toggle(w)
	local show = not w.checkactive
	w.checkactive = show
	w.checkicon = show and "icon_small_confirm" or "icon_small_empty"
	ShowGoal(w.goal_def.id, show)
end

-----------------------------------------------------------------------------------------------------

local ProgressPopup_layout<const> =
[[
	<Box dock=top-left bg=popup_box_bg padding=4 blur=true width=520 y=0>
		<Box bg=popup_pattern padding=4 blocking=false>
			<VerticalList>
				<HorizontalList child_padding=8>
					<Reg width=96 height=96 def_id={reg_item_id} icon={reg_icon} bg=item_default on_click={on_click}/>
					<VerticalList fill=true valign=center>
						<Text size=16 text={header} color=ui_light/>
						<Text size=20 text={title}/>
					</VerticalList>

				</HorizontalList>

				<HorizontalList halign=center child_padding=4 hidden={hide_stars}>
					<Image color=ui_light tooltip={tooltip1} image={star1}/>
					<Image color=ui_light tooltip={tooltip2} image={star2}/>
					<Image color=ui_light tooltip={tooltip3} image={star3}/>
				</HorizontalList>
			</VerticalList>
		</Box>
	</Box>]]

--[[
				<Text text={details} wrap=true wrapsize=400 textalign=center/>

				<Box bg=popup_box_bg halign=right padding=4>
					<Button icon=icon_confirm on_click={on_click}/>
				</Box>
--]]

local ProgressPopupOpen
local function ShowProgressPopup(goal_def, milestone, count)
	if Action.IsReplayPlayback() then return end -- no popups while playing back replay
	if not IsShowNotification("milestone") then return end
	if ProgressPopupOpen then ProgressPopupOpen:RemoveFromParent() end

	local prop
	if goal_def then
		prop = {
			header = "Completed Goal",
			title = goal_def.title,
			--details = goal_def.details,
			reg_icon = goal_def.goalicon,
			hide_stars = true,
		}
	else
		prop = {
			header = "Reached Milestone",
			title = milestone.title,
			--details = milestone.details,
			reg_item_id = milestone.id,
			reg_icon = milestone.icon,
			star1 = count >= milestone.levels[1] and "icon_achieved" or "icon_achieve",
			star2 = count >= milestone.levels[2] and "icon_achieved" or "icon_achieve",
			star3 = count >= milestone.levels[3] and "icon_achieved" or "icon_achieve",
			tooltip1 = L("Reach %d", milestone.levels[1]),
			tooltip2 = L("Reach %d", milestone.levels[2]),
			tooltip3 = L("Reach %d", milestone.levels[3]),
		}
		if milestone.achievement and count >= milestone.levels[3] then
			Game.GetLocalPlayerFaction():UnlockAchievement(milestone.achievement)
		end
	end
	function prop:construct()
		self.timer = 5
		self:TweenFromTo("sy", 0.5, 1, 200, "OutQuad")
		self:TweenFromTo("x", -1000, 0, 200, "OutQuad")
	end
	function prop:on_click()
		self:closepopup()
		ProgressViewTabIsMilestones = not self.hide_stars
		OpenMainWindow("ProgressView")
	end
	function prop:closepopup()
		self.timer = nil
		self:TweenFromTo("sy", 1, 0.5, 200, "InQuad")
		self:TweenFromTo("x", 0, -1000, 200, "InQuad", function() self:RemoveFromParent() end)
		self.on_click = nil
		ProgressPopupOpen = nil
	end
	function prop:every_frame_update(dt)
		if not self.timer then self.every_frame_update = nil return end
		self.timer = self.timer - dt
		if self.timer <= 0.0 then
			self:closepopup()
		end
	end
	ProgressPopupOpen = UI.AddLayout(ProgressPopup_layout, prop)
end

-----------------------------------------------------------------------------------------------------

local ProgressNotify_layout<const> =
[[
	<Box on_click={on_click_goal} height=24 tooltip={goal_tooltip}>
		<Canvas valign=center>
			<Image image={goalicon} dock=left margin_left=2 width=20 height=20 hide_no_image=true/>
			<Text id=check text="✓" dock=left size=18 hidden=true/>
			<Progress progress={progress} dock=fill margin=4 margin_left=22 color=ui_light/>
		</Canvas>
	</Box>
]]

local active_goals<const> = {}
local active_goal_progresses<const> = {}
local function RefreshGoal(faction, goal_id, show_talking_heads)
	local goal_def = data.codex[goal_id]
	if not goal_def then print("Unknown codex", goal_id) return end
	local total, res = goal_def.steps or 1, goal_def.goal_check(faction)
	local old_num = active_goal_progresses[goal_id]
	local new_num = (type(res) == "number" and res) or (not res and 0) or total

	if old_num ~= new_num then
		if old_num == nil then active_goals[#active_goals+1] = goal_id end
		active_goal_progresses[goal_id] = new_num
		if show_talking_heads then
			for i=(old_num or 0)+1,new_num do
				local step = goal_def.mission_steps and goal_def.mission_steps[i]
				if not step then break end
				if not step.irrelevant_on_skip or i == new_num then
					local multi = (type(step.talkinghead) == "table" and step.talkinghead)
					for m=1,(multi and #multi or 1) do
						PlayTalkingHead((multi and multi[m] or step), goal_id)
					end
				end
			end
		end
		local w = ProgressNotificationsOpen and ProgressNotificationsOpen[goal_id]
		if w then
			w.progress = new_num / total
			ProgressNotificationsOpen:update_visibilities()
		elseif new_num < total and ProgressNotificationsOpen and not IsGoalHidden(goal_def, Game.GetLocalPlayerExtra().hidden_goals or {}) then
			w = ProgressNotificationsOpen:add_entry(goal_id)
		end

		if new_num >= total then
			if w then
				w.goalicon = nil
				w.check.hidden = false
				w.check:TweenFromTo("sx",      0, 1, 1000, "OutBack")
				w.check:TweenFromTo("sy",      0, 1, 1000, "OutBack")
				w.check:TweenFromTo("angle", 180, 0, 1000, 500, "OutBack", function() ProgressNotificationsOpen:close(w) end)
			end
			-- ShowProgressPopup(check_goal_def)
			for i,v in ipairs(active_goals) do if v == goal_id then table.remove(active_goals, i) break end end
			active_goal_progresses[goal_id] = nil
		end
	end
end

local entity_missions = {}
local ProgressCheckCount = 0
local ProgressNotifications<const> = {}
UI.Register("ProgressNotifications", "<VerticalList/>", ProgressNotifications)

function ProgressNotifications:construct()
	ProgressNotificationsOpen = self
	self:refresh()
end

function ProgressNotifications:destruct()
	ProgressNotificationsOpen = nil
end

function ProgressNotifications:refresh(is_tutorial_end)
	for _,w in ipairs(self) do self:close(w) end
	for k in next, active_goals do active_goals[k] = nil end
	for k in next, active_goal_progresses do active_goal_progresses[k] = nil end
	for k,v in next, entity_missions do v = v.map_pin_idx if v then UI.FindWidgetWithTag("Minimap"):RemovePin(v) end entity_missions[k] = nil end
	if TutorialIsActive and not is_tutorial_end and TutorialIsActive() then return end

	local faction = Game.GetLocalPlayerFaction()
	if not faction then return end

	for id, def in pairs(data.codex) do
		if def.goal_check and faction:IsUnlocked(id) then
			RefreshGoal(faction, id)
		end
		if def.mission_get_entity then
			entity_missions[#entity_missions+1] = { def = def }
		end
	end

	local counters = faction.extra_data.counters
	for _,v in ipairs(milestones_db) do
		v.last_value = GetMilestone(v, faction, counters)
	end
end

function ProgressNotifications:every_frame_update()
	local faction = Game.GetLocalPlayerFaction()
	local n = ProgressCheckCount
	ProgressCheckCount = ProgressCheckCount + 1

	local active_goal_idx = (#active_goals > 0) and (1 + (n % #active_goals))
	local check_goal_id = active_goals[active_goal_idx]
	if check_goal_id then
		RefreshGoal(faction, check_goal_id, true)
	end

	local check_mission = entity_missions[#entity_missions > 0 and (1 + (n % #entity_missions))]
	if check_mission then
		local def = check_mission.def
		local goal_count = def.goal_check(faction) or 0
		local mission_started, mission_cleared = goal_count > 0 or nil, goal_count >= def.steps
		local mission_entity = def.mission_get_entity(faction, goal_count)
		local first_check = not check_mission.checked
		local have_entity = mission_entity and mission_entity.exists or nil
		local want_notify_func = def.mission_want_notify
		local want_notify = have_entity and ((not want_notify_func and not mission_cleared) or (want_notify_func and want_notify_func(faction, mission_entity, goal_count)))
		local location = have_entity and mission_entity.location or check_mission.location
		if have_entity then check_mission.location = location end
		if first_check then check_mission.checked = true end

		local have_entity_changed = check_mission.have_entity ~= have_entity
		if have_entity_changed or check_mission.started ~= mission_started then
			check_mission.have_entity = have_entity
			check_mission.started = mission_started

			-- Show notification if we haven't started the mission yet or if there is an entity again after it was lost
			local notify = not mission_started or (want_notify and have_entity_changed and not first_check)
			if notify and location and not IsGoalHidden(def) then
				if not IsShowNotification("mission") then return end
				local notification_title = (have_entity and def.mission_start_notification_title or def.mission_lost_notification_title)
				local notification_text = (have_entity and def.mission_start_notification_text or def.mission_lost_notification_text)
				Notification.Add(def.id, "mission", notification_title, L(notification_text, location.x, location.y), {
					tooltip = def.category,
					on_click = have_entity and function() View.JumpCameraToEntities(mission_entity) end
						or function() View.MoveCamera(location.x, location.y) end,
				})
			else
				Notification.Clear(def.id)
			end
		end

		local minimap = UI.FindWidgetWithTag("Minimap")
		local pin_idx, map_pin, get_pin = check_mission.map_pin_idx, def.mission_minimap_pin, def.mission_get_minimap_pin
		if ((map_pin or get_pin) and have_entity) or pin_idx then
			local showpin = want_notify and not IsGoalHidden(def) and IsShowNotification("mission_pins")
			local image = showpin and ((mission_started and (get_pin and get_pin(faction, goal_count) or map_pin)) or "Main/skin/Assets/mission_pin.png") or nil
			if image ~= check_mission.map_pin_image then
				check_mission.map_pin_image = image
				if image and pin_idx then minimap:RemovePin(pin_idx) pin_idx = nil end
			end
			if pin_idx and location and image then
				minimap:MovePin(pin_idx, location.x, location.y)
			elseif location and image then
				check_mission.map_pin_idx = minimap:AddPin(location.x, location.y, image)
			elseif pin_idx then
				minimap:RemovePin(pin_idx)
				check_mission.map_pin_idx = nil
			end
		end
	end

	local counters = faction.extra_data.counters
	local check_milestone_idx = (1 + (n % #milestones_db))
	local check_milestone = milestones_db[check_milestone_idx]
	if check_milestone then
		local count, show = GetMilestone(milestones_db[check_milestone_idx], faction, counters)
		local old_count = check_milestone.last_value or 0
		if show and count ~= old_count then
			check_milestone.last_value = count
			for i,v in ReverseIPairs(check_milestone.levels) do
				if old_count < v and count >= v then
					ShowProgressPopup(nil, check_milestone, v)
					break
				end
			end
		end
	end
end

function ProgressNotifications:update_visibilities()
	self:SortChildren(function(a, b) local p, q = a.progress, b.progress return p > q or (p == q and a.order < b.order) end)
	for i,w in ipairs(self) do
		w.hidden = i > 3
	end
end

function ProgressNotifications:add_entry(id)
	if not IsShowNotification("mission_progress") then return end
	local def = data.codex[id]
	if not def.goal_check then error() end

	local total, res = def.steps or 1, def.goal_check(Game.GetLocalPlayerFaction())
	local num = (type(res) == "number" and res) or (not res and 0) or total
	local w = self:Add(ProgressNotify_layout, {
		id = id,
		def = def,
		goalicon = def.goalicon,
		progress = num / total,
		order = string.format("|%04d%04d%s", CodexCategoryOrder[def.category] or 999, (def.index or 1), (def.title or "")),
	})
	self:update_visibilities()
	w:TweenFromTo("sy", 0, 1, 150)
	w:TweenFromTo("height", 0, w.height, 150)
	self[id] = w
	return w
end

function ProgressNotifications:close(w)
	if not w.on_click then return end
	self[w.id] = nil
	w.on_click = nil
	w:TweenFromTo("height", w.height, 0, 150)
	w:TweenTo("sy", 0, 150, function()
		w:RemoveFromParent()
		self:update_visibilities()
	end)
end

function ProgressNotifications:goal_tooltip(w)
	local def = w.def
	local total, res = def.steps or 1, def.goal_check(Game.GetLocalPlayerFaction())
	local num = (type(res) == "number" and res) or (not res and 0) or total
	local step = def.mission_steps and def.mission_steps[num]
	local multi = step and (type(step.talkinghead) == "table" and step.talkinghead)
	local step_txt = step and (multi and multi[#multi] or step).step_txt
	return L("<hl>%s: %s</>\n%s: %d / %d\n%s\n\n%s", def.category, def.title or def.id, "Progress", num, total, step_txt or def.details or "", "Click for more details")
end

function ProgressNotifications:on_click_goal(w, mousebtn)
	if mousebtn == "LEFTMOUSEBUTTON" and w.check.hidden then
		if w.def.text or w.def.talkinghead or w.def.mission_steps then
			OpenMainWindow("Codex", { param = w.id })
		else
			OpenMainWindow("ProgressView", { param = w.id })
		end
	elseif mousebtn == "RIGHTMOUSEBUTTON" and w.check.hidden then
		local faction = Game.GetLocalPlayerFaction()
		local goal_count = w.def.goal_check(faction) or 0
		local mission_entity = w.def.mission_get_entity and w.def.mission_get_entity(faction, goal_count)
		local have_entity = mission_entity and mission_entity.exists or nil

		UI.MenuPopup([[<Box padding=5><VerticalList>
				<Button text="Jump to Location" id=jumpbtn hidden=true on_click={on_jump_location}/>
				<Button text="Show in Codex" id=codex on_click={on_codex}/>
				<Button text="Show in Progress" on_click={on_progress}/>
				<Button text="Hide" on_click={on_hide}/>
			</VerticalList></Box>]], {
			construct = function(menu)
				menu.codex.hidden = not (w.def.text or w.def.talkinghead or w.def.mission_steps)
				if have_entity then menu.jumpbtn.hidden = false end
				menu:TweenFromTo("sy", 0, 1, 100)
			end,
			update = function()
				if not w:IsValid() or not w.check.hidden then UI.CloseMenuPopup() end
			end,
			on_codex = function()
				OpenMainWindow("Codex", { param = w.id })
			end,
			on_progress = function()
				OpenMainWindow("ProgressView", { param = w.id })
			end,
			on_jump_location = function()
				if have_entity then View.JumpCameraToEntities(mission_entity) UI.CloseMenuPopup() end
			end,
			on_hide = function()
				ShowGoal(w.id, false)
				UI.CloseMenuPopup()
			end,
		}, w, "DOWN")
	end
end

function ProgressNotifications:set_goal_visibility(id, show)
	for _,w in ipairs(self) do
		if w.id == id then
			self:close(w)
		end
	end
	if show and (not TutorialIsActive or not TutorialIsActive()) then
		self:add_entry(id)
	end
end

function UIMsg.OnCodexUnlocked(id)
	local def = data.codex[id]
	if def.talkinghead then
		if type(def.talkinghead) == "table" then
			for index,txt in ipairs(def.talkinghead) do
				local tbl = type(txt) == "table" and txt
				PlayTalkingHead({ img = tbl and tbl.img or def.img, style = tbl and tbl.style, txt = tbl and tbl.txt or txt, snd = tbl and tbl.sound or def.sound and def.sound[index] }, id)
			end
		else
			PlayTalkingHead({ img = def.img, txt = def.talkinghead, snd = def.sound }, id)
		end
	end

	if TutorialIsActive and TutorialIsActive() then return end

	if def.goal_check then
		RefreshGoal(Game.GetLocalPlayerFaction(), id, true)
	end
end

function UIMsg.OnLocalFactionChanged(old_faction, new_faction)
	RefreshGoals()
end

function UIMsg.OnFactionRespawn(faction)
	RefreshGoals()
end

function RefreshGoals(is_tutorial_end, specific_codex_id)
	if specific_codex_id then
		RefreshGoal(Game.GetLocalPlayerFaction(), specific_codex_id, true)
	elseif ProgressNotificationsOpen then
		ProgressNotificationsOpen:refresh(is_tutorial_end, specific_codex_id)
	end
end
