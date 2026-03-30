local LinkEditor_layout<const> =
[[
<Box blur=true>
	<Canvas child_fill=true margin=8>
		<VerticalList>
			<VerticalList id=components child_padding=8 halign=left margin_bottom=48 margin_right=0/>
			<HorizontalList id=frameregs child_padding=2/>
		</VerticalList>
		<Draw id=links/>
	</Canvas>
</Box>
]]

local LinkEditor<const> = {}
UI.Register("LinkEditor", LinkEditor_layout, LinkEditor)

function LinkEditor:construct()
	local entity = self.entity

	-- add component socket blocks
	for i,v in ipairs(entity.visual_def.sockets or {}) do
		local cb = self.components:Add("<ComponentBlock halign=left on_drop=false/>", { entity = entity, socket = i, socket_size = v[2] })
		cb.box.on_drag_start, cb.box.on_drag_cancel, cb.box.on_drop, cb.box.on_click = false, false, false -- no interaction
	end

	-- add frame registers
	self.regs = {}
	for i,v in ReverseIPairs(data.frame_regs) do
		local reg = self.frameregs:Add("<Reg on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_drag_complete={link_on_drag_complete} on_drop={link_on_drop} reg_row=0/>", {
			ent = entity,
			reg_index = i,
			empty_tooltip = v.tooltip,
			ui_icon = v.bg,
		})
		self.regs[i] = reg
	end

	if self.compact then
		self.bg = false
		self.blur = false
		self.blocking = false
		self.frameregs.margin_left = 26
		self[1].margin = 0
	end
end

function LinkEditor:update()
	-- add blocks for hidden components (including ones added after the frameview was already open)
	local entity, hiddencomps, hiddencount = self.entity
	for i=1,999 do
		local comp = entity:GetHiddenComponent(i)
		if not comp then break end
		local comp_def = comp.def
		if comp_def.get_ui or (comp_def.attachment_size and comp_def.attachment_size ~= "Hidden") then
			if not hiddencomps then hiddencomps = self.hiddencomps if not hiddencomps then hiddencomps = {} self.hiddencomps = hiddencomps end end
			hiddencount = (hiddencount or 0) + 1
			local compblock = hiddencomps[i]
			if not compblock or not compblock:IsValid() then
				compblock = self.components:Add("<ComponentBlock halign=left on_drop=false socket_size=hidden/>", { entity = entity, hiddencomp = i })
				compblock.box.on_drag_start, compblock.box.on_drag_cancel, compblock.box.on_drop, compblock.box.on_click = false, false, false -- no interaction
				compblock.child_index = hiddencount
				hiddencomps[i] = compblock
			end
		end
	end

	local components, reg_row, have_components, changed_components = self.components, 1
	for i,v in ipairs(components) do
		local socket = v.socket
		local comp = (socket and entity:GetComponent(socket)) or (not socket and entity:GetHiddenComponent(v.hiddencomp))
		local hash = (comp and Tool.Hash(comp, comp.register_index, comp.register_count) or 0)
		if (v.hash ~= hash) then
			local show, regs_per_row = comp and comp.exists and comp.register_count > 0, 5
			v.hash = hash
			v:SetComp(comp)
			v.regs:Clear()
			v.hidden = not show
			if show then
				local comp_def = comp.def
				local regdefs = comp_def.registers
				local regcount, abs_index = comp.register_count, comp.register_index - 1
				local behavior_asm = comp.base_id == "c_behavior" and comp.has_extra_data and GetFactionBehaviorAsmById(comp.faction, comp.extra_data.main_id)
				local behavior_pnames = behavior_asm and behavior_asm.code.pnames
				local reglayout = "<Reg on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel} on_drag_complete={link_on_drag_complete} on_drop={link_on_drop} valign=bottom/>"
				if regcount > 15 then regs_per_row = (regcount + 2) // 3 end
				for j=1,regcount do
					if j % regs_per_row == 1 then reg_row = reg_row + 1 end
					local regdef = regdefs and regdefs[j]
					local tt = regdef and regdef.tip
					self.regs[abs_index + j] = v.regs:Add(reglayout, {
						ent = entity,
						comp = comp,
						comp_index = i,
						reg_index = j,
						reg_row = reg_row,
						empty_tooltip = tt and L("%s\n\n<desc>A Register that holds a value</>", tt),
						no_num_txt = (behavior_pnames and behavior_pnames[j]) or (behavior_asm and NOLOC("P" .. j)) or nil,
					})
					v.progress.hidden, v.progressbg.hidden = true, true
				end
				v.regs.wrapsize = regs_per_row * 56 + (regs_per_row - 1) * 4
			end
			v.regs_per_row = regs_per_row
			changed_components = true
		end
		if comp and comp.is_working and v.progress.hidden then
			v.progress.hidden, v.progressbg.hidden = false, false
			v.progress.every_frame_update = function(p) p.progress = comp.interpolated_progress end
			v.progress.progress = comp.interpolated_progress
		elseif not v.progress.hidden and (not comp or not comp.is_working) then
			v.progress.hidden, v.progressbg.hidden = true, true
		end
		have_components = have_components or not v.hidden
	end
	self.components.hidden = not have_components

	-- If links changed, queue redrawing of lines
	local entity_links = entity:GetRegisterLinks()
	local links_hash = entity_links and Tool.Hash(entity_links)
	if self.links_hash ~= links_hash or changed_components then
		self.links_hash = links_hash
		self.links.on_draw = function(draw) self:UpdateLinks(draw) end
		self:MakeMarginsForLinks(entity_links)
	end
