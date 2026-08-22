-- arg - { 'in'/'out'/'exec', name(string), desc (string), filter (instruction_argument_filters), is extra param (bool)}
-- a op func returning true means the instruction has put the behavior component into waiting state and we get activated again once that finishes
--[=[
data.instructions.<instruction_id> = {
	-- Main logic executed when the instruction runs
	func = function(comp, state, cause, ...)
		-- Implementation here
		-- You can use helper functions like Get, Set, GetNum, GetEntity, etc.
		-- Return true if the instruction yields/waits
	end,
	-- (Optional) function to generate an additional argument which will be passed to func after cause
	make_asm = function(inst)
		-- i.e. return inst.c or 1
	end,

	-- (Optional) Additional execution control
	next = function(comp, state, it, ...)
		-- For loop/iterator instructions
	end,
	last = function(comp, state, it, ...)
		-- Cleanup or jump after loop ends
	end,

	-- (Optional) Extra argument definition for execution path branching
	exec_arg = { index, "Label", "Description", },

	-- (Optional) List of arguments (inputs, outputs, execution branches)
	args = {
		{ 'in',  "Input Name",  "Description", filter?, expanded? },
		{ 'out', "Output Name", "Description", nil?, expanded?},
		{ 'exec',"Exec Path",   "Description", nil?, expanded? },
	},

	-- (Optional) UI customization for the node editor
	node_ui = function(canvas, inst, program_ui)
		-- Add buttons, combos, text, etc.
		-- Return height (number of pixels) for the node UI
	end,

	-- Metadata
	name     = "Instruction Name",
	desc     = "Short description of what this does",
	category = "Flow | Logic | Loops | Values | Units | Movement | Inventory | Logistics | Components | Production | Communication | World | Memory | AutoBase",
	icon     = "path/to/icon.png",
	altnames = { "Alternative", "List", "For", "Search", }, -- Optional

	-- (Optional) Extended explanation (supports markup and inline images)
	explain  = [[Detailed explanation
	Include what the instruction reads and writes, when each branch runs, what
	happens with empty or invalid inputs, whether the instruction waits or loops,
	and any component/range/visibility requirements.
	<hl>Highlighted text</>
	<img image="path/to/example.png"/>]],

	-- (Optional) Sample encoded string for serialization/examples
	sample   = "encoded_sample_data_string",
}
--]=]
data.instructions = {}
data.instruction_color = {
	Flow = 'white',
	Logic = 'light_red',
	Loops = 'light_blue',
	Values = 'green',
	Units = 'yellow',
	Movement = 'orange',
	Inventory = 'cyan',
	Logistics = 'light_green',
	Components = 'blue',
	Production = 'light_purple',
	Communication = 'purple',
	World = 'yellow',
	Memory = 'light_red',
	AutoBase = 'light_blue',
}

