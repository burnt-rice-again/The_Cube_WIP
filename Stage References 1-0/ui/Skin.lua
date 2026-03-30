data.colors = {
	-- generic color names
	ui_bg         = "#2A2F3A",
	ui_dark       = "#47788a",
	ui_light      = "#67dcf8",
	title         = "#F6C668",
	highlight     = "#5D86FF",

	-- specific color names
	healthbar     = "#76E565",
	powerbar      = "#6CC9FF",
	efficiencybar = "#6CC9FF80",

	-- named brightness/transparency levels
	white         = "#FF",
	light_gray    = "#CC",
	gray          = "#88",
	dark_gray     = "#59",
	black         = "#000",
	transparent   = "#FF00",

	-- named colors (TODO should be replaced by ones defined above to better support overriding of color mapping by the user)
	red           = "#FF957C",
	light_red     = "#FFC5AC",
	cyan          = "#00FFFF",
	green         = "#00FFCC",
	light_green   = "#CCFFCC",
	yellow        = "#FBFF12",
	orange        = "#ffa671",
	blight        = "#8b00e9",
	virus         = "#5fb038",
	purple        = "#ab62ec",
	light_purple  = "#cbc3e3",
	blue          = "#0000ff",
	light_blue    = "#5555ff",
}

data.default_style = {
	font = "Font'/Game/Blueprints/UI/Fonts/Ubuntu.Ubuntu'",
	size = 12,
	letter_spacing = 0,
	typeface = "Default",
	outline_size = 0,
	outline_separate_fill_alpha = false,
	outline_apply_to_drop_shadows = false,
	outline_color = "#000000",
	color = "#FFFFFF",
	shadow_offset = { 0, 0 },
	shadow_color = "#000000",
	icon_color = "#67DCF8",
}

data.tooltip_layout = "<Box bg=popup_box_bg padding=12 blur=true><Text text={txt}/></Box>"

data.styles = {
	normal = {},
	header = {
		size = 14,
		outline_size = 1,
		color = "#F6C667",
	},
	res = {
		outline_size = 1,
		outline_color = "#000000B0",
	},
	res_arrow_green = {
		size = 8,
		typeface = "Bold",
		color="light_green",
		outline_size = 1,
		outline_color = "light_green",
	},
	res_arrow_red = {
		size = 8,
		typeface = "Bold",
		color="light_red",
		outline_size = 1,
		outline_color = "light_red",
	},
	desc = {
		outline_size = 1,
		color = "#CCCCCC",
	},
	-- highlight for lead line
	hl = {
		color = "#FFD174",
		outline_color = "#482309",
		outline_size = 1,
		size = 12.2,
	},
	--[[
	hl = {
		outline_size = 1,
		color = "#FFDD63",
	},
	-- blue text for lead line
	bl = {
		outline_size = 1,
		color = "#99ecff",
	},
	--]]
	bl = {
		color = "#A2F0EA", -- 96F1FF
		outline_color = "#193D54",
		outline_size = 1,
	},
	rl = {
		outline_size = 1,
		color = "#FF8582",
	},
	gl = {
		outline_size = 1,
		color = "#65FF62",
	},
	-- heavy yellow
	-- yl = {
	-- 	outline_size = 1,
	-- 	color = "#eeef1f",
	-- 	outline_color = "#eeef1f",
	-- },
	yl = {
		outline_size = 1,
		color = "#eeef1f",
		outline_color = "#C8AA00",
	},
	steps = {
		color = "#eeef1f",
		outline_size = 1,
		outline_color = "#C8AA00",
	},
	nt = {
		size = 12,
		outline_size = 0,
		color = "#bbcece",  -- d9a425 --e8dc35 --b8b6b6
		outline_color = "#eeefef",
	},
	large_header = {
		size = 40,
		outline_size = 1,
		color = "#F6C667",
	},
	console = {
		font = "Font'/Game/Blueprints/UI/Fonts/Orbitron.Orbitron'",
		size = 24,
		color = "#3D6E37",
	},
	console_elain = {
		font = "Font'/Game/Blueprints/UI/Fonts/Orbitron.Orbitron'",
		color = "#A2F0EA",
	},
	title = {
		typeface = "Bold",
		size = 14,
		color = "#62EDFF",
		letter_spacing = 1600,
		outline_size = 3,
		outline_color = "#FFFFFF26",
	},
	package_title = {
		outline_size = 1,
		color = "#FFFFFF"
	},
	orb = {
		font = "Font'/Game/Blueprints/UI/Fonts/Orbitron.Orbitron'",
		size = 36,
	},
	button_active = {
		color = "#2A303B",
		icon_color = "#45788A",
	},
	outline = {
		outline_size = 1,
	},
	notify_info = {
		color = "#FFFFFF",
		size = 20,
		outline_size = 1,
	},
	notify_italic = {
		color = "#FFFFFF",
		size = 20,
		outline_size = 1,
	},
	notify_warning = {
		color = "#F6E268",
		size = 20,
		outline_size = 1,
	},
	notify_error = {
		color = "#FFAA88",
		size = 20,
		outline_size = 1,
	},
	select = {
		color = "#009999",
		size = 12,
		outline_size = 1,
	},

	-- Tutorial
	gray = {
		color = "#cccccc",
	},
	intro = {
		typeface = "Bold",
		size = 12,
		color = "#62EDFF",
		letter_spacing = 100,
		outline_size = 3,
		outline_color = "#3a558f",
		-- font = "Font'/Game/Blueprints/UI/Fonts/Inconsolata.Inconsolata'",
	},
	detail = {
		color = "#ffeb74",
		size = 12,
		outline_size = 1,
		outline_color = "#480100",
	},
	direct = {
		color = "#8febff",
		size = 12,
		outline_size = 1,
		outline_color = "#28453e",
	},
	damage = {
		font = "Font'/Game/Blueprints/UI/Fonts/Ubuntu.Ubuntu'",
		outline_size = 2,
		outline_color = "#000000",
	},

	---------------------------------------------

	-- codex Entry Title
	codex_title = {
		color = "#FFC73E",
		outline_color = "#653410",
		outline_size = 1,
		size = 18,
	},

	-- codex main
	codex_m = {
		color = "#8AFFDC", -- 66FFD2
		outline_color = "#19604A", -- 19604A
		outline_size = 1,
		size = 12.5,
	},

	-- codex secondary
	codex_s = {
		color = "#97F7E3", -- 66FFD2
		outline_color = "#195247",
		outline_size = 1,
		size = 12.2,
	},

	-- name_list
	name_list = {
		color = "#FFBB6E", -- FF947B -- FAA463 -- FF9E61
		outline_color = "#59311A",
		outline_size = 1,
		size = 12.2,
	},

	------------------------------------------------------------
	-- unused

	tll = {
		color = "#ACDEE2",  -- 69E1BD
		-- outline_color = "#19604A",
		-- outline_size = 1,
		size = 11.5,
	},

	tl1 = {
		color = "#8AFFDC", -- 66FFD2
		outline_color = "#19604A",
		outline_size = 1,
		size = 12,
	},

	---------------------------------
}

