# This whole menu code sucks, but whatever. Rewrite this later, but "good".
# Half of it is programatic and general to all resource types, the
# other half assumes specific resources. Also, there's too many
# different sources of truth for the data, meaning we need to update EVERYTHING.

extends ManagedMenu

signal resource_purchased(resource_type: Globals.ResourceType, amount: int)

const MIN_RESOURCE = 0

@export var _current_coal_label: Label
@export var _current_luxuries_label: Label
@export var _current_food_label: Label
@export var _town_coal_label: Label
@export var _town_luxuries_label: Label
@export var _town_food_label: Label
@export var _number_select_coal: HBoxContainer
@export var _number_select_luxuries: HBoxContainer
@export var _number_select_food: HBoxContainer
@export var _purchase_button: Button
@export var _train_resources: Resource

var town_amount = {
	Globals.ResourceType.COAL: 0,
	Globals.ResourceType.LUXURIES: 0,
	Globals.ResourceType.FOOD: 0
}
var purchase_amount = {
	Globals.ResourceType.COAL: 0,
	Globals.ResourceType.LUXURIES: 0,
	Globals.ResourceType.FOOD: 0
}


func _ready() -> void:
	set_current_train_resources()
	SignalBus.train_resources_changed.connect(_on_train_resources_changed)
	_number_select_coal.display_label.text = str(0)
	_number_select_luxuries.display_label.text = str(0)
	_number_select_food.display_label.text = str(0)
	_setup_number_select(_number_select_coal, Globals.ResourceType.COAL)
	_setup_number_select(_number_select_luxuries, Globals.ResourceType.LUXURIES)
	_setup_number_select(_number_select_food, Globals.ResourceType.FOOD)
	_purchase_button.pressed.connect(_on_purchase_button_pressed)


func set_current_train_resources() -> void:
	_current_coal_label.text = str(_train_resources.resources[Globals.ResourceType.COAL])
	_current_luxuries_label.text = str(
		_train_resources.resources[Globals.ResourceType.LUXURIES]
	)
	_current_food_label.text = str(_train_resources.resources[Globals.ResourceType.FOOD])


func set_current_town_resources(coal: int, luxuries: int, food: int) -> void:
	town_amount[Globals.ResourceType.COAL] = coal
	town_amount[Globals.ResourceType.LUXURIES] = luxuries
	town_amount[Globals.ResourceType.FOOD] = food
	_town_coal_label.text = str(coal)
	_town_luxuries_label.text = str(luxuries)
	_town_food_label.text = str(food)


func _setup_number_select(
	number_select: HBoxContainer, resource_type: Globals.ResourceType
) -> void:
	number_select.minus_button.pressed.connect(
		_on_minus_button_pressed.bind(number_select, resource_type)
	)
	number_select.plus_button.pressed.connect(
		_on_plus_button_pressed.bind(number_select, resource_type)
	)


func _on_minus_button_pressed(
	number_select: HBoxContainer, resource_type: Globals.ResourceType
) -> void:
	purchase_amount[resource_type] = clamp(
		purchase_amount[resource_type] - 1, MIN_RESOURCE, town_amount[resource_type]
	)
	number_select.display_label.text = str(purchase_amount[resource_type])


func _on_plus_button_pressed(
	number_select: HBoxContainer, resource_type: Globals.ResourceType
) -> void:
	purchase_amount[resource_type] = clamp(
		purchase_amount[resource_type] + 1, MIN_RESOURCE, town_amount[resource_type]
	)
	number_select.display_label.text = str(purchase_amount[resource_type])


func _on_purchase_button_pressed() -> void:
	var coal_amount = purchase_amount[Globals.ResourceType.COAL]
	var luxuries_amount = purchase_amount[Globals.ResourceType.LUXURIES]
	var food_amount = purchase_amount[Globals.ResourceType.FOOD]

	_train_resources.add_resources(Globals.ResourceType.COAL, coal_amount)
	_train_resources.add_resources(Globals.ResourceType.LUXURIES, luxuries_amount)
	_train_resources.add_resources(Globals.ResourceType.FOOD, food_amount)

	# FIXME:
	# This can cause bugs as we now have 2 sources of truth. The menu, and the vertex.
	# We shouldn't have town_amount. Just pass in the resource amount for the town.
	resource_purchased.emit(Globals.ResourceType.COAL, coal_amount)
	resource_purchased.emit(Globals.ResourceType.LUXURIES, luxuries_amount)
	resource_purchased.emit(Globals.ResourceType.FOOD, food_amount)

	var new_town_coal = town_amount[Globals.ResourceType.COAL] - coal_amount
	var new_town_luxuries = town_amount[Globals.ResourceType.LUXURIES] - luxuries_amount
	var new_town_food = town_amount[Globals.ResourceType.FOOD] - food_amount

	set_current_town_resources(new_town_coal, new_town_luxuries, new_town_food)

	purchase_amount[Globals.ResourceType.COAL] = 0
	purchase_amount[Globals.ResourceType.LUXURIES] = 0
	purchase_amount[Globals.ResourceType.FOOD] = 0
	_number_select_coal.display_label.text = str(0)
	_number_select_luxuries.display_label.text = str(0)
	_number_select_food.display_label.text = str(0)


func _on_train_resources_changed() -> void:
	set_current_train_resources()
