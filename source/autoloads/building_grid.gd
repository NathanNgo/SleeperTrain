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
