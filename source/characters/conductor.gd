extends CharacterBody2D


func _physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("pan_right"):
        if not Input.is_action_pressed("pan_left"):
            conductor_go("right")
        else:
            conductor_go("stop")
    if Input.is_action_just_released("pan_right"):
        if not Input.is_action_pressed("pan_left"):
            conductor_go("stop")
        else:
            conductor_go("left")
    if Input.is_action_just_pressed("pan_left"):
        if not Input.is_action_pressed("pan_right"):
            conductor_go("left")
        else:
            conductor_go("stop")
    if Input.is_action_just_released("pan_left"):
        if not Input.is_action_pressed("pan_right"):
            conductor_go("stop")
        else:
            conductor_go("right")


func conductor_go(direction: String) -> void:
    if direction == "right":
        $AnimationPlayer.play("walk_right")
    if direction == "left":
        $AnimationPlayer.play("walk_left")
    if direction == "stop":
        $AnimationPlayer.stop()
        $ConductorSprite.frame = 0
