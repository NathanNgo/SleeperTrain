extends TileMapLayer

const TILE_SIZE = 32


func _ready() -> void:
	tile_set = TileSet.new()
	tile_set.tile_size = Vector2.ONE * TILE_SIZE


func global_position_to_grid(global_position_input: Vector2) -> Vector2:
	var local_position = to_local(global_position_input)
	return local_to_map(local_position)


func grid_to_global_position(grid_position: Vector2) -> Vector2:
	var local_position = map_to_local(grid_position)
	return to_global(local_position)


func center_global_position(global_position_input: Vector2) -> Vector2:
	return grid_to_global_position(global_position_to_grid(global_position_input))


func get_grid_positions_for_shape(
	global_position_input: Vector2, height: float, length: float
):
	var half_length = length / 2
	var half_height = height / 2
	var grid_position_left = global_position_input.x - half_length
	var grid_position_right = global_position_input.x + half_length
	var grid_position_bottom = global_position_input.y - half_height
	var grid_position_top = global_position_input.y + half_height

	return {
		Side.SIDE_LEFT: global_position_to_grid(grid_position_left),
		Side.SIDE_RIGHT: global_position_to_grid(grid_position_right),
		Side.SIDE_TOP: global_position_to_grid(grid_position_top),
		Side.SIDE_BOTTOM: global_position_to_grid(grid_position_bottom)
	}


func _calculate_global_pin_position(global_center_position: Vector2, width: float, height: float) -> Vector2:
	# centered_global_position: A global position centered on the square of the grid.
	# global_center_position: The position of the shapes center, in global coordinates.
	return Vector2(
		global_center_position.x - (width / 2.0) + (BuildingGrid.TILE_SIZE / 2.0),
		global_center_position.y + (height /2.0) - (BuildingGrid.TILE_SIZE / 2.0)
	)


func get_shift_for_grid_alignment(global_center_position: Vector2, width: float, height: float) -> Vector2:
	var global_pin_position = _calculate_global_pin_position(global_center_position, width, height)
	var global_center_pin_position = center_global_position(global_pin_position)

	if global_pin_position == global_center_pin_position:
		return Vector2.ZERO

	var difference = global_center_pin_position - global_pin_position
	# The pin position will always be in the top left if position += difference.
	return difference