local function GetStack(state, i)
	if not i then return end
	local stk = state.stk
	if type(stk) ~= "table" then
		if i > stk then return i - stk, true end
		return i
	end

	local up = 0
	::nextup::
	if i >= #stk then
		--print("    Sub accessing sub memory (" .. i .. " - " .. stk[1] .. ") = " .. (i - stk[1]), state.mem[i - stk[1]])
		return i - stk[1], true
	end
	if i < 0 then
		--print("    Sub accessing frame register " .. i)
		return i
	end
	--print("    Sub accessing parent stack of return #" .. (#state.returns - (up or 0)) .. ": " .. i  .. " ==> " .. tostring(stk[i + 1]))
	i = stk[i + 1]
	if not i then return end
	local returns = state.returns
	stk = returns[#returns - up][2]
	if type(stk) == "table" then
		up = up + 1
		goto nextup
	end
	if i > stk then
		--print("    Sub accessing main memory (" .. i .. " - " .. stk .. ") = " .. (i - stk), state.mem[i - stk])
		return i - stk, true
	end
	--print("    Sub accessing behavior parameter " .. tostring(i))
	return i
end

local GetCachedBehaviorAsm, GetFactionBehaviorAsm, GetFactionBehaviorAsmById = GetCachedBehaviorAsm, GetFactionBehaviorAsm, GetFactionBehaviorAsmById

local function CallRadio(fn, comp, state, j, i, setval)
	-- Simplified lookup of parents of subbehaviors (no need to check all cases because GetStack has returned < -99)
	local stkrevid = i < 0 and state.revid
	if not stkrevid then -- sub behavior writing to out param
		local returns, stk, up = state.returns, state.stk, 0
		::nextup::
		i = stk[i + 1]
		if i >= 0 then
			stk = returns[#returns - up][2]
			up = up + 1
			goto nextup
		end
		stkrevid = returns[#returns - up][1] -- might not be cached so also use GetFactionBehaviorAsm below
	end
	local fregs = (GetCachedBehaviorAsm(stkrevid) or GetFactionBehaviorAsm(comp.faction, stkrevid)).fregs
	local radio_storage = comp.faction.extra_data.radio_storage
	local radio_storage_names = radio_storage and radio_storage.extra_data.names
	local idx = radio_storage_names and radio_storage_names[fregs and fregs[-99 - j]]
	if not idx then return (fn == 'GetRegister' and Tool.NewRegisterObject()) or (fn == 'GetRegisterNum' and 0) or nil end
	if fn ~= 'SetRegister' or not radio_storage:RegisterIsLink(idx) then return radio_storage[fn](radio_storage, idx, setval) end
end

-- Global functions that can also be used by mods
function InstGet(comp, state, i)
	local j, inmem = GetStack(state, i)
	if not j then return Tool.NewRegisterObject() end
	if inmem then return state.mem[j] end
	if j > 0 then return comp:GetRegister(j) end
	if j >= -99 then return comp.owner:GetRegister(-j) end
	return CallRadio('GetRegister', comp, state, j, i)
end

function InstGetNum(comp, state, i)
	local j, inmem = GetStack(state, i)
	if not j then return 0 end
	if inmem then return state.mem[j].num end
	if j > 0 then return comp:GetRegisterNum(j) end
	if j >= -99 then return comp.owner:GetRegisterNum(-j) end
	return CallRadio('GetRegisterNum', comp, state, j, i)
end

function InstGetCoord(comp, state, i)
	local j, inmem = GetStack(state, i)
	if not j then return nil end
	if inmem then return state.mem[j].coord end
	if j > 0 then return comp:GetRegisterCoord(j) end
	if j >= -99 then return comp.owner:GetRegisterCoord(-j) end
	return CallRadio('GetRegisterCoord', comp, state, j, i)
end

function InstGetId(comp, state, i)
	local j, inmem = GetStack(state, i)
	if not j then return nil end
	if inmem then return state.mem[j].id end
	if j > 0 then return comp:GetRegisterId(j) end
	if j >= -99 then return comp.owner:GetRegisterId(-j) end
	return CallRadio('GetRegisterId', comp, state, j, i)
end

function InstGetEntity(comp, state, i)
	local j, inmem = GetStack(state, i)
	if not j then return nil end
	if inmem then return state.mem[j].entity end
	if j > 0 then return comp:GetRegisterEntity(j) end
	if j >= -99 then return comp.owner:GetRegisterEntity(-j) end
	return CallRadio('GetRegisterEntity', comp, state, j, i)
end

function InstSet(comp, state, i, val)
	local j, inmem = GetStack(state, i)
	if not j then return end
	if inmem then state.mem[j]:Init(val) return end
	if j > 0 then comp:SetRegister(j, val) return end
	if j >= -99 then comp.owner:SetRegister(-j, val) return end
	CallRadio('SetRegister', comp, state, j, i, val)
end

function InstError(comp, state, err, is_after_step)
	comp.faction:RunUI(function()
		local entity = comp.owner
		Notification.Add("notify_behavior", comp.def.texture, "Behavior", err, {
			on_click = function() View.SelectEntities(entity) View.FollowEntity(entity) end,
		})
	end)
	if not is_after_step then state.counter = state.lastcounter end -- step back
	state.debug = "PAUSE" -- switch into debug mode to stay at failed instruction in editor
	return true
end

function InstUnrollReturns(state)
	local returns = state.returns
	if returns and #returns > 0 then
		-- unroll block and return stacks and reset program counter
		local mem, old_counter, mem_count = state.mem
		state.revid, state.stk, old_counter, mem_count = table.unpack(returns[1])
		table.move(mem, #mem+1, #mem+#mem-mem_count, mem_count+1) -- trim to mem_count
		table.move(returns, #returns+1, #returns+#returns, 1) -- trim to 0
		return true
	end
end

function InstBeginBlock(comp, state, it, array_step)
	local next_counter, loop_inst_idx = state.counter, state.lastcounter
	local inst = GetCachedBehaviorAsm(state.revid)[loop_inst_idx]
	local op = data.instructions[inst[1]]
	if array_step and not state.counter and #it > 1 then -- no loop body, skip to end
		it[1] = #it + 1 - array_step
	end
	if op.next and op.next(comp, state, it, table.unpack(inst, 3)) then
		op.last(comp, state, it, table.unpack(inst, 3))
	else
		local blocks = state.blocks
		if not blocks then blocks = {} state.blocks = blocks end
		if #blocks >= 40 then return InstError(comp, state, "Behavior exceeded loop recursion limit") end
		blocks[#blocks + 1] = { next_counter, loop_inst_idx, it, state.returns and #state.returns or 0 }
	end
end

function InstTriggerEvent(ev_comp)
	local ev_ed = ev_comp.extra_data
	local comp = ev_ed.owner
	if not comp then Map.Defer(function() if ev_comp.exists then ev_comp:Destroy() end end) return end
	local state = comp.extra_data
	if not comp.is_active or (state.debug ~= nil and state.debug ~= 'BREAKPOINT') then return end -- don't trigger while paused
	local blocks = state.blocks
	local block_inst_idx, ev_inst_idx = blocks and blocks[1] and blocks[1][4] == 0 and blocks[1][2], ev_ed.inst_idx
	if block_inst_idx == ev_inst_idx then return end -- don't trigger same event twice
	local asm = GetFactionBehaviorAsm(comp, state.returns and state.returns[1] and state.returns[1][1] or state.revid)
	if not asm then return end -- don't trigger already modified behavior
	local block_inst_def = block_inst_idx and asm[block_inst_idx] and data.instructions[asm[block_inst_idx][1]]
	if block_inst_def and block_inst_def.event_setup then return end -- don't trigger while another event is running
	if not blocks then blocks = {0} state.blocks = blocks else table.move(blocks, #blocks+1, #blocks+#blocks-1, 2) end -- trim to 1
	blocks[1] = { 1, ev_inst_idx, false, 0 }
	local inst = asm[ev_inst_idx]
	state.counter = (inst and inst[2] or false)
	if InstUnrollReturns(state) then state.lastcounter = 1 end -- so program editor doesn't highlight the wrong instruction
	local ev_inst_def = data.instructions[inst and inst[1]]
	local event_trigger = ev_inst_def and ev_inst_def.event_trigger
	if event_trigger then event_trigger(comp, state, ev_comp, table.unpack(inst, 3)) end
	if state.breakpoints and state.breakpoints[(asm.code.id << 16) | (state.counter or 1)] then state.debug = 'BPHIT' end
	comp:Activate()
end

-- Local references for shorter names and avoiding global lookup on every use
local Get, GetNum, GetCoord, GetId, GetEntity, Set, BeginBlock = InstGet, InstGetNum, InstGetCoord, InstGetId, InstGetEntity, InstSet, InstBeginBlock

-- Filter function for register selection when setting constant input value in behavior editor
data.instruction_argument_filters = {
	any          = function(def, cat) return not cat.entity_panel end, -- any value including negative numbers
	data         = function(def, cat) return not cat.entity_panel and not cat.number_panel end, -- any data value (no numbers)
	entity       = function(def, cat) return false end, -- no register selection, just registers/parameters/variables
	posnum       = function(def, cat) return cat.number_panel end, -- just positive number
	posinfnum    = function(def, cat) return cat.number_panel or cat.allow_infinite end, -- positive number or infinite
	num          = function(def, cat) return cat.number_panel or cat.allow_negative or cat.allow_infinite or cat.allow_not end, -- just number
	coord        = function(def, cat) return cat.coord_panel end, -- coord
	coord_num    = function(def, cat) return cat.number_panel or cat.allow_negative or cat.coord_panel or cat.allow_infinite or cat.allow_not end, -- number or coord
	item         = function(def, cat) return cat.tab == 'item' end, -- item tab only
	item_num     = function(def, cat) return cat.tab == 'item' or cat.number_panel  or cat.allow_negative or cat.allow_infinite or cat.allow_not end,
	comp         = function(def, cat) return def.attachment_size end, -- component item
	comp_num     = function(def, cat) return def.attachment_size or cat.number_panel end,
	frame        = function(def, cat) return cat.tab == 'frame' end, -- frame tab only
	frame_num    = function(def, cat) return cat.tab == 'frame' or cat.number_panel end,
	frame_item   = function(def, cat) return cat.tab == 'frame' or cat.tab == 'item' end,
	radar        = function(def, cat) return cat.number_panel or cat.allow_negative or cat.allow_infinite or cat.allow_not or cat.tab == 'item' or cat.tab == 'frame' or def.tag == 'entityfilter' end,
	resource_num = function(def, cat) return def.tag == 'resource' or cat.number_panel or cat.allow_negative or cat.allow_infinite or cat.allow_not end,
	tech         = function(def, cat) return cat.is_tech end,
}

-- dummy instruction used as a replacement in the editor when an instruction gets removed from the definitions
data.instructions.nop =
{
	func = function() end,
	args = { },
	name = "Invalid Instruction",
	desc = "Instruction has been removed, behavior needs to be updated",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
	explain = [[Invalid Instruction - likely a deprecated function was replaced with this node.]],
}

data.instructions.cmt =
{
	func = function(comp, state) state.counter = false end,
	exec_arg = false,
	name = "Comment",
	desc = "Freestanding comment node",
	category = "Flow",
	icon = "icon_small_empty",
	explain = [[Adds a note to the behavior graph without running any gameplay action.

Comment nodes are for organizing larger behaviors. They do not continue execution through a normal output pin.]],
}

local function GetSeenEntityOrSelf(comp, state, ent)
	if not ent then return comp.owner end
	ent = GetEntity(comp, state, ent)
	return ent and comp.faction:IsSeen(ent) and ent or nil
end

local function GetAllyEntityOrSelf(comp, state, ent)
	if not ent then return comp.owner end
	ent = GetEntity(comp, state, ent)
	return ent and (ent.faction:IsAlly(comp) or (ent.lootable and comp.faction:IsSeen(ent))) and ent or nil
end

local function GetAdjacentFactionEntityOrSelf(comp, state, ent)
	if not ent then return comp.owner end
	ent = GetEntity(comp, state, ent)
	if not ent then return end
	local faction = comp.faction
	if ent.faction ~= faction or ent.is_construction then return end
	if ent:IsTouching(comp) then return ent end

	if comp.def.key == 'autobase' then
		-- must be in same logistics network
		local grid_owner = faction:GetPowerGridIndexAt(comp)
		local grid_other = faction:GetPowerGridIndexAt(ent)
		return grid_owner and grid_owner == grid_other and ent
	end
end

local function GetSourceNode(state)
	return GetCachedBehaviorAsm(state.revid).code[state.lastcounter]
end

local function GetComponentFromIndex(comp, state, comp_index, fallback_compid, other_owner, query_base_id)
	local id = (comp_index and GetId(comp, state, comp_index)) or (fallback_compid and GetId(comp, state, fallback_compid))
	local index = (comp_index and GetNum(comp, state, comp_index) or 0)

	-- If using default component index (0) and looking for a component matching the behavior controller, return itself
	if index == 0 and not query_base_id and id == comp.id and (not other_owner or other_owner == comp.owner) then return comp, id end

	-- Get the UI listed order and not equipped component order
	return id and (other_owner or comp.owner):FindComponent(id, query_base_id, (index == 0 and 1 or index), true), id
end

local function NodeUICombo(canvas, inst, program_ui, texts, default, tips, show_extra)
	local c, def = (inst.c or default or 1), (default or 1)
	if show_extra == false and c == def then return 0, true, true end
	local change = function(_, v) if (v or def) ~= c then inst.c, c = (v ~= def and v or nil), v program_ui:Refresh() end end
	canvas:Add("<Combo y=30 halign=fill margin=10/>", { on_change = change, texts = texts, tips = tips or texts, value = c })
	return 34, show_extra ~= nil, show_extra ~= nil and c == def
end

local function MakeASMInstCOrOne(inst) return inst.c or 1 end

local function PopupMenu(next_to, glowbtn, direction, width, on_set, texts, values, tips)
	local popargs = { destruct = function() glowbtn.active = false end, width = width, on_select = function(cmbpop, cmbbtn)
		local val = values[cmbbtn.text]
		if (type(val) ~= "table") then UI.CloseMenuPopup() on_set(val) return end
		PopupMenu(cmbbtn, cmbbtn, 'RIGHT', nil, on_set, val, values, tips) -- submenu
	end }
	local pop = UI.MenuPopup("<Box bg=popup_box_bg blur=true padding=6><ScrollList child_padding=3 id=list/></Box>", popargs, next_to, direction, 'TOP', 0, 1)
	if not pop then return end
	glowbtn.active = true
	for i=1,#texts do
		local btn, txt = pop.list:Add('<Button on_click={on_select}/>'), texts[i]
		btn.text, btn.tooltip, btn.icon = txt, tips and tips[txt], type(values[txt]) == "table" and "icon_small_input" or nil
	end
end

local comparison_menu = { "Smart Match", "Number Match", "Bit Mask Match", "Other" }
local comparison_values = {
	["Smart Match"] = 1,
	["Number Equal"] = 2, ["Number Not Equal"] = 3, ["Number Less Than"] = 4, ["Number Less Than or Equal"] = 5, ["Number Greater Than"] = 6, ["Number Greater Than or Equal"] = 7,
	["Any Bit Match"] = 8, ["All Bits Match"] = 9, ["No Bits Match"] = 10, ["Not All Bits Match"] = 11,
	["Fully Equal"] = 12, ["Fully Not Equal"] = 13, ["Data Equal"] = 14, ["Data Not Equal"] = 15, ["Destroyed Reference"] = 16, ["Existing Reference"] = 17,
	-- sub menus
	["Number Match"] = { "Number Equal", "Number Not Equal", "Number Less Than", "Number Less Than or Equal", "Number Greater Than", "Number Greater Than or Equal" },
	["Bit Mask Match"] = { "Any Bit Match", "All Bits Match", "No Bits Match", "Not All Bits Match" },
	["Other"] = { "Fully Equal", "Fully Not Equal", "Data Equal", "Data Not Equal", "Destroyed Reference", "Existing Reference" },
}
local comparison_tips = {
	["Smart Match"] = "Matches target reference with a radar filter, matches data part if set, or anything",
	["Number Match"] = "Smart matching with additional number comparison",
	["Bit Mask Match"] = "Smart matching with additional number comparison",
	["Fully Equal"] = "Matches fully equal values",
	["Data Equal"] = "Matches when the data parts are the same",
	["Destroyed Reference"] = "Matches destroyed target reference",
}

local function NodeUIComparison(canvas, inst, program_ui, show_extra, instkey)
	local c = math.abs(inst[instkey or 'c'] or 1)
	if show_extra == false and c == 1 then return 0, true, true end
	canvas:Add('<Text text="Comparison Mode" style=bl y=26 halign=fill margin=10/>')
	local text
	for k,v in pairs(comparison_values) do if v == c then text = k break end end
	local function on_set(v) if v ~= c then inst[instkey or 'c'], c = (v ~= 1 and v or nil), v program_ui:Refresh() end end
	local function on_dropdown(cmb) PopupMenu(cmb, cmb.drp, 'DOWN', select(3, cmb:GetViewportPosition()), on_set, comparison_menu, comparison_values, comparison_tips) end
	canvas:Add("<Combo y=50 halign=fill margin=10/>", { texts = { text }, tips = { comparison_tips[text] or text }, on_dropdown = on_dropdown })
	return 54, show_extra ~= nil, c == 1
end

local function ConvertShiftVarArgs(inst, start, shift)
	local nums
	for k,v in pairs(inst) do if type(k) == "number" and k >= start then nums = nums or {} nums[k] = v end end
	if not nums then return end
	for k,v in pairs(nums) do inst[k] = nil end
	for k,v in pairs(nums) do inst[k+shift] = v end
end

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- FLOW -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

local function call_var_args(inst_def, inst, code, library)
	local sub_code, arg_defs = inst.sub == 0 and code or (library and library[inst.sub]), inst_def.args
	local parameters, is_call, res = sub_code and sub_code.parameters, inst.op == 'call'
	if parameters then
		local pnames = sub_code and sub_code.pnames
		for i,v in ipairs(parameters) do
			if not res then res = arg_defs and table.move(arg_defs, 1, #arg_defs, 1, {}) or {} end -- shallow copy
			res[#res+1] = { is_call and v and 'out' or 'in', pnames and NOLOC(pnames[i]) or (is_call and v and "Output" or "Input") }
		end
	end
	if is_call and sub_code then
		for _,v in ipairs(sub_code) do
			if v.branch and v.op == "ret" then
				local namestr = NOLOC(v.branch)
				if res then for i=(arg_defs and #arg_defs+1 or 1),#res do if res[i][2] == namestr then goto seen end end end
				if not res then res = arg_defs and table.move(arg_defs, 1, #arg_defs, 1, {}) or {} end -- shallow copy
				res[#res+1] = { 'exec', namestr }
				::seen::
			end
		end
	end
	return res or arg_defs
end

local function call_ui(canvas, inst, program_ui)
	local sub_code = inst.sub == 0 and program_ui.code or program_ui.library[inst.sub]
	canvas:Add('<Text halign=fill y=34 textalign=center style=bl/>').text = (inst.op == 'call' and "Subroutine" or "Behavior")
	canvas:Add('<Text halign=fill y=60 textalign=center margin_left=4 margin_right=4 clip=true/>', { text = sub_code and (NOLOC(sub_code.name) or "New Behavior") or "none" })
	if sub_code and inst.sub and inst.sub ~= 0 and inst.sub ~= program_ui.code.id then
		canvas:Add('<Button halign=fill y=88 margin_left=104 margin_right=10 text="Edit"/>', {
			on_click = function()
				local edit_code = program_ui.library[inst.sub]
				if not edit_code then return end
				program_ui[1]:Add("Program", { library_item = edit_code, outer_ui = program_ui })
			end,
		})
	end
	canvas:Add('<Button halign=fill y=88 margin_left=10/>', {
		margin_right = (sub_code and 104 or 10),
		text = (sub_code and "Select" or "Select Subroutine"),
		on_click = function(btn)
			local function on_select(item)
				local was_changed, params, pinits = inst.sub ~= item.id, item.parameters, item.pinits
				inst.sub = item.id
				for i,is_out in ipairs(params or {}) do
					if not is_out and pinits and pinits[i] then
						inst[i] = pinits[i] -- apply default value
					elseif is_out and type(inst[i]) == "table" then
						inst[i] = nil -- can't have constant in output
					end
				end
				UI.CloseMenuPopup()
				if was_changed then program_ui:Refresh() end
			end
			UILibrarySelect(btn, 'C', on_select, nil,
				function(folder)
					UILibrarySaveItemAsNew(program_ui.library, { type = 'C' }, function (newitem) on_select(newitem) end)
				end,
				inst.sub, program_ui.comp and program_ui.comp.id, program_ui.library)
		end,
	})
	return 80
end

data.instructions.call =
{
	func = function(comp, state, cause, sub, ...)
		local returns, mem, oldstk = state.returns, state.mem, state.stk
		if not returns then returns = {} state.returns = returns end
		if #returns >= 20 then
			return InstError(comp, state, "Behavior exceeded call depth limit")
		end
		local asm, mem_index = sub == 0 and GetCachedBehaviorAsm(state.revid) or GetFactionBehaviorAsmById(comp.faction, sub), #mem
		if not asm then return end -- behavior deleted or modified
		returns[#returns + 1] = { state.revid, oldstk, state.counter, mem_index, state.lastcounter } -- return record
		table.move(asm.mem, 1, #asm.mem, mem_index + 1, mem) -- increase stack memory by amount of sub
		for i=mem_index + 1,#mem do mem[i] = Tool.NewRegisterObject(mem[i]) end -- copy values (don't reference)
		local code_parameters = asm.code.parameters
		local stk = (code_parameters and { #code_parameters - mem_index, table.unpack(code_parameters) } or { -mem_index })
		for i=2,#stk do
			local arg = select(i - 1, ...)
			if arg then stk[i] = arg -- got input argument
			elseif stk[i] then -- empty output argument must exist as the parameter might be used like a local variable
				mem[#mem + 1] = Tool.NewRegisterObject()
				stk[i] = #mem + (type(oldstk) == "table" and oldstk[1] or oldstk)
			end
		end
		state.revid, state.stk, state.counter, state.lastcounter = asm.revid, stk, 1, 1 -- subroutine state
		--print("[call] Return #" .. #returns  .. " - STK: " .. tostring(state.stk):gsub("\n", " "):gsub(" %p%d+%p: ", "") .. " - MEM: " .. tostring(state.mem):gsub("\n", " "):gsub(" %p%d+%p: ", "") .." - OLDSTK: " .. tostring(returns[#returns][3]):gsub("\n", " "):gsub(" %p%d+%p: ", "") .." - OLDMEM: " .. returns[#returns][5])
	end,
	name = "Call",
	desc = "Call a subroutine",
	category = "Flow",
	icon = "icon_input",
	node_ui = call_ui,
	make_asm = function(inst)
		return inst.sub or false
	end,
	var_args = call_var_args,
	explain = [[Runs a different behavior and then continues running the current behavior.]],
}

data.instructions.last = {
	func = function(comp, state, cause, n)
		local blocks, returns = state.blocks, state.returns
		local block = blocks and blocks[#blocks]
		if not block or not block[4] or block[4] ~= (returns and #returns or 0) then
			return InstError(comp, state, "Break called while not in loop")
		end
		::break_again::
		local next_counter, loop_inst_idx, it = table.unpack(table.remove(blocks))
		local inst = GetCachedBehaviorAsm(state.revid)[loop_inst_idx]
		local op = data.instructions[inst and inst[1]]
		if op then op.last(comp, state, it, table.unpack(inst, 3)) end
		if n > 1 then
			n = n - 1
			block = blocks and blocks[#blocks]
			if not block or not block[4] or block[4] ~= (returns and #returns or 0) then
				return InstError(comp, state, "Break count exceeded loop depth")
			end
			goto break_again
		end
	end,
	make_asm = function(inst)
		return (inst.n or 1)
	end,
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local inst_n = inst.n
		if not show_extra and not inst_n then return 0, true, true end
		canvas:Add('<Text text="Break Count:" style=bl y=26 halign=fill margin=10 tooltip="How many nested loops are to be broken out of"/>')
		canvas:Add('<InputText y=50 halign=fill margin=10 height=34 tooltip="How many nested loops are to be broken out of"/>', {
			text = tostring(inst.n or 1),
			on_change = function(inp, value)
				local n = math.min(math.max(tonumber(string.gsub(value, "%D", ""), 10) or 0, 0), 99)
				inp.text = (n == 0 and "" or tostring(n))
			end,
			on_commit = function(inp, value)
				local n = math.min(math.max(tonumber(string.gsub(value, "%D", ""), 10) or 1, 1), 99)
				inp.text = tostring(n)
				n = (n > 1 and n or nil)
				if n ~= inst.n then inst.n = n program_ui:set_dirty(true) end
			end,
		})
		return 56, true, not inst_n
	end,
	exec_arg = false,
	name = "Break",
	desc = "Breaks out of a loop",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Deny.png",
	explain = [[Breaks out of loops and continues running from the <hl>Done</> pin of the loop instruction.]],
}

data.instructions.exit =
{
	func = function(comp, state)
		InstUnrollReturns(state)
		state.counter, state.blocks, state.returns, state.debug, state.limit, state.unlock_continue = 1, nil

		-- Because data.instructions.exit gets called as a regular function outside of c_behavior:on_update, we can't use GetCachedBehaviorAsm here.
		-- And in addition to GetFactionBehaviorAsm we use GetFactionBehaviorAsmById as a fallback in case the behavior revision was already modified.
		local asm = GetFactionBehaviorAsm(comp, state.revid) or GetFactionBehaviorAsmById(comp.faction, state.main_id)
		if asm and asm.code.keeparrays ~= "store" then state.arrays = nil end

		UpdateEntityBehaviorState(comp.owner, comp)
		return true
	end,
	exec_arg = false,
	name = "Stop Behavior",
	altnames = { "Exit", "Abort", "Quit" },
	desc = "Stops execution of the behavior",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Deny.png",
	explain = [[Stops running the current behavior.]],
}

data.instructions.ret =
{
	func = function(comp, state, cause, arg_idx)
		local blocks, returns = state.blocks, state.returns
		local block = blocks and blocks[#blocks]
		while block and (not block[4] or block[4] == (returns and #returns or 0)) do
			blocks[#blocks] = nil
			block = blocks[#blocks]
		end
		if returns then
			local up_revid, up_lastcounter = returns[#returns][1], returns[#returns][5]
			local upcode = GetFactionBehaviorAsm(comp, up_revid)
			local upinst = upcode and upcode[up_lastcounter]
			returns[#returns][3] = upinst and upinst[arg_idx] or false -- set next counter after return
		end
		state.counter = false -- forces calling of c_behavior_on_end
	end,
	make_asm = function(inst, code)
		local inst_branch = inst.branch
		if not inst_branch then return 2 end -- without return branch just jump to next which is at index 2
		local parameters, seen = code.parameters
		local arg_idx = 3 + (parameters and #parameters or 0)
		for i,v in ipairs(code) do
			local v_branch = v.branch
			if v_branch and v.op == "ret" and (not seen or not seen[v_branch]) then
				arg_idx = arg_idx + 1
				if v_branch == inst_branch then return arg_idx end
				if seen then seen[v_branch] = true else seen = { [v_branch] = true } end
			end
		end
	end,
	exec_arg = false,
	name = "Return",
	desc = "Return from a called sub-behavior, optionally continuing a named branch",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Deny.png",
	node_ui = function(canvas, inst, program_ui)
		canvas:Add('<Text text="Branch:" style=bl y=26 halign=fill margin=10/>')
		canvas:Add('<InputText y=50 halign=fill margin=10 height=34/>', {
			text = inst.branch,
			on_commit = function(btn, txt)
				if txt and txt == "" then txt = nil end
				if inst.branch == txt then return end
				inst.branch = txt
				program_ui:set_dirty(true)
			end,
		})
		return 54
	end,
	explain = [[Ends the current sub-behavior and returns to the behavior that called it.

If a branch name is entered on the node, the calling <hl>Call</> instruction exposes that branch with a pin output. Use named return branches to report outcomes such as Success, Failed, or Retry from reusable sub-behaviors.

<hl>Node Settings</>
Branch is the optional return branch name shown on callers of this behavior.]],
}

data.instructions.restart =
{
	func = function(comp, state)
		state.counter = false -- forces restart and calling of c_behavior_on_end
		if InstUnrollReturns(state) then state.lastcounter = 1 end -- so program editor doesn't highlight the wrong instruction
		state.blocks, state.limit, state.unlock_continue = nil
		comp:SetStateSleep(1)
		return true
	end,
	exec_arg = false,
	name = "Restart",
	desc = "Restart execution of the behavior",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Deny.png",
	explain = [[Restarts a behavior from the <hl>Program Start</> node.]],
}

data.instructions.unlock = {
	func = function(comp, state, cause, val)
		local set_limit, behavior_limit = math.abs(val), Map.GetSettings().behavior_limit
		if behavior_limit == 1 then
			return InstError(comp, state, "Behavior used unlock instruction which has been disabled on this server")
		end
		state.limit = math.min(set_limit, behavior_limit or 99999)
		state.unlock_continue = (val < 0 or nil)
	end,
	make_asm = function(inst)
		return (inst.n or 1000) * (inst.c == 2 and -1 or 1)
	end,
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local inst_n, inst_c = inst.n, inst.c
		if not show_extra and not inst_n and not inst_c then return 0, true, true end
		canvas:Add('<Text text="Step Limit:" style=bl y=26 halign=fill margin=10/>')
		canvas:Add('<InputText y=50 halign=fill margin=10 height=34/>', {
			text = tostring(inst.n or 1000),
			on_change = function(inp, value)
				local n = math.min(math.max(tonumber(string.gsub(value, "%D", ""), 10) or 0, 0), Map.GetSettings().behavior_limit or 99999)
				inp.text = (n == 0 and "" or tostring(n))
			end,
			on_commit = function(inp, value)
				local n = math.min(math.max(tonumber(string.gsub(value, "%D", ""), 10) or 1000, 2), Map.GetSettings().behavior_limit or 99999)
				inp.text = tostring(n)
				if n == inst.n then return end
				inst.n = n
				program_ui:set_dirty(true)
			end,
		})
		NodeUICombo(canvas, inst, program_ui, { "Pause on limit", "Continue next tick" })
		canvas[#canvas].y = 92
		return 96, true, not inst_n and not inst_c
	end,
	name = "Unlock",
	desc = "Run as many instructions as possible. Use wait instructions to throttle execution.",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Unlocked.png",
	explain = [[By default, behavior controllers run one instruction per tick. Unlock allows multiple instructions to execute within one tick until it hits a <hl>Wait Ticks</> instruction, the end of the behavior, or an instruction that takes time to execute such as a synchronous <hl>Move Unit</> instruction.

If more than the set number (default 1000) of instructions are executed in one tick then the behavior will abort or continue the next tick.

Note: Running too many instructions in one tick can cause the game to slow down.]],
}

data.instructions.lock = {
	func = function(comp, state)
		state.limit, state.unlock_continue = nil, nil
	end,
	name = "Lock",
	desc = "Run one instruction at a time",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/Unlocked.png",
	explain = [[Will lock the behavior to run at one instruction per simulation tick, if you have previously Unlocked the behavior, returning it to the default behavior.]],
}

data.instructions.label =
{
	func = function() end,
	args = { { 'in', "Label", "Label identifier", 'any' } },
	name = "Label",
	desc = "Labels can be jumped to from anywhere in a behavior",
	category = "Flow",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
	sample = "5m3YxVw84XJFlw24tPSo1r2L8L3mKUrZ2SEiKA1NUiEH1MDB7y0QmVQm0Qz9aJ3hYzUj1tPR554Fop503HO9MG3M0r9Y3y90eu2MBd5m2xxcAA0962pa0oCuIy1cMU7G2iiUGY3Y4d1W2Nd5410aQYkf28dFvn3EQa3r3klEil1kXFpA0AbN7C2i2XeI0Mc4Oj",
	explain = [[Sets a label at a location in the behavior. You can make the behavior run instructions from the label by using the <hl>Jump</> instruction.]],
}

data.instructions.jump =
{
	func = function(comp, state, cause, label)
		label = Get(comp, state, label)
		local asm = GetCachedBehaviorAsm(state.revid)
		for i=1,#asm do
			if asm[i][1] == "label" and label == Get(comp, state, asm[i][3]) then
				state.counter = i
				return
			end
		end
	end,
	args = { { 'in', "Label", "Label identifier", 'any' } },
	name = "Jump",
	desc = "Jumps execution to label with the same label id",
	category = "Flow",
	icon = "Main/skin/Icons/Common/56x56/J Value.png",
	sample = "5m3YxVw84XJFlw24tPSo1r2L8L3mKUrZ2SEiKA1NUiEH1MDB7y0QmVQm0Qz9aJ3hYzUj1tPR554Fop503HO9MG3M0r9Y3y90eu2MBd5m2xxcAA0962pa0oCuIy1cMU7G2iiUGY3Y4d1W2Nd5410aQYkf28dFvn3EQa3r3klEil1kXFpA0AbN7C2i2XeI0Mc4Oj",
	explain = [[Will jump to a location in the behavior specified by a <hl>Label</> instruction.

Jumps can be dynamic and passed via <bl>parameter</> or <bl>variable</>]],
}

data.instructions.wait =
{
	func = function(comp, state, cause, time)
		local t = GetNum(comp, state, time)
		if t == REG_INFINITE then t = 2147483647 end -- max integer
		if t <= 0 then return end
		comp:SetStateSleep(t)
		return true
	end,
	args = { { 'in', "Time", "Number of ticks to wait", 'posinfnum' } },
	name = "Wait Ticks",
	desc = "Pauses execution of the behavior until 1 or more ticks later",
	category = "Flow",
	icon = "Main/skin/Icons/Special/Commands/Wait.png",
	explain = [[Will pause the current behavior for the specified number of ticks. There are 5 simulation ticks per second.]],
}

data.instructions.compare_register = {
	func = function(comp, state, cause, if_differ, val1, val2)
		if Get(comp, state, val1) ~= Get(comp, state, val2) then
			state.counter = if_differ
		end
	end,
	exec_arg = { 1, "If Equal", "Where to continue if the values are the same" },
	args = {
		{ 'exec', "If Different", "Where to continue if the values differ" },
		{ 'in', "Value 1" },
		{ 'in', "Value 2" },
	},
	name = "Compare",
	desc = "Compares two values for full equality",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Checks if both the <hl>data part</> (identifier, target reference or coordinate) and <hl>numerical part</> of two values are equal and continues execution based on the result.]],
}

data.instructions.compare_type = {
	func = function(comp, state, cause, if_differ, val1, val2)
		local r1, r2 = Get(comp, state, val1), Get(comp, state, val2)
		local r1_id, r2_id = r1.id, r2.id
		local r1_entity, r2_entity = not r1_id and r1.entity, not r2_id and r2.entity
		if (r1_entity and r1_entity.id or r1_id) ~= (r2_entity and r2_entity.id or r2_id) then
			state.counter = if_differ
		end
	end,
	exec_arg = { 1, "If Equal", "Where to continue if the types are the same" },
	args = {
		{ 'exec', "If Different", "Where to continue if the types differ" },
		{ 'in', "Item/Unit", nil, "frame_item" },
		{ 'in', "Item/Unit", nil, "frame_item" },
	},
	name = "Compare Type",
	altnames = { "Compare Item", "Is A" },
	desc = "Compares item or unit types",
	category = "Logic",
	sample = "3X3bEIye3Ws2zI1vrccS1GoXMX07HSFF1bRCNE17PfAn12QQs91US35J2fs4Ba0n7R082RvSGF2Z9Y9m2huVZ50FlMsE0QCZ3539VOuz0q0wH32aQ9vc3l5CDH00RCNR0Ypkum0xJ",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Checks if the inputs are of the same <hl>type</> and continues execution based on the result. Two inputs that don't denote a type will be treated as equal.]],
}

data.instructions.compare_data = {
	func = function(comp, state, cause, if_differ, val1, val2)
		if not Get(comp, state, val1):MatchData(Get(comp, state, val2)) then
			state.counter = if_differ
		end
	end,
	exec_arg = { 1, "If Equal", "Where to continue if the data parts are the same" },
	args = {
		{ 'exec', "If Different", "Where to continue if the data parts differ" },
		{ 'in', "Value", "The value to check with", 'data' },
		{ 'in', "Compare", "The number to check against", 'data' },
	},
	name = "Compare Data",
	altnames = { "Compare Unit" },
	desc = "Compare the data part (identifier, target reference or coordinate) of two values",
	category = "Logic",
	sample = "V02rMaA1CVygy1rAMqo0007ku00XOHi289lCC1z4boV23ezW221c39c07OOYi1CVzpA22TJ3325rsXl1mZxi922kYAG01oW",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Checks if the inputs contain the same <hl>data part</> (identifier, target reference or coordinate) and continues execution based on the result.]],
}

data.instructions.is_empty = {
	func = function(comp, state, cause, in_value, exec_empty, exec_has)
		local reg = Get(comp, state, in_value)
		if reg.is_empty then state.counter = exec_empty
		else state.counter = exec_has
		end
	end,
	exec_arg = false,
	args = {
		{ 'in', "Value", "Value to check", },
		{ 'exec', "Empty", "Where to continue if the value is empty" },
		{ 'exec', "Has Value", "Where to continue if the value exists" },
	},
	name = "Is Empty",
	desc = "Checks a value if it is empty",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Checks the passed value and if it is empty diverts logic using the result.]],
}

data.instructions.get_type = {
	func = function(comp, state, cause, in_val, out_type)
		local reg = Get(comp, state, in_val)
		local reg_id = reg.id
		local reg_entity = not reg_id and reg.entity
		Set(comp, state, out_type, reg_entity and reg_entity.id or reg_id)
	end,
	args = {
		{ 'in', "Item/Unit" },
		{ 'out', "Type" },
	},
	name = "Get Type",
	altnames = { "Get Unit Type" },
	desc = "Gets the type from an item or unit",
	category = "Values",
	sample = "2h3bEIye3Ws2zI1vrccS1GoXMX07HSFF1bRCNE17PfAn12QQs91US35J2fs4Ba0n7R081Dqt8l2ONsvP1XxBYI001eT232ZeBCh",
	icon = "Main/skin/Icons/Common/56x56/Processing.png",
	explain = [[Puts the <hl>Type</> of an <hl>Item</> or <hl>Unit</> into a register.]],
}

data.instructions.data_type = {
	func = function(comp, state, cause, in_data, if_item, if_component, if_frame, if_value, if_tech, if_coord, if_entity)
		in_data = Get(comp, state, in_data)
		local id = in_data.id
		if id then
			if data.items[id] then
				if if_item then state.counter = if_item end
			elseif data.components[id] then
				if if_component then state.counter = if_component end
			elseif data.frames[id] then
				if if_frame then state.counter = if_frame end
			elseif data.values[id] then
				if if_value then state.counter = if_value end
			elseif data.techs[id] then
				if if_tech then state.counter = if_tech end
			end
		elseif in_data.coord_x then
			if if_coord then state.counter = if_coord end
		elseif in_data.raw_entity then
			if if_entity then state.counter = if_entity end
		end
	end,
	exec_arg = { 9, "No Match", "Where to continue if there is no match" },
	args = {
		{ 'in', "Data", "Data to test" },
		{ 'exec', "Inventory Item", "Resources or materials", nil, true },
		{ 'exec', "Component Item", "Components of various sizes", nil, true },
		{ 'exec', "Type", "Unit/building/object types", nil, true },
		{ 'exec', "Information Value", "Color/filter/label values", nil, true },
		{ 'exec', "Research Value", "Research technology values", nil, true },
		{ 'exec', "Coordinate", "World coordinate", nil, true },
		{ 'exec', "Target Reference", "Reference to an object in the world", nil, true },
	},
	name = "Data Type Switch",
	desc = "Diverts the program depending on the type of data",
	category = "Logic",
	icon = "Main/skin/Icons/Common/56x56/Processing.png",
	explain = [[Continues execution of the behavior depending on what is contained by the data part of the passed <hl>Data</> value.

Output pins not connected will continue with 'No Match'.]],
}

data.instructions.get_first_locked_0 = {
	func = function(comp, state, cause, first_locked)
		for _,v in ipairs(comp.owner.slots) do
			if v.locked and v.id and v.stack == 0 then
				Set(comp, state, first_locked, { id = v.id, num = 1 })
				return
			end
		end
		Set(comp, state, first_locked, nil)
	end,
	args = {
		{ 'out', "Item", "The first locked item id with no item", },
	},
	name = "Get First Locked Id",
	desc = "Gets the first item where the locked slot exists but there is no item in it",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[<img image="Main/textures/behaviors/get_first_locked_id2.png"/>

Returns the first locked slot without any items in it.

<img image="Main/textures/behaviors/get_first_locked_id1.png"/>]],
}

data.instructions.entity_type = {
	func = function(comp, state, cause, in_unit, if_building, if_unit, if_construction, if_wall, if_gate, if_foundation, if_droppeditem, if_resource, if_destroyed)
		-- dont include self here so when people pass no unit it returns no match
		local ent = GetEntity(comp, state, in_unit)
		if not ent then
			if if_destroyed and Get(comp, state, in_unit).is_destroyed then
				state.counter = if_destroyed
			end
			return
		end
		local d = ent.def
		local dtype = d.type
		if dtype == nil then
			if (d.movement_speed or 0) == 0 then
				if if_building then state.counter = if_building end
			elseif (d.movement_speed or 0) > 0 then
				if if_unit then state.counter = if_unit end
			end
		elseif dtype == "Construction" then
			if if_construction then state.counter = if_construction end
		elseif dtype == "Wall" then
			if if_wall then state.counter = if_wall end
		elseif dtype == "Gate" then
			if if_gate then state.counter = if_gate end
		elseif dtype == "Foundation" then
			if if_foundation then state.counter = if_foundation end
		elseif dtype == 'DroppedItem' then
			if if_droppeditem then state.counter = if_droppeditem end
		elseif dtype == "Resource" then
			if if_resource then state.counter = if_resource end
		end
	end,
	exec_arg = { 11, "No Match", "Where to continue if there is no match" },
	args = {
		{ 'in', "Target Reference", "The target reference to check", 'entity', },
		{ 'exec', "Building", "Where to continue if it is a building", nil, true },
		{ 'exec', "Unit", "Where to continue if it is a moving unit", nil, true },
		{ 'exec', "Construction", "Where to continue if it is a construction site", nil, true },
		{ 'exec', "Wall", "Where to continue if it is a wall", nil, true },
		{ 'exec', "Gate", "Where to continue if it is a gate", nil, true },
		{ 'exec', "Foundation", "Where to continue if it is a foundation", nil, true },
		{ 'exec', "Dropped Item", "Where to continue if it is a dropped item", nil, true },
		{ 'exec', "Resource", "Where to continue if it is a resource node", nil, true },
		{ 'exec', "Destroyed Object", "Where to continue if it is a reference to a destroyed object", nil, true },
	},
	name = "Target Type Switch",
	altnames = { "Unit Type", "Check Destroyed" },
	desc = "Diverts the program depending on the type of a target reference",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	sample = "6W3YxVw81l9GKn2WCHGi0gj82b0g6aYz2vmKaq065ucK3CmCWp1vfP4E2H7Du24HyWfh2S9odm2unxFm1ZO5Nm31faUf2ntqRd0vOFMP13x0s72wB42D2bgl5M1OVg801NWdOF3rw96g00s4gL0x5PUT1nI3uf08dxmi27v6e23DoVNK1HPv",
	explain = [[Continues execution of the behavior depending on the type of the passed <hl>Target Reference</>.

Output pins not connected will continue with 'No Match'.]],
}

data.instructions.select_nearest = {
	func = function(comp, state, cause, exec_a, exec_b, entity_a, entity_b, closer_entity)
		local ent_a = GetEntity(comp, state, entity_a)
		local ent_b = GetEntity(comp, state, entity_b)

		if not ent_a and not ent_b then
			if closer_entity then Set(comp, state, closer_entity, nil) end
			return
		end

		local faction, owner = comp.faction, comp.owner
		local dist_a = ent_a and faction:IsSeen(ent_a) and owner:GetRangeSquaredTo(ent_a) or 9999999999
		local dist_b = ent_b and faction:IsSeen(ent_b) and owner:GetRangeSquaredTo(ent_b) or 9999999999

		if dist_a <= dist_b then
			if closer_entity then Set(comp, state, closer_entity, { entity = ent_a, num = dist_a }) end
			if exec_a then state.counter = exec_a end
		else
			if closer_entity then Set(comp, state, closer_entity, { entity = ent_b, num = dist_b }) end
			if exec_b then state.counter = exec_b end
		end
	end,
	args = {
		{ 'exec', "A", "A is nearer (or equal)" },
		{ 'exec', "B", "B is nearer" },
		{ 'in', "Unit A", nil, 'entity' },
		{ 'in', "Unit B", nil, 'entity' },
		{ 'out', "Closest", "Closest unit", nil, true },
	},
	name = "Select Nearest",
	desc = "Branches based on which unit is closer, optional branches for closer unit",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Closest Enemy.png",
	explain = [[Passing two <hl>Units</> will continue execution based on which one is closer to the unit running the behavior. An option parameter can also be used to get which unit is closer.]],
}

data.instructions.for_entities_in_range = {
	func = function(comp, state, cause, range, f1, f2, f3, out_entity, exec_done)
		local owner, range = comp.owner, GetNum(comp, state, range)
		if range < 1 then
			range = range == REG_INFINITE and owner.visibility_range or 1
		elseif range > owner.visibility_range then
			range = owner.visibility_range
		end

		local f1id = GetId(comp, state, f1)
		local filters = { f1id, f1id and GetNum(comp, state, f1), nil, nil, nil, nil }
		if filters[1] then
			filters[3] = GetId(comp, state, f2)
			filters[4] = filters[3] and GetNum(comp, state, f2)
			if filters[3] then
				filters[5] = GetId(comp, state, f3)
				filters[6] = filters[5] and GetNum(comp, state, f3)
			end
		end

		local it = { 2 }
		local entity_filter, override_range = PrepareFilterEntity(filters)
		Map.FindClosestEntity(owner, math.min(override_range or range, range), function(e)
			local ret, num = FilterEntity(owner, e, filters)
			if ret then
				it[#it+1] = num and { entity = e, num = num } or e
			end
		end, entity_filter)
		if #it > 1 then return BeginBlock(comp, state, it, 1) end
		Set(comp, state, out_entity, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, range, f1, f2, f3, out_entity, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_entity, it[i])
		it[1] = i + 1
	end,

	last = function(comp, state, it, range, f1, f2, f3, out_entity, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'in', "Range", "Range (up to units visibility range)", 'num' },
		{ 'in', "Filter", "Filter to check", 'radar' },
		{ 'in', "Filter", "Second Filter", 'radar', true },
		{ 'in', "Filter", "Third Filter", 'radar', true },
		{ 'out', "Unit", "Current Unit in loop" },
		{ 'exec', "Done", "Finished looping through all units in range" },
	},
	name = "Loop Units (Range)",
	desc = "Loops through all units in visibility range of the unit",
	category = "Loops",
	sample = "V058hik02qAks21cKXI2NbWvV2AjPm81vjnu321MU3Q1q0ayl21cbNw00W1gr25via528CEU31r8wR721MTit21KIal22kYQZ3YGixs1CVzMM02rudx1CW6ow1vjlnH21MU3Q21MPWZ21KGRc0yJrtP28EzzP22WKBc2Dq0xw00UuuY01G",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops over all entities within the given range.
Default is range 1, or visibility range if ∞ is passed

Optional filters allow you to only get desired units.]],
}

data.instructions.for_research = {
	func = function(comp, state, cause, out_tech, exec_done)
		local techs = GetResearchableTech(comp.faction)
		local it = { 2 }
		for _,v in ipairs(techs) do
			it[#it+1] = v
		end
		if #it > 1 then return BeginBlock(comp, state, it, 1) end
		Set(comp, state, out_tech, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, out_tech, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_tech, it[i])
		it[1] = i + 1
	end,

	last = function(comp, state, it, out_tech, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'out', "Tech", "Researchable Tech" },
		{ 'exec', "Done", "Finished looping through all researchable tech" },
	},
	name = "Loop Researchable Tech",
	desc = "Loops through all currently researchable tech",
	category = "Loops",
	sample = "3h3YxVw83N5hsf4870ro1w6gCm2iQlyI3b6v712hIRUP1jxAlq2pXtmm3Ff3bE2N2Q6i1wlqdV15Hlaf1DtsHb1sz2n90AgpPZ0PrBQg12syJi0aV2c50Nwd3O0o5W",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops through all technologies available for research.]],
}

data.instructions.for_research_unlocks = {
	func = function(comp, state, cause, in_tech, out_unlock, exec_done)
		local tech = GetId(comp, state, in_tech)
		tech = tech and data.techs[tech]
		if not tech or not tech.unlocks then
			state.counter = exec_done
			Set(comp, state, out_unlock, nil)
			return
		end

		local it = { 2 }
		for _,v in ipairs(tech.unlocks) do
			if not data.values[v] and not data.codex[v] then
				it[#it+1] = v
			end
		end
		if #it > 1 then return BeginBlock(comp, state, it, 1) end
		Set(comp, state, out_unlock, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, in_tech, out_unlock, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_unlock, it[i])
		it[1] = i + 1
	end,

	last = function(comp, state, it, in_tech, out_unlock, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'in', "Tech", "Tech", 'tech' },
		{ 'out', "Unlock", "Unlocks" },
		{ 'exec', "Done", "Finished looping through all unlocks" },
	},
	name = "Loop Research Unlocks",
	desc = "Loops through all unlocks for a researchable tech",
	category = "Loops",
	sample = "4j3YxVw83N5hsf4870Km1w6gCm2iQlyI3b6v712hIRUP1jxAlq2pXtmm3Ff3bE2N2Q6i1wlqdV0Ux6wP09XDbH1Do6aR1EqNvT2du1M44DohJF1t7hjx3Jk1Rf0pTQdH0BS6ZI02gBTK0rYsiK3AeTx109yTOU0pj94S2ux",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops through all items that are unlocked for a particular research.]],
}

data.instructions.is_unlocked =
{
	func = function(comp, state, cause, in_id, exec_nomatch)
		local id = GetId(comp, state, in_id)
		if not id or not comp.faction:IsUnlocked(id) then
			state.counter = exec_nomatch
		end
	end,
	args = {
		{ 'in', "Id", "Input Id"},
		{ 'exec', "No Match", "Execution path if there is no match" },
	},
	explain = [[Checks if your faction has researched a specific item or technology and continues execution based on the result.]],
	name = "Is Researched",
	desc = "Checks whether a faction has something researched",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
}

data.instructions.for_producers = {
	func = function(comp, state, cause, in_product, out_producer, exec_done)
		local id = GetId(comp, state, in_product)
		local ent = not id and GetEntity(comp, state, in_product)
		local def = ent and ent.def or data.all[id]
		local recipe = def and def.production_recipe
		local producers = (recipe and recipe.producers) or (def and def.mining_recipe)

		local faction = comp.faction
		if producers and faction:HavePickedUpItem(id) or faction:IsUnlocked(id) then
			local it = { 2 }
			for producer_id,duration in SortedPairs(producers) do
				if faction:HavePickedUpItem(producer_id) or faction:IsUnlocked(producer_id) then
					it[#it + 1] = { id = producer_id, num = duration }
				end
			end
			if #it > 1 then return BeginBlock(comp, state, it, 1) end
		end
		Set(comp, state, out_producer, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, in_product, out_producer, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_producer, it[i])
		it[1] = i + 1
	end,

	last = function(comp, state, it, in_product, out_producer, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'in', "Product", nil, "frame_item" },
		{ 'out', "Production Component" },
		{ 'exec', "Done", "Finished looping through all item producers" },
	},
	explain = [[Loops through all components that can produce a given item and returns the component and its production time.]],
	name = "Loop Producers",
	desc = "Loops through all producers for a production with their production time",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
}

data.instructions.for_producers_items = {
	func = function(comp, state, cause, c, in_producer, out_item, exec_done)
		local producer_id = GetId(comp, state, in_producer)
		local it, list_array, data_array = { 2 }
		if     c == 1 then list_array, data_array = comp.faction.unlocked_items,      data.items
		elseif c == 3 then list_array, data_array = comp.faction.unlocked_components, data.components
		elseif c == 4 then list_array, data_array = comp.faction.unlocked_frames,     data.frames
		else               list_array, data_array = comp.faction.unlocks,             data.all
		end
		for _,k in ipairs(list_array) do
			local def = data_array[k]
			local recipe = def and def.production_recipe
			local producers = recipe and recipe.producers or def.mining_recipe
			if producers and producers[producer_id] then
				it[#it + 1] = k
			end
		end
		if #it > 1 then
			return BeginBlock(comp, state, it, 1)
		else
			local producer_def = data.components[producer_id]
			local extracts = producer_def and producer_def.extracts
			if extracts and data_array[extracts] then
				it[#it + 1] = extracts
				return BeginBlock(comp, state, it, 1)
			end
		end
		Set(comp, state, out_item)
		state.counter = exec_done
	end,

	next = function(comp, state, it, c, in_producer, out_item, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_item, it[i])
		it[1] = i + 1
	end,

	last = function(comp, state, it, c, in_producer, out_item, exec_done)
		state.counter = exec_done
	end,

	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Only Items", "Everything", "Only Components", "Only Units" })
	end,
	args = {
		{ 'in', "Production Component", nil, 'comp' },
		{ 'out', "Product" },
		{ 'exec', "Done", "Finished looping through all items" },
	},
	sample = "4j3YxVw83WrDqD2fYjuz1j3MVd3ZRfWE1c5oAT3EiyEW0kGOAD19i5RG3JlJSv3HVtw82D3pvI0Q7VQX2SBv2A11I1P40ZC10t1eeALa0Kq2BC0Ga2hD3djiSq0LmhmR1GMKQ803DQis048utU3JxDNA0pAghE3BL",
	name = "Loop Products",
	desc = "Loops through everything a production component can produce",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops through products that can be made by the selected production component type.

<hl>Product</> is set once per loop iteration. If no matching product exists, Product is cleared and execution continues at <hl>Done</>.

<hl>Node Settings</>
Choose whether to loop only items, everything, only components, or only units. Mining components can also return the resource they extract.]],
}

data.instructions.for_unlocked = {
	func = function(comp, state, cause, cu, out_item, exec_done)
		local it, f, c, u, list_array, data_array, only_bot, no_codex = { 2 }, comp.faction, (cu & 31), ((cu & 32) ~= 0)
		if     c == 1 then list_array, data_array           = comp.faction.unlocked_components, data.components
		elseif c == 2 then list_array, data_array           = comp.faction.unlocked_items,      data.items
		elseif c == 3 then list_array, data_array, only_bot = comp.faction.unlocked_frames,     data.frames, true
		elseif c == 4 then list_array, data_array, only_bot = comp.faction.unlocked_frames,     data.frames, false
		elseif c == 5 then list_array, data_array           = comp.faction.unlocked_values,     data.values
		elseif c == 6 then list_array, data_array           = comp.faction.unlocked_techs,      data.techs
		else               list_array, data_array, no_codex = comp.faction.unlocks,             data.all, data.codex
		end
		table.sort(list_array)

		for i,k in ipairs(list_array) do
			if only_bot == nil or (only_bot and (data_array[k].movement_speed or 0) > 0) or (not only_bot and (data_array[k].movement_speed or 0) == 0) then
				if no_codex == nil or not no_codex[k] then
					if not u then
						it[#it + 1] = k
					else
						local recipe = data_array[k].production_recipe
						recipe = recipe and recipe.producers
						for compid,_ in SortedPairs(recipe or {}) do
							if f:IsUnlocked(compid) then
								it[#it + 1] = k
								break
							end
						end
					end
				end
			end
		end
		if #it > 1 then return BeginBlock(comp, state, it, 1) end
		Set(comp, state, out_item, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, cu, out_item, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_item, it[i])
		it[1] = i + 1
	end,

	last = function(comp, state, it, cu, out_item, exec_done)
		state.counter = exec_done
	end,

	make_asm = function(inst)
		return (inst.c or 1) | (inst.u and 32 or 0)
	end,
	node_ui = function(canvas, inst, program_ui)
		local inst_c, inst_u = (inst.c or 1), inst.u
		if inst_u and inst_c >= 4 and inst_c <= 6 then inst.u, inst_u = nil, nil end
		NodeUICombo(canvas, inst, program_ui, { "Only Components", "Only Items", "Only Units", "Only Buildings", "Only Values", "Only Researches", "Everything" })
		canvas:Add('<CheckBox y=74 halign=fill margin=10 text="Can be Produced" tooltip="Only return what can be made in available production components"/>', { check = inst_u, disabled = inst_c >= 4 and inst_c <= 6, on_change = function(chk, val) inst.u = val or nil program_ui:set_dirty(true) end })
		return 78
	end,
	args = {
		{ 'out', "Item" },
		{ 'exec', "Done", "Finished loop" },
	},
	sample = "V0589ch1CVygy21cbNz00W1gr25viZw1z75O31r9TP523ezW01p7QRs29YkjY001Ev24dY6XA1rAMtu33cAe01kNZr92yOV502R0igZ4dP8FQ2xwOJp3jco9u2DsHB01rBkIK1rBOTs23ezW300X",
	name = "Loop Researched",
	desc = "Loops through everything of a given type the faction has researched",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops through unlocked definitions for the faction.

<hl>Item</> is set once per loop iteration. If nothing matches the selected type, Item is cleared and execution continues at <hl>Done</>.

<hl>Node Settings</>
The type selector chooses components, items, units, buildings, values, researches, or everything. <hl>Can be Produced</> limits results to things that currently have an unlocked producer.]],
}

data.instructions.get_research = {
	func = function(comp, state, cause, out_research)
		local faction_data = comp.faction.extra_data
		local q = faction_data.research_queue or faction_data.research_paused
		Set(comp, state, out_research, q and q[1])
	end,
	args = { { 'out', "Tech", "First active research" }, },
	name = "Get Research Tech",
	desc = "Returns the first active research tech",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Returns the current technology being researched, if any.]],
}

data.instructions.get_research_requirement = {
	func = function(comp, state, cause, in_research, out_research)
		local r = Get(comp, state, in_research)
		local tech_id = r.tech_id
		if not tech_id then return end

		if not tech_id then
			Set(comp, state, out_research, nil)
			return
		end

		local def = data.techs[tech_id]
		local require_tech = def.require_tech and (def.require_tech[comp.faction.extra_data.race or "robot"] or def.require_tech[1])

		-- no category for listing is an auto unlock research
		if require_tech and not data.techs[require_tech].category then
			Set(comp, state, out_research, nil)
			return
		end

		Set(comp, state, out_research, require_tech)
	end,
	args = {
		{ 'in', "Tech", "The research to investigate for prior tech requirements", 'tech' },
		{ 'out', "Requirement", "The tech required for the research (if needed)", },
	},
	explain = [[Returns the prerequisite technology for a given research if one exists.]],
	name = "Get Research Requirement",
	desc = "Returns the research required (if needed)",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
}

data.instructions.set_research =
{
	func = function(comp, state, cause, in_research)
		local r = Get(comp, state, in_research)
		local tech = r.tech_id
		if not tech or not GetResearchableTech(comp.faction)[tech] then return end

		local function ArrayContains(arr, val)
			if not arr then return end
			for _,v in ipairs(arr) do
				if v == val then return true end
			end
		end

		local faction_data = comp.faction.extra_data
		local q = faction_data.research_queue or faction_data.research_paused
		if q and (#q >= 3 or ArrayContains(q, tech)) then return end
		FactionAction.SetResearch(comp.faction, { id = tech })
	end,
	args = { { 'in', "Tech", "First active research", 'tech' }, },
	name = "Set Research Tech",
	desc = "Add a new research into the active research queue",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Adds new research into the active research queue, but only if the queue isn't full and previous research requirements have been completed.]],
}

data.instructions.clear_research =
{
	func = function(comp, state, cause, in_research)
		local faction_data = comp.faction.extra_data
		local r = Get(comp, state, in_research)
		local tech = r.tech_id
		if not tech then
			faction_data.research_queue, faction_data.research_paused = { }, nil
		else
			local q = faction_data.research_queue or faction_data.research_paused
			local faction_data = comp.faction.extra_data
			local q = faction_data.research_queue or faction_data.research_paused

			local q, q_idx = faction_data.research_queue or faction_data.research_paused, -1
			if not q then q = {} faction_data.research_queue = q end
			for i,v in ipairs(q) do if v == tech then q_idx = i break end end

			table.remove(q, q_idx)
		end

		-- Trigger uplink updates
		for _,c in ipairs(comp.faction:GetComponents("c_uplink", true)) do
			c:Activate()
		end
	end,
	explain = [[Removes a technology from the research queue or clears the queue if none is specified.]],
	args = { { 'in', "Tech", "Tech to remove from research queue", 'tech' }, },
	name = "Clear Research Tech",
	desc = "Clears a research from research queue, or entire queue if no tech passed",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
}

data.instructions.for_number = {
	func = function(comp, state, cause, from, to, step, val, exec_done)
		local nfrom, nto, nstep, n = GetNum(comp, state, from), GetNum(comp, state, to), (step and GetNum(comp, state, step))
		if nfrom == REG_INFINITE or nstep == 0 or (nto == REG_INFINITE and not state.counter) or (nstep and ((nstep > 0 and nto < nfrom) or (nstep < 0 and nto > nfrom))) then
			state.counter = exec_done
			Set(comp, state, val, nil)
			return
		end
		if state.counter then
			n = nfrom + (nstep and -nstep or ((nfrom <= nto or nto == REG_INFINITE) and -1 or 1))
		else
			n = nto - (nstep and (((nto - nfrom) % nstep) + nstep) or (nfrom <= nto and 1 or -1))
		end
		return BeginBlock(comp, state, { n })
	end,

	next = function(comp, state, it, from, to, step, val, exec_done)
		local i, from_reg, nto, nstep = it[1], Get(comp, state, from), GetNum(comp, state, to), (step and GetNum(comp, state, step))
		if nto == REG_INFINITE then
			i = i + (nstep or 1)
			if i > 2147483647 then i = i - 4294967294 elseif i < (REG_NOT+1) then i = i + 4294967294 end
		elseif not nstep then
			if i == nto then return true end
			i = i + (from_reg.num <= nto and 1 or -1)
		else
			i = i + nstep
			if nstep > 0 then if i > nto then return true end elseif i < nto then return true end
		end
		Set(comp, state, val, Tool.NewRegisterObject(from_reg, i))
		it[1] = i
	end,

	last = function(comp, state, it, from, to, step, val, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'in', "From", "Loop start number", 'num' },
		{ 'in', "To", "Loop end number", 'num' },
		{ 'in', "Step", "Increment step, use -1 or 1 based on inputs if left empty", 'num', true },
		{ 'out', "Value", "Current number" },
		{ 'exec', "Done", "Finished loop" },
	},
	name = "Loop Number",
	desc = "Loops through numbers in a range",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops from a start number to an end number with optional step increments.]],
}

data.instructions.for_coordinate = {
	func = function(comp, state, cause, in_maxrange, in_minrange, in_source, out_coord, exec_done)
		local source = in_source and Get(comp, state, in_source)
		local entity = not source and comp.owner or source.entity
		local coord = not entity and source.coord
		local maxrange = in_maxrange and GetNum(comp, state, in_maxrange) or comp.owner.visibility_range
		local minrange = in_minrange and GetNum(comp, state, in_minrange) or 0
		if maxrange == REG_INFINITE or maxrange == 2147483647 then maxrange = 2147483646 end -- 1 less than biggest number that Map.GetDistance returns
		if (not entity and not coord) or (entity and source and not comp.faction:IsSeen(entity)) or maxrange < 0 or minrange > maxrange or minrange == REG_INFINITE then
			-- no source, can't see source entity or range is invalid
			state.counter = exec_done
			Set(comp, state, out_coord, nil)
		else
			local x, y, w, h, tx, ty, dx, dy, wx, wy, steps
			if entity then
				local area = entity.area
				x, y, w, h = area[1], area[2], area[3], area[4]
			else
				x, y, w, h = coord.x, coord.y, 1, 1
			end
			if w >= h then
				local heven, hhalf, whdiff = (h & 1) ~ 1, h // 2, w - h
				tx, ty, dx, dy, wx, wy, steps = x + hhalf + whdiff * heven, y + hhalf, 1 - (heven * 2), 0, 2 + whdiff, 1, 2 + whdiff
			else
				local wodd, whalf, hwdiff = w & 1, w // 2, h - w
				tx, ty, dx, dy, wx, wy, steps = x + whalf, y + whalf + hwdiff * wodd, 0, 1 - (wodd * 2), 1, 1 + hwdiff, 1 + hwdiff
			end
			if not state.counter then -- no loop body, skip to near the end to avoid long loop in next
				tx, ty, dx, dy, steps = tx + math.sqrt(maxrange)//1, y - maxrange, 1, 0, maxrange+w+1
				Set(comp, state, out_coord, nil) -- in case where tx/ty overflows
			end
			return BeginBlock(comp, state, { tx, ty, dx, dy, wx, wy, steps, maxrange, minrange, x, y, w, h })
		end
	end,

	next = function(comp, state, it, in_maxrange, in_minrange, in_source, out_coord, exec_done)
		::next_step::
		local dist = Map.GetDistance(it[10], it[11], it[12], it[13], it[1], it[2])
		if dist < it[9] then -- less than min range
			if dist < it[9] * 7 // 10 then it[1], it[2], it[7] = it[1] + it[3] * (it[7] - 1), it[2] + it[4] * (it[7] - 1), 1 end -- jump ahead on large min range (performance)
			dist = nil
		elseif dist <= it[8] then Set(comp, state, out_coord, it) -- in range
		elseif it[1] < it[10] or it[2] > it[11] - it[8] then dist = nil -- outside of range but still in square area
		else return true -- finished all possible tiles in range
		end
		if it[7] ~= 1 then     it[7] = it[7] - 1 -- continue walk straight
		elseif it[3] == 0 then it[7], it[4], it[3], it[5] = it[5], 0, -it[4], it[5] + 1 -- turn horizontal
		else                   it[7], it[3], it[4], it[6] = it[6], 0,  it[3], it[6] + 1 -- turn vertical
		end
		it[1], it[2] = it[1] + it[3], it[2] + it[4]
		if not dist then goto next_step end
	end,

	last = function(comp, state, it, in_maxrange, in_minrange, in_source, out_coord, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'in', "Max Range", "Maximum range (if not own visibility range)", 'num' },
		{ 'in', "Min Range", "Minimum range (if not 0)", 'num', true },
		{ 'in', "Source", "The unit or coordinate to start from (if not self)", 'coord', true },
		{ 'out', "Coordinate", "Current coordinate" },
		{ 'exec', "Done", "Finished loop" },
	},
	name = "Loop Coordinate",
	desc = "Loops through coordinates in a range around a unit or coordinate",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- MATH -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

data.instructions.check_number =
{
	func = function(comp, state, cause, if_larger, if_smaller, val1, val2)
		local num1, num2 = GetNum(comp, state, val1), GetNum(comp, state, val2)
		local d = num1 - num2
		if d < 0 then
			if num1 == REG_INFINITE then
				state.counter = if_larger
			else
				state.counter = if_smaller
			end
		elseif d > 0 then
			if num2 == REG_INFINITE then
				state.counter = if_smaller
			else
				state.counter = if_larger
			end
		end
	end,
	exec_arg = { 1, "If Equal", "Where to continue if the numerical values are the same" },
	args = {
		{ 'exec', "If Larger", "Where to continue if Value is larger than Compare" },
		{ 'exec', "If Smaller", "Where to continue if Value is smaller than Compare" },
		{ 'in', "Value", "The value to check with", 'num' },
		{ 'in', "Compare", "The number to check against", 'num' },
	},
	name = "Compare Number",
	desc = "Divert program depending on the numbers of Value and Compare",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Compares two numerical values and diverts logic depending on whether one is larger or smaller or both the same.]],
}

data.instructions.set_reg =
{
	func = function(comp, state, cause, value, output)
		Set(comp, state, output, Get(comp, state, value))
	end,
	args = {
		{ 'in', "Value", nil, 'any' },
		{ 'out', "Target" },
	},
	explain = [[Copies a value from one register to another.

The <hl>Value</> can be a constant register or a value passed via a <bl>parameter</> or <bl>variable</>.
The <hl>Target</> can be any <bl>parameter</> or <bl>variable</>.]],
	name = "Copy",
	altnames = { "Set", "Assign" },
	desc = "Copy a value to a base register, parameter or variable",
	sample = "3W3bEIye46U9yq3NmKKR12zdfK0kGNlX0yMA8M1sAjR732tz0E0OauG50T7oyz1j5YIq2gViSb24q4jh1UWD624cqTiE2H2sxW27unYF000qIO0f0uTP1",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
}

data.instructions.set_comp_reg =
{
	func = function(comp, state, cause, value, to, comp_index)
		local to_comp = GetComponentFromIndex(comp, state, comp_index, to)
		local to_num = math.max(GetNum(comp, state, to), 1)
		if not to_comp or to_num > to_comp.register_count then return end

		local register_defs = to_comp.def.registers
		local register_def = register_defs and register_defs[to_num]
		if register_def and register_def.read_only then return end

		to_comp:SetRegister(to_num, Get(comp, state, value))
	end,
	args = {
		{ 'in', "Value", "Value to set", 'any' },
		{ 'in', "To", "Component and register number to set", 'comp_num' },
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
	},
	explain = [[Writes a value to a register of the specified component

<hl>Component Index</> can be used to specify the component if multiple are equipped.]],
	name = "Set to Component",
	desc = "Writes a value into a component register",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Set Component Reg.png",
}

data.instructions.get_comp_reg =
{
	func = function(comp, state, cause, from, value, comp_index)
		local from_comp = GetComponentFromIndex(comp, state, comp_index, from)
		local from_num = math.max(GetNum(comp, state, from), 1)
		Set(comp, state, value, from_comp and from_comp:GetRegister(from_num))
	end,
	args = {
		{ 'in', "From", "Component and register number to get", 'comp_num' },
		{ 'out', "Value", "Value of Register"},
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
	},
	explain = [[Reads a value from a register of a specific component and register offset.

<hl>Component Index</> can be used to specify the component if multiple are equipped.]],
	name = "Get from Component",
	desc = "Reads a value from a component register",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Set Component Reg.png",
}

data.instructions.is_working =
{
	func = function(comp, state, cause, not_working, getcomp, comp_index, out_component_id)
		local res, comp_id = GetComponentFromIndex(comp, state, comp_index, getcomp)
		if not comp_id then
			-- If nothing is set, search all sockets in the entity
			for _,v in ipairs(comp.owner.components) do
				if v.is_working then
					res = v
					break
				end
			end
		elseif res and not res.is_working then
			res = nil
		end
		if out_component_id then -- Return when finding any working component
			Set(comp, state, out_component_id, res and { id = res.id, num = res.interface_order } )
		end
		if not res then
			state.counter = not_working
		end
	end,
	args = {
		{ 'exec', "Is Not Working", "If the requested component is NOT currently working" },
		{ 'in', "Component", "Specific component to check or empty to check all components", 'comp' },
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'out', "Value", "Returns the currently working component", nil, true },
	},
	explain = [[Checks if a component is currently functioning and returns the component if so.]],
	name = "Is Working",
	desc = "Checks whether a particular component is currently working",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
}

data.instructions.get_equipped_num = {
	func = function(comp, state, cause, getcomp, value, entity_in)
		local getcompreg = Get(comp, state, getcomp)
		local getcompid = getcompreg and getcompreg.id
		if not getcompid then Set(comp, state, value, nil) return end
		local target_entity = GetEntity(comp, state, entity_in)

		if target_entity then
			if not comp.faction:IsSeen(target_entity) then
				Set(comp, state, value, nil)
				return
			end
		else
			if entity_in then Set(comp, state, value, nil) return end
			target_entity = comp.owner
		end

		Set(comp, state, value, { id = getcompid, num = target_entity:CountComponents(getcompid) } )
	end,
	args = {
		{ 'in', "Component ID", "Component to search for", 'comp_num' },
		{ 'out', "Value" },
		{ 'in', "Unit", "The unit to check (if not self)", 'entity', true },
	},
	explain = [[Returns how many of a specific component are equipped on a unit.]],
	name = "Get Equipped Num",
	desc = "Returns how many of a component are equipped",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
}

data.instructions.combine_register =
{
	func = function(comp, state, cause, in_num, in_data, out_result, in_x, in_y)
		local num_reg = in_num and Get(comp, state, in_num)
		local num = num_reg and not num_reg.is_empty and num_reg.num
		local res = Tool.NewRegisterObject(in_data and Get(comp, state, in_data))
		if num or not res.is_empty then res.num = num or 0 end -- clear num from data
		if (in_x or in_y) and (res.is_empty or (not res.id and not res.entity)) then
			local x, y = in_x and Get(comp, state, in_x), in_y and Get(comp, state, in_y)
			if (x and not x.is_empty) or (y and not y.is_empty) then
				x, y = (x and x.num) or 0, (y and y.num) or 0
				res.coord_x, res.coord_y = (x > REG_NOT and x or 0), (y > REG_NOT and y or 0)
			end
		end
		Set(comp, state, out_result, res)
	end,
	args = {
		{ 'in', "Number", nil, 'num' },
		{ 'in', "Data", nil, 'data' },
		{ 'out', "Result" },
		{ 'in', "X", nil, 'num', true },
		{ 'in', "Y", nil, 'num', true },
	},
	explain = [[Creates a register from individual parts: Number and data (identifier, target reference or coordinate) or separate coordinate X and Y.

Note: A Register can hold a number and one of the following: Identifier, target reference, coordinate.]],
	name = "Combine",
	altnames = { "Set Number", "Set Data", "Combine Coordinate" },
	desc = "Combine to make a register from separate parameters",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
}

data.instructions.separate_register =
{
	func = function(comp, state, cause, in_register, out_num, out_entity, out_id, out_x, out_y, out_coord, out_data)
		local in_reg = Get(comp, state, in_register)
		local in_id = in_reg.id
		local in_entity = not in_id and in_reg.raw_entity
		local in_coord = not in_id and not in_entity and in_reg.coord
		if out_num    then Set(comp, state, out_num,    not in_reg.is_empty and in_reg.num) end
		if out_id     then Set(comp, state, out_id,     in_id                             ) end
		if out_entity then Set(comp, state, out_entity, in_entity                         ) end
		if out_x      then Set(comp, state, out_x,      in_coord and in_coord.x           ) end
		if out_y      then Set(comp, state, out_y,      in_coord and in_coord.y           ) end
		if out_coord  then Set(comp, state, out_coord,  in_coord                          ) end
		if out_data   then Set(comp, state, out_data,   { id = in_id, entity = in_entity, coord = in_coord }) end
	end,
	args = {
		{ 'in', "Register", nil, 'any' },
		{ 'out', "Number" },
		{ 'out', "Target Reference", nil, nil, true },
		{ 'out', "Identifier", nil, nil, true },
		{ 'out', "X", nil, nil, true },
		{ 'out', "Y", nil, nil, true },
		{ 'out', "Coordinate", nil, nil, true },
		{ 'out', "Data", nil, nil, true },
	},
	explain = [[Splits a register into its individual parts: Number, identifier, target reference, coordinate x and y.]],
	name = "Separate",
	altnames = { "Separate Coordinate" },
	desc = "Split a register into separate parameters",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
}

data.instructions.sqrt = {
	func = function(comp, state, cause, in_num, out_sqrt)
		local reg = Get(comp, state, in_num)
		local num = reg.num
		Set(comp, state, out_sqrt, Tool.NewRegisterObject(reg, num < 0 and REG_INFINITE or math.floor(math.sqrt(num)))) -- don't modify input
	end,
	args = {
		{ 'in', "Num", nil, 'num' },
		{ 'out', "Result" },
	},
	name = "Square Root",
	altnames = { "Sqrt" },
	desc = "Get the square root of a number",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Calculates the integer square root of <hl>Num</> and writes it to <hl>Result</>.

The result keeps the original register data part and replaces only the numerical part. Negative inputs return the infinite value.]],
}

data.instructions.bitwise_op = {
	func = function(comp, state, cause, op_type, in_val1, in_val2, out_val)
		local val = Get(comp, state, in_val1)
		local a, b, result = val.num, GetNum(comp, state, in_val2), 0

		if     op_type ==  1 then result = a & b  -- AND
		elseif op_type ==  2 then result = a | b  -- OR
		elseif op_type ==  3 then result = a ~ b  -- XOR
		elseif op_type ==  4 then result = ~a     -- NOT (ignores b)
		elseif op_type ==  5 then result = a << b -- Shift Left
		elseif op_type ==  6 then result = a >> b -- Shift Right
		elseif op_type ==  7 then result = a == b and 1 or 0 -- Compare Equal
		elseif op_type ==  8 then result = a >  b and 1 or 0 -- Compare Larger
		elseif op_type ==  9 then result = a >= b and 1 or 0 -- Compare Larger or Equal
		elseif op_type == 10 then result = a + b             -- Add
		elseif op_type == 11 then result = a - b             -- Subtract
		elseif op_type == 12 then result = a * b             -- Multiply
		elseif op_type == 13 then result = a // b            -- Divide
		elseif op_type == 14 then result = a % b             -- Modulo
		end

		Set(comp, state, out_val, Tool.NewRegisterObject(val, result))
	end,
	make_asm = MakeASMInstCOrOne,
	args = {
		{ 'in', "A", "First value (or value for NOT)", 'num' },
		{ 'in', "B", "Second value (ignored for NOT)", 'num' },
		{ 'out', "Result", "Bitwise operation result" },
	},
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "AND", "OR", "XOR", "NOT", "Shift Left", "Shift Right", "Compare Equal", "Compare Larger", "Compare Larger or Equal", "Add", "Subtract", "Multiply", "Divide", "Modulo" })
	end,
	name = "Bitwise Op",
	desc = "Performs a bitwise operation on two values",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Performs bitwise logic on two numbers.]],
}

data.instructions.check_bit = {
	func = function(comp, state, cause, exec_clear, in_value, in_bit_index)
		local value = GetNum(comp, state, in_value)
		local bit_index = GetNum(comp, state, in_bit_index)

		if bit_index <= 0 or bit_index > 32 then
			state.counter = exec_clear
		end

		local mask = 1 << (bit_index-1)
		if (value & mask) == 0 then
			state.counter = exec_clear
		end
	end,

	args = {
		{ 'exec', "Bit Clear", "Execution path if bit is clear" },
		{ 'in', "Value", "The number to check", 'num' },
		{ 'in', "Bit Index", "Bit index (1 = least significant)", 'num' },
	},

	exec_arg = { 1, "Bit Set", "Execution path if bit is set" },
	name = "Check Bit",
	desc = "Checks if a specific bit is set in a number",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Checks whether the bit at a specific index is set in the input <hl>Value</>. The index is 1-based (1 = least significant bit).

If the bit is set (1), execution jumps to the <hl>Bit Set</> path.
If the bit is clear (0), execution jumps to the <hl>Bit Clear</> path.]],
}

data.instructions.add =
{
	func = function(comp, state, cause, left, right, res)
		Set(comp, state, res, Get(comp, state, left) + Get(comp, state, right))
	end,
	args = {
		{ 'in', "To", nil, 'any' },
		{ 'in', "Num", nil, 'coord_num' },
		{ 'out', "Result" },
	},
	explain = [[Adds two values together and returns the result.]],
	name = "Add",
	desc = "Adds a number or coordinate to another number or coordinate",
	sample = "4n3YxVw80sfebZ3FYilH1mhyfZ1aqqXJ3mEgt61mSlGp1lR1A02pEzn83JGOGx2yjtHI03dj7c393Dme48tMBM0oR9Wf3gYKqo4Ir13P0oIFCO1kWMsT3Fqfg00LjJLm4bI1Jf2giIcU4BzdP64d1urc15VNyW2ReA392sJGaE32eOpU00IptM4J1AVYH",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Add Numbers.png",
}

data.instructions.sub =
{
	func = function(comp, state, cause, left, right, res)
		Set(comp, state, res, Get(comp, state, left) - Get(comp, state, right))
	end,
	args = {
		{ 'in', "From", nil, 'any' },
		{ 'in', "Num", nil, 'coord_num' },
		{ 'out', "Result" },
	},
	explain = [[Subtracts the value in <hl>Num</> from the value in <hl>From</> and stores the result.]],
	name = "Subtract",
	desc = "Subtracts a number or coordinate from another number or coordinate",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Substact Numbers.png",
}

data.instructions.mul =
{
	func = function(comp, state, cause, left, right, res)
		Set(comp, state, res, Get(comp, state, left) * Get(comp, state, right))
	end,
	args = {
		{ 'in', "To", nil, 'any' },
		{ 'in', "Num", nil, 'coord_num' },
		{ 'out', "Result" },
	},
	explain = [[Multiplies two values and returns the result.]],
	name = "Multiply",
	desc = "Multiplies a number or coordinate from another number or coordinate",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Mul Numbers.png",
}

data.instructions.div =
{
	func = function(comp, state, cause, rounding, left, right, out, remainder)
		if remainder then
			local q, r = Get(comp, state, left):Divide(Get(comp, state, right), rounding)
			Set(comp, state, out, q)
			Set(comp, state, remainder, r)
		else
			local q = Get(comp, state, left):Divide(Get(comp, state, right), rounding)
			Set(comp, state, out, q)
		end
	end,
	make_asm = MakeASMInstCOrOne,
	args = {
		{ 'in', "From", nil, 'any' },
		{ 'in', "Num", nil, 'coord_num' },
		{ 'out', "Result" },
		{ 'out', "Remainder", nil, nil, true },
	},
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local texts = { "Floor Rounding", "Ceil Rounding", "Truncate Rounding", "Nearest Rounding" }
		local tips = { "Rounding towards negative infinity", "Rounding towards positive infinity", "Rounding towards zero", "Rounding to nearest, half to even" }
		return NodeUICombo(canvas, inst, program_ui, texts, 1, tips, show_extra or false)
	end,
	category = "Values",
	name = "Divide",
	altnames = { "Modulo" },
	desc = "Divides a number or coordinate by another number or coordinate, optionally also returning the remainder",
	explain = [[Divides the value in <hl>From</> by the value in <hl>Num</> and stores the integer result rounded by the selected method. Optionally the remainder can also be returned.]],
	icon = "Main/skin/Icons/Special/Commands/Divide Numbers.png",
}

data.instructions.random_number = {
	func = function(comp, state, cause, min, max, out_num)
		local min_num, max_num = GetNum(comp, state, min), GetNum(comp, state, max)
		if (min_num == REG_INFINITE or max_num == REG_INFINITE) or (min_num == 0 and max_num == 0) then Set(comp, state, out_num, nil) return end
		if min_num == max_num then Set(comp, state, out_num, min_num) return end
		if min_num > max_num then local num = min_num min_num = max_num max_num = num end
		Set(comp, state, out_num, math.random(min_num, max_num))
	end,
	args = {
		{ 'in', "Min", nil, 'num' },
		{ 'in', "Max", nil, 'num' },
		{ 'out', "Result" },
	},
	name = "Random Number",
	desc = "Returns a random number value between a min and max value",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Generates a random number between and including the specified minimum and maximum numbers.]],
}

data.instructions.random_coordinate = {
	func = function(comp, state, cause, in_value, in_range, out_coord)
		local range, ent = math.max(GetNum(comp, state, in_range), 0), GetEntity(comp, state, in_value)
		local coord = ent and comp.faction:IsSeen(ent) and ent.location or GetCoord(comp, state, in_value)
		Set(comp, state, out_coord, { (coord and coord.x or 0) + math.random(-range, range), (coord and coord.y or 0) + math.random(-range, range) })
	end,
	args = {
		{ 'in', "Source", "The unit or coordinate to start from (if not use 0,0)", 'coord', true },
		{ 'in', "Range", "Radius range from source", 'posnum' },
		{ 'out', "Result" },
	},
	name = "Random Coordinate",
	desc = "Returns a random coordinate from a location within a specified range",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	sample = "4n3YxVw80sfebZ3FYilH1mhyfZ1aqqXJ3mEgt61mSlGp1lR1A02pEzn83JGOGx2yjtHI03dj7c393Dme48tMBM0oR9Wf3gYKqo4Ir13P0oIFCO1kWMsT3Fqfg00LjJLm4bI1Jf2giIcU4BzdP64d1urc15VNyW2ReA392sJGaE32eOpU00IptM4J1AVYH",
	explain = [[Generates a random coordinate within a certain range, which can include inaccessible coordinates.]],
}

data.instructions.getfreespace = {
	func = function(comp, state, cause, item_in, item_out, in_unit)
		local ent = GetAllyEntityOrSelf(comp, state, in_unit)
		if not ent then Set(comp, state, item_out, nil) return end
		local item_id = GetId(comp, state, item_in)
		local item_entity = not item_id and GetEntity(comp, state, item_in)
		if item_entity then
			if IsDroppedItem(item_entity) then
				for _,v in ipairs(item_entity.slots) do
					if v.id and v.unreserved_stack > 0 and ent:HaveFreeSpace(v.id) then
						item_id = v.id
						break
					end
				end
			else
				item_id = IsResource(item_entity) and GetResourceHarvestItemId(item_entity) or item_entity.id
			end
		end
		Set(comp, state, item_out, item_id and { id = item_id, num = ent:CountFreeSpace(item_id) })
	end,
	args = {
		{ 'in', "Item", "Item or target reference to check", 'item' },
		{ 'out', "Result", "Number of a specific item that can fit on a unit" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	explain = [[Calculates how many of a specific item can fit into a unit's inventory.

Besides an item identifier, a target reference to a resource node, dropped item or dockable unit can be passed.]],
	name = "Get Space for Item",
	desc = "Returns how many of the input item can fit in the inventory",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
}

data.instructions.checkfreespace = {
	func = function(comp, state, cause, if_cantfit, item_in, in_unit)
		local ent = GetAllyEntityOrSelf(comp, state, in_unit)
		if not ent then state.counter = if_cantfit end
		local item_reg = Get(comp, state, item_in)
		local item_id = item_reg.id
		local item_entity = not item_id and item_reg.entity
		if item_entity then
			if IsDroppedItem(item_entity) then
				for _,v in ipairs(item_entity.slots) do
					if v.id and v.unreserved_stack > 0 and ent:HaveFreeSpace(v.id) then
						return
					end
				end
			else
				item_id = IsResource(item_entity) and GetResourceHarvestItemId(item_entity) or item_entity.id
			end
		end
		if not item_id or not ent:HaveFreeSpace(item_id, math.max(item_reg.num, 1)) then state.counter = if_cantfit end
	end,
	args = {
		{ 'exec', "Can't Fit", "Execution if it can't fit the item" },
		{ 'in', "Item", "Item or target reference and amount to check", 'item_num' },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	explain = [[Checks if a unit has enough inventory space to store a given item and quantity.

Besides an item identifier, a target reference to a resource node, dropped item or dockable unit can be passed.]],
	name = "Check Space for Item",
	desc = "Checks if free space is available for an item and amount",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
}

data.instructions.lock_slots = {
	func = function(comp, state, cause, c, item_in, in_slot_index)
		local owner = comp.owner
		local slot_count = owner.slot_count
		if slot_count == 0 then return end

		local item_id = GetId(comp, state, item_in)
		local item_def = item_id and data.all[item_id]
		local need_type = item_def and (item_def.slot_type or "storage")
		local slot_index = in_slot_index and GetNum(comp, state, in_slot_index)
		if slot_index and slot_index <= 0 then slot_index = nil end

		-- Do nothing if slot_index is out of range
		for i=(slot_index or 1),(slot_index and (slot_index > slot_count and 0 or slot_index) or slot_count) do
			local slot = owner:GetSlot(i)
			if c == 2 or not slot.locked then -- only override locked slots if its set to override
				if not need_type or slot.type == need_type then -- only affect slots with a matching type (unless locking to empty)
					slot:SetLockedItem(item_id)
				end
			end
		end
	end,
	make_asm = MakeASMInstCOrOne,
	args = {
		{ 'in', "Item", "Item type to try locking to the slots", 'item_num' },
		{ 'in', "Slot Index", "Individual slot to lock", 'posnum', true },
	},
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Only Unlocked", "Override Locked" })
	end,
	name = "Lock Item Slots",
	desc = "Locks one or all item slots to a given item",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
	sample = "2d3bEIye2qnppo1wlqdV2piXHJ4colJi49hpUS49FnY40DeO5V1nK8gH4JRU453rnJr82huMTb1NlveV1qm7Hu1DhRzS3INCCr06d0Qc",
	explain = [[If the specified item is empty, slots will be locked as empty. Otherwise, only slots with a matching type are modified (i.e. Storage or Gas).]]
}

data.instructions.unlock_slots = {
	func = function(comp, state, cause, in_slot_index)
		local owner = comp.owner
		local slot_count = owner.slot_count
		if slot_count == 0 then return end

		local slot_index = in_slot_index and GetNum(comp, state, in_slot_index)
		if slot_index and slot_index <= 0 then slot_index = nil end

		-- Do nothing if slot_index is out of range
		for i=(slot_index or 1),(slot_index and (slot_index > slot_count and 0 or slot_index) or slot_count) do
			owner:GetSlot(i).locked = false
		end
	end,
	args = {
		{ 'in', "Slot Index", "Individual slot to unlock", 'posnum', true },
	},
	name = "Unlock Item Slots",
	desc = "Unlocks one or all item slots",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
}

data.instructions.get_health = {
	func = function(comp, state, cause, target, percent, current, max)
		local target_entity = GetAllyEntityOrSelf(comp, state, target)
		local h, mh = target_entity and target_entity.health, target_entity and target_entity.max_health
		if percent then Set(comp, state, percent, h and { entity = target_entity, num = math.floor(h*100/mh) }) end
		if current then Set(comp, state, current, h and { entity = target_entity, num = h }) end
		if max then Set(comp, state, max, h and { entity = target_entity, num = mh }) end
	end,
	args = {
		{ 'in', "Unit", "Unit to check", 'entity' },
		{ 'out', "Percent", "Percentage of health remaining" },
		{ 'out', "Current", "Value of health remaining", nil, true },
		{ 'out', "Max", "Value of maximum health", nil, true },
	},
	name = "Get Health",
	desc = "Gets a unit's health as a percentage, current remaining and max amount",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/H Value.png",
	explain = [[Gets health values for a Unit. Defaults to the unit the behavior is executing on.

<hl>Percent</> is the current health as a percentage of max health
<hl>Current</> is the actual amount of health points left
<hl>Max</> is the maximum amount of health points

Optional <hl>Unit</> parameter to specify a different unit in your faction.]],
}

data.instructions.get_shield = {
	func = function(comp, state, cause, target, percent, current, max)
		local target_entity, s, ms = GetAllyEntityOrSelf(comp, state, target)
		if target_entity then
			s, ms = 0, 0
			for _,v in ipairs(target_entity.components or {}) do
				local shield_max = v.def.shield_max
				if shield_max then
					s, ms = s + (v.has_extra_data and v.extra_data.stored or 0), ms + shield_max
				end
			end
		end
		if percent then Set(comp, state, percent, s and { entity = target_entity, num = math.floor(s*100/(ms > 0 and ms or 1)) }) end
		if current then Set(comp, state, current, s and { entity = target_entity, num = s }) end
		if max then Set(comp, state, max, s and { entity = target_entity, num = ms }) end
	end,
	args = {
		{ 'in', "Unit", "Unit to check", 'entity' },
		{ 'out', "Percent", "Percentage of shield remaining" },
		{ 'out', "Current", "Value of shield remaining", nil, true },
		{ 'out', "Max", "Value of maximum shield amount", nil, true },
	},
	name = "Get Shield",
	desc = "Get a unit's shield as a percentage, current remaining and max amount",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/H Value.png",
	explain = [[Returns the current shield value of a unit, if equipped.]],
}

data.instructions.get_entity_at = {
	func = function(comp, state, cause, in_coord, out_result)
		local coord = GetCoord(comp, state, in_coord)
		if not coord then
			Set(comp, state, out_result)
		else
			local result = Map.GetEntityAt(coord.x, coord.y)
			if result and comp.faction:IsSeen(result) then
				Set(comp, state, out_result, result)
			else
				Set(comp, state, out_result)
			end
		end
	end,
	args = {
		{ 'in', "Coordinate", "Coordinate to get Unit from", 'coord' },
		{ 'out', "Result" },
	},
	name = "Get Unit At",
	desc = "Gets the best matching unit at a coordinate",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/Power.png",
	explain = [[Returns the unit located at a specific coordinate if visible.]],
}

data.instructions.get_battery = {
	func = function(comp, state, cause, out_percent, in_unit, out_curr, out_max)
		local ent = GetAllyEntityOrSelf(comp, state, in_unit)
		if out_percent then Set(comp, state, out_percent, ent and { entity = ent, num = ent.battery_percent }) end
		if out_curr then Set(comp, state, out_curr, ent and { entity = ent, num = ent.battery_stored }) end
		if out_max then Set(comp, state, out_max, ent and { entity = ent, num = ent.battery_total }) end
	end,
	args = {
		{ 'out', "Percent" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
		{ 'out', "Current", "Value of battery remaining", nil, true },
		{ 'out', "Max", "Value of maximum battery amount", nil, true },
	},
	name = "Get Battery",
	desc = "Gets the value of the Battery level as a percent",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Check Battery.png",

	explain = [[Returns the unit and current battery level percentage as a number in the <hl>Result</> parameter.

When multiple batteries are equipped, all batteries will be calculated.

A unit that has no batteries equipped will always return zero, even while inside a power grid that has <bl>Unused</> power.]],
}

data.instructions.get_self = {
	func = function(comp, state, cause, out_entity, out_comp)
		if out_entity then Set(comp, state, out_entity, comp.owner) end
		if out_comp then Set(comp, state, out_comp, { id = comp.id, num = comp.interface_order }) end
	end,
	args = {
		{ 'out', "Unit Reference" },
		{ 'out', "Component/Index", "The component identifier and equipped index of the running behavior controller", nil, true },
	},
	name = "Get Self",
	desc = "Gets the value of the Unit running the behavior",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
	sample = "V02rugE1CW6YQ1rAMqo34kZAG1kNZqx1sI96h00UuuY0FuEN730UuGE1tR5zU00UuuY016",
	explain = [[Returns a reference to the unit running the behavior.]],
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- UNIT -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

data.instructions.read_signal = {
	func = function(comp, state, cause, in_unit, res)
		local ent = GetEntity(comp, state, in_unit)
		Set(comp, state, res, ent and ent:GetRegister(FRAMEREG_SIGNAL))
	end,
	args = {
		{ 'in', "Unit", "The owned unit to check for", 'entity' },
		{ 'out', "Result", "Value of units Signal register" },
	},
	name = "Read Signal",
	desc = "Reads the Signal register of another unit",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Scan.png",
	explain = [[Reads the current value of the <hl>Signal</> register from a Unit. This instruction does not require a signal reading component to be equipped.]],
}

data.instructions.read_radio =
{
	func = function(comp, state, cause, in_band, res)
		local radio_storage = comp.faction.extra_data.radio_storage
		local radio_storage_bands = radio_storage and radio_storage.extra_data.bands
		if not radio_storage_bands then Set(comp, state, res) return end

		local band, idx = Get(comp, state, in_band)
		for i,v in ipairs(radio_storage_bands) do
			if v == band then
				idx = i
				break
			end
		end

		if not idx then Set(comp, state, res) return end
		Set(comp, state, res, radio_storage:GetRegister(idx))
	end,
	args = {
		{ 'in', "Band", "The band to check for" },
		{ 'out', "Result", "Value of the radio signal" },
	},
	name = "Read Radio",
	desc = "Reads the Radio signal on a specified band",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Scan.png",
	explain = [[Receives and processes a message from the radio system. This instruction does not require a radio receiving component to be equipped.]],
}

data.instructions.for_signal_match = {
	func = function(comp, state, cause, filter_type, in_signal, out_unit, out_signal, exec_done)
		local signal, owner, it = Get(comp, state, in_signal), comp.owner, { 2 }
		local signal_id = signal.id
		local radar_filters = signal_id and filter_type < 12 and filter_type > -10 and { signal_id, signal.num }
		local entity_filter = radar_filters and PrepareFilterEntity(radar_filters)
		for _,e in ipairs(owner.faction:GetEntitiesWithRegister(FRAMEREG_SIGNAL, filter_type, signal, entity_filter)) do
			local e_sig = e:GetRegister(FRAMEREG_SIGNAL)
			local e_sig_entity = radar_filters and e_sig.entity
			if e_sig_entity then
				local ret, num = FilterEntity(owner, e_sig_entity, radar_filters)
				if not ret then goto skip end
				if num then e_sig.num = num end
			end
			it[#it+1] = e
			it[#it+1] = e_sig
			::skip::
		end
		if #it > 1 then return BeginBlock(comp, state, it, 2) end
		if out_unit then Set(comp, state, out_unit, nil) end
		if out_signal then Set(comp, state, out_signal, nil) end
		state.counter = exec_done
	end,
	make_asm = function(inst) return math.abs(inst.c or 1) end,
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		return NodeUIComparison(canvas, inst, program_ui, show_extra or false)
	end,

	next = function(comp, state, it, filter_type, in_signal, out_unit, out_signal, exec_done)
		local i = it[1]
		if i > #it then return true end
		if out_unit then Set(comp, state, out_unit, it[i]) end
		if out_signal then Set(comp, state, out_signal, it[i+1]) end
		it[1] = i + 2
	end,

	last = function(comp, state, it, filter_type, in_signal, out_unit, out_signal, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'in', "Signal Filter", "Signal value to match against" },
		{ 'out', "Unit", "Found Unit with signal" },
		{ 'out', "Signal", "Found signal", 'entity', true },
		{ 'exec', "Done", "Finished looping through all units with signal" },
	},
	name = "Loop Signal",
	desc = "Loops through all units with a signal of similar type and additional number checks",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Loops through signal inputs and returns only those matching specific criteria.]],
}

data.instructions.check_altitude = {
	func = function(comp, state, cause, c, in_target, if_valley, if_plateau)
		local ent, val = GetSeenEntityOrSelf(comp, state, in_target)
		if not ent then
			local coord = GetCoord(comp, state, in_target)
			if not coord or not comp.faction:IsDiscovered(coord) then
				return
			end
			val = Map.GetPlateauDelta(coord.x, coord.y, -1)
		else
			val = Map.GetPlateauDelta(ent, -1)
		end
		if val >= (c == 2 and -0.1 or 0) then
			state.counter = if_plateau
		else
			state.counter = if_valley
		end
	end,
	exec_arg = { 4, "No Visibility", "No visibility on target" },
	args = {
		{ 'in', "Target", "The unit or coordinate to check for (if not self)", 'coord', true },
		{ 'exec', "Valley", "Where to continue if the unit or coordinate is in a valley" },
		{ 'exec', "Plateau", "Where to continue if the unit or coordinate is on a plateau" },
	},
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local texts = { "Top of Plateau", "Increased Wind" }
		local tips = { "Check if the location is on the plateau", "Check if location is high enough for increased wind power" }
		return NodeUICombo(canvas, inst, program_ui, texts, 1, tips, show_extra or false)
	end,
	name = "Check Altitude",
	desc = "Divert program depending on the altitude at a unit or coordinate",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Branches execution based on the altitude at a location.

<img image="Main/textures/behaviors/check_altitude.png"/>

Optional parameter <hl>Target</> can specify a different unit or a specific coordinate to check.]],
}

data.instructions.check_blight = {
	func = function(comp, state, cause, c, in_target, if_blight, if_outside)
		local ent, val = GetSeenEntityOrSelf(comp, state, in_target)
		if not ent then
			local coord = GetCoord(comp, state, in_target)
			if not coord or not comp.faction:IsDiscovered(coord) then
				return
			end
			val = Map.GetBlightnessDelta(coord.x, coord.y, -1)
		else
			val = Map.GetBlightnessDelta(ent, -1)
		end
		if val >= (c == 2 and -0.02 or 0) then
			state.counter = if_blight
		else
			state.counter = if_outside
		end
	end,
	exec_arg = { 4, "No Visibility", "No visibility on target" },
	args = {
		{ 'in', "Target", "The unit or coordinate to check for (if not self)", 'coord', true },
		{ 'exec', "Blight", "Where to continue if the unit or coordinate is in the blight" },
		{ 'exec', "Outside", "Where to continue if the unit or coordinate is outside the blight" },
	},
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local texts = { "Fully Inside", "Near Blight" }
		local tips = { "Check if the location is in the blight", "Check if blight gas can be extracted at this location" }
		return NodeUICombo(canvas, inst, program_ui, texts, 1, tips, show_extra or false)
	end,
	name = "Check Blight",
	desc = "Divert program depending on the blightness at a unit or coordinate",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Branches execution depending on whether a location is inside the <hl>blight</>.

Optional parameter <hl>Target</> can specify a different unit or a specific coordinate to check.]],
}

data.instructions.check_health =
{
	func = function(comp, state, cause, if_full, in_unit)
		local ent = GetAllyEntityOrSelf(comp, state, in_unit)
		if ent and not ent.is_damaged then
			state.counter = if_full
		end
	end,
	args = {
		{ 'exec', "Full", "Where to continue if at full health" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	name = "Check Health",
	desc = "Checks a unit's health",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/H Value.png",
	explain = [[Checks a unit's current health and continues execution based on the result. Defaults to the unit the behavior is running on.

Optional <hl>Unit</> parameter to specify a different unit in your faction.]],
}

data.instructions.check_battery =
{
	func = function(comp, state, cause, if_full, in_unit)
		local ent = GetAllyEntityOrSelf(comp, state, in_unit)
		if ent and ent.battery_percent == 100 then
			state.counter = if_full
		end
	end,
	args = {
		{ 'exec', "Full", "Where to continue if battery power is fully recharged" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	name = "Check Battery",
	desc = "Checks the battery level of a unit",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Check Battery.png",
	explain = [[Conditional node which diverts program logic depending on whether a unit's battery power reserves are <hl>Full</>. Defaults to the unit the behavior is running on.

A unit that has no batteries equipped will never be <hl>Full</>, even while inside a power grid that has <bl>Unused</> power. When multiple batteries are equipped all will need to be full.

An optional <hl>Unit</> parameter allows specifying a different unit in your faction.]],
}

data.instructions.check_grid_effeciency =
{
	func = function(comp, state, cause, if_full, in_target)
		local loc, faction = (not in_target and comp.owner) or GetEntity(comp, state, in_target) or GetCoord(comp, state, in_target), comp.faction
		local grid_index = loc and faction:GetPowerGridIndexAt(loc)
		local grid = grid_index and faction:GetPowerGrid(grid_index)
		if grid and grid.efficiency == 100 then
			state.counter = if_full
		end
	end,
	args = {
		{ 'exec', "Full", "Where to continue if at full efficiency" },
		{ 'in', "Target", "The unit or coordinate to check for (if not self)", 'coord', true },
	},
	name = "Check Efficiency",
	desc = "Checks the power efficiency of the logistics network the unit or coordinate is on",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/Power.png",
}

data.instructions.count_item = {
	func = function(comp, state, cause, c, item, output, in_unit)
		local ent = GetAllyEntityOrSelf(comp, state, in_unit)
		if not ent then
			Set(comp, state, output, nil)
			return
		end

		local ent_slots, item_id, total = ent and ent.slots, GetId(comp, state, item), 0
		if ent_slots then
			for i,v in ipairs(ent_slots) do
				if v.id then
					if not item_id or v.id == item_id then
						if c == 2 then
							total = total + v.reserved_stack
						else
							total = total + v.stack
						end
					end
				end
			end
		end
		Set(comp, state, output, { item = item_id, num = total })
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Remaining", "Reserved" })
	end,
	args = {
		{ 'in', "Item", "Item to count", 'item' },
		{ 'out', "Result", "Number of this item in inventory or empty if none exist" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	name = "Count Items",
	desc = "Counts the number of the passed item contained in the unit's inventory",
	category = "Inventory",
	sample = "V058hik2woTaI21cbOz00W1gr22TIuo1kNaSL20D0P300UuuY3HEnhN02q3fd21cPWy39I8mL1or2Op29Kcbj25sxo500UuuYm",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Counts how many of a specific item is stored in a unit's inventory.

You can request how many items are <hl>Remaining</> in the unit or how many are <hl>Reserved</>.]],
}

local function GetNumSockets(frame_def, e, socket_size)
	local visual_def = ((e and e.visual_def) or (type(frame_def.visual) == "table" and frame_def.visual or data.visuals[frame_def.visual]))
	local sockets, res = visual_def and visual_def.sockets, 0
	if not sockets then return 0 end
	for _,v in ipairs(sockets) do if v[2] == socket_size then res = res + 1 end end
	return res
end

local function GetFrameDefSize(frame_def, get_width)
	local visual_def = (type(frame_def.visual) == "table" and frame_def.visual or data.visuals[frame_def.visual])
	local tile_size = visual_def and visual_def.tile_size
	return tile_size and tile_size[get_width and 1 or 2] or 1
end

local stats_unit = {
	{ function(def, e) return e and e.max_health or def.health_points or 100 end, "Durability" },
	{ function(def, e) return e and e.visibility_range or def.visibility_range or 0 end, "Visibility Range" },
	{ function(def, e) return e and math.floor((e.def.movement_speed or 0) * e.move_boost * 0.01 + 0.5) or def.movement_speed or 0 end, "Movement Speed" },
	{ function(def, e) return GetNumSockets(def, e, "Internal") end, "Internal Sockets", true },
	{ function(def, e) return GetNumSockets(def, e, "Small") end, "Small Sockets", true },
	{ function(def, e) return GetNumSockets(def, e, "Medium") end, "Medium Sockets", true },
	{ function(def, e) return GetNumSockets(def, e, "Large") end, "Large Sockets", true },
	{ function(def, e) return e and e.size.x or GetFrameDefSize(def, true) end, "Width", true },
	{ function(def, e) return e and e.size.y or GetFrameDefSize(def, false) end, "Height", true },
}

local stats_power = {
	{ function(pd) return pd and pd.produced*TICKS_PER_SECOND or 0 end, "Producing" },
	{ function(pd) return pd and pd.required*TICKS_PER_SECOND or 0 end, "Requiring" },
	{ function(pd) return pd and pd.efficiency or 100 end, "Efficiency" },
	{ function(pd) return pd and pd.consumed*TICKS_PER_SECOND or 0 end, "Consuming" },
	{ function(pd) return pd and pd.received*TICKS_PER_SECOND or 0 end, "Receiving" },
	{ function(pd) return pd and pd.transmitted*TICKS_PER_SECOND or 0 end, "Transmitting" },
}

local stats_item = {
	{ "stack_size", "Maximum Stack" },
	{ function(def) return def.range or def.attack_radius or def.transfer_radius or def.miner_range or def.trigger_radius end, "Range" },
	{ "minimum_range", "Min. Range" },
	{ "damage", "Damage" },
	{ function(def) return def.damage_type and data.damage_names[def.damage_type] or 0 end, "Damage Type"} ,
	{ "blast", "Blast Radius" },
	{ function(def) return def.shoot_while_moving and 1 or 0 end, "Move and Fire" },
	{ function(def) return (def.damage and def.charge_time) and math.ceil((def.damage*TICKS_PER_SECOND)/def.charge_time) or 0 end, "DPS" },
	{ "power_storage", "Power Storage" },
	{ function(def) return (def.drain_rate or 0)*TICKS_PER_SECOND end, "Drain Rate" },
	{ function(def) return (def.charge_rate or 0)*TICKS_PER_SECOND end, "Charge Rate" },
	{ function(def) return (def.bandwidth or 0)*TICKS_PER_SECOND end, "Bandwidth" },
	{ "drone_range", "Drone Range" },
	{ function(def) return (def.power or 0)*TICKS_PER_SECOND end, "Power" },
	{ function(def) return (def.charge_time or 0) end, "Charge Time (Ticks)" },
}

data.instructions.get_unit_info = {
	func = function(comp, state, cause, c, in_unit, output)
		local stat, id = stats_unit[c], in_unit and GetId(comp, state, in_unit)
		local entity = (not in_unit and comp.owner) or (not id and GetEntity(comp, state, in_unit))
		local my_entity = entity and (not in_unit or stat[3] or entity.faction:IsAlly(comp)) and entity
		local def = (id and data.frames[id]) or (not my_entity and entity and comp.faction:IsSeen(entity) and entity.def)
		local val = (my_entity or def) and stat[1](def, my_entity)
		Set(comp, state, output, val and { id = (my_entity and my_entity.id) or id or def.id, num = val })
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		local texts = {}
		for i,v in ipairs(stats_unit) do
			texts[#texts+1] = v[2]
		end
		return NodeUICombo(canvas, inst, program_ui, texts)
	end,
	args = {
		{ 'in', "Unit", "The unit type or target reference to check (if not self)", 'frame' },
		{ 'out', "Result" },
	},
	name = "Get Unit Info",
	desc = "Gets information on a unit",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Returns data about a specific unit such as the <bl>Durability</> or <bl>Visibility Range</>.

Return type info can be selected from the dropdown menu.]],
}

data.instructions.get_unit_power_info = {
	func = function(comp, state, cause, c, in_unit, output)
		local ent, val = GetAllyEntityOrSelf(comp, state, in_unit)
		if ent then
			local stat = stats_power[c][1]
			local power_details = ent.power_details
			val = stat and stat(power_details) or 0
		end
		Set(comp, state, output, val and { entity = ent, num = val })
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		local texts = {}
		for i,v in ipairs(stats_power) do
			texts[#texts+1] = v[2]
		end
		return NodeUICombo(canvas, inst, program_ui, texts)
	end,
	args = {
		{ 'in', "Unit", "The unit target reference to check (if not self)", 'entity' },
		{ 'out', "Result" },
	},
	name = "Get Unit Power Info",
	desc = "Gets power information on a unit",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Returns power information about a specific unit such as the power <bl>Producing</> or <bl>Receiving</>.

Return type info can be selected from the dropdown menu.]],
}

data.instructions.get_item_info = {
	func = function(comp, state, cause, c, in_id, output)
		local item_id, val = GetId(comp, state, in_id)
		if item_id then
			local def, stat = data.all[item_id], stats_item[c][1]
			if type(stat) == "string" and def then
				val = def[stat] or 0
			elseif def then
				val = stat(def)
			end
		end
		Set(comp, state, output, val and { id = item_id, num = val })
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		local texts = {}
		for i,v in ipairs(stats_item) do
			texts[#texts+1] = v[2]
		end
		return NodeUICombo(canvas, inst, program_ui, texts)
	end,
	args = {
		{ 'in', "Item", "The item to check", 'frame_item' },
		{ 'out', "Result" },
	},
	name = "Get Item Info",
	desc = "Gets information on an item",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Returns data about a specific item such as the <bl>Maximum Stack</> or <bl>Range</>.

Return type info can be selected from the dropdown menu.]],
}

local slottypes = { "ALL", "storage", "gas", "virus", "anomaly", "drone", "garage", "alien", "satellite" }

data.instructions.count_slots = {
	func = function(comp, state, cause, c, output, in_unit)
		local ent, stype, res = GetAllyEntityOrSelf(comp, state, in_unit), slottypes[c]
		local id = not ent and GetId(comp, state, in_unit)
		local def = id and data.frames[id]
		if def then
			local def_slots = def and def.slots
			if c == 1 then
				res = 0
				if def_slots then for _,v in pairs(def_slots) do res = res + v end end
			else
				res = def_slots and def_slots[stype] or 0
			end
		elseif ent then
			if c == 1 then
				res = ent.slot_count
			else
				res = 0
				local ent_slots = ent.slots
				if ent_slots then for _,v in ipairs(ent_slots) do if v.type == stype then res = res + 1 end end end
			end
		end
		Set(comp, state, output, res and { id = id, entity = ent, num = res })
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, slottypes)
	end,
	args = {
		{ 'out', "Result", "Number of slots of this type" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	name = "Count Slots",
	desc = "Returns the number of slots in this unit of the given type",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[This instruction returns the unit and the number of slots found using the search type.

Return type can be selected from the dropdown menu for a specific slot type or <bl>ALL</>.]],
}

data.instructions.get_max_stack = {
	func = function(comp, state, cause, in_item, out_stacksize)
		local id = Get(comp, state, in_item).item_id -- finds frames and components, too
		local def = data.all[id]
		Set(comp, state, out_stacksize, def and { id = id, num = def.stack_size or 1 })
	end,
	args = {
		{ 'in', "Item", "Item to count", 'item' },
		{ 'out', "Max Stack", "Max Stack", },
	},
	name = "Get Max Stack",
	desc = "Returns the amount an item can stack to",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Returns the maximum stack size for a specific item.]],
}

data.instructions.have_item = {
	func = function(comp, state, cause, item, exec_have, in_unit)
		local ent, reg = GetAllyEntityOrSelf(comp, state, in_unit), Get(comp, state, item)
		local item_id = reg.item_id
		if ent and item_id then
			local amt = ent:CountItem(item_id)
			local reg_num = reg.num
			if reg_num == REG_INFINITE then reg_num = 999999 end
			if amt >= reg_num then
				state.counter = exec_have
			end
		end
	end,
	args = {
		{ 'in', "Item", "Item to count", 'item_num' },
		{ 'exec', "Have Item", "have the specified item" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	name = "Have Item",
	desc = "Checks if you have at least a specified amount of an item",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Checks if a unit possesses a given item in its inventory and divert logic if the item exists.]],
}

data.instructions.can_equip = {
	func = function(comp, state, cause, in_unit, in_comp, exec_cant)
		local comp_id = GetId(comp, state, in_comp)
		if comp_id then
			local reg_id = GetId(comp, state, in_unit)
			local ent = not reg_id and GetAllyEntityOrSelf(comp, state, in_unit)
			if reg_id then -- check frame
				local comp_def = data.components[comp_id]
				local frame_def = comp_def and data.frames[reg_id]
				local visual = frame_def and frame_def.visual
				local visual_def = visual and ((type(visual) == "table" and visual or data.visuals[visual]))
				local sockets = visual_def and visual_def.sockets
				if sockets then
					local comp_sock_size = GetAttachmentSize(comp_def.attachment_size)
					for i,v in ipairs(sockets) do
						if comp_sock_size <= GetAttachmentSize(v[2]) then return end -- ok
					end
				end
			elseif ent and ent:GetFreeSocket(comp_id) then -- check entity
				return -- ok
			end
		end
		state.counter = exec_cant
	end,
	args = {
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
		{ 'in', "Component", "Component to equip", 'comp' },
		{ 'exec', "Cannot Equip", "If the component is unable to be equipped" },
	},
	name = "Can Equip",
	explain = [[Checks if a specific component can be equipped on the specified unit or frame type.

If a unit is able to equip a component it will check if there are available sockets.
If a unit type is passed it will check if the frame has any socket able to equip the component]],
	desc = "Checks if a component can be equipped on a unit",
	category = "Components",
	icon = "Main/skin/Icons/Common/56x56/Home.png",
}

data.instructions.equip_component = {
	func = function(comp, state, cause, if_failed, comp_id, slot_index, socket_index, in_unit)
		local ent = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if not ent then
			state.counter = if_failed
			return
		end

		comp_id, slot_index = (comp_id and GetId(comp, state, comp_id)), (slot_index and GetNum(comp, state, slot_index))
		local slot = (slot_index and ent:GetSlot(slot_index)) or (not slot_index and comp_id and ent:FindSlot(comp_id, 1))
		local slot_id = slot and ((slot_index and slot.unreserved_stack ~= 0 and slot.id) or (not slot_index and comp_id))
		if not slot_id or (comp_id and slot_id ~= comp_id) then
			state.counter = if_failed
			return
		end

		if socket_index then
			local socket_id, socket_num = (socket_index and GetId(comp, state, socket_index)), (socket_index and GetNum(comp, state, socket_index))
			local socket_comp = socket_id and ent:FindComponent(socket_id, false, (socket_num == 0 and 1 or socket_num), true)
			socket_index = (socket_id and (socket_comp and socket_comp.socket_index) or 0) or socket_num
		end

		local socket = (socket_index and ent:CheckSocketSize(slot_id, socket_index) and socket_index) or (not socket_index and ent:GetFreeSocket(slot_id))
		if not socket then
			state.counter = if_failed
			return
		end

		-- Don't allow swapping into storage slot of itself or locked slot
		local oldcomp = socket_index and ent:GetComponent(socket_index)
		if oldcomp and (slot.component == oldcomp or (slot.locked and slot.id ~= oldcomp.id)) then
			state.counter = if_failed
			return
		end

		Map.Defer(function()
			if not ent.exists or not slot.exists or slot.id ~= slot_id or (oldcomp and not oldcomp.exists) then return end
			if oldcomp and not oldcomp:PrepareRemoval() then return end -- can't check this outside of Map.Defer
			EntityAction.InvToComp(ent, { slot = slot, comp_index = socket })
		end)
	end,
	args = {
		{ 'exec', "Failed", "Invalid unit, component doesn't exist or no space" },
		{ 'in', "Component", "Component to equip", 'comp' },
		{ 'in', "Slot Index", "Specific inventory slot with the component to equip", 'posnum', true },
		{ 'in', "Socket Index", "Specific component socket to equip on or swap with", 'posnum', true },
		{ 'in', "Unit", "The unit to equip component on (if not self)", 'entity', true },
	},
	name = "Equip Component",
	desc = "Equips a component if it exists",
	category = "Components",
	icon = "Main/skin/Icons/Common/56x56/Home.png",
	explain = [[Equips a component from the inventory into a matching socket.

The input for <hl>Socket Index</> can also be given as a component identifier (and index if multiple are equipped) to swap with an equipped component.]],
}

data.instructions.unequip_component = {
	func = function(comp, state, cause, if_failed, in_comp, in_socket, in_slot, in_unit)
		local ent = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if not ent then
			state.counter = if_failed
			return
		end

		local comp_id, comp_idx, socket_idx = (in_comp and GetId(comp, state, in_comp)), (in_comp and GetNum(comp, state, in_comp)), (in_socket and GetNum(comp, state, in_socket))
		local oldcomp = (socket_idx and ent:GetComponent(socket_idx)) or (not socket_idx and comp_id and ent:FindComponent(comp_id, false, (comp_idx == 0 and 1 or comp_idx), true))
		local oldcomp_id = oldcomp and ((socket_idx and oldcomp.id) or (not socket_idx and comp_id))
		if not oldcomp_id or (comp_id and oldcomp_id ~= comp_id) or oldcomp.is_hidden then
			state.counter = if_failed
			return
		end

		-- Don't allow placing into storage slot of itself or locked slot
		local slot_index = (in_slot and GetNum(comp, state, in_slot))
		local slot = (slot_index and ent:GetSlot(slot_index)) or (not slot_index and ent:GetFreeSlot(oldcomp_id, 1))
		if not slot or slot.component == oldcomp or (slot_index and slot.locked and slot.id ~= oldcomp.id) then
			state.counter = if_failed
			return
		end

		local swap_id = slot_index and slot.unreserved_stack == 1 and data.components[slot.id] and slot.id
		if (not swap_id and slot_index and slot:GetUnreservedSpaceFor(oldcomp_id) == 0) or (swap_id and not ent:CheckSocketSize(swap_id, socket_idx or oldcomp.socket_index)) then
			state.counter = if_failed
			return
		end

		Map.Defer(function()
			if not ent.exists or not slot.exists or not oldcomp.exists then return end
			if not oldcomp:PrepareRemoval() then return end -- can't check this outside of Map.Defer
			EntityAction.CompToInv(ent, { comp = oldcomp, slot = slot })
		end)
	end,
	args = {
		{ 'exec', "Failed", "Invalid unit, component doesn't exist or no space" },
		{ 'in', "Component", "Component to unequip", 'comp' },
		{ 'in', "Socket Index", "Specific component socket to unequip from", 'posnum', true },
		{ 'in', "Slot Index", "Specific inventory slot to place into or swap with", 'posnum', true },
		{ 'in', "Unit", "The unit to equip component on (if not self)", 'entity', true },
	},
	name = "Unequip Component",
	desc = "Unequips a component if it exists",
	category = "Components",
	icon = "Main/skin/Icons/Common/56x56/Detach.png",
	explain = [[Removes a component from a unit and places it into its inventory but only if free space is available.]],
}

data.instructions.get_closest_entity =
{
	func = function(comp, state, cause, f1, f2, f3, output)
		local owner = comp.owner

		local f1id = GetId(comp, state, f1)
		local filters = { f1id, f1id and GetNum(comp, state, f1), nil, nil, nil, nil }
		if filters[1] then
			filters[3] = GetId(comp, state, f2)
			filters[4] = filters[3] and GetNum(comp, state, f2)
			if filters[3] then
				filters[5] = GetId(comp, state, f3)
				filters[6] = filters[5] and GetNum(comp, state, f3)
			end
		end
		local entity_filter, override_range = PrepareFilterEntity(filters)
		local range, num = owner.visibility_range
		local res = Map.FindClosestEntity(owner, math.min(override_range or range, range), function(e)
			local id,n = FilterEntity(owner, e, filters)
			num = id and n
			return id
		end, entity_filter)
		Set(comp, state, output, { entity = res, num = num })
	end,
	args = {
		{ 'in', "Filter", "Filter to check", 'radar' },
		{ 'in', "Filter", "Second Filter", 'radar', true },
		{ 'in', "Filter", "Third Filter", 'radar', true },
		{ 'out', "Output", "Unit" },
	},
	name = "Get Closest Unit",
	desc = "Gets the closest visible unit matching a filter",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Closest Enemy.png",
	explain = [[Finds and returns the closest visible unit.]],
}

data.instructions.match =
{
	func = function(comp, state, cause, in_unit, f1, f2, f3, failed)
		local owner = comp.owner
		local f1id = GetId(comp, state, f1)
		local filters = { f1id, f1id and GetNum(comp, state, f1), nil, nil, nil, nil }
		if filters[1] then
			filters[3] = GetId(comp, state, f2)
			filters[4] = filters[3] and GetNum(comp, state, f2)
			if filters[3] then
				filters[5] = GetId(comp, state, f3)
				filters[6] = filters[5] and GetNum(comp, state, f3)
			end
		end
		local unit = not in_unit and owner or GetEntity(comp, state, in_unit)
		local res = unit and unit:MatchFilter(PrepareFilterEntity(filters), owner.faction) and FilterEntity(owner, unit, filters)
		if not res then state.counter = failed end
	end,
	args = {
		{ 'in', "Unit", "Unit to Filter, defaults to Self", 'entity' },
		{ 'in', "Filter", "Filter to check", 'radar' },
		{ 'in', "Filter", "Second Filter", 'radar', true },
		{ 'in', "Filter", "Third Filter", 'radar', true },
		{ 'exec', "Failed", "Did not match filter" },
	},
	name = "Match",
	desc = "Filters the passed unit",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Compares two values and diverts logic depending on the result.]],
}

