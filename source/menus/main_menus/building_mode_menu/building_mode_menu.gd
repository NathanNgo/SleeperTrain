extends ManagedMenu

@export var _back_button: Button


func _ready() -> void:
	_back_button.pressed.connect(_on_back_button_pressed)


func _on_back_button_pressed() -> void:
	Globals.game_mode = Globals.GameModeType.NORMAL
	transition.emit(MainMenuManager.Menus.MAIN_MENU)
