class_name WorldObjectFactory extends Node

enum WorldObjectType {
	TABLE_CABIN, TABLE_DINING, BED, LAMP_WALL, LUGGAGE_RACK, CHAIR_BASIC
}

@export var _table_cabin: PackedScene
@export var _table_dining: PackedScene
@export var _bed: PackedScene
@export var _lamp_wall: PackedScene
@export var _luggage_rack: PackedScene
@export var _chair_basic: PackedScene


func create_world_object(world_object_type: WorldObjectType) -> WorldObject:
	match world_object_type:
		WorldObjectType.TABLE_CABIN:
			return _table_cabin.instantiate()
		WorldObjectType.TABLE_DINING:
			return _table_dining.instantiate()
		WorldObjectType.BED:
			return _bed.instantiate()
		WorldObjectType.LAMP_WALL:
			return _lamp_wall.instantiate()
		WorldObjectType.LUGGAGE_RACK:
			return _luggage_rack.instantiate()
		WorldObjectType.CHAIR_BASIC:
			return _chair_basic.instantiate()

	push_error("WorldObject not found in WorldObjectFactory")
	return null
