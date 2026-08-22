data.behavior_guides = data.behavior_guides or {}

data.behavior_guides.pickupbot = {
	index = 1, name = "Pickup Bot Behavior",
	steps = {
		{
			target = "graph",
			text = [[This guide builds a simple pickup bot: scan for a dropped item, pick it up, repeat until full, then drop everything at a storage target. Use Next and Previous at any time; steps that can be detected advance automatically.]],
		},
		{
			target = "parameters",
			text = [[Add one behavior parameter and rename it <hl>Storage</> by clicking on its name. The bot needs a visible destination so the finished behavior can be reused with any storage building.]],
			done = { type = "param_named", name = "Storage" },
		},
		{
			target = "toolbox",
			search = "Radar",
			text = [[In the instruction list, open the <hl>Components</> category and drag <hl>Radar</> after the <hl>Program Start</> node. Use it to search for the closest dropped item. Radar returns a target reference, not an item type.]],
			done = { type = 'op', op = "scan" },
		},
		{
			target = "help",
			select_op = 'radar',
			text = [[When a node is selected, this help area shows extra information about how to use it. For Radar, the Result output is the thing in the world that matches the filter, which later instructions can move to or pick up from.]],
			--done = { type = "selected_op", op = "radar" },
		},
		{
			target = "text",
			target_val = "Filter 1",
			text = [[Set the first Radar filter to <img id="v_droppeditem" width="32" height="32" style="hl"/>. Click the Radar node's <hl>Filter 1</> register and choose Dropped Item from the <hl>Information</> tab so Radar only finds item stacks on the ground.]],
		},
		{
			target = "toolbox",
			search = "Check Space",
			text = [[Add <hl>Check Space for Item</> from the instruction list. Drag it onto the first/default outgoing pin of the Radar node, which is the normal path when Radar found something. Do not attach it to <hl>No Result</>.]],
			done = { type = 'op', op = "checkfreespace" },
		},
		{
			target = "graph",
			text = [[Now pass the found target into Check Space for Item. Drag from the <hl>Result</> register on the Radar node to the <hl>Item</> register on the Check Space for Item node. The editor will automatically create a local variable to pass the Radar result along.]],
		},
		{
			target = "toolbox",
			search = "Pick Up",
			text = [[Add <hl>Pick Up Items</> from the instruction list. Drag it onto the first/default outgoing pin of the Check Space for Item node, which is the normal path when the item fits. Do not attach it to <hl>Can't Fit</>.]],
			done = { type = 'op', op = "dopickup" },
		},
		{
			target = "graph",
			text = [[Now pass the same found target into Pick Up Items. Drag from the <hl>Result</> register on the Radar node to the <hl>Source</> register on the Pick Up Items node. The editor will reuse the local variable carrying the Radar result. Leave Item / Amount empty so it picks up anything from the dropped item entity.]],
		},
		{
			target = "toolbox",
			search = "Drop Off",
			text = [[Add <hl>Drop Off Items</> from the instruction list. Drag it onto the <hl>Can't Fit</> pin of the Check Space for Item node. This sends the bot to unload when it cannot fit the item Radar found.]],
			done = { type = 'op', op = "dodrop" },
		},
		{
			target = "graph",
			text = [[Connect the <hl>Storage</> parameter to the <hl>Destination</> register on Drop Off Items. Leave Item / Amount empty so Drop Off Items unloads everything the bot is carrying.]],
		},
		{
			target = "toolbox",
			search = "Wait Ticks",
			text = [[Add <hl>Wait Ticks</> from the instruction list. Drag it onto the <hl>No Result</> pin of the Radar node. You can set its <hl>Time</> register to how many ticks to wait; <hl>5</> means 5 ticks, which is 1 second.]],
			done = { type = 'op', op = "wait" },
		},
		{
			target = "graph",
			text = [[Leave the ends of the Pick Up Items, Drop Off Items, and Wait Ticks pins unconnected. When a behavior reaches the end of a branch it continues the current loop or restarts the behavior; it only stops if it runs into an <hl>Stop Behavior</> node.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press <hl>Apply</> to save the behavior.]],
		},
		{
			target = "icon",
			target_val = "icon_confirm",
			text = [[Exit the behavior editor with the button in the bottom right and select the unit running this behavior. You will see the parameter registers above the behavior; set the <hl>Storage</> register there by choosing the storage unit or building to unload into. You can also start or stop the behavior from this same panel. If it stalls, return to the editor and inspect the node register values.]],
		},
	},
}

data.behavior_guides.safe_miner = {
	index = 2, name = "Safe Miner Behavior",
	steps = {
		{
			target = "graph",
			text = [[This guide builds a miner that checks for enemies first. If an enemy is detected it goes to your home location; if no enemy is detected it scans for a mineable resource and mines it.]],
		},
		{
			target = "toolbox",
			search = "Radar",
			text = [[In the instruction list, open the <hl>Components</> category and drag <hl>Radar</> after the <hl>Program Start</> node. This first Radar is the safety check.]],
			done = { type = 'op', op = "scan" },
		},
		{
			target = "text",
			target_val = "Filter 1",
			text = [[Set this Radar node's <hl>Filter 1</> register to <img id="v_enemy_faction" width="32" height="32" style="hl"/> <hl>Enemy</>. Click Filter 1, open the <hl>Information</> tab, and choose Enemy.]],
		},
		{
			target = "toolbox",
			search = "Get Home",
			text = [[Add <hl>Get Home</> from the instruction list. Drag it onto the first/default outgoing pin of the enemy Radar node, which is the path used when Radar found an enemy. Do not attach it to <hl>No Result</>.]],
			done = { type = 'op', op = "gethome" },
		},
		{
			target = "toolbox",
			search = "Move Unit",
			text = [[Add <hl>Move Unit</> from the instruction list. Drag it onto the first/default outgoing pin of Get Home. This makes the unit move after the home unit has been found.]],
			done = { type = 'op', op = "domove" },
		},
		{
			target = "graph",
			text = [[Wire the retreat target. Drag from the <hl>Result</> register on Get Home to the <hl>Target</> register on Move Unit. The editor will create a local variable carrying your home location.]],
		},
		{
			target = "toolbox",
			search = "Radar",
			text = [[Add a second <hl>Radar</> node. Drag it onto the <hl>No Result</> pin of the enemy Radar node. This second Radar only runs when no enemy was detected.]],
		},
		{
			-- cant select the second radar node
			--target = "text",
			--target_val = "Filter 1",
			text = [[Select the second Radar node and set its <hl>Filter 1</> register to <img id="v_mineable" width="32" height="32" style="hl"/> <hl>Mineable</>. Use the Information tab so it finds mineable resource deposits.]],
		},
		{
			target = "toolbox",
			search = "Mine",
			text = [[Add <hl>Mine</> from the instruction list. Drag it onto the first/default outgoing pin of the resource Radar node, which is the path used when Radar found a resource. Do not attach it to <hl>No Result</>.]],
			done = { type = 'op', op = "mine" },
		},
		{
			target = "graph",
			text = [[Wire the mining target. Drag from the <hl>Result</> register on the resource Radar node to the <hl>Resource</> register on the Mine node. The editor will create a local variable carrying the resource deposit.]],
		},
		{
			target = "toolbox",
			search = "Wait Ticks",
			text = [[Add <hl>Wait Ticks</> from the instruction list. Drag it onto the <hl>No Result</> pin of the resource Radar node. Set <hl>Time</> to 5 if you want it to wait 1 second before scanning again.]],
			done = { type = 'op', op = "wait" },
		},
		{
			target = "graph",
			text = [[Leave the ends of Move Unit, Mine, and Wait Ticks unconnected. Reaching the end of a branch continues the current loop or restarts the behavior; only a <hl>Stop Behavior</> node ends it.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press <hl>Apply</> to save the behavior. Use it on a unit with a mining component.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Exit the behavior editor in the bottom right, select the miner, and start or stop the behavior from the unit's behavior panel.]],
		},
	},
}

data.behavior_guides.run_away = {
	index = 3, name = "Run Away Behavior",
	steps = {
		{
			target = "graph",
			text = [[This guide builds a reactive run-away behavior. A Radar writes an enemy target into a behavior parameter, and a Parameter Event immediately runs a branch that gets your home location and moves the unit there.]],
		},
		{
			target = "parameters",
			text = [[Add one behavior parameter and rename it <hl>Enemy</>. This parameter stores the current enemy target and is also the value watched by the event branch.]],
			done = { type = "param_named", name = "Enemy" },
		},
		{
			target = "toolbox",
			search = "Radar",
			text = [[Add <hl>Radar</> from the <hl>Components</> category after <hl>Program Start</>. This polling branch is useful when the behavior controller does not already have a radar component feeding the Enemy parameter.]],
			done = { type = 'op', op = "scan" },
		},
		{
			target = "text",
			target_val = "Filter 1",
			text = [[Set Radar <hl>Filter 1</> to <img id="v_enemy_faction" width="32" height="32" style="hl"/> <hl>Enemy</>. Click Filter 1, open the <hl>Information</> tab, and choose Enemy.]],
		},
		{
			target = "graph",
			text = [[Drag from the Radar <hl>Result</> register to the <hl>Enemy</> parameter register above the graph. This stores the detected enemy in the behavior parameter.]],
		},
		{
			target = "graph",
			text = [[If the behavior controller has a radar component, this Radar node is optional. Instead, link the radar component's enemy/result register directly to the behavior's <hl>Enemy</> parameter register on the unit panel. The Parameter Event branch will still react when Enemy changes.]],
		},
		{
			target = "toolbox",
			search = "Parameter Event",
			text = [[Add <hl>Parameter Event</> from the instruction list. Place it as a separate branch, not connected to Program Start.]],
			done = { type = 'op', op = "event_parameter" },
		},
		{
			target = "graph",
			text = [[Set which parameter the event listens to. In the <hl>Parameter Event</> node body, click <hl>Select</> and choose the <hl>Enemy</> parameter. This makes the event branch run whenever the value of <hl>Enemy</> changes.]],
		},
		{
			target = "toolbox",
			search = "Get Home",
			text = [[Add <hl>Get Home</> from the instruction list. Drag it onto the first/default outgoing pin of the Parameter Event node. This branch starts whenever the value of <hl>Enemy</> changes.]],
			done = { type = 'op', op = "gethome" },
		},
		{
			target = "toolbox",
			search = "Move Unit",
			text = [[Add <hl>Move Unit</> from the instruction list. Drag it onto the first/default outgoing pin of Get Home. Leave it set to <hl>Synchronous</> so the behavior waits while moving home.]],
			done = { type = 'op', op = "domove" },
		},
		{
			target = "graph",
			text = [[Wire the home target. Drag from the Get Home <hl>Result</> register to the Move Unit <hl>Target</> register. The editor will create a local variable carrying the home target.]],
		},
		{
			target = "graph",
			text = [[Leave the end of <hl>Move Unit</> unconnected. Reaching the end of this event branch finishes the reaction, then the behavior can keep waiting for the next Enemy parameter change.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press <hl>Apply</> to save the behavior.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press Next to Complete the Tutorial. Exit the behavior editor, select the unit, and start the behavior. If using a radar component instead of the Radar node, link that component's enemy/result register to the behavior's <hl>Enemy</> parameter register above the behavior.]],
		},
	},
}

data.behavior_guides.battery_return_home = {
	index = 4, name = "Battery Return Home Behavior",
	steps = {
		{
			target = "graph",
			text = [[This guide builds a battery saving behavior. It reads the unit's battery percentage, compares it to 30, and sends the unit home when the battery is 30% or lower. You can change 30 to whatever battery percent you want to check.]],
		},
		{
			target = "toolbox",
			search = "Get Battery",
			text = [[Add <hl>Get Battery</> from the <hl>Units</> category after <hl>Program Start</>. Leave its optional Unit register empty so it checks the unit running the behavior.]],
			done = { type = 'op', op = "get_battery" },
		},
		{
			target = "toolbox",
			search = "Compare Number",
			text = [[Add <hl>Compare Number</> from the instruction list. Drag it onto the first/default outgoing pin of Get Battery.]],
			done = { type = 'op', op = "check_number" },
		},
		{
			target = "graph",
			text = [[Wire the battery value. Drag from the Get Battery <hl>Percent</> register to the Compare Number <hl>Value</> register. The editor will create a local variable carrying the battery percent.]],
		},
		{
			target = "graph",
			text = [[Set Compare Number <hl>Compare</> to <hl>30</>. This means the return-home branch will run when battery percent is equal to 30 or smaller than 30. You can use any percent you want later.]],
		},
		{
			target = "toolbox",
			search = "Get Home",
			text = [[Add <hl>Get Home</> from the instruction list. Drag it onto the <hl>If Equal</> pin of Compare Number. Then also connect Compare Number's <hl>If Smaller</> pin to the same Get Home node.]],
			--done = { type = 'op', op = "gethome" },
		},
		{
			target = "toolbox",
			search = "Move Unit",
			text = [[Add <hl>Move Unit</> from the instruction list. Drag it onto the first/default outgoing pin of Get Home. Leave it set to <hl>Synchronous</> so the behavior waits while the unit returns home.]],
			done = { type = 'op', op = "domove" },
		},
		{
			target = "graph",
			text = [[Wire the home target. Drag from the Get Home <hl>Result</> register to the Move Unit <hl>Target</> register. The editor will create a local variable carrying the home target.]],
		},
		{
			target = "graph",
			text = [[Leave the end of Move Unit unconnected, and leave Compare Number's <hl>If Larger</> pin empty for now. Reaching the end restarts the behavior, so it keeps checking the battery. Later you can attach any normal-work branch to <hl>If Larger</>.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press <hl>Apply</> to save the behavior.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press Next to Complete the Tutorial. Exit the behavior editor, select the unit, and start or stop the behavior from the unit's behavior panel.]],
		},
	},
}

data.behavior_guides.scout_avoid_enemies = {
	index = 5, name = "Scout With Enemy Avoidance Behavior",
	steps = {
		{
			target = "graph",
			text = [[This guide builds a scout that checks for enemies before moving. If it sees an enemy it goes home; if it sees no enemy it scouts a random nearby area and stores its latest location for the next scout move.]],
		},
		{
			target = "toolbox",
			search = "Radar",
			text = [[Add <hl>Radar</> from the <hl>Components</> category after <hl>Program Start</>. This Radar is the danger check.]],
			done = { type = 'op', op = "scan" },
		},
		{
			target = "text",
			target_val = "Filter 1",
			text = [[Set Radar <hl>Filter 1</> to <img id="v_enemy_faction" width="32" height="32" style="hl"/> <hl>Enemy</>. Use the Information tab.]],
		},
		{
			target = "toolbox",
			search = "Get Home",
			text = [[Add <hl>Get Home</> from the instruction list. Drag it onto the first/default outgoing pin of Radar, which is the path used when an enemy was found. Do not attach it to <hl>No Result</>.]],
			done = { type = 'op', op = "gethome" },
		},
		{
			target = "toolbox",
			search = "Move Unit",
			text = [[Add <hl>Move Unit</> from the instruction list. Drag it onto the first/default outgoing pin of Get Home. This is the retreat action.]],
			done = { type = 'op', op = "domove" },
		},
		{
			target = "graph",
			text = [[Wire the retreat target. Drag from Get Home <hl>Result</> to Move Unit <hl>Target</>. The editor will create a local variable carrying the home target.]],
		},
		{
			target = "toolbox",
			search = "Scout Range",
			text = [[Add <hl>Scout Range</> from the instruction list. Drag it onto the <hl>No Result</> pin of Radar, which is the path used when no enemy was found.]],
			done = { type = 'op', op = "scout_rand_range" },
		},
		{
			target = "graph",
			text = [[Set Scout Range <hl>Range</> to <hl>5</>. This controls how far the scout tries to move each time.]],
		},
		{
			target = "toolbox",
			search = "Get Location",
			text = [[Add <hl>Get Location</> from the instruction list. Drag it onto the first/default outgoing pin of Scout Range, as shown in the example graph. This records where the scout ended up after the move.]],
			done = { type = 'op', op = "get_location" },
		},
		{
			target = "graph",
			text = [[Wire the scout's previous position. Drag from Get Location <hl>Coord</> to Scout Range <hl>Coord</>. The editor will create a local variable, so each new scout move can use the last location as direction context.]],
		},
		{
			target = "graph",
			text = [[Leave the ends of <hl>Move Unit</> and <hl>Get Location</> unconnected. The behavior restarts after each branch, so it checks for enemies before every scout move.]],
		},
		{
			target = "tooltip",
			target_val = "View Options",
			text = [[To watch the scout while testing, click <hl>View Options</> in the bottom-left camera preview and raise <hl>Show Behind Editor</>. This lets you monitor the unit behind the behavior editor as it runs.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press <hl>Apply</> to save the behavior.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press Next to Complete the Tutorial. Exit the behavior editor, select the scout, and start or stop the behavior from the unit's behavior panel.]],
		},
	},
}

data.behavior_guides.radio_move = {
	index = 6, name = "Signal-Controlled Move Behavior",
	steps = {
		{
			target = "graph",
			text = [[This guide builds an event-driven behavior. A Radio Event waits for a radio signal on a chosen band; when the signal changes, the unit moves to the signal's target.]],
		},
		{
			target = "toolbox",
			search = "Radio Event",
			text = [[Add <hl>Radio Event</> from the <hl>Communication</> category. Place it as a separate branch, not connected to Program Start.]],
			done = { type = 'op', op = "event_radio" },
		},
		{
			target = "graph",
			text = [[Set the Radio Event <hl>Band</> in the node body. Click its Band register and choose a value you will also use when sending the radio signal. If no band is selected, the event will not watch anything.]],
		},
		{
			target = "toolbox",
			search = "Move Unit",
			text = [[Add <hl>Move Unit</> from the instruction list. Drag it onto the first/default outgoing pin of Radio Event. Leave it set to <hl>Synchronous</>.]],
			done = { type = 'op', op = "domove" },
		},
		{
			target = "graph",
			text = [[Wire the signal target. Drag from the Radio Event <hl>Signal</> register to the Move Unit <hl>Target</> register. The signal should be a unit or coordinate target; the editor will create a local variable carrying it.]],
		},
		{
			target = "graph",
			text = [[Leave the end of <hl>Move Unit</> unconnected. The event branch finishes after moving, then waits for the next radio signal change on the selected band.]],
		},
		{
			target = "id",
			target_val = "remoteconfirm_box",
			text = [[Press <hl>Apply</> to save the behavior.]],
		},
		{
			target = "icon",
			target_val = "icon_confirm",
			text = [[Press Next to Complete the Tutorial. Exit the behavior editor, select the unit, and start the behavior. To test it, equip a <img id="c_radio_transmitter" width="32" height="32" style="hl"/> on a different unit, set that radio behavior to the same band, then set coordinates on the radio; this bot will move to those coordinates when the radio signal changes.]],
		},
	},
}
