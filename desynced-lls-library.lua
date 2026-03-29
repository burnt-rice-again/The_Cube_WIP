--[[ - Desynced Lua definitions for use with Lua Language Server - --]]

---@meta

---@alias IdleMode               "IDLE" | "STORE" | "MOVE" | "ORDER" | "COMPONENT" | "DROP" | "INTERACT" | "RETURN"
---@alias EntityState            "None" | "Idle" | "PoweredDown" | "PathBlocked" | "Unpowered" | "Emergency" | "Broken" | "LuaCustom1" | "LuaCustom2" | "LuaCustom3" | "LuaCustom4"
---@alias FactionTrust           "ENEMY" | "NEUTRAL" | "ALLY"
---@alias SessionVisibility      "PUBLIC" | "FRIENDS" | "INVITE" | "LAN" | "LOCKED"
---@alias FullscreenMode         "windowed", "borderless", "fullscreen"
---@alias Point                  { x: integer, y: integer }
---@alias PointArray             { [1]: integer, [2]: integer }
---@alias Point3D                { x: integer, y: integer, z: integer }
---@alias RegRef                 Register|integer
---@alias AreaArray              { [1]: integer, [2]: integer, [3]: integer?, [4]: integer? }
---@alias AreaTable              { x: integer, y: integer, width: integer?, height: integer? }
---@alias Area                   Entity|Component|ItemSlot|AreaArray|AreaTable|Point|PointArray
---@alias ColorRGBAArray         { [1]: number, [2]: number, [3]: number, [4]: number? }
---@alias ColorRGBATable         { r: number, g: number, b: number, a: number? }
---@alias ColorHexRGB            string "#XXXXXX"
---@alias ColorHexRGBA           string "#XXXXXXXX"
---@alias ColorHexLuminance      string "#XX"
---@alias ColorHexLuminanceAlpha string "#XXXX"
---@alias ColorUnreal            string "R=1.0, G=1.0, B=1.0, A=1.0"
---@alias ColorName              string from data.colors
---@alias Color                  ColorRGBAArray|ColorRGBATable|ColorHexRGB|ColorHexRGBA|ColorHexLuminance|ColorHexLuminanceAlpha|ColorUnreal|ColorName
---@alias AnyId                  string
---@alias ComponentId            string
---@alias VisualId               string
---@alias FrameId                string
---@alias ItemId                 string
---@alias ValueId                string
---@alias TechId                 string
---@alias FactionId              string
---@alias FactionOrId            Faction|FactionId
---@alias FactionOrEntity        Faction|Entity

---------------------------------------------------------------------------------------------------------------
TICKS_PER_SECOND           = 5
TILES_PER_CHUNK            = 60
CULL_DISTANCE              = 15000
FRAMEREG_GOTO              = -1
FRAMEREG_STORE             = -2
FRAMEREG_VISUAL            = -3
FRAMEREG_SIGNAL            = -4
FRAMEREG_COUNT             = 4
REG_INFINITE               = -2147483648
REG_NOT                    = -2147483647
CC_ACTIVATED               = 1 << 0
CC_FINISH_WORK             = 1 << 1
CC_FINISH_SLEEP            = 1 << 2
CC_FINISH_MOVE             = 1 << 3
CC_REFRESH                 = 1 << 4
CC_WAKEUP                  = 1 << 5
CC_CHANGED_REGISTER_NUM    = 1 << 6
CC_CHANGED_REGISTER_ID     = 1 << 7
CC_CHANGED_REGISTER_ENTITY = 1 << 8
CC_CHANGED_REGISTER_COORD  = 1 << 9
CC_CHANGED_ITEMSLOT_AMOUNT = 1 << 10
CC_CHANGED_ITEMSLOT_ITEM   = 1 << 11
CC_CHANGED_ITEMSLOT_EXTRA  = 1 << 12
CC_LOST_MOVE_CONTROL       = 1 << 13
CC_LOST_POWER              = 1 << 14
CC_OTHER_COMP_FINISH_WORK  = 1 << 15
CC_OTHER_COMP_FAIL_WORK    = 1 << 16
FF_DECORATION              = 1 << 1
FF_FOUNDATION              = 1 << 2
FF_WALL                    = 1 << 3
FF_GATE                    = 1 << 4
FF_DROPPEDITEM             = 1 << 5
FF_RESOURCE                = 1 << 6
FF_CONSTRUCTION            = 1 << 7
FF_OPERATING               = 1 << 8
FF_ALL                     = (1 << 9) - 1
FF_OWNFACTION              = 1 << 11
FF_ENEMYFACTION            = 1 << 12
FF_NEUTRALFACTION          = 1 << 13
FF_ALLYFACTION             = 1 << 14
FF_WORLDFACTION            = 1 << 15

---@class EntityAction: EventListener
EntityAction = {}
---@class FactionAction: EventListener
FactionAction = {}
---@class ConstructionAction: EventListener
ConstructionAction = {}
---@class PlayerAction: EventListener
PlayerAction = {}
---@class Delay: EventListener
Delay = {}
---@class UIMsg: EventListener
UIMsg = {}
---@class MapMsg: EventListener
MapMsg = {}
---@class Chat: EventListener
Chat = {}

---Format a string and look up translation
--- This will tag the string as localized and it can only be used as text shown in UI
---@param format_string string Formatting string like string.format
---@param ... any
---@return string # Localized string
---@nodiscard
function L(format_string, ...) end

---Remove the localize tag from a localized string or mark a non-localized string as localized
--- This adds or removes the localize tag to show a string as is in UI (without translations) or store a translated string into saved data.
---@param str string # Input string
---@return string # Converted string
---@nodiscard
function NOLOC(str) end

---Custom random seed function which can take an arbitrary number of arguments of any type as input
---@param ... any
function math.randomseed(...) end

---Global data registry, can only be written to during startup and is read-only during afterwards.
---@class data
---@field all table<string, table> Contains all value/item/component/frame/visual/tech/codex/effect definitions (all must have unique IDs)
---@field values table<string, table> Value definitions
---@field items table<string, table> Item definitions
---@field components table<string, table> Component definitions
---@field frames table<string, table> Frame definitions
---@field visuals table<string, table> Visual definitions
---@field techs table<string, table> Tech definitions
---@field codex table<string, table> Codex definitions
---@field fx table<string, table> Effect definitions
---@field update_mapping table<string, string> Update mapping for renamed IDs
---@field settings table Global game settings
---@field colors table<string, Color> Named colors
---@field system_brushes table<string, table|string> UI graphic settings of built-in widgets
---@field brushes table<string, table|string> Custom UI graphic settings
---@field biomes table[] Biome definition array
---@field snow table Snow biome definition
---@field cliffs table<string, table> Cliff definitions
---@field land_features table[] Land feature array
---@field default_style table Default font style for UI text
---@field styles table<string, table> Custom text styles
---@field tooltip_layout string Layout of plain text tooltips
data = {}

---Define a custom class for generic tables (workaround for LLS bug https://github.com/LuaLS/lua-language-server/issues/2606)
---@class any_table
any_table = {}

---------------------------------------------------------------------------------------------------------------
---The action module contains functions that send (player input) actions  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#action)
Action = {}

---Send an action from the local player faction  
---A faction action can be registered with  
---function FactionAction.ACTIONID(faction, arg)
---@param action_id string Action id
---@param arg_table any_table? Additional action data (can be nil)
---@overload fun(action_id: string)
function Action.SendForLocalFaction(action_id, arg_table) end

---Send an action for an entity owned by the local player faction  
---An entity action can be registered with  
---function EntityAction.ACTIONID(entity, arg)
---@param action_id string Action id
---@param action_entity Entity Entity the action is for (must be owned by the local player)
---@param arg_table any_table? Additional action data (can be nil)
---@overload fun(action_id: string, action_entity: Entity)
function Action.SendForEntity(action_id, action_entity, arg_table) end

---Send a grouped entity action for all selected entities  
---Will automatically filter out construction sites and entities not owned by the local player faction
---@param action_id string Action id
---@param arg_table any_table? Additional action data (can be nil)
---@overload fun(action_id: string)
function Action.SendForSelectedEntities(action_id, arg_table) end

---Send a grouped entity action for a list of entities  
---Will automatically filter out construction sites and entities not owned by the local player faction
---@param action_id string Action id
---@param entity_array Entity[] Array of entities the action is for
---@param arg_table any_table? Additional action data (can be nil)
---@overload fun(action_id: string, entity_array: Entity[])
function Action.SendForEntities(action_id, entity_array, arg_table) end

---Send an action for a construction entity owned by the local player faction  
---A construction action can be registered with  
---function ConstructionAction.ACTIONID(entity, arg)
---@param action_id string Action id
---@param construction_entity Entity Entity the action is for (must be under construction and owned by the local player)
---@param arg_table any_table? Additional action data (can be nil)
---@overload fun(action_id: string, construction_entity: Entity)
function Action.SendForConstruction(action_id, construction_entity, arg_table) end

---Send an action from the player  
---A player action can be registered with  
---function PlayerAction.ACTIONID(player_id, faction, arg)
---@param action_id string Action id
---@param arg_table any_table? Additional action data (can be nil)
---@overload fun(action_id: string)
function Action.SendFromPlayer(action_id, arg_table) end

---Run code in UI context for the player that initiated the currently executing action   
---Must be called while executing an action and will execute for the one player that sent the action (to limit to other players use `faction:RunUI` or `UI.Run`)
---@param func function LUA function to execute in UI context
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(func: function)
function Action.RunUI(func, ...) end

---Run code in UI context for the player that initiated the currently executing action   
---Must be called while executing an action and will execute for the one player that sent the action (to limit to other players use `faction:RunUI` or `UI.Run`)
---@param uimsg_name string Message name registered in UIMsg
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(uimsg_name: string)
---@overload fun(uimsg_name: string, ...: any) -- dotdotdot
---@overload fun(func: function, ...: any)
function Action.RunUI(uimsg_name, ...) end

---Set player ready during the startup of a scenario using DelayedPlayerFactionSpawn mode
---@param state boolean? Ready state (OPTIONAL, default true)
---@overload fun()
function Action.SetPlayerReady(state) end

---Returns if a replay is being played back
---@return boolean # Replay state
function Action.IsReplayPlayback() end

---Returns the playback progress of the replay
---@param days_not_ticks boolean? Return the time in in-game days instead of ticks (OPTIONAL, default false)
---@return number # Ticks or days since replay start
---@overload fun(): number
function Action.GetReplayProgress(days_not_ticks) end

---Returns the total duration of the replay
---@param days_not_ticks boolean? Return the time in in-game days instead of ticks (OPTIONAL, default false)
---@return number # Duration in ticks or days
---@overload fun(): number
function Action.GetReplayDuration(days_not_ticks) end

---Set replay playback speed
---@param replay_speed number Replay speed
function Action.SetReplaySpeed(replay_speed) end

---Set replay viewed faction
---@param faction_id string Faction id to view
function Action.SetReplayViewFaction(faction_id) end

---Restart replay
function Action.RestartReplay() end

---While playing a replay, stop the replay and continue playing from here
function Action.ReplayPlayFromHere() end

---------------------------------------------------------------------------------------------------------------
---The debug module contains debug functions  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#debug)
Debug = {}

---Assert a condition during automated tests and data validation
---@param condition any Condition
---@param ... any? Message (multiple values are just concatenated)
---@return boolean # Condition result (converted to logical boolean if input was not a boolean)
---@overload fun(condition: any): boolean
function Debug.Assert(condition, ...) end

---Ending an automated test scenario
function Debug.EndTest() end

---Print the current call stack
function Debug.PrintCallStack() end

---Get lua internal memory stats
---@return table<string, integer> # Stats
function Debug.GetStats() end

---Get a hash of the entire map state
---@return integer # Map hash number
---@return integer # All hash number
function Debug.GetMapStateHash() end

---Start or stop tracking of all LUA memory allocations  
---Will log all new allocations that have not been freed between starting and stopping.
---@param state boolean State
function Debug.SetMemoryTracking(state) end

---Time some code
---@return number # Number of milliseconds (returned every second call)
function Debug.Benchmark() end

---Crash the program (only works in mod development mode)
function Debug.CrashProgram() end

---Reload Lua code (only works in mod development mode and only while not playing multiplayer)
function Debug.Reload() end

---Enable the LUA debugger server even while playing multiplayer
function Debug.AllowDebuggerInMultiplayer() end

---------------------------------------------------------------------------------------------------------------
---The game module contains global functions  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#game)
Game = {}

---Start a new game
---@param game_settings any_table New game settings (scenario, seed, etc.)
---@param disable_replay boolean? If replay recording is to be disabled (OPTIONAL, default false)
---@param multiplayer_settings any_table? Session settings when starting a multiplayer server (OPTIONAL, default nil)
---@overload fun(game_settings: any_table)
---@overload fun(game_settings: any_table, disable_replay: boolean)
---@overload fun(game_settings: any_table, multiplayer_settings: any_table?)
function Game.NewGame(game_settings, disable_replay, multiplayer_settings) end

---Restart the current scenario with the same game settings
function Game.RestartGame() end

---End the current game and return to the main menu
function Game.EndGame() end

---Quit the game to desktop
function Game.QuitGame() end

---Pauses the game (is only effective while playing without multiplayer)  
---If called multiple times with true, needs to be called equal amounts with false.
---@param pause boolean Pause state
function Game.OfflinePause(pause) end

---Get a loaded mod package
---@param mod_package_path string Mod package path ("Mod/Package")
---@return ModPackage? # Module package (or nil on error)
function Game.GetModPackage(mod_package_path) end

---Get all currently active mod packages
---@return ModPackage[] # Table of all active mod packages
function Game.GetModPackages() end

---Get the mod package of the currently running scenario
---@return ModPackage # Module package
function Game.GetScenarioModPackage() end

---Get meta data of all installed mods
---@return table[] # Array of tables with mod meta data
function Game.GetInstalledMods() end

---Get meta data of all packages from an installed mod
---@param arg_table string Mod id
---@return table[] # Array of tables with package meta data
function Game.GetInstalledModPackages(arg_table) end

---Get meta data of one package and its mod
---@param mod_package_path string Mod package path ("Mod/Package")
---@return table? # Array of tables with package meta data
---@return table? # Array of tables with mod meta data (or nil if package doesn't exist)
function Game.GetInstalledModPackage(mod_package_path) end

---Set a mods enabled state  
---Will be applied when the next map starts.
---@param mod_id string Mod id
---@param enable boolean Mod enable state
---@return string # Name of missing dependency if mod could not be enabled (or nil if all dependencies of at least one package are available)
function Game.SetModEnabled(mod_id, enable) end

---Refresh the list of installed mods and call mod change callbacks  
---UIOnModAdded with parameters id, name for newly added mods  
---UIOnModRemoved with parameters id, name for removed mods
function Game.RefreshInstalledMods() end

---Get the name of the mod management system of this platform
---@return string? # System name (or nil if none available)
function Game.GetNativeModManagerName() end

---Open the native the mod management system of this platform (if available)
function Game.OpenNativeModManager() end

---Get command line arguments
---@return string # Command line arguments
function Game.GetCommandLineArguments() end

---Save save game
---@param title string Save title
---@param slot_name string? Slot name (OPTIONAL, pass nil to save into a new slot)
---@return string? # Written slot name (or nil if save operation failed)
---@overload fun(title: string): string?
function Game.SaveGame(title, slot_name) end

---Load save game
---@param slot_name string Slot name
---@param multiplayer_settings any_table? Session settings when starting a multiplayer server (OPTIONAL, default nil)
---@param reset_mods boolean? Reset mods to the currently active ones (OPTIONAL, default false)
---@overload fun(slot_name: string)
---@overload fun(slot_name: string, multiplayer_settings: any_table)
---@overload fun(slot_name: string, reset_mods: boolean?)
function Game.LoadGame(slot_name, multiplayer_settings, reset_mods) end

---Play save game replay
---@param slot_name string Slot name
function Game.ReplayGame(slot_name) end

---Delete save game
---@param slot_name string Slot name
---@return boolean # Result
function Game.DeleteGame(slot_name) end

---Rename save game
---@param slot_name string Slot name
---@param new_title string New save title
---@return string? # Written slot name (or nil if rename operation failed)
function Game.RenameGame(slot_name, new_title) end

---Get the list of all save games
---@return table # Save game list table
function Game.GetSaveGameList() end

---Get list of mod packages that were in use when the save game was created.  
---Besides the basic fields (id, name, mod_id, mod_name, mod_version_code) the info table can contain the following flags:  
---- is_scenario: Set on the package that is the scenario  
---- error_missing: Set if the mod or package is now missing  
---- error_dependencies: Set if the mod now has missing dependencies  
---- error_version: Set if the save was made with a newer mod version than installed  
---- now_disabled: Set if the save was made with an addon that is now disabled or has any of the errors above  
---- now_enabled: Set if the save was made with an addon that has since been enabled  
---The tables in the resulting array can optionally have error flags 'error_missing' or 'error_version' set.
---@param slot_name string Slot name
---@return table[] # Array of mod package info tables
function Game.GetSaveGameModPackages(slot_name) end

---Check if save was made with older version of the game with which a new save won't be forward compatible with.  
---This checks both mod versions as well as the game internal save version number.
---@param slot_name string Slot name
---@return boolean # True if save was made with an older version
function Game.IsSaveGameOldVersion(slot_name) end

---Get if any save game exists
---@return boolean # True if any save game exists
function Game.HaveAnySaveGame() end

---Get auto save time setting
---@return integer # Auto save minutes (or 0 if disabled)
function Game.GetAutoSaveTime() end

---Set auto save time setting
---@param minutes integer Auto save minutes (or 0 to disable)
function Game.SetAutoSaveTime(minutes) end

---Get lock mouse option
---@return boolean # Option
function Game.GetMouseLock() end

---Set lock mouse option
---@param option boolean Option
function Game.SetMouseLock(option) end

---Get drag scrolling option
---@return boolean # Option
function Game.GetDragScrolling() end

---Set drag scrolling option
---@param option boolean Option
function Game.SetDragScrolling(option) end

---Get edge scrolling option
---@return boolean # Option
function Game.GetEdgeScrolling() end

---Set edge scrolling option
---@param option boolean Option
function Game.SetEdgeScrolling(option) end

---Get scroll speed setting
---@return number # Speed
function Game.GetScrollSpeed() end

---Set scroll speed setting
---@param speed number Speed
function Game.SetScrollSpeed(speed) end

---Get the play time
---@return number # Total number of seconds of play time
function Game.GetGameDuration() end

---Get the time that passed since the map was last saved
---@return number # Seconds since the map was last saved
function Game.GetTimeSinceSave() end

---Get the game version
---@return string # Game version
function Game.GetVersionString() end

---Get the local player faction
---@return Faction # Local player faction (or nil if there is none)
function Game.GetLocalPlayerFaction() end

---Get the local player extra data  
---If called without argument from a mod other than 'Main', will return a mod specific child table parent.mods[mod_id]  
---If called with an empty string or nil, will always return entire parent table
---@param mod_id string|nil? Mod id (OPTIONAL)
---@return table # Local player extra data table
---@overload fun(): table
function Game.GetLocalPlayerExtra(mod_id) end

---Get the local profile table  
---If called without argument from a mod other than 'Main', will return a mod specific child table parent.mods[mod_id]  
---If called with an empty string or nil, will always return entire parent table
---@param mod_id string|nil? Mod id (OPTIONAL)
---@return table # Profile table
---@overload fun(): table
function Game.GetProfile(mod_id) end

---Change the color mapping mode
---@param mode string Mode
function Game.SetColorMapping(mode) end

---Convert a color according to the color mapping
---@param color Color Input color
---@return Color # Mapped color
function Game.GetMappedColor(color) end

---Create an online session
---@param multiplayer_settings table Session settings
---@param on_complete function LUA function callback when complete (with 1 argument boolean success)
function Game.CreateOnlineSession(multiplayer_settings, on_complete) end

---Create an online session
---@param on_complete function LUA function callback when complete (with 2 arguments boolean success and table session list)
---@param lan boolean? True to search for servers on LAN, false to search lobbies on online service if available (OPTIONAL, default false)
---@overload fun(on_complete: function)
function Game.FindOnlineSessions(on_complete, lan) end

---Join an online session
---@param session_number integer Session number (in result list of FindOnlineSessions) to join. You can pass 0 or nil to join the most recent invited session.
---@param password string? Server password (OPTIONAL)
---@param on_complete function? LUA function callback when complete (with 1 argument boolean success) (OPTIONAL)
---@overload fun(session_number: integer)
---@overload fun(session_number: integer, password: string)
---@overload fun(session_number: integer, on_complete: function?)
function Game.JoinOnlineSession(session_number, password, on_complete) end

---Join an online session
---@param hostname string Server hostname (with optional :port suffix) to join with direct IP connection
---@param password string? Server password (OPTIONAL)
---@param on_complete function? LUA function callback when complete (with 1 argument boolean success) (OPTIONAL)
---@overload fun(hostname: string)
---@overload fun(hostname: string, password: string)
---@overload fun(hostname: string, on_complete: function?)
---@overload fun(session_number: integer, password: string, on_complete: function?)
function Game.JoinOnlineSession(hostname, password, on_complete) end

---End online session (stop server or go back to title on client)
function Game.EndOnlineSession() end

---Returns if online lobbies are available and sessions can be created with visibility PUBLIC/FRIENDS/INVITE
---@return boolean # Availability
function Game.OnlineHaveLobbies() end

---Returns if friend inviting is available
---@return boolean # Availability (true if available on platform and currently in a multiplayer session)
function Game.CanInviteFriend() end

---Show the friend invite UI to invite them to the current session
function Game.ShowFriendInviteUI() end

---Get the current network mode
---@return string # Mode string ('offline', 'server' or 'client')
function Game.GetNetMode() end

---Get a table of all connected multiplayer players
---@return table # Player list
function Game.GetAllPlayers() end

---Get a connected player by id
---@param player_id integer Player id
---@return table # Player details
function Game.GetPlayerById(player_id) end

---Get player details of the local player
---@return table # Player details
function Game.GetLocalPlayer() end

---Get player id of the local player
---@return integer # Player id
function Game.GetLocalPlayerId() end

---Get the name of a connected player
---@param player_id integer? Player id (OPTIONAL, defaults to local player)
---@return string # Player name
---@overload fun(): string
function Game.GetPlayerName(player_id) end

---Check if a given player id belongs to the host player
---@param player_id integer? Player id (OPTIONAL, defaults to local player)
---@return boolean # True if player is the host player
---@overload fun(): boolean
function Game.IsHostPlayer(player_id) end

---Check if a given player id belongs to the local player
---@param player_id integer Player id
---@return boolean # True if player is the local player
function Game.IsLocalPlayer(player_id) end

---Kick a player from the server (only available to the host of a locally running session)
---@param player_id integer Player id
---@param ban boolean? True to ban the player until the game on the server is restarted (OPTIONAL, default false)
---@overload fun(player_id: integer)
function Game.KickPlayer(player_id, ban) end

---Get the number of connected players  
---Will be 1 in single player, and 0 on a dedicated server without anyone connected
---@return integer # Player count
function Game.GetPlayerCount() end

---Get the maximum number of multiplayer players (or 1 if offline)
---@return integer # Max player count
function Game.GetMaxPlayerCount() end

---Get information about the current multiplayer session (returns nil if there is no session)
---@return string? # Name of the session
---@return boolean? # True if the server is dedicated
---@return SessionVisibility? # Visibility (PUBLIC, FRIENDS, INVITE, LOCKED, LAN)
function Game.GetMultiplayerSession() end

---Get the session settings used to start hosting the session. Only the host can use this.
---@return table? # Session settings table (or nil if not hosting a session)
function Game.GetHostSessionSettings() end

---Modify host session settings. Only the host can use this.  
---Not all fields that can be passed to `CreateOnlineSession` are supported.
---@param multiplayer_settings table Session settings
function Game.ModifyHostSessionSettings(multiplayer_settings) end

---Get which player has a given entity selected
---@param entity Entity Entity to check
---@return table? # List of player ids (or nil if none)
function Game.GetEntitySelectedPlayerId(entity) end

---Get the display fullscreen mode
---@return FullscreenMode # Mode ('windowed', 'borderless', 'fullscreen')
function Game.GetFullscreenMode() end

---Change the display fullscreen mode
---@param mode FullscreenMode Mode ('windowed', 'borderless', 'fullscreen')
function Game.SetFullscreenMode(mode) end

---Get active screen resolution
---@return integer # X resolution
---@return integer # Y resolution
function Game.GetScreenResolution() end

---Set screen resolution
---@param x integer X resolution
---@param y integer Y resolution
function Game.SetScreenResolution(x, y) end

---Get a list screen resolutions appropriate for the current fullscreen mode
---@return table # Resolution list
function Game.GetScreenResolutions() end

---Apply resolution and fullscreen mode settings
---@return boolean # True if a followup call to ConfirmScreenMode or RevertScreenMode is needed
function Game.ApplyScreenModeRequired() end

---Apply resolution and fullscreen mode settings
---@return boolean # True if a followup call to ConfirmScreenMode or RevertScreenMode is needed
function Game.ApplyScreenModeNeedConfirm() end

---Confirm changed resolution and fullscreen mode settings
function Game.ConfirmScreenMode() end

---Revert resolution and fullscreen mode to last confirmed settings
function Game.RevertScreenMode() end

---Read video settings table  
---- vsync: VSync enabled state (BOOLEAN)  
---- frame_rate_limit: Frame rate limit (0 means unlimited) (NUMBER)  
---- hdr_output: HDR output state (BOOLEAN)  
---- overall_quality: Overall video quality level (0 - 3) (NUMBER)  
---- view_distance_quality: View distance quality (0 - 3) (NUMBER)  
---- effect_quality: Effect and Volumetric fog quality (0 - 3) (NUMBER)  
---- shadow_quality: Shadow quality (0 = disabled, 3 = max) (NUMBER)  
---- anti_alias_quality: Anti-aliasing quality (0 = disabled, 3 = max) (NUMBER)  
---- bloom_quality: Bloom quality (0 = disabled, 5 = max) (NUMBER)  
---- depth_of_field_quality: Depth of field quality level (0 = disabled, 4 = max) (NUMBER)  
---- depth_of_field_strength: Depth of field strength (NUMBER)  
---- gamma: Gamma value (NUMBER)  
---- safe_mode: Only available if safe mode has been activated after a game crash (BOOLEAN)
---@return table # Settings table
function Game.GetVideoSettings() end

---Get supported Upscaling modes and features
---@return table # Table with modes and strings for all supported Upscaling modes and features
function Game.GetSupportedUpscalingModes() end

---Modify video settings
---@param video_settings table Table with settings that are to be changed (see `GetVideoSettings`)
function Game.SetVideoSettings(video_settings) end

---Get the volume of a mix type
---@param type string Volume type ('master', 'effect', 'music', 'voice', 'ui')
---@return number # Volume percentage (100 means full volume)
function Game.GetVolume(type) end

---Set the volume of a mix type
---@param type string Volume type ('master', 'effect', 'music', 'voice', 'ui')
---@param percentage number Volume percentage (100 means full volume)
function Game.SetVolume(type, percentage) end

---Get the volume of the game while unfocused
---@return number # Volume percentage (100 means full volume)
function Game.GetUnfocusedVolume() end

---Set the volume of the game while unfocused
---@param percentage number Volume percentage (100 means full volume)
function Game.SetUnfocusedVolume(percentage) end

---Load the news text table from the online source
---@param on_complete function LUA function callback when complete (with a table argument containing the news items)
function Game.GetNewsText(on_complete) end

---Open Website to a special URL
---@param site_name string Site name (one of "STORE", "DISCORD", "NEWSLETTER", "WIKI", "FEEDBACK")
---@param arg integer? Numerical extra argument for FEEDBACK (OPTIONAL)
---@overload fun(site_name: string)
function Game.OpenWebsite(site_name, arg) end

---Open OS file browser to a special folder
---@param type string Special folder name (one of "SAVEGAMES", "LOGS", "MODS")
function Game.ExploreFolder(type) end

---Send feedback to the developers
---@param rating integer Feedback rating
---@param category string Feedback category
---@param text string Feedback text
---@param attach_save boolean Attach save state
---@param attach_screenshot boolean Attach captured feedback screenshot
---@param on_complete function LUA function callback when complete (with one boolean argument containing success state)
function Game.SendFeedback(rating, category, text, attach_save, attach_screenshot, on_complete) end

---Unlock an achievement (only available on unmodded/unmodified game)
---@param id string Achievement ID
function Game.UnlockAchievement(id) end

---------------------------------------------------------------------------------------------------------------
---The Input module contains Input functions  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#input)
Input = {}

---Check if the shift key is pressed (either left or right shift key)
---@return boolean # Key state
function Input.IsShiftDown() end

---Check if the control key is pressed (either left or right control key)
---@return boolean # Key state
function Input.IsControlDown() end

---Check if the alt key is pressed (either left or right alt key)
---@return boolean # Key state
function Input.IsAltDown() end

---Check if a specific key is pressed  
---This does not work while a modal UI view is open
---@param key_name string Key name
---@return boolean # Key pressed state
function Input.IsKeyDown(key_name) end

---Bind a callback function to a named input action
---@param action_name string Action name
---@param event string Key event (one of 'Pressed', 'Released', 'Repeat', 'DoubleClick', 'Axis')
---@param func function Lua Function
---@return integer # Binding handle (for use with RemoveActionBinding)
function Input.BindAction(action_name, event, func) end

---Bind a callback function to a named input action
---@param action_name string Action name
---@param event string Key event (one of 'Pressed', 'Released', 'Repeat', 'DoubleClick', 'Axis')
---@param built_in string Built in game function name
---@return integer # Binding handle (for use with RemoveActionBinding)
---@overload fun(action_name: string, event: string, func: function): integer
function Input.BindAction(action_name, event, built_in) end

---Bind a callback function to a named input axis
---@param axis_name string Axis name
---@param func function Lua Function
function Input.BindAxis(axis_name, func) end

---Bind a callback function to a named input axis
---@param axis_name string Axis name
---@param built_in string Built in game function name
---@overload fun(axis_name: string, func: function)
function Input.BindAxis(axis_name, built_in) end

---Remove bound callback functions from a named input action
---@param action_name string Action name
---@param handle integer? Action handle (OPTIONAL, return value of BindAction, clear all if not passed)
---@overload fun(action_name: string)
function Input.RemoveActionBinding(action_name, handle) end

---Remove all bound callback functions from a named input axis
---@param axis_name string Axis name
function Input.RemoveAxisBinding(axis_name) end

---Map a physical input key to a named input action
---@param action_name string Action name
---@param key_name string Key name
---@param options any_table? Options (OPTIONAL, default none)
---@overload fun(action_name: string, key_name: string)
function Input.AddActionMapping(action_name, key_name, options) end

---Map a physical input key to a named input axis
---@param axis_name string Axis name
---@param key_name string Key name
---@param scale number? Scale (OPTIONAL, default 1.0)
---@overload fun(axis_name: string, key_name: string)
function Input.AddAxisMapping(axis_name, key_name, scale) end

---Remove previously mapped physical inputs from a named input action
---@param action_name string Action name
---@param key_name string? Key name (OPTIONAL, remove all if not given)
---@overload fun(action_name: string)
function Input.RemoveActionMapping(action_name, key_name) end

---Check if a key is bound to an action
---@param key_name string Key name
---@param action_name string Action name
---@return boolean # Is bound
function Input.IsBoundToAction(key_name, action_name) end

---Check if a key is bound to an axis
---@param key_name string Key name
---@param axis_name string Axis name
---@return boolean # Is bound
function Input.IsBoundToAxis(key_name, axis_name) end

---Remove previously mapped physical inputs from a named input axis
---@param axis_name string Axis name
---@param key_name string? Key name (OPTIONAL, remove all if not given)
---@overload fun(axis_name: string)
function Input.RemoveAxisMapping(axis_name, key_name) end

---Get a table with all key names of a category
---@param category string Category (one of "KEYBOARD", "MOUSE" or "GAMEPAD")
---@return table<string, string> # Table with key ids and localized key names
function Input.GetBindingNames(category) end

---Get the name of an unknown key binding name not returned with `GetBindingNames`
---@param key_id string Key ID
---@return string? # Localized key name or nil if unknown
function Input.GetUnknownKeyBindingName(key_id) end

---Set custom input processor which can pre-process all input events  
---If the passed lua function returns boolean true the event will be forwarded to the games regular input handling  
---is_down is relevant for button events (keyboard, mouse buttons, gamepad buttons)  
---axis is a numerical value for analog inputs (gamepad analog inputs, mouse screen position)  
---mouse_delta is a numerical value of the change for mouse inputs (mouse position, mouse wheel)
---@param callback function Lua function called with arguments (key_name, is_down, axis, mouse_delta)
---@param disable_deadzone boolean? Pass true to not apply dead zone scaling to analog gampead inputs (OPTIONAL, default false)
---@param disable_repeats boolean? Pass true to not filter out periodical repeat button press events (OPTIONAL, default false)
---@overload fun(callback: function)
---@overload fun(callback: function, disable_deadzone: boolean)
function Input.SetInputProcessor(callback, disable_deadzone, disable_repeats) end

---Clear the active custom input processor
function Input.ClearInputProcessor() end

---------------------------------------------------------------------------------------------------------------
---The map module contains global functions affecting the game state  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#map)
Map = {}

---Modify simulation speed
---@param speed integer Game speed
function Map.SetGameSpeed(speed) end

---Get simulation speed
---@return integer # Game speed
function Map.GetGameSpeed() end

---Check if LUA is currently running in simulation context
---@return boolean # True if in simulation context, false if in UI context
function Map.IsSimulation() end

---Check if the active map is the front-end menu
---@return boolean # True if front-end
function Map.IsFrontEnd() end

---Get current map settings (read only)
---@return table # Current map settings
function Map.GetSettings() end

---Set or modify a map setting  
---Settings that affect world generation or sun simulation shouldn't be changed after the game has started, otherwise the game will break or get out of sync.
---@param key string Settings key
---@param value any New value
function Map.ModifySettings(key, value) end

---Set or modify a map setting  
---Settings that affect world generation or sun simulation shouldn't be changed after the game has started, otherwise the game will break or get out of sync.
---@param table any_table Flat array with keys and values (key1, val1, key2, val2, ...)
---@overload fun(key: string, value: any)
function Map.ModifySettings(table) end

---Get map seed (same as GetSettings().seed)
---@return integer # Current map seed
function Map.GetSeed() end

---Get save table (can only be modified in simulation context)  
---If called without argument from a mod that doesn't contain the currently active scenario, will return a mod specific child table parent.mods[mod_id]  
---If called with an empty string or nil, will always return entire parent table
---@param mod_id string|nil? Mod id (OPTIONAL)
---@return table # Save table
---@overload fun(): table
function Map.GetSave(mod_id) end

---Call bound MapMsg functions
---@param msg_name string Message name registered in MapMsg
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(msg_name: string)
function Map.Run(msg_name, ...) end

---Get the current simulation tick number
---@return integer # Tick number
function Map.GetTick() end

---Get the number of player actions that have been executed
---@return integer # Action count
function Map.GetExecutedActionCount() end

---Create a new entity from a frame definition
---@param faction FactionOrId Faction or faction id
---@param frame_id string Frame id
---@param visual_id string? Specific visual id or another frame id from which to use the visual (OPTIONAL, defaults to frame visual)
---@param is_map_generation boolean? Pass true for entities spawned as part of map generation (OPTIONAL)
---@return Entity # Created entity object (or nil on error)
---@overload fun(faction: FactionOrId, frame_id: string): Entity
---@overload fun(faction: FactionOrId, frame_id: string, visual_id: string): Entity
---@overload fun(faction: FactionOrId, frame_id: string, is_map_generation: boolean?): Entity
function Map.CreateEntity(faction, frame_id, visual_id, is_map_generation) end

---Recreate an entity with a new frame definition but keep any references to it
---@param entity Entity Existing entity to be recreated
---@param frame_id string Frame id
---@param visual_id string? Specific visual id or another frame id from which to use the visual (OPTIONAL, defaults to frame visual)
---@param pass_extra_data boolean? Pass false to dispose extra data instead of passing it on (OPTIONAL, default true)
---@param pass_or_drop_items boolean? Pass false to destroy inventory content instead of passing or dropping it (OPTIONAL, default true)
---@param replace_on_map boolean? Pass false to not replace the entity back onto the map (OPTIONAL, default true)
---@return Entity # The same entity object (or nil on error)
---@overload fun(entity: Entity, frame_id: string): Entity
---@overload fun(entity: Entity, frame_id: string, visual_id: string): Entity
---@overload fun(entity: Entity, frame_id: string, pass_extra_data: boolean?): Entity
---@overload fun(entity: Entity, frame_id: string, visual_id: string, pass_extra_data: boolean?): Entity
---@overload fun(entity: Entity, frame_id: string, pass_extra_data: boolean?, pass_or_drop_items: boolean?): Entity
---@overload fun(entity: Entity, frame_id: string, visual_id: string, pass_extra_data: boolean?, pass_or_drop_items: boolean?): Entity
---@overload fun(entity: Entity, frame_id: string, pass_extra_data: boolean?, pass_or_drop_items: boolean?, replace_on_map: boolean?): Entity
function Map.RecreateEntity(entity, frame_id, visual_id, pass_extra_data, pass_or_drop_items, replace_on_map) end

---Drop an item at a specific location.  
---Will combine with existing dropped items if one exists and has space.  
---If this function is called while entities are being processed, the item will be dropped deferred (`Map.Defer` should still be used when this function is called multiple times).
---@param location Area Location
---@param item_id string Item id
---@param amount integer? Amount (OPTIONAL, default 1)
---@param extra_data any_table? Extra data table (OPTIONAL, default nil)
---@param frame_id string? Frame id (OPTIONAL, otherwise use default dropped item frame)
---@param visual_id string? Visual id (OPTIONAL, otherwise use default)
---@overload fun(x: integer, y: integer, item_id: string)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string)
---@overload fun(location: Area, item_id: string)
---@overload fun(x: integer, y: integer, item_id: string, amount: integer)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, amount: integer)
---@overload fun(location: Area, item_id: string, amount: integer)
---@overload fun(x: integer, y: integer, item_id: string, extra_data: any_table?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, extra_data: any_table?)
---@overload fun(location: Area, item_id: string, extra_data: any_table?)
---@overload fun(x: integer, y: integer, item_id: string, frame_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, frame_id: string?)
---@overload fun(location: Area, item_id: string, frame_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, amount: integer, extra_data: any_table?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, amount: integer, extra_data: any_table?)
---@overload fun(location: Area, item_id: string, amount: integer, extra_data: any_table?)
---@overload fun(x: integer, y: integer, item_id: string, amount: integer, frame_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, amount: integer, frame_id: string?)
---@overload fun(location: Area, item_id: string, amount: integer, frame_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, extra_data: any_table?, frame_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, extra_data: any_table?, frame_id: string?)
---@overload fun(location: Area, item_id: string, extra_data: any_table?, frame_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, frame_id: string?, visual_id: string?)
---@overload fun(location: Area, item_id: string, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, amount: integer, extra_data: any_table?, frame_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, amount: integer, extra_data: any_table?, frame_id: string?)
---@overload fun(location: Area, item_id: string, amount: integer, extra_data: any_table?, frame_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, amount: integer, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, amount: integer, frame_id: string?, visual_id: string?)
---@overload fun(location: Area, item_id: string, amount: integer, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, extra_data: any_table?, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, extra_data: any_table?, frame_id: string?, visual_id: string?)
---@overload fun(location: Area, item_id: string, extra_data: any_table?, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, item_id: string, amount: integer, extra_data: any_table?, frame_id: string?, visual_id: string?)
---@overload fun(x: integer, y: integer, width: integer, height: integer, item_id: string, amount: integer, extra_data: any_table?, frame_id: string?, visual_id: string?)
function Map.DropItemAt(location, item_id, amount, extra_data, frame_id, visual_id) end

