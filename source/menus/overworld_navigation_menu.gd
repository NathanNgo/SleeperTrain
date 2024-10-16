extends Control


const zoom_scaling_increment = 0.001

@export var _map: Sprite2D


func _process(_delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		_map.scale.x += zoom_scaling_increment
		_map.scale.y += zoom_scaling_increment

	if Input.is_action_pressed("ui_left"):
		_map.scale.x -= zoom_scaling_increment
		_map.scale.y -= zoom_scaling_increment