extends PanelContainer

@export var texture_rect: TextureRect
@export var item_name_label: Label
@export var item_description_label: Label
@export var item_price_label: Label

@export var item_sprite: AtlasTexture
@export var item_name: String
@export var item_description: String
@export var item_price: int

func _ready():
	texture_rect.texture = item_sprite
	item_name_label.text = item_name
	item_description_label.text = item_description
	item_price_label.text = str(item_price)
