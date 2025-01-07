class_name CharacterData extends RefCounted

const DEFAULT_LAYER := Globals.Layers.CARRIAGE_MIDDLE

var character_id: int

var character_name: String
# Dict[Globals.SatisfactionType, int]
var satisfaction = {}
var money: int
var hunger: int
var current_town: GridRailwayVertex
var destination_town: GridRailwayVertex
var global_world_position: Vector2
# int or null
var assigned_carriage_id: Variant
# int or null
var assigned_cabin_id: Variant

var world_representation: PackedScene
var menu_image: Resource

# const with a dict makes it read-only.
var default_satisfaction = {
	Globals.SatisfactionType.ROOM: 100,
	Globals.SatisfactionType.SERVICE: 100,
	Globals.SatisfactionType.FOOD: 100,
	Globals.SatisfactionType.TIME: 100,
	Globals.SatisfactionType.SCENERY: 100,
	Globals.SatisfactionType.SAFETY: 100
}


func _init(
	character_name_init: String,
	menu_image_init: Resource,
	world_representation_init: PackedScene,
	current_town_init: GridRailwayVertex,
	destination_town_init: GridRailwayVertex,
	money_init: int = 0,
	hunger_init: int = 0,
	satisfaction_init: Dictionary = default_satisfaction,
	assigned_cabin_id_init: Variant = null,
) -> void:
	var result = Globals.satisfaction_schema.parse(satisfaction_init)
	if not result.ok():
		push_error(result.error)
		return

	self.character_id = CharacterRegistry.register(self)
	self.character_name = character_name_init
	self.menu_image = menu_image_init
	self.satisfaction = satisfaction_init
	self.money = money_init
	self.current_town = current_town_init
	self.destination_town = destination_town_init
	self.hunger = hunger_init
	self.world_representation = world_representation_init
	self.assigned_cabin_id = assigned_cabin_id_init


func get_satisfaction_score() -> int:
	var score := 0
	for satisfaction_type in Globals.SatisfactionType.values():
		score += int(satisfaction[satisfaction_type])

	return score
