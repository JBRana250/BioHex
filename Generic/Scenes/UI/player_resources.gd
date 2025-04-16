extends PanelContainer

@export var player_inventory: PlayerInventory

@export var player_resources_changed: Event

@export var gold_label: Label
@export var claws_label: Label
@export var hoofs_label: Label
@export var scales_label: Label
@export var shards_label: Label
@export var essence_label: Label
@export var keys_label: Label

func _ready():
	player_resources_changed.connect("event_triggered", set_resources)
	set_resources()

func set_resources():
	gold_label.text = str(player_inventory.gold)
	claws_label.text = str(player_inventory.claws)
	hoofs_label.text = str(player_inventory.hoofs)
	scales_label.text = str(player_inventory.scales)
	shards_label.text = str(player_inventory.shards)
	essence_label.text = str(player_inventory.essence)
	keys_label.text = str(player_inventory.keys)
