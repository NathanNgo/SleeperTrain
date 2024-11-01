extends ParallaxBackground


@export var _layer_near: ParallaxLayer
@export var _layer_far: ParallaxLayer
var amount = 8


func _ready() -> void:
	_layer_near.show()
	_layer_far.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_base_offset -= Vector2(delta * 4, 0)


func show_near_layers(scale_amount: float) -> void:
	print(scale_amount)
	print(scale_amount)
	_layer_near.show()
	_layer_far.hide()


func hide_near_layers(scale_amount: float) -> void:
	print(scale_amount)
	_layer_near.hide()
	_layer_far.show()
