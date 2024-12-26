class_name WorldObject extends Node2D

@export var _world_object_area: Area2D
@export var _world_object_shape: CollisionShape2D

var world_object_id: int
var layer: Globals.Layers = Globals.Layers.CARRIAGE
var pin_position: Vector2
var height: float
var width: float
var _currently_selected := false


func setup(centered_global_position: Vector2) -> void:
	position = to_local(centered_global_position)
	_calculate_pin_position()
	_center_pin_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if (
			Globals.game_mode != Globals.GameModeType.DEMOLISHING
		):
			return

		if (
			layer != Globals.Layers.CABIN or layer != Globals.Layers.CARRIAGE
		):
			return

		if not _currently_selected:
			return

		remove()


func remove() -> void:
	TrainRegistry.unregister_world_object(world_object_id)
	queue_free()


func _calculate_pin_position() -> void:
	pin_position = Vector2(
		position.x - (width / 2.0) + (BuildingGrid.TILE_SIZE / 2.0),
		position.y + (height /2.0) - (BuildingGrid.TILE_SIZE / 2.0)
	)


func _center_pin_position() -> void:
	var global_pin_position = to_global(pin_position)
	var global_center_pin_position = BuildingGrid.center_global_position(global_pin_position)

	if global_pin_position == global_center_pin_position:
		return

	var difference = global_center_pin_position - global_pin_position
	position += difference


func _ready() -> void:
	world_object_id = TrainRegistry.register_world_object(self)
	_world_object_area.mouse_entered.connect(_on_mouse_entered)
	_world_object_area.mouse_exited.connect(_on_mouse_exited)
	width = _world_object_shape.shape.get_rect().size.x
	height = _world_object_shape.shape.get_rect().size.y


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false
