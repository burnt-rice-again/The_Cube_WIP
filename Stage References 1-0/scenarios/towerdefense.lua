local package = ...

function package:setup_scenario(settings)
	settings.pregenerated_noise = "Main/scenarios/maps/map_2player_defend_resimulator.tga"
	settings.allow_faction_switch = false
end

function package:get_new_player_faction_id()
	return "player_1"
end

local towers = {
	{
		components = { { "c_portable_turret", 1 } },
		frame = "f_building1x1a", -- 1M
		construction_recipe = { ingredients = { metalbar = 20 }, ticks = 1 },
	},
	{
		components = { { "c_adv_portable_turret", 1 } },
		frame = "f_building1x1a", -- 1M
		construction_recipe = { ingredients = { metalbar = 30 }, ticks = 1 },
	},
	{
		components = { { "c_photon_beam", 1 } },
		frame = "f_building1x1a", -- 1M
		construction_recipe = { ingredients = { metalbar = 50 }, ticks = 1 },
	},
	{
		components = { { "c_missile_turret", 1 } },
		frame = "f_building1x1b", -- 1L
		construction_recipe = { ingredients = { metalbar = 250 }, ticks = 1 },
	}
}

function EntityAction.UpgradeTower(entity, arg)
	local builder = Map.GetSave().storage:FindComponent("c_builder")
	if builder:PrepareConsumeProcess({ metalbar = arg.value}) then
		builder:FulfillProcess()
		entity:FindComponent("c_turret", true):Destroy()
		entity:AddComponent(arg.to)
	end
end