data.instructions.switch =
{
	func = function(comp, state, cause, mode, in_value, ...)
		local value = Get(comp, state, in_value)
		local filter_entity = mode < 12 and value.entity or nil
		local filter_owner, filters = filter_entity and comp.owner, filter_entity and { 0, 0 }
		for i=1,select('#', ...),2 do
			local in_c, out_c = select(i, ...)
			if in_c then
				local cmp = Get(comp, state, in_c)
				local filter_id = filters and cmp.id
				if filter_id then
					filters[1], filters[2] = filter_id, cmp.num
					if value:Compare(mode, cmp, PrepareFilterEntity(filters), filter_owner) and FilterEntity(filter_owner, filter_entity, filters) then
						state.counter = out_c
						return
					end
				elseif value:Compare(mode, cmp) then
					state.counter = out_c
					return
				end
			end
		end
	end,
	make_asm = function(inst) return math.abs(inst.c or 1) end,
	get_num = function(inst)
		local n = inst.n
		if not n then for i=10,2,-2 do if inst[i] or inst[i+1] then return i//2 end end end
		return n or 2
	end,
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local add_height, has_extra, can_hide = NodeUIComparison(canvas, inst, program_ui, show_extra or false)
		local n = data.instructions.switch.get_num(inst)
		local function addsub(btn)
			local isadd = btn.isadd
			if not isadd and n <= 1 then return end
			n = n + (isadd and 1 or -1)
			inst.n = n
			if isadd then inst[1 + n * 2] = false else inst[2 + n * 2], inst[3 + n * 2] = nil, nil end
			program_ui:Refresh()
		end
		local y = 108 + add_height + (add_height > 0 and 4 or 0) + n * 88
		canvas:Add('<Button icon=icon_add width=24 height=24 x=4 isadd=true tooltip="Add Case"/>', { y = y, on_click = addsub })
		canvas:Add('<Button icon=icon_remove width=24 height=24 x=32 tooltip="Remove Case"/>', { y = y, on_click = addsub })
		return add_height, has_extra, can_hide
	end,
	exec_arg = { 1, "No Match", "Where to continue if there is no match" },
	var_args = function(inst_def, inst, code, library, for_asm)
		local res = Tool.Copy(inst_def.args)
		for i=1,inst_def.get_num(inst) do
			local lbl = not for_asm and L("Case %d", i)
			res[#res+1] = { 'in', lbl, lbl, 'radar' }
			res[#res+1] = { 'exec', tostring(i), lbl }
		end
		return res
	end,
	args = {
		{ 'in', "Input", "Item or unit to check", 'data' }
	},
	name = "Switch",
	desc = "Diverts the program depending on the passed value",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Switches to different execution paths based on an input value.]],
}

