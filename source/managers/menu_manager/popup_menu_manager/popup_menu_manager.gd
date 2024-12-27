class_name PopupMenuManager extends MenuManager

enum Menus {
	PASSENGER_JOURNEY_REPORT_MENU,
}

const DEFAULT_TIME_LIMIT := 3.0

@export var _popup_timer: Timer

@export var _passenger_journey_report_menu: ManagedMenu:
	set(menu):
		menus[PopupMenuManager.Menus.PASSENGER_JOURNEY_REPORT_MENU] = menu


func _ready() -> void:
	super._ready()
	_popup_timer.timeout.connect(_on_popup_timer_timeout)


func transition_with_time_limit(
	menu: PopupMenuManager.Menus, time_limit: float = DEFAULT_TIME_LIMIT
):
	_popup_timer.wait_time = time_limit
	_popup_timer.start()
	transition(menu)


func transition(menu: PopupMenuManager.Menus) -> void:
	super(menu)


func get_menu(menu: PopupMenuManager.Menus) -> ManagedMenu:
	return super(menu)


func pin_menu(menu: PopupMenuManager.Menus) -> void:
	super(menu)


func _on_transition(menu: PopupMenuManager.Menus) -> void:
	super(menu)


func _on_popup_timer_timeout() -> void:
	_popup_timer.stop()
	hide_all()
