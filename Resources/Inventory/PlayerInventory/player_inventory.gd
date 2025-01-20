extends CreatureInventory

class_name PlayerInventory

@export var player_items: Array[ItemResource]

@export_group("Materials")
@export var gold: int = 0
@export var claws: int = 0
@export var hoofs: int = 0
@export var scales: int = 0
@export var shards: int = 0
@export var essence: int = 0
@export var keys: int = 0

@export_group("Misc")
@export var fresh_player: bool = true
@export var pkey: float = 0