data.instructions.category = {
	func = function(comp, state, cause, in_value, ...)
		local c = GetSourceNode(state).c
		local id = GetId(comp, state, in_value)
		local entity = not id and GetEntity(comp, state, in_value)
		local def = (id and data.all[id]) or (entity and entity.def)
		::retry::
		for i=2,def and select('#', ...)*2 or 0,2 do
			if def[c[i-1]] == c[i] then
				state.counter = select(i // 2, ...)
				return
			end
		end
		if entity then
			if IsResource(entity) then
				def = data.all[GetResourceHarvestItemId(entity)]
				if def then entity = nil goto retry end
			elseif IsDroppedItem(entity) and comp.owner.faction:IsSeen(entity) then
				local dropslot = entity:GetSlot(1)
				def = dropslot and dropslot.def
				if def then entity = nil goto retry end
			end
		end
	end,
	node_ui = function(canvas, inst, program_ui)
		local c = inst.c
		if not c then c = {} inst.c = c end
		canvas:Add('<Button icon=icon_add width=24 height=24 x=4 isadd=true tooltip="Add Case"/>', { y = 98, disabled = #c == #data.categories * 2, on_click = function(btn)
			UI.MenuPopup([[<Box bg=popup_box_bg padding=4 blur=true><HorizontalList>
					<VerticalList child_padding=4 id=item txt="Inventory Item"/>
					<VerticalList child_padding=4 id=frame txt="Types"/>
					<VerticalList child_padding=4 id=value txt="Information"/>
				</HorizontalList></Box>]], {
				construct = function(menu)
					menu:TweenFromTo("sy", 0, 1, 100)
					local insert_num, lastfilterfield = 0
					for _,v in ipairs(data.categories) do
						local first, disabled = #menu[v.tab] == 0
						for i=1,#c,2 do if v.filter_field == c[i+0] and v.filter_val == c[i+1] then disabled, insert_num = true, insert_num + 1 break end end
						if first then menu[v.tab]:Add("<Text style=bl halign=center margin_top=4/>").text = menu[v.tab].txt end
						menu[v.tab]:Add("<Button height=27 on_click={add}/>", { v = v, insert_num = insert_num, text = v.name, disabled = disabled, margin_top = not first and lastfilterfield ~= v.filter_field and 8 or 0, margin_right = (v.tab ~= 'value' and 8 or 0) })
						lastfilterfield = v.filter_field
					end
				end,
				add = function(menu, addbtn)
					table.insert(c, 1 + addbtn.insert_num * 2, addbtn.v.filter_val) -- insert val first
					table.insert(c, 1 + addbtn.insert_num * 2, addbtn.v.filter_field) -- insert field before val
					ConvertShiftVarArgs(inst, 2 + addbtn.insert_num, 1)
					inst[2 + addbtn.insert_num] = false
					program_ui:Refresh()
				end,
			}, btn, 'RIGHT')
		end })
		for i=1,#c,2 do
			canvas:Add('<Button icon=icon_remove width=24 height=24 x=4 tooltip="Remove Case" on_click={sub}/>', { y = 118+i*20, on_click = function()
				table.remove(c, i)
				table.remove(c, i)
				inst[2 + i // 2] = nil
				ConvertShiftVarArgs(inst, 2 + i // 2, -1)
				program_ui:Refresh()
			end})
		end
		return 0
	end,
	exec_arg = { 2, "No Match", "Where to continue if there is no match" },
	var_args = function(inst_def, inst, code, library, for_asm)
		local res, c, data_categories = Tool.Copy(inst_def.args), inst.c or {}, data.categories
		for i=1,#c,2 do
			for _,v in ipairs(data_categories) do
				if v.filter_field == c[i+0] and v.filter_val == c[i+1] then
					res[#res+1] = { 'exec', v.name }
					break
				end
			end
		end
		return res
	end,
	args = {
		{ 'in', "Input", "Item or unit to check", 'data' }
	},
	name = "Category Switch",
	desc = "Diverts the program depending on the category of the passed value",
	category = "Logic",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Switches to different execution paths based on an input value.]],
}

data.instructions.dodrop =
{
	func = function(comp, state, cause, c, target, item, path_blocked)
		local reg, target_coord, target_entity, source_entity, moved = Get(comp, state, item), GetCoord(comp, state, target), GetEntity(comp, state, target), comp.owner
		moved = target_entity and (source_entity.docked_garage == target_entity or target_entity.docked_garage == source_entity)
		local can_transfer = moved or source_entity.has_crane or source_entity.has_movement
		if not can_transfer or (not target_coord and (not target_entity or not target_entity.exists or (not target_entity.faction:IsAlly(source_entity) and (not target_entity.lootable or not source_entity.faction:IsSeen(target_entity))))) then
			return
		end

		local function transfer(item_id, limit)
			local have = source_entity:CountItem(item_id, true) -- count unreserved stacks
			if have == 0 then return end
			if not target_coord and (target_entity.is_construction or not target_entity:HaveFreeSpace(item_id)) and not target_entity:IsWaitingForOrder(item_id, true) then return end

			if not moved then
				local need_move, repeat_blocked = comp:RequestStateMove(target_coord or target_entity, math.max(comp.owner.crane_range, 1))
				if repeat_blocked then
					comp:SetStateSleep(1)
					state.counter = path_blocked
					return true
				elseif need_move then
					-- Not yet next to the target, wait for move to complete then repeat this instruction
					state.counter = state.lastcounter
					return true
				end
				moved = true
			end

			if target_coord then
				comp.owner:DropItem(item_id, limit or have, target_coord.x, target_coord.y)
			else
				if target_entity.is_construction then
					-- get reserved amount as limit
					local needed = 0
					for _,v in ipairs(target_entity.slots) do
						if v.id == item_id then needed = needed + v.reserved_space end
					end
					limit = limit and math.min(limit, needed) or needed
				end
				target_entity:TransferFrom(source_entity, item_id, limit or have, true)
			end
		end

		local reg_item_id = reg.item_id
		if reg_item_id then
			local num = reg.num
			if num and num > 0 then
				if c == 2 then
					if not target_coord then
						-- remove amount already in target
						num = num - target_entity:CountItem(reg_item_id)
					end
				end
				if num > 0 and transfer(reg_item_id, num) then return true end
			else
				if transfer(reg_item_id) then return true end
			end
		elseif reg.is_empty then -- transfer all
			for i,v in ipairs(source_entity.slots or {}) do
				if v.unreserved_stack > 0 and transfer(v.id) then return true end
			end
		end

		comp:SetStateSleep(1)
		return true
	end,
	make_asm = function(inst)
		return inst.c or 2
	end,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Specified Amount", "Up to Amount" }, 2)
	end,
	args = {
		{ 'in', "Destination", "Unit or destination to bring items to", 'entity' },
		{ 'in', "Item / Amount", "Item and amount to drop off", "item_num", true },
		{ 'exec', "Path Blocked", "If path to destination was blocked" },
	},
	name = "Drop Off Items",
	desc = "Drop off items at a unit or location",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Drop Items.png",
	sample = "4W3bEIye3fwNjk3JECPg0y39MG3hY0aB1ec5xT1UMwde1Zo3HO0gAAgb12wbKZ1UOcsF0LrwGE49YVIh2SYWFg0glIqD2VsJgH1WSiu53zcym80tUIMz2mzZEP0ol6XE0k9G5N001DOZ3zge2Ep",
	explain = [[Drops off items to a unit or location on the ground.

An optional <hl>Item/Amount</> can be specified, or default to all items in inventory.

<bl>Up to Amount</> means it will only drop off up to that many items from its inventory
<bl>Specified Amount</> will attempt to transfer that many items when dropping off]],
}

data.instructions.dopickup =
{
	func = function(comp, state, cause, c, source, item, path_blocked)
		local reg, source_entity, target_entity, moved = Get(comp, state, item), GetEntity(comp, state, source), comp.owner
		moved = source_entity and (source_entity.docked_garage == target_entity or target_entity.docked_garage == source_entity)
		local can_transfer = moved or target_entity.has_crane or target_entity.has_movement
		if not source_entity or not source_entity.exists or (target_entity.faction ~= source_entity.faction and not source_entity.lootable) or (not (can_transfer)) then
			return
		end

		local function transfer(item_id, limit)
			local have = source_entity:CountItem(item_id, true) -- count unreserved stacks
			if have == 0 then return end
			if not target_entity:HaveFreeSpace(item_id) then return end

			if not moved then
				local need_move, repeat_blocked = comp:RequestStateMove(source_entity, comp.owner.crane_range)
				if repeat_blocked then
					comp:SetStateSleep(1)
					state.counter = path_blocked
					return true
				elseif need_move then
					-- Not yet next to the source, wait for move to complete then repeat this instruction
					state.counter = state.lastcounter
					return true
				end
				moved = true
			end

			target_entity:TransferFrom(source_entity, item_id, limit or have, true)
		end

		local reg_item_id = reg.item_id
		if reg_item_id then
			local num = reg.num
			if num and num > 0 then

				-- remove amount already in target
				if c == 2 then
					num = num - target_entity:CountItem(reg_item_id)
				end
				if num > 0 and transfer(reg_item_id, num) then return true end
			else
				if transfer(reg_item_id) then return true end
			end
		elseif reg.is_empty then -- transfer all
			for i,v in ipairs(source_entity.slots or {}) do
				if v.unreserved_stack > 0 and transfer(v.id) then return true end
			end
		end

		comp:SetStateSleep(1)
		return true
	end,
	make_asm = function(inst)
		return inst.c or 2
	end,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Specified Amount", "Up to Amount" }, 2)
	end,
	args = {
		{ 'in', "Source", "Unit to take items from", 'entity' },
		{ 'in', "Item / Amount", "Item and amount to pick up", "item_num", true },
		{ 'exec', "Path Blocked", "If path to destination was blocked" },
	},
	name = "Pick Up Items",
	desc = "Picks up items from a unit",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Pick Up Items.png",
	sample = "4W3bEIye3fwNjk3JECPg0y39MG3hY0aB1ec5xT1UMwde1Zo3HO0gAAgb12wbKZ1UOcsF0LrwGE49YVIh2SYWFg0glIqD2VsJgH1WSiu53zcym80tUIMz2mzZEP0ol6XE0k9G5N001DOZ3zge2Ep",
	explain = [[Picks up items from a unit.

If an <hl>Item/Amount</> is specified then it will only try to pick up that many.

<bl>Up to Amount</> means it will only pick up to that many items into its inventory
<bl>Specified Amount</> will attempt to transfer that many items when picking up]],
}

data.instructions.request_item =
{
	func = function(comp, state, cause, c, item, channel)
		local r = Get(comp, state, item)
		local r_item_id, r_num = r.item_id, r.num
		if not r_item_id then return end
		if r_num == REG_INFINITE then r_num = 9999999 end
		if c == 2 then
			r_num = r_num - comp.owner:CountItem(r_item_id)
		end
		if r_num <= 0 then return end
		channel = GetNum(comp, state, channel)
		comp:OrderItem(r_item_id, r_num, channel >= 1 and channel <= 4 and (1 << (channel-1)) or nil)
	end,
	make_asm = function(inst)
		return inst.c or 2
	end,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Specified Amount", "Up to Amount" }, 2)
	end,
	args = {
		{ 'in', "Item", "Item and amount to order", 'item_num' },
		{ 'in', "Channel", "Optionally request on a specific logistics channel (1-4)", 'posnum', true },
	},
	name = "Request Item",
	desc = "Requests an item if it doesn't exist in the inventory",
	category = "Inventory",
	sample = "V02rMa900Zlp221cKrw34kYhJ1meMtZ25rrbw07Fz2w24kaMu28DbjZ1rBxEt23ezW900A",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Requests a specific amount of a specific item from the logistics system. The request remains valid as long as the behavior is active.

Infinite requests will request into all available slots but do not continue to request once items are taken out unless the instruction called again]],
}

data.instructions.order_to_shared_storage =
{
	func = function(comp, state, cause)
		comp.owner:IssueDumpingOrders()
	end,
	name = "Order to Shared Storage",
	desc = "Request Inventory to be sent to nearest shared storage with corresponding locked item slots",
	category = "Logistics",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Create orders to send the inventory of this unit to shared storage. Will only work if free space is available in locked item slots on an external unit equipped with a Shared Storage component.]],
}

data.instructions.request_wait =
{
	func = function(comp, state, cause, c, item, channel)
		local r = Get(comp, state, item)
		local r_item_id, r_num = r.item_id, r.num
		if not r_item_id then return end

		local have_amount = comp.owner:CountItem(r_item_id)
		if c == 1 then -- wait for specified amount
			local blocks = state.blocks
			local block = blocks and blocks[#blocks]
			local start_have_amount = block and block[2] == state.lastcounter and block[3]
			r_num = r_num + (start_have_amount or have_amount) - have_amount
			if not start_have_amount then -- first time, no block yet
				if r_num <= 0 then return end -- can't wait for 0, negative or infinite
				BeginBlock(comp, state, have_amount) -- remember have_amount at start of wait
			elseif r_num <= 0 then -- continuing wait
				blocks[#blocks] = nil -- end loop
				return -- have the requested amount
			end
		else -- wait up to amount
			r_num = r_num - have_amount
			if r_num <= 0 then return end -- have the requested amount
		end
		channel = GetNum(comp, state, channel)
		comp:OrderItem(r_item_id, r_num, channel >= 1 and channel <= 4 and (1 << (channel-1)) or nil)
		state.counter = state.lastcounter
		comp:SetStateSleep(1)
		return true
	end,
	make_asm = function(inst)
		return inst.c or 2
	end,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Specified Amount", "Up to Amount" }, 2)
	end,
	args = {
		{ 'in', "Item", "Item and amount to order", 'item_num' },
		{ 'in', "Channel", "Optionally request on a specific logistics channel (1-4)", 'posnum', true },
	},
	name = "Request Wait",
	desc = "Requests up to a specified amount of an item and waits until that amount exists in inventory",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Waits until a previously requested item or event has completed.]],
}

data.instructions.get_active_order = {
	func = function(comp, state, cause, source, target, amount)
		local order = comp.owner.active_order
		if source then Set(comp, state, source, order and order.source_entity) end
		if target then Set(comp, state, target, order and order.target_entity) end
		if amount then Set(comp, state, amount, order and { id = order.item_id, num = order.amount}) end
	end,
	args = {
		{ 'out', "Source" },
		{ 'out', "Target" },
		{ 'out', "Amount" },
	},
	name = "Get Active Order",
	desc = "Gets the source, target, and amount data from the current active order",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Returns the current order or task assigned to the unit.]],
}

data.instructions.get_resource_num = {
	func = function(comp, state, cause, entity, result)
		local r = GetEntity(comp, state, entity)
		Set(comp, state, result, IsResource(r) and { id = GetResourceHarvestItemId(r), num = GetResourceHarvestItemAmount(r) } or nil )
	end,
	args = {
		{ 'in', "Resource", "Resource Node to check", 'entity' },
		{ 'out', "Result" },
	},
	name = "Get Resource Amount",
	desc = "Gets the amount of resource",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Returns the quantity of resource remaining in a resource deposit.]],
}

data.instructions.get_inventory_item = {
	func = function(comp, state, cause, item, exec_none)
		local slots = comp.owner.slots
		if slots then
			for i,v in ipairs(slots) do
				if v.id and v.stack > 0 then
					Set(comp, state, item, { id = v.id, num = v.stack })
					return
				end
			end
		end
		Set(comp, state, item, nil)
		state.counter = exec_none
	end,
	args = {
		{ 'out', "Item" },
		{ 'exec', "No Items", "No items in inventory" },
	},
	name = "Get First Item",
	desc = "Reads the first item in the inventory of the unit",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Retrieves a reference to the first item from the unit's inventory. Diverts logic if no items are found.]],
}

data.instructions.get_inventory_item_index = {
	func = function(comp, state, cause, num, item, exec_none)
		local slot = comp.owner:GetSlot(GetNum(comp, state, num))
		if slot then
			local slot_entity = slot.entity or slot.reserved_entity
			local slot_id = not slot_entity and slot.id
			if slot_entity or slot_id then
				Set(comp, state, item, { entity = slot_entity, id = slot_id, num = slot.unreserved_stack } )
				return
			end
		end
		Set(comp, state, item, nil)
		state.counter = exec_none
	end,
	args = {
		{ 'in', "Index", "Slot index", 'posnum' },
		{ 'out', "Item" },
		{ 'exec', "No Item", "Item not found" },
	},
	name = "Get Inventory Item",
	desc = "Reads the item contained in the specified slot index",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Returns the index of a specific item from the inventory.]],
}

