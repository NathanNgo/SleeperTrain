class_name CharacterWorldRepresentation extends CharacterBody2D

signal consume_resource(resource_type: Globals.ResourceType, amount: int)

const DEFAULT_FOOD_CONSUMPTION := 5
const MAX_CONSUMPTION_WAIT_TIME := 10.0
const MIN_CONSUMPTION_WAIT_TIME := 3.0

@export var _consumption_timer: Timer

var character_data: CharacterData
var world_position: Vector2:
	set(value):
		character_data.world_position = value
		position = value
	get:
		return character_data.world_position


func _ready() -> void:
	assert(character_data != null, "character_data has not been configured")

	_consumption_timer.timeout.connect(_on_consumption_timer_timeout)


func start_character_consumption() -> void:
	_consumption_timer.wait_time = randf_range(
		MIN_CONSUMPTION_WAIT_TIME, MAX_CONSUMPTION_WAIT_TIME
	)
	_consumption_timer.start()


func stop_character_consumption() -> void:
	_consumption_timer.stop()


func _on_consumption_timer_timeout() -> void:
	consume_resource.emit(Globals.ResourceType.FOOD, DEFAULT_FOOD_CONSUMPTION)
	_consumption_timer.wait_time = randf_range(
		MIN_CONSUMPTION_WAIT_TIME, MAX_CONSUMPTION_WAIT_TIME
	)

###
# This should contain logic bespoke to a character. Walk, run, jump, etc.
#
