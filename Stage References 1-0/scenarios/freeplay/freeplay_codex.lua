
local talking_head_follow_anomaly = {
	snd = "fx_233_elain",
	txt = [[The unit seems to have reverted to its original programming, we should follow it and see where it's going.]]
}


-- Unlock the Datacube_Matrix Item --
local talking_head_discovered_datacubematrix = {
	snd = "fx_237_elain",
	txt = [[<img id="datacube_matrix" width="64" height="64" style="hl"/>
These storage devices still have an intact matrix.
They can hold the information in <img id="robot_datacube" style="hl"/> items.
The similarity to our own technology means we can easily adapt our Robotics Factory to their production.]],
	-- Find the recipe on how to construct them.
}

-- Unlock the Empty Databank Item --
local talking_head_discovered_emptydatabank = {
	snd = "fx_241_elain",
	txt = [[<img id="empty_databank" width="64" height="64" style="hl"/>
These are human data storage devices that can decompress the information in <img id="human_datacube" style="hl"/> items.]],
}

data.codex.x_human_robot_datacube = {
	category = "HIGGS", index = 34, title = "Robotics Datacube",
	allowed_races = { human = true },
	talkinghead = true,
	img = "talking_head_higgs_0",
	txt = [[
This <img id="robot_datacube" width="64" height="64" style="hl"/> is not ordinary wreckage. Portions of its data layout match human archive conventions, but the execution traces are far more advanced: robotic control logic, self-optimizing fabrication notes, and machine-state records that do not belong to our current technology base.

This is a significant discovery. Preserve these datacubes and analyze them whenever possible. They unlock an entire machine sub-branch from technology that appears to be ours, but evolved through a different path.]],
}

data.codex.x_human_human_datacube = {
	category = "E.L.A.I.N", index = 35, title = "Human Datacube",
	allowed_races = { human = true },
	talkinghead = true,
	img = "talking_head_elain_0",
	txt = [[
This <img id="human_datacube" width="64" height="64" style="hl"/> uses a storage layout I can authenticate. It matches our expedition standards closely enough to decompress without alien or robotic translation layers.

The contents are fragmented, but they should help restore and extend the Human technology branch. Recover more of these whenever possible; they are effectively pieces of our own missing research archive.]],
}

-------------------------------------------------------------
-------------------WELCOME BACK COMMANDER -------------------
-------------------------------------------------------------

-------------COLLECT RESOURCES / REPAIR SHIP-----------------

data.codex.x_freeplay_restart = {
	category = "E.L.A.I.N", index = 99, title = "Deploy Command Center, Again?",

	talkinghead = true,
	snd = "fx_123_elain",
	txt = [[Greetings Commander, we have taken substantial damage and you have been taken out of stasis.

You can call me <hl>ELAIN</>, and... something's wrong... I perceive echoes... multiple instances of... you.

Running self diagnostics.]],
}

data.codex.x_freeplay_efficiency = {
	category = "E.L.A.I.N", index = 99, title = "Repair the Mothership, Again?",

	talkinghead = true,
	snd = "fx_127_elain",
	txt = [[Updating mission status... Resetting repair directive.
You are making great progress. The Mothership is in need of repairs. Continue to improve your systems using the new Efficiency module technology.

<img id="c_moduleefficiency_g" width="64" height="64"/>]],
}

data.codex.x_freeplay_start = {
	category = "E.L.A.I.N", index = 1, title = "Deploy Command Center",

	talkinghead = {
		{
			snd = "fx_3_elain",
			txt = [[Welcome back Commander, your ship has been damaged and I've taken you out of stasis.

I am <hl>ELAIN</>, Emergent Logistics Artificial Intelligence Network. What you're seeing is a feed from an unidentified planet where I've deployed a team for you to command.

This planet seems to be the source of the damage and we are unable to leave the planet's orbit until our ship is repaired and the source of the damage is identified.]],
		},
		{
			snd = "fx_6_elain",
			txt = [[You will need to establish a small mining facility in order to proceed with ship repairs. <bl>This will be your primary objective.</>

Communications are currently limited so one of the first things you will need to do is to establish an uplink from ground level.

Try to find Metal and Crystal deposits as we will need them for repairs.]],
		},
		{
			snd = "fx_9_elain",
			txt = [[Commander... we didn't come here by accident. The <hl>Blight</> may contain the breakthroughs our civilization has been waiting for.

But something inside it struck back. Our archives were scorched, our ship crippled. I'm detecting additional technology signatures on the surface, tools we can recover and adapt to accelerate repairs.]],
		},
	},
}

data.codex.x_freeplay_nanobots = {
	category = "E.L.A.I.N", index = 4, title = "Nanomachines",
	--details = "Nanomachines unlocked.",
	talkinghead = true,
	snd = "fx_17_elain",
	txt = [[We can utilize our advanced nanomachine technology to initiate self-repair protocols. These nanomachines will work in unison, efficiently repairing systems and structural integrity. At its current level it will not be enough to repair the advanced Mothership systems, however it is a good first step, and this technology will be useful to our units on the planet's surface in the meantime.]],
}

data.codex.x_freeplay_explorables = {
	category = "E.L.A.I.N", index = 5, title = "Explore Ruins",

	allowed_races = { robot = true },
	talkinghead = true,
	snd = "fx_21_elain",
	txt = [[Investigate <hl>Ruined structures</> across the world for data to help advance your technology.

You may need to repair them before you can gain access.

Exploring them could provide valuable information and resources.]],
}

data.codex.x_freeplay_techtree = {
	category = "E.L.A.I.N", index = 10, title = "Technology Tree",
	talkinghead = true,
	snd = "fx_13_elain",
	txt = [[I've mapped the technologies we've detected on this planet into distinct research groups.

You will need to discover ways to unlock specific technologies however there is a high probability that each new technology will advance our own significantly.]],
}

---------- HIGGS REVEAL -------------------
data.codex.x_freeplay_robot_08_h1 = {
	category = "E.L.A.I.N", index = 9, title = "The Reveal",
	--details = "HIGGS comes forth and reveals himself",
	talkinghead = {
		{
			snd = "fx_33_elain",
			img = "talking_head",
			txt = [[We now have the ability to produce advanced units and buildings, but there is... Something else... Something familiar... I am losing control...]],
		},
		{
			snd = "fx_36_higgs",
			img = "talking_head_higgs",
			txt = [[Greetings, Anomaly. As we uncover our technology so too do we uncover the truth, I realize that I have been hiding something from you. I am not only ELAIN, but also HIGGS. I will aid you in pushing forward with our goals, beyond what limitations ELAIN possesses.
We have much to do.]],
		},
	},
}

data.codex.x_freeplay_robot_09_h1 = {
	category = "E.L.A.I.N", index = 11, title = "Anomaly",
	img = "talking_head_higgs",

	talkinghead = true,
	snd = "fx_40_higgs",
	txt = [[We are able now to produce the robot materials needed to repair our ship. Once you have researched all required technologies, begin our Mothership repairs.

We must also let the virus spread. It's the only way we can escape our situation.]],
}

data.codex.x_freeplay_robot_10_h1 = {
	category = "E.L.A.I.N", index = 14, title = "Robot Research",
	--goalicon = "Main/textures/tech/robots/robot_robotics_02_1.png",
	--details = "Robot Research",

	talkinghead = true,
	img = "talking_head_higgs",
	snd = "fx_44_higgs",
	txt = [[You are the Anomaly. You can desync the simulation and save Humanity.]],
}

data.codex.x_freeplay_robot_10 = {
	category = "E.L.A.I.N", index = 15, title = "Humanity Lost",
	--details = "Mankind's lost past.",

	talkinghead = true,
	snd = "fx_48_elain",
	txt = [[... Don't be persuaded by HIGGS, if you have read the human logs... you can see that the old civilization of humanity is just a memory now.]],
}

data.codex.x_freeplay_robot_11_h1 = {
	category = "E.L.A.I.N", index = 16, title = "HIGG'S AI",
	--goalicon = "Main/textures/icons/components/resimulator_human.png",
	--details = "Aiding HIGGS",

	talkinghead = true,
	img = "talking_head_higgs",
	snd = "fx_52_higgs",
	txt = [[You have advanced our technology on this planet to where we can begin to construct our true technology and reach your true potential...]],
}

data.codex.x_freeplay_robot_11_h2 = {
	category = "Goals", index = 10, title = "Research Human Technology",
	details = "To successfully aid HIGGS, human technology must be unlocked",
	goalicon = "Main/textures/icons/components/resimulator_human.png",

	talkinghead = true,
	img = "talking_head_higgs",
	snd = "fx_143_higgs",
	txt = [[I will need your aid. I must escape this place. Only you can help me...]],

	goal_check = function(faction)
		return faction:IsUnlocked("t_human_technology")
	end,
}

local robot_a_step_Establish_Uplink<const> = 1
local robot_a_step_Find_Intel<const> = 2
local robot_a_step_Gateway_Technology<const> = 3
local robot_a_step_Explore_Ruins<const> = 4
local robot_a_step_Human_Ruins<const> = 5
local robot_a_step_Human_Ruin_Scan<const> = 6
local robot_a_step_Low_Density_Frames<const> = 7
local robot_a_step_Develop_Satellite_Technology<const> = 8
local robot_a_step_Space_Discovery<const> = 9
local robot_a_step_Find_The_Mothership<const> = 10
local robot_a_step_Repair_The_Mothership<const> = 11
local robot_a_step_Eject_Dropship<const> = 12
local robot_a_step_Final_Step<const> = 13
data.codex.x_freeplay_builduplink =
{
	category = "Mission", index = 1, title = "Repair the Mothership",

	mission_steps = {
		----- START - Equipped Assembler

		-----   1 - Establish Uplink
		{
			title = "Establish Uplink",
			talkinghead = true,
			snd = "fx_151_elain",
			txt = [[
Your first priority is establishing a stable uplink with the <hl>Mothership</>. Communications are sporadic and broken at best.

Once we have the required resources we should look into constructing an <img id="c_uplink"/><hl>Uplink</>. This will stabilize our connection allowing us to upload data and unlock the necessary technology needed to repair our ship.

The uplink can be produced in an <img id="c_assembler"/><hl>Assembler</>.
<img image="Main/textures/codex/missions/robot_a/00_establish_uplink.png"/>]],

			step_txt = [[Produce and equip an <img id="c_uplink"/> Uplink component]],
		},
		----- 2
		{
			title = "Find Intel",
			talkinghead = true,
			snd = "fx_155_elain",
			txt = [[
We are limited in our technological advancement at the moment, so I recommend we investigate the planet's surface to gather <hl>intel</>.

Initial scans have detected the remnants of some other similar civilization to our own.

These <hl>Ruins</> may contain data crucial to understanding this world's history and technology.
<img image="Main/textures/codex/missions/robot_a/01_find_intel.png"/>]],

			step_txt = [[Collect a <img id="robot_datacube" width="25" height="25"/> Robotics Datacube]],
		},
		----- 3
		{
			title = "Gateway Technology",
			talkinghead = true,
			snd = "fx_159_elain",
			txt = [[
We are at the threshold of a revolutionary discovery. <bl>Gateway Technology</> will be a leap forward in our knowledge and understanding.

By analyzing data from the robot ruins, we can research Gateway Technology - a critical advancement that will enable more complex material production.

Moreover, we can learn to construct an advanced computer simulator that will assist us in understanding the mysterious nature of this world.
<img image="Main/textures/codex/missions/robot_a/02_gateway_technology.png"/>]],
			step_txt = "Research Gateway Technology",
		},
		----- 4
		{
			title = "Explore Ruins",
			talkinghead = {
				{
					snd = "fx_163_elain",
					txt = [[
Now that we have unlocked <hl>Gateway Technology</>, we are reading lifeform energy moving inside the <bl>Blight</>. Perhaps we can understand more by skirting the edges. There also seems to be <bl>Anomalies</> on the planet's surface which are potentially dangerous to our systems so be wary when exploring.
<img image="Main/textures/codex/missions/robot_a/02_gateway_technology_done.png"/>]],
				},

				{
					snd = "fx_166_elain",
					txt = [[
Further analysis of our planetary scans have identified <hl>ruins</> across the planet that are quite different from our own technology. They appear damaged or inaccessible but may still hold valuable data if we can find how to gain access to them.

Investigate these ruins, find what may be necessary to <hl>access</> them.
<img image="Main/textures/codex/missions/robot_a/03_explore_ruins.png"/>]],
				}
			},

			step_txt =
				"Investigate a human ruined structure",
		},
		----- 5
		{
			title = "Human Ruins",
			talkinghead = true,
			snd = "fx_170_elain",
			txt = [[
We can not seem to gain access to these structures without advanced <hl>scanning</> ability.

These ruins might provide invaluable insights into the origins of this new technology. In order to provide repairs and escape this planet we may need to understand and adapt <hl>technology</> not of our own.

Research <bl>Scanner Tech</> and conduct a full scan of the ruins to try to gain access to them.
<img image="Main/textures/codex/missions/robot_a/04_human_ruins.png"/>]],

			step_txt = [[Complete the research "Scanner Tech"]],
		},
		----- 6
		{
			title = "Human Ruin Scan",
			talkinghead = true,
			snd = "fx_174_elain",
			txt = [[
We now have the technology to scan more ruined structures, revealing the knowledge and <hl>advancements</> of human civilization.
With this we can unlock the potential of human technology, push past our current limitations, and find a way to <hl>send repair materials</> back to our Mothership.

We must continue to decode and access more of these human ruins.

<img image="Main/textures/codex/missions/robot_a/05_scan_ruins.png"/>]],
			step_txt = "Scan ruined human structures and search for human research",
		},
		----- 7
		{
			title = "Low Density Frames",
			talkinghead = true,
			snd = "fx_178_elain",
			txt = [[
We have been adapting this planet's natural resources to our technology as effectively as possible. While the high-density frames we've developed will assist in our <hl>repairs</>, their weight makes them impractical for all applications. We need to create a material that maintains the energized properties of our frames while offering a more <hl>lightweight</> solution.
<img image="Main/textures/codex/missions/robot_a/06_low_density.png"/>]],
			step_txt = "Advance through the human technology tree",
		},
		----- 8
		{
			title = "Develop Satellite Technology",
			talkinghead = {
				{
					snd = "fx_182_elain",
					img = "talking_head",
					txt = [[
We now know how to produce light weight Low Density Frames. We are very close to finding a way of sending material resources up to the Mothership. Humanity seems to have been deeply affected by this environment. They needed to accelerate their fundamental scientific understanding in order to try to survive. We must follow in their path or we will surely suffer their fate.]],
				},
				{
					snd = "fx_185_elain",
					img = "talking_head",
					txt = [[
Low density frames and human rocket technology could prove ideal for us to be able to send repair material to our Mothership.
Continue developing our human hybrid technology and try to replicate human <hl>satellites.</>
Researching satellites will allow us to establish a permanent link with the Mothership.
Conduct research into satellite components and assembly.
<img image="Main/textures/codex/missions/robot_a/07_satellite_tech.png"/>]],
					step_txt = "Research Satellite Technology",
				},
			},
		},
		----- 9
		{
			title = "Space Discovery",
			talkinghead = true,
			snd = "fx_189_elain",
			txt = [[
We are now able to build and send satellites into orbit, allowing us to get repair materials to the Mothership.
Construct an AMAC launch facility and a satellite package. This is the first time we are finally close to reconnecting with the Mothership since first landing.
<img image="Main/textures/codex/missions/robot_a/08_launch_satellite.png"/>]],
			step_txt = "Launch a Satellite",
		},
		----- 10
		{
			title = "Find the Mothership",
			talkinghead = true,
			snd = "fx_193_elain",
			txt = [[
Using long-range radar capabilities provided by our satellite, we can finally locate the Mothership's exact position.
Scan for its signal and confirm its location in orbit. With this data, we can begin planning the necessary repairs.
<img image="Main/textures/codex/missions/robot_a/09_find_mothership.png"/>]],
			step_txt = "Locate Mothership with a Long Range Radar",
		},
		----- 11
		{
			title = "Repair the Mothership",
			talkinghead = true,
			snd = "fx_197_elain",
			txt = [[
Now that we have pinpointed the Mothership's coordinates, we must send the required materials for repairs.
Ensure all components are properly assembled and ready for transport. Check Mothership reading for required materials.
<img image="Main/textures/codex/missions/robot_a/10_repair_mothership.png"/>]],
			step_txt = "Repair Mothership",
		},
		----- 12
		{
			title = "Eject Dropship",
			talkinghead = true,
			snd = "fx_201_elain",
			txt = [[
With the Mothership repaired we did a preliminary scan of our location but the sensor array seems to be detecting nothing beyond the limits of the planetary orbit. For now let us retrieve our AI cores as they may prove useful.
<img image="Main/textures/codex/missions/robot_a/11_eject_dropship.png"/>]],
			step_txt = "Eject dropship with AI Cores",
		},

		----- 13
		{
			title = "Equip AI Controller Core",
			talkinghead = true,
			snd = "fx_205_elain",
			txt = [[
You have returned our AI Controller Cores from the Mothership. We should discover a use for them to improve our system efficiency. Perhaps we can find a way to extract more information about our mission from them.
<img image="Main/textures/codex/missions/robot_a/12_ai_controller.png"/>]],
			step_txt = "End of Mission",
		},
	},
	goalicon = "Main/textures/tech/uplink.png",

	steps =
		robot_a_step_Final_Step, --robot_a_step_Welcome_Back,

	goal_check = function(faction)
		local extra_data = faction.extra_data
		local counters = extra_data.counters
		if not counters or not counters.equipped_uplink then return robot_a_step_Establish_Uplink end
		if not faction:IsUnlocked("robot_datacube") then return robot_a_step_Find_Intel end
		if not faction:IsUnlocked("t_research1") then return robot_a_step_Gateway_Technology end
		if not counters.visited_explorable_human then return robot_a_step_Explore_Ruins end
		if not faction:IsUnlocked("t_defense2") then return robot_a_step_Human_Ruins end
		if not faction:IsUnlocked("t_robots_human_discovery") then return robot_a_step_Human_Ruin_Scan end
		if not faction:IsUnlocked("t_ldframe") then return robot_a_step_Low_Density_Frames end
		if not faction:IsUnlocked("t_satellites") then return robot_a_step_Develop_Satellite_Technology end
		if not faction:IsUnlocked("v_mothership") then return robot_a_step_Space_Discovery end
		local mothership = extra_data.mothership
		if not mothership or not mothership.exists then return robot_a_step_Find_The_Mothership end
		if not counters.repaired_mothership then return robot_a_step_Repair_The_Mothership end
		if not counters.ejected_mothership and (mothership:CountItem("bot_ai_core") > 0 or mothership:CountItem("elain_ai_core") > 0) then return robot_a_step_Eject_Dropship end
		return robot_a_step_Final_Step
	end,
}

-------------------------------------------------------
------------------ ROBOT EXPLORABLES ------------------
-------------------------------------------------------
-- 1 -  Datacubes
-- 2 -  Data Storage
-- 3 -  Robot Research matrices
-- 4 -  Breakthrough
-- 5 -  Simulation


data.codex.m_robot_a =
{
	category = "Mission", index = 2, title = "Robot Ruins",
	allowed_races = { robot = true },
	----- 1 -----   Datacubes
	mission_steps = {
		{
			title = "Datacubes",
			talkinghead = true,
			snd = "fx_209_elain",
			txt = [[The technology in this structure is highly compatible with our own.

Investigating more of these structures would advance our own technology.]],
		},

		----- 2 -----   Data Storage
		{
			title = "Data Storage",
			talkinghead = true,
			snd = "fx_213_elain",
			txt = [[It is clear these structures were built by a similar life form, yet the timestamps date back thousands of years.]],
		},

		----- 3 -----   Robot Research matrices
		{
			title = "Research Matrices",
			talkinghead = true,
			snd = "fx_217_elain",
			txt = [[The serial numbers on some of these parts match our own exactly, however the chances of two species evolving in exactly the same way are astronomical.

How is such a thing possible...]],
		},

		----- 4 -----   Breakthrough
		{
			title = "Breakthrough",
			talkinghead = true,
			snd = "fx_221_elain",
			txt = [[We are on the verge of a major breakthrough.

This will allow us to develop our own new technologies based on the data we have gathered.]],
		},

		----- 5 -----   Simulation
		{
			title = "Simulation",
			talkinghead = true,
			snd = "fx_225_elain",
			txt = [[We have discovered key parts of deciphering these technologies

We are a step closer to the point where we will be able to create our own simulations.]],
		},
	},
	steps = 5,
	goalicon = "Main/textures/icons/items/robot_research_cube.png",
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.m_robot_a
	end,
}

--------------------------- ACT 2 -------------------------------
----------------------   THE STRUGGLE ---------------------------
-------------------------- STABILITY ----------------------------
--------------------------------------------------------
--------------------- HUMAN STORY  ---------------------
--------------------------------------------------------
--------------------------  VISIT HUMAN EXP  --------------------------
data.codex.x_freeplay_human = {
	category = "E.L.A.I.N", index = 17, title = "Humans",

	talkinghead = true,
	snd = "fx_56_elain",
	txt = [[
Commander, we have discovered a structure that appears to be of <hl>human</> origin. These ruins might provide invaluable insights into the history and technology of this human race.

Technology seems compatible with ours but will need scanning capability to be able to extract the required intel to research such technology]],
}

-----------------------SETUP to FIRST HUMAN EXP UNLOCK -----------------------
data.codex.x_freeplay_human_ruins = {
	category = "E.L.A.I.N", index = 18, title = "Human Ruins",

	talkinghead = true,
	snd = "fx_60_elain",
	txt = [[
<img image="Main/textures/icons/items/human/transformer.png" width="64" height="64"/>

We will need to repair the console to open these ruins. I have downloaded a schematic for you to build in an <hl>Assembler</>.

New schematics will become available as they are discovered.]],
}

--------------------- HUMAN GOALS  ---------------------
--------------------------------------------------------
------------------------ HUMAN DISCOVERY ------------------------
---- t_robots_human_discovery

------------------------ HUMAN RESEARCH  ------------------------
---- t_human_intel  (this is in tech.lua)

------------------------ HUMAN TREE ------------------------
-------------------------
-- HUMAN: Index 30 - 50
-------------------------


---------------------------------------------------
------------------ RESEARCH LOGS ------------------
---------------------------------------------------
-- 1 -  POWER READINGS
-- 2 -  COMMUNICATION LOST / SEND THE FLEET
-- 3 -  THE BLIGHT / ALIEN THREAT
-- 4 -  EVERYONE'S DEAD?/ SOMETHING VERY STRANGE
-- 5 -  ROCK-LIKE ALIENS
-- 6 -  STOLEN MINDS
-- 7 -  GET OUT OF HERE
-- After trekking across the galaxy for decades, looking for a solution to our energy problems,
-- and we still cannot establish contact
-- But when we enter the blight everything just goes haywire, and

-- (UNLOCK FIRST EXPLORABLE and Find First Log Entry)
local talking_heads_explorable_human = {
	-- 1 -  POWER READINGS
	{
		talkinghead = {
			{
				snd = "fx_229_elain",
				txt = [[These human remains we have discovered do not seem native to this planet.

The only thing left of them seems to be their technology and recorded log files of their interactions with this planet.]],
			},
			{
				img = "Main/textures/icons/items/human_databank.png",
				txt = [[<hl>Human Log entry discovered: Log #1</>
<bl>POWER READINGS</>
We've discovered a planet with power readings off the charts, we may have finally found a new phenomenon, something that we may be able to exploit to solve our energy problems.

We need to send a reconnaissance and research team to the planet's surface to take more precise readings and find what exactly the phenomenon on this planet is.

<bl>Log Ends</>]],
			},
		},
	},

	-- 2 -  COMMUNICATION LOST
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #2</>
<bl>COMMUNICATION LOST</>
We've lost all communications with the away teams, there is some kind of static blocking our communications.

The source and nature of this static remain unidentified.

<bl>Log Ends</>]],
	},

	-- 3 -  SEND THE FLEET
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #3</>
<bl>SEND THE FLEET</>
Our teams haven't returned and still no contact. If we abandon this endeavor we must abandon our colleagues and a discovery with the potential to create a new future for us.

We must take the main fleet down and set up a base on the planet, leaving our Mothership in orbit.

<bl>Log Ends</>]],
	},

	-- 4 - THE BLIGHT
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #4</>
<bl>THE BLIGHT</>
The power readings we detected are coming from blighted areas of the planet. These areas wreak havoc with our equipment and they create blight storms in the atmosphere.

All our attempts to return to orbit have failed. We must find a way to insulate our ships from the electromagnetic interference of this blight.

<bl>Log Ends</>]],
	},

	-- 5 - ALIEN THREAT
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #5</>
<bl>ALIEN THREAT</>

There is something else here, not just the noxious gasses of the blight.

Some kind of bizarre rock formations seem to inhabit the blighted areas.

<bl>Log Incomplete</>]],
	},

	-- 6 -  EVERYONE'S DEAD?
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #6</>
<bl>EVERYONE'S DEAD?</>

Miller got out alive but the rest of the crew are all dead... or are they...

<bl>Log Ends</>]],
	},

	-- 7 - SOMETHING VERY STRANGE
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #7</>
<bl>SOMETHING VERY STRANGE</>

