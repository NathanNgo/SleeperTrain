extends ParallaxBackground

const SCROLL_BASE_OFFSET_MAGNITUDE = 20


func _process(delta: float) -> void:
	scroll_base_offset -= Vector2(delta * SCROLL_BASE_OFFSET_MAGNITUDE, 0)