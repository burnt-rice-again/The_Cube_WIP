---------------------------------
---This method is mostly depreceated by alt recipes
---Cube Recharger and Melter are still used 
----------------------------------

-- scrap sorter

-- depreceated for other component cc_scrap_fabricator
local cc_scrap_converter = Comp:RegisterComponent("cc_scrap_converter", {
	name = "Scrap Recycler",
	texture = "Main/textures/icons/human/Human_Building_2x2_Refinery.png",
	desc = "Manipulates various resources into other resources. Usable inside the blight",
	race = "robot",
	attachment_size = "Medium",
	power = -20, 
	visual = "v_blight_converter",
	--production_recipe = CreateProductionRecipe({ metalbar = 10, datakey_robot = 2, metalplate = 5 }, { c_fabricator = 60 }),
	activation = "OnAnyItemSlotChange",
	registers = { { read_only = true, tip = "Converting" }  },
	requires_blight = false,
	production_recipe = CreateProductionRecipe({ metalbar = 10, datakey_robot = 2, metalplate = 5 }, { c_fabricator = 60 })
})

cc_scrap_converter.recipes = {
	{ 	id = "metalore", 
		desc = "Basic scrap recyling",
		amt = {["metalore"] = 20} , 
		t = 50, 
		to = { ["concreteslab"] = 10, ["steelblock"] = 10} ,
	},
	{ 	id = "aluminiumrod", 
		desc = "Search For More Valuable Materials",
		amt = {["metalore"] = 20, ["datakey_robot"] = 1} , 
		t = 50,
		to = {["aluminiumrod"] = 5},
		tech = "tc_cube_aluminium",
	},
	{ 	id = "phase_leaf", 
		desc = "Destroy excess seeds",
		amt = {["cc_plant_seed"] = 1} , 
		t = 5, 
		to = {["phase_leaf"] = 1},
		tech = "tc_cube_green_discovery",
	},
	{ 	id = "phase_leaf", 
		amt = {["cc_plant_seed2"] = 1} , 
		t = 5, 
		to = {["phase_leaf"] = 1},
		tech = "tc_cube_green_discovery",
	},
	{ 	id = "aluminiumrod", 
		amt = {["metalore"] = 60, ["ic_cube_blue"] = 1, ["aluminiumrod"] = 1} , 
		t = 50, 
		to = {["aluminiumrod"] = 30},
		cube_out = "ic_cube_empty",
		tech = "tc_cube_scrapping",
	},
}


-- local function FulfillProcessCustom(recipe, entity){

-- 	for input, amt in pairs(recipe.amt) do 
-- 		entity:RemoveItem()


-- }
-- local function replace_cube(recipe, entity)
-- 	--print(recipe)
-- 	if recipe.byproduct ~= nil then 
-- 		for waste,num in pairs(recipe.byproduct) do
-- 			--print(waste)
-- 			--print(num)
-- 			entity:AddItem(waste)
-- 		end 
-- 	end 
-- end

function cc_scrap_converter:get_ui(comp)
	if comp.owner:FindComponent(comp.base_id, true, 1) ~= comp then return end
	local reg_ui = UI.New('<Box width=240 blur=true padding=10><HorizontalList><Text valign=center style=hl text="'.. self.name ..'"/><Spacer fill=true/><Text text={cmpimg}/></HorizontalList></Box>', {
		cmpimg = '<img id="' .. self.id .. '"/>',
		tooltip = function(w)
			local box = UI.New("<Box bg=popup_box_bg blur=true padding=12/>")
			local r = box:Add("<VerticalList child_align=left child_padding=4/>")
			local added
			local hidden = 0
			for k,v in pairs(self.recipes) do
				
				if v.tech == nil or comp.faction:IsUnlocked(v.tech) then 
					if not added then added = true r:Add("Text", { text = L("<hl>%s</>", "Known Recipes"), size = 30 }) end

					if v.desc ~= nil then
						r:Add("Text",{text = v.desc})
					end
					local h = r:Add("<HorizontalList child_align=center child_padding=4/>")
					-- display inputs 
					for ing, amt in pairs(v.amt) do
						--print(ing, amt)
						h:Add("<Reg bg=item_default/>", { def_id = ing, num = amt })
					end
					if v.requires_blight == true then 
						h:Add("<Reg bg=item_default/>", { def_id = "v_blight"})
					end


					--h:Add("<Reg bg=item_default/>", { def_id="icon_small_time", num = v.t/5 })
					h:Add("<Image image=icon_small_time/>")
					h:Add("text",{text = tostring(math.floor(v.t/5))})
					h:Add("<Image image=icon_small_arrow/>")
					
					--TODO add time
					--h:Add(tostring(v.t).."s")
					--display outputs
					if v.cube_out ~= nil then 
						h:Add("<Reg bg=item_default/>", { def_id = v.cube_out})
					end

					for k2,v2 in pairs(v.to) do

						h:Add("<Reg bg=item_default/>", { def_id = k2, num = v2 })
						
					end
				else
					hidden = hidden + 1
				end
			end
			if not added then r = L("<hl>%s</>", "No Known Recipes") end
			if hidden > 0 then 
				r:Add("Text",{text = L("There are ".. hidden .. " Unknown Recipes")})
			end
			return box
		end
	})
	return nil, nil, false, reg_ui
