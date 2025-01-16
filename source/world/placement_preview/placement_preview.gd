class_name PlacementPreview extends Node2D

@export var _world_object_shape: CollisionShape2D
@export var _world_object_sprite: Sprite2D

var height: float
var length: float
var shape_grid_positions: Dictionary


func set_shape(height_input, length_input) -> void:
	height = height_input
	length = length_input
	_world_object_shape.shape.get_rect().size.x = height
	_world_object_shape.shape.get_rect().size.y = length


func set_sprite(texture: Texture2D) -> void:
	_world_object_sprite.texture = texture


func move(global_mouse_position: Vector2) -> void:
	position -= BuildingGrid.get_shift_for_grid_alignment(
		global_mouse_position, length, height
	)
	shape_grid_positions = BuildingGrid.get_grid_positions_for_aligned_shape(
		_world_object_shape.global_position, height, length
	)
