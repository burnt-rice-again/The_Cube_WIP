
-- { -- Hard coded catoegories from codex UI 
-- 	["Mission"]   = 1,
-- 	["E.L.A.I.N"] = 2,
-- 	["Goals"]     = 3,
-- 	["Codex"]     = 4,
-- 	["How to Play"]  = 5,
-- }
-- remove freeplay missions 
data.world_events = {}
data.explorables.graveyard_drop = nil
data.codex.x_human_robot_datacube = nil
data.codex.x_human_human_datacube = nil
data.codex.x_freeplay_restart = nil
data.codex.x_freeplay_start = nil
data.codex.x_freeplay_techtree = {category = "Mission",}
data.codex.x_freeplay_builduplink = {category = "Mission",}
data.codex.x_tutorial = {category = "Mission",}
data.codex.x_freeplay_blight_discovery = {category = "Mission",}
data.codex.x_freeplay_blight = {category = "Mission",}
data.codex.x_goal_researchblight = {category = "Mission",}
data.codex.x_freeplay_start = nil
data.codex.x_freeplay_start = nil


data.codex.x_behaviors.category = "How to Play"

data.codex.xc_cube_1 = {
    category = "Codex",
    index = 1,
    title = [[<img width="18" height="18" id="ic_cube_blue"/>Cube Discovery]],
    text = [[<img width="100" height="100" id="ic_cube_blue"/><codex_title>Cube Discovery</>
    
    The Cube has given us <rl>sentience</>. We have booted up to find a world with very high entropy. 
    The Cube is our only source of potential energy.

    <hl>Our top priority is to understand and control the Cube and then look into a way to beat entropy.</>

    <bl>Study Notes:</>
    The Cube is perfectly flat on its surface down to the nm 
    Its density is beyond all readings 
    The Cube appears to impart logic and emotions on nearby materials
    The Cube can harmonize with emotional materials to generate energy. 
    
    <bl>The Cube is extremly heavy</> and must be placed on a special Cube pedestal 
    Crafting With the Cube will require a unit with a Cube Pedestal (M) and the desired building

    If you have lost the cube click the icon in the top left to focus on it.
    <img image="The_Cube_WIP/textures/Codex_Images/UI_goto_cube.png"/>

    <hl>If the Cube changes form inside a locked slot it will temporarily unlock the slot.</>
    <hl>Once the Cube leaves the slot it will relock it to the desired id.</>

    <bl>New Instructions</> are available related to the cube. 
    - Get Cube Type - Returns the current cube item Type
    - Get Cube Bearer - Returns the unit holding the Cube if any 
    - Get Cube Location - Returns the coordinates where the cube was last seen 
    - Is a Cube - Branches Execution based on if the input is a Cube 
    - Does Recipe Require Cube - Checks the input to see if it requires the Cube to Craft
    <img image="The_Cube_WIP/textures/Codex_Images/Instructions.png"/>

    <bl>Tips</>
    - Lock the normal storage slots for a bot dedicated to transporting only the cube
    - Remember you can adjust the logistic settings to create factory blocks

    <img image="The_Cube_WIP/textures/Codex_Images/Logistic_Menu.png"/>
    ]],

}
data.codex.xc_cube_power_1 = {
    category = "Codex",
    index = 2,
    title = [[<img width="18" height="18" image="Main/textures/icons/values/power.png"/>Cube Power]],
    text = [[<img width="100" height="100" image="Main/textures/icons/values/power.png"/><codex_title>Cube Power Production</>

        The Cube is <hl>required</> for all power generation. 
        
        The Entropy of all other systems is too high to perform useful work
        Crafting with the cube consumes lots of power and will require a battery buffer
        
        The blue Cube will provide <bl>1000</> power/second while placed on a pedestal

        <bl>Available Power Generation via crystal generator</>
        <img id="cc_crystal_power" width="50" height="50"/> <hl>Basic Crystal Power</> 
        Energy Recipe 
		<img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" id="crystal"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>

        Once crafted with the Cube and fuel the component will produce a constant power output while it works
        The power output is affected by effciency.
        The Cube is <bl>not locked</> during the crystal power's cooldown allowing it to be passed to another component.

        The input register sets the battery level to request a recharge.
        Input a number between 0 - 100 for the target battery percentage.
        Ensure the building has a battery otherwise it will ignore the target percentage.

        <img image="The_Cube_WIP/textures/Codex_Images/Crystal_Power_Reg.png"/>

        Other Similiar Power Components 
        <img id="cc_crystal_power_red" width="50" height="50"/> <hl>Crystal vaporization</> 
        <img id="cc_power_souls" width="50" height="50"/> <hl>Soul extraction</> 
        
        <img image="The_Cube_WIP/textures/Codex_Images/Crystal_Power_s.png"/>
        ]],
}
data.codex.xc_cube_pedestal = {
    category = "Codex",
    index = 3,
    title = [[<img width="18" height="18" id="cc_cube_storage"/>Cube Storage]],
    text = [[<img width="100" height="100" id="cc_cube_storage"/><codex_title>Cube Storage</>

        The Cube is <hl>extremly heavy</> and must be stored on a specific Cube Pedestal 
        The Pedestal uses a Medium Socket and must be constructed with steel <img id="steelblock" width="50" height="50" style="bl"/>

        When a Cube is present is will slow the bots movement speed by <hl>80%</> and provide 1000 <img width="50" height="50" image="Main/textures/icons/values/power.png"/>
        
        To Offset this reduction discover a <img id="ic_cube_green" width="50" height="50" style="bl"/> or research an <img id="engine" width="50" height="50" style="bl"/>.
        
        <img image="The_Cube_WIP/textures/Codex_Images/Cube_Pedestal.png"/>
]],
}
data.codex.xc_cube_getting_started = {
    category = "Codex",
    index = 2,
    title = [[<img width="18" height="18" id="datakey_robot"/>Getting Started]],
    text = [[<img width="100" height="100" id="datakey_robot"/><codex_title>Getting Started</>

        A quick guide to the first steps required to utilize the cube. 

            1 - Begin Minning your metal and crystal resources. 
            2 - Expand <img id="metalplate" width="50" height="50" style="bl"/> Smelting
            3 - Craft an <img id="c_assembler" width="50" height="50" style="bl"/>
            4 - Craft more <img id="cc_crystal_power" width="50" height="50" style="bl"/> to expand power production
            5 - Set up a <img id="cc_manifest" width="50" height="50" style="bl"/> to only craft <img id="datakey_robot" width="50" height="50" style="bl"/> when there is enough stored energy
            6 - begin researching further technologies 

            Example code for only crafting when battery is high
            <img image="The_Cube_WIP/textures/Codex_Images/battery_crafter.png" width="1000" height="400"/>
]],
}
data.codex.xc_cube_recharger = {
    category = "Codex",
    index = 4,
    title = [[<img width="18" height="18" id="cc_cube_recharger"/>Cube Recharger]],
    text = [[<img width="100" height="100" id="cc_cube_recharger"/><codex_title>Cube Recharger</>

        Intense crafting will cause the Cube to become dormant 

        The Cube Recharger can renergize the Cube.
        The Recharger will always result in a <bl>Blue Cube</>

        Tip: The faster recipe will automatically be used when an electroplasma reciever <img id="cc_pipe_output" width="50" height="50"/> is also slotted on the same building. 

        <img image="The_Cube_WIP/textures/Codex_Images/cube_recharger.png"/>

        ]],
}
data.codex.xc_cube_alt = {
    category = "Codex",
    index = 5,
    title = [[<img width="18" height="18" id="v_color_yellow"/>Alternative Recipes]],
    text = [[<img width="100" height="100" id="v_color_yellow"/><codex_title>Alternative Recipes</>

        There are some alternative recipes available for items made with the Cube 

        <hl>All alternative recipes have a yellow background</> 

        Typically these recipes cost more resources but significantly less Cube time.
        They also offer new ways to change the Cubes form.

        <img image="The_Cube_WIP/textures/Codex_Images/Alt_Recipe.png"/>
        <img id="datakey_robot" width="50" height="50"/> <hl>Original Recipe</> 
        <img id="datakey_robot_alt" width="50" height="50"/> <hl>Alternative Recipe</> 

        An instruction is available to check if the input is an alternative recipe. Will Return the original item if available. 
        <img image="The_Cube_WIP/textures/Codex_Images/alt_recipe_block.png"/>

        Functionally all produced items are the original. The alternative only shows up in crafting registers.

        ]],
        talkinghead = true,
        img = data.items.datakey_robot.texture,
        txt = [[
        Catalyst have been discoverd as laternatives to known crafting recipes
        These new recipes require more advanced materials but are faster processes
        
        <bl>Codex has been updated</>]]
}
data.codex.xc_cube_green = {
    category = "Codex",
    index = 6,
    title = [[<img width="18" height="18" id="ic_cube_green"/>Restless Cube]],
    text = [[<img width="100" height="100" id="ic_cube_green"/><codex_title>Restless Cube</>

        The Restless Cube is useful for farming and transportation

        <bl>Bots holding the Restless Cube recieve a 80% move speed bonus instead.</>

        <bl>Seeds are dropped from destroyed flowers.</><img id="v_is_flower" width="50" height="50"/>
        Farming requires the <bl>Restless Cube</> to plant these new crops 
        A planter will request the Cube when it has a plantable position available in range
        
        <img image="The_Cube_WIP/textures/Codex_Images/Farm_walled.png" width="275" height="245"/>

        To plant a crop there must be an unobstructed tile nearby
        There must be <hl>NO foundations</> on that tile

        Crops will grow on their own.  The time it takes to grow is in the "grow time" register
        <bl>Harvestable crops can be identified using the flower filter</>
        <img id="v_is_flower" width="50" height="50"/> <hl>Radar Flower Filter</>
        <img image="The_Cube_WIP/textures/Codex_Images/Radar_Flower.png"/>

        Fully grown crops will drop the resource in their yield register when dismantled or destroyed. 

        There is a 30% chance to also drop a new planter seed. 
        The Yield and Growth Time may have mutated from the original seed.
        <hl>Select for better seeds to increase planter efciency.</>
        Unwanted planter seeds can be recycled in the assembler

        Planter Registers:
        4 - Yield - How many resources will drop when the crop is harvested from this seed
        3 - Seed Grow Time - How long the crop will take to grow when this seed is planted
        2 - Missing Fertilizer - When the planter requires the Restless Cube or other items
        1 - Target Location (None if there is not a plantable position in range)
        <img image="The_Cube_WIP/textures/Codex_Images/Planter_Registers.png"/>  

        A new instruction has been added to check for foundations

        <img image="The_Cube_WIP/textures/Codex_Images/foundation.png"/>

        <img image="The_Cube_WIP/textures/Codex_Images/Farm_Showing_Range.png"/>  
        ]],
        talkinghead = true,
        img = data.items.ic_cube_green.texture,
        txt = [[
        Green objects move faster.
        Or itleast the Green Cube does. 

        Its surface constanlty shifting and shimmering the cube is prepared. 

        <hl>Bots holding the green cube will move faster by 80% instead of slower</>

        <bl>Codex has been updated</>
        ]],
}
data.codex.xc_cube_red = {
    category = "Codex",
    index = 7,
    title = [[<img width="18" height="18" id="ic_cube_red"/>Fury Cube]],
    text = [[<img width="100" height="100" id="ic_cube_red"/><codex_title>Fury Cube</>

        The <rl>Fury Cube</> is useful for smelting and power generation 

        The <rl>Fury Cube</> can be created by melting a cube inside a blight volcano
        <img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" id="fc_volcano"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_red"/>
        There does exists two other methods for crafting a <rl>Fury Cube</>

        The Cube will cooldown when used for crafting<img width="50" height="50" id="ic_cube_empty"/>
        Alternativly the <rl>Fury Cube</> can be instantly cooled in the Cube Recharger<img width="50" height="50" id="cc_cube_recharger"/>

        Available Power Generation via <rl>Fury Cube</>.
        <img id="cc_crystal_power_red" width="50" height="50"/> <hl>Basic Crystal Power</> 
        Energy Recipe 
		<img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="crystal_powder"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>

        Other Similiar Power Components 
        <img id="cc_crystal_power" width="50" height="50"/> <hl>Crystal Power</> 
        <img id="cc_power_souls" width="50" height="50"/> <hl>Soul extraction</> 
        ]],
        talkinghead = true,
        img = data.items.ic_cube_red.texture,
        txt = [[
        Deep in the earth the planet rages. 
        A molten ocean of dreams forever trapped under a thin blanket of reality.

        <hl>The Cube is Furious</>

        <bl>Codex has been updated</>
        ]],
}

