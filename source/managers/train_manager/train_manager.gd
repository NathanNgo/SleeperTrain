extends Node


@export var _train_carriage_scene: PackedScene
@export var _train_carriage_short_scene: PackedScene
var train_pivot: Node2D

# Index 0 will always be the back of the train. len(train_layout) - 1 will always
# be the front of the train.
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


func _organize_train() -> void:
	# We reverse the array to easily iterate from the front of the train to the back.
	var copy_train_layout = train_layout.duplicate()
	copy_train_layout.reverse()

	var initial_carriage_length = (
		copy_train_layout[0].train_carriage_length if copy_train_layout.size() > 0 else 0.0
	)
	var current_train_length = 0

	for train_carriage in copy_train_layout:
		var offset = (
			current_train_length +
			CARRIAGE_WIDTH_MULTIPLIER *
			(train_carriage.train_carriage_length - initial_carriage_length)
		)

		train_carriage.position.x = -offset
		current_train_length += train_carriage.train_carriage_length


func add_carriage_at(location: int, train_carriage_type: Globals.TrainCarriageType) -> void:
	# TODO: Do this properly. Also, rename "type"
	var train_carriage: Node2D
	if train_carriage_type == Globals.TrainCarriageType.BASIC:
		train_carriage = _train_carriage_scene.instantiate()
	elif train_carriage_type == Globals.TrainCarriageType.SHORT:
		train_carriage = _train_carriage_short_scene.instantiate()

	train_pivot.add_child(train_carriage)

	_push_at(location, train_carriage)
	_organize_train()


func remove_carriage_at(location: int) -> void:
	if location >= len(train_layout):
		return

	var train_carriage = train_layout.pop_at(location)

	train_carriage.queue_free()
	_organize_train()


func _on_add_train_carriage_at(
	location: int, train_carriage_type: Globals.TrainCarriageType
) -> void:
	add_carriage_at(location, train_carriage_type)


func _on_remove_train_carriage_at(location: int) -> void:
	remove_carriage_at(location)


func _on_add_train_carriage_at_front(train_carriage_type: Globals.TrainCarriageType) -> void:
	add_carriage_at(len(train_layout), train_carriage_type)


func _on_remove_train_carriage_at_front() -> void:
	remove_carriage_at(-1)


func _on_add_train_carriage_at_back(train_carriage_type: Globals.TrainCarriageType) -> void:
	add_carriage_at(0, train_carriage_type)


func _on_remove_train_carriage_at_back() -> void:
	remove_carriage_at(0)


func _push_at(location: int, item: Node2D) -> void:
	# TODO: Replace with Array.insert()
	var beginning_array: Array[Node2D] = train_layout.slice(0, location)
	var end_array: Array[Node2D] = train_layout.slice(location, len(train_layout))
	var item_array: Array[Node2D] = [item]
	train_layout = beginning_array + item_array + end_array
