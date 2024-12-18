class_name GUIMenuManager extends MenuManager

const DEFAULT_MENU = GUIMenuManager.Menus.RESOURCE_GUI_MENU

@export var _resource_gui_menu: ManagedMenu:
	set(menu):
		menus[GUIMenuManager.Menus.RESOURCE_GUI_MENU] = menu

enum Menus {
	RESOURCE_GUI_MENU,
}


func _ready() -> void:
	super._ready()
	transition(DEFAULT_MENU)


func transition(menu: GUIMenuManager.Menus) -> void:
	super(menu)


func get_menu(menu: GUIMenuManager.Menus) -> ManagedMenu:
	return super(menu)


func pin_menu(menu: GUIMenuManager.Menus) -> void:
	super(menu)


func _on_transition(menu: GUIMenuManager.Menus) -> void:
	super(menu)
