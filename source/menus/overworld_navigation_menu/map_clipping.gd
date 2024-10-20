extends Control


const zoom_scaling_increment := 0.1
const max_scale := Vector2(0.5, 0.5)
const min_scale := Vector2(0.07, 0.07)

@export var _map: Node2D

var dragging := false
var inputs = {
	ZOOM_IN = "zoom_in",
	ZOOM_OUT = "zoom_out",
	LEFT_MOUSE_CLICK = "left_mouse_click"
}


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(inputs.ZOOM_IN):
		if _map.get_map_image_scale() > max_scale:
			return

		_map.zoom_in(zoom_scaling_increment)

	if event.is_action_pressed(inputs.ZOOM_OUT):
		if _map.get_map_image_scale() < min_scale:
			return

		_map.zoom_out(zoom_scaling_increment)

	if event.is_action_pressed(inputs.LEFT_MOUSE_CLICK):
		dragging = true
	
	if event.is_action_released(inputs.LEFT_MOUSE_CLICK):
		dragging = false

	if dragging and event is InputEventMouseMotion:
		_map.move_map(event.relative)