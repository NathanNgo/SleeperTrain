extends Control

@export var _texture_rect: TextureRect


func set_texture(texture: Resource):
	_texture_rect.texture = texture