end

function cc_scrap_converter:get_reg_error(comp)
	if self.requires_blight then
		local blightpower = Map.GetSave().dust_storm or Map.GetBlightnessDelta(comp, -1) >= 0
		if not blightpower then
			return "Must be placed inside the blight"
		end
	end
	return "Not enough room for output"
end

function cc_scrap_converter:on_update(comp, cause)
	local work_finished = (cause & CC_FINISH_WORK == CC_FINISH_WORK)
	if work_finished then
		
		local id = comp:GetRegisterId(1)
		comp:SetRegister(1, nil)
		comp:FulfillProcess()
		comp:StopEffects()

		-- add cube back 
		for index, recipe in ipairs(self.recipes) do 
			-- find one with same id 
			if recipe.id == id then 
				
				if recipe.cube_out ~= nil then 
					--print("Add Cube")
					AddCubeThroughFixed(comp.owner,recipe.cube_out)
				end
				break
			end
		end
	end

	-- if self.requires_blight then
	-- 	-- must be placed in the blight to start working
	-- 	local blightpower = Map.GetSave().dust_storm or Map.GetBlightnessDelta(comp, -1) >= 0
	-- 	if not blightpower then
	-- 		--comp:FlagRegisterError(1)
	-- 		comp:SetRegister(1, nil)
	-- 		comp:StopEffects()
	-- 		return comp:SetStateSleep(TICKS_PER_SECOND)
	-- 	end
	-- end

	if not work_finished and comp.is_working then return comp:SetStateContinueWork() end

	local owner = comp.owner
	local check_blightness = Map.GetBlightnessDelta(owner.location.x, owner.location.y, -1) >= 0
	for _,conv in ipairs(self.recipes) do
		--print(conv.t)
		if type(conv.amt) ~= "table" then
			-- just a number
			if owner:CountItem(conv.id) >= conv.amt then
				if comp:PrepareProduceProcess(conv.amt, conv.to, 1) then
					comp:SetRegister(1, { id = conv.id, num = conv.amt[0] })
					return comp:SetStateStartWork(conv.t, false)
				end
			end
		else 
			-- my modification here
			if conv.requires_blight ~= true or check_blightness then
				
				-- check all ingriendents are ready
				local check = true
				for ingredient, amount in pairs(conv.amt) do
					if owner:CountItem(ingredient) < amount then check = false break end
				end
				-- has all items
				if check and comp:PrepareProduceProcess(conv.amt, conv.to, 1) then
					comp:SetRegister(1, { id = conv.id, num = conv.amt })
					if conv.effect ~= nil then 
						comp:PlayEffect(conv.effect)
					end
					return comp:SetStateStartWork(conv.t, false)
				end
			end
		end
	end
end


-- recharge the cube 
cc_scrap_converter:RegisterComponent("cc_cube_recharger", {
	name = "Cube Recharger",
	texture = "Main/textures/icons/components/Component_BlightPowerGenerator_01_M.png",
	desc = "Uses Ridiculous amounts of power to Recharge The Cube",
	attachment_size = "Small",
	visual = "v_blightpowergenerator_01_m",
	power = -500,
	production_recipe = CreateProductionRecipe({ metalplate = 5, crystal = 20, datakey_robot = 1 }, { c_fabricator = 30, c_assembler = 20 }),
	recipes = {
		{ 	id = "ic_cube_green", 
		amt = {["ic_cube_empty"] = 1} , 
		t = 100,
		to = {},
		cube_out = "ic_cube_green",
		effect = "fx_blight_extract",
		requires_blight = true ,
		tech = "tc_cube_green_discovery",
		},
		{ 	id = "bug_carapace", 
		amt = {["ic_cube_empty"] = 1, ["ic_soul_plasma"] = 1} , 
		t = 5, 
		to = {},
		cube_out = "ic_cube_blue",
		effect = "fx_blight_extract"
		},
		{ 	id = "ic_cube_empty", 
		amt = {["ic_cube_empty"] = 1} , 
		t = 100, 
		to = {},
		cube_out = "ic_cube_blue",
		effect = "fx_blight_extract"
		},
		{ 	id = "ic_cube_red", 
		amt = {["ic_cube_red"] = 1} , 
		t = 10, 
		to = {},
		cube_out = "ic_cube_blue",
		effect = "fx_blight_extract",
		desc = "Emergency Cube Cooling"
		},
		{ 	id = "ic_cube_empty", 
		amt = {["ic_cube_green"] = 1} , 
		t = 10, 
		to = {},
		cube_out = "ic_cube_empty",
		effect = "fx_blight_extract",
		desc = "Cube Settling"
		},
	},
})

