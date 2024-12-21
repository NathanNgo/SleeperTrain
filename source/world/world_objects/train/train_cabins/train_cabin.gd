class_name TrainCabin extends Node2D

@export var _objects_container: Node2D
@export var _characters_container: Node2D
@export var _train_cabin_shape: CollisionShape2D
@export var _train_cabin_background: Sprite2D
@export var _train_cabin_foreground: Sprite2D

var cabin_id: int
# Dict[Vector2, Node2D]
var _grid_position_to_objects_mapping = {}
var start_grid_position_x: int
var end_grid_position_x: int
var length: float



func setup(start_grid_position_x_setup: int, end_grid_position_x_setup: int, height: float) -> void:
	var start_global_position = BuildingGrid.grid_to_global_position(Vector2.ONE * start_grid_position_x_setup)
	var end_global_position = BuildingGrid.grid_to_global_position(Vector2.ONE * end_grid_position_x_setup)

	var average_global_position: Vector2 = (start_global_position + end_global_position) / 2.0
	position.x = to_local(average_global_position).x
	length = end_global_position.x - start_global_position.x

	_train_cabin_shape.shape = _train_cabin_shape.shape.duplicate()
	_train_cabin_shape.shape.set_size(Vector2(length, height))

	_train_cabin_background.set_region_rect(Rect2(0, 0, length, height))
	_train_cabin_foreground.set_region_rect(Rect2(0, 0, length, height))


func set_train_cabin_background(background: Resource)	-> void:
	_train_cabin_background.texture = background


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