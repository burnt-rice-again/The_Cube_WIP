function ConfirmBox(msg, on_ok, on_cancel, title)
	UI.AddLayout('<ConfirmDialog ok_text="Yes" cancel_text="No"/>', {
		title = title or "Confirm", body = msg,
		ok = function(w) w:RemoveFromParent() if on_ok then on_ok() end end,
		cancel = function(w) w:RemoveFromParent() if on_cancel then on_cancel() end end,
	}, 99)
end

function ConfirmPopup(popup_next_to, msg, on_ok, title)
	UI.MenuPopup('<ConfirmDialog ok_text="Yes" cancel_text="No"/>', {
		construct = function(w) w:TweenFromTo("sy", 0.01, 1, 80, 'OutQuad') end,
		title = title or "Confirm", body = msg,
		ok = function(w) if on_ok then on_ok() end UI.CloseMenuPopup(w) end,
		cancel = function(w) UI.CloseMenuPopup(w) end,
	}, popup_next_to)
end

function MessageBox(msg, title, on_close)
	if View.IsRunningHeadless() then print(NOLOC(L("%s: %s", title or "Message", msg))) return end
	UI.AddLayout("ConfirmDialog", {
		title = title or "Message", body = msg,
		ok = function(w) w:RemoveFromParent() if on_close then on_close() end end,
	}, 99)
end

function MessagePopup(popup_next_to, msg, title)
	UI.MenuPopup("ConfirmDialog", { title = title or "Message", body = msg, ok = function(w) UI.CloseMenuPopup(w) end }, popup_next_to)
end

function InputBox(msg, title, on_ok, current_text, password, multiline)
	UI.AddLayout("ConfirmDialog", {
		title = title, body = msg,
		construct = function(w)
			local i = w.list:Add(multiline and "<MultiLineInputText height=200/>" or "<InputText/>")
			w.input, i.text, i.password, i.on_enter = i, current_text or "", (password ~= nil), function() w:ok() end
			i:Focus()
		end,
		ok = function(w) if on_ok(w.input.text) ~= false then w:RemoveFromParent() end end,
		cancel = function(w) w:RemoveFromParent() end,
	}, 99)
end

