extends Node

@export var player_inventory: PlayerInventory

@export var item_pool: ItemDatabase
@export var item_database: ItemDatabase

func _ready():
	
	_refresh_item_pool()
	
	if Globals.rooms_cleared == 0:
		_start_world()
	else:
		player_inventory.fresh_player = false
	

func _refresh_item_pool():
	item_pool.rarity_one_items = item_database.rarity_one_items
	item_pool.rarity_two_items = item_database.rarity_two_items
	item_pool.rarity_three_items = item_database.rarity_three_items
	item_pool.rarity_four_items = item_database.rarity_four_items
	item_pool.rarity_five_items = item_database.rarity_five_items

func _start_world():
	player_inventory.fresh_player = true
