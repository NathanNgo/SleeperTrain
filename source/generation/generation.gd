class_name Generation extends RefCounted

const MAX_CHARACTERS := 20
const MIN_CHARACTERS := 18
const MIN_HUNGER := 0
const MAX_HUNGER := 100
const DEFAULT_SATISFACTION := 100
const DEFAULT_CHARACTER_NAME := "John"

static var _passenger_world_representation: PackedScene = preload(
	"res://source/characters/character_world_representation.tscn"
)
static var _passenger_menu_image: Resource = preload(
	"res://assets/graphics/Passenger.png"
)


# Returns Dict[Globals.Resource, int]
static func _generate_resources() -> Variant:
	var resources = {
		Globals.ResourceType.COAL: randi_range(10, 100),
		Globals.ResourceType.FOOD: randi_range(10, 100),
		Globals.ResourceType.LUXURIES: randi_range(10, 100),
		Globals.ResourceType.REPUTATION: randi_range(10, 100)
	}
	return resources


static func _generate_characters() -> Array[int]:
	var characters: Array[int] = []

	for count in range(randi_range(MIN_CHARACTERS, MAX_CHARACTERS)):
		var hunger = randi_range(MIN_HUNGER, MAX_HUNGER)
		var generated_character: CharacterData = CharacterData.new(
			DEFAULT_CHARACTER_NAME,
			_passenger_menu_image,
			_passenger_world_representation,
			hunger,
			DEFAULT_SATISFACTION
		)
		characters.append(generated_character.character_id)

	return characters
