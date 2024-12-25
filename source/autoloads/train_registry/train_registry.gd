extends Node

signal carriage_added(carriage: Node2D)
signal character_added

const DEFAULT_CARRIAGE_CAPACITY := 3
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
var characters_on_train: Array[int] = []
var max_train_capacity := 0

# We maintain a carriage registry as a convenience, so we don't have to search train_layout
# every time.
var carriage_registry = {}
var total_carriages = 0

var cabin_registry = {}
var total_cabins = 0

var world_object_registry = {}
var total_world_objects = 0

var portal_registry = {}
var total_portals = 0


func setup(carriage_type: TrainCarriage.TrainCarriageType) -> void:
	add_carriage_at(0, carriage_type)


func _ready() -> void:
	_consumption_timer.timeout.connect(_on_consumption_timer_timeout)


func register_carriage(carriage: TrainCarriage) -> int:
	total_carriages += 1
	carriage_registry[total_carriages] = carriage
	return total_carriages


func unregister_carriage(carriage_id: int) -> void:
	carriage_registry.erase(carriage_id)


func register_cabin(cabin: TrainCabin) -> int:
	total_cabins += 1
	cabin_registry[total_cabins] = cabin
	return total_cabins


func unregister_cabin(cabin_id: int) -> void:
	cabin_registry.erase(cabin_id)


func register_world_object(world_object: WorldObject) -> int:
	total_world_objects += 1
	world_object_registry[total_world_objects] = world_object
	return total_world_objects


func unregister_world_object(world_object_id: int) -> void:
	world_object_registry.erase(world_object_id)


func register_portal(portal: Portal) -> int:
	total_portals += 1
	portal_registry[total_portals] = portal

	portal.player_body_transitioned_in.connect(
		_on_player_body_transitioned_in.bind(portal)
	)
	portal.player_body_transitioned_out.connect(
		_on_player_body_transitioned_out.bind(portal)
	)
	return total_portals


func unregister_portal(portal_id: int) -> void:
	portal_registry.erase(portal_id)


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


func add_carriage_at(
	carriage_index: int, train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	var train_carriage: Node2D

	match train_carriage_type:
		TrainCarriage.TrainCarriageType.BASIC:
			train_carriage = _train_carriage_scene.instantiate()
		TrainCarriage.TrainCarriageType.SHORT:
			train_carriage = _train_carriage_short_scene.instantiate()

	carriage_added.emit(train_carriage)

	if train_carriage.carriage_id not in carriage_registry:
		return

	_push_at(carriage_index, train_carriage)
	# We need the train carriage to be added to the scene tree before we organise the
	# train. Otherwise, _ready() doesn't get run, and none of the member variables we
	# rely on to calculate the carriage offsets are initialized.
	_organize_train()
	max_train_capacity += DEFAULT_CARRIAGE_CAPACITY


func remove_carriage_at(carriage_index: int) -> void:
	if carriage_index >= len(train_layout):
		return

	var train_carriage = train_layout.pop_at(carriage_index)

	carriage_registry.erase(train_carriage.carriage_id)
	train_carriage.queue_free()
	_organize_train()


func get_random_carriage() -> Node2D:
	return train_layout[randi_range(0, train_layout.size() - 1)]


func get_carriage(carriage_id: int) -> Node2D:
	return carriage_registry[carriage_id]


func get_random_cabin() -> Node2D:
	var cabin_ids = cabin_registry.keys()
	return cabin_ids[randi_range(0, cabin_ids.size() - 1)]


func get_cabin(cabin_id: int) -> Node2D:
	return cabin_registry[cabin_id]


func add_character_to_train(character_id: int) -> void:
	if characters_on_train.size() >= max_train_capacity:
		# TODO: Display to player
		print("Train is full")
		return

	characters_on_train.append(character_id)
	character_added.emit()


func add_character_to_cabin(character_id: int, cabin_id: int) -> void:
	var cabin = cabin_registry[cabin_id]
	var character_data = CharacterRegistry.get_character_data(character_id)

	if character_id not in characters_on_train:
		# TODO: Display to player
		print("Character is not on the train")
		return

	if cabin.assigned_characters.size() >= cabin.max_cabin_capacity:
		# TODO: Display to player
		print("Cabin is full")
		return

	cabin.assigned_characters.append(character_id)
	character_data.assigned_cabin_id = cabin_id


func remove_character_from_train(character_id: int) -> void:
	if character_id not in characters_on_train:
		return

	remove_character_from_cabin(character_id)
	characters_on_train.erase(character_id)


func remove_character_from_cabin(character_id: int) -> void:
	var character_data = CharacterRegistry.get_character_data(character_id)

	if character_id not in characters_on_train:
		return

	if not character_data.assigned_cabin_id:
		return

	cabin_registry[character_data.assigned_cabin_id].assigned_characters.erase(
		character_id
	)
	character_data.assigned_cabin_id = null


func remove_all_characters() -> void:
	characters_on_train.clear()

	for cabin_id in cabin_registry:
		var cabin = cabin_registry[cabin_id]
		cabin.assigned_characters.clear()


func start_train_consumption() -> void:
	_consumption_timer.wait_time = randf_range(
		MIN_CONSUMPTION_WAIT_TIME, MAX_CONSUMPTION_WAIT_TIME
	)
	_consumption_timer.start()


func stop_train_consumption() -> void:
	_consumption_timer.stop()


func add_train_carriage_at_front(
	train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	add_carriage_at(len(train_layout), train_carriage_type)


func remove_train_carriage_at_front() -> void:
	remove_carriage_at(-1)


func add_train_carriage_at_back(
	train_carriage_type: TrainCarriage.TrainCarriageType
) -> void:
	add_carriage_at(0, train_carriage_type)


func remove_train_carriage_at_back() -> void:
	remove_carriage_at(0)


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


func _on_player_body_transitioned_in(portal: Portal) -> void:
	var portal_grid_postion = BuildingGrid.global_position_to_grid(portal.global_position)
	for cabin_id in cabin_registry:
		var cabin = cabin_registry[cabin_id]

		if cabin.grid_position_in_cabin(portal_grid_postion):
			cabin.hide_foreground()


func _on_player_body_transitioned_out(portal: Portal) -> void:
	var portal_grid_postion = BuildingGrid.global_position_to_grid(portal.global_position)
	for cabin_id in cabin_registry:
		var cabin = cabin_registry[cabin_id]

		if cabin.grid_position_in_cabin(portal_grid_postion):
			cabin.show_foreground()
