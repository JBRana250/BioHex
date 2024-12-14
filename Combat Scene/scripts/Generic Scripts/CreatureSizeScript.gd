extends Node

var creature

@export var size: float = 0.75

func _ready():
	creature.scale = Vector3(size,size,size)

func globalChangeCreatureSize(newSize):
	creature.scale = Vector3(newSize, newSize, newSize)
