local package = ...

-- files loaded when mod is initializing
package.includes = {
	"utilities.lua",
	"widgets.lua",
	"Skin.lua",
	"Effects.lua",
	"Reg.lua",
	"ItemSlot.lua",
	"Notification.lua",
	"TextChat.lua",
	"SideBar.lua",
	"DefinitionTooltip.lua",
	"SocketList.lua",
	"Inventory.lua",
	"InGameMenu.lua",
	"LoadSave.lua",
	"Codex.lua",
	"Tech.lua",
	"Program.lua",
	"behavior_guides.lua",
	"RegisterSelection.lua",
	"BuildView.lua",
	"FrameView.lua",
	"Explorable.lua",
	"minigame/",
	"Faction.lua",
	"Library.lua",
	"TalkingHead.lua",
	"ReplayPlayer.lua",
	"MapOverlay.lua",
	"Options.lua",
	"HoverEntity.lua",
	"ResourceBar.lua",
	"ShortcutBar.lua",
	"Music.lua",
	"viruspopup.lua",
	"Challenges.lua",
	"BlueprintEditor.lua",
	"LinkEditor.lua",
}

-- called when mod is initializing
function package:init_ui()
	-- setup local profile table
	local profile = Game.GetProfile()
	if type(profile.options) ~= "table" then profile.options = {} end
	if type(profile.library) ~= "table" then profile.library = {} end
	Game.SetColorMapping(profile.options.colorblind_mode or "normal")
end

function UIMsg.OnSetup(local_faction)
	-- Globally always open UI elements
	UI.AddLayout("SideBar")
	UI.AddLayout("ResourceBar")
	UI.AddLayout("MapOverlay", -1)
	UI.AddLayout("TextChat", 2)
	if Action.IsReplayPlayback() then UI.AddLayout("ReplayPlayer", 9) end

	local profile = Game.GetProfile()
	if (profile.blueprints or profile.behaviors) and LibraryUpgradeOldProfile then LibraryUpgradeOldProfile() end

	local_faction:RunUI("OnFactionUpdateBlightfog", local_faction)
	if local_faction.extra_data.notify_destroy then Action.SendForLocalFaction("LoginNotifyDestroy") end
end

function UIMsg.OnFactionUpdateBlightfog(local_faction)
	local extra = local_faction.extra_data
	local newfog = extra.blight_fog ~= nil and extra.blight_fog or 0.0
	View.SetPostProcess("BlightVisibility", newfog)
end

function UIMsg.OnLocalFactionChanged(old_faction, new_faction)
	UI.Run("OnFactionUpdateBlightfog", new_faction)
	if new_faction.extra_data.notify_destroy then Action.SendForLocalFaction("LoginNotifyDestroy") end
end

local gameOverDialog
function UIMsg.OnGameOver()
	if gameOverDialog then return end
	local is_multiplayer = Game.GetNetMode() ~= "offline"
	gameOverDialog = UI.AddLayout('<ConfirmDialog title="Game Over" ok_text="Start Over"/>', {
		body        = is_multiplayer and "Do you want to start over?\n\nUse the menu to leave the game or switch to a different player faction." or "Do you want to start over or leave the game and go back to the main menu?",
		cancel_text = is_multiplayer and "Dismiss" or "Leave Game",
		cancel = function()
			if is_multiplayer then
				gameOverDialog:RemoveFromParent()
				gameOverDialog = nil
			else
				Game.EndGame()
			end
		end,
		ok = function()
			Action.SendForLocalFaction("RespawnPlayerFaction")
			gameOverDialog:RemoveFromParent()
			gameOverDialog = nil
		end,
	}, 99)
end

function UIMsg.OnFactionRespawn(faction)
	if gameOverDialog then
		gameOverDialog:RemoveFromParent()
		gameOverDialog = nil
	end
	UI.Run("OnFactionUpdateBlightfog", faction)
end

