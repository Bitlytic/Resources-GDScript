class_name Inventory

signal updated

const SIZE := 8

var items : Array[ItemStack] = []


func _init():
	for slot in SIZE:
		items.append(ItemStack.new(Items.EMPTY, 0))


# Take in ItemStack, add in relevant slots, returns either adjusted ItemStack or Empty
func add_item(new_stack: ItemStack) -> ItemStack:
	
	for stack in items:
		if new_stack.is_empty():
			break
		
		# If the slot contains the item and had headroom, fill it as much as we can
		if stack.item == new_stack.item && stack.count < stack.max_count:
			stack.count += new_stack.count
			
			var overload = stack.count - stack.max_count
			
			stack.count = clamp(stack.count, 0, stack.max_count)
			
			if overload <= 0:
				new_stack = ItemStack.new(Items.EMPTY)
			else:
				new_stack.count = overload
	
	for stack in items:
		if new_stack.is_empty():
			break
		
		# If the slot is empty, just take the stack wholesale
		if stack.is_empty():
			stack.item = new_stack.item
			stack.count = new_stack.count
			new_stack = ItemStack.new(Items.EMPTY)
	
	updated.emit()
	
	# Return any remaining items
	return new_stack


func remove_item(item: Item, count: int) -> void:
	
	for stack in items:
		
		if count <= 0:
			break
		
		# If this stack contains the item, remove as much as we can
		if stack.item == item:
			var diff = stack.count - count
			
			stack.count = max(stack.count - count, 0)
			
			if diff <= 0:
				stack.item = Items.EMPTY
				# Here's the leftover count we need to remove
				count = abs(diff)
			else:
				count = 0
	
	updated.emit()


func has_count(item: Item, count: int) -> bool:
	
	var total := 0
	for stack in items:
		if stack.item == item:
			total += stack.count
			
			if total >= count:
				return true
	
	return false


func _to_string() -> String:
	var s = ""
	
	for stack in items:
		s += str(stack) + "\n"
	
	return s
