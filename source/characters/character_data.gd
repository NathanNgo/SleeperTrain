extends RefCounted

class_name CharacterData

var character_id: int
var character_name: String
var satisfaction: int
var hunger: int
var world_representation: PackedScene
var menu_image: Resource
var world_position: Vector2


func _init(
	character_name_: String,
	menu_image_: Resource,
	world_representation_: PackedScene,
	hunger_: int = 0,
	satisfaction_: int = 0
) -> void:
	self.character_id = CharacterRegistry.register(self)
	self.character_name = character_name_
	self.menu_image = menu_image_
	self.satisfaction = satisfaction_
	self.hunger = hunger_
	self.world_representation = world_representation_