local function FilterCombatEntities(entities, x, y, target)
	local pfac = Game.GetLocalPlayerFaction()
	local in_blight, have_powered_down, have_turret = (target and Map.GetBlightnessDelta(target) >= 0) or (x and Map.GetBlightnessDelta(x, y) >= 0)
	for i=#entities,1,-1 do
		local e, exclude = entities[i]
		if not e.exists or e.faction ~= pfac or e.is_construction or e.register_count == 0 then
			exclude = true -- exclude non interactable, non movable entities
		elseif in_blight and target and LocationBlockedByBlight(target, "cannot lock on to target inside the blight", e) then
			return
		elseif in_blight and not target and LocationBlockedByBlight({x,y}, "cannot move into the blight", e) then
			return
		elseif not target and e.powered_down then
			if not have_powered_down then Notification.Error("Cannot move powered down unit") end
			exclude, have_powered_down = true, true -- exclude shut down
		end

		if exclude then
			entities[i] = entities[#entities]
			entities[#entities] = nil
		elseif not have_turret and e:FindComponent("c_turret", true) then
			have_turret = true
		end
	end
	if have_turret then return true end
	--Notification.Error("No combat unit selected")
end

local attack_move_down, attack_move_show_help
Input.BindAction("AttackMove", "Pressed", function()
	local entities = View.GetSelectedEntities()
	if not entities then return end
	if not FilterCombatEntities(entities) then return end

	local function on_accept()
		attack_move_show_help = false
		if not attack_move_down then View.StopCursor() end -- stop cursor
		local x, y = View.GetHoveredTilePosition()
		local target = View.GetHoveredEntity(FF_FOUNDATION|FF_WALL|FF_GATE|FF_CONSTRUCTION|FF_RESOURCE|FF_OPERATING) or Map.GetEntityAt(x, y, FF_FOUNDATION|FF_WALL|FF_GATE|FF_CONSTRUCTION|FF_RESOURCE|FF_OPERATING)
		if not FilterCombatEntities(entities, x, y, target) then return end
		if not target then Notification.Error("No target for forced attack") return end
		Action.SendForLocalFaction("AttackMove", { target = target, solo = #entities == 1 and entities[1] or nil, group = #entities > 1 and entities or nil })
		UI.PlaySound("fx_ui_MOUSE_CLICK")
	end
	local function on_abort(is_right_click)
		if not is_right_click then attack_move_down, attack_move_show_help = false, false return end
		attack_move_show_help = false
		if attack_move_down then View.StartCursorChooseLocation(on_accept, on_abort) end -- keep cursor
		local x, y = View.GetHoveredTilePosition()
		if not FilterCombatEntities(entities, x, y) then return end
		Action.SendForLocalFaction("AttackMove", { x = x, y = y, solo = #entities == 1 and entities[1] or nil, group = #entities > 1 and entities or nil })
		UI.PlaySound("fx_ui_MOUSE_CLICK")
	end
	View.StartCursorChooseLocation(on_accept, on_abort)
	attack_move_down, attack_move_show_help = true, true
end)

Input.BindAction("AttackMove", "Released", function()
	if not attack_move_down then return end
	attack_move_down = false
	if attack_move_show_help then
		local entities = View.GetSelectedEntities()
		for i=#entities,1,-1 do
			if IsBot(entities[i]) then
				Notification.Warning('<Key action="SelectAction"/> - Force Attack\n<Key action="ExecuteAction"/> - Attack Move')
				return
			end
		end
		Notification.Warning('<Key action="SelectAction"/> - Force Attack')
	else
		View.StopCursor()
	end
end)

function UIMsg.OnExecuteAction(entities, target, x, y)
	local pfac = Game.GetLocalPlayerFaction()
	if target and target.faction == pfac then
		local show_menu = #entities == 0
		for i=#entities,1,-1 do if entities[i] == target then show_menu = true break end end
		if show_menu then Frameview_OpenContextMenu(#entities > 1 and entities or target, nil, target) return end
	end
	if #entities == 0 then return end

	if target and Input.IsAltDown() then target = nil end -- force move
	if target and target.def.prevent_goto then return end
	local set_store, set_queue = Input.IsControlDown(), Input.IsShiftDown()
	local in_blight = (target and Map.GetBlightnessDelta(target) or Map.GetBlightnessDelta(x, y)) >= 0
	local drop_item_slots = target and IsDroppedItem(target) and target.slots
	local resource_id, can_mine = target and IsResource(target) and GetResourceHarvestItemId(target)
	local have_powered_down, pickup_building, pickup_bot, can_pickup, new_store
	for i=#entities,1,-1 do
		local e, exclude = entities[i]
		if e.faction ~= pfac or e.is_construction or e.register_count == 0 then
			exclude = true -- exclude non interactable entry
		elseif in_blight and target and LocationBlockedByBlight(target, "cannot lock on to target inside the blight", e) then
			return
		elseif set_store then
			new_store = new_store or set_queue or e:GetRegisterEntity(FRAMEREG_STORE) ~= target
		elseif drop_item_slots then
			if IsBuilding(e) and not e.has_crane then
				exclude, pickup_building = true, true -- exclude building
			else
				pickup_bot = true
				for _,s in ipairs(drop_item_slots) do
					if s.id and (e:HaveFreeSpace(s.id) or e:GetFreeSocket(s.id)) then
						can_pickup = true
						break
					end
				end
			end
		elseif in_blight and not target and LocationBlockedByBlight({x,y}, "cannot move into the blight", e) then
			FactionCount("try_enter_blight", true)
			return
		elseif not target and not IsBot(e) then
			exclude = true -- exclude building
		elseif not target and e.powered_down then
			if not have_powered_down then Notification.Error("Cannot move powered down unit") end
			exclude, have_powered_down = true, true -- exclude shut down
		end

		if set_queue and e:RegisterIsLink(FRAMEREG_GOTO) then
			return Notification.Error("Cannot queue action while Goto register is linked")
		elseif target and not set_store and not set_queue and e:RegisterIsLink(FRAMEREG_GOTO) then
			return Notification.Error("Cannot interact while Goto register is linked")
		end

		if exclude then
			entities[i] = entities[#entities]
			entities[#entities] = nil
		elseif resource_id then
			for j=1,999 do
				local miner = e:FindComponent("c_miner", true, j)
				if not miner then break end
				if miner.def:can_harvest(miner, resource_id) then can_mine = true break end
			end
		end
	end

	if pickup_bot and not can_pickup then
		return Notification.Error("No free inventory space to pick up items")
	elseif pickup_building and not pickup_bot then
		return Notification.Error("Buildings cannot pick up items directly")
	elseif #entities == 0 then
		return
	elseif resource_id and not can_mine then
		return Notification.Error(L("Cannot mine %s", data.all[resource_id].name or "Resource"))
	end

	if set_store then
		if not new_store and not target then return end
		local storereg, toggle_queue = { entity = new_store and target }, new_store and set_queue
		if     toggle_queue then Action.SendForEntities("SetQueue",    entities, { idx = -FRAMEREG_STORE, reg = storereg, toggle = true }) end
		if not toggle_queue then Action.SendForEntities("SetRegister", entities, { idx = -FRAMEREG_STORE, reg = storereg                }) end
		UI.PlaySound("fx_ui_MOUSE_CLICK")
		return Notification.Warning(new_store and target and L("Set %s as store", GetEntityName(target)) or "Cleared store")
	end

	local args = { target = target, x = not target and x or nil, y = not target and y or nil, solo = #entities == 1 and entities[1] or nil, group = #entities > 1 and entities or nil, queue = set_queue or nil }
	if FrameView_BlockGotoAction(args) then return end

	Action.SendForLocalFaction("Goto", args)
	UI.PlaySound("fx_ui_MOUSE_CLICK")
end

function UIMsg.OnAttackAction(entities, target, x, y)
	attack_move_down, attack_move_show_help = false, false
	if not entities or #entities == 0 then return end
	if not FilterCombatEntities(entities, x, y) then return end
	Action.SendForLocalFaction("AttackMove", { x = x, y = y, solo = #entities == 1 and entities[1] or nil, group = #entities > 1 and entities or nil })
	UI.PlaySound("fx_ui_MOUSE_CLICK")
end

Input.BindAction("Ping", "Pressed", function()
	UI.SendChatFaction("PlayerPing", { View.GetHoveredTilePosition() })
end)

function Chat.PlayerPing(arg, player_id)
	local x, y = arg[1], arg[2]
	View.PlayEffect("fx_ping", x, y)
	local minimap = UI.FindWidgetWithTag("Minimap")
	if minimap then minimap:AddPing(x, y, Game.IsLocalPlayer(player_id) and 'green' or 'yellow', 2000) end -- show for 2000 ms

	if Game.IsLocalPlayer(player_id) or not IsShowNotification("multiplayer_ping") then return end
	Notification.Add("ping", "info", "Pinged Here",
		L("Player <header>%S</> pinged at <header>%dx%d</>", Game.GetPlayerName(player_id), x, y),
		{ duration = 30.0, on_click = function(id) View.MoveCamera(x, y) end })
end

InputDefaultActionMappings, InputDefaultAxisMappings, InputTooltips = {}, {}, {}
local action, axis, tooltip = InputDefaultActionMappings, InputDefaultAxisMappings, InputTooltips
action.SelectAction            = { 'LEFTMOUSEBUTTON', 'GAMEPAD_FACEBUTTON_BOTTOM' }
action.ExecuteAction           = { 'RIGHTMOUSEBUTTON', 'GAMEPAD_FACEBUTTON_LEFT' }
action.DragCamera              = 'RIGHTMOUSEBUTTON'
action.RotateAction            = 'MIDDLEMOUSEBUTTON'
action.AttackAction            = 'MIDDLEMOUSEBUTTON'
action.InGameMenu              = { 'ESCAPE', 'GAMEPAD_SPECIAL_RIGHT' }
action.Build                   = { "B", 'GAMEPAD_DPAD_UP' }
action.Tech                    = { "T", 'GAMEPAD_DPAD_RIGHT' }
action.Codex                   = { "X", 'GAMEPAD_DPAD_DOWN' }
action.FactionView             = { "F", 'GAMEPAD_DPAD_LEFT' }
action.Chat                    = "K"
action.Accept                  = 'ENTER'
action.SystemIndex             = "I"
action.Library                 = "L"
action.Progress                = "O"
action.PauseGame               = 'SPACEBAR'
action.Select1                 = 'ONE'
action.Select2                 = 'TWO'
action.Select3                 = 'THREE'
action.Select4                 = 'FOUR'
action.Select5                 = 'FIVE'
action.Select6                 = 'SIX'
action.Select7                 = 'SEVEN'
action.Select8                 = 'EIGHT'
action.Select9                 = 'NINE'
action.Select0                 = 'ZERO'
action.ShortcutRowNext         = 'ALT+UP'
action.ShortcutRowPrev         = 'ALT+DOWN'
action.SelectPrevious          = 'BACKSPACE'
action.CameraHome              = 'HOME'
action.CameraReset             = 'END'
action.FactionHome             = 'CTRL+HOME'
action.CameraZero              = ""
action.HideUserInterface       = "U"
action.Camera_FollowTarget     = "N"
action.PowerInfo_Toggle        = "P"
action.CursorGrid_Toggle       = "G"
action.RotateConstructionSite  = "R"
action.Relocate                = 'PERIOD'
action.ShowPath                = "J"
action.MapOverlay              = 'TAB'
action.OverlaySettings         = "Y"
action.Map                     = "M"
action.CaptureFeedbackShot     = 'F8'
action.ToggleGamepadMouse      = 'GAMEPAD_RIGHTTHUMBSTICK'
action.SimulationStep          = 'CTRL+SPACEBAR'
action.UnitCopy                = "C"
action.UnitPaste               = "V"
action.QuickAction             = "E"
action.AttackMove              = "Q"
action.HoldPosition            = "H"
action.Ping                    = 'ALT+LEFTMOUSEBUTTON'

axis.CameraX                   = { 20.0, 'GAMEPAD_LEFTX',  { "D", 'RIGHT' }, { "A", 'LEFT' } }
axis.CameraY                   = { 20.0, 'GAMEPAD_LEFTY',  { "W", 'UP' },    { "S", 'DOWN' } }
axis.CameraRotate              = {  4.0, 'GAMEPAD_RIGHTX', 'INSERT',         'DELETE'      }
axis.CameraPitch               = {  4.0, 'GAMEPAD_RIGHTY', 'PAGEUP',         'PAGEDOWN'      }
axis.CameraZoom                = {  0.2, 'MOUSEWHEELAXIS', 'GAMEPAD_RIGHTSHOULDER', 'GAMEPAD_LEFTSHOULDER' }

tooltip.SelectAction           = { sort =  1, label = "Select", tooltip = "Click: Select one unit or building on the map\nDrag: Select a group of units and buildings" }
tooltip.ExecuteAction          = { sort =  2, label = "Move Unit", tooltip = "Move the selected unit(s) or give them a target" }
tooltip.DragCamera             = { sort =  3, label = "Move Camera", tooltip = "Move the camera by moving the mouse while holding down the button" }
tooltip.RotateAction           = { sort =  4, label = "Rotate Camera", tooltip = "Rotate the camera by moving the mouse while holding down the button" }
tooltip.AttackAction           = { sort =  5, label = "Attack Move", tooltip = "Move the selected combat unit(s) but attack encountered enemies" }
tooltip.UnitCopy               = { sort =  6, label = "Settings Copy", tooltip = "Copy the settings of a unit or building" }
tooltip.UnitPaste              = { sort =  7, label = "Settings Paste", tooltip = "Apply the copied settings to a unit or building, or construct a building copy" }
tooltip.AttackMove             = { sort =  8, label = "Force Attack/Attack Move", tooltip = 'Press <Key action="SelectAction"/> to force attack target\nPress <Key action="ExecuteAction"/> to move unit(s) but attack encountered enemies' }
tooltip.HoldPosition           = { sort =  9, label = "Hold Position", tooltip = "Stop movement of selected unit(s).\nLocks units with a range 1 pulse weapon component in position until issued another command." }
tooltip.QuickAction            = { sort = 10, label = "Quick Action", tooltip = "Show Link Editor\nWith Shift: Show Logistics Settings\nWith Ctrl: Toggle Shutdown\n(can also be used while nothing is selected by hovering over a unit or building)" }
tooltip.RotateConstructionSite = { sort = 11, label = "Rotate Construction Site", tooltip = "Rotates a structure" }
tooltip.Relocate               = { sort = 12, label = "Relocate", tooltip = "Relocate one or multiple buildings" }
tooltip.PauseGame              = { sort = 13, label = "Pause Game", tooltip = "Pauses the game" }
tooltip.InGameMenu             = { sort = 14, label = "In Game Menu", tooltip = "Opens the in-game menu" }
tooltip.Build                  = { sort = 15, label = "Build Menu", tooltip = "Opens the building menu" }
tooltip.Tech                   = { sort = 16, label = "Tech Tree", tooltip = "Opens the tech tree menu" }
tooltip.Codex                  = { sort = 17, label = "Codex", tooltip = "Opens the codex menu" }
tooltip.FactionView            = { sort = 18, label = "Control Center", tooltip = "Opens the Control Center menu" }
tooltip.Library                = { sort = 19, label = "Library", tooltip = "Opens the library menu" }
tooltip.Progress               = { sort = 20, label = "Progress", tooltip = "Opens the progress menu" }
tooltip.Accept                 = { sort = 21, label = "Accept", tooltip = "Accepts current dialogue"}
tooltip.SystemIndex            = { sort = 22, label = "System Index", tooltip = "Opens a separate window to view information on known technology" }
tooltip.Chat                   = { sort = 23, label = "Chat", tooltip = "Opens the Chat window" }
tooltip.MapOverlay             = { sort = 24, label = "Map Overlay", tooltip = "Toggle showing of map overlay information" }
tooltip.OverlaySettings        = { sort = 25, label = "Overlay Settings", tooltip = "Opens the Overlay Settings menu" }
tooltip.Map                    = { sort = 26, label = "Map", tooltip = "Toggle full screen map" }
tooltip.CameraHome             = { sort = 27, label = "Set Camera Home", tooltip = "Repositions camera to the main base" }
tooltip.CameraReset            = { sort = 28, label = "Reset Camera", tooltip = "Reset Camera rotation and zoom level to default" }
tooltip.FactionHome            = { sort = 29, label = "Set Faction Home", tooltip = "Sets the faction home unit or building. Used for jumping the camera Home." }
tooltip.CameraZero             = { sort = 30, label = "Set Camera Zero", tooltip = "Repositions camera to coordinate 0,0" }
tooltip.PowerInfo_Toggle       = { sort = 31, label = "Toggle Power Grid", tooltip = "Toggles on/off the power grid" }
tooltip.CursorGrid_Toggle      = { sort = 32, label = "Toggle Grid Cursor", tooltip = "Toggles on/off the grid cursor" }
tooltip.ShowPath               = { sort = 33, label = "Show Path", tooltip = "Shows the path of a moving unit" }
tooltip.Camera_FollowTarget    = { sort = 34, label = "Set Camera Follow Target", tooltip = "Repositions camera to follow the selected target" }
tooltip.SelectPrevious         = { sort = 35, label = "Select Previous", tooltip = "Switch to previous selection" }
tooltip.Select1                = { sort = 36, label = "Group 1",  tooltip = "Select shortcut group 1" }
tooltip.Select2                = { sort = 37, label = "Group 2",  tooltip = "Select shortcut group 2" }
tooltip.Select3                = { sort = 38, label = "Group 3",  tooltip = "Select shortcut group 3" }
tooltip.Select4                = { sort = 39, label = "Group 4",  tooltip = "Select shortcut group 4" }
tooltip.Select5                = { sort = 40, label = "Group 5",  tooltip = "Select shortcut group 5" }
tooltip.Select6                = { sort = 41, label = "Group 6",  tooltip = "Select shortcut group 6" }
tooltip.Select7                = { sort = 42, label = "Group 7",  tooltip = "Select shortcut group 7" }
tooltip.Select8                = { sort = 43, label = "Group 8",  tooltip = "Select shortcut group 8" }
tooltip.Select9                = { sort = 44, label = "Group 9",  tooltip = "Select shortcut group 9" }
tooltip.Select0                = { sort = 45, label = "Group 10", tooltip = "Select shortcut group 10" }
tooltip.ShortcutRowNext        = { sort = 46, label = "Next Shortcut Group Row" }
tooltip.ShortcutRowPrev        = { sort = 47, label = "Previous Shortcut Group Row" }
tooltip.Ping                   = { sort = 48, label = "Ping",     tooltip = "Ping a location to notify other players in your faction" }
tooltip.HideUserInterface      = { sort = 49, label = "Hide User Interface", tooltip = "Toggles on/off the user interface" }
tooltip.CaptureFeedbackShot    = { sort = 50, label = "Feedback with Screenshot", tooltip = "Capture the screen and open the form to send feedback to the developers" }
tooltip.ToggleGamepadMouse     = { sort = 51, label = "Toggle Gamepad Mouse", tooltip = "Gives controllers added mouse support" }
tooltip.SimulationStep         = { sort = 52, label = "Simulation Stepping", tooltip = "Run one simulation tick then pause the game again" }
tooltip.CameraY                = { sort =  1, label_var = "Move Camera Up/Down",    label_pos = "Move Camera Up",      label_neg = "Move Camera Down",   }
tooltip.CameraX                = { sort =  2, label_var = "Move Camera Right/Left", label_pos = "Move Camera Right",   label_neg = "Move Camera Left",   }
tooltip.CameraRotate           = { sort =  3, label_var = "Rotate Camera",          label_pos = "Rotate Camera Right", label_neg = "Rotate Camera Left", }
tooltip.CameraPitch            = { sort =  4, label_var = "Pitch Camera",           label_pos = "Pitch Camera Down",   label_neg = "Pitch Camera Up", }
tooltip.CameraZoom             = { sort =  5, label_var = "Zoom Camera" ,           label_pos = "Zoom Camera In",      label_neg = "Zoom Camera Out",    }

-- left click
Input.BindAction("SelectAction", "Pressed", 'SelectActionDown')
Input.BindAction("SelectAction", "Released", 'SelectActionUp')

-- right click
Input.BindAction("ExecuteAction", "Pressed", 'ExecuteActionDown')
Input.BindAction("ExecuteAction", "Released", 'ExecuteActionUp')
Input.BindAction("DragCamera", "Pressed", 'DragCameraDown')
Input.BindAction("DragCamera", "Released", 'DragCameraUp')

-- middle click
Input.BindAction("AttackAction", "Pressed", 'AttackActionDown')
Input.BindAction("AttackAction", "Released", 'AttackActionUp')
Input.BindAction("RotateAction", "Pressed", 'RotateCameraDown')
Input.BindAction("RotateAction", "Released", 'RotateCameraUp')

Input.BindAction("Accept", "Pressed", 'UIAccept')
Input.BindAction("InGameMenu", "Pressed", 'UICancel')
Input.BindAction("CaptureFeedbackShot", "Released", 'CaptureFeedbackShot')
Input.BindAction("ToggleGamepadMouse", "Released", 'ToggleGamepadMouse')

UnitCopyPaste = {}

local function ValidBlueprintEntity(entity, is_multi) -- matches BlueprintValidateRules
	local def = GetBuiltFrameDef(entity, true)
	if is_multi then return def and def.type ~= "Foundation" and def.visual and def.construction_recipe end
	return def and def.type ~= "Foundation"
end

function UnitCopyPaste.Copy(entity_or_entities)
	local entities, hover = entity_or_entities and (type(entity_or_entities) == "table" and entity_or_entities or { entity_or_entities })
	if not entities then
		hover = View.GetHoveredEntity()
		entities = hover and not View.IsSelectedEntity(hover) and { hover } or View.GetSelectedEntities()
	end

	local pfac, make_multi_bp, hover_invalid = Game.GetLocalPlayerFaction(), (entities and #entities > 1)
	for i=entities and #entities or 0,1,-1 do
		local e = entities[i]
		if e.faction ~= pfac or not ValidBlueprintEntity(e, make_multi_bp) then
			if e == hover then hover_invalid = true end
			entities[i] = entities[#entities]
			entities[#entities] = nil
		end
	end

	if not entities or #entities == 0 or hover_invalid or (make_multi_bp and #entities == 1) then
		if make_multi_bp and hover then return UnitCopyPaste.Copy(hover) end -- try solo copy
		return Notification.Warning("Must focus unit or building to copy settings from")
	end

	local bp = MakeBlueprintFromEntity(entities, true)
	if not bp then return Notification.Warning("Unable to copy settings") end
	Tool.SetClipboard(bp, 'B')
	UnitCopyPaste.last_valid_item = bp
	if #entities == 1 then
		UnitCopyPaste.last_rotation = entities[1].rotation
		Notification.Warning(L("Copied settings from %s", GetEntityName(entities[1])))
	else
		UnitCopyPaste.last_rotation = nil
		Notification.Warning(L("Copied blueprint for %d constructions", #entities))
	end
end

function UnitCopyPaste.ClipboardCopyReference(entity)
	Notification.Warning("Copied register value")
	return { entity = entity }, 'R'
end

function UnitCopyPaste.Paste(entities, validated_item, force_apply)
	local bp, no_entities, solo = (validated_item or UnitCopyPaste.GetItem('B')), (not entities or #entities == 0), (entities and #entities == 1 and entities[1])
	local build, frame_def, pfac = bp and (no_entities or (solo and solo.is_construction)), bp and data.frames[bp.frame], Game.GetLocalPlayerFaction()
	if build then
		if frame_def and not frame_def.production_recipe and not frame_def.construction_recipe then
			return Notification.Warning("Unit production or building construction unknown")
		elseif not FactionHasUnlockedCustomBlueprint(pfac, bp) then
			return Notification.Warning("Haven't unlocked prerequisites for construction")
		end
	elseif frame_def then
		local bot_vs_building = solo and (((frame_def.movement_speed or 0) > 0) ~= ((solo.def.movement_speed or 0) > 0))
		local confirm = not force_apply and (#entities > 1 or bot_vs_building)
		for i=#entities,1,-1 do
			if entities[i].is_construction or entities[i].faction ~= pfac then table.remove(entities, i) end
		end
		if #entities == 0 then return Notification.Warning("Settings can only be applied to your units and buildings") end
		if confirm then return ConfirmBox(L("Are you sure you want to apply the copied settings onto the selected %d units/buildings?", #entities), function() UnitCopyPaste.Paste(entities, bp, true) end) end
	else
		return
	end

	UILibraryImportBlueprint(bp, function(ibp)
		UILibraryAssignBlueprintParams(ibp, function(bpp)
			if build then
				StartBuildCursor(bpp, (bp == UnitCopyPaste.last_valid_item and UnitCopyPaste.last_rotation or 0))
			else
				Notification.Warning(#entities > 1 and L("Apply settings onto %d units/buildings", #entities) or L("Apply settings onto %s", GetEntityName(entities[1])))
				Action.SendForLocalFaction("ApplySettings", { entity = #entities == 1 and solo, entities = #entities > 1 and entities, bp = bpp })
			end
		end)
	end)
end

function UnitCopyPaste.Upgrade(entity)
	local bp = UnitCopyPaste.GetItem('B')
	if not bp then return end
	UILibraryImportBlueprint(bp, function(ibp)
		UILibraryAssignBlueprintParams(ibp, function(bpp)
			StartCustomConstruction(entity, bpp)
		end)
	end)
end

function UnitCopyPaste.GetItem(prefix_filter1, prefix_filter2)
	local item, prefix = Tool.GetClipboard()
	if prefix_filter1 and prefix ~= prefix_filter1 and (not prefix_filter2 or prefix ~= prefix_filter2) then return end
	if UnitCopyPaste.last_valid_item ~= item then
		if prefix == 'B' and not ValidateCustomBlueprint(item) then return end
		if prefix == 'C' and not ValidateCustomBehavior(item) then return end
		UnitCopyPaste.last_valid_item = item
	end
	return item, prefix
end

Input.BindAction("UnitCopy", "Pressed", function()
	if UI.IsMouseOverUI() then
		local copy_widget = UI.GetWidgetWithPropertyUnderCursor("on_clipboard_copy")
		if copy_widget then
			local item, prefix = copy_widget:SendEvent("on_clipboard_copy")
			if prefix then Tool.SetClipboard(item, prefix) UnitCopyPaste.last_valid_item = item end
		end
	else
		-- Copy setting of either hovered entity or first selected entity
		UnitCopyPaste.Copy()
	end
end)

Input.BindAction("UnitPaste", "Pressed", function()
	local copy_table, copy_prefix = UnitCopyPaste.GetItem()
	if UI.IsMouseOverUI() then
		local paste_widget = copy_prefix and UI.GetWidgetWithPropertyUnderCursor("on_clipboard_paste")
		if paste_widget then paste_widget:SendEvent("on_clipboard_paste", copy_table, copy_prefix) end
	else
		-- If mouse is over UI or over selected entity, paste settings onto selected entities
		-- If mouse hovers over an entity, paste settings onto hovered entity
		-- Otherwise create a copy building construction if a building was copied
		if copy_prefix ~= 'B' then return Notification.Warning("Need to copy settings first") end
		local hover = View.GetHoveredEntity()
		local entities = ((not hover and UI.IsMouseOverUI()) or (hover and View.IsSelectedEntity(hover))) and View.GetSelectedEntities()
		if entities and #entities == 1 then hover = entities[1] entities = nil end
		UnitCopyPaste.Paste(entities or {hover}, copy_table)
	end
end)

Input.BindAction("CameraHome", "Released", function()
	local loc = Game.GetLocalPlayerFaction().home_location
	View.MoveCamera(loc.x, loc.y, false)
end)

Input.BindAction("CameraReset", "Pressed", function() View.ResetCamera() end)

Input.BindAction("FactionHome", "Released", function()
	local entities = View.GetSelectedEntities()
	if entities and #entities == 1 and entities[1].faction == Game.GetLocalPlayerFaction() then
		Action.SendForLocalFaction("SetHomeEntity", { e = entities[1] })
		Notification.Info("Set Faction Home Location")
	end
end)

Input.BindAction("Chat", "Pressed", function() OpenMainWindow("TextChat") end)
Input.BindAction("Build", "Released", function() OpenMainWindow("BuildView") end)
Input.BindAction("Tech", "Released", function() OpenMainWindow("Tech") end)
Input.BindAction("Map", "Released", function() OpenMainWindow("ScreenMap") end)
Input.BindAction("Codex", "Released", function() OpenMainWindow("Codex") end)
Input.BindAction("FactionView", "Released", function() OpenMainWindow("Faction") end)
Input.BindAction("Library", "Released", function() OpenMainWindow("Library") end)
Input.BindAction("Progress", "Released", function() OpenMainWindow("ProgressView") end)

function UIMsg.OnMapCancel()
	OpenMainWindow("InGameMenu")
end

Input.BindAction("HoldPosition", "Released", function()
	local entities, pfac = View.GetSelectedEntities(), Game.GetLocalPlayerFaction()
	if not entities then return end
	for i=#entities,1,-1 do
		local e = entities[i]
		if e.faction ~= pfac or e.is_construction or e.register_count == 0 or not IsBot(e) or (not e.is_moving and not e:FindComponent("c_turret", true)) then
			-- exclude non interactable, non movable entities and ones that either don't move or don't have a weapon
			entities[i] = entities[#entities]
			entities[#entities] = nil
		end
	end
	if #entities == 0 then
		Notification.Error("No combat unit selected to hold position")
		return
	end

	Action.SendForLocalFaction("HoldPosition", { solo = #entities == 1 and entities[1] or nil, group = #entities > 1 and entities or nil })
	UI.PlaySound("fx_ui_MOUSE_CLICK")
end)

Input.BindAction("HideUserInterface", "Released", function()
	UI.SetUIHidden()
end)

Input.BindAction("SelectPrevious", "Released", function() View.SelectPreviousEntities() end)
Input.BindAction("CameraZero", "Released", function() View.MoveCamera(0, 0) end)

function UIMsg.OnSetupInputMapping()
	-- Bind remaining actions defined in included files
	Input.BindAction("Camera_FollowTarget", "Released", Quickview_ToggleFollow)
	Input.BindAction("ShowPath", "Released", Quickview_ToggleMovePaths)
	Input.BindAction("CursorGrid_Toggle", "Released", Quickview_ToggleGrid)
	Input.BindAction("PowerInfo_Toggle", "Released", Quickview_TogglePower)
	Input.BindAction("MapOverlay", "Pressed", Quickview_ToggleMapOverlay)
	Input.BindAction("OverlaySettings", "Pressed", Quickview_OpenOverlaySettings)

	-- Currently not remappable
	Input.AddAxisMapping("GamepadCursorX", 'GAMEPAD_RIGHTX', 1.0)
	Input.AddAxisMapping("GamepadCursorY", 'GAMEPAD_RIGHTY', 1.0)

	---- Debug keys
	--local s = 0
	--Input.AddActionMapping("Debug_StaticAdd", "ADD")
	--Input.AddActionMapping("Debug_StaticDel", "SUBTRACT")
	--Input.BindAction("Debug_StaticAdd", "Released", function() s = s + 0.05 View.SetPostProcess("ScreenStaticAmount", s) end)
	--Input.BindAction("Debug_StaticDel", "Released", function() s = s - 0.05 View.SetPostProcess("ScreenStaticAmount", s) end)
end

function UIMsg.OnMultiplayerJoin(player_id)
	if not IsShowNotification("joining_leaving") then return end

	local player_info = Game.GetPlayerById(player_id)
	Notification.Add("player_" .. player_id, "info", "Player Joined",
		L("Name: <header>%S</> - Faction: <header>%S</>", player_info.name, Map.GetFaction(player_info.faction_id).name),
		{ duration = 30.0 })
end

function UIMsg.OnMultiplayerLeave(player_id)
	if not IsShowNotification("joining_leaving") then return end

	local player_info = Game.GetPlayerById(player_id)
	Notification.Add("player_" .. player_id, "info", "Player Left",
		L("Name: <header>%S</> - Faction: <header>%S</>", player_info.name, Map.GetFaction(player_info.faction_id).name),
		{ duration = 30.0 })
end

function UIMsg.OnMultiplayerChangeFaction(player_id, old_faction, new_faction)
	if not IsShowNotification("switching_faction") then return end

	local player_info = Game.GetPlayerById(player_id)
	Notification.Add("player_" .. player_id, "info", "Player Changed Faction",
		L("Name: <header>%S</> - Old Faction: <header>%S</> - Faction: <header>%S</>", player_info.name, old_faction.name, new_faction.name),
		{ duration = 30.0 })
end

function UIMsg.OnFactionTrustChange(other_faction, new_trust, old_trust)
	Notification.Add("trustchange" .. other_faction.id, "info", "Faction Settings", L("%S changed you from %s to %s", other_faction.name, old_trust, new_trust),
		{ on_click = function() OpenMainWindow("Faction", { show_tab = 'faction' }) return true end })
	if other_faction.id == "alien" and new_trust == 'ENEMY' then
		Game.GetLocalPlayerFaction():UnlockAchievement("ALIEN_TRUST")
	end
end

local servercatchup
function UIMsg.OnServerCatchUp(ticks)
	if not servercatchup and ticks == 0 then return end
	servercatchup = servercatchup or UI.AddLayout([[<Modal><Box bg=popup_box_bg blur=true dock=center padding=24><VerticalList child_padding=48>
			<Text text="Multiplayer Session" size=24 textalign=center/>
			<Text text="You are currently catching up with the game simulation on the server." size=14 textalign=center/>
			<Progress id=prog progress=0 height=40/>
			<Text id=ticktxt size=14 textalign=center/>
			<Button text="Disconnect" on_click={disconnect}/>
		</VerticalList></Box></Modal>]], {
		disconnect = function()
			ConfirmBox("Are you sure you want to abort the scenario and return to the main menu?", function()
				Game.EndGame()
			end)
		end,
	}, 99)
	if ticks > 0 then
		servercatchup.max_ticks = math.max(servercatchup.max_ticks or 1, ticks)
		servercatchup.prog.progress = (servercatchup.max_ticks - ticks) / servercatchup.max_ticks
		servercatchup.ticktxt.text = L("You are %d ticks behind the server", ticks)
	else
		servercatchup:RemoveFromParent()
		servercatchup = nil
	end
end

function UIMsg.OnAutoSave(slot_name)
	Game.GetProfile().latest_save = slot_name
	Game.GetProfile().latest_session_settings = Game.GetHostSessionSettings()
	if not IsShowNotification("auto_save") then return end
	Notification.Add("autosave", "info", "Auto Save", "Game was automatically saved", { duration = 5.0, nosound = true })
end

local attackstack = {}
local function JumpToLastAttackingEntity()
	local atk = table.remove(attackstack)
	if not atk then return end
	if atk[1].exists then
		View.JumpCameraToEntities(atk[1])
	else
		View.MoveCamera(atk[2].x, atk[2].y, false)
	end
end

function UIMsg.OnAttack(entity, damager)
	if IsFoundation(entity) then return end
	if damager and damager == entity and entity:FindComponent("c_virus") then
		local svent = damager
		Notification.Add("got_virus", "Main/textures/tech/virus.png", "Virus Detected", "A virus has been detected in the network", {
			on_click = function()
				View.JumpCameraToEntities(svent)
			end,
			duration = 120.0,
		})
	end

	if #attackstack == 0 then
		Notification.Error("WARNING: TAKING DAMAGE !!!")
	end

	-- if its not already in the list
	local loc = entity.location
	for _,v in ipairs(attackstack) do
		if v[1] == entity then v[2] = loc return end
	end
	attackstack[#attackstack+1] = { entity, loc }

	if not IsShowNotification("attack") then return end

	Notification.Add("attacked", entity.def.texture or "info", "Attack", L("You are taking damage (%d)", #attackstack), {
		on_click = function()
			JumpToLastAttackingEntity()
			if #attackstack == 0 then
				return true
			end
			-- update number of attack number?
			Notification.UpdateText("attacked", L("You are under attack (%d)", #attackstack))
		end,
		on_clear = function() attackstack = {} end,
		duration = 120.0,
	})
end

-- only called for local faction for the UI callback
local destroystack = {}
local function NotifyAddDeath(frame_id, x, y)
	--destroystack[#destroystack+1], destroystack[#destroystack+2] = x, y
	local def = data.all[frame_id]
	destroystack[#destroystack+1] = { def = def, x = x, y = y}
	Notification.Add("death", def and def.texture or "info", "Destroyed", L((def.movement_speed or 0) > 0 and "You have lost a unit (%d)" or "You have lost a building (%d)", #destroystack), {
		on_click = function()
			local destroyed, def = table.remove(destroystack)
			View.MoveCamera(destroyed.x, destroyed.y, false)
			if #destroystack == 0 then
				return true
			end
			if #destroystack then
				def = destroystack[#destroystack].def
			end
			-- update number of attack number?
			--Notification.UpdateText("death", L("You have lost a unit (%d)", #destroystack // 2))
			Notification.UpdateAll("death", {
				text = L("You have lost a unit (%d)", #destroystack),
				icon = def and def.texture or "info",
			})
		end,
		on_clear = function() destroystack = {} end,
		--duration = 120.0,
	})
end

function UIMsg.OnDeath(entity, damager)
	if not IsFoundation(entity) then NotifyAddDeath(entity.id, entity:GetLocationXY()) end
end

function FactionAction.LoginNotifyDestroy(faction)
	local ed = faction.extra_data
	local notify_destroy = ed.notify_destroy
	if not notify_destroy then return end
	faction:RunUI(function()
		for _,v in ipairs(notify_destroy) do
			NotifyAddDeath(v[1], v[2], v[3])
		end
	end)
	ed.notify_destroy = nil
end

function Delay.ReplaceBuildingConstruction(arg)
	local faction, entity, bp = arg.faction, arg.entity, arg.custom_blueprint
	arg.start_paused, arg.faction, arg.entity = not arg.unpaused, nil, nil
	arg.custom_blueprint = bp.dependencies and ImportBlueprint(faction, bp, "Imported", true) or bp
	local placed = FactionAction.PlaceConstruction(faction, arg)
	if placed then
		faction:UpdateEntityInRegisters(entity, placed)
		faction:RunUI("OnEntityRecreate", entity, placed, true)
	end
end

function MapMsg.OnPlayerEntityDeath(entity, damager)
	local faction, def = entity.faction, entity.def
	if (def.movement_speed or 0) == 0 and def.construction_recipe and def.visual and def.type ~= "Foundation" then
		local mode = faction.extra_data.replace_buildings
		local building_bp = mode ~= 0 and faction:IsUnlocked(entity.id) and MakeBlueprintFromEntity(entity)
		if building_bp then
			Map.Delay("ReplaceBuildingConstruction", 1, { faction = faction, entity = entity, custom_blueprint = building_bp, locations = { entity.placed_location }, rotation = entity.rotation, unpaused = (mode == 2 or nil) })
		end
	end
	if not faction.has_logged_in_player and def.type ~= "Foundation" then
		local ed, x, y = faction.extra_data, entity:GetLocationXY()
		local notify_destroy = ed.notify_destroy
		if not notify_destroy then notify_destroy = {} ed.notify_destroy = notify_destroy end
		notify_destroy[#notify_destroy+1] = { entity.id, x, y }
	end
end

function UIMsg.NotifyHarvestedRich(item_def, entity, x, y)
	if not IsShowNotification("resource") then return end
	Notification.Add("harvested_" .. entity.key, "info", "Resource", L("Rich %s resource depleted", item_def.name),
		{ duration = 20.0, on_click = function() View.MoveCamera(x, y) return true end })
end

function UIMsg.NotifyAnomaly(entity, detected)
	if not IsShowNotification("anomaly") then return end
	Notification.Add("world_events", "warning", detected and "Instability Warning" or "Anomaly Detected", detected and "Dense Anomaly Clusters Detected" or "Investigate the Anomaly", {
		tooltip = "World Event",
		duration = 60.0,
		on_click = entity and function() View.JumpCameraToEntities(entity) end,
	})
end

function UIMsg.NotifyDust(msg)
	Notification.Warning(msg)
	if not IsShowNotification("blight_storm_warning") then return end
	Notification.Add("world_events", "warning", "World Event", msg, { duration = 60.0 })
end
