
-- { -- Hard coded catoegories from codex UI 
-- 	["Mission"]   = 1,
-- 	["E.L.A.I.N"] = 2,
-- 	["Goals"]     = 3,
-- 	["Codex"]     = 4,
-- 	["How to Play"]  = 5,
-- }

data.codex.xc_cube_1 = {
    category = "Codex",
    index = 1,
    title = [[<img width="18" height="18" id="ic_cube_blue"/>Cube Discovery]],
    text = [[<img width="100" height="100" id="ic_cube_blue"/><codex_title>Cube Introduction</>
    
    Status: Operator Online

    Providing Mission Briefing

    Awakening sentince module,
    Clearing stored personality matrix,
    Verifying emotinal processor
    Verification failed 
  
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
        
        The blue Cube will provide <bl>500</> power/second while placed on a pedestal

        Available Power Generation via crystal generator 
        <img id="cc_crystal_power" width="50" height="50"/> <hl>Basic Crystal Power</> 
        Energy Recipe 
		<img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" id="crystal"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_blue"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>

        Crystal power will attempt to recharge when its battery is empty
        A single recharge will fully recharge the internal battery

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
        The Pedestal uses a Medium Slot.

        When a Cube is present is will slow the bots movement speed by <hl>90%</> 
        To Offset this reduction research engines or discover a lightweight Cube.

        The blue Cube will provide <bl>500</> power/second while placed on a pedestal
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
        ]],
}
data.codex.xc_cube_green = {
    category = "Codex",
    index = 6,
    title = [[<img width="18" height="18" id="ic_cube_green"/>Restless Cube]],
    text = [[<img width="100" height="100" id="ic_cube_green"/><codex_title>Restless Cube</>

        The Restless Cube is useful for farming and transportation

        It can be crafted at the Cube think tank
        Alternativly recharging the cube inside the blight will produce a Restless Cube
        <img width="50" height="50" id="cc_cube_recharger"/>

        Farming requires the Restless cube to plant new crops 
        A planter will request the Cube when it has a space available in range
        
        To plant a crop there must be an unobstructed tile nearby
        There must be <hl>NO foundations</> on that tile

        Crops will grow on their own.  The time it takes to grow is in the "grow time" register
        <bl>Harvestable crops can be idetified using the flower filter</>
        <img id="v_is_flower" width="50" height="50"/> <hl>Radar Flower Filter</>
        Crops will yield the resource in their yield register. 
        Destroy or dismantle fully grown crops for them to drop their yield.

        There is a 30% chance to also drop a new planter seed. 
        The Yield and Growth Time may differ from the original seed.
        Select for better seeds to increase planter efciency. 
    
        Unwanted seeds can be recycled in the assembler
        ]],
}
data.codex.xc_cube_red = {
    category = "Codex",
    index = 7,
    title = [[<img width="18" height="18" id="ic_cube_red"/>Fury Cube]],
    text = [[<img width="100" height="100" id="ic_cube_red"/><codex_title>Fury Cube</>

        The Fury Cube is useful for smelting and power generation 

        The Fury Cube can only be created by melting a dormant cube inside a blight volcano
        <img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" id="fc_volcano"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_red"/>

        The Cube will cooldown when used for crafting
        Alternativly the Fury Cube can be instantly cooled in the Cube Recharger<img width="50" height="50" id="cc_cube_recharger"/>

        Available Power Generation via Fury Cube.
        <img id="cc_crystal_power_red" width="50" height="50"/> <hl>Basic Crystal Power</> 
        Energy Recipe 
		<img width="50" height="50" id="ic_cube_red"/><img width="50" height="50" id="crystal_powder"/><img width="32" height="32" image="Main/skin/Icons/Common/32x32/Arrow.png"/><img width="50" height="50" id="ic_cube_empty"/><img width="50" height="50" image="Main/textures/icons/values/power.png"/>

        Crystal power will attempt to recharge when its battery is empty.
        A single recharge will fully recharge the internal battery.

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

        <img id="ic_souls" width="50" height="50"/>Souls are dropped by enemy units and occasionaly found at defended explroables

        They can be converted into Ectoplasma at the soul refinery <img id="cc_soul_refinery" width="50" height="50"/>
        
        Ectoplasma is highly unstable and must be transfered through a seperate network<img id="fc_pipe" width="50" height="50"/>
        The Soul refinery will automatically transfer to nearby Pylons. 
        <img id="cc_pipe_output" width="50" height="50"/>Plasma Coils can take Ectoplasma from nearby pylons to be used by components
        Bots carrying ectoplasma will slow down significantly due to its instability 

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

        Placing the Cube and Anti-Cube into the same frame will cause them to anhillate. 

        The Anti-Cube will explode dealing damage to units within range 10. 
        Blight Crystal Deposits will form neaarby. 
        Units Killed by the explosion will cause additonal blight crystals to appear. 

        In additon the Cube will be transformed into another form. 
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