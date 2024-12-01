extends ManagedMenu

@export var _money_display: HBoxContainer
@export var _reputation_display: HBoxContainer
@export var _coal_display: HBoxContainer
@export var _food_display: HBoxContainer
@export var _luxuries_display: HBoxContainer


func set_resource_amounts(resource_amounts: Variant) -> void:
	_money_display.resource_amount = resource_amounts[Globals.ResourceType.MONEY]
	_reputation_display.resource_amount = resource_amounts[
		Globals.ResourceType.REPUTATION
	]
	_coal_display.resource_amount = resource_amounts[Globals.ResourceType.COAL]
	_food_display.resource_amount = resource_amounts[Globals.ResourceType.FOOD]
	_luxuries_display.resource_amount = resource_amounts[Globals.ResourceType.LUXURIES]
