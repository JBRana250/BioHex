extends MarginContainer

@export var amount_gained: int
@export var resource_gained: String
@export var label: Label
@export var texture_rect: TextureRect

const gold_sprite = preload("res://In-Game Resource Sprite/Biohex Gold Sprite.png")
const claw_sprite = preload("res://In-Game Resource Sprite/Biohex Claw Sprite.png")
const hoof_sprite = preload("res://In-Game Resource Sprite/Biohex Hoof Sprite.png")
const scale_sprite = preload("res://In-Game Resource Sprite/Biohex Scale Sprite.png")
const shard_sprite = preload("res://In-Game Resource Sprite/Biohex Shard Sprite.png")
const essence_sprite = preload("res://In-Game Resource Sprite/Biohex Essence Sprite.png")

func globalShowResourcesGained():
	label.text = "+{amount}".format({"amount": amount_gained})
	
	match resource_gained:
		"Gold":
			texture_rect.texture = gold_sprite
		"Claw":
			texture_rect.texture = claw_sprite
		"Hoof":
			texture_rect.texture = hoof_sprite
		"Scale":
			texture_rect.texture = scale_sprite
		"Shard":
			texture_rect.texture = shard_sprite
		"Essence":
			texture_rect.texture = essence_sprite
		_:
			print_debug("invalid resource specified")
