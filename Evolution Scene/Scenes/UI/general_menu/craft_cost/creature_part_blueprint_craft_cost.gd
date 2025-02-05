extends Node

const claw_sprite = preload("res://In-Game Resource Sprite/Biohex Claw Sprite.png")
const hoof_sprite = preload("res://In-Game Resource Sprite/Biohex Hoof Sprite.png")
const scale_sprite = preload("res://In-Game Resource Sprite/Biohex Scale Sprite.png")
const shard_sprite = preload("res://In-Game Resource Sprite/Biohex Shard Sprite.png")
const essence_sprite = preload("res://In-Game Resource Sprite/Biohex Essence Sprite.png")

@export var label: Label
@export var texture_rect: TextureRect

var mat_amount: int
var material_type: String

func display_craft_cost():
	label.text = str(mat_amount)
	
	match material_type:
		"Claws":
			texture_rect.texture = claw_sprite
		"Hoofs":
			texture_rect.texture = hoof_sprite
		"Scales":
			texture_rect.texture = scale_sprite
		"Shards":
			texture_rect.texture = shard_sprite
		"Essence":
			texture_rect.texture = essence_sprite
		_:
			print_debug("invalid resource specified")
