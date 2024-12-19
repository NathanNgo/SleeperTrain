class_name TrainCarriageLevel extends Node2D

const MIN_CABIN_SIZE = 2

@export var _train_cabin: PackedScene
@export var _train_cabins_container: Node2D
@export var _objects_container: Node2D
@export var _characters_container: Node2D
@export var _train_carriage_level_shape: CollisionShape2D

# Dict[Vector2, Node2D]
var _grid_position_to_objects_mapping = {}

@onready var length = _train_carriage_level_shape.shape.get_rect().size.x
@onready var height = _train_carriage_level_shape.shape.get_rect().size.y


func get_grid_positions():
	return BuildingGrid.get_grid_positions_for_shape(global_position, length, height)


func add_object(object: Node2D, grid_position: Vector2) -> void:
	_objects_container.add_child(object)
	object.position = to_local(BuildingGrid.grid_to_global_position(grid_position))
	_grid_position_to_objects_mapping[grid_position] = object


func remove_object(grid_position: Vector2) -> void:
	_grid_position_to_objects_mapping[grid_position].queue_free()


func get_object(grid_position: Vector2) -> Array[Node]:
	return _grid_position_to_objects_mapping[grid_position]


func get_objects() -> Array[Node]:
	return _objects_container.get_children()


func add_character(character_id: int, spawn_global_position: Vector2) -> void:
	var character_world_representation = CharacterRegistry.get_world_representation(
		character_id
	)
	character_world_representation.position = to_local(spawn_global_position)
	_characters_container.add_child(character_world_representation)


func remove_character(character_id: Vector2) -> void:
	for character in _characters_container.get_children():
		if character.character_data.character_id == character_id:
			character.queue_free()


func get_character(character_id: int) -> CharacterWorldRepresentation:
	for character in _characters_container.get_children():
		if character.character_data.character_id == character_id:
			return character
	return null


func get_characters() -> Array[Node]:
	return _characters_container.get_children()


func add_cabin(start_grid_position_x: int, end_grid_position_x: int) -> void:
	var cabin := _train_cabin.instantiate()
	_train_cabins_container.add_child(cabin)
	cabin.setup(start_grid_position_x, end_grid_position_x)


func remove_cabin(grid_position: Vector2) -> void:
	for cabin in _train_cabins_container.get_children():
		var cabin_grid_positions = cabin.get_grid_positions()
		if (
			cabin_grid_positions[Side.SIDE_LEFT] < grid_position.x
			and grid_position.x < cabin_grid_positions[Side.SIDE_RIGHT]
		):
			cabin.queue_free()
			return


func get_cabin_by_position(grid_position: Vector2) -> TrainCabin:
	for cabin in _train_cabins_container.get_children():
		var cabin_grid_positions = cabin.get_grid_positions()
		if (
			cabin_grid_positions[Side.SIDE_LEFT] < grid_position.x
			and grid_position.x < cabin_grid_positions[Side.SIDE_RIGHT]
		):
			return cabin
	return null


func get_cabin(cabin_number: int) -> TrainCabin:
	return _train_cabins_container.get_children().pop_at(cabin_number)


func get_cabins() -> Array[Node]:
	return _train_cabins_container.get_children()
