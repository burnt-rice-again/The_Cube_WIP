  


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
        f_building2x1g = 1,
        f_building2x2d = 1,
        f_building2x2b = 1,
        f_building3x2b = 1,
        f_building2x2c = 1,
        f_building3x2a = 1,
        f_building1x1d = 1,
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
        c_turret = 1,
        c_twin_autocannons = 5,
        c_light_cannon = 5,
    },
    m = {
        c_virus_bitlock = 10,
        c_photon_cannon = 15,
        c_plasma_turret = 10,
        c_pulse_disrupter = 10,
        c_photon_beam = 8,
        c_laser_turret = 6,
        c_pulselasers = 5,
        c_plasma_cannon = 10,
        c_railgun = 10,
    },
    l = {
        c_missile_turret = 5,
        c_human_missilelauncher = 3,
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

local function random_key(list, filter)
    if filter ~= nil then
        local check = 3
        while check > 0 do
            local id = list[math.random(1,#list)]
            if string.find(id,filter) ~= nil then 
                return id
            end
            check = check - 1
        end
    end
    return list[math.random(1,#list)]
end

local cc_damage_check = Comp:RegisterComponent("cc_damage_check",{
    name = "damage", 
    desc = "prevent frame from dropping comps when destroyed"
})

-- prevent the units from dropping components 
-- owner.exists did not work or .is_updating
function cc_damage_check:on_take_damage(comp, amount)
    local owner = comp.owner
    --print("Damage:",amount, " Health_old:",owner.health, "HealthNew:", owner.health-amount)
    if owner.health-amount <= 0  then
        owner.max_health = 60000;
        owner:AddHealth(60000)
        for i = 1, owner.component_count do 
            local comp2 = owner:GetComponent(i)
            if comp2 ~= nil then 
                --print(comp2.id, "Destroyed")
                --comp2:Destroy()
                Map.Defer(function()comp2:Destroy()end)
            end
        end
        owner.powered_down = true
        --owner:Unplace()

        Map.Delay('destroy_ent', 2, {ent = owner})
    end
end
function Delay.reset_max_health(arg) 

	local bot = arg.ent

	if bot ~= nil then 
		bot.max_health = bot.def.health_points
	end
end
function Delay.destroy_ent(arg) 

	local bot = arg.ent
    --print("Destroying", bot)
	if bot ~= nil then 
		bot:Destroy()
	end
end


-- create a randomized bot 
local function build_random_bot(faction, frame_filter, bonus)

    local cost = 0

    local bot = Map.CreateEntity(faction, random_key(frame_keys, frame_filter))
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
                bot:AddComponent(comp_id,"hidden")
                cost = cost + comp_cost_list.i[comp_id]
            elseif val[2] == "Large" then 
                comp_id = random_key(comp_keys.l)
                bot:AddComponent(comp_id)
                cost = cost + comp_cost_list.l[comp_id]
            end
        end

        --- add bonus hidden comps 
        if bonus > 20 then bonus = 30 end --prevents hidden comps taking all the power
        while bonus >= 1 do 
            bonus = bonus - 1
            local comp_id = random_key(comp_keys.i)
            bot:AddComponent(comp_id,"hidden")
        end 


        bot:AddComponent("cc_damage_check")
        -- add temporary health to prevent dying on the first tick
        bot.max_health = 65535

        -- add a radar so it can automattically hunt 
        local radar = bot:AddComponent("c_alien_sensor_wide")
        radar:SetRegister(1,data.values.v_enemy_faction)
        -- stop it targetting construction sites
        radar:SetRegister(2,data.values.v_robot_faction)
        --always links to the first weapon
        bot:LinkRegisterFromRegister(6,4,radar)
        -- add a soul 
        bot:AddItem("bug_carapace", 1)

        -- attempt to fix error when comps are being removed. 
        -- did not work but still prevents the bot being detroyed the tick it spawns in.
        Map.Delay('reset_max_health', 2, {ent = bot})
        --Map.Delay(function() bot.max_health = bot.def.health_points end)
    end
    return bot, cost
end 

function Delay.Place_random_bot(arg)
        local bot, bot_cost = build_random_bot(arg.faction, arg.frame_filter,arg.bonus)
        bot:Place(arg.cord.x + math.random(-arg.range, arg.range),arg.cord.y + math.random(-arg.range, arg.range), math.random(0,3))
        bot:PlayEffect("fx_pulse")
        --print('spawning', bot.location)
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
	power = -11111,
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
    wait_ticks = 60*5*2,--3min
    range = 10,
})

local function time_delta_to_yield (delta)

    local yield = math.min(20, math.ceil())


    return 
end

function  cc_time_travel_machine:on_add(comp, cause)
    
    if comp.has_extra_data == false then 
        comp.extra_data.delta = 10
        comp.extra_data.supplied = {}
    end
    --- set registers 
    if comp:RegisterIsEmpty(2) then 
        comp:SetRegisterNum(2,math.random(0,30))
    end 


    comp:Activate()
end
local function delta_to_output(delta)
    return math.ceil(10 * delta/1024)
end
local function spawn_robot_attack(comp, cost, options)

    local owner = comp.owner
    local range = options.range or 20
    local cord = owner.location
    local i = 5
    while cost > 0 do 
        Map.Delay("Place_random_bot", i, {faction = "time_bots", cord = cord, range = range, frame_filter = "f_bot", bonus = delta_to_output(comp.extra_data.delta)-1})
        cost = cost - 1
        i = i + 5
    end
end
function  cc_time_travel_machine:on_remove(comp, cause)
    -- spawn attack if removed while working 
    if comp.is_working then 
        spawn_robot_attack(comp, comp:GetRegisterNum(2) + 10, {range = self.range})
        comp.extra_data.delta = math.ceil(comp.extra_data.delta * 0.9)
    end
end

local replace_cube_with <const> = {
    ic_cube_blue = 'ic_cube_green',
    ic_cube_green = 'ic_cube_empty',
    ic_cube_empty = 'ic_cube_red',
    ic_cube_red = 'ic_cube_blue',
}

local function delta_to_warning_text(delta)
    local delta_lvl = delta_to_output(delta)
    if delta_lvl <= 1 then 
        return "Equivalent"
    elseif delta_lvl <= 2 then 
        return "Improved"
    elseif delta_lvl <= 4 then  
        return "Advanced"
    elseif delta_lvl <= 6 then  
        return "Theoretical"
    elseif delta_lvl <= 8 then  
        return "Alien"
    elseif delta_lvl <= 10 then  
        return "Magical"
    elseif delta_lvl <= 12 then  
        return "Mythical"
    elseif delta_lvl <= 16 then  
        return "Impossible"
    elseif delta_lvl <= 20 then  
        return "Unfathomable"
    end
end
local function delta_to_warning_text_colour(delta)
    local delta_lvl = delta_to_output(delta)

    if delta_lvl <= 4 then  
        return "bl"
    elseif delta_lvl <= 9 then  
        return "hl"
    else
        return "rl"
    end
end

local function new_order_id(comp)
    local req <const> = {
    "ic_cube_green", "ic_cube_blue","ic_cube_red","ic_cube_empty",
    "c_adv_portable_turret","c_shield_generator2","c_shield_generator","c_radio_transmitter","c_radio_receiver",
    "ic_soul_angry","ic_soul_happy","phase_leaf","phase_leaf","ic_time_crystal","ic_time_crystal","ic_time_crystal",
    "f_bot_1s_b","f_bot_1m1s","f_flyer_m"
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
        -- collapse time travel machine
        --print("cost__reg", comp:GetRegisterNum(2))
        comp.extra_data.delta = math.ceil(comp.extra_data.delta * 0.9)
        spawn_robot_attack(comp, comp:GetRegisterNum(2), {range = self.range})
        
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
                can_make, missing, no_space = comp:PrepareProduceProcess({[order] = 1},{fused_electrodes = delta_to_output(comp.extra_data.delta)})
            else 
                no_space = comp:PrepareGenerateProcess({fused_electrodes = delta_to_output(comp.extra_data.delta)})

                can_make = false
                local garage = owner:GetSlotsByType("garage")
                for key, val in pairs(garage) do
                    if val.id == order then
                        val.entity:Destroy()
                        can_make = true
                        break
                    end
                end
                -- for frame inputs 
            end
        end
        if can_make then 
            if is_frame == true then 
                
            else 
                comp:FulfillProcess()
            end
            -- update tally 
            comp.extra_data.delta = comp.extra_data.delta + 10
            comp.extra_data.supplied[order] = (comp.extra_data.supplied[order] or 0) + 1 
            -- replace CUBE
            local new_id = replace_cube_with[order]
            if new_id ~= nil then 
                AddCubeThroughFixed(owner,new_id)
                --owner:AddItem(new_id)
            end 

            -- work again
            comp:SetStateStartWork(self.wait_ticks)
            comp:SetRegisterNum(2, math.random(0,30))
            if comp:GetRegisterNum(2) > 10 then comp:FlagRegisterError(2) end 
            comp:PlayEffect('fx_unit_teleport','fx')
            comp:PlayWorkEffect('fx_power_core',"fx")
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
            return "Supply This Item or Unit before the machine\n finishes working for the expedition to keep working"
        end 
        return "Not enough space for items\nor no slots for the Cube or Ectoplasma"
    elseif comp:RegisterIsError(2) then
        return "Warning Extremly Dangerous Defence Response Detected\nKeep jumping for a safer time to collapse the loop"
    end
end
function cc_time_travel_machine:get_ui(comp)
	if comp.owner:FindComponent(comp.base_id, true, 1) ~= comp then return end
	local reg_ui = UI.New([[
<Box width=300 blur=true padding=10>
    <VerticalList child_padding=6>
        <HorizontalList>
            <Text valign=center style=hl text="Time Travel Expedition"/><Spacer fill=true/><Text text={cmpimg}/>
        </HorizontalList>
        
        <HorizontalList>
            <Text text="Current Expedition delta: "/><Text text={years} style="bl"/><Text text=" Years"/>
        </HorizontalList>
        <Text text="Invention of Superconductors at 1024"/>
        <Text text="Lose 10% progress on portal collapse"/>
        <HorizontalList>    
            <Canvas min_width=280>
                <Progress halign=fill margin_top=5 height=12 id=powerprogress color=ui_light/>
            </Canvas>
        </HorizontalList>
        <HorizontalList> 
            <Reg def_id="fused_electrodes" num={reward_num}/><Text text="   Superconductor Density" style = "hl"/>
        </HorizontalList>
        <HorizontalList> 
            <Reg def_id="v_alert" num={reward_num}/><Text text="   Threat Level:" style = "hl"/><Text text={alert_text} style = {alert_style}/>
        </HorizontalList>
    </VerticalList>
</Box>]], {
		cmpimg = '<img id="' .. self.id .. '"/>',
        tooltip = function(w)
			local box = UI.New("<Box bg=popup_box_bg blur=true padding=12/>")
			local r = box:Add("<VerticalList child_align=left child_padding=4/>")
            r:Add("Text", { text = "Supplied items to raiding party"})
            local h = r:Add("<HorizontalList child_align=center child_padding=4/>")
            -- loop through extra data.supplied
            local list_length = 0
			for id,amt in pairs(comp.extra_data.supplied) do
				h:Add("<Reg bg=item_default/>", { def_id = id, num = amt })
                list_length = list_length + 1
                if list_length >= 3 then 
                    h = r:Add("<HorizontalList child_align=center child_padding=4/>")
                    list_length = 0
                end
			end
			return box
		end,
        years = tostring(comp.extra_data.delta),
        reward_num =  delta_to_output(comp.extra_data.delta),
        alert_text = delta_to_warning_text(comp.extra_data.delta),
        alert_style = delta_to_warning_text_colour(comp.extra_data.delta),
        update = function(w)
            w.years = tostring(comp.extra_data.delta)
            w.reward_num =  delta_to_output(comp.extra_data.delta)
            w.alert_text = delta_to_warning_text(comp.extra_data.delta)
            w.alert_style = delta_to_warning_text_colour(comp.extra_data.delta)
            w.powerprogress.progress =  comp.extra_data.delta/1024
        end,
	})
    

	return nil, nil , false, reg_ui
end










-- need to fix bug of unplaced units causing an error message 
-- happens for pulse weapons maybe splash too
-- need to include this as well
-- local function TurretApplyDamage(compdef, comp, enemy, damage, damage_type, damager, extra_effect)
-- 	if damage_type then damage = math.ceil(CalcDamageReduction(damage, enemy.def.shield_type, damage_type)) end
-- 	if (comp.def.damage_air_bonus and enemy.def.cost_modifier) or
-- 		(comp.def.damage_ground_bonus and not enemy.def.cost_modifier) then
-- 		damage = math.ceil(damage * (comp.def.damage_air_bonus or comp.def.damage_ground_bonus))
-- 	end

-- 	AddDamagedEnemy(enemy, damage, damage_type)
-- 	enemy:RemoveHealth(damage, damager, damage_type)
-- 	if enemy.exists and enemy.health > 0 and extra_effect then extra_effect(compdef, comp, enemy) end
-- end
-- data.components.c_turret.damage_func = function(self, comp, e, trgloc)
-- 	local damager, damager_faction = comp.owner, comp.faction
-- 	local damage, damage_type, extra_effect = self.damage, self.damage_type, self.extra_effect
-- 	local degrade = 1

--     -- add a check here for unplaced CUBE MOD
--     --if damager.is_placed == false then return end

-- 	-- If e was destroyed or has moved more than 2 tiles away, see if there is another enemy at the location
-- 	if not e or not e.exists or e:GetRangeSquaredTo(trgloc) > 4 then
-- 		e = Map.GetEntityAt(trgloc.x, trgloc.y)
-- 		if not e or damager_faction:GetTrust(e) ~= "ENEMY" then
-- 			e = nil
-- 		end
-- 	end
-- 	if e then
-- 		-- Damage e for all weapon types except beam (so it will get damaged even if it is a resource or foundation)
-- 		TurretApplyDamage(self, comp, e, damage, damage_type, damager, extra_effect)
-- 		if self.beam_range then degrade = degrade - 0.1 end
-- 	end

-- 	if self.blast then
-- 		if self.blast_fx then
-- 			UI.Run(function() View.PlayEffect(self.blast_fx, trgloc.x, trgloc.y) end)
-- 		end
-- 		local affects_flying = self.affects_flying
-- 		for _,enemy in ipairs(Map.GetEntitiesInRange(trgloc, self.blast, FF_OPERATING|FF_WALL|FF_GATE|FF_ENEMYFACTION, damager_faction)) do
-- 			--  for splash damage, check trust if its an enemy (only specific splash damage affects air units)
-- 			if e ~= enemy and (affects_flying or not IsFlyingUnit(enemy)) then
-- 				TurretApplyDamage(self, comp, enemy, damage // 2, damage_type, damager, extra_effect) -- 50% splash damage
-- 			end
-- 		end
-- 	elseif self.pulse then
-- 		local affects_flying = self.affects_flying
-- 		for _,enemy in ipairs(Map.GetEntitiesInRange(damager, self.pulse, FF_OPERATING|FF_WALL|FF_GATE|FF_ENEMYFACTION)) do
-- 			-- check trust if its an enemy (only specific pulse damage affects air units)
-- 			if e ~= enemy and (affects_flying or not IsFlyingUnit(enemy)) then
-- 				TurretApplyDamage(self, comp, enemy, damage, damage_type, damager, extra_effect)
-- 			end
-- 		end
-- 		if self.explode then
-- 			Map.Delay("DelayedDestroyEntity", self.explode, { ent = comp.owner })
-- 		end
-- 	elseif self.beam_range then -- beam style (railgun)
-- 		for _,enemy in ipairs(Map.GetEntitiesOnLine(damager, trgloc, self.beam_range, FF_OPERATING|FF_WALL|FF_GATE|FF_ENEMYFACTION)) do -- TODO: needs to specifically add in the target entity
-- 			TurretApplyDamage(self, comp, enemy, math.floor(damage * degrade), damage_type, damager, extra_effect)
-- 			degrade = degrade - 0.1
-- 			if degrade <= 0.1 then break end
-- 		end
-- 	end
-- end

-- data.components.c_portable_radar.on_update = function(self, comp, cause)
--     --if comp.owner.is_placed == false then return end 
-- 	local numregs, filters, passthrough = comp.register_count
-- 	for i=1,numregs-1 do
-- 		local regnum, regid, regentity = comp:GetRegisterData(i)
-- 		if regid then
-- 			if not filters then
-- 				filters = { regid, regnum, nil, nil, nil, nil }
-- 			else
-- 				local n = #filters
-- 				filters[n+1], filters[n+2] = regid, regnum
-- 			end
-- 		elseif regentity and not passthrough then
-- 			passthrough = regentity
-- 		end
-- 	end

-- 	if not filters then
-- 		if numregs > 0 then
-- 			comp:SetRegister(numregs, { entity = passthrough }) -- passthrough for entity
-- 		end
-- 		if self.radar_show_area then
-- 			if cause & CC_FINISH_WORK == CC_FINISH_WORK then
-- 				--print("[portable_radar] Start Work")
-- 				return comp:SetStateSleep(10)
-- 			end

-- 			local loc = comp.owner.location
-- 			local len
-- 			if comp.owner.visibility_range > self.range then
-- 				len = math.random(self.range, comp.owner.visibility_range)
-- 			else
-- 				len = math.random(comp.owner.visibility_range, self.range)
-- 			end

-- 			local ang_deg = Map.GetTick()%360
-- 			local loc_x = loc.x + math.floor(math.cos(math.rad(ang_deg))*(len))
-- 			local loc_y = loc.y + math.floor(math.sin(math.rad(ang_deg))*(len))
-- 			local self_range, comp_owner = self.radar_show_range+1, comp.owner

-- 			local comp_faction = comp.faction
-- 			Map.Defer(function()
-- 				Map.SpawnChunks(loc_x-self_range-1, loc_y-self_range-1, (self_range*2)+2, (self_range*2)+2, comp_owner)
-- 				comp_faction:RevealArea(loc_x, loc_y, self_range)
-- 			end)

-- 			Map.Delay("RadarHideArea", self.charge_time+10, { faction = comp_faction, x = loc_x, y = loc_y, range = self_range })
-- 			return comp:SetStateStartWork(self.charge_time)
-- 		end
-- 		return
-- 	end

-- 	--------- mothership scanning using long range radar
-- 	if filters[1] == "v_mothership" and (comp.id == "c_radar" or comp.id == "c_radar_array") then
-- 		if comp.faction.extra_data.mothership == nil then
-- 			Map.Defer(function()
-- 				-- spawn it the first time you scan for it from a satellite
-- 				comp.faction.extra_data.mothership = Map.CreateEntity(comp.faction, "f_mothership")
-- 				comp.faction.extra_data.mothership:AddComponent("c_mothership_repair")
-- 				comp.faction.extra_data.mothership:AddComponent("c_mothership_eject")
-- 				--local fix = comp.faction.extra_data.mothership:AddComponent("c_explorable_fix", "hidden")
-- 				--fix.extra_data.explorable_fix = "anomaly_particle"
-- 			end)
-- 		elseif comp.faction.extra_data.mothership:FindComponent("c_mothership_eject") == nil then
-- 			Map.Defer(function()
-- 				comp.faction.extra_data.mothership:AddComponent("c_mothership_eject")
-- 			end)
-- 		end
-- 		comp:SetRegister(numregs, { entity = comp.faction.extra_data.mothership, })
-- 		return comp:SetStateSleep(self.charge_time)
-- 	end
-- 	---------

-- 	if cause & CC_FINISH_WORK ~= CC_FINISH_WORK then
-- 		--print("[portable_radar] Start Work")
-- 		if comp.is_working then
-- 			return comp:SetStateContinueWork()
-- 		end
-- 		return comp:SetStateStartWork(TICKS_PER_SECOND)
-- 	end

-- 	local owner = comp.owner
-- 	local loc = owner.location
-- 	local range = self.range
-- 	local num = REG_INFINITE
-- 	Map.SpawnChunks(loc.x-(range//2), loc.y-(range//2), range, range, owner)
-- 	local entity_filter, override_range = PrepareFilterEntity(filters)
-- 	local closest_entity = Map.FindClosestEntity(owner, (override_range and math.min(math.max(override_range, 0), range) or range),
-- 		function(e)
-- 			local a,b = FilterEntity(owner, e, filters)
-- 			if a and b then num = b end
-- 			return a
-- 		end, entity_filter)

-- 	-- check result
-- 	if closest_entity then
-- 		comp:SetRegister(numregs, { entity = closest_entity, num = num })

-- 		local faction = owner.faction
-- 		if not faction:IsVisible(closest_entity) then
-- 			local show_range, ent_x, ent_y = self.radar_show_range, closest_entity:GetLocationXY()
-- 			faction:RevealArea(ent_x, ent_y, show_range)
-- 			Map.Delay("RadarHideArea", 23, { faction = faction, x = ent_x, y = ent_y, range = show_range })
-- 		end
-- 	else
-- 		comp:SetRegister(numregs, nil)
-- 	end
-- 	return comp:SetStateSleep(self.charge_time)
-- end
--<Image halign=fill margin=2 margin_top=42 height=8 id=powerexcess color=ui_light image=progress_mask/>
        -- req_comp = {'c_integrated_power_cell'},
        -- items = {fused_electrodes = 1},

-- TODO known bug is the requirement will change on uneqip/requip of the components

local ruined_visuals = { "v_simulator_ruined", "v_2x2_a_ruined","v_explorable_building_4","v_explorable_building_6","v_explorable_building_3", "v_battery_01_l_ruined", "v_missile_launcher_m_ruined","v_transporter_01_m_ruined","v_crashedship_2x1_moss","v_crashedship_2x1_desert","v_explorable_glitchbuilding" }

function Place_enemy_fort(x,y,cost)

	local start_area_size = math.min(math.max(cost,1),5)
    local faction = "time_bots"
    if cost < 1 then cost = 1 end 
    
	CreateFoundationsFromCentre(x, y, start_area_size,start_area_size,"f_human_foundation_basic",faction)
	--spawn wals 
	for n = -start_area_size, start_area_size do 
		if math.random() > 0.05 then 
			--horizontal
			local wall = Map.CreateEntity(faction, "f_wall_bli")
			wall:Place(x + n, y+start_area_size, false)
			wall = Map.CreateEntity(faction, "f_wall_bli")
			wall:Place(x + n, y-start_area_size, false)
			--vertical
			wall = Map.CreateEntity(faction, "f_wall_bli")
			wall:Place(x + start_area_size, y+n, false)
			wall = Map.CreateEntity(faction, "f_wall_bli")
			wall:Place(x - start_area_size, y+n, false)

		end
	end
    start_area_size = start_area_size - 1
    -- storage with souls 
    local storage = Map.CreateEntity(faction,"f_building1x1g")
    storage:AddItem("bug_carapace",(cost+3)*(cost+1)*2)
    storage:Place(x,y,math.random(0,3))

    local anti_cost = 10 - cost
    while cost > 0 do 
        Delay.Place_random_bot({
            faction = "time_bots",
            cord = {x = x, y = y},
            range = start_area_size,
            frame_filter = "f_building",
            bonues = 15,
        })
        cost = cost - 1
    end
    -- place derelict structures 
    while anti_cost > 0 do 
        PlaceResourceNode({x = math.random(-start_area_size,start_area_size) + x, y = math.random(-start_area_size,start_area_size) + y},
            "concreteslab", math.random(100,2000),"f_resourcenode_concrete",
            ruined_visuals[math.random(1,#ruined_visuals)])
        anti_cost = anti_cost - 1
    end
end
























