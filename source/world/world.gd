extends Node2D

const CAMERA_PAN_SPEED = 5
const CAMERA_ZOOM_INCREMENT = 2
const CAMERA_ZOOM_OFFSET = 200
const MAX_CAMERA_ZOOM = 2
const MIN_CAMERA_ZOOM = 1

@export var train_container: Node2D
@export var character_container: Node2D
@export var _camera: Camera2D
@export var _background_pivot: Node2D
@export var _background_sub_viewport: SubViewport
@export var _train_resources: Resource

@export var _journey_background: PackedScene
@export var _town_background: PackedScene


func _process(_delta: float) -> void:
	if Input.is_action_pressed("pan_left"):
		_camera.position.x -= CAMERA_PAN_SPEED
		$Conductor.position.x -= CAMERA_PAN_SPEED
	if Input.is_action_pressed("pan_right"):
		_camera.position.x += CAMERA_PAN_SPEED
		$Conductor.position.x += CAMERA_PAN_SPEED
	_background_pivot.position = _camera.position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in") and _camera.zoom.x < MAX_CAMERA_ZOOM:
		_camera.position.y += CAMERA_ZOOM_OFFSET
		_camera.zoom *= Vector2.ONE * CAMERA_ZOOM_INCREMENT
		_background_pivot.scale /= Vector2.ONE * CAMERA_ZOOM_INCREMENT

	if event.is_action_pressed("zoom_out") and _camera.zoom.x > MIN_CAMERA_ZOOM:
		_camera.position.y -= CAMERA_ZOOM_OFFSET
		_camera.zoom /= Vector2.ONE * CAMERA_ZOOM_INCREMENT
		_background_pivot.scale *= Vector2.ONE * CAMERA_ZOOM_INCREMENT


func clear_world_characters() -> void:
	for character in character_container.get_children():
		character.queue_free()


func spawn_world_character(character_id: int, world_position: Vector2) -> void:
	var character_world_representation := CharacterRegistry.get_world_representation(
		character_id
	)
	character_world_representation.world_position = world_position
	character_world_representation.consume_resource.connect(
		_on_character_consume_resource
	)

	character_container.add_child(character_world_representation)


func collect_passenger_payments() -> void:
	for character in character_container.get_children():
		_train_resources.add_resource(character.money)


func start_character_consumption() -> void:
	for character in character_container.get_children():
		character.start_character_consumption()


func stop_character_consumption() -> void:
	for character in character_container.get_children():
		character.stop_character_consumption()


func _on_character_consume_resource(
	resource_type: Globals.ResourceType, amount: int
) -> void:
	_train_resources.remove_resources(resource_type, amount)


# TODO: Clean this janky shit up.
func set_background_town() -> void:
	for child in _background_sub_viewport.get_children():
		child.queue_free()

	_background_sub_viewport.add_child(_town_background.instantiate())


func set_background_journey() -> void:
	for child in _background_sub_viewport.get_children():
		child.queue_free()

	_background_sub_viewport.add_child(_journey_background.instantiate())