end

-- Shared code with FrameView (TODO: refactor FrameView and LinkEditor to do this nicer)
local FrameViewClass = UI.GetRegisteredLayoutClass("FrameView")
LinkEditor.link_on_drag_start    = FrameViewClass.link_on_drag_start
LinkEditor.link_on_drag_cancel   = FrameViewClass.link_on_drag_cancel
LinkEditor.link_on_drag_complete = FrameViewClass.link_on_drag_complete
LinkEditor.link_on_drop          = FrameViewClass.link_on_drop

function LinkEditor:MakeMarginsForLinks(entity_links)
	local components = self.components
	for _,v in ipairs(components) do
		v.margin_top = 0
		for i=v.regs_per_row+1,#v.regs,v.regs_per_row do v.regs[i].margin_top = 0 end
	end

	local regs, comps_y, comps_right = self.regs, 0, 0
	for i,link in ipairs(entity_links) do
		local sreg, treg, no_source_raise = regs[link.source_index], regs[link.index]
		if not sreg or not treg then goto no_raise end -- hidden component?
		local srow, trow = sreg.reg_row, treg.reg_row
		for j=1,(i-1) do
			if entity_links[j].source_index == link.source_index then
				no_source_raise = true
				local ptreg = regs[entity_links[j].index]
				if ptreg.reg_row == trow then goto no_raise end -- already had a link from the same source targeting the same row
			end
		end
		for part=(no_source_raise and 2 or 1),(srow == trow and 1 or 2) do
			local reg = (part == 1 and sreg or treg)
			if reg.comp_index then
				local v, idx = components[reg.comp_index], reg.reg_index
				local lift_register = idx > v.regs_per_row
				if lift_register then
					v = v.regs[idx - ((idx - 1) % v.regs_per_row)]
				end
				v.margin_top = (v.margin_top == 0 and (lift_register and 25 or 20) or v.margin_top + 10)
			else
				comps_y = (comps_y == 0 and 25 or comps_y + 10)
			end
		end
		if srow ~= trow then comps_right = comps_right + 10 end
		::no_raise::
	end
	components.margin_bottom = math.max(comps_y, 48)
	components.margin_right = comps_right
end