---Get a faction
---@param faction_id string Faction id
---@return Faction? # Faction object (or nil on error)
function Map.GetFaction(faction_id) end

---Create a new faction (or get it if it already exists)
---@param faction_id string Faction id
---@param player_controlled boolean? Set if this faction is to be controlled by a player (only applicable if the faction does not exist yet) (OPTIONAL, default false)
---@return Faction # Faction object
---@return boolean # True if this faction was newly created, false if it already existed
---@overload fun(faction_id: string): Faction, boolean
function Map.CreateFaction(faction_id, player_controlled) end

---Get all factions
---@return Faction[] # List of faction objects
function Map.GetFactions() end

---Get the number of spawned factions
---@return integer # Number of factions
function Map.GetFactionCount() end

---Get all player controlled factions
---@return Faction[] # List of faction objects
function Map.GetPlayerFactions() end

---Get the number of spawned player factions
---@return integer # Number of player controlled factions
function Map.GetPlayerFactionCount() end

---Switches a players faction
---@param player_id integer Player id
---@param faction_id string Faction id
function Map.SetPlayerFaction(player_id, faction_id) end

---Get the number of days progressed
---@return integer # Number of days (floating point value, fractional part indicates time of day)
function Map.GetTotalDays() end

---Get the current year
---@return integer # Current year
function Map.GetYear() end

---Get the current season value between 0-1, 0.5 being summer, 0/1 being winter
---@return number # Season value
function Map.GetYearSeason() end

---Get the current sunlight intensity
---@return number # Sunlight intensity
function Map.GetSunlightIntensity() end

---Get the current amount of sunlight (square root of sunlight intensity)
---@return number # Amount of sunlight (between 0.0 and 1.0 inclusive)
function Map.GetSunlightAmount() end

---Get the direction of the sunlight as a normalized vector
---@return number # Sunlight X direction
---@return number # Sunlight Y direction
function Map.GetSunlightDirection() end

---Get the day time of sunrise and sunset
---@param intensity_threshold number? Return time when the sun crosses a given amount of sunlight intensity (OPTIONAL, default 0.0)
---@return number # Sunrise time (between 0.0 and 1.0)
---@return number # Sunset time (between 0.0 and 1.0)
---@overload fun(): number, number
function Map.GetSunriseAndSunset(intensity_threshold) end

---Get the location of the Nth next unspawned chunk  
---The returned tile position is at the center of the unspawned 60x60 chunk
---@param number integer? Request the Nth undiscovered chunk (OPTIONAL, default first)
---@return integer # X position
---@return integer # Y position
---@overload fun(): integer, integer
function Map.GetUndiscoveredLocation(number) end

---Get the location of a tile at a given distance from a starting point  
---This function matches the behavior of `GetEntitiesOnLine`.
---@param start_area Area Area to start the line from
---@param end_area Area Area as directional indicator from the starting point
---@param distance integer Distance to query the coordinate for
---@return integer # X position
---@return integer # Y position
---@overload fun(x: integer, y: integer, end_area: Area, distance: integer): integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area, distance: integer): integer, integer
function Map.GetLocationInRange(start_area, end_area, distance) end

---Get the closest tile location of an area towards another area  
---Useful when starting area potentially is larger than 1x1.
---@param from_area Area Area to test from (result will be a tile in this area)
---@param to_area Area Area to test against
---@return integer # X coordinate
---@return integer # Y coordinate
---@overload fun(x: integer, y: integer, to_area: Area): integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, to_area: Area): integer, integer
function Map.GetClosestLocation(from_area, to_area) end

---Make sure chunks exist at the given location  
---If this function is called while entities are being processed, new chunks will spawn deferred.
---@param area Area Location or area to spawn chunks for
---@param discoverer Entity? Entity which is causing any new chunks to be spawned (OPTIONAL)
---@return integer # Returns how many new chunks were created (or will be if spawning is deferred)
---@overload fun(x: integer, y: integer): integer
---@overload fun(x: integer, y: integer, width: integer, height: integer): integer
---@overload fun(area: Area): integer
---@overload fun(x: integer, y: integer, discoverer: Entity): integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, discoverer: Entity): integer
function Map.SpawnChunks(area, discoverer) end

---Get blightness for a tile or area
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # blightness
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetBlightness(area, get_smallest, unplaced_value) end

---Get blightness delta against the blight threshold for a tile or area (same as `Map.GetBlightness(..) - Map.GetSettings().blight_threshold`)
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # blightness delta
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetBlightnessDelta(area, get_smallest, unplaced_value) end

---Get elevation for a tile or area
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # elevation
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetElevation(area, get_smallest, unplaced_value) end

---Get richness for a tile or area
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # richness
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetRichness(area, get_smallest, unplaced_value) end

---Get variation for a tile or area
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # variation
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetVariation(area, get_smallest, unplaced_value) end

---Get height for a tile or area
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # height
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetHeight(area, get_smallest, unplaced_value) end

---Get the height against the plateau height for a tile or area (same as `Map.GetHeight(..) - Map.GetPlateauHeight()`)
---@param area Area Location to check
---@param get_smallest boolean? If checking more than a single tile, return the smallest value instead of the biggest (OPTIONAL, default false)
---@param unplaced_value number? If the first argument is an entity that isn't placed on the map and not docked, return this value instead of an error (OPTIONAL)
---@return number # height delta
---@overload fun(x: integer, y: integer): number
---@overload fun(x: integer, y: integer, width: integer, height: integer): number
---@overload fun(area: Area): number
---@overload fun(x: integer, y: integer, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean): number
---@overload fun(area: Area, get_smallest: boolean): number
---@overload fun(x: integer, y: integer, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, unplaced_value: number?): number
---@overload fun(area: Area, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, get_smallest: boolean, unplaced_value: number?): number
---@overload fun(x: integer, y: integer, width: integer, height: integer, get_smallest: boolean, unplaced_value: number?): number
function Map.GetPlateauDelta(area, get_smallest, unplaced_value) end

---Get plateau height
---@return number # plateau height
function Map.GetPlateauHeight() end

---Get water height
---@return number # water height
function Map.GetWaterHeight() end

---Get table with full tile data for a given location
---@param x integer X coordinate
---@param y integer Y coordinate
---@return table # blightness, elevation, richness, variation
function Map.GetTileData(x, y) end

---Defer function until after components have been processed  
---For example, it is not possible to create new entities during processing, creation needs to be deferred.
---@param func function LUA function to execute after components have been processed
function Map.Defer(func) end

---Delay function for a given number of ticks  
---A delay function can be registered with  
---function Delay.FUNCTIONNAME(arg)
---@param delay_name string Function name
---@param delay_ticks integer Number of ticks to wait until called (0 is like using Defer function)
---@param arg_table any_table? Argument table to pass (OPTIONAL)
---@overload fun(delay_name: string, delay_ticks: integer)
function Map.Delay(delay_name, delay_ticks, arg_table) end

---Start terraforming
---@param entity Entity Entity
---@param range integer Range
---@param rate number Rate (change per tick)
---@return integer # Terraforming instance index
function Map.StartTerraforming(entity, range, rate) end

---End terraforming
---@param instance_index integer Terraforming instance index
function Map.StopTerraforming(instance_index) end

---Get an entity at a specific location  
---If there are multiple entities, it will return the first entity in the following order: blocking, non-blocking, foundation
---@param x integer X coordinate
---@param y integer Y coordinate
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@param faction FactionOrEntity? The faction that is considered self with regards to faction filters passed to the previous argument (must be passed for faction filters)
---@return Entity? # Entity (or nil if none)
---@overload fun(x: integer, y: integer): Entity?
---@overload fun(x: integer, y: integer, filter: integer): Entity?
---@overload fun(x: integer, y: integer, faction: FactionOrEntity?): Entity?
function Map.GetEntityAt(x, y, filter, faction) end

---Get a foundation entity at a specific location (faster than the function above)
---@param x integer X coordinate
---@param y integer Y coordinate
---@return Entity? # Entity (or nil if none)
function Map.GetFoundationEntityAt(x, y) end

---Get all entities at a specific location
---@param x integer X coordinate
---@param y integer Y coordinate
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@param faction FactionOrEntity? The faction that is considered self with regards to faction filters passed to the previous argument (must be passed for faction filters)
---@return Entity[] # Array of entities
---@overload fun(x: integer, y: integer): Entity[]
---@overload fun(x: integer, y: integer, filter: integer): Entity[]
---@overload fun(x: integer, y: integer, faction: FactionOrEntity?): Entity[]
function Map.GetEntitiesAt(x, y, filter, faction) end

---Get all entities in a range around a specific location or area  
---If an entity is used to specify the area, the result will not contain that entity.
---@param area Area Area to start the search from
---@param radius integer Search radius in tiles
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@param faction FactionOrEntity? The faction that is considered self with regards to faction filters passed to the previous argument (must be passed if no entity is specified as the area)
---@return Entity[] # Array of entities
---@overload fun(x: integer, y: integer, radius: integer): Entity[]
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer): Entity[]
---@overload fun(area: Area, radius: integer): Entity[]
---@overload fun(x: integer, y: integer, radius: integer, filter: integer): Entity[]
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, filter: integer): Entity[]
---@overload fun(area: Area, radius: integer, filter: integer): Entity[]
---@overload fun(x: integer, y: integer, radius: integer, faction: FactionOrEntity?): Entity[]
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, faction: FactionOrEntity?): Entity[]
---@overload fun(area: Area, radius: integer, faction: FactionOrEntity?): Entity[]
---@overload fun(x: integer, y: integer, radius: integer, filter: integer, faction: FactionOrEntity?): Entity[]
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, filter: integer, faction: FactionOrEntity?): Entity[]
function Map.GetEntitiesInRange(area, radius, filter, faction) end

---Get all entities on a line between two points or from a starting point until a given distance  
---If an entity is used to specify the starting area, the result will not contain that entity.  
---But an entity used for the ending area will be contained in the result.  
---The line of search will always be thin (just 1 tile) even if a passed area is wider.
---@param start_area Area Area to start the line from
---@param end_area Area Area to end the line at (or directional indicator if passing the next argument)
---@param distance integer? Search distance towards or beyond end coordinate instead of ending the line there (OPTIONAL, default -1)
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@param faction FactionOrEntity? The faction that is considered self with regards to faction filters passed to the previous argument (must be passed if no entity is specified as the area)
---@return Entity[] # Array of entities
---@return integer # X position of last tile checked
---@return integer # Y position of last tile checked
---@overload fun(x: integer, y: integer, end_area: Area): Entity[], integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area): Entity[], integer, integer
---@overload fun(start_area: Area, end_area: Area): Entity[], integer, integer
---@overload fun(x: integer, y: integer, end_area: Area, distance: integer): Entity[], integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area, distance: integer): Entity[], integer, integer
---@overload fun(start_area: Area, end_area: Area, distance: integer): Entity[], integer, integer
---@overload fun(x: integer, y: integer, end_area: Area, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(start_area: Area, end_area: Area, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, end_area: Area, distance: integer, filter: integer?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area, distance: integer, filter: integer?): Entity[], integer, integer
---@overload fun(start_area: Area, end_area: Area, distance: integer, filter: integer?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, end_area: Area, distance: integer, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area, distance: integer, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(start_area: Area, end_area: Area, distance: integer, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, end_area: Area, distance: integer, filter: integer?, faction: FactionOrEntity?): Entity[], integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, end_area: Area, distance: integer, filter: integer?, faction: FactionOrEntity?): Entity[], integer, integer
function Map.GetEntitiesOnLine(start_area, end_area, distance, filter, faction) end

---Search for the closest entity in a range  
---If an entity is used to specify the area, the callback will not be called for that entity.
---@param area Area Area to start the search from
---@param radius integer Search radius in tiles
---@param callback function Callback called for each entity in range in order of distance, return true from this to stop the search
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@param faction FactionOrEntity? The faction that is considered self with regards to faction filters passed to the previous argument (must be passed if no entity is specified as the area)
---@return Entity? # The entity for which the callback returned true (or nil if none)
---@overload fun(x: integer, y: integer, radius: integer, callback: function): Entity?
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, callback: function): Entity?
---@overload fun(area: Area, radius: integer, callback: function): Entity?
---@overload fun(x: integer, y: integer, radius: integer, callback: function, filter: integer): Entity?
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, callback: function, filter: integer): Entity?
---@overload fun(area: Area, radius: integer, callback: function, filter: integer): Entity?
---@overload fun(x: integer, y: integer, radius: integer, callback: function, faction: FactionOrEntity?): Entity?
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, callback: function, faction: FactionOrEntity?): Entity?
---@overload fun(area: Area, radius: integer, callback: function, faction: FactionOrEntity?): Entity?
---@overload fun(x: integer, y: integer, radius: integer, callback: function, filter: integer, faction: FactionOrEntity?): Entity?
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, callback: function, filter: integer, faction: FactionOrEntity?): Entity?
function Map.FindClosestEntity(area, radius, callback, filter, faction) end

