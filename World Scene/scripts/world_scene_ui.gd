extends Control

@export var player_inventory: PlayerInventory

@onready var item_panel_container = preload("res://World Scene/scenes/UI/item_panel_container.tscn")

@export var player_items_vflow: VFlowContainer

@export var player_items_changed: Event

func _ready():
	player_items_changed.connect("event_triggered", set_items)
	set_items()

func set_items():
	for item in player_items_vflow.get_children():
		item.queue_free()
	
	for item in player_inventory.player_items:
		var item_panel_container_instance = item_panel_container.instantiate()
		item_panel_container_instance.item_texture.texture = item.item_sprite
		player_items_vflow.add_child(item_panel_container_instance)
