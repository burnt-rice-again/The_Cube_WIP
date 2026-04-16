
-- { -- Hard coded catoegories from codex UI 
-- 	["Mission"]   = 1,
-- 	["E.L.A.I.N"] = 2,
-- 	["Goals"]     = 3,
-- 	["Codex"]     = 4,
-- 	["How to Play"]  = 5,
-- }
data.codex.x_behaviors.category = "How to Play"

data.codex.xc_cube_1 = {
    category = "Codex",
    index = 1,
    title = [[<img width="18" height="18" id="ic_cube_blue"/>Cube Discovery]],
    text = [[<img width="100" height="100" id="ic_cube_blue"/><codex_title>Cube Discovery</>
    
    The Cube has given us <rl>sentience</>. 

    <hl>Our top priority is to understand and control the Cube that formed us from rocks.</>

    Study Notes:
    The Cube is perfectly flat on its surface down to the nm 
    Its density is beyond all readings 
    The Cube appears to impart logic and emotions on neary materials
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
        Crafting with the cube requires lots of power and will need a suitable buffer as well
        
        The blue Cube will provide <bl>1000</> power/second while placed on a pedestal

        <bl>Available Power Generation via crystal generator</>
        <img id="cc_crystal_power" width="50" height="50"/> <hl>Basic Crystal Power</> 
        Energy Recipe 
		<img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" id="crystal"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>

        Once crafted with the Cube and fuel the component will produce a constant power output while it works
        The power output is affected by effciency.
        The Cube is <bl>not locked</> during the components cooldown allowing it to be passed to another component.

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
        The Pedestal uses a Medium Socket.

        When a Cube is present is will slow the bots movement speed by <hl>80%</> and provide 1000 <img width="50" height="50" image="Main/textures/icons/values/power.png"/>
        
        To Offset this reduction discover a <img id="ic_cube_green" width="50" height="50" style="bl"/> or research an <img id="engine" width="50" height="50" style="bl"/>.
        
        <img image="The_Cube_WIP/textures/Codex_Images/Cube_Pedestal.png"/>
]],
}
data.codex.xc_cube_recharger = {
    category = "Codex",
    index = 4,
    title = [[<img width="18" height="18" id="cc_cube_recharger"/>Cube Recharger]],
    text = [[<img width="100" height="100" id="cc_cube_recharger"/><codex_title>Cube Recharger</>

        Intense crafting will cause the Cube to become dormant 

        The Cube Recharger can renergize the Cube.
        A list of known recipes is found at the resource bar.
        The Recharger will normally create a Blue Cube.

        Some recipes require more resources but craft significantly faster. 

        There are some alternative recipes as well 
            -- Emergency Cube Cooling can cool the Fury Cube.
            -- Charging inside the blight can create a Restless Cube. 
        ]],
}
data.codex.xc_cube_alt = {
    category = "Codex",
    index = 5,
    title = [[<img width="18" height="18" id="v_color_yellow"/>Alternative Recipes]],
    text = [[<img width="100" height="100" id="v_color_yellow"/><codex_title>Alternative Recipes</>

        There are some alternative recipes available for items made with the Cube 

        All alternative recipes have a yellow background 

        Typically these recipes cost more resources but significantly less Cube time.
        They also offer new ways to change the Cubes form.

        <img image="The_Cube_WIP/textures/Codex_Images/Alt_Recipe.png"/>
        <img id="datakey_robot" width="50" height="50"/> <hl>Original Recipe</> 
        <img id="datakey_robot_alt" width="50" height="50"/> <hl>Alternative Recipe</> 

        An instruction is available to check if the input is an alternative recipe. Will Return the original item if available. 
        <img image="The_Cube_WIP/textures/Codex_Images/alt_recipe_block.png"/>

        ]],
}
data.codex.xc_cube_green = {
    category = "Codex",
    index = 6,
    title = [[<img width="18" height="18" id="ic_cube_green"/>Restless Cube]],
    text = [[<img width="100" height="100" id="ic_cube_green"/><codex_title>Restless Cube</>

        The Restless Cube is useful for farming and transportation

        <bl>Bots holding the Restless Cube recieve a 80% move speed bonus instead.</>

        It can be crafted at the Cube think tank
        Alternativly recharging the cube inside the blight will produce a Restless Cube<img width="50" height="50" id="cc_cube_recharger"/>
        Farming requires the <bl>Restless Cube</> to plant new crops 
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
        3 - Seed Grow Time - How long the crop will take to grow when plated with this seed
        2 - Missing Fertilizer - When the planter requires the Restless Cube or other items
        1 - Target Location (None if there is not a plantable position in range)
        <img image="The_Cube_WIP/textures/Codex_Images/Planter_Registers.png"/>  

        <img image="The_Cube_WIP/textures/Codex_Images/Farm_Showing_Range.png"/>  
        ]],
}
data.codex.xc_cube_red = {
    category = "Codex",
    index = 7,
    title = [[<img width="18" height="18" id="ic_cube_red"/>Fury Cube]],
    text = [[<img width="100" height="100" id="ic_cube_red"/><codex_title>Fury Cube</>

        The Fury Cube is useful for smelting and power generation 

        The Fury Cube can be created by melting a cube inside a blight volcano
        <img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" id="fc_volcano"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_red"/>

        The Cube will cooldown when used for crafting<img width="50" height="50" id="ic_cube_empty"/>
        Alternativly the Fury Cube can be instantly cooled in the Cube Recharger<img width="50" height="50" id="cc_cube_recharger"/>

        Available Power Generation via Fury Cube.
        <img id="cc_crystal_power_red" width="50" height="50"/> <hl>Basic Crystal Power</> 
        Energy Recipe 
		<img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="crystal_powder"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>

        Other Similiar Power Components 
        <img id="cc_crystal_power" width="50" height="50"/> <hl>Crystal Power</> 
        <img id="cc_power_souls" width="50" height="50"/> <hl>Soul extraction</> 
        ]],
}

