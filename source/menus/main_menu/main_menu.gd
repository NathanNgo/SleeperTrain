extends ManagedMenu


func _ready() -> void:
	# TODO: Do this properly.
	$Button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	transition.emit(Globals.Menus.OVERWORLD_NAVIGATION_MENU)
