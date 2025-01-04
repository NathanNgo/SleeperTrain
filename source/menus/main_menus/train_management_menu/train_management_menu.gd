extends ManagedMenu

@export var _add_carriage_button: Button
@export var _remove_carriage_button: Button


func _ready() -> void:
	_add_carriage_button.pressed.connect(_on_add_carriage_button_pressed)
	_remove_carriage_button.pressed.connect(_on_remove_carriage_button_pressed)


func _on_add_carriage_button_pressed() -> void:
	TrainRegistry.add_train_carriage_at_back(TrainCarriage.TrainCarriageType.BASIC)


func _on_remove_carriage_button_pressed() -> void:
	TrainRegistry.remove_train_carriage_at_back()