function GetSortedTableKeys(tbl)
	local keys = {}
	if not tbl then return keys end
	for k in next, tbl do keys[#keys+1] = k end
	table.sort(keys)
	return keys
end

function SortedPairs(tbl)
	local i, keys = 0, GetSortedTableKeys(tbl)
	return function()
		i = i+1
		local k = keys[i]
		if k then return k, tbl[k] end
	end
end

function ReverseIPairs(tbl)
	local i = tbl and (#tbl + 1) or 1
	return function() i = i - 1 if i ~= 0 then return i, tbl[i] end end
end

function ProcessUnlockedDefinitions(cb, filter_defs, get_from_library, get_last_entity_copy, add_extra_known_things)
	local faction = Game.GetLocalPlayerFaction()
	local faction_unlocks, categories, frames = faction.unlocks, data.categories, data.frames
	for i=1,#faction_unlocks do faction_unlocks[faction_unlocks[i]] = true end
	if add_extra_known_things then for id,_ in pairs(Tech_GetExtraKnownThings()) do faction_unlocks[id] = true end end

	for catidx=1,#categories do
		local category = categories[catidx]
		local defs, filter_field, filter_val = category.defs, category.filter_field, category.filter_val
		if not filter_defs or defs == filter_defs then
			for def_id, def in pairs(defs) do
				if ((faction_unlocks[def_id])) and def[filter_field] == filter_val then
					cb(def_id, def, category, nil, nil, catidx)
				end
			end
			if defs == frames and get_from_library then
				for id,item in pairs(get_from_library) do
					local def = item.type == 'B' and faction_unlocks[item.frame] and frames[item.frame] -- blueprint
					if def and def[filter_field] == filter_val and FactionHasUnlockedCustomBlueprint(faction, item) then
						cb(id, item, category, def, nil, catidx)
					end
				end
			end
		end
	end
	if get_from_library then
		local multibpcat
		for id,item in pairs(get_from_library) do
			if item.type == 'B' and item.multi then -- multi-blueprint
				if not multibpcat then multibpcat = { name = "Multi Blueprint" } end
				if FactionHasUnlockedCustomBlueprint(faction, item) then cb(id, item, multibpcat, nil, item.multi, 0) end
			end
		end
	end
	if get_last_entity_copy then
		local copy_bp = UnitCopyPaste.GetItem('B')
		local copy_bp_frame = copy_bp and faction_unlocks[copy_bp.frame] and frames[copy_bp.frame]
		if copy_bp_frame and FactionHasUnlockedCustomBlueprint(faction, copy_bp) then
			cb(-1, copy_bp, { name = "Last Copied", tab = 'item' }, copy_bp_frame, nil, 0)
		elseif copy_bp and copy_bp.multi and FactionHasUnlockedCustomBlueprint(faction, copy_bp) then
			cb(-1, copy_bp, { name = "Last Copied", tab = 'item' }, nil, copy_bp.multi, 0)
		end
	end
end

function ActionOrderTransfer(to_entity, slot_or_comp, amount)
	local id, target_is_construction, one_thing = slot_or_comp.id, to_entity.is_construction, (not amount or amount == 1)
	if not id then print("item no longer exists in slot") return end
	if not to_entity.exists then Notification.Error("Destination unit no longer exists") return end
	local can_transfer = (to_entity:HaveFreeSpace(id) and not target_is_construction)
	                  or (one_thing and to_entity:GetFreeSocket(id) and not target_is_construction)
	                  or (to_entity:IsWaitingForOrder(id))
	if not can_transfer then
		return Notification.Error(target_is_construction and "Construction site cannot take this item" or "Not enough free space to transfer item")
	end
	if to_entity.is_docked or slot_or_comp.owner.is_docked then
		return Notification.Error("Docked entity is unable to transfer items")
	end

	local is_comp = slot_or_comp.meta_type == "component"
	Action.SendForLocalFaction("OrderTransfer", { target = to_entity, source_slot = not is_comp and slot_or_comp, source_component = is_comp and slot_or_comp, amount = amount })
end

function ActionTransfer(to_entity, slot_or_comp, amount)
	local id, from_entity = slot_or_comp.id, slot_or_comp.owner
	if not id then print("item no longer exists in slot") return end
	if not to_entity.exists then Notification.Error("Destination unit no longer exists") return end
	local from_faction, to_faction, player_faction = from_entity.faction, to_entity.faction, Game.GetLocalPlayerFaction()
	local is_docked_transfer = (from_entity.docked_garage == to_entity or to_entity.docked_garage == from_entity)
	local valid_faction =
		(to_faction == player_faction and (from_faction == player_faction or from_entity.lootable)) or
		(from_faction == player_faction and (to_entity.lootable or to_faction:IsAlly(player_faction)))

	if amount == 0 then -- amount can also be nil (meaning transfer all)
		Notification.Error("No items available to transfer")
	elseif not valid_faction or not from_entity.is_on_map or not to_entity.is_on_map or (is_docked_transfer and from_faction ~= to_faction) then
		if IsExplorable(to_entity) then
			Notification.Error("Cannot transfer items to unsolved explorables")
		elseif IsResource(to_entity) then
			Notification.Error("Cannot transfer items to resource nodes")
		else
			Notification.Error("Unable to transfer items between these two units or buildings")
		end
	elseif is_docked_transfer then
		if slot_or_comp.meta_type == "component" then
			return -- TODO: add transfer of equipped component between docked and garage
		elseif not to_entity:HaveFreeSpace(id) and not to_entity:IsWaitingForOrder(id, true) then
			return Notification.Error("Not enough free space to transfer item")
		else
			Action.SendForEntity("DockedSlotTransfer", from_entity, { target = to_entity, source_slot = slot_or_comp, amount = amount})
		end
	else
		ActionOrderTransfer(to_entity, slot_or_comp, amount)
	end
end

function GetEntityName(entity)
	return entity.has_extra_data and NOLOC(entity.extra_data.name) or entity.visual_def.explorable_name or entity.def.name or "Unnamed"
end

local comp_race_image<const> = {
	robot = "component_bg_robot",
	alien = "component_bg_alien",
	human = "component_bg_human",
	blight = "component_bg_blight",
	virus = "component_bg_virus",
}
function GetComponentRaceBG(race)
	return race and comp_race_image[race] or "component_bg"
end

function LocationBlockedByBlight(area, errmsg, entity)
	-- check if its in the blight
	if Map.GetBlightnessDelta(area, -1) >= 0 then -- or Map.GetSave().dust_storm
		if (entity and entity.faction or Game.GetLocalPlayerFaction()).has_blight_shield then return end
		if entity and entity.has_blight_shield then return end
		if errmsg then Notification.Error(L("Triangulation failure, interference too high, %s", errmsg), 500) end -- Interference too high
		return true
	end
end

function IsShowNotification(notification_type)
	local hidden_notifications = Game.GetProfile().hidden_notifications
	return not hidden_notifications or not hidden_notifications[notification_type]
end

function ArrayContains(arr, val)
	if not arr then return end
	for _,v in ipairs(arr) do
		if v == val then return true end
	end
end

local attachment_sizenums<const> = { Internal = 1, Small = 2, Medium = 3, Large = 4 }
function GetAttachmentSize(a)
	return attachment_sizenums[a] or 5
end

function PlayCutsceneCamera(cutscene, prevent_abort, custom_cb)
	if Action.IsReplayPlayback() and Action.GetReplaySpeed() ~= 1 then return end
	local start_cam_pos, start_cam_trg = View.GetCamera3DPosition()
	local hiddenwidgets, talkinghead, n, p2, t2, p1, t1, cnvs = {}, UI.FindWidgetWithTag("TalkingHead"), 0, start_cam_pos, start_cam_trg
	local old_selection = View.GetSelectedEntities()
	View.SelectEntities() -- hide selection rings
	DisableHoverEntity()
	Quickview_SetMapOverlayActive(false)
	local function endCutScene(wait)
		if cnvs.barwdt < 95 or cnvs.opacity then return end -- don't allow aborting too early or multiple times
		n, p2, t2, p1, t1 = #cutscene+4, start_cam_pos, start_cam_trg, View.GetCamera3DPosition()
		cnvs:TweenFromTo("opacity", 1.0, 0.0, wait and 800 or 250, wait or 0)
		cnvs:TweenFromTo("f", 0, 1, wait and 800 or 250, wait or 0, 'InOutSine', function()
			View.SetCamera3DPosition(start_cam_pos, start_cam_trg)
			EnableHoverEntity()
			Quickview_SetMapOverlayActive(true)
			for w,old_hidden in pairs(hiddenwidgets) do
				if w:IsValid() then w.hidden = old_hidden and nil end -- restore as false or nil
			end
			View.SelectEntities(old_selection)
			Input.ClearInputProcessor()
			cnvs:RemoveFromParent()
		end)
	end
	Input.SetInputProcessor(function(key_name, is_down, axis)
		if prevent_abort then return end
		if not axis and key_name:find("MOUSEBUTTON") then return true end
		if not is_down and not axis and not key_name:find("MOUSEBUTTON") then endCutScene() end
	end)

	cnvs = UI.AddLayout('<Canvas fill=true><Image dock=top-fill height={barwdt} color=black/><Image dock=bottom-fill height={barwdt} color=black/><Text text="Press any key to resume control" style=notify_info opacity={txtopa} dock=bottom margin_bottom=40 hidden={hidetxt}/></Canvas>', {
		every_frame_update = function(c)
			-- hide any root widgets including ones that are newly opening during the cutscene (like an entity getting recreated causing a new frameview to show)
			for _,w in ipairs(UI.GetRootWidgets()) do
				if w ~= c and w ~= talkinghead and not w.hidden then w.hidden, hiddenwidgets[w] = true, w.hidden == nil end -- remember if false or nil
			end

			local f = math.min(1, math.max(0, c.f))
			local pos = { p1.x + (p2.x - p1.x) * f, p1.y + (p2.y - p1.y) * f, p1.z + (p2.z - p1.z) * f }
			local trg = { t1.x + (t2.x - t1.x) * f, t1.y + (t2.y - t1.y) * f, t1.z + (t2.z - t1.z) * f }
			if custom_cb then custom_cb(n, f, pos, trg, cnvs) end
			View.SetCamera3DPosition(pos, trg)
		end,
		on_mouse_button_up = not prevent_abort and function() endCutScene() end,
		hidetxt = prevent_abort,
	})
	cnvs:TweenFromTo("barwdt", 0, 100, 1000)
	cnvs:TweenFromTo("txtopa", 0, 0.3, 1000)

	local function advance()
		p2, t2, p1, t1 = cutscene[n+1], cutscene[n+2], p2, t2
		if not t2 then endCutScene(1000) return end
		cnvs:TweenFromTo("f", 0, 1, n == 0 and 800 or cutscene[n], n == 0 and 800 or 100, 'InOutSine', advance)
		n = n + 3
	end
	advance()
end

function SelectEntity(entity, mousebtn, no_append)
	if mousebtn == 'RIGHTMOUSEBUTTON' then
		View.JumpCameraToEntities(entity)
	elseif not no_append and (Input.IsShiftDown() or Input.IsControlDown()) then
		local entities = View.GetSelectedEntities() or {}
		if View.IsSelectedEntity(entity) then
			for i,e in ipairs(entities) do if e == entity then table.remove(entities, i) break end end
		else
			entities[#entities+1] = entity
		end
		View.SelectEntities(entities)
	elseif View.IsSelectedEntity(entity, true) then
		View.JumpCameraToEntities(entity)
	else
		View.SelectEntities(entity)
	end
end

function UpdateChineseLinks()
	local str = UI.GetLanguageCode()
	local wikilink = UI.FindWidgetWithProperty("id", "wikilink")
	local chatlink = UI.FindWidgetWithProperty("id", "chatlink")

	if str == 'zh' then -- zh_tw
		wikilink.site = 'GS_WIKI'
		chatlink.site = 'QQ'
		chatlink.image = "Main/textures/logo/gswiki_logo.png"
	else
		chatlink.site = 'DISCORD'
		chatlink.image = "Main/textures/logo/discord_logo.png"
		wikilink.site = 'WIKI'
	end
end

function UIMsg.OnLanguageChanged()
	UpdateChineseLinks()
end
