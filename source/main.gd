extends Node


@export var _menu_manager: CanvasLayer
var _graph: GridRailwayGraph


func _ready() -> void:
	_setup_graph()


func _setup_graph() -> void:
	var overworld_navigation_menu = _menu_manager.get_menu(Globals.Menus.OVERWORLD_NAVIGATION_MENU)
	var edges = overworld_navigation_menu.overworld.level.grid_railway_edges
	var vertexes = overworld_navigation_menu.overworld.level.grid_railway_vertexes

	_graph = GridRailwayGraph.new()

	for vertex in vertexes:
		_graph.add_vertex(vertex)

	for edge in edges:
		_graph.add_edge(edge)