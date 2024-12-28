extends Portal

const DEFAULT_TRANSITION_LAYER = Globals.Layers.CABIN

@export var transition_layer_in: Globals.Layers = Globals.Layers.CABIN
@export var transition_layer_out: Globals.Layers = Globals.Layers.CARRIAGE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("enter_poral"):
		for body in _bodies:
			if "player_character" not in body or not body.player_character:
				continue

			transition(body)


func transition(body: Node2D) -> void:
	if body.layer == transition_layer_in:
		_transition(body, transition_layer_out)
		player_body_transitioned_out.emit()
	elif body.layer == transition_layer_out:
		_transition(body, transition_layer_in)
		player_body_transitioned_in.emit()
