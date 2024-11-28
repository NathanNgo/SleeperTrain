extends CharacterBody2D

@export var conductor_sprite: Sprite2D
@export var conductor_animation: AnimationPlayer


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("pan_right") and Input.is_action_pressed("pan_left"):
		move_conductor("stop")
	elif Input.is_action_pressed("pan_right"):
		move_conductor("right")
	elif Input.is_action_pressed("pan_left"):
		move_conductor("left")
	else:
		move_conductor("stop")


func move_conductor(direction: String) -> void:
	if direction == "right":
		conductor_animation.play("walk_right")
	if direction == "left":
		conductor_animation.play("walk_left")
	if direction == "stop":
		conductor_animation.stop()
		conductor_sprite.frame = 0
