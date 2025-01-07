extends Portal

const DEFAULT_TRANSITION_LAYER = Globals.Layers.CABIN_MIDDLE

@export var transition_layer_in: Globals.Layers = Globals.Layers.CABIN_MIDDLE
@export var transition_layer_out: Globals.Layers = Globals.Layers.CARRIAGE_MIDDLE
@export
var transition_collision_layer: Globals.CollisionLayers = Globals.CollisionLayers.CABINS


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter_portal"):
		for body in _bodies:
			if "player_character" not in body or not body.player_character:
				continue

			transition(body)


func transition(body: Node2D) -> void:
	if body.z_index == transition_layer_in:
		_transition_out(body, transition_layer_out, transition_collision_layer)
		player_body_transitioned_out.emit()
	elif body.z_index == transition_layer_out:
		_transition_in(body, transition_layer_in, transition_collision_layer)
		player_body_transitioned_in.emit()
