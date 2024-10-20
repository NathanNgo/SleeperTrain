extends Node2D


func _ready() -> void:
	var station_graph = AStar2D.new()
	var town_counter = 0

	for town_vertex in get_tree().get_nodes_in_group("town_vertex"):
		station_graph.add_point(town_counter, town_vertex.position)
		town_counter += 1