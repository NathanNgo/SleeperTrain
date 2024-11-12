extends Node


var registry = {}
static var total_characters = 0


func register(character: Variant) -> void:
	character.id = total_characters
	total_characters += 1
	registry[character.id] = character