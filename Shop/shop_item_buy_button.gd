extends Button

var already_pressed: bool = false

func _on_pressed() -> void:
	if PlayerResources.gold >= owner.item.item_price and !already_pressed:
		already_pressed = true
		
		PlayerResources.gold -= owner.item.item_price
		
		PlayerResources.player_items.append(owner.item)
		
		UI.currently_active_ui._set_resources()
		
		owner.queue_free()
