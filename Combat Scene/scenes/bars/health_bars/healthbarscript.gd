extends Node

@export var health_label: Label3D
@export var health_sprite: Sprite3D

@export var max_health: float
@export var health: float

@export var current_health_ratio: float
@export var health_bar_sprite_max_length: float = 100
@export var current_health_bar_length: float = 100

@export var health_color: Color

func _change_health():
	health_label.text = "{current_health} / {max_health}".format({"current_health": clamp(snappedf(health, 0.1), 0, max_health), "max_health": clamp(snappedf(max_health, 0.1), 0, 9999)})
	
	current_health_ratio = health / max_health
	current_health_bar_length = health_bar_sprite_max_length * current_health_ratio
	health_sprite.scale.x = current_health_bar_length
	
	health_color = Color.GREEN.lerp(Color.RED, (1 - current_health_ratio))
	health_sprite.modulate = health_color

func globalInitHealth(_health: float, _max_health: float):
	max_health = _max_health
	health = _health
	_change_health()

func globalSetMaxHealth(value: float):
	max_health = value
	_change_health()

func globalSetHealth(value: float):
	health = value
	_change_health()