data.instructions.sequence =
{
	func = function(comp, state, cause, exec_first, exec_second, exec_third, exec_fourth, exec_last)
		local steps = { 1 }
		if exec_first then steps[#steps+1] = exec_first end
		if exec_second then steps[#steps+1] = exec_second end
		if exec_third then steps[#steps+1] = exec_third end
		if exec_fourth then steps[#steps+1] = exec_fourth end
		return BeginBlock(comp, state, steps)
	end,

	next = function(comp, state, it, exec_first, exec_second, exec_third, exec_fourth, exec_last)
		local i = it[1]
		if i > #it then return true end
		state.counter = it[i+1]
		it[1] = i + 1
	end,

	last = function(comp, state, it, exec_first, exec_second, exec_third, exec_fourth, exec_last)
		state.counter = exec_last
	end,

	exec_arg = false,
	args = {
		{ 'exec', "First", "First" },
		{ 'exec', "Second", "Second", nil, true },
		{ 'exec', "Third", "Third", nil, true },
		{ 'exec', "Fourth", "Fourth", nil, true },
		{ 'exec', "Last", "Last" },
	},
	name = "Sequence",
	desc = "Executes a series of branches in sequence",
	category = "Flow",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	--sample = "4w3YxVw83N5hsf2N72v21wlqdV1w59mf2iQlyI3b6kSN2qNbeT2ucU4M2du9081bSutT2MBBeE2xTuTJ1urOph1tHKMr0LRWRM0avnxQ3jO9Ys38Uk5H1z4OKy1wmQOj1i1HdI0DAn5Y2bW0Av0gyF8N1lgBc51H40X518RUgK0s33RY2IR",
	explain = [[Runs each connected branch in order, then continues through <hl>Last</>.

Unconnected optional branches are skipped. Use this when one condition should trigger several independent behavior sections without manually chaining them together.]],
}

data.instructions.for_component = {
	func = function(comp, state, cause, out_val, out_index, exec_done)
		return BeginBlock(comp, state, { 1 })
	end,

	next = function(comp, state, it, out_val, out_index, exec_done)
		local i, first_non_hiden, entity, c = it[1], it[2] or 999, comp.owner

		while i < first_non_hiden do
			c = entity:GetHiddenComponent(i)
			if not c then it[2], first_non_hiden = i, i break end
			i = i + 1
			local comp_def = c.def
			if comp_def.get_ui then break end
		end

		while not c do
			i = i + 1
			local socket = i - first_non_hiden
			if socket > entity.socket_count then return true end
			c = entity:GetComponent(socket)
		end

		it[1] = i
		Set(comp, state, out_val, { id = c.id, num = c.interface_order })

		if out_index then
			Set(comp, state, out_index, (i > first_non_hiden and (i - first_non_hiden) or 0))
		end
	end,

	last = function(comp, state, it, val, out_index, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'out', "Component", "Equipped component" },
		{ 'out', "Socket Index", "Socket index of the component (is 0 for integrated components)", 'num', true },
		{ 'exec', "Done", "Finished loop" },
	},
	name = "Loop Equipped Components",
	desc = "Loops through equipped Components",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	sample = "4w3YxVw83N5hsf2N72v21wlqdV1w59mf2iQlyI3b6kSN2qNbeT2ucU4M2du9081bSutT2MBBeE2xTuTJ1urOph1tHKMr0LRWRM0avnxQ3jO9Ys38Uk5H1z4OKy1wmQOj1i1HdI0DAn5Y2bW0Av0gyF8N1lgBc51H40X518RUgK0s33RY2IR",
	explain = [[Loops over all components equipped on the current unit including integrated components.]],
}

data.instructions.has_like_component =
{
	func = function(comp, state, cause, in_comp, in_unit, exec_fail)
		local basecomp = GetId(comp, state, in_comp)
		local entity = GetAllyEntityOrSelf(comp, state, in_unit)
		if not basecomp or not entity then
			state.counter = exec_fail
			return
		end
		local basedef = data.components[basecomp]
		local baseid = (basedef and basedef.base_id) or basecomp
		local findcomp = entity:FindComponent(baseid, true)
		if not findcomp then state.counter = exec_fail end
	end,
	args = {
		{ 'in', "Component", "Component" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
		{ 'exec', "Failed", "Failed" },
	},
	name = "Has Like Component",
	desc = "Checks Unit for a component type",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Checks if the Unit has a component that is like the one passed]],
}

data.instructions.for_inventory_item = {
	func = function(comp, state, cause, val, exec_done, r_stack, ur_stack, r_space, ur_space, out_index, in_unit)
		return BeginBlock(comp, state, { 1, GetAllyEntityOrSelf(comp, state, in_unit) })
	end,

	next = function(comp, state, it, val, exec_done, r_stack, ur_stack, r_space, ur_space, out_index, in_unit)
		local i, ent = it[1], it[2]
		local slot = type(ent) == 'userdata' and ent.exists and ent:GetSlot(i)
		if not slot then return true end

		local id, entity = slot.id, slot.entity or slot.reserved_entity
		if val then Set(comp, state, val, id and { entity = entity, id = not entity and id or nil, num = id and slot.unreserved_stack }) end
		if r_stack then Set(comp, state, r_stack, id and { id = id, num = slot.reserved_stack }) end
		if ur_stack then Set(comp, state, ur_stack, id and { id = id, num = slot.unreserved_stack }) end
		if r_space then Set(comp, state, r_space, id and { id = id, num = slot.reserved_space }) end
		if ur_space then Set(comp, state, ur_space, id and { id = id, num = slot.unreserved_space }) end
		if out_index then Set(comp, state, out_index, i) end
		it[1] = i + 1
	end,

	last = function(comp, state, it, val, exec_done, r_stack, ur_stack, r_space, ur_space, out_index, in_unit)
		if it[1] == 1 then -- clear if having not looped once
			if val then Set(comp, state, val) end
			if r_stack then Set(comp, state, r_stack) end
			if ur_stack then Set(comp, state, ur_stack) end
			if r_space then Set(comp, state, r_space) end
			if ur_space then Set(comp, state, ur_space) end
			if out_index then Set(comp, state, out_index) end
		end
		state.counter = exec_done
	end,

	args = {
		{ 'out', "Inventory", "Item Inventory" },
		{ 'exec', "Done", "Finished loop" },
		{ 'out', "Reserved Stack", "Items reserved for outgoing order or recipe", 'num', true },
		{ 'out', "Unreserved Stack", "Items available", 'num', true },
		{ 'out', "Reserved Space", "Space reserved for an incoming order", 'num', true },
		{ 'out', "Unreserved Space", "Remaining space", 'num', true },
		{ 'out', "Index", "Slot Index", 'num', true },
		{ 'in', "Unit", "Unit", 'entity', true },
	},
	name = "Loop Inventory Slots",
	desc = "Loops through Inventory",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Loops through each item currently stored in a unit's inventory.]],
}

data.instructions.for_ingredients = {
	func = function(comp, state, cause, cu, product, out_ingredient, exec_done)
		local c, u, it = (cu & 15), (cu >> 4), { 2 }
		local prod_id, faction, prod_recipe = GetId(comp, state, product), comp.faction
		local ent = not prod_id and GetEntity(comp, state, product)

		if prod_id then
			local prod_def = prod_id and data.all[prod_id]
			prod_recipe = prod_def and (c == 1 or c == 5) and (prod_def.production_recipe or prod_def.construction_recipe)

			local uplink_recipe = not prod_recipe and prod_def and (c == 3 or c == 5) and prod_def.uplink_recipe
			if uplink_recipe then
				local research_progress, total = faction.extra_data.research_progress, (prod_def.progress_count or 1)
				local progress = research_progress and research_progress[prod_id] or (faction:IsUnlocked(prod_id) and total or 0)
				local count = (u == 1 and (total - progress) or (u == 2 and total or 1))
				for item,n in SortedPairs(uplink_recipe.ingredients or {}) do
					if count > 0 then it[#it + 1] = { id = item, num = n * count } end
				end
			end
		elseif ent then
			if ent.is_construction and (c == 2 or c == 5) and ent.faction:IsAlly(comp) then
				local fd, bd = GetProduction(ent:GetRegisterId(FRAMEREG_GOTO), ent)
				local con_comp = ent:FindComponent("c_construction", true)
				local skip = con_comp and con_comp.has_extra_data and con_comp.extra_data.skip
				for item,total in SortedPairs(fd and GetIngredients((fd.construction_recipe or fd.production_recipe), bd) or {}) do
					local num = (skip and skip[item] and 0 or (u == 1 and math.max(total - ent:CountItem(item), 0) or (u == 2 and total or 1)))
					if num > 0 then it[#it + 1] = { id = item, num = num } end
				end
			else
				local prod_def =  ent.def
				prod_id, prod_recipe = ent.id, prod_def and (c == 1 or c == 5) and (prod_def.production_recipe or prod_def.construction_recipe)

				local has_repair = not prod_recipe and (c == 4 or c == 5) and ent.faction:IsAlly(comp) and ent:FindComponent("c_mothership_repair", true)
				if has_repair then
					local repair_data = has_repair and has_repair.has_extra_data and has_repair.extra_data
					local repair_items, total = repair_data and repair_data.items, repair_data and repair_data.max_items or 0
					for item,n in SortedPairs(repair_items or {}) do
						local num = (u == 1 and (total - n) or (u == 2 and total or 1))
						if num > 0 then it[#it + 1] = { id = item, num = num } end
					end
				end
			end
		end

		if prod_recipe and faction:IsUnlocked(prod_id) then -- regular products must be unlocked
			for item,n in SortedPairs(prod_recipe.ingredients or {}) do
				it[#it + 1] = { id = item, num = n }
			end
		end

		if #it > 1 then return BeginBlock(comp, state, it, 1) end
		Set(comp, state, out_ingredient, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, c, product, out_ingredient, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_ingredient, { id = it[i].id, num = it[i].num,  })
		it[1] = i + 1
	end,

	last = function(comp, state, it, c, product, out_ingredient, exec_done)
		state.counter = exec_done
	end,

	make_asm = function(inst)
		return (inst.c or 1) | ((inst.u or 1) << 4)
	end,
	node_ui = function(canvas, inst, program_ui)
		local height = NodeUICombo(canvas, inst, program_ui, { "Recipe", "Construction Site", "Research", "Repair Mission", "Automatic" })
		if (inst.c or 1) == 1 then inst.u = nil return height end
		local u, umodes = (inst.u or 1), { "Remaining Amount", "Total Amount", "Single Step" }
		local change = function(_, v) if (v or 1) ~= u then inst.u, u = (v ~= 1 and v or nil), v program_ui:Refresh() end end
		canvas:Add("<Combo y=72 halign=fill margin=10/>", { on_change = change, texts = umodes, tips = umodes, value = u })
		return 74
	end,
	args = {
		{ 'in', "Input", nil, 'data' },
		{ 'out', "Ingredient" },
		{ 'exec', "Done", "Finished loop" },
	},
	name = "Loop Ingredients",
	altnames = { "Loop Recipe Ingredients", "Loop Research Ingredients", "Loop Repair Ingredients" },
	desc = "Loop over ingredients required for production, construction, research or repair",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Loop over each ingredient required for a product, construction site, technology research or repair mission.

The <hl>Automatic</> mode will use an appropriate mode depending on the type of data contained in <hl>Input</>.]],
}

data.instructions.get_inventory_total = {
	func = function(comp, state, cause, res, in_unit)
		local ent, total = GetAllyEntityOrSelf(comp, state, in_unit)
		if ent then
			total = 0
			for i,v in ipairs(ent.slots or {}) do total = total + v.stack end
		end
		Set(comp, state, res, total)
	end,
	args = {
		{ 'out', "Result" },
		{ 'in', "Unit", "The unit to check for (if not self)", 'entity', true },
	},
	name = "Get Inventory Total",
	desc = "Returns the total contained in inventory",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Returns the total number of all items in the inventory.]],
}

data.instructions.get_distance = {
	func = function(comp, state, cause, target, output, source)
		local reg_s, reg_t = source and Get(comp, state, source), Get(comp, state, target)

		do
			local use_self = not reg_s or reg_s.is_empty -- if optional param is unset or empty, use self
			local entity_s = use_self and comp.owner or reg_s.entity
			local coord_s = not entity_s and reg_s.coord
			if not entity_s and not coord_s then goto failed_distance end -- source is not an entity or a coord
			if entity_s and not use_self and not comp.faction:IsSeen(entity_s) then goto failed_distance end -- can't see source entity

			local entity_t = reg_t.entity
			local coord_t = not entity_t and reg_t.coord
			if not entity_t and not coord_t then goto failed_distance end -- target is not an entity or a coord
			if entity_t and not comp.faction:IsSeen(entity_t) then goto failed_distance end -- can't see target entity

			local dist = Map.GetDistance(entity_s or coord_s, entity_t or coord_t)
			Set(comp, state, output, { entity = entity_t or entity_s, num = dist })
			return
		end

		::failed_distance::
		Set(comp, state, output, REG_INFINITE)
	end,
	args = {
		{ 'in', "Target", "Target unit or coordinate", 'coord' },
		{ 'out', "Distance", "Unit and its distance in the numerical part of the value" },
		{ 'in', "Source", "The unit or coordinate to start from (if not self)", 'coord', true },
	},
	name = "Distance",
	desc = "Get the distance between units or coordinates",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Closest Enemy.png",
	explain = [[Measures the distance between two units or coordinates.

If <hl>Source</> is empty, the unit running the behavior is used. If either side is not a coordinate or visible unit, <hl>Distance</> receives the infinite value.

The numerical part contains the distance. The data part is set to the target unit when the target is a unit, otherwise to the source unit when using self as the source.]],
}

data.instructions.order_transfer =
{
	func = function(comp, state, cause, target_entity, item)
		-- get current ordered amount?
		target_entity = GetEntity(comp, state, target_entity)
		item = Get(comp, state, item)
		local item_id, amount = item.item_id, item.num
		if not target_entity or not item_id then return end
		--print("making order from " .. comp.owner.def.name .. " to " .. target_entity.def.name)
		if (target_entity.is_docked and target_entity.docked_garage == comp.owner) or
			(comp.owner.is_docked and comp.owner.docked_garage == target_entity) then
			target_entity:TransferFrom(comp.owner, item_id, amount, false, false)
		else
			comp.faction:OrderTransfer(comp.owner, target_entity, item_id, amount > 0 and amount, true)
		end
	end,
	args = {
		{ 'in', "Target", "Target unit", 'entity' },
		{ 'in', "Item", "Item and amount to transfer", 'item_num' },
	},
	name = "Order Transfer To",
	desc = "Transfers an Item to another Unit",
	category = "Logistics",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Transfer items or resources between the inventories of units.]],
}

data.instructions.is_logistics =
{
	func = function(comp, state, cause, in_unit, exec_outside)
		local ent1 = GetSeenEntityOrSelf(comp, state, in_unit)
		local coord
		if ent1 and ent1.faction ~= comp.faction then
			coord = ent1.location
			ent1 = nil
		end
		if ent1 then
			local power_grid_index = ent1 and ent1.power_grid_index
			if not power_grid_index then state.counter = exec_outside end
			return
		end
		coord = coord or GetCoord(comp, state, in_unit)
		if coord then if comp.faction:GetPowerGridIndexAt( coord ) then return end end
		state.counter = exec_outside
	end,
	exec_arg = { 1, "Inside", "Where to continue if unit or coordinate is in a logistics network" },
	args = {
		{ 'in', "Target", "Unit or coordinate", 'coord' },
		{ 'exec', "Outside", "If not inside a logistics network" },
	},
	name = "Is Inside Logistics Network",
	desc = "Checks if a unit or coordinates is in the logistics network",
	category = "Logistics",
	icon = "Main/skin/Icons/Common/56x56/Power.png",
	explain = [[Diverts logic depending on whether a unit or coordinate is inside a logistics network.]],
}

data.instructions.is_same_grid =
{
	func = function(comp, state, cause, in_unit1, in_unit2, exec_diff)
		local ent1, ent2 = GetEntity(comp, state, in_unit1), GetEntity(comp, state, in_unit2)
		local e1gi = ent1 and ent1.power_grid_index
		local e2gi = ent2 and ent2.power_grid_index
		if e1gi and e2gi and ent1.faction == comp.faction and ent1.faction == ent2.faction and e1gi == e2gi then return end
		local coord1 = GetCoord(comp, state, in_unit1)
		if e2gi and ent2.faction == comp.faction and not e1gi and coord1 then if comp.faction:GetPowerGridIndexAt( {coord1.x, coord1.y} ) == e2gi then return end end
		local coord2 = GetCoord(comp, state, in_unit2)
		if e1gi and ent1.faction == comp.faction and not e2gi and coord2 then if comp.faction:GetPowerGridIndexAt( {coord2.x, coord2.y} ) == e1gi then return end end
		if coord1 and coord2 then if comp.faction:GetPowerGridIndexAt( {coord1.x, coord1.y} ) == comp.faction:GetPowerGridIndexAt( {coord2.x, coord2.y} ) then return end end
		state.counter = exec_diff
	end,
	exec_arg = { 1, "Same Grid", "Where to continue if both units or coordinates are in the same logistics network" },
	args = {
		{ 'in', "Unit", "First Unit or Coordinate", 'entity' },
		{ 'in', "Unit", "Second Unit or Coordinate", 'entity' },
		{ 'exec', "Different", "Different logistics networks" },
	},
	name = "Is Same Grid",
	desc = "Checks if two units or coordinates are in the same logistics network",
	category = "Logistics",
	icon = "Main/skin/Icons/Common/56x56/Power.png",
	explain = [[Returns true if the two entities are on the same logistics network.]],
}

data.instructions.is_moving = {
	func = function(comp, state, cause, not_moving, path_blocked, no_result, in_unit)
		local entity = GetSeenEntityOrSelf(comp, state, in_unit)
		if not entity then state.counter = no_result return end
		if entity.state_path_blocked then state.counter = path_blocked return end
		if not entity.is_moving then state.counter = not_moving return end
	end,
	exec_arg = { 1, "Moving", "Where to continue if unit is moving" },
	args = {
		{ 'exec', "Not Moving", "Where to continue if unit is not moving" },
		{ 'exec', "Path Blocked", "Where to continue if unit is path blocked" },
		{ 'exec', "No Result", "Where to continue if unit is out of visual range" },
		{ 'in', "Unit", "The unit to check (if not self)", 'entity', true },
	},
	name = "Is Moving",
	desc = "Checks the movement state of a unit",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[Checks the movement status of a unit and diverts logic according to the result.]],
}

data.instructions.is_passable =
{
	func = function(comp, state, cause, in_coord, impassable, passable)
		local loc = GetCoord(comp, state, in_coord)
		if not loc then return end

		local x, y = loc.x, loc.y
		local blocked_landscape, blocked_entity = Map.CountTiles(x, y, 0, true)
		if comp.faction:IsVisible(x, y) then
			if blocked_landscape > 0 or blocked_entity > 0 then
				state.counter = impassable
			else
				state.counter = passable
			end
		elseif comp.faction:IsDiscovered(x, y) then
			if blocked_landscape > 0 then
				state.counter = impassable
			else
				local e = blocked_entity > 0 and Map.GetEntityAt(x, y)
				if e and comp.faction:IsSeen(e) then
					state.counter = impassable
				else
					state.counter = passable
				end
			end
		end
	end,
	args = {
		{ 'in', "Coordinate", "The location in a discovered tile to check", 'coord' },
		{ 'exec', "Impassable", "Unit is unable to pass through this coordinate"},
		{ 'exec', "Passable", "Unit is able to pass through this coordinate" }
	},
	name = "Is Passable",
	desc = "Checks whether a location is passable",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[Returns whether a location is passable by units and diverts logic according to the result.]],
}

data.instructions.is_fixed = {
	func = function(comp, state, cause, in_index, if_locked)
		local slot = comp.owner:GetSlot(GetNum(comp, state, in_index))
		if slot and slot.locked then
			state.counter = if_locked
		end
	end,
	args = {
		{ 'in', "Slot Index", "Individual slot to check", 'posnum', },
		{ 'exec', "Is Locked", "Where to continue if inventory slot is locked" },
	},
	name = "Is Item Slot Locked",
	desc = "Check if a specific item slot is locked",
	category = "Inventory",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
	explain = [[Checks if an item slot of the inventory is locked and diverts logic depending on the result.]],
}

data.instructions.is_equipped = {
	func = function(comp, state, cause, in_id, is_equipped, out_num)
		local component_id, ent, found = GetId(comp, state, in_id), comp.owner, 0
		if component_id then
			for i=1,999 do
				local next_comp = ent:FindComponent(component_id, i)
				if not next_comp then break end
				found = found + 1
				if not out_num then break end -- no need for exact count
			end
		end
		if out_num then Set(comp, state, out_num, found) end
		if found > 0 then state.counter = is_equipped end
	end,
	args = {
		{ 'in', "Component", "Component to check", 'comp' },
		{ 'exec', "Component Equipped", "Where to continue if component is equipped" },
		{ 'out', "Number", "How many of it are equipped", nil, true },
	},
	name = "Is Equipped",
	desc = "Check if a specific component has been equipped",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
	explain = [[Checks if a specific component is currently equipped on a unit and returns how many were found. Diverts logic depending on the result.]],
}

data.instructions.shutdown = {
	func = function(comp, state, cause)
		comp.owner.powered_down = true
	end,
	name = "Turn Off",
	desc = "Shuts down the power of the Unit",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/Power.png",
}

data.instructions.turnon = {
	func = function(comp, state, cause)
		comp.owner.powered_down = false
	end,
	name = "Turn On",
	desc = "Turns on the power of the Unit",
	category = "Units",
	icon = "Main/skin/Icons/Common/56x56/Power.png",
}

data.instructions.set_logistics_options = {
	func = function(comp, state, cause)
		local src_node = GetSourceNode(state)
		local entity, c, c2 = comp.owner, src_node.c or {}, src_node.c2
		for flag, v in pairs(c) do
			if not v then
				-- handle old version where a removed setting would remain in c as false
			elseif flag == "connected" then
				entity.disconnected = not c2[flag]
			elseif (flag ~= 'carrier' and flag ~= 'transport_route' and flag ~= 'can_construction') or IsBot(entity) or entity.has_crane then
				entity["logistics_" .. flag] = (c2[flag] == true)
			end
		end
	end,
	name = "Set Logistics",
	desc = "Sets logistics settings on a unit",
	category = "Logistics",
	icon = "Main/skin/Icons/Common/56x56/Network.png",
	node_ui = function(canvas, inst, program_ui)
		local vl = canvas:Add("<VerticalList y=30 halign=fill margin=6 child_padding=4/>")

		-- Start with a reasonable default and disallow removing the last item
		inst.c, inst.c2 = inst.c or { connected = true }, inst.c2 or { connected = true }
		local c, c2 = inst.c, inst.c2
		local disable_remove, data_logistics_flags = not next(c, next(c)), data.logistics_flags
		local connected_flag = { flag = "connected", label = "Connect to Logistics Network", tooltip = "Connect to Logistics Network" }

		for i=0,#data_logistics_flags do
			local v = data_logistics_flags[i] or connected_flag
			local flag = v.flag
			if flag and c[flag] then
				vl:Add([[<HorizontalList child_padding=6>
						<Button icon=icon_remove width=24 height=24 tooltip="Remove Item" disabled={disable_remove} on_click={remove}/>
						<Text valign=center width=128 clip=true on_click={toggle} text={label}/>
						<Button width=24 height=24 on_click={toggle} icon={chk}/>
					</HorizontalList>]], {
					tooltip = v.tooltip, disable_remove = disable_remove, label = v.label, chk = c2[flag] and "icon_small_confirm" or nil,
					remove = function()
						c[flag], c2[flag] = nil, nil
						program_ui:Refresh()
					end,
					toggle = function(hl)
						c2[flag] = not c2[flag] or nil
						hl[3].icon = c2[flag] and "icon_small_confirm" or nil
						program_ui:Refresh()
					end
				})
			end
		end

		vl:Add('<Button icon=icon_add width=24 height=24 halign=left tooltip="Add Item"/>', { on_click = function(btn)
			UI.MenuPopup("<Box bg=popup_box_bg padding=4 blur=true><VerticalList child_padding=4/></Box>", {
				construct = function(menu)
					menu:TweenFromTo("sy", 0, 1, 100)
					local list, addmargin = menu[1]
					for i=0,#data_logistics_flags do
						local v = data_logistics_flags[i] or connected_flag
						local flag = v.flag
						if c[flag] then -- already in list
						elseif flag then
							list:Add("<Button height=28/>", { text = v.label, tooltip = v.tooltip, margin_top = addmargin and 8 or 0, on_click = function()
								c[flag], c2[flag] = true, true
								program_ui:Refresh()
							end })
							addmargin = i == 0 -- always add space after "Connect"
						elseif #list > 0 then
							addmargin = true
						end
					end
				end,
			}, btn, 'DOWN')
		end, disabled = #vl == 13 })

		return #vl * 28 - 14
	end,
	sample = "2i3flt3g43MHy42CkT121UP6Yj0JlyqH3blvYp12jvHB3Z8O1I3cRcuK13mqwz3cMEYr3cZLWf0g2H8j3cDS2L0RImB10trpdK1nVgZI1MR7684Gjv",
	explain = [[Allows customization of the unit's logistic settings.

Click the <hl>Add Item</> button to add specific settings to modify.]],
}

data.instructions.check_logistics_options = {
	func = function(comp, state, cause, result_false, entity_in)
		local ent = GetAllyEntityOrSelf(comp, state, entity_in)
		if not ent then state.counter = result_false return end
		local src_node = GetSourceNode(state)
		local c, c2, u = src_node.c or {}, src_node.c2, src_node.u or 1
		if not next(c) then state.counter = result_false return end
		for k, _ in pairs(c) do
			local c2_flag, ent_flag = (c2[k] or false)
			if k == "connected" then
				ent_flag = not ent.disconnected
			else
				ent_flag = ent["logistics_" .. k]
			end
			if u == 1 then -- "Match All", fail on first mismatch
				if c2_flag ~= ent_flag then state.counter = result_false return end
			elseif u == 2 then -- "Match Any", succeed on first match
				if c2_flag == ent_flag then return end
			end
		end
		if u == 1 then return end -- "Match All", succeed because matched all
		state.counter = result_false -- "Match Any", fail because matched none
	end,
	name = "Check Logistics",
	desc = "Divert program depending on logistics settings",
	category = "Logistics",
	icon = "Main/skin/Icons/Common/56x56/Network.png",
	node_ui = function(canvas, inst, program_ui)
		local yheight = data.instructions.set_logistics_options.node_ui(canvas, inst, program_ui) - 26
		if next(inst.c, next(inst.c)) then
			local u, utexts, utips = (inst.u or 1), { "Match All", "Match Any" }, { "Must match all items exactly", "Succeed if one item matches" }
			local change = function(_, v) if (v or 1) ~= u then inst.u, u = (v ~= 1 and v or nil), v program_ui:Refresh() end end
			canvas:Add("<Combo halign=fill margin=6 margin_left=34/>", { on_change = change, texts = utexts, tips = utips, value = u, y = yheight + 42 })
			yheight = yheight + 34
		end
		return yheight
	end,
	args = {
		{ 'exec', "Failed", "Where to continue if the check failed" },
		{ 'in', "Unit", "The unit to check (if not self)", 'entity', true },
	},
	explain = [[Allows checking one or more logistics settings on a unit.

Click the <hl>Add Item</> button to add specific settings to check against.]],
}

data.instructions.sort_storage =
{
	func = function(comp, state, cause)
		EntityAction.SortInventory(comp.owner, { slot_type = "storage" })
	end,
	name = "Sort Storage",
	desc = "Sorts Storage Containers on Unit",
	category = "Inventory",
	icon = "Main/skin/Icons/Common/32x32/Sort.png",
	explain = [[Sorts items in the storage into an efficient order and combines stacks together.]],
}

data.instructions.solve =
{
	func = function(comp, state, cause, target, missing, exec_failed)
		local reg = Get(comp, state, target)
		local target_entity = reg and (reg.entity or reg.coord)
		if not target_entity or not IsExplorable(target_entity) or target_entity.extra_data.solved then
			Set(comp, state, missing, nil)
			return
		end
		local owner = comp.owner

		local has_scannable = target_entity:FindComponent("c_explorable_scannable")
		if has_scannable and not has_scannable.extra_data.ok then
			local scanner = owner:FindComponent("c_small_scanner")
			if not scanner or not owner.has_power then
				state.counter = exec_failed
				Set(comp, state, missing, { id = scanner and "v_unpowered" or "c_small_scanner", num = 1 })
				comp:SetStateSleep(1)
				return true
			end

			scanner:SetRegisterEntity(1, target_entity)
			state.counter = state.lastcounter
			Set(comp, state, missing, nil)
			comp:WaitForOtherCompFinish(scanner)
			return true
		end

		local solve_puzzle_comp, slot_with_fix_item, override_item
		for _,puzzle_comp in ipairs(target_entity.components or {}) do
			local puzzle_comp_def = puzzle_comp.def
			local puzzle_comp_extra_data = puzzle_comp_def.type == "Puzzle" and puzzle_comp.extra_data
			if puzzle_comp_extra_data and not puzzle_comp_extra_data.ok then
				-- check item fixables
				override_item = puzzle_comp_extra_data.explorable_override or puzzle_comp_def.explorable_override
				local fix_item = puzzle_comp_extra_data.explorable_fix or puzzle_comp_def.explorable_fix
				if fix_item or override_item then
					slot_with_fix_item = owner:FindSlot(fix_item or override_item, 1)
					if slot_with_fix_item then
						solve_puzzle_comp = puzzle_comp
						break
					end
					if fix_item or override_item then
						Set(comp, state, missing, { id = fix_item or override_item, num = 1 })
						state.counter = exec_failed
						comp:SetStateSleep(1)
						return true
					end
				elseif puzzle_comp.id == "c_explorable_autosolve" then
					solve_puzzle_comp = puzzle_comp
					break
				elseif puzzle_comp.id == "c_alien_lock" then
					if owner:FindComponent("c_alien_key") then
						solve_puzzle_comp = puzzle_comp
						break
					end
				end

				-- remaining puzzles should just need to wait until theyre done
				local id = puzzle_comp.id
				Set(comp, state, missing, { id = id, num = 1 })
				state.counter = exec_failed
				comp:SetStateSleep(1)
				return true
			end
		end

		-- if it got here without being solved and theres an override item then set missing to that
		if not solve_puzzle_comp then
			if override_item then
				Set(comp, state, missing, { id = override_item, num = 1 })
				state.counter = exec_failed
				comp:SetStateSleep(1)
				return true
			end
		end

		-- Mark puzzle or explorable as solved then repeat this instruction
		state.counter = state.lastcounter
		Set(comp, state, missing, nil)

		if comp:RequestStateMove(target_entity) then
			-- Not yet next to the target, wait for move to complete then repeat this instruction
			return true
		end

		if solve_puzzle_comp then
			FactionAction.ExplorableSolvePuzzle(owner.faction, { comp = solve_puzzle_comp, consume_slot = slot_with_fix_item })
		else
			FactionAction.ExplorableSetSolved(owner.faction, { entity = target_entity })
		end

		comp:SetStateSleep(1)
		return true
	end,
	args = {
		{ 'in', "Target", "Explorable to solve", 'entity' },
		{ 'out', "Missing", "Missing repair item, scanner component or Unpowered" },
		{ 'exec', "Failed", "Missing item, component, or power to scan" },
	},
	name = "Solve Explorable",
	desc = "Attempt to solve an explorable",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Drop Items.png",
	explain = [[Will attempt to solve the next item on an unsolved explorable. <hl>Missing</> will contain the required item if failed to solve it. Diverts logic if solving fails.]],
}

data.instructions.is_docked = {
	func = function(comp, state, cause, exec_nodock, out_garage)
		local docked_garage = comp.owner.docked_garage
		if out_garage then Set(comp, state, out_garage, docked_garage) end
		if not docked_garage then state.counter = exec_nodock end
	end,
	args = {
		{ 'exec', "Not Docked", "Where to continue if unit is not docked" },
		{ 'out', "Garage", "Unit" },
	},
	name = "Is Docked",
	desc = "Check if a unit is docked and get its garage",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Count Free Space.png",
	explain = [[Checks if the unit is docked and returns the garage if docked or diverts logic is not docked.]],
}

local function GetRegisterOrComponentRegister(comp, state, compreg, comp_index, writable)
	local regcomp, getcompid = GetComponentFromIndex(comp, state, comp_index, compreg)
	local num = GetNum(comp, state, compreg)
	if getcompid then
		if not regcomp then return end
		if num <= 0 then num = 1 end
		local register_defs = writable and regcomp.def.registers
		local register_def = register_defs and register_defs[num]
		if register_def and register_def.read_only then return end
		return regcomp:GetRegister(num)
	end
	if num == 1 then return FRAMEREG_SIGNAL
	elseif num == 2 then return FRAMEREG_VISUAL
	elseif num == 3 then return FRAMEREG_STORE
	elseif num == 4 then return FRAMEREG_GOTO end
end

data.instructions.set_link =
{
	func = function(comp, state, cause, from, from_index, to, to_index)
		local reg_from = GetRegisterOrComponentRegister(comp, state, from, from_index)
		local reg_to = GetRegisterOrComponentRegister(comp, state, to, to_index, true)
		if reg_from and reg_to then comp.owner:LinkRegisterFromRegister(reg_to, reg_from) end
	end,
	args = {
		{ 'in', "From", "Component and register number to start a new link", 'comp_num' },
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'in', "To", "Component and register number to end a new link", 'comp_num' },
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
	},
	name = "Set Link",
	desc = "Set register link",
	category = "Components",
	sample = "4d3bEIye2fVSng3WqwOU0xokOC25vA8t2JZIgm1UWD613pjgUE0zP4hW36Q9Ly0EoTor3jiXVs1Wqoo80vHdhz4C75Bj3KrEF548U0Xb3es3Dl1mCf1Z000qQ41OU5jHe",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
	explain = [[Creates a link between two registers.

<hl>From</> specifies the component and register number on that register to start the link
<hl>To</> specifies the component and register number of the register to end the link

- If no number is specified it will get the first register.
- Extra variables for <hl>Component Index</> allow specifying registers if multiple of the same component are equipped.
- If no component is specified then it will use the base registers of the unit.

Example:
- Link the result register of the Scout Radar to the frames <bl>Visual</> Register
- Link the Missing Ingredient register of the second equipped fabricator to the units <bl>Signal</> Register.]],
}

data.instructions.clear_link =
{
	func = function(comp, state, cause, from, from_index, to, to_index)
		local reg_from = GetRegisterOrComponentRegister(comp, state, from, from_index)
		local reg_to = GetRegisterOrComponentRegister(comp, state, to, to_index)
		if reg_from and reg_to then comp.owner:UnlinkRegisterFromRegister(reg_to, reg_from) end
	end,
	args = {
		{ 'in', "From", "Component/Register Index to start clearing a link", 'comp_num' },
		{ 'in', "Component Index", "Index for when multiple components equipped of same type", 'posnum', true },
		{ 'in', "To", "Component/Register Index to end clearing a link", 'comp_num' },
		{ 'in', "Component Index", "Index for when multiple components equipped of same type", 'posnum', true },
	},
	name = "Clear Link",
	desc = "Clear register link",
	sample = "V02rugD00ZrgW1kIyn229KtvP1mdoOq2yRWLc02Gtj720HOnj000gcg29Kh6o04YPFt1r9kT41z2xSD2yPbs9018W0VU",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
	explain = [[Clears a specific established link or connection

See <hl>Set Link</> for parameter details.]],
}

data.instructions.clear_all_links =
{
	func = function(comp, state, cause)
		for _, l in ipairs(comp.owner:GetRegisterLinks(false, true) or {}) do
			local reg_from, reg_to = l.source_index, l.index
			local comp_from, comp_to = (reg_from > FRAMEREG_COUNT and l.source_component), (reg_to > FRAMEREG_COUNT and l.component)
			if (not comp_from or not comp_from.is_hidden or comp_from.def.get_ui) and (not comp_to or not comp_to.is_hidden or comp_to.def.get_ui) then
				comp.owner:UnlinkRegisterFromRegister(reg_to, reg_from)
			end
		end
	end,
	name = "Clear All Links",
	desc = "Clear all register links on this unit",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Set Register.png",
	explain = [[Clear all register links on the unit holding the Behavior controller. Including links to and from components that contain registers.

Note: This instruction cannot be used to perform the action on an external unit.]],
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- MOVE -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

data.instructions.stop =
{
	func = function(comp, state, cause, target)
		comp.owner:Cancel()
	end,
	name = "Stop Unit",
	desc = "Stop movement and abort what is currently controlling the unit's movement",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Halts all movement and actions currently being executed by the unit.]],
}