function LinkEditor:UpdateLinks(draw)
	-- This function is called via the on_draw callback which gets called when the draw widget is being painted.
	-- Because the draw widget is last in the parent canvas, all the GetViewportPosition calls are done on widgets that have already been laid out.

	-- Calculate X position of vertical connection line
	local compsx, compsy, compsw = self.components:GetViewportPosition(draw)
	local vertx = compsx and (compsx + compsw) or 0

	local reg_conns, targets, raises, rows = {}, {}, {}, {}
	local function ConnXOffset(idx, skip_increment)
		local conns = reg_conns[idx] or 0
		if not skip_increment then conns = conns + 1 reg_conns[idx] = conns end
		if conns <= 1 then return    0 end
		if conns == 2 then return   10 end
		if conns == 3 then return - 10 end
		if conns == 4 then return   20 end
		if conns == 5 then return - 20 end
		return 50 - conns * 7
	end

	local entity_links = self.entity:GetRegisterLinks() or {}
	table.sort(entity_links, function (a,b) return a.source_index > b.source_index end)

	draw:Reset()
	local regs, link_colors, col_idx, numtargets, source = self.regs, data.link_colors, 0, 0
	for i=1,#entity_links+1 do
		local link = entity_links[i]
		local next_source, link_index = link and link.source_index, link and link.index
		if source ~= next_source and source then
			local sreg = regs[source]
			if sreg and sreg:IsValid() then
				local sx, sy, sw, sh = sreg:GetViewportPosition(draw)
				if sx then
					local half_reg = sw / 2
					sx = sx + half_reg + ConnXOffset(source)

					local srow = sreg.reg_row
					for k,_ in pairs(rows) do rows[k] = nil end
					rows[srow] = true
					for t=1,numtargets do
						local target = targets[t]
						local treg = regs[target]
						rows[treg.reg_row] = true
					end
					for k,_ in pairs(rows) do
						raises[k] = (raises[k] or 10) + 10
					end
					local sraise = raises[srow]

					local pushed_vert
					for pass=1,2 do
						local col = (pass == 1 and "#44EE" or "white")
						if pass == 2 then
							col = link_colors[1 + (col_idx % #link_colors)]
							col_idx = col_idx + 1
						end

						local thick = (pass == 1 and 2.0 or 0.0)
						draw:AddTriangle(sx, sy, 12.5+thick, col)

						for i=1,numtargets do
							local target = targets[i]

							local traise, tx, ty = 20
							local treg = regs[target]
							traise = raises[treg.reg_row]
							tx, ty = treg:GetViewportPosition(draw)
							tx = tx + half_reg + ConnXOffset(target, thick == 0)

							local pass_vert = (math.abs(ty - sy) > 50)
							if pass_vert and not pushed_vert then
								pushed_vert = true
								vertx = vertx + 10
							end
							local midx = (pass_vert and vertx or (sx + tx) * 0.5)
							if not pass_vert then traise = sraise + (ty - sy) end

							draw:AddTriangle(tx, ty, 8.5+thick, 180, col)
							draw:AddLines(
								sx, sy,
								sx, sy - sraise,
								midx, sy - sraise,
								midx, ty - traise,
								tx, ty - traise,
								tx, ty,
								col, 3, true, thick)
						end
					end
				end
			end
			numtargets = 0
		end

		if next_source and regs[link_index] then
			source = next_source
			numtargets = numtargets + 1
			targets[numtargets] = link_index
		end
	end

	local dragsource = self.dragsource
	if dragsource then
		local flip, tx, ty = UI.IsMouseOverUI() and 0 or 180, UI.GetMousePosition(draw)
		local sx, sy, sw, sh = dragsource:GetViewportPosition(draw)
		if sx and tx then
			local sup = ty < sy + sh
			local tup = ty > sy - 10
			sx = sx + (sw / 2)
			sy = sy + (sup and 0 or sh)
			local curve = math.max(50, math.abs(sx - tx) / 5)

			for pass=1,2 do
				local col = (pass == 1 and "#44EE" or "white")
				local thick = (pass == 1 and 2.0 or 0.0)
				draw:AddTriangle(sx,     sy, 12.5+thick, (sup and 0 or 180) + flip, col)
				draw:AddTriangle(tx - 1, ty,  8.5+thick, (tup and 180 or 0) + flip, col)
				draw:AddBezierCurve(sx, sy,
					sx, sy + (sup and -curve or curve),
					tx, ty + (tup and -curve or curve),
					tx, ty, col, 3+thick)
			end
		end
	else
		draw.on_draw = nil
	end
end
