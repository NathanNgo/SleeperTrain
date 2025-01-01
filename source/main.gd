extends Node

@export var _game_manager: Node
@export var _splash_screen_menu_manager: CanvasLayer

@onready var _splash_screen_menu: ManagedMenu = _splash_screen_menu_manager.get_menu(
	SplashScreenMenuManager.Menus.SPLASH_SCREEN_MENU
)

func _ready() -> void:
	_splash_screen_menu.new_game_pressed.connect(_on_new_game_pressed)
	_splash_screen_menu.quit_game_pressed.connect(_on_quit_game_pressed)
	_game_manager.process_mode = Node.PROCESS_MODE_DISABLED


func _on_new_game_pressed() -> void:
	_splash_screen_menu_manager.hide()
	_splash_screen_menu_manager.process_mode = Node.PROCESS_MODE_DISABLED
	_game_manager.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_quit_game_pressed() -> void:
	get_tree().quit()
