class_name WorldObject extends Node2D

@export var _world_object_area: Area2D

var world_object_id: int
var layer: Globals.Layers = Globals.Layers.CARRIAGE
var pin_grid_position: Vector2
var height: int
var width: int
var _currently_selected := false


func setup(centered_global_position: Vector2) -> void:
	position = to_local(centered_global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if (
			Globals.game_mode != Globals.GameModeType.DEMOLISHING_CARRIAGE_LAYER
			or Globals.game_mode != Globals.GameModeType.DEMOLISHING_CABIN_LAYER
		):
			return

		if (
			Globals.game_mode == Globals.GameModeType.DEMOLISHING_CABIN_LAYER
			and layer != Globals.Layers.CABIN
		):
			return

		if (
			Globals.game_mode == Globals.GameModeType.DEMOLISHING_CARRIAGE_LAYER
			and layer != Globals.Layers.CARRIAGE
		):
			return

		if not _currently_selected:
			return

		remove()


func remove() -> void:
	TrainRegistry.unregister_world_object(world_object_id)
	queue_free()


func _ready() -> void:
	world_object_id = TrainRegistry.register_world_object(self)
	_world_object_area.mouse_entered.connect(_on_mouse_entered)
	_world_object_area.mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false