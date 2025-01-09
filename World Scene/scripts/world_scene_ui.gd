extends Control

@export var gold_label: Label
@export var claws_label: Label
@export var hoofs_label: Label
@export var scales_label: Label
@export var shards_label: Label
@export var essence_label: Label
@export var keys_label: Label

func _ready():
	_set_resources()

func _set_resources():
	gold_label.text = str(PlayerResources.gold)
	claws_label.text = str(PlayerResources.claws)
	hoofs_label.text = str(PlayerResources.hoofs)
	scales_label.text = str(PlayerResources.scales)
	shards_label.text = str(PlayerResources.shards)
	essence_label.text = str(PlayerResources.essence)
	keys_label.text = str(PlayerResources.keys)
