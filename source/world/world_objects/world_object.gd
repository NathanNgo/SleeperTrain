class_name WorldObject extends Node2D


var world_object_id: int


func setup(centered_global_position: Vector2) -> void:
	position = to_local(centered_global_position)


func remove() -> void:
	TrainRegistry.unregister_world_object(world_object_id)
	queue_free()


func _ready() -> void:
	world_object_id = TrainRegistry.register_world_object(self)