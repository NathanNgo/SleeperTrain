extends CharacterBody2D


func _physics_process(_delta: float) -> void:
	#move_conductor("right")
	#else:
	#move_conductor("stop")
	#if Input.is_action_just_released("pan_right"):
	#if not Input.is_action_pressed("pan_left"):
	#move_conductor("stop")
	#else:
	#move_conductor("left")
	#if Input.is_action_just_pressed("pan_left"):
	#if not Input.is_action_pressed("pan_right"):
	#move_conductor("left")
	#else:
	#move_conductor("stop")
	#if Input.is_action_just_released("pan_left"):
	#if not Input.is_action_pressed("pan_right"):
	#move_conductor("stop")
	#else:
	#move_conductor("right")


func move_conductor(direction: String) -> void:
	if direction == "right":
		$AnimationPlayer.play("walk_right")
	if direction == "left":
		$AnimationPlayer.play("walk_left")
	if direction == "stop":
		$AnimationPlayer.stop()
		$ConductorSprite.frame = 0
