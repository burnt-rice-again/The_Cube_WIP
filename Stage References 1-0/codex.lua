--[=[

data.codex.x_samplecodex = {
	category = "<CATEGORY>",
	title = "<TITLE>",
	text = [[ --multiline string
<DESCRIPTION>
<DESCRIPTION>
...
]],
}

]=]

---------------------------------
-----------  GOALS  -------------
---------------------------------

--------------------------------------
-- BLIGHT GOALS:  Index 26+
--------------------------------------

-- GOAL: RESEARCH BLIGHT --
data.codex.x_goal_researchblight = {
	category = "Goals", index = 2, title = "Research Blight",
	details = "Extract and Research Blight Gas",
	--goalicon = "Main/textures/icons/items/blight_extraction.png",

	text = [[
<img id="blight_extraction" width="64" height="64"/><codex_title>Research Blight</>

<hl>Extract and Research Blight Gas</>

Position your units equipped with a <img id="c_blight_extractor" style="hl"/> component into the area of blight so that they may extract <img id="blight_extraction" style="hl"/>.

<img image="Main/textures/codex/botshots/in_blight.png" width="400" height="200"/>


<hl>Blight Gas Containment</>

Blight gas cannot be held in normal inventory slots. Extractors have a special chamber for containing the gas.

<img image="Main/textures/codex/inventory/blight_inventory.png" width="300" height="100"/>

In addition there are components specifically designed to contain blight gas.

<img id="c_blight_container_i" width="64" height="64"/><img id="c_blight_container_s" width="64" height="64"/><img id="c_blight_container_m" width="64" height="64"/>]],
	talkinghead = "A <hl>blight</> seems to be corrupting the planet. Electrical interference prevents entry. We would need to research it more if we wanted to enter...",
}

-----------  VIRUS GOALS  -------------

-- GOAL: RESEARCH VIRUS --
data.codex.x_goal_researchvirus = {
	category = "Goals", index = 3, title = "Virus Protection",
	details = "You have been infected with a virus\nand must make yourself some protection",
	--goalicon = "Main/textures/icons/components/virus_cure.png",

	talkinghead = [[
You have contracted what seems to be a proximity based self-replicating virus. Effects are unknown but I have manufactured a component that gives you temporary protection from the virus.

You can produce the component in the assembler. In the meantime keep the infected unit away from other units to avoid more infections.]],

	text = [[
<img id="c_virus_cure" width="64" height="64"/><codex_title>Virus Protection</>

<bl>Manufacture a component giving protection from the virus.</>

<img image="Main/textures/codex/ui/line_h1.png"/>

Units infected with the virus should stay clear of other units so as not to infect them. The virus has unknown effects that can be harmful so building protection should be high priority.

<img image="Main/textures/codex/botshots/virus_infection.png"/>

<img image="Main/textures/codex/ui/line_h1.png"/>

<hl>Virus Protection Recipe</>

<img image="Main/textures/codex/items/virus_protection.png"/>

You should now have a recipe in your Assembler for simple protection from the virus however researching the Virus may lead to new technology.]],
}

data.codex.x_tc_behaviors = {
	category = "How to Play", index = 16, title = "Behavior Controllers", behavior_related = true,

	text = [[
<img width="50" height="50" id="c_behavior" style="header"/>

<img image="Main/textures/codex/ui/line_h1.png"/>

These components are an <bl>option</> when playing Desynced.

Bases can operate normally and efficiently <bl>without</> the use of behavior controllers.

Though they are not required to play Desynced, using them can open up the level of control a player can have over their units and their bases.

For new players it is recommended to start by using the <bl>native logistics system</> to run their base and later add in <hl>Behavior Controllers</> components as they learn more about how the game's mechanics work.

Behaviors can sometimes conflict with the logistics network so it is recommended to take units off the logistics network unless you are familiar with how the systems interact.

Robot units have the ability to add an integrated behavior controller which can be added via the unit menu.]],
}


data.codex.x_behaviors = {
	category = "Codex", index = 20, title = "Behaviors", behavior_related = true,

	text = [[<img width="50" height="50" id="c_behavior" style="header"/>

<img image="Main/textures/codex/ui/line_h1.png"/>

<img image="Main/textures/codex/auto3_behavior/modify_behavior.png"/>

Click on the modify behavior button to open the behavior editor screen.


<img image="Main/textures/codex/ui/line_h1.png"/>


<img image="Main/textures/codex/auto3_behavior/01_prog_start.png"/>

When the behavior editor opens, <hl>Program Start</> will be the beginning point for your behavior.

<img image="Main/textures/codex/ui/line_h1.png"/>


<img image="Main/textures/codex/auto3_behavior/02_pick_up.png"/>

Start by dragging the <hl>Pick Up Items</> instruction over to Program Start to connect it.

<img image="Main/textures/codex/ui/line_h1.png"/>


<img image="Main/textures/codex/auto3_behavior/03_add_param.png"/>


Next, click on the <bl>[ + ]</> sign at the top of the behavior editor to add a <bl>Register [ P 1 ]</>

<img image="Main/textures/codex/ui/line_h1.png"/>


<img image="Main/textures/codex/auto3_behavior/04_drag_param.png"/>

Drag the new Register <bl>[ P1 ]</> to the <hl>Source</> for Pick Up Items

<img image="Main/textures/codex/ui/line_h1.png"/>


<img image="Main/textures/codex/auto3_behavior/05_param_icon.png"/>

Now whatever the P1 Register is set to will be the input for the instructions Source.

<img image="Main/textures/codex/ui/line_h1.png"/>


<img image="Main/textures/codex/auto3_behavior/06_drop_off.png"/>

Repeat the same process for the Drop off instruction.

<img image="Main/textures/codex/ui/line_h1.png"/>



<img image="Main/textures/codex/auto3_behavior/07_param2.png"/>

Add Register 2 [ P2 ] and drag it to the Source for the Drop off instruction.

<img image="Main/textures/codex/ui/line_h1.png"/>



<img image="Main/textures/codex/auto3_behavior/08_rename.png"/>

Rename your behavior to something like 'Transfer Behavior' and add a description if you would like.


<img image="Main/textures/codex/auto3_behavior/confirm.png"/>

Click the confirm button to return to the main screen.


<img image="Main/textures/codex/auto3_behavior/09_parameters.png"/>

Registers [ P1 ] and [ P2 ] that you created can now be set.


<img image="Main/textures/codex/auto3_behavior/10_set_parameters.png"/>

Set [ P1 ] to the building you want items picked up from and [ P2 ] to the building where you want them to be dropped off at.


<img image="Main/textures/codex/auto3_behavior/start_behavior.png"/>

Click the Run button to start the behavior.]],
}

data.codex.x_tutorial = {
	category = "Codex", index = 25, title = "Tutorials",
	special_tutorials = true,
}

----------------------------------------------------------------
----------------- @@INTRODUCTION - TUTORIAL CODEX TC01 START
----------------------------------------------------------------

data.codex.x_tc_introduction = {
	category = "How to Play", index = 2, title = "Introduction",

	sections = {
		{
			title = "Landing Team",
			text = [[
You are <hl>landing</> with a Team of <hl>advanced units</>.

		<img id="f_bot_2m_as" width="32" height="32"/> <hl>Command Center</> - deployable to a Command Building
		<img id="f_bot_1s_as" width="32" height="32"/> <hl>Scout Bot</> - fast reconnaissance bot
		<img id="f_bot_1s_adw" width="32" height="32"/> <hl>2x Engineer Bots</> - high efficiency bot
		<img id="f_spacedrop" width="32" height="32"/> <hl>Drop Pod</> - contains additional landing items]]
		},
		{
			title = "Landing Components",
			text = [[
You are <hl>landing</> with:

		<img id="c_adv_portable_turret" width="32" height="32"/> <hl>Advanced Portable Laser</> - advanced version of a portable turret
		<img id="c_adv_miner" width="32" height="32"/> <hl>2x Laser Mining Tools</> - advanced version of a mining component
		<img id="c_fabricator" width="32" height="32"/> <hl>2x Fabricators</> - basic production component
		<img id="c_power_cell" width="32" height="32"/> <hl>Power Cell</> - power source with power field
		<img id="c_scout_radar" width="32" height="32"/> <hl>Scout Radar</> - radar with a single filter
		<img id="c_deployer" width="32" height="32"/> <hl>Deployer</> - contains Metal Bar Production Building]]
		},
	},

	text = [[<codex_title>Introduction</>

<bl>You are landing on an unknown world with a small team deployed from your Mothership where you control them from. This team is composed of</> <hl>advanced units</> <bl>which cannot be produced from the basic resources you initially discover, so protect them well.</>

<img image="Main/textures/codex/new/INTRODUCTION_landing_00.png"/>]],
}

--------------------------------------------------
------------------- @@CONTROLS
--------------------------------------------------

-- CAMERA MOVEMENT
-- In addition to using WASD to move the camera you can Right Click and Screen Drag.
-- [Image showing mouse camera control]
-- Toggle Camera Rotation:  <Key action="MouseCameraRotateToggle" style="bl"/>
-- Set Camera Zero:  <Key action="CameraZero" style="bl"/>

