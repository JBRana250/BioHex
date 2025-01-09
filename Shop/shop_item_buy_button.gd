extends Button

func _on_pressed() -> void:
	if PlayerResources.gold >= owner.item_price:
		PlayerResources.gold -= owner.item_price
		UI.currently_active_ui._set_resources()
