class_name CharacterData extends RefCounted

var character_id: int
var character_name: String
var satisfaction: int
var money: int
var hunger: int
var current_town: GridRailwayVertex
var destination_town: GridRailwayVertex
var world_representation: PackedScene
var menu_image: Resource
var world_position: Vector2


func _init(
	character_name_init: String,
	menu_image_init: Resource,
	world_representation_init: PackedScene,
	money_init: int,
	current_town_init: GridRailwayVertex,
	destination_town_init: GridRailwayVertex,
	hunger_init: int = 0,
	satisfaction_init: int = 0
) -> void:
	self.character_id = CharacterRegistry.register(self)
	self.character_name = character_name_init
	self.menu_image = menu_image_init
	self.satisfaction = satisfaction_init
	self.money = money_init
	self.current_town = current_town_init
	self.destination_town = destination_town_init
	self.hunger = hunger_init
	self.world_representation = world_representation_init
