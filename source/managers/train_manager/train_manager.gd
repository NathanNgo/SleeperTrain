class_name TrainManager extends Node

signal carriage_added(carriage: Node2D)
signal character_added

const DEFAULT_CARRIAGE_AMOUNT := 1
const DEFAULT_PASSENGER_LIMIT := 1
const CARRIAGE_WIDTH_MULTIPLIER := 0.5
const DEFAULT_COAL_CONSUMPTION := 5
const MAX_CONSUMPTION_WAIT_TIME := 10.0
const MIN_CONSUMPTION_WAIT_TIME := 5.0

@export var _train_carriage_scene: PackedScene
@export var _train_carriage_short_scene: PackedScene
@export var _consumption_timer: Timer
@export var _train_resources: Resource

# Index 0 will always be the back of the train. len(train_layout) - 1 will always
# be the front of the train.
var train_layout: Array[Node2D] = []
# Dict[int, int]
var character_id_to_carriage_id_mapping = {}
# Dict[int, Array[int]]
var carriage_id_to_character_ids_mapping = {}
var carriage_id_count = 0


func setup(carriage_type: TrainCarriage.TrainCarriageType) -> void:
	add_carriage_at(0, carriage_type)


func _ready() -> void:
	SignalBus.add_train_carriage_at.connect(_on_add_train_carriage_at)
	SignalBus.remove_train_carriage_at.connect(_on_remove_train_carriage_at)
	SignalBus.add_train_carriage_at_front.connect(_on_add_train_carriage_at_front)
	SignalBus.remove_train_carriage_at_front.connect(_on_remove_train_carriage_at_front)
	SignalBus.add_train_carriage_at_back.connect(_on_add_train_carriage_at_back)
	SignalBus.remove_train_carriage_at_back.connect(_on_remove_train_carriage_at_back)

	SignalBus.add_character_to_carriage.connect(_on_add_character_to_carriage)
	SignalBus.remove_character.connect(_on_remove_character)
	SignalBus.remove_all_characters.connect(_on_remove_all_characters)

	SignalBus.add_cabin_to_carriage.connect(_on_add_cabin_to_carriage)
	SignalBus.remove_cabin_from_carriage.connect(_on_remove_cabin_from_carraige)

	_consumption_timer.timeout.connect(_on_consumption_timer_timeout)


func _organize_train() -> void:
	# We reverse the array to easily iterate from the front of the train to the back.
	var copy_train_layout := train_layout.duplicate()
	copy_train_layout.reverse()

	var initial_carriage_length: float = (
		copy_train_layout[0].max_train_carriage_length
		if copy_train_layout.size() > 0
		else 0.0
	)
	var current_train_length := 0.0

	for train_carriage in copy_train_layout:
		var train_offset = (
			current_train_length
			+ (
				CARRIAGE_WIDTH_MULTIPLIER
				* (train_carriage.max_train_carriage_length - initial_carriage_length)
			)
		)

		train_carriage.position.x = -train_offset
		current_train_length += train_carriage.max_train_carriage_length


func get_carriage(carriage_id: int) -> Node2D:
	var carriage = train_layout.filter(
		func(current_carriage): current_carriage.carriage_id = carriage_id
	)[0]

	return carriage


