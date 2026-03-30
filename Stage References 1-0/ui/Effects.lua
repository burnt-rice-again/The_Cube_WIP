data.fx.fx_line = {
	particle = { "NiagaraSystem'/Game/Effects/Entity/FX_Arrow.FX_Arrow'", flags = "Preload", },
	flags = "Infinite|IgnoreRotation",
}

data.fx.fx_range = {
	particle = { "NiagaraSystem'/Game/Effects/Entity/FX_Range.FX_Range'", flags = "Preload", },
	flags = "Infinite|IgnoreRotation",
}

-- music
--data.fx.fx_music_main_theme      = { sound = "Main/sounds/music/MAIN_THEME.ogg",      flags = "Music" }
data.fx.fx_music_main_menu       = { sound = "Main/sounds/music/MAIN_MENU.ogg",       flags = "Music" }
data.fx.fx_music_storytelling    = { sound = "Main/sounds/music/STORYTELLING.ogg",    flags = "Music" }
data.fx.fx_music_storytelling2   = { sound = "Main/sounds/music/STORYTELLING2.ogg",   flags = "Music" }
data.fx.fx_music_upbeat          = { sound = "Main/sounds/music/UPBEAT.ogg",          flags = "Music" }
data.fx.fx_music_upbeat2         = { sound = "Main/sounds/music/UPBEAT2.ogg",         flags = "Music" }
data.fx.fx_music_base_building   = { sound = "Main/sounds/music/BASE_BUILDING.ogg",   flags = "Music" }
data.fx.fx_music_base_building2  = { sound = "Main/sounds/music/BASE_BUILDING2.ogg",  flags = "Music" }
data.fx.fx_music_base_building3  = { sound = "Main/sounds/music/BASE_BUILDING3.ogg",  flags = "Music" }
data.fx.fx_music_base_building4  = { sound = "Main/sounds/music/BASE_BUILDING4.ogg",  flags = "Music" }
data.fx.fx_music_puzzle          = { sound = "Main/sounds/music/PUZZLE.ogg",          flags = "Music" }
data.fx.fx_music_alien_darkness  = { sound = "Main/sounds/music/ALIEN_DARKNESS.ogg",  flags = "Music" }
data.fx.fx_music_alien_mystery   = { sound = "Main/sounds/music/ALIEN_MYSTERY.ogg",   flags = "Music" }
data.fx.fx_music_alien_encounter = { sound = "Main/sounds/music/ALIEN_ENCOUNTER.ogg", flags = "Music" }

-- ambience
local ambient_attenuation = 15000
data.fx.fx_ambience_BLIGHT_AMBIENT_ZONE  = {
	sound = "Main/sounds/ambience/BLIGHT_AMBIENT_ZONE(LOOP).ogg",
	flags = "Ambience|SoundLooping",
	sound_attenuation = "high",
	ambience_falloff_distance = ambient_attenuation
}

data.fx.fx_ambience_PLATEAU_AMBIENT_ZONE = {
	sound = "Main/sounds/ambience/FOREST_AMBIENT_ZONE(LOOP).ogg",
	flags = "Ambience|SoundLooping",
	sound_attenuation = "high",
	ambience_falloff_distance = ambient_attenuation
}

data.fx.fx_ambience_GENERAL_AMBIENT_ZONE = {
	sound = "Main/sounds/ambience/GENERAL_AMBIENT_ZONE(LOOP).ogg",
	flags = "Ambience|SoundLooping",
	sound_attenuation = "high",
	ambience_falloff_distance = ambient_attenuation
}

data.fx.fx_ambience_FOREST_AMBIENT_ZONE  = {
	sound = "Main/sounds/ambience/PLATEAU_AMBIENT_ZONE(LOOP).ogg",
	flags = "Ambience|SoundLooping",
	sound_attenuation = "high",
	ambience_falloff_distance = ambient_attenuation
}

-- environment
data.fx.fx_environment_SYSTEM_GLITCH          = { sound = "Main/sounds/environment/SYSTEM_GLITCH.ogg" }

