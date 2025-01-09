extends Control

@onready var shop_item_panel = preload("res://Shop/shop_item.tscn")

@export var display_vbox: VBoxContainer
@export var random_item_getter: Node

@export var items: Array[ItemResource]

func _ready():
	for i in range(5):
		var item = random_item_getter._get_item_without_replacement()
		if item == null:
			return
		items.append(item)
	
	for item in items:
		var shop_item_panel_instance = shop_item_panel.instantiate()
		shop_item_panel_instance.item_sprite = item.item_sprite
		shop_item_panel_instance.item_name = item.item_name
		shop_item_panel_instance.item_description = item.item_description
		shop_item_panel_instance.item_price = item.item_price
		display_vbox.add_child(shop_item_panel_instance)