---Get an entity from a key (obtained from `entity.key`)
---@param key integer Numerical entity key
---@return Entity # The entity object matching the key
function Map.GetEntityFromKey(key) end

---Count tiles in and around an area  
---To count number of owned entities, an entity needs to be specified as the area
---@param area Area Area to start the search from
---@param radius integer Search radius in tiles
---@param count_area boolean? Also count the tiles covering the area, otherwise only count in the radius outside (OPTIONAL, default false)
---@return integer # Number of blocked tiles due to landscape
---@return integer # Number of blocked tiles due to entity without movement or from another faction
---@return integer # Number of passable tiles with a construction site of the same faction
---@return integer # Number of passable tiles without a construction site of the same faction
---@return integer # Number of non-floating entities with movement of the same faction
---@overload fun(x: integer, y: integer, radius: integer): integer, integer, integer, integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer): integer, integer, integer, integer, integer
---@overload fun(area: Area, radius: integer): integer, integer, integer, integer, integer
---@overload fun(x: integer, y: integer, radius: integer, count_area: boolean): integer, integer, integer, integer, integer
---@overload fun(x: integer, y: integer, width: integer, height: integer, radius: integer, count_area: boolean): integer, integer, integer, integer, integer
function Map.CountTiles(area, radius, count_area) end

---Get all component instances of a given type  
---This is slow so please use it sparingly, preferably only for one-time global operations like version updates.
---@param component_id string Component id
---@param query_base_id boolean? Set to true to query the base_id value of component definitions if it exists (OPTIONAL, default false)
---@return Component[] # Array of components
---@overload fun(component_id: string): Component[]
function Map.GetComponents(component_id, query_base_id) end

---Show a item throw effect
---@param source_entity Entity Source entity
---@param target_entity Entity Target entity
---@param item_id string Item id
---@param instance_number integer? Render instance number (OPTIONAL)
---@overload fun(source_entity: Entity, target_entity: Entity, item_id: string)
function Map.ThrowItemEffect(source_entity, target_entity, item_id, instance_number) end

---------------------------------------------------------------------------------------------------------------
---The tool module contains utility functions  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#tool)
Tool = {}

---Create a checksum of a value
---@param ... any Value(s) (any type, can pass multiple values)
---@return integer # Checksum
function Tool.Hash(...) end

---Create a deep copy of a value, most often used with tables
---@param ... any Value(s) (any type, can pass multiple values)
---@return any # Copied value(s)
function Tool.Copy(...) end

---Truncate a string potentially containing Unicode characters
---@param string string String to be truncated
---@param length integer Maximum number of Unicode characters to return
---@param offset integer? How many Unicode characters should be skipped (OPTIONAL)
---@return string # Resulting truncated string
---@return boolean # True if the string was truncated or false if everything after the offset fit
---@overload fun(string: string, length: integer): string, boolean
function Tool.TruncateString(string, length, offset) end

---Compare two strings potentially containing Unicode characters case insensitive
---@param string1 string First string to be compared
---@param string2 string Second string to be compared
---@return boolean # True if the two strings are equal ignoring case
function Tool.CompareStringNoCase(string1, string2) end

---Check if a string exists inside another string case insensitive, where the strings potentially contain Unicode characters
---@param haystack string String in which to find another string
---@param needle string The part to find in the string of the first argument
---@return boolean # True if the string is contained ignoring case
function Tool.ContainsStringNoCase(haystack, needle) end

---Convert a lua table to a string
---@param table table Table
---@return string # Encoded string
function Tool.TableToString(table) end

---Convert a string back to a lua table
---@param string string Encoded string
---@return table # Table
function Tool.StringToTable(string) end

---Store a LUA table into the OS clipboard  
---The passed table should not be modified afterwards because Tool.GetClipboard will return the same table reference until the clipboard is modified.
---@param table any_table Table to set the clipboard to
---@param prefix_char string A one character identifier to be included in the prefix of the encoded string
function Tool.SetClipboard(table, prefix_char) end

---Store a LUA table into the OS clipboard  
---The passed table should not be modified afterwards because Tool.GetClipboard will return the same table reference until the clipboard is modified.
---@param str string String to set the clipboard to (only the main mod is allowed to pass raw strings)
---@param prefix_char string A one character identifier to be included in the prefix of the encoded string
---@overload fun(table: any_table, prefix_char: string)
function Tool.SetClipboard(str, prefix_char) end

---Retrieve a LUA table from the OS clipboard  
---The returned table should not be modified because the same table reference will get returned again until the clipboard is modified.
---@param prefix_char string? A one character identifier to check in the prefix of the encoded string (OPTIONAL, return any if omitted)
---@return table # Clipboard table content
---@return string # Decoded prefix character
---@overload fun(): table, string
function Tool.GetClipboard(prefix_char) end

---Encode the difference how to get from one lua table to another  
---This is useful if a table is slightly modified over time and a modification history is to be kept (i.e. for a undo/redo system)  
---The function must be first called without src_table_str to generate the encoded string of dst_table which then can be used on a secondary call.
---@param dst_table any_table The destination lua table to encode the difference to
---@param src_table_str string? The encoded old table as was returned on a previous call to this function or ApplyTableDelta (OPTIONAL)
---@return string # Encoded destination table (to use on another call to this function or ApplyTableDelta)
---@return string # Encoded difference to get from the destination table back to the source table (only returned when old_table_str is passed)
---@overload fun(dst_table: any_table): string, string
function Tool.GetTableDelta(dst_table, src_table_str) end

---Apply an encoded difference string to revert a table back to the source table after using GetTableDelta
---@param dst_table_str string The encoded destination table as was returned by a call to GetTableDelta or this function
---@param delta_str string The encoded difference as was returned by a call to GetTableDelta or this function
---@param get_reverse boolean? Return an encoded table and difference to go forward again to the destination
---@return table # The source table
---@return string # Encoded returned source table (only returned when get_reverse is passed)
---@return string # Encoded difference to get from the returned source table back again to the passed destination table (only returned when get_reverse is passed)
---@overload fun(dst_table_str: string, delta_str: string): table, string, string
function Tool.ApplyTableDelta(dst_table_str, delta_str, get_reverse) end

---Format a date and time value as a string  
---Will use current time if no timestamp gets passed.
---@param date_format string? Date format (OPTIONAL, defaults to "%Y.%m.%d-%H.%M.%S")
---@return string # Formatted date/time string
---@overload fun(): string
function Tool.GetDateStr(date_format) end

---Format a date and time value as a string  
---Will use current time if no timestamp gets passed.
---@param unix_timestamp integer Unix timestamp
---@param date_format string? Date format (OPTIONAL, defaults to "%Y.%m.%d-%H.%M.%S")
---@return string # Formatted date/time string
---@overload fun(unix_timestamp: integer): string
---@overload fun(date_format: string): string
function Tool.GetDateStr(unix_timestamp, date_format) end

---Format a time duration to a string (HH:MM:SS)
---@param seconds number Seconds
---@return string # Formatted time duration string
function Tool.GetTimeDurationStr(seconds) end

---Create an empty or copied register object
---@param source Register|any_table|nil Copy contents from another register or a table (OPTIONAL)
---@return Register # New register object
function Tool.NewRegisterObject(source) end

---Parse binary entity state bit-flags into a readable table
---@param states integer States bitflag number
---@return EntityState[] # State names
function Tool.ParseEntityStates(states) end

---Encode readable table into binary entity state bit-flags
---@param states EntityState[] State names
---@return integer # States bitflag number
function Tool.EncodeEntityStates(states) end

---Encode readable table into binary trust level bit-flags
---@param levels FactionTrust[] Trust level names
---@return integer # Levels bitflag number
function Tool.EncodeTrustLevels(levels) end

---------------------------------------------------------------------------------------------------------------
---The twitch module contains functions that interact with Twitch.  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#twitch)
Twitch = {}

---Start the auth process on Twitch unless already logged in  
---Once logged in the authentication data is stored to disk and login is not needed until logged out
---@param callback function Callback which will get called with true or false depending on success
function Twitch.Login(callback) end

---Clear any stored authentication parameters if logged in
function Twitch.Logout() end

---Check if the user is logged in on Twitch
---@return boolean # Login status
function Twitch.IsLoggedIn() end

---Request user information of the logged in user  
---If the user data has already been requested before the callback will be called immediately.
---@param callback function Callback which will get called with user_id and display_name or nil on error
function Twitch.GetUserData(callback) end

---Request the list of custom rewards  
---If the reward list has already been requested before the callback will be called immediately with the cached data.
---@param callback function Callback which will get called with an array of reward tables { id = "...", title = "..." }
function Twitch.GetCustomRewards(callback) end

---Start listening for reward redemptions  
---User must be logged in before this is called (`IsLoggedIn` must return true)  
---When a reward is redeemed, `UIMsg.TwitchOnRewardRedeemed(reward_id, user_display_name, redemption_user_input)` will get called
function Twitch.StartRewards() end

---Stop listening for reward redemptions
function Twitch.StopRewards() end

---Start listening for chat messages  
---When a message is posted, `UIMsg.TwitchOnChatMessage(username, message)` will get called
---@param channel_name string? Channel name to join, can be omitted if logged in (OPTIONAL)
---@overload fun()
function Twitch.StartChat(channel_name) end

---Stop listening for chat messages
function Twitch.StopChat() end

---------------------------------------------------------------------------------------------------------------
---The UI module contains UI related functions  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#ui)
UI = {}

---Register a layout definition tag
---@param tag_name string Layout tag name
---@param layout string Layout string
---@param class any_table? Class table (OPTIONAL)
---@param do_overwrite boolean? Set to true to overwrite an existing layout tag (OPTIONAL, default false)
---@overload fun(tag_name: string, layout: string)
---@overload fun(tag_name: string, layout: string, class: any_table)
---@overload fun(tag_name: string, layout: string, do_overwrite: boolean?)
function UI.Register(tag_name, layout, class, do_overwrite) end

---Check if a layout tag has been registered
---@param tag_name string Layout tag name
---@return boolean # True if known layout tag
function UI.IsRegistered(tag_name) end

---Instantiate a new widget
---@param layout string Layout Text
---@param properties any_table? Property table (OPTIONAL)
---@return Widget # Created widget (or nil on error)
---@overload fun(layout: string): Widget
function UI.New(layout, properties) end

---Add widget to screen canvas
---@param widget Widget Widget
---@param order_priority integer? Ordering priority (OPTIONAL, default 0)
---@return Widget # The widget passed in the first argument
---@overload fun(widget: Widget): Widget
function UI.AddLayout(widget, order_priority) end

---Add widget to screen canvas
---@param layout string Layout text for creating a new widget inline
---@param properties any_table? Property table for the inline widget (OPTIONAL)
---@param order_priority integer? Ordering priority (OPTIONAL, default 0)
---@return Widget # The widget passed in the first argument
---@overload fun(layout: string): Widget
---@overload fun(layout: string, properties: any_table): Widget
---@overload fun(layout: string, order_priority: integer?): Widget
---@overload fun(widget: Widget, order_priority: integer): Widget
function UI.AddLayout(layout, properties, order_priority) end

---Find a widget with a given tag that is on screen
---@param tag_name string Layout tag name
---@return Widget? # A widget with the given tag or nil if none is on screen
function UI.FindWidgetWithTag(tag_name) end

---Find all widgets with a given tag which are on screen
---@param tag_name string Layout tag name
---@return Widget[] # An array with widgets with the given tag
function UI.FindWidgetsWithTag(tag_name) end

---Find a widget with a given property that is on screen
---@param property_name string Property key name
---@param property_value any? If set, also filter the exact value of the property (OPTIONAL)
---@return Widget? # A widget with the given tag or nil if none is on screen
---@overload fun(property_name: string): Widget?
function UI.FindWidgetWithProperty(property_name, property_value) end

---Find all widgets with a given property which are on screen
---@param property_name string Property key name
---@param property_value any? If set, also filter the exact value of the property (OPTIONAL)
---@return Widget[] # An array with widgets with the given tag
---@overload fun(property_name: string): Widget[]
function UI.FindWidgetsWithProperty(property_name, property_value) end

---Get the layout string of a registered layout tag  
---When running a dedicated server, this function will always return an empty string.
---@param tag_name string Layout tag name
---@return string # Layout string
function UI.GetRegisteredLayoutString(tag_name) end

---Overwrite the layout string of a registered layout tag  
---Will not apply to layout tags already on screen.  
---When running a dedicated server, this function will do nothing.
---@param tag_name string Layout tag name
---@param layout string New layout string
function UI.SetRegisteredLayoutString(tag_name, layout) end

---Get the class table of a registered layout tag  
---When running a dedicated server, this function will do always return an empty table.
---@param tag_name string Layout tag name
---@return table # Class table
function UI.GetRegisteredLayoutClass(tag_name) end

---Overwrite the class table of a registered layout tag  
---Can only be done for layout tags which are not on screen.  
---When running a dedicated server, this function will do nothing.
---@param tag_name string Layout tag name
---@param class table New class table
function UI.SetRegisteredLayoutClass(tag_name, class) end

---Find all widgets below the mouse cursor or at a position  
---The most top widget will be the first in the result.  
---If the position is outside of the current view, only widgets that fill out the view will be returned (current view can be a popup or the entire game window).
---@param position_x number? X position to check or mouse cursor if not given (OPTIONAL)
---@param position_y number? Y position to check or mouse cursor if not given (OPTIONAL)
---@return Widget[] # An array with found widgets
---@overload fun(): Widget[]
---@overload fun(position_x: number): Widget[]
function UI.GetWidgetsUnderCursor(position_x, position_y) end

---Find a widgets with a given tag below the mouse cursor or at a position
---@param tag_name string Layout tag name
---@param position_x number? X position to check or mouse cursor if not given (OPTIONAL)
---@param position_y number? Y position to check or mouse cursor if not given (OPTIONAL)
---@return Widget? # A widget with the given tag or nil if none was found
---@overload fun(tag_name: string): Widget?
---@overload fun(tag_name: string, position_x: number): Widget?
function UI.GetWidgetWithTagUnderCursor(tag_name, position_x, position_y) end

---Find a widgets with a given property below the mouse cursor or at a position
---@param property_name string Property key name
---@param property_value any? If set, also filter the exact value of the property (OPTIONAL)
---@param position_x number? X position to check or mouse cursor if not given (OPTIONAL)
---@param position_y number? Y position to check or mouse cursor if not given (OPTIONAL)
---@return Widget? # A widget with the given property or nil if none was found
---@overload fun(property_name: string): Widget?
---@overload fun(property_name: string, property_value: any): Widget?
---@overload fun(property_name: string, position_x: number?): Widget?
---@overload fun(property_name: string, property_value: any, position_x: number?): Widget?
---@overload fun(property_name: string, position_x: number?, position_y: number?): Widget?
function UI.GetWidgetWithPropertyUnderCursor(property_name, property_value, position_x, position_y) end

---Get all widgets that have been attached to the screen canvas with `UI.AddLayout`.
---@return Widget[] # An array with widgets attached to the screen canvas
function UI.GetRootWidgets() end

---Instantiate the options widget of a mod
---@param mod_id string Mod id
---@return Widget # Created widget (or nil on error)
function UI.MakeModOptionsWidget(mod_id) end

---Get all custom map settings tables of the active or a specific scenario
---@param mod_package_path string? Mod package path ("Mod/Package") (OPTIONAL, default to active scenario)
---@return table # Array to add map settings tables (contains functions to build settings ui)
---@overload fun(): table
function UI.GetMapSettingsArray(mod_package_path) end

---Get the size of the screen scaled in UI coordinates
---@return number # Screen size X
---@return number # Screen size Y
function UI.GetScreenSize() end

