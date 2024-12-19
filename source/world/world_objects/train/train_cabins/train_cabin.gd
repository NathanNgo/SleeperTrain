class_name TrainCabin extends Node2D

@export var _objects_container: Node2D
@export var _characters_container: Node2D
@export var _train_cabin_shape: CollisionShape2D
@export var _train_cabin_background: Sprite2D

var cabin_id: int
# Dict[Vector2, Node2D]
var _grid_position_to_objects_mapping = {}
var start_grid_position_x: int
var end_grid_position_x: int

@onready var length := _train_cabin_shape.shape.get_rect().size.x
@onready var height := _train_cabin_shape.shape.get_rect().size.y


func setup(start_grid_position_x_setup: int, end_grid_position_x_setup: int) -> void:
	var average_grid_position: Vector2 = (
		Vector2.ONE * (start_grid_position_x_setup + end_grid_position_x_setup) / 2.0
	)
	var average_global_position := BuildingGrid.grid_to_global_position(
		average_grid_position
	)
	position.x = to_local(average_global_position).x

	# var normalized_positions = get_normalized_position()
	material.set_shader_param("interior_is_transparent", false)
	# material.set_shader_param("bottom_left", false)
	# material.set_shader_param("top_right", false)


# func get_normalized_position() -> Variant:
# 	var half_length := length / 2.0
# 	var half_height := height / 2.0
# 	var texture_height := _train_cabin_background.texture.get_height()
# 	var texture_width := _train_cabin_background.texture.get_width()
# 
# 	var left_position = position.x - half_length
# 	var right_position = position.x + half_length
# 	var bottom_position = position.y - half_length
# 	var top_right = position.y + half_length
# 
# 	var left_percentage = left_position 
# 
# 	return {
# 		Corner.CORNER_BOTTOM_LEFT: Vector2(position.x - half_length, position.y - half_height),
# 		Corner.CORNER_TOP_RIGHT: Vector2(position.x + half_length, position.y + half_height)
# 	}


func set_train_cabin_background(background: Resource)	-> void:
	_train_cabin_background.texture = background


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