func add_carriage_at(
	carriage_index: int, train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	var train_carriage: Node2D

	match train_carriage_type:
		TrainCarriage.TrainCarriageType.BASIC:
			train_carriage = _train_carriage_scene.instantiate()
		TrainCarriage.TrainCarriageType.SHORT:
			train_carriage = _train_carriage_short_scene.instantiate()

	carriage_id_count  += 1
	train_carriage.carriage_id = carriage_id_count

	_push_at(carriage_index, train_carriage)
	# We need the train carriage to be added to the scene tree before we organise the
	# train. Otherwise, _ready() doesn't get run, and none of the member variables we
	# rely on to calculate the carriage offsets are initialized.
	carriage_added.emit(train_carriage)
	_organize_train()


func remove_carriage_at(carriage_index: int) -> void:
	if carriage_index >= len(train_layout):
		return

	var carriage_id = train_layout[carriage_index].carriage_id

	if (
		carriage_id in carriage_id_to_character_ids_mapping
		and not carriage_id_to_character_ids_mapping[carriage_id]
	):
		# TODO: Display message to user.
		print("Cannot remove carriage with passengers assigned.")
		return

	var train_carriage = train_layout.pop_at(carriage_index)

	train_carriage.queue_free()
	_organize_train()


func add_character_to_carriage(character_id: int, carriage_index: int) -> void:
	# We identify carriages by carriage_id and not carriage_index as the index can change
	# when we add or remove carriages. The id remains consistent.
	var carriage_id = train_layout[carriage_index].carriage_id

	if carriage_id not in carriage_id_to_character_ids_mapping:
		carriage_id_to_character_ids_mapping[carriage_id] = []

	if carriage_id_to_character_ids_mapping[carriage_id].size() > DEFAULT_PASSENGER_LIMIT:
		# TODO: Display to player
		print("Carriage is full")
		return

	character_id_to_carriage_id_mapping[character_id] = carriage_id
	carriage_id_to_character_ids_mapping[carriage_id] += [character_id]

	character_added.emit()


func remove_character(character_id: int) -> void:
	var carriage_id = character_id_to_carriage_id_mapping[character_id]

	if character_id in character_id_to_carriage_id_mapping:
		character_id_to_carriage_id_mapping.erase(character_id)

	if carriage_id in carriage_id_to_character_ids_mapping:
		carriage_id_to_character_ids_mapping[carriage_id].erase(character_id)


func remove_all_characters() -> void:
	character_id_to_carriage_id_mapping.clear()
	carriage_id_to_character_ids_mapping.clear()


func move_character_to_carriage(character_id: int, carriage_index: int) -> void:
	remove_character(character_id)
	add_character_to_carriage(character_id, carriage_index)


func start_train_consumption() -> void:
	_consumption_timer.wait_time = randf_range(
		MIN_CONSUMPTION_WAIT_TIME, MAX_CONSUMPTION_WAIT_TIME
	)
	_consumption_timer.start()


func stop_train_consumption() -> void:
	_consumption_timer.stop()


func _on_add_train_carriage_at(
	carriage_index: int, train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	add_carriage_at(carriage_index, train_carriage_type)


func _on_remove_train_carriage_at(carriage_index: int) -> void:
	remove_carriage_at(carriage_index)


func _on_add_train_carriage_at_front(
	train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	add_carriage_at(len(train_layout), train_carriage_type)


func _on_remove_train_carriage_at_front() -> void:
	remove_carriage_at(-1)


func _on_add_train_carriage_at_back(
	train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	add_carriage_at(0, train_carriage_type)


func _on_remove_train_carriage_at_back() -> void:
	remove_carriage_at(0)


func _on_add_character_to_carriage(character_id: int, carriage_index: int) -> void:
	add_character_to_carriage(character_id, carriage_index)


func _on_remove_character(character_id: int) -> void:
	remove_character(character_id)


func _on_remove_all_characters() -> void:
	remove_all_characters()


func _on_add_cabin_to_carriage(
	start_position: Vector2, end_position: Vector2, level: int, carriage_index: int
) -> void:
	var carriage = train_layout[carriage_index]
	var start_grid_coordinates = BuildingGrid.global_position_to_grid(start_position)
	var end_grid_coordinates = BuildingGrid.global_position_to_grid(end_position)

	carriage.add_cabin(start_grid_coordinates.x, end_grid_coordinates.x, level)


func _on_remove_cabin_from_carraige(
	position: Vector2, level: int, carriage_index: int
) -> void:
	var carriage = train_layout[carriage_index]
	var grid_coordinates = BuildingGrid.global_position_to_grid(position)

	carriage.remove_cabin(grid_coordinates.x, level)


func _push_at(carriage_index: int, item: Node2D) -> void:
	# TODO: Replace with Array.insert()
	var beginning_array: Array[Node2D] = train_layout.slice(0, carriage_index)
	var end_array: Array[Node2D] = train_layout.slice(carriage_index, len(train_layout))
	var item_array: Array[Node2D] = [item]
	train_layout = beginning_array + item_array + end_array


func _on_consumption_timer_timeout() -> void:
	_train_resources.remove_resources(Globals.ResourceType.COAL, DEFAULT_COAL_CONSUMPTION)
	_consumption_timer.wait_time = randf_range(
		MIN_CONSUMPTION_WAIT_TIME, MAX_CONSUMPTION_WAIT_TIME
	)
