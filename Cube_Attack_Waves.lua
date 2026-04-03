


--- Code for spawning a randomized wave of enemy frames 
--- 
--- Will take in a frame_cost_list, component_cost_list
--- 
--- frame cost list will be frame + req comps
--- then choose a random weapon or shield for each socket
--- 
--- then add reward items 
--- 
--- 

local frame_cost_list <const> = {
        --f_bot_1s_b = 3,
        f_bot_1s_as = 3,
        f_bot_1m_c = 5,
        f_bot_1s_adw = 9,
        f_bot_1m1s = 10,
        f_bot_2m_as = 15,
        f_bot_1l_a = 15,
        
        -- buildinga always cost more
        f_building1x1h = 10,
        f_building2x2e = 30,
        f_building2x2f = 15,
}
local comp_cost_list <const> = {
    i ={
        c_repairkit = 1,
        c_modulehealth = 4,
        c_moduleefficiency = 2,
        c_modulespeed = 1,
        c_shield_generator = 1,
        c_shield_generator2 = 2,
        c_shield_generator3 = 3,
        c_internal_storage = 0, -- dud item
    },
    s ={
        c_portable_turret = 1,
        c_adv_portable_turret = 2,
        c_plasma_turret = 5,
        c_portable_turret_red = 3,
        --c_portable_turret_green = 2, -- no virus protection in tech tree
        c_melee_pulse = 1,
    },
    m = {
        c_virus_bitlock = 10,
        c_photon_cannon = 15,
        c_plasma_turret = 10,
        c_pulse_disrupter = 10,
        c_photon_beam = 8,
        c_laser_turret = 6
    },
    l = {
        c_missile_turret = 5,
    },
}

local frame_keys = {}
local comp_keys = {i={},s={},m={},l={}}
-- Insert the keys of the table into an array
for key, _ in pairs(comp_cost_list.i) do
    table.insert(comp_keys.i, key)
end
for key, _ in pairs(comp_cost_list.s) do
    table.insert(comp_keys.s, key)
end
for key, _ in pairs(comp_cost_list.m) do
    table.insert(comp_keys.m, key)
end
for key, _ in pairs(comp_cost_list.l) do
    table.insert(comp_keys.l, key)
end
for key, _ in pairs(frame_cost_list) do
    table.insert(frame_keys, key)
end

