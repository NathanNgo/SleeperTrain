class_name TrainCarriageLevel extends Node2D

@export var _train_cabin: PackedScene
@export var _objects: Node2D
@export var _cabins: Node2D
@export var _train_carriage_level_shape: CollisionShape2D

# Dict[Vector2, Node2D]
var _grid_position_to_objects_mapping = {}

@onready var length = _train_carriage_level_shape.shape.get_rect().size.x
@onready var height = _train_carriage_level_shape.shape.get_rect().size.y


func get_grid_positions():
	return BuildingGrid.get_grid_positions_for_shape(global_position, length, height)


func add_object(object: Node2D, grid_position: Vector2) -> void:
	_objects.add_child(object)
	_grid_position_to_objects_mapping[grid_position] = object


func remove_object(grid_position: Vector2) -> void:
	_grid_position_to_objects_mapping[grid_position].queue_free()


func get_object(grid_position: Vector2) -> Array[Node]:
	return _grid_position_to_objects_mapping[grid_position]


func get_objects() -> Array[Node]:
	return _objects.get_children()


func add_cabin(start: int, end: int) -> void:
	var cabin := _train_cabin.instantiate()
	_cabins.add_child(cabin)
	cabin.setup(start, end)


func remove_cabin(grid_position: Vector2) -> void:
	for cabin in _cabins.get_children():
		var cabin_grid_positions = cabin.get_grid_positions()
		if (
			cabin_grid_positions[Globals.GridPositionType.LEFT] < grid_position.x
			and grid_position.x < cabin_grid_positions[Globals.GridPositionType.RIGHT]
		):
			cabin.queue_free()
			return


func get_cabin(grid_position: Vector2) -> TrainCabin:
	for cabin in _cabins.get_children():
		var cabin_grid_positions = cabin.get_grid_positions()
		if (
			cabin_grid_positions[Globals.GridPositionType.LEFT] < grid_position.x
			and grid_position.x < cabin_grid_positions[Globals.GridPositionType.RIGHT]
		):
			return cabin
	return null


func get_cabins() -> Array[Node]:
	return _cabins.get_children()
