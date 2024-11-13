extends Node


var registry = {}
static var total_characters = 0


func register(character: Variant) -> int:
	total_characters += 1
	registry[total_characters] = character
	return total_characters