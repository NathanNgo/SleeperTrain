extends Node

@export var _menu_manager: CanvasLayer
@export var _train_manager: Node
@export var _world: Node2D

@export var _passenger_world_representation: PackedScene
@export var _passenger_menu_image: Resource

var _graph: GridRailwayGraph
var _current_vertex: GridRailwayVertex
var _destination_vertex: GridRailwayVertex
var _train_arrived := true

const MAX_CHARACTERS := 20
const MIN_CHARACTERS := 18
const MIN_HUNGER := 0
const MAX_HUNGER := 100
const DEFAULT_SATISFACTION := 100
const DEFAULT_CHARACTER_NAME := "John"
const DEFAULT_TOWN_NAME := "First Town"
const DEFAULT_TRAVEL_TIME := 5

@onready var _overworld_navigation_menu: ManagedMenu = _menu_manager.get_menu(
    Globals.Menus.OVERWORLD_NAVIGATION_MENU
)
@onready var _passenger_management_menu: ManagedMenu = _menu_manager.get_menu(
    Globals.Menus.PASSENGER_MANAGEMENT_MENU
)
@onready var _resource_management_menu: ManagedMenu = _menu_manager.get_menu(
    Globals.Menus.RESOURCE_MANAGEMENT_MENU
)


func _ready() -> void:
    _setup_graph()
    _setup_overworld_navigation_menu()
    _setup_train_manager()
    _setup_resource_management_menu()
    _populate_passenger_management_menu()
    _populate_resource_management_menu()


func _setup_graph() -> void:
    var edges = _overworld_navigation_menu.overworld.level.grid_railway_edges
    var vertexes = _overworld_navigation_menu.overworld.level.grid_railway_vertexes

    _graph = GridRailwayGraph.new()

    for vertex in vertexes:
        _graph.add_vertex(vertex)

        if vertex.vertex_type == Globals.VertexType.TOWN:
            vertex.available_character_ids = _generate_characters()
            vertex.available_resources = _generate_resources()

    for edge in edges:
        _graph.add_edge(edge)

    _current_vertex = _graph.get_vertex_by_name(DEFAULT_TOWN_NAME)


func _setup_train_manager() -> void:
    _train_manager.carriage_added.connect(_on_carriage_added)
    _train_manager.character_added.connect(_on_character_added)
    _train_manager.add_carriage_at(0, Globals.TrainCarriageType.BASIC)


func _setup_overworld_navigation_menu() -> void:
    _overworld_navigation_menu.current_location_name = _current_vertex.vertex_name
    _overworld_navigation_menu.overworld.train_arrived.connect(_on_train_arrived)

    for town_selection in _overworld_navigation_menu.overworld.level.town_selections:
        town_selection.pressed.connect(_on_town_selection_pressed.bind(town_selection.vertex_name))


func _setup_resource_management_menu() -> void:
    _resource_management_menu.resource_purchased.connect(_on_resource_purchased)


func _generate_characters() -> Array[int]:
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


# Returns Dict[Globals.Resource, int]
func _generate_resources() -> Variant:
    var resources = {
        Globals.ResourceType.COAL: randi_range(10, 100),
        Globals.ResourceType.FOOD: randi_range(10, 100),
        Globals.ResourceType.LUXURIES: randi_range(10, 100),
        Globals.ResourceType.REPUTATION: randi_range(10, 100)
    }
    return resources


func _populate_passenger_management_menu() -> void:
    _passenger_management_menu.set_available_character_list(_current_vertex.available_character_ids)
    _passenger_management_menu.total_carriages = _train_manager.train_layout.size()


func _populate_resource_management_menu() -> void:
    _resource_management_menu.set_current_town_resources(
        _current_vertex.available_resources[Globals.ResourceType.COAL],
        _current_vertex.available_resources[Globals.ResourceType.LUXURIES],
        _current_vertex.available_resources[Globals.ResourceType.FOOD]
    )


func _clear_world_characters() -> void:
    for child in _world.character_container.get_children():
        child.queue_free()


func _spawn_world_characters() -> void:
    _clear_world_characters()
    for character_id in _train_manager.character_id_to_carriage_id_mapping:
        var character_world_representation := CharacterRegistry.get_world_representation(
            character_id
        )

        var carriage_id: int = _train_manager.character_id_to_carriage_id_mapping[character_id]

        var carriage: Node2D = _train_manager.get_carriage(carriage_id)
        character_world_representation.world_position = carriage.position

        _world.character_container.add_child(character_world_representation)


func _on_town_selection_pressed(vertex_name: String) -> void:
    if not _train_arrived:
        return

    _train_arrived = false

    _destination_vertex = _graph.get_vertex_by_name(vertex_name)
    var full_path := _graph.get_full_path(_current_vertex.id, _destination_vertex.id)

    _overworld_navigation_menu.overworld.move_train(full_path, DEFAULT_TRAVEL_TIME)


func _on_carriage_added(carriage: Node2D) -> void:
    _world.train_container.add_child(carriage)
    _passenger_management_menu.total_carriages = _train_manager.train_layout.size()


func _on_character_added() -> void:
    _spawn_world_characters()


func _on_train_arrived() -> void:
    _train_arrived = true
    _current_vertex = _destination_vertex
    _overworld_navigation_menu.current_location_name = _current_vertex.vertex_name
    _populate_passenger_management_menu()
    _populate_resource_management_menu()


func _on_resource_purchased(resource_type: Globals.ResourceType, amount: int) -> void:
    _current_vertex.available_resources[resource_type] -= amount
