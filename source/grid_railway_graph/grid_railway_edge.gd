class_name GridRailwayEdge extends Line2D

@export var edge_name: String
@export var weight := 1.0

var edge_points: Array[Vector2] = []

@onready var first_point := points[0] + position
@onready var last_point := points[-1] + position
@onready var id: Array[Vector2] = [first_point, last_point]


func _ready() -> void:
	for point in points:
		# TODO: use global_position instead of adding position to point co-ordinates.
		edge_points.append(point + position)
