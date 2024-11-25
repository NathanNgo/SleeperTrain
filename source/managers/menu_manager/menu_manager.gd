extends CanvasLayer

@export var _main_menu: ManagedMenu:
    set(menu):
        menus[Globals.Menus.MAIN_MENU] = menu

@export var _overworld_navigation_menu: ManagedMenu:
    set(menu):
        menus[Globals.Menus.OVERWORLD_NAVIGATION_MENU] = menu

@export var _how_to_play_menu: ManagedMenu:
    set(menu):
        menus[Globals.Menus.HOW_TO_PLAY_MENU] = menu

@export var _train_management_menu: ManagedMenu:
    set(menu):
        menus[Globals.Menus.TRAIN_MANAGEMENT_MENU] = menu

@export var _passenger_management_menu: ManagedMenu:
    set(menu):
        menus[Globals.Menus.PASSENGER_MANAGEMENT_MENU] = menu

@export var _resource_management_menu: ManagedMenu:
    set(menu):
        menus[Globals.Menus.RESOURCE_MANAGEMENT_MENU] = menu

var menus = {}
var menu_open = false

const DEFAULT_MENU = Globals.Menus.MAIN_MENU
const DEFAULT_ESCAPE_ACTION = "escape"


func _ready() -> void:
    _setup_all()
    _hide_all()
    transition(DEFAULT_MENU)


func _input(event: InputEvent) -> void:
    if event.is_action_pressed(DEFAULT_ESCAPE_ACTION):
        if menu_open:
            _hide_all()
            menu_open = false
        else:
            transition(DEFAULT_MENU)


func transition(menu: Globals.Menus) -> void:
    _hide_all()
    menus[menu].show()
    menu_open = true


func get_menu(menu: Globals.Menus) -> ManagedMenu:
    return menus[menu]


func _setup_all() -> void:
    for key in menus:
        menus[key].transition.connect(_on_transition)


func _hide_all() -> void:
    for key in menus:
        menus[key].hide()


func _on_transition(menu: Globals.Menus) -> void:
    transition(menu)
