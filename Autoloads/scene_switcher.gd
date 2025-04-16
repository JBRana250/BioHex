extends Node

@export var leaving_scene: Event

var current_scene = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)

func _deferred_switch_scene(res_path):
	leaving_scene.emit_signal("event_triggered")
	current_scene.queue_free()
	var scene = load(res_path)
	current_scene = scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
