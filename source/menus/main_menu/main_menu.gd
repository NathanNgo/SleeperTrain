extends ManagedMenu

@export var _map_button: Button
@export var _how_to_play_button: Button
@export var _train_management_button: Button
@export var _passenger_management_button: Button
@export var _resource_management_menu: Button


func _ready() -> void:
	_map_button.pressed.connect(_on_map_button_pressed)
	_how_to_play_button.pressed.connect(_on_how_to_play_button_pressed)
	_train_management_button.pressed.connect(_on_train_management_button_pressed)
	_passenger_management_button.pressed.connect(_on_passenger_management_button_pressed)
	_resource_management_menu.pressed.connect(_on_resource_management_button_pressed)


func enable_town_buttons() -> void:
	_train_management_button.disabled = false
	_passenger_management_button.disabled = false
	_resource_management_menu.disabled = false


func disable_town_buttons() -> void:
	_train_management_button.disabled = true
	_passenger_management_button.disabled = true
	_resource_management_menu.disabled = true


func _on_map_button_pressed() -> void:
	transition.emit(Globals.Menus.OVERWORLD_NAVIGATION_MENU)


func _on_how_to_play_button_pressed() -> void:
	transition.emit(Globals.Menus.HOW_TO_PLAY_MENU)


func _on_train_management_button_pressed() -> void:
	transition.emit(Globals.Menus.TRAIN_MANAGEMENT_MENU)


func _on_passenger_management_button_pressed() -> void:
	transition.emit(Globals.Menus.PASSENGER_MANAGEMENT_MENU)


func _on_resource_management_button_pressed() -> void:
	transition.emit(Globals.Menus.RESOURCE_MANAGEMENT_MENU)
