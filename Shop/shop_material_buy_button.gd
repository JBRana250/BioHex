extends Button

func _on_pressed() -> void:
	if PlayerResources.gold >= owner.material_price:
			PlayerResources.gold -= owner.material_price
			match owner.mat:
				"claws":
					PlayerResources.claws += 1
				"hoofs":
					PlayerResources.hoofs += 1
				"scales":
					PlayerResources.scales += 1
				"shards":
					PlayerResources.shards += 1
				"essence":
					PlayerResources.essence += 1
				"keys":
					PlayerResources.keys += 1
					
			owner.stock -= 1
			UI.currently_active_ui._set_resources()
			
			if owner.stock <= 0:
				owner.queue_free()
			else:
				owner._set_stock()