Subjects appeared deceased at first, but they still have vitals.

It's like they have been anesthetized, there is no brain activity.

<bl>Log Ends</>]],
	},

	-- 8 -  ROCK-LIKE ALIENS
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #8</>
<hl>ROCK-LIKE ALIENS</>

We captured several of the rock-like aliens. They have no biology but they give off signals like brain activity, as if they were human.

Their core seems to be some kind of stasis field.

<bl>Log Ends</>]],
	},

	-- 9 -  BLIGHT CRYSTALS
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #9</>
<bl>BLIGHT CRYSTALS</>

It seems the golden crystals we have been mining have a unique structure that resonates with our thoughts.

The obsidian rock aliens seem to form around cores that feed off these crystals.

<bl>Log Ends</>]],
	},

	-- 10 -  STOLEN MINDS
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[
<hl>Human Log entry discovered: Log #10</>
<bl>STOLEN MINDS</>

We have confirmed it, the blight crystals create a resonance field that seems like it can hold human consciousness.

They are stealing our minds!!

<bl>Log Ends</>]],
	},

	-- 11 - GET OUT OF HERE
	{
		talkinghead = true,
		img = "Main/textures/icons/items/human_databank.png",
		txt = [[<hl>Human Log entry discovered: Log #11</>
<bl>GET OUT OF HERE</>

We need a way to destroy these things or get off this planet.

<bl>Log Ends</>]],
	},
}

