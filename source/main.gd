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


func _on_town_selection_pressed(vertex_name: String) -> void:
	if _overworld_navigation_menu.overworld.train_moving:
		return


	var destination_vertex := _graph.get_vertex_by_name(vertex_name)
	var full_path = _graph.get_full_path(_current_vertex.id, destination_vertex.id)

	_overworld_navigation_menu.overworld.move_train(full_path, 5)
	_current_vertex = destination_vertex
	_overworld_navigation_menu.current_location_name = _current_vertex.vertex_name