local function random_key(list)
    return list[math.random(1,#list)]
end

local cc_damage_check = Comp:RegisterComponent("cc_damage_check",{
    name = "damage", 
})

-- prevent the units from dropping components 
function cc_damage_check:on_take_damage(comp, amount)
    local owner = comp.owner
    --print("Damage:",amount, " Health_old:",owner.health, "HealthNew:", owner.health-amount)
    if owner.health-amount <= 0 then
        for i = 1, owner.component_count do 
            local comp2 = owner:GetComponent(i)
            if comp2 ~= nil then 
                --print(comp2.id, "Destroyed")
                comp2:Destroy()
            end
        end
    end
end

-- create a randomized bot 
local function build_random_bot(faction)

    local cost = 0

    local bot = Map.CreateEntity(faction, random_key(frame_keys))
    cost = cost + frame_cost_list[bot.id]
    bot:AddComponent("c_integrated_power_cell")

    local sockets = bot.visual_def.sockets
    if sockets then 
        for i, val in ipairs(sockets) do 
            local comp_id
            if val[2] == "Medium" then 
                comp_id = random_key(comp_keys.m)
                bot:AddComponent(comp_id)
                cost = cost + comp_cost_list.m[comp_id]
            elseif val[2] == "Small" then 
                comp_id = random_key(comp_keys.s)
                bot:AddComponent(comp_id)
                cost = cost + comp_cost_list.s[comp_id]
            elseif val[2] == "Internal" then 
                comp_id = random_key(comp_keys.i)
                bot:AddComponent(comp_id)
                cost = cost + comp_cost_list.i[comp_id]
            elseif val[2] == "Large" then 
                comp_id = random_key(comp_keys.l)
                bot:AddComponent(comp_id)
                cost = cost + comp_cost_list.l[comp_id]
            end
        end
        bot:AddComponent("cc_damage_check")
        -- add a radar so it can automattically hunt 
        local radar = bot:AddComponent("c_alien_sensor_wide")
        radar:SetRegister(1,data.values.v_enemy_faction)
        -- stop it targetting construction sites
        radar:SetRegister(2,data.values.v_robot_faction)
        --always links to the first weapon
        bot:LinkRegisterFromRegister(6,4,radar)
        -- add a soul 
        bot:AddItem("ic_souls", 1)
    end
    return bot, cost
end 

function Delay.Place_random_bot(arg)
        local bot, bot_cost = build_random_bot(arg.faction)
        bot:Place(arg.cord.x + math.random(-arg.range, arg.range),arg.cord.y + math.random(-arg.range, arg.range), math.random(0,3))
        bot:PlayEffect("fx_pulse")
        --print('spawning', bot.location)
end

local function spawn_robot_attack(owner, cost, options)

    local range = options.range or 20
    local cord = owner.location
    local i = 5
    while cost > 0 do 
        Map.Delay("Place_random_bot", i, {faction = "time_bots", cord = cord, range = range})
        cost = cost - 1
        i = i + 5
    end
end

local cc_time_travel_machine = Comp:RegisterComponent("cc_time_travel_machine",{
	name = "Time Travel Machine",
	desc = "Steal Resources no longer obtanable in our time\n\nProvide resources and bots to an ongoing expedition to return items\n\nEnd the Expedition when the component finishes without the provided item\n\nPrepare for a defence response from currently visited timeline",
	race = "robot",
	attachment_size = "Large",
	texture = "Main/textures/icons/components/Component_UnitTeleporter_01_L.png", -- "Main/textures/icons/components/component_ScienceAnalyzer_01_l.png",
	visual = "v_teleporter_01_l",  --"v_scienceanalyzer_l",
	effect = "fx_unit_teleport",
	slots = { garage = 1 },
	power = 0,---1000,
	production_recipe = CreateProductionRecipe({["steelblock"]=100,["concreteslab"]=100,["phase_leaf"]=50,["wire"] = 50}, {["c_assembler"] = 150}, 1),
	activation = "OnAnyItemSlotChange",
	--power = -500,
	registers = {
		--{tip = "<header>Request Charge</>\n\nThe further into the future or past the more resources the robots can return\n\nHowever prepare for proportionally stronger retaliations from the inhabitants of that timeline"},
        --{ read_only = true, ui_icon = "icon_small_time", tip = "<header>Years Travelled</>\n\nThe further into the future or past the more resources the robots can return\n\nHowever prepare for proportionally stronger retaliations from the inhabitants of that timeline"},
        { read_only = true, ui_icon = "icon_small_time", tip = "<header>Resupply Required</>\n\nItems/bots required to resupply the party"},
        { read_only = true, ui_icon = "icon_warning", tip = "<header>Defenders At Current Time</>\n\nThe Amount of defenders that will spawn if the portal collapses\nChanges with each jump in time."},
    },
	get_ui = false,
	output_item = "fused_electrodes",
    wait_ticks = 100,
    range = 10,
})

function  cc_time_travel_machine:on_add(comp, cause)
    --- set registers 
    if comp:RegisterIsEmpty(2) then 
        comp:SetRegisterNum(2,math.random(0,30))
    end 
    comp:Activate()
end

function  cc_time_travel_machine:on_remove(comp, cause)
    -- spawn attack if removed while working 
    if comp.is_working then 
        spawn_robot_attack(comp.owner, comp:GetRegisterNum(2) + 10, {range = self.range})
    end 
end

local replace_cube_with <const> = {
    ic_cube_blue = 'ic_cube_green',
    ic_cube_green = 'ic_cube_empty',
    ic_cube_empty = 'ic_cube_red',
    ic_cube_red = 'ic_cube_blue',
    ic_cube_sphere = 'ic_cube_sphere',
}
local function new_order_id(comp)
    local req = {"ic_cube_green", "ic_cube_blue","ic_cube_red","ic_cube_empty","ic_cube_sphere",
    "c_adv_portable_turret",
    "ic_soul_angry","ic_soul_happy","phase_leaf",
    "f_bot_1s_b","f_bot_1m1s"
    }
    local new_id = req[math.random(1,#req)]
    -- for testing 
    --new_id = "ic_cube_blue"
    comp:SetRegister(1, {id = new_id, num = 1})
    return new_id
end

function  cc_time_travel_machine:on_update(comp, cause)

    --print(comp.CauseToString(comp, cause))

    if cause & CC_FINISH_WORK ~= 0 then 
        -- collapse tiem travel machine
        spawn_robot_attack(comp.owner, comp:GetRegisterNum(2), {range = self.range})
        -- spawn attackers 

        comp:SetRegisterNum(2,0)
        comp:SetStateSleep(1000)
        comp:StopEffects()
        comp:PlayEffect("fx_pulse",'fx')
        -- effect for stopped
        
    else
        -- check if order has arrived 
        -- reset work timer 
        -- check current order 
        local order = comp:GetRegisterId(1)
        local owner = comp.owner 
        

        if order == nil then 
            -- select new order 
            order = new_order_id(comp)
        end 
        -- check for frame type
        local is_frame = nil ~= data.frames[order]

        -- assign process when item amounts have changed (not item types)
        local can_make, missing, no_space
        if cause and CC_CHANGED_ITEMSLOT_AMOUNT then 
            if is_frame ~= true then 
                can_make, missing, no_space = comp:PrepareProduceProcess({[order] = 1},{fused_electrodes = 1})
            else 
                no_space = comp:PrepareGenerateProcess({fused_electrodes = 1})
                can_make = no_space
                -- for frame inputs 
            end
        end
        if can_make then 
            if is_frame == true then 
                local garage = owner:GetSlotsByType("garage")
                local check = true
                for key, val in pairs(garage) do 
                    if val.id == order then 
                        check = false 
                        val.entity:Destroy()
                        break 
                    end
                end
                -- reuturn if no frame found 
                if check then comp:SetStateSleep(1000) return end 
            else 
                comp:FulfillProcess()
            end
            -- update tally 
            -- replace CUBE
            local new_id = replace_cube_with[order]
            if new_id ~= nil then 
                owner:AddItem(new_id)
            end 

            -- work again
            comp:SetStateStartWork(self.wait_ticks)
            comp:SetRegisterNum(2, math.random(0,30))
            if comp:GetRegisterNum(2) > 10 then comp:FlagRegisterError(2) end 
            comp:PlayEffect('fx_unit_teleport','fx')
            comp:PlayWorkEffect('fx_glitch2',"fx")
            new_order_id(comp)
            return 
            -- add new order
        elseif no_space or comp.is_working then 
            comp:FlagRegisterError(1)
        else
            comp:FlagRegisterError(1, false)
        end

        if comp.is_working then 
            comp:SetStateContinueWork()
        else 
            comp:SetStateSleep(1000)
        end
    end
end
function  cc_time_travel_machine:get_reg_error(comp, cause)

    if comp:RegisterIsError(1) then
        if comp.is_working then 
            return "Supply This Item or Unit before the machine finishes working for the expedition to keep working"
        end 
        return "Not enough space for items\nor no slots for the Cube or Ectoplasma"
    elseif comp:RegisterIsError(2) then
        return "Warning Extremly Dangerous Defence Response Detected\nKeep jumping for a safer time to collapse the loop"
    end
end

        -- req_comp = {'c_integrated_power_cell'},
        -- items = {fused_electrodes = 1},

-- TODO known bug is the requirement will change on uneqip/requip of the components




