data.system_brushes = {
	box_bg = { "Main/skin/Assets/HUD Main Pannel BG v2.png", slice = 0.1 },
	button_default = { "Main/skin/Assets/Button Default.png", slice = 0.2, interact_gain = 0.4 },
	button_active  = { "Main/skin/Assets/Button Active.png", slice = 0.4, overlap = 16 },
	input_default  = { "Main/skin/Assets/Input Default.png", slice = 0.2 },
	slider_base    = { "Main/skin/Assets/Slider Base.png", slice = 0.4, interact_gain = 0.4 },
	slider_thumb   = { "Main/skin/Assets/Slider Thumb.png", interact_gain = 0.4 },
	progress_body  =   "Main/skin/Assets/Progress Bar Body.png",
	progress_base  =   "Main/skin/Assets/Progress Bar Base.png",
}

data.brushes = {
	talking_head = "Main/textures/codex/robot.png",
	talking_head_elain_0 = "Main/textures/codex/robot3.png",
	talking_head_higgs = "Main/textures/codex/robot2.png",
	talking_head_higgs_0 = "Main/textures/codex/robot4.png",
	talking_head_final = "Main/textures/tech/alien_tech.png",
	talking_head_final2 = "Main/textures/tech/alien/energetics/energetics_comm_3.png",

	corner_box_bg = { "Main/skin/Assets/HUD Main Pannel BG v1.png", slice = 0.1 },
	blueprint_bg = "Main/skin/Assets/Blueprint BG.png",

	popup_box_bg            = { "Main/skin/Assets/Additional Windows BGs For Pointer.png", slice = 0.2 },
	popup_pointer           =   "Main/skin/Assets/Additional Windows Pointer.png",
	popup_pattern           = { "Main/skin/Assets/Additional Windows BG Pattern.png", tile = true },
	popup_additional_bg     =   "Main/skin/Assets/Additional Windows Default BG.png",
	alt_additional_bg       =   "Main/skin/Assets/Additional Windows Alt BG.png",
	highlight_additional_bg =   "Main/skin/Assets/Additional Windows Highlight BG.png",
	card_box_bg             = { "Main/skin/Assets/Cards Default BG.png", slice = 0.2 },
	tutorial_highlight      = { "Main/skin/Assets/Tutorial Highlight.png", slice = 0.4, overlap = 16 },
	order_thumb             =   "Main/skin/Assets/Order Thumb.png",
	popup_button_bg         = { "Main/skin/Assets/Button Default.png", slice = 0.2, interact_gain = 0.4 },

	label_left = { "Main/skin/Assets/Label Left.png", slice = 0.5 },
	label_right = { "Main/skin/Assets/Label Right.png", slice = 0.5 },

	reg_base      = "Main/skin/Assets/Register Base.png",
	reg_base_ro   = "Main/skin/Assets/Register Base RO.png",
	reg_entity    = "Main/skin/Assets/Register Entity.png",
	reg_entity_ro = "Main/skin/Assets/Register Entity RO.png",
	reg_value     = "Main/skin/Assets/Register Value.png",
	reg_hover     = "Main/skin/Assets/Register Hover.png",

	black_bg = "Main/skin/Assets/Black BG.png",

	-- Components
	component_bg = { "Main/skin/Assets/Component Base BG Default.png", slice = 0.3 },
	component_bg_blight = { "Main/skin/Assets/Component Base BG Blight.png", slice = 0.3 },
	component_bg_human = { "Main/skin/Assets/Component Base BG Human.png", slice = 0.3 },
	component_bg_alien = { "Main/skin/Assets/Component Base BG Alien.png", slice = 0.3 },
	component_bg_virus = { "Main/skin/Assets/Component Base BG Virus.png", slice = 0.3 },
	component_bg_robot = { "Main/skin/Assets/Component Base BG Robot.png", slice = 0.3 },
	component_base = "Main/skin/Assets/Component Base.png",

	-- Item/Units
	item_default  = { "Main/skin/Assets/Item BG Default.png", slice = 0.3 },
	item_disabled = { "Main/skin/Assets/Item BG Disabled.png", slice = 0.3 },
	item_empty    = { "Main/skin/Assets/Item BG Empty.png", slice = 0.3 },
	item_active   = { "Main/skin/Assets/Item BG Active.png", slice = 0.3, overlap = 16 },
	item_lock     =   "Main/skin/Assets/Item Lock.png",

	-- Tech
	tech_category_bg                 = { "Main/skin/Assets/Tech Category BG.png", slice = 0.4 },
	tech_category_bg_hover           = { "Main/skin/Assets/Tech Category BG Hover.png", slice = 0.4 },
	tech_opened_category_bg          = { "Main/skin/Assets/Tech Category BG Open.png", slice = 0.4, overlap = 32 },
	tech_not_researched_catergory_bg =   "Main/skin/Assets/Tech Category BG Locked.png",
	tech_disabled_bg                 = { "Main/skin/Assets/Tech BG Disabled.png", slice = 0.4, overlap = 16 },
	tech_next_to_research_bg         = { "Main/skin/Assets/Tech BG Queued.png", slice = 0.4, overlap = 16 },
	tech_researched_bg               = { "Main/skin/Assets/Tech BG Unlocked.png", slice = 0.4, overlap = 16 },
	tech_selected_bg                 = { "Main/skin/Assets/Tech BG Selected.png", slice = 0.4, overlap = 16 },
	tech_tree_pattern_bg             =   "Main/skin/Assets/Tech Tree Pattern BG.png",
	tech_tree_pattern                = { "Main/skin/Assets/Tech Tree Pattern.png", tile = true },

	-- Progress Bars
	progress_mask   = { "Main/skin/Assets/Progress Bar Mask.png", tile = true },
	progress_stroke = { "Main/skin/Assets/Slider Base.png", slice = 0.4 },

	-- Warning
	warning_pattern =  "Main/skin/Assets/Warning Message Mask Pattern.png",

	-- Icons 32x32
	icon_small_arrow_direction = "Main/skin/Icons/Common/32x32/Arrow Direction.png",
	icon_small_arrow_down      = "Main/skin/Icons/Common/32x32/Arrow Down.png",
	icon_small_arrow_up        = "Main/skin/Icons/Common/32x32/Arrow Up.png",
	icon_small_arrow_right     = "Main/skin/Icons/Common/32x32/Arrow Right.png",
	icon_small_arrow_left      = "Main/skin/Icons/Common/32x32/Arrow Left.png",
	icon_small_arrow           = "Main/skin/Icons/Common/32x32/Arrow.png",
	icon_small_author          = "Main/skin/Icons/Common/32x32/Author.png",
	icon_small_battery         = "Main/skin/Icons/Common/32x32/Battery.png",
	icon_small_behavior        = "Main/skin/Icons/Common/32x32/Behavior.png",
	icon_small_blueprint       = "Main/skin/Icons/Common/32x32/Blueprint.png",
	icon_small_blight          = "Main/skin/Icons/Common/32x32/Blight.png",
	icon_small_camera          = "Main/skin/Icons/Common/32x32/Camera.png",
	icon_small_confirm         = "Main/skin/Icons/Common/32x32/Confirm.png",
	icon_small_cursor_area     = "Main/skin/Icons/Common/32x32/Cursor Area.png",
	icon_small_day             = "Main/skin/Icons/Common/32x32/Day.png",
	icon_small_deny            = "Main/skin/Icons/Common/32x32/Deny.png",
	icon_small_drone_port      = "Main/skin/Icons/Common/32x32/Drone Port.png",
	icon_small_durability      = "Main/skin/Icons/Common/32x32/Durability.png",
	icon_small_duration        = "Main/skin/Icons/Common/32x32/Duration.png",
	icon_small_edit            = "Main/skin/Icons/Common/32x32/Edit.png",
	icon_small_empty           = "Main/skin/Icons/Common/32x32/Empty.png",
	icon_small_energy_warning  = "Main/skin/Icons/Common/32x32/Energy Warning.png",
	icon_small_energy          = "Main/skin/Icons/Common/32x32/Energy.png",
	icon_small_find            = "Main/skin/Icons/Common/32x32/Find.png",
	icon_small_flyer_port      = "Main/skin/Icons/Common/32x32/Flyer Port.png",
	icon_small_folder          = "Main/skin/Icons/Common/32x32/Folder.png",
	icon_small_garage          = "Main/skin/Icons/Common/32x32/Garage.png",
	icon_small_input           = "Main/skin/Icons/Common/32x32/Input.png",
	icon_small_installed       = "Main/skin/Icons/Common/32x32/Installed.png",
	icon_small_inv_warning     = "Main/skin/Icons/Common/32x32/Inventory Warning.png",
	icon_small_inventory       = "Main/skin/Icons/Common/32x32/Inventory.png",
	icon_small_locked          = "Main/skin/Icons/Common/32x32/Locked.png",
	icon_small_navigation      = "Main/skin/Icons/Common/32x32/Navigation.png",
	icon_small_next            = "Main/skin/Icons/Common/32x32/Next.png",
	icon_small_night           = "Main/skin/Icons/Common/32x32/Night.png",
	icon_small_object          = "Main/skin/Icons/Common/32x32/Object.png",
	icon_small_output          = "Main/skin/Icons/Common/32x32/Output.png",
	icon_small_pause           = "Main/skin/Icons/Common/32x32/Pause.png",
	icon_small_previous        = "Main/skin/Icons/Common/32x32/Previous.png",
	icon_small_register_in     = "Main/skin/Icons/Common/32x32/Register In.png",
	icon_small_register_out    = "Main/skin/Icons/Common/32x32/Register Out.png",
	icon_small_register_var    = "Main/skin/Icons/Common/32x32/Register Var.png",
	icon_small_request         = "Main/skin/Icons/Common/32x32/Request.png",
	icon_small_satellite       = "Main/skin/Icons/Common/32x32/Satellite.png",
	icon_small_save            = "Main/skin/Icons/Common/32x32/Save.png",
	icon_small_seed            = "Main/skin/Icons/Common/32x32/Seed.png",
	icon_small_sort            = "Main/skin/Icons/Common/32x32/Sort.png",
	icon_small_stick_to        = "Main/skin/Icons/Common/32x32/Stick To.png",
	icon_small_time            = "Main/skin/Icons/Common/32x32/Time.png",
	icon_small_transmit        = "Main/skin/Icons/Common/32x32/Transmit.png",
	icon_small_visual          = "Main/skin/Icons/Common/32x32/Visual.png",
	icon_small_view_list       = "Main/skin/Icons/Common/32x32/View List.png",
	icon_small_view_icon       = "Main/skin/Icons/Common/32x32/View Icon.png",
	icon_small_warning         = "Main/skin/Icons/Common/32x32/Warning.png",
	icon_small_zoom_in         = "Main/skin/Icons/Common/32x32/Zoom In.png",
	icon_small_zoom_out        = "Main/skin/Icons/Common/32x32/Zoom Out.png",

	-- Icons 56x56
	icon_achieve    = "Main/skin/Icons/Common/56x56/Achieve.png",
	icon_achieved   = "Main/skin/Icons/Common/56x56/Achieved.png",
	icon_add        = "Main/skin/Icons/Common/56x56/Add.png",
	icon_amount     = "Main/skin/Icons/Common/56x56/Amount.png",
	icon_attack     = "Main/skin/Icons/Common/56x56/Attack.png",
	icon_back       = "Main/skin/Icons/Common/56x56/Back.png",
	icon_behavior   = "Main/skin/Icons/Common/56x56/Behavior.png",
	icon_blueprint  = "Main/skin/Icons/Common/56x56/Blueprint.png",
	icon_letter     = "Main/skin/Icons/Common/56x56/BG Letter.png",
	icon_number     = "Main/skin/Icons/Common/56x56/BG Number.png",
	icon_transport  = "Main/skin/Icons/Common/56x56/Transport.png",
	icon_docarry    = "Main/skin/Icons/Common/56x56/Carry.png",
	icon_carry      = "Main/skin/Icons/Common/56x56/Network.png",
	icon_component  = "Main/skin/Icons/Common/56x56/Component.png",
	icon_confirm    = "Main/skin/Icons/Common/56x56/Confirm.png",
	icon_context    = "Main/skin/Icons/Common/56x56/Context.png",
	icon_copy       = "Main/skin/Icons/Common/56x56/Copy.png",
	icon_deny       = "Main/skin/Icons/Common/56x56/Deny.png",
	icon_comp       = "Main/skin/Icons/Common/56x56/Detach Comp.png",
	icon_detach     = "Main/skin/Icons/Common/56x56/Detach.png",
	icon_distance   = "Main/skin/Icons/Common/56x56/Distance.png",
	icon_item       = "Main/skin/Icons/Common/56x56/Dropped Item.png",
	icon_duration   = "Main/skin/Icons/Common/56x56/Duration.png",
	icon_storm      = "Main/skin/Icons/Common/56x56/Dust Storm.png",
	icon_behav      = "Main/skin/Icons/Common/56x56/Edit Behavior.png",
	icon_program    = "Main/skin/Icons/Common/56x56/Edit Program.png",
	icon_edit       = "Main/skin/Icons/Common/56x56/Edit.png",
	icon_register   = "Main/skin/Icons/Common/56x56/Empty Register.png",
	icon_feedback   = "Main/skin/Icons/Common/56x56/Feedback.png",
	icon_folder     = "Main/skin/Icons/Common/56x56/Folder.png",
	icon_gamepad    = "Main/skin/Icons/Common/56x56/Gamepad.png",
	icon_home       = "Main/skin/Icons/Common/56x56/Home.png",
	icon_button     = "Main/skin/Icons/Common/56x56/Input button.png",
	icon_input      = "Main/skin/Icons/Common/56x56/Input.png",
	icon_inventory  = "Main/skin/Icons/Common/56x56/Inventory.png",
	icon_inv_garage = "Main/skin/Icons/Common/56x56/Inventory_Garage.png",
	icon_inv_gas    = "Main/skin/Icons/Common/56x56/Inventory_Gas.png",
	icon_inv_anomaly = "Main/skin/Icons/Common/56x56/Inventory_Anomaly.png",
	icon_inv_bughole = "Main/skin/Icons/Common/56x56/Inventory_Bughole.png",
	icon_inv_alien  = "Main/skin/Icons/Common/56x56/Inventory_Alien.png",
	icon_inv_virus  = "Main/skin/Icons/Common/56x56/Inventory_Virus.png",
	icon_inv_drone  = "Main/skin/Icons/Common/56x56/Inventory_Drone.png",
	icon_inv_flyer  = "Main/skin/Icons/Common/56x56/Inventory_Flyer.png",
	icon_inv_satellite  = "Main/skin/Icons/Common/56x56/Inventory_Satellite.png",
	icon_key        = "Main/skin/Icons/Common/56x56/Key.png",
	icon_keyboard   = "Main/skin/Icons/Common/56x56/Keyboard.png",
	icon_local      = "Main/skin/Icons/Common/56x56/Local.png",
	icon_locked     = "Main/skin/Icons/Common/56x56/Locked.png",
	icon_resources  = "Main/skin/Icons/Common/56x56/Lack of Resources.png",
	icon_map        = "Main/skin/Icons/Common/56x56/Select on Map.png",
	icon_menu       = "Main/skin/Icons/Common/56x56/Menu.png",
	icon_minus      = "Main/skin/Icons/Common/56x56/Minus.png",
	icon_mouse      = "Main/skin/Icons/Common/56x56/Mouse.png",
	icon_new        = "Main/skin/Icons/Common/56x56/New.png",
	icon_next       = "Main/skin/Icons/Common/56x56/Next.png",
	icon_output     = "Main/skin/Icons/Common/56x56/Output.png",
	icon_paste      = "Main/skin/Icons/Common/56x56/Paste.png",
	icon_pause      = "Main/skin/Icons/Common/56x56/Pause.png",
	icon_pin        = "Main/skin/Icons/Common/56x56/Pin.png",
	icon_play       = "Main/skin/Icons/Common/56x56/Play.png",
	icon_previous   = "Main/skin/Icons/Common/56x56/Previous.png",
	icon_power      = "Main/skin/Icons/Common/56x56/Power.png",
	icon_processing = "Main/skin/Icons/Common/56x56/Processing.png",
	icon_question   = "Main/skin/Icons/Common/56x56/Question.png",
	icon_refresh    = "Main/skin/Icons/Common/56x56/Refresh.png",
	icon_remote     = "Main/skin/Icons/Common/56x56/Remote.png",
	icon_remove     = "Main/skin/Icons/Common/56x56/Remove.png",
	icon_rename     = "Main/skin/Icons/Common/56x56/Rename.png",
	icon_replay     = "Main/skin/Icons/Common/56x56/Replay.png",
	icon_save       = "Main/skin/Icons/Common/56x56/Save.png",
	icon_signal     = "Main/skin/Icons/Common/56x56/Signal.png",
	icon_radar     = "Main/skin/Icons/Common/56x56/Radar.png",
	icon_steam      = "Main/skin/Icons/Common/56x56/Steam.png",
	icon_stop       = "Main/skin/Icons/Common/56x56/Stop.png",
	icon_target     = "Main/skin/Icons/Common/56x56/Target.png",
	icon_target2     = "Main/skin/Icons/Common/56x56/Target_2.png",
	icon_test       = "Main/skin/Icons/Common/56x56/Test.png",
	icon_undo       = "Main/skin/Icons/Common/56x56/Undo.png",
	icon_unlocked   = "Main/skin/Icons/Common/56x56/Unlocked.png",
	icon_update     = "Main/skin/Icons/Common/56x56/Update.png",
	icon_uplink     = "Main/skin/Icons/Common/56x56/Uplink.png",
	icon_vision     = "Main/skin/Icons/Common/56x56/Vision.png",
	icon_warning    = "Main/skin/Icons/Common/56x56/Warning.png",

	icon_i_socket   = "Main/skin/Icons/Common/56x56/I_socket.png",
	icon_s_socket   = "Main/skin/Icons/Common/56x56/S_socket.png",
	icon_m_socket   = "Main/skin/Icons/Common/56x56/M_socket.png",
	icon_l_socket   = "Main/skin/Icons/Common/56x56/L_socket.png",
	icon_cog        = "Main/skin/Icons/Common/56x56/Cog.png",

	-- Icons 50x50
	icon50_Build    = "Main/skin/Icons/Common/50x50/Build.png",
	icon50_Codex    = "Main/skin/Icons/Common/50x50/Codex.png",
	icon50_Faction  = "Main/skin/Icons/Common/50x50/Faction.png",
	icon50_Library  = "Main/skin/Icons/Common/50x50/Library.png",
	icon50_Progress = "Main/skin/Icons/Common/50x50/Progress.png",
	icon50_Tech     = "Main/skin/Icons/Common/50x50/Technology Tree.png",
	icon50_ItemNum  = "Main/skin/Icons/Common/50x50/Resources.png",

	-- Icons 78x78
	icon_large_medal = "Main/skin/Icons/Common/78x78/Achievement Medal.png",

	-- Icons 24x24
	icon_tiny_battery_down     = "Main/skin/Icons/Common/24x24/Battery Down.png",
	icon_tiny_battery_up       = "Main/skin/Icons/Common/24x24/Battery Up.png",
	icon_tiny_battery          = "Main/skin/Icons/Common/24x24/Battery.png",
	icon_tiny_building_size    = "Main/skin/Icons/Common/24x24/Building Size.png",
	icon_tiny_calendar         = "Main/skin/Icons/Common/24x24/Calendar.png",
	icon_tiny_damage           = "Main/skin/Icons/Common/24x24/Damage.png",
	icon_tiny_day              = "Main/skin/Icons/Common/24x24/Day.png",
	icon_tiny_durone_range     = "Main/skin/Icons/Common/24x24/Drone Range.png",
	icon_tiny_durability       = "Main/skin/Icons/Common/24x24/Durability.png",
	icon_tiny_duration         = "Main/skin/Icons/Common/24x24/Duration.png",
	icon_tiny_empty            = "Main/skin/Icons/Common/24x24/Empty.png",
	icon_tiny_energy           = "Main/skin/Icons/Common/24x24/Energy.png",
	icon_tiny_energy_down      = "Main/skin/Icons/Common/24x24/Energy Down.png",
	icon_tiny_energy_lack      = "Main/skin/Icons/Common/24x24/Energy Lack.png",
	icon_tiny_energy_range     = "Main/skin/Icons/Common/24x24/Energy Range.png",
	icon_tiny_energy_transmit  = "Main/skin/Icons/Common/24x24/Energy Transmit.png",
	icon_tiny_energy_up        = "Main/skin/Icons/Common/24x24/Energy Up.png",
	icon_tiny_inventory        = "Main/skin/Icons/Common/24x24/Inventory.png",
	icon_tiny_movement_speed   = "Main/skin/Icons/Common/24x24/Movement Speed.png",
	icon_tiny_night            = "Main/skin/Icons/Common/24x24/Night.png",
	icon_tiny_range            = "Main/skin/Icons/Common/24x24/Range.png",
	icon_tiny_save             = "Main/skin/Icons/Common/24x24/Save.png",
	icon_tiny_speed            = "Main/skin/Icons/Common/24x24/Speed.png",
	icon_tiny_tick             = "Main/skin/Icons/Common/24x24/Tick.png",
	icon_tiny_time             = "Main/skin/Icons/Common/24x24/Time.png",
	icon_tiny_visibility_range = "Main/skin/Icons/Common/24x24/Visibility Range.png",

	icon_cmd_pickup            = "Main/skin/Icons/Special/Commands/Pick Up Items.png",
	icon_cmd_moveto            = "Main/skin/Icons/Special/Commands/Move To.png",

	icon_left_mouse            = "Main/skin/Assets/LeftMouseButton.png",

	icon_1_g          = "Main/skin/Icons/Common/56x56/1_g.png",
	icon_2_g          = "Main/skin/Icons/Common/56x56/2_g.png",
	icon_3_g          = "Main/skin/Icons/Common/56x56/3_g.png",
}

