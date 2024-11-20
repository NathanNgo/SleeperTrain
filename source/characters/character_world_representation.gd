extends Node2D

class_name CharacterWorldRepresentation

var character_data: CharacterData
var world_position: Vector2:
	set(value):
		character_data.world_position = value
		position = value
	get:
		return character_data.world_position



func _ready() -> void:
	assert(character_data != null, "character_data has not been configured")