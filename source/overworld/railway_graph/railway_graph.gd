extends Node2D


# Dict[str, int]
var vertex_name_to_id_mapping = {}
var vertex_id_to_name_mapping = {}

@onready var railway_graph = AStar2DWithEdges.new()


func _ready() -> void:
	_add_vertexes(get_tree().get_nodes_in_group("station_vertexes"))
	_add_vertexes(get_tree().get_nodes_in_group("junction_vertexes"))

	for railway_edge in get_tree().get_nodes_in_group("railway_edges"):
		var first_vertex_id = vertex_name_to_id_mapping[railway_edge.first_vertex.name]
		var second_vertex_id = vertex_name_to_id_mapping[railway_edge.second_vertex.name]
		railway_graph.connect_points_with_edge(first_vertex_id, second_vertex_id, railway_edge)


func _add_vertexes(vertexes: Array[Node]):
	for vertex in vertexes:
		var vertex_id = railway_graph.get_available_point_id()
		vertex_name_to_id_mapping[vertex.name] = vertex_id
		vertex_id_to_name_mapping[vertex_id] = str(vertex.name)
		railway_graph.add_point(vertex_id, vertex.position)