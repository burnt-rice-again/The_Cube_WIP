local layout =
[[
	<HorizontalList dock=top-left child_align=center child_padding=4>
		<HorizontalList id=horizinfo child_align=center child_padding=4/>
		<VerticalList child_padding=4>
			<Text id=hovertext style=header/>
			<VerticalList id=vertinfo child_padding=4/>
		</VerticalList>
	</HorizontalList>
]]

local HoverEntity = { }
UI.Register("HoverEntity", layout, HoverEntity)

function HoverEntity:construct()
	self.hidden = true
end

function HoverEntity:destruct()
	if self.entity then View.HighlightEntity(nil) end
end

function HoverEntity:update()
	if not self.entity or not self.entity.exists then return end

	for _,reg in ipairs(self.horizinfo) do
		if reg.is_resource then
			reg.num = self.entity:GetRegisterNum(FRAMEREG_GOTO)
		elseif reg.slot and reg.slot.exists then
			reg.num = reg.slot.stack
			reg.hidden = reg.num <= 0
		end
	end
end

function HoverEntity:every_frame_update(dt, force_update)
	local entity = self.entity
	if not entity or not entity.exists then return end

	local shift = Input.IsShiftDown()
	if self.shift ~= shift or force_update then
		self.shift = shift
		if self.have_inventory then
			local inventorybox = self.inventorybox
			if shift and not inventorybox then
				inventorybox = self.vertinfo:Add("<Box padding=8><Inventory/></Box>")
				inventorybox[1].entity = entity
				self.inventorybox = inventorybox
			end
			if inventorybox then
				inventorybox.hidden = not shift
				if shift then inventorybox[1]:update() end
			end
		end
	end

	--local x, y = UI.GetMousePosition()
	local success, x, y = UI.EntityLocationOnScreen(entity, true, true)
	self.hidden = not success
	if success then
		self:SetPosition(x+30, y-10)
	end
end