data.codex.x_tc_controls = {
	category = "How to Play", index = 1, title = "Controls",

	text = [[<codex_title>Controls</>

<hl>Key bindings</> <bl>can be changed via the</> <hl>options</> <bl>menu.</>

<img image="Main/textures/codex/new/0-CONTROLS.png"/>]],

	sections = {
		{
			title = "Camera Control",
			text = [[
Pan the Camera: <Key axis="CameraX" style="bl"/><bl>/</><Key axis="CameraY" style="bl"/> or <Key action="ExecuteAction" style="hl"/> <gray>(Screen edge will scroll, settings in Options)</>
Zoom the Camera: <Key axis="CameraZoom" style="bl"/>
Rotate the Camera: <Key action="RotateAction" style="hl"/>]]
		},
		{
			title = "Mouse Cursor",
			text = [[
When placing a Building, the construction wireframe will appear in the mouse cursor. A grid will also appear which gives information to help with placement.
<img image="Main/textures/codex/new/0-mouse_cursor.png"/>]]
		},
		{
			title = "Hotkeys",
			text = [[
In Game Menu:  <Key action="InGameMenu" style="bl"/>
Pause:  <Key action="PauseGame" style="bl"/>
Map Overlay:  <Key action="MapOverlay" style="bl"/>
Chat:  <Key action="Chat" style="bl"/>
Accept:  <Key action="Accept" style="bl"/>
Hide User Interface:  <Key action="HideUserInterface" style="bl"/>
Ping:  <Key action="Ping" style="bl"/>]]
		},
		{
			title = "Camera",
			text = [[
Camera Zoom:  <Key axis="CameraZoom" style="bl"/>
Camera Home:  <Key action="CameraHome" style="bl"/>
Follow Camera:  <Key action="Camera_FollowTarget" style="bl"/>
Set Faction Home Unit:  <Key action="FactionHome" style="bl"/>
Reset Camera:  <Key action="CameraReset" style="bl"/>]],
		},
		{
			title = "Unit",
			text = [[
Select Unit:  <Key action="SelectAction" style="bl"/>
Move Unit:  <Key action="ExecuteAction" style="bl"/>
Quick Action:  <Key action="QuickAction" style="bl"/>
Force Attack/Attack Move:  <Key action="AttackMove" style="bl"/>
Hold Position:  <Key action="HoldPosition" style="bl"/>]]
		},
		{
			title = "Menu",
			text = [[
Tech Tree:  <Key action="Tech" style="bl"/>
Build Menu:  <Key action="Build" style="bl"/>
Progress:  <Key action="Progress" style="bl"/>
Codex:  <Key action="Codex" style="bl"/>
Library:  <Key action="Library" style="bl"/>
Control Center:  <Key action="FactionView" style="bl"/>
System Index:  <Key action="SystemIndex" style="bl"/>
Map:  <Key action="Map" style="bl"/>
Overlay Settings:  <Key action="OverlaySettings" style="bl"/>]]
		},
		{
			title = "Information",
			text = [[
Logistics Network:  <Key action="PowerInfo_Toggle" style="bl"/>
Toggle Path Lines:  <Key action="ShowPath" style="bl"/>
Visualization:  <Key action="MapOverlay" style="bl"/>]]
		},
		{
			title = "Copy / Paste",
			text = [[
Copy Settings:  <Key action="UnitCopy" style="bl"/>
Paste Settings:  <Key action="UnitPaste" style="bl"/>]]
		},
		{
			title = "Construction",
			text = [[
Build Menu:  <Key action="Build" style="bl"/>
Cursor:  <Key action="CursorGrid_Toggle" style="bl"/>
Rotate Component:  <Key action="RotateConstructionSite" style="bl"/>  <gray>(Mouse over component icon)</>
Rotate Building/Site:  <Key action="RotateConstructionSite" style="bl"/>  <gray>(Mouse over Building/Site)</>]]
		},
		{
			title = "Control Groups",
			text = [[
Select Previous:  <Key action="SelectPrevious" style="bl"/>
Group 1:  <Key action="Select1" style="bl"/>
Group 2:  <Key action="Select2" style="bl"/>
Group 3:  <Key action="Select3" style="bl"/>
Group 4:  <Key action="Select4" style="bl"/>
Group 5:  <Key action="Select5" style="bl"/>
Group 6:  <Key action="Select6" style="bl"/>
Group 7:  <Key action="Select7" style="bl"/>
Group 8:  <Key action="Select8" style="bl"/>
Group 9:  <Key action="Select9" style="bl"/>
Group 10:  <Key action="Select0" style="bl"/>]]
		}
	},
}

--------------------------------------------------
---------------- @@GAME SCREEN
--------------------------------------------------
data.codex.x_tc_user_interface = {
	category = "How to Play", index = 3, title = "Game Screen",

	sections = {
		{
			title = "Map",
			text = [[
<hl>Minimap</>
<img image="Main/textures/codex/new/GAMESCREEN_mini-map.png"/>

<name_list>Reset Camera</> <img image="icon_small_navigation" color="ui_light" width="32" height="32"/>
Resets the camera zoom and rotation and focuses on your home unit.

<name_list>Overlay Settings</> <img image="icon_small_visual" color="ui_light" width="32" height="32"/> (<Key action="OverlaySettings" style="hl"/>)
Brings up a list of overlay visualization options.

<name_list>Follow Camera</> <img image="icon_small_camera" color="ui_light" width="32" height="32"/> (<Key action="Camera_FollowTarget" style="hl"/>)
Toggles the camera to follow the selection. Dragging the camera manually will also stop following the unit.

<name_list>Toggle Full Screen Map</> <img image="icon_remote" color="ui_light" width="32" height="32"/> (<Key action="Map" style="hl"/>)
Opens the full screen map for wider visibility.

<name_list>Zoom In/Out</> <img image="icon_small_zoom_in" color="ui_light" width="32" height="32"/> <img image="icon_small_zoom_out" color="ui_light" width="32" height="32"/>
Zoom in/out on the minimap. Also available by using the <hl>Mouse Wheel</> while hovering over the minimap.

<name_list>Edit Pins</> <img image="icon_small_edit" color="ui_light" width="32" height="32"/>
Allows you to select an icon to be pinned onto the map or to delete existing pins.

<name_list>Mini-map Follow Camera</> <img image="icon_small_stick_to" color="ui_light" width="32" height="32"/>
Toggles whether the mini-map will follow the player camera or stay focused on a specific location.]]
		},
		{
			title = "Menu Bar",
			text = [[
<name_list>Research</> <img image="icon50_Tech" color="ui_light" width="32" height="32"/> (<Key action="Tech" style="hl"/>)
Opens the technology tree window.

<name_list>Build</> <img image="icon50_Build" color="ui_light" width="32" height="32"/> (<Key action="Build" style="hl"/>)
Opens a selection of buildings or blueprints to construct.

<name_list>Progress</> <img image="icon50_Progress" color="ui_light" width="32" height="32"/> (<Key action="Progress" style="hl"/>)
Shows progress of <hl>missions</> and <hl>milestones</>.

<name_list>Codex</> <img image="icon50_Codex" color="ui_light" width="32" height="32"/> (<Key action="Codex" style="hl"/>)
Opens the codex which contains information, missions and story dialogue.

<name_list>Library</> <img image="icon50_Library" color="ui_light" width="32" height="32"/> (<Key action="Library" style="hl"/>)
Allows you to manage <hl>blueprints</> and <hl>behaviors</>.

<name_list>Control Center</> <img image="icon50_Faction" color="ui_light" width="32" height="32"/> (<Key action="FactionView" style="hl"/>)
Shows a breakdown of information related to your faction.]]
		},
		{
			title = "Control Center Tabs",
			text = [[
<name_list>Power</>
A summary of your faction's power, including total battery, production and consumption, and a breakdown of unit, building and component power usage.

<name_list>Units</>
A filterable list of all units and buildings.

<name_list>Items</>
Item statistics for all available or visible items that allows jumping directly to units that hold or produce that item.

<name_list>Orders</>
A list of all orders sorted by time to help discover problems with your logistics network.

<name_list>Faction</>
Various faction settings such as name and color, faction registers, coalition and trust to other factions.]]
		},
	},

	text = [[<codex_title>Game Screen</>

<img image="Main/textures/codex/new/0-GAMESCREEN.png"/>]],
}
--------------------------------------------------
---------------- @@UNIT
--------------------------------------------------