-- called when mod is initializing
function package:init()
	data.land_features = {}
	UIMsg:UnbindAll("OnCodexUnlocked")
	UIMsg:UnbindAll("OnTechResearch")
	UIMsg:UnbindAll("OnEntityHovered")

	data.techs.t_towerd_start = {
		name = "Tower Defense", -- recovered database etc.
		unlocks = {
			'metalbar', 'f_building1x1a', 'f_building1x1d', 'f_building1x1b',
		},
		category = "Start",
	}
	data.components.c_portable_turret.power = 0
	data.components.c_portable_turret.trigger_radius = 15
	data.components.c_portable_turret.attack_radius = 15

	data.components.c_turret.power = 0
	data.components.c_turret.trigger_radius = 15
	data.components.c_turret.attack_radius = 15

	data.components.c_power_cell.transfer_radius = 50

	data.components.c_adv_portable_turret.power = 0
	data.components.c_adv_portable_turret.trigger_radius = 10
	data.components.c_adv_portable_turret.attack_radius = 10

	data.components.c_twin_autocannons.power = 0
	data.components.c_twin_autocannons.trigger_radius = 10
	data.components.c_twin_autocannons.attack_radius = 10

	data.components.c_portable_turret_green.power = 0
	data.components.c_portable_turret_green.trigger_radius = 10
	data.components.c_portable_turret_green.attack_radius = 10

	data.components.c_plasma_cannon.power = 0
	data.components.c_photon_beam.power = 0

	data.components.c_laser_turret.power = 0
	data.components.c_laser_turret.trigger_radius = 10
	data.components.c_laser_turret.attack_radius = 10

	data.components.c_railgun.power = 0
	data.components.c_virus_bitlock.power = 0

	data.components.c_missile_turret.power = 0
	data.components.c_missile_turret.trigger_radius = 15
	data.components.c_missile_turret.attack_radius = 15

	-- some frame
	data.frames.f_saveme = {
		immortal = true,
		name = "Re-Simulator",
		visibility_range = 50,
		slots = { storage = 1 },
		texture = "Main/textures/icons/frame/3x3_SIM.png",
	}
	data.frames.f_building1x1e.visibility_range = 70
	data.frames.f_building1x1a.components = { { "c_upgrader", "hidden" } }
	data.frames.f_building1x1d.components = { { "c_upgrader", "hidden" } }
	data.frames.f_building1x1b.components = { { "c_upgrader", "hidden" } }

	local upgrade_table = {
		c_portable_turret = { "c_twin_autocannons", 40 },
		c_twin_autocannons = { "c_turret", 60 },
		c_turret = { "c_portable_turret_green", 60 },

		c_adv_portable_turret = { "c_laser_turret", 70 },
		c_laser_turret = { "c_plasma_cannon", 80 },

		c_photon_beam = { "c_railgun", 80 },
		c_railgun = { "c_virus_bitlock", 80 },
	}

	Comp:RegisterComponent("c_upgrader", {
		name = "Upgrader",
		texture = "Main/textures/icons/hidden/carrier_factory.png",
		get_ui = function(_, comp)
			local turret = comp.owner:FindComponent("c_turret", true).id
			local upgrade = upgrade_table[turret]
			if not upgrade then return end
			local upgradeto = upgrade[1]
			local value = upgrade[2]
			local def = data.all[upgradeto]
			return nil, UI.New('<Box blur=true><Button height=64 icon={ticon} text={txt} textsize=30 textalign=left on_click={click}/></Box>', {

				every_frame_update = function(btn)
					local turret = comp.owner:FindComponent("c_turret", true).id
					if turret ~= btn.current then
						local upgrade = upgrade_table[turret]
						if not upgrade then
							self.hidden=true
							self.every_frame_update = nil
							return
						end
						btn.current = turret
						btn.value = upgrade[2]
						btn.click = function() Action.SendForEntity("UpgradeTower", comp.owner, { to = upgrade[1], value = upgrade[2] }) end
						local def = data.all[upgrade[1]]
						btn.ticon = def.texture
						btn.tooltip = DefinitionTooltip(def)
						btn.txt = L('%d', btn.value)
					end

					local have = Map.GetSave().storage:CountItem("metalbar")
					local haveenough = have >= btn.value
					btn.disabled =  not haveenough
				end,
			})
		end,
		attachment_size = "Hidden",
	})
	Comp:RegisterComponent("c_builder", {
		activation = "Always",
		on_add = function(self, comp)
			local fed = comp.faction.extra_data
			fed.wave = 1
			fed.time = Map.GetTick() + 100
		end,
		on_update = function(self, comp, cause)
			local tick = Map.GetTick()
			local fed = comp.faction.extra_data
			if tick >= fed.time then
				fed.wave = fed.wave + 1
				fed.time = tick + 100

				Map.Defer(function()
					local bug_levels = GetBugCountsForLevel(fed.wave, 5 + (fed.wave//10))
					--print("level", arg.num, bug_levels)
					for i=1,#bug_levels do
						if bug_levels[i] > 0 then
							-- spawn the number of bugs for that level
							for j=1,bug_levels[i] do
								local bug = CreateBugForBugLevel(i)
								bug.max_health = math.min(65535, bug.max_health + (fed.wave * 2))
								bug:FindComponent("c_turret", true):Destroy()
								bug:AddComponent("c_trilobyte_kill", "hidden")
								bug:Place(-46,-41)
							end
						end
					end
				end)
			end
		end,
	})
	Comp:RegisterComponent("c_trilobyte_kill", {
		activation = "Always",
		on_update = function(self, comp)
			--if not comp.exists or not comp.owner.exists then print("got here") return end
			local targetBase = Map.GetSave().targetBase
			if comp:RequestStateMove(targetBase, 0, true) then return end -- move
			-- eat a power cell
			--print("finished walking")
			local consumer = targetBase:FindComponent("c_builder")
			if consumer:PrepareConsumeProcess({silica = 1}) then
				consumer:FulfillProcess()
				comp.owner:Destroy(false)
				local remaining = math.max(targetBase:CountItem("silica"), 0)
				UI.Run(function()
					Notification.Warning(L("They have gotten your silica, %d left!!!", remaining))
				end)
			else
				UI.Run(function()
					Notification.Warning("Game Over")
				end)
				Map.Delay("RestartGame", 10)
			end
			--return comp:SetStateSleep(10)
		end
	})
	function Delay.RestartGame() UI.Run(function() Game.RestartGame() end) end
	-- make sure they can see everything
	data.frames.f_trilobyte1.visibility_range = 50
	data.frames.f_trilobyte1.on_destroy = function(entity, damager)
		Map.GetSave().storage:AddItem("metalbar", self.value)
	end
	data.frames.f_trilobyte1.on_remove = nil

	local allbugs = {
		{ "f_trilobyte1", 1 },
		{ "f_gastarias1", 2 },
		{ "f_trilobyte1a", 3 },
		{ "f_scaramar1", 3 },
		{ "f_trilobyte1b", 4 },
		{ "f_wasp1", 4 },
		{ "f_scaramar2", 5 },
		{ "f_gastarid1", 6 },
	}
	for i,v in ipairs(allbugs) do
		data.frames[v[1]].value = v[2]
		--data.frames[v].health_points = math.ceil(data.frames[v].health_points * 1.5)
	end

	local buildview = UI.GetRegisteredLayoutClass("BuildView")
	if buildview then
		buildview.hide_default = true
	end
end

function UIMsg.OnSetup()
	UI.AddLayout("TowerDefense")
	Notification.Warning("The bugs are here to eat your silica\nDefend it at all costs !!!")
end

function UIMsg.OnSetupInputMapping()
	Input.RemoveActionBinding("Select1")
	Input.RemoveActionBinding("Select2")
	Input.RemoveActionBinding("Select3")
	Input.RemoveActionBinding("Select4")

	Input.BindAction("Select1", "Pressed", function() StartBuildCursor(towers[1]) end)
	Input.BindAction("Select2", "Pressed", function() StartBuildCursor(towers[2]) end)
	Input.BindAction("Select3", "Pressed", function() StartBuildCursor(towers[3]) end)
	Input.BindAction("Select4", "Pressed", function() StartBuildCursor(towers[4]) end)
end

function FactionAction.PlaceBlueprint(faction, arg)
	local builder = Map.GetSave().storage:FindComponent("c_builder")
	if builder:PrepareConsumeProcess(arg.custom_blueprint.construction_recipe.ingredients) then
		builder:FulfillProcess()
		local e = CreateFrameOrBlueprint(faction, arg.custom_blueprint)
		e:Place(arg.locations[1])
	end
end

-- called once all mods are loaded
function package:post_init()
	local construction_custom_blueprint, construction_is_copy_paste
	local function OnConfirmConstruction(locations, rotation, is_valid)
		if not is_valid then Notification.Warning("Cannot build here") return end
		View.StopCursor()
		Quickview_HideGrid()

		if construction_custom_blueprint then
			local function place_bp(bp)
				Action.SendForLocalFaction("PlaceBlueprint", { locations = locations, custom_blueprint = bp })
			end
			if construction_is_copy_paste then
				UILibraryImportBlueprint(construction_custom_blueprint, place_bp)
			else
				ProcessLibraryBlueprint(construction_custom_blueprint, place_bp)
			end
		else
			error("Invalid construction")
		end

		UI.PlaySound("fx_ui_BUILD_COMPLETE")
	end

	local function OnCancelConstruction()
		Quickview_HideGrid()
	end

	local placing_value = 99999
	local function OnCheckConstruction(x, y, rotation, is_visible, can_place, is_powered, size_x, size_y)
		local have = Map.GetSave().storage:CountItem("metalbar")
		if placing_value > have then return false end
		return can_place and Map.GetHeight(x, y) > 0.1
	end
	function _G.StartBuildCursor(id_or_custom)
		construction_custom_blueprint = type(id_or_custom) ~= "string" and id_or_custom
		local frame_id = construction_custom_blueprint and construction_custom_blueprint.frame
		local construction_recipe = construction_custom_blueprint and construction_custom_blueprint.construction_recipe
		placing_value = construction_recipe and construction_recipe.ingredients.metalbar
		if not frame_id or not placing_value then return end

		View.StartCursorConstruction(frame_id, OnConfirmConstruction, OnCancelConstruction, OnCheckConstruction, true)

		UI.CloseMenuPopup()
		Quickview_ShowGrid()
	end
end

function package:on_player_faction_spawn(faction)
	local starting_amount = 40
	faction.home_location = { x=-9, y=-2 } --GetPlayerFactionHomeOnGround()
	local loc = faction.home_location

	local lfid = faction.id
	faction:Unlock("t_towerd_start")

	for _,v in ipairs(towers) do
		ImportBlueprint(faction, v)
	end

	local storage = Map.CreateEntity(faction, "f_building1x1e")
	storage:AddItem("metalbar", starting_amount)
	storage:AddComponent("c_builder", "hidden")
	storage:Place(loc.x, loc.y)
	Map.GetSave().storage = storage

	-- make thing to defend
	local targetBase = Map.CreateEntity(faction, "f_saveme", "v_building_sim")
	targetBase:AddComponent("c_builder", "hidden")
	targetBase:AddItem("silica", 20)
	targetBase:Place(41, 41)
	Map.GetSave().targetBase = targetBase

	local bugspawner = Map.CreateEntity("nme", "f_saveme", "v_plasma_canon_m")
	bugspawner:Place(-46, -41)

	faction:SetTrust("nme", 'ENEMY')
	Map.GetFaction("nme"):SetTrust(faction, 'ENEMY')
end

-- StartBuildCursor(def, nil, id == -1)
local TowerDefenseUI = {}
local towerd_layout = [[
	<VerticalList dock=top child_padding=4>
		<HorizontalList halign=center child_padding=4>
			<Reg def_id="c_portable_turret" num=20 id=t1 turretindex=1 on_click={build_turret}/>
			<Reg def_id="c_adv_portable_turret" num=30 id=t2 turretindex=2 on_click={build_turret}/>
			<Reg def_id="c_photon_beam" num=50 id=t3 turretindex=3 on_click={build_turret}/>
			<Reg def_id="c_missile_turret" num=250 id=t4 turretindex=4 on_click={build_turret}/>
		</HorizontalList>
		<HorizontalList halign=center child_padding=4>
			<Button width=60 text="1x"  on_click={on_click_game_speed} speed=1/>
			<Button width=60 text="2x"  on_click={on_click_game_speed} speed=2/>
			<Button width=60 text="5x"  on_click={on_click_game_speed} speed=5/>
			<Button width=60 text="10x" on_click={on_click_game_speed} speed=10/>
		</HorizontalList>

		<HorizontalList id=ui>
			<Text id=wavetxt size=24 margin_right=10/>
		</HorizontalList>
	</VerticalList>

]]
UI.Register("TowerDefense", towerd_layout, TowerDefenseUI)

function FactionAction.SetGameSpeed(faction, arg)
	Map.SetGameSpeed(arg.speed)
end

local shortcutkey_layout<const> =
[[
	<Box dock=top-right y=2 margin_left=1 margin_bottom=1 blocking=false bg=label_left color=ui_bg>
		<Text text={numtxt} size=10 margin_left=3 margin_right=4 margin_bottom=1/>
	</Box>
]]
function TowerDefenseUI:construct(w)
	self.t1:Add(shortcutkey_layout, { numtxt = "1"})
	self.t2:Add(shortcutkey_layout, { numtxt = "2"})
	self.t3:Add(shortcutkey_layout, { numtxt = "3"})
	self.t4:Add(shortcutkey_layout, { numtxt = "4"})
end

function TowerDefenseUI:on_click_game_speed(btn)
	Action.SendForLocalFaction("SetGameSpeed", { speed = btn.speed })
end

function TowerDefenseUI:build_turret(btn)
	local def = towers[btn.turretindex]
	StartBuildCursor(def)
end

function TowerDefenseUI:update()
	local have = Map.GetSave().storage:CountItem("metalbar")
	local fed = Game.GetLocalPlayerFaction().extra_data

	self.t1.disabled = have < 20
	self.t2.disabled = have < 30
	self.t3.disabled = have < 50
	self.t4.disabled = have < 250

	local timer = fed.time - Map.GetTick()
	local timetxt = Tool.GetTimeDurationStr(timer//TICKS_PER_SECOND)

	self.wavetxt.text = L("Wave: %d - Next Wave In: %s", fed.wave, timetxt)
end
