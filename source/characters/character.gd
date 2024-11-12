extends Node2D

class_name Character

var id: int

func _ready() -> void:
	CharactersRegistry.register(self)