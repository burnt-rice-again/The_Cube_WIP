local TextSearch = {}
UI.Register("TextSearch", [[<HorizontalList child_align=center>
		<Text text="Search:" margin_right=8/>
		<InputText id=inp on_change={on_change} fill=true margin_right=-24/>
		<Button id=btn normal=icon_small_empty disabled=true icon=icon_small_find on_click={clear} height=24 width=24 x=-4/>
	</HorizontalList>]], TextSearch)
function TextSearch:Focus() self.inp:Focus() end
function TextSearch:Refresh() self:SendEvent("on_refresh", self.inp.text) end
function TextSearch:SetText(v) self.inp.text = v self:set_btn(not v or #v == 0) end
function TextSearch:clear() self.inp.text = "" self:on_change(self.imp, "") self.inp:Focus() end
function TextSearch:set_btn(emp) self.btn.disabled, self.btn.icon, self.btn.tooltip = emp, emp and "icon_small_find" or "icon_small_deny", emp and "" or "Clear Search" end
function TextSearch:on_change(inp, text) self:set_btn(not text or #text == 0) self:SendEvent("on_refresh", text) end

local ProgressPip = {}
UI.Register("ProgressPip", "<Canvas child_fill=true><HorizontalList id=piplist child_fill=true/><Progress color=ui_light bg=false progress={progress} margin=2/></Canvas>", ProgressPip)
UI.Register("ProgressDualPip", "<Canvas child_fill=true><HorizontalList id=piplist child_fill=true/><Progress color=ui_dark bg=false progress={darkprogress} margin=2/><Progress color=ui_light bg=false progress={progress} margin=2/></Canvas>", ProgressPip)
function ProgressPip:render()
	local pips = math.max(self.pips or 1, 1)
	if pips ~= self.lastpips then
		self.lastpips = pips
		self.piplist:Clear()
		for i=1,pips do
			self.piplist:Add("<Image image=progress_stroke width=1/>")
		end
	end
end

local ConfirmDialog = {}
UI.Register("ConfirmDialog", [[<Modal><Box dock=center bg=popup_box_bg padding=4 blur=true><VerticalList>
		<Box bg=popup_pattern padding=24>
			<VerticalList id=list child_padding=24>
				<Text text={title} size=20 textalign=center/>
				<Text text={body} size=16 width=520 wrap=true textalign=center/>
			</VerticalList>
		</Box>
		<Box bg=popup_additional_bg padding=12>
			<HorizontalList halign=center min_width=400 width={buttons_width} child_padding=10>
				<Button id=okbtn on_click={ok} icon=icon_confirm fill=true/>
				<Button id=cancelbtn on_click={cancel} icon=icon_deny fill=true/>
			</HorizontalList>
		</Box>
	</VerticalList></Box></Modal>]], ConfirmDialog)

function ConfirmDialog:on_ui_accept() self:ok() end

function ConfirmDialog:on_ui_cancel() if self.cancel then self:cancel() else self:ok() end end

function ConfirmDialog:render()
	self.okbtn.text = self.ok_text or "OK"
	self.cancelbtn.text = self.cancel_text or "Cancel"
	self.okbtn.hidden = not self.okbtn.on_click
	self.cancelbtn.hidden = not self.cancelbtn.on_click
end

local CheckBox = {}
UI.Register("CheckBox", [[
	<HorizontalList child_padding=10 child_align=center>
		<Button id=checkbutton width=32 height=32 on_click={on_click}/>
		<Text text={text}/>
	</HorizontalList>
]], CheckBox)
function CheckBox:render()
	self.check = type(self.check) == "boolean" and self.check or false
	self.text = type(self.text) == "string" and self.text or ""
	self.checkbutton.icon = self.check and "icon_small_confirm" or "icon_small_empty"
end
function CheckBox:on_click(btn)
	self.check = not self.check
	self:SendEvent("on_change", self.check)
end

local Combo = {}
UI.Register("Combo", [[<HorizontalList child_padding=1>
		<Button on_click={on_button} textstyle={textstyle} textsize={textsize} text={text} fill=true clip=true/>
		<Button on_click={on_dropdown} id=drp icon=icon_small_arrow_down/>
	</HorizontalList>]], Combo)
function Combo:render()
	local texts = self.texts
	local count = texts and #texts > 0 and #texts
	self.text = count and texts[math.min(math.max(self.value or 1, 1), count)] or ""
	for _,v in ipairs(self) do v.disabled = not count end
end
function Combo:on_button()
	if #self.texts ~= 2 then return self:on_dropdown() end
	self.value = (self.value == 2 and 1 or 2)
	self:SendEvent("on_change", self.value)
end
function Combo:on_dropdown()
	UI.MenuPopup("<Box bg=popup_box_bg blur=true width=10 padding=6><ScrollList child_padding=3 id=list/></Box>", {
		construct = function(cmbpop)
			local val = self.value or 1
			for i,v in ipairs(self.texts) do
				cmbpop.list:Add("<Button on_click={on_select}/>", { i = i, text = v, active = i == val })
			end
			self.drp.active = true
		end,
		destruct = function()
			self.drp.active = false
		end,
		on_select = function(cmbpop, cmbbtn)
			self.value = cmbbtn.i
			self:SendEvent("on_change", self.value)
			UI.CloseMenuPopup(cmbpop)
		end,
		width = self[2]:GetViewportPosition(self) + 32,
		max_height = self.combo_height,
	}, self, "DOWN", "LEFT", 0, 1)
end

local ColorPicker = {}
UI.Register("ColorPicker", [[
		<HorizontalList child_padding=10>
			<Image id=preview width=72 height=72/>
			<VerticalList fill=true>
				<HorizontalList child_align=center><Text width=75 text="Red"/><Slider id=red ind=1 height=24 min=0 max=1.0 step=0.01 on_change={on_slider} fill=true/><InputText margin_left=8 on_change={on_change_txt} on_commit={on_commit} ind=1 id=red_val padding=0 width=42 height=28/></HorizontalList>
				<HorizontalList child_align=center><Text width=75 text="Green"/><Slider id=green ind=2 height=24 min=0 max=1.0 step=0.01 on_change={on_slider} fill=true/><InputText margin_left=8 on_change={on_change_txt} on_commit={on_commit} ind=2 id=green_val padding=0 width=42 height=28/></HorizontalList>
				<HorizontalList child_align=center><Text width=75 text="Blue"/><Slider id=blue ind=3 height=24 min=0 max=1.0 step=0.01 on_change={on_slider} fill=true/><InputText margin_left=8 on_change={on_change_txt} on_commit={on_commit} ind=3 id=blue_val padding=0 width=42 height=28/></HorizontalList>
			</VerticalList>
		</HorizontalList>
	]], ColorPicker)
function ColorPicker:render()
	self.sliders={ self.red, self.green, self.blue }
	self.txt = { self.red_val, self.green_val, self.blue_val }
	self.color = self.color or {1,1,1}

	for i=1,3 do
		self.sliders[i].value = self.color[i]
		self.txt[i].text = string.format("%.0f", self.color[i] * 255 + 0.499)
	end
	self.preview.color = self.color_mapping and Game.GetMappedColor(self.color) or self.color
end
function ColorPicker:on_slider(slider, val)
	self.color[slider.ind] = val
	self.txt[slider.ind].text = string.format("%.0f", val * 255 + 0.499)
	self.preview.color = self.color_mapping and Game.GetMappedColor(self.color) or self.color
	self:SendEvent("on_change", self.color)
end

function ColorPicker:on_change_txt(txt, val)
	local numval = math.min(math.max(tonumber(val) or 0.0, 0.0), 255.0) / 255.0
	self.sliders[txt.ind].value = numval
	self.color[txt.ind] = numval
	self.preview.color = self.color_mapping and Game.GetMappedColor(self.color) or self.color
	self:SendEvent("on_change", self.color)
end

function ColorPicker:on_commit(txt)
	txt.text = string.format("%.0f", self.color[txt.ind] * 255 + 0.499)
end
