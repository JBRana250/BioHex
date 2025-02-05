extends Node

@export var creature_part_ui_database: CreaturePartUIDatabase

func _on_pressed() -> void:
	owner.display_parts(creature_part_ui_database)