data.instructions.get_location = {
	func = function(comp, state, cause, in_entity, out_coord)
		local ent = GetSeenEntityOrSelf(comp, state, in_entity)
		Set(comp, state, out_coord, ent and ent.location)
	end,
	args = {
		{ 'in', "Unit", "Unit to get coordinates of", 'entity' },
		{ 'out', "Coord", "Coordinate of unit", },
	},
	name = "Get Location",
	desc = "Gets location of a seen unit",
	category = "Movement",
	sample = "4n3YxVw80sfebZ3FYilH1mhyfZ1aqqXJ3mEgt61mSlGp1lR1A02pEzn83JGOGx2yjtHI03dj7c393Dme48tMBM0oR9Wf3gYKqo4Ir13P0oIFCO1kWMsT3Fqfg00LjJLm4bI1Jf2giIcU4BzdP64d1urc15VNyW2ReA392sJGaE32eOpU00IptM4J1AVYH",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[Gets the current coordinate of the unit.]],
}

data.instructions.get_offset = {
	func = function(comp, state, cause, in_target, out_offset)
		local reg = Get(comp, state, in_target)
		local target_entity = reg.entity
		local ofs = target_entity and target_entity.location or reg.coord
		if ofs then
			local x, y = comp.owner:GetLocationXY()
			ofs.x, ofs.y = x - ofs.x, y - ofs.y
		end
		Set(comp, state, out_offset, ofs)
	end,
	args = {
		{ 'in', "Target", "Unit/Coord to get offset from", 'coord' },
		{ 'out', "Offset", "Offset from unit", 'coord' },
	},
	name = "Get Offset",
	desc = "Gets current offset from a unit",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[<hl>Target</> specifies the unit or coord you want to get the offset from]],
	sample = "2W3bEIye4XJFlw0eSEdy3tXhH132VJta0glM3R1vgfPV2XzKR33GxCnS1mFGcl4SPuUM30qovr0QMAzZ1Ds",
}

data.instructions.move_offset =
{
	func = function(comp, state, cause, in_offset, in_entity)
		local move_ofs = GetCoord(comp, state, in_offset)
		local e = GetSeenEntityOrSelf(comp, state, in_entity)
		if move_ofs and e then
			local loc = e.location
			if not comp:RequestStateMove(loc.x+move_ofs.x, loc.y+move_ofs.y) then comp:SetStateSleep(1) end
		else
			comp:SetStateSleep(1)
		end
		return true
	end,
	args = {
		{ 'in', "Offset", "Offset to move to", 'coord' },
		{ 'in', "Unit", "Unit to offset from", 'entity', true },
	},
	name = "Move Offset",
	desc = "Moves to a specific offset of current location or specified unit",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[<hl>Offset</> is the x,y offset amount to move
Optional <hl>Unit</> can specify a unit as the base for the offset.
Defaults to current location.]],
	sample = "2W3bEIye4XJFlw0eSEdy3tXhH132VJta0glM3R1vgfPV2XzKR33GxCnS1mFGcl4SPuUM30qovr0QMAzZ1Ds",
}

data.instructions.move_east =
{
	func = function(comp, state, cause, target)
		local x, y = comp.owner:GetLocationXY()
		if not comp:RequestStateMove(x+GetNum(comp, state, target), y) then comp:SetStateSleep(1) end
		return true
	end,
	-- deprecated, unlisted by having no category, use move offset instead
	args = { { 'in', "Number", nil, 'posnum' }, },
	name = "Move East",
	desc = "Move East",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
}

data.instructions.move_west =
{
	func = function(comp, state, cause, target)
		local x, y = comp.owner:GetLocationXY()
		if not comp:RequestStateMove(x-GetNum(comp, state, target), y) then comp:SetStateSleep(1) end
		return true
	end,
	-- deprecated, unlisted by having no category, use move offset instead
	args = { { 'in', "Number", "Number of tiles to move West", 'posnum' }, },
	name = "Move West",
	desc = "Move West",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
}

data.instructions.move_north =
{
	func = function(comp, state, cause, target)
		local x, y = comp.owner:GetLocationXY()
		if not comp:RequestStateMove(x, y-GetNum(comp, state, target)) then comp:SetStateSleep(1) end
		return true
	end,
	-- deprecated, unlisted by having no category, use move offset instead
	args = { { 'in', "Number", "Number of tiles to move North", 'posnum' }, },
	name = "Move North",
	desc = "Move North",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
}

data.instructions.move_south =
{
	func = function(comp, state, cause, target)
		local x, y = comp.owner:GetLocationXY()
		if not comp:RequestStateMove(x, y+GetNum(comp, state, target)) then comp:SetStateSleep(1) end
		return true
	end,
	-- deprecated, unlisted by having no category, use move offset instead
	args = { { 'in', "Number", "Number of tiles to move South", 'posnum' }, },
	name = "Move South",
	desc = "Move South",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
}

data.instructions.attack_move =
{
	func = function(comp, state, cause, in_target, in_unit)
		local ent = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if not ent then return end

		local reg = Get(comp, state, in_target)
		local target_entity = reg.entity
		local target_coord = target_entity and target_entity.location or reg.coord

		local turret
		local turret_range
		for i=1,999 do
			local next_turret = ent:FindComponent("c_turret", true, i)
			if not next_turret then break end
			local next_range = next_turret.def.attack_radius
			if not turret or next_range > turret_range then
				turret = next_turret
				turret_range = next_range
			end
		end
		if turret then
			if not target_coord then
				turret:SetRegister(1, nil)
			else
				turret:SetRegister(1, { coord = target_coord, num = reg.num })
			end
		end
	end,
	args = {
		{ 'in', "Target", "Target unit or coordinate", 'coord' },
		{ 'in', "Unit", "Unit", 'entity', true },
	},
	name = "Attack Move",
	desc = "Moves towards a location stopping to attack any enemies encountered",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[Moves toward a location while stopping to attack any enemies encountered along the way.]],
}

data.instructions.simulation_tick = {
	func = function(comp, state, cause, out_tick)
		Set(comp, state, out_tick, Map.GetTick())
	end,
	args = {
		{ 'out', "Tick", "Simulation Tick"}
	},
	name = "Simulation Tick",
	category = "Values",
	desc = "Returns the current Simulation Tick",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Writes the current simulation tick to <hl>Tick</>.

The value increases as the map simulation runs and can be used for timers, rate limits, or comparing when something last happened. There are 5 simulation ticks per second.]],
}

data.instructions.domove =
{
	func = function(comp, state, cause, c, target, exec_fail, in_unit)
		local ent = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if not ent then if exec_fail then state.counter = exec_fail end return end

		local reg = Get(comp, state, target)
		local target = reg and (reg.entity or reg.coord)
		if not target then return end
		if c == 2 or comp.owner ~= ent then
			ent:MoveTo(target, math.max(reg.num, 0))
		else
			local need_move, repeat_blocked = comp:RequestStateMove(target, math.max(reg.num, 0))
			if repeat_blocked then
				comp:SetStateSleep(1)
				state.counter = exec_fail
			elseif need_move then
				-- Not yet next to the target, wait for move to complete then repeat this instruction
				state.counter = state.lastcounter
			else
				comp:SetStateSleep(1)
			end
			return true
		end
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Synchronous", "Asynchronous" })
	end,
	args = {
		{ 'in', "Target", "Unit or coordinate to move to, the number specifies the range in which to be in", 'coord_num' },
		{ 'exec', "Path Blocked", "Where to continue if unit is path blocked" },
		{ 'in', "Unit", "The unit to move (if not self)", 'entity', true },
	},
	name = "Move Unit",
	desc = "Moves to another unit or within a range of another unit",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[Moves the unit to the specified target location or within range of it by specifying the number in the register.]],
}

data.instructions.moveaway_range =
{
	func = function(comp, state, cause, c, target)
		local reg = Get(comp, state, target)
		if not reg or not reg.entity then return end
		local range = reg.num > 0 and reg.num or 5

		-- find location away from unit
		local l1, l2 = comp.owner.location, reg.entity.location

		local x = l1.x-l2.x
		local y = l1.y-l2.y
		local denom = math.sqrt((x*x)+(y*y))
		if denom > range then return end
		if denom == 0 then
			if c == 2 then comp.owner:MoveTo(l1.x+range, l1.y) return end
			if not comp:RequestStateMove(l1.x+range, l1.y) then comp:SetStateSleep(1) end
		else
			local lx = math.ceil((x/denom)*range)+l2.x
			local ly = math.ceil((y/denom)*range)+l2.y
			if c == 2 then comp.owner:MoveTo(lx, ly) return end
			if not comp:RequestStateMove(lx, ly) then comp:SetStateSleep(1) end
		end
		return true
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Synchronous", "Asynchronous" })
	end,
	args = {
		{ 'in', "Target", "Unit to move away from", 'entity' },
	},
	name = "Move Away (Range)",
	desc = "Moves out of range of another unit, the number value of the target specifies the range",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
	explain = [[Moves the unit away from a target until it is outside the of specified range specified in the number of the register.]],
}

data.instructions.scout =
{
	func = function(comp, state, cause, c)
		local loc = comp.faction.home_location
		local target_loc = comp.owner.location
		local vx = target_loc.x - loc.x
		local vy = target_loc.y - loc.y
		local len = math.sqrt(vx * vx + vy * vy)
		if len == 0 then -- i am the faction home
			local newx, newy = comp.faction:FindClosestHiddenTile(target_loc.x, target_loc.y, 1000)
			if newx == nil then
				-- pick random direction
				target_loc.x = target_loc.x + math.random(-10, 10)
				target_loc.y = target_loc.y + math.random(-10, 10)
			else
				target_loc.x, target_loc.y = newx, newy
			end
		elseif len < 40 then
			-- * check distance from base and move away from it if too close
			--print(target_loc, len)
			target_loc.x, target_loc.y = math.floor(target_loc.x + (vx*20)/len), math.floor(target_loc.y + (vy*20)/len)
			--print(target_loc)
		else
			-- not very smart...
			-- * try to head towards hidden tiles? target_loc.x, target_loc.y = comp.faction:FindClosestHiddenTile(target_loc.x, target_loc.y, 1000)
			-- * try to not get stuck... how to detect stuck?
			-- * avoid blight! this should probably be part of the pathing/movement system...

			-- add some randomness
			local ang_deg = Map.GetTick()%360
			local rx=math.floor(math.cos(math.rad(ang_deg))*(len/15))
			local ry=math.floor(math.sin(math.rad(ang_deg))*(len/15))

			-- go around in circles wiht a bit of loopy loop randomness
			target_loc.x, target_loc.y = math.floor(target_loc.x + (vy*(len/10))/len)+rx, math.floor(target_loc.y + (-vx*(len/10))/len)+ry
		end

		-- async
		if c == 2 then comp.owner:MoveTo(target_loc.x, target_loc.y) return end

		-- sync
		local moveret = comp:RequestStateMove(target_loc.x, target_loc.y)
		if not moveret then state.counter = state.lastcounter comp:SetStateSleep(5) end
		return true
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		return NodeUICombo(canvas, inst, program_ui, { "Synchronous", "Asynchronous" })
	end,
	name = "Scout",
	desc = "Moves in a scouting pattern around the factions home location",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Scout.png",
	explain = [[Sends the unit to explore unknown areas in a spiral movement around your faction home.]],
}

data.instructions.scout_rand_range =
{
	func = function(comp, state, cause, in_range, in_lastLoc)
		local target_loc = comp.owner.location
		local range = GetNum(comp, state, in_range)
		if range <= 0 then range = 5 end

		if in_lastLoc then
			local lastCoord = GetCoord(comp, state, in_lastLoc)
			if lastCoord then
				local x1, x2, y1, y2 = lastCoord.x, target_loc.x, lastCoord.y, target_loc.y
				if x1 ~= x2 or y1 ~= y2 then
					local dx, dy = x2-x1, y2-y1
					target_loc.x = target_loc.x + math.ceil(dx*1.5)
					target_loc.y = target_loc.y + math.ceil(dy*1.5)
				end
			end
		end

		-- pick random direction
		target_loc.x = target_loc.x + math.random(-range, range)
		target_loc.y = target_loc.y + math.random(-range, range)

		comp.owner:MoveTo(target_loc.x, target_loc.y)
	end,
	args = {
		{ 'in', "Range", "Range to scout", 'posnum' },
		{ 'in', "Coord", "Last Coordinate", 'coord' },
	},
	name = "Scout Range",
	desc = "Moves in a random direction a specified amount\nOptionally pass a coordinate to give some directionality",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Scout.png",
	explain = [[Scouts a random location within a defined range.]],
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- COMPONENT -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
data.instructions.for_count_resources =
{
	func = function(comp, state, cause, out_resource, exec_done)
		local resources = { }
		local location = comp.owner.location

		local range = comp.owner.power_range
		if range == 0 then range = comp.owner.visibility_range end
		Map.FindClosestEntity(location.x, location.y, range - 1, function(e)
			if not comp.faction:IsDiscovered(e) then return end
			local id, amt = GetResourceHarvestItemId(e), GetResourceHarvestItemAmount(e)
			if id and resources[id] ~= REG_INFINITE then
				if amt == REG_INFINITE then resources[id] = REG_INFINITE
				else resources[id] = (resources[id] or 0) + amt
				end
			end
		end, FF_RESOURCE)
		local it = { 2 }
		for k,v in SortedPairs(resources) do
			it[#it+1] = k
			it[#it+1] = v
		end
		if #it > 1 then return BeginBlock(comp, state, it, 2) end
		Set(comp, state, out_resource, nil)
		state.counter = exec_done
	end,

	next = function(comp, state, it, out_resource, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_resource, { id = it[i], num = it[i+1] })
		it[1] = i + 2
	end,

	last = function(comp, state, it, out_resource, exec_done)
		state.counter = exec_done
	end,

	args = {
		{ 'out', "Resource" },
		{ 'exec', "Done" },
	},
	name = "Loop Nearby Resources",
	desc = "Scans for nearby resources in power field or visibility range",
	category = "Loops",
	icon = "Main/skin/Icons/Special/Commands/Scan.png",
	explain = [[Loops over all resource types and counts the total amount of each in the power field or visibility range.]],
}

data.instructions.deploy = {
	func = function(comp, state, cause, in_coord)
		local owner = comp.owner
		local deployment = owner:FindComponent("c_deployment", true)
		local deployment_frame = deployment and deployment.def.deployment_frame
		local deployer = not deployment_frame and owner:FindComponent("c_deployer")
		local deployer_ed = deployer and deployer.has_extra_data and deployer.extra_data
		local deployer_frame = deployer_ed and deployer_ed.bp and deployer_ed.bp.frame
		local frame_id = deployment_frame or deployer_frame
		if not frame_id then return end
		local faction, depcomp, coord = comp.faction, (deployment or deployer), GetCoord(comp, state, in_coord) or owner.location
		if not faction:IsVisible(coord) then return end
		local x, y = faction:GetPlaceableLocation(frame_id, coord.x, coord.y, true)
		depcomp:SetRegister(1, { x, y })
	end,
	name = "Deploy",
	desc = "Deploys the unit itself or a unit held in a Deployer component at specified or current location",
	category = "Components",
	args = {
		{ 'in', "Location", "Location to deploy", 'coord' },
	},
	icon = "Main/skin/Icons/Special/Commands/Move To.png",
}

data.instructions.wait_component =
{
	func = function(comp, state, cause, in_comp, comp_index, exec_not_working)
		if cause & CC_OTHER_COMP_FINISH_WORK ~= 0 then
			comp:SetStateSleep(1)
		else
			local found_comp = GetComponentFromIndex(comp, state, comp_index, in_comp)
			if found_comp then
				if not found_comp.is_working and exec_not_working then state.counter = exec_not_working return end
				comp:WaitForOtherCompFinish(found_comp)
			else
				comp:SetStateSleep(1)
			end
		end
		return true
	end,
	args = {
		{ 'in', "Component", "Component to wait for", 'comp'},
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'exec', "Not Working", "Execution path if the component isn't currently working" },
	},
	name = "Wait Component",
	desc = "Waits for a component before continuing behavior",
	sample = "V02rMa9057Lu41kIyn329KtvP1mdoOq2yRWLc3BYvDV28Aqyl20Fjl11rAJLk22kZQc01oI",
	explain = [[Waits on a specified component to finish their current work cycle and then resumes execution of the behavior]],
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Wait.png"
}

data.instructions.scan =
{
	func = function(comp, state, cause, f1, f2, f3, result, no_result)
		local owner = comp.owner
		local radar = owner:FindComponent("c_portable_radar", true)

		local f1id = GetId(comp, state, f1)
		local filters = { f1id, f1id and GetNum(comp, state, f1), nil, nil, nil, nil }
		if filters[1] then
			filters[3] = GetId(comp, state, f2)
			filters[4] = filters[3] and GetNum(comp, state, f2)
			if filters[3] then
				filters[5] = GetId(comp, state, f3)
				filters[6] = filters[5] and GetNum(comp, state, f3)
			end
		end

		if not radar then
			local num
			local entity_filter, override_range = PrepareFilterEntity(filters)
			local range = owner.visibility_range
			local res = Map.FindClosestEntity(owner, math.min(override_range or range, range), function(e)
				local a, b = FilterEntity(owner, e, filters)
				if a then
					num = b
				end
				return a
			end, entity_filter)
			Set(comp, state, result, { entity = res, num = num })
			if not res then
				state.counter = no_result
			end
			comp:SetStateSleep(1)
			return true
		end

		local vals = { Get(comp, state, f1), Get(comp, state, f2), Get(comp, state, f3) }
		local radar_reg_count, filters_changed = #radar.def.registers
		for i=1,math.min(#vals, radar_reg_count - 1) do
			if radar:GetRegister(i) ~= vals[i] then
				radar:SetRegister(i, vals[i])
				filters_changed = true
			end
		end

		if filters_changed or cause & CC_OTHER_COMP_FINISH_WORK == 0 then
			state.counter = state.lastcounter
			comp:WaitForOtherCompFinish(radar)
			return true
		end

		Set(comp, state, result, radar:GetRegister(radar_reg_count))

		if not GetEntity(comp, state, result) then state.counter = no_result end

		for i=1,math.min(#vals, radar_reg_count - 1) do
			radar:SetRegister(i, nil)
		end
	end,
	args = {
		{ 'in', "Filter 1", "First filter", 'radar' },
		{ 'in', "Filter 2", "Second filter", 'radar' },
		{ 'in', "Filter 3", "Third filter", 'radar' },
		{ 'out', "Result" },
		{ 'exec', "No Result", "Execution path if no results are found" },
	},
	name = "Radar",
	desc = "Scan for the closest unit that matches the filters",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Scan.png",
	explain = [[Scans the nearby environment for objects or entities of interest. This instruction does not require a radar component to be equipped. If no radar is equipped, visibility range is used.]],
}

data.instructions.mine = {
	func = function(comp, state, cause, resource, exec_cantmine, exec_full)
		local owner = comp.owner
		local miner = owner:FindComponent("c_miner", true)
		if not miner then -- no miner component
			state.counter = exec_cantmine
			comp:SetStateSleep(1)
			return true
		end

		local val = Get(comp, state, resource)
		local val_id = val.id
		local val_entity = not val_id and val.entity
		if val_entity then
			if IsResource(val_entity) then
				val_id = GetResourceHarvestItemId(val_entity)
			elseif IsDroppedItem(val_entity) and owner.faction:IsSeen(val_entity) then
				local dropslot = val_entity:GetSlot(1)
				val_id = dropslot and dropslot.id
			end
		end

		--  get the list of possible miner components and check if already has required amount or is out of power
		local val_def = val_id and data.items[val_id]
		local mining_recipe = val_def and val_def.mining_recipe
		local is_full = mining_recipe and (not owner:HaveFreeSpace(val_id, 1) or (val.num > 0 and owner:CountItem(val_id) >= val.num))
		local no_power = mining_recipe and (owner.efficiency == 0)

		-- if un-mineable item, full or out of power, clear miner registers
		local set_val = (mining_recipe and not is_full and not no_power and val or nil)

		-- try to recover when calling mine instruction while path is blocked
		local path_blocked = set_val and owner.state_path_blocked
		if path_blocked then owner:Cancel() end

		local set_regs, i, set_infinite = 0, 1, (set_val and set_val.num <= 0)
		while miner do
			-- Only set miners that can mine the requested item, and, don't set registers of miners that already target the specified node
			if not mining_recipe or mining_recipe[miner.id] then
				local miner_num = miner:GetRegisterNum(1)
				if set_infinite and miner_num <= 0 then set_val.num = miner_num end -- keep existing infinite (miner component treats everything <= 0 as infinite)
				if path_blocked or not set_val or miner_num ~= set_val.num or (val_entity and (not miner.has_extra_data or miner.extra_data.target ~= val_entity)) or (not val_entity and miner:GetRegisterId(1) ~= set_val.id) then
					miner:SetRegister(1, set_val, path_blocked)
				end
				set_regs = set_regs + 1
			end
			i = i + 1
			miner = owner:FindComponent("c_miner", true, i)
		end

		if not set_val or set_regs == 0 then
			state.counter = (is_full and exec_full) or (not is_full and exec_cantmine)
		end
	end,
	args = {
		{ 'in', "Resource", "Resource to Mine", "resource_num" },
		{ 'exec', "Cannot Mine", "Execution path if mining was unable to be performed" },
		{ 'exec', "Full", "Execution path if can't fit resource into inventory" },
	},
	name = "Mine",
	desc = "Mine a single resource deposit",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Starts mining nearby resource deposits and divert logic depending on whether the unit cannot mine or inventory is full.]],
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- GLOBAL -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

data.instructions.get_stability = {
	func = function(comp, state, cause, out_stability)
		local stability = StabilityGet and StabilityGet() or 0
		Set(comp, state, out_stability, stability)
	end,
	args = {
		{ 'out', "Number", "Stability" },
	},
	name = "Get Stability",
	desc = "Gets the current world stability",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Returns the current world stability as a number.]],
}

data.instructions.percent_value = {
	func = function(comp, state, cause, in_value, in_max, out_percent)
		local value, max = GetNum(comp, state, in_value), GetNum(comp, state, in_max)
		Set(comp, state, out_percent, (value*100) // (max ~= 0 and max or 1))
	end,
	args = {
		{ 'in', "Value", "Value to check" },
		{ 'in', "Max Value", "Max value to get percentage of" },
		{ 'out', "Number", "Percent" },
	},
	name = "Percent",
	desc = "Calculate the percentage that value is of max value",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Calculates a percentage-based value from an input number.]],
}

data.instructions.remap_value = {
	func = function(comp, state, cause, in_value, in_low_input, in_high_input, in_low_target, in_high_target, out_result)
		local value, low_input, high_input, low_target, high_target = GetNum(comp, state, in_value), GetNum(comp, state, in_low_input), GetNum(comp, state, in_high_input), GetNum(comp, state, in_low_target), GetNum(comp, state, in_high_target)
		local dif_target = high_target-low_target
		local dif_input = high_input-low_input

		if dif_target == 0 or dif_input == 0 then
			Set(comp, state, out_result, high_target)
		else
			local outnum = low_target+ (value-low_input) * (dif_target) // (dif_input)
			outnum = math.min(outnum, high_target)
			outnum = math.max(outnum, low_target)
			Set(comp, state, out_result, outnum)
		end
	end,
	args = {
		{ 'in', "Value", "Value to Remap" },
		{ 'in', "Input Low", "Low value for input" },
		{ 'in', "Input High", "High value for input" },
		{ 'in', "Target Low", "Low value for target" },
		{ 'in', "Target high", "High value for target" },
		{ 'out', "Result", "Remapped value" },
	},
	name = "Remap",
	desc = "Remaps a value between two ranges",
	category = "Values",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Maps a number from one value range to another.]],
}

data.instructions.is_daynight = {
	func = function(comp, state, cause, if_day, if_night)
		state.counter = Map.GetSunlightIntensity() > 0.0 and if_day or if_night
	end,
	exec_arg = false,
	args = {
		{ 'exec', "Day", "Where to continue if it is nighttime" },
		{ 'exec', "Night", "Where to continue if it is daytime" },
	},
	name = "Check Day/Night",
	desc = "Divert program depending on the time of day",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Checks whether it is currently day or night in the world.]],
}

data.instructions.get_season = {
	func = function(comp, state, cause, if_winter, if_spring, if_summer, if_fall)
		local season = Map.GetYearSeason()
		local season_no = (math.floor((season + 0.125) * 4.0) % 4) + 1
		if season_no == 1 then state.counter = if_winter
		elseif season_no == 2 then state.counter = if_spring
		elseif season_no == 3 then state.counter = if_summer
		else state.counter = if_fall
		end
	end,
	exec_arg = false,
	args = {
		{ 'exec', "Winter", "Where to continue if it is winter" },
		{ 'exec', "Spring", "Where to continue if it is spring" },
		{ 'exec', "Summer", "Where to continue if it is summer" },
		{ 'exec', "Fall", "Where to continue if it is fall" },
	},
	name = "Check Season",
	desc = "Divert program depending on season",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Compare Values.png",
	explain = [[Returns the current season and diverts logic depending on the season.]],
}

data.instructions.faction_item_amount = {
	func = function(comp, state, cause, item, output, exec_none)
		local item_id = GetId(comp, state, item)
		local amount = item_id and comp.faction:GetItemAmount(item_id)
		if amount == 0 then state.counter = exec_none end -- not taken if amount is nil
		Set(comp, state, output, item_id and { item = item_id, num = amount })
	end,
	args = {
		{ 'in', "Item", "Item to count", 'item' },
		{ 'out', "Result", "Number of this item in your faction" },
		{ 'exec', "None", "Execution path when none of this item exists in your faction" },
	},
	name = "Faction Item Amount",
	desc = "Counts the number of the passed item in your logistics network",
	category = "Logistics",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Counts how many of the selected item is available to the faction.

The count comes from faction storage/logistics availability. If the input is not an item, <hl>Result</> is cleared. If the item count is zero, execution continues through <hl>None</>.]],
}

data.instructions.readkey = {
	func = function(comp, state, cause, in_entity, key)
		local entity = GetEntity(comp, state, in_entity)
		local entity_ed = entity and entity.has_extra_data and entity.extra_data
		local scannable = entity_ed and entity_ed.solved and entity:FindComponent("c_explorable_scannable")
		local scannable_ed = scannable and scannable.has_extra_data and scannable.extra_data
		local hack_code = scannable_ed and scannable_ed.hack_code
		Set(comp, state, key, hack_code and { entity = entity, num = hack_code } or nil)
	end,
	args = {
		{ 'in', "Explorable", "Structure to read the key for", 'entity' },
		{ 'out', "Key", "Number key of structure" },
	},
	name = "Read Key",
	desc = "Attempts to read the internal key of the unit",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Read Key.png",
	explain = [[Reads a value from a configuration or storage key.]],
}

data.instructions.can_produce =
{
	func = function(comp, state, cause, can_prod, product_id, in_component)
		local product_def = data.all[GetId(comp, state, product_id)]
		if not product_def then
			local entity = GetEntity(comp, state, product_id)
			if entity then product_def = entity.def end
		end
		local owner, production_recipe = comp.owner, product_def and (product_def.production_recipe or product_def.construction_recipe)
		local producers = (production_recipe and production_recipe.producers) or (product_def and product_def.mining_recipe)
		if producers then
			-- only check the owner if a component wasnt specified
			local component_id = GetId(comp, state, in_component)
			if component_id then
				for k,v in pairs(producers) do
					if k == component_id then
						state.counter = can_prod
						return
					end
				end
			else
				for k,v in pairs(producers) do
					if owner:CountComponents(k) > 0 then
						state.counter = can_prod
						return
					end
				end
			end
		end
	end,
	name = "Can Produce",
	desc = "Returns if a unit can produce an item",
	exec_arg = { 1, "Cannot Produce", "Where to continue if the item cannot be produced" },
	args = {
		{ 'exec', "Can Produce", "Where to continue if the item can be produced" },
		{ 'in', "Item", "Production Item", 'item' },
		{ 'in', "Component", "Optional Component to check (if Component not equipped)", 'comp_num', true },
	},
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Can Produce.png",
	explain = [[Checks if a unit can produce a specific item and diverts logic depending on the result.]],
}

data.instructions.get_ingredients =
{
	func = function(comp, state, cause, product, out1, out2, out3)
		local item_id = GetId(comp, state, product)
		local product_def, ingredients = item_id and data.all[item_id]
		local ent = not product_def and GetEntity(comp, state, product)
		local count = 1
		if product_def then
			local production_recipe = product_def.production_recipe or product_def.uplink_recipe
			ingredients = production_recipe.ingredients
			if product_def.progress_count then count = product_def.progress_count end
		elseif ent and ent.is_construction then
			local fd, bd = GetProduction(ent:GetRegisterId(FRAMEREG_GOTO), ent)
			ingredients = fd and GetIngredients((fd.construction_recipe or fd.production_recipe), bd)
		end
		local res = { }
		if ingredients then
			for rec_item,rec_num in SortedPairs(ingredients) do
				res[#res + 1] = { id = rec_item, num = rec_num*count }
			end
		end
		table.sort(res, function(a, b) return a.id < b.id end)
		Set(comp, state, out1, res[1])
		Set(comp, state, out2, res[2])
		Set(comp, state, out3, res[3])
	end,
	args = {
		{ 'in', "Product", nil, 'item' },
		{ 'out', "Out 1", "First Ingredient" },
		{ 'out', "Out 2", "Second Ingredient" },
		{ 'out', "Out 3", "Third Ingredient" },
	},
	-- deprecated, unlisted by having no category, use loop ingredients instead
	name = "Get Ingredients",
	desc = "Returns the ingredients required to produce an item",
	icon = "Main/skin/Icons/Special/Commands/Ingradients.png",
	explain = [[Returns the required ingredients for producing a specified item or recipe.]],
}

local function stringinput_convert(comp, state, msg, ...)
	local i = 1
	for k in string.gmatch(msg or '', '{[^}]+}') do
		local a, v = Get(comp, state, select(i, ...))
		local anum, aid, aentity, acoord = a.num, a.id, a.raw_entity, a.coord
		local anumstr = (anum == REG_INFINITE and "∞") or (anum == REG_NOT and "≠") or tostring(anum)
		if aid then
			v = string.format('<img id="%s" width="32" height="32" style="hl"/>', aid)
		elseif aentity then
			v = string.format('<img id="%s" width="32" height="32" style="hl"/>', (aentity.exists and aentity.id or 'v_destroyed'))
		elseif acoord then
			v = string.format('<hl>%d, %d</>', acoord.x, acoord.y)
		else
			v = string.format('<hl>%s</>', anumstr)
		end
		if anum ~= 0 and (aid or acoord or aentity) then
			v = string.format('<bl>%s</> %s', anumstr, v)
		end
		msg = string.gsub(msg, k, v, 1)
		i = i + 1
	end
	return msg
end

local function stringinput_var_args(inst_def, inst)
	local res
	for k in string.gmatch(inst.txt or '', '{([^}]+)}') do
		if not res then res = Tool.Copy(inst_def.args) or {} end
		res[#res+1] = { 'in', k }
	end
	return res or inst_def.args
end

local function stringinput_node_ui(canvas, inst, program_ui)
	canvas:Add('<Text text="Text:" style=bl y=26 halign=fill margin=10/>')
	canvas:Add('<InputText y=50 halign=fill margin=10 height=34/>', {
		text = inst.txt,
		on_commit = function(btn, txt)
			if txt and txt == "" then txt = nil end
			if inst.txt == txt then return end
			inst.txt = txt
			program_ui:Refresh()
		end,
	})
	return 54
end

data.instructions.notify =
{
	func = function(comp, state, cause, txt, notify_value, timeout_value, ...)
		comp.faction:RunUI(function(...)
			local reg, reg_def = Get(comp, state, notify_value)
			local reg_id, reg_entity, reg_num, reg_coord = reg.id, reg.raw_entity, reg.num, reg.coord
			local timeout = GetNum(comp, state, timeout_value)
			local msg = (select("#", ...) > 0 and stringinput_convert(comp, state, txt, ...) or txt)
			if reg_entity then
				reg_def = reg_entity.exists and reg_entity.def or data.values.v_destroyed
			elseif reg_id then
				reg_def = data.all[reg_id]
			elseif reg_num ~= 0 or reg_coord then
				reg_def = comp.def
			else
				reg_def = data.values.v_notify
			end
			local notify_id = reg_coord and string.format("C%d|%d", reg_coord.x, reg_coord.y) or reg_id or "notify_behavior"
			local notify_title = reg_coord and L("Notify (%s)", string.format("%d,%d", reg_coord.x, reg_coord.y)) or (reg_num ~= 0 and L("Notify (%s)", (reg_num == REG_INFINITE and "∞") or (reg_num == REG_NOT and "≠") or tostring(reg_num)) or "Notify")
			local jump_entity = not reg_coord and (reg_entity or comp.owner)
			Notification.Add(notify_id, reg_def.texture, notify_title, NOLOC(msg) or reg_def.name or "Notification", {
				tooltip = "Behavior Notification",
				on_click = function() if reg_coord then View.MoveCamera(reg_coord.x, reg_coord.y, false) elseif Game.GetLocalPlayerFaction():IsSeen(jump_entity) then View.JumpCameraToEntities(jump_entity) end end,
				duration = timeout > 0 and timeout,
			})
		end, ...)
	end,
	make_asm = function(inst)
		return inst.txt or false
	end,
	var_args = stringinput_var_args,
	node_ui = stringinput_node_ui,
	args = {
		{ 'in', "Notify Value" },
		{ 'in', "Timeout", nil, 'num', true },
	},
	name = "Notify",
	desc = "Triggers a faction notification",
	category = "Communication",
	sample = "V02rugD00ZsUA21cKTA34kYhJ1rBwi41rBxFC07Fz2w28CU1P0as2O11rBwhY1rBxFC28EzzP22WKBc2Dq0xw00UuuY01S",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Shows an in-game notification with the specified register and some text.

<img image="Main/textures/behaviors/notify_image.png"/>

If the <hl>Notify Value</> has a target reference, then clicking on the notification will jump the camera to that unit.

If the text contains one or more tags like <hl>{My Tag}</> additional values can be embedded.]],
}

data.instructions.get_resource_item = {
	func = function(comp, state, cause, res_node, res_item, exec_notresource)
		local node = GetEntity(comp, state, res_node)
		if not node or not IsResource(node) then
			Set(comp, state, res_item, nil)
			state.counter = exec_notresource
			return
		end
		Set(comp, state, res_item, GetResourceHarvestItemId(node))
	end,
	args = {
		{ 'in', "Resource Deposit", "Resource Deposit", 'entity' },
		{ 'out', "Resource", "Resource Type" },
		{ 'exec', "Not Resource", "Continue here if it wasn't a resource deposit" },
	},
	name = "Get Resource Type",
	desc = "Gets the resource type from a resource deposit",
	category = "World",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Returns the resource type from the resource deposit. Diverts logic if the passed variable isn't a resource deposit.]],
}

data.instructions.gettrust =
{
	func = function(comp, state, cause, if_ally, if_neutral, if_enemy, target)
		if target then
			local target_entity = GetEntity(comp, state, target)
			if target_entity and target_entity.exists then
				local trust = target_entity.faction:GetTrust(comp.faction)
				if trust == 'ALLY' then state.counter = if_ally
				elseif trust == 'ENEMY' then state.counter = if_enemy
				elseif trust == 'NEUTRAL' then state.counter = if_neutral
				end
			end
		end
	end,
	exec_arg = { 1, "No Unit", "No Unit Passed" },
	args = {
		{ 'exec', "Ally", "Target unit considers you an ally" },
		{ 'exec', "Neutral", "Target unit considers you neutral" },
		{ 'exec', "Enemy", "Target unit considers you an enemy" },
		{ 'in', "Unit", "Target Unit", 'entity' },
	},
	name = "Check Trust",
	desc = "Divert program depending on the trust level of a unit's faction towards you",
	category = "World",
	icon = "Main/skin/Icons/Common/56x56/Question.png",
	explain = [[Returns the trust of the unit passed towards your own faction and diverts logic according to the result.]],
}

