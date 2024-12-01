extends MenuManager

const DEFAULT_MENU = Globals.GUIMenus.RESOURCE_GUI_MENU

@export var _resource_gui_menu: ManagedMenu:
	set(menu):
		menus[Globals.GUIMenus.RESOURCE_GUI_MENU] = menu


func _ready() -> void:
	super._ready()
	transition(DEFAULT_MENU)


func transition(menu: Globals.GUIMenus) -> void:
	super(menu)


func get_menu(menu: Globals.GUIMenus) -> ManagedMenu:
	return super(menu)


func pin_menu(menu: Globals.GUIMenus) -> void:
	super(menu)


func _on_transition(menu: Globals.GUIMenus) -> void:
	super(menu)