---Pop up a context menu or window  
---If there isn't enough space in the direction it will flip to the other side  
---If there isn't enough space in the crosswise direction it will shift horizontally (if UP/DOWN) or vertically (if LEFT/RIGHT)
---@param widget Widget Widget
---@param pop_up_next_to Widget? Pop up next to this widget (OPTIONAL, default pop up at mouse cursor)
---@param direction string? Direction (OPTIONAL, default DOWN or UP/LEFT/RIGHT/CENTER or special TOOLTIP/SCREEN)
---@param alignment string? Alignment (OPTIONAL, default MIDDLE or LEFT/RIGHT/TOP/BOTTOM)
---@param x_offset integer? Attachment X offset (OPTIONAL)
---@param y_offset integer? Attachment Y offset (OPTIONAL)
---@return Widget # The widget passed in the first argument or that was created
---@overload fun(widget: Widget): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget): Widget
---@overload fun(widget: Widget, direction: string?): Widget
---@overload fun(widget: Widget, x_offset: integer?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, direction: string?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, x_offset: integer?): Widget
---@overload fun(widget: Widget, direction: string?, alignment: string?): Widget
---@overload fun(widget: Widget, direction: string?, x_offset: integer?): Widget
---@overload fun(widget: Widget, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, direction: string?, alignment: string?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, direction: string?, x_offset: integer?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(widget: Widget, direction: string?, alignment: string?, x_offset: integer?): Widget
---@overload fun(widget: Widget, direction: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, direction: string?, alignment: string?, x_offset: integer?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, direction: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(widget: Widget, direction: string?, alignment: string?, x_offset: integer?, y_offset: integer?): Widget
function UI.MenuPopup(widget, pop_up_next_to, direction, alignment, x_offset, y_offset) end

---Pop up a context menu or window  
---If there isn't enough space in the direction it will flip to the other side  
---If there isn't enough space in the crosswise direction it will shift horizontally (if UP/DOWN) or vertically (if LEFT/RIGHT)
---@param layout string Layout text for creating a new widget inline
---@param properties any_table? Property table for the inline widget (OPTIONAL)
---@param pop_up_next_to Widget? Pop up next to this widget (OPTIONAL, default pop up at mouse cursor)
---@param direction string? Direction (OPTIONAL, default DOWN or UP/LEFT/RIGHT/CENTER or special TOOLTIP/SCREEN)
---@param alignment string? Alignment (OPTIONAL, default MIDDLE or LEFT/RIGHT/TOP/BOTTOM)
---@param x_offset integer? Attachment X offset (OPTIONAL)
---@param y_offset integer? Attachment Y offset (OPTIONAL)
---@return Widget # The widget passed in the first argument or that was created
---@overload fun(layout: string): Widget
---@overload fun(layout: string, properties: any_table): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?): Widget
---@overload fun(layout: string, direction: string?): Widget
---@overload fun(layout: string, x_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?): Widget
---@overload fun(layout: string, properties: any_table, direction: string?): Widget
---@overload fun(layout: string, properties: any_table, x_offset: integer?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, direction: string?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, x_offset: integer?): Widget
---@overload fun(layout: string, direction: string?, alignment: string?): Widget
---@overload fun(layout: string, direction: string?, x_offset: integer?): Widget
---@overload fun(layout: string, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, direction: string?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, x_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, direction: string?, alignment: string?): Widget
---@overload fun(layout: string, properties: any_table, direction: string?, x_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, direction: string?, alignment: string?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, direction: string?, x_offset: integer?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, direction: string?, alignment: string?, x_offset: integer?): Widget
---@overload fun(layout: string, direction: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, direction: string?, alignment: string?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, direction: string?, x_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, direction: string?, alignment: string?, x_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, direction: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, direction: string?, alignment: string?, x_offset: integer?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, direction: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, direction: string?, alignment: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, direction: string?, alignment: string?, x_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, pop_up_next_to: Widget?, direction: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, properties: any_table, direction: string?, alignment: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(layout: string, pop_up_next_to: Widget?, direction: string?, alignment: string?, x_offset: integer?, y_offset: integer?): Widget
---@overload fun(widget: Widget, pop_up_next_to: Widget, direction: string?, alignment: string?, x_offset: integer?, y_offset: integer?): Widget
function UI.MenuPopup(layout, properties, pop_up_next_to, direction, alignment, x_offset, y_offset) end

---Force start a drag and drop operation without the user necessarily having to drag anything
---@param payload Widget Drag payload widget
---@param visual Widget Drag visual cursor widget
---@param alignment_x number? Horizontal alignment of the visual to the cursor (-0.5 is left, 0 is centered, 0.5 is right) (OPTIONAL, default 0)
---@param alignment_y number? Vertical alignment of the visual to the cursor (-0.5 is top, 0 is centered, 0.5 is bottom) (OPTIONAL, default 0)
---@param start_visual_at_cursor boolean? Set to true to snap the visual to the cursor, otherwise it will animate from the payload towards it (OPTIONAL, default false)
---@return boolean # True on success, false if drag already active or visual widget is already on screen
---@overload fun(payload: Widget, visual: Widget): boolean
---@overload fun(payload: Widget, visual: Widget, alignment_x: number): boolean
---@overload fun(payload: Widget, visual: Widget, start_visual_at_cursor: boolean?): boolean
---@overload fun(payload: Widget, visual: Widget, alignment_x: number, alignment_y: number?): boolean
---@overload fun(payload: Widget, visual: Widget, alignment_x: number, start_visual_at_cursor: boolean?): boolean
function UI.StartDrag(payload, visual, alignment_x, alignment_y, start_visual_at_cursor) end

---Close the context menu opened with MenuPopup
---@param contained_widget Widget? Close popup containing this widget (OPTIONAL, default close all popups)
---@return boolean # If a popup was actually closed
---@overload fun(): boolean
function UI.CloseMenuPopup(contained_widget) end

---Close the current tooltip
function UI.CloseTooltip() end

---Refresh the current tooltip
function UI.RefreshTooltip() end

---Run code after a given delay (similar to widget tweens)
---@param delay_time number? Delay time in milliseconds (OPTIONAL, default to call after 1 frame)
---@param func function Delay callback
---@overload fun(func: function)
function UI.Delay(delay_time, func) end

---Play a UI sound effect, music, voice or ambience
---@param fx_id string Effect ID
---@param volume integer? Volume multiplier for sound effect (OPTIONAL, default 1)
---@param pitch integer? Pitch multiplier for sound effect (OPTIONAL, default 1)
---@param start_time integer? Start time for sound effect (OPTIONAL, default 0)
---@overload fun(fx_id: string)
---@overload fun(fx_id: string, volume: integer)
---@overload fun(fx_id: string, volume: integer, pitch: integer?)
function UI.PlaySound(fx_id, volume, pitch, start_time) end

---Stop the playing music
function UI.StopMusic() end

---Stop the playing voice
function UI.StopVoice() end

---Stop the playing ambience sound effect
function UI.StopAmbienceSound() end

---Hide the entire UI
---@param state boolean? UI hidden state (OPTIONAL, if not set will toggle)
---@return boolean # UI hidden state
---@overload fun(): boolean
function UI.SetUIHidden(state) end

---Check if UI has been hidden with SetUIHidden
---@return boolean # UI hidden state
function UI.IsUIHidden() end

---Query the UI coordinate of an entity in the game camera view
---@param entity Entity Input entity
---@param must_be_on_screen boolean? Only return success if the position is on screen (or less than 100 points away from the screen border) (OPTIONAL, default false)
---@param query_hidden boolean? Also query invisible entities not currently rendered (far off camera or not in visible area) (OPTIONAL, default false)
---@return boolean # Success state (query can fail if the camera points away from the entity)
---@return number # Screen position X
---@return number # Screen position Y
---@overload fun(entity: Entity): boolean, number, number
---@overload fun(entity: Entity, must_be_on_screen: boolean): boolean, number, number
function UI.EntityLocationOnScreen(entity, must_be_on_screen, query_hidden) end

---Run code in UI context or call bound UIMsg functions  
---When called from simulation context the function will execute for all connected players (to limit to specific players use `faction:RunUI` or `Action.RunUI`)  
---When called from UI context the function will only execute for the local player
---@param func function LUA function to execute in UI context
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(func: function)
function UI.Run(func, ...) end

---Run code in UI context or call bound UIMsg functions  
---When called from simulation context the function will execute for all connected players (to limit to specific players use `faction:RunUI` or `Action.RunUI`)  
---When called from UI context the function will only execute for the local player
---@param msg_name string Message name registered in UIMsg
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(msg_name: string)
---@overload fun(msg_name: string, ...: any) -- dotdotdot
---@overload fun(func: function, ...: any)
function UI.Run(msg_name, ...) end

---Get a table of languages
---@return table<string, string> # languages (pairs of 'code' = 'name')
function UI.GetLanguages() end

---Get the current language code
---@return string # language code (for example 'en_us')
function UI.GetLanguageCode() end

---Change the active language
---@param lang_code string language code (for example 'en_us')
function UI.SetLanguageCode(lang_code) end

---Get the UI scale factor
---@return number # scale factor (1.0 being 100%)
function UI.GetScale() end

---Set the UI scale factor
---@param scale number scale factor (1.0 being 100%)
function UI.SetScale(scale) end

---Gets position of mouse cursor  
---If a widget gets passed that hasn't had its layout calculated yet, the function will return nil
---@param widget Widget? Widget to get relative position to (OPTIONAL)
---@return number? # x position of mouse cursor
---@return number? # y position of mouse cursor
---@overload fun(): number?, number?
function UI.GetMousePosition(widget) end

---Check if the mouse cursor is over a UI widget
---@return boolean # True if mouse is over UI
function UI.IsMouseOverUI() end

---Send chat function call to every player (including locally)  
---A chat function can be registered with  
---function Chat.FUNCTIONNAME(arg, sender_player_id, scope)
---@param chat_name string Function name
---@param arg_table any_table? Argument table to pass (will be copied, not referenced) (OPTIONAL)
---@overload fun(chat_name: string)
function UI.SendChatGlobal(chat_name, arg_table) end

---Send chat function call to a specific player
---@param chat_name string Function name
---@param player_id integer Target player id
---@param arg_table any_table? Argument table to pass (will be copied, not referenced) (OPTIONAL)
---@overload fun(chat_name: string, player_id: integer)
function UI.SendChatPlayer(chat_name, player_id, arg_table) end

---Send chat function call to all players of the local or a specific faction
---@param chat_name string Function name
---@param arg_table any_table? Argument table to pass (will be copied, not referenced) (OPTIONAL)
---@param faction FactionOrId? Target faction (OPTIONAL, default local player faction)
---@overload fun(chat_name: string)
---@overload fun(chat_name: string, arg_table: any_table)
---@overload fun(chat_name: string, faction: FactionOrId?)
function UI.SendChatFaction(chat_name, arg_table, faction) end

---Send chat function call to all players that share visibility with the local or a specific faction
---@param chat_name string Function name
---@param arg_table any_table? Argument table to pass (will be copied, not referenced) (OPTIONAL)
---@param faction FactionOrId? Target faction (OPTIONAL, default local player faction)
---@overload fun(chat_name: string)
---@overload fun(chat_name: string, arg_table: any_table)
---@overload fun(chat_name: string, faction: FactionOrId?)
function UI.SendChatAlliance(chat_name, arg_table, faction) end

---------------------------------------------------------------------------------------------------------------
---The view module contains global functions that don't affect the state of the simulation but aren't directly related to UI  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#view)
View = {}

---Get the location of the currently hovered tile
---@return integer # X factor of the virtual cursor
---@return integer # Y factor of the virtual cursor
function View.GetHoveredTilePosition() end

---Get the entity currently hovered
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@return Entity? # Hovered entity (or nil if none)
---@overload fun(): Entity?
function View.GetHoveredEntity(filter) end

---Reset the camera to the faction home location
---@param reset_zoom boolean? Whether to reset zoom level (OPTIONAL, default true)
---@overload fun()
function View.ResetCamera(reset_zoom) end

---Move the camera to a given location
---@param x integer X position
---@param y integer Y position
---@param reset_zoom boolean? Whether to reset zoom level (OPTIONAL, default true)
---@overload fun(x: integer, y: integer)
function View.MoveCamera(x, y, reset_zoom) end

---Focus the camera on one or more entities
---@param entities Entity[] List of entities to focus on
function View.JumpCameraToEntities(entities) end

---Focus the camera on one or more entities
---@param ... Entity Entities to focus on (argument can be repeated)
---@overload fun(...: Entity) -- dotdotdot
---@overload fun(entities: Entity[])
function View.JumpCameraToEntities(...) end

---Get Local camera zoom distance
---@return number # Camera zoom distance
function View.GetCameraZoom() end

---Sets the entity for the camera to follow
---@param entity Entity? Entity to follow or nil to stop follow (OPTIONAL)
---@overload fun()
function View.FollowEntity(entity) end

---Get the entity currently followed by the camera
---@return Entity? # Followed entity (or nil if there is none)
function View.GetFollowEntity() end

---Enable or disable visualization modes  
---Pass a table settings, any settings not present in the table will be set to disabled.  
---{  
---global = { stores = true, gotos = true, transport_routes = true, power_transmitters = true, portals = true, orders = true, paths = true },  
---selected = { stores = true, gotos = true, transport_routes = true, power_transmitters = true, portals = true, orders = true, paths = true },  
---}
---@param visualization_settings table Table with settings that are to be changed
function View.SetVisualizations(visualization_settings) end

---Get the currently selected entities
---@return Entity[]? # List of selected entities (or nil if empty)
function View.GetSelectedEntities() end

---Get the currently selected entity (will be just the first if multiple are selected)
---@return Entity? # Selected entity (or nil if empty)
function View.GetSelectedEntity() end

---Check if an entity is selected
---@param entity Entity Entity to check
---@return boolean # Result of check
function View.IsSelectedEntity(entity) end

---Set the selected entity(s)
---@param entities Entity[]? List of entities to select (or nil to unselect everything)
---@overload fun()
function View.SelectEntities(entities) end

---Set the selected entity(s)
---@param ... Entity Entities to select (argument can be repeated)
---@overload fun(...: Entity) -- dotdotdot
---@overload fun(entities: Entity[])
function View.SelectEntities(...) end

---Switch entity selection to previously selected entities
function View.SelectPreviousEntities() end

---Highlight an entity
---@param entity Entity|nil? Entity to highlight (or nil to remove highlight)
---@overload fun()
function View.HighlightEntity(entity) end

---Switch to a cursor mode to select a location on the map
---@param on_confirm function LUA function called when confirming a location with the location as the argument
---@param on_abort function? LUA function called when placing aborting the cursor mode (OPTIONAL)
---@overload fun(on_confirm: function)
function View.StartCursorChooseLocation(on_confirm, on_abort) end

---Switch to a cursor mode to select an entity on the map
---@param on_confirm function LUA function called when confirming an entity with the entity as the argument
---@param on_abort function? LUA function called when aborting the cursor mode (OPTIONAL)
---@param include_foundations boolean? Set to true to include foundations in selection (OPTIONAL, default false)
---@overload fun(on_confirm: function)
---@overload fun(on_confirm: function, on_abort: function)
---@overload fun(on_confirm: function, include_foundations: boolean?)
function View.StartCursorChooseEntity(on_confirm, on_abort, include_foundations) end

---Show entity construction location selection on map
---@param frame_id string Frame id
---@param visual_id string? Specific visual id or another frame id from which to use the visual (OPTIONAL, defaults to frame visual)
---@param rotation integer? Rotation (0 to 3) (OPTIONAL, otherwise remembers last used rotation)
---@param on_confirm function? LUA function called when confirming placement with arguments (location, rotation, is_valid) location will be an array if dragging is enabled (OPTIONAL)
---@param on_abort function? LUA function called when aborting the cursor mode (OPTIONAL)
---@param on_check function? LUA function called to check placement with arguments (x, y, rotation, is_visible, can_place, is_powered, size_x, size_y) (OPTIONAL)
---@param allow_drag boolean? Set to true to allow placing multiple constructions via dragging (OPTIONAL, default false)
---@overload fun(frame_id: string)
---@overload fun(frame_id: string, visual_id: string)
---@overload fun(frame_id: string, rotation: integer?)
---@overload fun(frame_id: string, on_confirm: function?)
---@overload fun(frame_id: string, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?)
---@overload fun(frame_id: string, visual_id: string, on_confirm: function?)
---@overload fun(frame_id: string, visual_id: string, allow_drag: boolean?)
---@overload fun(frame_id: string, rotation: integer?, on_confirm: function?)
---@overload fun(frame_id: string, rotation: integer?, allow_drag: boolean?)
---@overload fun(frame_id: string, on_confirm: function?, on_abort: function?)
---@overload fun(frame_id: string, on_confirm: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, on_confirm: function?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, on_confirm: function?, on_abort: function?)
---@overload fun(frame_id: string, visual_id: string, on_confirm: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, rotation: integer?, on_confirm: function?, on_abort: function?)
---@overload fun(frame_id: string, rotation: integer?, on_confirm: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, on_confirm: function?, on_abort: function?, on_check: function?)
---@overload fun(frame_id: string, on_confirm: function?, on_abort: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, on_confirm: function?, on_abort: function?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, on_confirm: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, on_confirm: function?, on_abort: function?, on_check: function?)
---@overload fun(frame_id: string, visual_id: string, on_confirm: function?, on_abort: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, rotation: integer?, on_confirm: function?, on_abort: function?, on_check: function?)
---@overload fun(frame_id: string, rotation: integer?, on_confirm: function?, on_abort: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, on_confirm: function?, on_abort: function?, on_check: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, on_confirm: function?, on_abort: function?, on_check: function?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, on_confirm: function?, on_abort: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, on_confirm: function?, on_abort: function?, on_check: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, rotation: integer?, on_confirm: function?, on_abort: function?, on_check: function?, allow_drag: boolean?)
function View.StartCursorConstruction(frame_id, visual_id, rotation, on_confirm, on_abort, on_check, allow_drag) end

---Show entity construction location selection on map
---@param multi_table any_table Array of tables with fields frame (frame id), x/y (optional position offsets), rotation (optional rotation)
---@param rotation integer? Rotation (0 to 3) (OPTIONAL, otherwise remembers last used rotation)
---@param on_confirm function? LUA function called when confirming placement with arguments (location, rotation, is_valid) location will be an array if dragging is enabled (OPTIONAL)
---@param on_abort function? LUA function called when aborting the cursor mode (OPTIONAL)
---@param on_check function? LUA function called to check placement with arguments (x, y, rotation, is_visible, can_place, is_powered, size_x, size_y) (OPTIONAL)
---@param allow_drag boolean? Set to true to allow placing multiple constructions via dragging (OPTIONAL, default false)
---@overload fun(multi_table: any_table)
---@overload fun(multi_table: any_table, rotation: integer)
---@overload fun(multi_table: any_table, on_confirm: function?)
---@overload fun(multi_table: any_table, allow_drag: boolean?)
---@overload fun(multi_table: any_table, rotation: integer, on_confirm: function?)
---@overload fun(multi_table: any_table, rotation: integer, allow_drag: boolean?)
---@overload fun(multi_table: any_table, on_confirm: function?, on_abort: function?)
---@overload fun(multi_table: any_table, on_confirm: function?, allow_drag: boolean?)
---@overload fun(multi_table: any_table, rotation: integer, on_confirm: function?, on_abort: function?)
---@overload fun(multi_table: any_table, rotation: integer, on_confirm: function?, allow_drag: boolean?)
---@overload fun(multi_table: any_table, on_confirm: function?, on_abort: function?, on_check: function?)
---@overload fun(multi_table: any_table, on_confirm: function?, on_abort: function?, allow_drag: boolean?)
---@overload fun(multi_table: any_table, rotation: integer, on_confirm: function?, on_abort: function?, on_check: function?)
---@overload fun(multi_table: any_table, rotation: integer, on_confirm: function?, on_abort: function?, allow_drag: boolean?)
---@overload fun(multi_table: any_table, on_confirm: function?, on_abort: function?, on_check: function?, allow_drag: boolean?)
---@overload fun(frame_id: string, visual_id: string, rotation: integer?, on_confirm: function?, on_abort: function?, on_check: function?, allow_drag: boolean?)
function View.StartCursorConstruction(multi_table, rotation, on_confirm, on_abort, on_check, allow_drag) end

---Cancel cursor mode started with the functions above
function View.StopCursor() end

---RotateConstructionSite
---@param clockwise boolean? Clockwise (OPTIONAL, default false)
---@overload fun()
function View.RotateConstructionSite(clockwise) end

---Set a fullscreen effect parameter
---@param effect_name string Effect name
---@param value any Effect value (numerical or color value)
function View.SetPostProcess(effect_name, value) end

---Play effect at a location
---@param fx_id string effect id
---@param x integer Tile Location X
---@param y integer Tile Location Y
---@param hide_outside_visible boolean? Set to true to not show the effect outside the local player factions visibility (OPTIONAL, default false)
---@return integer # Effect instance (can be used with `View.StopEffect`)
---@overload fun(fx_id: string, x: integer, y: integer): integer
function View.PlayEffect(fx_id, x, y, hide_outside_visible) end

---Play effect at a location
---@param fx_id string effect id
---@param entity Entity entity to play it on
---@param socket_name string? Socket name (OPTIONAL)
---@param target_entity Entity? Target entity (OPTIONAL)
---@param instance_number integer? Render instance number (OPTIONAL)
---@param params any_table? Particle effect parameter table (OPTIONAL)
---@return integer # Effect instance (can be used with `View.StopEffect`)
---@overload fun(fx_id: string, entity: Entity): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string): integer
---@overload fun(fx_id: string, entity: Entity, target_entity: Entity?): integer
---@overload fun(fx_id: string, entity: Entity, instance_number: integer?): integer
---@overload fun(fx_id: string, entity: Entity, params: any_table?): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string, target_entity: Entity?): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string, instance_number: integer?): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string, params: any_table?): integer
---@overload fun(fx_id: string, entity: Entity, target_entity: Entity?, instance_number: integer?): integer
---@overload fun(fx_id: string, entity: Entity, target_entity: Entity?, params: any_table?): integer
---@overload fun(fx_id: string, entity: Entity, instance_number: integer?, params: any_table?): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string, target_entity: Entity?, instance_number: integer?): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string, target_entity: Entity?, params: any_table?): integer
---@overload fun(fx_id: string, entity: Entity, socket_name: string, instance_number: integer?, params: any_table?): integer
---@overload fun(fx_id: string, entity: Entity, target_entity: Entity?, instance_number: integer?, params: any_table?): integer
---@overload fun(fx_id: string, x: integer, y: integer, hide_outside_visible: boolean): integer
function View.PlayEffect(fx_id, entity, socket_name, target_entity, instance_number, params) end

---Set a parameter on an effect started with `View.PlayEffect`
---@param effect_instance integer Effect instance
---@param param_name string Parameter name
---@param value any Parameter value (numerical or color value)
function View.SetEffectParam(effect_instance, param_name, value) end

---Stop an effect started with `View.PlayEffect`
---@param effect_instance integer Effect instance
function View.StopEffect(effect_instance) end

---Checks if the player is currently in construction mode
---@return boolean # Is in construction mode
function View.InConstructionMode() end

---Get all entities currently on screen  
---The filter_trust argument is a bit-flag integer which can be generated by `Tool.EncodeTrustLevels`  
---The 5th element returned for each entity 'trust' contains special entries 'faction' and 'world' besides 'ally'/'neutral'/'enemy'
---@param cache_table any_table? Pass a table to use it as a cache for the return value to avoid allocating a new large table (OPTIONAL)
---@param only_damaged boolean? Set to true to only get entities with health not at the maximum (OPTIONAL, default false)
---@param no_stealth boolean? Set to true to not get any entities with stealth state unless owned or allied (OPTIONAL, default false)
---@param filter_trust integer? Return only entities matching a certain trust level (OPTIONAL)
---@return table # One array with 5 or 7 elements for each entity (entity, X, Y, distance, trust, health/max_health if true was passed)
---@return integer # How many elements were written to the table (entity count * 4 or 6)
---@overload fun(): table, integer
---@overload fun(cache_table: any_table): table, integer
---@overload fun(only_damaged: boolean?): table, integer
---@overload fun(filter_trust: integer?): table, integer
---@overload fun(cache_table: any_table, only_damaged: boolean?): table, integer
---@overload fun(cache_table: any_table, filter_trust: integer?): table, integer
---@overload fun(only_damaged: boolean?, no_stealth: boolean?): table, integer
---@overload fun(only_damaged: boolean?, filter_trust: integer?): table, integer
---@overload fun(cache_table: any_table, only_damaged: boolean?, no_stealth: boolean?): table, integer
---@overload fun(cache_table: any_table, only_damaged: boolean?, filter_trust: integer?): table, integer
---@overload fun(only_damaged: boolean?, no_stealth: boolean?, filter_trust: integer?): table, integer
function View.GetVisibleEntities(cache_table, only_damaged, no_stealth, filter_trust) end

---Set the full 3D camera position and target location directly
---@param position Point3D? A table with x, y and z camera position (or nil if only setting the target location)
---@param view_target Point3D? A table with x, y and z target location (or nil if only setting the camera position)
---@overload fun()
---@overload fun(position: Point3D)
function View.SetCamera3DPosition(position, view_target) end

---Get the 3D camera position and target location
---@return Point3D # A table with x, y and z camera position
---@return Point3D # A table with x, y and z target location
---@return Point3D # A table with x, y and z normalized look direction
---@return number # Distance from camera position to target location
function View.GetCamera3DPosition() end

---Directly shift the camera in 3D space (relative to the current camera rotation)
---@param forward number Forward/backward move amount
---@param side number Right/left move amount
---@param updown number Up/down move amount
function View.PanCamera3DPosition(forward, side, updown) end

---Directly rotate the camera in place
---@param yaw number Yaw amount in degrees (how much to rotate around the Z axis)
---@param pitch number Pitch amount in degrees (how much to rotate up and down)
function View.TiltCamera3DRotation(yaw, pitch) end

---Fully lock the camera in its current state until `UnlockCamera` is called  
---Direct modification of the camera with `SetCamera3DPosition`, `PanCamera3DPosition` or `TiltCamera3DRotation` is available even while locked.
function View.LockCamera() end

---Unlock the camera again after having `LockCamera` called
function View.UnlockCamera() end

---Check if the game is running without rendering (headless)
---@return boolean # Is in construction mode
function View.IsRunningHeadless() end

---------------------------------------------------------------------------------------------------------------
---A component object represents a component equipped by an entity.  
--- - Custom operator 'tostring'  
--- - Custom operator 'equal'  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#component)
---@class Component
---@field owner Entity The owner of this component
---@field faction Faction The faction of the owner of this component
---@field exists boolean Check if this component and its owning entity still exists or if it was unequipped or destroyed
---@field key integer A unique numerical identifier of this component
---@field id ComponentId The id of this component
---@field base_id ComponentId The base id of this component
---@field def table The definition table of this component
---@field visual_id VisualId The visual id of this component
---@field visual_def table The visual definition table of this component
---@field socket_index integer The socket index this component is attached to
---@field slot_index integer Gets the index of the first item slot of this component in the entities slot array
---@field slot_count integer Check the number of item slots a component has
---@field slots ItemSlot[] Get an array with all item slots of this component It is not possible to overwrite or add items to this array
---@field register_index integer Gets the index of the first register of this component in the entities register array
---@field register_count integer Check or change the number of registers a component has
---@field is_empty boolean Returns if the component has no items stored in it
---@field is_hidden boolean Returns if the component is a hidden component (does not occupy a socket)
---@field is_active boolean Returns if the component is active (waiting on completing SetState, RequestState or WaitFor calls)
---@field is_working boolean Returns if the component is still working on something started with `SetStateStartWork`
---@field is_sleeping boolean Returns if the component is currently active but sleeping (waiting on completing SetStateSleep)
---@field is_updating boolean Returns if the component currently executing the on_update callback
---@field has_move_control boolean Returns if the component has successfully gained movement control over its owner
---@field has_prepared_process boolean Returns if the component has prepared a produce/generate/consume process
---@field progress_percent integer The progress of work that has been completed
---@field interpolated_progress number The progress of work that has been completed interpolated to the rendered frame rate (only accessible by UI)
---@field ticker integer The work ticker This number can be returned rounded up to the next tick if the component is working but not at 100% efficiency.
---@field ticker_target integer The work ticker target
---@field has_extra_data boolean Check if extra_data has been created for this component
---@field extra_data table Access to the extra data table of this component instance Reading it will always return a valid table when (will be created if not set yet) Writing nil to it will free the table from memory
---@field stored_power integer The amount of power currently stored in this battery component Cannot exceed power_storage value in the component definition This does nothing if the entity is docked (returns nil) The number can be very small without ever jumping to 0.
---@field extra_power integer The dynamic additional power supplied/consumed by this component Added on top of the base value in the component definition This does nothing if the entity is docked (returns nil)
---@field extra_transfer_range integer The dynamic additional power range of this component Added on top of the base value in the component definition This does nothing if the entity is docked (returns nil)
---@field power_relay_target Entity The relay target of this power relay component This does nothing if the entity is docked (returns nil)
---@field power_details table? Get a table with power details about this component Building this table is slow so avoid reading it multiple times. Some of the returned numbers (stored, change, transmitted) can be very small without ever jumping to 0.
---@field animation_speed number Set Material animation speed if supported by the visual
---@field light_color Color Set light color (RGB) and intensity (A) if supported by the visual
---@field has_active_effects boolean Check if there are any looping effects playing on this component
---@field triggering_entities Entity[] Get an array with all matching entities inside this components trigger_radius
Component = {}

---destroys a component
---@param force_drop_items boolean? Remove contained items by moving into other slots or dropping (OPTIONAL, default false)
---@return table # The final state of the extra_data value after on_remove has been called
---@overload fun(self): table
function Component:Destroy(force_drop_items) end

---Prepare a component for removal by clearing out all item slots and reserves related to this component  
---If the component is hidden, the function will return false.  
---Contained items will be moved to other inventory slots or (if the entity is movable or has a crane) dropped.  
---The function returns true if all items could be moved away or dropped (or there are no items contained).
---@param keep_empty ItemSlot? An item slot that should be kept empty (OPTIONAL)
---@param force_drop_items boolean? Forces dropping of items even for buildings (OPTIONAL, default false)
---@return boolean # Result
---@overload fun(self): boolean
---@overload fun(self, keep_empty: ItemSlot): boolean
---@overload fun(self, force_drop_items: boolean?): boolean
function Component:PrepareRemoval(keep_empty, force_drop_items) end

---Get a register of this component
---@param register RegRef Register reference
---@return Register # Register object
function Component:GetRegister(register) end

---Get the number part of a register of this component
---@param register RegRef Register reference
---@return integer # Number value
function Component:GetRegisterNum(register) end

---Get the id part of a register of this component
---@param register RegRef Register reference
---@return AnyId # Id value
function Component:GetRegisterId(register) end

---Get the definition table of the id stored in a register of this component
---@param register RegRef Register reference
---@return table # Definition table
function Component:GetRegisterDef(register) end

---Get the entity part of a register of this component
---@param register RegRef Register reference
---@return Entity # Entity value
function Component:GetRegisterEntity(register) end

---Get the coordinate part of a register of this component
---@param register RegRef Register reference
---@return Point # Coordinate value
function Component:GetRegisterCoord(register) end

---Compare two registers of this component
---@param register1 RegRef First register reference
---@param register2 RegRef Second register reference
---@return boolean # Comparison result
function Component:RegistersEqual(register1, register2) end

---Set a register of this component
---@param register RegRef Register reference
---@param reg_value Register|any_table|nil Register object or table (or nil to clear a register)
---@param force_update boolean? Force update the register and activate the component (OPTIONAL, default false)
---@overload fun(self, register: RegRef, reg_value: Register|any_table|nil)
function Component:SetRegister(register, reg_value, force_update) end

---Set the number part of a register of this component
---@param register RegRef Register reference
---@param number integer Number value
function Component:SetRegisterNum(register, number) end

---Set the id part of a register of this component (will overwrites the entity/coordinate part)
---@param register RegRef Register reference
---@param id string? Id value (or nil to clear the id part)
---@param number integer? Number value (OPTIONAL)
---@overload fun(self, register: RegRef)
---@overload fun(self, register: RegRef, id: string)
---@overload fun(self, register: RegRef, number: integer?)
function Component:SetRegisterId(register, id, number) end

---Set the entity part of a register of this component (will overwrite the id/coordinate part)
---@param register RegRef Register reference
---@param entity Entity? Entity value (or nil to clear the entity part)
---@param number integer? Number value (OPTIONAL)
---@overload fun(self, register: RegRef)
---@overload fun(self, register: RegRef, entity: Entity)
---@overload fun(self, register: RegRef, number: integer?)
function Component:SetRegisterEntity(register, entity, number) end

---Set the coordinate part of a register of this component (will overwrite the id/entity part)
---@param register RegRef Register reference
---@param coord Point? Coordinate value (or nil to clear the coordinate part)
---@param number integer? Number value (OPTIONAL)
---@overload fun(self, register: RegRef)
---@overload fun(self, register: RegRef, coord: Point)
---@overload fun(self, register: RegRef, number: integer?)
function Component:SetRegisterCoord(register, coord, number) end

---Flag the error state on a register of this component  
---Will stay flagged until the register value changes.
---@param register RegRef Register reference
---@param state boolean? Whether to set the error state (OPTIONAL, default true)
---@overload fun(self, register: RegRef)
function Component:FlagRegisterError(register, state) end

---Check if a register of this component is linked from another register
---@param register RegRef Register reference
---@return boolean # Link state
function Component:RegisterIsLink(register) end

---Check if a register of this component is empty
---@param register RegRef Register reference
---@return boolean # Empty state
function Component:RegisterIsEmpty(register) end

---Check if a register of this component is in error state
---@param register RegRef Register reference
---@return boolean # Error state
function Component:RegisterIsError(register) end

---Check if two registers have a connection via link(s)
---@param register1 RegRef Register one
---@param register2 RegRef Register two
---@param separate_entity Entity? Different entity that holds the second register (OPTIONAL)
---@return boolean # Check result
---@overload fun(self, register1: RegRef, register2: RegRef): boolean
function Component:RegisterHasConnection(register1, register2, separate_entity) end

---Check if two registers have a connection via link(s)
---@param register1 RegRef Register one
---@param register2 RegRef Register two
---@param separate_component Component A component that holds the second register
---@return boolean # Check result
---@overload fun(self, register1: RegRef, register2: RegRef, separate_entity: Entity): boolean
function Component:RegisterHasConnection(register1, register2, separate_component) end

---Link a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_entity Entity? Different entity that holds the source register (OPTIONAL)
---@overload fun(self, target_reg: RegRef, source_reg: RegRef)
function Component:LinkRegisterFromRegister(target_reg, source_reg, source_entity) end

---Link a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_component Component A component that holds the source register
---@overload fun(self, target_reg: RegRef, source_reg: RegRef, source_entity: Entity)
function Component:LinkRegisterFromRegister(target_reg, source_reg, source_component) end

---Unlink a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_entity Entity? Different entity that holds the source register (OPTIONAL)
---@overload fun(self, target_reg: RegRef, source_reg: RegRef)
function Component:UnlinkRegisterFromRegister(target_reg, source_reg, source_entity) end

---Unlink a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_component Component A component that holds the source register
---@overload fun(self, target_reg: RegRef, source_reg: RegRef, source_entity: Entity)
function Component:UnlinkRegisterFromRegister(target_reg, source_reg, source_component) end

---Get the source index of the first relevant register link  
---If no entity or component is specified, information of the first link containing any value will be returned.  
---Otherwise it will look up a specific link and return only the register index.
---@param target_reg RegRef Target register reference
---@return integer? # Source register index, absolute entity index unless a source component is specified (or nil if not exist)
---@return Entity? # Entity that holds the source register (unless entity/component specified)
---@return Component? # Component that holds the source register or nil if frame register (unless entity/component specified)
function Component:GetRegisterLinkSource(target_reg) end

---Get the source index of the first relevant register link  
---If no entity or component is specified, information of the first link containing any value will be returned.  
---Otherwise it will look up a specific link and return only the register index.
---@param target_reg RegRef Target register reference
---@param source_entity Entity Entity that holds the source register
---@return integer? # Source register index, absolute entity index unless a source component is specified (or nil if not exist)
---@return Entity? # Entity that holds the source register (unless entity/component specified)
---@return Component? # Component that holds the source register or nil if frame register (unless entity/component specified)
function Component:GetRegisterLinkSource(target_reg, source_entity) end

