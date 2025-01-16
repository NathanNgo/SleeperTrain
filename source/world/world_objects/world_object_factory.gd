class_name WorldObjectFactory extends Node

enum WorldObjectType {
	TABLE_CABIN, TABLE_DINING, BED, LAMP_WALL, LUGGAGE_RACK, CHAIR_BASIC
}

@export var _placement_preview: PackedScene

@export var _table_cabin: PackedScene
@export var _table_dining: PackedScene
@export var _bed: PackedScene
@export var _lamp_wall: PackedScene
@export var _luggage_rack: PackedScene
@export var _chair_basic: PackedScene


func get_world_object_instance(world_object_type: WorldObjectType) -> WorldObject:
	var world_object: WorldObject = null

	match world_object_type:
		WorldObjectType.TABLE_CABIN:
			world_object = _table_cabin.instantiate()
		WorldObjectType.TABLE_DINING:
			world_object = _table_dining.instantiate()
		WorldObjectType.BED:
			world_object = _bed.instantiate()
		WorldObjectType.LAMP_WALL:
			world_object = _lamp_wall.instantiate()
		WorldObjectType.LUGGAGE_RACK:
			world_object = _luggage_rack.instantiate()
		WorldObjectType.CHAIR_BASIC:
			world_object = _chair_basic.instantiate()

	if not world_object:
		push_error("WorldObject not found in WorldObjectFactory")

	return world_object


func create_placement_preview(world_object_type: WorldObjectType) -> PlacementPreview:
	var world_object := get_world_object_instance(world_object_type)
	var placement_preview := _placement_preview.instantiate()
	var rect := world_object.world_object_shape.shape.get_rect()
	var sprite := world_object.world_object_sprite

	placement_preview.set_shape(rect.size.y, rect.size.x)
	placement_preview.set_sprite(sprite.texture)

	return placement_preview


func create_world_object(world_object_type: WorldObjectType) -> WorldObject:
	return get_world_object_instance(world_object_type)