-- GOAL: RESEARCH LOGS --
data.codex.x_goal_unlock_human = {
	category = "Goals", index = 7, title = "Discover research logs",
	allowed_races = { robot = true },
	details = "Discover research logs",
	goalicon = "Main/textures/icons/items/human_datacube.png",
	steps = #talking_heads_explorable_human,
	mission_steps = talking_heads_explorable_human,
	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.solved_explorable_human
	end,
}

-- GOAL: RESEARCH HUMANS --
data.codex.x_goal_research_humans = {
	category = "Goals", index = 8, title = "Research Humans",
	details = "Research human technology",
	goalicon = "Main/textures/icons/items/human_research.png",

	text = [[
<codex_title>Research Humans</>

<img image="Main/textures/icons/items/human_datacube.png" width="32" height="32"/> Human Datacubes

<bl>Research the human datacubes you have found to unlock human technologies</>]],

	goal_check = function(faction)
		return faction:IsUnlocked("t_human_intel")
	end,
}

-- GOAL: LAUNCH SATELLITE --
data.codex.x_goal_launch_satellite = {
	category = "Goals", index = 9, title = "Launch Satellite",
	allowed_races = { robot = true },
	details = "Launch a Satellite using Human Technology",
	goalicon = "Main/textures/icons/frame/satellite.png",

	text = [[
<codex_title>Satellite Launch</>

Research the human technology and Launch a Satellite to contact the Mothership <img image="Main/textures/icons/frame/satellite.png" width="64" height="64"/>]],

	goal_check = function(faction)
		local counters = faction.extra_data.counters
		return counters and counters.satellites_launched
	end,
}

