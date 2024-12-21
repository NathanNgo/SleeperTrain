class_name TrainCarriage extends Polygon2D

@export var _train_carriage_levels_container: Node2D

var carriage_id: int
var max_train_carriage_length := 0.0

enum TrainCarriageType { BASIC, SHORT }


func _ready() -> void:
	_calculate_max_length()


func get_carriage_level_by_position(grid_position: Vector2) -> TrainCarriageLevel:
	for carriage_level in _train_carriage_levels_container.get_children():
		var carriage_level_grid_positions = carriage_level.get_grid_positions()
		if (
			(grid_position.y < carriage_level_grid_positions[Side.SIDE_BOTTOM])
			or (grid_position.y > carriage_level_grid_positions[Side.SIDE_TOP])
		):
			continue

		return carriage_level
	return null


func get_carriage_level(level: int) -> TrainCarriageLevel:
	return _train_carriage_levels_container.get_children().pop_at(level)


func _calculate_max_length() -> void:
	var left := 0.0
	var right := 0.0

	for vertex in polygon:
		if vertex.x < left:
			left = vertex.x
		if vertex.x > right:
			right = vertex.x

		max_train_carriage_length = abs(right - left)