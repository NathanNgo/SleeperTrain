extends Node2D

signal train_arrived

@export var _camera: Camera2D
@export var level: Node2D
@export var _train_path: Path2D
@export var _train_path_follow: PathFollow2D
@export var _train: Sprite2D

const ZOOM_SCALING_INCREMENT := 2
const MAX_ZOOM_SCALE := 4

var _train_moving := false
var _inputs = {
	ZOOM_IN = "zoom_in",
	ZOOM_OUT = "zoom_out",
	LEFT_MOUSE_CLICK = "left_mouse_click"
}
var _dragging = false
var _current_train_path: Array[Vector2]
var _total_travel_time_seconds: float
var _current_travel_time_seconds: float


func _ready() -> void:
	_train.hide()


func _process(delta: float) -> void:
	if not _train_moving:
		_train.hide()
		return

	_current_travel_time_seconds += delta

	var ratio_travelled: float = _current_travel_time_seconds / _total_travel_time_seconds
	
	if ratio_travelled >= 1.0:
		_current_travel_time_seconds = 0.0
		_train_moving = false
		train_arrived.emit()
		return

	_train_path_follow.progress_ratio = ratio_travelled


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(_inputs.ZOOM_IN):
		if _camera.zoom == Vector2.ONE * MAX_ZOOM_SCALE:
			return
		_camera.zoom *= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(_inputs.ZOOM_OUT):
		if _camera.zoom == Vector2.ONE:
			return
		_camera.zoom /= Vector2.ONE * ZOOM_SCALING_INCREMENT

	if event.is_action_pressed(_inputs.LEFT_MOUSE_CLICK):
		_dragging = true
	
	if event.is_action_released(_inputs.LEFT_MOUSE_CLICK):
		_dragging = false

	if _dragging and event is InputEventMouseMotion:
		_move_camera(event.relative)


func _move_camera(relative_move_amount: Vector2) -> void:
	_camera.position -= relative_move_amount / _camera.zoom.x


func move_train(path: Array[Vector2], travel_time: float) -> void:
	_train_path.curve.clear_points()
	
	for point in path:
		_train_path.curve.add_point(point)

	_current_travel_time_seconds = 0
	_current_train_path = path
	_total_travel_time_seconds = travel_time
	_train_moving = true
	_train.show()