function HoverEntity:SetEntity(entity, play_sound)
	if entity == self.entity then return end

	View.HighlightEntity(entity)
	self.entity = entity

	self.horizinfo:Clear()
	self.vertinfo:Clear()
	self.vertinfo.update = nil
	if not entity or not entity.exists then
		self.hidden = true
		self.hovertext.text = ""
		return
	end

	if play_sound then UI.PlaySound("fx_ui_MOUSE_HOVER") end

	-- check if its a resource
	local entity_def = entity.def
	if entity_def.type == "Resource" then
		local res_reg = entity:GetRegister(FRAMEREG_GOTO)
		local res_reg_def = data.all[res_reg.id]
		if res_reg_def then
			self.hovertext.text = (res_reg_def.name or res_reg.id)
			self.horizinfo:Add("<Reg width=48 height=48 bg=item_default/>", { def = res_reg_def, num = res_reg.num, is_resource = true })
		end
	else
		self.hovertext.text = GetEntityName(entity)
		if entity_def.type == "DroppedItem" then
			for _,slot in ipairs(entity.slots) do
				if slot.stack > 0 then
					self.horizinfo:Add("<Reg width=48 height=48 bg=item_default/>", { def_id = slot.id, num = slot.stack })
				end
			end
			if View.GetSelectedEntity() then
				self.vertinfo:Add("Text", { text = '<Key action="ExecuteAction" style="hl"/> to pick up' })
			end
		elseif entity.is_construction then
			local con_comp, frame_def, frame_id, bp, pausedtxt, progbar, ingredlist
			local function update_construction()
				if not con_comp then
					frame_id, bp = GetConstructionSiteIdOrBP(entity, true)
					con_comp = entity:FindComponent("c_construction", true) or entity:FindComponent("c_deploy_construction")
					frame_def = data.frames[bp and bp.frame or frame_id]
					self.hovertext.text = L('<img id="v_construction"/>%s', frame_def and frame_def.name or "Deployment Site")
					self.horizinfo:SetContent("<Image width=48 height=48/>", { image = (frame_def or entity.def).texture })
				end
				if not entity.exists or (con_comp and not con_comp.exists) then return end
				local powered_down, working = entity.powered_down, con_comp and con_comp.is_working
				if not powered_down ~= not pausedtxt then
					if pausedtxt then pausedtxt:RemoveFromParent() end
					pausedtxt = powered_down and self.vertinfo:Add('<Text text="<rl>Paused Construction</>"/>') or nil
				end
				if not working ~= not progbar then
					if progbar then progbar:RemoveFromParent() end
					progbar = working and self.vertinfo:Add('<Progress height=16 width=64 color=green/>', { every_frame_update = function()
						if not con_comp.exists then return end
						progbar.progress = (con_comp.has_active_effects or entity.powered_down) and con_comp.interpolated_progress or 1.0
						update_construction()
					end })
				end
				if not not working ~= not ingredlist then
					if ingredlist then ingredlist:RemoveFromParent() end
					ingredlist = not working and self.vertinfo:Add('<HorizontalList child_padding=4/>', { update = function(hl, first_update)
						local show_recipe = first_update and frame_def and con_comp.id == "c_construction" and (frame_def.construction_recipe or frame_def.production_recipe)
						if show_recipe then
							local skip = con_comp.extra_data.skip or {}
							local ingredients = GetIngredients(show_recipe, bp)
							for k,v in pairs(ingredients) do
								if not skip[k] then
									ingredlist:Add("<Reg width=48 height=48 bg=item_default/>", { def_id = k, ingred_max = v })
								end
							end
						end
						for i=#ingredlist,1,-1 do
							local reg = ingredlist[i]
							reg.num = entity.exists and math.max(reg.ingred_max - entity:CountItem(reg.def_id), 0) or 0
							if reg.num == 0 then reg:RemoveFromParent() end
						end
						update_construction()
					end })
				end
			end
			update_construction()
		elseif IsExplorable(entity) then
			self.hovertext.text = entity.visual_def.explorable_name or self.hovertext.text

			local lootable = entity.lootable
			if lootable then
				local horiz = self.vertinfo:Add("<HorizontalList child_padding=4/>")
				for k,v in ipairs(entity.slots) do
					local num = v.unreserved_stack
					if num > 0 then
						horiz:Add("<Reg width=48 height=48 bg=item_default/>", { def_id = v.id, num = num })
					end
				end
			end

			local solved = lootable and (entity.has_extra_data and entity.extra_data.solved)
			self.vertinfo:Add("<Text style=res/>", { text = solved and "Solved" or "Right click to investigate", color = solved and "green" or "white" })

			local open = lootable or (not entity:FindComponent("c_explorable_scannable") and entity.has_extra_data and entity.extra_data.visited)
			local show_fix = open and not solved --and entity:FindComponent("c_explorable_fix", true)
			if show_fix then
				for i=1,999 do
					show_fix = entity:FindComponent("c_explorable_fix", true, i)
					if not show_fix then break end

					local show_fix_ed = show_fix.has_extra_data and show_fix.extra_data
					local show_fix_item = (not show_fix_ed or not show_fix_ed.ok) and ((show_fix_ed and show_fix_ed.explorable_fix) or show_fix.def.explorable_fix)
					if show_fix_item then
						local horiz = self.vertinfo:Add("<HorizontalList child_padding=4/>")
						horiz:Add("<Reg width=32 height=32 bg=item_default/>", { def_id = show_fix_item })
						horiz:Add("<Text style=res valign=center/>").text = show_fix.def.name
					end
				end
			end
			local show_fabricator = open and entity:FindComponent("c_fabricator", true)
			if show_fabricator then
				local show_fabricator_prod = show_fabricator:GetRegisterId(1)
				local show_fabricator_recipe = show_fabricator_prod and data.all[show_fabricator_prod].production_recipe
				if show_fabricator_recipe then
					local horiz = self.vertinfo:Add("<HorizontalList child_padding=4/>")
					horiz:Add("<Reg width=32 height=32 bg=item_default/>", { def_id = show_fabricator_prod })
					horiz:Add('<Text style=res valign=center text="Production"/>')
				end
			end
		elseif entity.powered_down then
			self.vertinfo:Add("Text", {text = "<rl>Powered Down</>"})
		end
	end

	local owned = entity.faction == Game.GetLocalPlayerFaction()
	self.have_inventory = owned and entity.slot_count > 0 and not entity.is_construction
	self.inventorybox = nil

	local selectors = owned and Game.GetEntitySelectedPlayerId(entity)
	if selectors then
		for _,player_id in ipairs(selectors) do
			self.vertinfo:Add("Text", { text = L("Selected by: %S", Game.GetPlayerName(player_id)) })
		end
	end

	self:every_frame_update(0, true)
end

local hover_entity_ui, hover_entity_disabled, hovered_grid

function DisableHoverEntity()
	hover_entity_disabled = (hover_entity_disabled or 0) + 1
	if hover_entity_ui then
		hover_entity_ui:RemoveFromParent()
		hover_entity_ui = nil
	end
end

function EnableHoverEntity()
	hover_entity_disabled = (hover_entity_disabled > 1 and hover_entity_disabled - 1 or nil)
end

function UIMsg.OnEntityHovered(entity, x, y, is_drag_drop)
	if hover_entity_disabled then return end

	if not hover_entity_ui then
		hover_entity_ui = UI.AddLayout("HoverEntity", -1)
		hover_entity_ui:SetIgnoreHitTest() -- don't accept input or drag and dropping
	end
	hover_entity_ui:SetEntity(entity, is_drag_drop)

	local hover_grid = is_drag_drop and not UI.IsMouseOverUI() and not entity or nil
	if hovered_grid ~= hover_grid then
		if hover_grid then
			Quickview_ShowGrid(0)
		else
			Quickview_HideGrid()
		end
		hovered_grid = hover_grid
	end
end
