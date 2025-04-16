extends Button

var already_pressed: bool = false

@export var player_resources_changed: Event
@export var player_items_changed: Event

@export var player_items_editor: Node

@export var player_inventory: PlayerInventory
@export var shop_inventory: ShopInventory

func _on_pressed() -> void:
	if already_pressed:
		return
	already_pressed = true
	
	player_inventory.gold += owner.item.item_price
	
	player_items_editor._remove_item(owner.item)
	shop_inventory.items.append(owner.item)
	
	player_resources_changed.emit_signal("event_triggered")
	player_items_changed.emit_signal("event_triggered")
	
	owner.queue_free()
