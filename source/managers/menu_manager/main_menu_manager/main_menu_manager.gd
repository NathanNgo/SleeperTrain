class_name MainMenuManager extends MenuManager

const DEFAULT_MENU = Menus.MAIN_MENU
const DEFAULT_ESCAPE_ACTION = "escape"

enum Menus {
	MAIN_MENU,
	OVERWORLD_NAVIGATION_MENU,
	HOW_TO_PLAY_MENU,
	TRAIN_MANAGEMENT_MENU,
	PASSENGER_MANAGEMENT_MENU,
	RESOURCE_MANAGEMENT_MENU
}

@export var _main_menu: ManagedMenu:
	set(menu):
		menus[MainMenuManager.Menus.MAIN_MENU] = menu

@export var _overworld_navigation_menu: ManagedMenu:
	set(menu):
		menus[MainMenuManager.Menus.OVERWORLD_NAVIGATION_MENU] = menu

@export var _how_to_play_menu: ManagedMenu:
	set(menu):
		menus[MainMenuManager.Menus.HOW_TO_PLAY_MENU] = menu

@export var _train_management_menu: ManagedMenu:
	set(menu):
		menus[MainMenuManager.Menus.TRAIN_MANAGEMENT_MENU] = menu

@export var _passenger_management_menu: ManagedMenu:
	set(menu):
		menus[MainMenuManager.Menus.PASSENGER_MANAGEMENT_MENU] = menu

@export var _resource_management_menu: ManagedMenu:
	set(menu):
		menus[MainMenuManager.Menus.RESOURCE_MANAGEMENT_MENU] = menu


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


func transition(menu: MainMenuManager.Menus) -> void:
	super(menu)


func pin_menu(menu: MainMenuManager.Menus) -> void:
	super(menu)


func get_menu(menu: MainMenuManager.Menus) -> ManagedMenu:
	return super(menu)


func _on_transition(menu: MainMenuManager.Menus) -> void:
	super(menu)
