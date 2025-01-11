extends PanelContainer

@export var texture_rect: TextureRect
@export var item_name_label: Label
@export var item_description_label: Label
@export var item_price_label: Label

@export var item: ItemResource

func _ready():
	texture_rect.texture = item.item_sprite
	item_name_label.text = item.item_name
	item_description_label.text = item.item_description
	item_price_label.text = str(item.item_price)
