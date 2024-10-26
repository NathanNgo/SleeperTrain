extends Node2D

@export var _camera: Camera2D
@export var level: Node2D

const ZOOM_SCALING_INCREMENT := 0.1

var inputs = {
	ZOOM_IN = "zoom_in",
	ZOOM_OUT = "zoom_out",
	LEFT_MOUSE_CLICK = "left_mouse_click"
}
var dragging = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(inputs.ZOOM_IN):
		_camera.zoom += Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(inputs.ZOOM_OUT):
		_camera.zoom -= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(inputs.LEFT_MOUSE_CLICK):
		dragging = true
	
	if event.is_action_released(inputs.LEFT_MOUSE_CLICK):
		dragging = false

	if dragging and event is InputEventMouseMotion:
		_move_camera(event.relative)


func _move_camera(relative_move_amount: Vector2) -> void:
	_camera.position -= relative_move_amount / _camera.zoom.x