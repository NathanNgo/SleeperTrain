class_name CharacterWorldRepresentation extends CharacterBody2D

signal consume_resource(resource_type: Globals.ResourceType, amount: int)

enum States { IDLE, WALKING }

const DEFAULT_FOOD_CONSUMPTION := 5
const MAX_CONSUMPTION_WAIT_TIME := 10.0
const MIN_CONSUMPTION_WAIT_TIME := 3.0
const MAX_RANDOM_WALK_WAIT_TIME := 1.0
const MIN_RANDOM_WALK_WAIT_TIME := 1.0
const AXIS_NEUTRAL := 0
const BOOLEAN_DIVISOR := 2
# Stringed Enum's aren't a thing yet :(
const ANIMATIONS = {
	IDLE = "idle",
	WALK = "walk",
}

@export var _consumption_timer: Timer
@export var _random_walk_timer: Timer
@export var _animation_player: AnimationPlayer
@export var _sprites: Sprite2D
@export var state := States.IDLE
@export var move_speed := 150

var character_data: CharacterData
var moving: bool
var move_direction: Vector2


func _ready() -> void:
	if not character_data:
		push_error(Error.ERR_UNCONFIGURED)

	_consumption_timer.timeout.connect(_on_consumption_timer_timeout)
	_random_walk_timer.timeout.connect(_on_random_walk_timer_timeout)
	_random_walk_timer.start()


func _physics_process(_delta) -> void:
	match state:
		States.IDLE:
			if moving:
				state = States.WALKING
				_move()
			else:
				_idle()

		States.WALKING:
			if not moving:
				state = States.IDLE
				_idle()
			else:
				_move()


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


func _on_random_walk_timer_timeout() -> void:
	_random_walk_timer.wait_time = randf_range(
		MIN_RANDOM_WALK_WAIT_TIME, MAX_RANDOM_WALK_WAIT_TIME
	)
	moving = randi() % BOOLEAN_DIVISOR == 0
	_set_random_direction_vector()


func _set_random_direction_vector() -> void:
	var left = -1
	var right = 1
	move_direction = Vector2([left, right].pick_random(), 0)


func _idle() -> void:
	_animation_player.play(ANIMATIONS.IDLE)


func _move() -> void:
	_animation_player.play(ANIMATIONS.WALK)

	if move_direction.x > AXIS_NEUTRAL:
		_sprites.scale.x = abs(_sprites.scale.x)
	elif move_direction.x < AXIS_NEUTRAL:
		_sprites.scale.x = -abs(_sprites.scale.x)

	velocity = move_direction.normalized() * move_speed
	move_and_slide()

	character_data.global_world_position = to_global(position)
