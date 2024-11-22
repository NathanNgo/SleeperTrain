extends Node

signal add_train_carriage_at(location: int, type: String)
signal remove_train_carriage_at(location: int)
signal add_train_carriage_at_front(type: String)
signal remove_train_carriage_at_front
signal add_train_carriage_at_back(type: String)
signal remove_train_carriage_at_back

signal add_character_to_carriage(character_id: int, carriage_id: int)
signal remove_character(character_id: int)
signal remove_all_characters