data.instructions.gethome = {
	func = function(comp, state, cause, result)
		Set(comp, state, result, comp.faction.home_entity)
	end,
	args = {
		{ 'out', "Result", "Factions home unit" },
	},
	name = "Get Home",
	desc = "Gets the factions home unit",
	category = "World",
	icon = "Main/skin/Icons/Common/56x56/Question.png",
	explain = [[Returns the designated home or base location of the unit.]],
}

local grid_info_stats = {
	{ "Efficiency",             function(grid) return grid.efficiency end },
	{ "Generated",              function(grid) return grid.total*TICKS_PER_SECOND end },
	{ "Received",               function(grid) return grid.received*TICKS_PER_SECOND end },
	{ "Load",                   function(grid) return grid.load*TICKS_PER_SECOND end },
	{ "Batteries/Transmitters", function(grid) return (grid.available-grid.load-grid.unused)*TICKS_PER_SECOND end },
	{ "Unused",                 function(grid) return grid.unused*TICKS_PER_SECOND end },
	--{ "Available",              function(grid) return grid.available*TICKS_PER_SECOND end },
}

data.instructions.get_grid_info = {
	func = function(comp, state, cause, c, in_target, out_result, exec_nogrid)
		local loc, faction = (not in_target and comp.owner) or GetEntity(comp, state, in_target) or GetCoord(comp, state, in_target), comp.faction
		local grid_index = loc and faction:GetPowerGridIndexAt(loc)
		local grid = grid_index and faction:GetPowerGrid(grid_index)
		if grid then
			Set(comp, state, out_result, grid_info_stats[c][2](grid))
		else
			if exec_nogrid then state.counter = exec_nogrid end
			Set(comp, state, out_result, nil)
		end
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = function(canvas, inst, program_ui)
		local texts = {}
		for i,v in ipairs(grid_info_stats) do
			texts[#texts+1] = v[1]
		end
		return NodeUICombo(canvas, inst, program_ui, texts)
	end,
	args = {
		{ 'in', "Target", "The unit or coordinate to check for (if not self)", 'coord' },
		{ 'out', "Result", "Numerical value of the grid information" },
		{ 'exec',"No Grid", nil, nil, true },
	},
	name = "Get Grid Info",
	desc = "Gets power grid information about a given location",
	category = "Logistics",
	icon = "Main/skin/Icons/Special/Commands/Scan.png",
	explain = [[Returns power grid information from a location inside the logistics network.

The type of information returned can be selected from the dropdown menu.]],
}

data.instructions.ping =
{
	func = function(comp, state, cause, target_entity_id)
		local target = Get(comp, state, target_entity_id)
		local coord = target.entity and comp.faction:IsSeen(target.entity) and target.entity.location or target.coord
		if coord then
			comp.faction:RunUI(function()
				View.PlayEffect("fx_ping", coord.x, coord.y)
				local minimap = UI.FindWidgetWithTag("Minimap")
				if minimap then minimap:AddPing(coord.x, coord.y, 'ui_light', 500) end -- just show for 500 ms
			end)
		end
	end,
	args = {
		{ 'in', "Target", "Target unit", 'entity' },
	},
	name = "Ping",
	desc = "Plays the Ping effect and notifies other players playing in the same faction",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	sample = "V02rugE1CW6YQ1rAMqo34kZAG1kNZqx1sI96h00UuuY0FuEN730UuGE1tR5zU00UuuY016",
	explain = [[Sends a ping signal to a coordinate or unit and a notification to all players in the faction. Can only be seen by the current faction.]],
}

local function build_produce_ui(canvas, inst, program_ui, op)
	local inst_def = data.instructions[op]
	canvas:Add('<Text halign=fill y=34 textalign=center style=bl/>').text = (inst_def.produce_type)
	local inst_library_id = inst.bp
	local library_item = inst_library_id and program_ui.library[inst_library_id]
	local inst_frame_id = library_item and library_item.frame or inst.frame
	local frame_def = inst_frame_id and data.frames[inst_frame_id]
	local frame_name = frame_def and (library_item and library_item.name and NOLOC(library_item.name) or frame_def.name or "Unnamed")
	local show_name = library_item and (library_item.name or (library_item.multi and "New Multi Blueprint" or "New Blueprint")) or frame_name or "Unnamed"
	if library_item or frame_def then canvas:Add('<Text halign=fill y=60 textalign=center margin_left=4 margin_right=4 clip=true/>', { text = show_name, tooltip = DefinitionTooltip(library_item or frame_def) }) end
	local popup_layout = inst_def.produce_type == "Building"
		and "<Box padding=5><BuildView on_select={on_select} library={library}/></Box>"
		or "<Box padding=5><SimpleRegisterSelection width=626 max_height=536 on_select_id={on_select_id} def_filter={bot_def_filter} is_production=true library={library}/></Box>"
	canvas:Add('<Button halign=fill y=78 margin=10/>', {
		text = L("Select %s", inst_def.produce_type),
		on_click = function(btn)
			UI.MenuPopup(popup_layout, {
				library = program_ui.library,
				inst = inst,
				on_select_id = function(menu, regsel, id, library_id)
					menu:on_select(nil, library_id, not library_id and id)
				end,
				on_select = function(menu, buildview, library_id, frame_id)
					local ins, was_changed = menu.inst
					if library_id then
						was_changed = ins.bp ~= library_id or ins.frame ~= nil
						ins.bp, ins.frame = library_id, nil
						local bp = was_changed and program_ui.library[library_id]
						if bp and bp.params then
							local argc = (inst_def.args and #inst_def.args or 0)
							for i,entry in ipairs(bp.params) do
								if not ins[argc+i] and entry[2] then ins[argc+i] = Tool.Copy(entry[2]) end
							end
						end
					elseif frame_id then
						was_changed = ins.frame ~= frame_id or ins.bp ~= nil
						ins.frame, ins.bp = frame_id, nil
					end
					UI.CloseMenuPopup()
					if was_changed then program_ui:Refresh() end
				end,
				bot_def_filter = function(def)
					return def.movement_speed or (def.frame and data.frames[def.frame].movement_speed)
				end,
			}, btn)
		end,
	})
	return 82
end

local function build_produce_var_args(inst_def, inst, code, library)
	local arg_defs, inst_library_id, res = inst_def.args, inst.bp
	local library_item = inst_library_id and library and library[inst_library_id]
	local params = library_item and library_item.params
	if params then
		for _,entry in ipairs(params) do
			if not res then res = arg_defs and table.move(arg_defs, 1, #arg_defs, 1, {}) or {} end -- shallow copy
			res[#res+1] = { 'in', NOLOC(entry[1]) or "Parameter" }
		end
	end
	return res or arg_defs
end

local function build_produce_setup_bp(comp, state, accept_multi, ...)
	local inst, faction = GetSourceNode(state), comp.faction
	local faction_library_id, faction_library = inst.bp, faction.extra_data.library
	local bp = faction_library_id and faction_library and faction_library[faction_library_id]
	local frame_id = bp and bp.frame or inst.frame
	if not frame_id and (not accept_multi or not bp or not bp.multi) then return end
	if bp and not BlueprintIsCustomized(bp) then bp = nil end
	if bp and not FactionHasUnlockedCustomBlueprint(faction, bp) then return end
	if bp then bp = ProcessLibraryBlueprint(bp) end -- returns copy
	if bp and bp.params then
		local param_vals = {...}
		for i,v in ipairs(param_vals) do
			local val = v and Get(comp, state, v)
			val = val and { id = val.id, entity = val.entity, coord = val.coord, num = val.num }
			if not val or not next(val) then val = false elseif val.num == 0 and (val.id or val.entity or val.coord) then val.num = nil end
			param_vals[i] = val
		end
		SetLibraryBlueprintParams(bp, param_vals)
	end
	if not bp and not faction:IsUnlocked(frame_id) then return end
	return frame_id, bp, faction
end

data.instructions.construct = {
	func = function(comp, state, cause, in_location, in_rotation, out_entity, on_failed, ...)
		local location, rotation = GetCoord(comp, state, in_location), GetNum(comp, state, in_rotation)
		local loc = location or comp.owner.location
		local frame_id, bp, faction = build_produce_setup_bp(comp, state, true, ...)
		local x, y, multi = loc.x, loc.y, (not frame_id and bp and Tool.Copy(bp.multi))
		if multi then
			BlueprintTransform(multi, rotation, nil, nil, true) -- shifts x/y to start at 0,0 and clears sizex of invalid frames
			for _,m in ipairs(multi) do
				local m_x, m_y = x + m.x, y + m.y
				if m.sizex and faction:IsVisible(m_x, m_y, m.sizex, m.sizey, true) and faction:CanPlace(m.frame, m_x, m_y, m.rotation or 0, true, true) then
					goto can_place
				end
			end
		elseif frame_id and faction:IsVisible(x, y) and faction:CanPlace(frame_id, x, y, rotation, true) then
			goto can_place
		end

		if out_entity then Set(comp, state, out_entity, nil) end
		state.counter = on_failed
		do return end
		::can_place::

		local check_revid, check_counter = out_entity and state.revid, out_entity and state.counter
		Map.Defer(function()
			local res = FactionAction.PlaceConstruction(faction, { locations = {loc}, id = not bp and frame_id, custom_blueprint = bp, rotation = rotation })
			if check_revid and res and comp.exists and comp.is_sleeping and comp.extra_data == state and state.revid == check_revid and state.counter == check_counter then
				Set(comp, state, out_entity, res)
			end
		end)

		if out_entity then -- need to wait to receive result from deferred code
			Set(comp, state, out_entity, nil)
			comp:SetStateSleep(1)
			return true
		end
	end,
	args = {
		{ 'in', "Coordinate", "Target location, or at currently location if not specified", 'coord', true },
		{ 'in', "Rotation", "Building Rotation (0 to 3) (default 0)", 'posnum', true },
		{ 'out', "Target Reference", "Reference to the placed building", nil, true },
		{ 'exec', "Construction Failed", "Where to continue if construction fails" },
	},
	name = "Place Construction",
	desc = "Places a construction site for a specific structure",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	node_ui = build_produce_ui,
	var_args = build_produce_var_args,
	produce_type = "Building",
	explain = [[Begins construction of a specified building or structure at the target location. Logic can be diverted if creation of the construction fails.]],
}

data.instructions.produce_unit = {
	func = function(comp, state, cause, in_comp_index, in_unit, out_comp, if_failed, ...)
		local ent = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if ent then
			local frame_id, bp = build_produce_setup_bp(comp, state, false, ...)
			local frame_def = data.frames[frame_id]
			local production_recipe = frame_def and frame_def.production_recipe
			local producers = production_recipe and production_recipe.producers
			if producers then
				local prodcomp, prodcomp_id
				if in_comp_index then
					prodcomp, prodcomp_id = GetComponentFromIndex(comp, state, in_comp_index, nil, ent)
					if not producers[prodcomp_id] then prodcomp = nil end
				else
					for k,v in SortedPairs(producers) do
						prodcomp = ent:FindComponent(k)
						if prodcomp then prodcomp_id = k break end
					end
				end
				if prodcomp then
					-- Must force update if just switching to a different blueprint
					local force_update = prodcomp:GetRegisterId(1) == frame_id and Tool.Hash(bp) ~= Tool.Hash(prodcomp.has_extra_data and prodcomp.extra_data.custom_blueprint or nil)
					prodcomp:SetRegister(1, { id = frame_id, num = 1 }, force_update)
					if bp then
						prodcomp.extra_data.custom_blueprint = bp
					elseif prodcomp.has_extra_data then
						local ed = prodcomp.extra_data
						ed.custom_blueprint = nil
						if not next(ed) then comp.extra_data = nil end
					end

					if out_comp then Set(comp, state, out_comp, { id = prodcomp_id, num = prodcomp.interface_order }) end
					return
				end
			end
		end
		if out_comp then Set(comp, state, out_comp, nil) end
		state.counter = if_failed
	end,
	var_args = build_produce_var_args,
	args = {
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'in', "Unit", "The unit or building to operate on (if not self)", 'entity', true },
		{ 'out', "Component/Index", "Component and index the production was started on", nil, true },
		{ 'exec', "Production Failed" },
	},
	name = "Produce Unit",
	desc = "Sets a production component to produce a blueprint",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	node_ui = build_produce_ui,
	produce_type = "Unit",
	explain = [[Begins production of a specified item using available ingredients.]],
}

data.instructions.set_signpost =
{
	func = function(comp, state, cause, txt, ...)
		comp.owner.extra_data.signpost = (select("#", ...) > 0 and stringinput_convert(comp, state, txt, ...) or txt)
	end,
	make_asm = function(inst)
		return inst.txt or false
	end,
	var_args = stringinput_var_args,
	node_ui = stringinput_node_ui,
	name = "Set Signpost",
	desc = "Set the signpost to specific text",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Sets a visible marker or label at a location for guidance.

If the text contains one or more tags like <hl>{My Tag}</> additional values can be embedded.]],
}

data.instructions.activate =
{
	func = function(comp, state, cause, exec_failed)
		for _,activate_comp in ipairs(comp.owner.components) do
			local activate_comp_def = activate_comp.def
			local behavior_activate = activate_comp_def.behavior_activate
			if behavior_activate then
				if not behavior_activate(activate_comp_def, activate_comp, comp) then state.counter = exec_failed end
				return
			end
		end
		state.counter = exec_failed
	end,
	args = {
		{ 'exec', "Failed", "Failed" },
	},
	name = "Activate",
	desc = "Activate",
	category = "Components",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Runs the first component activation action available on the unit.

This is used by components that expose a behavior activation hook. If no component can activate, or the component reports failure, execution continues through <hl>Failed</>.]],
}

data.instructions.launch =
{
	func = function(comp, state, cause)
		for _,activate_comp in ipairs(comp.owner.components) do
			local activate_comp_def = activate_comp.def
			local behavior_activate = activate_comp_def.behavior_activate
			if behavior_activate == data.components.c_satellite_launcher.behavior_activate or behavior_activate == data.components.c_mothership_eject.behavior_activate then
				behavior_activate(activate_comp_def, activate_comp, comp)
				return
			end
		end
	end,
	name = "Launch",
	desc = "Launches a satellite if executed on an AMAC or a Drop Pod to the planet if executed on the Mothership",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Launches a unit, such as a drone or rocket, from its current position if equipped on an appropriate launcher.]],
}

data.instructions.abort_construction =
{
	func = function(comp, state, cause, target_entity)
		local entity = GetEntity(comp, state, target_entity)
		if entity and IsConstruction(entity) and entity.faction == comp.faction then
			Map.Defer(function()
				if entity.exists then entity:Destroy() end
			end)
		end
	end,
	args = {
		{ 'in', "Target", "Target Construction", 'entity' },
	},
	name = "Abort Construction",
	desc = "Abort an owned construction",
	category = "Production",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Aborts the construction of a structure or unit, dropping any delivered ingredients to the ground.

Note: Units that became construction sites using the Edit feature will be deconstructed and not cancelled.]],
}

data.instructions.lookat = {
	func = function(comp, state, cause, target_entity_coord)
		local target = Get(comp, state, target_entity_coord)
		target = target and (target.entity or target.coord)
		if target then comp.owner:LookAt(target) end
	end,
	args = {
		{ 'in', "Target", "Target unit or coordinate", 'coord' },
	},
	name = "Look At",
	desc = "Turns the unit to look at a unit or a coordinate",
	category = "Movement",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Rotates the unit to face a specific target or coordinate.]],
}

data.instructions.land =
{
	func = function(comp, state, cause)
		local sat = comp.owner:FindComponent("c_satellite")
		if sat then
			EntityAction.LandSatellite(comp.owner)
		end
	end,
	name = "Land",
	desc = "Tells a satellite that has been launched to land",
	category = "Units",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Lands a satellite to the unit that launched it. Should the original launching location no longer exist, will try to land at another vacant location if one exists.]],
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
data.instructions.debug_print =
{
	func = function(comp, state, cause, notify_value)
		comp.faction:RunUI(function()
			local reg = Get(comp, state, notify_value)
			print("[DEBUGPRINT]", reg)
		end)
	end,
	args = { { 'in', "Print Value", "Notification Value" } },
	name = "Debug Print",
	desc = "Debug print to log console",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Notify.png",
	explain = [[Outputs a debug message for developers during behavior execution.]],
}

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------- AUTO BASE ------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
local function AutoBaseResetLogistics(e, high_prio)
	e.disconnected, e.logistics_channel_1, e.logistics_supplier, e.logistics_requester, e.logistics_carrier, e.logistics_crane_only, e.logistics_flying_only, e.logistics_transport_route, e.logistics_high_priority =
		false, true, true, true, true, false, false, false, high_prio or false
end

local function AutoBaseSendMiner(owner, miner, id, node, amount)
	--print("[AUTO BASE] Send miner to get "..(amount or "infinite").." of "..id)
	if miner:GetRegisterId(1) == id and miner:GetRegisterNum(1) == (amount or REG_INFINITE) and miner.is_working then return end
	miner:SetRegister(1, { entity = node, amount = (amount or REG_INFINITE) })
	local freeslot = not miner.owner:HaveFreeSpace(id) and miner.owner:GetSlot(1)
	if freeslot and freeslot.unreserved_stack > 0 then
		-- miner has something in the inventory, just give it to the auto base owner
		owner.faction:OrderTransfer(miner.owner, owner, freeslot, true)
	end
end

local function AutoBaseOrderFromStored(ab, owner, target, id, amount)
	if (ab.carriers or 0) < 1 then return end -- no one to deliver
	if not target:GetFreeSlot(id, amount) then return end -- target has no space (avoid OrderTransfer order directly equipping component which would confuse AutoBaseEquip)
	local faction = owner.faction
	local function func(e)
		local slot = e.faction == faction and e:FindSlot(id, amount)
		if not slot then return end
		if faction:OrderTransfer(e, target, id, amount, true) then return true end
	end
	if (ab.stored[id] or 0) >= amount and Map.FindClosestEntity(owner, ab.range, func, FF_OPERATING) then
		return true -- found in stored
	elseif target ~= owner and func(owner) then
		return true -- found in owner
	end
end

local function AutoBaseEquip(ab, owner, e, comp_id, fulfill_func)
	local have = e:FindSlot(comp_id)
	AutoBaseResetLogistics(e)
	if have and have.unreserved_stack > 0 then
		local socket = e:GetFreeSocket(comp_id)
		if not socket then
			for i=1,e.socket_count do if e:CheckSocketSize(comp_id, i) and e:GetComponent(i).base_id ~= "c_behavior" then socket = i break end end
			if not socket then print("[AUTO BASE] Unable to equip "..comp_id.." on ", e) return end
		end
		Map.Defer(function() EntityAction.InvToComp(e, { slot = have, comp_index = socket }) end)
		return 1 -- equipped successfully
	elseif have and have.has_order and have.reserved_space > 0 then
		return 3 -- waiting for incoming order
	end

	local time = fulfill_func and fulfill_func(ab, owner, comp_id, 1)
	if time then return time end -- waiting for fulfillment

	return AutoBaseOrderFromStored(ab, owner, e, comp_id, 1) and 3 -- waiting for new incoming order
end

local function AutoBaseFulfill(ab, owner, id, amount, recursiveness, ignore_stored)
	--print("[AUTO BASE] Need "..amount.." of "..id.." (producers: "..(ab.producers[id] or 0)..", stored: "..(ab.stored[id] or 0)..", held: "..(owner:CountItem(id) or 0)..")")
	if (ab.producers[id] or 0) > 0 then return end -- it's being made somewhere
	local miss = amount - (not ignore_stored and ab.stored[id] or 0)
	if miss <= 0 then return end
	miss = miss - owner:CountItem(id)
	if miss <= 0 then return end

	local need_def = data.all[id]
	local need_recipe = need_def and need_def.production_recipe
	if not need_recipe and need_def and need_def.mining_recipe then return true end -- special case handled outside
	if not need_recipe or not need_recipe.producers or not need_recipe.ingredients then
		print("[AUTO BASE] Stuck while needing "..id.." but don't know its recipe")
		return
	end

	local mine_id, mine_amount
	for ing_id, ing_amount in SortedPairs(need_recipe.ingredients) do
		local time = AutoBaseFulfill(ab, owner, ing_id, miss * ing_amount, (recursiveness or 0) + 1)
		if time then
			if time ~= true then return time end
			mine_id, mine_amount = ing_id, miss * ing_amount
		end
	end

	local time, first_researched_prod_comp_id
	for comp_id,prod_time in SortedPairs(need_recipe.producers) do
		local prod = owner:FindComponent(comp_id)
		if prod then
			if prod:GetRegisterId(1) == id and prod:GetRegisterNum(1) == miss then
				--print("[AUTO BASE] Already making "..miss.." of "..id.." with producer "..comp_id)
				time = ((miss > 1 or not prod.is_working) and prod_time or 2)
				break
			end
			--print("[AUTO BASE] Making "..miss.." of "..id.." with producer "..comp_id)
			prod:SetRegister(1, { id = id, num = miss })
			time = prod_time -- started local work on something needed
			break
		end

		time = AutoBaseEquip(ab, owner, owner, comp_id)
		if time then break end -- waiting for incoming order/equipping

		first_researched_prod_comp_id = first_researched_prod_comp_id or (owner.faction:IsUnlocked(comp_id) and comp_id)
	end
	if first_researched_prod_comp_id and not time and (not recursiveness or recursiveness <= 20) then
		time = AutoBaseFulfill(ab, owner, first_researched_prod_comp_id, 1, (recursiveness or 0) + 1, true)
		if not time and not recursiveness then print("[AUTO BASE] Stuck while needing "..miss.." of "..id.." but don't have means to produce it") end
	end

	-- Need to send the miner last in this function so it happens only for the most urgently required material
	if mine_id and ((ab.miners[mine_id] or 0) == 0 or ab.carriers == 0) and (ab.temp_miner or ab.working_miner or ab.free_miner) then
		local mine_node = ab.nodes[mine_id]
		if mine_node then
			AutoBaseSendMiner(owner, ab.temp_miner or ab.working_miner or ab.free_miner, mine_id, mine_node, mine_amount)
			local mining_recipe = data.items[mine_id].mining_recipe
			local mining_time = mining_recipe and mining_recipe[(ab.temp_miner or ab.working_miner or ab.free_miner).id]
			if mining_time then time = (time or 0) + mining_time * mine_amount end
			ab.temp_miner, ab.working_miner, ab.free_miner = nil, nil, nil -- in use
		end
	end

	return time
end

data.instructions.gather_information =
{
	func = function(comp, state, cause, range)
		--print("[AUTO BASE] --------------------------------------------------------------------------------------------------")
		if comp.def.key ~= 'autobase' then return end -- running autobase behavior on regular behavior component
		local ab = state.autobase
		if not ab then ab = {} state.autobase = ab end
		ab.carriers = 0
		ab.free_socket_bot = nil
		ab.miners = ab.miners or {}
		ab.nodes = ab.nodes or {}
		ab.working_miner = nil
		ab.free_miner = nil
		ab.temp_miner = nil
		ab.turret_bots = 0
		ab.producers = ab.producers or {}
		ab.free_producers = ab.free_producers or {}
		ab.free_building = nil
		ab.stored = ab.stored or {}
		ab.construction_need = nil
		ab.construction_exists = false

		ab.registered = {}

		local range = GetNum(comp, state, range)
		if range <= 0 then range = 15 end
		ab.range = range

		-- reuse tables and arrays for performance
		for k in next, ab.producers do ab.producers[k] = 0 end
		for k in next, ab.miners do ab.miners[k] = 0 end
		for k in next, ab.nodes do ab.nodes[k] = nil end
		for k in next, ab.free_producers do ab.free_producers[k] = nil end
		for k in next, ab.stored do ab.stored[k] = 0 end

		local owner = comp.owner
		local faction, power_grid_index = owner.faction, owner.power_grid_index
		Map.FindClosestEntity(owner, range, function(e)
			if e.faction ~= faction then
				if IsResource(e) and faction:GetPowerGridIndexAt(e) == power_grid_index then
					local id = GetResourceHarvestItemId(e)
					if id and not ab.nodes[id]then ab.nodes[id] = e end
				end
			elseif e.power_grid_index ~= power_grid_index and (e.powered_down or faction:GetPowerGridIndexAt(e) ~= power_grid_index) then
				-- ignore powered down units and units outside of power grid
			elseif IsBot(e) then
				local miner = e:FindComponent("c_miner", true)
				local turret = not miner and e:FindComponent("c_turret", true)
				if miner then
					local miner_id, miner_num = miner:GetRegisterId(1), miner:GetRegisterNum(1)
					local miner_entity = not miner_id and miner:GetRegisterEntity(1)
					if miner_entity then miner_id = GetResourceHarvestItemId(miner_entity) end
					if miner_id and (e.is_moving or miner.is_working or e:CountItem(miner_id) > 0) then
						if miner_num <= 0 then -- only count infinite mining
							ab.miners[miner_id] = (ab.miners[miner_id] or 0) + 1
						else
							ab.temp_miner = ab.temp_miner or miner
						end
						ab.working_miner = ab.working_miner or miner
					else ab.free_miner = ab.free_miner or miner end
				elseif turret then
					ab.turret_bots = ab.turret_bots + 1
				elseif e.id == "f_carrier_bot" then
					ab.carriers = ab.carriers + 1
				else
					if (not ab.free_socket_bot or ab.free_socket_bot.key < e.key) and e:GetFreeSocket("c_miner") then ab.free_socket_bot = e end
				end
			elseif IsConstruction(e) then
				if e.powered_down then e.powered_down = false end
				ab.construction_need = ab.construction_need or e:GetRegister(FRAMEREG_SIGNAL)
				ab.construction_exists = true
			elseif e.slot_count > 0 and e.id ~= "f_building_sim" then
				local fab = e:FindComponent("c_fabricator", true)
				if fab then
					local fab_id = fab:GetRegisterId(1)
					if fab_id then
						ab.producers[fab_id] = (ab.producers[fab_id] or 0) + 1
					elseif not (e.has_extra_data and e.extra_data.autobase_register) then
						ab.free_producers[#ab.free_producers + 1] = fab
					end
				elseif not (e.has_extra_data and e.extra_data.autobase_register) then
					ab.free_building = ab.free_building or e
				end
				for _,slot in ipairs(e.slots) do
					local item_id = slot.id
					local item_available = item_id and slot.unreserved_stack
					if item_available and item_available > 0 then ab.stored[item_id] = (ab.stored[item_id] or 0) + item_available end
				end
			end
		end)

		for _,e in ipairs(comp.faction.entities) do
			-- check register
			local abreg = e.has_extra_data and e.extra_data.autobase_register
			if abreg then ab.registered[abreg] = (ab.registered[abreg] or 0) + 1 end
		end

		--local enemy
		-- loop signal registers
		for _,e in ipairs(comp.faction:GetEntitiesWithRegister(FRAMEREG_SIGNAL, true)) do
			local signal_entity = e:GetRegisterEntity(FRAMEREG_SIGNAL)
			if signal_entity then
				-- add signaled resources
				if IsResource(signal_entity) then
					if faction:GetPowerGridIndexAt(signal_entity) == power_grid_index then
						local id = GetResourceHarvestItemId(e)
						if id and not ab.nodes[id]then ab.nodes[id] = e end
					end
				--elseif not enemy and faction:IsEnemy(signal_entity) then
				--	enemy = signal_entity
				end
			end
		end
	end,

	args = {
		{ 'in', "Range", "Range of operation", 'posnum' },
	},
	name = "Gather Information",
	desc = "Collect information for running the auto base controller",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Scans the surrounding area or unit to gather intelligence.]],
}

data.instructions.get_registered =
{
	func = function(comp, state, cause, in_id, out_value)
		local ab = state.autobase
		if not ab then return end
		local id = GetId(comp, state, in_id)
		if id and ab.registered[id] then
			Set(comp, state, out_value, { id = id, num = ab.registered[id]})
			return
		end
		Set(comp, state, out_value)
	end,
	args = {
		{ 'in', "Id", "Id to get register of" },
		{ 'out', "Value", "Value of registered Unit" },
	},
	name = "Get Registered",
	desc = "Get number of registered buildings",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Retrieves the most recently registered value.]],
}

data.instructions.make_carrier =
{
	func = function(comp, state, cause, frame_num, on_work)
		local ab = state.autobase
		if not ab then return end

		local frame_num = Get(comp, state, frame_num)
		if ab.carriers >= frame_num.num then return end
		local sleep = AutoBaseFulfill(ab, comp.owner, frame_num.id, 1) or 3

		comp:SetStateSleep(sleep)
		state.counter = on_work
		return true
	end,
	args = {
		{ 'in', "Carriers", "Type and count of carriers to make", "frame_num" },
		{ 'exec', "If Working", "Where to continue if the unit started working" },
	},
	name = "Make Carriers",
	desc = "Construct carrier bots for delivering orders or to use for other tasks",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Creates carrier bots for transporting goods.]],
}

data.instructions.make_miner =
{
	func = function(comp, state, cause, resource_num, frameid, on_work)
		local ab = state.autobase
		if not ab then return end

		local item_id = GetId(comp, state, resource_num)
		if not item_id or (ab.miners[item_id] or 0) >= GetNum(comp, state, resource_num) then return end
		if not ab.nodes[item_id] then return end

		local sleep = 3
		if ab.free_miner or ab.temp_miner then
			if ab.temp_miner then
				ab.temp_miner:SetRegister(1, nil)
				ab.free_miner, ab.temp_miner = ab.free_miner or ab.temp_miner, nil
			end
			AutoBaseSendMiner(comp.owner, ab.free_miner, item_id, ab.nodes[item_id])
		else
			if not ab.free_socket_bot or not ab.free_socket_bot.exists then
				local frameid = GetId(comp, state, frameid)
				sleep = AutoBaseFulfill(ab, comp.owner, frameid, 1) or 3
			else
				sleep = AutoBaseEquip(ab, comp.owner, ab.free_socket_bot, "c_miner", AutoBaseFulfill) or 5
			end
		end

		comp:SetStateSleep(sleep)
		state.counter = on_work
		return true
	end,
	args = {
		{ 'in', "Resource/Count", "Resource type and number of miners to maintain", 'item_num' },
		{ 'in', "Frame", "Unit to create if none are free", 'frame' },
		{ 'exec', "If Working", "Where to continue if the unit started working" },
	},
	name = "Make Miners",
	desc = "Construct and equip miner components on available carrier bots",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Creates miner bots capable of extracting resources.]],
}

data.instructions.serve_construction =
{
	func = function(comp, state, cause, on_work)
		local ab = state.autobase
		if not ab then return end

		if not ab.construction_need then
			if ab.construction_exists then
				comp:SetStateSleep(1)
				state.counter = on_work
			else
				return
			end
		end
		local sleep = ab.construction_need.id and AutoBaseFulfill(ab, comp.owner, ab.construction_need.id, ab.construction_need.num) or 3
		comp:SetStateSleep(sleep)
		state.counter = on_work
		return true
	end,
	args = { { 'exec', "If Working", "Where to continue if the unit started working" }, },
	name = "Serve Construction",
	desc = "Produce materials needed in construction sites",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Assigns the unit to serve at a nearby construction site.]],
}

data.instructions.make_producer =
{
	func = function(comp, state, cause, item_num, prodcomp_id, frame_id, offset, on_work)
		local ab = state.autobase
		if not ab then return end

		local item_id = GetId(comp, state, item_num)
		if not item_id or (ab.producers[item_id] or 0) >= GetNum(comp, state, item_num) then return end

		local prodcomp_id = GetId(comp, state, prodcomp_id)
		for i,fab in ipairs(ab.free_producers) do
			if fab.id == prodcomp_id then
				local producer = table.remove(ab.free_producers, i)
				producer:SetRegister(1, { id = item_id, num = REG_INFINITE })
				ab.producers[item_id] = (ab.producers[item_id] or 0) + 1

				-- lock dedicated producers to 1 stack
				local ingredients = data.all[item_id].production_recipe.ingredients
				local count = 1
				for _,_ in pairs(ingredients) do
					count = count + 1
				end
				for i,slot in ipairs(producer.owner.slots) do
					if i > count then slot.locked = true end
				end

				comp:SetStateSleep(1)
				state.counter = on_work
				return true
			end
		end

		local owner, faction = comp.owner, comp.faction
		local building = ab.free_building and Map.FindClosestEntity(owner, ab.range, function(e)
			if e.faction ~= faction or not IsBuilding(e) or (e.has_extra_data and e.extra_data.autobase_register) then return end
			if e:GetFreeSocket(prodcomp_id) then return true end
			local prod = e:FindComponent(prodcomp_id)
			local prodreg = prod and prod:GetRegister(1)
			return prodreg and prodreg.is_empty
		end, FF_OPERATING)

		local sleep
		if building then
			sleep = AutoBaseEquip(ab, owner, building, prodcomp_id, AutoBaseFulfill) or 5
		else
			local loc = owner.location
			local offset = GetCoord(comp, state, offset)
			local frame_id = GetId(comp, state, frame_id)
			if not offset or not frame_id then return end
			Map.Defer(function()
				local place_x, place_y = comp.faction:GetPlaceableLocation(frame_id, loc.x + offset.x, loc.y + offset.y, true)
				CreateConstructionSite(comp.faction, frame_id, place_x, place_y).logistics_high_priority = true
			end)
			sleep = 5
		end

		comp:SetStateSleep(sleep)
		state.counter = on_work
		return true
	end,
	args = {
		{ 'in', "Item/Count", "Item type and number of producers to maintain", 'item_num' },
		{ 'in', "Component", "Production component", 'comp' },
		{ 'in', "Building", "Building type to use as producer", 'frame' },
		{ 'in', "Location", "Location offset from self", 'coord' },
		{ 'exec', "If Working", "Where to continue if the unit started working" },
	},
	name = "Make Producer",
	desc = "Build and maintain dedicated production buildings",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Converts the unit into a production facility for crafting items.]],
}

data.instructions.make_turret_bots =
{
	func = function(comp, state, cause, frame_num, on_work)
		local ab = state.autobase
		if not ab then return end

		if ab.turret_bots >= GetNum(comp, state, frame_num) then return end

		local sleep = 3
		if not ab.free_socket_bot or not ab.free_socket_bot.exists then
			local frameid = GetId(comp, state, frame_num)
			sleep = AutoBaseFulfill(ab, comp.owner, frameid, 1) or 3
		else
			sleep = AutoBaseEquip(ab, comp.owner, ab.free_socket_bot, "c_portable_turret", AutoBaseFulfill) or 5
		end
		comp:SetStateSleep(sleep)
		state.counter = on_work
		return true
	end,
	args = {
		{ 'in', "Number", "Number of turret bots to maintain" },
		{ 'exec', "If Working", "Where to continue if the unit started working" },
	},
	name = "Make Turret Bots",
	desc = "Construct and equip turret components on available carrier bots",
	category = "AutoBase",
	icon = "icon_input",
	key = 'autobase',
	explain = [[Creates turret bots for defense or attack purposes.]],
}

data.instructions.set_reg_remotely =
{
	func = function(comp, state, cause, in_unit, in_val, to, comp_index, exec_fail)
		local ent, to_obj, to_num = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if ent then
			local to_comp, to_id = GetComponentFromIndex(comp, state, comp_index, to, ent)
			to_num = math.max(GetNum(comp, state, to), 1)
			if to_comp then
				local register_defs = to_comp.def.registers
				local register_def = register_defs and register_defs[to_num]
				to_obj = (to_num <= to_comp.register_count) and (not register_def or not register_def.read_only) and to_comp
			else
				to_obj, to_num = (not to_id and to_num <= 4 and ent), (5 - to_num)
			end
		end
		if to_obj then
			to_obj:SetRegister(to_num, Get(comp, state, in_val))
		elseif exec_fail then
			state.counter = exec_fail
		end
	end,
	args = {
		{ 'in', "Unit", "The unit to set component register on (if not self)", 'entity' },
		{ 'in', "Value", "Value to set remotely", 'any' },
		{ 'in', "To", "Component and register number to set", 'comp_num' },
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'exec',"Failed", "Failed to set register", nil, true },
	},
	name = "Set to Component Remotely",
	desc = "Writes a value into a component register on an external unit",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Set Component Reg.png",
	explain = [[Remotely set an external unit's component register to a value. Diverts logic if instruction fails.

The source and target units <bl>must be adjacent</> unless running on an <img id="c_autobase" style="hl"/>.]],
}

