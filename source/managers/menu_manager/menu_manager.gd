class_name MenuManager extends CanvasLayer

var menus := {}
var pinned_menus := []
var menu_open := false


func _ready() -> void:
	_setup_all()
	hide_all()


# These should be types as "Variant" and set in the subclasses, but Godot doesn't like
# doing that, so we remove the typing here and just type them in the overriding function.
func transition(menu) -> void:
	hide_all()
	menus[menu].show()
	menu_open = true


func pin_menu(menu) -> void:
	pinned_menus.append(menu)


func get_menu(menu) -> ManagedMenu:
	return menus[menu]


func hide_all() -> void:
	for key in menus:
		if key in pinned_menus:
			continue
		menus[key].hide()


func _setup_all() -> void:
	for key in menus:
		menus[key].transition.connect(_on_transition)


func _on_transition(menu) -> void:
	transition(menu)
