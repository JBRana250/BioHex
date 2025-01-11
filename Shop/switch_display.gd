extends Button

@export var display_type: String

func _on_pressed() -> void:
	if owner.current_display == display_type:
		return
	
	owner.current_display = display_type
	owner._clear_display()
	
	match display_type:
		"mats":
			owner._instantiate_materials_in_display()
		"items":
			owner._instantiate_items_in_display()
