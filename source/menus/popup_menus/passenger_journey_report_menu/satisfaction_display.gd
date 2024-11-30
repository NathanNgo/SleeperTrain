extends HBoxContainer

@export var _satisfaction_label: Label
@export var _satisfaction_texture: TextureRect

@export var satisfaction_texture_image: Resource:
	set(value):
		_satisfaction_texture.texture = value
		satisfaction_texture_image = value

var satisfaction_amount: int:
	set(value):
		_satisfaction_label.text = str(value)
		satisfaction_amount = value