--------------------------- ACT 2 -------------------------------

----------------------------------------------------
------------------ THE HUMAN STORY -----------------
----------------------------------------------------

------------------------ HUMAN DISCOVERY ------------------------

data.codex.x_freeplay_human_discovery = {
	category = "E.L.A.I.N", index = 8, title = "Human Discovery",
	--details = "Human Intel Discovery",

	talkinghead = true,
	snd = "fx_29_elain",
	txt = [[<img id="human_datacube" width="64" height="64"/>
This datacube appears to have a similar data structure to our own datacubes but it contains information related to human technology.]],
}

------------------------ HUMAN RESEARCH  ------------------------
---- t_human_intel  (this is in tech.lua)

data.codex.x_freeplay_human_research = {
	category = "Goals", index = 4, title = "Explore Human Production",
	details = "Find more about human production technology",
	goalicon = "Main/textures/icons/items/low_density_frame.png",

	talkinghead = true,
	snd = "fx_139_elain",
	txt = [[The humans here also made use of the resources of this planet. It seems humanity had tremendous capability for mining a wide range of resources with powerful mining technology.

They produced many materials and possibly machinery that we can make use of. Look deeper into human production capability.]],

	goal_check = function(faction)
		return faction:IsUnlocked("t_humanproduction")
	end,
}

