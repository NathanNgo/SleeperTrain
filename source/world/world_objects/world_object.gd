class_name WorldObject extends Node2D

@export var _world_object_area: Area2D
@export var _world_object_shape: CollisionShape2D

var world_object_id: int
var layer: Globals.Layers = Globals.Layers.CARRIAGE

var height: float
var length: float

var shape_grid_positions: Dictionary

var _currently_selected := false


func setup(centered_global_position: Vector2) -> void:
	global_position = centered_global_position
	# The object is placed in the center of a grid square, and so
	# centered_global_position == global_center_position
	position -= BuildingGrid.get_shift_for_grid_alignment(
		centered_global_position, length, height
	)
	shape_grid_positions = BuildingGrid.get_grid_positions_for_aligned_shape(
		_world_object_shape.global_position, height, length
	)


func _ready() -> void:
	world_object_id = TrainRegistry.register_world_object(self)
	_world_object_area.mouse_entered.connect(_on_mouse_entered)
	_world_object_area.mouse_exited.connect(_on_mouse_exited)
	length = _world_object_shape.shape.get_rect().size.x
	height = _world_object_shape.shape.get_rect().size.y
	setup(BuildingGrid.center_global_position(global_position))


func _exit_tree() -> void:
	TrainRegistry.unregister_world_object(world_object_id)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if Globals.game_mode != Globals.GameModeType.DEMOLISHING:
			return

		if layer != Globals.Layers.CABIN or layer != Globals.Layers.CARRIAGE:
			return

		if not _currently_selected:
			return

		remove()


func remove() -> void:
	queue_free()


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false
