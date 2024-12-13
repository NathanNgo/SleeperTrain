extends Node2D

@export var _train_carriage_shape: CollisionShape2D

var carriage_id: int
# Array[Array[int]], carriage_divisions[carraige_level, division_position]
var carriage_divisions = []

@onready var train_carriage_length := _train_carriage_shape.shape.get_rect().size.x


func add_division_on_level(division_position: int, level: int) -> void:
	# level > size, discontinuous array.
	# level == size, creating a new item in the array by appending onto the end.
	# level < size, accessing existing item.

	if level > carriage_divisions.size():
		# TODO: Error out or show to player.
		print("Cannot create discontinuous level")
		return

	if level == carriage_divisions.size():
		carriage_divisions.append([])

	if carriage_divisions[level].has(division_position):
		# TODO: Error out or show to player.
		print("Division already exists on level")
		return

	carriage_divisions[level].append(division_position)
	carriage_divisions.sort()


func remove_division_on_level(division_position: int, level: int) -> void:
	if level >= carriage_divisions.size():
		# TODO: Error out or show to player.
		print("Level does not exist")
		return

	carriage_divisions[level].erase(division_position)
	carriage_divisions.sort()


func remove_all_divisions() -> void:
	carriage_divisions.clear()
