extends Node

const DEFAULT_TRAVEL_TIME := 1
const DEFAULT_TOWN_NAME := "First Town"

@export var _main_menu_manager: CanvasLayer
@export var _popup_menu_manager: CanvasLayer
@export var _gui_menu_manager: CanvasLayer
@export var _train_manager: Node
@export var _world: Node2D
@export var _train_resources: Resource

var _graph: GridRailwayGraph
var _current_vertex: GridRailwayVertex
var _destination_vertex: GridRailwayVertex
var _train_arrived := true

@onready var _overworld_navigation_menu: ManagedMenu = _main_menu_manager.get_menu(
	Globals.MainMenus.OVERWORLD_NAVIGATION_MENU
)
@onready var _passenger_management_menu: ManagedMenu = _main_menu_manager.get_menu(
	Globals.MainMenus.PASSENGER_MANAGEMENT_MENU
)
@onready var _resource_management_menu: ManagedMenu = _main_menu_manager.get_menu(
	Globals.MainMenus.RESOURCE_MANAGEMENT_MENU
)
@onready
var _main_menu: ManagedMenu = _main_menu_manager.get_menu(Globals.MainMenus.MAIN_MENU)
@onready var _passenger_journey_report_menu: ManagedMenu = _popup_menu_manager.get_menu(
	Globals.PopupMenus.PASSENGER_JOURNEY_REPORT_MENU
)
@onready var _resource_gui_menu: ManagedMenu = _gui_menu_manager.get_menu(
	Globals.GUIMenus.RESOURCE_GUI_MENU
)


func _ready() -> void:
	_setup_graph()
	_setup_overworld_navigation_menu()
	_setup_train_manager()
	_setup_resource_management_menu()
	_setup_train_resources()
	_populate_passenger_management_menu()
	_populate_resource_management_menu()
	_populate_resource_gui_menu(_train_resources.resources)
	_world.set_background_town()


func _setup_graph() -> void:
	_graph = GridRailwayGraph.new(
		_overworld_navigation_menu.overworld.level.grid_railway_vertexes,
		_overworld_navigation_menu.overworld.level.grid_railway_edges
	)
	_current_vertex = _graph.get_vertex_by_name(DEFAULT_TOWN_NAME)


func _setup_train_manager() -> void:
	_train_manager.carriage_added.connect(_on_carriage_added)
	_train_manager.character_added.connect(_on_character_added)
	_train_manager.setup(Globals.TrainCarriageType.BASIC)


func _setup_overworld_navigation_menu() -> void:
	_overworld_navigation_menu.overworld.train_arrived.connect(_on_train_arrived)

	for town_selection in _overworld_navigation_menu.overworld.level.town_selections:
		town_selection.pressed.connect(
			_on_town_selection_pressed.bind(town_selection.vertex_name)
		)

	_overworld_navigation_menu.setup(_current_vertex.vertex_name)


func _setup_resource_management_menu() -> void:
	_resource_management_menu.resource_purchased.connect(_on_resource_purchased)


func _setup_train_resources() -> void:
	SignalBus.train_resources_changed.connect(_on_train_resources_changed)


func _populate_passenger_management_menu() -> void:
	_passenger_management_menu.set_available_character_list(
		_current_vertex.available_character_ids
	)
	_passenger_management_menu.total_carriages = _train_manager.train_layout.size()


func _populate_resource_management_menu() -> void:
	_resource_management_menu.set_current_town_resources(
		_current_vertex.available_resources[Globals.ResourceType.COAL],
		_current_vertex.available_resources[Globals.ResourceType.LUXURIES],
		_current_vertex.available_resources[Globals.ResourceType.FOOD]
	)


func _populate_passenger_journey_report_menu(satisfaction_scores: Variant) -> void:
	_passenger_journey_report_menu.set_satisfaction_scores(satisfaction_scores)
	(
		_popup_menu_manager
		. transition_with_time_limit(
			Globals.PopupMenus.PASSENGER_JOURNEY_REPORT_MENU,
		)
	)


func _populate_resource_gui_menu(resource_amounts: Variant) -> void:
	_resource_gui_menu.set_resource_amounts(resource_amounts)


func _disembark_passengers() -> void:
	# We don't want to modify the dict we're iterating through, so we duplicate it.
	var satisfaction_scores = {
		Globals.SatisfactionType.ROOM: 0,
		Globals.SatisfactionType.SERVICE: 0,
		Globals.SatisfactionType.FOOD: 0,
		Globals.SatisfactionType.SCENERY: 0,
		Globals.SatisfactionType.TIME: 0
	}
	var character_departed = false

	for character_id in _train_manager.character_id_to_carriage_id_mapping.duplicate():
		var character_data := CharacterRegistry.get_character_data(character_id)
		character_data.current_town = _current_vertex

		if character_data.destination_town == _current_vertex:
			character_departed = true

			_train_manager.remove_character(character_id)
			_train_resources.add_resources(
				Globals.ResourceType.MONEY, character_data.money
			)
			_train_resources.add_resources(
				Globals.ResourceType.REPUTATION, character_data.get_satisfaction_score()
			)

			for satisfaction_type in character_data.satisfaction:
				var satisfied: bool = character_data.satisfaction[satisfaction_type]
				satisfaction_scores[satisfaction_type] += int(satisfied)

	if character_departed:
		_populate_passenger_journey_report_menu(satisfaction_scores)


func _reload_train_characters() -> void:
	_world.clear_world_characters()

	for character_id in _train_manager.character_id_to_carriage_id_mapping:
		var carriage_id: int = (
			_train_manager.character_id_to_carriage_id_mapping[character_id]
		)
		var carriage: Node2D = _train_manager.get_carriage(carriage_id)

		_world.spawn_world_character(character_id, carriage.position)


func _start_train_journey(destination_vertex_name: String) -> void:
	_destination_vertex = _graph.get_vertex_by_name(destination_vertex_name)
	var full_path := _graph.get_full_path(_current_vertex.id, _destination_vertex.id)

	_overworld_navigation_menu.overworld.move_train(full_path, DEFAULT_TRAVEL_TIME)
	_train_manager.start_train_consumption()
	_world.start_character_consumption()
	_world.set_background_journey()
	_main_menu.disable_town_buttons()
	_train_arrived = false


func _stop_train_journey() -> void:
	_current_vertex = _destination_vertex
	_overworld_navigation_menu.current_location_name = _current_vertex.vertex_name
	_populate_passenger_management_menu()
	_populate_resource_management_menu()
	_train_manager.stop_train_consumption()
	_world.stop_character_consumption()
	_world.set_background_town()
	_main_menu.enable_town_buttons()
	_disembark_passengers()
	_reload_train_characters()
	_train_arrived = true


func _on_carriage_added(carriage: Node2D) -> void:
	_world.train_container.add_child(carriage)
	_passenger_management_menu.total_carriages = _train_manager.train_layout.size()


func _on_resource_purchased(resource_type: Globals.ResourceType, amount: int) -> void:
	_current_vertex.available_resources[resource_type] -= amount


func _on_character_added() -> void:
	_reload_train_characters()


func _on_town_selection_pressed(destination_vertex_name: String) -> void:
	if not _train_arrived:
		return

	if _current_vertex.vertex_name == destination_vertex_name:
		# TODO: Give a message to the player.
		print("Cannot travel to the same vertex")
		return

	_start_train_journey(destination_vertex_name)


func _on_train_arrived() -> void:
	_stop_train_journey()


func _on_train_resources_changed() -> void:
	_populate_resource_gui_menu(_train_resources.resources)
