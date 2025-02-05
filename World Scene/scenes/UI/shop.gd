extends Control

@onready var shop_item_panel = preload("res://Shop/shop_item.tscn")
@onready var shop_mat_panel = preload("res://Shop/shop_material.tscn")

@onready var shop_item_sell_panel = preload("res://Shop/shop_item_sell.tscn")
@onready var shop_mat_sell_panel = preload("res://Shop/shop_material_sell.tscn")

@export var current_mode: String = "Buy"
@export var current_display: String = "items"

@export var display_vbox: VBoxContainer
@export var random_item_getter: Node

@export var possible_materials: Array[String] = [
	"claws",
	"hoofs",
	"scales",
	"shards",
	"essence",
	"keys"
]

@export var material_resource: MatResource

@export var shop_inventory: ShopInventory
@export var player_inventory: PlayerInventory

func _generate_random_items():
	for i in range(5):
		var item = random_item_getter._get_item_without_replacement()
		if item == null:
			return
		shop_inventory.items.append(item)

func _generate_random_materials():
	var randnum = randi_range(10, 20)
	for i in range(randnum):
		shop_inventory.materials[possible_materials.pick_random()] += 1

func _instantiate_items_in_display():
	for item in shop_inventory.items:
		var shop_item_panel_instance = shop_item_panel.instantiate()
		shop_item_panel_instance.item = item
		display_vbox.add_child(shop_item_panel_instance)

func _instantiate_materials_in_display():
	for mat in shop_inventory.materials.keys():
		var stock = shop_inventory.materials[mat]
		if stock > 0:
			var shop_mat_panel_instance = shop_mat_panel.instantiate()
			shop_mat_panel_instance.mat = mat
			shop_mat_panel_instance.stock = stock
			display_vbox.add_child(shop_mat_panel_instance)

func _instantiate_sell_items_in_display():
	for item in player_inventory.player_items:
		var shop_item_sell_panel_instance = shop_item_sell_panel.instantiate()
		shop_item_sell_panel_instance.item = item
		display_vbox.add_child(shop_item_sell_panel_instance)

func _instantiate_sell_materials_in_display():
	if player_inventory.claws > 0:
		var shop_mat_sell_panel_instance = shop_mat_sell_panel.instantiate()
		shop_mat_sell_panel_instance.mat = "claws"
		shop_mat_sell_panel_instance.stock = player_inventory.claws
		display_vbox.add_child(shop_mat_sell_panel_instance)
	if player_inventory.hoofs > 0:
		var shop_mat_sell_panel_instance = shop_mat_sell_panel.instantiate()
		shop_mat_sell_panel_instance.mat = "hoofs"
		shop_mat_sell_panel_instance.stock = player_inventory.hoofs
		display_vbox.add_child(shop_mat_sell_panel_instance)
	if player_inventory.scales > 0:
		var shop_mat_sell_panel_instance = shop_mat_sell_panel.instantiate()
		shop_mat_sell_panel_instance.mat = "scales"
		shop_mat_sell_panel_instance.stock = player_inventory.scales
		display_vbox.add_child(shop_mat_sell_panel_instance)
	if player_inventory.shards > 0:
		var shop_mat_sell_panel_instance = shop_mat_sell_panel.instantiate()
		shop_mat_sell_panel_instance.mat = "shards"
		shop_mat_sell_panel_instance.stock = player_inventory.shards
		display_vbox.add_child(shop_mat_sell_panel_instance)
	if player_inventory.essence > 0:
		var shop_mat_sell_panel_instance = shop_mat_sell_panel.instantiate()
		shop_mat_sell_panel_instance.mat = "essence"
		shop_mat_sell_panel_instance.stock = player_inventory.essence
		display_vbox.add_child(shop_mat_sell_panel_instance)
	if player_inventory.keys > 0:
		var shop_mat_sell_panel_instance = shop_mat_sell_panel.instantiate()
		shop_mat_sell_panel_instance.mat = "keys"
		shop_mat_sell_panel_instance.stock = player_inventory.keys
		display_vbox.add_child(shop_mat_sell_panel_instance)

func _clear_display():
	for thing in display_vbox.get_children():
		thing.queue_free()

func _randomize_mat_prices():
	var small_prices = [
		material_resource.claws_price,
		material_resource.hoofs_price,
		material_resource.scales_price,
	]
	for price in small_prices:
		var rand_price = randi_range(1,2)
		
	var med_prices = [
		material_resource.shards_price,
		material_resource.essence_price
	]
	
	for price in med_prices:
		var rand_price = randi_range(2,4)
		price = rand_price
	
	var rand_price = randi_range(3,6)
	material_resource.key_price = rand_price

func _randomize_item_prices():
	for item in shop_inventory.items:
		var rand_num = randi_range(-1,3)
		item.item_price += rand_num
		if item.item_price < 1:
			item.item_price = 1

func _randomize_shop():
	shop_inventory.items.clear()
	for value in shop_inventory.materials.values():
		value = 0
	_generate_random_items()
	_generate_random_materials()

func _switch_display():
	_clear_display()
	match current_mode:
		"Buy":
			match current_display:
				"mats":
					_instantiate_materials_in_display()
				"items":
					_instantiate_items_in_display()
		"Sell":
			match current_display:
				"mats":
					_instantiate_sell_materials_in_display()
				"items":
					_instantiate_sell_items_in_display()

func _ready():
	_randomize_shop()
	_randomize_mat_prices()
	_randomize_item_prices()
	_instantiate_items_in_display()
