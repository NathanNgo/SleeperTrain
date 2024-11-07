extends ManagedMenu


@export var _map_button: Button
@export var _how_to_play_button: Button


func _ready() -> void:
	_map_button.pressed.connect(_on_map_button_pressed)
	_how_to_play_button.pressed.connect(_on_how_to_play_button_pressed)


func _on_map_button_pressed():
	transition.emit(Globals.Menus.OVERWORLD_NAVIGATION_MENU)


func _on_how_to_play_button_pressed():
	transition.emit(Globals.Menus.HOW_TO_PLAY_MENU)
