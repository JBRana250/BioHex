extends Node

@export var size: float = 0.75

func _ready():
	owner.scale = Vector3(size,size,size)

func globalChangeCreatureSize(newSize):
	owner.scale = Vector3(newSize, newSize, newSize)
