class_name Portal extends Node2D

signal player_body_transitioned_in
signal player_body_transitioned_out

@export var _portal_area: Area2D
@export var _portal_shape: CollisionShape2D

var portal_id: int
var height: float
var length: float
var shape_grid_positions: Dictionary
var _currently_selected := false
var _bodies: Array[Node2D] = []


func setup(centered_global_position: Vector2) -> void:
	global_position = centered_global_position
	position -= BuildingGrid.get_shift_for_grid_alignment(
		centered_global_position, length, height
	)
	shape_grid_positions = BuildingGrid.get_grid_positions_for_shape(
		_portal_shape.global_position, height, length
	)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if Globals.game_mode != Globals.GameModeType.DEMOLISHING:
			return

		if not _currently_selected:
			return

		remove()


func remove() -> void:
	queue_free()


func _ready() -> void:
	portal_id = TrainRegistry.register_portal(self)
	z_index = Globals.Layers.CARRIAGE

	_portal_area.body_entered.connect(_on_body_entered)
	_portal_area.body_exited.connect(_on_body_exited)
	_portal_area.mouse_entered.connect(_on_mouse_entered)
	_portal_area.mouse_exited.connect(_on_mouse_exited)

	length = _portal_shape.shape.get_rect().size.x
	height = _portal_shape.shape.get_rect().size.y
	# setup(BuildingGrid.center_global_position(global_position))


func _exit_tree() -> void:
	TrainRegistry.unregister_portal(portal_id)


func _transition(body: Node2D, layer: Globals.Layers) -> void:
	if body not in _bodies:
		return

	body.z_index = layer
	body.layer = layer
	body.collision_mask = layer


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false


func _on_body_entered(body: Node2D) -> void:
	_bodies.append(body)


func _on_body_exited(body: Node2D) -> void:
	_bodies.erase(body)
