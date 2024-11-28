class_name CharacterData extends RefCounted

var character_id: int
var character_name: String
var satisfaction: int
var hunger: int
var world_representation: PackedScene
var menu_image: Resource
var world_position: Vector2


func _init(
    character_name_init: String,
    menu_image_init: Resource,
    world_representation_init: PackedScene,
    hunger_init: int = 0,
    satisfaction_init: int = 0
) -> void:
    self.character_id = CharacterRegistry.register(self)
    self.character_name = character_name_init
    self.menu_image = menu_image_init
    self.satisfaction = satisfaction_init
    self.hunger = hunger_init
    self.world_representation = world_representation_init
