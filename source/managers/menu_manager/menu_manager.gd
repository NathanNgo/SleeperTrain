extends CanvasLayer

@export var _main_menu: ManagedMenu:
	set(menu):
		menus[Globals.Menus.MAIN_MENU] = menu

@export var _overworld_navigation_menu: ManagedMenu:
	set(menu):
		menus[Globals.Menus.OVERWORLD_NAVIGATION_MENU] = menu

var menus = {}
const default_menu = Globals.Menus.MAIN_MENU


func _ready() -> void:
	_setup_all()
	_hide_all()
	transition(default_menu)


func transition(menu: Globals.Menus) -> void:
	_hide_all()
	menus[menu].show()


func get_menu(menu: Globals.Menus) -> ManagedMenu:
	return menus[menu]


func _setup_all() -> void:
	for key in menus:
		menus[key].transition.connect(_on_transition)


func _hide_all():
	for key in menus:
		menus[key].hide()


func _on_transition(menu: Globals.Menus) -> void:
	transition(menu)