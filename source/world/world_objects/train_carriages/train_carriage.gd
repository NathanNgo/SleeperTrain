extends Node2D

@export var _train_carriage_shape: CollisionShape2D

@onready var train_carriage_length := _train_carriage_shape.shape.get_rect().size.x

var carriage_id: int
