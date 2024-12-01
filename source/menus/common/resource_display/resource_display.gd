extends HBoxContainer

@export var _resource_label: Label
@export var _resource_texture: TextureRect

@export var resource_texture_image: Resource:
	set(value):
		_resource_texture.texture = value
		resource_texture_image = value

var resource_amount: int:
	set(value):
		_resource_label.text = str(value)
		resource_amount = value
