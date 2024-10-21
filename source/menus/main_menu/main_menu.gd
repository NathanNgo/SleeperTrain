extends Control


func _ready() -> void:
	$Button.pressed.connect(_on_button_pressed)


func _on_button_pressed():
	MenuManager.transition(MenuManager.Menus.OVERWORLD_NAVIGATION)
