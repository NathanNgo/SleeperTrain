extends Node2D

@export var _train_carriage_shape: CollisionShape2D

var carriage_id: int

@onready var train_carriage_length := _train_carriage_shape.shape.get_rect().size.x

signal player_entered_carriage(Node2D)
signal player_exited_carriage(Node2D)

func _on_train_carriage_area_body_entered(body: Node2D) -> void:
	player_entered_carriage.emit(self)
	print("Detected player entering")


func _on_train_carriage_area_body_exited(body: Node2D) -> void:
	player_exited_carriage.emit(self)
	print("Detected player leaving")