---Get the source index of the first relevant register link  
---If no entity or component is specified, information of the first link containing any value will be returned.  
---Otherwise it will look up a specific link and return only the register index.
---@param target_reg RegRef Target register reference
---@param source_component Component Component that holds the source register
---@return integer? # Source register index, absolute entity index unless a source component is specified (or nil if not exist)
---@return Entity? # Entity that holds the source register (unless entity/component specified)
---@return Component? # Component that holds the source register or nil if frame register (unless entity/component specified)
---@overload fun(self, target_reg: RegRef): integer?, Entity?, Component?
---@overload fun(self, target_reg: RegRef, source_entity: Entity): integer?, Entity?, Component?
function Component:GetRegisterLinkSource(target_reg, source_component) end

---Get the target index of the first relevant register link
---@param source_reg RegRef Source register reference
---@param source_entity Entity? Different entity that holds the source register (OPTIONAL)
---@return integer? # Target register index, relative to this component (or nil if not exist)
---@overload fun(self, source_reg: RegRef): integer?
function Component:GetRegisterLinkTarget(source_reg, source_entity) end

---Get the target index of the first relevant register link
---@param source_reg RegRef Source register reference
---@param source_component Component A component that holds the source register
---@return integer? # Target register index, relative to this component (or nil if not exist)
---@overload fun(self, source_reg: RegRef, source_entity: Entity): integer?
function Component:GetRegisterLinkTarget(source_reg, source_component) end

---Check if a register of this entity has a queue (2 or more elements)
---@param register RegRef Register reference
---@return boolean # Queue has 2 or more elements
function Component:HaveRegisterQueue(register) end

---Count the number of queued elements
---@param register RegRef Register reference
---@return integer # Queue length (having nothing queued returns 1, register with links returns 0)
function Component:RegisterQueueLength(register) end

---Get an element of the register queue.  
---Querying the first element will return the same as `GetRegister` unless the register is linked.
---@param register RegRef Register reference
---@param index integer? Queue index (OPTIONAL, default to last)
---@return Register? # Register object (or nil if invalid index)
---@overload fun(self, register: RegRef): Register?
function Component:RegisterQueueGet(register, index) end

---Get the entire queue as an array
---@param register RegRef Register reference
---@return Register[] # An array of register values of the same length as `RegisterQueueLength`
function Component:RegisterQueueGetAll(register) end

---Overwrite a queued element.  
---Can write the first element while keeping the queue (unlike `SetRegister` which clears the queue).  
---Can write to an index past the end of the queue (same as `RegisterQueueInsert`).
---@param register RegRef Register reference
---@param reg_value Register|any_table|nil Register object or table
---@param index integer? Queue index (OPTIONAL, default to last)
---@overload fun(self, register: RegRef, reg_value: Register|any_table|nil)
function Component:RegisterQueueSet(register, reg_value, index) end

---Insert a queued element at a given position or the end.  
---Can write to an index past the end of the queue (same as `RegisterQueueSet`).
---@param register RegRef Register reference
---@param reg_value Register|any_table|nil Register object or table
---@param index integer? Insertion index (OPTIONAL, default to appending to the end)
---@overload fun(self, register: RegRef, reg_value: Register|any_table|nil)
function Component:RegisterQueueInsert(register, reg_value, index) end

---Remove a queued element
---@param register RegRef Register reference
---@param index integer? Queue index (OPTIONAL, default to last)
---@return Register? # Removed register object (or nil if invalid index)
---@overload fun(self, register: RegRef): Register?
function Component:RegisterQueueRemove(register, index) end

---Get an item slot of this component
---@param slot_number integer Slot number (starts at 1)
---@return ItemSlot # Item slot object
function Component:GetSlot(slot_number) end

---Clear activation change flags that would trigger the on_update callback in the next tick.  
---If the on_update callback causes modification to the same item slots that triggers its activation,  
---unless this function is called, it will be activated again in the next tick due to its own change.  
---Changes to registers made with the component:SetRegister function during on_update are automatically cleared.  
---Be aware this does not work for the activation modes 'OnAnyItemSlotChange'.
function Component:ClearActivationChangeFlags() end

---Set up a process that consumes ingredients and generates output items
---@param ingredients table<ItemId, integer> Ingredients table (item_id keys and count values)
---@param outputs table<ItemId, integer>? Outputs table (item_id keys and count values) (when nil, act like PrepareConsumeProcess)
---@param order_count integer? Order count (if multiple processes are queued up) (OPTIONAL, default 1)
---@return boolean # Returns true if inventory space for outputs and ingredient amounts are available now and process can start
---@return Register? # A register value describing the first missing ingredient (or nil if all ingredients are available)
---@return boolean # Returns true if not enough slots exist for all ingredients and outputs
---@overload fun(self, ingredients: table<ItemId, integer>): boolean, Register?, boolean
---@overload fun(self, ingredients: table<ItemId, integer>, outputs: table<ItemId, integer>): boolean, Register?, boolean
---@overload fun(self, ingredients: table<ItemId, integer>, order_count: integer?): boolean, Register?, boolean
function Component:PrepareProduceProcess(ingredients, outputs, order_count) end

---Set up a process that generates output items
---@param outputs table<ItemId, integer> Outputs table (item_id keys and count values)
---@return boolean # Returns true if inventory space for outputs are available now and process can start
function Component:PrepareGenerateProcess(outputs) end

---Set up a process that consumes ingredients
---@param ingredients table<ItemId, integer> Ingredients table (item_id keys and count values)
---@param order_count integer? Order count (if multiple processes are queued up) (OPTIONAL, default 1)
---@return boolean # Returns true if ingredient amounts are available now and process can start
---@return Register? # A register value describing the first missing ingredient (or nil if all ingredients are available)
---@return boolean # Returns true if not enough slots exist for all ingredients
---@overload fun(self, ingredients: table<ItemId, integer>): boolean, Register?, boolean
function Component:PrepareConsumeProcess(ingredients, order_count) end

---Set up a process that consumes ingredients
---@param ingredients table<ItemId, integer> Ingredients table (item_id keys and count values)
---@param consume_slot ItemSlot Consume from specific item slot
---@return boolean # Returns true if ingredient amounts are available now and process can start
---@return Register? # A register value describing the first missing ingredient (or nil if all ingredients are available)
---@return boolean # Returns true if not enough slots exist for all ingredients
---@overload fun(self, ingredients: table<ItemId, integer>, order_count: integer): boolean, Register?, boolean
function Component:PrepareConsumeProcess(ingredients, consume_slot) end

---Finish a prepared process (add generated items and remove consumed ingredients)
---@param collect_extra_data_tables boolean? Pass true to receive a table with item id keys, each with an array of extra_data tables that have been remove from consumed ingredients (OPTIONAL, default false)
---@return table<ComponentId, table[]>? # The extra data table collection if it was requested and if there was at least one ingredient with an extra_data table
---@overload fun(self): table<ComponentId, table[]>?
function Component:FulfillProcess(collect_extra_data_tables) end

---Cancel ongoing process and related orders from this component
function Component:CancelProcess() end

---If there is a prepared process, get an item slot from which items are consumed from.
---@param slot_number integer? This selects the slot when there are multiple consume slots (OPTIONAL, default 1)
---@return ItemSlot # Consuming item slot (nil if no active consume process or invalid argument)
---@overload fun(self): ItemSlot
function Component:GetProcessConsumeSlot(slot_number) end

---If there is a prepared process, get an item slot from which items are output to.
---@param slot_number integer? This selects the slot when there are multiple output slots (OPTIONAL, default 1)
---@return ItemSlot # Output item slot (nil if no active generate process or invalid argument)
---@overload fun(self): ItemSlot
function Component:GetProcessOutputSlot(slot_number) end

---Order an item through this component  
---The order will stay active while this component works or sleeps but gets canceled when the component becomes inactive or when CancelProcess is called.  
---Will return nil on invalid item or amount or if not enough free space available in the slot.  
---Multiple orders can be created covering the entire inventory.  
---If priority IS NOT "ManualOrder", no new orders will be created if the inventory already contains the requested amount (and nil will be returned).  
---If priority IS "ManualOrder", a single component can be ordered and auto equipped even when there is no free item slot is available.
---@param item_id string Item id to be ordered
---@param amount integer Amount to be ordered
---@param mode string? Mode "None", "HighPriority", "ManualOrder", "Recurring", "ManualOrder|Recurring" (OPTIONAL, default "None")
---@param channel_bitmask integer? If set and not 0, make the order on the channels denoted by the set bits (OPTIONAL)
---@return integer # Order ID created or modified
---@overload fun(self, item_id: string, amount: integer): integer
---@overload fun(self, item_id: string, amount: integer, mode: string): integer
---@overload fun(self, item_id: string, amount: integer, channel_bitmask: integer?): integer
function Component:OrderItem(item_id, amount, mode, channel_bitmask) end

---Turns component to look at a target entity or location
---@param target_entity Entity Target entity to look at
---@param rotate_entity boolean? If the entity has movement rotate it instead (OPTIONAL, default false)
---@overload fun(self, target_entity: Entity)
function Component:RotateComponent(target_entity, rotate_entity) end

---Turns component to look at a target entity or location
---@param target_component Component Target component whose owning entity to look at
---@param rotate_entity boolean? If the entity has movement rotate it instead (OPTIONAL, default false)
---@overload fun(self, target_component: Component)
function Component:RotateComponent(target_component, rotate_entity) end

---Turns component to look at a target entity or location
---@param target_area Area Location or area to look at
---@param rotate_entity boolean? If the entity has movement rotate it instead (OPTIONAL, default false)
---@overload fun(self, x: integer, y: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer)
---@overload fun(self, target_area: Area)
---@overload fun(self, x: integer, y: integer, rotate_entity: boolean)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, rotate_entity: boolean)
function Component:RotateComponent(target_area, rotate_entity) end

---Turns component to look at a target entity or location
---@param rotate_degree number Offset degree amount to rotate (negative or positive)
---@overload fun(self, target_entity: Entity, rotate_entity: boolean)
---@overload fun(self, target_component: Component, rotate_entity: boolean)
---@overload fun(self, target_area: Area, rotate_entity: boolean)
function Component:RotateComponent(rotate_degree) end

---Request the entity to move on behalf of this component (if movement is needed)  
---The function will also return true if out of range and the entity has no movement.  
---The function will also return true if the owner or target_entity is not placed on the map and not docked.
---@param target_entity Entity Target entity to move next to
---@param move_range integer? Range of how close by to stop (OPTIONAL, default 1)
---@param force_move boolean? Keep moving when component sleeps or starts working (OPTIONAL, default false)
---@return boolean # Returns true if movement is needed, otherwise the entity is already in place
---@overload fun(self, target_entity: Entity): boolean
---@overload fun(self, target_entity: Entity, move_range: integer): boolean
---@overload fun(self, target_entity: Entity, force_move: boolean?): boolean
function Component:RequestStateMove(target_entity, move_range, force_move) end

---Request the entity to move on behalf of this component (if movement is needed)  
---The function will also return true if out of range and the entity has no movement.  
---The function will also return true if the owner or target_entity is not placed on the map and not docked.
---@param target_component Component Target component whose owning entity to move next to
---@param move_range integer? Range of how close by to stop (OPTIONAL, default 1)
---@param force_move boolean? Keep moving when component sleeps or starts working (OPTIONAL, default false)
---@return boolean # Returns true if movement is needed, otherwise the entity is already in place
---@overload fun(self, target_component: Component): boolean
---@overload fun(self, target_component: Component, move_range: integer): boolean
---@overload fun(self, target_component: Component, force_move: boolean?): boolean
function Component:RequestStateMove(target_component, move_range, force_move) end

---Request the entity to move on behalf of this component (if movement is needed)  
---The function will also return true if out of range and the entity has no movement.  
---The function will also return true if the owner or target_entity is not placed on the map and not docked.
---@param target_area Area Location or area to move to
---@param move_range integer? Range of how close by to stop (OPTIONAL, default 0)
---@param force_move boolean? Keep moving when component sleeps or starts working (OPTIONAL, default false)
---@return boolean # Returns true if movement is needed, otherwise the entity is already in place
---@overload fun(self, x: integer, y: integer): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): boolean
---@overload fun(self, target_area: Area): boolean
---@overload fun(self, x: integer, y: integer, move_range: integer): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, move_range: integer): boolean
---@overload fun(self, target_area: Area, move_range: integer): boolean
---@overload fun(self, x: integer, y: integer, force_move: boolean?): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, force_move: boolean?): boolean
---@overload fun(self, target_area: Area, force_move: boolean?): boolean
---@overload fun(self, x: integer, y: integer, move_range: integer, force_move: boolean?): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, move_range: integer, force_move: boolean?): boolean
---@overload fun(self, target_entity: Entity, move_range: integer, force_move: boolean?): boolean
---@overload fun(self, target_component: Component, move_range: integer, force_move: boolean?): boolean
function Component:RequestStateMove(target_area, move_range, force_move) end

---Request the component to sleep
---@param ticks integer? Number of ticks to sleep (OPTIONAL, default 5)
---@param keep_movement_control boolean? Keep movement control (OPTIONAL, default false)
---@overload fun(self)
---@overload fun(self, ticks: integer)
---@overload fun(self, keep_movement_control: boolean?)
function Component:SetStateSleep(ticks, keep_movement_control) end

---Request the component to work for a duration  
---If the component is required to prevent the entity from moving while working, `RequestStateMove` needs to be called first.
---@param ticks integer? Number of ticks to work (OPTIONAL, default 5)
---@param use_refresh boolean? Refresh flag, if true, the component will be updated every 5 ticks during work (OPTIONAL, default false)
---@param continue_work boolean? Continue work flag, if true, don't restart if already working (OPTIONAL, default false)
---@overload fun(self)
---@overload fun(self, ticks: integer)
---@overload fun(self, use_refresh: boolean?)
---@overload fun(self, ticks: integer, use_refresh: boolean?)
---@overload fun(self, use_refresh: boolean?, continue_work: boolean?)
function Component:SetStateStartWork(ticks, use_refresh, continue_work) end

---Request the component to work for a duration  
---If the component is required to prevent the entity from moving while working, `RequestStateMove` needs to be called first.
---@param ticks integer Total number of ticks to work
---@param refresh_ticks integer Refresh tick count, will update the component periodically during work (max 255)
---@param continue_work boolean? Continue work flag, if true, don't restart if already working (OPTIONAL, default false)
---@overload fun(self, ticks: integer, refresh_ticks: integer)
---@overload fun(self, ticks: integer, use_refresh: boolean?, continue_work: boolean?)
function Component:SetStateStartWork(ticks, refresh_ticks, continue_work) end

---Notify other components waiting for this with CC_OTHER_COMP_FAIL_WORK
function Component:NotifyWorkFailed() end

---Continue work that was started with SetStateStartWork
function Component:SetStateContinueWork() end

---Get called back the next time the first register of this component changes
function Component:WaitForFirstRegisterChange() end

---Get called back the next time any register of this component changes
function Component:WaitForComponentRegisterChange() end

---Get called back the next time the first item slot of this component changes
function Component:WaitForFirstItemSlotChange() end

---Get called back the next time any item slot of this component changes
function Component:WaitForComponentItemSlotChange() end

---Get called back the next time the entity has low power
function Component:WaitForLowPower() end

---Get called back the next time the battery charge is empty
function Component:WaitForPowerStoredEmpty() end

---Get called back when another component finishes work  
---It is not possible to wait on multiple components simultaneously
---@param other_comp Component Another component to get called back the next time it finishes work
function Component:WaitForOtherCompFinish(other_comp) end

---Activate a component (trigger on_update)  
---This is most useful for components that have the activation mode set to 'Manual', but it can also be used for other components.  
---Usage of Activate cannot be mixed with the WaitFor* functions.  
---Cannot be called from inside the on_update function (check with `is_updating`).
function Component:Activate() end

---Deactivate a component (stop triggering on_update)  
---This will abort what has been started with a SetState, RequestState or WaitFor call.  
---Cannot be called from inside the on_update function (check with `is_updating`).
function Component:Shutdown() end

---Convert a numerical cause variable received in on_update to a string (for debugging purpose)
---@param cause integer Cause
function Component:CauseToString(cause) end

---Search for the closest entity of all matching entities inside this components trigger_radius
---@param callback function Callback called for each entity in range in order of distance, return true from this to stop the search
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@return Entity? # The entity for which the callback returned true (or nil if none)
---@overload fun(self, callback: function): Entity?
function Component:FindClosestTriggeringEntity(callback, filter) end

---Spawn particle/sound effect on this component  
---Avoid calling this in the on_add callback, instead use effect property on component definition instead for automatically spawning effects.
---@param fx_id string Effect ID
---@param socket_name string? Socket name (OPTIONAL)
---@param target_entity Entity? Target entity (only for non-looping effects) (OPTIONAL)
---@param params any_table? Particle effect parameter table (only for non-looping effects) (OPTIONAL)
---@param render_instance integer? Render instance number on target if set otherwise on source (OPTIONAL)
---@return integer # Effect instance index (only for looping effects, can be used with `entity:StopEffect`)
---@overload fun(self, fx_id: string): integer
---@overload fun(self, fx_id: string, socket_name: string): integer
---@overload fun(self, fx_id: string, target_entity: Entity?): integer
---@overload fun(self, fx_id: string, params: any_table?): integer
---@overload fun(self, fx_id: string, render_instance: integer?): integer
---@overload fun(self, fx_id: string, socket_name: string, target_entity: Entity?): integer
---@overload fun(self, fx_id: string, socket_name: string, params: any_table?): integer
---@overload fun(self, fx_id: string, socket_name: string, render_instance: integer?): integer
---@overload fun(self, fx_id: string, target_entity: Entity?, params: any_table?): integer
---@overload fun(self, fx_id: string, target_entity: Entity?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, params: any_table?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, socket_name: string, target_entity: Entity?, params: any_table?): integer
---@overload fun(self, fx_id: string, socket_name: string, target_entity: Entity?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, socket_name: string, params: any_table?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, target_entity: Entity?, params: any_table?, render_instance: integer?): integer
function Component:PlayEffect(fx_id, socket_name, target_entity, params, render_instance) end

---Play effect for working component  
---Similar to PlayEffect but only starts the effect if not already playing an effect and if power is available. Will also stop playing effects if power is not available.  
---This is best used together with SetStateStartWork and passing true to its refresh flag argument.
---@param fx_id string Effect ID
---@param socket_name string? Socket name (OPTIONAL)
---@param target_entity Entity? Target entity (only for non-looping effects) (OPTIONAL)
---@param params any_table? Particle effect parameter table (only for non-looping effects) (OPTIONAL)
---@param render_instance integer? Render instance number on target if set otherwise on source (OPTIONAL)
---@overload fun(self, fx_id: string)
---@overload fun(self, fx_id: string, socket_name: string)
---@overload fun(self, fx_id: string, target_entity: Entity?)
---@overload fun(self, fx_id: string, params: any_table?)
---@overload fun(self, fx_id: string, render_instance: integer?)
---@overload fun(self, fx_id: string, socket_name: string, target_entity: Entity?)
---@overload fun(self, fx_id: string, socket_name: string, params: any_table?)
---@overload fun(self, fx_id: string, socket_name: string, render_instance: integer?)
---@overload fun(self, fx_id: string, target_entity: Entity?, params: any_table?)
---@overload fun(self, fx_id: string, target_entity: Entity?, render_instance: integer?)
---@overload fun(self, fx_id: string, params: any_table?, render_instance: integer?)
---@overload fun(self, fx_id: string, socket_name: string, target_entity: Entity?, params: any_table?)
---@overload fun(self, fx_id: string, socket_name: string, target_entity: Entity?, render_instance: integer?)
---@overload fun(self, fx_id: string, socket_name: string, params: any_table?, render_instance: integer?)
---@overload fun(self, fx_id: string, target_entity: Entity?, params: any_table?, render_instance: integer?)
function Component:PlayWorkEffect(fx_id, socket_name, target_entity, params, render_instance) end

---Stop all looping effects playing on this component
function Component:StopEffects() end

---Sets animation speed multiplied by the components current power efficiency
---@param speed number? New animation speed to be multiplied (OPTIONAL, default 1)
---@overload fun(self)
function Component:SetWorkAnimationSpeed(speed) end

