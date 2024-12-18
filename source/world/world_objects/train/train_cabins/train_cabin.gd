class_name TrainCabin extends Node2D

@export var _objects_container: Node2D
@export var _characters_container: Node2D
@export var _train_cabin_shape: CollisionShape2D

var cabin_id: int
# Dict[Vector2, Node2D]
var _grid_position_to_objects_mapping = {}

@onready var length = _train_cabin_shape.shape.get_rect().size.x
@onready var height = _train_cabin_shape.shape.get_rect().size.y


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


func add_character(character_id: int, spawn_position: Vector2) -> void:
	var character_world_representation = CharacterRegistry.get_world_representation(character_id)
	character_world_representation.position = to_local(spawn_position)
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
