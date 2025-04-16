extends Button

@export var player_resources_changed: Event
@export var player_inventory: PlayerInventory
@export var shop_inventory: ShopInventory

func _on_pressed():
	player_inventory.gold += owner.material_price
	match owner.mat:
		"claws":
			player_inventory.claws -= 1
			shop_inventory.materials["claws"] += 1
		"hoofs":
			player_inventory.hoofs -= 1
			shop_inventory.materials["hoofs"] += 1
		"scales":
			player_inventory.scales -= 1
			shop_inventory.materials["scales"] += 1
		"shards":
			player_inventory.shards -= 1
			shop_inventory.materials["shards"] += 1
		"essence":
			player_inventory.essence -= 1
			shop_inventory.materials["essence"] += 1
		"keys":
			player_inventory.keys -= 1
			shop_inventory.materials["keys"] += 1
			
	owner.stock -= 1
	
	player_resources_changed.emit_signal("event_triggered")
	
	if owner.stock <= 0:
		owner.queue_free()
	else:
		owner._set_stock()
