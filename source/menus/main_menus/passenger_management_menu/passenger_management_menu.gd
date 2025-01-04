extends ManagedMenu

const MIN_CARRIAGES = 0

@export var _passengers_container: HFlowContainer
@export var _character_display: PackedScene
@export var _submit_button: Button
@export var _number_select: HBoxContainer

var total_carriages: int = 0

var _character_selection: int
var _carriage_selection: int = 0


func _ready() -> void:
	_submit_button.pressed.connect(_on_submit_button_pressed)
	_number_select.minus_button.pressed.connect(_on_minus_button_pressed)
	_number_select.plus_button.pressed.connect(_on_plus_button_pressed)
	_number_select.display_label.text = str(MIN_CARRIAGES)


func set_available_character_list(character_ids: Array[int]) -> void:
	for child in _passengers_container.get_children():
		child.queue_free()

	for character_id in character_ids:
		var character_data = CharacterRegistry.get_character_data(character_id)
		var character_display = _character_display.instantiate()
		character_display.set_character_button_texture(character_data.menu_image)
		character_display.set_destination_label(
			character_data.destination_town.vertex_name
		)
		character_display.character_button.pressed.connect(
			_on_character_button_pressed.bind(character_data.character_id)
		)

		_passengers_container.add_child(character_display)


func _on_minus_button_pressed() -> void:
	_carriage_selection = clamp(
		_carriage_selection - 1, MIN_CARRIAGES, total_carriages - 1
	)
	_number_select.display_label.text = str(_carriage_selection)


func _on_plus_button_pressed() -> void:
	_carriage_selection = clamp(
		_carriage_selection + 1, MIN_CARRIAGES, total_carriages - 1
	)
	_number_select.display_label.text = str(_carriage_selection)


func _on_submit_button_pressed() -> void:
	if not _character_selection:
		return

	TrainRegistry.add_character_to_train(_character_selection)


func _on_character_button_pressed(character_id: int) -> void:
	_character_selection = character_id
