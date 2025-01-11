extends Control

@onready var shop_item_panel = preload("res://Shop/shop_item.tscn")
@onready var shop_mat_panel = preload("res://Shop/shop_material.tscn")

@export var current_mode: String = "buy"
@export var current_display: String = "items"

@export var display_vbox: VBoxContainer
@export var random_item_getter: Node

@export var items: Array[ItemResource]

@export var possible_materials: Array[String] = [
	"claws",
	"hoofs",
	"scales",
	"shards",
	"essence",
	"keys"
]

@export var materials = {
	"claws": 0,
	"hoofs": 0,
	"scales": 0,
	"shards": 0,
	"essence": 0,
	"keys": 0
}

func _generate_random_items():
	for i in range(5):
		var item = random_item_getter._get_item_without_replacement()
		if item == null:
			return
		items.append(item)

func _generate_random_materials():
	var randnum = randi_range(10, 20)
	for i in range(randnum):
		materials[possible_materials.pick_random()] += 1

func _instantiate_items_in_display():
	for item in items:
		var shop_item_panel_instance = shop_item_panel.instantiate()
		shop_item_panel_instance.item = item
		display_vbox.add_child(shop_item_panel_instance)

func _instantiate_materials_in_display():
	for mat in materials.keys():
		var stock = materials[mat]
		if stock > 0:
			var shop_mat_panel_instance = shop_mat_panel.instantiate()
			shop_mat_panel_instance.mat = mat
			shop_mat_panel_instance.stock = stock
			display_vbox.add_child(shop_mat_panel_instance)

func _clear_display():
	for thing in display_vbox.get_children():
		thing.queue_free()

func _refresh_shop():
	items.clear()
	for value in materials.values():
		value = 0
	_generate_random_items()
	_generate_random_materials()

func _ready():
	_generate_random_items()
	_generate_random_materials()
	_instantiate_items_in_display()
