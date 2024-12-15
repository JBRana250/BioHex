extends Node

@export var mana_label: Label3D
@export var mana_sprite: Sprite3D

@export var max_mana: float
@export var mana: float

@export var current_mana_ratio: float
@export var mana_bar_sprite_max_length: float = 100
@export var current_mana_bar_length: float = 100

@export var mana_color: Color

func _change_mana():
	mana_label.text = "{current_mana} / {max_mana}".format({"current_mana": clamp(snappedf(mana, 0.1), 0, max_mana), "max_mana": clamp(snappedf(max_mana, 0.1), 0, 9999)})
	
	current_mana_ratio = mana / max_mana
	current_mana_bar_length = mana_bar_sprite_max_length * current_mana_ratio
	mana_sprite.scale.x = current_mana_bar_length
	
	mana_color = Color.BLUE.lerp(Color.BLACK, (1 - current_mana_ratio))
	mana_sprite.modulate = mana_color

func globalInitMana(_mana: float, _max_mana: float):
	max_mana = _max_mana
	mana = _mana
	_change_mana()

func globalSetMaxMana(value: float):
	max_mana = value
	_change_mana()

func globalSetMana(value: float):
	mana = value
	_change_mana()