data.codex.x_tc_unit = {
	category = "How to Play", index = 9, title = "Units",

	text = [[<codex_title>Units</>

<hl>Units</><bl> and </><hl>Buildings</><bl> share the same </><Link id="x_tc_the_interface" style="codex_s">Interface</><bl> and share the the same qualities except that</> <hl>Units</><bl> are moveable.</>

<img image="Main/textures/codex/new/UNITS_units_and_buildings_02.png"/>]],
	sections = {
		{
			-------------------------
			-- @@SELECTION
			-------------------------
			title = "Selection",
			text = [[
<hl>Units and buildings</> are selected by using <Key action="SelectAction" style="hl"/> directly. You can also <hl>drag select</> around multiple targets to select all of them.

<img image="Main/textures/codex/new/UNITS_selection_02.png"/><img image="Main/textures/codex/new/UNITS_selection_01.png"/>]]
		},
		{
			-------------------------
			-- @@UNIT ACTIONS
			-------------------------
			title = "Unit Actions",
			text = [[
<Key action="ExecuteAction" style="bl"/> is used for movement and to issue commands and instructions.

<name_list>Move</> - Move a <hl>unit</> with <Key action="ExecuteAction" style="hl"/>
<name_list>Mining</> - <Key action="ExecuteAction" style="hl"/> on a <hl>Node</> to mine

<img image="Main/textures/codex/new/UNITS_actions_01.png"/>

Holding Shift + <Key action="ExecuteAction" style="bl"/> queues up multiple commands
<Key action="ExecuteAction" style="bl"/> on a component to get a context menu]]
		},
	},
}

--------------------------------------------------
---------------- @@THE INTERFACE @@INTERFACE
--------------------------------------------------

data.codex.x_tc_the_interface = {
	category = "How to Play", index = 4, title = "Interface",

	text = [[<codex_title>Information</>

<Link id="x_tc_unit" style="codex_s">Units</><bl> and </><Link id="x_tc_buildings" style="codex_s">Buildings</> <bl>both use the same Interface</>

<img image="Main/textures/codex/new/UNITS_interface_01.png"/>]],


	sections = {
		{
			title = "Information Window",
			text = [[
<codex_s>Basic Information</>
<name_list>Name</>
This is the name that will appear when you hover over it in the world. Click in the box to <hl>Rename</> the unit.

<name_list>Health Bar</>
Indicates how much health the unit has remaining. click and hold to <hl>Deconstruct</> the unit.

<name_list>Battery</>
The bar indicates how much battery power the unit has remaining. If not enough power is available the unit will drop in effeciency which will slow down components. When now power is available components will stop working and the unit's movement will be slowed dramatically. The tooltip contains a breakdown of the units power details.

<codex_s>Logistics</>
<name_list>Power</> <img image="icon_power" color="ui_light" width="32" height="32"/>
Allows powering on/off of the unit. Some components such as Behavior Controllers can still function while powered off.

<name_list>Logistics</> <img image="icon_carry" color="ui_light" width="32" height="32"/>
<Key action="SelectAction" style="tl2"/> Connects/Disconnects the unit to the logistics network, allowing it to perform various task automatically. Behaviors are a way to give custom behavior to a unit so it is recommended to take it off the network to avoid conflicts.
<Key action="ExecuteAction" style="tl2"/> Customize logistics settings for this unit.

<name_list>Transport Route</> <img image="icon_transport" color="ui_light" width="32" height="32"/>
A specific type of logstics mode that picks up items from units specificed in the <hl>Goto</> register and drops off items at units in the <hl>Store</> register.
More information can be found on the <Link id="x_tc_logistics">Logistics</> page.]],
		},
		{
			title = "Options Menu",
			text = [[
<codex_s>Options Menu</> <img image="icon_menu" color="ui_light" width="32" height="32"/>
* The Options menu can also be accessed via <Key action="ExecuteAction" style="tl2"/> on a unit in the game world

<name_list>Edit</>
Allows you to modify the building settings including type and components. Options that require new items will turn into a construction site and become unavailable until the new items are delivered.

<name_list>Center Camera</>
Moves the camera as to center this unit on the screen

<name_list>Copy/Paste Unit Settings</>
Copies/pastes the logistics settings, register values, behaviors and locked slots of a unit

<name_list>Set Integrated Behavior</>
Adds an <hl>Integrated Behavior Controller</> for the unit. This is only available on Robot units and buildings.

<name_list>Deconstruct</>
Deconstructs the unit dropping 100% of its construction ingredients onto the ground.

<name_list>Relocate</>
Lets you relocate a buildings to a new location. Units are required to move the items from one location to the other. Initially only available for relocation inside the same <hl>logistics network</> you can later research technology that allows you to relocate and operate outside and across Networks.

More information on the <Link id="x_tc_buildings">Buildings</> page.]]
		},
		{
			---------------------
			-- @@INVENTORY
			---------------------
			title = "Inventory",
			text = [[
<img image="Main/textures/codex/new/UNITS_inventory_01.png"/>

<hl>Inventory</> space allows Units and Buildings to hold <hl>items</> and <hl>components</>.

<Key action="ExecuteAction" style="hl"/> on an item slot to get a context menu related to the current item or empty slot.
<hl>SHIFT+</><Key action="SelectAction" style="hl"/> will lock the slot to the current item type or as an empty slot.

<Key action="SelectAction" style="hl"/> allows you to move items by clicking or dragging the item between item slots or onto units in the game world to transfer them. If either of the units is unable to perform the transfer then an order will be created to transfer the item and a unit on the logistics network will be required to transfer it.

<img image="Main/textures/codex/new/UNITS_move_items_04.png"/>]]
		},
		{
			level = 2, title = "Item Slots",
			text = [[
<codex_s>Lock Slot</> - Locking item slots

<img image="Main/textures/codex/new/UNITS_lock_inventory_03.png"/>

You can <hl>lock slots</> by pressing <Key action="ExecuteAction"/> on an inventory slot and selecting <hl>Lock Slot to this Item</>. A Lock icon will appear on the slot to show that it is a Locked Inventory Slot. <hl>Empty slots</> can also be locked to prevent items being stored in them by pressing <Key action="ExecuteAction"/> an empty slot and choosing <hl>Lock Empty Slot.</>

Multiple inventory slots can be locked by <Key action="ExecuteAction"/> on the top left corner Icon of the inventory and choosing <hl>Lock All Slots</>.

Slots can be unlocked in the same manner by choosing the Unlock options.

<codex_s>Specific Amount</>

<img image="Main/textures/codex/menushots/specific_amount.png"/>   2)  <img image="Main/textures/codex/menushots/specific_amount2.png"/>   3)  <img image="Main/textures/codex/menushots/specific_amount3.png"/>

You can remove a <hl>specific amount</> from a stack by <Key action="ExecuteAction"/> on an inventory stack and Selecting Specific Amount. Input the amount you wish to take from the stack. Left click and drag from the icon.

You can drag and drop items to the ground as well.

<codex_s>Inventory Slot Types</>

<name_list>Storage</> <img image="icon_inventory" color="ui_light" width="32" height="32"/>
Hold most physical items or components.

<name_list>Garage</> <img image="icon_inv_garage" color="ui_light" width="32" height="32"/>
Allows you to hold generic units inside a building

<name_list>Drone</> <img image="icon_inv_drone" color="ui_light" width="32" height="32"/>
Holds small flying <hl>drone</> units and acts as a home for them to return to. Drones will only perform orders if they are docked.

<name_list>Drone</> <img image="icon_inv_drone" color="ui_light" width="32" height="32"/>
Holds <hl>Flyer</> units and acts as a home for them to return to.

<name_list>Gas</> <img image="icon_inv_gas" color="ui_light" width="32" height="32"/>
A container required to hold various types of gas.

<name_list>Virus</> <img image="icon_inv_virus" color="ui_light" width="32" height="32"/>
A specialized storage facility specialized in containing virus related items.

<name_list>Anomaly</> <img image="icon_inv_anomaly" color="ui_light" width="32" height="32"/>
Holds anomaly related items.]]
		},
		{
			level = 2, title = "Storage",
			text = [[
<hl>Storage</> <bl>units will provide a place for units to store items when needed.</>

<img image="Main/textures/codex/codex_storage.png" width="500" height="200"/>

When a component is unable to output an item (e.g. a Miner or Fabricator component) because the building it is in is full, it will stop producing until space is made.

When a storage building however has a <img width="50" height="50" id="c_shared_storage" style="hl"/> component, it becomes a place of storage where excess items can be stored when buildings or units become full.

Some storage <bl>components</> can be slotted to provide extra storage slots however all slots on that unit will become available storage.]],
		},
		{
			---------------------
			-- @@SOCKETS
			---------------------
			title = "Sockets and Components",
			text = [[
<img image="Main/textures/codex/new/UNITS_sockets_components_01.png"/>

Sockets accept <hl>internal</>, <hl>small</>, <hl>medium</>, or <hl>large</> components (fit same size or larger).

Equipping components grants capabilities (mining, production, logistics).
Buildings auto-equip delivered components if compatible.]]
		},
		{
			---------------------
			-- @@BASE REGISTERS
			---------------------
			title = "Base Registers",
			text = [[
<img image="Main/textures/codex/new/UNITS_frame_registers_01.png"/>

The four general purpose <hl>registers</> are: <hl>Signal, Visual, Store, Goto</>.

<name_list>Signal</> <img image="icon_signal" color="ui_light" width="32" height="32"/>
Can broadcast values to other units. The value can be read with a <img id="c_signal_reader" width="32" height="32" style="hl"/> or a <img id="c_behavior" width="32" height="32" style="hl"/>.

<name_list>Visual</> <img image="icon_vision" color="ui_light" width="32" height="32"/>
Provides an in-world label. Production registers default to linking their production register to the Visual register if it is not already set.

<name_list>Store</> <img image="icon_home" color="ui_light" width="32" height="32"/>
Allows you to specify one or more storage locations. Can be set directly with Set with <hl>Ctrl+</><Key action="ExecuteAction"/> on a target.

<name_list>Goto</> <img image="icon_context" color="ui_light" width="32" height="32"/>
Focuses a unit on an task or onto a target in the world. Can be set by clicking with <Key action="ExecuteAction"/>.

<hl>Registers</> can be cleared with <Key action="ExecuteAction"/> on the icon. You can create a link between registers to automatically transfer their value by dragging from one register to another. Perform the same linking again to remove it. Register values can be copied by holding <hl>Ctrl</> while dragging with the mouse. Dragging a register onto an item slot will attempt to lock that item slot to the dragged item value. You can also use the standard <hl>Copy/Paste</> keys to copy values between registers.

<Link id="x_tc_registers" style="codex_s">More on Registers</>]],
		},
		{
			---------------------
			-- @@CONDITION INDICATORS
			---------------------
			title = "Condition Indicators",
			text = [[
<name_list>Idle</> <img image="Main/textures/icons/states/idle.png" width="32" height="32"/>
Units will have this state set if they are not utilized for a period of time.

<name_list>Powered Off</> <img image="Main/textures/icons/states/powereddown.png" width="32" height="32"/>
Units specifically Turned off.

<name_list>Path Blocked</> <img image="Main/textures/icons/states/pathblocked.png" width="32" height="32"/>
Units that are trying to move but are unable to reach their destination from having their paths blocked.

<name_list>Ineffecient</> <img image="Main/textures/icons/states/inefficient.png" width="32" height="32"/>
Insufficient power leading to inefficiency.

<name_list>Unpowered</> <img image="Main/textures/icons/states/unpowered.png" width="32" height="32"/>
No power delivered to the unit or building.

<name_list>Emergency</> <img image="Main/textures/icons/states/emergency.png" width="32" height="32"/>
A unit's health has dropped below 75% health.

<name_list>Broken</> <img image="Main/textures/icons/states/broken.png" width="32" height="32"/>
A unit's health has dropped below 25% health.

<name_list>Stale Order</> <img image="Main/textures/icons/states/stale.png" width="32" height="32"/>
An order related to this unit has not been fulfilled within a period of time. While this might be fine in some cases, it is to help indicate where there might be issues with your logistics network.

<name_list>Infected</> <img image="Main/textures/icons/states/infected.png" width="32" height="32"/>
A unit is infected by the virus.

<name_list>Running Behavior</> <img image="Main/textures/icons/components/basic_cpu.png" width="32" height="32"/>
The unit is running a behavior.

<name_list>Connected</> <img image="Main/textures/icons/states/connected.png" width="32" height="32"/>
The unit is connected to the logistics network.

<name_list>Disconnected</> <img image="Main/textures/icons/states/disconnected.png" width="32" height="32"/>
The unit is disconnected from the logistics network.

<name_list>Transport Route</> <img image="Main/textures/icons/states/transport.png" width="32" height="32"/>
The unit is set to perform a transport route.

<name_list>High Priority</> <img image="Main/textures/icons/states/high_priority.png" width="32" height="32"/>
The unit is marked as high priority. Orders will prefer to source from this location and orders related to this unit will be higher priority than other orders in the network.]]
		},
		{
			---------------------
			-- @@ITEM REQUESTS
			---------------------
			title = "Request Items",
			text = [[Items can be requested to be delivered to a unit or building. <img image="icon_small_request" color="ui_light" width="32" height="32"/>

Item requests create an <hl>order.</> Multiple orders can be made by holding shift while pressing the request item button. Items can be

Items can be moved between units in a number of ways, such as clicking and dragging the item onto the new building. Another way is to have a unit <hl>request</> a desired item.

<hl>Recurring</> requests will continually request items to try to keep that amount of items in the unit and is a good way to keep a stock of items at a location. Requests can be made on different <hl>channels</> even if the unit itself isn't on that channel. This helps other nearby recurring requests from sending items back and forth.

<nt>Note: Requests (orders) put out to the Network will only be fulfilled from existing items and are not a request for something to be produced.</>]]
		},
	},
}

