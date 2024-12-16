extends Node

# Train Manager Signals
signal add_train_carriage_at(carriage_index: int, type: String)
signal remove_train_carriage_at(carriage_index: int)
signal add_train_carriage_at_front(type: String)
signal remove_train_carriage_at_front
signal add_train_carriage_at_back(type: String)
signal remove_train_carriage_at_back

signal add_character_to_carriage(character_id: int, carriage_index: int)
signal remove_character(character_id: int)
signal remove_all_characters

signal add_cabin_to_carriage(
	start_postition: Vector2, end_postition: Vector2, level: int, carriage_index: int
)
signal remove_cabin_from_carriage(position: Vector2, level: int, carriage_index: int)
signal remove_all_cabins_from_carriage(carriage_index: int)

# Train Resource Signals
signal train_resources_changed
