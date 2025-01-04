extends ManagedMenu

signal new_game_pressed
signal quit_game_pressed

@export var _new_game_button: Button
@export var _quit_button: Button


func _ready() -> void:
	_new_game_button.pressed.connect(_on_new_game_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)


func _on_new_game_button_pressed() -> void:
	new_game_pressed.emit()


func _on_quit_button_pressed() -> void:
	quit_game_pressed.emit()
