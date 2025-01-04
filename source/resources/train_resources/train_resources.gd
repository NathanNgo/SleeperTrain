extends Resource

@export var resources = {
	Globals.ResourceType.COAL: 98,
	Globals.ResourceType.FOOD: 50,
	Globals.ResourceType.LUXURIES: 72,
	Globals.ResourceType.REPUTATION: 100,
	Globals.ResourceType.MONEY: 100
}


func set_resource(resource_type: Globals.ResourceType, amount: int) -> void:
	resources[resource_type] = amount
	# TODO: Is this really the best way to do this? Sending a signal every update.
	# It does mean we can trigger updates if things are listening, but goes
	# against out "push down" pattern we've adopted. Maybe we switch to this pattern instead?
	SignalBus.train_resources_changed.emit()

	_validate_or_throw(resources)


func add_resources(resource_type: Globals.ResourceType, amount: int) -> void:
	resources[resource_type] += amount
	SignalBus.train_resources_changed.emit()

	_validate_or_throw(resources)


func remove_resources(resource_type: Globals.ResourceType, amount: int) -> void:
	resources[resource_type] -= amount
	SignalBus.train_resources_changed.emit()

	_validate_or_throw(resources)


func _validate_or_throw(resources_for_validation: Variant) -> void:
	var result = Globals.resource_schema.parse(resources_for_validation)
	if not result.ok():
		push_error(result.error)