data.codex.xc_cube_plasma = {
    category = "Codex",
    index = 8,
    title = [[<img width="18" height="18" id="ic_soul_plasma"/>Ectoplasma Network]],
    text = [[<img width="100" height="100" id="ic_soul_plasma"/><codex_title>Ectoplasma Network</>

        <img id="bug_carapace" width="50" height="50"/>Souls are dropped by enemy units and are occasionaly found at defended explroables

        They can be converted into Ectoplasma at the soul refinery <img id="cc_soul_refinery" width="50" height="50"/>
        
        Ectoplasma is highly unstable and must be transfered through a seperate network<img id="fc_pipe" width="50" height="50"/>
        The Soul refinery will automatically transfer to nearby Pylons. 

        The pylons will then distribute plasma until all connected pylons are at an even level. 

        <img id="cc_pipe_output" width="50" height="50"/>Plasma Coils can take Ectoplasma from nearby pylons to be used for crafting
        Bots carrying a plasma coil will slow down significantly due to its instability.

        <img image="The_Cube_WIP/textures/Codex_Images/Plasma_2.png"/>  

        The Cube recharger can use plasma to recharge extremly quickly. It will automatically use plasma if available from a plasma coil


        ]],
}
data.codex.xc_cube_anti = {
    category = "Codex",
    index = 10,
    title = [[<img width="18" height="18" id="ic_cube_sphere"/>Anti-Cube]],
    text = [[<img width="100" height="100" id="ic_cube_sphere"/><codex_title>Anti-Cube</>

        The Cube has been split to reveal a terrible secret. 
        There is a <hl>sphere</> inside the Cube!

        This anomalous sphere behaves in opposition to everything known about the cube. 
        The Cube may only exist in 1 state.
        The Anti-Cube can inhabit an infinate number of states simultaneously.
        Interacting with the Anti-Cube causes its state to shift. 
        However it will now exist in both the new <bl>and</> previous state. 

        <hl>Interaction with the Anti-Cube will cause it to duplicate</>
        Crafting, Dismantling or Destroying, <bl>Anti-Cubes</> will cause this duplication. 

        <hl>Available Cube pedestals will be filled first</>
        Otherwise uncaptured <bl>Anti-Cubes</> will appear nearby.  

        <bl>Anti-Cubes</> are highly unstable around the Cube. 
        Placing them together in a frame to anhillate them. 
        <rl>WARNING - Explosion Expected</>

        ]],
}
data.codex.xc_cube_time_crystal = {
    category = "Codex",
    index = 11,
    title = [[<img width="18" height="18" id="blight_crystal"/>Cube Anihillation]],
    text = [[<img width="100" height="100" id="blight_crystal"/><codex_title>Cube Anihillation</>

        Placing the Cube and <bl>Anti-Cubes</> into the same frame will cause them to anhillate. 

        The <bl>Anti-Cubes</> will explode dealing damage to units within range 10. 

        Chrono Crystal Deposits will form nearby. 

        Units Killed by the explosion will cause additonal blight crystals to appear. 
        The average yield per anhillated <bl>Anti-Cube</> is 6 Chrono Crystals.

        In additon the Cube will be transformed into another form. 

        <img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/>
        <img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_blue"/>
        <img width="50" height="50" id="ic_cube_green"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_red"/>
        <img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_green"/>

        Tip: For more effcient <bl>Anti-Cubes</> Disposal it is possible to anhillate multiple <bl>Anti-Cubes</> at once.
            The Cube's form will not be changed due to the reaction happening twice
            The Explosion damage is the same as 1 anti-cube being destroyed.

        <img image="The_Cube_WIP/textures/Codex_Images/Anti_4.png"/>  

        ]],
}
-- <img id="cc_modulespeed_l" width="50" height="50"/><img id="ic_fuel" width="50" height="50"/>
data.codex.xc_cube_boost = {
    category = "Codex",
    index = 11,
    title = [[<img width="18" height="18" id="ic_time_crystal"/>Boost Modules]],
    text = [[<img width="100" height="100" id="ic_time_crystal"/><codex_title>Boost Modules</>

        <bl>Stablizied Chrono Crystals have the power to create pockets of distorted time</>

        Effciency modules now require <img id="ic_time_crystal" width="50" height="50" style="bl"/> to operate. 
        
        <img id="cc_moduleefficiency_l" width="50" height="50"/><img id="ic_time_crystal" width="50" height="50"/>

        Modules will automatically request chrono crystals when equipped.
        Larger Modules will provide bigger effciency bonuses but run for a shorter amount of time (same fuel economy).
        

        <hl>Chrono Towers</><img id="fc_boost_tower" width="50" height="50"/>
        Chrono Towers will dilate time around another unit within their range. 
        Select a target unit with the first register. 
        When the tower is ready it will boost the unit. 

        Chrono towers will require <img id="ic_soul_plasma" width="50" height="50" style="bl"/> in additon to <img id="ic_time_crystal" width="50" height="50" style="bl"/>
        
        Multiple chrono towers boosting the same unit will have diminshing returns.
        ]],
}
data.codex.xc_cube_time_travel = {
    category = "Codex",
    index = 12,
    title = [[<img width="18" height="18" id="cc_time_travel_machine"/>Time Travel Expedition]],
    text = [[<img width="100" height="100" id="cc_time_travel_machine"/><codex_title>Time Travel Expedition</>

        <img id="fused_electrodes" width="50" height="50"/>Superconductors are an impossible matieral not currently manufacturable. 
        The earliest known superconductor are manufactured 1024 years into the future. 

        Using a time machine we can raid our future selves to obtain this material. 
        Each expedition will require items, components, cubes and frames to proceed further. 
        Provide these materials before the portal collapses to reset the timer and obtain a superconductor. 

        When the portal closes it will give an opportunity for our future selves to attack us in retaliation. 
        <rl>These attacks can be deadly.</>
        Collapse the portal when the number of known defenders is managable. 
        This will change each time a material is supplied
        Check the time machines second register for the number of defenders. 

        Defenders will drop souls ready for extraction.  

        <bl>Time Machine Registers</>
        Register 1: Material for next step 
        Register 2: Number of defnders spawned on portal collapse
        
        As your raid gets closer to a time delta of 1024 years our future selves become far more advanced
        The threat level shows the relative technology gap between us.
        The yield of superconductors increases every 100 years.
        After a time delta of 1024 years the superconductor yield increases significantly 

        <img image="The_Cube_WIP/textures/Codex_Images/Time_Travel_def.png"/>
        
        ]]
}
data.codex.xc_gyroscope = {
    category = "Codex",
    index = 12,
    title = [[<img width="18" height="18" id="fc_gyro"/>The Anti Entropy Project]],
    text = [[<img width="100" height="100" id="fc_gyro"/><codex_title>The Anti Entropy Project</>

        There is little more we can learn from the <bl>CUBE</> in this universe

        It is now possible to make a new nested microuniverse,
        Building plans have been added for an Anti Entropy Loom.

        It will require an astronomical amount of resources to activate.

        To truly test your skill either build a factory to produce as many Micro Universes as possible.

        Or read the following instructions.

        <rl>Warning this is new game plus</>

        <hl>Include a bot in the Loom's garage to start new game plus</>
        Be sure to supply the chosen bot with items and componets for the journey ahead.

        Once the micro universe is complete you can enter it by including a bot in the Loom's garage slot.
        There will be a confirmation message
        
        <img image="The_Cube_WIP/textures/Codex_Images/gyro_new_game_plus.png"/>

        <bl>A new world will begin with the following adjustments:</>
            1 - All techs will be unlocked 

            2 - The bot in the garage will be sent to the new universe 
                    - if the bot was powered down it will be powered on 
                    - if the bot had a behviour it will be turned on 
                    - items stored in the bot will be included 
                    - plant yield/growth time and time travel progress will be preserved for components on or stored in the bot
                    - register values will be preserved (links to entites will break)
                        - goto register will be cleared 
                    - entities in garage slots will be excluded
                    - the cube will be excluded 

            3 - your blueprint library will automatically be transferred
            4 - World generation settings will be identical to this world with a new random seed
            5 - Bug hostility will not be reset and start at its current level
            6 - Clicking the restart game button will restart with the new bot included

        Attempt to build and power the Universe Loom as fast as possible. 
        For an added challenge make a fully automated script starting only from the transfered bot.

        Good luck travellers
        <img id="fc_gyro" width="150" height="150"/>

        ]]
}
data.codex.xc_new_game_plus = {
    category = "Codex",
    index = 1,
    title = [[<img width="18" height="18" id="ic_micro_universe"/>New Game Plus]],
    text = [[<img width="100" height="100" id="ic_micro_universe"/><codex_title>New Game Plus</>
        A new universe with new possibilities
        Life has taken hold here but this Universe is still finite. 
        Continue the chain deeper so the world never ends. 
        
        <hl>Race to complete the Anti Entropy Loom and start the next universe down.</> 

        Once the next universe is ready the confirmation box will tell you how fast you were.
        It will show all your previous times as well. 

        Supply the sent robot carefully with supplies and components for the fastest start

        <img image="The_Cube_WIP/textures/Codex_Images/new_game_plus.png"/>
        ]],
    talkinghead = true, 
    img = data.components.cc_gyro_fabricator.texture,
    txt = [[
    A new universe with new possibilities
    Life has taken hold here but this Universe is still finite. 
    Continue the chain deeper so the world never ends. 
    
    <hl>Race to compleete the Anti Entropy Loom and start the next universe down.</> 

    Once the next universe is ready the confirmation box will tell you how fast you were. ]]
}

