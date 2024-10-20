extends CanvasLayer


const default_menu = Menus.MAIN
enum Menus {
	MAIN,
	OVERWORLD_NAVIGATION
}
var menus = {
	Menus.MAIN: preload("res://source/menus/main_menu/main_menu.tscn").instantiate(),
	Menus.OVERWORLD_NAVIGATION: preload(
		"res://source/menus/overworld_navigation_menu/overworld_navigation_menu.tscn"
	).instantiate(),
}


func _ready() -> void:
	_add_all_as_child()
	_hide_all()
	transition(default_menu)


func transition(menu_name: Menus) -> void:
	_hide_all()
	menus[menu_name].show()


func _add_all_as_child() -> void:
	for key in menus:
		add_child(menus[key])


func _hide_all():
	for key in menus:
		menus[key].hide()