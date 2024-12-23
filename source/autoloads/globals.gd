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

var game_mode := GameModeType.NORMAL
