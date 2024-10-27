extends Node


@export var _menu_manager: CanvasLayer

var _graph: GridRailwayGraph
var _current_vertex: GridRailwayVertex

@onready var _overworld_navigation_menu: ManagedMenu = _menu_manager.get_menu(Globals.Menus.OVERWORLD_NAVIGATION_MENU) 


func _ready() -> void:
	_setup_graph()
	_overworld_navigation_menu.current_location_name = _current_vertex.vertex_name
	
	for town_selection in _overworld_navigation_menu.overworld.level.town_selections:
		town_selection.pressed.connect(_on_town_selection_pressed.bind(town_selection.vertex_name))


func _setup_graph() -> void:
	var edges = _overworld_navigation_menu.overworld.level.grid_railway_edges
	var vertexes = _overworld_navigation_menu.overworld.level.grid_railway_vertexes

	_graph = GridRailwayGraph.new()

	for vertex in vertexes:
		_graph.add_vertex(vertex)

	for edge in edges:
		_graph.add_edge(edge)

	_current_vertex = _graph.get_vertex_by_name("First Town")


func _on_town_selection_pressed(vertex_name: String):
	var destination_vertex := _graph.get_vertex_by_name(vertex_name)
	var path := _graph.get_path(_current_vertex.id, destination_vertex.id)

	var train_path = _overworld_navigation_menu.overworld.train_path
	train_path.curve.clear_points()

	var full_path = _generate_full_path(path)
	
	for point in full_path:
		train_path.curve.add_point(point)

	_current_vertex = destination_vertex
	_overworld_navigation_menu.current_location_name = _current_vertex.vertex_name


func _generate_full_path(path: Array[Vector2]) -> Array[Vector2]:
	var full_path: Array[Vector2] = []

	for index in range(len(path)):
		if index == len(path) - 1:
			return full_path

		var point := path[index]
		var next_point := path[index + 1]
		var edge_id: Array[Vector2] = [point, next_point]

		var edge = _graph.get_edge(edge_id)
		var edge_points = edge.edge_points
		var reverse_edge_points = edge.edge_points.duplicate()
		reverse_edge_points.reverse()

		if edge.first_point != point:
			edge_points = reverse_edge_points

		for edge_point in edge_points:
			full_path.append(edge_point)

	return full_path