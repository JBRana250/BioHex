extends Button

class_name ButtonNavToSceneScript

@export var scene_path: String

func _on_pressed():
	SceneSwitcher.switch_scene(scene_path)