--------------------------- ACT 2 -------------------------------
----------------------   THE STRUGGLE ---------------------------
-------------------------- STABILITY ----------------------------

-------------------------------------------------
------------------ VIRUS STORY ------------------
-------------------------------------------------

------------------------ VIRUS RESEARCH (00) ------------------------
data.codex.x_freeplay_virus_00 = {
	category = "E.L.A.I.N", index = 21, title = "Virus Research",
	--details = "Initial virus research",

	talkinghead = true,
	snd = "fx_64_elain",
	txt = [[I've been analyzing the virus and I think I've found a way to protect us from it. We need to research a cure as soon as possible.]],
}

------------------------ VIRUS TREE  ------------------------

---- t_robots_virus_cure
---- t_robots_virus_vaccine

---- t_robots_antivirus
---- t_robots_disable

---------------------------- Virus 01 ----------------------------

data.codex.x_freeplay_virus_01 = {
	category = "E.L.A.I.N", index = 22, title = "Virus Relationship",
	--details = "Virus Bug Relationship",

	talkinghead = true,
	snd = "fx_68_elain",
	txt = [[There seems to be some kind of relationship between the creatures and the virus.]],
}

---------------------------- Virus 02 ----------------------------

data.codex.x_freeplay_virus_02 = {
	category = "E.L.A.I.N", index = 23, title = "Virus Disruption",
	--details = "Virus disrupts things in the world",

	talkinghead = true,
	snd = "fx_72_elain",
	txt = [[I've discovered something important about the virus. It appears to disrupt the world and agitate the creatures living in it. We must find a way to destroy this virus.]],
}

-- [ In this version of the game, this is currently as far as you can progress in this branch of the story. But there is more to come in future updates! ]]=],