---------------------------------------------------------------------------------------------------------------
---An entity object represents a single entity that can be placed in the world.  
--- - Custom operator 'tostring'  
--- - Custom operator 'equal'  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#entity)
---@class Entity
---@field key integer A unique numerical identifier of this entity
---@field id FrameId The frame id of this entity
---@field def table The frame definition table of this entity
---@field visual_id VisualId The visual id of this entity
---@field visual_def table The visual definition table of this entity
---@field components Component[] Get an array with all components of this entity (hidden and visible) It is not possible to overwrite or add items to this array
---@field slots ItemSlot[] Get an array with all item slots of this entity It is not possible to overwrite or add items to this array
---@field has_extra_data boolean Check if extra_data has been created for this entity
---@field extra_data table Access to the extra data table of this entity Reading it will always return a valid table when (will be created if not set yet) Writing nil to it will free the table from memory
---@field faction Faction The faction of this entity
---@field visibility_range integer The visibility range of this entity Must be between 0 and 255
---@field component_boost integer The component efficiency boost of this entity in percent Must be between 0 and 2550, can only be set to increments of 10 (default 100).
---@field move_boost integer The move speed boost of this entity in percent Must be between 0 and 2550, can only be set to increments of 10 (default 100).
---@field max_health integer The maximum health of this entity Must be between 1 and 65535
---@field health integer The health of this entity For adding/removing health it is preferred to use the `AddHealth`/`RemoveHealth` functions Changing the amount does nothing if the entity is at 0 health (because it is in the process of being destroyed)
---@field is_damaged boolean Check if the entity is not at max health
---@field exists boolean Check if this entity still exists or if it was destroyed
---@field efficiency integer? The power efficiency of this entity
---@field power_grid_index integer? The index of the power grid this entity is in
---@field has_power boolean Check if power is available This can be true even if other power variables (i.e. `efficiency` or `power_details`) return nil when the entity is placed inside a power grid. For docked entities it will check the availability for the outer garage entity placed on the map.
---@field extra_power integer The dynamic extra power supplied/consumed by this entity
---@field extra_transfer_range integer The dynamic extra power range of this entity
---@field power_range integer The power range of this entity
---@field power_details table<string, integer> Get a table with power details about this entity Building this table is slow so avoid reading it multiple times.
---@field battery_percent integer Get a percent number how full all equipped batteries are
---@field battery_stored integer Get the summed up number of stored power in all equipped batteries
---@field battery_total integer Get the summed up total capacity of all equipped batteries
---@field animation_speed integer Material animation speed if supported by the visual
---@field light_color Color Set light color (RGB) and intensity (A) if supported by the visual
---@field location Point The location of this entity For entities larger than 1x1 this is different than `placed_location` as it designates the location in the center of an entity. Will return the last used location for entities not placed on map.
---@field placed_location Point The location where this entity is placed For entities larger than 1x1 this is different than `location` as it designates the placed location (top left corner) of an entity. Will return the last used location for entities not placed on map.
---@field location_hash integer A hashed number representing the location of this entity Can be used to easier check if an entity has been moved.
---@field size Point The tile size of this entity
---@field area Area The position and size of this entity as an array table
---@field rotation integer The rotation of this entity
---@field move_goal Point? Get the goal coordinate of the current movement path
---@field is_moving boolean Check if the entity is moving
---@field has_movement boolean Check if this entity has movement
---@field is_placed boolean Check if this entity is placed on the map
---@field is_on_map boolean Check if this entity is on the map
---@field is_docked boolean Check if this entity is docked
---@field is_docked_on_map boolean Check if this entity is docked into something that either has is_placed or is_docked_on_map
---@field docked_garage Entity The garage this entity is docked in
---@field reserved_redock_entity Entity The garage entity this entity was autonomously undocked from
---@field disconnected boolean Disconnected from logistics network state of this entity
---@field powered_down boolean Controls the power down state of an entity.
---@field stealth boolean Controls the stealth effect of an entity.
---@field lootable boolean The lootable flag of this entity sets if all factions are able to take out items in its inventory
---@field has_blight_shield boolean The 'has blight shield' flag of this entity sets if the entity can go into the blight Note: If the entity belongs to a faction with has_blight_shield set this will always return true.
---@field has_landing_pad boolean The 'has landing pad' flag of this entity sets if orders of this entity can interact with flyers
---@field _deprecated_want_goto_callback boolean Deprecated flag
---@field logistics_channel_1 boolean The 'logistics channel 1' flag of this entity sets if the entity is connected to this channel of the logistics network (default on)
---@field logistics_channel_2 boolean The 'logistics channel 2' flag of this entity sets if the entity is connected to this channel of the logistics network (default off)
---@field logistics_channel_3 boolean The 'logistics channel 3' flag of this entity sets if the entity is connected to this channel of the logistics network (default off)
---@field logistics_channel_4 boolean The 'logistics channel 4' flag of this entity sets if the entity is connected to this channel of the logistics network (default off)
---@field logistics_supplier boolean The 'logistics supplier' flag of this entity sets if the entity is connected to the logistics network as a supplier (default on)
---@field logistics_requester boolean The 'logistics supplier' flag of this entity sets if the entity is connected to the logistics network as a requester (default on)
---@field logistics_carrier boolean The 'logistics carrier' flag of this entity sets if the entity is connected to the logistics network as a carrier (default on)
---@field logistics_crane_only boolean The 'logistics crane only' flag of this entity sets if the carrier of an order from or to this entity must be a building with a crane (default off)
---@field logistics_flying_only boolean The 'logistics flying only' flag of this entity sets if the carrier of an order from or to this entity must be a flying unit (default off)
---@field logistics_can_construction boolean The 'logistics can_construction' flag of this entity sets if the carrier of an order can service a construction entity (default on)
---@field logistics_transport_route boolean The 'logistics transport route' flag of this entity sets if the unit will always pick up at GOTO and deliver everything to STORE (default off)
---@field logistics_high_priority boolean The 'logistics high priority' flag of this entity sets if orders requested by this entity are flagged as high priority (default off)
---@field has_crane boolean The 'has crane' flag of this entity is set if crane_range has been set to a value larger than 0
---@field crane_range integer Set this to a value larger than 0 to enable the crane functionality on an entity
---@field is_construction boolean Check if this entity is a construction site
---@field state_idle boolean The 'idle' state of this entity is set when an entity does not have its movement controlled for a while
---@field state_path_blocked boolean The 'path blocked' state of this entity is set when movement fails to complete a path
---@field state_inefficient boolean The 'inefficient' state of this entity is set when running not at 100% efficiency
---@field state_unpowered boolean The 'unpowered' state of this entity is set when out of power (but not shut down)
---@field state_emergency boolean The 'emergency' state of this entity is set when health is below 75%
---@field state_broken boolean The 'broken' state of this entity is set when health is below 25%
---@field state_custom_1 boolean The custom state 1 flag of this entity (to be used freely by lua)
---@field state_custom_2 boolean The custom state 2 flag of this entity (to be used freely by lua)
---@field state_custom_3 boolean The custom state 3 flag of this entity (to be used freely by lua)
---@field state_custom_4 boolean The custom state 4 flag of this entity (to be used freely by lua)
---@field idle_mode IdleMode Get the current idle mode describing what currently controls the bots movement
---@field controlling_component Component? Get the component in control of the bots movement (or nil if none)
---@field active_order table? Get currently executing order (or nil if none)
---@field has_component_list boolean Check if the entity has a component list and can have components
---@field component_count integer Gets the number of components
---@field socket_count integer Gets the number of sockets available on the visual of this entity
---@field slot_count integer Gets the number of item slots
---@field register_count integer Gets the number of all registers (frame and component registers)
---@field frame_register_count integer? Check or change the number of frame registers (can't be less than `FRAMEREG_COUNT`)
---@field most_relevant_state EntityState Gets most relevant state
---@field all_states EntityState[] Gets all states affecting an entity (broken, path blocked, powered down, etc.)
---@field render_instances integer Get number of render instances associated with this entity
---@field has_active_effects boolean Check if there are any looping effects playing on this entity
---@field idle_ticks integer Return the number of ticks this entity has been idle for
---@field triggered_components Component[] Get an array with all components currently triggered by this entity being in their trigger_radius
---@field interpolated_location Point3D The location of the entity, interpolated to the rendered frame while moving (only accessible by UI) The Z coordinate will be the height of the ground under the entity
---@field interpolated_center Point3D The center position of the entity, interpolated to the rendered frame while moving (only accessible by UI) The Z coordinate will be adjusted to be in the center of the entity
---@field interpolated_rotation number The rotation of the entity in degrees, interpolated to the rendered frame while moving (only accessible by UI)
---@field interpolated_direction Point3D The forward direction of the entity, interpolated to the rendered frame while moving (only accessible by UI)
Entity = {}

---Place this entity on the map (or teleport it if it is already placed)  
---Unless the last parameter is false, automatically selects a close location if the passed coordinates are occupied  
---If rotation argument is not passed, it will keep the previous rotation
---@param x integer Location X
---@param y integer Location Y
---@param rotation integer? Rotation (0 to 3) (OPTIONAL)
---@param eject_from Entity? Entity for a bot to come out of (cannot be passed together with rotation) (OPTIONAL)
---@param nearby_if_blocking boolean? Place nearby if blocking (OPTIONAL, default true)
---@return boolean # Returns boolean false if failed to place, otherwise nil
---@overload fun(self, x: integer, y: integer): boolean
---@overload fun(self, x: integer, y: integer, rotation: integer): boolean
---@overload fun(self, x: integer, y: integer, eject_from: Entity?): boolean
---@overload fun(self, x: integer, y: integer, nearby_if_blocking: boolean?): boolean
---@overload fun(self, x: integer, y: integer, rotation: integer, eject_from: Entity?): boolean
---@overload fun(self, x: integer, y: integer, rotation: integer, nearby_if_blocking: boolean?): boolean
---@overload fun(self, x: integer, y: integer, eject_from: Entity?, nearby_if_blocking: boolean?): boolean
function Entity:Place(x, y, rotation, eject_from, nearby_if_blocking) end

---Place this entity on the map (or teleport it if it is already placed)  
---Unless the last parameter is false, automatically selects a close location if the passed coordinates are occupied  
---If rotation argument is not passed, it will keep the previous rotation
---@param location Point Location
---@param rotation integer? Rotation (0 to 3) (OPTIONAL)
---@param eject_from Entity? Entity for a bot to come out of (cannot be passed together with rotation) (OPTIONAL)
---@param nearby_if_blocking boolean? Place nearby if blocking (OPTIONAL, default true)
---@return boolean # Returns boolean false if failed to place, otherwise nil
---@overload fun(self, location: Point): boolean
---@overload fun(self, location: Point, rotation: integer): boolean
---@overload fun(self, location: Point, eject_from: Entity?): boolean
---@overload fun(self, location: Point, nearby_if_blocking: boolean?): boolean
---@overload fun(self, location: Point, rotation: integer, eject_from: Entity?): boolean
---@overload fun(self, location: Point, rotation: integer, nearby_if_blocking: boolean?): boolean
---@overload fun(self, location: Point, eject_from: Entity?, nearby_if_blocking: boolean?): boolean
---@overload fun(self, x: integer, y: integer, rotation: integer, eject_from: Entity?, nearby_if_blocking: boolean?): boolean
function Entity:Place(location, rotation, eject_from, nearby_if_blocking) end

---Remove this entity from the map
function Entity:Unplace() end

---Destroy this entity  
---Can automatically drop all components and inventory items held by it, as well as additional items
---@param drop_held_things boolean? Flag if items and components held by this entity should be dropped (OPTIONAL, default true)
---@param drop_ingredients table<ItemId, integer>? Table of additional items that drop (item_id keys and count values) (OPTIONAL)
---@param store_drops_in Entity? If set, try to store items in this entities inventory instead of dropping them to the ground (OPTIONAL)
---@overload fun(self)
---@overload fun(self, drop_held_things: boolean)
---@overload fun(self, drop_ingredients: table<ItemId, integer>?)
---@overload fun(self, store_drops_in: Entity?)
---@overload fun(self, drop_held_things: boolean, drop_ingredients: table<ItemId, integer>?)
---@overload fun(self, drop_held_things: boolean, store_drops_in: Entity?)
---@overload fun(self, drop_ingredients: table<ItemId, integer>?, store_drops_in: Entity?)
function Entity:Destroy(drop_held_things, drop_ingredients, store_drops_in) end

---Create and add a new component
---@param component_id string Component id
---@param add_mode string? Add mode ("auto" will find a suitable socket, "hidden" will add the component hidden) (OPTIONAL, default "auto")
---@param extra_data any_table? Extra data table (OPTIONAL, default nil)
---@return Component? # Component object (or nil on error)
---@overload fun(self, component_id: string): Component?
---@overload fun(self, component_id: string, add_mode: string): Component?
---@overload fun(self, component_id: string, extra_data: any_table?): Component?
function Entity:AddComponent(component_id, add_mode, extra_data) end

---Create and add a new component
---@param component_id string Component id
---@param socket_index integer Socket index to place the component (starts at 1)
---@param extra_data any_table? Extra data table (OPTIONAL, default nil)
---@return Component? # Component object (or nil on error)
---@overload fun(self, component_id: string, socket_index: integer): Component?
---@overload fun(self, component_id: string, add_mode: string, extra_data: any_table?): Component?
function Entity:AddComponent(component_id, socket_index, extra_data) end

---Get an existing component at a specific socket index
---@param socket_index integer Socket index (starts at 1)
---@return Component? # Component object or nil if not exist
function Entity:GetComponent(socket_index) end

---Swap the content of two sockets  
---One or both sockets must contain a component which must fit into the other socket
---@param src_socket_index integer First socket index
---@param trg_socket_index integer Second socket index
---@return boolean # If it was successful
function Entity:SwapSockets(src_socket_index, trg_socket_index) end

---Get an existing hidden component
---@param hidden_number integer? Hidden component number (starts at 1) (OPTIONAL, default 1)
---@return Component? # Component object or nil if not exist
---@overload fun(self): Component?
function Entity:GetHiddenComponent(hidden_number) end

---Count the components of the same type on an entity
---@param component_id string Component id
---@param query_base_id boolean? Set to true to query the base_id value of component definitions if it exists (OPTIONAL, default false)
---@return integer # Number of the components
---@overload fun(self, component_id: string): integer
function Entity:CountComponents(component_id, query_base_id) end

---Find an existing component
---@param component_id string Component id
---@param query_base_id boolean? Set to true to query the base_id value of component definitions if it exists (OPTIONAL, default false)
---@param component_number integer? Component number (if there are multiples of the same component) (OPTIONAL, default 1)
---@return Component? # Component object or nil if not found
---@overload fun(self, component_id: string): Component?
---@overload fun(self, component_id: string, query_base_id: boolean): Component?
---@overload fun(self, component_id: string, component_number: integer?): Component?
function Entity:FindComponent(component_id, query_base_id, component_number) end

---Check if a free socket of large enough size is available to equip a component
---@param component_id string Component id
---@return integer? # Socket index it can be equipped into or nil if not possible (or if passed id is not a component)
function Entity:GetFreeSocket(component_id) end

---Test if a component fits into a socket (regardless if there is already something equipped in the socket)
---@param component_id string Component id
---@param socket_index integer Socket index to test the component against (starts at 1)
---@return boolean # True if the socket is large enough to hold the component
function Entity:CheckSocketSize(component_id, socket_index) end

---Get a list of links on the entity
---@param include_cross_entity boolean? Also return cross-entity links (OPTIONAL, default false)
---@return table[] # Array of links
---@overload fun(self): table[]
function Entity:GetRegisterLinks(include_cross_entity) end

---Get a register of this entity
---@param register RegRef Register reference
---@return Register # Register object
function Entity:GetRegister(register) end

---Get the number part of a register of this entity
---@param register RegRef Register reference
---@return integer # Number value
function Entity:GetRegisterNum(register) end

---Get the id part of a register of this entity
---@param register RegRef Register reference
---@return AnyId # Id value
function Entity:GetRegisterId(register) end

---Get the definition table of the id stored in a register of this entity
---@param register RegRef Register reference
---@return table # Definition table
function Entity:GetRegisterDef(register) end

---Get the entity part of a register of this entity
---@param register RegRef Register reference
---@return Entity # Entity value
function Entity:GetRegisterEntity(register) end

---Get the coordinate part of a register of this entity
---@param register RegRef Register reference
---@return Point # Coordinate value
function Entity:GetRegisterCoord(register) end

---Compare two registers of this entity
---@param register1 RegRef First register reference
---@param register2 RegRef Second register reference
---@return boolean # Comparison result
function Entity:RegistersEqual(register1, register2) end

---Set a register of this entity
---@param register RegRef Register reference
---@param reg_value Register|any_table|nil Register object or table (or nil to clear a register)
---@param force_update boolean? Force update the register and activate components (OPTIONAL, default false)
---@overload fun(self, register: RegRef, reg_value: Register|any_table|nil)
function Entity:SetRegister(register, reg_value, force_update) end

---Set the number part of a register of this entity
---@param register RegRef Register reference
---@param number integer Number value
function Entity:SetRegisterNum(register, number) end

---Set the id part of a register of this entity (will overwrites the entity/coordinate part)
---@param register RegRef Register reference
---@param id string? Id value (or nil to clear the id part)
---@param number integer? Number value (OPTIONAL)
---@overload fun(self, register: RegRef)
---@overload fun(self, register: RegRef, id: string)
---@overload fun(self, register: RegRef, number: integer?)
function Entity:SetRegisterId(register, id, number) end

---Set the entity part of a register of this entity (will overwrite the id/coordinate part)
---@param register RegRef Register reference
---@param entity Entity? Entity value (or nil to clear the entity part)
---@param number integer? Number value (OPTIONAL)
---@overload fun(self, register: RegRef)
---@overload fun(self, register: RegRef, entity: Entity)
---@overload fun(self, register: RegRef, number: integer?)
function Entity:SetRegisterEntity(register, entity, number) end

---Set the coordinate part of a register of this entity (will overwrite the id/entity part)
---@param register RegRef Register reference
---@param coord Point? Coordinate value (or nil to clear the coordinate part)
---@param number integer? Number value (OPTIONAL)
---@overload fun(self, register: RegRef)
---@overload fun(self, register: RegRef, coord: Point)
---@overload fun(self, register: RegRef, number: integer?)
function Entity:SetRegisterCoord(register, coord, number) end

---Flag the error state on a register of this entity  
---Will stay flagged until the register value changes.
---@param register RegRef Register reference
---@param state boolean? Whether to set the error state (OPTIONAL, default true)
---@overload fun(self, register: RegRef)
function Entity:FlagRegisterError(register, state) end

---Check if a register of this entity is linked from another register
---@param register RegRef Register reference
---@return boolean # Link state
function Entity:RegisterIsLink(register) end

---Check if a register of this entity is empty
---@param register RegRef Register reference
---@return boolean # Empty state
function Entity:RegisterIsEmpty(register) end

---Check if a register of this entity is in error state
---@param register RegRef Register reference
---@return boolean # Error state
function Entity:RegisterIsError(register) end

---Check if two registers have a connection via link(s)
---@param register1 RegRef Register one
---@param register2 RegRef Register two
---@param separate_entity Entity? Different entity that holds the second register (OPTIONAL)
---@return boolean # Check result
---@overload fun(self, register1: RegRef, register2: RegRef): boolean
function Entity:RegisterHasConnection(register1, register2, separate_entity) end

---Check if two registers have a connection via link(s)
---@param register1 RegRef Register one
---@param register2 RegRef Register two
---@param separate_component Component A component that holds the second register
---@return boolean # Check result
---@overload fun(self, register1: RegRef, register2: RegRef, separate_entity: Entity): boolean
function Entity:RegisterHasConnection(register1, register2, separate_component) end

---Link a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_entity Entity? Different entity that holds the source register (OPTIONAL)
---@overload fun(self, target_reg: RegRef, source_reg: RegRef)
function Entity:LinkRegisterFromRegister(target_reg, source_reg, source_entity) end

---Link a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_component Component A component that holds the source register
---@overload fun(self, target_reg: RegRef, source_reg: RegRef, source_entity: Entity)
function Entity:LinkRegisterFromRegister(target_reg, source_reg, source_component) end

---Unlink a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_entity Entity? Different entity that holds the source register (OPTIONAL)
---@overload fun(self, target_reg: RegRef, source_reg: RegRef)
function Entity:UnlinkRegisterFromRegister(target_reg, source_reg, source_entity) end

---Unlink a register from another register
---@param target_reg RegRef Target register reference
---@param source_reg RegRef Source register reference
---@param source_component Component A component that holds the source register
---@overload fun(self, target_reg: RegRef, source_reg: RegRef, source_entity: Entity)
function Entity:UnlinkRegisterFromRegister(target_reg, source_reg, source_component) end

---Get the source index of the first relevant register link  
---If no entity or component is specified, information of the first link containing any value will be returned.  
---Otherwise it will look up a specific link and return only the register index.
---@param target_reg RegRef Target register reference
---@return integer? # Source register index, absolute entity index unless a source component is specified (or nil if not exist)
---@return Entity? # Entity that holds the source register (unless entity/component specified)
---@return Component? # Component that holds the source register or nil if frame register (unless entity/component specified)
function Entity:GetRegisterLinkSource(target_reg) end

---Get the source index of the first relevant register link  
---If no entity or component is specified, information of the first link containing any value will be returned.  
---Otherwise it will look up a specific link and return only the register index.
---@param target_reg RegRef Target register reference
---@param source_entity Entity Entity that holds the source register
---@return integer? # Source register index, absolute entity index unless a source component is specified (or nil if not exist)
---@return Entity? # Entity that holds the source register (unless entity/component specified)
---@return Component? # Component that holds the source register or nil if frame register (unless entity/component specified)
function Entity:GetRegisterLinkSource(target_reg, source_entity) end

---Get the source index of the first relevant register link  
---If no entity or component is specified, information of the first link containing any value will be returned.  
---Otherwise it will look up a specific link and return only the register index.
---@param target_reg RegRef Target register reference
---@param source_component Component Component that holds the source register
---@return integer? # Source register index, absolute entity index unless a source component is specified (or nil if not exist)
---@return Entity? # Entity that holds the source register (unless entity/component specified)
---@return Component? # Component that holds the source register or nil if frame register (unless entity/component specified)
---@overload fun(self, target_reg: RegRef): integer?, Entity?, Component?
---@overload fun(self, target_reg: RegRef, source_entity: Entity): integer?, Entity?, Component?
function Entity:GetRegisterLinkSource(target_reg, source_component) end

---Get the target index of the first relevant register link
---@param source_reg RegRef Source register reference
---@param source_entity Entity? Different entity that holds the source register (OPTIONAL)
---@return integer? # Target register index, absolute entity index (or nil if not exist)
---@overload fun(self, source_reg: RegRef): integer?
function Entity:GetRegisterLinkTarget(source_reg, source_entity) end

---Get the target index of the first relevant register link
---@param source_reg RegRef Source register reference
---@param source_component Component A component that holds the source register
---@return integer? # Target register index, absolute entity index (or nil if not exist)
---@overload fun(self, source_reg: RegRef, source_entity: Entity): integer?
function Entity:GetRegisterLinkTarget(source_reg, source_component) end

---Check if a register of this entity has a queue (2 or more elements)
---@param register RegRef Register reference
---@return boolean # Queue has 2 or more elements
function Entity:HaveRegisterQueue(register) end

---Count the number of queued elements
---@param register RegRef Register reference
---@return integer # Queue length (having nothing queued returns 1, register with links returns 0)
function Entity:RegisterQueueLength(register) end

---Get an element of the register queue  
---Querying the first element will return the same as `GetRegister` unless the register is linked.
---@param register RegRef Register reference
---@param index integer? Queue index (OPTIONAL, default to last)
---@return Register? # Register object (or nil if invalid index)
---@overload fun(self, register: RegRef): Register?
function Entity:RegisterQueueGet(register, index) end

---Get the entire queue as an array
---@param register RegRef Register reference
---@return Register[] # An array of register values of the same length as `RegisterQueueLength`
function Entity:RegisterQueueGetAll(register) end

---Overwrite a queued element.  
---Can write the first element while keeping the queue (unlike `SetRegister` which clears the queue).  
---Can write to an index past the end of the queue (same as `RegisterQueueInsert`).
---@param register RegRef Register reference
---@param reg_value Register|any_table|nil Register object or table
---@param index integer? Queue index (OPTIONAL, default to last)
---@overload fun(self, register: RegRef, reg_value: Register|any_table|nil)
function Entity:RegisterQueueSet(register, reg_value, index) end

---Insert a queued element at a given position or the end.  
---Can write to an index past the end of the queue (same as `RegisterQueueSet`).
---@param register RegRef Register reference
---@param reg_value Register|any_table|nil Register object or table
---@param index integer? Insertion index (OPTIONAL, default to appending to the end)
---@overload fun(self, register: RegRef, reg_value: Register|any_table|nil)
function Entity:RegisterQueueInsert(register, reg_value, index) end

---Remove a queued element
---@param register RegRef Register reference
---@param index integer? Queue index (OPTIONAL, default to last)
---@return Register? # Removed register object (or nil if invalid index)
---@overload fun(self, register: RegRef): Register?
function Entity:RegisterQueueRemove(register, index) end

---Add an item to the inventory
---@param item_id string Item id
---@param amount integer? Amount (OPTIONAL, default 1)
---@param count_history boolean? Set to true to count this as item generation in the history graph (OPTIONAL, default false)
---@param extra_data any_table? Extra data table (OPTIONAL, default nil)
---@return ItemSlot? # First item slot object into which the item has been added (or nil on error)
---@return integer # Actual amount of items that have been added
---@overload fun(self, item_id: string): ItemSlot?, integer
---@overload fun(self, item_id: string, amount: integer): ItemSlot?, integer
---@overload fun(self, item_id: string, count_history: boolean?): ItemSlot?, integer
---@overload fun(self, item_id: string, extra_data: any_table?): ItemSlot?, integer
---@overload fun(self, item_id: string, amount: integer, count_history: boolean?): ItemSlot?, integer
---@overload fun(self, item_id: string, amount: integer, extra_data: any_table?): ItemSlot?, integer
---@overload fun(self, item_id: string, count_history: boolean?, extra_data: any_table?): ItemSlot?, integer
function Entity:AddItem(item_id, amount, count_history, extra_data) end

---Count (unreserved) stacks of an item across all item slots
---@param item_id string Item id
---@param count_unreserved boolean? Count unreserved, if true it will only count unreserved stack amounts (OPTIONAL, default false)
---@return integer # Item count
---@overload fun(self, item_id: string): integer
function Entity:CountItem(item_id, count_unreserved) end

---Check if there is any free space to add the item in any item slots
---@param item_id string Item id
---@param amount integer? Count of item (OPTIONAL, default 1)
---@return boolean # Can items be added (or nil if the entity has no inventory or the item id is invalid)
---@overload fun(self, item_id: string): boolean
function Entity:HaveFreeSpace(item_id, amount) end

---Count how much free space for an item in any item slots
---@param item_id string Item id
---@return integer # Number of available Space (or nil if item id is nil)
function Entity:CountFreeSpace(item_id) end

---Find an item slot with enough free space to store a given amount
---@param item_id string Item id
---@param amount integer? Amount to search (OPTIONAL, default max stack size)
---@return ItemSlot? # Item slot object with the space available (or nil if there is none)
---@overload fun(self, item_id: string): ItemSlot?
function Entity:GetFreeSlot(item_id, amount) end

---Get a single item slot at a specific slot index
---@param slot_index integer Slot index (starts at 1)
---@return ItemSlot? # Item slot object or nil if not exist
function Entity:GetSlot(slot_index) end

---Find an item slot with a specific item
---@param item_id string Item id
---@param filter_stack integer? Limit search to slot with at least this amount of unreserved stack in it (OPTIONAL)
---@return ItemSlot? # Item slot object or nil if not found
---@overload fun(self, item_id: string): ItemSlot?
function Entity:FindSlot(item_id, filter_stack) end

---Add inventory slots
---@param slot_type string Slot type
---@param count integer? Number of slots to add (OPTIONAL, default 1)
---@return ItemSlot # Item slot object of the first newly created slot (or nil on error)
---@overload fun(self, slot_type: string): ItemSlot
function Entity:AddSlots(slot_type, count) end

---Automatically merge stacks of the same item across the inventory
---@param item_id string? Limit merging to just one this one item id (OPTIONAL)
---@return integer # Number of inventory slots that became empty due to the merge
---@overload fun(self): integer
function Entity:AutoMergeSlots(item_id) end

---Check if the entity is waiting for an order of a specific item
---@param item_id string Item id
---@param only_unassigned_orders boolean? Return true only if there is an order without a carrier assigned (OPTIONAL, default false)
---@return boolean # Has item on order
---@overload fun(self, item_id: string): boolean
function Entity:IsWaitingForOrder(item_id, only_unassigned_orders) end

---Transfer an item from the inventory of another entity
---@param source_entity Entity Item source entity
---@param item_id string Item id
---@param amount integer Amount
---@param show_throw boolean? Show the visual item throw effect (OPTIONAL, default false)
---@param auto_equip_component boolean? Should attempt to auto equip a component if inventory is full (OPTIONAL, default false)
---@return integer # Amount actually transferred (can be 0 if there is no free space) (or nil on error)
---@overload fun(self, source_entity: Entity, item_id: string, amount: integer): integer
---@overload fun(self, source_entity: Entity, item_id: string, amount: integer, show_throw: boolean): integer
function Entity:TransferFrom(source_entity, item_id, amount, show_throw, auto_equip_component) end

---Drop an item to the ground  
---If a drop target coordinate is given further away than 1 tile and the entity has movement, the entity will move to the location before dropping.
---@param item_id string Item id
---@param amount integer? Amount (OPTIONAL, default to everything available of that item id)
---@param drop_x integer? X coordinate of drop target (OPTIONAL)
---@param drop_y integer? Y coordinate of drop target (OPTIONAL)
---@overload fun(self, item_id: string)
---@overload fun(self, item_id: string, amount: integer)
---@overload fun(self, item_id: string, amount: integer, drop_x: integer?)
function Entity:DropItem(item_id, amount, drop_x, drop_y) end

---Drop an item to the ground  
---If a drop target coordinate is given further away than 1 tile and the entity has movement, the entity will move to the location before dropping.
---@param item_slot ItemSlot Item slot
---@param amount integer? Amount (OPTIONAL, default to everything available in given item slot)
---@param drop_x integer? X coordinate of drop target (OPTIONAL)
---@param drop_y integer? Y coordinate of drop target (OPTIONAL)
---@overload fun(self, item_slot: ItemSlot)
---@overload fun(self, item_slot: ItemSlot, amount: integer)
---@overload fun(self, item_slot: ItemSlot, amount: integer, drop_x: integer?)
---@overload fun(self, item_id: string, amount: integer, drop_x: integer?, drop_y: integer?)
function Entity:DropItem(item_slot, amount, drop_x, drop_y) end

---Drop an equipped component to the ground  
---If a drop target coordinate is given, it will only used as a direction where to drop. It is not possible to drop away further than 1 tile.
---@param component Component Component to drop
---@param drop_x integer X coordinate of drop target
---@param drop_y integer Y coordinate of drop target
function Entity:DropComponent(component, drop_x, drop_y) end

---Order an item  
---The order will stay active until fulfilled, CancelOrder gets called or the entity is destroyed.  
---Will return nil on invalid item or amount or if not enough free space available in the slot.  
---Multiple orders can be created covering the entire inventory.  
---If priority IS NOT "ManualOrder", no new orders will be created if the inventory already contains the requested amount (and nil will be returned).  
---If priority IS "ManualOrder", a single component can be ordered and auto equipped even when there is no free item slot is available.
---@param item_id string Item id to be ordered
---@param amount integer Amount to be ordered
---@param mode string? Mode "None", "HighPriority", "ManualOrder", "Recurring", "ManualOrder|Recurring" (OPTIONAL, default "None")
---@param channel_bitmask integer? If set and not 0, make the order on the channels denoted by the set bits (OPTIONAL)
---@return integer # Order ID created or modified
---@overload fun(self, item_id: string, amount: integer): integer
---@overload fun(self, item_id: string, amount: integer, mode: string): integer
---@overload fun(self, item_id: string, amount: integer, channel_bitmask: integer?): integer
function Entity:OrderItem(item_id, amount, mode, channel_bitmask) end

---Get the location of this entity. Same as `location` but returns 2 integers instead of a table.
---@return integer # X coordinate
---@return integer # Y coordinate
function Entity:GetLocationXY() end

---Estimate the location of this entity in the future, only different from `location` when moving.
---@param ticks integer How many ticks in the future to estimate for
---@return integer # X coordinate
---@return integer # Y coordinate
function Entity:EstimateLocationInTicks(ticks) end

---Start moving the entity to a given location
---@param target_entity Entity Target entity to move next to
---@param move_range integer? Range of how close by to stop (OPTIONAL, default 1)
---@overload fun(self, target_entity: Entity)
function Entity:MoveTo(target_entity, move_range) end

---Start moving the entity to a given location
---@param target_area Area Location or area to move away from
---@param move_range integer? Range of how close by to stop (OPTIONAL, default 0)
---@overload fun(self, x: integer, y: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer)
---@overload fun(self, target_area: Area)
---@overload fun(self, x: integer, y: integer, move_range: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, move_range: integer)
---@overload fun(self, target_entity: Entity, move_range: integer)
function Entity:MoveTo(target_area, move_range) end

---Start moving the entity somewhere outside of a given area.  
---This will do nothing if the entity is already outside the area.
---@param area Area Location or area to move away from
---@overload fun(self, x: integer, y: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer)
function Entity:MoveAway(area) end

---Stop movement and abort what is currently controlling the entities movement.  
---Movement can be controlled via manual movement, or automated by order/component/context/home.  
---Components that don't request movement control will continue working autonomously.
function Entity:Cancel() end

---Rotate the entity to look towards a given location
---@param area Area Location
---@overload fun(self, x: integer, y: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer)
function Entity:LookAt(area) end

---Check if the entity is touching another entity or a location
---@param area Area Location
---@return boolean # True if located next to other entity/location
---@overload fun(self, x: integer, y: integer): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): boolean
function Entity:IsTouching(area) end

