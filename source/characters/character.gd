extends RefCounted

class_name Character

var id: int
var satisfaction: int
var hunger: int

func _init(hunger_: int = 0, satisfaction_: int = 0) -> void:
	self.satisfaction = satisfaction_
	self.hunger = hunger_
	self.id = CharactersRegistry.register(self)