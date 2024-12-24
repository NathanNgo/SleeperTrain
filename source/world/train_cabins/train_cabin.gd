class_name TrainCabin extends Node2D

const CABIN_SPRITE_DEFAULT_OFFSET_X = 0
const CABIN_SPRITE_DEFAULT_OFFSET_Y = 0
const NUMBER_OF_GRID_POSTITIONS = 2

@export var _train_cabin_shape: CollisionShape2D
@export var _train_cabin_background: Sprite2D
@export var _train_cabin_foreground: Sprite2D

var cabin_id: int
# Dict[Vector2, Node2D]
var left_grid_position: int
var right_grid_position: int
var bottom_grid_position: int
var top_grid_position: int
var length: float


func setup(
	start_centered_global_position_setup: Vector2,
	end_centered_global_position_setup: Vector2,
	height: float
) -> void:
	var average_global_position: Vector2 = (
		(start_centered_global_position_setup + end_centered_global_position_setup) / NUMBER_OF_GRID_POSTITIONS
	)

	position.x = to_local(average_global_position).x
	length = end_centered_global_position_setup.x - start_centered_global_position_setup.x

	_train_cabin_shape.shape = _train_cabin_shape.shape.duplicate()
	_train_cabin_shape.shape.set_size(Vector2(length, height))

	var cabin_sprite_rect = Rect2(
		CABIN_SPRITE_DEFAULT_OFFSET_X, CABIN_SPRITE_DEFAULT_OFFSET_Y, length, height
	)
	_train_cabin_background.set_region_rect(cabin_sprite_rect)
	_train_cabin_foreground.set_region_rect(cabin_sprite_rect)

	left_grid_position = BuildingGrid.global_position_to_grid(start_centered_global_position_setup).x
	right_grid_position = BuildingGrid.global_position_to_grid(end_centered_global_position_setup).x
	bottom_grid_position = BuildingGrid.global_position_to_grid(global_position - Vector2.ONE * (height / 2.0)).y
	top_grid_position = BuildingGrid.global_position_to_grid(global_position + Vector2.ONE * (height / 2.0)).y


func remove() -> void:
	TrainRegistry.unregister_cabin(cabin_id)
	queue_free()


func _ready() -> void:
	cabin_id = TrainRegistry.register_cabin(self)


func set_train_cabin_background(background: Resource) -> void:
	_train_cabin_background.texture = background


func grid_position_in_cabin(grid_position) -> bool:
	if (
		left_grid_position < grid_position.x
		and grid_position.x < right_grid_position
		and bottom_grid_position < grid_position.y
		and grid_position.y < top_grid_position
	):
		return true
	return false


func hide_foreground() -> void:
	_train_cabin_foreground.hide()


func show_foreground() -> void:
	_train_cabin_foreground.show()