

local cc_pipe_crane = Comp:RegisterComponent("cc_pipe_crane", {

    name = "ectoplasma conduit",
    desc = "Sparkly Death",
    texture = "Main/textures/icons/components/Component_HackingTool_01_S.png",
    slots = {anomaly = 1},
    --attachment_size = "Hidden",
    power = -10,
    race = "robot",
    range = 10,
    trigger_radius = 6,
    trigger_channels = "building",
    activation = "OnComponentItemSlotChange",
    effect_send = "fx_alien_monolith_lightning",
    --activation = "Always"
    get_ui = true,
    on_remove = function(self, comp) comp.owner.move_boost = 100 end,
    wait_ticks = 25,
})


-- fx_alien_monolith_lightning - this is cool
-- fx_turret_3 - single shot looks okay 
--fx_extractor - better then standard miner

local function send_plasma(ent_from, ent_to, amt,comp)
    
    local transfer = ent_to:TransferFrom(ent_from, "ic_soul_plasma", amt)
    if comp ~= nil then 
        --is a input/output

        if comp.id ~= "cc_pipe_output" then 
            comp:RotateComponent(ent_to)
            comp:PlayEffect("fx_alien_monolith_lightning","fx",ent_to)
            --must be send 
        else
            -- must be recieve
            comp:RotateComponent(ent_from)
            ent_from:PlayEffect("fx_alien_monolith_lightning","fx",ent_to)
        end
        return
    end
    --regular pipe transfer
    if transfer > 0 then 
        ent_from:PlayEffect("fx_alien_monolith_lightning","fx",ent_to)
    end
end
    --comp:SetStateSleep(5) 
function cc_pipe_crane:on_update(comp, cause)

    if comp.is_working then 
        comp:SetStateContinueWork()
        return
    end

    if cause & CC_CHANGED_ITEMSLOT_AMOUNT or cause & CC_FINISH_SLEEP then 
        local slot = comp:GetSlot(1)
        local holding = slot.stack
        local owner = comp.owner

        local pipes = Map.GetEntitiesInRange(owner,self.range,FF_OWNFACTION)

        for i,ent in ipairs(pipes) do 
            if ent.id == "fc_pipe" then
                local difference = holding - ent:CountItem("ic_soul_plasma") 
                if difference > 1 then 
                    send_plasma(owner,ent,math.floor(math.abs(difference)/2))
                    comp:SetStateStartWork(self.wait_ticks)
                    return 
                elseif difference < -1 then
                    send_plasma(ent,owner,math.floor(math.abs(difference)/2))
                    comp:SetStateStartWork(self.wait_ticks)
                    return 
                end 
            end
        end
    end
end
function cc_pipe_crane:on_trigger(comp, other_entity)
    comp:Activate()
end
function cc_pipe_crane:on_add(comp, cause)
    comp.owner.move_boost = 0
    comp:Activate()
end
-- TODO this doesnt work. Or its does but the building still drops the item. 
-- function cc_pipe_crane:on_remove(comp, cause)
--     -- remove particles so their not on the grpund 
--     print("Clearing Pipe")
--     for i, val in ipairs(comp.owner.slots) do 
--         print(val,val.id)
--         if val.id == "ic_soul_plasma" then 
--             val:Clear()
--             print("Slot Cleared", val)
--         end
--     end
--     print(comp.owner.slots)
-- end
local function send_only_plasma(self, comp, cause)
    if cause & (CC_CHANGED_ITEMSLOT_AMOUNT | CC_FINISH_SLEEP) then 
        local slot = comp:GetSlot(1)
        local holding = slot.stack
        if holding <= 0 then 
            --no need to continue
            if comp.is_working == false then comp:SetStateSleep(500) end
            return  
        end

        local owner = comp.owner

        local pipes = Map.GetEntitiesInRange(owner,self.range,FF_OWNFACTION)
        for i,ent in ipairs(pipes) do 
            if ent.id == "fc_pipe" then
                local free_space = ent:CountFreeSpace ("ic_soul_plasma") 
                if free_space > 1 then 
                    --print('send')
                    comp:PlayEffect("fx_alien_monolith_lightning","fx",ent)
                    comp:RotateComponent(ent)
                    send_plasma(owner,ent,free_space,comp)
                    return 
                end
            end
        end
        --no destinations found
        if comp.is_working == false then comp:SetStateSleep(25) end
    end
