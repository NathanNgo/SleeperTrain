extends Node2D

class_name GridRailwayVertex

# Array[Array[Vector2]]
@export var connections = []
@export var vertex_name: String
@export var available_character_ids: Array[int]
@export var vertex_type: Globals.VertexType

@onready var id := position


func add_connection(connection: Array[Vector2]) -> void:
	connections.append(connection)


func remove_connection(connection: Array[Vector2]) -> void:
	var reverse_connection = [id[Globals.SECOND_VERTEX_ID_IN_EDGE_ID], id[Globals.FIRST_VERTEX_ID_IN_EDGE_ID]]

	if connection in connection:
		connections.erase(connection)
	elif reverse_connection in connections:
		connections.erase(reverse_connection)