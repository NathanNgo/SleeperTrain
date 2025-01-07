class_name TrainCarriage extends Polygon2D

enum TrainCarriageType { BASIC }

@export var _train_building_zones_container: Node2D
@export var initial_carriage_index := 0

var carriage_id: int
var max_train_carriage_length := 0.0


func _ready() -> void:
	_calculate_max_length()
	carriage_id = TrainRegistry.register_carriage(self)


func _exit_tree() -> void:
	TrainRegistry.unregister_carriage(carriage_id)


func get_building_zone_by_position(grid_position: Vector2) -> TrainBuildingZone:
	for building_zone in _train_building_zones_container.get_children():
		var building_zone_grid_positions = building_zone.get_grid_positions()
		if (
			(grid_position.y < building_zone_grid_positions[Side.SIDE_BOTTOM])
			or (grid_position.y > building_zone_grid_positions[Side.SIDE_TOP])
		):
			continue

		return building_zone
	return null


func get_building_zone(level: int) -> TrainBuildingZone:
	return _train_building_zones_container.get_children()[level]


func _calculate_max_length() -> void:
	var left := 0.0
	var right := 0.0

	for vertex in polygon:
		if vertex.x < left:
			left = vertex.x
		if vertex.x > right:
			right = vertex.x

		max_train_carriage_length = abs(right - left)


func get_cabins_in_carriage() -> Array[TrainCabin]:
	var cabins: Array[TrainCabin] = []
	for building_zone in _train_building_zones_container.get_children():
		cabins.append_array(building_zone.get_cabins_in_building_zone())

	return cabins
