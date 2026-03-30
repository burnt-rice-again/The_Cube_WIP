local layout<const> =
[[
	<Box dock=top y=30 padding=12>
		<VerticalList child_padding=4>
			<Text text="Loaded save game contains no replay data" id=noreplay/>
			<Text text="Replay Speed"   /><Slider id=speed    width=800 height=20 min=0 max=100 step=0.1 value=0 on_change={on_speed_change}/>
			<Text text="Replay Progress"/><Slider id=progress width=800 height=20 min=0 on_change={on_set_progress} tooltip={progress_tooltip}/>
			<HorizontalList halign=center child_padding=4>
				<Button text="Pause Playback" on_click={on_click_pause}/>
				<Button text="Set 100% Speed" on_click={on_click_resetspeed}/>
				<InputText text="100" on_enter={on_custom_speed} id=inpspeed width=100 textalign=center/>
				<Button text="Set Custom Speed" on_click={on_custom_speed}/>
				<Button text="Switch Faction" on_click={on_click_faction}/>
				<Button text="Restart Playback" on_click={on_click_restart}/>
				<Button text="Play Game From Here" on_click={on_click_playfromhere}/>
			</HorizontalList>
			<Text id=status halign=center/>
		</VerticalList>
	</Box>
]]

local ReplayPlayer<const> = {}
local ReplayPlayerOpen
UI.Register("ReplayPlayer", layout, ReplayPlayer)

function ReplayPlayer:construct()
	local dur = Action.GetReplayDuration()
	self.noreplay.hidden = (dur ~= 0)
	self.progress.max = dur
	ReplayPlayerOpen = self
end

function ReplayPlayer:update()
	self.progress.value = Action.GetReplayProgress()
	local speed = self.speed.value
	local total_days   = Action.GetReplayDuration(true)
	local current_days = Action.GetReplayProgress(true)
	self.status.text = L("%s - [ %s ] / [ %s ]",
		L("Speed: %s", (speed > 0 and string.format("%.0f%%", speed*100+.49) or "Paused")),
		L("Day %d %02d:%02d", math.floor(current_days + 1), math.floor(current_days * 24 % 24), math.floor(current_days * 1440 % 60)),
		L("Day %d %02d:%02d", math.floor(total_days   + 1), math.floor(total_days   * 24 % 24), math.floor(total_days   * 1440 % 60))
	)
end

function ReplayPlayer:progress_tooltip()
	return UI.New([[<Box padding=8 bg=popup_box_bg blur=true><VerticalList>
			<HorizontalList child_align=center><Image image=icon_tiny_tick color=ui_light margin_right=4/><Text text="Time at cursor"      color=ui_light fill=true/><Text id=hover   width=100 margin_left=20/></HorizontalList>
			<HorizontalList child_align=center><Image image=icon_tiny_time color=ui_light margin_right=4/><Text text="Current replay time" color=ui_light fill=true/><Text id=current width=100 margin_left=20/></HorizontalList>
		</VerticalList></Box>]], {
		every_frame_update = function(w)
			local day_start_offset = Map.GetSettings().day_start_offset
			local wid = self.progress:GetDesiredSize()
			local x = UI.GetMousePosition(self.progress)
			local hover_progress = math.max(0, math.min(1, (x - 10) / (wid - 20)))
			local hover_days = day_start_offset + (Action.GetReplayDuration(true) - day_start_offset) * hover_progress
			local current_days = Action.GetReplayProgress(true)
			w.hover.text   = L("%s %02d:%02d", L("Day %d", math.floor(hover_days + 1)), math.floor(hover_days * 24 % 24), math.floor(hover_days * 1440 % 60))
			w.current.text = L("%s %02d:%02d", L("Day %d", math.floor(current_days + 1)), math.floor(current_days * 24 % 24), math.floor(current_days * 1440 % 60))
		end
	})
end

function ReplayPlayer:on_set_progress(slider, value)
	self.progress.value = Action.GetReplayProgress()
end

function ReplayPlayer:on_speed_change(slider, value)
	Action.SetReplaySpeed(value)
	self:update()
end

function ReplayPlayer:on_click_pause()
	Action.SetReplaySpeed(0)
	self.speed.value = 0
	self:update()
end

function ReplayPlayer:on_click_resetspeed()
	Action.SetReplaySpeed(1)
	self.speed.value = 1
	self:update()
end

function ReplayPlayer:on_custom_speed()
	local num = math.min(math.max(string.gsub("0"..self.inpspeed.text, "[^%d.]", "")//1|0, 0))
	Action.SetReplaySpeed(num * 0.01)
	self.speed.value = num * 0.01
	self.inpspeed.text = tostring(num)
	self:update()
end

function ReplayPlayer:on_click_faction()
	UI.AddLayout("<Modal><Box dock=center bg=popup_box_bg padding=12 blur=true><Wrap width=1000 height=1000 id=list/></Box></Modal>", {
		construct = function(view)
			for _,f in ipairs(Map.GetFactions()) do
				if not f.is_world_faction and f.num_entities > 0 then
					view.list:Add("<Button on_click={on_select}/>", { text = f.id })
				end
			end
		end,
		on_select = function(view, btn)
			Action.SetReplayViewFaction(btn.text)
			view:RemoveFromParent()
		end,
	},10)
end

function ReplayPlayer:on_click_restart()
	Action.RestartReplay()
end

function ReplayPlayer:on_click_playfromhere()
	Action.ReplayPlayFromHere()
	self:RemoveFromParent()
end

function ReplayPlayer_ToggleCustomSpeed()
	if not ReplayPlayerOpen then return end
	local speed = math.min(math.max(string.gsub("0"..ReplayPlayerOpen.inpspeed.text, "[^%d.]", "")//1|0, 0))
	speed = (speed < 25 and 25 or (speed < 50 and 50 or (speed < 75 and 75 or (speed < 100 and 100 or (speed < 200 and 200 or (speed < 500 and 500 or (speed < 1000 and 1000 or (speed < 2500 and 2500 or 0))))))))
	ReplayPlayerOpen.inpspeed.text = string.format("%.0f", speed)
	if ReplayPlayerOpen.speed.value > 0 then
		ReplayPlayerOpen:on_custom_speed()
	end
end

function ReplayPlayer_SetPlaying(playing)
	if not ReplayPlayerOpen then return end
	if ReplayPlayerOpen.speed.value == 0 and playing then
		ReplayPlayerOpen:on_custom_speed()
	elseif ReplayPlayerOpen.speed.value > 0 and not playing then
		ReplayPlayerOpen:on_click_pause()
	end
end