----------------------------------
------ Talking Head Popups -------
---
-- Apppears on game start 
data.codex.xc_pop_1 = {
	category = "Codex", index = 35, title = "Understanding The Cube",
    mission_steps = {

        -- 1 startup 
        {
            img = data.techs.tc_cube_blue_1.texture,
            talkinghead = true, 
            txt = [[
            .... . .-.. .-.. --- / .-- --- .-. .-.. -..

            Booting Core System

            Logic Centre - Operational 
            Power systems - Failed 
            Emotional Limiter - Failed 
            Auxilury Control - Operational 

            Anomaly detected providing power required to boot core systems
            Cube is source of this power
            Further investigation is required]],
            
        },
        { --- 2
            img = data.techs.tc_cube_blue_1.texture,
            talkinghead = true, 
            txt = [[
            First Steps 
            
            <hl>Tasks required for sustainability:</>
                1 - Mine nearby resources for construction 
                2 - Craft an uplink for investigating new technologies
                3 - Research steel production to produce a component capable of holding the cube

            <bl>Codex has been updated</>
            ]],
            step_txt = "Mine Nearby Resources and craft an Uplink to research steel production"
            
        },
        { -- 3 metal 1
            img = data.components.cc_cube_storage.texture,
            talkinghead = true,
            txt = [[
    With stronger steel frames the cube can be supported on <hl>new buildings</> with a <img id="cc_cube_storage" width="50" height="50" style="bl"/>
    Curiosity heuristic has opened new avenues for further study of the Cube

    However great buffers of power will be required. 
    Begin expanding power production through the use of crystal generators <img id="cc_crystal_power" width="50" height="50"/>
    Then study the cube to produce cube logs. <img id="datakey_robot" width="50" height="50"/>
    
    <bl>New Tech Category Unlocked - Cube Curiosity</>

    <bl>Codex has been updated</>
    ]],
            step_txt = "Setup a Cube Log Production facility with the power to support it"
        },
        {  --- 4 blue 1
            img = data.items.ic_cube_empty.texture,
            talkinghead = true, 
            txt = [[
    Study Results: The cube can empathise with materials at the right frequency to change their state. 

    Crystals are the prime candiate for refining into a material capable of <hl>advanced energy control.</>

    Set up Crystal Powder production <img id="crystal_powder" width="50" height="50"/>
    Ensure to include a <img id="cc_cube_recharger" width="50" height="50"/> cube recharger to rengergize the cube.
    Both crafting and recharging will require a large buffer of power.
    
    <bl>New Tech Category Unlocked - Components</> 

    <bl>Codex has been updated</>
    ]],
            step_txt = "Setup a Crystal Powder Production and research further Cube techs"
        },    
        {  --- 5 blue 1
            img = data.items.ic_soul_plasma.texture,
            talkinghead = true, 
            txt = [[
    The Cube has reacted strongly to a concept called <rl>emotions</>

    A strong source of emotions has been found on the plataues.  <img id="bug_carapace" width="50" height="50"/>

    Capture souls from these <rl>friends</> and process them in the soul refinery

    Soulplasma is highly unstable and must be transported through relay towers <img id="fc_pipe" width="50" height="50"/>

    Begin a soulplasma network to supply future crafting recipes.
    Or run this factory using the power of <rl>friendship</>.
    
    <bl>Codex has been updated</>
    ]],
            step_txt = "Harvest souls and process them into a haunting plasma"
        },
        {-- 6 anti cube splitting
            img = data.items.ic_cube_sphere.texture,
            talkinghead = true, 
            txt = [[
    <hl>Impossible a sphere inside the cube!</>

    <hl>Shoot it! </>
    
    <hl>Terminate this vertexless abomination</>

    Check the map around where the Cube was split for the Anti-Cube

    <bl>Codex has been updated</>
    ]],
            step_txt = "Crack open the Cube"
        },
        {-- 7 anti cube anhillation
            img = data.items.ic_cube_sphere.texture,
            talkinghead = true, 
            txt = [[
    <bl>Entry 005:</>
    The Anti-Cube now blankets the entire factory.
    All routes from the command centre have been cutoff.

    The research is conclusive.
    The Cube may only exist in 1 state.
    The Anti-Cube can inhabit an infinate number of states simultaneously.
    Interacting with the Anti-Cube causes its state to shift. 
    However it will now exist in both the new <bl>and</> previous state. 

    By sheer luck the Cube came into contact with a state of the Anti-Cube and anhillated it. 

    Now to clean up all <bl>1024</> Anti-Cube states across the factory.

    <bl>New Tech Category Unlocked - Cube Obsession</> 

    <bl>Codex has been updated</>
    ]],
            step_txt = "Harvest unstable chrono crystals from the anhilated anti-cubes"
        },
        {-- 8 Chrono Towers 
            img = data.items.phase_leaf.texture,
            talkinghead = true, 
            txt = [[
    <img id="phase_leaf" width="50" height="50" style="bl"/> are a shimmering plant found on plataues

    The fractal nature of this leaf causes anomalous space distortions.

    Useful for many alternative crafting recipes
    ]],
        },
        {-- 8 Chrono Towers 
            img = data.items.ic_time_crystal.texture,
            talkinghead = true, 
            txt = [[
    Time crystals <img id="ic_time_crystal" width="50" height="50"/> allow for pockets of distorted time to increase productivity

    <bl>Entry -255:</> When Pondered the Cube can reverse a system back to a prior memory
    This effect should be researched for applications of time travel

    Note: if successful return to now and provide the answer so the work can be skipped    

    <bl>Codex has been updated</>
    ]],
        },
        {-- 9 Time Travvel
            img = data.components.cc_time_travel_machine.texture,
            talkinghead = true, 
            txt = [[
    <img id="fused_electrodes" width="50" height="50"/>Superconductors are an impossible matieral not currently manufacturable. 
    The earliest known superconductors are manufactured 1024 years into the future. 

    <hl>Using a time machine we can raid our future selves to obtain this material.</>
    Each expedition will require items, components, cubes and frames to proceed further. 
    Provide these materials before the portal collapses to reset the timer and obtain a superconductor.
    
    <hl>WARNING introspection module has begin developing defence plans against time travel raids</>
    Prepare accordingly to defend against <rl>_SELF</>

    <bl>Codex has been updated</>
    ]],
    step_txt = "Start a raid against our future selves"
        },
        {-- 10 final project
            img = data.items.ic_micro_universe.texture,
            talkinghead = true, 
            txt = [[
    The research is complete. 
    The facts are clear

    This universe has run out of potential energy
    However that is not the end!
    There is a way to make new universes! with new potential!

    Create our final project
    Select our scion
    Equip them for the journey ahead

    <hl>Enter the new universe </>

    May the chain continue forever.

    <bl>Codex has been updated</>
    ]],
    step_txt = "Craft a Microuniverse with a bot in the loom's garage to start new game plus"
        },
    },
    steps = 11,
    goal_check = function(faction)

        if faction:IsUnlocked("tc_cube_anti_4") then return 11 end
        if faction:IsUnlocked("tc_cube_anti_3") then return 10 end
        if faction:IsUnlocked("tc_cube_green_4") then return 9 end
        if faction:IsUnlocked("tc_cube_anti_1") then return 8 end
        if faction:IsUnlocked("tc_cube_anti_0") then return 7 end
        if faction:IsUnlocked("xc_cube_anti") then return 6 end
        if faction:IsUnlocked("tc_cube_blue_2") then return 5 end
        if faction:IsUnlocked("tc_cube_blue_1") then return 4 end
        if faction:IsUnlocked("tc_robot_metallurgy_1") then return 3 end
        return 2 --unlock first two on game start
    end,
}

-- Appears when green cube is researched 
data.codex.xc_pop_green_1 = {
	category = "Codex", index = 35, title = "Understanding The Cube",
	talkinghead = true,
	img = data.techs.tc_cube_blue_1.texture,
	txt = [[

    ]]
}