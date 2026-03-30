local notifications_layout<const> =
[[
	<VerticalList>
		<Text text="Notifications" color=light_gray size=10 hidden=true/>
		<VerticalList child_padding=3 id=notifications/>
	</VerticalList>
]]

local notify_layout<const> = [[
	<Box padding=4 blur=true>
		<HorizontalList child_padding=8 child_align=center>
			<Image width=48 height=48 image={icon} margin_left=4/>
			<VerticalList>
				<Text text={title} color=title width=200 wrap=true/>
				<Text size=10 text={content_text} width=200 wrap=true/>
			</VerticalList>
		</HorizontalList>
	</Box>
]]

local Notifications = {}
local notifications_list
local notification_stack = {}

UI.Register("Notifications", notifications_layout, Notifications)

function Notifications:construct()
	notifications_list = self.notifications

	for id,args in pairs(notification_stack) do
		notification_stack[id] = false
		if type(args) == "table" then -- ignore old widgets in the stack if the sidebar gets closed and added again
			Notification.Add(table.unpack(args))
		end
	end
end

function Notifications:destruct()
	notifications_list = nil
end

Notification = {}
local notification_undefined_id = 0
local current_popup = nil

local notify_icons = {
	["warning"]      = "Main/skin/Icons/Special/Notifications/Warning.png",
	["info"]         = "Main/skin/Icons/Special/Notifications/Info.png",
	["mission"]      = "Main/skin/Icons/Special/Notifications/Mission.png",
	--["error"]        = "Main/skin/Icons/Special/Notifications/Error.png",
	--["idle"]         = "Main/skin/Icons/Special/Notifications/Idle.png",
	--["story"]        = "Main/skin/Icons/Special/Notifications/Story.png",
	--["underattack"]  = "Main/skin/Icons/Special/Notifications/Under Attack.png",
}

local error_layout = [[
	<Canvas dock=bottom y=-200>
		<Box dock=fill opacity=0.7 blocking=false/>
		<Image color="#5CEBA319" dock=fill/>
		<Image image=warning_pattern color="#60D4A2" dock=top-right/>
		<HorizontalList dock=fill child_padding=8 margin=5>
			<Image image=icon_warning width=80 height=80 color="#FFFF00"/>
			<Text text={errtxt} style=notify_error width=446 wrap=true fill=true valign=center/>
		</HorizontalList>
	</Canvas>
]]
function Notification.Error(errortxt, duration)
	if current_popup ~= nil then current_popup:RemoveFromParent() end
	current_popup = UI.AddLayout(error_layout, { errtxt = errortxt })
	current_popup:TweenFromTo("x", 0, 0, 2000, "InQuad", function()
		current_popup:TweenFromTo("sy", 1, 0.01, duration or 40, "InQuad", function() current_popup:RemoveFromParent() current_popup = nil end)
	end)
end

function Notification.Warning(warntxt, duration)
	if current_popup ~= nil then current_popup:RemoveFromParent() end
	current_popup = UI.AddLayout("<Text dock=bottom y=-300 style=notify_warning/>", { text = warntxt })
	current_popup:TweenFromTo("x", 0, 0, 2000, "InQuad", function()
		current_popup:TweenFromTo("sy", 1, 0.01, duration or 40, "InQuad", function() current_popup:RemoveFromParent() current_popup = nil end)
	end)
end

function Notification.Info(infotxt, duration)
	if current_popup ~= nil then current_popup:RemoveFromParent() end
	current_popup = UI.AddLayout("<Text dock=bottom y=-300 style=notify_info/>", { text = infotxt })
	current_popup:TweenFromTo("x", 0, 0, 2000, "InQuad", function()
		current_popup:TweenFromTo("sy", 1, 0.01, duration or 40, "InQuad", function() current_popup:RemoveFromParent() current_popup = nil end)
	end)
end

-- opts is a table with keys { tooltip = "str", duration = seconds, on_click = function, on_secondary = function }
function Notification.Add(id, icon, title, text, opts)
	if not notifications_list then
		notification_stack[id] = { id, icon, title, text, opts }
		return
	end

	local function notify_click_func(widget, mousebtn)
		if mousebtn == "RIGHTMOUSEBUTTON" then
			if opts and opts.on_secondary then
				opts.on_secondary(id)
			end
			Notification.Clear(id)
		elseif mousebtn == "LEFTMOUSEBUTTON" then
			if not opts or not opts.on_click or opts.on_click(id) then
				Notification.Clear(id)
			end
		end
	end

	local function notify_tick_remain(widget, dtime)
		widget.remain = widget.remain - dtime
		if widget.remain <= 0.0 then
			if opts.on_secondary then
				opts.on_secondary()
			end
			Notification.Clear(id)
		end
	end

	local params = {
		icon = notify_icons[icon] or icon,
		title = title,
		content_text = text,
		on_click = notify_click_func,
		tooltip = opts and opts.tooltip or title,
		remain = opts and opts.duration,
		every_frame_update = opts and opts.duration and notify_tick_remain,
		on_clear = opts and opts.on_clear,
	}

	local existing = notification_stack[id]
	if existing then
		for k,v in pairs(params) do
			existing[k] = v
		end
	else
		if not id then
			notification_undefined_id = notification_undefined_id + 1
			id = "notification_" .. notification_undefined_id
		end

		notification_stack[id] = notifications_list:Add(notify_layout, params)
		notifications_list.previous_sibling.hidden = false
		-- add some movement to notify the player
		notification_stack[id]:TweenFromTo("x", 600, 0, 180, "InQuad")
		if opts and opts.nosound == true then return end
		if Map.GetTick() > 1 then
			UI.PlaySound("fx_ui_OBJECTIVE_NEW")
		end
	end
end

function Notification.UpdateText(id, newtext)
	local existing = notification_stack[id]
	if existing then
		existing.content_text = newtext
	end
end

function Notification.UpdateAll(id, tbl)
	if not tbl then return end
	local existing = notification_stack[id]
	if existing then
		existing.content_text = tbl.text
		existing.icon = tbl.icon
	end
end

function Notification.Clear(id)
	local existing = notification_stack[id]
	if not existing then return end
	if notifications_list then
		if existing.on_clear then
			existing.on_clear()
		end
		existing:TweenFromTo("x", 0, 600, 180, "InQuad", function(w)
			w:RemoveFromParent()
			notifications_list.previous_sibling.hidden = #notifications_list == 0
		end)
		UI.PlaySound("fx_ui_WINDOW_OBJECTIVES_CLOSE")
	end
	notification_stack[id] = nil
end

function UIMsg.OnFactionRespawn()
	if notifications_list then
		for _,w in ipairs(notifications_list) do
			if w.on_clear then
				w.on_clear()
			end
		end
		notifications_list:Clear()
		notifications_list.previous_sibling.hidden = true
	end
	notification_stack = {}
end