-- melt the cube 
cc_scrap_converter:RegisterComponent("cc_cube_melter", {
	name = "Cube Furnace",
	texture = "Main/textures/icons/values/plateau.png",
	desc = "Melt away everything that isnt essential",
	attachment_size = "Hidden",
	--visual = "v_blightpowergenerator_01_m",
	power = 0,
	--production_recipe = CreateProductionRecipe({ steelblock = 5, crystal = 10, concreteslab = 10 }, { c_fabricator = 30, }),
	production_recipe = false,
	recipes = {
		{ 	id = "ic_cube_empty", 
		amt = {["ic_cube_empty"] = 1} , 
		t = 5, 
		to = {},
		cube_out = "ic_cube_red",
		--effect = "fx_alien_monolith_lightning"
		},
		{ 	id = "ic_cube_blue", 
		amt = {["ic_cube_blue"] = 1} , 
		t = 5, 
		to = {},
		cube_out = "ic_cube_red",
		--effect = "fx_alien_monolith_lightning"
		}
	},
})

-- cc_scrap_converter:RegisterComponent("cc_red_cube_refinery", {
-- 	name = "Mantle Tear",
-- 	texture = "Main/textures/icons/alien/alienbuilding_alienheart.png",
-- 	desc = "Refined Sadness petrified into a moment of anguish\n\nProvides Alternative Crafting recipes ",
-- 	attachment_size = "Large",
-- 	visual = "v_explorable_blightanomaly_01",
-- 	--power = -500,
-- 	production_recipe = CreateProductionRecipeWithWaste({ ic_cube_red = 1, crystal_powder = 100, aluminiumsheet = 40}, { cc_manifest = 30, }, 1, {ic_cube_red = 1}),
-- 	recipes = {
-- 		{ id = "metalbar", 
-- 		amt = {["ic_cube_red"] = 1, ["metalore"] = 160, } , 
-- 		t = 15, 
-- 		to = {["metalbar"] = 120, ["aluminiumrod"] = 40},
-- 		cube_out = "ic_cube_empty",
-- 		desc = "Scrap Melting",
-- 		effect = "fx_alien_core",
-- 		},
-- 		{ 	id = "reinforced_plate", 
-- 		amt = {["ic_cube_red"] = 1, ["metalbar"] = 80, ["steelblock"] = 80, } , 
-- 		t = 15, 
-- 		to = {["reinforced_plate"] = 160},
-- 		cube_out = "ic_cube_empty",
-- 		desc = "Reinforced Plate Forging",
-- 		effect = "fx_alien_core",
-- 		},
-- 		{ 	id = "steelblock", 
-- 		amt = {["ic_cube_red"] = 1, ["metalbar"] = 80, ["concreteslab"] = 40, } , -- TODO change to biomass?
-- 		t = 15, 
-- 		to = {["steelblock"] = 160}, 
-- 		cube_out = "ic_cube_empty",
-- 		desc = "Steel Mixing",
-- 		effect = "fx_alien_core",
-- 		},
-- 		{ 	id = "fused_electrodes", 
-- 		amt = {["ic_cube_red"] = 1, ["crystal_powder"] = 60, ["aluminiumrod"] = 40, } , -- TODO change to biomass?
-- 		t = 15, 
-- 		to = {["fused_electrodes"] = 40}, 
-- 		cube_out = "ic_cube_empty",
-- 		desc = "Steel Mixing",
-- 		tech = "tc_",
-- 		effect = "fx_alien_core",
-- 		},

-- 	},
-- })

-- split the cube 
-- cc_scrap_converter:RegisterComponent("cc_cube_splitter", {
-- 	name = "Cube Splitter",
-- 	texture = "Main/textures/icons/values/plateau.png",
-- 	desc = "A ray of distilled emotion can cut into an already molten Cube\n\nThe Power Required is extreme",
-- 	attachment_size = "Large",
-- 	visual = "v_human_powerplant",
-- 	power = -100000,
-- 	production_recipe = CreateProductionRecipe({ reinforced_plate = 64, ic_soul_angry = 16, concreteslab = 10 }, { c_fabricator = 30, }),
-- 	--production_recipe = false,
-- 	recipes = {
-- 		{ 	id = "ic_cube_red", 
-- 		amt = {["ic_cube_red"] = 1} , 
-- 		t = 300, 
-- 		to = {ic_cube_sphere = 1},
-- 		cube_out = "ic_cube_empty",
-- 		},
-- 		{ 	id = "datakey_robot", 
-- 		amt = {["ic_cube_empty"] = 1, ic_soul_happy = 10} , 
-- 		t = 300, 
-- 		to = {datakey_robot = 100},
-- 		cube_out = "ic_cube_blue",
-- 		},
-- 		-- some hidden recipes 

-- 	},
-- })