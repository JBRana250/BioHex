extends PanelContainer

@export var texture_rect: TextureRect
@export var material_name_label: Label
@export var material_stock_label: Label
@export var material_price_label: Label

@export var mat: String
@export var stock: int

var material_price: int

@export var materials_resource: MatResource

func _set_claws_material():
	texture_rect.texture = materials_resource.claws_sprite
	material_name_label.text = "Claws"
	material_stock_label.text = "Stock: " + str(stock)
	material_price = materials_resource.claws_price
	material_price_label.text = str(material_price)
	
	
func _set_hoofs_material():
	texture_rect.texture = materials_resource.hoofs_sprite
	material_name_label.text = "Hoofs"
	material_stock_label.text = "Stock: " + str(stock)
	material_price = materials_resource.hoofs_price
	material_price_label.text = str(material_price)

func _set_scales_material():
	texture_rect.texture = materials_resource.scales_sprite
	material_name_label.text = "Scales"
	material_stock_label.text = "Stock: " + str(stock)
	material_price = materials_resource.scales_price
	material_price_label.text = str(material_price)
	
func _set_shards_material():
	texture_rect.texture = materials_resource.shards_sprite
	material_name_label.text = "Shards"
	material_stock_label.text = "Stock: " + str(stock)
	material_price = materials_resource.shards_price
	material_price_label.text = str(material_price)

func _set_essence_material():
	texture_rect.texture = materials_resource.essence_sprite
	material_name_label.text = "Essence"
	material_stock_label.text = "Stock: " + str(stock)
	material_price = materials_resource.essence_price
	material_price_label.text = str(material_price)

func _set_keys_material():
	texture_rect.texture = materials_resource.key_sprite
	material_name_label.text = "Keys"
	material_stock_label.text = "Stock: " + str(stock)
	material_price = materials_resource.key_price
	material_price_label.text = str(material_price)

func _set_stock():
	material_stock_label.text = "Stock: " + str(stock)

func _ready():
	match mat:
		"claws":
			_set_claws_material()
		"hoofs":
			_set_hoofs_material()
		"scales":
			_set_scales_material()
		"shards":
			_set_shards_material()
		"essence":
			_set_essence_material()
		"keys":
			_set_keys_material()
	
