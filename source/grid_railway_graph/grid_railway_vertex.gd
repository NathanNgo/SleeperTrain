class_name GridRailwayVertex extends Node2D

# Array[Array[Vector2]]
@export var connections = []
@export var vertex_name: String
@export var available_character_ids: Array[int]
# Dict[Globals.ResourceType, int]
@export var available_resources = {}
@export var vertex_type: Globals.VertexType

@onready var id := position


func add_connection(connection: Array[Vector2]) -> void:
	connections.append(connection)


func remove_connection(connection: Array[Vector2]) -> void:
	var reverse_connection = [
		id[Globals.SECOND_VERTEX_ID_IN_EDGE_ID], id[Globals.FIRST_VERTEX_ID_IN_EDGE_ID]
	]

	if connection in connection:
		connections.erase(connection)
	elif reverse_connection in connections:
		connections.erase(reverse_connection)
