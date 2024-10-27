extends Node2D

@export var _camera: Camera2D
@export var level: Node2D
@export var train_path: Path2D

const ZOOM_SCALING_INCREMENT := 2
const MAX_ZOOM_SCALE := 4

var inputs = {
	ZOOM_IN = "zoom_in",
	ZOOM_OUT = "zoom_out",
	LEFT_MOUSE_CLICK = "left_mouse_click"
}
var dragging = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(inputs.ZOOM_IN):
		if _camera.zoom == Vector2.ONE * MAX_ZOOM_SCALE:
			return
		_camera.zoom *= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(inputs.ZOOM_OUT):
		if _camera.zoom == Vector2.ONE:
			return
		_camera.zoom /= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(inputs.LEFT_MOUSE_CLICK):
		dragging = true
	
	if event.is_action_released(inputs.LEFT_MOUSE_CLICK):
		dragging = false

	if dragging and event is InputEventMouseMotion:
		_move_camera(event.relative)


func _move_camera(relative_move_amount: Vector2) -> void:
	_camera.position -= relative_move_amount / _camera.zoom.x