data.codex.xc_cube_plasma = {
    category = "Codex",
    index = 8,
    title = [[<img width="18" height="18" id="ic_soul_plasma"/>Ectoplasma Network]],
    text = [[<img width="100" height="100" id="ic_soul_plasma"/><codex_title>Ectoplasma Network</>

        <img id="bug_carapace" width="50" height="50"/>Souls are dropped by enemy units and occasionaly found at defended explroables

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

        This anomalous sphere behaves in opposition to everythin known about the cube. 

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

        In additon the Cube will be transformed into another form. 

        <img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/>
        <img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_blue"/>
        <img width="50" height="50" id="ic_cube_green"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_red"/>
        <img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="ic_cube_sphere"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_green"/>

        For more effcient <bl>Anti-Cubes</> Disposal it is possible to anhillate multiple <bl>Anti-Cubes</> at once without causing more damage.
        <img image="The_Cube_WIP/textures/Codex_Images/Anti_4.png"/>  

        ]],
}
data.codex.xc_cube_boost = {
    category = "Codex",
    index = 11,
    title = [[<img width="18" height="18" id="ic_fuel"/>Boost Modules]],
    text = [[<img width="100" height="100" id="ic_fuel"/><codex_title>Boost Modules</>

        Effciency and Movement Speed boost modules now require fuel to operate. 
        
        <img id="cc_modulespeed_l" width="50" height="50"/><img id="ic_fuel" width="50" height="50"/>
        <img id="cc_moduleefficiency_l" width="50" height="50"/><img id="ic_time_crystal" width="50" height="50"/>

        Modules will automatically request a full stack but only consume 1 at a time.

        <hl>Chrono Towers</><img id="fc_boost_tower" width="50" height="50"/>
        Chrono Towers will dilate time around another unit within their range. 
        Select a target unit with the first register. 
        When the tower is ready it will boost the unit. 

        Multiple boost towers affecting the same unit will have diminshing returns 
        ]],
}
data.codex.xc_cube_time_travel = {
    category = "Codex",
    index = 12,
    title = [[<img width="18" height="18" id="cc_time_travel_machine"/>Time Travel Expedition]],
    text = [[<img width="100" height="100" id="cc_time_travel_machine"/><codex_title>Time Travel Expedition</>

        <img id="fused_electrodes" width="50" height="50"/>Superconductors are an impossible matieral not currently manufacturable. 
        The earliest known superconductor was manufactured 1024 years into the future. 

        Using a time machine we can raid our future selves to obtain this material. 
        Each expedition will require items, components, cubes and frames to proceed further. 
        Provide these materials before the portal collapses to reset the timer and obtain a superconductor. 

        When the portal closes it will give an opportunity for our past selves to attack us for our superconductors. 
        <rl>These attacks can be deadly.</>
        Collapse the portal when the number of known defenders is managable. 
        This will change each time a material is supplied
        Check the time machines second register for the number of defenders. 

        Defenders will drop souls ready for extraction.  

        <bl>Time Machine Registers</>
        Register 1: Material for next step 
        Register 2: Number of defnders spawned on portal collapse
        ]],
}