--------------------------------------------------
------------------ @@DEPLOYMENT
--------------------------------------------------
data.codex.x_tc_deployment = {
	category = "How to Play", index = 11, title = "Deployment",

	sections = {
		{
			title = "<codex_s>Deploy Components</>",
			text = [[
<img width="32" height="32" id="c_deployer" style="hl"/> components can hold a premade <hl>unit</> or <hl>building</> that can be placed.

<img image="Main/textures/codex/new/DEPLOY_deployer_02.png"/>

<hl>Deployers</> are an internal component that can be moved like any other item (dragged to a unit) and <hl>must be equipped</> so that they may deploy what they hold.

To deploy the building, click the <hl>Target</> register on the Deployer, then select the desired location to place the building.

<img image="Main/textures/codex/new/DEPLOY_deployer_04.png"/>]],
		}
	},

	text = [[<codex_title>Deployment</>

<bl>The </><hl>Command Center</><bl> can be deployed.</>

<img image="Main/textures/codex/new/DEPLOY_command_center_02.png"/>
With your <img id="f_bot_2m_as" width="50" height="50" style="hl"/> selected, deploy it by using the <yl>[</> <hl>Deploy Base</> <yl>]</> button.]],
}
--------------------------------------------------
----------------- @@COMPONENTS
--------------------------------------------------
-- Components need to be constructed separately to allow them to be equipped and can be linked together via <hl>Registers</> to automate various functions.
-- Units have limited functionality until equipped with a component, however mobile units are able to pick up and drop items freely while buildings can not do so without a supporting component.


