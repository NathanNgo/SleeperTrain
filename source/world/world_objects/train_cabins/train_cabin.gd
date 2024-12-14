class_name TrainCabin extends RefCounted

var characters: Array[int] = []
var objects: Array[Node] = []

var cabin_start: int
var cabin_end: int
var level: int


func _init(cabin_start_init: int, cabin_end_init: int, level_init) -> void:
    self.cabin_start = cabin_start_init
    self.cabin_end = cabin_end_init