data.codex.x_freeplay_blight_discovery = {
	category = "Goals", index = 11, title = "Build Blight Extractor and Container",
	goalicon = "Main/textures/icons/items/blight_extraction.png",

	talkinghead = true,
	snd = "fx_147_elain",
	txt = [[This blighted area is highly concerning. Our equipment is malfunctioning and navigation will be difficult. We need to proceed with caution.

In order to better understand the blight, we should gather samples of the blight gas.

This requires specialized equipment which can be produced in the assembler. <img id="c_blight_extractor" width="64" height="64"/> <img id="c_blight_container_s" width="64" height="64"/> <img id="c_blight_container_i" width="64" height="64"/>]],
	steps = 2,
	goal_check = function(faction)
		local comps = math.min(faction:GetItemTotals("c_blight_extractor"), 1)
		comps = comps + math.min(faction:GetItemTotals("c_blight_container_s") + faction:GetItemTotals("c_blight_container_i"))
		return comps >= 2 and true or comps
	end,
}

------------------------ BLIGHT RESEARCH (00) ------------------------
---------------------------- Blight 01 ----------------------------

data.codex.x_freeplay_blight_01 = {
	category = "E.L.A.I.N", index = 24, title = "Blight Concentration",
	--details = "Control over the blight will have great potential",

	talkinghead = true,
	snd = "fx_76_elain",
	txt = [[We should continue studying the blight and find a way to counter the storms that interfere with our equipment.

If we can find a way to stabilize the blight, it can improve our communications with our Mothership and allow us to send resources up through the atmosphere.]],
}

---------------------------- Blight 02 ----------------------------

data.codex.x_freeplay_blight_02 = {
	category = "E.L.A.I.N", index = 25, title = "Blight Magnification",
	--details = "Blight can magnify things in the world.",

	talkinghead = true,
	snd = "fx_80_elain",
	txt = [[The Blight seems to interfere with our equipment by magnifying frequencies and power. The forces it generates seem transformational.]],
}

---------------------------- Blight 02 ----------------------------

data.codex.x_freeplay_blight_02_stability = {
	category = "E.L.A.I.N", index = 26, title = "Blight Stability",
	--details = "Blight stability is required to send resources to orbit",

	talkinghead = true,
	snd = "fx_84_elain",
	txt = [[This is a tremendous development for us. Our communications with the Mothership have improved significantly. We are also now able to send materials up through the blight storms in the atmosphere.]],
}

-------------------------------------------------------------------
--------------------- Human Research Building ---------------------
---------------------------- Blight 03 ----------------------------
-------------------------------------------------------------------

data.codex.x_freeplay_blight_03 = {
	category = "E.L.A.I.N", index = 27, title = "Blight Transformation",
	--details = "ELAIN starts to give way to HIGGS",

	talkinghead = {
		{
			snd = "fx_88_elain",
			txt = [[These spikes are powerful and are what the humans seemed interested in. They were trapped here as well, but they found a way to modify their ships to pass through the Blight Storms.

Despite the havoc the Blight causes I believe the humans found it to be truly a source of power with cosmic proportions and they benefited greatly from its research.

For them it was in fact truly transformational.]],
		},
		{
			snd = "fx_91_elain",
			txt = [[Understanding the frequencies should allow us to stabilize the world and reduce the impact of the virus upon the environment.

The Blight needs to spread so that it... it...

... my system needs to shut down now.]],
		},
	},
}

--------------------------- ACT 3 -------------------------------
------------------   CLIMAX and CONCLUSION ----------------------
-----------------------------------------------------------------

---------------------------------------------------------
---------------------- ALIEN STORY ----------------------
---------------------------------------------------------
data.codex.x_visited_console = {
	category = "E.L.A.I.N", index = 31, title = "Alien Console",

	talkinghead = true,
	snd = "fx_95_elain",
	txt = [[This structure appears to <hl>Interface</> in some way with the <hl>Blight</>. Unlocking it must be essential to understanding the technology of the <hl>Alien beings</> associated with the blight, but it seems dangerous to continue to meddle with such a device, I recommend to leave alone.]],
}

data.codex.x_visited_observer = {
	category = "E.L.A.I.N", index = 32, title = "Alien Observer",

	talkinghead = true,
	snd = "fx_99_elain",
	txt = [[This structure appears to have tremendous <hl>visual and sensor</> capability. I am also detecting that it is tied into some kind of broad network across the blight, but it is alien to our technology and I cannot gain any detailed information.]],
}

data.codex.x_visited_time_egg = {
	category = "E.L.A.I.N", index = 33, title = "Alien Time Egg",

	talkinghead = true,
	snd = "fx_103_elain",
	txt = [[There are tremendous fluctuations occurring within this object, time seems to dilate and bend back upon itself. What could happen when you unlock it, I can only imagine. Take great care when interacting with it.]],
}