---Check if the entity is in range of another entity or a location
---@param area Area Location
---@param test_range integer Range to test (if 1 will act like IsTouching)
---@return boolean # True if in range of other entity/location
---@overload fun(self, x: integer, y: integer, test_range: integer): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, test_range: integer): boolean
function Entity:IsInRangeOf(area, test_range) end

---Measure the range in tiles to another entity or a location
---@param area Area Location
---@return integer # Distance in number of tiles
---@overload fun(self, x: integer, y: integer): integer
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): integer
function Entity:GetRangeTo(area) end

---Get the squared distance to another entity or a location
---@param area Area Location
---@return integer # Squared distance
---@overload fun(self, x: integer, y: integer): integer
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): integer
function Entity:GetRangeSquaredTo(area) end

---Request Inventory to be dumped into nearest storage
function Entity:IssueDumpingOrders() end

---Dock this entity into an item slot of another entity
---@param garage_entity Entity Garage entity to dock into
---@return boolean # True if docking succeeded, false if garage was full (or nil on error)
function Entity:DockInto(garage_entity) end

---Undock this entity
---@param reserve_return boolean? If true, reserve the item slot for this entity to come back later (OPTIONAL, default false)
---@param place_on_map boolean? If false, don't place the entity on the map after undocking (OPTIONAL, default true)
---@return boolean # True if undocking succeeded (or nil on error)
---@overload fun(self): boolean
---@overload fun(self, reserve_return: boolean): boolean
function Entity:Undock(reserve_return, place_on_map) end

---removes an instance from the entity
function Entity:RemoveEntityInstance() end

---Spawn particle/sound effect on this entity
---@param fx_id string Effect ID
---@param socket_anme string? Socket name (OPTIONAL)
---@param target_entity Entity? Target entity (only for non-looping effects) (OPTIONAL)
---@param params any_table? Particle effect parameter table (only for non-looping effects) (OPTIONAL)
---@param render_instance integer? Render instance number on target if set otherwise on source (OPTIONAL)
---@return integer # Effect instance (only for looping effects, can be used with `entity:StopEffect`)
---@overload fun(self, fx_id: string): integer
---@overload fun(self, fx_id: string, socket_anme: string): integer
---@overload fun(self, fx_id: string, target_entity: Entity?): integer
---@overload fun(self, fx_id: string, params: any_table?): integer
---@overload fun(self, fx_id: string, render_instance: integer?): integer
---@overload fun(self, fx_id: string, socket_anme: string, target_entity: Entity?): integer
---@overload fun(self, fx_id: string, socket_anme: string, params: any_table?): integer
---@overload fun(self, fx_id: string, socket_anme: string, render_instance: integer?): integer
---@overload fun(self, fx_id: string, target_entity: Entity?, params: any_table?): integer
---@overload fun(self, fx_id: string, target_entity: Entity?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, params: any_table?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, socket_anme: string, target_entity: Entity?, params: any_table?): integer
---@overload fun(self, fx_id: string, socket_anme: string, target_entity: Entity?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, socket_anme: string, params: any_table?, render_instance: integer?): integer
---@overload fun(self, fx_id: string, target_entity: Entity?, params: any_table?, render_instance: integer?): integer
function Entity:PlayEffect(fx_id, socket_anme, target_entity, params, render_instance) end

---Stop all looping particle/sound effects
function Entity:StopEffects() end

---Stop a specific looping particle/sound effect
---@param effect_instance integer Effect Instance
function Entity:StopEffect(effect_instance) end

---Activate event of the visuals frame blueprint
function Entity:Activate() end

---Deactivate event of the visuals frame blueprint
function Entity:Deactivate() end

---Get the size this entity would have at a given rotation
---@param rotation integer Rotation (0 to 3)
---@return integer # Size width
---@return integer # Size height
function Entity:GetSizeAtRotation(rotation) end

---Sets a new visual and rotation for an entity  
---This will fail and return false if the new visual in the new rotation occupies different tiles or has different component sockets.
---@param visual_id string Visual id
---@param rotation integer? Rotation (0 to 3) (OPTIONAL)
---@return boolean # Result
---@overload fun(self, visual_id: string): boolean
function Entity:SetVisual(visual_id, rotation) end

---Check if this entity matches an entity filter
---@param filter integer? Filter by frame type (FF_FOUNDATION, FF_WALL, FF_GATE, FF_DROPPEDITEM, FF_CONSTRUCTION, FF_RESOURCE, FF_OPERATING) or faction (FF_OWNFACTION, FF_ENEMYFACTION, FF_NEUTRALFACTION, FF_ALLYFACTION, FF_WORLDFACTION) (OPTIONAL, default FF_ALL)
---@param faction FactionOrEntity? The faction that is considered self with regards to faction filters passed to the previous argument (must be passed for faction filters)
---@return boolean # True if the entity matches the filter
---@overload fun(self): boolean
---@overload fun(self, filter: integer): boolean
---@overload fun(self, faction: FactionOrEntity?): boolean
function Entity:MatchFilter(filter, faction) end

---Check if this entity still exists and is owned by a given faction
---@param faction FactionOrId Faction or faction id to check
---@return boolean # Result
function Entity:ExistsOnFaction(faction) end

---Add health (cannot exceed max_health)  
---This does nothing if the entity is at 0 health (because it is in the process of being destroyed)
---@param add_health integer Add amount
---@return integer # New health amount on entity
function Entity:AddHealth(add_health) end

---Remove health while handling any damage reduction by shield components  
---This does nothing if the entity is at 0 health (because it is in the process of being destroyed)
---@param remove_health integer Remove amount
---@param damager_entity Entity? Which entity caused the damage (OPTIONAL)
---@param damager_type string? type of damage to remove (OPTIONAL)
---@return integer # New health amount on entity (0 if destroyed)
---@overload fun(self, remove_health: integer): integer
---@overload fun(self, remove_health: integer, damager_entity: Entity): integer
---@overload fun(self, remove_health: integer, damager_type: string?): integer
function Entity:RemoveHealth(remove_health, damager_entity, damager_type) end

---------------------------------------------------------------------------------------------------------------
---A global event listener used for various APIs  
--- - Custom operator 'index': Depending on context or the type of this listener calling a bound function might not be supported.  
--- - Custom operator 'newindex': Bind a function to this listener, usually done with a function assignment like function LISTENER.FUNCTIONNAME(arg1, arg2) ... end  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#eventlistener)
---@class EventListener
---@field [string] function Listener functions (can bind multiple function to same key)
EventListener = {}

---Bind a function to this listener, usually done with a function assignment like  
---function LISTENER.FUNCTIONNAME(arg1, arg2) ... end  
---Only use this if you want to explicitly unbind the function later.
---@param function_name string Function name
---@param callback function Callback function
function EventListener:Bind(function_name, callback) end

---Unbind a specific function from this listener  
---Depending on the type of this listener unbinding functions might not be supported.
---@param function_name string Function name
---@param callback function Callback function
function EventListener:Unbind(function_name, callback) end

---Unbind all functions bound to a given name  
---Depending on the type of this listener unbinding functions might not be supported.
---@param function_name string Function name
function EventListener:UnbindAll(function_name) end

---------------------------------------------------------------------------------------------------------------
---A faction object represents a player or world owned faction.  
--- - Custom operator 'tostring'  
--- - Custom operator 'equal'  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#faction)
---@class Faction
---@field is_world_faction boolean Check if this faction is the world faction
---@field is_player_controlled boolean Check if this faction was created to be controlled by players
---@field has_logged_in_player boolean Check if this faction has a logged in player
---@field default_trust FactionTrust The default trust level towards other factions
---@field entities Entity[] Get entities owned by this faction (excludes foundation entities)
---@field num_entities integer Get the number of entities owned by this faction (excludes foundation entities)
---@field num_operating_entities integer Get the number of operating entities placed by this faction
---@field num_unlocked_techs integer Get the number of unlocked techs
---@field foundation_entities Entity[] Get foundation entities owned by this faction
---@field all_items table<ItemId, integer> Get all resources available to this faction
---@field has_extra_data boolean Check if extra_data has been created for this faction
---@field extra_data table Access to the extra data table of this faction Reading it will always return a valid table when (will be created if not set yet) Writing nil to it will free the table from memory
---@field has_blight_shield boolean The 'has blight shield' flag of this faction sets if its entities can go into the blight
---@field id FactionId The id of this faction
---@field component_boost integer The component efficiency boost of this faction in percent (default 100).
---@field index FactionId The index of this faction in the faction array of the map
---@field name string The name of this faction If not explicitly set, returns the name of the first player controlling this faction. If not set and no player is controlling the faction, returns just the id.
---@field seed integer This returns a completely random number for this faction assigned at spawn time independent of the map seed
---@field unlocks AnyId[] Get list of unlocked things
---@field unlocked_techs TechId[] Get list of unlocked techs
---@field unlocked_items ItemId[] Get list of unlocked items (does not include frames or components)
---@field unlocked_frames FrameId[] Get list of unlocked frames
---@field unlocked_components ComponentId[] Get list of unlocked components
---@field unlocked_values ValueId[] Get list of unlocked values
---@field unlocked_codex AnyId[] Get list of unlocked codex entries
---@field researchable_techs TechId[] Get list of all techs available for research
---@field items_picked_up ItemId[] Get list of all picked up items
---@field discovered_tiles integer Get the total number of visibility tiles this faction has revealed
---@field moods table<string, integer> Get table of faction moods
---@field color Color The faction color Can only be modified before the first entity is created for this faction
---@field home_location Point Faction home/start location If home_entity is set and exists, it will override what is returned when getting the location
---@field home_entity Entity Faction home/start entity Setting a home entity will also set the home location to that entities location
Faction = {}

---Unlock something
---@param id string Id to unlock (can be item, frame, component, blueprint, behavior, codex or tech)
---@param show_notification boolean? Notification (OPTIONAL, default true)
---@return boolean # Returns false if already unlocked
---@overload fun(self, id: string): boolean
function Faction:Unlock(id, show_notification) end

---Check if something was unlocked
---@param id string Id to check
---@return boolean # Result of check
function Faction:IsUnlocked(id) end

---Check if a tech is available for research
---@param tech_id string Tech id
---@return boolean # Result of check
function Faction:IsResearchable(tech_id) end

---Check if an item was picked up
---@param item_id string Item id
---@return boolean # Result of check
function Faction:HavePickedUpItem(item_id) end

---Get stats on all power grids of this faction
---@return table<string, integer>[] # Power grids
function Faction:GetPowerGrids() end

---Get stats on all power grids of this faction
---@param grid_index integer Grid index (see entity.power_details or faction:GetPowerGridIndexAt)
---@return table<string, integer> # Power grid details
function Faction:GetPowerGrid(grid_index) end

---Check if a tile or area is in a power grid of this faction  
---If the checking area is larger than one tile, will only return the first power grid found.
---@param area Area Location to check
---@param range integer? Additional range around the location to check (OPTIONAL, default 0)
---@return integer? # Index of the power grid (or nil if not inside any power grid)
---@overload fun(self, x: integer, y: integer): integer?
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): integer?
---@overload fun(self, area: Area): integer?
---@overload fun(self, x: integer, y: integer, range: integer): integer?
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, range: integer): integer?
function Faction:GetPowerGridIndexAt(area, range) end

---Get the history of power  
---If the requested number of elements is larger than history buffer, the arrays will be filled with zeros  
---If the requested number of elements is 1, the function will return the numbers directly instead of an array
---@param resolution integer Resolution (1 finest, 3 most coarse)
---@param count integer Number of elements to read
---@return table # Power history data { total_produced = .., total_consumed = .. }
function Faction:GetPowerHistory(resolution, count) end

---Get the history of an item held by the faction  
---If the requested number of elements is larger than history buffer, the arrays will be filled with zeros  
---If the requested number of elements is 1, the function will return the numbers directly instead of an array
---@param item_id string item id
---@param resolution integer Resolution (1 finest, 3 most coarse)
---@param count integer Number of elements to read
---@return table # Item history data { added = .., removed = .. }
function Faction:GetItemHistory(item_id, resolution, count) end

---Get the total amount currently available of an item
---@param item_id string item id
---@return integer # Total item availability count
function Faction:GetItemAmount(item_id) end

---Get a table of all entities that hold a specific item
---@param item_id string item id
---@return table<Entity, integer>? # Item availability table (key is entity, value is amount held) or nil if not available
function Faction:GetItemAvailability(item_id) end

---Get the total amount of generated (mined/produced) and consumed (as ingredients) for an item
---@param item_id string item id
---@return integer # Total amount generated
---@return integer # Total amount consumed
function Faction:GetItemTotals(item_id) end

---Modify the total amount of generated (mined/produced) and consumed (as ingredients) for an item
---@param item_id string item id
---@param change_generated integer Change to total amount generated (positive value to increase, negative value to reduce)
---@param change_consumed integer Change to total amount consumed (positive value to increase, negative value to reduce)
---@param store_history boolean? Store this change in the history graph (passed numbers must be positive values) (OPTIONAL)
---@overload fun(self, item_id: string, change_generated: integer, change_consumed: integer)
function Faction:ModifyItemTotals(item_id, change_generated, change_consumed, store_history) end

---Get a list of all active orders
---@param filter_entity Entity? Filter orders to only contain those that involve this entity (OPTIONAL)
---@return table[] # Array of orders
---@overload fun(self): table[]
function Faction:GetActiveOrders(filter_entity) end

---Get the count of all active orders
---@param filter_entity Entity? Filter orders to only contain those that involve this entity (OPTIONAL)
---@return integer # Count of orders
---@overload fun(self): integer
function Faction:GetNumActiveOrders(filter_entity) end

---Cancel an existing order
---@param order_id integer Order id
function Faction:CancelOrder(order_id) end

---Create order to move items from one entity to another  
---Either source or target entity must be owned by this faction
---@param source_entity Entity Source entity
---@param target_entity Entity Target entity
---@param item_id string Item id
---@param amount integer? Amount (OPTIONAL, default to anything available in first slot with item id)
---@param update_existing boolean? Pass true update an existing order first with a new amount before creating a new order (OPTIONAL)
---@return boolean # Return true if successful and false if the source doesn't hold the item amount or the target can't receive it
---@overload fun(self, source_entity: Entity, target_entity: Entity, item_id: string): boolean
---@overload fun(self, source_entity: Entity, target_entity: Entity, item_id: string, amount: integer): boolean
---@overload fun(self, source_entity: Entity, target_entity: Entity, item_id: string, update_existing: boolean?): boolean
function Faction:OrderTransfer(source_entity, target_entity, item_id, amount, update_existing) end

---Create order to move items from one entity to another  
---Either source or target entity must be owned by this faction
---@param source_entity Entity Source entity
---@param target_entity Entity Target entity
---@param source_slot ItemSlot Source item slot
---@param amount integer? Amount (OPTIONAL, default to anything available in source item slot)
---@param update_existing boolean? Pass true update an existing order first with a new amount before creating a new order (OPTIONAL)
---@return boolean # Return true if successful and false if the source doesn't hold the item amount or the target can't receive it
---@overload fun(self, source_entity: Entity, target_entity: Entity, source_slot: ItemSlot): boolean
---@overload fun(self, source_entity: Entity, target_entity: Entity, source_slot: ItemSlot, amount: integer): boolean
---@overload fun(self, source_entity: Entity, target_entity: Entity, source_slot: ItemSlot, update_existing: boolean?): boolean
function Faction:OrderTransfer(source_entity, target_entity, source_slot, amount, update_existing) end

---Create order to move items from one entity to another  
---Either source or target entity must be owned by this faction
---@param source_entity Entity Source entity
---@param target_entity Entity Target entity
---@param source_component Component Source component
---@return boolean # Return true if successful and false if the source doesn't hold the item amount or the target can't receive it
---@overload fun(self, source_entity: Entity, target_entity: Entity, item_id: string, amount: integer, update_existing: boolean?): boolean
---@overload fun(self, source_entity: Entity, target_entity: Entity, source_slot: ItemSlot, amount: integer, update_existing: boolean?): boolean
function Faction:OrderTransfer(source_entity, target_entity, source_component) end

---Check if a specific frame/visual combination can be placed by this faction at a given location  
---If the construction flag is set, the check will return true if checking a location over entities with movement that can move out of the way.  
---If 'return blocking buildings' is true, the check will not fail on blocking buildings of the same faction but instead the function will return a second value with a table array containing the blocked buildings.
---@param frame_id string Frame id
---@param location_x integer Location X
---@param location_y integer Location Y
---@param rotation integer? Rotation (0 to 3) (OPTIONAL, default 0)
---@param visual_id string? Specific visual id or another frame id from which to use the visual (OPTIONAL, defaults to frame visual)
---@param is_construction boolean? Construction flag (OPTIONAL, default false)
---@param is_ungenerated_blocking boolean? Treat ungenerated map areas as blocking (OPTIONAL, default true)
---@param get_blocking_buildings boolean? Return blocking buildings (OPTIONAL, default false)
---@param get_dropped_items boolean? Return array of dropped items in area (OPTIONAL, default false)
---@return boolean # Result of the check
---@return Entity[]? # Blocking buildings table (only returned if get_blocking_buildings was set, will be nil if there are none)
---@return Entity[]? # Dropped items table (only returned if get_dropped_items was set, will be nil if there are none)
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, is_construction: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, visual_id: string?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, is_construction: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?, is_construction: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, visual_id: string?, is_construction: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?, is_construction: boolean?, is_ungenerated_blocking: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, visual_id: string?, is_construction: boolean?, is_ungenerated_blocking: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?, get_dropped_items: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, visual_id: string?, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?, get_dropped_items: boolean?): boolean, Entity[]?, Entity[]?
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?, is_construction: boolean?, is_ungenerated_blocking: boolean?, get_blocking_buildings: boolean?, get_dropped_items: boolean?): boolean, Entity[]?, Entity[]?
function Faction:CanPlace(frame_id, location_x, location_y, rotation, visual_id, is_construction, is_ungenerated_blocking, get_blocking_buildings, get_dropped_items) end

---Return the closest location where CanPlace would return true
---@param frame_id string Frame id
---@param location_x integer Location X
---@param location_y integer Location Y
---@param rotation integer? Rotation (0 to 3) (OPTIONAL, default 0)
---@param visual_id string? Specific visual id or another frame id from which to use the visual (OPTIONAL, defaults to frame visual)
---@param is_construction boolean? Construction flag (OPTIONAL, default false)
---@param is_ungenerated_blocking boolean? Treat ungenerated map areas as blocking (OPTIONAL, default true)
---@return integer # Resulting Location X
---@return integer # Resulting Location Y
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, is_construction: boolean?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, visual_id: string?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, is_construction: boolean?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?, is_construction: boolean?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, visual_id: string?, is_construction: boolean?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, rotation: integer, is_construction: boolean?, is_ungenerated_blocking: boolean?): integer, integer
---@overload fun(self, frame_id: string, location_x: integer, location_y: integer, visual_id: string?, is_construction: boolean?, is_ungenerated_blocking: boolean?): integer, integer
function Faction:GetPlaceableLocation(frame_id, location_x, location_y, rotation, visual_id, is_construction, is_ungenerated_blocking) end

---Reveal visibility of an area
---@param area Area Area
---@param range integer Visibility range
---@overload fun(self, x: integer, y: integer, range: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, range: integer)
function Faction:RevealArea(area, range) end

---Hide visibility of an area
---@param area Area Area
---@param range integer Visibility range
---@overload fun(self, x: integer, y: integer, range: integer)
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, range: integer)
function Faction:HideArea(area, range) end

---Check if a tile or area is currently visible to this faction
---@param area Area Location to check
---@param need_all_visible boolean? If true and area specifies multiple tiles, require all tiles to be visible (OPTIONAL, default false)
---@return boolean # Result of check
---@overload fun(self, x: integer, y: integer): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): boolean
---@overload fun(self, area: Area): boolean
---@overload fun(self, x: integer, y: integer, need_all_visible: boolean): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, need_all_visible: boolean): boolean
function Faction:IsVisible(area, need_all_visible) end

---Check if a tile or area has been revealed by this faction
---@param area Area Location to check
---@param need_all_discovered boolean? If true and area specifies multiple tiles, require all tiles to be discovered (OPTIONAL, default false)
---@return boolean # Result of check
---@overload fun(self, x: integer, y: integer): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): boolean
---@overload fun(self, area: Area): boolean
---@overload fun(self, x: integer, y: integer, need_all_discovered: boolean): boolean
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, need_all_discovered: boolean): boolean
function Faction:IsDiscovered(area, need_all_discovered) end

---Check if an entity is visible to this faction (true for everything in visible are as well as certain entities in discovered tiles)
---@param entity Entity Entity to check
---@return boolean # Result of check
function Faction:IsSeen(entity) end

---Finds closest non visible tile
---@param start_x integer Start X coordinate
---@param start_y integer Start Y coordinate
---@param check_tile_count integer Stop search after checking how many tiles
---@param skip_blight boolean? Skip blight tiles (OPTIONAL, default true)
---@return integer # Result X position
---@return integer # Result Y position
---@overload fun(self, start_x: integer, start_y: integer, check_tile_count: integer): integer, integer
function Faction:FindClosestHiddenTile(start_x, start_y, check_tile_count, skip_blight) end

---Run code in UI context or call bound UIMsg functions  
---When called from simulation context the function will execute for all players in this faction (to limit to other players use `UI.Run` or `Action.RunUI`)  
---When called from UI context the function will only execute for the local player if it is in this faction
---@param func function LUA function to execute in UI context
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(self, func: function)
function Faction:RunUI(func, ...) end

---Run code in UI context or call bound UIMsg functions  
---When called from simulation context the function will execute for all players in this faction (to limit to other players use `UI.Run` or `Action.RunUI`)  
---When called from UI context the function will only execute for the local player if it is in this faction
---@param msg_name string Message name registered in UIMsg
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@overload fun(self, msg_name: string)
---@overload fun(self, msg_name: string, ...: any) -- dotdotdot
---@overload fun(self, func: function, ...: any)
function Faction:RunUI(msg_name, ...) end

---Order movable entities to move away from a given area
---@param area Area Location or area
---@param except_entity Entity? An entity that will be excepted from the order (OPTIONAL)
---@return integer # The number of entities that successfully were ordered to move away
---@return integer # The total number of blocking entities currently in the area (of any faction, excludes the excepted entity)
---@overload fun(self, x: integer, y: integer): integer, integer
---@overload fun(self, x: integer, y: integer, width: integer, height: integer): integer, integer
---@overload fun(self, area: Area): integer, integer
---@overload fun(self, x: integer, y: integer, except_entity: Entity): integer, integer
---@overload fun(self, x: integer, y: integer, width: integer, height: integer, except_entity: Entity): integer, integer
function Faction:OrderEntitiesToMoveAway(area, except_entity) end

---Faction wide change all references in registers of one entity to point towards another  
---Will also update the `home_entity` if that is set to the old entity
---@param old_entitz Entity The old entity value
---@param new_entity Entity? The new entity value (or nil to clear it)
---@overload fun(self, old_entitz: Entity)
function Faction:UpdateEntityInRegisters(old_entitz, new_entity) end

---Respawn the faction
function Faction:Respawn() end

---Add some amount to one of the faction moods
---@param mood_name string Mood name (one of the table keys in moods)
---@param amount integer Amount to add
function Faction:AddMood(mood_name, amount) end

---Get all components of a given type equipped by entities of this faction
---@param component_id string? Component id
---@param query_base_id boolean? Set to true to query the base_id value of component definitions if it exists (OPTIONAL, default false)
---@return Component[] # Array of components
---@overload fun(self): Component[]
---@overload fun(self, component_id: string): Component[]
---@overload fun(self, query_base_id: boolean?): Component[]
function Faction:GetComponents(component_id, query_base_id) end

---Get all entities of this faction that have a given component equipped
---@param component_id string Component id
---@param query_base_id boolean? Set to true to query the base_id value of component definitions if it exists (OPTIONAL, default false)
---@param exclude_hidden boolean? Set to not return hidden components (OPTIONAL, default false)
---@return Entity[] # Array of entities
---@overload fun(self, component_id: string): Entity[]
---@overload fun(self, component_id: string, query_base_id: boolean): Entity[]
function Faction:GetEntitiesWithComponent(component_id, query_base_id, exclude_hidden) end

