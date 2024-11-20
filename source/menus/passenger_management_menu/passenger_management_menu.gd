extends ManagedMenu


@export var _passengers_container: HBoxContainer
@export var _carriages_container: HBoxContainer

var _character_selection: int


func set_available_character_list(character_ids: Array[int]) -> void:
	for character_id in character_ids:
		var character_data = CharacterRegistry.get_character_data(character_id)
		var texture_button = TextureButton.new()
		texture_button.texture_normal = character_data.menu_image

		_passengers_container.add_child(texture_button)


func set_available_carriages_list() -> void:
	pass