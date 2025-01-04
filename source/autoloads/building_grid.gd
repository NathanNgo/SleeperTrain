extends TileMapLayer

const TILE_SIZE = 16
const GRID_OFFSET = 1


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


func get_grid_positions_for_aligned_shape(
	global_position_input: Vector2, height: float, length: float
):
	var half_length = length / 2
	var half_height = height / 2
	var shape_position_left = global_position_input.x - half_length
	var shape_position_right = global_position_input.x + half_length
	var shape_position_bottom = global_position_input.y + half_height
	var shape_position_top = global_position_input.y - half_height

	var bottom_left_position = global_position_to_grid(
		Vector2(shape_position_left, shape_position_bottom)
	)
	var top_right_position = global_position_to_grid(
		Vector2(shape_position_right, shape_position_top)
	)

	# The GRID_OFFSET prevents the shape from being one tile larger than it actually is.
	# This is because of how we sample the points. Given that being on the very edge
	# of the grid causes it to move into the square either on the top or the right, those
	# grids values will be used. E.g. a 1x1 will be a 2x2.
	return {
		Side.SIDE_LEFT: bottom_left_position.x,
		Side.SIDE_RIGHT: top_right_position.x - GRID_OFFSET,
		Side.SIDE_TOP: top_right_position.y + GRID_OFFSET,
		Side.SIDE_BOTTOM: bottom_left_position.y
	}


func _calculate_global_pin_position(
	global_center_position: Vector2, length: float, height: float
) -> Vector2:
	# centered_global_position: A global position centered on the square of the grid.
	# global_center_position: The position of the shapes center, in global coordinates.
	return Vector2(
		global_center_position.x + (length / 2.0) - (BuildingGrid.TILE_SIZE / 2.0),
		global_center_position.y - (height / 2.0) + (BuildingGrid.TILE_SIZE / 2.0)
	)


func get_grid_pin_position(
	global_center_position, length: float, height: float
) -> Vector2:
	return global_position_to_grid(
		_calculate_global_pin_position(global_center_position, length, height)
	)


func get_shift_for_grid_alignment(
	global_center_position: Vector2, length: float, height: float
) -> Vector2:
	var global_pin_position = _calculate_global_pin_position(
		global_center_position, length, height
	)
	var global_center_pin_position = center_global_position(global_pin_position)

	if global_pin_position == global_center_pin_position:
		return Vector2.ZERO

	var difference = global_center_pin_position - global_pin_position
	# The shift will always be one square to the bottom right if position -= difference.
	return difference


func grid_position_in_bounds(grid_position: Vector2, bounds: Dictionary) -> bool:
	if (
		bounds[Side.SIDE_LEFT] <= grid_position.x
		and grid_position.x <= bounds[Side.SIDE_RIGHT]
		and bounds[Side.SIDE_BOTTOM] >= grid_position.y
		and grid_position.y >= bounds[Side.SIDE_TOP]
	):
		return true
	return false


func grid_bounds_in_bounds(
	interior_bounds: Dictionary, exterior_bounds: Dictionary
) -> bool:
	if (
		interior_bounds[Side.SIDE_LEFT] < exterior_bounds[Side.SIDE_LEFT]
		or interior_bounds[Side.SIDE_RIGHT] > exterior_bounds[Side.SIDE_RIGHT]
		or interior_bounds[Side.SIDE_TOP] < exterior_bounds[Side.SIDE_TOP]
		or interior_bounds[Side.SIDE_BOTTOM] > exterior_bounds[Side.SIDE_BOTTOM]
	):
		return false
	return true
