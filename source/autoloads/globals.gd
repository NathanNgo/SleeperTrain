extends Node

enum GameModeType { NORMAL, BUILDING }

enum ResourceType {
	COAL,
	FOOD,
	LUXURIES,
	REPUTATION,
	MONEY,
}

enum SatisfactionType {
	ROOM,
	SERVICE,
	FOOD,
	SCENERY,
	TIME,
}

enum Layers {
	CABIN = 1,
	CARRIAGE = 2
}

enum ObjectType {
	CABIN,
	PORTAL,
	WORLD_OBJECT
}

var game_mode := GameModeType.NORMAL
var building_object_type := ObjectType.CABIN