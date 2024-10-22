extends Node2D


@export var _map_image: Sprite2D

const ORIGINAL_IMAGE_SCALE = 1
const IMAGE_SCALE = 0.113


func zoom_in(zoom_scaling_increment: float) -> void:
	var absolute_scaling_increment = ORIGINAL_IMAGE_SCALE + zoom_scaling_increment
	_map_image.scale.x *= absolute_scaling_increment 
	_map_image.scale.y *= absolute_scaling_increment 
	_reposition_map_on_zoom(_map_image.get_local_mouse_position(), zoom_scaling_increment, true)


func zoom_out(zoom_scaling_increment: float) -> void:
	var absolute_scaling_increment = ORIGINAL_IMAGE_SCALE + zoom_scaling_increment
	_map_image.scale.x /= absolute_scaling_increment 
	_map_image.scale.y /= absolute_scaling_increment 
	_reposition_map_on_zoom(_map_image.get_local_mouse_position(), zoom_scaling_increment, false)


func move_map(relative_move_amount: Vector2) -> void:
	_map_image.position += relative_move_amount


func get_map_image_scale() -> Vector2:
	return _map_image.scale


func _reposition_map_on_zoom(
	original_mouse_position: Vector2, zoom_scaling_increment: float, is_zooming_in: bool = true
) -> void:
	var scaled_mouse_position: Vector2
	var absolute_scaling_increment = ORIGINAL_IMAGE_SCALE + zoom_scaling_increment

	if is_zooming_in:
		scaled_mouse_position = original_mouse_position * (absolute_scaling_increment)
	else:
		scaled_mouse_position = original_mouse_position / (absolute_scaling_increment)

	var offset = original_mouse_position - scaled_mouse_position
	_map_image.offset += offset

	_resize_group("station_vertex", offset)
	_resize_group("junction_vertex", offset)
	_resize_group("station_areas", offset)
	_resize_group("railway_edges", offset)
	

func _resize_group(group_name: String, offset: Vector2):
	for group_item in get_tree().get_nodes_in_group(group_name):
		group_item.position += offset