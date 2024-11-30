extends MenuManager

const DEFAULT_MENU = Globals.MainMenus.MAIN_MENU
const DEFAULT_ESCAPE_ACTION = "escape"

@export var _main_menu: ManagedMenu:
	set(menu):
		menus[Globals.MainMenus.MAIN_MENU] = menu

@export var _overworld_navigation_menu: ManagedMenu:
	set(menu):
		menus[Globals.MainMenus.OVERWORLD_NAVIGATION_MENU] = menu

@export var _how_to_play_menu: ManagedMenu:
	set(menu):
		menus[Globals.MainMenus.HOW_TO_PLAY_MENU] = menu

@export var _train_management_menu: ManagedMenu:
	set(menu):
		menus[Globals.MainMenus.TRAIN_MANAGEMENT_MENU] = menu

@export var _passenger_management_menu: ManagedMenu:
	set(menu):
		menus[Globals.MainMenus.PASSENGER_MANAGEMENT_MENU] = menu

@export var _resource_management_menu: ManagedMenu:
	set(menu):
		menus[Globals.MainMenus.RESOURCE_MANAGEMENT_MENU] = menu


func _ready() -> void:
	super._ready()
	transition(DEFAULT_MENU)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(DEFAULT_ESCAPE_ACTION):
		if menu_open:
			hide_all()
			menu_open = false
		else:
			transition(DEFAULT_MENU)


func transition(menu: Globals.MainMenus) -> void:
	super(menu)


func get_menu(menu: Globals.MainMenus) -> ManagedMenu:
	return super(menu)


func _on_transition(menu: Globals.MainMenus) -> void:
	super(menu)
