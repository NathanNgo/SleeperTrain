extends Node


var registry = {}
static var total_characters = 0


func register(character_data: CharacterData) -> int:
	total_characters += 1
	registry[total_characters] = character_data
	return total_characters


func get_character_data(id: int) -> CharacterData:
	return registry[id]


func get_world_representation(id: int) -> CharacterBody2D:
	var character_data: CharacterData = registry[id]
	var character_world_representation: CharacterBody2D = character_data.world_representation.instantiate()
	character_world_representation.character_data = character_data
	return character_world_representation