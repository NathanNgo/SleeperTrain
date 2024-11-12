extends Node2D

class_name GridRailwayVertex

# Array[Array[Vector2]]
@export var connections = []
@export var vertex_name: String
@export var available_characters: Array[PackedScene]

@onready var id := position

var characters: Array[Character] = []

const MAX_CHARACTERS := 10
const MIN_CHARACTERS := 1


func _ready() -> void:
	for count in range(randi_range(MIN_CHARACTERS, MAX_CHARACTERS)):
		var selected_character: Character = available_characters.pick_random().instantiate()
		add_child(selected_character)
		characters.append(selected_character)


func add_connection(connection: Array[Vector2]) -> void:
	connections.append(connection)


func remove_connection(connection: Array[Vector2]) -> void:
	var reverse_connection = [id[Globals.SECOND_VERTEX_ID_IN_EDGE_ID], id[Globals.FIRST_VERTEX_ID_IN_EDGE_ID]]

	if connection in connection:
		connections.erase(connection)
	elif reverse_connection in connections:
		connections.erase(reverse_connection)