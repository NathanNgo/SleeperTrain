class_name TrainCarriageLevel extends Polygon2D

const CARRIAGE_LEVEL_SPRITE_DEFAULT_OFFSET_X = 0
const CARRIAGE_LEVEL_SPRITE_DEFAULT_OFFSET_Y = 0

@export var _train_cabin: PackedScene
@export var _train_cabins_container: Node2D
@export var _objects_container: Node2D
@export var _train_carriage_level_area: Area2D
@export var _train_carriage_level_shape: CollisionShape2D
@export var _train_carriage_level_background: Sprite2D

# Dict[Vector2, Node2D]
var height: float
var length: float
var _grid_position_to_objects_mapping = {}
var _initial_position: Vector2
var _currently_selected: bool = false


func _ready() -> void:
	_calculate_height_and_length()
	_train_carriage_level_shape.shape = _train_carriage_level_shape.shape.duplicate()
	_train_carriage_level_shape.shape.set_size(Vector2(length, height))
	_train_carriage_level_area.mouse_entered.connect(_on_mouse_entered)
	_train_carriage_level_area.mouse_exited.connect(_on_mouse_exited)

	var carriage_level_sprite_rect = Rect2(
		CARRIAGE_LEVEL_SPRITE_DEFAULT_OFFSET_X,
		CARRIAGE_LEVEL_SPRITE_DEFAULT_OFFSET_Y,
		length,
		height
	)
	_train_carriage_level_background.set_region_rect(carriage_level_sprite_rect)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if not Globals.game_mode == Globals.GameModeType.BUILDING:
			return

		if not _currently_selected:
			_initial_position = Vector2.ZERO
			return

		var mouse_position = get_global_mouse_position()

		if not _initial_position or mouse_position.x < _initial_position.x:
			_initial_position = mouse_position
			return

		var start_grid_position_x = (
			BuildingGrid.global_position_to_grid(_initial_position).x
		)
		var end_grid_position_x = (
			BuildingGrid.global_position_to_grid(get_global_mouse_position()).x
		)
		add_cabin(start_grid_position_x, end_grid_position_x)
		_initial_position = Vector2.ZERO


func _calculate_height_and_length() -> void:
	var top := 0.0
	var bottom := 0.0
	var left := 0.0
	var right := 0.0

	for vertex in polygon:
		if vertex.x < left:
			left = vertex.x
		if vertex.x > right:
			right = vertex.x
		if vertex.y > top:
			top = vertex.y
		if vertex.y < bottom:
			bottom = vertex.y

		height = abs(top - bottom)
		length = abs(right - left)


func get_grid_positions():
	return BuildingGrid.get_grid_positions_for_shape(global_position, height, length)


func add_object(object: Node2D, grid_position: Vector2) -> void:
	_objects_container.add_child(object)
	object.position = to_local(BuildingGrid.grid_to_global_position(grid_position))
	_grid_position_to_objects_mapping[grid_position] = object


func remove_object(grid_position: Vector2) -> void:
	_grid_position_to_objects_mapping[grid_position].queue_free()


func get_object(grid_position: Vector2) -> Array[Node]:
	return _grid_position_to_objects_mapping[grid_position]


func get_objects() -> Array[Node]:
	return _objects_container.get_children()


func add_cabin(start_grid_position_x: int, end_grid_position_x: int) -> void:
	var cabin := _train_cabin.instantiate()
	_train_cabins_container.add_child(cabin)
	cabin.setup(start_grid_position_x, end_grid_position_x, height)


func remove_cabin(grid_position: Vector2) -> void:
	for cabin in _train_cabins_container.get_children():
		var cabin_grid_positions = cabin.get_grid_positions()
		if (
			cabin_grid_positions[Side.SIDE_LEFT] < grid_position.x
			and grid_position.x < cabin_grid_positions[Side.SIDE_RIGHT]
		):
			cabin.queue_free()
			return


func get_cabin_by_position(grid_position: Vector2) -> TrainCabin:
	for cabin in _train_cabins_container.get_children():
		var cabin_grid_positions = cabin.get_grid_positions()
		if (
			cabin_grid_positions[Side.SIDE_LEFT] < grid_position.x
			and grid_position.x < cabin_grid_positions[Side.SIDE_RIGHT]
		):
			return cabin
	return null


func get_cabin(cabin_number: int) -> TrainCabin:
	return _train_cabins_container.get_children().pop_at(cabin_number)


func get_cabins() -> Array[Node]:
	return _train_cabins_container.get_children()


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false
	_initial_position = Vector2.ZERO
