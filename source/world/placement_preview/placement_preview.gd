class_name PlacementPreview extends Node2D

@export var _world_object_shape: CollisionShape2D
@export var _world_object_sprite: Sprite2D


func set_shape(height, length) -> void:
	_world_object_shape.shape.get_rect().size.x = height
	_world_object_shape.shape.get_rect().size.y = length


func set_sprite(texture: Texture2D) -> void:
	_world_object_sprite.texture = texture