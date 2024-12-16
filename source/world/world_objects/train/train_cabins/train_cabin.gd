class_name TrainCabin extends Node2D

@export var _objects: Node2D
@export var _train_cabin_shape: CollisionShape2D

var cabin_id: int

@onready var length = _train_cabin_shape.shape.get_rect().size.x
@onready var height = _train_cabin_shape.shape.get_rect().size.y


func get_grid_positions():
	return BuildingGrid.get_grid_positions_for_shape(global_position, length, height)


func add_object_to_cabin(
	object: Node2D,
	grid_position: Vector2,
) -> void:
	for carriage_level in carriage_levels:
		if grid_position.y < carriage_level.grid_level_floor or grid_position.y > carriage_level.grid_level_ceiling:
			continue

		carriage_level.get_cabin(grid_position).add_object(object)


func remove_object_from_cabin(grid_position: Vector2) -> void:
	for carriage_level in carriage_levels:
		if grid_position.y < carriage_level.grid_level_floor or grid_position.y > carriage_level.grid_level_ceiling:
			continue

		carriage_level.get_cabin(grid_position).remove_object(grid_position)


func get_objects_from_cabin(grid_position: Vector2) -> Array[int]:
	for carriage_level in carriage_levels:
		if grid_position.y < carriage_level.grid_level_floor or grid_position.y > carriage_level.grid_level_ceiling:
			continue

		return carriage_level.get_cabin(grid_position).get_objects()
	return []



# class_name TrainCabin extends RefCounted
#
# var characters: Array[int] = []
# var objects: Array[Node] = []
#
# var grid_cabin_start: int
# var grid_cabin_end: int
# var level: int
#
#
# func _init(grid_cabin_start_init: int, grid_cabin_end_init: int, level_init: int) -> void:
# 	self.grid_cabin_start = grid_cabin_start_init
# 	self.grid_cabin_end = grid_cabin_end_init
# 	self.level = level_init
#
