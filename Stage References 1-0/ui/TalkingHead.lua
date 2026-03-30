local layout<const> =
[[
	<Canvas dock=top-right x=-320 y=20 width=690>
		<Box bg=popup_box_bg fill=true blur=true on_click={on_click}/>
		<VerticalList fill=true>
			<Text id=titletxt style=hl textalign=center wrap=true margin_top=10 margin_bottom=2 hidden=true/>
			<Image id=titlesep color=ui_light height=4 margin=8 hidden=true/>
			<Text id=talkingtext min_height=160 wrap=true width=650 margin=20/>
			<Image id=talkingsep color=ui_light height=4 margin=8 margin_right=48/>
			<Text id=talkingstep style=hl textalign=center wrap=true width=630 margin=16 margin_right=48 margin_top=0/>
		</VerticalList>
		<Image id=advanceimg dock=bottom-right x=5 y=-7 color=ui_light image=icon_left_mouse opacity=0.5 sx=0.75 sy=0.75/>
		<Text id=queuetxt textalign=center style=bl dock=bottom-right margin_bottom=20 width=50/>
		<Image dock=bottom id=timerimg height=3 margin=1 width=690 color=green/>
		<Box bg=tech_not_researched_catergory_bg blur=true valign=top x=-158 y=20 on_click={on_click}>
			<StaticImage id=talkingimg width=160 height=160/>
		</Box>
	</Canvas>
]]

local talking_open
local TalkingHead<const> = {}
UI.Register("TalkingHead", layout, TalkingHead)

function TalkingHead:construct()
	self:TweenFromTo("sx", 0.01, 1, 40, "OutQuad")
end

function TalkingHead:SetInfo(info, codex_id)
	self.talkingtext.text = info.txt or "Missing Text"
	self.talkingtext.style = info.style
	self.talkingimg.image = info.img or "talking_head"
	self:SetStepText(codex_id and info.step_txt)
	self:UpdateQueueText()
	if info.snd then
		UI.PlaySound(info.snd)
	end
	if info.dialogue then
		-- dont queue, just override, and hide the mouse cursor icon
		self.advanceimg.hidden = true
		self.queuetxt.hidden = true
	end

	self.timermax = info.timer or 300
	self.timer = self.timermax
	self.timerimg.width = 690

	self.codex_id = codex_id
	if codex_id then
		local extra = Game.GetLocalPlayerExtra()
		if not extra.read_codex then extra.read_codex = {} end
		extra.read_codex[codex_id] = true
	end

	local codex_def = codex_id and data.codex[codex_id]
	local codex_category = codex_def and codex_def.category
	if codex_category and (codex_category == "Mission" or codex_category == "Goals") then
		self.titletxt.text = L("%s: %s", codex_def.category, codex_def.title or codex_def.id)
		self.titletxt.hidden = false
		self.titlesep.hidden = false
		self.talkingtext.margin_top = 0
	else
		self.titletxt.hidden = true
		self.titlesep.hidden = true
		self.talkingtext.margin_top = 20
	end
end

function TalkingHead:SetStepText(step_txt)
	if step_txt then
		self.talkingstep.text = step_txt
		self.talkingsep.hidden = false
		self.talkingstep.hidden = false
		self.talkingtext.margin_bottom = 0
	else
		self.talkingtext.margin_bottom = 20
		self.talkingsep.hidden = true
		self.talkingstep.hidden = true
	end
end

function TalkingHead:UpdateQueueText(animate)
	local queuepos, queue = self.queuepos, self.queue
	if not queuepos and not queue then return end
	self.queuetxt.text = string.format("%d / %d", (queuepos or 1), (queuepos or 1) + (queue and #queue or 0))
	if not animate or self.timer == self.timermax then return end
	self.queuetxt:TweenFromTo("sx", 1.5, 1.0)
	self.queuetxt:TweenFromTo("sy", 1.5, 1.0)
end

function TalkingHead:on_click()
	if self.close then self:close() end
end

function TalkingHead:close()
	UI.StopVoice()
	if self.queue then
		UI.PlaySound("fx_ui_WINDOW_TUT_NEXT")
		self.queuepos = (self.queuepos or 1) + 1
		self:SetInfo(table.remove(self.queue, 1), table.remove(self.queue_codex_ids, 1))
		self.queue = EmptyTableAsNil(self.queue)
	else
		UI.PlaySound("fx_ui_WINDOW_TUT_POPOUT")

		local imgbox, codex_id = self.talkingimg.parent, self.codex_id
		local tx, ty, tw, th = imgbox:GetViewportPosition()
		imgbox:RemoveFromParent()
		imgbox.dock = "top-left"
		imgbox.x, imgbox.y, imgbox.width, imgbox.height = tx, ty, tw, th
		UI.AddLayout(imgbox, 1)
		self:TweenFromTo("sx", 1, 0, 120, "InQuad")
		self:TweenFromTo("x", self.x, self.x - 690/2, 120, "InQuad", function()
			self:RemoveFromParent()
			if codex_id and DropInSidebarButton("Codex", imgbox) then
				local Codex = UI.GetRegisteredLayoutClass("Codex")
				Codex.lastid = codex_id
				Codex.lastscroll = data.codex[codex_id].mission_steps and 999999 or 0
			else
				imgbox:TweenFromTo("opacity", 1, 0, 80, function() imgbox:RemoveFromParent() end)
			end
		end)

		self.close = nil
		self.every_frame_update = nil
		talking_open = nil
	end
end

function TalkingHead:every_frame_update(dt)
	if self.timer == nil then return end
	self.timer = self.timer - (dt * Map.GetGameSpeed())
	if self.timer <= 0 then
		self:close()
		return
	end
	self.timerimg.width = 690 * self.timer / self.timermax
end

function PlayTalkingHead(info, codex_id)
	if Action.IsReplayPlayback() then return end -- no popups while playing back replay
	local race = Game.GetLocalPlayerFaction().extra_data.race or "robot"
	if race ~= "robot" then return end -- no popups for anything but robot race atm

	-- Start if not open yet or has already been closed
	if not talking_open then
		if Map.GetTick() > 1 then UI.PlaySound("fx_ui_WINDOW_TUT_POPUP") end
		talking_open = UI.AddLayout("TalkingHead", 1)
		talking_open:SetInfo(info, codex_id)
		return
	end

	local queue, queue_codex_ids = (talking_open.queue or {}), (talking_open.queue_codex_ids or {})
	-- If queuing a mission step for the same mission already shown or queued, show the step text only for the current
	if codex_id and info.step_txt then
		if talking_open.codex_id == codex_id then
			talking_open:SetStepText(nil) -- hide now that a new popup is queued for the same mission
		end
		for i,v in ipairs(queue_codex_ids) do
			if v == codex_id then queue_codex_ids[i] = false end -- mark to not show step text
		end
	end
	-- Add to end of queue
	queue[#queue+1] =  info
	queue_codex_ids[#queue_codex_ids+1] = codex_id or false
	talking_open.queue, talking_open.queue_codex_ids = queue, queue_codex_ids
	talking_open:UpdateQueueText(true)
end

function IsTalkingHeadActive()
	return talking_open ~= nil
end

----Test
--function UIMsg.OnSetup()
--	PlayTalkingHead({ txt = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", step_txt = "Do this" }, "x_xxx")
--	PlayTalkingHead({ txt = "A second talking head popup", step_txt = "Do that" }, "x_xxx")
--	UI.Delay(2000, function() PlayTalkingHead({ txt = "A third talking head popup", step_txt = "Then do that!" }, "x_xxxl") end)
--end
