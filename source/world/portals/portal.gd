class_name Portal extends Node2D

signal player_body_transitioned_in
signal player_body_transitioned_out

@export var _portal_area: Area2D

var _currently_selected := false
var portal_id: int
var _bodies: Array[Node2D] = []


func setup(centered_global_position: Vector2) -> void:
	position = to_local(centered_global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse_click"):
		if Globals.game_mode != Globals.GameModeType.DEMOLISHING_CARRIAGE_LAYER:
			return

		if not _currently_selected:
			return

		remove()


func remove() -> void:
	TrainRegistry.unregister_portal(portal_id)
	queue_free()


func _ready() -> void:
	portal_id = TrainRegistry.register_portal(self)
	z_index = Globals.Layers.CARRIAGE

	_portal_area.body_entered.connect(_on_body_entered)
	_portal_area.body_exited.connect(_on_body_exited)
	_portal_area.mouse_entered.connect(_on_mouse_entered)
	_portal_area.mouse_exited.connect(_on_mouse_exited)


func _transition(body: Node2D, layer: Globals.Layers) -> void:
	if body not in _bodies:
		return

	body.z_index = layer
	body.layer = layer


func _on_mouse_entered() -> void:
	_currently_selected = true


func _on_mouse_exited() -> void:
	_currently_selected = false


func _on_body_entered(body: Node2D) -> void:
	_bodies.append(body)


func _on_body_exited(body: Node2D) -> void:
	_bodies.erase(body)
