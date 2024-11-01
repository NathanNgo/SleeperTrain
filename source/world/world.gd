extends Node2D


@export var _background: ParallaxBackground


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		$Camera2D.position.x -= 10
	if Input.is_action_pressed("ui_right"):
		$Camera2D.position.x += 10
	$BackgroundPivot.position = $Camera2D.position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		$Camera2D.zoom = Vector2(2, 2)
		$BackgroundPivot.scale = Vector2(0.5, 0.5)
		$Camera2D.position.y += 160
		_background.show_near_layers(1.5)
	if event.is_action_pressed("zoom_out"):
		$Camera2D.zoom = Vector2(1, 1)
		$BackgroundPivot.scale = Vector2(1, 1)
		$Camera2D.position.y -= 160
		_background.hide_near_layers(1.5)