data.item_slot_icons = {
	gas = "icon_inv_gas",
	virus = "icon_inv_virus",
	anomaly = "icon_inv_anomaly",
	alien = "icon_inv_alien",
	bughole = "icon_inv_bughole",
	garage = "icon_inv_garage",
	satellite = "icon_inv_satellite",
	drone = "icon_inv_drone",
	flyer = "icon_inv_flyer",
}

data.item_slot_order = {
	storage = 1,
	gas = 2,
	virus = 3,
	anomaly = 4,
	alien = 5,
	garage = 6,
	bughole = 7,
	satellite = 8,
	drone = 9,
	flyer = 10,
}

data.state_icons = {
	Idle        = "Main/textures/icons/states/idle.png?filter=bilinear?mipmaps=true",
	PoweredDown = "Main/textures/icons/states/powereddown.png?filter=bilinear?mipmaps=true",
	PathBlocked = "Main/textures/icons/states/pathblocked.png?filter=bilinear?mipmaps=true",
	Inefficient = "Main/textures/icons/states/inefficient.png?filter=bilinear?mipmaps=true",
	Unpowered   = "Main/textures/icons/states/unpowered.png?filter=bilinear?mipmaps=true",
	Emergency   = "Main/textures/icons/states/emergency.png?filter=bilinear?mipmaps=true",
	Broken      = "Main/textures/icons/states/broken.png?filter=bilinear?mipmaps=true",
	StaleOrder  = "Main/textures/icons/states/stale.png?filter=bilinear?mipmaps=true",
	LuaCustom1  = "Main/textures/icons/states/infected.png?filter=bilinear?mipmaps=true",
	LuaCustom2  = "Main/textures/icons/states/behavior.png?filter=bilinear?mipmaps=true",
	-- Special states for map overlay
	LogisticsConnected      = "Main/textures/icons/states/connected.png?filter=bilinear?mipmaps=true",
	LogisticsDisconnected   = "Main/textures/icons/states/disconnected.png?filter=bilinear?mipmaps=true",
	LogisticsTransportRoute = "Main/textures/icons/states/transport.png?filter=bilinear?mipmaps=true",
	LogisticsHighPriority   = "Main/textures/icons/states/high_priority.png?filter=bilinear?mipmaps=true",
	LogisticsCraneOnly      = "Main/textures/icons/states/crane_only.png?filter=bilinear?mipmaps=true",
}

