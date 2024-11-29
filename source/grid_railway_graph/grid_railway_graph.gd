class_name GridRailwayGraph extends RefCounted

var astar := AStar2DWithEdgeWeights.new()

# Dict[Vector2, int]
var vertex_id_to_astar_id_mapping = {}
# Dict[String, int]
var vertex_name_to_vertex_id_mapping = {}
# Dict[Vector2, GridRailwayVertex]
var vertexes = {}
# Dict[Vector2, GridRailwayEdge]
var edges = {}

# 
func _init(vertexes_init: Array[Node], edges_init: Array[Node]) -> void:
	for vertex in vertexes_init:
		add_vertex(vertex)

		if vertex.vertex_type == Globals.VertexType.TOWN:
			vertex.available_character_ids = Generation._generate_characters()
			vertex.available_resources = Generation._generate_resources()

	for edge in edges_init:
		add_edge(edge)


func add_vertex(vertex: GridRailwayVertex) -> void:
	var astar_id := astar.get_available_point_id()

	vertexes[vertex.id] = vertex
	vertex_id_to_astar_id_mapping[vertex.id] = astar_id
	vertex_name_to_vertex_id_mapping[vertex.vertex_name] = vertex.id
	astar.add_point(astar_id, vertex.id)


func add_edge(edge: GridRailwayEdge) -> void:
	var astar_from_id: int = vertex_id_to_astar_id_mapping[edge.first_point]
	var astar_to_id: int = vertex_id_to_astar_id_mapping[edge.last_point]

	edges[edge.id] = edge
	astar.connect_points_with_edge_weight(astar_from_id, astar_to_id, edge.weight)


func remove_vertex(id: Vector2) -> void:
	if id not in vertexes:
		return

	var vertex: GridRailwayVertex = vertexes[id]
	# Array[Array[Vector2]]
	var vertex_connections = vertex.get_connections()

	for vertex_connection in vertex_connections:
		var first_vertex_id: Vector2 = vertex_connection[
			Globals.FIRST_VERTEX_ID_IN_EDGE_ID
		]
		var second_vertex_id: Vector2 = vertex_connection[
			Globals.SECOND_VERTEX_ID_IN_EDGE_ID
		]
		var vertex_neighbour: GridRailwayVertex

		if first_vertex_id != id:
			vertex_neighbour = vertexes[first_vertex_id]
		else:
			vertex_neighbour = vertexes[second_vertex_id]

		vertex_neighbour.remove_connection(vertex_connection)
		edges.erase(vertex_connection)

	vertexes.erase(id)
	vertex_name_to_vertex_id_mapping.erase(vertex.vertex_name)


func remove_edge(id: Array[Vector2]) -> void:
	var first_vertex_id := id[Globals.FIRST_VERTEX_ID_IN_EDGE_ID]
	var second_vertex_id := id[Globals.SECOND_VERTEX_ID_IN_EDGE_ID]
	var edge := get_edge(id)

	if not edge:
		return

	var astar_from_id: int = vertex_id_to_astar_id_mapping[first_vertex_id]
	var astar_to_id: int = vertex_id_to_astar_id_mapping[second_vertex_id]

	edges.erase(id)
	vertexes[first_vertex_id].remove_connection(id)
	vertexes[second_vertex_id].remove_connection(id)
	astar.disconnect_points_with_edge_weight(astar_from_id, astar_to_id)


func get_vertex(id: Vector2) -> GridRailwayVertex:
	if id in vertexes:
		return vertexes[id]

	return null


func get_vertex_by_name(vertex_name: String) -> GridRailwayVertex:
	if vertex_name in vertex_name_to_vertex_id_mapping:
		var id: Vector2 = vertex_name_to_vertex_id_mapping[vertex_name]
		return vertexes[id]

	return null


func get_edge(id: Array[Vector2]) -> GridRailwayEdge:
	var reverse_id := [
		id[Globals.SECOND_VERTEX_ID_IN_EDGE_ID], id[Globals.FIRST_VERTEX_ID_IN_EDGE_ID]
	]

	if id in edges:
		return edges[id]

	if reverse_id in edges:
		return edges[reverse_id]

	return null


func get_vertex_id_path(from_id: Vector2, to_id: Vector2) -> PackedVector2Array:
	var astar_from_id: int = vertex_id_to_astar_id_mapping[from_id]
	var astar_to_id: int = vertex_id_to_astar_id_mapping[to_id]
	var path_ids := astar.get_point_path(astar_from_id, astar_to_id)

	# We use the position of the vertex as its ID, therefore we can just treat the position vectors
	# returned by AStar as a collection of vertex ID's.
	return path_ids


func get_vertex_path(from_id: Vector2, to_id: Vector2) -> Array[GridRailwayVertex]:
	var path_ids := get_vertex_id_path(from_id, to_id)
	var vertex_path: Array[GridRailwayVertex] = []

	for id in path_ids:
		vertex_path.append(vertexes[id])

	return vertex_path


func get_edge_path(from_id: Vector2, to_id: Vector2) -> Array[GridRailwayEdge]:
	# Edge directions may not be consistent! Use normalize_edge_direction.

	var path_ids := get_vertex_id_path(from_id, to_id)
	var edge_path: Array[GridRailwayEdge] = []
	var path_length := len(path_ids)

	for index in range(path_length):
		if index >= path_length - 1:
			return edge_path

		var current_point := path_ids[index]
		var next_point := path_ids[index + 1]

		var edge := get_edge([current_point, next_point])
		edge_path.append(edge)

	return edge_path


func normalize_edge_direction(edge_first_point: Vector2, edge_points: Array[Vector2]):
	if edge_first_point == edge_points[0]:
		return edge_points

	var copy_edge_points = edge_points.duplicate()
	copy_edge_points.reverse()

	return copy_edge_points


# Returns Array[Array[Vector2]]
func get_chunked_full_path_from_edge_path(
	starting_point: Vector2, edge_path: Array[GridRailwayEdge]
) -> Variant:
	var previous_edge_last_point := starting_point
	var chunked_full_path: Variant = []

	if not edge_path:
		return chunked_full_path

	for edge in edge_path:
		var chunked_path: Array[Vector2] = []
		var edge_points = normalize_edge_direction(
			previous_edge_last_point, edge.edge_points
		)
		previous_edge_last_point = edge_points[-1]

		for edge_point in edge_points:
			chunked_path.append(edge_point)

		chunked_full_path.append(chunked_path)

	return chunked_full_path


func get_full_path(from_id: Vector2, to_id: Vector2) -> Array[Vector2]:
	var starting_point := from_id
	var edge_path := get_edge_path(from_id, to_id)
	var full_path: Array[Vector2] = []

	if not edge_path:
		return full_path

	var previous_edge_last_point := starting_point

	for edge in edge_path:
		var edge_points = normalize_edge_direction(
			previous_edge_last_point, edge.edge_points
		)
		previous_edge_last_point = edge_points[-1]

		for edge_point in edge_points:
			full_path.append(edge_point)

	return full_path
