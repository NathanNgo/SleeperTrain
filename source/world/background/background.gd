extends ParallaxBackground


@export var _small_layer: ParallaxLayer
@export var _big_layer: ParallaxLayer

const SCROLL_BASE_OFFSET_MAGNITUDE = 20


func _ready() -> void:
	hide_big_layer()


func _process(delta: float) -> void:
	scroll_base_offset -= Vector2(delta * SCROLL_BASE_OFFSET_MAGNITUDE, 0)


func show_big_layer() -> void:
	_small_layer.hide()
	_big_layer.show()


func hide_big_layer() -> void:
	_small_layer.show()
	_big_layer.hide()
