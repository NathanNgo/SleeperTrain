extends CharacterBody2D

@export var conductor_sprite: Sprite2D
@export var conductor_animation: AnimationPlayer
@export var speed := 250

var player_character := true
var layer := Globals.Layers.CARRIAGE


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
		move_conductor("stop")
	elif Input.is_action_pressed("move_right"):
		move_conductor("right")
	elif Input.is_action_pressed("move_left"):
		move_conductor("left")
	else:
		move_conductor("stop")


func move_conductor(direction: String) -> void:
	if direction == "right":
		conductor_animation.play("walk_right")
		velocity = Vector2(1, 0).normalized() * speed
	if direction == "left":
		conductor_animation.play("walk_left")
		velocity = Vector2(-1, 0).normalized() * speed
	if direction == "stop":
		conductor_animation.stop()
		conductor_sprite.frame = 0
		velocity = Vector2(0, 0).normalized() * speed

	move_and_slide()
