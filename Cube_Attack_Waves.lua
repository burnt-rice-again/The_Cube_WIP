


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
    },
    s ={
        c_portable_turret = 1,
        c_adv_portable_turret = 2,
        c_plasma_turret = 5,
        c_virus_bitlock = 5,
        c_portable_turret_red = 3,
        c_portable_turret_green = 2,
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

-- create a randomized bot 
function Build_random_bot(faction)

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
    end
    print(cost, bot)
    return bot, cost
end 



        -- req_comp = {'c_integrated_power_cell'},
        -- items = {fused_electrodes = 1},






























