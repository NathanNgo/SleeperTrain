extends CharacterBody2D

class_name CharacterWorldRepresentation

var character_data: CharacterData


func _ready() -> void:
	assert(character_data != null, "character_data has not been configured")