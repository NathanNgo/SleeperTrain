extends Node2D

@export var _camera: Camera2D
@export var level: Node2D
@export var _train_path: Path2D
@export var _train_path_follow: PathFollow2D
@export var _train: Sprite2D

const ZOOM_SCALING_INCREMENT := 2
const MAX_ZOOM_SCALE := 4

var inputs = {
	ZOOM_IN = "zoom_in",
	ZOOM_OUT = "zoom_out",
	LEFT_MOUSE_CLICK = "left_mouse_click"
}
var dragging = false
var current_train_path: Array[Vector2]
var total_travel_time_seconds: float
var current_travel_time_seconds: float
var train_moving := false


func _ready() -> void:
	_train.hide()


func _process(delta: float) -> void:
	if not train_moving:
		_train.hide()
		return

	current_travel_time_seconds += delta

	var ratio_travelled: float = current_travel_time_seconds / total_travel_time_seconds
	
	if ratio_travelled >= 1.0:
		current_travel_time_seconds = 0.0
		train_moving = false
		return

	_train_path_follow.progress_ratio = ratio_travelled


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(inputs.ZOOM_IN):
		if _camera.zoom == Vector2.ONE * MAX_ZOOM_SCALE:
			return
		_camera.zoom *= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(inputs.ZOOM_OUT):
		if _camera.zoom == Vector2.ONE:
			return
		_camera.zoom /= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(inputs.LEFT_MOUSE_CLICK):
		dragging = true
	
	if event.is_action_released(inputs.LEFT_MOUSE_CLICK):
		dragging = false

	if dragging and event is InputEventMouseMotion:
		_move_camera(event.relative)


func _move_camera(relative_move_amount: Vector2) -> void:
	_camera.position -= relative_move_amount / _camera.zoom.x


func move_train(path: Array[Vector2], travel_time: float) -> void:
	_train_path.curve.clear_points()
	
	for point in path:
		_train_path.curve.add_point(point)

	current_travel_time_seconds = 0
	current_train_path = path
	total_travel_time_seconds = travel_time
	train_moving = true
	_train.show()
