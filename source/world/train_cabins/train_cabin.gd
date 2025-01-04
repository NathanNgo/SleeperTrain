class_name TrainCabin extends Node2D

enum CabinQualityType {
	AESTHETIC,
	AMENITIES,
	BEDDING,
	SPACE
}
enum AmenitiesType {
	STORAGE,
	TOILET,
	HYGIENE,
	DESK,
	SEATING
}

const AESTHETIC_MAX = 30
const AMENITIES_MAX = 25
const BEDDING_MAX = 30
const SPACE_MAX = 30
const AESTHETIC_MIN = 0
const AMENITIES_MIN = 0
const BEDDING_MIN = 0
const SPACE_MIN = 0

const CABIN_SPRITE_DEFAULT_OFFSET_X = 0
const CABIN_SPRITE_DEFAULT_OFFSET_Y = 0
const NUMBER_OF_GRID_POSTITIONS = 2

@export var _train_cabin_shape: CollisionShape2D
@export var _train_cabin_background: Sprite2D
@export var _train_cabin_foreground: Sprite2D
@export var _first_wall_shape: CollisionShape2D
@export var _second_wall_shape: CollisionShape2D

var cabin_id: int
# Dict[Vector2, Node2D]
var length: float
var height: float
var shape_grid_positions: Dictionary

var CabinQualitySchema = Z.schema({
	CabinQualityType.AESTHETIC: Z.integer().minimum(AESTHETIC_MIN).maximum(AESTHETIC_MAX),
	CabinQualityType.AMENITIES: Z.integer().minimum(AMENITIES_MIN).maximum(AMENITIES_MAX),
	CabinQualityType.BEDDING: Z.integer().minimum(BEDDING_MIN).maximum(BEDDING_MAX),
	CabinQualityType.SPACE: Z.integer().minimum(SPACE_MIN).maximum(SPACE_MAX),
})

var CabinAmenitiesSchema = Z.schema({
	AmenitiesType.STORAGE: Z.boolean(),
	AmenitiesType.TOILET: Z.boolean(),
	AmenitiesType.HYGIENE: Z.boolean(),
	AmenitiesType.DESK: Z.boolean(),
	AmenitiesType.SEATING: Z.boolean()
})

var cabin_quality := {
	CabinQualityType.AESTHETIC: 0,
	CabinQualityType.AMENITIES: 0,
	CabinQualityType.BEDDING: 0,
	CabinQualityType.SPACE: 0,
}

var cabin_amenities := {
	AmenitiesType.STORAGE: false,
	AmenitiesType.TOILET: false,
	AmenitiesType.HYGIENE: false,
	AmenitiesType.DESK: false,
	AmenitiesType.SEATING: false,
}


func setup(
	start_centered_global_position_setup: Vector2 = Vector2.ZERO,
	end_centered_global_position_setup: Vector2 = Vector2.ZERO,
	height_setup: float = 0.0
) -> void:
	var average_global_position: Vector2 = (
		(start_centered_global_position_setup + end_centered_global_position_setup)
		/ NUMBER_OF_GRID_POSTITIONS
	)

	position.x = to_local(average_global_position).x

	height = height_setup
	length = (
		end_centered_global_position_setup.x
		- start_centered_global_position_setup.x
		+ BuildingGrid.TILE_SIZE
	)

	_train_cabin_shape.shape = _train_cabin_shape.shape.duplicate()
	_train_cabin_shape.shape.set_size(Vector2(length, height))

	var cabin_sprite_rect = Rect2(
		CABIN_SPRITE_DEFAULT_OFFSET_X, CABIN_SPRITE_DEFAULT_OFFSET_Y, length, height
	)
	_train_cabin_background.set_region_rect(cabin_sprite_rect)
	_train_cabin_foreground.set_region_rect(cabin_sprite_rect)

	# to_global(position) will give incorrect results, as it's designed for the nodes
	# children. We therefore need to use global_position instead.
	# https://docs.godotengine.org/en/stable/classes/class_node2d.html#class-node2d-method-to-global
	shape_grid_positions = BuildingGrid.get_grid_positions_for_aligned_shape(
		_train_cabin_shape.global_position, height, length
	)

	_first_wall_shape.shape = _first_wall_shape.shape.duplicate()
	_first_wall_shape.shape.set_size(Vector2(BuildingGrid.TILE_SIZE, height))
	_first_wall_shape.position.x = to_local(start_centered_global_position_setup).x
	_second_wall_shape.shape = _second_wall_shape.shape.duplicate()
	_second_wall_shape.shape.set_size(Vector2(BuildingGrid.TILE_SIZE, height))
	_second_wall_shape.position.x = to_local(end_centered_global_position_setup).x


func remove() -> void:
	queue_free()


func _ready() -> void:
	cabin_id = TrainRegistry.register_cabin(self)


func _exit_tree() -> void:
	TrainRegistry.unregister_cabin(cabin_id)


func set_train_cabin_background(background: Resource) -> void:
	_train_cabin_background.texture = background


func grid_position_in_cabin(grid_position: Vector2) -> bool:
	if (
		shape_grid_positions[Side.SIDE_LEFT] < grid_position.x
		and grid_position.x < shape_grid_positions[Side.SIDE_RIGHT]
		and shape_grid_positions[Side.SIDE_BOTTOM] < grid_position.y
		and grid_position.y < shape_grid_positions[Side.SIDE_TOP]
	):
		return true
	return false


func hide_foreground() -> void:
	_train_cabin_foreground.hide()


func show_foreground() -> void:
	_train_cabin_foreground.show()
