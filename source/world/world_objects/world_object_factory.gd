class_name WorldObjectFactory extends RefCounted

enum WorldObjectType {
	TABLE_CABIN,
	TABLE_DINING,
	BED,
	LAMP_WALL,
	LUGGAGE_RACK
}


static func create_world_object(world_object_type: WorldObjectType) -> WorldObject:
	match world_object_type:
		WorldObjectType.TABLE_CABIN:
			return preload("./table_dining/table_dining.tscn").instantiate()
		WorldObjectType.TABLE_DINING:
			return 
		WorldObjectType.BED:
			return 
		WorldObjectType.LAMP_WALL:
			return 
		WorldObjectType.LUGGAGE_RACK:
			return 

	push_error("WorldObject not found in WorldObjectFactory")
	return null