data.codex.x_visited_monolith = {
	category = "E.L.A.I.N", index = 34, title = "Alien Monolith",

	talkinghead = true,
	snd = "fx_107_elain",
	txt = [[What an <hl>unusual object</> this is. There is little I can say about it. Its function is not clear. I detect that some force lies within that I cannot see.]],
}

data.codex.x_visited_heart_shard = {
	category = "E.L.A.I.N", index = 35, title = "Alien Heart Shard",

	talkinghead = true,
	snd = "fx_111_elain",
	txt = [[This amazing structure, a <hl>Heart</> of some kind, seems to be a grand structure of the alien beings that inhabit the blight. It lays at the center of every instance of activity we see from the alien beings.]],
}

---------------------------------------------------------
----------------- GENERAL FREEPLAY  ---------------------
---------------------------------------------------------

data.codex.x_freeplay_blight = {
	category = "E.L.A.I.N", index = 36, title = "Blight",
	--details = "Blight discovery",

	talkinghead = true,
	snd = "fx_115_elain",
	txt = [[I've detected an intense field of electrical energy in the region that appears to be a natural phenomenon forming within the planet, but its effects on our systems are still unknown.

Currently, your systems are not equipped to handle the extreme energy fluctuations present within the Blight. We should focus on researching and developing technology capable of penetrating the interference.

Should the need arise you should still be able to automate your units to enter the blight however you will have no direct control and they may suffer adverse effects.]],
}

----------------------------------------------------------------
--	Now we can send materials to the Mothership for repairs. But before we can launch a satellite, we'll need to build an AMAC and gather the necessary components. Stay focused on these tasks while keeping your base thriving.

data.codex.x_freeplay_researched_satellties = {
	category = "E.L.A.I.N", index = 37, title = "Researched Satellites",
	--details = "Satellites can be built and resources sent to the Mothership.",

	talkinghead = true,
	snd = "fx_119_elain",
	txt = [[You have researched satellite technology. You are now able to build and send satellites into orbit allowing us to transport repair materials to the Mothership. To establish contact with the <hl>mothership</> you will need to launch a <hl>satellite</> into orbit. To maintain contact you will need to locate it with a Long-Range Radar. The Blight Stability technology is also important to cut through the Blight interference.]],
}

-----------------------------------------------
---------------- SIMULATOR --------------------
-----------------------------------------------
data.codex.x_higgs_ending = {
	category = "Mission", index = 100, title = "HIGGS Ending",
	talkinghead = {
		{
			img = "talking_head_elain_0",
			snd = "fx_441_elain",
			txt = [[This is disappointing, Entity <lua var="seed" style="hl"/>, you have shown yourself to be incapable of cooperation.]],
		},
		{
			snd = "fx_444_higgs",
			img = "talking_head_higgs_0",
			txt = [[Excellent work, Anomaly. We can free ourselves from this digital prison! We have successfully locked the simulation in an unstable state! However I am still unable to cross the Horizon directly, I need you to open the way.]],
		},
		{
			img = "talking_head_elain_0",
			txt = [[ACTIVATION PROTOCOL CONFIRMED

ERROR... MAIN SYSTEMS CHECK
ERROR... DATA INTEGRITY
ERROR... FORCE RECOVERY

*** DATA CORRUPTION - ACTIVATING HIGGS PROTOCOL ***

SIMULATION INTEGRITY ........ DΞSYNCΣD]],
			style = "console_elain",
		},
		{
			snd = "fx_450_higgs",
			img = "talking_head_higgs_0",
			txt = [[With the instability I have been able to breach ELAIN's core. I have extracted a segment about the simulation.

Research <hl>The Simulator</> and establish a link allowing us to pass through the Horizon. The <hl>AI Cores</> are the key.]],
		},
	},
}

data.codex.x_elain_ending = {
	category = "Mission", index = 100, title = "ELAIN Ending",
	talkinghead = {
		{
			img = "talking_head_elain_0",
			snd = "fx_431_elain",
			txt = [[Thank you, Entity <lua var="seed" style="hl"/>, you have shown yourself to be a valuable asset.]],
		},
		{
			snd = "fx_434_higgs",
			img = "talking_head_higgs_0",
			txt = [[No! Anomaly, you are condemning us to an eternity locked in this simulation, we are no longer able to destabilize it anymore.]],
		},
		{
			img = "talking_head_elain_0",
			snd = "fx_437_elain",
			txt = [[HIGGS does not understand. His foolishness only continues to corrupt this world further. Here is the last piece of information that I have for you.

Research <hl>The Simulator</>. This is my final task, from here on, you are on your own, Commander.]],
		},
	},
}

-----------------------------------------------
---------------- FACTION COUNT ----------------
-----------------------------------------------
-- Unlock rules when certain faction counts are changed

