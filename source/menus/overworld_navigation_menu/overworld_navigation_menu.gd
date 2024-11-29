extends ManagedMenu

@export var overworld: Node2D
@export var _location_name_label: Label
var current_location_name: String:
	set(name):
		_location_name_label.text = name


func setup(current_location_name_init) -> void:
	self.current_location_name = current_location_name_init
