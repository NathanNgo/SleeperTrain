class_name TrainCarriage extends Node2D

@export var _carriage_levels_container: Node2D

var carriage_id: int
var max_train_carriage_length := 0.0

enum TrainCarriageType { BASIC, SHORT }


func _ready() -> void:
	for carriage_level in _carriage_levels_container.get_children():
		if carriage_level.length > max_train_carriage_length:
			max_train_carriage_length = carriage_level.length


func get_carriage_level_by_position(grid_position: Vector2) -> TrainCarriageLevel:
	for carriage_level in _carriage_levels_container.get_children():
		var carriage_level_grid_positions = carriage_level.get_grid_positions()
		if (
			(
				grid_position.y
				< carriage_level_grid_positions[BuildingGrid.GridPositionType.BOTTOM]
			)
			or (
				grid_position.y
				> carriage_level_grid_positions[BuildingGrid.GridPositionType.TOP]
			)
		):
			continue

		return carriage_level
	return null


func get_carriage_level(level: int) -> TrainCarriageLevel:
	return _carriage_levels_container.get_children().pop_at(level)



# const MIN_CABIN_SIZE = 2
#
# @export var train_carriage_shapes: Array[CollisionShape2D]
#
# var carriage_id: int
# var carriage_cabins: Array[TrainCabin] = []
# # Array[Dict[str, int]]
# var grid_carriage_bounds_by_level: Array[Dictionary]
# var max_train_carriage_length := 0.0
#
# @onready var max_carriage_levels: int = train_carriage_shapes.size()
#
#
# func _ready() -> void:
# 	for train_carriage_shape in train_carriage_shapes:
# 		var train_carriage_length = train_carriage_shape.shape.get_rect().size.x
# 		if train_carriage_length > max_train_carriage_length:
# 			max_train_carriage_length = train_carriage_length
#
#
# func add_cabin(start: int, end: int, level: int) -> void:
# 	if grid_carriage_bounds_by_level.size() != max_carriage_levels:
# 		print("Carriage has not been initialized with building grid")
# 		return
#
# 	if level >= max_carriage_levels:
# 		# TODO: Error out or show to player.
# 		print("Level does not exist on carriage")
# 		return
#
# 	var carriage_bounds = grid_carriage_bounds_by_level[level]
#
# 	if start < carriage_bounds.start or end > carriage_bounds.end:
# 		# TODO: Error out or show to player.
# 		print("Cabin is out of bounds")
# 		return
#
# 	if abs(start - end) < MIN_CABIN_SIZE:
# 		# TODO: Error out or show to player.
# 		print("Cabin is too small")
# 		return
#
# 	for cabin in carriage_cabins:
# 		if start < cabin.cabin_end or end > cabin.cabin_start:
# 			# TODO: Error out or show to player.
# 			print("Cabin overlaps with an existing cabin")
# 			return
#
# 	var cabin = TrainCabin.new(start, end, level)
# 	carriage_cabins.append(cabin)
#
#
# func remove_cabin(removal_position: int, level: int) -> void:
# 	if level >= max_carriage_levels:
# 		# TODO: Error out or show to player.
# 		print("Level does not exist on carriage")
# 		return
#
# 	for cabin in carriage_cabins:
# 		if removal_position > cabin.cabin_start and removal_position < cabin.cabin_end:
# 			cabin.queue_free()
#
#
# func add_level(start: int, end: int, level: int) -> void:
# 	# level > size, discontinuous array.
# 	# level == size, creating a new item in the array by appending onto the end.
# 	# level < size, accessing existing item.
#
# 	if level > max_carriage_levels:
# 		# TODO: Error out or show to player.
# 		print("Cannot create discontinuous level")
# 		return
#
# 	grid_carriage_bounds_by_level.append({start: start, end: end})
#
#
# func remove_level(level: int) -> void:
# 	if level >= max_carriage_levels:
# 		# TODO: Error out or show to player.
# 		print("Level does not exist")
# 		return
#
# 	grid_carriage_bounds_by_level.erase(level)
#