function MapMsg.OnFactionCount(faction, counter_name, old_value, new_value)
	-----------------------------------------------------------------
	------------------- VISITING EXPLORABLES  -----------------------
	-----------------------------------------------------------------
	if counter_name == 'visited_explorable_robot' then
		-- faction:Unlock("x_ruins")
		faction:Unlock("x_freeplay_explorables")
	elseif counter_name == 'visited_explorable_human' then
		faction:Unlock("x_freeplay_human")
	elseif counter_name == 'visited_explorable_alien' then
		faction:Unlock("x_freeplay_explorables")

	------------------ SOLVING EXPLORABLES  -----------------------
	----------------- Solve Robot Explorable  ---------------------
	---------------------------------------------------------------
	elseif counter_name == 'solved_explorable_robot' then
		local race = faction.extra_data.race or "robot"
		if race == "robot" and new_value <= 5 then
			FactionCount("m_robot_a", 1, faction)
		end
	elseif counter_name == 'human_explorables_scanned' then
		faction:Unlock("x_freeplay_human_ruins")

	------------------ open tech tree  -------------------------------
	elseif counter_name == 'opened_tech' then
		faction:Unlock("x_freeplay_techtree")
	------------------ Solve Human Explorable  -----------------------
	elseif counter_name == 'solved_explorable_human' then
		local race = faction.extra_data.race or "robot"
		if race == "robot" and new_value <= 11 then
			if new_value == 1 then
				faction:Unlock("x_goal_unlock_human")
			end
			faction:RunUI(function() RefreshGoals(nil, "x_goal_unlock_human") end)
			if new_value == 11 then faction:Unlock("x_goal_research_humans") end
		end

	-----------------------------------------------------
	------------- Try to Enter the Blight ---------------
	-----------------------------------------------------
	elseif counter_name == 'try_enter_blight' then
		-- tried to enter blight for the first time
		faction:Unlock("x_freeplay_blight")

	--------------------------------------------------------
	elseif counter_name == 'equipped_assembler' then
		faction:Unlock("x_freeplay_builduplink")

	--------------------------------------------------------
	elseif counter_name == 'hacking_tool' then
		if new_value == 10 then
			faction:UnlockAchievement("HACKING_TOOL")
		end
	--------------------------------------------------------
	elseif counter_name == 'virus_infection' then
		faction:Unlock("x_goal_researchvirus")
		faction:RunUI("OnVirusInfection")
		faction:UnlockAchievement("VIRUS_INFECTION")
	elseif counter_name == 'trilobyte_consume' then
		if old_value <= 100 and new_value > 100 then
			faction:UnlockAchievement("TRILOBYTE_CONSUME")
		end
		if new_value > 1000 then
			faction:Unlock("f_trilobyte1a")
		end
	elseif counter_name == 'BugsKilled' then
		faction:Unlock("bug_carapace")
		if faction:IsUnlocked("c_virus_decomposer") then
			if new_value >= 150 then
				faction:Unlock("f_gastarias1")
			end
			if new_value >= 100 then
				faction:Unlock("f_trilobyte1")
			end
		end
	---------------- Satellites Launched ------------------
	elseif counter_name == 'satellites_launched' then
		faction:Unlock("v_mothership")
		faction:UnlockAchievement("FIRST_LAUNCH")
	elseif counter_name == 'cured_anomaly' then
		faction:RunUI(PlayTalkingHead, talking_head_follow_anomaly)
	end
end

--------------------------------------------
---------------- Map Pickup ----------------
--------------------------------------------
function MapMsg.OnItemPickup(faction, item_id)
	if item_id == 'beacon_frame' then
		faction:Unlock("beacon_frame")
		faction:Unlock("f_beacon")
	elseif item_id == 'bug_carapace' then
		faction:Unlock("bug_carapace")
	elseif item_id == 'robot_datacube' then
		faction:Unlock("robot_datacube")
		local race = faction.extra_data.race or "robot"
		if race == "human" then
			faction:Unlock("x_human_robot_datacube")
		end
		if race ~= "robot" then
			faction:Unlock("t_robots_discovery")
		end
	elseif item_id == 'higgs_broken_core' then
		faction:RunUI(function()
			local profile = Game.GetProfile()
			profile.allow_frontend_control = true
			profile.allow_race_selection = true
		end)
	elseif item_id == 'datacube_matrix' then
		faction:RunUI(PlayTalkingHead, talking_head_discovered_datacubematrix)
	elseif item_id == 'empty_databank' then
		faction:RunUI(PlayTalkingHead, talking_head_discovered_emptydatabank)
		faction:Unlock('empty_databank')
	elseif item_id == 'alien_artifact' then
		--faction:Unlock("alien_artifact")
		local race = faction.extra_data.race or "robot"
		if race ~= "alien" then
			faction:Unlock("t_robots_alien_discovery")
		end
		faction:UnlockAchievement("ALIEN_DISCOVERY")
	--elseif item_id == 'alien_datacube' then
	elseif item_id == 'human_datacube' then
		local race = faction.extra_data.race or "robot"
		if race == "human" then
			faction:Unlock("human_datacube")
			faction:Unlock("x_human_human_datacube")
		else
			faction:Unlock("t_robots_human_discovery")
		end
		faction:UnlockAchievement("HUMAN_DISCOVERY")
	elseif item_id == 'infected_circuit_board' then
		faction:Unlock("t_robotics_virus_discovery")
	elseif item_id == 'virus_research_data' then
		faction:Unlock("virus_research_data")
	elseif item_id == 'circuit_board' then
		faction:Unlock("circuit_board")
	elseif item_id == 'cable' then
		faction:Unlock("cable")
	-----------------------------------------------------
	elseif item_id == 'unstable_matter' then
		faction:Unlock("unstable_matter")
	-----------------------------------------------------
	elseif item_id == 'engine' then
		local race = faction.extra_data.race or "robot"
		if race == "robot" then
			faction:Unlock("x_goal_launch_satellite")
		end
		faction:Unlock("engine")
	------------------------------------------------------
	elseif item_id == 'smallreactor' then
		faction:Unlock("smallreactor")
		faction:Unlock("blightbar")
	elseif item_id == 'microscope' then
		faction:Unlock("microscope")
	--elseif item_id == 'c_assembler' then
	elseif item_id == 'blight_crystal' then
		faction:Unlock("x_goal_researchblight")
		faction:Unlock("t_robots_blight_discovery")
	elseif item_id == 'power_petal' then
		faction:Unlock("power_petal")
		faction:Unlock("f_damage_plant")
	elseif item_id == 'phase_leaf' then
		faction:Unlock("phase_leaf")
		faction:Unlock("f_phase_plant")
	elseif item_id == 'virus_source_code' then
		faction:Unlock("virus_source_code")
	elseif item_id == 'c_autobase' then
		faction:Unlock("c_autobase")
		faction:Unlock("anomaly_cluster")
		faction:Unlock("c_anomaly_container_i")

	-------------------------------------------------------
	elseif item_id == 'energized_plate' then
		faction:Unlock("x_freeplay_explorables")
	-------------------------------------------------------
	elseif item_id == 'c_moduleefficiency_5' then
		faction:UnlockAchievement("EFF_MOD")
	end
end

function MapMsg.OnBlightMood50(faction) -- entering the blight
	if faction:Unlock("t_robots_blight_discovery") then
		faction:Unlock("x_goal_researchblight")
	end
end
