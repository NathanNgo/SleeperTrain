class_name Generation extends RefCounted

const MAX_CHARACTERS := 4
const MIN_CHARACTERS := 1
const MIN_HUNGER := 0
const MAX_HUNGER := 100
const MIN_MONEY := 1
const MAX_MONEY := 10
const DEFAULT_CHARACTER_NAME := "John"

static var _passenger_world_representation: PackedScene = preload(
	"res://source/characters/character_world_representation.tscn"
)
static var _passenger_menu_image: Resource = preload(
	"res://assets/graphics/Passenger.png"
)


# Returns Dict[Globals.Resource, int]
static func generate_resources() -> Variant:
	var resources = {
		Globals.ResourceType.COAL: randi_range(10, 100),
		Globals.ResourceType.FOOD: randi_range(10, 100),
		Globals.ResourceType.LUXURIES: randi_range(10, 100),
	}
	return resources


static func generate_characters(
	current_town: GridRailwayVertex, available_towns: Array[GridRailwayVertex]
) -> Array[int]:
	var characters: Array[int] = []
	available_towns.erase(current_town)

	for count in range(randi_range(MIN_CHARACTERS, MAX_CHARACTERS)):
		var money = randi_range(MIN_MONEY, MAX_MONEY)
		var hunger = randi_range(MIN_HUNGER, MAX_HUNGER)
		var destination_town = available_towns[randi_range(0, available_towns.size() - 1)]
		var generated_character: CharacterData = CharacterData.new(
			DEFAULT_CHARACTER_NAME,
			_passenger_menu_image,
			_passenger_world_representation,
			current_town,
			destination_town,
			money,
			hunger,
		)
		characters.append(generated_character.character_id)

	return characters
