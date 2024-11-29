extends Node

@export var character_button: Button
@export var destination_label: Label


func set_character_button_texture(texture: Resource) -> void:
	character_button.set_texture(texture)


func set_destination_label(destination_name: String) -> void:
	destination_label.text = destination_name
