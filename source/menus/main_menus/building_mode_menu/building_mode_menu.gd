extends ManagedMenu

@export var _back_button: Button
@export var _door_button: Button
@export var _cabin_button: Button


func _ready() -> void:
	_back_button.pressed.connect(_on_back_button_pressed)
	_door_button.pressed.connect(_on_door_button_pressed)
	_cabin_button.pressed.connect(_on_cabin_button_pressed)


func _on_back_button_pressed() -> void:
	Globals.game_mode = Globals.GameModeType.NORMAL
	transition.emit(MainMenuManager.Menus.MAIN_MENU)


func _on_cabin_button_pressed() -> void:
	Globals.building_object_type = Globals.ObjectType.CABIN


func _on_door_button_pressed() -> void:
	Globals.building_object_type = Globals.ObjectType.PORTAL