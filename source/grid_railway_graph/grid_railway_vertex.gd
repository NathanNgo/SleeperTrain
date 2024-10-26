extends Node2D

class_name GridRailwayVertex

# Array[Array[Vector2]]
@export var connections = []
@export var vertex_name: String

@onready var id := position

# TODO: get_connections, add_connection, remove_connection

func add_connection(connection: Array[Vector2]) -> void:
	connections.append(connection)


func remove_connection(connection: Array[Vector2]) -> void:
	var reverse_connection = [id[Globals.SECOND_VERTEX_ID_IN_EDGE_ID], id[Globals.FIRST_VERTEX_ID_IN_EDGE_ID]]

	if connection in connection:
		connections.erase(connection)
	elif reverse_connection in connections:
		connections.erase(reverse_connection)