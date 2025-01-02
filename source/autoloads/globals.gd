extends Node

enum GameModeType {
	NORMAL,
	BUILDING,
	DEMOLISHING,
}

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
	TIME,
	SCENERY,
	SAFETY
}

enum Layers { CABIN = 1, CARRIAGE = 2 }

enum ObjectType { CABIN, PORTAL, WORLD_OBJECT }

const RESOURCE_MIN = 0

const ROOM_MAX = 100
const SERVICE_MAX = 100
const FOOD_MAX = 100
const TIME_MAX = 100
const SCENERY_MAX = 100
const SAFETY_MAX = 100

const ROOM_MIN = 0
const SERVICE_MIN = 0
const FOOD_MIN = 0
const TIME_MIN = 0
const SCENERY_MIN = 0
const SAFETY_MIN = 0

var game_mode := GameModeType.NORMAL
var building_layer := Layers.CARRIAGE
var building_object_type := ObjectType.CABIN

var ResourceScema = Z.schema({
	ResourceType.COAL: Z.integer().minimum(RESOURCE_MIN),
	ResourceType.FOOD: Z.integer().minimum(RESOURCE_MIN),
	ResourceType.LUXURIES: Z.integer().minimum(RESOURCE_MIN),
	ResourceType.REPUTATION: Z.integer(),
	ResourceType.MONEY: Z.integer()
})
var SatisfactionSchema = Z.schema({
	SatisfactionType.ROOM: Z.integer().minimum(ROOM_MIN).maximum(ROOM_MAX),
	SatisfactionType.SERVICE: Z.integer().minimum(SERVICE_MIN).maximum(SERVICE_MAX),
	SatisfactionType.FOOD: Z.integer().minimum(FOOD_MIN).maximum(FOOD_MAX),
	SatisfactionType.TIME: Z.integer().minimum(TIME_MIN).maximum(TIME_MAX),
	SatisfactionType.SCENERY: Z.integer().minimum(SCENERY_MIN).maximum(SCENERY_MAX),
	SatisfactionType.SAFETY: Z.integer().minimum(SAFETY_MIN).maximum(SAFETY_MAX)
})