data.state_names = {
	Idle        = "Idle",
	PoweredDown = "Shutdown",
	PathBlocked = "Path Blocked",
	Inefficient = "Inefficient",
	Unpowered   = "Out of Power",
	Emergency   = "Slightly Damaged",
	Broken      = "Heavily Damaged",
	StaleOrder  = "Has Stale Order",
	LuaCustom1  = "Infected",
	LuaCustom2  = "Running a Behavior",
	-- Special states for map overlay
	LogisticsConnected      = "Connected",
	LogisticsDisconnected   = "Disconnected",
	LogisticsTransportRoute = "Transport Route",
	LogisticsHighPriority   = "High Priority",
	LogisticsCraneOnly      = "Only Item Transporters",
}

data.state_descriptions = {
	PoweredDown = "Unit or building has been shut down",
	Inefficient = "Lack of power causes unit or building to run at less than 100% efficiency",
	StaleOrder  = "Unit or building is waiting a long time for an order",
	LuaCustom1  = "Unit or building has been infected by a virus",
	LuaCustom2  = "Unit or building has a running behavior controller component",
}

data.state_order = {
	'Idle', 'PoweredDown', 'PathBlocked', 'Inefficient', 'Unpowered', 'Emergency', 'Broken', 'StaleOrder', 'LuaCustom2', 'LuaCustom1',
	'LogisticsConnected', 'LogisticsDisconnected', 'LogisticsTransportRoute', 'LogisticsHighPriority', 'LogisticsCraneOnly',
}

