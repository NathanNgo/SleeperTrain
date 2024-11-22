extends ManagedMenu

@export var _passengers_container: HFlowContainer
@export var _character_button: PackedScene
@export var _minus_button: Button
@export var _plus_button: Button
@export var _submit_button: Button
@export var _current_carriage_display: Label

var _character_selection: int
var _carriage_selection: int = 0
var total_carriages: int = 0

const MIN_CARRIAGES = 0


func _ready() -> void:
	_minus_button.pressed.connect(_on_minus_button_pressed)
	_plus_button.pressed.connect(_on_plus_button_pressed)
	_submit_button.pressed.connect(_on_submit_button_pressed)
	_current_carriage_display.text = str(MIN_CARRIAGES)


func set_available_character_list(character_ids: Array[int]) -> void:
	for child in _passengers_container.get_children():
		child.queue_free()

	for character_id in character_ids:
		var character_data = CharacterRegistry.get_character_data(character_id)
		var character_button: Control = _character_button.instantiate()
		character_button.set_texture(character_data.menu_image)
		character_button.pressed.connect(
			_on_character_button_pressed.bind(character_data.character_id)
		)

		_passengers_container.add_child(character_button)


func _on_minus_button_pressed() -> void:
	_carriage_selection = clamp(_carriage_selection - 1, MIN_CARRIAGES, total_carriages - 1)
	_current_carriage_display.text = str(_carriage_selection)


func _on_plus_button_pressed() -> void:
	_carriage_selection = clamp(_carriage_selection + 1, MIN_CARRIAGES, total_carriages - 1)
	_current_carriage_display.text = str(_carriage_selection)


func _on_submit_button_pressed() -> void:
	if not _character_selection:
		return

	SignalBus.add_character_to_carriage.emit(_character_selection, _carriage_selection)


func _on_character_button_pressed(character_id: int) -> void:
	_character_selection = character_id