data.instructions.get_reg_remotely = {
	func = function(comp, state, cause, in_unit, from, out_val, comp_index, exec_fail)
		local ent, res = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if ent then
			local from_comp, from_id = GetComponentFromIndex(comp, state, comp_index, from, ent)
			local from_num = math.max(GetNum(comp, state, from), 1)
			if from_comp then
				res = from_comp:GetRegister(from_num)
			elseif not from_id then
				res = from_num <= 4 and ent:GetRegister(5-from_num) or nil
			end
		end
		if exec_fail and not res then state.counter = exec_fail end
		Set(comp, state, out_val, res)
	end,
	args = {
		{ 'in', "Unit", "The unit to get component register from (if not self)", 'entity' },
		{ 'in', "From", "Component and register number to get remotely", 'comp_num' },
		{ 'out', "Value", "Value of Register"},
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'exec',"Failed", "Failed to get register", nil, true },
	},
	name = "Get from Component Remotely",
	desc = "Reads a value from a component register on an external unit",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Set Component Reg.png",
	explain = [[Remotely read an external unit's component register value. Diverts logic if instruction fails.

The source and target units <bl>must be adjacent</> unless running on an <img id="c_autobase" style="hl"/>.]],
	--key = 'autobase',
}

data.instructions.load_behavior =
{
	func = function(comp, state, cause, sub, in_unit, comp_index, out_failed, ...)
		if not sub then return end
		local ent = GetAdjacentFactionEntityOrSelf(comp, state, in_unit)
		if not ent then state.counter = out_failed return end

		comp_index = comp_index and Get(comp, state, comp_index)
		local only_comp_id, index = comp_index and comp_index.id, (comp_index and comp_index.num or 0)
		local behavior_comp = ent:FindComponent(only_comp_id or "c_behavior", not only_comp_id, (index == 0 and 1 or index), true)
		if not behavior_comp then
			local frame_def = ent.def
			local can_have_integrated_behavior = not frame_def.type and frame_def.race == "robot" and not frame_def.no_integrated_behavior
			if not can_have_integrated_behavior then state.counter = out_failed return end
			local have_integrated_behavior = can_have_integrated_behavior and ent:CountComponents("c_integrated_behavior") > 0
			if have_integrated_behavior then state.counter = out_failed return end
			behavior_comp = ent:AddComponent("c_integrated_behavior")
			if not behavior_comp then state.counter = out_failed return end
		end

		if behavior_comp ~= comp then
			SetBehavior(behavior_comp, sub)

			-- Variable arguments can have a different count if the behavior was since edited, always set all registers to avoid theoretical state discrepancy
			for i=1,behavior_comp.register_count do
				local in_reg = select(i, ...)
				behavior_comp:SetRegister(i, in_reg and Get(comp, state, in_reg) or nil)
			end
		else
			-- Special handling if overwriting the behavior of the active controller (need to read the arguments first then set the behavior deferred)
			local args = select("#", ...) > 0 and {}
			for i=1,select("#", ...) do
				local in_reg = select(i, ...)
				args[i] = in_reg and Get(comp, state, in_reg) or nil
			end
			Map.Defer(function()
				if not behavior_comp.exists then return end
				SetBehavior(behavior_comp, sub)
				for i=1,behavior_comp.register_count do
					behavior_comp:SetRegister(i, args[i])
				end
			end)
			return true
		end
	end,
	args = {
		{ 'in', "Unit", "The unit to load the behavior on (if not self)", 'entity' },
		{ 'in', "Component/Index", "Component (and index if multiple are equipped)", 'comp_num', true },
		{ 'exec', "Failed", "Failed" },
	},
	name = "Load Behavior",
	node_ui = call_ui,
	make_asm = function(inst)
		return inst.sub or false
	end,
	var_args = call_var_args,
	desc = "Load and run a behavior on an external unit",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Set Component Reg.png",
	explain = [[Remotely run a behavior on another unit. Will automatically install an <img id="c_integrated_behavior" style="hl"/> if needed.

The source and target units <bl>must be adjacent</> unless running on an <img id="c_autobase" style="hl"/>.]],
}

data.instructions.build_registered =
{
	func = function(comp, state, cause, in_location, in_rotation, in_register, on_work, on_failed, ...)
		local ab = state.autobase
		if not ab then return end

		-- should we build this
		local id = GetId(comp, state, in_register)
		local num = GetNum(comp, state, in_register)
		if not id then state.counter = on_failed return end
		local regged = ab.registered[id]
		if regged and regged >= num then
			return
		end

		local frame_id, bp, faction = build_produce_setup_bp(comp, state, false, ...)
		if not frame_id then state.counter = on_failed return end

		local location, rotation = GetCoord(comp, state, in_location), GetNum(comp, state, in_rotation)
		local loc = comp.owner.location
		local x, y = location.x, location.y
		local place_x, place_y = comp.faction:GetPlaceableLocation(frame_id, loc.x + x, loc.y + y, true)

		--if not faction:CanPlace(frame_id, x, y, rotation, true) then state.counter = on_failed return end

		if not bp then bp = { frame = frame_id } end
		bp.spawn_extra_data = { autobase_register = id }

		Map.Defer(function()
			local e = CreateConstructionSite(faction, frame_id, place_x, place_y, rotation)
			e.extra_data.custom_blueprint = bp
		end)

		comp:SetStateSleep(1)
		state.counter = on_work
		return true
	end,
	args = {
		{ 'in', "Coordinate", "Target location, or at currently location if not specified", 'coord', true },
		{ 'in', "Rotation", "Building Rotation (0 to 3) (default 0)", 'posnum', true },
		{ 'in', "Id", "Id to register with" },
		{ 'exec', "If Working", "Where to continue if the unit started working" },
		{ 'exec', "Construction Failed", "Where to continue if construction fails" },
	},
	name = "Build Registered",
	desc = "Places a building to be registered",
	category = "AutoBase",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	node_ui = build_produce_ui,
	var_args = build_produce_var_args,
	produce_type = "Building",
	key = 'autobase',
	explain = [[Constructs a structure or unit defined in a register at a given location or the current location if not specified.]],
}

data.instructions.produce_registered =
{
	func = function(comp, state, cause, in_register, on_work, ...)
		local ab = state.autobase
		if not ab then return end

		-- should we build this
		local id = GetId(comp, state, in_register)
		local num = GetNum(comp, state, in_register)
		--if not id then state.counter = on_failed return end
		local regged = ab.registered[id]
		if regged and regged >= num then
			return
		end

		local frame_id, bp = build_produce_setup_bp(comp, state, false, ...)
		if not frame_id then return end

		local frame_def = data.frames[frame_id]
		local production_recipe = frame_def and frame_def.production_recipe
		if not production_recipe or not production_recipe.producers then return end

		if not bp then bp = { frame = frame_id } end
		bp.spawn_extra_data = { autobase_register = id }

		local owner = comp.owner
		for k,v in SortedPairs(production_recipe.producers) do
			local prodcomp = owner:FindComponent(k)
			if prodcomp and not prodcomp.is_working and prodcomp:GetRegisterId() == nil then
				prodcomp:SetRegister(1, { id = frame_id, num = 1 })
				prodcomp.extra_data.custom_blueprint = bp
				comp:SetStateSleep(1)
				state.counter = on_work
				return true
			end
		end
		comp:SetStateSleep(1)
		state.counter = on_work
		return true
	end,
	args = {
		{ 'in', "Id", "Id to register with" },
		{ 'exec', "If Working", "Where to continue if the unit started working" },
	},

	name = "Produce Registered Unit",
	desc = "Sets a production component to produce a blueprint",
	category = "AutoBase",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	node_ui = build_produce_ui,
	var_args = build_produce_var_args,
	produce_type = "Unit",
	key = 'autobase',
	explain = [[AutoBase-only instruction that starts production of a unit blueprint and registers it under the requested id.

If the AutoBase already has enough registered units for the requested id and amount, it does nothing. If an idle matching production component is available, it assigns the blueprint and continues through <hl>If Working</> while waiting for production to progress.

<hl>Node Settings</>
The production selector controls which unit blueprint is produced and adds any ingredient/blueprint pins needed by that selection.]],
}

Comp:RegisterComponent("c_event_reg", {
	activation = "OnFirstRegisterChange",
	registers = { {} },
	transient = true,
	on_remove = function(self, comp)
		RadioDisconnect(comp, false)
	end,
	on_update = function(self, comp)
		InstTriggerEvent(comp)
	end
})

data.instructions.event_radio =
{
	func = function(comp, state, cause, out_signal)
		-- Shouldn't be called directly, but can if it is the very first instruction
		state.counter = false -- forces restart and calling of c_behavior_on_end
	end,
	node_ui = function(canvas, inst, program_ui)
		local band = inst.band
		canvas:Add('<Text y=34 text="Band" style=bl halign=center/>')
		canvas:Add('<Reg y=60 halign=center/>', {
			def_id = band and band.id, entity = band and band.entity, coord = band and band.coord, num = band and band.num,
			on_click = function(reg)
				local function register_on_set(rsel, val)
					reg.def_id, reg.entity, reg.coord, reg.num = val.id, val.entity, val.coord, val.num
					if not val or not next(val) then val = nil elseif val.num == 0 and (val.id or val.entity or val.coord) then val.num = nil end
					if Tool.Hash(val) ~= Tool.Hash(inst.band) then inst.band = val program_ui:set_dirty(true) end
				end
				local rsel = ShowRegisterSelection(reg, register_on_set, nil, nil, { hide_entity_panel = true })
				if rsel then rsel:SetRegister({ id = reg.def_id, entity = reg.entity, coord = reg.coord, num = reg.num }) end
			end,
		})
		return 76
	end,
	event_setup = function(comp, source_node)
		if not source_node.band then return end
		local ev_comp = comp.owner:AddComponent("c_event_reg")
		RadioConnect(ev_comp, false, Tool.NewRegisterObject(source_node.band))
		return ev_comp
	end,
	event_trigger = function(comp, state, ev_comp, out_signal)
		if out_signal then Set(comp, state, out_signal, ev_comp:GetRegister(1)) end
	end,
	args = {
		{ 'out', "Signal", "Signal value" }
	},
	name = "Radio Event",
	desc = "Run event when the signal of the specified radio band changes its value",
	category = "Communication",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Starts this branch when the selected radio band receives a new value.

The band is selected in the node body, not through an input pin. When the event fires, <hl>Signal</> receives the new radio value.

Use this for event-driven behaviors that should sleep until a radio signal changes instead of polling with <hl>Read Radio</>.

<hl>Node Settings</>
The band chooses the radio channel to watch. If no band is selected, no event watcher is installed.]],
}

data.instructions.event_parameter =
{
	func = function(comp, state, cause, out_signal)
		-- Shouldn't be called directly, but can if it is the very first instruction
		state.counter = false -- forces restart and calling of c_behavior_on_end
	end,
	node_ui = function(canvas, inst, program_ui)
		canvas:Add('<Text y=34 text="Parameter" style=bl halign=center/>')
		local txt = canvas:Add('<Text y=60 text="None" halign=center/>')
		local btn = canvas:Add('<Button text="Select" halign=fill y=78 margin=10/>')
		btn.on_click = function(btn)
			local parameters, pnames = program_ui.code.parameters, program_ui.code.pnames
			local box = UI.MenuPopup("<Box padding=5><VerticalList/></Box>", btn, 'DOWN')
			if not box then return end
			for i=1,(parameters and #parameters or 0) do
				box[1]:Add("Button", { text = NOLOC(pnames and pnames[i] or string.format("P%d", i)), on_click = function(b) txt.text = b.text inst.pnum = i program_ui:set_dirty(true) UI.CloseMenuPopup(b) end })
			end
			box[1]:Add("Button", { text = L("- %s -", "None"), on_click = function(b) txt.text = "None" inst.pnum = nil program_ui:set_dirty(true) UI.CloseMenuPopup(b) end })
		end
		local pnum, pnames = inst.pnum, program_ui.code.pnames
		if pnum then txt.text = NOLOC(pnames and pnames[pnum] or string.format("P%d", pnum)) end
		return 82
	end,
	event_setup = function(comp, source_node)
		if not source_node.pnum then return end
		local ev_comp = comp.owner:AddComponent("c_event_reg")
		ev_comp:LinkRegisterFromRegister(1, source_node.pnum, comp)
		return ev_comp
	end,
	args = {},
	name = "Parameter Event",
	desc = "Run event when the value of the specified parameter changes",
	category = "Flow",
	icon = "Main/skin/Icons/Special/Commands/Make Order.png",
	explain = [[Starts this branch when the selected behavior parameter changes value.

The watched parameter is selected in the node body. This is useful for behaviors that should react immediately when a controller register is edited or linked from another register.

<hl>Node Settings</>
Parameter chooses which behavior parameter to watch. If no parameter is selected, no event watcher is installed.]],
}

local function MemoryNodeUI(canvas, inst, program_ui, op, show_extra)
	return NodeUICombo(canvas, inst, program_ui, { "Local Arrays", "Faction Arrays" }, nil, nil, show_extra or false)
end

data.instructions.memory_get = {
	func = function(comp, state, cause, c, in_index, out_value)
		in_index = Get(comp, state, in_index)
		local key = in_index.id or (in_index.raw_entity and in_index.raw_entity.key) or (in_index.coord and (in_index.coord.x .. ":" .. in_index.coord.y))
		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		local array = arrays and arrays[key]
		local val
		if array then
			-- get last value if no number is specified (0)
			local num = in_index.num
			val = array[num > 0 and num or #array]
		end
		Set(comp, state, out_value, val)
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = MemoryNodeUI,
	args = {
		{ 'in', "Id/Index", "Array identifier and index" },
		{ 'out', "Value" },
	},
	name = "Memory Get",
	desc = "Get memory array element",
	category = "Memory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Retrieves a value from a named memory location. If no number index is specified it will get the value of the last element in the array.]],
}

data.instructions.memory_set = {
	func = function(comp, state, cause, c, in_index, in_value, out_oldvalue)
		in_index = Get(comp, state, in_index)
		local key = in_index.id or (in_index.raw_entity and in_index.raw_entity.key) or (in_index.coord and (in_index.coord.x .. ":" .. in_index.coord.y))
		if not key then
			if out_oldvalue then Set(comp, state, out_oldvalue, nil) end
			return
		end

		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		if not arrays then
			arrays = {}
			if c == 1 then state.arrays = arrays else comp.faction.extra_data.arrays = arrays end
		end

		local array = arrays[key]
		if not array then
			array = {}
			arrays[key] = array
		end

		local num = in_index.num
		local index = num > 0 and num or #array + 1
		if out_oldvalue then Set(comp, state, out_oldvalue, array[index]) end
		array[index] = Tool.NewRegisterObject(Get(comp, state, in_value))
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = MemoryNodeUI,
	args = {
		{ 'in', "Id/Index", "Array identifier and index" },
		{ 'in', "Value" },
		{ 'out', "Old", "Previous value" }
	},
	name = "Memory Set",
	desc = "Set memory array value at a given index",
	category = "Memory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Set memory array value at a given index. No index will add a new element to the end of the array (push).]],
}

data.instructions.memory_length = {
	func = function(comp, state, cause, c, in_index, out_value)
		in_index = Get(comp, state, in_index)
		local key = in_index.id or (in_index.raw_entity and in_index.raw_entity.key) or (in_index.coord and (in_index.coord.x .. ":" .. in_index.coord.y))
		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		if key then
			local array = arrays and arrays[key]
			Set(comp, state, out_value, Tool.NewRegisterObject(in_index, (array and #array or 0)))
		elseif arrays then
			local arraycount = 0
			for k in next, arrays do arraycount = arraycount + 1 end
			Set(comp, state, out_value, arraycount)
		else
			Set(comp, state, out_value, 0)
		end
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = MemoryNodeUI,
	args = {
		{ 'in', "Id", "Array identifier or empty to process known identifiers" },
		{ 'out', "Length" },
	},
	name = "Memory Length",
	desc = "Get length of memory array",
	category = "Memory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Retrieves the length of a memory array.

Will return the length of the memory array specified by the array identifier <hl>Id</> or the total number of arrays in memory if no <hl>Id</> is specified.]],
}

data.instructions.memory_insert = {
	func = function(comp, state, cause, c, in_index, in_value)
		in_index = Get(comp, state, in_index)
		local key = in_index.id or (in_index.raw_entity and in_index.raw_entity.key) or (in_index.coord and (in_index.coord.x .. ":" .. in_index.coord.y))
		if not key then return end

		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		if not arrays then
			arrays = {}
			if c == 1 then state.arrays = arrays else comp.faction.extra_data.arrays = arrays end
		end

		local array = arrays[key]
		if not array then
			array = {}
			arrays[key] = array
		end

		local newval = Tool.NewRegisterObject(Get(comp, state, in_value))
		local index = in_index.num
		local len = #array
		if index <= 0 or index > len then -- insert element at end
			array[len+1] = newval
		else -- insert element in middle (shift upwards)
			table.insert(array, index, newval)
		end
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = MemoryNodeUI,
	args = {
		{ 'in', "Id/Index", "Array identifier and index" },
		{ 'in', "Value", "Value" },
	},
	name = "Memory Insert",
	desc = "Insert value into memory array",
	category = "Memory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Insert value into memory array, shifting elements above upwards. No index will add a new element to the end of the array (push).]],
}

data.instructions.memory_remove = {
	func = function(comp, state, cause, c, in_index, out_oldvalue)
		in_index = Get(comp, state, in_index)
		local key = in_index.id or (in_index.raw_entity and in_index.raw_entity.key) or (in_index.coord and (in_index.coord.x .. ":" .. in_index.coord.y))
		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		local array, oldval = arrays and arrays[key]
		if array then
			local index = in_index.num
			if index == REG_INFINITE then -- clear the array
				arrays[key] = nil
			else
				local len = #array
				if index <= 0 then -- remove last element
					oldval = array[len]
					array[len] = nil
				elseif index < len then -- remove element, shift downwards
					oldval = table.remove(array, index)
				else -- remove last element or element in unsequenced part of the array
					oldval = array[index]
					array[index] = nil
				end

				-- clear if empty
				if not next(array) then arrays[key] = nil end
			end
		end
		if out_oldvalue then Set(comp, state, out_oldvalue, oldval) end
	end,
	make_asm = MakeASMInstCOrOne,
	node_ui = MemoryNodeUI,
	args = {
		{ 'in', "Id/Index", "Array identifier and index" },
		{ 'out', "Old Value", "Removed value" },
	},
	name = "Memory Remove",
	desc = "Remove value from memory array",
	category = "Memory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Remove value from a memory array, shifting elements above downwards.
No index will remove from the end of the array (pop).
Specifying ∞ will clear the array.]],
}

local function MemoryParseKey(key, num)
	if type(key) == "string" then
		local x,y = string.match(key, "^([0-9-]+):([0-9-]+)$")
		if x then
			return Tool.NewRegisterObject({ x//1, y//1 }, num)
		else
			return Tool.NewRegisterObject(key, num)
		end
	else
		return Tool.NewRegisterObject(Map.GetEntityFromKey(key), num)
	end
end

data.instructions.memory_sift = {
	func = function(comp, state, cause, cu, in_index, in_val, out_count)
		local keyreg, c, u = Get(comp, state, in_index), (cu & 15), (cu >> 4)
		local key = keyreg.id or (keyreg.raw_entity and keyreg.raw_entity.key) or (keyreg.coord and (keyreg.coord.x .. ":" .. keyreg.coord.y))
		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		local list = arrays and ((key and arrays[key]) or (not key and arrays)) or {}
		local valreg, len, removecount, k, v = Get(comp, state, in_val), #list, 0

		local filter_id, filter_owner, filters, prepared_filter = u < 12 and valreg.id
		if filter_id then
			filter_owner, filters = comp.owner, { filter_id, valreg.num }
			prepared_filter = PrepareFilterEntity(filters)
		end

		while true do
			k, v = next(list, k)
			if not k then break end
			if not key then v = MemoryParseKey(k) end
			local filter_entity = filter_id and v.entity
			if v:Compare(u, valreg, prepared_filter, filter_owner) and (not filter_entity or FilterEntity(filter_owner, filter_entity, filters)) then
				if key and k <= len then
					table.remove(list, k)
					k, len = (k > 1 and k - 1 or nil), len - 1
				else
					list[k] = nil
				end
				removecount = removecount + 1
			end
		end
		if out_count then Set(comp, state, out_count, removecount) end
	end,
	make_asm = function(inst) return (inst.c or 1) | (math.abs(inst.u or 1) << 4) end,
	args = {
		{ 'in', "Id", "Array identifier or empty to process known identifiers" },
		{ 'in', "Filter", "Filter value" },
		{ 'out', "Remove Count", nil, nil, true },
	},
	node_ui = function(canvas, inst, program_ui, op, show_extra)
		local add_height, has_extra, can_hide = MemoryNodeUI(canvas, inst, program_ui, op, show_extra)
		if add_height > 0 then canvas, add_height = canvas:Add("<Canvas y=44 halign=fill/>"), 44 end
		add_height = add_height + NodeUIComparison(canvas, inst, program_ui, nil, 'u')
		return add_height, has_extra, can_hide
	end,
	name = "Memory Sift",
	desc = "Remove multiple items of a memory array with a filter",
	category = "Memory",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Remove multiple items of a memory array depending on the filter comparison mode and value.

If an identifier <hl>Id</> is specified, values of the array with that identifier will be filtered.
Otherwise the instruction will remove full arrays depending on their identifier keys.]],
}

data.instructions.memory_loop = {
	func = function(comp, state, cause, c, in_index, out_value, exec_done, out_index)
		in_index = Get(comp, state, in_index)
		local key = in_index.id or (in_index.raw_entity and in_index.raw_entity.key) or (in_index.coord and (in_index.coord.x .. ":" .. in_index.coord.y))
		local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
		local it
		if not arrays then
			it = {}
		elseif not key then -- loop all keys
			it = {}
			local entities
			for k in next, arrays do
				if type(k) == "string" then
					it[#it+1] = k
				else
					if not entities then entities = {} end
					entities[#entities+1] = k
				end
			end
			table.sort(it)
			if entities then
				table.sort(entities)
				for i,v in ipairs(entities) do
					it[#it+1] = v
				end
			end
			if out_index and #it > 0 then Set(comp, state, out_index, nil) end
		elseif arrays[key] then
			it = { key = key, num = 1 }
		else
			it = {}
		end
		return BeginBlock(comp, state, it)
	end,

	next = function(comp, state, it, c, in_index, out_value, exec_done, out_index)
		local key, num, val = it.key, it.num or 1
		if key then -- iterating array
			local arrays = (c == 1 and state.arrays) or (c == 2 and comp.faction.extra_data.arrays)
			local array = arrays and arrays[key]
			val = array and array[num]
			if val == nil then return true end
			if out_index then Set(comp, state, out_index, MemoryParseKey(key, num)) end
		else -- iterating keys
			val = it[num]
			if val == nil then return true end
			val = MemoryParseKey(val)
		end
		Set(comp, state, out_value, val)
		it.num = num + 1
	end,

	last = function(comp, state, it, c, in_index, out_value, exec_done, out_index)
		if (it.num or 1) == 1 then -- clear if having not looped once
			if out_index then Set(comp, state, out_index, nil) end
			if out_value then Set(comp, state, out_value, nil) end
		end
		state.counter = exec_done
	end,

	make_asm = MakeASMInstCOrOne,
	node_ui = MemoryNodeUI,
	args = {
		{ 'in', "Id", "Array identifier or empty to process known identifiers" },
		{ 'out', "Value" },
		{ 'exec', "Done", "Finished loop" },
		{ 'out', "Index", nil, nil, true },
	},
	name = "Loop Memory",
	desc = "Loops through memory array or known array identifiers",
	category = "Loops",
	sample = "5V3YxVw83JETKb3V8u6o0iV6Ya3Jm0vf25wHsQ1DnjVG1EhaLv1NUYvM1MDB7y1AtPzc1Mr8XB36hwCE2jUAWn1Pi73B2dYEbz3zcrTB0oLJd328jlrA3ka87s3r89zO3Ixrjo3pwI720c9HSy0VNcd40bClk31dWIL81s8Y3S00Jq0Y0yAVfc3mu",
	icon = "Main/skin/Icons/Special/Commands/Count Item.png",
	explain = [[Loops through all entries stored in a memory list.

If an identifier <hl>Id</> is specified, all sequential values of the array with that identifier will be evaluated, starting from 1.
Otherwise the instruction will enumerate over all identifier keys in the memory.]],
}

-- conversion functions for old instructions
data.instructions.modulo = {
	func = function(comp, state, cause, left, right, out_remainder) return data.instructions.div.func(comp, state, cause, 1, left, right, nil, out_remainder) end,
	convert = function(inst) inst.op, inst[3], inst[4] = 'div', nil, inst[3] end,
	args = { {'in'}, {'in'}, {'out'} },
}
data.instructions.for_signal = {
	func = function(comp, state, cause, in_signal, out_unit, exec_done)
		local it = { 2 }
		for i,e in ipairs(comp.faction:GetEntitiesWithRegister(FRAMEREG_SIGNAL, 11, Get(comp, state, in_signal))) do it[i+1] = e end
		return BeginBlock(comp, state, it)
	end,
	next = function(comp, state, it, in_signal, out_unit, exec_done)
		local i = it[1]
		if i > #it then return true end
		Set(comp, state, out_unit, it[i])
		it[1] = i + 1
	end,
	last = function(comp, state, it, in_signal, out_unit, exec_done)
		Set(comp, state, out_unit, nil)
		state.counter = exec_done
	end,
	convert = function(inst) inst.op, inst.c, inst[3], inst[4] = 'for_signal_match', 11, nil, inst[3] end,
	args = { {'in'}, {'out'}, {'exec'} },
}
data.instructions.domove_async = {
	func = function(comp, state, cause, target) return data.instructions.domove.func(comp, state, cause, 2, target) end,
	convert = function(inst) inst.op, inst.c, inst[2] = 'domove', 2, false end,
	args = { {'in'} },
}
data.instructions.domove_range = {
	func = function(comp, state, cause, target) return data.instructions.domove.func(comp, state, cause, 1, target) end,
	convert = function(inst) inst.op, inst[2] = 'domove', false end,
	args = { {'in'}, },
}
data.instructions.set_number = {
	func = function(comp, state, cause, in_data, in_num, out_result) return data.instructions.combine_register.func(comp, state, cause, in_num, in_data, out_result) end,
	convert = function(inst) inst.op, inst[1], inst[2] = 'combine_register', inst[2], inst[1] end,
	args = { {'in'}, {'in'}, {'out'} },
}
data.instructions.set_data = {
	func = data.instructions.combine_register.func,
	convert = function(inst) inst.op = 'combine_register' end,
	args = data.instructions.combine_register.args,
}
data.instructions.combine_coordinate = {
	func = function(comp, state, cause, in_x, in_y, out_result) return data.instructions.combine_register.func(comp, state, cause, nil, nil, out_result, in_x, in_y) end,
	convert = function(inst) inst.op, inst[1], inst[2], inst[4], inst[5] = 'combine_register', nil, nil, inst[1], inst[2] end,
	args = { {'in'}, {'in'}, {'out'} },
}
data.instructions.separate_coordinate = {
	func = function(comp, state, cause, in_coord, out_x, out_y) return data.instructions.separate_register.func(comp, state, cause, in_coord, nil, nil, nil, out_x, out_y) end,
	convert = function(inst) inst.op, inst[2], inst[3], inst[5], inst[6] = 'separate_register', nil, nil, inst[2], inst[3] end,
	args = { {'in'}, {'out'}, {'out'} },
}
data.instructions.is_unit_a = {
	func = function(comp, state, cause, in_entity, in_type, is_not) return data.instructions.compare_type.func(comp, state, cause, is_not, in_entity, in_type) end,
	convert = function(inst) inst.op, inst[1], inst[2], inst[3] = 'compare_type', inst[3], inst[1], inst[2] end,
	exec_arg = data.instructions.compare_type.exec_arg,
	args = { {'in'}, {'in'}, {'exec'} },
}
data.instructions.is_a = {
	func = data.instructions.compare_type.func,
	convert = function(inst) inst.op = 'compare_type' end,
	exec_arg = data.instructions.compare_type.exec_arg,
	args = data.instructions.compare_type.args,
}
data.instructions.compare_item = {
	func = data.instructions.compare_type.func,
	convert = function(inst) inst.op = 'compare_type' end,
	exec_arg = data.instructions.compare_type.exec_arg,
	args = data.instructions.compare_type.args,
}
data.instructions.compare_entity = {
	func = function(comp, state, cause, if_differ, val1, val2) return data.instructions.compare_data.func(comp, state, cause, if_differ, val1, val2) end,
	convert = function(inst) inst.op, inst[4] = 'compare_data', inst[1] end,
	exec_arg = data.instructions.compare_data.exec_arg,
	args = data.instructions.compare_data.args,
}
data.instructions.get_unit_type = {
	func = data.instructions.get_type.func,
	convert = function(inst) inst.op = 'get_type' end,
	args = data.instructions.get_type.args,
}
data.instructions.unit_type = {
	func = function(comp, state, cause, in_unit, if_building, if_bot, if_construction) return data.instructions.entity_type.func(comp, state, cause, in_unit, if_building, if_bot, if_construction, false, false, false, false, false, false) end,
	convert = function(inst) inst.op, inst[5], inst[6], inst[7], inst[8], inst[9], inst[10] = 'entity_type', false, false, false, false, false, false end,
	args = data.instructions.entity_type.args,
}
data.instructions.value_type = {
	func = function(comp, state, cause, item, exec_item, exec_entity, exec_component, exec_tech, exec_value, exec_coord)
		data.instructions.data_type.func(comp, state, cause, item, exec_item, exec_component, exec_entity, exec_value, exec_tech, exec_coord, exec_entity)
	end,
	convert = function(inst) inst.op, inst[3], inst[4], inst[5], inst[6], inst[8] = 'data_type', inst[4], inst[3], inst[6], inst[5], inst[3] end,
	args = data.instructions.data_type.args,
}
data.instructions.equip_component_remotely = {
	func = function(comp, state, cause, in_unit, out_failed, equip_comp, equip_index) return data.instructions.equip_component.func(comp, state, cause, out_failed, equip_comp, equip_index, nil, in_unit) end,
	convert = function(inst) inst.op, inst[1], inst[2], inst[3], inst[4], inst[5] = 'equip_component', inst[2], inst[3], inst[4], nil, inst[1] end,
	args = { {'in'}, {'exec'}, {'in'}, {'in'} },
}
data.instructions.unequip_component_remotely = {
	func = function(comp, state, cause, in_unit, out_failed, unequip_comp, unequip_index) return data.instructions.unequip_component.func(comp, state, cause, out_failed, unequip_comp, unequip_index, nil, in_unit) end,
	convert = function(inst) inst.op, inst[1], inst[2], inst[3], inst[4], inst[5] = 'unequip_component', inst[2], inst[3], inst[4], nil, inst[1] end,
	args = { {'in'}, {'exec'}, {'in'}, {'in'} },
}
data.instructions.produce = {
	func = function(comp, state, cause, ...) return data.instructions.produce_unit.func(comp, state, cause, false, false, false, state.counter, ...) end,
	convert = function(inst) ConvertShiftVarArgs(inst, 1, 4) inst.op, inst[4] = 'produce_unit', inst.next end,
	var_args = build_produce_var_args,
}
data.instructions.build = {
	func = function(comp, state, cause, in_location, in_rotation, on_failed, ...) return data.instructions.construct.func(comp, state, cause, in_location, in_rotation, false, on_failed, ...) end,
	convert = function(inst) ConvertShiftVarArgs(inst, 4, 1) inst.op, inst[3], inst[4] = 'construct', nil, inst[3] end,
	var_args = build_produce_var_args,
	args = { {'in'}, {'in'}, {'exec'} },
}
data.instructions.get_unlocked_components = {
	func = function(comp, state, cause, out_item, exec_done) return data.instructions.for_unlocked.func(comp, state, cause, 33, out_item, exec_done) end,
	next = function(comp, state, it, out_item, exec_done) return data.instructions.for_unlocked.next(comp, state, it, 33, out_item, exec_done) end,
	last = function(comp, state, it, out_item, exec_done) state.counter = exec_done end,
	convert = function(inst) inst.op, inst.c, inst.u = 'for_unlocked', 1, true end,
	args = data.instructions.for_unlocked.args,
}
data.instructions.for_recipe_ingredients = {
	func = function(comp, state, cause, product, out_ingredient, exec_done) return data.instructions.for_ingredients.func(comp, state, cause, 21, product, out_ingredient, exec_done) end,
	next = function(comp, state, it, product, out_ingredient, exec_done) return data.instructions.for_ingredients.next(comp, state, it, 21, product, out_ingredient, exec_done) end,
	last = function(comp, state, it, product, out_ingredient, exec_done) return data.instructions.for_ingredients.last(comp, state, it, 21, product, out_ingredient, exec_done) end,
	convert = function(inst) inst.op, inst.c = 'for_ingredients', 5 end,
	args = data.instructions.for_ingredients.args,
}
data.instructions.for_repair_ingredients = {
	func = function(comp, state, cause, product, out_ingredient, exec_done) return data.instructions.for_ingredients.func(comp, state, cause, 20, product, out_ingredient, exec_done) end,
	next = function(comp, state, it, product, out_ingredient, exec_done) return data.instructions.for_ingredients.next(comp, state, it, 20, product, out_ingredient, exec_done) end,
	last = function(comp, state, it, product, out_ingredient, exec_done) return data.instructions.for_ingredients.last(comp, state, it, 20, product, out_ingredient, exec_done) end,
	convert = function(inst) inst.op, inst.c = 'for_ingredients', 4 end,
	args = data.instructions.for_ingredients.args,
}
data.instructions.for_research_ingredients = {
	func = function(comp, state, cause, product, out_ingredient, exec_done) return data.instructions.for_ingredients.func(comp, state, cause, 51, product, out_ingredient, exec_done) end,
	next = function(comp, state, it, product, out_ingredient, exec_done) return data.instructions.for_ingredients.next(comp, state, it, 51, product, out_ingredient, exec_done) end,
	last = function(comp, state, it, product, out_ingredient, exec_done) return data.instructions.for_ingredients.last(comp, state, it, 51, product, out_ingredient, exec_done) end,
	convert = function(inst) inst.op, inst.c, inst.u = 'for_ingredients', 3, 3 end,
	args = data.instructions.for_ingredients.args,
}
data.instructions.get_grid_effeciency = {
	func = function(comp, state, cause, res) return data.instructions.get_grid_info.func(comp, state, cause, 1, nil, res) end,
	convert = function(inst) inst.op, inst[3] = 'get_grid_info', false end,
	args = { {'out'} },
}
data.instructions.connect = {
	func = function(comp, state, cause) comp.owner.disconnected = false end,
	convert = function(inst) inst.op, inst.c, inst.c2 = 'set_logistics_options', { connected = true }, { connected = true } end,
}
data.instructions.disconnect = {
	func = function(comp, state, cause) comp.owner.disconnected = true end,
	convert = function(inst) inst.op, inst.c, inst.c2 = 'set_logistics_options', { connected = true }, { } end,
}
data.instructions.enable_transport_route = {
	func = function(comp, state, cause) local e = comp.owner if IsBot(e) or e.has_crane then e.logistics_transport_route = true end end,
	convert = function(inst) inst.op, inst.c, inst.c2 = 'set_logistics_options', { transport_route = true }, { transport_route = true } end,
}
data.instructions.disable_transport_route = {
	func = function(comp, state, cause) local e = comp.owner if IsBot(e) or e.has_crane then e.logistics_transport_route = false end end,
	convert = function(inst) inst.op, inst.c, inst.c2 = 'set_logistics_options', { transport_route = true }, {} end,
}
data.instructions.check_blightness = {
	func = function(comp, state, cause, in_target, if_blight) return data.instructions.check_blight.func(comp, state, cause, 1, in_target, if_blight, state.counter) end,
	convert = function(inst) inst.op, inst[3] = 'check_blight', inst.next end,
	args = { {'in'}, {'exec'} },
}
