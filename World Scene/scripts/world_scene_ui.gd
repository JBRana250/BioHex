extends Control

@export var player_inventory: PlayerInventory

@onready var item_panel_container = preload("res://World Scene/scenes/UI/item_panel_container.tscn")

@export var gold_label: Label
@export var claws_label: Label
@export var hoofs_label: Label
@export var scales_label: Label
@export var shards_label: Label
@export var essence_label: Label
@export var keys_label: Label

@export var player_items_vflow: VFlowContainer

func _ready():
	_set_resources()

func _set_resources():
	gold_label.text = str(player_inventory.gold)
	claws_label.text = str(player_inventory.claws)
	hoofs_label.text = str(player_inventory.hoofs)
	scales_label.text = str(player_inventory.scales)
	shards_label.text = str(player_inventory.shards)
	essence_label.text = str(player_inventory.essence)
	keys_label.text = str(player_inventory.keys)
	
	for item in player_items_vflow.get_children():
		item.queue_free()
	
	for item in player_inventory.player_items:
		var item_panel_container_instance = item_panel_container.instantiate()
		item_panel_container_instance.item_texture.texture = item.item_sprite
		player_items_vflow.add_child(item_panel_container_instance)
