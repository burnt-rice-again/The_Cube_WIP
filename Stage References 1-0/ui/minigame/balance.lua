local Balance_layout<const> =
[[
	<Box padding=4>
		<VerticalList child_padding=16>
			<Canvas>
				<HorizontalList>
					<VerticalList id=sources/>
					<Text width=162 style=hl id=totaltxt textalign=center valign=bottom/>
					<VerticalList id=targets/>
				</HorizontalList>
				<Draw id=links fill=true clip=true/>
			</Canvas>
			<HorizontalList halign=center>
				<Progress id=leftbar width=80 height=20 valign=center margin_left=20/>
				<Image width=2 height=40 valign=center/>
				<Progress id=rightbar width=80 height=20 valign=center margin_right=20/>
			</HorizontalList>
		</VerticalList>
	</Box>
]]

local Balance = {}
UI.Register("ExplorableGameBalance", Balance_layout, Balance)

local LinkColors = { "white", "#6DFF49", "#FF7070", "#7098FF", "#FFF970", "#70FFFF", "#DE70FF","#FFA671", }
local amounts = { v_signal_a = 2, v_signal_b = 3, v_signal_c = 5, v_signal_d = 7, v_signal_e = 13 }

function Balance:construct()
	local num_regs = 3 -- must be >= 2 and <= number of keys in amounts
	for i=1,num_regs do
		self.sources:Add("<Reg on_drag_start={link_on_drag_start} on_drag_cancel={link_on_drag_cancel}/>")
		self.targets:Add("<Reg read_only=true on_drop={link_on_drop} on_click={target_on_click}/>")
	end

	local possible_signals = {}
	for k,_ in pairs(amounts) do table.insert(possible_signals, k) end

	local has_key = Game.GetLocalPlayerFaction():HavePickedUpItem("c_alien_key")
	for _,w in ipairs(self.sources) do
		local n = math.random(#possible_signals)
		w.def_id = possible_signals[n]
		w.num = has_key and amounts[w.def_id]
		table.remove(possible_signals, n)
	end

	self.need_amount = 0
	for i=1,1+math.random(#self.targets-1) do -- a combination of at least 2 source amounts
		self.need_amount = self.need_amount + amounts[self.sources[math.random(#self.sources)].def_id]
	end
	if has_key then self.totaltxt.text = tostring(self.need_amount) end

	self:Recalculate() -- reset bars
end

function Balance:Recalculate()
	local have_amount = 0
	for _,w in ipairs(self.targets) do
		if w.def_id then
			have_amount = have_amount + amounts[w.def_id]
		end
	end

	local match = have_amount / self.need_amount
	self.leftbar.progress = match
	self.rightbar.progress = match - 1.0
	if match == 1.0 then
		self.outer:OnSolve()
	end

	self:DrawLinks()
end

function Balance:target_on_click(reg, mousebtn)
	if mousebtn ~= "RIGHTMOUSEBUTTON" or not reg.def_id then return end
	reg.def_id, reg.srcreg = nil, nil
	self:Recalculate()
end

function Balance:DrawLinks()
	local draw = self.links
	draw:Reset()
	for n=(self.dragreg and 0 or 1),#self.targets do
		for pass=1,2 do
			local src = n == 0 and self.dragreg or self.targets[n].srcreg
			if src then
				local sx, sy, tx, ty = src:GetViewportPosition(self.links)
				sx, sy = sx + 52 + 4, sy + 28
				if n == 0 then
					tx, ty = UI.GetMousePosition(draw)
				else
					tx, ty = self.targets[n]:GetViewportPosition(self.links)
					tx, ty = tx - 4, ty + 28
				end
				local thick, col = (pass == 1 and 2.0 or 0.0), (pass == 2 and LinkColors[n+1] or "#44EE")
				draw:AddTriangle(sx, sy, 8.5+thick, 270, col)
				draw:AddTriangle(tx, ty, 8.5+thick, 270, col)
				draw:AddBezierCurve(sx, sy, sx + 64, sy, tx - 64, ty, tx, ty, col, 3+thick)
			end
		end
	end
end

function Balance:link_on_drag_start(reg)
	UI.PlaySound("fx_ui_ELEMENT_DRAG")
	self.dragreg = reg
	self.every_frame_update = function(me) me:DrawLinks() end
	return UI.New("Spacer") -- invisible drag visual
end

function Balance:link_on_drop(reg, payload)
	if payload.parent ~= self.sources then return end
	if reg.def_id == payload.def_id then
		reg.def_id, reg.srcreg = nil, nil
	else
		reg.def_id, reg.srcreg = payload.def_id, payload
	end
	self:link_on_drag_cancel()
end

function Balance:link_on_drag_cancel()
	if not self:IsValid() then return end
	self.dragreg, self.every_frame_update = nil, nil
	self:Recalculate()
end
