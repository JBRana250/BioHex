extends Button

@export var display_type: String

func _on_pressed() -> void:
	if owner.current_display == display_type:
		return
	
	owner.current_display = display_type
	owner._switch_display()
