class_name SplashScreenMenuManager extends MenuManager

enum Menus {
	SPLASH_SCREEN_MENU,
}

const DEFAULT_MENU = SplashScreenMenuManager.Menus.SPLASH_SCREEN_MENU
const DEFAULT_ESCAPE_ACTION = "escape"

@export var _splash_screen_menu: ManagedMenu:
	set(menu):
		menus[SplashScreenMenuManager.Menus.SPLASH_SCREEN_MENU] = menu


func _ready() -> void:
	super._ready()
	transition(DEFAULT_MENU)


func transition(menu: SplashScreenMenuManager.Menus) -> void:
	super(menu)


func pin_menu(menu: SplashScreenMenuManager.Menus) -> void:
	super(menu)


func get_menu(menu: SplashScreenMenuManager.Menus) -> ManagedMenu:
	return super(menu)


func _on_transition(menu: SplashScreenMenuManager.Menus) -> void:
	super(menu)
