extends Node

@export var gold: int
@export var claws: int
@export var hoofs: int
@export var scales: int
@export var shards: int
@export var essence: int

@export var keys: int
@export var pkey: int

@export var health: int
@export var mana: int

@export var fresh_player: bool = true

func globalIncreaseGold(value: int):
	gold += value

func globalDecreaseGold(value: int):
	gold -= value
	if gold < 0:
		gold = 0

func globalIncreaseClaws(value: int):
	claws += value

func globalDecreaseClaws(value: int):
	claws -= value 
	if claws < 0:
		claws = 0

func globalIncreaseHoofs(value: int):
	hoofs += value

func globalDecreaseHoofs(value: int):
	hoofs -= value
	if hoofs < 0:
		hoofs = 0

func globalIncreaseScales(value: int):
	scales += value

func globalDecreaseScales(value: int):
	scales -= value 
	if scales < 0:
		scales = 0

func globalIncreaseShards(value: int):
	shards += value

func globalDecreaseShards(value: int):
	shards -= value
	if shards < 0:
		shards = 0

func globalIncreaseEssence(value: int):
	essence += value

func globalDecreaseEssence(value: int):
	essence -= value 
	if essence < 0:
		essence = 0

func globalIncreaseKeys(value: int):
	keys += value

func globalDecreaseKeys(value: int):
	keys -= value
	if keys < 0:
		keys = 0
