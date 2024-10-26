extends Node


@export var _grid_railway_vertex_container: Node2D
@export var _grid_railway_edge_container: Node2D

@export var map: Node2D
@onready var grid_railway_vertexes: Array[Node] = _grid_railway_vertex_container.get_children()
@onready var grid_railway_edges: Array[Node] = _grid_railway_edge_container.get_children()