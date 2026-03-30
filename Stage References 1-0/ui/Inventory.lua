local Inventory = {}
UI.Register("Inventory", "Wrap", Inventory)

function Inventory:update()
	-- check all slots for changes
	self.wrapsize=63*12
	local have_entity = self.entity and self.entity.exists
	local entity_slots = have_entity and self.entity.slots or {}
	if self.last_num ~= #entity_slots or self.last_slot ~= entity_slots[#entity_slots] then
		local is_explorable = have_entity and IsExplorable(self.entity)
		self.last_num = #entity_slots
		self.last_slot = entity_slots[#entity_slots]
		self:Clear()
		for i,slot in ipairs(entity_slots) do
			if not is_explorable or not slot.component then -- dont show comp slots on explorables
				local slotw = self:Add("ItemSlot", { orig_i = i, slot = slot, num = false })
				if self.on_slot_click then
					slotw.on_click = function(w)
						self:SendEvent("on_slot_click", w.slot)
					end
				end
			end
		end
	end

	for i,w in ipairs(self) do
		local slot = entity_slots[i]
		if w.slot ~= slot or w.id ~= slot.id or w.num ~= slot.stack or (w.reserved_stack + w.reserved_space) ~= (slot.reserved_stack + slot.reserved_space) or slot.locked ~= w.locked then
			w.slot = slot
			w:UpdateInfo()
		end
	end

	-- sort slots
	local typeorder = data.item_slot_order
	self:SortChildren(function(a,b)
		local at, bt = a.slot.type, b.slot.type
		local ao, bo = typeorder[at] or 999, typeorder[bt] or 999
		return (ao == bo and a.orig_i < b.orig_i) or (ao < bo)
	end)
end
