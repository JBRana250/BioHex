extends TextureButton

@export var creature_part_button: bool

@export var evo_ui_mouse_filter_change: EventWithParam

func _on_pressed():
	if creature_part_button:
		evo_ui_mouse_filter_change.event_triggered.emit("pass")
	get_tree().current_scene.display_manager.globalDisplayCreatureData()
	
	Globals.active_cell_blueprint.get_node("Components").get_node("MouseInputComponent").globalDeselectBlueprint()
	Globals.active_cell_blueprint = null