---Get all entities of this faction that have a specific frame register set, optionally filtered by id or entity
---@param frame_register integer Frame register number
---@param only_entities boolean? Return only entities which have any kind of entity referenced in the register (OPTIONAL, default false)
---@return Entity[] # Array of entities matching the filter
---@overload fun(self, frame_register: integer): Entity[]
function Faction:GetEntitiesWithRegister(frame_register, only_entities) end

---Get all entities of this faction that have a specific frame register set, optionally filtered by id or entity
---@param frame_register integer Frame register number
---@param filter_id string Id filter
---@param include_entities boolean? Additionally return all entities which have any kind of entity referenced in the register (OPTIONAL, default false)
---@return Entity[] # Array of entities matching the filter
---@overload fun(self, frame_register: integer, filter_id: string): Entity[]
function Faction:GetEntitiesWithRegister(frame_register, filter_id, include_entities) end

---Get all entities of this faction that have a specific frame register set, optionally filtered by id or entity
---@param frame_register integer Frame register number
---@param filter_entity Entity Entity filter
---@return Entity[] # Array of entities matching the filter
---@overload fun(self, frame_register: integer, only_entities: boolean): Entity[]
---@overload fun(self, frame_register: integer, filter_id: string, include_entities: boolean): Entity[]
function Faction:GetEntitiesWithRegister(frame_register, filter_entity) end

---Get all entities of this faction with a given frame id  
---Cannot be used with foundation type frame ids
---@param frame_id string Frame id
---@return Entity[] # Array of entities
function Faction:GetEntitiesWithId(frame_id) end

---Check if this faction owns an entity with a given frame id, will return the first found entity or nil  
---Cannot be used with foundation type frame ids
---@param frame_id string Frame id
---@return Entity? # Entity (or nil if none)
function Faction:GetEntityWithId(frame_id) end

---Get all entities owned by this faction that are on screen (excludes foundation entities)  
---If true gets passed, the 5th element will be either nil, a register value or an array with 3 elements per register (reg, x, y)  
---The states value is a bit-flag integer which can be passed to `Tool.ParseEntityStates`  
---The filter_state argument is a bit-flag integer which can be generated by `Tool.EncodeEntityStates`
---@param cache_table any_table? Pass a table to use it as a cache for the return value to avoid allocating a new large table (OPTIONAL)
---@param visual_or_state boolean? Set to true to only get entities with visual register set or a state (OPTIONAL, default false)
---@param filter_entity Entity? If set will only check against that single entity instead of everything on screen (OPTIONAL)
---@param filter_state integer? Only usable with visual_or_state set to true, return only entities with certain states (OPTIONAL)
---@return table # One array with 4 or 6 elements for each entity (entity, X, Y, distance as well as visual register and states if true was passed)
---@return integer # How many elements were written to the table (entity count * 4 or 6)
---@overload fun(self): table, integer
---@overload fun(self, cache_table: any_table): table, integer
---@overload fun(self, visual_or_state: boolean?): table, integer
---@overload fun(self, filter_entity: Entity?): table, integer
---@overload fun(self, filter_state: integer?): table, integer
---@overload fun(self, cache_table: any_table, visual_or_state: boolean?): table, integer
---@overload fun(self, cache_table: any_table, filter_entity: Entity?): table, integer
---@overload fun(self, cache_table: any_table, filter_state: integer?): table, integer
---@overload fun(self, visual_or_state: boolean?, filter_entity: Entity?): table, integer
---@overload fun(self, visual_or_state: boolean?, filter_state: integer?): table, integer
---@overload fun(self, filter_entity: Entity?, filter_state: integer?): table, integer
---@overload fun(self, cache_table: any_table, visual_or_state: boolean?, filter_entity: Entity?): table, integer
---@overload fun(self, cache_table: any_table, visual_or_state: boolean?, filter_state: integer?): table, integer
---@overload fun(self, cache_table: any_table, filter_entity: Entity?, filter_state: integer?): table, integer
---@overload fun(self, visual_or_state: boolean?, filter_entity: Entity?, filter_state: integer?): table, integer
function Faction:GetVisibleEntities(cache_table, visual_or_state, filter_entity, filter_state) end

---Set the trust level towards another faction  
---The trust level from/to the world faction and self can't be changed
---@param other_faction FactionOrId Other faction or faction id
---@param trust_level string Trust level, one of 'ENEMY', 'NEUTRAL' or 'ALLY'
---@param bidirectional boolean? If set to true, will apply the trust level bidirectional for the other faction towards this as well (OPTIONAL, default false)
---@overload fun(self, other_faction: FactionOrId, trust_level: string)
function Faction:SetTrust(other_faction, trust_level, bidirectional) end

---Set the trust level towards another faction  
---The trust level from/to the world faction and self can't be changed
---@param other_entity Entity Entity to use the owning faction for the check
---@param trust_level string Trust level, one of 'ENEMY', 'NEUTRAL' or 'ALLY'
---@param bidirectional boolean? If set to true, will apply the trust level bidirectional for the other faction towards this as well (OPTIONAL, default false)
---@overload fun(self, other_entity: Entity, trust_level: string)
---@overload fun(self, other_faction: FactionOrId, trust_level: string, bidirectional: boolean)
function Faction:SetTrust(other_entity, trust_level, bidirectional) end

---Get the trust level towards another faction
---@param other_faction FactionOrId Other faction or faction id
---@return FactionTrust # Trust level, one of 'ENEMY', 'NEUTRAL' or 'ALLY' (will always be 'ALLY' when checking against self and nil when other faction doesn't exist)
function Faction:GetTrust(other_faction) end

---Get the trust level towards another faction
---@param other_entity Entity Entity to use the owning faction for the check
---@return FactionTrust # Trust level, one of 'ENEMY', 'NEUTRAL' or 'ALLY' (will always be 'ALLY' when checking against self and nil when other faction doesn't exist)
---@overload fun(self, other_faction: FactionOrId): FactionTrust
function Faction:GetTrust(other_entity) end

---Reset any customized faction trust levels of this faction  
---Will make all factions bidirectionally revert to default trust level in regards to this faction
function Faction:ResetTrust() end

---Check if this faction is sharing visibility with anyone and with how many other factions visibility is shared with
---@return integer? # Number of factions visibility is shared with (or nil if not sharing visibility)
function Faction:GetSharedVisibilityCount() end

---Check if this faction is sharing visibility with another factions
---@param other_faction FactionOrId Other faction or faction id
---@return boolean # True if faction is sharing visibility with the other faction
function Faction:IsSharingVisibilityWith(other_faction) end

---Share visibility with another faction
---@param other_faction FactionOrId Other faction or faction id
function Faction:ShareVisibility(other_faction) end

---Unshare visibility with other factions
function Faction:UnshareVisibility() end

---------------------------------------------------------------------------------------------------------------
---An item slot object represents one slot of the inventory of an entity.  
--- - Custom operator 'tostring'  
--- - Custom operator 'equal'  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#itemslot)
---@class ItemSlot
---@field id ItemId? The item id in this slot
---@field def table? The definition table of the item in this slot
---@field stack integer The amount of items in this slot Modification is only possible for slots with an item in it. On modification, if the new amount is lower than `reserved_stack` or higher than `stack + unreserved_space` it will fail with an error. If the new amount is zero, the item will be cleared from the slot and the stack can't be modified again until the item is put in again.
---@field max_stack integer Get the maximum stack count of the item in this slot
---@field reserved_stack integer The amount of reserved items for ingredients or outgoing orders
---@field unreserved_stack integer The amount of items not reserved for ingredients or outgoing orders
---@field reserved_space integer The amount of free space reserved for generation or incoming orders
---@field unreserved_space integer The amount of free space actually available to be filled (slot must have an item in it)
---@field has_order boolean Check if there exists any order related to this slot
---@field owner Entity The entity that owns this slot
---@field exists boolean Check if this item slot and its owning entity still exists or if it was unequipped or destroyed
---@field entity Entity The entity docked in this slot It can only be set to a valid entity if there is nothing in it currently. To undock an already docked entity onto the map use `entity:Undock()`. To remove a docked entity without placing it onto the map set entity to nil.
---@field reserved_entity Entity An entity that has been undocked but is reserved to come back (usually tethered entity)
---@field component Component? The component that holds this slot
---@field type string The type of slot
---@field has_extra_data boolean Check if extra_data has been created for this item slot
---@field extra_data table Access to the extra data table of the item in this slot Extra data can only be set for unstackable items Reading it will always return a valid table when (will be created if not set yet) Writing nil to it will free the table from memory
---@field locked boolean Is this item slot locked from changing item def?
ItemSlot = {}

---Sets the content of an empty slot
---@param item_id string Item id
---@param amount integer Amount
---@param extra_data any_table? Extra data table (OPTIONAL, default nil)
---@overload fun(self, item_id: string, amount: integer)
function ItemSlot:SetItemAndStack(item_id, amount, extra_data) end

---Add amounts in this slot (must have an item in it).  
---If the new amount is higher than `stack + unreserved_space` it will fail with an error.
---@param amount integer Amount to be added
---@param count_history boolean? Set to true to count this stack modification as item generation in the history graph (OPTIONAL, default false)
---@overload fun(self, amount: integer)
function ItemSlot:AddStack(amount, count_history) end

---Add or remove amounts in this slot (must have an item in it).  
---If the new amount is lower than `reserved_stack` it will fail with an error.  
---If the new amount is zero, the item will be cleared from the slot  
---and the stack can't be modified again until the item is put in again.  
---This cannot be used to remove stack of something with extra_data (use Clear)
---@param amount integer Amount to be removed
---@param count_history boolean? Set to true to count this stack modification as item consumption in the history graph (OPTIONAL, default false)
---@overload fun(self, amount: integer)
function ItemSlot:RemoveStack(amount, count_history) end

---Clear the content in this slot
---@return table # The extra_data table before the slot was cleared
function ItemSlot:Clear() end

---Sets the item and locks an otherwise empty slot
---@param item_id string? Item id (or nil to change a locked slot to empty)
---@return boolean # True if the locked item was set (False if slot contains something else already)
---@overload fun(self): boolean
function ItemSlot:SetLockedItem(item_id) end

---Swap the entire contents (including reservations) of two slots of the same slot type on the same inventory
---@param other_slot ItemSlot Other item slot (must be of the same slot type and on the same inventory)
function ItemSlot:Swap(other_slot) end

---Move as much as possible (including reservations) into another slot on the same inventory
---@param target_slot ItemSlot Target item slot (must be on the same inventory and be empty or have the same item)
---@param limit_amount integer? Limit amount to be moved (OPTIONAL, default everything)
---@return boolean # True if any items or reservations have been moved
---@overload fun(self, target_slot: ItemSlot): boolean
function ItemSlot:Move(target_slot, limit_amount) end

---Gets all the reserve information relative to this slot
---@return table[] # A set of tables of each reserve info related to this slot
function ItemSlot:GetReserveInfo() end

---Cancel all orders related to this item slot
function ItemSlot:CancelOrders() end

---Order an item into this slot  
---The order will stay active until fulfilled, CancelOrder gets called, the slot is removed or the entity is destroyed.  
---Additionally if a component is specified, the order gets canceled when the component becomes inactive or when `component:CancelProcess` is called.  
---If an order already exists on the same item slot and no source slot is specified, it will be modified to the new amount requested.  
---If modifying an order and amount is less than already ordered (or 0), existing order(s) will get adjusted to the new amount (or aborted).  
---Will return nil on invalid item or amount or if not enough free space available in the slot.
---@param item_id string Item id to be ordered
---@param amount integer Amount to be ordered
---@param priority string? Priority "None", "HighPriority", "ManualOrder" (OPTIONAL, default "None")
---@param channel_bitmask integer? If set and not 0, make the order on the channels denoted by the set bits (OPTIONAL)
---@param source_slot ItemSlot? Make a fixed order from this slot (must be different entity, must have amount available) (OPTIONAL)
---@param component Component? Component through which the items will be ordered (must be on same entity as this slot, also see `component:OrderItem`) (OPTIONAL)
---@return integer # Order ID created or modified
---@overload fun(self, item_id: string, amount: integer): integer
---@overload fun(self, item_id: string, amount: integer, priority: string): integer
---@overload fun(self, item_id: string, amount: integer, channel_bitmask: integer?): integer
---@overload fun(self, item_id: string, amount: integer, source_slot: ItemSlot?): integer
---@overload fun(self, item_id: string, amount: integer, component: Component?): integer
---@overload fun(self, item_id: string, amount: integer, priority: string, channel_bitmask: integer?): integer
---@overload fun(self, item_id: string, amount: integer, priority: string, source_slot: ItemSlot?): integer
---@overload fun(self, item_id: string, amount: integer, priority: string, component: Component?): integer
---@overload fun(self, item_id: string, amount: integer, channel_bitmask: integer?, source_slot: ItemSlot?): integer
---@overload fun(self, item_id: string, amount: integer, channel_bitmask: integer?, component: Component?): integer
---@overload fun(self, item_id: string, amount: integer, source_slot: ItemSlot?, component: Component?): integer
---@overload fun(self, item_id: string, amount: integer, priority: string, channel_bitmask: integer?, source_slot: ItemSlot?): integer
---@overload fun(self, item_id: string, amount: integer, priority: string, channel_bitmask: integer?, component: Component?): integer
---@overload fun(self, item_id: string, amount: integer, priority: string, source_slot: ItemSlot?, component: Component?): integer
---@overload fun(self, item_id: string, amount: integer, channel_bitmask: integer?, source_slot: ItemSlot?, component: Component?): integer
function ItemSlot:OrderItem(item_id, amount, priority, channel_bitmask, source_slot, component) end

---The amount of free space actually available to be filled with a specific item (slot can be empty)
---@param item_id ItemId Item id
---@return integer # Unreserved free space count
function ItemSlot:GetUnreservedSpaceFor(item_id) end

---Get how many items a component with a prepared process is generating into this slot
---@param component Component? Component which is generating item(s) (or nil to count all)
---@return integer # How many items the component is generating into this item slot (0 if not generating into this slot)
---@overload fun(self): integer
function ItemSlot:CountGenerateAmount(component) end

---Get how many items a component with a prepared process is consuming from this slot
---@param component Component? Component which is consuming item(s) (or nil to count all)
---@return integer # How many items the component is consuming from this item slot (0 if not consuming from this slot)
---@overload fun(self): integer
function ItemSlot:CountConsumeAmount(component) end

---------------------------------------------------------------------------------------------------------------
---A mod package object represents a loaded mod package currently active in the game.  
---  
---Startup sequence (each step is performed on all active mod packages in dependency order where packages with no dependencies are called first):  
---  
---1. Run the entry lua file of all active mod packages    
---2. When starting a new game, run the function package:setup_scenario(settings). This function can modify the settings table. This step is skipped when loading a save or joining a multiplayer game.    
---3. Load all files set in package:includes and call either package:init_ui() or package:init(). The function init_ui is not called when there is no local player (i.e. on a dedicated servre). Packages with init_ui are allowed to write to local variables defined outside of the function scope.    
---4. Call package:post_init()    
---5. When starting a new game, run the function package:on_world_spawn()    
---6. For the local player or any newly joining multiplayer players, run the function package:get_new_player_faction_id(faction_id) which can return a faction id to be used for that player (only called on server!). The passed faction_id will be nil on the first package this is called on.    
---7. When a new player faction is spawned or respawned, run the function package:on_player_faction_spawn(faction, is_respawn, player_faction_num)  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#modpackage)
---@class ModPackage
---@field id string Get the package id
---@field name string Get the package name
---@field description string Get the package description
---@field entry string Get the package entry file
---@field type string Get the package type
---@field dependencies string[] Get the dependencies list
---@field modes string[] Get the multiplayer game modes list
---@field mod_id string Get the mod id
---@field mod_name string Get the mod name
---@field mod_version_name string Get the mod version name
---@field mod_version_code string Get the mod version code
---@field mod_author string Get the mod author
---@field mod_homepage string Get the mod homepage
---@field mod_description string Get the mod description
---@field includes string[] Load a lua file or all lua files in a sub directory of this mod
ModPackage = {}

---------------------------------------------------------------------------------------------------------------
---A register object represents the content of a register of an entity.    
---Unlike many other objects, it is not a reference to a game object but a copy.    
---Therefore after modification, the value needs to be written back with SetRegister.  
--- - Custom operator 'tostring'  
--- - Custom operator 'equal'  
--- - Custom operator 'add': Add two register values. While the left side of the operator always needs to be a register object, the right side can be a register, a table or an integer number. If either side (or both) have a 2-dimensional coordinate, the result will also be a coordinate, otherwise it will be a number.  
--- - Custom operator 'sub': Subtract two register values. While the left side of the operator always needs to be a register object, the right side can be a register, a table or an integer number. If either side (or both) have a 2-dimensional coordinate, the result will also be a coordinate, otherwise it will be a number.  
--- - Custom operator 'mul': Multiply two register values. While the left side of the operator always needs to be a register object, the right side can be a register, a table or an integer number. If either side (or both) have a 2-dimensional coordinate, the result will also be a coordinate, otherwise it will be a number.  
--- - Custom operator 'idiv': Integer division of two register values. While the left side of the operator always needs to be a register object, the right side can be a register, a table or an integer number. If either side (or both) have a 2-dimensional coordinate, the result will also be a coordinate, otherwise it will be a number.  
--- - Custom operator 'mod': Modulo of two register values. While the left side of the operator always needs to be a register object, the right side can be a register, a table or an integer number. If either side (or both) have a 2-dimensional coordinate, the result will also be a coordinate, otherwise it will be a number.  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#register)
---@class Register
---@field num integer The number stored in this register
---@field id AnyId? The generic id stored in this register
---@field def table? The definition table of the id stored in this register
---@field value_id ValueId? The id stored in this register if it is referring to a value definition. Can be a key from data.values, data.items, data.frames or data.components.
---@field item_id ItemId? The id stored in this register if it is referring to an item definition. Can be a key from data.items, data.frames or data.components.
---@field frame_id FrameId? The id stored in this register if it is referring to a frame definition. If this doesn't return nil, it will be a key from data.frames.
---@field component_id ComponentId? The id stored in this register if it is referring to a component definition. If this doesn't return nil, it will be a key from data.components.
---@field tech_id TechId? The id stored in this register if it is referring to a tech definition. If this doesn't return nil, it will be a key from data.techs.
---@field entity Entity? The entity stored in this register This will return nil if there is a destroyed entity referenced in this register.
---@field coord Point? The coordinate stored in this register or nil if no coordinate is stored
---@field coord_x integer? The X coordinate stored in this register or nil if no coordinate is stored
---@field coord_y integer? The Y coordinate stored in this register or nil if no coordinate is stored
---@field raw_entity Entity? The raw entity value stored in this register This will return the value as is stored, even if there is a destroyed entity referenced in this register.
---@field is_link boolean Check if a register is linked from another register
---@field is_empty boolean Check if a register is empty (or contains a reference to a destroyed entity while having number set to 0)
---@field raw_is_empty boolean Check if a register is fully empty (true even if entity references a destroyed entity)
---@field is_error boolean Check if a register is in error state
Register = {}

---Clear contents
function Register:Clear() end

---Copy contents from another register or table
---@param new_value Register|any_table New register object or table
function Register:Init(new_value) end

---------------------------------------------------------------------------------------------------------------
---A widget object represents a UI object that is part of a layout tree.  
--- - Custom operator 'index': Read properties of this widget  
--- - Custom operator 'newindex': Modify or add new properties of this widget  
--- - Custom operator 'tostring'  
--- - Custom operator 'length': Get number of child widgets (same as child_count)  
--- - Custom operator 'equal'  
---[Official Documentation](https://modding.desyncedgame.com/syntax.html#widget)
---@class Widget
---@field parent Widget Get the parent of a widget
---@field root Widget Get the root (top-most parent) of a widget
---@field children Widget[] Get or set an array of child widgets
---@field child_count integer Get number of child widgets Cannot be set to a number larger than already exists
---@field has_children boolean Check if child widgets exist
---@field child_index integer Get or set the child index of this widget in relation to its parent
---@field next_sibling Widget Get the next sibling in the list of child widgets of the parent
---@field previous_sibling Widget Get the previous sibling in the list of child widgets of the parent
---@field class table Get the table passed to `UI.Register`
---@field [string] any Widget properties
Widget = {}

---Check if widget has not been removed yet
---@return boolean # Valid state
function Widget:IsValid() end

---Check if widget is visible on screen (self and no parent is hidden)
---@return boolean # Visible state
function Widget:IsVisible() end

---Add a widget to a panel widget
---@param widget Widget The widget to add
---@return Widget # The added widget
function Widget:Add(widget) end

---Add a widget to a panel widget
---@param layout string Layout text for creating a new widget inline
---@param properties any_table? Property table for the inline widget (OPTIONAL)
---@return Widget # The added widget
---@overload fun(self, layout: string): Widget
---@overload fun(self, widget: Widget): Widget
function Widget:Add(layout, properties) end

---Set the content of a single-child panel widget
---@param widget Widget The widget to set
---@return Widget # The set widget
function Widget:SetContent(widget) end

---Set the content of a single-child panel widget
---@param layout string Layout text for creating a new widget inline
---@param properties any_table? Property table for the inline widget (OPTIONAL)
---@return Widget # The set widget
---@overload fun(self, layout: string): Widget
---@overload fun(self, widget: Widget): Widget
function Widget:SetContent(layout, properties) end

---Clear all widgets in a panel widget
function Widget:Clear() end

---Get a child widget
---@param child_number integer? Which child to get (OPTIONAL, default 1)
---@return Widget # Child widget
---@overload fun(self): Widget
function Widget:GetChild(child_number) end

---Sort all child widgets
---@param predicate function Sort predicate callback (will be called with two widgets to compare)
function Widget:SortChildren(predicate) end

---Remove a widget from its parent
function Widget:RemoveFromParent() end

---Invoke an event function  
---Similar to calling the function directly but will correctly pass the parent as self if invoking a function higher up the layout tree.
---@param property_name string Function property name
---@param ... any? Passed values (OPTIONAL, can pass multiple values)
---@return any # Return values of call
---@overload fun(self, property_name: string): any
function Widget:SendEvent(property_name, ...) end

---Get the desired size of a widget
---@return number # Width
---@return number # Height
function Widget:GetDesiredSize() end

---Set the position of a widget placed a canvas panel widget
---@param position_x number X position
---@param position_y number Y position
---@param z_order number? Z order, widgets with higher values are drawn on top (OPTIONAL)
---@overload fun(self, position_x: number, position_y: number)
function Widget:SetPosition(position_x, position_y, z_order) end

---Gets the viewport relative position (and size) of the widget  
---If a widget gets passed that hasn't had its layout calculated yet, the function will return nil
---@param related_widget Widget? Widget to get relative position to (OPTIONAL)
---@return number # X position
---@return number # Y position
---@return number # X size
---@return number # Y size
---@overload fun(self): number, number, number, number
function Widget:GetViewportPosition(related_widget) end

---Set this widget (and any children) to not interact with the mouse cursor (clicking or dragging over)
---@param ignore_hit_test boolean? Ignore hit test  (OPTIONAL)
---@overload fun(self)
function Widget:SetIgnoreHitTest(ignore_hit_test) end

---Animate a numerical property
---@param param_name string Parameter name
---@param target_value number Target value
---@param duration number? Duration in milliseconds (OPTIONAL, default 400)
---@param wait number? Wait time in milliseconds (OPTIONAL, default 0)
---@param easing_name string? Easing function name (OPTIONAL, default "InOutQuad")
---@param on_finish function? Animation finished callback (OPTIONAL)
---@overload fun(self, param_name: string, target_value: number)
---@overload fun(self, param_name: string, target_value: number, duration: number)
---@overload fun(self, param_name: string, target_value: number, easing_name: string?)
---@overload fun(self, param_name: string, target_value: number, on_finish: function?)
---@overload fun(self, param_name: string, target_value: number, duration: number, wait: number?)
---@overload fun(self, param_name: string, target_value: number, duration: number, easing_name: string?)
---@overload fun(self, param_name: string, target_value: number, duration: number, on_finish: function?)
---@overload fun(self, param_name: string, target_value: number, easing_name: string?, on_finish: function?)
---@overload fun(self, param_name: string, target_value: number, duration: number, wait: number?, easing_name: string?)
---@overload fun(self, param_name: string, target_value: number, duration: number, wait: number?, on_finish: function?)
---@overload fun(self, param_name: string, target_value: number, duration: number, easing_name: string?, on_finish: function?)
function Widget:TweenTo(param_name, target_value, duration, wait, easing_name, on_finish) end

---Animate a numerical property
---@param param_name string Parameter name
---@param start_value number Start value
---@param target_value number Target value
---@param duration number? Duration in milliseconds (OPTIONAL, default 400)
---@param wait number? Wait time in milliseconds (OPTIONAL, default 0)
---@param easing_name string? Easing function name (OPTIONAL, default "InOutQuad")
---@param on_finish function? Animation finished callback (OPTIONAL)
---@overload fun(self, param_name: string, start_value: number, target_value: number)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number)
---@overload fun(self, param_name: string, start_value: number, target_value: number, easing_name: string?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, on_finish: function?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number, wait: number?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number, easing_name: string?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number, on_finish: function?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, easing_name: string?, on_finish: function?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number, wait: number?, easing_name: string?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number, wait: number?, on_finish: function?)
---@overload fun(self, param_name: string, start_value: number, target_value: number, duration: number, easing_name: string?, on_finish: function?)
function Widget:TweenFromTo(param_name, start_value, target_value, duration, wait, easing_name, on_finish) end

---Stop an active tween
---@param param_name string Parameter name
---@return boolean # True if a tween existed and was stopped
function Widget:StopTween(param_name) end

---Get the target value of an active tween
---@param param_name string Parameter name
---@return number # Target value (or nil if not active tween)
function Widget:GetTweenTarget(param_name) end

---Find property in any widget above in the layout tree
---@param param_name string Parameter name
---@return any # Parameter value if found
function Widget:FindAbove(param_name) end
