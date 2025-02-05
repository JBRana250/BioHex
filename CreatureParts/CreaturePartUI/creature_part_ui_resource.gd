extends Resource

class_name CreaturePartUIResource

@export var creature_part_name: String
@export var creature_part_description: String

@export var creature_part_resource: Creature_Part_Resource

@export var creature_part_craft_cost: Dictionary = {
	"Claws": 0,
	"Hoofs": 0,
	"Scales": 0,
	"Shards": 0,
	"Essence": 0
}