data.codex.x_tc_components = {
	category = "How to Play", index = 7, title = "Components",

	sections = {
		{
			title = "Sockets",
			text = [[
<hl>Units</> and <hl>buildings</> can be customized by placing a <hl>component</> into any available <hl>socket</>, this is how they gain functionality such as mining, production, scanning and more.

Components come in four sizes, <hl>small</>, <hl>medium</>, <hl>large</> and <hl>internal</> and can fit into sockets of the same size or larger.
<img image="Main/textures/codex/ui/sockets.png"/>

<gray>Note: Components equipped in a socket larger than their size will gain an efficiency boost.</>]]
		},
		{
			title = "Equipping Components",
			text = [[
Components can be <hl>equipped</> onto Units and Buildings several different ways:

<img image="Main/textures/codex/new/COMP_equip_03.png"/>

Components can be <hl>dragged</> from an inventory slot to a component socket. You can also press <Key action="ExecuteAction" style="bl"/> on a component in an inventory slot and select <hl>Equip</> from the context menu or directly press <hl>Ctrl+</><Key action="SelectAction" style="hl"/> on it to equip the component. Additionally, components can be dragged into the world and <hl>dropped</> onto a unit or building.]]
		},
		{
			title = "Component Registers",
			text = [[
<img image="Main/textures/codex/registers/codex_miner.png"/>

<hl>Mining</> components will harvest the resource node specified in its Register. If a resource type, such as <img id="metalore" style="hl"/> or <img id="crystal" style="hl"/>
are set in the Register then the component will try to find a matching resource node within visible range. If a number is specified then
the component will only mine up to that amount of items or until full.

<img image="Main/textures/codex/registers/codex_production.png"/>

<hl>Production</> component registers specify the item or unit to be produced. If available you can also set a <hl>unit blueprint</> to the
register to manufacture a <hl>pre-made unit</> saved earlier. The second Register on production units shows the next <hl>required ingredient</> that
is required for production. This is useful to pass along to other components to create production chains.

If the number is specified as <hl>Infinity</> then it will continue production until it is no longer able to do so.

<img image="Main/textures/codex/registers/codex_research.png"/>

<hl>Uplink</> and research components show the technology that is currently being researched. Similar to production components, the second
register will show the new required ingredient to complete the research.

Certain <hl>components</> will have Registers that when set will activate the functionality of that component.]]
		},
		{
			title = "Rotate Components",
			text = [[
<img image="Main/textures/codex/buildingshots/component_rotate.png" width="500" height="200"/>
To rotate components, mouse over a socketed component's icon and press the <Key action="RotateConstructionSite" style="bl"/> key. This is purely for visual effect and has no influence on gameplay.]]
		},
		{
			title = "Component Types",
			text = [[
<img image="Main/textures/codex/new/COMP_component_types_01.png" align="right"/>

Components have a variety of functions, from adding power or storage to giving units scanning or radar capabilities.

<hl>Production</>
Produces materials, components or units, requesting ingredients from the logistics network if connected. If inventory is full it will try to send its current inventory to any available shared storage. can be set to infinite or a number to make.

<hl>Mining/Harvesting</>
A variety of components to get resources from the map

<hl>Detection</>
Adds radar for detecting resources, enemy units and buildings. Scanning can open structures requiring special access

<hl>Power</>
components that produce/transfer power, connected to the logistics network

<hl>Research</>
Will request required ingredients for the research item it currently uses, will perform one at a time so load balancing happens across multiple research components. Will not start research it cannot finish for reasons such as not being able to hold the required items

<hl>Storage</>
Adds more inventory to a unit. Shared storage will receive any items the logistics network wishes to store into any slots that are locked to that item.

<hl>Resimulator/Cores</>
unlocks special recipes and abilities throughout the game]]
		},
		{
			title = "Radar",
			text = [[
The <img width="50" height="50" id="c_portable_radar" style="hl"/> is one of the first key components you will unlock via the Basic Signals technology.
Radar can be set to search for one particular item or target in the world. (multiple filters are Not for multiple items)

For example it could be set to search for metal ore <img width="50" height="50" id="metalore"/> or enemies<img width="50" height="50" id="v_enemy_faction"/> or unsolved ruins<img width="50" height="50" id="v_unsolved"/>

<img image="Main/textures/codex/registers/radar_registers.png" width="450" height="120"/>

The first three boxes <yl>(1)</> are <hl>Filters</>, and the last box <yl>(2)</> is the <hl>Radar Result</>

<hl>Multiple Filters</>

Multiple filters can be used to refine a search.

For example, this setting will look for <hl>Silica</> and <hl>Dropped Item</>. It will only look for 'scattered or dropped silica' on the ground and not mineable nodes.

<img image="Main/textures/codex/registers/radar_filters.png" width="450" height="90"/>]]
		},
		{
			title = "Signal Reader",
			text = [[
With a <img width="50" height="50" id="c_signal_reader" style="hl"/> the<hl>Signal Register</> <img image="Main/textures/codex/icons/register_signal.png" width="50" height="50"/>value of a target can be read.

Example: Twin Bot reading from Cub's signal Register

<img image="Main/textures/codex/logistics/signal_reader_1.png" width="800" height="320"/>


<yl>(1)</>  In the example above the Twinbot's <hl>Signal Reader</> is set to Target the Cub.

<yl>(2)</>  A result of <bl>[ Metal Ore ]</><img width="50" height="50" id="metalore"/> is being returned from the Cub's <hl>Signal Register</>

<yl>(3)</>  It then feeds that result into its miner component.]],
		},
		{
			title = "Transporters",
			text = [[
With a <img width="50" height="50" id="c_portablecrane" style="hl"/> (Range 1) a unit is able to pass items or components directly to another unit that is located beside it.

<img image="Main/textures/codex/logistics/transporter_1.png" width="800" height="320"/>

In the above example the Production building in the center has a Portable Transporter in one of its internal slots. With this:

<yl>(1)</>  <bl>Metal Bars</> and <bl>Metal Plates</> being stored in the <hl>Storage Block</> on the left will be transported to the <hl>Production building</>

<yl>(2)</>  <bl>Reinforced Plates</> being produced in the <hl>Production building</> will be transported to the <hl>Storage block</> on the right.


<img image="Main/textures/codex/registers/radar_filters.png" width="450" height="90"/>]]
		},
		{
			title = "Drones and Drone Ports",
			text = [[
<img width="50" height="50" id="c_drone_port" style="hl"/><img width="50" height="50" id="f_drone_transfer_a" style="hl"/> that perform logistics functions (fulfilling orders) on your network.

Drone Packages <img width="50" height="50" id="drone_transfer_package"/> are produced separately from the Drone Ports and must be dragged and dropped into the Port's inventory to load the Drones.

<img image="Main/textures/codex/logistics/drone_port_1.png" width="800" height="320"/>

<img image="Main/textures/codex/registers/radar_filters.png" width="450" height="90"/>]]
		},
		{
			title = "Integrated Components",
			text = [[
<img image="Main/textures/codex/new/COMP_integrated_components_01.png" align="right"/>

Some units and buildings have integrated components that cannot be removed. For example the <hl>Command Center</> has a built-in producer <hl>Robot Factory</> for making units.]],
		}
	},

	text = [[<codex_title>Components</>

<hl>Components</><bl> need to be equipped to a </><hl>Socket</><bl> in order to function. Most units and buildings have one or more sockets for mounting components.</>

<img image="Main/textures/codex/new/0-COMPONENTS.png"/>]],
}

--------------------------------------------------
------------- @@RESOURCES and MINING
--------------------------------------------------

data.codex.x_tc_resources_mining = {
	category = "How to Play", index = 6, title = "Resources and Mining",

	text = [[<codex_title>Resources and Mining</>

<img image="Main/textures/codex/new/RESOURCE_mining_01.png"/>]],
	sections = {
		{
			title = "Basic Resources",
			text = [[
<hl>Basic Resources</> can be found throughout the world and are harvested with various types of <hl>miner</> components. Other types of resources may require more advanced extraction components and be processed in different production facilities.
The early production component for mining is the standard <img id="c_miner" width="40" height="40" style="hl"/> component

<img image="Main/textures/codex/resources/three_resources.png" width="250" height="80"/>

Selecting a unit equipped with a <hl>mining component</> and interacting with a resource will begin harvesting the resources if it is able to.

This will put the resource node into the Register of the component. Once this node has depleted it will look for nodes of a similar resource type and continue mining.]]
		},
		{
			title = "Mining Register",
			text = [[
You can also set a resource item <hl>directly</> into a Component's <hl>Register.</>

The unit will then look for resource nodes in a <hl>visible radius</> automatically.

If a <hl>number</> is set into the Register then the miner will only extract while there are <hl>less than</> that many of the resources in its inventory.

The range of mining equipment can be extended by linking a radar component to the miner components Register.

If a specific <hl>resource node</> is set then the miner will try to specifically mine only that resource. This can lead to issues if you have several miners set to a particular node, so it is recommended to use the more generic resource type value.]]
		}
	},
}

--------------------------------------------------
----------------- @@REGISTERS
--------------------------------------------------

data.codex.x_tc_registers = {
	category = "How to Play", index = 5, title = "Registers",

	text = [[<codex_title>Registers</>

<hl>Registers</> <bl>are the way</> <hl>data</> <bl>is passed around. They are essentially a </><hl>container</> <bl>for specific</> <hl>values</> <bl>and anything that requires settings in the game uses registers, allowing for interconnectivity between various elements. There are no data types outside of registers and any register can hold </><hl>any type of data.</>

<img image="Main/textures/codex/new/REGISTERS_title_00.png"/>]],

	sections = {
		{
			title = "Register Values",
			text = [[
Register values are the main data type used by most systems. They can be used to set <bl>production</>, control unit and building <bl>logistics</>, and hold parameters of <bl>behaviors</>.

<img image="Main/textures/codex/registers/single_register.png"/>
Registers can hold two pieces of data:

A <hl>Number</> (including <bl>infinity</>) and <bl>one</> of the following:
- <hl>Identifier</>: An item/component/unit/building type or information (color value, radar filter, research technology)
- <hl>Target Reference</>: A reference to a specific object in the game like a unit, building or resource node
- <hl>Coordinate</>: A 2D coordinate referencing a specific location in the game composed of X and Y parts

Registers on the Interface can be linked together by dragging from the source register to the destination. This link will automatically transfer the value of the source register into the destination. To remove the link do the same action again by dragging from the source to the destination. Clearing or setting a register will also clear any incoming links.]]
		},
		{
			title = "Copy Register Values",
			text = [[
You can copy a register value by hovering over it with the mouse and pressing <Key style="hl" action="UnitCopy"/> which will copy it to the clipboard. Hovering over a different register and pressing <Key style="hl" action="UnitPaste"/> will paste the current value in the clipboard to that register. holding down <hl>Ctrl</> and dragging a register will drag its value for easily copying registers around. You can also drag registers containing an item type into an inventory slot to lock it to that item.

<img image="Main/textures/codex/automation/goto_set.png"/>
Target references can be created by dragging from a register onto the 3d object in the world, and are shown with a yellow outline to show that they have a target value. Similarly, Coordinates can also be obtained by dragging the register over an empty location in the world.

Some registers have default functionality or filters applied, such as on turret and production components, to only show what is available for that component. To get a full list of unfiltered values you can hold down <hl>Ctrl</> while clicking the register.]]
		},
		{
			title = "Store Register",
			text = [[
Higher priority than general logistics orders. You can set multiple store locations and the system will fill them up starting from the first one in the list. Orders will be created if the unit cannot fulfill it itself

Setting the <hl>Store register</><img image="Main/textures/codex/icons/register_store.png" width="45" height="45"/> to a Building on a Unit will make that unit store all its items on that building.

<img image="Main/textures/codex/automation/home_mine1.png"/> <img image="Main/textures/codex/automation/home_mine2.png"/>

<desc>In the example above when the Unit has filled up from mining it will take it to the Building and empty its inventory, then go back to mining.</>

To set the Store Register <img image="Main/textures/codex/icons/register_store.png" width="45" height="45"/> select the unit, click and drag from the Store Register. A white arrow will appear, drag onto the target in the world and release the mouse button. Alternatively, with the unit selected, hold <hl>Ctrl</> and <Key action="ExecuteAction"/> on the target.

By clicking on the <hl>Store register</> and then the <hl>Add to Store Targets</> button you can set multiple storage locations.
<img image="Main/textures/codex/new/0-MULTIPLE_STORE.png"/>]],
		},
		{
			title = "Goto Register",
			text = [[
If you set the <bl>Goto register</> <img image="Main/textures/codex/icons/register_goto.png" width="32" height="32"/> to another unit it will follow that unit. The distance kept while following can be specified by setting a number on the register.

You can set it by either <hl>dragging</> from the <bl>Goto register</> to the Unit, or clicking the <Key action="ExecuteAction" style="hl"/> on that Unit.

<img image="Main/textures/codex/automation/goto_set.png"/><img image="Main/textures/codex/automation/home_follow.png"/>]]
		},
	},
}

--------------------------------------------------
----------------- @@PRODUCTION
--------------------------------------------------

data.codex.x_tc_production = {
	category = "How to Play", index = 8, title = "Production Components",

	sections = {
		{
			title = "Setting Production",
			text = [[
<img image="Main/textures/codex/new/COMP_set_register_04.png"/>
Production Components all have a <hl>register</> for setting what item or unit to produce.

<hl>Setting Production</>
Units with a production component (e.g. <hl>Fabricator</> or <hl>Assembler</>) set their production by clicking the <hl>production</> register and choose the item or unit type to produce.
You can adjust the amount if needed. Setting it to infinity (∞) will reserve and order half a stack of the required ingredients.

<hl>Setting Production to Infinite</>
Open the register and select the item to produce. Materials will <hl>automatically</> be set to produce an infinite amount. For <hl>components</>, you must click the <hl>infinite button</> to do so, otherwise it will default to produce just one component.

<hl>Setting Production to a Specific Amount</>
Open the <hl>production</> register, select the item and at the bottom specify the amount to produce.

<hl>Requesting Ingredients</>
So long as the production component is in a unit or building that is <hl>connected</> to a logistics <hl>network</> it will automatically order missing ingredients from that network. The orders will be delivered by units when available.

<hl>Additional Information</>
- The second register shows the next <hl>required ingredient</> which has not yet been delivered.
- If the output inventory is full, production will pause until space is available.
- Some components have an additional <hl>Rally Point</> register which will send a unit to a location after production, or set its <hl>Goto</> register.]]
		},
		{
			title = "Early Production Components",
			text = [[
Production components can produce/refine materials and produce components and units.

<img width="30" height="30" id="c_fabricator"/> <hl>Fabricator</> - the most basic production component for <bl>basic materials</> and early <bl>components</>
<img width="30" height="30" id="c_assembler"/> <hl>Assembler</> - the early main production component for <bl>advanced materials</> and <bl>components</>
<img width="30" height="30" id="c_robotics_factory"/> <hl>Robotics Assembler</> - the primary production component for producing <bl>Robot units</> and <bl>hi‑tech materials</>
<img width="30" height="30" id="c_refinery"/> <hl>Refinery</> - the first production component for <bl>specialized materials</>
<img width="30" height="30" id="c_carrier_factory"/> <hl>Integrated Producers</> - some buildings have built-in producers like the <img id="c_carrier_factory" style="bl"/> on the deployed <img id="f_landingpod" style="bl"/>.]]
		},
	},

	text = [[<codex_title>Production Components</>

<bl>Production components are key components necessary to refine resources, to produce new materials and to make other components.</>

<img image="Main/textures/codex/new/PROD_components_01.png"/>]],
}


--------------------------------
----------------- @@BUILDINGS
--------------------------------------------------
-- Build Menu
-- Default buildings, can also place from blueprint library
-- <img showing build menu>

-- Copy/Pasting buildings
-- <explain and images on how to copy paste

-- Placing multiple times
-- Shift or draw multiple units

-- Editing buildings
-- Ctrl click to edit while placing. Ctrl-placing over an existing building will replace or upgrade that building with the new one. Buildings also available for "Edit" after its been placed.
-- <img for building editor single building>

-- Multi building blueprints
-- can place multiple buildings at the same time
-- <img for multiple building editor>

-- Save as blueprint
-- into your blueprint library. Blueprints saved as favorites will be available in other games. blueprints can be edited directly inside your library

-- Deconstruction
-- long hold on the units health button to deconstruct. With multiple selection if the option is available a deconstruction button will appear

-- Relocation
-- select relocate to move a set of buildings, the units will carry the items and rebuild the buildings elsewhere. Initially limited to the same logistics network but later will have the means to relocate outside or across logistics networks

-- <codex_m>< Constructing a Building ></>
-- <yl>1</> Open the <hl>Build Menu (</><Key action="Build" style="hl"/><hl>)</> <img image="Main/textures/codex/icons/icon_build.png" width="40" height="40"/> and select a <hl>Building 1x1 (1S)</>
-- <yl>2</> Place the small building <img id="f_building1x1d" width="50" height="50"/>

-- <img image="Main/textures/codex/production_top.png" width="350" height="200"/>

data.codex.x_tc_buildings = {
	category = "How to Play", index = 10, title = "Buildings",

	sections = {
		{
			title = "Build Menu",
			text = [[
The <hl>build menu</> <img image="Main/textures/codex/icons/icon_build.png" width="32" height="32"/> (<Key action="Build" style="hl"/>) displays a list of buildings available for construction.

<img image="Main/textures/codex/buildingshots/buildmenu.png"/>

After selecting the building you want to construct, it will appear in your <hl>mouse cursor</> and is ready for placement. Press <Key action="SelectAction"/> to place it, creating a <hl>construction site</>.

<img image="Main/textures/codex/buildingshots/buildcursor.png"/>
The build cursor color indicates whether a blueprint cannot be placed (red), is being placed outside the logistics network (yellow), or within it (blue). The <bl>cursor grid</> surrounding the build cursor will additionally show nearby blocked locations in red.

At the top of the screen there will be some extra information indicating nearby resources and other game related information about the location you are hovering over.

<img image="Main/textures/codex/buildingshots/construction_rotate.png" width="500" height="180"/>
Buildings can be rotated (<Key action="RotateConstructionSite" style="hl"/>) before being placed. Dragging while holding <Key action="SelectAction"/> allows you to place a row or block of buildings. Holding <hl>Shift</> enables placing construction sites in multiple locations one after another.

<img image="Main/textures/codex/buildingshots/building_rotate.png" width="500" height="180"/>
You can also rotate buildings after they are placed as long as it fits into the same footprint by hovering the mouse over a building and pressing <Key action="RotateConstructionSite" style="hl"/>.

<img image="Main/textures/codex/buildingshots/buildmenu2.png"/>
<img image="icon_achieved" width="32" height="32" color="ui_light"/> There is a button in the bottom right corner that allows you to load building <bl>blueprints</> from your favorites. At the bottom, more tabs will appear as you create folders in your <bl>library</>.]]
		},
		{
			title = "Copy / Paste",
			text = [[
Buildings can be <hl>duplicated</> including components, behaviors, registers and logistics settings.

<img image="Main/textures/codex/new/BUILDINGS_construction_01.png"/>

Pressing <Key style="hl" action="UnitCopy"/> with one or more buildings selected will store a blueprint into your clipboard. You can also hover over a building and press <Key style="hl" action="UnitCopy"/> without anything selected to copy that building.

To set the blueprint as your build cursor press <Key style="hl" action="UnitPaste"/> and it will be ready to be placed. Alternatively, you can press <Key style="hl" action="UnitPaste"/> while hovering over an existing building to apply the settings from the blueprint onto the existing building. This is convenient if you wish to set up new buildings with the same or similar settings as an existing one.

The copied <bl>blueprint</> in your clipboard will also become available to save in your <bl>Library</> (available by pressing <Key action="Library" style="hl"/>).]]
		},
		{
			title = "Construction Editor",
			text = [[
<img image="Main/textures/codex/buildingshots/blueprint_editor.png"/>

When placing buildings, you can hold down <hl>Ctrl</> while pressing <Key action="SelectAction"/> to bring up the <hl>Construction Editor</> before placement. This allows you to access various building settings, set registers, logistics settings, swap out components or lock inventory slots. This is similar to the editor used in the <hl>Library</> when editing library blueprints. You can use the <hl>Edit</> option in the <hl>Unit Options</> which allows you to reconfigure an existing unit or building.]]
		},
		{
			title = "Multi-Building Blueprints",
			text = [[
<img image="Main/textures/codex/new/BUILDINGS_multi_group_02.png"/>  <img image="Main/textures/codex/new/BUILDINGS_multi_edit_03.png"/>

Several <hl>Buildings</> can be copied, pasted and edited when placed as a group.]]
		},
		{
			title = "Blueprints",
			text = [[
<img image="Main/textures/codex/new/BUILDINGS_add_library_04.png"/>

You can save copied building or unit blueprints to your Library for use later. The library can be accessed via the Library button <img image="Main/textures/codex/icons/icon_library.png" width="32" height="32"/>

With the Building(s) selected, open the <hl>Library</> (<Key action="Library" style="hl"/>) and choose <hl>Create Item</>, then <hl>Create New Blueprint</>]]
		},
		{
			title = "Deconstruction",
			text = [[
<img image="Main/textures/codex/buildingshots/deconstruct.png"/>

Units can be deconstructed if you have researched the technology to rebuild them. Long press on the unit's health bar to initiate deconstruction. It will drop its construction ingredients as well as any held items and components onto the ground. With multiple units selected, and if the option to deconstruct is available, a deconstruct button will be shown.]]
		},
		{
			title = "Relocate",
			text = [[
<img image="Main/textures/codex/buildingshots/relocate.png"/>

Buildings can be relocated by selecting the <hl>Relocate</> option from the Unit menu, either from inside the <bl>Interface</> or pressing <Key action="ExecuteAction" style="hl"/> on a unit. This works with multiple buildings selected.

The units will carry the items and rebuild the buildings elsewhere. Initially limited to the same logistics network but later you will have the means to relocate outside or across logistics networks.]]
		},
	},
	text = [[<codex_title>Buildings</>

<hl>Buildings</><bl> share the same </><Link id="x_tc_the_interface" style="codex_s">Interface</><bl> and most of the characteristics of </><hl>Units</><bl>, only that they cannot move. They can be however be deconstructed and also relocated.</>

<img image="Main/textures/codex/new/0-BUILDINGS.png"/>]],
}

--------------------------------------------
----------------- @@THE NETWORK @@LOGISTICS
--------------------------------------------

data.codex.x_tc_logistics = {
	category = "How to Play", index = 12, title = "Logistics Network",

	text = [[<codex_title>Logistics Network</>

<bl>There are multiple systems to </> <hl>Automate</> <bl>your base, one is a</> <hl>Logistics Network</> <bl>that will broadly manage orders in the network, and there are more dedicated options available.</>

<img image="Main/textures/codex/new/0-NETWORK.png"/>]],
	sections = {
		{
			title = "Network Overview",
			text = [[
Any Unit or Building that has its <hl>Network</> <img image="Main/textures/codex/icons/network_button.png" width="32" height="32"/> button turned <hl>ON</><img image="Main/textures/codex/icons/network_button_ON.png" width="32" height="32"/> and is inside of a Network (represented by the grid) is connected to that Logistics Network and will receive orders from the Network. They will operate within that Network <hl>without any direction</> from the Player.

Units with the <hl>Network</> (whether connected or not) will receive <hl>Power</>

Power generators within the Logistics Network add to the Networks total power and active components will draw power from this pool.

Orders are automatically fulfilled inside the network. For example, ingredients for a production component are automatically requested.]],
		},
		{
			title = "Network Area",
			text = [[
The <hl>Network</> defines the area where units and buildings are both powered  <hl>Powered</> and are receiving <hl>Orders</> from the network. It is the most basic and most hands-off system of automation.

Toggle the <hl>Network</> with ( <Key action="PowerInfo_Toggle" style="hl"/> )

<img image="Main/textures/codex/new/LOGISTICS_the_network_00.png"/>]],
		},
		{
			title = "Connecting to the Network",
			text = [[
<img image="Main/textures/codex/registers/logistics.png" width="80" height="40"/> The Logistics button is next to the Power button on every unit.

<Key action="SelectAction" style="hl"/> the Logistics button to <hl>Toggle</> connection ON/OFF.
<Key action="ExecuteAction" style="hl"/> the Logistics button to open the <hl>Logistics Settings</> menu.

<gray>Note: There is a Logistics Network Menu with options if the player wants advanced control. Left click the logistics button to view this menu.</>]]
		},
		{
			title = "Settings",
			text = [[
<Key action="ExecuteAction" style="hl"/> the <hl>Network Button</> to open <hl>Logistics Settings</>

<img image="Main/textures/codex/new/LOGISTICS_logistics_settings_02.png"/>

- <name_list>Channels</>: 4 channels to isolate networks. Units interact only within their channels. Units can be set to only supply or only receive.
- <name_list>Priority</>: Requests from this unit will be of higher priority.
- <name_list>Carry Out Orders</>: If unticked, this unit stays connected but does not carry orders.
- <name_list>Only Item Transporters</>: Only item transporter components serve this unit's orders.
- <name_list>Request Item</>: Directly request an item to this unit's inventory from existing stock on the network. No fabrication.
- <name_list>Transport Route</>: Continuously pick up from <hl>Goto</> and deliver to <hl>Store</>. Requires both <hl>Goto</> and <hl>Store</> to be set.]]
		},
		{
			title = "Network Connectivity",
			text = [[
Additional Details Regarding Network Connectivity

Connecting a unit to the logistics network makes its inventory available to other units on the network.

Requested items are reserved so other orders do not use them before being picked up.

Empty space at the destination is also reserved for delivery. If there is no free space to make the reservation an order is not created until space is available.

If a unit has no space to carry the item it will also not pick up that order. Orders will only be delivered up to one item stack at a time and are only sourced from one location at a time, so an order requesting several items may require multiple trips if items are scattered across buildings.]]
		},
		{
			title = "How it Works",
			text = [[
<bl>Connected</> units fulfill item transfer requests called <hl>Orders</>.

When a component requires an item it will make an <hl>Order</> on the logistics network for that item.

Available units will fulfill this request by picking up the <hl>Order</>, sourcing the required <bl>Item</> from within the logistics network and finally delivering the <bl>Item</> automatically.

<hl>Example:</> A Fabricator set to <hl>Metal Bars</> will request <hl>Metal Ore</>. A unit picks up ore from storage and delivers it automatically.

Connecting a unit to the logistics network makes its inventory available to other units on the network.

Requested items are reserved so other orders do not use them before being picked up.

Empty space at the destination is also reserved for delivery. If there is no free space to make the reservation an order is not created until space is available.

If a unit has no space to carry the item it will also not pick up that order. Orders will only be delivered up to one item stack at a time and are only sourced from one location at a time, so an order requesting several items may require multiple trips if items are scattered across buildings.]]
		},
		{
			title = "Order Preferences",
			text = [[
If a moveable unit is a source or destination for an order, it prefers to perform that order. For large networks consider dedicated <hl>Transport Routes</>, <hl>Channels</> and other logistics settings for better optimization.]]
		},
		{
			title = "Direct Orders",
			text = [[
Player actions, such as manually dragging items between units, have the highest priority for a better play experience. If a unit is currently moving and a player executes their own move directive then that will initially override where the unit was previously moving.]]
		},

		{
			title = "Transport Route",
			text = [[
You can find more information on the <Link id="x_tc_transport_route">Transport Route</> page.]]
		},
	},
}

-- 	text = [[
-- <hl>Automation 1:</>  <bl>THE LOGISTICS MENU</> <icon icon="icon_carry" width="40" height="40"/>

-- <img image="Main/textures/codex/ui/line_h1.png"/>

-- <header>Open the Menu</>

-- <img image="Main/textures/codex/registers/logistics.png" width="80" height="40"/> Next to Power on every unit.

-- - <Key action="SelectAction" style="hl"/> the Logistics button to open <hl>Logistics Settings</>.

-- <img image="Main/textures/codex/menushots/logistics_settings.png" width="240" height="400"/>

-- <header>Settings</>

-- - <hl>Channels</>: 4 channels to isolate networks; units interact only within their channel. Units can be set to only supply or only receive.
-- - <hl>Priority</>: Requests from this unit become high priority.
-- - <hl>Carry Out Orders</>: If unticked, this unit stays connected but does not carry orders.
-- - <hl>Only Item Transporters</>: Only item transporter components serve this unit's orders.
-- - <hl>Request Item</>: Directly request an item to this unit's inventory from existing stock on the network. No fabrication.
-- - <hl>Transport Route</>: Continuously pick up from <hl>Goto</> and deliver to <hl>Store</>. Requires both <hl>Goto</> and <hl>Store</> to be set.]],

--------------------------------------------------
----------------- @@TRANSPORT ROUTE
--------------------------------------------------

data.codex.x_tc_transport_route = {
	category = "How to Play", index = 13, title = "Transport Route",

	sections = {
		{
			title = "Enable Transport Route",
			text = [[
<img image="Main/textures/codex/new/TRANSPORT_ROUTE_button_01.png"/> Enabling the Transport Route button means the Unit will continuously <hl>pick up items</> from one or more sources and <hl>drop them off</> at one or more targets.

Once enabled, <hl>white arrows</> will appear to allow you to assign one source and one target, stored in the <hl>Goto</> and <hl>Store</> registers respectively.

<img image="Main/textures/codex/new/TRANSPORT_ROUTE_set_goto_02.png"/>

Set the <bl>Goto Register</> <img image="Main/textures/codex/icons/register_goto.png" width="40" height="40"/> to the location you wish to <hl>Pick Up</> from.

Set the <bl>Store Register</> <img image="Main/textures/codex/icons/register_store.png" width="40" height="40"/> to the location you wish to <hl>Drop Off</> to.]]
		},
		{

			title = "Transport Route in Logistics",
			text = [[
Transport Route can be set in the Logistics Network Menu: <img image="Main/textures/codex/menushots/transport_route.png"/>

A unit with a transport route can also be connected to the Network.]]
		},
	},

	text = [[<codex_title>Transport Route</>

<bl>A </><hl>Transport Route</> <bl>is a special system that uses the </><hl>Goto and Store Base Registers</><bl> to automate pickup and delivery.</>

<img image="Main/textures/codex/new/0-TRANSPORT_ROUTE.png"/>]],
}

--------------------------------------------------
------------------- @@Power
--------------------------------------------------
data.codex.x_tc_power = {
	category = "How to Play", index = 14, title = "Power",

	text = [[<codex_title>Power</>

<bl>Units require</> <hl>Power</> <bl>to function.</>

<hl>Low Power</> <bl>will lead to inefficiency and slower production.</>

<img image="Main/textures/codex/new/POWER_low_power_02.png"/>]],

	sections = {
		{
			title = "Powered",
			text = [[
If a unit runs <hl>out of power</> completely, then its components will not function and movement speed will be dramatically decreased. Using the <hl>power button</> you can turn off a unit at any time.

<img image="Main/textures/codex/new/POWER_powered_03.png"/>  <img image="Main/textures/codex/new/POWER_unpowered_04.png"/>  <img image="Main/textures/codex/new/POWER_powered_down_05.png"/>]]
		},
		{
			title = "Power Producers",
			text = [[
<hl>Power Producers</> provide their power to a <hl>Logistics Network</>. This is constant * and not based on demand. Excess power can be stored. <gray>(see batteries below)</>

<gray>Note: Power Producers do not necessarily produce their own Logistics Network.</>

<img width="50" height="50" id="c_solar_cell"/><bl>Solar Cells</> provide constant power to a Logistics Network during daylight.

<img width="50" height="50" id="c_wind_turbine"/><bl>Wind Turbines</> provide constant power to a Logistics Network. They produce double the power on the plateau.

* constant so long as their power conditions apply (e.g. if there is daylight for a Solar Cell component).]]
		},
		{
			title = "Batteries",
			text = [[
<bl>Batteries</> provide their power to a <hl>Logistics Network</> but on demand. When a Logistics Network has insufficient power for its needs it will draw power from batteries and their power will drain. How a battery recharges depends on the type of battery.

<img width="50" height="50" id="c_small_battery"/><bl>Batteries</> within a Logistics Network make their power available when <hl>Consumption</> exceeds power <hl>Production</>. They have limited charge and discharge rates depend on size. Batteries utilize the excess power in the Logistics Network they are in to recharge, and are very effective when used in conjunction with solar cells, for example, to compensate for power loss during the night.]]
		},
		{
			title = "Power Buffer",
			text = [[
<img width="50" height="50" id="c_crystal_power"/><bl>Crystal Power</> will add power to your network the same as a standard battery, on demand. They do not however recharge from excess power, but charge by consuming and converting crystal chunks to power.]]
		},
		{
			title = "Power Fields",
			text = [[
<img width="50" height="50" id="c_small_relay"/> <bl>Power Fields</> generate a network around the unit they are equipped on. Overlapping them on an existing network allows you to expand your existing logistics range. Power Fields do not however provide their own power. Power producers and batteries that are within a Logistics Network will supply to that Network. If you create a completely separate Network, it will require its own power producers.]],
		},
		{
			title = "Power Transmission",
			text = [[
<img width="50" height="50" id="c_power_transmitter"/> <bl>Power Transmitters</> can transfer a limited amount of energy to a single unit, allowing that unit to move freely outside a logistics network.]]
		},
	},
}

--------------------------------------------------
------------------- @@RESEARCH
--------------------------------------------------
-- Research requires a uplink<img id="c_uplink" width="40" height="40"/> component

-- ]]
-- #if TUT_SHOW
-- ..[[
-- <codex_m>(Tutorial)</><hl>21- Researcg Basic Structures</>
-- <codex_m>(Tutorial)</><hl>25- Researcg Basic Power</>
-- ]]
-- #endif

------------------------------------------------------
data.codex.x_tc_research = {
	category = "How to Play", index = 15, title = "Research",

	sections = {
		{
			title = "Technology Tree",
			text = [[
Various categories will open up as you progress through the game
<img image="Main/textures/codex/techtree/basic_tree.png" width="120" height="120"/>

Once unlocked, categories will show a grid of research nodes for that entire category.
<img image="Main/textures/codex/techtree/technology_full_tree.png" width="500" height="400"/>

Selecting a node will show more details on the Technology and allow you to research or queue up to 2 extra technologies.
<img image="Main/textures/codex/techtree/research_basic_power.png"/>


<nt>Note: You can reposition the Tech Tree with the mouse by clicking and dragging the background.</>]]
		},
		{
			title = "Multiple Research Components",
			text = [[
Each equipped Uplink component requests ingredients for research and reduces research time by researching multiple steps at a time. If you have more uplinks than there are remaining steps on the current research, queued technology will begin researching unless they share common resources with the current research.

Uplinks will not be assigned research they cannot perform such as in the case of missing a specific slot type. For example research that requires <img id="blight_extraction" width="32" height="32" style="hl"/> will need a container component for it (see below).]]
		},
		{

			title = "Researching Blight",
			text = [[
Researching Blight requiring the extraction of <hl>Blight Gas</> <img width="30" height="30" id="blight_extraction"/>.
<img width="32" height="32" id="c_blight_extractor" style="hl"/> need to be in the blight or at its edge in order to extract. Special containers are required to hold Blight Gas.
Position your units with blight extractors into the area of blight so that they may extract the gas.
<img image="Main/textures/codex/botshots/in_blight.png" width="400" height="200"/>


<hl>Blight Gas Containment</>
Blight gas cannot be held in normal inventory slots. Extractors have a special chamber for containing the gas.

<img image="Main/textures/codex/new/RESEARCH_blight_inventory_01.png"/>

In addition there are components specifically designed to contain blight gas.]]
		},
	},

	text = [[<codex_title>Research</>
<bl>Access the </><hl>Technology Tree</> <bl>via the</> <hl>Research</> <img image="Main/textures/codex/icons/techtree_icon.png" width="32" height="32"/> <bl>button or by pressing</> ( <Key action="Tech" style="hl"/> ). <bl>This will become available once you have equipped a research component such as the</> <img id="c_uplink" width="32" height="32" style="hl"/>.

<img image="Main/textures/codex/new/0-RESEARCH.png"/>]],
}


data.codex.x_tc_virus = {
	category = "How to Play", index = 19, title = "Virus",
	text = [[<codex_title>Virus</>

You will need to protect yourself from <hl>Viruses</> in the world. Units infected with the <hl>Virus</> will infect other units at a rapid rate and should stay clear as not to infect them. Researching the Virus can open up methods of <hl>Protection</>. The virus has unknown effects that can be harmful so building protection should be high priority.

<img image="Main/textures/codex/new/RESEARCH_virus_infection_01.png"/>]],
	sections = {
		{
			title = "Virus Protection",
			text = [[
One of the first components that can give <hl>Protection</> from the <hl>Virus</>

<img image="Main/textures/codex/items/virus_protection.png"/>

This recipe will appear in your Assembler after the virus has been discovered. Further research can lead to improved methods of protection.]]
		},
	}
}

data.codex.x_tc_blight = {
	category = "How to Play", index = 18, title = "Blight",
	text = [[<codex_title>Blight</>

The <hl>Blight</> covers parts of the planet destroying biological life and searing the ground black. It is a thick electrified gas <img id="blight_extraction" width="32" height="32"/> that cannot be entered without the required equipment. From the Mothership access to the blight will be restricted as long range radio signals cannot penetrate the thick electrical interference. Units however will be able to enter the blight if not reliant on external interaction.

<img image="Main/textures/codex/new/0-BLIGHT.png"/>]],
	sections = {
		{
			title = "Blight Protection",
			text = [[Due to thick electrical forces your units will receive damage if they enter the blight unprotected. Researching new blight technologies will allow you to not only enter the blight but allow you to overcome the thick electrical interference and to interact directly with units.]]
		},
		{
			title = "Blight Resources",
			text = [[The thick electrical fog can transform the landscape as well as resources, producing resources that can only be found inside the blight. <img id="obsidian" width="32" height="32" style="hl"/> can be used for construction purposes and <img id="blight_crystal" width="32" height="32" style="hl"/>, being an electrified variant of normal crystal chunks, can hold charge and is used to advance certain component technologies.]]
		},
	}
}

--------- @@BUGS ----------
data.codex.x_bugs = {
	category = "How to Play", index = 17, title = "Bugs",

	text = [[
<codex_title>Bugs</>


<bl>Native Bug Life on the Planet</>

<img image="Main/textures/codex/new/0-BUGS.png"/>

<img image="Main/textures/codex/bugs/bug_trillo.png" width="250" height="150"/>  <img image="Main/textures/codex/bugs/bug_slug.png" width="250" height="150"/>

The bug life on the planet is inherently hostile to those who enter onto their territory.



<img image="Main/textures/codex/bugs/bug_nest.png" width="250" height="150"/>  <img image="Main/textures/codex/bugs/bug_hive.png" width="250" height="150"/>

These bugs live underground and in hive nests predominantly in the rocky plateau regions of the planet.

These hives and burrows need to be destroyed in order to cut off the bugs from the surface.]],
}

--------------------------------------------------
----------------- TUTORIAL CODEX TC01 END
--------------------------------------------------