data.order_channel_bit_images = {
	[1] = { image = "Main/textures/icons/values/number_1.png", tooltip = "On Channel 1" },
	[2] = { image = "Main/textures/icons/values/number_2.png", tooltip = "On Channel 2" },
	[4] = { image = "Main/textures/icons/values/number_3.png", tooltip = "On Channel 3" },
	[8] = { image = "Main/textures/icons/values/number_4.png", tooltip = "On Channel 4" },
}

data.categories = {
	{ name = "Resource",             tab = "item",  defs = data.items,      filter_field = "tag",             filter_val = "resource"          },
	{ name = "Simple Material",      tab = "item",  defs = data.items,      filter_field = "tag",             filter_val = "simple_material"   },
	{ name = "Advanced Material",    tab = "item",  defs = data.items,      filter_field = "tag",             filter_val = "advanced_material" },
	{ name = "Hi-Tech Material",     tab = "item",  defs = data.items,      filter_field = "tag",             filter_val = "hitech_material"   },
	{ name = "Research Data",        tab = "item",  defs = data.items,      filter_field = "tag",             filter_val = "research"          },
	{ name = "Integrated Component", tab = "item",  defs = data.components, filter_field = "attachment_size", filter_val = "Hidden"            },
	{ name = "Internal Component",   tab = "item",  defs = data.components, filter_field = "attachment_size", filter_val = "Internal"          },
	{ name = "Small Component",      tab = "item",  defs = data.components, filter_field = "attachment_size", filter_val = "Small"             },
	{ name = "Medium Component",     tab = "item",  defs = data.components, filter_field = "attachment_size", filter_val = "Medium"            },
	{ name = "Large Component",      tab = "item",  defs = data.components, filter_field = "attachment_size", filter_val = "Large"             },
	{ name = "Color Value",          tab = "value", defs = data.values,     filter_field = "tag",             filter_val = "color"             },
	{ name = "Object Type",          tab = "value", defs = data.values,     filter_field = "tag",             filter_val = "entityfilter"      },
	{ name = "Value",                tab = "value", defs = data.values,     filter_field = "tag",             filter_val = "value"             },
	{ name = "?",                    tab = "value", defs = data.values,     filter_field = "tag",             filter_val = "alien_signal"      },
	{ name = "Unit",                 tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Unit"              },
	{ name = "Drone",                tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Drone"             },
	{ name = "Small Building",       tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Small"             },
	{ name = "Medium Building",      tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Medium"            },
	{ name = "Large Building",       tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Large"             },
	{ name = "Special Building",     tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Special"           },
	{ name = "Foundations",          tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Foundation"        },
	{ name = "Walls",                tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Wall"              },
	{ name = "Other Construction",   tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Other"             },
	{ name = "Resource",             tab = "frame", defs = data.frames,     filter_field = "type",            filter_val = "Resource"          },
	{ name = "Human Building",       tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Human"             },
	--{ name = "Bug Building",         tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Bug"               },
	{ name = "Alien Building",       tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Alien"             },
	{ name = "Virus",                tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Virus"             },
	{ name = "Hive",                 tab = "frame", defs = data.frames,     filter_field = "size",            filter_val = "Hive"              },
}

data.frame_regs = {
	{
		name = "Goto", bg = "icon_context",
		tooltip = [[<header>Goto</>
<Key action="ExecuteAction" style="hl"/> or <hl>Drag</>
<hl>Shift+</><Key action="ExecuteAction" style="hl"/> to queue

Move to this object or location and attempt to <hl>interact</>.

Use <Key id="MOUSEWHEELAXIS" style="hl"/> to set the movement distance.]],
	},
	{
		name = "Store", bg = "icon_home",
		tooltip = [[<header>Store</>
<hl>Ctrl+</><Key action="ExecuteAction" style="hl"/> or <hl>Drag</>

Set to an owned <hl>unit</> or <hl>building</> to transfer inventory when possible.

Use <Key id="MOUSEWHEELAXIS" style="hl"/> to set the minimum transfer amount.]],
	},
	{
		name = "Visual", bg = "icon_vision",
		tooltip = [[<header>Visual</>

Shown in the game world, useful to link to production
by dragging from the <hl>Production</> to the <hl>Visual</>

Change visibility with <Key action="MapOverlay" style="hl"/>]],
	},
	{
		name = "Signal", bg = "icon_signal",
		tooltip = [[<header>Signal</>

The unit or building emits this signal which can be read
through signal related components or through behaviors.

Useful for advanced automation]],
	}
}

data.link_colors = {
	"#74F157", --green
	"#F47C7C", --red
	"#7C9EF4", --blue
	"#F4ED7C", --yellow
	"#7CF3F4", --cyan
	"#D97CF4", --purple
	"#F4A97C", --orange
}
