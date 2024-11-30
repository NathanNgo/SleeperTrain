extends Node

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
var total_carriages = 0


func setup(carriage_type: Globals.TrainCarriageType) -> void:
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

	_consumption_timer.timeout.connect(_on_consumption_timer_timeout)


func _organize_train() -> void:
	# We reverse the array to easily iterate from the front of the train to the back.
	var copy_train_layout := train_layout.duplicate()
	copy_train_layout.reverse()

	var initial_carriage_length: float = (
		copy_train_layout[0].train_carriage_length
		if copy_train_layout.size() > 0
		else 0.0
	)
	var current_train_length := 0.0

	for train_carriage in copy_train_layout:
		var offset = (
			current_train_length
			+ (
				CARRIAGE_WIDTH_MULTIPLIER
				* (train_carriage.train_carriage_length - initial_carriage_length)
			)
		)

		train_carriage.position.x = -offset
		current_train_length += train_carriage.train_carriage_length


func get_carriage(carriage_id: int) -> Node2D:
	# TODO:
	# Either maintain a mapping of chatacter_id --> carriage object, or
	# do this search every time. For now this is probably fine.
	# This gets slower the more carriages we have.
	var filter_function = func(carriage_lambda):
		return carriage_lambda.carriage_id == carriage_id
	var carriage = train_layout.filter(filter_function)[0]

	return carriage


func add_carriage_at(
	carriage_index: int, train_carriage_type: Globals.TrainCarriageType
) -> void:
	var train_carriage: Node2D

	match train_carriage_type:
		Globals.TrainCarriageType.BASIC:
			train_carriage = _train_carriage_scene.instantiate()
		Globals.TrainCarriageType.SHORT:
			train_carriage = _train_carriage_short_scene.instantiate()

	total_carriages += 1
	train_carriage.carriage_id = total_carriages

	_push_at(carriage_index, train_carriage)
	carriage_added.emit(train_carriage)
	_organize_train()


func remove_carriage_at(carriage_index: int) -> void:
	if carriage_index >= len(train_layout):
		return

	# TODO:
	# We should probably maintain a reverse mapping of carriage_id to character_id.
	# That will mean we don't have to check every character to see if they exist
	# on the carriage we're trying to delete.
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
	carriage_index: int, train_carriage_type: Globals.TrainCarriageType
) -> void:
	add_carriage_at(carriage_index, train_carriage_type)


func _on_remove_train_carriage_at(carriage_index: int) -> void:
	remove_carriage_at(carriage_index)


func _on_add_train_carriage_at_front(
	train_carriage_type: Globals.TrainCarriageType
) -> void:
	add_carriage_at(len(train_layout), train_carriage_type)


func _on_remove_train_carriage_at_front() -> void:
	remove_carriage_at(-1)


func _on_add_train_carriage_at_back(
	train_carriage_type: Globals.TrainCarriageType
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
