extends TileMapLayer


func global_position_to_grid(global_position_input: Vector2) -> Vector2:
	var local_position = to_local(global_position_input)
	return local_to_map(local_position)


func get_grid_positions_for_shape(
	global_position_input: Vector2, length: float, height: float
):
	var half_length = length / 2
	var half_height = height / 2
	var grid_position_left = global_position_input.x - half_length
	var grid_position_right = global_position_input.x + half_length
	var grid_position_bottom = global_position_input.y - half_height
	var grid_position_top = global_position_input.y + half_height

	return {
		Globals.GridPositionType.LEFT: global_position_to_grid(grid_position_left),
		Globals.GridPositionType.RIGHT: global_position_to_grid(grid_position_right),
		Globals.GridPositionType.TOP: global_position_to_grid(grid_position_top),
		Globals.GridPositionType.BOTTOM: global_position_to_grid(grid_position_bottom)
	}
