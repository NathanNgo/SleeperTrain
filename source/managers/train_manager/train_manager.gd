extends Node2D


@export var _train_carriage_scene: PackedScene
@export var _train_carriage_short_scene: PackedScene
@export var _train: Node2D

# Index 0 will always be the back of the train. len(train_layout) - 1 will always be the front of the train.
var train_layout: Array[Node2D] = []


const DEFAULT_CARRIAGE_AMOUNT := 1
const CARRIAGE_WIDTH_MULTIPLIER := 0.5


func _ready() -> void:
	SignalBus.add_train_carriage_at.connect(_on_add_train_carriage_at)
	SignalBus.remove_train_carriage_at.connect(_on_remove_train_carriage_at)
	SignalBus.add_train_carriage_at_front.connect(_on_add_train_carriage_at_front)
	SignalBus.remove_train_carriage_at_front.connect(_on_remove_train_carriage_at_front)
	SignalBus.add_train_carriage_at_back.connect(_on_add_train_carriage_at_back)
	SignalBus.remove_train_carriage_at_back.connect(_on_remove_train_carriage_at_back)

	if len(train_layout) < DEFAULT_CARRIAGE_AMOUNT:
		_add_carriage_at(0, "basic")


func _organize_train() -> void:
	# We reverse the array to easily iterate from the front of the train to the back.
	var copy_train_layout = train_layout.duplicate()
	copy_train_layout.reverse()

	var initial_carriage_length = copy_train_layout[0].train_carriage_length if copy_train_layout.size() > 0 else 0.0
	var current_train_length = 0

	for train_carriage in copy_train_layout:
		var offset = current_train_length + CARRIAGE_WIDTH_MULTIPLIER * (train_carriage.train_carriage_length - initial_carriage_length)

		train_carriage.position.x = -offset
		current_train_length += train_carriage.train_carriage_length


func _add_carriage_at(location: int, type: String) -> void:
	# TODO: Do this properly. Also, rename "type"
	var train_carriage: Node2D
	if type == "basic":
		train_carriage = _train_carriage_scene.instantiate()
	elif type == "short":
		train_carriage = _train_carriage_short_scene.instantiate()

	_train.add_child(train_carriage)

	_push_at(location, train_carriage)
	_organize_train()


func _remove_carriage_at(location: int) -> void:
	if location >= len(train_layout):
		return

	var train_carriage = train_layout.pop_at(location)

	train_carriage.queue_free()
	_organize_train()


func _on_add_train_carriage_at(location: int, type: String) -> void:
	_add_carriage_at(location, type)


func _on_remove_train_carriage_at(location: int) -> void:
	_remove_carriage_at(location)


func _on_add_train_carriage_at_front(type: String) -> void:
	_add_carriage_at(len(train_layout), type)


func _on_remove_train_carriage_at_front() -> void:
	_remove_carriage_at(-1)


func _on_add_train_carriage_at_back(type: String) -> void:
	_add_carriage_at(0, type)


func _on_remove_train_carriage_at_back() -> void:
	_remove_carriage_at(0)


func _push_at(location: int, item: Node2D) -> void:
	# TODO: Replace with Array.insert()
	var beginning_array: Array[Node2D] = train_layout.slice(0, location)
	var end_array: Array[Node2D] = train_layout.slice(location, len(train_layout))
	var item_array: Array[Node2D] = [item]
	train_layout = beginning_array + item_array + end_array