-- UI
data.fx.fx_ui_BUILD_ADD                       = { flags = "UI", sound = "Main/sounds/ui/BUILD_ADD.ogg" }
data.fx.fx_ui_BUILD_ADD_ROTATE                = { flags = "UI", sound = "Main/sounds/ui/BUILD_ADD_ROTATE.ogg" }
data.fx.fx_ui_BUILD_COMPLETE                  = { flags = "UI", sound = "Main/sounds/ui/BUILD_COMPLETE.ogg" }
data.fx.fx_ui_WINDOW_MOUSE_HOVER              = { flags = "UI", sound = "Main/sounds/ui/WINDOW_MOUSE_HOVER.ogg" }
data.fx.fx_ui_INVENTORY_POPUP                 = { flags = "UI", sound = "Main/sounds/ui/INVENTORY_POPUP.ogg" }
data.fx.fx_ui_BUTTON_START_GAME               = { flags = "UI", sound = "Main/sounds/ui/BUTTON_START_GAME.ogg" }
data.fx.fx_ui_COMPONENT_EQUIP                 = { flags = "UI", sound = "Main/sounds/ui/COMPONENT_EQUIP.ogg" }
data.fx.fx_ui_ELEMENT_DRAG                    = { flags = "UI", sound = "Main/sounds/ui/UI MOUSE HOVER_01.ogg" } --"Main/sounds/ui/WINDOW_SELECTION_MENU_INCREMENT.ogg" } -- ELEMENT_DRAG
data.fx.fx_ui_GRID_SELECT                     = { flags = "UI", sound = "Main/sounds/ui/WINDOW_BUILD_MENU_POPUP.ogg" }
data.fx.fx_ui_INIT_GAME                       = { flags = "UI", sound = "Main/sounds/ui/INIT_GAME.ogg" }
data.fx.fx_ui_INIT_TYPING_CHAR                = { flags = "UI", sound = "Main/sounds/ui/INIT_TYPING_CHAR.ogg" }
data.fx.fx_ui_INIT_TYPING_ENTER               = { flags = "UI", sound = "Main/sounds/ui/INIT_TYPING_ENTER.ogg" }
data.fx.fx_ui_INIT_TYPING_DONE                = { flags = "UI", sound = "Main/sounds/ui/INIT_TYPING_DONE.ogg" }
data.fx.fx_ui_MOUSE_CLICK                     = { flags = "UI", sound = "Main/sounds/ui/UI MOUSE CLICK_01.ogg" }
data.fx.fx_ui_MOUSE_HOVER                     = { flags = "UI", sound = "Main/sounds/ui/UI MOUSE HOVER_01.ogg" }
data.fx.fx_ui_OBJECTIVE_NEW                   = { flags = "UI", sound = "Main/sounds/ui/OBJECTIVE_NEW.ogg" }
data.fx.fx_ui_WINDOW_OBJECTIVES_CLOSE         = { flags = "UI", sound = "Main/sounds/ui/WINDOW_OBJECTIVES_CLOSE.ogg" }
data.fx.fx_ui_RIDDLE_SOLVED                   = { flags = "UI", sound = "Main/sounds/ui/RIDDLE_SOLVED.ogg" }
data.fx.fx_ui_WINDOW_GENERIC_CLOSE            = { flags = "UI", sound = "Main/sounds/ui/WINDOW_GENERIC_CLOSE.ogg" }
data.fx.fx_ui_WINDOW_GENERIC_OPEN             = { flags = "UI", sound = "Main/sounds/ui/WINDOW_GENERIC_OPEN.ogg" }
data.fx.fx_ui_WINDOW_INFO_POPOUT              = { flags = "UI", sound = "Main/sounds/ui/WINDOW_INFO_POPOUT.ogg" }
data.fx.fx_ui_WINDOW_INFO_POPUP               = { flags = "UI", sound = "Main/sounds/ui/WINDOW_INFO_POPUP.ogg" }
data.fx.fx_ui_WINDOW_SELECTION_MENU_OPEN      = { flags = "UI", sound = "Main/sounds/ui/UI WINDOW SELECTION MENU OPEN_01.ogg" }
data.fx.fx_ui_WINDOW_SELECTION_MENU_INCREMENT = { flags = "UI", sound = "Main/sounds/ui/UI MOUSE HOVER_01.ogg" }
data.fx.fx_ui_WINDOW_SELECTION_MENU_APPLY     = { flags = "UI", sound = "Main/sounds/ui/UI WINDOW SELECTION MENU APPLY_01.ogg" }
data.fx.fx_ui_WINDOW_TUT_POPUP                = { flags = "UI", sound = "Main/sounds/ui/WINDOW_TUT_POPUP.ogg" }
data.fx.fx_ui_WINDOW_TUT_NEXT                 = { flags = "UI", sound = "Main/sounds/ui/UI WINDOW TUT NEXT_01.ogg" }
data.fx.fx_ui_WINDOW_TUT_POPOUT               = { flags = "UI", sound = "Main/sounds/ui/UI WINDOW TUT POPOUT_01.ogg" }
