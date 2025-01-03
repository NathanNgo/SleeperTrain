class_name TrainCarriageLevel extends Polygon2D

const CARRIAGE_LEVEL_SPRITE_DEFAULT_OFFSET_X = 0
const CARRIAGE_LEVEL_SPRITE_DEFAULT_OFFSET_Y = 0

@export var _train_cabin: PackedScene
@export var _door_portal: PackedScene
# TODO: Remove this.
@export var _placeholder_world_object: PackedScene
@export var _train_cabins_container: Node2D
@export var _world_objects_container: Node2D
@export var _portals_container: Node2D
@export var _train_carriage_level_area: Area2D
@export var _train_carriage_level_shape: CollisionShape2D
@export var _train_carriage_level_background: Sprite2D

# Dict[Vector2, Node2D]
var height: float
var length: float

var shape_grid_positions: Dictionary

var _initial_position: Vector2
var _currently_selected: bool = false


func _ready() -> void:
	_calculate_height_and_length()
	shape_grid_positions = BuildingGrid.get_grid_positions_for_shape(
		_train_carriage_level_shape.global_position, height, length
	)
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
		if Globals.game_mode != Globals.GameModeType.BUILDING:
			return

		if not _currently_selected:
			return

		var mouse_position = get_global_mouse_position()

		match Globals.building_object_type:
			Globals.ObjectType.CABIN:
				build_cabin(mouse_position)
			Globals.ObjectType.PORTAL:
				build_portal(mouse_position)
			Globals.ObjectType.WORLD_OBJECT:
				build_world_object(mouse_position)


func build_cabin(mouse_position: Vector2) -> void:
	if not _initial_position or mouse_position.x < _initial_position.x:
		_initial_position = mouse_position
		return

	add_cabin(
		BuildingGrid.center_global_position(_initial_position),
		BuildingGrid.center_global_position(mouse_position)
	)
	_initial_position = Vector2.ZERO


func add_cabin(
	start_centered_global_position: Vector2, end_centered_global_position: Vector2
) -> void:
	var cabin := _train_cabin.instantiate()
	_train_cabins_container.add_child(cabin)
	cabin.setup(start_centered_global_position, end_centered_global_position, height)


func build_portal(mouse_position: Vector2) -> void:
	var portal = add_portal(BuildingGrid.center_global_position(mouse_position))

	if not BuildingGrid.grid_bounds_in_bounds(
		portal.shape_grid_positions, shape_grid_positions
	):
		portal.queue_free()
		# TODO: Show to player
		print("Portal out of bounds")
		return


func add_portal(centered_global_position: Vector2) -> Portal:
	var portal := _door_portal.instantiate()
	_portals_container.add_child(portal)
	portal.setup(centered_global_position)
	return portal


func build_world_object(mouse_position) -> void:
	var world_object = add_world_object(BuildingGrid.center_global_position(mouse_position))

	if not BuildingGrid.grid_bounds_in_bounds(
		world_object.shape_grid_positions, shape_grid_positions
	):
		world_object.queue_free()
		# TODO: Show to player
		print("Object out of bounds")
		return


func add_world_object(centered_global_position: Vector2) -> WorldObject:
	var world_object := WorldObjectFactory.create_world_object(
		Globals.building_world_object_type
	)
	_world_objects_container.add_child(world_object)
	world_object.setup(centered_global_position)
	return world_object


func commit_world_object() -> void:
	pass


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


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false
	_initial_position = Vector2.ZERO
