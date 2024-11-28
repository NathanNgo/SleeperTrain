extends CharacterBody2D

@export var conductor_sprite: Sprite2D
@export var conductor_animation: AnimationPlayer


func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed("pan_right") and not Input.is_action_pressed("pan_left")) or (Input.is_action_just_released("pan_left") and Input.is_action_pressed("pan_right")):
		move_conductor("right")
	if (Input.is_action_just_pressed("pan_left") and not Input.is_action_pressed("pan_right")) or (Input.is_action_just_released("pan_right") and Input.is_action_pressed("pan_left")):
		move_conductor("left")
	if (Input.is_action_pressed("pan_left") and Input.is_action_pressed("pan_right")) or (Input.is_action_just_released("pan_left") and not Input.is_action_pressed("pan_right")) or (Input.is_action_just_released("pan_right") and not Input.is_action_pressed("pan_left")):
		move_conductor("stop")


func move_conductor(direction: String) -> void:
	if direction == "right":
		conductor_animation.play("walk_right")
	if direction == "left":
		conductor_animation.play("walk_left")
	if direction == "stop":
		conductor_animation.stop()
		conductor_sprite.frame = 0
