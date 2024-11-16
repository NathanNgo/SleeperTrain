extends RefCounted

class_name CharacterData

var id: int
var name: String
var satisfaction: int
var hunger: int
var world_representation: PackedScene
var position: Vector2


func _init(name_: String, world_representation_: PackedScene, hunger_: int = 0, satisfaction_: int = 0) -> void:
	self.id = CharacterRegistry.register(self)
	self.name = name_
	self.satisfaction = satisfaction_
	self.hunger = hunger_
	self.world_representation = world_representation_