end
local function recieve_only_plasma(self, comp, cause)
    
    if comp.is_working then comp:SetStateContinueWork() return  end
    local slot = comp:GetSlot(1)
    if slot.reserved_space <= 0 then 
        --no need to continue as it already has required items 
        --only need to wake up if less then 100 otherwise activation trigger can handle it
        if slot.stack < 100 then comp:SetStateSleep(25) end
        return  
    end
    -- look for relay to take plasma from 
    local owner = comp.owner
    local pipes = Map.GetEntitiesInRange(owner,self.range,FF_OWNFACTION)
    for i,ent in ipairs(pipes) do 
        if ent.id == "fc_pipe" then
            local stored = ent:CountItem("ic_soul_plasma") 
            if stored > 0 then
                --print('recieve')
                send_plasma(ent,owner,slot.reserved_space,comp)
                comp:PlayEffect("fx_alien_monolith_lightning","fx",ent)
                comp:RotateComponent(ent)
                comp:SetStateStartWork(self.wait_ticks)
                return
            end
        end
    end
    --no destinations found
    comp:SetStateSleep(self.wait_ticks)
end

local refinery = data.components.cc_soul_refinery
function refinery:pipe_input(comp, cause)
    send_only_plasma(self,comp,cause)
end

cc_pipe_crane:RegisterComponent("cc_pipe_input",{

    name = "Ectoplasma Transmitter",
    desc = "Sends Ectoplasma Into nearby relays",
    power = -50,
    texture = "Main/textures/icons/components/Component_HackingTool_01_S.png",
    attachment_size = "Small",
    send_only = true,
    visual = "v_hacking_tool_s",--'v_blight_control',
    on_update = send_only_plasma,
    production_recipe = CreateProductionRecipe({steelblock = 8, crystal_powder = 4, wire = 1},{c_fabricator = 40})
})
cc_pipe_crane:RegisterComponent("cc_pipe_output",{

    name = "Ectoplasma Reciever",
    desc = "Recieves Ectoplasma From Nearby Relays",
    power = -50,
    texture = "Main/textures/icons/components/Component_HackingTool_01_S.png",
    attachment_size = "Small",
    recieve_only = true,
    visual = 'v_hacking_tool_s',
    on_update = recieve_only_plasma,
    production_recipe = CreateProductionRecipe({steelblock = 8, concreteslab = 4, wire = 1},{c_assembler = 40})
})

cc_pipe_crane:RegisterComponent("cc_pipe_output_h",{

    name = "Ectoplasma Reciever",
    desc = "Takes Ectoplasma In",
    power = -50,
    texture = "Main/textures/icons/components/Component_HackingTool_01_S.png",
    attachment_size = "Hidden",
    recieve_only = true,
    on_update = recieve_only_plasma,
})

cc_pipe_crane:RegisterComponent("cc_pipe_output_i",{

    name = "Ectoplasma Reciever",
    desc = "Takes Ectoplasma In",
    power = -50,
    texture = "Main/textures/icons/components/Component_HackingTool_01_S.png",
    attachment_size = "Internal",
    recieve_only = true,
    on_update = recieve_only_plasma,
    visual = "v_generic_i"
})
cc_pipe_crane:RegisterComponent("cc_pipe_input_i",{

    name = "Ectoplasma Transmitter",
    desc = "Sends Ectoplasma Into nearby relays",
    power = -50,
    texture = "Main/textures/icons/components/Component_HackingTool_01_S.png",
    attachment_size = "Small",
    send_only = true,
    visual = "v_hacking_tool_s",--'v_blight_control',
    on_update = send_only_plasma,
    production_recipe = CreateProductionRecipe({steelblock = 8, crystal_powder = 4, wire = 1},{c_fabricator = 40})
})
