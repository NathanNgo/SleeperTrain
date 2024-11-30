extends ManagedMenu

@export var _room_satisfaction_display: HBoxContainer
@export var _service_satisfaction_display: HBoxContainer
@export var _food_satisfaction_display: HBoxContainer
@export var _scenery_satisfaction_display: HBoxContainer
@export var _time_satisfaction_display: HBoxContainer


func set_satisfaction_scores(satisfaction_scores: Variant) -> void:
	_room_satisfaction_display.satisfaction_amount = satisfaction_scores[
        Globals.SatisfactionType.ROOM
    ]
	_service_satisfaction_display.satisfaction_amount = satisfaction_scores[
		Globals.SatisfactionType.SERVICE
	]
	_food_satisfaction_display.satisfaction_amount = satisfaction_scores[
        Globals.SatisfactionType.FOOD
    ]
	_scenery_satisfaction_display.satisfaction_amount = satisfaction_scores[
		Globals.SatisfactionType.SCENERY
	]
	_time_satisfaction_display.satisfaction_amount = satisfaction_scores[
        Globals.SatisfactionType.TIME
    ]